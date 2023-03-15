//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the general function merging optimization.
//
// It identifies similarities between functions, and If profitable, merges them
// into a single function, replacing the original ones. Functions do not need
// to be identical to be merged. In fact, there is very little restriction to
// merge two function, however, the produced merged function can be larger than
// the two original functions together. For that reason, it uses the
// TargetTransformInfo analysis to estimate the code-size costs of instructions
// in order to estimate the profitability of merging two functions.
//
// This function merging transformation has three major parts:
// 1. The input functions are linearized, representing their CFGs as sequences
//    of labels and instructions.
// 2. We apply a sequence alignment algorithm, namely, the Needleman-Wunsch
//    algorithm, to identify similar code between the two linearized functions.
// 3. We use the aligned sequences to perform code generate, producing the new
//    merged function, using an extra parameter to represent the function
//    identifier.
//
// This pass integrates the function merging transformation with an exploration
// framework. For every function, the other functions are ranked based their
// degree of similarity, which is computed from the functions' fingerprints.
// Only the top candidates are analyzed in a greedy manner and if one of them
// produces a profitable result, the merged function is taken.
//
//===----------------------------------------------------------------------===//
//
// This optimization was proposed in
//
// Function Merging by Sequence Alignment (CGO'19)
// Rodrigo C. O. Rocha, Pavlos Petoumenos, Zheng Wang, Murray Cole, Hugh Leather
//
// Effective Function Merging in the SSA Form (PLDI'20)
// Rodrigo C. O. Rocha, Pavlos Petoumenos, Zheng Wang, Murray Cole, Hugh Leather
//
// HyFM: Function Merging for Free (LCTES'21)
// Rodrigo C. O. Rocha, Pavlos Petoumenos, Zheng Wang, Murray Cole, Kim Hazelwood, Hugh Leather
//
// F3M: Fast Focused Function Merging (CGO'22)
// Sean Sterling, Rodrigo C. O. Rocha, Hugh Leather, Kim Hazelwood, Michael O'Boyle, Pavlos Petoumenos
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/IPO/FunctionMerging.h"

#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Verifier.h"

#include "llvm/Support/Error.h"
#include "llvm/Support/Timer.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FormatVariadic.h"

#include "llvm/Analysis/LoopInfo.h"
//#include "llvm/Analysis/ValueTracking.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/Analysis/CallGraph.h"
#include "llvm/Analysis/InstructionSimplify.h"
#include "llvm/Analysis/IteratedDominanceFrontier.h"
#include "llvm/Analysis/PostDominators.h"

#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/CodeExtractor.h"

#include "llvm/Support/RandomNumberGenerator.h"

//#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/BreadthFirstIterator.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"

#include "llvm/Analysis/Utils/Local.h"
#include "llvm/Transforms/Utils/Local.h"

#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Utils/FunctionComparator.h"
#include "llvm/Transforms/Utils/Mem2Reg.h"
#include "llvm/Transforms/Utils/PromoteMemToReg.h"

#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/Transforms/IPO.h"

#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils.h"

#include "llvm/Analysis/InlineSizeEstimatorAnalysis.h"

#include "llvm/Transforms/IPO/SALSSACodeGen.h"

#include <algorithm>
#include <array>
#include <fstream>
#include <functional>
#include <queue>
#include <random>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <climits>
#include <cstdlib>
#include <ctime>

#ifdef __unix__
/* __unix__ is usually defined by compilers targeting Unix systems */
#include <unistd.h>
#elif defined(_WIN32) || defined(WIN32)
/* _Win32 is usually defined by compilers targeting 32 or   64 bit Windows
 * systems */
#include <windows.h>
#endif

#define DEBUG_TYPE "func-merging"

//#define ENABLE_DEBUG_CODE

// #define TIME_STEPS_DEBUG

using namespace llvm;

static cl::list<std::string>
    OnlyFunctions("func-merging-only", cl::Hidden,
                  cl::desc("Merge only the specified functions"));

static cl::opt<unsigned> ExplorationThreshold(
    "func-merging-explore", cl::init(1), cl::Hidden,
    cl::desc("Exploration threshold of evaluated functions"));

static cl::opt<unsigned> RankingThreshold(
    "func-merging-ranking-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of how many candidates should be ranked"));

static cl::opt<int> MergingOverheadThreshold(
    "func-merging-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of allowed overhead for merging function"));

static cl::opt<bool> AllowUnprofitableMerge(
    "func-merging-allow-unprofitable", cl::init(false), cl::Hidden,
    cl::desc("Allow merging functions that are not profitable"));

static cl::opt<bool>
    MaxParamScore("func-merging-max-param", cl::init(true), cl::Hidden,
                  cl::desc("Maximizing the score for merging parameters"));

static cl::opt<bool> Debug("func-merging-debug", cl::init(true), cl::Hidden,
                           cl::desc("Outputs debug information"));

static cl::opt<bool> Verbose("func-merging-verbose", cl::init(false),
                             cl::Hidden, cl::desc("Outputs debug information"));

static cl::opt<bool>
    IdenticalType("func-merging-identic-type", cl::init(true), cl::Hidden,
                  cl::desc("Match only values with identical types"));

static cl::opt<bool>
    EnableUnifiedReturnType("func-merging-unify-return", cl::init(false),
                            cl::Hidden,
                            cl::desc("Enable unified return types"));

static cl::opt<bool>
    HasWholeProgram("func-merging-whole-program", cl::init(false), cl::Hidden,
                    cl::desc("Function merging applied on whole program"));

static cl::opt<bool>
    EnableHyFMPA("func-merging-hyfm-pa", cl::init(false), cl::Hidden,
                 cl::desc("Enable HyFM with the Pairwise Alignment"));

static cl::opt<bool>
    EnableHyFMNW("func-merging-hyfm-nw", cl::init(false), cl::Hidden,
                 cl::desc("Enable HyFM with the Needleman-Wunsch alignment"));

static cl::opt<bool> ReuseMergedFunctions(
    "func-merging-reuse-merges", cl::init(true), cl::Hidden,
    cl::desc("Try to reuse merged functions for another merge operation"));

static cl::opt<bool> HyFMProfitability(
    "hyfm-profitability", cl::init(true), cl::Hidden,
    cl::desc("Try to reuse merged functions for another merge operation"));

static cl::opt<bool>
    EnableF3M("func-merging-f3m", cl::init(false), cl::Hidden,
              cl::desc("Enable function pairing based on MinHashes and LSH"));

static cl::opt<unsigned>
    LSHRows("hyfm-f3m-rows", cl::init(2), cl::Hidden,
            cl::desc("Number of rows in the LSH structure"));

static cl::opt<unsigned>
    LSHBands("hyfm-f3m-bands", cl::init(100), cl::Hidden,
             cl::desc("Number of bands in the LSH structure"));

static cl::opt<bool>
    ShingleCrossBBs("shingling-cross-basic-blocks", cl::init(true), cl::Hidden,
                    cl::desc("Do shingles in MinHash cross basic blocks"));

static cl::opt<bool> AdaptiveThreshold(
    "adaptive-threshold", cl::init(false), cl::Hidden,
    cl::desc("Adaptively define a new threshold based on the application"));

static cl::opt<bool> AdaptiveBands(
    "adaptive-bands", cl::init(false), cl::Hidden,
    cl::desc("Adaptively define the LSH geometry based on the application"));

static cl::opt<double>
    RankingDistance("ranking-distance", cl::init(1.0), cl::Hidden,
                    cl::desc("Define a threshold to be used"));

static cl::opt<bool> EnableThunkPrediction(
    "thunk-predictor", cl::init(false), cl::Hidden,
    cl::desc(
        "Enable dismissal of candidates caused by thunk non-profitability"));

static cl::opt<bool>
    ReportStats("func-merging-report", cl::init(false), cl::Hidden,
                cl::desc("Only report the distances and alignment between all "
                         "allowed function pairs"));

static cl::opt<bool>
    MatcherStats("func-merging-matcher-report", cl::init(false), cl::Hidden,
                 cl::desc("Only report statistics about the distribution of "
                          "distances and bucket sizes in the Matcher"));

static cl::opt<bool> Deterministic(
    "func-merging-deterministic", cl::init(true), cl::Hidden,
    cl::desc("Replace all random number generators with deterministic values"));

static cl::opt<unsigned>
    BucketSizeCap("bucket-size-cap", cl::init(1000000000), cl::Hidden,
                  cl::desc("Define a threshold to be used"));

static std::string GetValueName(const Value *V);

#ifdef __unix__ /* __unix__ is usually defined by compilers targeting Unix     \
                   systems */

unsigned long long getTotalSystemMemory() {
  long pages = sysconf(_SC_PHYS_PAGES);
  long page_size = sysconf(_SC_PAGE_SIZE);
  return pages * page_size;
}

#elif defined(_WIN32) ||                                                       \
    defined(WIN32) /* _Win32 is usually defined by compilers targeting 32 or   \
                      64 bit Windows systems */

unsigned long long getTotalSystemMemory() {
  MEMORYSTATUSEX status;
  status.dwLength = sizeof(status);
  GlobalMemoryStatusEx(&status);
  return status.ullTotalPhys;
}
#endif

static OptimizationRemarkMissed createMissedRemark(StringRef RemarkName,
                                                   StringRef Reason,
                                                   Function *F1, Function *F2) {
  auto remark = OptimizationRemarkMissed(DEBUG_TYPE, RemarkName, F1);
  if (!Reason.empty())
    remark << ore::NV("Reason", Reason);
  remark << ore::NV("Function", F1);
  remark << ore::NV("Function", F2);
  return remark;
}

class FunctionMerging {
public:
  bool runImpl(Module &M, function_ref<TargetTransformInfo *(Function &)> GTTI,
               function_ref<OptimizationRemarkEmitter &(Function &)> GORE);
};

FunctionMergeResult MergeFunctions(Function *F1, Function *F2,
                                   const FunctionMergingOptions &Options) {
  if (F1->getParent() != F2->getParent())
    return FunctionMergeResult(F1, F2, nullptr);
  FunctionMerger Merger(F1->getParent());
  return Merger.merge(F1, F2, "", nullptr, Options);
}

static bool CmpTypes(Type *TyL, Type *TyR, const DataLayout *DL,
                     FunctionMerger::CmpTypesUse Use);

static bool CmpStructTypes(const StructType *STyL, const StructType *STyR,
                           const DataLayout *DL,
                           FunctionMerger::CmpTypesUse Use) {
  if (STyL->getPrimitiveSizeInBits() != STyR->getPrimitiveSizeInBits()) {
    return false;
  }
  if (STyL->getNumElements() != STyR->getNumElements()) {
    return false;
  }

  if (STyL->isPacked() != STyR->isPacked()) {
    return false;
  }

  for (unsigned i = 0,
                e = std::max(STyL->getNumElements(), STyR->getNumElements());
       i != e; ++i) {
    bool Res =
        CmpTypes(STyL->getElementType(i), STyR->getElementType(i), DL, Use);
    if (!Res)
      return false;
  }
  return true;
}

static bool CmpNumbers(uint64_t L, uint64_t R) { return L == R; }

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
static bool CmpTypes(Type *TyL, Type *TyR, const DataLayout *DL,
                     FunctionMerger::CmpTypesUse Use) {
  auto *PTyL = dyn_cast<PointerType>(TyL);
  auto *PTyR = dyn_cast<PointerType>(TyR);

  // const DataLayout &DL = FnL->getParent()->getDataLayout();
  if (PTyL && PTyL->getAddressSpace() == 0)
    TyL = DL->getIntPtrType(TyL);
  if (PTyR && PTyR->getAddressSpace() == 0)
    TyR = DL->getIntPtrType(TyR);

  if (TyL->getTypeID() != TyR->getTypeID())
    return false;
  if (TyL == TyR) {
    return true;
  }

  switch (TyL->getTypeID()) {
  default:
    llvm_unreachable("Unknown type!");
  case Type::IntegerTyID:
    return CmpNumbers(cast<IntegerType>(TyL)->getBitWidth(),
                      cast<IntegerType>(TyR)->getBitWidth());
  // TyL == TyR would have returned true earlier, because types are uniqued.
  case Type::VoidTyID:
  case Type::FloatTyID:
  case Type::DoubleTyID:
  case Type::X86_FP80TyID:
  case Type::FP128TyID:
  case Type::PPC_FP128TyID:
  case Type::LabelTyID:
  case Type::MetadataTyID:
  case Type::TokenTyID:
    return false;

  case Type::PointerTyID:
    assert(PTyL && PTyR && "Both types must be pointers here.");
    return CmpNumbers(PTyL->getAddressSpace(), PTyR->getAddressSpace());

  case Type::StructTyID: {
    if (Use == FunctionMerger::CmpTypesUse::BitCast) {
      // FIXME(katei): bitcast for aggregate types is invalid
      return false;
    } else {
      return CmpStructTypes(cast<StructType>(TyL), cast<StructType>(TyR), DL,
                            Use);
    }
  }

  case Type::FunctionTyID: {
    auto *FTyL = cast<FunctionType>(TyL);
    auto *FTyR = cast<FunctionType>(TyR);
    if (FTyL->getNumParams() != FTyR->getNumParams())
      return CmpNumbers(FTyL->getNumParams(), FTyR->getNumParams());

    if (FTyL->isVarArg() != FTyR->isVarArg())
      return CmpNumbers(FTyL->isVarArg(), FTyR->isVarArg());

    if (int Res =
            CmpTypes(FTyL->getReturnType(), FTyR->getReturnType(), DL, Use))
      return Res;

    for (unsigned i = 0, e = FTyL->getNumParams(); i != e; ++i) {
      if (int Res =
              CmpTypes(FTyL->getParamType(i), FTyR->getParamType(i), DL, Use))
        return Res;
    }
    return false;
  }

  case Type::ArrayTyID: {
    if (Use == FunctionMerger::CmpTypesUse::BitCast) {
      // FIXME(katei): bitcast for aggregate types is invalid
      return false;
    }
    auto *STyL = cast<ArrayType>(TyL);
    auto *STyR = cast<ArrayType>(TyR);
    if (STyL->getNumElements() != STyR->getNumElements())
      return CmpNumbers(STyL->getNumElements(), STyR->getNumElements());
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL, Use);
  }
  case Type::FixedVectorTyID:
  case Type::ScalableVectorTyID: {
    if (Use == FunctionMerger::CmpTypesUse::BitCast) {
      // FIXME(katei): bitcast for aggregate types is invalid
      return false;
    }
    auto *STyL = cast<VectorType>(TyL);
    auto *STyR = cast<VectorType>(TyR);
    if (STyL->getElementCount().isScalable() !=
        STyR->getElementCount().isScalable())
      return CmpNumbers(STyL->getElementCount().isScalable(),
                        STyR->getElementCount().isScalable());
    if (STyL->getElementCount() != STyR->getElementCount())
      return CmpNumbers(STyL->getElementCount().getKnownMinValue(),
                        STyR->getElementCount().getKnownMinValue());
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL, Use);
  }
  }
}

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
bool FunctionMerger::areTypesEquivalent(Type *Ty1, Type *Ty2,
                                        const DataLayout *DL,
                                        const FunctionMergingOptions &Options,
                                        CmpTypesUse Use) {
  if (Ty1 == Ty2)
    return true;
  if (Options.IdenticalTypesOnly)
    return false;

  return CmpTypes(Ty1, Ty2, DL, Use);
}

static bool matchIntrinsicCalls(Intrinsic::ID ID, const CallBase *CI1,
                                const CallBase *CI2) {
  Function *F = CI1->getCalledFunction();
  if (!F)
    return false;
  auto ID1 = (Intrinsic::ID)F->getIntrinsicID();

  F = CI2->getCalledFunction();
  if (!F)
    return false;
  auto ID2 = (Intrinsic::ID)F->getIntrinsicID();

  if (ID1 != ID)
    return false;
  if (ID1 != ID2)
    return false;

  switch (ID) {
  default:
    break;
  case Intrinsic::coro_id: {
    /*
    auto *InfoArg = CS.getArgOperand(3)->stripPointerCasts();
    if (isa<ConstantPointerNull>(InfoArg))
      break;
    auto *GV = dyn_cast<GlobalVariable>(InfoArg);
    Assert(GV && GV->isConstant() && GV->hasDefinitiveInitializer(),
      "info argument of llvm.coro.begin must refer to an initialized "
      "constant");
    Constant *Init = GV->getInitializer();
    Assert(isa<ConstantStruct>(Init) || isa<ConstantArray>(Init),
      "info argument of llvm.coro.begin must refer to either a struct or "
      "an array");
    */
    break;
  }
  case Intrinsic::ctlz: // llvm.ctlz
  case Intrinsic::cttz: // llvm.cttz
    // is_zero_undef argument of bit counting intrinsics must be a constant int
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::experimental_constrained_fadd:
  case Intrinsic::experimental_constrained_fsub:
  case Intrinsic::experimental_constrained_fmul:
  case Intrinsic::experimental_constrained_fdiv:
  case Intrinsic::experimental_constrained_frem:
  case Intrinsic::experimental_constrained_fma:
  case Intrinsic::experimental_constrained_sqrt:
  case Intrinsic::experimental_constrained_pow:
  case Intrinsic::experimental_constrained_powi:
  case Intrinsic::experimental_constrained_sin:
  case Intrinsic::experimental_constrained_cos:
  case Intrinsic::experimental_constrained_exp:
  case Intrinsic::experimental_constrained_exp2:
  case Intrinsic::experimental_constrained_log:
  case Intrinsic::experimental_constrained_log10:
  case Intrinsic::experimental_constrained_log2:
  case Intrinsic::experimental_constrained_rint:
  case Intrinsic::experimental_constrained_nearbyint:
    // visitConstrainedFPIntrinsic(
    //    cast<ConstrainedFPIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_declare: // llvm.dbg.declare
    // Assert(isa<MetadataAsValue>(CS.getArgOperand(0)),
    //       "invalid llvm.dbg.declare intrinsic call 1", CS);
    // visitDbgIntrinsic("declare",
    // cast<DbgInfoIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_addr: // llvm.dbg.addr
    // visitDbgIntrinsic("addr", cast<DbgInfoIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_value: // llvm.dbg.value
    // visitDbgIntrinsic("value", cast<DbgInfoIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_label: // llvm.dbg.label
    // visitDbgLabelIntrinsic("label",
    // cast<DbgLabelInst>(*CS.getInstruction()));
    break;
  case Intrinsic::memcpy:
  case Intrinsic::memmove:
  case Intrinsic::memset: {
    // isvolatile argument of memory intrinsics must be a constant int
    return CI1->getArgOperand(3) == CI2->getArgOperand(3);
  }
  case Intrinsic::memcpy_element_unordered_atomic:
  case Intrinsic::memmove_element_unordered_atomic:
  case Intrinsic::memset_element_unordered_atomic: {
    const auto *AMI1 = cast<AtomicMemIntrinsic>(CI1);
    const auto *AMI2 = cast<AtomicMemIntrinsic>(CI2);

    auto *ElementSizeCI1 = dyn_cast<ConstantInt>(AMI1->getRawElementSizeInBytes());

    auto *ElementSizeCI2 = dyn_cast<ConstantInt>(AMI2->getRawElementSizeInBytes());

    return (ElementSizeCI1 != nullptr && ElementSizeCI1 == ElementSizeCI2);
  }
  case Intrinsic::gcroot:
  case Intrinsic::gcwrite:
  case Intrinsic::gcread:
    // llvm.gcroot parameter #2 must be a constant.
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::init_trampoline:
    break;
  case Intrinsic::prefetch:
    // arguments #2 and #3 in llvm.prefetch must be constants
    return CI1->getArgOperand(1) == CI2->getArgOperand(1) &&
           CI1->getArgOperand(2) == CI2->getArgOperand(2);
  case Intrinsic::stackprotector:
    /*
    Assert(isa<AllocaInst>(CS.getArgOperand(1)->stripPointerCasts()),
           "llvm.stackprotector parameter #2 must resolve to an alloca.", CS);
    */
    break;
  case Intrinsic::lifetime_start:
  case Intrinsic::lifetime_end:
  case Intrinsic::invariant_start:
    // size argument of memory use markers must be a constant integer
    return CI1->getArgOperand(0) == CI2->getArgOperand(0);
  case Intrinsic::invariant_end:
    // llvm.invariant.end parameter #2 must be a constant integer
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::localescape: {
    /*
    BasicBlock *BB = CS.getParent();
    Assert(BB == &BB->getParent()->front(),
           "llvm.localescape used outside of entry block", CS);
    Assert(!SawFrameEscape,
           "multiple calls to llvm.localescape in one function", CS);
    for (Value *Arg : CS.args()) {
      if (isa<ConstantPointerNull>(Arg))
        continue; // Null values are allowed as placeholders.
      auto *AI = dyn_cast<AllocaInst>(Arg->stripPointerCasts());
      Assert(AI && AI->isStaticAlloca(),
             "llvm.localescape only accepts static allocas", CS);
    }
    FrameEscapeInfo[BB->getParent()].first = CS.getNumArgOperands();
    SawFrameEscape = true;
    */
    break;
  }
  case Intrinsic::localrecover: {
    /*
    Value *FnArg = CS.getArgOperand(0)->stripPointerCasts();
    Function *Fn = dyn_cast<Function>(FnArg);
    Assert(Fn && !Fn->isDeclaration(),
           "llvm.localrecover first "
           "argument must be function defined in this module",
           CS);
    auto *IdxArg = dyn_cast<ConstantInt>(CS.getArgOperand(2));
    Assert(IdxArg, "idx argument of llvm.localrecover must be a constant int",
           CS);
    auto &Entry = FrameEscapeInfo[Fn];
    Entry.second = unsigned(
        std::max(uint64_t(Entry.second), IdxArg->getLimitedValue(~0U) + 1));
    */
    break;
  }
    /*
    case Intrinsic::experimental_gc_statepoint:
      Assert(!CS.isInlineAsm(),
             "gc.statepoint support for inline assembly unimplemented", CS);
      Assert(CS.getParent()->getParent()->hasGC(),
             "Enclosing function does not use GC.", CS);

      verifyStatepoint(CS);
      break;
    case Intrinsic::experimental_gc_result: {
      Assert(CS.getParent()->getParent()->hasGC(),
             "Enclosing function does not use GC.", CS);
      // Are we tied to a statepoint properly?
      CallSite StatepointCS(CS.getArgOperand(0));
      const Function *StatepointFn =
        StatepointCS.getInstruction() ? StatepointCS.getCalledFunction() :
    nullptr; Assert(StatepointFn && StatepointFn->isDeclaration() &&
                 StatepointFn->getIntrinsicID() ==
                     Intrinsic::experimental_gc_statepoint,
             "gc.result operand #1 must be from a statepoint", CS,
             CS.getArgOperand(0));

      // Assert that result type matches wrapped callee.
      const Value *Target = StatepointCS.getArgument(2);
      auto *PT = cast<PointerType>(Target->getType());
      auto *TargetFuncType = cast<FunctionType>(PT->getElementType());
      Assert(CS.getType() == TargetFuncType->getReturnType(),
             "gc.result result type does not match wrapped callee", CS);
      break;
    }
    case Intrinsic::experimental_gc_relocate: {
      Assert(CS.getNumArgOperands() == 3, "wrong number of arguments", CS);

      Assert(isa<PointerType>(CS.getType()->getScalarType()),
             "gc.relocate must return a pointer or a vector of pointers", CS);

      // Check that this relocate is correctly tied to the statepoint

      // This is case for relocate on the unwinding path of an invoke statepoint
      if (LandingPadInst *LandingPad =
            dyn_cast<LandingPadInst>(CS.getArgOperand(0))) {

        const BasicBlock *InvokeBB =
            LandingPad->getParent()->getUniquePredecessor();

        // Landingpad relocates should have only one predecessor with invoke
        // statepoint terminator
        Assert(InvokeBB, "safepoints should have unique landingpads",
               LandingPad->getParent());
        Assert(InvokeBB->getTerminator(), "safepoint block should be well
    formed", InvokeBB); Assert(isStatepoint(InvokeBB->getTerminator()), "gc
    relocate should be linked to a statepoint", InvokeBB);
      }
      else {
        // In all other cases relocate should be tied to the statepoint
    directly.
        // This covers relocates on a normal return path of invoke statepoint
    and
        // relocates of a call statepoint.
        auto Token = CS.getArgOperand(0);
        Assert(isa<Instruction>(Token) &&
    isStatepoint(cast<Instruction>(Token)), "gc relocate is incorrectly tied to
    the statepoint", CS, Token);
      }

      // Verify rest of the relocate arguments.

      ImmutableCallSite StatepointCS(
          cast<GCRelocateInst>(*CS.getInstruction()).getStatepoint());

      // Both the base and derived must be piped through the safepoint.
      Value* Base = CS.getArgOperand(1);
      Assert(isa<ConstantInt>(Base),
             "gc.relocate operand #2 must be integer offset", CS);

      Value* Derived = CS.getArgOperand(2);
      Assert(isa<ConstantInt>(Derived),
             "gc.relocate operand #3 must be integer offset", CS);

      const int BaseIndex = cast<ConstantInt>(Base)->getZExtValue();
      const int DerivedIndex = cast<ConstantInt>(Derived)->getZExtValue();
      // Check the bounds
      Assert(0 <= BaseIndex && BaseIndex < (int)StatepointCS.arg_size(),
             "gc.relocate: statepoint base index out of bounds", CS);
      Assert(0 <= DerivedIndex && DerivedIndex < (int)StatepointCS.arg_size(),
             "gc.relocate: statepoint derived index out of bounds", CS);

      // Check that BaseIndex and DerivedIndex fall within the 'gc parameters'
      // section of the statepoint's argument.
      Assert(StatepointCS.arg_size() > 0,
             "gc.statepoint: insufficient arguments");
      Assert(isa<ConstantInt>(StatepointCS.getArgument(3)),
             "gc.statement: number of call arguments must be constant integer");
      const unsigned NumCallArgs =
          cast<ConstantInt>(StatepointCS.getArgument(3))->getZExtValue();
      Assert(StatepointCS.arg_size() > NumCallArgs + 5,
             "gc.statepoint: mismatch in number of call arguments");
      Assert(isa<ConstantInt>(StatepointCS.getArgument(NumCallArgs + 5)),
             "gc.statepoint: number of transition arguments must be "
             "a constant integer");
      const int NumTransitionArgs =
          cast<ConstantInt>(StatepointCS.getArgument(NumCallArgs + 5))
              ->getZExtValue();
      const int DeoptArgsStart = 4 + NumCallArgs + 1 + NumTransitionArgs + 1;
      Assert(isa<ConstantInt>(StatepointCS.getArgument(DeoptArgsStart)),
             "gc.statepoint: number of deoptimization arguments must be "
             "a constant integer");
      const int NumDeoptArgs =
          cast<ConstantInt>(StatepointCS.getArgument(DeoptArgsStart))
              ->getZExtValue();
      const int GCParamArgsStart = DeoptArgsStart + 1 + NumDeoptArgs;
      const int GCParamArgsEnd = StatepointCS.arg_size();
      Assert(GCParamArgsStart <= BaseIndex && BaseIndex < GCParamArgsEnd,
             "gc.relocate: statepoint base index doesn't fall within the "
             "'gc parameters' section of the statepoint call",
             CS);
      Assert(GCParamArgsStart <= DerivedIndex && DerivedIndex < GCParamArgsEnd,
             "gc.relocate: statepoint derived index doesn't fall within the "
             "'gc parameters' section of the statepoint call",
             CS);

      // Relocated value must be either a pointer type or vector-of-pointer
    type,
      // but gc_relocate does not need to return the same pointer type as the
      // relocated pointer. It can be casted to the correct type later if it's
      // desired. However, they must have the same address space and
    'vectorness' GCRelocateInst &Relocate =
    cast<GCRelocateInst>(*CS.getInstruction());
      Assert(Relocate.getDerivedPtr()->getType()->isPtrOrPtrVectorTy(),
             "gc.relocate: relocated value must be a gc pointer", CS);

      auto ResultType = CS.getType();
      auto DerivedType = Relocate.getDerivedPtr()->getType();
      Assert(ResultType->isVectorTy() == DerivedType->isVectorTy(),
             "gc.relocate: vector relocates to vector and pointer to pointer",
             CS);
      Assert(
          ResultType->getPointerAddressSpace() ==
              DerivedType->getPointerAddressSpace(),
          "gc.relocate: relocating a pointer shouldn't change its address
    space", CS); break;
    }
    case Intrinsic::eh_exceptioncode:
    case Intrinsic::eh_exceptionpointer: {
      Assert(isa<CatchPadInst>(CS.getArgOperand(0)),
             "eh.exceptionpointer argument must be a catchpad", CS);
      break;
    }
    case Intrinsic::masked_load: {
      Assert(CS.getType()->isVectorTy(), "masked_load: must return a vector",
    CS);

      Value *Ptr = CS.getArgOperand(0);
      //Value *Alignment = CS.getArgOperand(1);
      Value *Mask = CS.getArgOperand(2);
      Value *PassThru = CS.getArgOperand(3);
      Assert(Mask->getType()->isVectorTy(),
             "masked_load: mask must be vector", CS);

      // DataTy is the overloaded type
      Type *DataTy = cast<PointerType>(Ptr->getType())->getElementType();
      Assert(DataTy == CS.getType(),
             "masked_load: return must match pointer type", CS);
      Assert(PassThru->getType() == DataTy,
             "masked_load: pass through and data type must match", CS);
      Assert(Mask->getType()->getVectorNumElements() ==
             DataTy->getVectorNumElements(),
             "masked_load: vector mask must be same length as data", CS);
      break;
    }
    case Intrinsic::masked_store: {
      Value *Val = CS.getArgOperand(0);
      Value *Ptr = CS.getArgOperand(1);
      //Value *Alignment = CS.getArgOperand(2);
      Value *Mask = CS.getArgOperand(3);
      Assert(Mask->getType()->isVectorTy(),
             "masked_store: mask must be vector", CS);

      // DataTy is the overloaded type
      Type *DataTy = cast<PointerType>(Ptr->getType())->getElementType();
      Assert(DataTy == Val->getType(),
             "masked_store: storee must match pointer type", CS);
      Assert(Mask->getType()->getVectorNumElements() ==
             DataTy->getVectorNumElements(),
             "masked_store: vector mask must be same length as data", CS);
      break;
    }

    case Intrinsic::experimental_guard: {
      Assert(CS.isCall(), "experimental_guard cannot be invoked", CS);
      Assert(CS.countOperandBundlesOfType(LLVMContext::OB_deopt) == 1,
             "experimental_guard must have exactly one "
             "\"deopt\" operand bundle");
      break;
    }

    case Intrinsic::experimental_deoptimize: {
      Assert(CS.isCall(), "experimental_deoptimize cannot be invoked", CS);
      Assert(CS.countOperandBundlesOfType(LLVMContext::OB_deopt) == 1,
             "experimental_deoptimize must have exactly one "
             "\"deopt\" operand bundle");
      Assert(CS.getType() ==
    CS.getInstruction()->getFunction()->getReturnType(),
             "experimental_deoptimize return type must match caller return
    type");

      if (CS.isCall()) {
        auto *DeoptCI = CS.getInstruction();
        auto *RI = dyn_cast<ReturnInst>(DeoptCI->getNextNode());
        Assert(RI,
               "calls to experimental_deoptimize must be followed by a return");

        if (!CS.getType()->isVoidTy() && RI)
          Assert(RI->getReturnValue() == DeoptCI,
                 "calls to experimental_deoptimize must be followed by a return
    " "of the value computed by experimental_deoptimize");
      }

      break;
    }
    */
  };
  return false; // TODO: change to false by default
}

// bool FunctionMerger::matchLandingPad(LandingPadInst *LP1, LandingPadInst
// *LP2) {
static bool matchLandingPad(LandingPadInst *LP1, LandingPadInst *LP2) {
  if (LP1->getType() != LP2->getType())
    return false;
  if (LP1->isCleanup() != LP2->isCleanup())
    return false;
  if (LP1->getNumClauses() != LP2->getNumClauses())
    return false;
  for (unsigned i = 0; i < LP1->getNumClauses(); i++) {
    if (LP1->isCatch(i) != LP2->isCatch(i))
      return false;
    if (LP1->isFilter(i) != LP2->isFilter(i))
      return false;
    if (LP1->getClause(i) != LP2->getClause(i))
      return false;
  }
  return true;
}

static bool matchLoadInsts(const LoadInst *LI1, const LoadInst *LI2) {
  return LI1->isVolatile() == LI2->isVolatile() &&
         LI1->getAlignment() == LI2->getAlignment() &&
         LI1->getOrdering() == LI2->getOrdering();
}

static bool matchStoreInsts(const StoreInst *SI1, const StoreInst *SI2) {
  return SI1->isVolatile() == SI2->isVolatile() &&
         SI1->getAlignment() == SI2->getAlignment() &&
         SI1->getOrdering() == SI2->getOrdering();
}

static bool matchAllocaInsts(const AllocaInst *AI1, const AllocaInst *AI2,
                             const DataLayout *DL,
                             const FunctionMergingOptions &Options) {
  if (AI1->getArraySize() != AI2->getArraySize() ||
      AI1->getAlignment() != AI2->getAlignment())
    return false;

  /*
  // If size is known, I2 can be seen as equivalent to I1 if it allocates
  // the same or less memory.
  if (DL->getTypeAllocSize(AI->getAllocatedType())
        < DL->getTypeAllocSize(cast<AllocaInst>(I2)->getAllocatedType()))
    return false;

  */

  return FunctionMerger::areTypesEquivalent(AI1->getType(), AI2->getType(), DL,
                                            Options);
}

static bool matchGetElementPtrInsts(const GetElementPtrInst *GEP1,
                                    const GetElementPtrInst *GEP2,
                                    const DataLayout *DL,
                                    const FunctionMergingOptions &Options) {
  Type *Ty1 = GEP1->getSourceElementType();
  SmallVector<Value *, 16> Idxs1(GEP1->idx_begin(), GEP1->idx_end());

  Type *Ty2 = GEP2->getSourceElementType();
  SmallVector<Value *, 16> Idxs2(GEP2->idx_begin(), GEP2->idx_end());

  if (!FunctionMerger::areTypesEquivalent(
          Ty1, Ty2, DL, Options, FunctionMerger::CmpTypesUse::GetElementPtr))
    return false;
  if (Idxs1.size() != Idxs2.size())
    return false;

  if (Idxs1.empty())
    return true;

  for (unsigned i = 1; i < Idxs1.size(); i++) {
    Value *V1 = Idxs1[i];
    Value *V2 = Idxs2[i];

    // structs must have constant indices, therefore they must be constants and
    // must be identical when merging
    if (isa<StructType>(Ty1)) {
      if (V1 != V2)
        return false;
    }
    Ty1 = GetElementPtrInst::getTypeAtIndex(Ty1, V1);
    Ty2 = GetElementPtrInst::getTypeAtIndex(Ty2, V2);
    if (Ty1 != Ty2)
      return false;
  }
  return true;
}

static bool matchSwitchInsts(const SwitchInst *SI1, const SwitchInst *SI2) {
  if (SI1->getNumCases() == SI2->getNumCases()) {
    auto CaseIt1 = SI1->case_begin(), CaseEnd1 = SI1->case_end();
    auto CaseIt2 = SI2->case_begin(), CaseEnd2 = SI2->case_end();
    do {
      auto *Case1 = &*CaseIt1;
      auto *Case2 = &*CaseIt2;
      if (Case1 != Case2)
        return false; // TODO: could allow permutation!
      ++CaseIt1;
      ++CaseIt2;
    } while (CaseIt1 != CaseEnd1 && CaseIt2 != CaseEnd2);
    return true;
  }
  return false;
}

static bool matchCallInsts(const CallBase *CI1, const CallBase *CI2) {
  if (CI1->isInlineAsm() || CI2->isInlineAsm())
    return false;

  // if (CI1->getCalledFunction()==nullptr) return false;

  if (CI1->getCalledFunction() != CI2->getCalledFunction())
    return false;

  if (Function *F = CI1->getCalledFunction()) {
    if (auto ID = (Intrinsic::ID)F->getIntrinsicID()) {
      if (!matchIntrinsicCalls(ID, CI1, CI2))
        return false;
    }
  }

  return CI1->getNumArgOperands() == CI2->getNumArgOperands() &&
         CI1->getCallingConv() == CI2->getCallingConv() &&
         CI1->getAttributes() == CI2->getAttributes();
}

static bool matchInvokeInsts(const InvokeInst *II1, const InvokeInst *II2) {
  return matchCallInsts(II1, II2) &&
         II1->getCallingConv() == II2->getCallingConv() &&
         II1->getAttributes() == II2->getAttributes() &&
         matchLandingPad(II1->getLandingPadInst(), II2->getLandingPadInst());
}

static bool matchInsertValueInsts(const InsertValueInst *IV1,
                                  const InsertValueInst *IV2) {
  return IV1->getIndices() == IV2->getIndices();
}

static bool matchExtractValueInsts(const ExtractValueInst *EV1,
                                   const ExtractValueInst *EV2) {
  return EV1->getIndices() == EV2->getIndices();
}

static bool matchFenceInsts(const FenceInst *FI1, const FenceInst *FI2) {
  return FI1->getOrdering() == FI2->getOrdering() &&
         FI1->getSyncScopeID() == FI2->getSyncScopeID();
}

bool FunctionMerger::matchInstructions(Instruction *I1, Instruction *I2,
                                       const FunctionMergingOptions &Options) {

  if (I1->getOpcode() != I2->getOpcode())
    return false;

  if (I1->getOpcode() == Instruction::CallBr)
    return false;

  // Returns are special cases that can differ in the number of operands
  if (I1->getOpcode() == Instruction::Ret)
    return true;

  if (I1->getNumOperands() != I2->getNumOperands())
    return false;

  const DataLayout *DL =
      &I1->getParent()->getParent()->getParent()->getDataLayout();

  if (I1->getOpcode() == Instruction::Alloca)
    return matchAllocaInsts(cast<AllocaInst>(I1), cast<AllocaInst>(I2), DL,
                            Options);

  bool sameType = false;
  if (Options.IdenticalTypesOnly) {
    sameType = (I1->getType() == I2->getType());
    for (unsigned i = 0; i < I1->getNumOperands(); i++) {
      sameType = sameType &&
                 (I1->getOperand(i)->getType() == I2->getOperand(i)->getType());
    }
  } else {
    sameType = areTypesEquivalent(I1->getType(), I2->getType(), DL, Options);
    for (unsigned i = 0; i < I1->getNumOperands(); i++) {
      sameType = sameType &&
                 areTypesEquivalent(I1->getOperand(i)->getType(),
                                    I2->getOperand(i)->getType(), DL, Options);
    }
  }
  if (!sameType)
    return false;

  switch (I1->getOpcode()) {
    // case Instruction::Br: return false; //{ return (I1->getNumOperands()==1);
    // }

    //#define MatchCaseInst(Kind, I1, I2) case Instruction::#Kind

  case Instruction::Load:
    return matchLoadInsts(dyn_cast<LoadInst>(I1), dyn_cast<LoadInst>(I2));
  case Instruction::Store:
    return matchStoreInsts(dyn_cast<StoreInst>(I1), dyn_cast<StoreInst>(I2));
  case Instruction::Alloca:
    return matchAllocaInsts(dyn_cast<AllocaInst>(I1), dyn_cast<AllocaInst>(I2),
                            DL, Options);
  case Instruction::GetElementPtr:
    return matchGetElementPtrInsts(dyn_cast<GetElementPtrInst>(I1),
                                   dyn_cast<GetElementPtrInst>(I2), DL,
                                   Options);
  case Instruction::Switch:
    return matchSwitchInsts(dyn_cast<SwitchInst>(I1), dyn_cast<SwitchInst>(I2));
  case Instruction::Call:
    return matchCallInsts(dyn_cast<CallInst>(I1), dyn_cast<CallInst>(I2));
  case Instruction::Invoke:
    return matchInvokeInsts(dyn_cast<InvokeInst>(I1), dyn_cast<InvokeInst>(I2));
  case Instruction::InsertValue:
    return matchInsertValueInsts(dyn_cast<InsertValueInst>(I1),
                                 dyn_cast<InsertValueInst>(I2));
  case Instruction::ExtractValue:
    return matchExtractValueInsts(dyn_cast<ExtractValueInst>(I1),
                                  dyn_cast<ExtractValueInst>(I2));
  case Instruction::Fence:
    return matchFenceInsts(dyn_cast<FenceInst>(I1), dyn_cast<FenceInst>(I2));
  case Instruction::AtomicCmpXchg: {
    const AtomicCmpXchgInst *CXI = dyn_cast<AtomicCmpXchgInst>(I1);
    const AtomicCmpXchgInst *CXI2 = cast<AtomicCmpXchgInst>(I2);
    return CXI->isVolatile() == CXI2->isVolatile() &&
           CXI->isWeak() == CXI2->isWeak() &&
           CXI->getSuccessOrdering() == CXI2->getSuccessOrdering() &&
           CXI->getFailureOrdering() == CXI2->getFailureOrdering() &&
           CXI->getSyncScopeID() == CXI2->getSyncScopeID();
  }
  case Instruction::AtomicRMW: {
    const AtomicRMWInst *RMWI = dyn_cast<AtomicRMWInst>(I1);
    return RMWI->getOperation() == cast<AtomicRMWInst>(I2)->getOperation() &&
           RMWI->isVolatile() == cast<AtomicRMWInst>(I2)->isVolatile() &&
           RMWI->getOrdering() == cast<AtomicRMWInst>(I2)->getOrdering() &&
           RMWI->getSyncScopeID() == cast<AtomicRMWInst>(I2)->getSyncScopeID();
  }
  default:
    if (auto *CI = dyn_cast<CmpInst>(I1))
      return CI->getPredicate() == cast<CmpInst>(I2)->getPredicate();
    if (isa<OverflowingBinaryOperator>(I1)) {
      if (!isa<OverflowingBinaryOperator>(I2))
        return false;
      if (I1->hasNoUnsignedWrap() != I2->hasNoUnsignedWrap())
        return false;
      if (I1->hasNoSignedWrap() != I2->hasNoSignedWrap())
        return false;
    }
    if (isa<PossiblyExactOperator>(I1)) {
      if (!isa<PossiblyExactOperator>(I2))
        return false;
      if (I1->isExact() != I2->isExact())
        return false;
    }
    if (isa<FPMathOperator>(I1)) {
      if (!isa<FPMathOperator>(I2))
        return false;
      if (I1->isFast() != I2->isFast())
        return false;
      if (I1->hasAllowReassoc() != I2->hasAllowReassoc())
        return false;
      if (I1->hasNoNaNs() != I2->hasNoNaNs())
        return false;
      if (I1->hasNoInfs() != I2->hasNoInfs())
        return false;
      if (I1->hasNoSignedZeros() != I2->hasNoSignedZeros())
        return false;
      if (I1->hasAllowReciprocal() != I2->hasAllowReciprocal())
        return false;
      if (I1->hasAllowContract() != I2->hasAllowContract())
        return false;
      if (I1->hasApproxFunc() != I2->hasApproxFunc())
        return false;
    }
  }

  return true;
}

bool FunctionMerger::match(Value *V1, Value *V2, const FunctionMergingOptions &Options) {
  if (isa<Instruction>(V1) && isa<Instruction>(V2))
    return matchInstructions(dyn_cast<Instruction>(V1),
                             dyn_cast<Instruction>(V2), Options);

  if (isa<BasicBlock>(V1) && isa<BasicBlock>(V2)) {
    auto *BB1 = dyn_cast<BasicBlock>(V1);
    auto *BB2 = dyn_cast<BasicBlock>(V2);
    if (BB1->isLandingPad() || BB2->isLandingPad()) {
      LandingPadInst *LP1 = BB1->getLandingPadInst();
      LandingPadInst *LP2 = BB2->getLandingPadInst();
      if (LP1 == nullptr || LP2 == nullptr)
        return false;
      return matchLandingPad(LP1, LP2);
    } 
    return true;
  }
  return false;
}

static unsigned
RandomLinearizationOfBlocks(BasicBlock *BB,
                            std::list<BasicBlock *> &OrederedBBs,
                            std::set<BasicBlock *> &Visited) {
  if (Visited.find(BB) != Visited.end())
    return 0;
  Visited.insert(BB);

  Instruction *TI = BB->getTerminator();

  std::vector<BasicBlock *> NextBBs;
  for (unsigned i = 0; i < TI->getNumSuccessors(); i++) {
    NextBBs.push_back(TI->getSuccessor(i));
  }
  std::random_device rd;
  std::shuffle(NextBBs.begin(), NextBBs.end(), std::mt19937(rd()));

  unsigned SumSizes = 0;
  for (BasicBlock *NextBlock : NextBBs) {
    SumSizes += RandomLinearizationOfBlocks(NextBlock, OrederedBBs, Visited);
  }

  OrederedBBs.push_front(BB);
  return SumSizes + BB->size();
}

static unsigned
RandomLinearizationOfBlocks(Function *F, std::list<BasicBlock *> &OrederedBBs) {
  std::set<BasicBlock *> Visited;
  return RandomLinearizationOfBlocks(&F->getEntryBlock(), OrederedBBs, Visited);
}

static unsigned
CanonicalLinearizationOfBlocks(BasicBlock *BB,
                               std::list<BasicBlock *> &OrederedBBs,
                               std::set<BasicBlock *> &Visited) {
  if (Visited.find(BB) != Visited.end())
    return 0;
  Visited.insert(BB);

  Instruction *TI = BB->getTerminator();

  unsigned SumSizes = 0;
  for (unsigned i = 0; i < TI->getNumSuccessors(); i++) {
    SumSizes += CanonicalLinearizationOfBlocks(TI->getSuccessor(i), OrederedBBs,
                                               Visited);
  }
  // for (unsigned i = 1; i <= TI->getNumSuccessors(); i++) {
  //  SumSizes +=
  //  CanonicalLinearizationOfBlocks(TI->getSuccessor(TI->getNumSuccessors()-i),
  //  OrederedBBs,
  //                                             Visited);
  //}

  OrederedBBs.push_front(BB);
  return SumSizes + BB->size();
}

static unsigned
CanonicalLinearizationOfBlocks(Function *F,
                               std::list<BasicBlock *> &OrederedBBs) {
  std::set<BasicBlock *> Visited;
  return CanonicalLinearizationOfBlocks(&F->getEntryBlock(), OrederedBBs,
                                        Visited);
}

void FunctionMerger::linearize(Function *F, SmallVectorImpl<Value *> &FVec,
                               FunctionMerger::LinearizationKind LK) {
  std::list<BasicBlock *> OrderedBBs;

  unsigned FReserve = 0;
  switch (LK) {
  case LinearizationKind::LK_Random:
    FReserve = RandomLinearizationOfBlocks(F, OrderedBBs);
    break;
  case LinearizationKind::LK_Canonical:
  default:
    FReserve = CanonicalLinearizationOfBlocks(F, OrderedBBs);
    break;
  }

  FVec.reserve(FReserve + OrderedBBs.size());
  for (BasicBlock *BB : OrderedBBs) {
    FVec.push_back(BB);
    for (Instruction &I : *BB) {
      if (!isa<LandingPadInst>(&I) && !isa<PHINode>(&I)) {
        FVec.push_back(&I);
      }
    }
  }
}

bool FunctionMerger::validMergeTypes(Function *F1, Function *F2,
                                     const FunctionMergingOptions &Options) {
  bool EquivTypes =
      areTypesEquivalent(F1->getReturnType(), F2->getReturnType(), DL, Options);
  if (!EquivTypes && !F1->getReturnType()->isVoidTy() &&
      !F2->getReturnType()->isVoidTy()) {
    return false;
  }
  return true;
}

#ifdef TIME_STEPS_DEBUG
Timer TimeLin("Merge::CodeGen::Lin", "Merge::CodeGen::Lin");
Timer TimeAlign("Merge::CodeGen::Align", "Merge::CodeGen::Align");
Timer TimeAlignRank("Merge::CodeGen::Align::Rank", "Merge::CodeGen::Align::Rank");
Timer TimeParam("Merge::CodeGen::Param", "Merge::CodeGen::Param");
Timer TimeCodeGen("Merge::CodeGen::Gen", "Merge::CodeGen::Gen");
Timer TimeCodeGenFix("Merge::CodeGen::Fix", "Merge::CodeGen::Fix");
Timer TimePostOpt("Merge::CodeGen::PostOpt", "Merge::CodeGen::PostOpt");
Timer TimeCodeGenTotal("Merge::CodeGen::Total", "Merge::CodeGen::Total");

Timer TimePreProcess("Merge::Preprocess", "Merge::Preprocess");
Timer TimeRank("Merge::Rank", "Merge::Rank");
Timer TimeVerify("Merge::Verify", "Merge::Verify");
Timer TimeUpdate("Merge::Update", "Merge::Update");
Timer TimePrinting("Merge::Printing", "Merge::Printing");
Timer TimeTotal("Merge::Total", "Merge::Total");

std::chrono::time_point<std::chrono::steady_clock> time_ranking_start;
std::chrono::time_point<std::chrono::steady_clock> time_ranking_end;
std::chrono::time_point<std::chrono::steady_clock> time_align_start;
std::chrono::time_point<std::chrono::steady_clock> time_align_end;
std::chrono::time_point<std::chrono::steady_clock> time_codegen_start;
std::chrono::time_point<std::chrono::steady_clock> time_codegen_end;
std::chrono::time_point<std::chrono::steady_clock> time_verify_start;
std::chrono::time_point<std::chrono::steady_clock> time_verify_end;
std::chrono::time_point<std::chrono::steady_clock> time_update_start;
std::chrono::time_point<std::chrono::steady_clock> time_update_end;
std::chrono::time_point<std::chrono::steady_clock> time_iteration_end;
#endif


static bool validMergePair(Function *F1, Function *F2) {
  if (!HasWholeProgram && (F1->hasAvailableExternallyLinkage() ||
                           F2->hasAvailableExternallyLinkage()))
    return false;

  if (!HasWholeProgram &&
      (F1->hasLinkOnceLinkage() || F2->hasLinkOnceLinkage()))
    return false;

  // if (!F1->getSection().equals(F2->getSection())) return false;
  //  if (F1->hasSection()!=F2->hasSection()) return false;
  //  if (F1->hasSection() && !F1->getSection().equals(F2->getSection())) return
  //  false;

  if (F1->hasComdat() != F2->hasComdat())
    return false;
  if (F1->hasComdat() && F1->getComdat() != F2->getComdat())
    return false;

  if (F1->hasPersonalityFn() != F2->hasPersonalityFn())
    return false;
  if (F1->hasPersonalityFn()) {
    Constant *PersonalityFn1 = F1->getPersonalityFn();
    Constant *PersonalityFn2 = F2->getPersonalityFn();
    if (PersonalityFn1 != PersonalityFn2)
      return false;
  }

  return true;
}

static void MergeArguments(LLVMContext &Context, Function *F1, Function *F2,
                           AlignedSequence<Value *> &AlignedSeq,
                           std::map<unsigned, unsigned> &ParamMap1,
                           std::map<unsigned, unsigned> &ParamMap2,
                           std::vector<Type *> &Args,
                           const FunctionMergingOptions &Options) {

  Args.push_back(IntegerType::get(Context, 1)); // push the function Id argument
  unsigned ArgId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    ParamMap1[ArgId] = Args.size();
    Args.push_back((*I).getType());
    ArgId++;
  }

  auto AttrList1 = F1->getAttributes();
  auto AttrList2 = F2->getAttributes();

  // merge arguments from Function2 with Function1
  ArgId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {

    std::map<unsigned, int> MatchingScore;
    // first try to find an argument with the same name/type
    // otherwise try to match by type only
    for (unsigned i = 0; i < F1->arg_size(); i++) {
      if (F1->getArg(i)->getType() != (*I).getType()) {
        continue;
      }

      auto AttrSet1 = AttrList1.getParamAttributes(F1->getArg(i)->getArgNo());
      auto AttrSet2 = AttrList2.getParamAttributes((*I).getArgNo());
      if (AttrSet1 != AttrSet2)
        continue;

      bool hasConflict = false; // check for conflict from a previous matching
      for (auto ParamPair : ParamMap2) {
        if (ParamPair.second == ParamMap1[i]) {
          hasConflict = true;
          break;
        }
      }
      if (hasConflict)
        continue;
      MatchingScore[i] = 0;
      if (!Options.MaximizeParamScore)
        break; // if not maximize score, get the first one
    }

    if (MatchingScore.size() > 0) { // maximize scores
      for (auto &Entry : AlignedSeq) {
        if (!Entry.match()) {
          continue;
        }
        auto *I1 = dyn_cast<Instruction>(Entry.get(0));
        auto *I2 = dyn_cast<Instruction>(Entry.get(1));
        if (I1 == nullptr || I2 == nullptr) { // test both for sanity
          continue;
        }
        for (unsigned i = 0; i < I1->getNumOperands(); i++) {
          for (auto KV : MatchingScore) {
            if (I1->getOperand(i) != F1->getArg(KV.first))
              continue;
            if (!(i < I2->getNumOperands() && I2->getOperand(i) == &(*I)))
              continue;
            MatchingScore[KV.first]++;
          }
        }
      }

      int MaxScore = -1;
      unsigned MaxId = 0;

      for (auto KV : MatchingScore) {
        if (KV.second > MaxScore) {
          MaxScore = KV.second;
          MaxId = KV.first;
        }
      }

      ParamMap2[ArgId] = ParamMap1[MaxId];
    } else {
      ParamMap2[ArgId] = Args.size();
      Args.push_back((*I).getType());
    }

    ArgId++;
  }
}

static void SetFunctionAttributes(Function *F1, Function *F2,
                                  Function *MergedFunc) {
  unsigned MaxAlignment = std::max(F1->getAlignment(), F2->getAlignment());
  if (F1->getAlignment() != F2->getAlignment()) {
    if (Debug)
      errs() << "WARNING: different function alignment!\n";
  }
  if (MaxAlignment)
    MergedFunc->setAlignment(Align(MaxAlignment));

  if (F1->getCallingConv() == F2->getCallingConv()) {
    MergedFunc->setCallingConv(F1->getCallingConv());
  } else {
    if (Debug)
      errs() << "WARNING: different calling convention!\n";
    // MergedFunc->setCallingConv(CallingConv::Fast);
  }

  /*
    if (F1->getLinkage() == F2->getLinkage()) {
      MergedFunc->setLinkage(F1->getLinkage());
    } else {
      if (Debug) errs() << "ERROR: different linkage type!\n";
      MergedFunc->setLinkage(GlobalValue::LinkageTypes::InternalLinkage);
    }
  */
  // MergedFunc->setLinkage(GlobalValue::LinkageTypes::ExternalLinkage);
  MergedFunc->setLinkage(GlobalValue::LinkageTypes::InternalLinkage);

  /*
  if (F1->isDSOLocal() == F2->isDSOLocal()) {
    MergedFunc->setDSOLocal(F1->isDSOLocal());
  } else {
    if (Debug) errs() << "ERROR: different DSO local!\n";
  }
  */
  MergedFunc->setDSOLocal(true);

  if (F1->getSubprogram() == F2->getSubprogram()) {
    MergedFunc->setSubprogram(F1->getSubprogram());
  } else {
    if (Debug)
      errs() << "WARNING: different subprograms!\n";
  }

  /*
    if (F1->getUnnamedAddr() == F2->getUnnamedAddr()) {
      MergedFunc->setUnnamedAddr(F1->getUnnamedAddr());
    } else {
      if (Debug) errs() << "ERROR: different unnamed addr!\n";
      MergedFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);
    }
  */
  // MergedFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

  /*
  if (F1->getVisibility() == F2->getVisibility()) {
    //MergedFunc->setVisibility(F1->getVisibility());
  } else if (Debug) {
    errs() << "ERROR: different visibility!\n";
  }
  */
  MergedFunc->setVisibility(GlobalValue::VisibilityTypes::DefaultVisibility);

  // Exception Handling requires landing pads to have the same personality
  // function
  if (F1->hasPersonalityFn() && F2->hasPersonalityFn()) {
    Constant *PersonalityFn1 = F1->getPersonalityFn();
    Constant *PersonalityFn2 = F2->getPersonalityFn();
    if (PersonalityFn1 == PersonalityFn2) {
      MergedFunc->setPersonalityFn(PersonalityFn1);
    } else {
#ifdef ENABLE_DEBUG_CODE
      PersonalityFn1->dump();
      PersonalityFn2->dump();
#endif
      // errs() << "ERROR: different personality function!\n";
      if (Debug)
        errs() << "WARNING: different personality function!\n";
    }
  } else if (F1->hasPersonalityFn()) {
    // errs() << "Only F1 has PersonalityFn\n";
    // TODO: check if this is valid: merge function with personality with
    // function without it
    MergedFunc->setPersonalityFn(F1->getPersonalityFn());
    if (Debug)
      errs() << "WARNING: only one personality function!\n";
  } else if (F2->hasPersonalityFn()) {
    // errs() << "Only F2 has PersonalityFn\n";
    // TODO: check if this is valid: merge function with personality with
    // function without it
    MergedFunc->setPersonalityFn(F2->getPersonalityFn());
    if (Debug)
      errs() << "WARNING: only one personality function!\n";
  }

  if (F1->hasComdat() && F2->hasComdat()) {
    auto *Comdat1 = F1->getComdat();
    auto *Comdat2 = F2->getComdat();
    if (Comdat1 == Comdat2) {
      MergedFunc->setComdat(Comdat1);
    } else if (Debug) {
      errs() << "WARNING: different comdats!\n";
    }
  } else if (F1->hasComdat()) {
    // errs() << "Only F1 has Comdat\n";
    MergedFunc->setComdat(F1->getComdat()); // TODO: check if this is valid:
                                            // merge function with comdat with
                                            // function without it
    if (Debug)
      errs() << "WARNING: only one comdat!\n";
  } else if (F2->hasComdat()) {
    // errs() << "Only F2 has Comdat\n";
    MergedFunc->setComdat(F2->getComdat()); // TODO: check if this is valid:
                                            // merge function with comdat with
                                            // function without it
    if (Debug)
      errs() << "WARNING: only one comdat!\n";
  }

  if (F1->hasSection()) {
    MergedFunc->setSection(F1->getSection());
  }
}

Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
                          Type *IntPtrTy,
                          const FunctionMergingOptions &Options = {});

/*
bool CodeGenerator(Value *IsFunc1, BasicBlock *EntryBB1, BasicBlock *EntryBB2,
BasicBlock *PreBB, std::list<std::pair<Value *, Value *>> &AlignedInsts,
                   ValueToValueMapTy &VMap, Function *MergedFunc,
Type *RetType1, Type *RetType2, Type *ReturnType, bool RequiresUnifiedReturn,
LLVMContext &Context, Type *IntPtrTy, const FunctionMergingOptions &Options =
{}) {
*/

template <typename BlockListType>
void FunctionMerger::CodeGenerator<BlockListType>::destroyGeneratedCode() {
  for (Instruction *I : CreatedInsts) {
    I->dropAllReferences();
  }
  for (Instruction *I : CreatedInsts) {
    I->eraseFromParent();
  }
  for (BasicBlock *BB : CreatedBBs) {
    BB->eraseFromParent();
  }
  CreatedInsts.clear();
  CreatedBBs.clear();
}

unsigned instToInt(Instruction *I);

inst_range getInstructions(Function *F) { return instructions(F); }

iterator_range<BasicBlock::iterator> getInstructions(BasicBlock *BB) {
  return make_range(BB->begin(), BB->end());
}


template <class T> class FingerprintMH {
private:
  // The number of instructions defining a shingle. 2 or 3 is best.
  static constexpr size_t K = 2;
  static constexpr double threshold = 0.3;
  static constexpr size_t MaxOpcode = 68;
  const uint32_t _footprint;

public:
  uint64_t magnitude{0};
  std::vector<uint32_t> hash;
  std::vector<uint32_t> bandHash;

public:
  FingerprintMH() = default;

  FingerprintMH(T owner, SearchStrategy &searchStrategy) : _footprint(searchStrategy.item_footprint()) {
    std::vector<uint32_t> integers;
    std::array<uint32_t, MaxOpcode> OpcodeFreq;

    for (size_t i = 0; i < MaxOpcode; i++)
      OpcodeFreq[i] = 0;

    if (ShingleCrossBBs)
    {
      for (Instruction &I : getInstructions(owner)) {
        integers.push_back(instToInt(&I));
        OpcodeFreq[I.getOpcode()]++;
        if (I.isTerminator())
            OpcodeFreq[0] += I.getNumSuccessors();
      }
    }
    else
    {
      for (BasicBlock &BB : *owner)
      {

        // Process normal instructions
        for (Instruction &I : BB)
        {
          integers.push_back(instToInt(&I));
          OpcodeFreq[I.getOpcode()]++;
          if(I.isTerminator())
            OpcodeFreq[0] += I.getNumSuccessors();
        }
        
        // Add dummy instructions between basic blocks
        for (size_t i = 0; i<K-1;i++)
        {
            integers.push_back(1);
        }

      }

    }

    for (size_t i = 0; i < MaxOpcode; ++i) {
      uint64_t val = OpcodeFreq[i];
      magnitude += val * val;
    }

    searchStrategy.generateShinglesMultipleHashPipelineTurbo<K>(integers, hash);
    searchStrategy.generateBands(hash, bandHash);
  }

  uint32_t footprint() const { return _footprint; }

  float distance(const FingerprintMH &FP2) const {
    size_t nintersect = 0;
    size_t pos1 = 0;
    size_t pos2 = 0;
    size_t nHashes = hash.size();

    while (pos1 != nHashes && pos2 != nHashes) {
      if (hash[pos1] == FP2.hash[pos2]) {
        nintersect++;
        pos1++;
        pos2++;
      } else if (hash[pos1] < FP2.hash[pos2]) {
        pos1++;
      } else {
        pos2++;
      }
    }

    int nunion = 2 * nHashes - nintersect;
    return 1.f - (nintersect / (float)nunion);
  }

  float distance_under(const FingerprintMH &FP2, float best_distance) const {
    size_t mismatches = 0;
    size_t pos1 = 0;
    size_t pos2 = 0;
    size_t nHashes = hash.size();
    size_t best_nintersect = static_cast<size_t>(2.0 * nHashes  * (1.f - best_distance) / (2.f - best_distance));
    size_t best_mismatches = 2 * (nHashes - best_nintersect);

    while (pos1 != nHashes && pos2 != nHashes) {
      if (hash[pos1] == FP2.hash[pos2]) {
        pos1++;
        pos2++;
      } else if (hash[pos1] < FP2.hash[pos2]) {
        mismatches++;
        pos1++;
      } else {
        mismatches++;
        pos2++;
      }
      if (mismatches > best_mismatches)
        break;
    }

    size_t nintersect = nHashes - (mismatches / 2);
    int nunion = 2 * nHashes - nintersect;
    return 1.f - (nintersect / (float)nunion);
  }
};


template <class T> class Fingerprint {
public:
  uint64_t magnitude{0};
  static const size_t MaxOpcode = 68;
  std::array<uint32_t, MaxOpcode> OpcodeFreq;

  Fingerprint() = default;

  Fingerprint(T owner) {
    // memset(OpcodeFreq, 0, sizeof(int) * MaxOpcode);
    for (size_t i = 0; i < MaxOpcode; i++)
      OpcodeFreq[i] = 0;

    for (Instruction &I : getInstructions(owner)) {
      OpcodeFreq[I.getOpcode()]++;
      if (I.isTerminator())
        OpcodeFreq[0] += I.getNumSuccessors();
    }
    for (size_t i = 0; i < MaxOpcode; i++) {
      uint64_t val = OpcodeFreq[i];
      magnitude += val * val;
    }
  }

  uint32_t footprint() const { return sizeof(int) * MaxOpcode; }

  float distance(const Fingerprint &FP2) const {
    int Distance = 0;
    for (size_t i = 0; i < MaxOpcode; i++) {
      int Freq1 = OpcodeFreq[i];
      int Freq2 = FP2.OpcodeFreq[i];
      Distance += std::abs(Freq1 - Freq2);
    }
    return static_cast<float>(Distance);
  }
};

class BlockFingerprint : public Fingerprint<BasicBlock *> {
public:
  BasicBlock *BB{nullptr};
  size_t Size{0};

  BlockFingerprint(BasicBlock *BB) : Fingerprint(BB), BB(BB) {
    for (Instruction &I : *BB) {
      if (!isa<LandingPadInst>(&I) && !isa<PHINode>(&I)) {
        Size++;
      }
    }
  }
};

template <class T, template<typename> class FPTy = Fingerprint> class MatcherFQ : public Matcher<T>{
private:
  struct MatcherEntry {
    T candidate;
    size_t size;
    FPTy<T> FP;
    MatcherEntry() : MatcherEntry(nullptr, 0){};

    template<typename T1 = FPTy<T>, typename T2 = Fingerprint<T>>
    MatcherEntry(T candidate, size_t size, 
    typename std::enable_if_t<std::is_same<T1,T2>::value, int> * = nullptr)
        : candidate(candidate), size(size), FP(candidate){}
    
    template <typename T1 = FPTy<T>, typename T2 = FingerprintMH<T>>
    MatcherEntry(T candidate, size_t size, SearchStrategy &strategy,
    typename std::enable_if_t<std::is_same<T1, T2>::value, int> * = nullptr)
        : candidate(candidate), size(size), FP(candidate, strategy){}
  };
  using MatcherIt = typename std::list<MatcherEntry>::iterator;

  bool initialized{false};
  FunctionMerger &FM;
  FunctionMergingOptions &Options;
  std::list<MatcherEntry> candidates;
  std::unordered_map<T, MatcherIt> cache;
  std::vector<MatchInfo<T>> matches;
  SearchStrategy strategy;

public:
  MatcherFQ() = default;
  MatcherFQ(FunctionMerger &FM, FunctionMergingOptions &Options, size_t rows=2, size_t bands=100)
      : FM(FM), Options(Options), strategy(rows, bands){};

  virtual ~MatcherFQ() = default;

  void add_candidate(T candidate, size_t size) override {
    add_candidate_helper(candidate, size);
    cache[candidate] = candidates.begin();
  }

  template<typename T1 = FPTy<T>, typename T2 = Fingerprint<T>>
  void add_candidate_helper(T candidate, size_t size, 
  typename std::enable_if_t<std::is_same<T1,T2>::value, int> * = nullptr)
  {
      candidates.emplace_front(candidate, size);
  }

  template<typename T1 = FPTy<T>, typename T2 = Fingerprint<T>>
  void add_candidate_helper(T candidate, size_t size, 
  typename std::enable_if_t<!std::is_same<T1,T2>::value, int> * = nullptr)
  {
      candidates.emplace_front(candidate, size, strategy);
  }

  void remove_candidate(T candidate) override {
    auto cache_it = cache.find(candidate);
    assert(cache_it != cache.end());
    candidates.erase(cache_it->second);
  }

  T next_candidate() override {
    if (!initialized) {
      candidates.sort([&](auto &item1, auto &item2) -> bool {
        return item1.FP.magnitude > item2.FP.magnitude;
      });
      initialized = true;
    }
    update_matches(candidates.begin());
    return candidates.front().candidate;
  }

  std::vector<MatchInfo<T>> &get_matches(T candidate) override {
    return matches;
  }

  size_t size() override { return candidates.size(); }

  void print_stats() override {
    int Sum = 0;
    int Count = 0;
    float MinDistance = std::numeric_limits<float>::max();
    float MaxDistance = 0;

    int Index1 = 0;
    for (auto It1 = candidates.begin(), E1 = candidates.end(); It1!=E1; It1++) {

      int BestIndex = 0;
      bool FoundCandidate = false;
      float BestDist = std::numeric_limits<float>::max();

      unsigned CountCandidates = 0;
      int Index2 = Index1;
      for (auto It2 = It1, E2 = candidates.end(); It2 != E2; It2++) {

        if (It1->candidate == It2->candidate || Index1 == Index2) {
          Index2++;
          continue;
        }

        if ((!FM.validMergeTypes(It1->candidate, It2->candidate, Options) &&
             !Options.EnableUnifiedReturnType) ||
            !validMergePair(It1->candidate, It2->candidate))
          continue;

        auto Dist = It1->FP.distance(It2->FP);
        if (Dist < BestDist) {
          BestDist = Dist;
          FoundCandidate = true;
          BestIndex = Index2;
        }
        if (RankingThreshold && CountCandidates > RankingThreshold) {
          break;
        }
        CountCandidates++;
        Index2++;
      }
      if (FoundCandidate) {
        int Distance = std::abs(Index1 - BestIndex);
        Sum += Distance;
        if (Distance > MaxDistance) MaxDistance = Distance;
        if (Distance < MinDistance) MinDistance = Distance;
        Count++;
      }
      Index1++;
    }
    errs() << "Total: " << Count << "\n";
    errs() << "Min Distance: " << MinDistance << "\n";
    errs() << "Max Distance: " << MaxDistance << "\n";
    errs() << "Average Distance: " << (((double)Sum)/((double)Count)) << "\n";
  }


private:
  void update_matches(MatcherIt it) {
    size_t CountCandidates = 0;
    matches.clear();

    MatchInfo<T> best_match;
    best_match.OtherSize = it->size;
    best_match.OtherMagnitude = it->FP.magnitude;
    best_match.Distance = std::numeric_limits<float>::max();

    if (ExplorationThreshold == 1) {
      for (auto entry = std::next(candidates.cbegin()); entry != candidates.cend(); ++entry) {
        if ((!FM.validMergeTypes(it->candidate, entry->candidate, Options) &&
             !Options.EnableUnifiedReturnType) ||
            !validMergePair(it->candidate, entry->candidate))
          continue;
        auto new_distance = it->FP.distance(entry->FP);
        if (new_distance < best_match.Distance) {
          best_match.candidate = entry->candidate;
          best_match.Size = entry->size;
          best_match.Magnitude = entry->FP.magnitude;
          best_match.Distance = new_distance;
        }
        if (RankingThreshold && (CountCandidates > RankingThreshold))
          break;
        CountCandidates++;
      }
      if (best_match.candidate != nullptr)
        if (!EnableF3M || best_match.Distance < RankingDistance)
          /*if (EnableThunkPrediction)
          {
              if (std::max(best_match.size, best_match.OtherSize) + EstimateThunkOverhead(it->candidate, best_match->candidate)) // Needs AlwaysPreserved
                return;
          }*/
          matches.push_back(std::move(best_match));
      return;
    }

    for (auto &entry : candidates) {
      if (entry.candidate == it->candidate)
        continue;
      if ((!FM.validMergeTypes(it->candidate, entry.candidate, Options) &&
           !Options.EnableUnifiedReturnType) ||
          !validMergePair(it->candidate, entry.candidate))
        continue;
      MatchInfo<T> new_match(entry.candidate, entry.size);
      new_match.Distance = it->FP.distance(entry.FP);
      new_match.OtherSize = it->size;
      new_match.OtherMagnitude = it->FP.magnitude;
      new_match.Magnitude = entry.FP.magnitude;
      if (!EnableF3M || new_match.Distance < RankingDistance)
        matches.push_back(std::move(new_match));
      if (RankingThreshold && (CountCandidates > RankingThreshold))
        break;
      CountCandidates++;
    }


    if (ExplorationThreshold < matches.size()) {
      std::partial_sort(matches.begin(), matches.begin() + ExplorationThreshold,
                        matches.end(), [&](auto &match1, auto &match2) -> bool {
                          return match1.Distance < match2.Distance;
                        });
      matches.resize(ExplorationThreshold);
      std::reverse(matches.begin(), matches.end());
    } else {
      std::sort(matches.begin(), matches.end(),
                [&](auto &match1, auto &match2) -> bool {
                  return match1.Distance > match2.Distance;
                });
    }
  }
};

class MatcherManual : public Matcher<Function *> {
  std::vector<Function *> Functions;
  std::vector<MatchInfo<Function *>> matches;
  bool consumed = false;

public:
  MatcherManual(std::vector<Function *> Functions)
      : Matcher<Function *>(), Functions(Functions), matches() {
    assert(Functions.size() > 0);
    for (size_t i = 1; i < Functions.size(); i++) {
      auto *F = Functions[i];
      matches.push_back(MatchInfo<Function *>(F));
    }
  }
  virtual ~MatcherManual() = default;
  void add_candidate(Function *candidate, size_t size) override {}
  void remove_candidate(Function *candidate) override {}
  Function *next_candidate() override { return this->Functions[0]; }
  std::vector<MatchInfo<Function *>> &
  get_matches(Function *candidate) override {
    consumed = true;
    return matches;
  }
  size_t size() override { return consumed ? 0 : 1; }
  void print_stats() override {}
};

template <class T> class MatcherLSH : public Matcher<T> {
private:
  struct MatcherEntry {
    T candidate;
    size_t size;
    FingerprintMH<T> FP;
    MatcherEntry() : MatcherEntry(nullptr, 0){};
    MatcherEntry(T candidate, size_t size, SearchStrategy &strategy)
        : candidate(candidate), size(size),
        FP(candidate, strategy){};
  };
  using MatcherIt = typename std::list<MatcherEntry>::iterator;

  bool initialized{false};
  const size_t rows{2};
  const size_t bands{100};
  FunctionMerger &FM;
  FunctionMergingOptions &Options;
  SearchStrategy strategy;

  std::list<MatcherEntry> candidates;
  std::unordered_map<uint32_t, std::vector<MatcherIt>> lsh;
  std::vector<std::pair<T, MatcherIt>> cache;
  std::vector<MatchInfo<T>> matches;

public:
  MatcherLSH() = default;
  MatcherLSH(FunctionMerger &FM, FunctionMergingOptions &Options, size_t rows, size_t bands)
      : rows(rows), bands(bands), FM(FM), Options(Options), strategy(rows, bands) {};

  virtual ~MatcherLSH() = default;

  void add_candidate(T candidate, size_t size) override {
    candidates.emplace_front(candidate, size, strategy);

    auto it = candidates.begin();
    auto &bandHash = it->FP.bandHash;
    for (size_t i = 0; i < bands; ++i) {
      if (lsh.count(bandHash[i]) > 0)
        lsh.at(bandHash[i]).push_back(it);
      else
        lsh.insert(std::make_pair(bandHash[i], std::vector<MatcherIt>(1, it)));
    }
  }

  void remove_candidate(T candidate) override {
    auto cache_it = candidates.end();
    for (auto &cache_item : cache) {
      if (cache_item.first == candidate) {
        cache_it = cache_item.second;
        break;
      }
    }
    assert(cache_it != candidates.end());

    auto &FP = cache_it->FP;
    for (size_t i = 0; i < bands; ++i) {
      if (lsh.count(FP.bandHash[i]) == 0)
        continue;

      auto &foundFs = lsh.at(FP.bandHash[i]);
      for (size_t j = 0; j < foundFs.size(); ++j)
        if (foundFs[j]->candidate == candidate)
          lsh.at(FP.bandHash[i]).erase(lsh.at(FP.bandHash[i]).begin() + j);
    }
    candidates.erase(cache_it);
  }

  T next_candidate() override {
    if (!initialized) {
      candidates.sort([&](auto &item1, auto &item2) -> bool {
        return item1.FP.magnitude > item2.FP.magnitude;
      });
      initialized = true;
    }
    update_matches(candidates.begin());
    return candidates.front().candidate;
  }

  std::vector<MatchInfo<T>> &get_matches(T candidate) override {
    return matches;
  }

  size_t size() override { return candidates.size(); }

  void print_stats() override {
    std::unordered_set<T> seen;
    std::vector<uint32_t> hist_bucket_size(20);
    std::vector<uint32_t> hist_distances(21);
    std::vector<uint32_t> hist_distances_diff(21);
    uint32_t duplicate_hashes = 0;

    for (auto it = lsh.cbegin(); it != lsh.cend(); ++it) {
      size_t idx = 31 - __builtin_clz(it->second.size());
      idx = idx < 20 ? idx : 19;
      hist_bucket_size[idx]++;
    }
    for (size_t i = 0; i < 20; i++)
      errs() << "STATS: Histogram Bucket Size " << (1 << i) << " : " << hist_bucket_size[i] << "\n";
    return;

    for (auto it = candidates.begin(); it != candidates.end(); ++it) {
      seen.clear();
      seen.reserve(candidates.size() / 10);

      float best_distance = std::numeric_limits<float>::max();
      std::unordered_set<uint32_t> temp(it->FP.hash.begin(), it->FP.hash.end());
      duplicate_hashes += it->FP.hash.size() - temp.size();

      for (size_t i = 0; i < bands; ++i) {
        auto &foundFs = lsh.at(it->FP.bandHash[i]);
        size_t idx = 31 - __builtin_clz(foundFs.size());
        idx = idx < 20 ? idx : 19;
        hist_bucket_size[idx]++;
        for (size_t j = 0; j < foundFs.size(); ++j) {
          auto match_it = foundFs[j];
          if ((match_it->candidate == NULL) ||
              (match_it->candidate == it->candidate))
            continue;
          if ((!FM.validMergeTypes(it->candidate, match_it->candidate, Options) &&
               !Options.EnableUnifiedReturnType) ||
              !validMergePair(it->candidate, match_it->candidate))
            continue;

          if (seen.count(match_it->candidate) == 1)
            continue;
          seen.insert(match_it->candidate);

          auto distance = it->FP.distance(match_it->FP);
          best_distance = distance < best_distance ? distance : best_distance;
          auto idx2 = static_cast<size_t>(distance * 20);
          idx2 = idx2 < 21 ? idx2 : 20;
          hist_distances[idx2]++;
          auto idx3 = static_cast<size_t>((distance - best_distance) * 20);
          idx3 = idx3 < 21 ? idx3 : 20;
          hist_distances_diff[idx3]++;
        }
      }
    }
    errs() << "STATS: Avg Duplicate Hashes: " << (1.0*duplicate_hashes) / candidates.size() << "\n";
    for (size_t i = 0; i < 20; i++)
      errs() << "STATS: Histogram Bucket Size " << (1 << i) << " : " << hist_bucket_size[i] << "\n";
    for (size_t i = 0; i < 21; i++)
      errs() << "STATS: Histogram Distances " << i * 0.05 << " : " << hist_distances[i] << "\n";
    for (size_t i = 0; i < 21; i++)
      errs() << "STATS: Histogram Distances Diff " << i * 0.05 << " : " << hist_distances_diff[i] << "\n";
  }

private:
  void update_matches(MatcherIt it) {
    size_t CountCandidates = 0;
    std::unordered_set<T> seen;
    seen.reserve(candidates.size() / 10);
    matches.clear();
    cache.clear();
    cache.emplace_back(it->candidate, it);

    auto &FP = it->FP;
    MatchInfo<T> best_match;
    best_match.Distance = std::numeric_limits<float>::max();
    for (size_t i = 0; i < bands; ++i) {
      assert(lsh.count(FP.bandHash[i]) > 0);

      auto &foundFs = lsh.at(FP.bandHash[i]);
      for (size_t j = 0; j < foundFs.size() && j < BucketSizeCap; ++j) {
        auto match_it = foundFs[j];
        if ((match_it->candidate == NULL) ||
            (match_it->candidate == it->candidate))
          continue;
        if ((!FM.validMergeTypes(it->candidate, match_it->candidate, Options) &&
             !Options.EnableUnifiedReturnType) ||
            !validMergePair(it->candidate, match_it->candidate))
          continue;

        if (seen.count(match_it->candidate) == 1)
          continue;
        seen.insert(match_it->candidate);

        MatchInfo<T> new_match(match_it->candidate, match_it->size);
        if (best_match.Distance < 0.1)
          new_match.Distance = FP.distance_under(match_it->FP, best_match.Distance);
        else
          new_match.Distance = FP.distance(match_it->FP);
        new_match.OtherSize = it->size;
        new_match.OtherMagnitude = FP.magnitude;
        new_match.Magnitude = match_it->FP.magnitude;
        if (new_match.Distance < best_match.Distance && new_match.Distance < RankingDistance )
          best_match = new_match;
        if (ExplorationThreshold > 1)
          if (new_match.Distance < RankingDistance)
            matches.push_back(new_match);
        cache.emplace_back(match_it->candidate, match_it);
        if (RankingThreshold && (CountCandidates > RankingThreshold))
          break;
        CountCandidates++;
      }
      // If we've gone through i = 0 without finding a distance of 0.0
      // the minimum distance we might ever find is 2.0 / (nHashes + 1)
      if ((ExplorationThreshold == 1) && (best_match.Distance < (2.0 / (rows * bands) )))
        break;
      if (RankingThreshold && (CountCandidates > RankingThreshold))
        break;
    }

    if (ExplorationThreshold == 1)
      if (best_match.candidate != nullptr)
        matches.push_back(std::move(best_match));

    if (matches.size() <= 1)
      return;

    size_t toRank = std::min((size_t)ExplorationThreshold, matches.size());

    std::partial_sort(matches.begin(), matches.begin() + toRank, matches.end(),
                      [&](auto &match1, auto &match2) -> bool {
                        return match1.Distance < match2.Distance;
                      });
    matches.resize(toRank);
    std::reverse(matches.begin(), matches.end());
  }
};

std::unique_ptr<Matcher<Function *>>
llvm::createMatcherLSH(FunctionMerger &FM, FunctionMergingOptions &Options,
                      size_t rows, size_t bands) {
  return std::make_unique<MatcherLSH<Function *>>(FM, Options, rows, bands);
}

template <class T> class MatcherReport {
private:
  struct MatcherEntry {
    T candidate;
    Fingerprint<T> FPF;
    FingerprintMH<T> FPMH;
    MatcherEntry(T candidate, SearchStrategy &strategy)
        : candidate(candidate), FPF(candidate), FPMH(candidate, strategy){};
  };
  using MatcherIt = typename std::list<MatcherEntry>::iterator;

  FunctionMerger &FM;
  FunctionMergingOptions &Options;
  SearchStrategy strategy;
  std::vector<MatcherEntry> candidates;

public:
  MatcherReport() = default;
  MatcherReport(size_t rows, size_t bands, FunctionMerger &FM, FunctionMergingOptions &Options)
      : FM(FM), Options(Options), strategy(rows, bands) {};

  ~MatcherReport() = default;

  void add_candidate(T candidate) {
    candidates.emplace_back(candidate, strategy);
  }

  void report() const {
    char distance_mh_str[20];

    for (auto &entry: candidates) {
      uint64_t val = 0;
      for (auto &num: entry.FPF.OpcodeFreq)
        val += num;
      errs() << "Function Name: " << GetValueName(entry.candidate)
             << " Fingerprint Size: " << val << "\n";
    }

    std::string Name("_m_f_");
    for (auto it1 = candidates.cbegin(); it1 != candidates.cend(); ++it1) {
      for (auto it2 = std::next(it1); it2 != candidates.cend(); ++it2) {
        if ((!FM.validMergeTypes(it1->candidate, it2->candidate, Options) &&
             !Options.EnableUnifiedReturnType) ||
            !validMergePair(it1->candidate, it2->candidate))
          continue;

        auto distance_fq = it1->FPF.distance(it2->FPF);
        auto distance_mh = it1->FPMH.distance(it2->FPMH);
        std::snprintf(distance_mh_str, 20, "%.5f", distance_mh);
        errs() << "F1: " << it1 - candidates.cbegin() << " + "
               << "F2: " << it2 - candidates.cbegin() << " "
               << "FQ: " << static_cast<int>(distance_fq) << " "
               << "MH: " << distance_mh_str << "\n";
        FunctionMergeResult Result =
            FM.merge(it1->candidate, it2->candidate, Name, nullptr, Options);
      }
    }
  }
};

bool FunctionMerger::isSAProfitable(AlignedSequence<Value *> &AlignedBlocks) {
    int OriginalCost = 0;
    int MergedCost = 0;

    bool InsideSplit = false;

    for (auto &Entry : AlignedBlocks) {
      Instruction *I1 = nullptr;
      if (Entry.get(0))
        I1 = dyn_cast<Instruction>(Entry.get(0));

      Instruction *I2 = nullptr;
      if (Entry.get(1))
        I2 = dyn_cast<Instruction>(Entry.get(1));

      bool IsInstruction = I1 != nullptr || I2 != nullptr;
      if (Entry.match()) {
        if (IsInstruction) {
          OriginalCost += 2;
          MergedCost += 1;
        }
        if (InsideSplit) {
          InsideSplit = false;
          MergedCost += 2;
        }
      } else {
        if (IsInstruction) {
          OriginalCost += 1;
          MergedCost += 1;
        }
        if (!InsideSplit) {
          InsideSplit = true;
          MergedCost += 1;
        }
      }
    }

    bool Profitable = (MergedCost <= OriginalCost);
    if (Verbose)
      errs() << ((Profitable) ? "Profitable" : "Unprofitable") << "\n";
    return Profitable;
}

bool FunctionMerger::isPAProfitable(BasicBlock *BB1, BasicBlock *BB2){
  int OriginalCost = 0;
  int MergedCost = 0;

  bool InsideSplit = !FunctionMerger::match(BB1, BB2);
  if(InsideSplit)
    MergedCost = 1;

  auto It1 = BB1->begin();
  while (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1))
    It1++;

  auto It2 = BB2->begin();
  while (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2))
    It2++;

  while (It1 != BB1->end() && It2 != BB2->end()) {
    Instruction *I1 = &*It1;
    Instruction *I2 = &*It2;

    OriginalCost += 2;
    if (matchInstructions(I1, I2)) {
      MergedCost += 1; // reduces 1 inst by merging two insts into one
      if (InsideSplit) {
        InsideSplit = false;
        MergedCost += 2; // two branches to converge
      }
    } else {
      if (!InsideSplit) {
        InsideSplit = true;
        MergedCost += 1; // one branch to split
      }
      MergedCost += 2; // two instructions
    }
    It1++;
    It2++;
  }
  assert(It1 == BB1->end() && It2 == BB2->end());

  bool Profitable = (MergedCost <= OriginalCost);
  if (Verbose)
    errs() << ((Profitable) ? "Profitable" : "Unprofitable") << "\n";
  return Profitable;
}

class Aligner {
public:
  virtual ~Aligner() = default;
  virtual AlignedSequence<Value *> align(Function *F1, Function *F2, bool &isProfitable) = 0;

  static void extendAlignedSeq(AlignedSequence<Value *> &AlignedSeq,
                               AlignedSequence<Value *> &AlignedSubSeq,
                               AlignmentStats &stats) {
    for (auto &Entry : AlignedSubSeq) {
      Instruction *I1 = nullptr;
      if (Entry.get(0))
        I1 = dyn_cast<Instruction>(Entry.get(0));

      Instruction *I2 = nullptr;
      if (Entry.get(1))
        I2 = dyn_cast<Instruction>(Entry.get(1));

      bool IsInstruction = I1 != nullptr || I2 != nullptr;

      AlignedSeq.Data.emplace_back(Entry.get(0), Entry.get(1), Entry.match());

      if (IsInstruction) {
        stats.Insts++;
        if (Entry.match())
          stats.Matches++;
        Instruction *I = I1 ? I1 : I2;
        if (I->isTerminator())
          stats.CoreMatches++;
      }
    }
  }

  static void extendAlignedSeq(AlignedSequence<Value *> &AlignedSeq,
                               BasicBlock *BB1, BasicBlock *BB2,
                               AlignmentStats &stats) {
    if (BB1 != nullptr && BB2 == nullptr) {
      AlignedSeq.Data.emplace_back(BB1, nullptr, false);
      for (Instruction &I : *BB1) {
        if (isa<PHINode>(&I) || isa<LandingPadInst>(&I))
          continue;
        stats.Insts++;
        AlignedSeq.Data.emplace_back(&I, nullptr, false);
      }
    } else if (BB1 == nullptr && BB2 != nullptr) {
      AlignedSeq.Data.emplace_back(nullptr, BB2, false);
      for (Instruction &I : *BB2) {
        if (isa<PHINode>(&I) || isa<LandingPadInst>(&I))
          continue;
        stats.Insts++;
        AlignedSeq.Data.emplace_back(nullptr, &I, false);
      }
    } else {
      AlignedSeq.Data.emplace_back(BB1, BB2, FunctionMerger::match(BB1, BB2));

      auto It1 = BB1->begin();
      while (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1))
        It1++;

      auto It2 = BB2->begin();
      while (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2))
        It2++;

      while (It1 != BB1->end() && It2 != BB2->end()) {
        Instruction *I1 = &*It1;
        Instruction *I2 = &*It2;

        stats.Insts++;
        if (FunctionMerger::matchInstructions(I1, I2)) {
          AlignedSeq.Data.emplace_back(I1, I2, true);
          stats.Matches++;
          if (!I1->isTerminator())
            stats.CoreMatches++;
        } else {
          AlignedSeq.Data.emplace_back(I1, nullptr, false);
          AlignedSeq.Data.emplace_back(nullptr, I2, false);
        }

        It1++;
        It2++;
      }
      assert((It1 == BB1->end()) && (It2 == BB2->end()));
    }
  }
};

class SALSSAAligner : public Aligner {
public:
  AlignedSequence<Value *> align(Function *F1, Function *F2,
                                 bool &isProfitable) override {
    SmallVector<Value *, 8> F1Vec;
    SmallVector<Value *, 8> F2Vec;

    FunctionMerger::linearize(F1, F1Vec);
    FunctionMerger::linearize(F2, F2Vec);

    NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(
        ScoringSystem(-1, 2),
        [&](auto *F1, auto *F2) { return FunctionMerger::match(F1, F2); });
    isProfitable = true;
    return SA.getAlignment(F1Vec, F2Vec);
  }
};

class HyFMNWAligner : public Aligner {

  AlignedSequence<Value *> align(Function *F1, Function *F2,
                                 bool &isProfitable) override {
    AlignedSequence<Value *> AlignedSeq;
    AlignmentStats TotalAlignmentStats;

    int B1Max = 0;
    int B2Max = 0;
    size_t MaxMem = 0;

    int NumBB1 = 0;
    int NumBB2 = 0;
    size_t MemSize = 0;

#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.startTimer();
#endif
    std::vector<BlockFingerprint> Blocks;
    for (BasicBlock &BB1 : *F1) {
      BlockFingerprint BD1(&BB1);
      MemSize += BD1.footprint();
      NumBB1++;
      Blocks.push_back(std::move(BD1));
    }
#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.stopTimer();
#endif

    for (BasicBlock &BIt : *F2) {
#ifdef TIME_STEPS_DEBUG
      TimeAlignRank.startTimer();
#endif
      NumBB2++;
      BasicBlock *BB2 = &BIt;
      BlockFingerprint BD2(BB2);

      auto BestIt = Blocks.end();
      float BestDist = std::numeric_limits<float>::max();
      for (auto BDIt = Blocks.begin(), E = Blocks.end(); BDIt != E; BDIt++) {
        auto D = BD2.distance(*BDIt);
        if (D < BestDist) {
          BestDist = D;
          BestIt = BDIt;
        }
      }
#ifdef TIME_STEPS_DEBUG
      TimeAlignRank.stopTimer();
#endif

      bool MergedBlock = false;
      if (BestIt != Blocks.end()) {
        auto &BD1 = *BestIt;
        BasicBlock *BB1 = BD1.BB;

        SmallVector<Value *, 8> BB1Vec;
        SmallVector<Value *, 8> BB2Vec;

        BB1Vec.push_back(BB1);
        for (auto &I : *BB1)
          if (!isa<PHINode>(&I) && !isa<LandingPadInst>(&I))
            BB1Vec.push_back(&I);

        BB2Vec.push_back(BB2);
        for (auto &I : *BB2)
          if (!isa<PHINode>(&I) && !isa<LandingPadInst>(&I))
            BB2Vec.push_back(&I);

        NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(
            ScoringSystem(-1, 2),
            [&](auto *F1, auto *F2) { return FunctionMerger::match(F1, F2); });

        auto MemReq = SA.getMemoryRequirement(BB1Vec, BB2Vec);
        if (Verbose)
          errs() << "PStats: " << BB1Vec.size() << " , " << BB2Vec.size()
                 << " , " << MemReq << "\n";

        if (MemReq > MaxMem) {
          MaxMem = MemReq;
          B1Max = BB1Vec.size();
          B2Max = BB2Vec.size();
        }

        AlignedSequence<Value *> AlignedBlocks =
            SA.getAlignment(BB1Vec, BB2Vec);

        if (!HyFMProfitability ||
            FunctionMerger::isSAProfitable(AlignedBlocks)) {
          extendAlignedSeq(AlignedSeq, AlignedBlocks, TotalAlignmentStats);
          Blocks.erase(BestIt);
          MergedBlock = true;
        }
      }

      if (!MergedBlock)
        extendAlignedSeq(AlignedSeq, nullptr, BB2, TotalAlignmentStats);
    }

    for (auto &BD1 : Blocks)
      extendAlignedSeq(AlignedSeq, BD1.BB, nullptr, TotalAlignmentStats);

    if (Verbose) {
      errs() << "Stats: " << B1Max << " , " << B2Max << " , " << MaxMem << "\n";
      errs() << "RStats: " << NumBB1 << " , " << NumBB2 << " , " << MemSize
             << "\n";
    }

    isProfitable = TotalAlignmentStats.isProfitable();
    return AlignedSeq;
  }
};

class HyFMPAAligner : public Aligner {
  virtual AlignedSequence<Value *> align(Function *F1, Function *F2,
                                         bool &isProfitable) {
    AlignedSequence<Value *> AlignedSeq;
    AlignmentStats TotalAlignmentStats;

    int NumBB1 = 0;
    int NumBB2 = 0;
    size_t MemSize = 0;

#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.startTimer();
#endif
    std::map<size_t, std::vector<BlockFingerprint>> BlocksF1;
    for (BasicBlock &BB1 : *F1) {
      BlockFingerprint BD1(&BB1);
      NumBB1++;
      MemSize += BD1.footprint();
      BlocksF1[BD1.Size].push_back(std::move(BD1));
    }
#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.stopTimer();
#endif

    for (BasicBlock &BIt : *F2) {
#ifdef TIME_STEPS_DEBUG
      TimeAlignRank.startTimer();
#endif
      NumBB2++;
      BasicBlock *BB2 = &BIt;
      BlockFingerprint BD2(BB2);

      auto &SetRef = BlocksF1[BD2.Size];

      auto BestIt = SetRef.end();
      float BestDist = std::numeric_limits<float>::max();
      for (auto BDIt = SetRef.begin(), E = SetRef.end(); BDIt != E; BDIt++) {
        auto D = BD2.distance(*BDIt);
        if (D < BestDist) {
          BestDist = D;
          BestIt = BDIt;
        }
      }
#ifdef TIME_STEPS_DEBUG
      TimeAlignRank.stopTimer();
#endif

      bool MergedBlock = false;
      if (BestIt != SetRef.end()) {
        BasicBlock *BB1 = BestIt->BB;

        if (!HyFMProfitability || FunctionMerger::isPAProfitable(BB1, BB2)) {
          extendAlignedSeq(AlignedSeq, BB1, BB2, TotalAlignmentStats);
          SetRef.erase(BestIt);
          MergedBlock = true;
        }
      }

      if (!MergedBlock)
        extendAlignedSeq(AlignedSeq, nullptr, BB2, TotalAlignmentStats);
    }

    for (auto &Pair : BlocksF1)
      for (auto &BD1 : Pair.second)
        extendAlignedSeq(AlignedSeq, BD1.BB, nullptr, TotalAlignmentStats);

    if (Verbose)
      errs() << "RStats: " << NumBB1 << " , " << NumBB2 << " , " << MemSize
             << "\n";

    isProfitable = TotalAlignmentStats.isProfitable();
    return AlignedSeq;
  }
};

FunctionMergeResult
FunctionMerger::merge(Function *F1, Function *F2, std::string Name,
                      OptimizationRemarkEmitter *ORE,
                      const FunctionMergingOptions &Options) {
  bool ProfitableFn = true;
  LLVMContext &Context = *ContextPtr;
  FunctionMergeResult ErrorResponse(F1, F2, nullptr);

  if (!validMergePair(F1, F2)) {
    if (ORE) {
      ORE->emit(
          [&]() { return createMissedRemark("InvalidMergePair", "", F1, F2); });
    }
    return ErrorResponse;
  }

#ifdef TIME_STEPS_DEBUG
  TimeAlign.startTimer();
  time_align_start = std::chrono::steady_clock::now();
#endif

  std::unique_ptr<Aligner> Aligner;
  if (EnableHyFMNW) {
    Aligner = std::make_unique<HyFMNWAligner>();
  } else if (EnableHyFMPA) {
    Aligner = std::make_unique<HyFMPAAligner>();
  } else { // default SALSSA
    Aligner = std::make_unique<SALSSAAligner>();
  }
  AlignedSequence<Value *> AlignedSeq;
  AlignedSeq = Aligner->align(F1, F2, ProfitableFn);

#ifdef TIME_STEPS_DEBUG
  TimeAlign.stopTimer();
  time_align_end = std::chrono::steady_clock::now();
#endif
  if (!ProfitableFn && !ReportStats) {
    if (Verbose)
      errs() << "Skipped: Not profitable enough!!\n";
    if (ORE) {
      ORE->emit(
          [&]() { return createMissedRemark("NotProfitable", "", F1, F2); });
    }
    return ErrorResponse;
  }

  if (ReportStats)
    return ErrorResponse;

#ifdef TIME_STEPS_DEBUG
  TimeParam.startTimer();
#endif

  // Merging parameters
  std::map<unsigned, unsigned> ParamMap1;
  std::map<unsigned, unsigned> ParamMap2;
  std::vector<Type *> Args;

  MergeArguments(Context, F1, F2, AlignedSeq, ParamMap1, ParamMap2, Args,
                 Options);

  Type *RetType1 = F1->getReturnType();
  Type *RetType2 = F2->getReturnType();
  Type *ReturnType = nullptr;

  bool RequiresUnifiedReturn = false;

  if (validMergeTypes(F1, F2, Options)) {
    // errs() << "Simple return types\n";
    ReturnType = RetType1;
    if (ReturnType->isVoidTy()) {
      ReturnType = RetType2;
    }
  } else if (Options.EnableUnifiedReturnType) {
    // errs() << "Unifying return types\n";
    RequiresUnifiedReturn = true;

    auto SizeOfTy1 = DL->getTypeStoreSize(RetType1);
    auto SizeOfTy2 = DL->getTypeStoreSize(RetType2);
    if (SizeOfTy1 >= SizeOfTy2) {
      ReturnType = RetType1;
    } else {
      ReturnType = RetType2;
    }
  } else {
#ifdef TIME_STEPS_DEBUG
    TimeParam.stopTimer();
#endif
    if (ORE) {
      ORE->emit(
          [&]() { return createMissedRemark("InvalidTypePair", "", F1, F2); });
    }
    return ErrorResponse;
  }
  FunctionType *FTy =
      FunctionType::get(ReturnType, ArrayRef<Type *>(Args), false);

  if (Name.empty()) {
    // Name = ".m.f";
    Name = "_m_f";
  }
  /*
    if (!HasWholeProgram) {
      Name = M->getModuleIdentifier() + std::string(".");
    }
    Name = Name + std::string("m.f");
  */
  Function *MergedFunc =
      Function::Create(FTy, // GlobalValue::LinkageTypes::InternalLinkage,
                       GlobalValue::LinkageTypes::PrivateLinkage, Twine(Name),
                       M); // merged.function

  // errs() << "Initializing VMap\n";
  ValueToValueMapTy VMap;

  std::vector<Argument *> ArgsList;
  for (Argument &arg : MergedFunc->args()) {
    ArgsList.push_back(&arg);
  }
  Value *FuncId = ArgsList[0];
  FuncId->setName("discriminator");

  ////TODO: merging attributes might create compilation issues if we are not careful.
  ////Therefore, attributes are not being merged right now.
  //auto AttrList1 = F1->getAttributes();
  //auto AttrList2 = F2->getAttributes();
  //auto AttrListM = MergedFunc->getAttributes();

  auto assignArgName = [&](Argument *MergedArg, Argument *SrcArg) {
    std::string displayName;
    if (SrcArg->getName().empty()) {
      displayName = std::to_string(SrcArg->getArgNo());
    } else {
      displayName = SrcArg->getName().str();
    }
    if (MergedArg->getName().empty()) {
      MergedArg->setName("m." + displayName);
    } else {
      MergedArg->setName(MergedArg->getName() + Twine(".") + displayName);
    }

  };
  int ArgId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    Argument *Arg = ArgsList[ParamMap1[ArgId]];
    VMap[&(*I)] = Arg;

    assignArgName(Arg, I);
    //auto AttrSet1 = AttrList1.getParamAttributes((*I).getArgNo());
    //AttrBuilder Attrs(AttrSet1);
    //AttrListM = AttrListM.addParamAttributes(
    //    Context, ArgsList[ParamMap1[ArgId]]->getArgNo(), Attrs);

    ArgId++;
  }

  ArgId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {
    Argument *Arg = ArgsList[ParamMap2[ArgId]];
    VMap[&(*I)] = Arg;

    assignArgName(Arg, I);
    //auto AttrSet2 = AttrList2.getParamAttributes((*I).getArgNo());
    //AttrBuilder Attrs(AttrSet2);
    //AttrListM = AttrListM.addParamAttributes(
    //    Context, ArgsList[ParamMap2[ArgId]]->getArgNo(), Attrs);

    ArgId++;
  }
  //MergedFunc->setAttributes(AttrListM);
  
#ifdef TIME_STEPS_DEBUG
  TimeParam.stopTimer();
#endif

  // errs() << "Setting attributes\n";
  SetFunctionAttributes(F1, F2, MergedFunc);

  // errs() << "Running code generator\n";

  auto Gen = [&](auto &CG) {
    CG.setFunctionIdentifier(FuncId)
        .setEntryPoints(&F1->getEntryBlock(), &F2->getEntryBlock())
        .setReturnTypes(RetType1, RetType2)
        .setMergedFunction(MergedFunc)
        .setMergedEntryPoint(BasicBlock::Create(Context, "entry", MergedFunc))
        .setMergedReturnType(ReturnType, RequiresUnifiedReturn)
        .setContext(ContextPtr)
        .setIntPtrType(IntPtrTy);
    if (!CG.generate(AlignedSeq, VMap, Options)) {
      // F1->dump();
      // F2->dump();
      // MergedFunc->dump();
      MergedFunc->eraseFromParent();
      MergedFunc = nullptr;
      if (Debug)
        errs() << "ERROR: Failed to generate the merged function!\n";

      if (ORE) {
        ORE->emit(
            [&]() { return createMissedRemark("SALSSACodeGen", "", F1, F2); });
      }
    }
  };

  SALSSACodeGen<Function::BasicBlockListType> CG(F1->getBasicBlockList(),
                                                 F2->getBasicBlockList());
  Gen(CG);

  /*
  if (!RequiresFuncId) {
    errs() << "Removing FuncId\n";

    MergedFunc = RemoveFuncIdArg(MergedFunc, ArgsList);

    for (auto &kv : ParamMap1) {
      ParamMap1[kv.first] = kv.second - 1;
    }
    for (auto &kv : ParamMap2) {
      ParamMap2[kv.first] = kv.second - 1;
    }
    FuncId = nullptr;

  }
  */

  FunctionMergeResult Result(F1, F2, MergedFunc, RequiresUnifiedReturn);
  Result.setArgumentMapping(F1, ParamMap1);
  Result.setArgumentMapping(F2, ParamMap2);
  Result.setFunctionIdArgument(FuncId != nullptr);
  return Result;
}

void FunctionMerger::replaceByCall(Function *F, FunctionMergeResult &MFR,
                                   const FunctionMergingOptions &Options) {
  LLVMContext &Context = M->getContext();

  Value *FuncId = MFR.getFunctionIdValue(F);
  Function *MergedF = MFR.getMergedFunction();

  // Make sure we preserve its linkage
  auto Linkage = F->getLinkage();

  F->deleteBody();
  BasicBlock *NewBB = BasicBlock::Create(Context, "", F);
  IRBuilder<> Builder(NewBB);

  std::vector<Value *> args;
  for (unsigned i = 0; i < MergedF->getFunctionType()->getNumParams(); i++) {
    args.push_back(nullptr);
  }

  if (MFR.hasFunctionIdArgument()) {
    args[0] = FuncId;
  }

  std::vector<Argument *> ArgsList;
  for (Argument &arg : F->args()) {
    ArgsList.push_back(&arg);
  }

  for (auto Pair : MFR.getArgumentMapping(F)) {
    args[Pair.second] = ArgsList[Pair.first];
  }

  for (unsigned i = 0; i < args.size(); i++) {
    if (args[i] == nullptr) {
      args[i] = UndefValue::get(MergedF->getFunctionType()->getParamType(i));
    }
  }

  F->setLinkage(Linkage);

  CallInst *CI =
      (CallInst *)Builder.CreateCall(MergedF, ArrayRef<Value *>(args));
  CI->setTailCall();
  CI->setCallingConv(MergedF->getCallingConv());
  CI->setAttributes(MergedF->getAttributes());
  CI->setIsNoInline();

  if (F->getReturnType()->isVoidTy()) {
    Builder.CreateRetVoid();
  } else {
    Value *CastedV;
    if (MFR.needUnifiedReturn()) {
      Value *AddrCI = Builder.CreateAlloca(CI->getType());
      Builder.CreateStore(CI, AddrCI);
      Value *CastedAddr = Builder.CreatePointerCast(
          AddrCI,
          PointerType::get(F->getReturnType(), DL->getAllocaAddrSpace()));
      CastedV = Builder.CreateLoad(F->getReturnType(), CastedAddr);
    } else {
      CastedV = createCastIfNeeded(CI, F->getReturnType(), Builder, IntPtrTy,
                                   Options);
    }
    Builder.CreateRet(CastedV);
  }
}

bool FunctionMerger::replaceCallsWith(Function *F, FunctionMergeResult &MFR,
                                      const FunctionMergingOptions &Options) {

  Value *FuncId = MFR.getFunctionIdValue(F);
  Function *MergedF = MFR.getMergedFunction();

  unsigned CountUsers = 0;
  std::vector<CallBase *> Calls;
  for (User *U : F->users()) {
    CountUsers++;
    if (auto *CI = dyn_cast<CallInst>(U)) {
      if (CI->getCalledFunction() == F) {
        Calls.push_back(CI);
      }
    } else if (auto *II = dyn_cast<InvokeInst>(U)) {
      if (II->getCalledFunction() == F) {
        Calls.push_back(II);
      }
    }
  }

  if (Calls.size() < CountUsers)
    return false;

  for (CallBase *CI : Calls) {
    IRBuilder<> Builder(CI);

    std::vector<Value *> args;
    for (unsigned i = 0; i < MergedF->getFunctionType()->getNumParams(); i++) {
      args.push_back(nullptr);
    }

    if (MFR.hasFunctionIdArgument()) {
      args[0] = FuncId;
    }

    for (auto Pair : MFR.getArgumentMapping(F)) {
      args[Pair.second] = CI->getArgOperand(Pair.first);
    }

    for (unsigned i = 0; i < args.size(); i++) {
      if (args[i] == nullptr) {
        args[i] = UndefValue::get(MergedF->getFunctionType()->getParamType(i));
      }
    }

    CallBase *NewCB = nullptr;
    if (CI->getOpcode() == Instruction::Call) {
      NewCB = (CallInst *)Builder.CreateCall(MergedF->getFunctionType(),
                                             MergedF, args);
    } else if (CI->getOpcode() == Instruction::Invoke) {
      auto *II = dyn_cast<InvokeInst>(CI);
      NewCB = (InvokeInst *)Builder.CreateInvoke(MergedF->getFunctionType(),
                                                 MergedF, II->getNormalDest(),
                                                 II->getUnwindDest(), args);
      // MergedF->dump();
      // MergedF->getFunctionType()->dump();
      // errs() << "Invoke CallUpdate:\n";
      // II->dump();
      // NewCB->dump();
    }
    NewCB->setCallingConv(MergedF->getCallingConv());
    NewCB->setAttributes(MergedF->getAttributes());
    NewCB->setIsNoInline();
    Value *CastedV = NewCB;
    if (!F->getReturnType()->isVoidTy()) {
      if (MFR.needUnifiedReturn()) {
        Value *AddrCI = Builder.CreateAlloca(NewCB->getType());
        Builder.CreateStore(NewCB, AddrCI);
        Value *CastedAddr = Builder.CreatePointerCast(
            AddrCI,
            PointerType::get(F->getReturnType(), DL->getAllocaAddrSpace()));
        CastedV = Builder.CreateLoad(F->getReturnType(), CastedAddr);
      } else {
        CastedV = createCastIfNeeded(NewCB, F->getReturnType(), Builder,
                                     IntPtrTy, Options);
      }
    }

    // if (F->getReturnType()==MergedF->getReturnType())
    if (CI->getNumUses() > 0) {
      CI->replaceAllUsesWith(CastedV);
    }
    // assert( (CI->getNumUses()>0) && "ERROR: Function Call has uses!");
    CI->eraseFromParent();
  }

  return true;
}

static bool ShouldPreserveGV(const GlobalValue *GV) {
  // Function must be defined here
  if (GV->isDeclaration())
    return true;

  // Available externally is really just a "declaration with a body".
  // if (GV->hasAvailableExternallyLinkage())
  //  return true;

  // Assume that dllexported symbols are referenced elsewhere
  if (GV->hasDLLExportStorageClass())
    return true;

  // Already local, has nothing to do.
  if (GV->hasLocalLinkage())
    return false;

  return false;
}

static int RequiresOriginalInterface(Function *F, FunctionMergeResult &MFR,
                                     StringSet<> &AlwaysPreserved) {
  bool CanErase = !F->hasAddressTaken();
  CanErase =
      CanErase && (AlwaysPreserved.find(F->getName()) == AlwaysPreserved.end());
  if (!HasWholeProgram) {
    CanErase = CanErase && F->isDiscardableIfUnused();
  }
  return !CanErase;
}

static int RequiresOriginalInterfaces(FunctionMergeResult &MFR,
                                      StringSet<> &AlwaysPreserved) {
  auto FPair = MFR.getFunctions();
  Function *F1 = FPair.first;
  Function *F2 = FPair.second;
  return (RequiresOriginalInterface(F1, MFR, AlwaysPreserved) ? 1 : 0) +
         (RequiresOriginalInterface(F2, MFR, AlwaysPreserved) ? 1 : 0);
}

void FunctionMerger::updateCallGraph(Function *F, FunctionMergeResult &MFR,
                                     StringSet<> &AlwaysPreserved,
                                     const FunctionMergingOptions &Options) {
  replaceByCall(F, MFR, Options);
  if (!RequiresOriginalInterface(F, MFR, AlwaysPreserved)) {
    bool CanErase = replaceCallsWith(F, MFR, Options);
    CanErase = CanErase && F->use_empty();
    CanErase = CanErase &&
               (AlwaysPreserved.find(F->getName()) == AlwaysPreserved.end());
    if (!HasWholeProgram) {
      CanErase = CanErase && !ShouldPreserveGV(F);
      CanErase = CanErase && F->isDiscardableIfUnused();
    }
    if (CanErase)
      F->eraseFromParent();
  }
}

void FunctionMerger::updateCallGraph(FunctionMergeResult &MFR,
                                     StringSet<> &AlwaysPreserved,
                                     const FunctionMergingOptions &Options) {
  auto FPair = MFR.getFunctions();
  Function *F1 = FPair.first;
  Function *F2 = FPair.second;
  updateCallGraph(F1, MFR, AlwaysPreserved, Options);
  updateCallGraph(F2, MFR, AlwaysPreserved, Options);
}

int EstimateThunkOverhead(FunctionMergeResult &MFR,
                          StringSet<> &AlwaysPreserved) {
  // return RequiresOriginalInterfaces(MFR, AlwaysPreserved) * 3;
  return RequiresOriginalInterfaces(MFR, AlwaysPreserved) *
         (2 + MFR.getMergedFunction()->getFunctionType()->getNumParams());
}

/*static int EstimateThunkOverhead(Function* F1, Function* F2,
                                 StringSet<> &AlwaysPreserved) {
  int fParams = F1->getFunctionType()->getNumParams() + F2->getFunctionType()->getNumParams();
  return RequiresOriginalInterfaces(F1, F2, AlwaysPreserved) * (2 + fParams);
}*/

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI) {
  float size = 0;
  for (Instruction &I : instructions(F)) {
    switch (I.getOpcode()) {
    // case Instruction::Alloca:
    case Instruction::PHI:
      size += 0.2;
      break;
    // case Instruction::Select:
    //  size += 1.2;
    //  break;
    default:
      auto cost = TTI->getInstructionCost(&I, TargetTransformInfo::TargetCostKind::TCK_CodeSize);
    size += cost.getValue().getValue();
    }
  }
  return size_t(std::ceil(size));
}


unsigned instToInt(Instruction *I) {
  uint32_t value = 0;
  static uint32_t pseudorand_value = 100;

  if (pseudorand_value > 10000)
    pseudorand_value = 100;

  // std::ofstream myfile;
  // std::string newPath = "/home/sean/similarityChecker.txt";

  // Opcodes must be equivalent for instructions to match -- use opcode value as
  // base
  value = I->getOpcode();

  // Number of operands must be equivalent -- except in the case where the
  // instruction is a return instruction -- +1 to stop being zero
  uint32_t operands =
      I->getOpcode() == Instruction::Ret ? 1 : I->getNumOperands();
  value = value * (operands + 1);

  // Instruction type must be equivalent, pairwise operand types must be
  // equivalent -- use typeID casted to int -- This may not be perfect as my
  // understanding of this is limited
  auto instTypeID = static_cast<uint32_t>(I->getType()->getTypeID());
  value = value * (instTypeID + 1);
  auto *ITypePtr = I->getType();
  if (ITypePtr && !Deterministic) {
    value = value * (reinterpret_cast<std::uintptr_t>(ITypePtr) + 1);
  }

  for (size_t i = 0; i < I->getNumOperands(); i++) {
    auto operTypeID = static_cast<uint32_t>(I->getOperand(i)->getType()->getTypeID());
    value = value * (operTypeID + 1);

    auto *IOperTypePtr = I->getOperand(i)->getType();

    if (IOperTypePtr && !Deterministic) {
      value =
          value *
          (reinterpret_cast<std::uintptr_t>(I->getOperand(i)->getType()) + 1);
    }

    value = value * (i + 1);
  }
  return value;

  // Now for the funky stuff -- this is gonna be a wild ride
  switch (I->getOpcode()) {

  case Instruction::Load: {

    const LoadInst *LI = dyn_cast<LoadInst>(I);
    uint32_t lValue = LI->isVolatile() ? 1 : 10;        // Volatility
    lValue += LI->getAlignment();                       // Alignment
    lValue += static_cast<unsigned>(LI->getOrdering()); // Ordering

    value = value * lValue;

    break;
  }

  case Instruction::Store: {

    const StoreInst *SI = dyn_cast<StoreInst>(I);
    uint32_t sValue = SI->isVolatile() ? 2 : 20;        // Volatility
    sValue += SI->getAlignment();                       // Alignment
    sValue += static_cast<unsigned>(SI->getOrdering()); // Ordering

    value = value * sValue;

    break;
  }

  case Instruction::Alloca: {
    const AllocaInst *AI = dyn_cast<AllocaInst>(I);
    uint32_t aValue = AI->getAlignment(); // Alignment

    if (AI->getArraySize() && !Deterministic) {
      aValue += reinterpret_cast<std::uintptr_t>(AI->getArraySize());
    }

    value = value * (aValue + 1);

    break;
  }

  case Instruction::GetElementPtr: // Important
  {

    auto *GEP = dyn_cast<GetElementPtrInst>(I);
    uint32_t gValue = 1;

    SmallVector<Value *, 8> Indices(GEP->idx_begin(), GEP->idx_end());
    gValue = Indices.size() + 1;

    gValue += GEP->isInBounds() ? 3 : 30;

    Type *AggTy = GEP->getSourceElementType();
    gValue += static_cast<unsigned>(AggTy->getTypeID());

    unsigned curIndex = 1;
    for (; curIndex != Indices.size(); ++curIndex) {
      // CompositeType* CTy = dyn_cast<CompositeType>(AggTy);

      if (!AggTy || AggTy->isPointerTy()) {
        if (Deterministic)
          value = pseudorand_value++;
        else
          value = std::rand() % 10000 + 100;
        break;
      }

      Value *Idx = Indices[curIndex];

      if (isa<StructType>(AggTy)) {
        if (!isa<ConstantInt>(Idx)) {
          if (Deterministic)
            value = pseudorand_value++;
          else
            value = std::rand() % 10000 + 100; // Use a random number as we don't
                                               // want this to match with anything
          break;
        }

        auto i = 0;
        if (Idx && !Deterministic) {
          i = reinterpret_cast<std::uintptr_t>(Idx);
        }
        gValue += i;
      }
    }

    value = value * gValue;

    break;
  }

  case Instruction::Switch: {
    auto *SI = dyn_cast<SwitchInst>(I);
    uint32_t sValue = 1;
    sValue = SI->getNumCases();

    auto CaseIt = SI->case_begin(), CaseEnd = SI->case_end();

    while (CaseIt != CaseEnd) {
      auto *Case = &*CaseIt;
      if (Case && !Deterministic) {
        sValue += reinterpret_cast<std::uintptr_t>(Case);
      }
      CaseIt++;
    }

    value = value * sValue;

    break;
  }

  case Instruction::Call: {
    auto *CI = dyn_cast<CallInst>(I);
    uint32_t cValue = 1;

    if (CI->isInlineAsm()) {
      if (Deterministic)
        value = pseudorand_value++;
      else
        value = std::rand() % 10000 + 100;
      break;
    }

    if (CI->getCalledFunction() && !Deterministic) {
      cValue = reinterpret_cast<std::uintptr_t>(CI->getCalledFunction());
    }

    if (Function *F = CI->getCalledFunction()) {
      if (auto ID = (Intrinsic::ID)F->getIntrinsicID()) {
        cValue += static_cast<unsigned>(ID);
      }
    }

    cValue += static_cast<unsigned>(CI->getCallingConv());

    value = value * cValue;

    break;
  }

  case Instruction::Invoke: // Need to look at matching landing pads
  {
    auto *II = dyn_cast<InvokeInst>(I);
    uint32_t iValue = 1;

    iValue = static_cast<unsigned>(II->getCallingConv());

    if (II->getAttributes().getRawPointer() && !Deterministic) {
      iValue +=
          reinterpret_cast<std::uintptr_t>(II->getAttributes().getRawPointer());
    }

    value = value * iValue;

    break;
  }

  case Instruction::InsertValue: {
    auto *IVI = dyn_cast<InsertValueInst>(I);

    uint32_t ivValue = 1;

    ivValue = IVI->getNumIndices();

    // check element wise equality
    auto Idx = IVI->getIndices();
    const auto *IdxIt = Idx.begin();
    const auto *IdxEnd = Idx.end();

    while (IdxIt != IdxEnd) {
      auto *val = &*IdxIt;
      if (val) {
        ivValue += reinterpret_cast<unsigned>(*val);
      }
      IdxIt++;
    }

    value = value * ivValue;

    break;
  }

  case Instruction::ExtractValue: {
    auto *EVI = dyn_cast<ExtractValueInst>(I);

    uint32_t evValue = 1;

    evValue = EVI->getNumIndices();

    // check element wise equality
    auto Idx = EVI->getIndices();
    const auto *IdxIt = Idx.begin();
    const auto *IdxEnd = Idx.end();

    while (IdxIt != IdxEnd) {
      auto *val = &*IdxIt;
      if (val) {
        evValue += reinterpret_cast<unsigned>(*val);
      }
      IdxIt++;
    }

    value = value * evValue;

    break;
  }

  case Instruction::Fence: {
    auto *FI = dyn_cast<FenceInst>(I);

    uint32_t fValue = 1;

    fValue = static_cast<unsigned>(FI->getOrdering());

    fValue += static_cast<unsigned>(FI->getSyncScopeID());

    value = value * fValue;

    break;
  }

  case Instruction::AtomicCmpXchg: {
    auto *AXI = dyn_cast<AtomicCmpXchgInst>(I);

    uint32_t axValue = 1;

    axValue = AXI->isVolatile() ? 4 : 40;
    axValue += AXI->isWeak() ? 5 : 50;
    axValue += static_cast<unsigned>(AXI->getSuccessOrdering());
    axValue += static_cast<unsigned>(AXI->getFailureOrdering());
    axValue += static_cast<unsigned>(AXI->getSyncScopeID());

    value = value * axValue;

    break;
  }

  case Instruction::AtomicRMW: {
    auto *ARI = dyn_cast<AtomicRMWInst>(I);

    uint32_t arValue = 1;

    arValue = static_cast<unsigned>(ARI->getOperation());
    arValue += ARI->isVolatile() ? 6 : 60;
    arValue += static_cast<unsigned>(ARI->getOrdering());
    arValue += static_cast<unsigned>(ARI->getSyncScopeID());

    value = value * arValue;
    break;
  }

  case Instruction::PHI: {
    if (Deterministic)
      value = pseudorand_value++;
    else
      value = std::rand() % 10000 + 100;
    break;
  }

  default:
    if (auto *CI = dyn_cast<CmpInst>(I)) {
      uint32_t cmpValue = 1;

      cmpValue = static_cast<unsigned>(CI->getPredicate()) + 1;

      value = value * cmpValue;
    }
  }

  // Return
  return value;
}

bool ignoreFunction(Function &F) {
  for (Instruction &I : instructions(F)) {
    if (auto *CB = dyn_cast<CallBase>(&I)) {
      if (Function *F2 = CB->getCalledFunction()) {
        if (auto ID = (Intrinsic::ID)F2->getIntrinsicID()) {
          if (Intrinsic::isOverloaded(ID))
            continue;
          if (Intrinsic::getName(ID).contains("permvar"))
            return true;
          if (Intrinsic::getName(ID).contains("vcvtps"))
            return true;
          if (Intrinsic::getName(ID).contains("avx"))
            return true;
          if (Intrinsic::getName(ID).contains("x86"))
            return true;
          if (Intrinsic::getName(ID).contains("arm"))
            return true;
        }
      }
    }
  }
  return false;
}

bool FunctionMerging::runImpl(
    Module &M, function_ref<TargetTransformInfo *(Function &)> GTTI,
    function_ref<OptimizationRemarkEmitter &(Function &)> GORE) {

#ifdef TIME_STEPS_DEBUG
  TimeTotal.startTimer();
  TimePreProcess.startTimer();
#endif

  StringSet<> AlwaysPreserved;
  AlwaysPreserved.insert("main");

  srand(time(nullptr));

  FunctionMergingOptions Options =
      FunctionMergingOptions()
          .maximizeParameterScore(MaxParamScore)
          .matchOnlyIdenticalTypes(IdenticalType)
          .enableUnifiedReturnTypes(EnableUnifiedReturnType);

  // auto *PSI = &this->getAnalysis<ProfileSummaryInfoWrapperPass>().getPSI();
  // auto LookupBFI = [this](Function &F) {
  //  return &this->getAnalysis<BlockFrequencyInfoWrapperPass>(F).getBFI();
  //};

  // TODO: We could use a TTI ModulePass instead but current TTI analysis pass
  // is a FunctionPass.

  FunctionMerger FM(&M);

  if (ReportStats) {
    MatcherReport<Function *> reporter(LSHRows, LSHBands, FM, Options);
    for (auto &F : M) {
      if (F.isDeclaration() || F.isVarArg() || (!HasWholeProgram && F.hasAvailableExternallyLinkage()))
        continue;
      reporter.add_candidate(&F);
    }
    reporter.report();
#ifdef TIME_STEPS_DEBUG
    TimeTotal.stopTimer();
    TimePreProcess.stopTimer();
    TimeRank.clear();
    TimeCodeGenTotal.clear();
    TimeAlign.clear();
    TimeAlignRank.clear();
    TimeParam.clear();
    TimeCodeGen.clear();
    TimeCodeGenFix.clear();
    TimePostOpt.clear();
    TimeVerify.clear();
    TimePreProcess.clear();
    TimeLin.clear();
    TimeUpdate.clear();
    TimePrinting.clear();
    TimeTotal.clear();
#endif
    return false;
  }

  std::unique_ptr<Matcher<Function *>> matcher;

  // Check whether to use a linear scan instead
  int size = 0;
  for (auto &F : M) {
    if (F.isDeclaration() || F.isVarArg() || (!HasWholeProgram && F.hasAvailableExternallyLinkage()))
      continue;
    size++;
  }

  // Create a threshold based on the application's size
  if (AdaptiveThreshold || AdaptiveBands)
  {
    double x = std::log10(size) / 10;
    RankingDistance = (double) (x - 0.3);
    if (RankingDistance < 0.05)
      RankingDistance = 0.05;
    if (RankingDistance > 0.4)
      RankingDistance = 0.4;
  
    if (AdaptiveBands) {
      float target_probability = 0.9;
      float offset = 0.1;
      unsigned tempBands = std::ceil(std::log(1.0 - target_probability) / std::log(1.0 - std::pow(RankingDistance + offset, LSHRows)));
      if (tempBands < LSHBands)
        LSHBands = tempBands;

    }
    if (AdaptiveThreshold)
      RankingDistance = 1 - RankingDistance;
    else
      RankingDistance = 1.0;

  }
  if (Verbose) {
    errs() << "Threshold: " << RankingDistance << "\n";
    errs() << "LSHRows: " << LSHRows << "\n";
    errs() << "LSHBands: " << LSHBands << "\n";
  }

  if (!OnlyFunctions.empty()) {
    std::vector<Function *> functions;
    std::vector<Function *> Functions;
    for (auto &FuncName : OnlyFunctions) {
      auto *F = M.getFunction(FuncName);
      if (!F) {
        errs() << "Function " << FuncName << " not found\n";
        continue;
      }
      Functions.push_back(F);
    }
    matcher = std::make_unique<MatcherManual>(Functions);
  } else if (EnableF3M) {
    matcher = std::make_unique<MatcherLSH<Function *>>(FM, Options, LSHRows, LSHBands);
    if (Verbose) errs() << "LSH MH\n";
  } else {
    matcher = std::make_unique<MatcherFQ<Function *>>(FM, Options);
    if (Verbose) errs() << "LIN SCAN FP\n";
  }

  SearchStrategy strategy(LSHRows, LSHBands);
  size_t count=0;
  for (auto &F : M) {
    if (F.isDeclaration() || F.isVarArg() || (!HasWholeProgram && F.hasAvailableExternallyLinkage()))
      continue;
    if (ignoreFunction(F))
      continue;
    matcher->add_candidate(&F, EstimateFunctionSize(&F, GTTI(F)));
    count++;
  }

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.stopTimer();
#endif

  if (MatcherStats) {
    errs() << "Number of Functions: " << matcher->size() << "\n";
    matcher->print_stats();
#ifdef TIME_STEPS_DEBUG
    TimeRank.clear();
    TimeCodeGenTotal.clear();
    TimeAlign.clear();
    TimeAlignRank.clear();
    TimeParam.clear();
    TimeCodeGen.clear();
    TimeCodeGenFix.clear();
    TimePostOpt.clear();
    TimeVerify.clear();
    TimePreProcess.clear();
    TimeLin.clear();
    TimeUpdate.clear();
    TimePrinting.clear();
    TimeTotal.clear();
#endif
    return false;
  }

  unsigned TotalMerges = 0;
  unsigned TotalOpReorder = 0;
  unsigned TotalBinOps = 0;

  while (matcher->size() > 0) {
#ifdef TIME_STEPS_DEBUG
    TimeRank.startTimer();
    time_ranking_start = std::chrono::steady_clock::now();

    time_ranking_end = time_ranking_start;
    time_align_start = time_ranking_start;
    time_align_end = time_ranking_start;
    time_codegen_start = time_ranking_start;
    time_codegen_end = time_ranking_start;
    time_verify_start = time_ranking_start;
    time_verify_end = time_ranking_start;
    time_update_start = time_ranking_start;
    time_update_end = time_ranking_start;
    time_iteration_end = time_ranking_start;
#endif

    Function *F1 = matcher->next_candidate();
    auto &Rank = matcher->get_matches(F1);
    matcher->remove_candidate(F1);

#ifdef TIME_STEPS_DEBUG
    TimeRank.stopTimer();
    time_ranking_end = std::chrono::steady_clock::now();
#endif
    unsigned MergingTrialsCount = 0;
    float OtherDistance = 0.0;

    while (!Rank.empty()) {
#ifdef TIME_STEPS_DEBUG
      TimeCodeGenTotal.startTimer();
      time_codegen_start = std::chrono::steady_clock::now();
#endif
      MatchInfo<Function *> match = Rank.back();
      Rank.pop_back();
      Function *F2 = match.candidate;

      std::string F1Name(GetValueName(F1));
      std::string F2Name(GetValueName(F2));

      if (Verbose) {
        if (EnableF3M) {
          Fingerprint<Function *> FP1(F1);
          Fingerprint<Function *> FP2(F2);
          OtherDistance = FP1.distance(FP2);
        } else {
          FingerprintMH<Function *> FP1(F1, strategy);
          FingerprintMH<Function *> FP2(F2, strategy);
          OtherDistance = FP1.distance(FP2);
        }
      }

      MergingTrialsCount++;


      if (Debug)
        errs() << "Attempting: " << F1Name << ", " << F2Name << " : " << match.Distance << "\n";

      auto &ORE = GORE(*F1);
      std::string Name =
          "__fm_merge_" + F1->getName().str() + "_" + F2->getName().str();
      FunctionMergeResult Result = FM.merge(F1, F2, Name, &ORE, Options);
#ifdef TIME_STEPS_DEBUG
      TimeCodeGenTotal.stopTimer();
      time_codegen_end = std::chrono::steady_clock::now();
#endif

      if (Result.getMergedFunction() != nullptr) {
#ifdef TIME_STEPS_DEBUG
        TimeVerify.startTimer();
        time_verify_start = std::chrono::steady_clock::now();
#endif
        match.Valid = !verifyFunction(*Result.getMergedFunction());
#ifdef TIME_STEPS_DEBUG
        TimeVerify.stopTimer();
        time_verify_end = std::chrono::steady_clock::now();
#endif

#ifdef ENABLE_DEBUG_CODE
        if (Debug) {
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
          errs() << "F1-F2:\n";
          Result.getMergedFunction()->dump();
        }
#endif
      

#ifdef TIME_STEPS_DEBUG
        TimeUpdate.startTimer();
        time_update_start = std::chrono::steady_clock::now();
#endif
        if (!match.Valid) {
          ORE.emit([&] {
            return createMissedRemark("CodeGen", "Invalid merged function", F1,
                                      F2);
          });
          Result.getMergedFunction()->eraseFromParent();
        } else {
          size_t MergedSize = EstimateFunctionSize(Result.getMergedFunction(), GTTI(*Result.getMergedFunction()));
          size_t Overhead = EstimateThunkOverhead(Result, AlwaysPreserved);

          size_t SizeF12 = MergedSize + Overhead;
          size_t SizeF1F2 = EstimateFunctionSize(F1, GTTI(*F1)) +
                            EstimateFunctionSize(F2, GTTI(*F2));

          match.MergedSize = SizeF12;
          match.Profitable = (SizeF12 + MergingOverheadThreshold) < SizeF1F2;

          if (match.Profitable || AllowUnprofitableMerge ||
              !OnlyFunctions.empty()) {
            ORE.emit([&] {
              auto remark = OptimizationRemark(DEBUG_TYPE, "Merge",
                                               Result.getMergedFunction());
              remark << ore::NV("Function", F1->getName());
              remark << ore::NV("Function", F2->getName());
              remark << ore::NV("MergedSize", MergedSize);
              remark << ore::NV("ThunkOverhead", Overhead);
              remark << ore::NV("OriginalTotalSize", SizeF1F2);
              return remark;
            });
            TotalMerges++;
            matcher->remove_candidate(F2);

            FM.updateCallGraph(Result, AlwaysPreserved, Options);

            if (ReuseMergedFunctions) {
              // feed new function back into the working lists
              matcher->add_candidate(
                  Result.getMergedFunction(),
                  EstimateFunctionSize(Result.getMergedFunction(), GTTI(*Result.getMergedFunction())));
            }
          } else {
            ORE.emit([&] {
              return createMissedRemark("UnprofitableMerge", "", F1, F2)
                     << ore::NV("MergedSize", MergedSize)
                     << ore::NV("ThunkOverhead", Overhead)
                     << ore::NV("OriginalTotalSize", SizeF1F2);
            });
            Result.getMergedFunction()->eraseFromParent();
          }
        }
#ifdef TIME_STEPS_DEBUG
        TimeUpdate.stopTimer();
        time_update_end = std::chrono::steady_clock::now();
#endif
      } else {
        ORE.emit([&] {
          return createMissedRemark("CodeGen", "Null Merged Function", F1, F2);
        });
      }
#ifdef TIME_STEPS_DEBUG
      time_iteration_end = std::chrono::steady_clock::now();

      TimePrinting.startTimer();
#endif

      if (Verbose) {
        errs() << F1Name << " + " << F2Name << " <= " << Name
               << " Tries: " << MergingTrialsCount
               << " Valid: " << match.Valid
               << " BinSizes: " << match.OtherSize << " + " << match.Size << " <= " << match.MergedSize
               << " IRSizes: " << match.OtherMagnitude << " + " << match.Magnitude
               << " Profitable: " << match.Profitable
               << " Distance: " << match.Distance;
        errs() << " OtherDistance: " << OtherDistance;
#ifdef TIME_STEPS_DEBUG
      using namespace std::chrono_literals;
      errs() << " TotalTime: " << (time_iteration_end - time_ranking_start) / 1us
             << " RankingTime: " << (time_ranking_end - time_ranking_start) / 1us
             << " AlignTime: " << (time_align_end - time_align_start) / 1us
             << " CodegenTime: " << ((time_codegen_end - time_codegen_start) - (time_align_end - time_align_start)) / 1us
             << " VerifyTime: " << (time_verify_end - time_verify_start) / 1us
             << " UpdateTime: " << (time_update_end - time_update_start) / 1us;
#endif
        errs() << "\n";
      }


#ifdef TIME_STEPS_DEBUG
      TimePrinting.stopTimer();
#endif

      //if (match.Profitable || (MergingTrialsCount >= ExplorationThreshold))
      if (MergingTrialsCount >= ExplorationThreshold)
        break;
    }
  }

  double MergingAverageDistance = 0;
  unsigned MergingMaxDistance = 0;

  if (Debug || Verbose) {
    errs() << "Total operand reordering: " << TotalOpReorder << "/"
           << TotalBinOps << " ("
           << 100.0 * (((double)TotalOpReorder) / ((double)TotalBinOps))
           << " %)\n";

    //    errs() << "Total parameter score: " << TotalParamScore << "\n";

    //    errs() << "Total number of merges: " << MergingDistance.size() <<
    //    "\n";
    errs() << "Average number of trials before merging: "
           << MergingAverageDistance << "\n";
    errs() << "Maximum number of trials before merging: " << MergingMaxDistance
           << "\n";
  }

#ifdef TIME_STEPS_DEBUG
  TimeTotal.stopTimer();

  errs() << "Timer:Rank: " << TimeRank.getTotalTime().getWallTime() << "\n";
  TimeRank.clear();

  errs() << "Timer:CodeGen:Total: " << TimeCodeGenTotal.getTotalTime().getWallTime() << "\n";
  TimeCodeGenTotal.clear();

  errs() << "Timer:CodeGen:Align: " << TimeAlign.getTotalTime().getWallTime() << "\n";
  TimeAlign.clear();

  errs() << "Timer:CodeGen:Align:Rank: " << TimeAlignRank.getTotalTime().getWallTime() << "\n";
  TimeAlignRank.clear();

  errs() << "Timer:CodeGen:Param: " << TimeParam.getTotalTime().getWallTime() << "\n";
  TimeParam.clear();

  errs() << "Timer:CodeGen:Gen: " << TimeCodeGen.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen.clear();

  errs() << "Timer:CodeGen:Fix: " << TimeCodeGenFix.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGenFix.clear();

  errs() << "Timer:CodeGen:PostOpt: " << TimePostOpt.getTotalTime().getWallTime()
         << "\n";
  TimePostOpt.clear();

  errs() << "Timer:Verify: " << TimeVerify.getTotalTime().getWallTime() << "\n";
  TimeVerify.clear();

  errs() << "Timer:PreProcess: " << TimePreProcess.getTotalTime().getWallTime()
         << "\n";
  TimePreProcess.clear();

  errs() << "Timer:Lin: " << TimeLin.getTotalTime().getWallTime() << "\n";
  TimeLin.clear();

  errs() << "Timer:Update: " << TimeUpdate.getTotalTime().getWallTime() << "\n";
  TimeUpdate.clear();

  errs() << "Timer:Printing: " << TimePrinting.getTotalTime().getWallTime() << "\n";
  TimePrinting.clear();

  errs() << "Timer:Total: " << TimeTotal.getTotalTime().getWallTime() << "\n";
  TimeTotal.clear();
#endif

  return true;
}

class FunctionMergingLegacyPass : public ModulePass {
public:
  static char ID;
  FunctionMergingLegacyPass() : ModulePass(ID) {
#ifndef LLVM_NEXT_FM_STANDALONE
    initializeFunctionMergingLegacyPassPass(*PassRegistry::getPassRegistry());
#endif
  }
  bool runOnModule(Module &M) override {
    auto GTTI = [this](Function &F) -> TargetTransformInfo * {
      return &this->getAnalysis<TargetTransformInfoWrapperPass>().getTTI(F);
    };
    std::unique_ptr<OptimizationRemarkEmitter> ORE;
    std::function<OptimizationRemarkEmitter &(Function &)> GORE =
        [&ORE](Function &F) -> OptimizationRemarkEmitter & {
      ORE.reset(new OptimizationRemarkEmitter(&F));
      return *ORE.get();
    };
    FunctionMerging FM;
    return FM.runImpl(M, GTTI, GORE);
  }
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<TargetTransformInfoWrapperPass>();
    // ModulePass::getAnalysisUsage(AU);
  }
};

char FunctionMergingLegacyPass::ID = 0;
#ifdef LLVM_NEXT_FM_STANDALONE
static RegisterPass<FunctionMergingLegacyPass> X("func-merging", "New Function Merging",
                                                 false, false);
#else
INITIALIZE_PASS(FunctionMergingLegacyPass, "func-merging",
                "New Function Merging", false, false)

ModulePass *llvm::createFunctionMergingPass() {
  return new FunctionMergingLegacyPass();
}
#endif

PreservedAnalyses FunctionMergingPass::run(Module &M,
                                           ModuleAnalysisManager &AM) {
  auto &FAM = AM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
  std::function<TargetTransformInfo *(Function &)> GTTI =
      [&FAM](Function &F) -> TargetTransformInfo * {
    return &FAM.getResult<TargetIRAnalysis>(F);
  };
  auto GORE = [&](Function &F) -> OptimizationRemarkEmitter & {
    return FAM.getResult<OptimizationRemarkEmitterAnalysis>(F);
  };

  FunctionMerging FM;
  if (!FM.runImpl(M, GTTI, GORE))
    return PreservedAnalyses::all();
  return PreservedAnalyses::none();
}

static std::string GetValueName(const Value *V) {
  if (V) {
    std::string name;
    raw_string_ostream namestream(name);
    V->printAsOperand(namestream, false);
    return namestream.str();
  }
  return "[null]";
}

/// Create a cast instruction if needed to cast V to type DstType. We treat
/// pointer and integer types of the same bitwidth as equivalent, so this can be
/// used to cast them to each other where needed. The function returns the Value
/// itself if no cast is needed, or a new CastInst instance inserted before
/// InsertBefore. The integer type equivalent to pointers must be passed as
/// IntPtrType (get it from DataLayout). This is guaranteed to generate no-op
/// casts, otherwise it will assert.
// Value *FunctionMerger::createCastIfNeeded(Value *V, Type *DstType,
// IRBuilder<> &Builder, const FunctionMergingOptions &Options) {
Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
                          Type *IntPtrTy,
                          const FunctionMergingOptions &Options) {

  if (V->getType() == DstType || Options.IdenticalTypesOnly)
    return V;

  Value *Result;
  Type *OrigType = V->getType();

  if (OrigType->isStructTy()) {
    assert(DstType->isStructTy());
    assert(OrigType->getStructNumElements() == DstType->getStructNumElements());

    Result = UndefValue::get(DstType);
    for (unsigned int I = 0, E = OrigType->getStructNumElements(); I < E; ++I) {
      Value *ExtractedValue =
          Builder.CreateExtractValue(V, ArrayRef<unsigned int>(I));
      Value *Element =
          createCastIfNeeded(ExtractedValue, DstType->getStructElementType(I),
                             Builder, IntPtrTy, Options);
      Result =
          Builder.CreateInsertValue(Result, Element, ArrayRef<unsigned int>(I));
    }
    return Result;
  }
  assert(!DstType->isStructTy());

  if (OrigType->isPointerTy() &&
      (DstType->isIntegerTy() || DstType->isPointerTy())) {
    Result = Builder.CreatePointerCast(V, DstType, "merge_cast");
  } else if (OrigType->isIntegerTy() && DstType->isPointerTy() &&
             OrigType == IntPtrTy) {
    // Int -> Ptr
    Result = Builder.CreateCast(CastInst::IntToPtr, V, DstType, "merge_cast");
  } else {
    llvm_unreachable("Can only cast int -> ptr or ptr -> (ptr or int)");
  }

  // assert(cast<CastInst>(Result)->isNoopCast(InsertAtEnd->getParent()->getParent()->getDataLayout())
  // &&
  //    "Cast is not a no-op cast. Potential loss of precision");

  return Result;
}

template <typename BlockListType>
void FunctionMerger::CodeGenerator<BlockListType>::removeRedundantInstructions(
    std::vector<Instruction *> &WorkInst, DominatorTree &DT) {
  std::set<Instruction *> SkipList;

  std::map<Instruction *, std::list<Instruction *>> UpdateList;

  for (Instruction *I1 : WorkInst) {
    if (SkipList.find(I1) != SkipList.end())
      continue;
    for (Instruction *I2 : WorkInst) {
      if (I1 == I2)
        continue;
      if (SkipList.find(I2) != SkipList.end())
        continue;
      assert(I1->getNumOperands() == I2->getNumOperands() &&
             "Should have the same num of operands!");
      bool AllEqual = true;
      for (unsigned i = 0; i < I1->getNumOperands(); ++i) {
        AllEqual = AllEqual && (I1->getOperand(i) == I2->getOperand(i));
      }

      if (AllEqual && DT.dominates(I1, I2)) {
        UpdateList[I1].push_back(I2);
        SkipList.insert(I2);
        SkipList.insert(I1);
      }
    }
  }

  int count = 0;
  for (auto &kv : UpdateList) {
    for (auto *I : kv.second) {
      count++;
      erase(I);
      I->replaceAllUsesWith(kv.first);
      I->eraseFromParent();
    }
  }
}

