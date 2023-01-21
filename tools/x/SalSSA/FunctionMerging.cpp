//===- FunctionMerging.cpp - A function merging pass ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
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
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/IPO/FunctionMerging.h"

#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Verifier.h"
#include <llvm/IR/IRBuilder.h>

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

#include "llvm/Support/raw_os_ostream.h"

#include <cstdlib>
#include <fstream>

#include <algorithm>
#include <list>

#include <limits.h>

#include <functional>
#include <queue>
#include <vector>

#include <algorithm>
#include <stdlib.h>
#include <time.h>

#if defined(__unix__) || defined(__linux__)
/* __unix__ is usually defined by compilers targeting Unix systems */
#include <unistd.h>
#elif defined(_WIN32) || defined(WIN32)
/* _Win32 is usually defined by compilers targeting 32 or   64 bit Windows
 * systems */
#include <windows.h>
#endif

#define DEBUG_TYPE "MyFuncMerge"

//#define ENABLE_DEBUG_CODE

//#define FMSA_USE_JACCARD

#define TIME_STEPS_DEBUG

using namespace llvm;

static cl::opt<unsigned> ExplorationThreshold(
    "func-merging-explore", cl::init(1), cl::Hidden,
    cl::desc("Exploration threshold of evaluated functions"));

static cl::opt<unsigned>
    SAMethod("func-merging-sa-method", cl::init(0), cl::Hidden,
             cl::desc("(0) hirschberg; (1) needleman-wunsch;"));

static cl::opt<unsigned> RankingThreshold(
    "func-merging-ranking-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of how many candidates should be ranked"));

static cl::opt<int> MergingOverheadThreshold(
    "func-merging-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of allowed overhead for merging function"));

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

static cl::opt<bool> ApplySimilarityHeuristic(
    "func-merging-similarity-pruning", cl::init(true), cl::Hidden,
    cl::desc("Prune the candidates based on their fingerprint similarity"));

static cl::opt<bool>
    EnableUnifiedReturnType("func-merging-unify-return", cl::init(false),
                            cl::Hidden,
                            cl::desc("Enable unified return types"));

static cl::opt<bool>
    EnableOperandReordering("func-merging-operand-reorder", cl::init(true),
                            cl::Hidden, cl::desc("Enable operand reordering"));

static cl::opt<bool>
    HasWholeProgram("func-merging-whole-program", cl::init(false), cl::Hidden,
                    cl::desc("Function merging applied on whole program"));

static cl::opt<bool>
    EnableSALSSA("func-merging-salssa", cl::init(false), cl::Hidden,
                 cl::desc("Enable full support of the SSA form with SalSSA"));

static cl::opt<bool> EnableSALSSACoalescing(
    "func-merging-coalescing", cl::init(true), cl::Hidden,
    cl::desc("Enable phi-node coalescing during SSA reconstruction"));

static cl::opt<bool> ConservativeMode(
    "func-merging-conservative", cl::init(false), cl::Hidden,
    cl::desc("Enable conservative mode to avoid runtime overhead"));

static cl::opt<bool> MergeListNames(
    "func-merging-list-merges", cl::init(false), cl::Hidden,
    cl::desc("Run function merging using the list of function names"));

static cl::opt<bool> GenTrainingData("func-merging-gen-training",
                                     cl::init(false), cl::Hidden,
                                     cl::desc("Generate the training data"));

static cl::opt<bool> GenTestingData("func-merging-gen-testing", cl::init(false),
                                    cl::Hidden,
                                    cl::desc("Generate the testing data"));

static cl::opt<bool> RunPrediction("func-merging-predict", cl::init(false),
                                   cl::Hidden,
                                   cl::desc("Generate the testing data"));

static cl::opt<std::string> OptBenchName("func-merging-bench-name",
                                         cl::init(""), cl::Hidden,
                                         cl::desc("Generate the testing data"));

static cl::opt<unsigned>
    MaxNumSelection("func-merging-max-selects", cl::init(500), cl::Hidden,
                    cl::desc("Maximum number of allowed operand selection"));

//////////////////////////// Tests

static cl::opt<std::string> TestFM_DataPATH("func-merging-gen-prefix",
                                            cl::init(""), cl::Hidden,
                                            cl::desc(""));

static cl::opt<bool> TestFM_Oracle("fm-built-oracle", cl::init(false),
                                   cl::Hidden, cl::desc(""));

static cl::opt<bool> TestFM_CompilationCostModel("fm-built-size-cost",
                                                 cl::init(false), cl::Hidden,
                                                 cl::desc(""));

static cl::opt<std::string> TestFM_ClangPATH("fm-built-size-cost-cc",
                                             cl::init(""), cl::Hidden,
                                             cl::desc(""));

#define OPTIMIZE_SALSSA_CODEGEN
//#define DEBUG_OUTPUT_EACH_CHANGE

std::string TPrefix;
unsigned TestCount = 0;

//////////////////////////// Tests

#if defined(__unix__) || defined(__linux__)

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

static Value *GetAnyValue(Type *Ty) {
  switch (Ty->getTypeID()) {
  case Type::IntegerTyID:
  case Type::HalfTyID:
  case Type::FloatTyID:
  case Type::DoubleTyID:
  case Type::X86_FP80TyID:
  case Type::FP128TyID:
  case Type::PPC_FP128TyID:
  case Type::PointerTyID:
  case Type::StructTyID:
  case Type::ArrayTyID:
  case Type::VectorTyID:
  case Type::TokenTyID:
    return Constant::getNullValue(Ty);
  default:
    return UndefValue::get(Ty);
  }
}

static std::string GetValueName(const Value *V);

// TODO: make these two functions public from the original -mem2reg and -reg2mem
static void demoteRegToMem(Function &F);

static bool promoteMemoryToRegister(Function &F, DominatorTree &DT);

static void fixNotDominatedUses(Function *F, BasicBlock *Entry,
                                DominatorTree &DT);
// static void removeRedundantInstructions(std::vector<Instruction *> &WorkInst,
// DominatorTree &DT); Optional<size_t> MeasureSize(std::vector<Function*> &Fs,
// Module &M, bool Timeout);

FunctionMergeResult MergeFunctions(Function *F1, Function *F2,
                                   const FunctionMergingOptions &Options) {
  if (F1->getParent() != F2->getParent())
    return FunctionMergeResult(F1, F2, nullptr);
  FunctionMerger Merger(F1->getParent());
  return Merger.merge(F1, F2, "", Options);
}

static bool CmpNumbers(uint64_t L, uint64_t R) { return L == R; }

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
static bool CmpTypes(Type *TyL, Type *TyR, const DataLayout *DL) {
  PointerType *PTyL = dyn_cast<PointerType>(TyL);
  PointerType *PTyR = dyn_cast<PointerType>(TyR);

  // const DataLayout &DL = FnL->getParent()->getDataLayout();
  if (PTyL && PTyL->getAddressSpace() == 0)
    TyL = DL->getIntPtrType(TyL);
  if (PTyR && PTyR->getAddressSpace() == 0)
    TyR = DL->getIntPtrType(TyR);

  if (TyL == TyR)
    return 0;

  if (int Res = CmpNumbers(TyL->getTypeID(), TyR->getTypeID()))
    return Res;

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
    return 0;

  case Type::PointerTyID:
    assert(PTyL && PTyR && "Both types must be pointers here.");
    return CmpNumbers(PTyL->getAddressSpace(), PTyR->getAddressSpace());

  case Type::StructTyID: {
    StructType *STyL = cast<StructType>(TyL);
    StructType *STyR = cast<StructType>(TyR);
    if (STyL->getNumElements() != STyR->getNumElements())
      return CmpNumbers(STyL->getNumElements(), STyR->getNumElements());

    if (STyL->isPacked() != STyR->isPacked())
      return CmpNumbers(STyL->isPacked(), STyR->isPacked());

    for (unsigned i = 0, e = STyL->getNumElements(); i != e; ++i) {
      if (int Res =
              CmpTypes(STyL->getElementType(i), STyR->getElementType(i), DL))
        return Res;
    }
    return 0;
  }

  case Type::FunctionTyID: {
    FunctionType *FTyL = cast<FunctionType>(TyL);
    FunctionType *FTyR = cast<FunctionType>(TyR);
    if (FTyL->getNumParams() != FTyR->getNumParams())
      return CmpNumbers(FTyL->getNumParams(), FTyR->getNumParams());

    if (FTyL->isVarArg() != FTyR->isVarArg())
      return CmpNumbers(FTyL->isVarArg(), FTyR->isVarArg());

    if (int Res = CmpTypes(FTyL->getReturnType(), FTyR->getReturnType(), DL))
      return Res;

    for (unsigned i = 0, e = FTyL->getNumParams(); i != e; ++i) {
      if (int Res = CmpTypes(FTyL->getParamType(i), FTyR->getParamType(i), DL))
        return Res;
    }
    return 0;
  }

  case Type::ArrayTyID: {
    auto *STyL = cast<ArrayType>(TyL);
    auto *STyR = cast<ArrayType>(TyR);
    if (STyL->getNumElements() != STyR->getNumElements())
      return CmpNumbers(STyL->getNumElements(), STyR->getNumElements());
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL);
  }
  case Type::VectorTyID: {
    auto *STyL = cast<VectorType>(TyL);
    auto *STyR = cast<VectorType>(TyR);
    if (STyL->getElementCount().Scalable != STyR->getElementCount().Scalable)
      return CmpNumbers(STyL->getElementCount().Scalable,
                        STyR->getElementCount().Scalable);
    if (STyL->getElementCount().Min != STyR->getElementCount().Min)
      return CmpNumbers(STyL->getElementCount().Min,
                        STyR->getElementCount().Min);
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL);
  }
  }
}

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
bool FunctionMerger::areTypesEquivalent(Type *Ty1, Type *Ty2,
                                        const DataLayout *DL,
                                        const FunctionMergingOptions &Options) {
  if (Ty1 == Ty2)
    return true;
  if (Options.IdenticalTypesOnly)
    return false;

  return CmpTypes(Ty1, Ty2, DL);
}

static bool matchIntrinsicCalls(Intrinsic::ID ID, const CallInst *CI1,
                                const CallInst *CI2) {
  Intrinsic::ID ID1;
  Intrinsic::ID ID2;
  if (Function *F = CI1->getCalledFunction())
    ID1 = (Intrinsic::ID)F->getIntrinsicID();
  if (Function *F = CI2->getCalledFunction())
    ID2 = (Intrinsic::ID)F->getIntrinsicID();

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

    ConstantInt *ElementSizeCI1 =
        dyn_cast<ConstantInt>(AMI1->getRawElementSizeInBytes());

    ConstantInt *ElementSizeCI2 =
        dyn_cast<ConstantInt>(AMI2->getRawElementSizeInBytes());

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

bool matchLoadInsts(const LoadInst *LI1, const LoadInst *LI2) {
  return LI1->isVolatile() == LI2->isVolatile() &&
         LI1->getAlignment() == LI2->getAlignment() &&
         LI1->getOrdering() == LI2->getOrdering();
}

bool matchStoreInsts(const StoreInst *SI1, const StoreInst *SI2) {
  return SI1->isVolatile() == SI2->isVolatile() &&
         SI1->getAlignment() == SI2->getAlignment() &&
         SI1->getOrdering() == SI2->getOrdering();
}

bool matchAllocaInsts(const AllocaInst *AI1, const AllocaInst *AI2) {
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

  return true;
}

bool matchGetElementPtrInsts(const GetElementPtrInst *GEP1,
                             const GetElementPtrInst *GEP2) {
  SmallVector<Value *, 8> Indices1(GEP1->idx_begin(), GEP1->idx_end());
  SmallVector<Value *, 8> Indices2(GEP2->idx_begin(), GEP2->idx_end());
  if (Indices1.size() != Indices2.size())
    return false;

  if (GEP1->isInBounds() != GEP2->isInBounds())
    return false;

  // TODO: some indices must be constant depending on the type being indexed.
  // For simplicity, whenever a given index is constant, keep it constant.
  // This simplification may degrade the merging quality.
  for (unsigned i = 0; i < Indices1.size(); i++) {
    if ((isa<ConstantInt>(Indices1[i]) || isa<ConstantInt>(Indices2[i])) &&
        Indices1[i] != Indices2[i])
      return false; // if different constant values
  }

  Type *AggTy1 = GEP1->getSourceElementType();
  Type *AggTy2 = GEP2->getSourceElementType();

  // Assert(all_of(
  //  Idxs, [](Value* V) { return V->getType()->isIntOrIntVectorTy(); }),
  //  "GEP indexes must be integers", &GEP);
  SmallVector<Value *, 16> Idxs1(GEP1->idx_begin(), GEP1->idx_end());
  SmallVector<Value *, 16> Idxs2(GEP2->idx_begin(), GEP2->idx_end());
  if (Idxs1.size() != Idxs2.size())
    return false;
  // for (unsigned i = 0; i<Idxs1.size(); i++) {
  //  if (Idxs1[i]!=Idxs2[i]) return false;
  //}

  return true;
}

bool matchSwitchInsts(const SwitchInst *SI1, const SwitchInst *SI2) {
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

bool matchCallInsts(const CallInst *CI1, const CallInst *CI2) {
  if (CI1->isInlineAsm() || CI2->isInlineAsm())
    return false;
  if (CI1->getCalledFunction() != CI2->getCalledFunction())
    return false;
  if (Function *F = CI1->getCalledFunction()) {
    if (Intrinsic::ID ID = (Intrinsic::ID)F->getIntrinsicID()) {

      if (!matchIntrinsicCalls(ID, CI1, CI2))
        return false;
    }
  }

  return CI1->getCallingConv() ==
         CI2->getCallingConv(); // &&
                                // CI->getAttributes() ==
                                // cast<CallInst>(I2)->getAttributes();
}

bool matchInvokeInsts(const InvokeInst *II1, const InvokeInst *II2) {
  return II1->getCallingConv() == II2->getCallingConv() &&
         matchLandingPad(II1->getLandingPadInst(), II2->getLandingPadInst());
}

bool matchInsertValueInsts(const InsertValueInst *IV1,
                           const InsertValueInst *IV2) {
  return IV1->getIndices() == IV2->getIndices();
}

bool matchExtractValueInsts(const ExtractValueInst *EV1,
                            const ExtractValueInst *EV2) {
  return EV1->getIndices() == EV2->getIndices();
}

bool matchFenceInsts(const FenceInst *FI1, const FenceInst *FI2) {
  return FI1->getOrdering() == FI2->getOrdering() &&
         FI1->getSyncScopeID() == FI2->getSyncScopeID();
}

bool FunctionMerger::matchInstructions(Instruction *I1, Instruction *I2,
                                       const FunctionMergingOptions &Options) {

  if (I1->getOpcode() != I2->getOpcode())
    return false;

  // Returns are special cases that can differ in the number of operands
  if (I1->getOpcode() == Instruction::Ret)
    return true;

  if (I1->getNumOperands() != I2->getNumOperands())
    return false;

  const DataLayout *DL =
      &I1->getParent()->getParent()->getParent()->getDataLayout();

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

  // if (I1->hasNoUnsignedWrap()!=I2->hasNoUnsignedWrap()) return false;
  // if (I1->hasNoSignedWrap()!=I2->hasNoSignedWrap()) return false;

  switch (I1->getOpcode()) {
    // case Instruction::Br: return false; //{ return (I1->getNumOperands()==1);
    // }

    //#define MatchCaseInst(Kind, I1, I2) case Instruction::#Kind

  case Instruction::Load:
    return matchLoadInsts(dyn_cast<LoadInst>(I1), dyn_cast<LoadInst>(I2));
  case Instruction::Store:
    return matchStoreInsts(dyn_cast<StoreInst>(I1), dyn_cast<StoreInst>(I2));
  case Instruction::Alloca:
    return matchAllocaInsts(dyn_cast<AllocaInst>(I1), dyn_cast<AllocaInst>(I2));
  case Instruction::GetElementPtr:
    return matchGetElementPtrInsts(dyn_cast<GetElementPtrInst>(I1),
                                   dyn_cast<GetElementPtrInst>(I2));
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
    if (const CmpInst *CI = dyn_cast<CmpInst>(I1))
      return CI->getPredicate() == cast<CmpInst>(I2)->getPredicate();
  }

  return true;
}

bool FunctionMerger::match(Value *V1, Value *V2) {
  if (isa<Instruction>(V1) && isa<Instruction>(V2)) {
    return matchInstructions(dyn_cast<Instruction>(V1),
                             dyn_cast<Instruction>(V2));
  } else if (isa<BasicBlock>(V1) && isa<BasicBlock>(V2)) {
    BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
    BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);
    if (BB1->isLandingPad() || BB2->isLandingPad()) {
      LandingPadInst *LP1 = BB1->getLandingPadInst();
      LandingPadInst *LP2 = BB2->getLandingPadInst();
      if (LP1 == nullptr || LP2 == nullptr)
        return false;
      return matchLandingPad(LP1, LP2);
    } else
      return true;
  }
  return false;
}

bool FunctionMerger::matchWholeBlocks(Value *V1, Value *V2) {
  if (isa<BasicBlock>(V1) && isa<BasicBlock>(V2)) {
    BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
    BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);
    if (BB1->isLandingPad() || BB2->isLandingPad()) {
      LandingPadInst *LP1 = BB1->getLandingPadInst();
      LandingPadInst *LP2 = BB2->getLandingPadInst();
      if (LP1 == nullptr || LP2 == nullptr)
        return false;
      return matchLandingPad(LP1, LP2);
    }

    auto It1 = BB1->begin();
    auto It2 = BB2->begin();

    while (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1))
      It1++;
    while (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2))
      It2++;

    while (It1 != BB1->end() && It2 != BB2->end()) {
      Instruction *I1 = &*It1;
      Instruction *I2 = &*It2;

      if (!matchInstructions(I1, I2))
        return false;

      It1++;
      It2++;
    }

    if (It1 != BB1->end() || It2 != BB2->end())
      return false;

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
  std::random_shuffle(NextBBs.begin(), NextBBs.end());

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

/*
void FunctionMerger::alignLinearizedCFGs(SmallVectorImpl<Value *> &F1Vec,
                    SmallVectorImpl<Value *> &F2Vec,
                    std::list<std::pair<Value *, Value *>> &AlignedInstsList) {

  ScoringSystem Scoring;
  Scoring.setMatchProfit(1)
         .setAllowMismatch(false)
         .setGapStartPenalty(-3)
         .setGapExtendPenalty(0)
         .setPenalizeStartingGap(true)
         .setPenalizeEndingGap(false);

  SequenceAligner<Value*>
SA(F1Vec,F2Vec,FunctionMerger::match,(Value*)nullptr,Scoring); AlignedInstsList
= SA.Result.Data;
}
*/

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

struct SelectCacheEntry {
public:
  Value *Cond;
  Value *ValTrue;
  Value *ValFalse;
  BasicBlock *Block;

  SelectCacheEntry(Value *C, Value *V1, Value *V2, BasicBlock *BB)
      : Cond(C), ValTrue(V1), ValFalse(V2), Block(BB) {}

  bool operator<(const SelectCacheEntry &Other) const {
    if (Cond != Other.Cond)
      return Cond < Other.Cond;
    if (ValTrue != Other.ValTrue)
      return ValTrue < Other.ValTrue;
    if (ValFalse != Other.ValFalse)
      return ValFalse < Other.ValFalse;
    if (Block != Other.Block)
      return Block < Other.Block;
    return false;
  }
};

#ifdef TIME_STEPS_DEBUG
Timer TimeLin("Merge::Lin", "Merge::Lin");
Timer TimeAlign("Merge::Align", "Merge::Align");
Timer TimeParam("Merge::Param", "Merge::Param");
Timer TimeCodeGen("Merge::CodeGen", "Merge::CodeGen");
Timer TimeSimplify("Merge::Simplify", "Merge::Simplify");

Timer TimePredictionGains("FM::PredictionGains", "FM::PredictionGains");
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

  // if (F1->hasComdat()!=F2->hasComdat()) return false;
  // if (F1->hasComdat() && F1->getComdat() != F2->getComdat()) return false;

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

  std::vector<Argument *> ArgsList1;
  for (Argument &arg : F1->args()) {
    ArgsList1.push_back(&arg);
  }

  Args.push_back(IntegerType::get(Context, 1)); // push the function Id argument
  unsigned ArgId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    ParamMap1[ArgId] = Args.size();
    Args.push_back((*I).getType());
    ArgId++;
  }

  // merge arguments from Function2 with Function1
  ArgId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {

    std::map<unsigned, int> MatchingScore;
    // first try to find an argument with the same name/type
    // otherwise try to match by type only
    for (unsigned i = 0; i < ArgsList1.size(); i++) {
      if (ArgsList1[i]->getType() == (*I).getType()) {
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
    }

    if (MatchingScore.size() > 0) { // maximize scores
      for (auto &Entry : AlignedSeq) {
        if (Entry.match()) {
          auto *I1 = dyn_cast<Instruction>(Entry.get(0));
          auto *I2 = dyn_cast<Instruction>(Entry.get(1));
          if (I1 != nullptr && I2 != nullptr) { // test both for sanity
            for (unsigned i = 0; i < I1->getNumOperands(); i++) {
              for (auto KV : MatchingScore) {
                if (I1->getOperand(i) == ArgsList1[KV.first]) {
                  if (i < I2->getNumOperands() && I2->getOperand(i) == &(*I)) {
                    MatchingScore[KV.first]++;
                  }
                }
              }
            }
          }
        }
      }

      int MaxScore = -1;
      int MaxId = 0;

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
  MergedFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

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

Function *RemoveFuncIdArg(Function *F, std::vector<Argument *> &ArgsList) {

  // Start by computing a new prototype for the function, which is the same as
  // the old function, but doesn't have isVarArg set.
  FunctionType *FTy = F->getFunctionType();

  std::vector<Type *> NewArgs;
  for (unsigned i = 1; i < ArgsList.size(); i++) {
    NewArgs.push_back(ArgsList[i]->getType());
  }
  ArrayRef<llvm::Type *> Params(NewArgs);

  // std::vector<Type *> Params(FTy->param_begin(), FTy->param_end());
  FunctionType *NFTy = FunctionType::get(FTy->getReturnType(), Params, false);
  // unsigned NumArgs = Params.size();

  // Create the new function body and insert it into the module...
  Function *NF = Function::Create(NFTy, F->getLinkage());

  NF->copyAttributesFrom(F);

  if (F->getAlignment())
    NF->setAlignment(Align(F->getAlignment()));
  NF->setCallingConv(F->getCallingConv());
  // NF->setLinkage(F->getLinkage());
  NF->setDSOLocal(F->isDSOLocal());
  NF->setSubprogram(F->getSubprogram());
  NF->setUnnamedAddr(F->getUnnamedAddr());
  NF->setVisibility(F->getVisibility());
  // Exception Handling requires landing pads to have the same personality
  // function
  if (F->hasPersonalityFn())
    NF->setPersonalityFn(F->getPersonalityFn());
  if (F->hasComdat())
    NF->setComdat(F->getComdat());
  if (F->hasSection())
    NF->setSection(F->getSection());

  F->getParent()->getFunctionList().insert(F->getIterator(), NF);
  NF->takeName(F);

  // Since we have now created the new function, splice the body of the old
  // function right into the new function, leaving the old rotting hulk of the
  // function empty.
  NF->getBasicBlockList().splice(NF->begin(), F->getBasicBlockList());

  std::vector<Argument *> NewArgsList;
  for (Argument &arg : NF->args()) {
    NewArgsList.push_back(&arg);
  }

  // Loop over the argument list, transferring uses of the old arguments over to
  // the new arguments, also transferring over the names as well.  While we're
  // at it, remove the dead arguments from the DeadArguments list.
  /*
  for (Function::arg_iterator I = F->arg_begin(), E = F->arg_end(),
       I2 = NF->arg_begin(); I != E; ++I, ++I2) {
    // Move the name and users over to the new version.
    I->replaceAllUsesWith(&*I2);
    I2->takeName(&*I);
  }
  */

  for (unsigned i = 0; i < NewArgsList.size(); i++) {
    ArgsList[i + 1]->replaceAllUsesWith(NewArgsList[i]);
    NewArgsList[i]->takeName(ArgsList[i + 1]);
  }

  // Clone metadatas from the old function, including debug info descriptor.
  SmallVector<std::pair<unsigned, MDNode *>, 1> MDs;
  F->getAllMetadata(MDs);
  for (auto MD : MDs)
    NF->addMetadata(MD.first, *MD.second);

  // Fix up any BlockAddresses that refer to the function.
  F->replaceAllUsesWith(ConstantExpr::getBitCast(NF, F->getType()));
  // Delete the bitcast that we just created, so that NF does not
  // appear to be address-taken.
  NF->removeDeadConstantUsers();
  // Finally, nuke the old function.
  F->eraseFromParent();
  return NF;
}

static Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
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

template <typename BlockListType>
bool FunctionMerger::FMSACodeGen<BlockListType>::generate(
    AlignedSequence<Value *> &AlignedSeq, ValueToValueMapTy &VMap,
    const FunctionMergingOptions &Options) {

  LLVMContext &Context = CodeGenerator<BlockListType>::getContext();
  Function *MergedFunc = CodeGenerator<BlockListType>::getMergedFunction();
  Value *IsFunc1 = CodeGenerator<BlockListType>::getFunctionIdentifier();
  Type *ReturnType = CodeGenerator<BlockListType>::getMergedReturnType();
  bool RequiresUnifiedReturn =
      CodeGenerator<BlockListType>::getRequiresUnifiedReturn();
  BasicBlock *EntryBB1 = CodeGenerator<BlockListType>::getEntryBlock1();
  BasicBlock *EntryBB2 = CodeGenerator<BlockListType>::getEntryBlock2();
  BasicBlock *PreBB = CodeGenerator<BlockListType>::getPreBlock();

  Type *RetType1 = CodeGenerator<BlockListType>::getReturnType1();
  Type *RetType2 = CodeGenerator<BlockListType>::getReturnType2();

  Type *IntPtrTy = CodeGenerator<BlockListType>::getIntPtrType();

  std::vector<Instruction *> ListSelects;

  Value *RetUnifiedAddr = nullptr;
  Value *RetAddr1 = nullptr;
  Value *RetAddr2 = nullptr;

  BasicBlock *MergedBB = nullptr;
  BasicBlock *MergedBB1 = nullptr;
  BasicBlock *MergedBB2 = nullptr;

  std::map<BasicBlock *, BasicBlock *> TailBBs;

  std::map<SelectCacheEntry, Value *> SelectCache;
  std::map<std::pair<BasicBlock *, BasicBlock *>, BasicBlock *> CacheBBSelect;

  std::set<BasicBlock *> OriginalBlocks;
  std::set<PHINode *> PHINodes;
  for (auto &Entry : AlignedSeq) {
    if (Entry.match()) {

      if (isa<BasicBlock>(Entry.get(0))) {
        BasicBlock *NewBB = BasicBlock::Create(Context, "", MergedFunc);
        CodeGenerator<BlockListType>::insert(NewBB);

        BasicBlock *BB1 = dyn_cast<BasicBlock>(Entry.get(0));
        BasicBlock *BB2 = dyn_cast<BasicBlock>(Entry.get(1));
        VMap[BB1] = NewBB;
        VMap[BB2] = NewBB;
        OriginalBlocks.insert(NewBB);

        IRBuilder<> Builder(NewBB);
        if (BB1->isLandingPad() || BB2->isLandingPad()) {
          LandingPadInst *LP1 = BB1->getLandingPadInst();
          LandingPadInst *LP2 = BB2->getLandingPadInst();
          assert((LP1 != nullptr && LP2 != nullptr) &&
                 "Should be both as per the BasicBlock match!");
          Instruction *NewLP = LP1->clone();
          CodeGenerator<BlockListType>::insert(NewLP);
          VMap[LP1] = NewLP;
          VMap[LP2] = NewLP;

          Builder.Insert(NewLP);
        }
      }
    } else {
      Value *V = Entry.getNonBlank();

      if (isa<BasicBlock>(V)) {
        BasicBlock *BB = dyn_cast<BasicBlock>(V);

        BasicBlock *NewBB = BasicBlock::Create(Context, "", MergedFunc);
        CodeGenerator<BlockListType>::insert(NewBB);
        OriginalBlocks.insert(NewBB);

        VMap[BB] = NewBB;
        TailBBs[dyn_cast<BasicBlock>(V)] = NewBB;

        // errs() << "Here 2!\n";
        IRBuilder<> Builder(NewBB);

        if (BB->isLandingPad()) {
          LandingPadInst *LP = BB->getLandingPadInst();
          Instruction *NewLP = LP->clone();
          CodeGenerator<BlockListType>::insert(NewLP);
          VMap[LP] = NewLP;

          Builder.Insert(NewLP);
        }
      }
    }
  }

  if (RequiresUnifiedReturn) {
    IRBuilder<> Builder(PreBB);
    RetUnifiedAddr = Builder.CreateAlloca(ReturnType);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetUnifiedAddr));

    RetAddr1 = Builder.CreateAlloca(RetType1);
    RetAddr2 = Builder.CreateAlloca(RetType2);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr1));
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr2));
  }

  if (VMap[EntryBB1] != VMap[EntryBB2]) {
    IRBuilder<> Builder(PreBB);
    Instruction *Br =
        Builder.CreateCondBr(IsFunc1, dyn_cast<BasicBlock>(VMap[EntryBB1]),
                             dyn_cast<BasicBlock>(VMap[EntryBB2]));
    CodeGenerator<BlockListType>::insert(Br);
  } else {
    BasicBlock *NewEntryBB = dyn_cast<BasicBlock>(VMap[EntryBB1]);
    if (NewEntryBB->size() == 0) {
      VMap[EntryBB1] = PreBB;
      VMap[EntryBB2] = PreBB;
      CodeGenerator<BlockListType>::erase(NewEntryBB);
      NewEntryBB->eraseFromParent();
    } else {
      IRBuilder<> Builder(PreBB);
      Instruction *Br = Builder.CreateBr(NewEntryBB);
      CodeGenerator<BlockListType>::insert(Br);
    }
  }

  for (auto &Entry : AlignedSeq) {
    // mergeable instructions
    if (Entry.match()) {

      if (isa<BasicBlock>(Entry.get(0))) {
        BasicBlock *NewBB =
            dyn_cast<BasicBlock>(VMap[dyn_cast<BasicBlock>(Entry.get(0))]);

        MergedBB = NewBB;
        MergedBB1 = dyn_cast<BasicBlock>(Entry.get(0));
        MergedBB2 = dyn_cast<BasicBlock>(Entry.get(1));

      } else {
        assert(isa<Instruction>(Entry.get(0)) && "Instruction expected!");
        Instruction *I1 = dyn_cast<Instruction>(Entry.get(0));
        Instruction *I2 = dyn_cast<Instruction>(Entry.get(1));

        if (MergedBB == nullptr) {
          MergedBB = BasicBlock::Create(Context, "", MergedFunc);
          CodeGenerator<BlockListType>::insert(MergedBB);
          {
            IRBuilder<> Builder(TailBBs[dyn_cast<BasicBlock>(I1->getParent())]);
            Instruction *Br = Builder.CreateBr(MergedBB);
            CodeGenerator<BlockListType>::insert(Br);
          }
          {
            IRBuilder<> Builder(TailBBs[dyn_cast<BasicBlock>(I2->getParent())]);
            Instruction *Br = Builder.CreateBr(MergedBB);
            CodeGenerator<BlockListType>::insert(Br);
          }
        }
        MergedBB1 = dyn_cast<BasicBlock>(I1->getParent());
        MergedBB2 = dyn_cast<BasicBlock>(I2->getParent());

        Instruction *NewI = nullptr;

        Instruction *I = I1;

        IRBuilder<> Builder(MergedBB);
        if (I1->getOpcode() == Instruction::Ret) {
          if (RequiresUnifiedReturn) {
            NewI = Builder.CreateRet(GetAnyValue(ReturnType));
          } else {
            if (I1->getNumOperands() >= I2->getNumOperands())
              I = I1;
            else
              I = I2;
            NewI = I->clone();
            Builder.Insert(NewI);
          }
        } else {
          assert(I1->getNumOperands() == I2->getNumOperands() &&
                 "Num of Operands SHOULD be EQUAL\n");
          NewI = I->clone();
          Builder.Insert(NewI);
        }

        CodeGenerator<BlockListType>::insert(NewI);

        VMap[I1] = NewI;
        VMap[I2] = NewI;

        // TODO: temporary removal of metadata

        SmallVector<std::pair<unsigned, MDNode *>, 8> MDs;
        NewI->getAllMetadata(MDs);
        for (std::pair<unsigned, MDNode *> MDPair : MDs) {
          NewI->setMetadata(MDPair.first, nullptr);
        }

        if (NewI->isTerminator()) {
          MergedBB = nullptr;
          MergedBB1 = nullptr;
          MergedBB2 = nullptr;
        }
      }
    } else {
      if (MergedBB != nullptr) {

        BasicBlock *NewBB1 = BasicBlock::Create(Context, "", MergedFunc);
        BasicBlock *NewBB2 = BasicBlock::Create(Context, "", MergedFunc);
        CodeGenerator<BlockListType>::insert(NewBB1);
        CodeGenerator<BlockListType>::insert(NewBB2);

        TailBBs[MergedBB1] = NewBB1;
        TailBBs[MergedBB2] = NewBB2;

        IRBuilder<> Builder(MergedBB);
        Instruction *Br = Builder.CreateCondBr(IsFunc1, NewBB1, NewBB2);
        CodeGenerator<BlockListType>::insert(Br);

        MergedBB = nullptr;
      }

      Value *V = Entry.getNonBlank();

      if (isa<BasicBlock>(V)) {
        BasicBlock *NewBB = dyn_cast<BasicBlock>(VMap[dyn_cast<BasicBlock>(V)]);
        TailBBs[dyn_cast<BasicBlock>(V)] = NewBB;
      } else {
        assert(isa<Instruction>(V) && "Instruction expected!");
        Instruction *I = dyn_cast<Instruction>(V);

        Instruction *NewI = nullptr;
        if (I->getOpcode() == Instruction::Ret && !ReturnType->isVoidTy() &&
            I->getNumOperands() == 0) {
          NewI = ReturnInst::Create(Context, GetAnyValue(ReturnType));
        } else
          NewI = I->clone();

        CodeGenerator<BlockListType>::insert(NewI);
        VMap[I] = NewI;

        BasicBlock *BBPoint = TailBBs[dyn_cast<BasicBlock>(I->getParent())];
        if (BBPoint == nullptr) {
          BBPoint = TailBBs[dyn_cast<BasicBlock>(I->getParent())] =
              dyn_cast<BasicBlock>(VMap[dyn_cast<BasicBlock>(I->getParent())]);
        }

        IRBuilder<> Builder(BBPoint);
        Builder.Insert(NewI);

        // TODO: temporarily removing metadata

        SmallVector<std::pair<unsigned, MDNode *>, 8> MDs;
        NewI->getAllMetadata(MDs);
        for (std::pair<unsigned, MDNode *> MDPair : MDs) {
          NewI->setMetadata(MDPair.first, nullptr);
        }
      }
    }
  }

  for (auto &Entry : AlignedSeq) {
    // mergable instructions
    if (Entry.match()) {

      if (isa<Instruction>(Entry.get(0))) {
        Instruction *I1 = dyn_cast<Instruction>(Entry.get(0));
        Instruction *I2 = dyn_cast<Instruction>(Entry.get(1));

        Instruction *I = I1;
        if (I1->getOpcode() == Instruction::Ret) {
          if (I1->getNumOperands() >= I2->getNumOperands())
            I = I1;
          else
            I = I2;
        } else {
          assert(I1->getNumOperands() == I2->getNumOperands() &&
                 "Num of Operands SHOULD be EQUAL\n");
        }

        Instruction *NewI = dyn_cast<Instruction>(VMap[I]);

        IRBuilder<> Builder(NewI);

        if (isa<BinaryOperator>(NewI) && I->isCommutative()) {
          // CountBinOps++;

          BinaryOperator *BO1 = dyn_cast<BinaryOperator>(I1);
          BinaryOperator *BO2 = dyn_cast<BinaryOperator>(I2);
          Value *VL1 = MapValue(BO1->getOperand(0), VMap);
          Value *VL2 = MapValue(BO2->getOperand(0), VMap);
          Value *VR1 = MapValue(BO1->getOperand(1), VMap);
          Value *VR2 = MapValue(BO2->getOperand(1), VMap);
          if (VL1 == VR2 && VL2 != VR2) {
            Value *TmpV = VR2;
            VR2 = VL2;
            VL2 = TmpV;
            // CountOpReorder++;
          }

          std::vector<std::pair<Value *, Value *>> Vs;
          Vs.push_back(std::pair<Value *, Value *>(VL1, VL2));
          Vs.push_back(std::pair<Value *, Value *>(VR1, VR2));

          for (unsigned i = 0; i < Vs.size(); i++) {
            Value *V1 = Vs[i].first;
            Value *V2 = Vs[i].second;

            Value *V = V1; // first assume that V1==V2
            if (V1 != V2) {
              // create predicated select instruction
              if (V1 == ConstantInt::getTrue(Context) &&
                  V2 == ConstantInt::getFalse(Context)) {
                V = IsFunc1;
              } else if (V1 == ConstantInt::getFalse(Context) &&
                         V2 == ConstantInt::getTrue(Context)) {
                V = Builder.CreateNot(IsFunc1);
                CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(V));
              } else {
                Value *SelectI = nullptr;

                SelectCacheEntry SCE(IsFunc1, V1, V2, NewI->getParent());
                if (SelectCache.find(SCE) != SelectCache.end()) {
                  SelectI = SelectCache[SCE];
                } else {
                  Value *CastedV2 = createCastIfNeeded(
                      V2, V1->getType(), Builder, IntPtrTy, Options);
                  SelectI = Builder.CreateSelect(IsFunc1, V1, CastedV2);
                  CodeGenerator<BlockListType>::insert(
                      dyn_cast<Instruction>(SelectI));

                  ListSelects.push_back(dyn_cast<Instruction>(SelectI));

                  SelectCache[SCE] = SelectI;
                }

                V = SelectI;
              }
            }

            // TODO: cache the created instructions
            Value *CastedV = createCastIfNeeded(
                V, NewI->getOperand(i)->getType(), Builder, IntPtrTy, Options);
            NewI->setOperand(i, CastedV);
          }
        } else if (I->getOpcode() == Instruction::Ret &&
                   RequiresUnifiedReturn) {
          Value *V1 = MapValue(I1->getOperand(0), VMap);
          Value *V2 = MapValue(I2->getOperand(0), VMap);

          if (V1->getType() != ReturnType) {
            Instruction *SI = Builder.CreateStore(V1, RetAddr1);
            CodeGenerator<BlockListType>::insert(SI);
            Value *CastedAddr =
                Builder.CreatePointerCast(RetAddr1, RetUnifiedAddr->getType());
            CodeGenerator<BlockListType>::insert(
                dyn_cast<Instruction>(CastedAddr));
            Instruction *LI = Builder.CreateLoad(ReturnType, CastedAddr);
            CodeGenerator<BlockListType>::insert(LI);
            V1 = LI;
          }
          if (V2->getType() != ReturnType) {
            Instruction *SI = Builder.CreateStore(V2, RetAddr2);
            CodeGenerator<BlockListType>::insert(SI);
            Value *CastedAddr =
                Builder.CreatePointerCast(RetAddr2, RetUnifiedAddr->getType());
            CodeGenerator<BlockListType>::insert(
                dyn_cast<Instruction>(CastedAddr));
            Instruction *LI = Builder.CreateLoad(ReturnType, CastedAddr);
            CodeGenerator<BlockListType>::insert(LI);
            V2 = LI;
          }

          Value *SelV = Builder.CreateSelect(IsFunc1, V1, V2);
          if (isa<Instruction>(SelV)) {
            CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(SelV));
            ListSelects.push_back(dyn_cast<Instruction>(SelV));
          }

          NewI->setOperand(0, SelV);
        } else {
          for (unsigned i = 0; i < I->getNumOperands(); i++) {
            Value *F1V = nullptr;
            Value *V1 = nullptr;
            if (i < I1->getNumOperands()) {
              F1V = I1->getOperand(i);
              V1 = MapValue(I1->getOperand(i), VMap);
              assert(V1 != nullptr && "Mapped value should NOT be NULL!");
              /*
              if (V1 == nullptr) {
                errs() << "ERROR: Null value mapped: V1 = "
                          "MapValue(I1->getOperand(i), "
                          "VMap);\n";
                MergedFunc->eraseFromParent();
                return ErrorResponse;
              }
              */
            } else
              V1 = GetAnyValue(I2->getOperand(i)->getType());

            Value *F2V = nullptr;
            Value *V2 = nullptr;
            if (i < I2->getNumOperands()) {
              F2V = I2->getOperand(i);
              V2 = MapValue(I2->getOperand(i), VMap);
              assert(V2 != nullptr && "Mapped value should NOT be NULL!");
              /*
              if (V2 == nullptr) {
                errs() << "ERROR: Null value mapped: V2 = "
                          "MapValue(I2->getOperand(i), "
                          "VMap);\n";
                MergedFunc->eraseFromParent();
                return ErrorResponse;
              }
              */
            } else
              V2 = GetAnyValue(I1->getOperand(i)->getType());

            assert(V1 != nullptr && "Value should NOT be null!");
            assert(V2 != nullptr && "Value should NOT be null!");

            Value *V = V1; // first assume that V1==V2

            if (V1 != V2) {
              // TODO: Create BasicBlock Select function
              if (isa<BasicBlock>(V1) && isa<BasicBlock>(V2)) {
                auto CacheKey = std::pair<BasicBlock *, BasicBlock *>(
                    dyn_cast<BasicBlock>(V1), dyn_cast<BasicBlock>(V2));
                BasicBlock *SelectBB = nullptr;
                if (CacheBBSelect.find(CacheKey) != CacheBBSelect.end()) {
                  SelectBB = CacheBBSelect[CacheKey];
                } else {
                  SelectBB = BasicBlock::Create(Context, "", MergedFunc);
                  IRBuilder<> BuilderBB(SelectBB);

                  CodeGenerator<BlockListType>::insert(SelectBB);

                  BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
                  BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);

                  if (BB1->isLandingPad() || BB2->isLandingPad()) {
                    LandingPadInst *LP1 = BB1->getLandingPadInst();
                    LandingPadInst *LP2 = BB2->getLandingPadInst();
                    assert((LP1 != nullptr && LP2 != nullptr) &&
                           "Should be both as per the BasicBlock match!");

                    Instruction *NewLP = LP1->clone();
                    BuilderBB.Insert(NewLP);

                    CodeGenerator<BlockListType>::insert(NewLP);

                    BasicBlock *F1BB = dyn_cast<BasicBlock>(F1V);
                    BasicBlock *F2BB = dyn_cast<BasicBlock>(F2V);

                    VMap[F1BB] = SelectBB;
                    VMap[F2BB] = SelectBB;
                    if (TailBBs[F1BB] == nullptr)
                      TailBBs[F1BB] = BB1;
                    if (TailBBs[F2BB] == nullptr)
                      TailBBs[F2BB] = BB2;
                    VMap[F1BB->getLandingPadInst()] = NewLP;
                    VMap[F2BB->getLandingPadInst()] = NewLP;

                    BB1->replaceAllUsesWith(SelectBB);
                    BB2->replaceAllUsesWith(SelectBB);

                    // remove landingpad instructions from
                    LP1->replaceAllUsesWith(NewLP);
                    CodeGenerator<BlockListType>::erase(LP1);
                    LP1->eraseFromParent();
                    LP2->replaceAllUsesWith(NewLP);
                    CodeGenerator<BlockListType>::erase(LP2);
                    LP2->eraseFromParent();
                  }

                  Instruction *Br = BuilderBB.CreateCondBr(IsFunc1, BB1, BB2);
                  CodeGenerator<BlockListType>::insert(Br);
                  CacheBBSelect[CacheKey] = SelectBB;
                }
                V = SelectBB;
              } else {

                // TODO: Create Value Select function
                // create predicated select instruction
                if (V1 == ConstantInt::getTrue(Context) &&
                    V2 == ConstantInt::getFalse(Context)) {
                  V = IsFunc1;
                } else if (V1 == ConstantInt::getFalse(Context) &&
                           V2 == ConstantInt::getTrue(Context)) {
                  V = Builder.CreateNot(IsFunc1);
                  CodeGenerator<BlockListType>::insert(
                      dyn_cast<Instruction>(V));
                } else {
                  Value *SelectI = nullptr;

                  SelectCacheEntry SCE(IsFunc1, V1, V2, NewI->getParent());
                  if (SelectCache.find(SCE) != SelectCache.end()) {
                    SelectI = SelectCache[SCE];
                  } else {
                    // TODO: cache created instructions
                    Value *CastedV2 = createCastIfNeeded(
                        V2, V1->getType(), Builder, IntPtrTy, Options);
                    SelectI = Builder.CreateSelect(IsFunc1, V1, CastedV2);
                    CodeGenerator<BlockListType>::insert(
                        dyn_cast<Instruction>(SelectI));
                    if (isa<Instruction>(SelectI))
                      ListSelects.push_back(dyn_cast<Instruction>(SelectI));

                    SelectCache[SCE] = SelectI;
                  }

                  V = SelectI;
                }
              }
            }

            Value *CastedV = V;
            if (!isa<BasicBlock>(V)) {
              // TODO: cache the created instructions
              CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(),
                                           Builder, IntPtrTy, Options);
            }
            NewI->setOperand(i, CastedV);
          }
        } // end of commutative if-else
      }

    } else {
      bool isFuncId1 = true;
      Value *V = nullptr;
      if (Entry.get(0)) {
        isFuncId1 = true;
        V = Entry.get(0);
      } else {
        isFuncId1 = false;
        V = Entry.get(1);
      }

      if (isa<Instruction>(V)) {
        Instruction *I = dyn_cast<Instruction>(V);

        Instruction *NewI = dyn_cast<Instruction>(VMap[I]);

        IRBuilder<> Builder(NewI);

        if (I->getOpcode() == Instruction::Ret && RequiresUnifiedReturn) {
          Value *V = MapValue(I->getOperand(0), VMap);

          if (V->getType() != ReturnType) {
            Value *Addr = (isFuncId1 ? RetAddr1 : RetAddr2);
            Instruction *SI = Builder.CreateStore(V, Addr);

            CodeGenerator<BlockListType>::insert(SI);

            Value *CastedAddr =
                Builder.CreatePointerCast(Addr, RetUnifiedAddr->getType());
            CodeGenerator<BlockListType>::insert(
                dyn_cast<Instruction>(CastedAddr));

            Instruction *LI = Builder.CreateLoad(ReturnType, CastedAddr);
            CodeGenerator<BlockListType>::insert(LI);

            V = LI;
          }

          NewI->setOperand(0, V);
        } else {
          for (unsigned i = 0; i < I->getNumOperands(); i++) {
            Value *V = MapValue(I->getOperand(i), VMap);
            assert(V != nullptr && "Mapped value should NOT be NULL!");
            /*
            if (V == nullptr) {
              errs() << "ERROR: Null value mapped: V = "
                        "MapValue(I->getOperand(i), VMap);\n";
              MergedFunc->eraseFromParent();
              return ErrorResponse;
            }
            */
            Value *CastedV = V;
            if (!isa<BasicBlock>(V))
              CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(),
                                           Builder, IntPtrTy, Options);
            NewI->setOperand(i, CastedV);
          }
        }
      }
    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif

#ifdef TIME_STEPS_DEBUG
  TimeSimplify.startTimer();
#endif
  DominatorTree DT(*MergedFunc);
  CodeGenerator<BlockListType>::removeRedundantInstructions(ListSelects, DT);

  fixNotDominatedUses(MergedFunc, PreBB, DT);

#ifdef TIME_STEPS_DEBUG
  TimeSimplify.stopTimer();
#endif

  return true;
}

static void simplifySelects(Function *F) {
  std::set<SelectInst *> AllSelects;

  for (Instruction &I : instructions(F)) {
    if (isa<SelectInst>(&I)) {
      AllSelects.insert(dyn_cast<SelectInst>(&I));
    }
  }

  for (SelectInst *SI : AllSelects) {
    if (isa<AllocaInst>(SI->getTrueValue()) &&
        isa<AllocaInst>(SI->getFalseValue())) {
      Instruction *TrueI = dyn_cast<Instruction>(SI->getTrueValue());
      Instruction *FalseI = dyn_cast<Instruction>(SI->getFalseValue());
      if (TrueI->getNumUses() == 1 && FalseI->getNumUses() == 1) {
        SI->replaceAllUsesWith(TrueI);
        SI->dropAllReferences();
        SI->eraseFromParent();
        FalseI->eraseFromParent();
      }
    }
  }
}

FunctionMergeResult
FunctionMerger::merge(Function *F1, Function *F2, std::string Name,
                      const FunctionMergingOptions &Options) {
  LLVMContext &Context = *ContextPtr;
  FunctionMergeResult ErrorResponse(F1, F2, nullptr);

  if (!validMergePair(F1, F2))
    return ErrorResponse;

  SmallVector<Value *, 8> F1Vec;
  SmallVector<Value *, 8> F2Vec;

#ifdef TIME_STEPS_DEBUG
  TimeLin.startTimer();
#endif

  // errs() << "Here Lin 1\n";
  if (ConservativeMode) {
    std::list<BasicBlock *> OrderedBBs;
    CanonicalLinearizationOfBlocks(F1, OrderedBBs);
    for (BasicBlock *BB : OrderedBBs)
      F1Vec.push_back(BB);

    OrderedBBs.clear();
    CanonicalLinearizationOfBlocks(F2, OrderedBBs);
    for (BasicBlock *BB : OrderedBBs)
      F2Vec.push_back(BB);
  } else {
    linearize(F1, F1Vec);
    linearize(F2, F2Vec);
  }
  // errs() << "Here Lin 2\n";

#ifndef __APPLE__
  size_t MemoryRequirement =
      F1Vec.size() * F2Vec.size() * sizeof(ScoreSystemType);
  if (MemoryRequirement > getTotalSystemMemory() * 0.9)
    return ErrorResponse;
#endif

#ifdef TIME_STEPS_DEBUG
  TimeLin.stopTimer();
#endif

#ifdef TIME_STEPS_DEBUG
  TimeAlign.startTimer();
#endif

  AlignedSequence<Value *> AlignedSeq;
  if (ConservativeMode) {
    NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(
        ScoringSystem(-1, 2), FunctionMerger::matchWholeBlocks);
    AlignedSequence<Value *> AlignedBlocks = SA.getAlignment(F1Vec, F2Vec);

    for (auto &Entry : AlignedBlocks) {
      if (Entry.match()) {
        BasicBlock *BB1 = dyn_cast<BasicBlock>(Entry.get(0));
        BasicBlock *BB2 = dyn_cast<BasicBlock>(Entry.get(1));
        // if (BB1==nullptr || BB2==nullptr) {
        //    return ErrorResponse;
        //}
        AlignedSeq.Data.push_back(
            AlignedSequence<Value *>::Entry(BB1, BB2, true));

        auto It1 = BB1->begin();
        auto It2 = BB2->begin();

        while (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1))
          It1++;
        while (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2))
          It2++;

        while (It1 != BB1->end() && It2 != BB2->end()) {
          Instruction *I1 = &*It1;
          Instruction *I2 = &*It2;

          // if (!matchInstructions(I1,I2))
          //  return ErrorResponse;

          AlignedSeq.Data.push_back(
              AlignedSequence<Value *>::Entry(I1, I2, true));

          It1++;
          It2++;
        }

        if (It1 != BB1->end() || It2 != BB2->end())
          return ErrorResponse;

      } else {
        if (Entry.get(0)) {
          BasicBlock *BB = dyn_cast<BasicBlock>(Entry.get(0));
          AlignedSeq.Data.push_back(
              AlignedSequence<Value *>::Entry(BB, nullptr, false));
          for (Instruction &I : *BB) {
            if (isa<PHINode>(&I) || isa<LandingPadInst>(&I))
              continue;
            AlignedSeq.Data.push_back(
                AlignedSequence<Value *>::Entry(&I, nullptr, false));
          }
        }
        if (Entry.get(1)) {
          BasicBlock *BB = dyn_cast<BasicBlock>(Entry.get(1));
          AlignedSeq.Data.push_back(
              AlignedSequence<Value *>::Entry(nullptr, BB, false));
          for (Instruction &I : *BB) {
            if (isa<PHINode>(&I) || isa<LandingPadInst>(&I))
              continue;
            AlignedSeq.Data.push_back(
                AlignedSequence<Value *>::Entry(nullptr, &I, false));
          }
        }
      }
    }
  } else {
    /*
    switch (SAMethod) {
      case 2: {
  */
    // errs() << "Here SA 1\n";
    // DiagonalWindowsSA<SmallVectorImpl<Value*>>
    // SA(ScoringSystem(-1,2),FunctionMerger::match,256);
    NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(ScoringSystem(-1, 2),
                                                   FunctionMerger::match);
    AlignedSeq = SA.getAlignment(F1Vec, F2Vec);

    // errs() << "Here SA 2\n";
    /*
          break;
        }
        case 1: {


          NeedlemanWunschSA<SmallVectorImpl<Value*>>
      SA(ScoringSystem(-1,2),FunctionMerger::match); AlignedSeq =
      SA.getAlignment(F1Vec,F2Vec);


          break;
        }
        default: {
          HirschbergSA<SmallVectorImpl<Value*>>
      SA(ScoringSystem(-1,2),FunctionMerger::match); AlignedSeq =
      SA.getAlignment(F1Vec,F2Vec); break;
        }
      }
      */
  }
#ifdef TIME_STEPS_DEBUG
  TimeAlign.stopTimer();
#endif

  //#ifdef ENABLE_DEBUG_CODE
  if (Verbose) {
    for (auto &Entry : AlignedSeq) {
      if (Entry.match()) {
        errs() << "1: ";
        if (isa<BasicBlock>(Entry.get(0)))
          errs() << "BB " << GetValueName(Entry.get(0)) << "\n";
        else
          Entry.get(0)->dump();
        errs() << "2: ";
        if (isa<BasicBlock>(Entry.get(1)))
          errs() << "BB " << GetValueName(Entry.get(1)) << "\n";
        else
          Entry.get(1)->dump();
        errs() << "----\n";
      } else {
        if (Entry.get(0)) {
          errs() << "1: ";
          if (isa<BasicBlock>(Entry.get(0)))
            errs() << "BB " << GetValueName(Entry.get(0)) << "\n";
          else
            Entry.get(0)->dump();
          errs() << "2: -\n";
        } else if (Entry.get(1)) {
          errs() << "1: -\n";
          errs() << "2: ";
          if (isa<BasicBlock>(Entry.get(1)))
            errs() << "BB " << GetValueName(Entry.get(1)) << "\n";
          else
            Entry.get(1)->dump();
        }
        errs() << "----\n";
      }
    }
  }
  //#endif

#ifdef TIME_STEPS_DEBUG
  TimeParam.startTimer();
#endif

  // errs() << "Creating function type\n";

  // Merging parameters
  std::map<unsigned, unsigned> ParamMap1;
  std::map<unsigned, unsigned> ParamMap2;
  std::vector<Type *> Args;

  // errs() << "Merging arguments\n";
  MergeArguments(Context, F1, F2, AlignedSeq, ParamMap1, ParamMap2, Args,
                 Options);

  Type *RetType1 = F1->getReturnType();
  Type *RetType2 = F2->getReturnType();
  Type *ReturnType = nullptr;

  bool RequiresUnifiedReturn = false;

  // Value *RetUnifiedAddr = nullptr;
  // Value *RetAddr1 = nullptr;
  // Value *RetAddr2 = nullptr;

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
    return ErrorResponse;
  }
  FunctionType *FTy =
      FunctionType::get(ReturnType, ArrayRef<Type *>(Args), false);

  if (Name.empty()) {
    Name = ".m.f";
    if (TestFM_CompilationCostModel)
      Name = "_fm_tmp_";
  }
  /*
    if (!HasWholeProgram) {
      Name = M->getModuleIdentifier() + std::string(".");
    }
    Name = Name + std::string("m.f");
  */
  Function *MergedFunc =
      Function::Create(FTy, GlobalValue::LinkageTypes::InternalLinkage,
                       // GlobalValue::LinkageTypes::PrivateLinkage,
                       Twine(Name), M); // merged.function
  // MergedFunc->setAttributes(F1->getAttributes());

  // errs() << "Initializing VMap\n";
  ValueToValueMapTy VMap;

  std::vector<Argument *> ArgsList;
  for (Argument &arg : MergedFunc->args()) {
    ArgsList.push_back(&arg);
  }
  Value *FuncId = ArgsList[0];

  int ArgId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    VMap[&(*I)] = ArgsList[ParamMap1[ArgId]];
    ArgId++;
  }
  ArgId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {
    VMap[&(*I)] = ArgsList[ParamMap2[ArgId]];
    ArgId++;
  }

#ifdef TIME_STEPS_DEBUG
  TimeParam.stopTimer();
#endif

  // errs() << "Setting attributes\n";
  SetFunctionAttributes(F1, F2, MergedFunc);

  Value *IsFunc1 = FuncId;

  // errs() << "Running code generator\n";

  auto Gen = [&](auto &CG) {
    CG.setFunctionIdentifier(IsFunc1)
        .setEntryPoints(&F1->getEntryBlock(), &F2->getEntryBlock())
        .setReturnTypes(RetType1, RetType2)
        .setMergedFunction(MergedFunc)
        .setMergedEntryPoint(BasicBlock::Create(Context, "entry", MergedFunc))
        .setMergedReturnType(ReturnType, RequiresUnifiedReturn)
        .setContext(ContextPtr)
        .setIntPtrType(IntPtrTy);
    if (!CG.generate(AlignedSeq, VMap, Options)) {
      MergedFunc->eraseFromParent();
      MergedFunc = nullptr;
      if (Debug)
        errs() << "Failed to generate the merged function!\n";
    }
  };

  if (EnableSALSSA) {
    SALSSACodeGen<Function::BasicBlockListType> CG(F1->getBasicBlockList(),
                                                   F2->getBasicBlockList());
    Gen(CG);
  } else {
    FMSACodeGen<Function::BasicBlockListType> CG(F1->getBasicBlockList(),
                                                 F2->getBasicBlockList());
    Gen(CG);
  }

  if (MergedFunc != nullptr && FuncId->getNumUses() == 0) {
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
      args[i] = GetAnyValue(MergedF->getFunctionType()->getParamType(i));
    }
  }

  CallInst *CI =
      (CallInst *)Builder.CreateCall(MergedF, ArrayRef<Value *>(args));
  // CI->setTailCall();
  CI->setCallingConv(MergedF->getCallingConv());
  CI->setAttributes(MergedF->getAttributes());
  CI->setIsNoInline();

  if (F->getReturnType()->isVoidTy()) {
    Builder.CreateRetVoid();
  } else {
    Value *CastedV = CI;
    if (MFR.needUnifiedReturn()) {
      Value *AddrCI = Builder.CreateAlloca(CI->getType());
      Builder.CreateStore(CI, AddrCI);
      Value *CastedAddr = Builder.CreatePointerCast(
          AddrCI,
          PointerType::get(F->getReturnType(), DL->getAllocaAddrSpace()));
      CastedV = Builder.CreateLoad(CastedAddr);
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
    if (CallInst *CI = dyn_cast<CallInst>(U)) {
      if (CI->getCalledFunction() == F) {
        Calls.push_back(CI);
      }
    } else if (InvokeInst *II = dyn_cast<InvokeInst>(U)) {
      if (II->getCalledFunction() == F) {
        if (EnableSALSSA)
          Calls.push_back(II);
      }
    }
  }

  if (Calls.size() < CountUsers)
    return false;

  for (CallBase *CI : Calls) {
    InlineFunctionInfo IFI;
    InlineFunction(*CI, IFI);
    continue;

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
        args[i] = GetAnyValue(MergedF->getFunctionType()->getParamType(i));
      }
    }

    CallBase *NewCB = nullptr;
    if (CI->getOpcode() == Instruction::Call) {
      NewCB = (CallInst *)Builder.CreateCall(MergedF->getFunctionType(),
                                             MergedF, args);
    } else if (CI->getOpcode() == Instruction::Invoke) {
      InvokeInst *II = dyn_cast<InvokeInst>(CI);
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
        CastedV = Builder.CreateLoad(CastedAddr);
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
    /// TODO: don't update call graph when dynamically tracing calls
    // bool CanErase = false; //replaceCallsWith(F, MFR, Options);
    bool CanErase = replaceCallsWith(F, MFR, Options);
    CanErase = CanErase && F->use_empty();
    CanErase = CanErase && (!F->hasAddressTaken());
    CanErase = CanErase &&
               (AlwaysPreserved.find(F->getName()) == AlwaysPreserved.end());
    if (!HasWholeProgram) {
      // CanEraseF1 = CanEraseF1 && ShouldPreserveGV(F1);
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

static int EstimateThunkOverhead(FunctionMergeResult &MFR,
                                 StringSet<> &AlwaysPreserved) {
  // return RequiresOriginalInterfaces(MFR, AlwaysPreserved) * 3;
  return RequiresOriginalInterfaces(MFR, AlwaysPreserved) *
         (2 + MFR.getMergedFunction()->getFunctionType()->getNumParams());
}

static bool CompareFunctionScores(const std::pair<Function *, unsigned> &F1,
                                  const std::pair<Function *, unsigned> &F2) {
  return F1.second > F2.second;
}

//#define FMSA_USE_JACCARD

class Fingerprint {
public:
  // static const size_t MaxOpcode = 65;
  // int OpcodeFreq[MaxOpcode];
  std::map<unsigned, int> OpcodeFreq;
  // size_t NumOfInstructions;
  // size_t NumOfBlocks;

#ifdef FMSA_USE_JACCARD
  std::set<Type *> Types;
#else
  std::map<Type *, int> TypeFreq;
#endif

  Function *F;

  Fingerprint(Function *F) {
    this->F = F;

    // memset(OpcodeFreq, 0, sizeof(int) * MaxOpcode);
    // for (int i = 0; i<MaxOpcode; i++) OpcodeFreq[i] = 0;

    // NumOfInstructions = 0;
    for (Instruction &I : instructions(F)) {
      // OpcodeFreq[I.getOpcode()]++;
      if (OpcodeFreq.find(I.getOpcode()) != OpcodeFreq.end())
        OpcodeFreq[I.getOpcode()]++;
      else
        OpcodeFreq[I.getOpcode()] = 1;
        // NumOfInstructions++;

#ifdef FMSA_USE_JACCARD
      Types.insert(I.getType());
#else
      TypeFreq[I.getType()]++;
#endif
    }
    // NumOfBlocks = F->size();
  }
};

class FingerprintSimilarity {
public:
  Function *F1;
  Function *F2;
  int Similarity;
  int LeftOver;
  int TypesDiff;
  int TypesSim;
  float Score;

  FingerprintSimilarity() : F1(nullptr), F2(nullptr), Score(0.0f) {}

  FingerprintSimilarity(Fingerprint *FP1, Fingerprint *FP2) {
    F1 = FP1->F;
    F2 = FP2->F;

    Similarity = 0;
    LeftOver = 0;
    TypesDiff = 0;
    TypesSim = 0;

    /*
    for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
      int Freq1 = FP1->OpcodeFreq[i];
      int Freq2 = FP2->OpcodeFreq[i];
      int MinFreq = std::min(Freq1, Freq2);
      Similarity += MinFreq;
      LeftOver += std::max(Freq1, Freq2) - MinFreq;
    }
    */

    for (auto Pair : FP1->OpcodeFreq) {
      if (FP2->OpcodeFreq.find(Pair.first) == FP2->OpcodeFreq.end()) {
        LeftOver += Pair.second;
      } else {
        int MinFreq = std::min(Pair.second, FP2->OpcodeFreq[Pair.first]);
        Similarity += MinFreq;
        LeftOver +=
            std::max(Pair.second, FP2->OpcodeFreq[Pair.first]) - MinFreq;
      }
    }
    for (auto Pair : FP2->OpcodeFreq) {
      if (FP1->OpcodeFreq.find(Pair.first) == FP1->OpcodeFreq.end()) {
        LeftOver += Pair.second;
      }
    }

#ifdef FMSA_USE_JACCARD
    for (auto Ty1 : FP1->Types) {
      if (FP2->Types.find(Ty1) == FP2->Types.end())
        TypesDiff++;
      else
        TypesSim++;
    }
    for (auto Ty2 : FP2->Types) {
      if (FP1->Types.find(Ty2) == FP1->Types.end())
        TypesDiff++;
    }

    float TypeScore = ((float)TypesSim) / ((float)TypesSim + TypesDiff);
#else
    for (auto Pair : FP1->TypeFreq) {
      if (FP2->TypeFreq.find(Pair.first) == FP2->TypeFreq.end()) {
        TypesDiff += Pair.second;
      } else {
        int MinFreq = std::min(Pair.second, FP2->TypeFreq[Pair.first]);
        TypesSim += MinFreq;
        TypesDiff += std::max(Pair.second, FP2->TypeFreq[Pair.first]) - MinFreq;
      }
    }
    for (auto Pair : FP2->TypeFreq) {
      if (FP1->TypeFreq.find(Pair.first) == FP1->TypeFreq.end()) {
        TypesDiff += Pair.second;
      }
    }
    float TypeScore =
        ((float)TypesSim) / ((float)(TypesSim * 2.0f + TypesDiff));
#endif
    float UpperBound =
        ((float)Similarity) / ((float)(Similarity * 2.0f + LeftOver));

#ifdef FMSA_USE_JACCARD
    Score = UpperBound * TypeScore;
#else
    Score = std::min(UpperBound, TypeScore);
#endif
  }

  bool operator<(const FingerprintSimilarity &FS) const {
    return Score < FS.Score;
  }

  bool operator>(const FingerprintSimilarity &FS) const {
    return Score > FS.Score;
  }

  bool operator<=(const FingerprintSimilarity &FS) const {
    return Score <= FS.Score;
  }

  bool operator>=(const FingerprintSimilarity &FS) const {
    return Score >= FS.Score;
  }

  bool operator==(const FingerprintSimilarity &FS) const {
    return Score == FS.Score;
  }
};

bool SimilarityHeuristicFilter(const FingerprintSimilarity &Item) {
  if (!ApplySimilarityHeuristic)
    return true;

  if (((float)Item.Similarity) < 0.8f * Item.LeftOver)
    return false;

  float TypesDiffRatio = (((float)Item.TypesDiff) / ((float)Item.TypesSim));
  if (TypesDiffRatio > 2.f)
    return false;

  return true;
}

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI) {
  double size = 0;
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
      size += TTI->getInstructionCost(
          &I, TargetTransformInfo::TargetCostKind::TCK_CodeSize);
    }
  }
  return size_t(std::ceil(size));
}

#ifdef TIME_STEPS_DEBUG
Timer TimePreProcess("Merge::Preprocess", "Merge::Preprocess");
Timer TimeRank("Merge::Rank", "Merge::Rank");
Timer TimeUpdate("Merge::Update", "Merge::Update");
// double AccumulatedUnprofitableMergeTime = 0;
// Timer TimeTotal("FM::Total", "FM::Total");
#endif
Timer TimePrediction("FM::Prediction", "FM::Prediction");

struct MergeOrder {
  std::string OutputName;
  std::vector<std::string> FNames;
  MergeOrder() {}
  MergeOrder(std::string ON, std::vector<std::string> FNs)
      : OutputName(ON), FNames(FNs) {}
};

static bool runFMTest(Module &M, FunctionMerger &FM, TargetTransformInfo &TTI,
                      FunctionMergingOptions Options = {}) {
  std::vector<MergeOrder> Merges;

  // Merges.push_back({"_ZN9flexarrayI6pointtE8doublingEb__merged",
  // {"_ZN9flexarrayI6pointtE8doublingEb",
  // "_ZN9flexarrayI11levelplacetE8doublingEb"}});
  // Merges.push_back({"_ZN9flexarrayIP6regobjE8doublingEb__merged",
  // {"_ZN9flexarrayIP6regobjE8doublingEb",
  // "_ZN9flexarrayI11regboundobjE8doublingEb"}});
  // Merges.push_back({"_ZN6wayobj9getxcoordEi__merged",
  // {"_ZN6wayobj9getxcoordEi", "_ZN6wayobj9getycoordEi"}});

  std::ifstream ifs("list-merges.txt");
  while (ifs.good()) {
    MergeOrder MO;
    ifs >> MO.OutputName;
    if (!ifs.good())
      break;

    std::string Name;
    ifs >> Name;
    while (ifs.good() && Name != ";") {
      MO.FNames.push_back(Name);
      Name = "";
      ifs >> Name;
    }
    Merges.push_back(MO);
  }

  StringSet<> AlwaysPreserved;
  AlwaysPreserved.insert("main");

  unsigned TotalMerges = 0;
  for (auto &Order : Merges) {
    Function *F1 = M.getFunction(Order.FNames[0]);
    Function *Merged = nullptr;
    if (F1 == nullptr) {
      errs() << "Invalid Function: Name Not Found: " << Order.FNames[0] << "\n";
      continue;
    }
    for (unsigned i = 1; i < Order.FNames.size(); i++) {
      Function *F2 = M.getFunction(Order.FNames[i]);
      if (F2 == nullptr) {
        errs() << "Invalid Function: Name Not Found: " << Order.FNames[i]
               << "\n";
        continue;
      }

      if (Debug || Verbose) {
        errs() << "Attempting: " << GetValueName(F1) << ", " << GetValueName(F2)
               << "\n";
      }

      std::string Name = ".m.f." + std::to_string(TotalMerges);
      FunctionMergeResult Result = FM.merge(F1, F2, Name, Options);

      bool validFunction = true;

      if (Result.getMergedFunction() != nullptr &&
          verifyFunction(*Result.getMergedFunction())) {
        if (Debug || Verbose) {
          errs() << "Invalid Function: " << GetValueName(F1) << ", "
                 << GetValueName(F2) << "\n";
        }
        if (Verbose) {
          if (Result.getMergedFunction() != nullptr) {
            Result.getMergedFunction()->dump();
          }
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
        }
        Result.getMergedFunction()->eraseFromParent();
        validFunction = false;
      }

      if (Result.getMergedFunction() && validFunction) {
        if (!EnableSALSSA) {
          DominatorTree MergedDT(*Result.getMergedFunction());
          promoteMemoryToRegister(*Result.getMergedFunction(), MergedDT);
        }

        size_t SizeF1 = EstimateFunctionSize(F1, &TTI);
        size_t SizeF2 = EstimateFunctionSize(F2, &TTI);

        size_t SizeF12 = EstimateThunkOverhead(Result, AlwaysPreserved) +
                         EstimateFunctionSize(Result.getMergedFunction(), &TTI);

        //#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
          errs() << "F1-F2:\n";
          Result.getMergedFunction()->dump();
        }
        //#endif

        size_t SizeF1F2 = SizeF1 + SizeF2;

        if (Debug || Verbose) {
          errs() << "Estimated Sizes: " << SizeF1 << " + " << SizeF2
                 << " <= " << SizeF12 << "? ("
                 << (SizeF12 <
                     SizeF1F2 * ((100.0 + MergingOverheadThreshold) / 100.0))
                 << ") ";
          errs() << "Reduction: "
                 << (int)((1 - ((double)SizeF12) / (SizeF1 + SizeF2)) * 100)
                 << "% "
                 << " : " << GetValueName(F1) << "; " << GetValueName(F2)
                 << "\n";
        }

        TotalMerges++;
        if (Debug || Verbose) {
          errs() << "Merged: " << GetValueName(F1) << ", " << GetValueName(F2)
                 << " = " << GetValueName(Result.getMergedFunction()) << "\n";
        }

        FM.updateCallGraph(Result, AlwaysPreserved, Options);

        if (!EnableSALSSA)
          demoteRegToMem(*Result.getMergedFunction());

        F1 = Result.getMergedFunction();
        Merged = Result.getMergedFunction();
      }
    }

    if (Merged)
      Merged->setName(Order.OutputName);
  }

  return true;
}

static void TmpLinearize(Function *F, SmallVectorImpl<Value *> &FVec) {
  std::list<BasicBlock *> OrderedBBs;

  unsigned FReserve = 0;
  FReserve = CanonicalLinearizationOfBlocks(F, OrderedBBs);

  FVec.reserve(FReserve + OrderedBBs.size());
  for (BasicBlock *BB : OrderedBBs) {
    FVec.push_back(BB);
    for (Instruction &I : *BB) {
      // FVec.push_back(&I);
      if (!isa<LandingPadInst>(&I) && !isa<PHINode>(&I)) {
        FVec.push_back(&I);
      }
    }
  }
}

static std::string GetTypeName(const Type *Ty) {
  if (Ty == nullptr)
    return "";

  if (const VectorType *VecTy = dyn_cast<VectorType>(Ty)) {
    return (std::string("vec_") + std::to_string(VecTy->getNumElements()) +
            std::string(" ") + GetTypeName(VecTy->getElementType()));
  }
  if (const ArrayType *ArrTy = dyn_cast<ArrayType>(Ty)) {
    return (std::string("arr_") + std::to_string(ArrTy->getNumElements()) +
            std::string(" ") + GetTypeName(ArrTy->getElementType()));
  }
  if (const PointerType *PtrTy = dyn_cast<PointerType>(Ty)) {
    return (std::string("ptr ") + GetTypeName(PtrTy->getElementType()));
  }
  if (isa<StructType>(Ty)) {
    return std::string("struct");
  }
  if (isa<FunctionType>(Ty)) {
    return std::string("function");
  }

  if (Ty->isVoidTy() || Ty->isIntegerTy() || Ty->isFloatingPointTy()) {
    std::string name;
    raw_string_ostream namestream(name);
    Ty->print(namestream, false, false);
    return namestream.str();
  } else
    return "";
}

static void WriteTrainingFile(std::string Prefix, Function *F1, Function *F2,
                              Function *FM, bool Profitable,
                              bool Append = true) {

  SmallVector<Value *, 8> F1Vec;
  SmallVector<Value *, 8> F2Vec;
  TmpLinearize(F1, F1Vec);
  TmpLinearize(F2, F2Vec);
  SmallVector<Value *, 8> FMVec;
  if (FM)
    TmpLinearize(FM, FMVec);

  std::string Name = Prefix + std::string("training.txt");

  std::ofstream out(Name.c_str(),
                    Append ? (std::ofstream::out | std::ofstream::app)
                           : std::ofstream::out);

  out << "= " << ((int)Profitable) << "\n";
  auto WriteFunc = [&](auto &Vec) {
    for (Value *V : Vec) {
      if (Instruction *I = dyn_cast<Instruction>(V)) {
        out << I->getOpcodeName() << " ";
        Type *Ty = I->getType();
        if (StoreInst *SI = dyn_cast<StoreInst>(I)) {
          Ty = SI->getValueOperand()->getType();
        } else if (ReturnInst *RI = dyn_cast<ReturnInst>(I)) {
          if (RI->getReturnValue())
            Ty = RI->getReturnValue()->getType();
        }

        out << GetTypeName(Ty) << "\n";

      } else
        out << "label\n";
    }
    out << "EOS\n";
  };
  out << "!fn: " << GetValueName(F1) << "\n";
  WriteFunc(F1Vec);
  out << "!fn: " << GetValueName(F2) << "\n";
  WriteFunc(F2Vec);
  if (FM) {
    out << "!fn: " << GetValueName(FM) << "\n";
    WriteFunc(FMVec);
  }
  out.close();
}

static void WriteTrainingFile2(std::string Prefix, Function *F1, Function *F2,
                               Function *FM, bool Profitable,
                               bool Append = true) {

  SmallVector<Value *, 8> F1Vec;
  SmallVector<Value *, 8> F2Vec;
  TmpLinearize(F1, F1Vec);
  TmpLinearize(F2, F2Vec);
  SmallVector<Value *, 8> FMVec;
  if (FM)
    TmpLinearize(FM, FMVec);

  // std::string FileName = "../training-full.txt";
  // std::error_code ec;
  // llvm::raw_fd_ostream os(FileName, ec, llvm::sys::fs::OF_Text);

  std::string Name = Prefix + std::string("training-full.txt");
  std::ofstream out(Name.c_str(),
                    Append ? (std::ofstream::out | std::ofstream::app)
                           : std::ofstream::out);
  llvm::raw_os_ostream os(out);

  out << "= " << ((int)Profitable) << "\n";
  auto WriteFunc = [&](auto &Vec) {
    for (Value *V : Vec) {
      if (Instruction *I = dyn_cast<Instruction>(V)) {
        I->print(os);
        out << "\n";
        /*
        out << I->getOpcodeName() << " ";
        Type *Ty = I->getType();
        if (StoreInst *SI = dyn_cast<StoreInst>(I)) {
            Ty = SI->getValueOperand()->getType();
        } else if (ReturnInst *RI = dyn_cast<ReturnInst>(I)) {
            if (RI->getReturnValue()) Ty = RI->getReturnValue()->getType();
        }
        out << GetTypeName(Ty) << "\n";
        */
      } else {
        out << "!label: " << GetValueName(V) << "\n";
      }
    }
    out << "EOS\n";
  };

  out << "!fn: " << GetValueName(F1) << "\n";
  WriteFunc(F1Vec);
  out << "!fn: " << GetValueName(F2) << "\n";
  WriteFunc(F2Vec);
  if (FM) {
    out << "!fn: " << GetValueName(FM) << "\n";
    WriteFunc(FMVec);
  }

  out.close();
}

#include "FMObjFileSize.hpp"

bool FunctionMerging::runOnModule(Module &M) {
#ifdef TIME_STEPS_DEBUG
  // TimeTotal.startTimer();
  // AccumulatedUnprofitableMergeTime  = 0;
#endif

  // errs() << "Running FMSA\n";

  int pid = 0;
#ifndef __APPLE__
  pid = getpid();
#endif
  TPrefix = std::string("/tmp/") + std::to_string(pid) + std::string("-") +
            std::to_string((size_t)(&FunctionMerging::ID)) + std::string(".");
  // TPrefix = std::string("../");

  StringSet<> AlwaysPreserved;
  AlwaysPreserved.insert("main");

  srand(time(NULL));

  FunctionMergingOptions Options =
      FunctionMergingOptions()
          .maximizeParameterScore(MaxParamScore)
          .matchOnlyIdenticalTypes(IdenticalType)
          .enableUnifiedReturnTypes(EnableUnifiedReturnType);

  auto *PSI = &this->getAnalysis<ProfileSummaryInfoWrapperPass>().getPSI();
  auto LookupBFI = [this](Function &F) {
    return &this->getAnalysis<BlockFrequencyInfoWrapperPass>(F).getBFI();
  };

  // TODO: We could use a TTI ModulePass instead but current TTI analysis pass
  // is a FunctionPass.
  TargetTransformInfo TTI(M.getDataLayout());

  std::vector<std::pair<Function *, unsigned>> FunctionsToProcess;

  unsigned TotalMerges = 0;

  unsigned TotalOpReorder = 0;
  unsigned TotalBinOps = 0;

  FunctionMerger FM(&M, PSI, LookupBFI);

  if (MergeListNames)
    return runFMTest(M, FM, TTI, Options);

  std::map<Function *, Fingerprint *> CachedFingerprints;
  std::map<Function *, unsigned> FuncSizes;

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.startTimer();
#endif

  std::set<std::string> Blacklist;
  // TODO: load from file
  // Blacklist.insert(std::string("quantum_state_collapse"));
  // Blacklist.insert(std::string("quantum_bmeasure_bitpreserve"));

  for (auto &F : M) {
    if (F.isDeclaration() || F.isVarArg() ||
        (!HasWholeProgram && F.hasAvailableExternallyLinkage()))
      continue;

    // if (!Blacklist.count(F.getName().str())) continue;

    FuncSizes[&F] = EstimateFunctionSize(&F, &TTI);

    if (!EnableSALSSA)
      demoteRegToMem(F);

    FunctionsToProcess.push_back(
        std::pair<Function *, unsigned>(&F, FuncSizes[&F]));

    CachedFingerprints[&F] = new Fingerprint(&F);
  }
  errs() << "Number of Functions: " << FunctionsToProcess.size() << "\n";

  std::sort(FunctionsToProcess.begin(), FunctionsToProcess.end(),
            CompareFunctionScores);

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.stopTimer();
#endif

  std::list<Function *> WorkList;

  std::list<Function *> AvailableCandidates;

  for (std::pair<Function *, unsigned> FuncAndSize1 : FunctionsToProcess) {
    Function *F1 = FuncAndSize1.first;
    WorkList.push_back(F1);
    AvailableCandidates.push_back(F1);
  }

  std::vector<FingerprintSimilarity> Rank;
  if (ExplorationThreshold > 1)
    Rank.reserve(FunctionsToProcess.size());

  FunctionsToProcess.clear();

  Optional<size_t> SizeF1F2Opt;
  Optional<size_t> SizeF12Opt;
  if (TestFM_Oracle) {
    SizeF1F2Opt = MeasureSize(M, "oracle1"); // oracle
  }

  while (!WorkList.empty()) {
    Function *F1 = WorkList.front();
    WorkList.pop_front();

    AvailableCandidates.remove(F1);

    Rank.clear();

#ifdef TIME_STEPS_DEBUG
    TimeRank.startTimer();
#endif

    Fingerprint *FP1 = CachedFingerprints[F1];

    if (ExplorationThreshold > 1) {
      unsigned CountCandidates = 0;
      for (Function *F2 : AvailableCandidates) {
        if ((!FM.validMergeTypes(F1, F2, Options) &&
             !Options.EnableUnifiedReturnType) ||
            !validMergePair(F1, F2))
          continue;

        Fingerprint *FP2 = CachedFingerprints[F2];

        FingerprintSimilarity PairSim(FP1, FP2);
        if (SimilarityHeuristicFilter(PairSim))
          Rank.push_back(PairSim);
        if (RankingThreshold && CountCandidates > RankingThreshold) {
          break;
        }
        CountCandidates++;
      }
      std::make_heap(Rank.begin(), Rank.end());
    } else {

      bool FoundCandidate = false;
      FingerprintSimilarity BestPair;

      unsigned CountCandidates = 0;
      for (Function *F2 : AvailableCandidates) {
        if ((!FM.validMergeTypes(F1, F2, Options) &&
             !Options.EnableUnifiedReturnType) ||
            !validMergePair(F1, F2))
          continue;

        Fingerprint *FP2 = CachedFingerprints[F2];

        FingerprintSimilarity PairSim(FP1, FP2);
        if (PairSim > BestPair && SimilarityHeuristicFilter(PairSim)) {
          BestPair = PairSim;
          FoundCandidate = true;
        }
        if (RankingThreshold && CountCandidates > RankingThreshold) {
          break;
        }
        CountCandidates++;
      }
      if (FoundCandidate)
        Rank.push_back(BestPair);
    }

#ifdef TIME_STEPS_DEBUG
    TimeRank.stopTimer();
#endif

    unsigned MergingTrialsCount = 0;

    while (!Rank.empty()) {
      auto RankEntry = Rank.front();
      Function *F2 = RankEntry.F2;
      std::pop_heap(Rank.begin(), Rank.end());
      Rank.pop_back();

      // CountBinOps = 0;
      // CountOpReorder = 0;

      MergingTrialsCount++;

      if (Debug || Verbose) {
        errs() << "Attempting: " << GetValueName(F1) << ", " << GetValueName(F2)
               << "\n";
      }

      bool ProftablePrediction = true;
      if (RunPrediction) {
#ifdef TIME_STEPS_DEBUG
        // TimeTotal.stopTimer();
#endif
        TimePrediction.startTimer();

        WriteTrainingFile(TPrefix, F1, F2, nullptr, false, false);

        std::string PredictionPath = TPrefix + std::string(".prediction.txt");

        // WriteTrainingFile2(TPrefix, F1,F2, nullptr, false, false);
        // std::string Cmd = std::string("python3
        // /home/rodrigo/ml/deepopt/repo/src/v2/predict.py
        // /home/rodrigo/ml/deepopt/data/dataset-n1-built-full-2.txt  ") +
        // OptBenchName + std::string(" ../training-full.txt >
        // /tmp/prediction.txt");
        std::string Cmd =
            std::string(
                "python3 /home/rodrigo/ml/deepopt/repo/src/v4/predict.py "
                "/home/rodrigo/ml/deepopt/data/dataset-n1-built-2.txt  ") +
            OptBenchName + std::string("   ") + TPrefix +
            std::string("training.txt") + std::string("  >   ") +
            PredictionPath;
        // std::string Cmd = std::string("python3
        // /home/rodrigo/ml/deepopt/repo/src/v1/predict.py
        // /home/rodrigo/ml/deepopt/data/testing.txt  ") + OptBenchName +
        // std::string(" ../training.txt > /tmp/prediction.txt");
        bool BadMeasurement = std::system(Cmd.c_str());
        if (!BadMeasurement) {
          std::ifstream ifs(PredictionPath.c_str());
          if (ifs.good()) {
            std::string Str;
            ifs >> Str;
            ProftablePrediction = std::stoul(Str, nullptr, 0);
            errs() << "Prediction: " << ProftablePrediction << "\n";
            ifs.close();
          }
        }

        TimePrediction.stopTimer();
#ifdef TIME_STEPS_DEBUG
        // TimeTotal.startTimer();
#endif
      }

      if (!ProftablePrediction) {
        errs() << "Skipping\n";
      }

      if (ProftablePrediction) {

        // if (!ProftablePrediction)
        //  TimePredictionGains.startTimer();

#ifdef TIME_STEPS_DEBUG
        // Timer TimeOneMerge("FM::OneMerge", "FM::OneMerge");
        // TimeOneMerge.startTimer();
#endif

        // errs() << "Here1\n";
        std::string Name = ".m.f." + std::to_string(TotalMerges);
        FunctionMergeResult Result = FM.merge(F1, F2, Name, Options);
        // errs() << "Here2\n";

        bool validFunction = true;
        bool Profitable = false;

        if (Result.getMergedFunction() != nullptr &&
            verifyFunction(*Result.getMergedFunction())) {
          if (Debug || Verbose) {
            errs() << "Invalid Function: " << GetValueName(F1) << ", "
                   << GetValueName(F2) << "\n";
            // Result.getMergedFunction()->dump();
          }
#ifdef ENABLE_DEBUG_CODE
          if (Verbose) {
            if (Result.getMergedFunction() != nullptr) {
              Result.getMergedFunction()->dump();
            }
            errs() << "F1:\n";
            F1->dump();
            errs() << "F2:\n";
            F2->dump();
          }
#endif
          Result.getMergedFunction()->eraseFromParent();
          validFunction = false;
        }

        if (Result.getMergedFunction() && validFunction) {
          if (!EnableSALSSA) {
            DominatorTree MergedDT(*Result.getMergedFunction());
            promoteMemoryToRegister(*Result.getMergedFunction(), MergedDT);
          }

          unsigned SizeF1 = FuncSizes[F1];
          unsigned SizeF2 = FuncSizes[F2];

          unsigned SizeF12 =
              EstimateThunkOverhead(Result, AlwaysPreserved) +
              EstimateFunctionSize(Result.getMergedFunction(), &TTI);

          //#ifdef ENABLE_DEBUG_CODE
          if (Verbose) {
            errs() << "F1:\n";
            F1->dump();
            errs() << "F2:\n";
            F2->dump();
            errs() << "F1-F2:\n";
            Result.getMergedFunction()->dump();
          }
          //#endif

          unsigned SizeF1F2 = SizeF1 + SizeF2;

          if (TestFM_Oracle) {
            // oracle
            SizeF12Opt = MeasureSize(M, Result, AlwaysPreserved, Options);

            if (SizeF1F2Opt.hasValue() && SizeF12Opt.hasValue() &&
                SizeF1F2Opt.getValue() && SizeF12Opt.getValue()) {
              SizeF1F2 = SizeF1F2Opt.getValue();
              SizeF12 = SizeF12Opt.getValue();
            } else {
              errs() << "Sizes: Could NOT Compute!\n";
              if (Result.getMergedFunction() != nullptr)
                Result.getMergedFunction()->eraseFromParent();
              continue; // only accept compiled estimates
            }
          }

          bool ProfitableOracle =
              (SizeF12 <
               SizeF1F2 * ((100.0 + MergingOverheadThreshold) / 100.0));

          errs() << "Estimated Sizes: " << SizeF1F2 << " <= " << SizeF12
                 << "? : " << ProfitableOracle << ": Reduction: "
                 << (int)(((((double)SizeF1F2) - (double)SizeF12) /
                           ((double)SizeF1F2)) *
                          100.)
                 << "% \n";

          if (TestFM_CompilationCostModel) {

            // errs() << "Here 3\n";
            if (!MeasureMergedSize(SizeF1F2, SizeF12, M, Result,
                                   AlwaysPreserved, Options)) {
              if (ProfitableOracle) {
                errs() << "Could not extract profitable candidate!! "
                       << TestCount << "\n";
              }
              if (Result.getMergedFunction() != nullptr)
                Result.getMergedFunction()->eraseFromParent();
              continue;
            }
          }

          Profitable =
              (SizeF12 <
               SizeF1F2 * ((100.0 + MergingOverheadThreshold) / 100.0));

          if (ProfitableOracle != Profitable) {
            errs() << "unexpected diversion! " << TestCount << "\n";
          }
          TestCount++;

          if (Debug || Verbose) {
            errs() << "Estimated Sizes: " << SizeF1F2 << " <= " << SizeF12
                   << "? : " << Profitable << ": Reduction: "
                   << (int)(((((double)SizeF1F2) - (double)SizeF12) /
                             ((double)SizeF1F2)) *
                            100.)
                   << "% : " << MergingTrialsCount << " : " << GetValueName(F1)
                   << "; " << GetValueName(F2) << "\n";
          }

          if ((GenTestingData || GenTrainingData) && EnableSALSSA) {
            if (!RunPrediction) {
              WriteTrainingFile(TestFM_DataPATH, F1, F2,
                                Result.getMergedFunction(), Profitable);
              WriteTrainingFile2(TestFM_DataPATH, F1, F2,
                                 Result.getMergedFunction(), Profitable);
            }
          }

          // if (GenTrainingData && EnableSALSSA) {
          //   Profitable = false;
          //}

          if (Profitable) {

            // MergingDistance.push_back(MergingTrialsCount);

            // TotalOpReorder += CountOpReorder;
            // TotalBinOps += CountBinOps;

            if (Debug || Verbose) {
              errs() << "Merged: " << GetValueName(F1) << ", "
                     << GetValueName(F2) << " = "
                     << GetValueName(Result.getMergedFunction()) << "\n";
            }
            // if (Verbose) {
            //  F1->dump();
            //  F2->dump();
            //  Result.getMergedFunction()->dump();
            //}
#ifdef TIME_STEPS_DEBUG
            TimeUpdate.startTimer();
#endif

            AvailableCandidates.remove(F2);
            WorkList.remove(F2);

            TotalMerges++;

#ifdef DEBUG_OUTPUT_EACH_CHANGE
            if (EnableSALSSA) {
              std::string FilePath =
                  std::string("/home/rodrigo/eval/eachmerge/em-") +
                  std::to_string(TotalMerges) + std::string(".txt");
              std::error_code EC;
              llvm::raw_fd_ostream OS(FilePath, EC, llvm::sys::fs::F_None);
              OS << "Merged: " << GetValueName(F1) << ", " << GetValueName(F2)
                 << "\n";
              OS << *F1;
              OS << *F2;
              OS.flush();
            }
#endif

            FM.updateCallGraph(Result, AlwaysPreserved, Options);

#ifdef DEBUG_OUTPUT_EACH_CHANGE
            if (EnableSALSSA) {
              std::string FilePath =
                  std::string("/home/rodrigo/eval/eachmerge/em-") +
                  std::to_string(TotalMerges) + std::string(".ll");
              std::error_code EC;
              llvm::raw_fd_ostream OS(FilePath, EC, llvm::sys::fs::F_None);
              OS << M;
              OS.flush();
            }
#endif

            // feed new function back into the working lists
            WorkList.push_front(Result.getMergedFunction());
            AvailableCandidates.push_front(Result.getMergedFunction());

            FuncSizes[Result.getMergedFunction()] =
                EstimateFunctionSize(Result.getMergedFunction(), &TTI);

            if (!EnableSALSSA)
              demoteRegToMem(*Result.getMergedFunction());

            CachedFingerprints[Result.getMergedFunction()] =
                new Fingerprint(Result.getMergedFunction());

#ifdef TIME_STEPS_DEBUG
            TimeUpdate.stopTimer();
#endif

            if (TestFM_Oracle) {
              SizeF1F2Opt = SizeF12Opt; // oracle
            }

            // if (!ProftablePrediction)
            //  TimePredictionGains.stopTimer();
            break; // end exploration with F1
          } else {
            if (Result.getMergedFunction() != nullptr)
              Result.getMergedFunction()->eraseFromParent();
          } // end profitable if-else
        }   // end if valid merge

#ifdef TIME_STEPS_DEBUG
        // TimeOneMerge.stopTimer();
        // if (!Profitable) {
        // AccumulatedUnprofitableMergeTime +=
        // TimeOneMerge.getTotalTime().getWallTime();
        //}
        // TimeOneMerge.clear();
#endif
        // if (!ProftablePrediction)
        //  TimePredictionGains.stopTimer();
      } // end ProftablePrediction

      if (!GenTrainingData) {
        if (MergingTrialsCount >= ExplorationThreshold) {
          break;
        }
      }
    }
  }

  WorkList.clear();

  for (auto kv : CachedFingerprints) {
    delete kv.second;
  }
  CachedFingerprints.clear();

  double MergingAverageDistance = 0;
  unsigned MergingMaxDistance = 0;

  /*
    for (unsigned Distance : MergingDistance) {
      MergingAverageDistance += Distance;
      if (Distance > MergingMaxDistance)
        MergingMaxDistance = Distance;
    }
    if (MergingDistance.size() > 0) {
      MergingAverageDistance = MergingAverageDistance / MergingDistance.size();
    }
  */

#ifdef TIME_STEPS_DEBUG
  // TimeTotal.stopTimer();
#endif

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

  if (RunPrediction) {
    errs() << "Timer:Prediction: "
           << TimePrediction.getTotalTime().getWallTime() << "\n";
    TimePrediction.clear();
  }
#ifdef TIME_STEPS_DEBUG
  errs() << "Timer:PredictionGains: "
         << TimePredictionGains.getTotalTime().getWallTime() << "\n";
  TimePredictionGains.clear();

  // errs() << "Timer:Total: " << TimeTotal.getTotalTime().getWallTime() <<
  // "\n"; TimeTotal.clear();

  // errs() << "Timer:Unprofitable: " << AccumulatedUnprofitableMergeTime <<
  // "\n";

  errs() << "Timer:Align: " << TimeAlign.getTotalTime().getWallTime() << "\n";
  TimeAlign.clear();

  errs() << "Timer:Param: " << TimeParam.getTotalTime().getWallTime() << "\n";
  TimeParam.clear();

  errs() << "Timer:CodeGen: " << TimeCodeGen.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen.clear();

  errs() << "Timer:Simplify: " << TimeSimplify.getTotalTime().getWallTime()
         << "\n";
  TimeSimplify.clear();

  errs() << "Timer:PreProcess: " << TimePreProcess.getTotalTime().getWallTime()
         << "\n";
  TimePreProcess.clear();

  errs() << "Timer:Lin: " << TimeLin.getTotalTime().getWallTime() << "\n";
  TimeLin.clear();

  errs() << "Timer:Rank: " << TimeRank.getTotalTime().getWallTime() << "\n";
  TimeRank.clear();

  errs() << "Timer:Update: " << TimeUpdate.getTotalTime().getWallTime() << "\n";
  TimeUpdate.clear();
#endif

  return true;
}

void FunctionMerging::getAnalysisUsage(AnalysisUsage &AU) const {
  ModulePass::getAnalysisUsage(AU);
  AU.addRequired<ProfileSummaryInfoWrapperPass>();
  AU.addRequired<BlockFrequencyInfoWrapperPass>();
}

char FunctionMerging::ID = 0;
INITIALIZE_PASS(FunctionMerging, "func-merging", "New Function Merging", false,
                false)

ModulePass *llvm::createFunctionMergingPass() { return new FunctionMerging(); }

static std::string GetValueName(const Value *V) {
  if (V) {
    std::string name;
    raw_string_ostream namestream(name);
    V->printAsOperand(namestream, false);
    return namestream.str();
  } else
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

    Result = GetAnyValue(DstType);
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

static bool valueEscapes(const Instruction *Inst) {
  const BasicBlock *BB = Inst->getParent();
  for (const User *U : Inst->users()) {
    const Instruction *UI = cast<Instruction>(U);
    if (UI->getParent() != BB || isa<PHINode>(UI))
      return true;
  }
  return false;
}

// TODO: use the function implemented by the reg2mem pass directly
//-reg2mem
static void demoteRegToMem(Function &F) {
  if (F.isDeclaration())
    return;

  // Insert all new allocas into entry block.
  BasicBlock *BBEntry = &F.getEntryBlock();

  assert(pred_empty(BBEntry) &&
         "Entry block to function must not have predecessors!");

  // Find first non-alloca instruction and create insertion point. This is
  // safe if block is well-formed: it always have terminator, otherwise
  // we'll get and assertion.
  BasicBlock::iterator I = BBEntry->begin();
  while (isa<AllocaInst>(I))
    ++I;

  CastInst *AllocaInsertionPoint = new BitCastInst(
      Constant::getNullValue(Type::getInt32Ty(F.getContext())),
      Type::getInt32Ty(F.getContext()), "reg2mem alloca point", &*I);

  // Find the escaped instructions. But don't create stack slots for
  // allocas in entry block.
  std::list<Instruction *> WorkList;
  for (BasicBlock &ibb : F)
    for (BasicBlock::iterator iib = ibb.begin(), iie = ibb.end(); iib != iie;
         ++iib) {
      if (!(isa<AllocaInst>(iib) && iib->getParent() == BBEntry) &&
          valueEscapes(&*iib)) {
        WorkList.push_front(&*iib);
      }
    }

  // Demote escaped instructions
  // NumRegsDemoted += WorkList.size();
  for (Instruction *ilb : WorkList)
    DemoteRegToStack(*ilb, false, AllocaInsertionPoint);

  WorkList.clear();

  // Find all phi's
  for (BasicBlock &ibb : F)
    for (BasicBlock::iterator iib = ibb.begin(), iie = ibb.end(); iib != iie;
         ++iib)
      if (isa<PHINode>(iib))
        WorkList.push_front(&*iib);

  // Demote phi nodes
  // NumPhisDemoted += WorkList.size();
  for (Instruction *ilb : WorkList)
    DemotePHIToStack(cast<PHINode>(ilb), AllocaInsertionPoint);
}

// TODO: use the function implemented by the mem2reg pass directly
static bool promoteMemoryToRegister(Function &F, DominatorTree &DT) {
  std::vector<AllocaInst *> Allocas;
  BasicBlock &BB = F.getEntryBlock(); // Get the entry node for the function
  bool Changed = false;

  while (true) {
    Allocas.clear();

    // Find allocas that are safe to promote, by looking at all instructions in
    // the entry node
    for (BasicBlock::iterator I = BB.begin(), E = --BB.end(); I != E; ++I)
      if (AllocaInst *AI = dyn_cast<AllocaInst>(I)) // Is it an alloca?
        if (isAllocaPromotable(AI))
          Allocas.push_back(AI);

    if (Allocas.empty())
      break;

    // PromoteMemToReg(Allocas, DT, &AC);
    PromoteMemToReg(Allocas, DT, nullptr);
    // NumPromoted += Allocas.size();
    Changed = true;
  }
  return Changed;
}

static void fixNotDominatedUses(Function *F, BasicBlock *Entry,
                                DominatorTree &DT) {
  std::list<Instruction *> WorkList;
  std::map<Instruction *, Value *> StoredAddress;

  std::map<Instruction *, std::map<Instruction *, std::list<unsigned>>>
      UpdateList;

  auto StoreInstIntoAddr = [&](Instruction *IV, Value *Addr) {
    IRBuilder<> Builder(IV->getParent());
    if (IV->isTerminator()) {
      BasicBlock *SrcBB = IV->getParent();
      if (InvokeInst *II = dyn_cast<InvokeInst>(IV)) {
        BasicBlock *DestBB = II->getNormalDest();

        Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
        // create PHI
        PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
        for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
             PredIt != PredE; PredIt++) {
          BasicBlock *PredBB = *PredIt;
          if (PredBB == SrcBB) {
            PHI->addIncoming(IV, PredBB);
          } else {
            PHI->addIncoming(GetAnyValue(IV->getType()), PredBB);
          }
        }
        Builder.CreateStore(PHI, Addr);
      } else {
        for (auto SuccIt = succ_begin(SrcBB), SuccE = succ_end(SrcBB);
             SuccIt != SuccE; SuccIt++) {
          BasicBlock *DestBB = *SuccIt;

          Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
          // create PHI
          PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
          for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
               PredIt != PredE; PredIt++) {
            BasicBlock *PredBB = *PredIt;
            if (PredBB == SrcBB) {
              PHI->addIncoming(IV, PredBB);
            } else {
              PHI->addIncoming(GetAnyValue(IV->getType()), PredBB);
            }
          }
          Builder.CreateStore(PHI, Addr);
        }
      }
    } else {
      Instruction *LastI = nullptr;
      Instruction *InsertPt = nullptr;
      for (Instruction &I : *IV->getParent()) {
        InsertPt = &I;
        if (LastI == IV)
          break;
        LastI = &I;
      }
      if (isa<PHINode>(InsertPt) || isa<LandingPadInst>(InsertPt))
        Builder.SetInsertPoint(&*IV->getParent()->getFirstInsertionPt());
      else
        Builder.SetInsertPoint(InsertPt);

      Builder.CreateStore(IV, Addr);
    }
  };

  // bool HasPHINodes = false;
  for (Instruction &I : instructions(*F)) {
    for (auto *U : I.users()) {
      Instruction *UI = dyn_cast<Instruction>(U);
      if (UI && !DT.dominates(&I, UI)) {
        auto &ListOperands = UpdateList[&I][UI];
        for (unsigned i = 0; i < UI->getNumOperands(); i++) {
          if (UI->getOperand(i) == (Value *)(&I)) {
            ListOperands.push_back(i);
          }
        }
      }
    }
    if (UpdateList[&I].size() > 0) {
      IRBuilder<> Builder(&*Entry->getFirstInsertionPt());
      StoredAddress[&I] = Builder.CreateAlloca(I.getType());
      // Builder.CreateStore(GetAnyValue(I.getType()), StoredAddress[&I]);
      StoreInstIntoAddr(&I, StoredAddress[&I]);
    }
  }

  for (auto &kv1 : UpdateList) {
    Instruction *I = kv1.first;
    for (auto &kv : kv1.second) {
      Instruction *UI = kv.first;
      IRBuilder<> Builder(UI);
      Value *V = Builder.CreateLoad(StoredAddress[I]);
      for (unsigned i : kv.second) {
        UI->setOperand(i, V);
      }
    }
  }

  // demoteRegToMem(*F);
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

////////////////////////////////////   SALSSA   ////////////////////////////////

static bool simplifyPHIsInBlock(BasicBlock &BB) {
  std::list<PHINode *> Phis;
  for (Instruction &I : BB) {
    if (PHINode *PHI = dyn_cast<PHINode>(&I))
      Phis.push_back(PHI);
  }
  std::set<PHINode *> Removed;
  for (auto It1 = Phis.begin(), E = Phis.end(); It1 != E; It1++) {
    for (auto It2 = Phis.begin(); It2 != It1; It2++) {
      PHINode *PHI1 = *It1;
      PHINode *PHI2 = *It2;
      if (Removed.find(PHI2) != Removed.end())
        continue;

      bool FoundPHI = true;
      for (unsigned i = 0; i < PHI1->getNumIncomingValues(); i++) {
        if (PHI1->getIncomingValue(i) !=
            PHI2->getIncomingValueForBlock(PHI1->getIncomingBlock(i))) {
          FoundPHI = false;
        }
      }
      if (FoundPHI) {
        PHI1->replaceAllUsesWith(PHI2);
        Removed.insert(PHI1);
        break;
      }
    }
  }
  for (PHINode *PHI : Removed) {
    if (PHI->use_empty())
      PHI->eraseFromParent();
  }
  return !Removed.empty();
}

static void simplifyInstructions(Function &F) {
  for (BasicBlock &BB : F) {
    simplifyPHIsInBlock(BB);
    SimplifyInstructionsInBlock(&BB);
  }
}

static void simplifyCFG(Function &F) {
  TargetTransformInfo TTI(F.getParent()->getDataLayout());
  std::list<BasicBlock *> BBs;
  for (BasicBlock &BB : F)
    BBs.push_back(&BB);
  for (BasicBlock *BB : BBs) {
    simplifyCFG(BB, TTI);
  }
}

static void MySimplifyCFG(Function &F) {
  std::set<BasicBlock *> ToSimplify;
  for (BasicBlock &BB : F) {
    Instruction *TI = BB.getTerminator();
    if (isa<BranchInst>(TI) && TI->getNumSuccessors() == 1) {
      BasicBlock::iterator I = BB.getFirstNonPHIOrDbg()->getIterator();
      if (I->isTerminator() && (&BB) != (&F.getEntryBlock()))
        ToSimplify.insert(&BB);
    }
  }
  for (BasicBlock *BB : ToSimplify) {
    TryToSimplifyUncondBranchFromEmptyBlock(BB);
  }
}

static void postProcessFunction(Function &F) {
  //  simplifyInstructions(F);
  //  simplifyCFG(F);

  legacy::FunctionPassManager FPM(F.getParent());

  // FPM.add(createPromoteMemoryToRegisterPass());
  FPM.add(createCFGSimplificationPass());
  FPM.add(createInstructionCombiningPass());
  FPM.add(createCFGSimplificationPass());

  FPM.doInitialization();
  FPM.run(F);
  FPM.doFinalization();
}

template <typename BlockListType>
static void
CodeGen(BlockListType &Blocks1, BlockListType &Blocks2, BasicBlock *EntryBB1,
        BasicBlock *EntryBB2, Function *MergedFunc, Value *IsFunc1,
        BasicBlock *PreBB, AlignedSequence<Value *> &AlignedSeq,
        ValueToValueMapTy &VMap, std::map<BasicBlock *, BasicBlock *> &BlocksF1,
        std::map<BasicBlock *, BasicBlock *> &BlocksF2,
        std::map<Value *, BasicBlock *> &MaterialNodes) {

  auto CloneInst = [](IRBuilder<> &Builder, Function *MF,
                      Instruction *I) -> Instruction * {
    Instruction *NewI = nullptr;
    if (I->getOpcode() == Instruction::Ret) {
      if (MF->getReturnType()->isVoidTy()) {
        NewI = Builder.CreateRetVoid();
      } else {
        NewI = Builder.CreateRet(GetAnyValue(MF->getReturnType()));
      }
    } else {
      // assert(I1->getNumOperands() == I2->getNumOperands() &&
      //      "Num of Operands SHOULD be EQUAL!");
      NewI = I->clone();
      Builder.Insert(NewI);
    }

    NewI->dropPoisonGeneratingFlags(); // TODO: NOT SURE IF THIS IS VALID

    // TODO: temporarily removing metadata

    SmallVector<std::pair<unsigned, MDNode *>, 8> MDs;
    NewI->getAllMetadata(MDs);
    for (std::pair<unsigned, MDNode *> MDPair : MDs) {
      NewI->setMetadata(MDPair.first, nullptr);
    }

    if (isa<GetElementPtrInst>(NewI)) {
      GetElementPtrInst *GEP = dyn_cast<GetElementPtrInst>(I);
      // GetElementPtrInst * GEP2 = dyn_cast<GetElementPtrInst>(I2);
      dyn_cast<GetElementPtrInst>(NewI)->setIsInBounds(GEP->isInBounds());
    }

    if (CallBase *CB = dyn_cast<CallBase>(NewI)) {
      AttributeList AL;
      CB->setAttributes(AL);
    }

    return NewI;
  };

  for (auto &Entry : AlignedSeq) {
    if (Entry.match()) {

      Instruction *I1 = dyn_cast<Instruction>(Entry.get(0));
      Instruction *I2 = dyn_cast<Instruction>(Entry.get(1));

      std::string BBName =
          (I1 == nullptr) ? "m.label.bb"
                          : (I1->isTerminator() ? "m.term.bb" : "m.inst.bb");

      BasicBlock *MergedBB =
          BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);

      MaterialNodes[Entry.get(0)] = MergedBB;
      MaterialNodes[Entry.get(1)] = MergedBB;

      if (I1 != nullptr && I2 != nullptr) {
        IRBuilder<> Builder(MergedBB);
        Instruction *NewI = CloneInst(Builder, MergedFunc, I1);

        VMap[I1] = NewI;
        VMap[I2] = NewI;
        BlocksF1[MergedBB] = I1->getParent();
        BlocksF2[MergedBB] = I2->getParent();
      } else {
        assert(isa<BasicBlock>(Entry.get(0)) && isa<BasicBlock>(Entry.get(1)) &&
               "Both nodes must be basic blocks!");
        BasicBlock *BB1 = dyn_cast<BasicBlock>(Entry.get(0));
        BasicBlock *BB2 = dyn_cast<BasicBlock>(Entry.get(1));

        VMap[BB1] = MergedBB;
        VMap[BB2] = MergedBB;
        BlocksF1[MergedBB] = BB1;
        BlocksF2[MergedBB] = BB2;

        IRBuilder<> Builder(MergedBB);
        for (Instruction &I : *BB1) {
          if (isa<PHINode>(&I)) {
            VMap[&I] = Builder.CreatePHI(I.getType(), 0);
          }
        }
        for (Instruction &I : *BB2) {
          if (isa<PHINode>(&I)) {
            VMap[&I] = Builder.CreatePHI(I.getType(), 0);
          }
        }
      } // end if(instruction)-else
    }
  }

  auto ChainBlocks = [](BasicBlock *SrcBB, BasicBlock *TargetBB,
                        Value *IsFunc1) {
    IRBuilder<> Builder(SrcBB);
    if (SrcBB->getTerminator() == nullptr) {
      Builder.CreateBr(TargetBB);
    } else {
      BranchInst *Br = dyn_cast<BranchInst>(SrcBB->getTerminator());
      assert(Br && Br->isUnconditional() &&
             "Branch should be unconditional at this point!");
      BasicBlock *SuccBB = Br->getSuccessor(0);
      // if (SuccBB != TargetBB) {
      Br->eraseFromParent();
      Builder.CreateCondBr(IsFunc1, SuccBB, TargetBB);
      //}
    }
  };

  auto ProcessEachFunction = [&](BlockListType &Blocks,
                                 std::map<BasicBlock *, BasicBlock *> &BlocksFX,
                                 Value *IsFunc1) {
    for (BasicBlock &BB : Blocks) {
      BasicBlock *LastMergedBB = nullptr;
      BasicBlock *NewBB = nullptr;
      bool HasBeenMerged = MaterialNodes.find(&BB) != MaterialNodes.end();
      if (HasBeenMerged) {
        LastMergedBB = MaterialNodes[&BB];
      } else {
        std::string BBName = std::string("src.bb");
        NewBB =
            BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);
        VMap[&BB] = NewBB;
        BlocksFX[NewBB] = &BB;

        IRBuilder<> Builder(NewBB);
        for (Instruction &I : BB) {
          if (isa<PHINode>(&I)) {
            VMap[&I] = Builder.CreatePHI(I.getType(), 0);
          }
        }
      }
      for (Instruction &I : BB) {
        if (isa<LandingPadInst>(&I))
          continue;
        if (isa<PHINode>(&I))
          continue;

        bool HasBeenMerged = MaterialNodes.find(&I) != MaterialNodes.end();
        if (HasBeenMerged) {
          BasicBlock *NodeBB = MaterialNodes[&I];
          if (LastMergedBB) {
            ChainBlocks(LastMergedBB, NodeBB, IsFunc1);
          } else {
            IRBuilder<> Builder(NewBB);
            Builder.CreateBr(NodeBB);
          }
          // end keep track
          LastMergedBB = NodeBB;
        } else {
          if (LastMergedBB) {
            std::string BBName = std::string("split.bb");
            NewBB = BasicBlock::Create(MergedFunc->getContext(), BBName,
                                       MergedFunc);
            ChainBlocks(LastMergedBB, NewBB, IsFunc1);
            BlocksFX[NewBB] = &BB;
          }
          LastMergedBB = nullptr;

          IRBuilder<> Builder(NewBB);
          Instruction *NewI = CloneInst(Builder, MergedFunc, &I);
          VMap[&I] = NewI;
        }
      }
    }
  };
  ProcessEachFunction(Blocks1, BlocksF1, IsFunc1);
  ProcessEachFunction(Blocks2, BlocksF2, IsFunc1);

  BasicBlock *BB1 = dyn_cast<BasicBlock>(VMap[EntryBB1]);
  BasicBlock *BB2 = dyn_cast<BasicBlock>(VMap[EntryBB2]);

  BlocksF1[PreBB] = BB1;
  BlocksF2[PreBB] = BB2;

  if (BB1 == BB2) {
    IRBuilder<> Builder(PreBB);
    Builder.CreateBr(BB1);
  } else {
    IRBuilder<> Builder(PreBB);
    Builder.CreateCondBr(IsFunc1, BB1, BB2);
  }
}

template <typename BlockListType>
bool FunctionMerger::SALSSACodeGen<BlockListType>::generate(
    AlignedSequence<Value *> &AlignedSeq, ValueToValueMapTy &VMap,
    const FunctionMergingOptions &Options) {

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.startTimer();
#endif

  LLVMContext &Context = CodeGenerator<BlockListType>::getContext();
  Function *MergedFunc = CodeGenerator<BlockListType>::getMergedFunction();
  Value *IsFunc1 = CodeGenerator<BlockListType>::getFunctionIdentifier();
  Type *ReturnType = CodeGenerator<BlockListType>::getMergedReturnType();
  bool RequiresUnifiedReturn =
      CodeGenerator<BlockListType>::getRequiresUnifiedReturn();
  BasicBlock *EntryBB1 = CodeGenerator<BlockListType>::getEntryBlock1();
  BasicBlock *EntryBB2 = CodeGenerator<BlockListType>::getEntryBlock2();
  BasicBlock *PreBB = CodeGenerator<BlockListType>::getPreBlock();

  Type *RetType1 = CodeGenerator<BlockListType>::getReturnType1();
  Type *RetType2 = CodeGenerator<BlockListType>::getReturnType2();

  Type *IntPtrTy = CodeGenerator<BlockListType>::getIntPtrType();

  BlockListType &Blocks1 = CodeGenerator<BlockListType>::getBlocks1();
  BlockListType &Blocks2 = CodeGenerator<BlockListType>::getBlocks2();

  std::vector<Instruction *> ListSelects;

  std::list<Instruction *> LinearOffendingInsts;
  std::set<Instruction *> OffendingInsts;
  std::map<Instruction *, std::map<Instruction *, unsigned>>
      CoalescingCandidates;

  std::vector<AllocaInst *> Allocas;
  std::map<SelectCacheEntry, Value *> SelectCache;
  // std::map<std::pair<BasicBlock *, BasicBlock *>, BasicBlock *>
  // CacheBBSelect;

  Value *RetUnifiedAddr = nullptr;
  Value *RetAddr1 = nullptr;
  Value *RetAddr2 = nullptr;

  // maps new basic blocks in the merged function to their original
  // correspondents
  std::map<BasicBlock *, BasicBlock *> BlocksF1;
  std::map<BasicBlock *, BasicBlock *> BlocksF2;

  std::map<Value *, BasicBlock *> MaterialNodes;

  CodeGen(Blocks1, Blocks2, EntryBB1, EntryBB2, MergedFunc, IsFunc1, PreBB,
          AlignedSeq, VMap, BlocksF1, BlocksF2, MaterialNodes);

  // errs() << "CodeGen:\n";
  // MergedFunc->dump();

  if (RequiresUnifiedReturn) {
    IRBuilder<> Builder(PreBB);
    RetUnifiedAddr = Builder.CreateAlloca(ReturnType);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetUnifiedAddr));

    RetAddr1 = Builder.CreateAlloca(RetType1);
    RetAddr2 = Builder.CreateAlloca(RetType2);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr1));
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr2));
  }

  // errs() << "LabelOperand Assignment:\n";

  std::set<BranchInst *> XorBrConds;
  // assigning label operands
  for (auto &Entry : AlignedSeq) {
    Instruction *I1 = nullptr;
    Instruction *I2 = nullptr;

    if (Entry.get(0) != nullptr)
      I1 = dyn_cast<Instruction>(Entry.get(0));
    if (Entry.get(1) != nullptr)
      I2 = dyn_cast<Instruction>(Entry.get(1));

    // Skip non-instructions
    if (I1 == nullptr && I2 == nullptr)
      continue;

    if (Entry.match()) {

      Instruction *I = I1;
      if (I1->getOpcode() == Instruction::Ret) {
        I = (I1->getNumOperands() >= I2->getNumOperands()) ? I1 : I2;
      } else {
        assert(I1->getNumOperands() == I2->getNumOperands() &&
               "Num of Operands SHOULD be EQUAL\n");
      }

      Instruction *NewI = dyn_cast<Instruction>(VMap[I]);

      bool Handled = false;

      BranchInst *NewBr = dyn_cast<BranchInst>(NewI);
      if (EnableOperandReordering && NewBr != nullptr &&
          NewBr->isConditional()) {
        BranchInst *Br1 = dyn_cast<BranchInst>(I1);
        BranchInst *Br2 = dyn_cast<BranchInst>(I2);

        BasicBlock *SuccBB10 =
            dyn_cast<BasicBlock>(MapValue(Br1->getSuccessor(0), VMap));
        BasicBlock *SuccBB11 =
            dyn_cast<BasicBlock>(MapValue(Br1->getSuccessor(1), VMap));

        BasicBlock *SuccBB20 =
            dyn_cast<BasicBlock>(MapValue(Br2->getSuccessor(0), VMap));
        BasicBlock *SuccBB21 =
            dyn_cast<BasicBlock>(MapValue(Br2->getSuccessor(1), VMap));

        if (SuccBB10 != nullptr && SuccBB11 != nullptr &&
            SuccBB10 == SuccBB21 && SuccBB20 == SuccBB11) {
          if (Debug)
            errs() << "OptimizationTriggered: Labels of Conditional Branch "
                      "Reordering\n";

          XorBrConds.insert(NewBr);
          NewBr->setSuccessor(0, SuccBB20);
          NewBr->setSuccessor(1, SuccBB21);
          Handled = true;
        }
      }

      if (!Handled) {
        for (unsigned i = 0; i < I->getNumOperands(); i++) {

          Value *F1V = nullptr;
          Value *V1 = nullptr;
          if (i < I1->getNumOperands()) {
            F1V = I1->getOperand(i);
            V1 = MapValue(F1V, VMap);
            // assert(V1!=nullptr && "Mapped value should NOT be NULL!");
            if (V1 == nullptr) {
              if (Debug)
                errs() << "ERROR: Null value mapped: V1 = "
                          "MapValue(I1->getOperand(i), "
                          "VMap);\n";
                // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
              TimeCodeGen.stopTimer();
#endif
              return false;
            }
          } else {
            V1 = GetAnyValue(I2->getOperand(i)->getType());
          }

          Value *F2V = nullptr;
          Value *V2 = nullptr;
          if (i < I2->getNumOperands()) {
            F2V = I2->getOperand(i);
            V2 = MapValue(F2V, VMap);
            // assert(V2!=nullptr && "Mapped value should NOT be NULL!");

            if (V2 == nullptr) {
              if (Debug)
                errs() << "ERROR: Null value mapped: V2 = "
                          "MapValue(I2->getOperand(i), "
                          "VMap);\n";
                // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
              TimeCodeGen.stopTimer();
#endif
              return false;
            }

          } else {
            V2 = GetAnyValue(I1->getOperand(i)->getType());
          }

          assert(V1 != nullptr && "Value should NOT be null!");
          assert(V2 != nullptr && "Value should NOT be null!");

          Value *V = V1; // first assume that V1==V2

          // handling just label operands for now
          if (!isa<BasicBlock>(V))
            continue;

          BasicBlock *F1BB = dyn_cast<BasicBlock>(F1V);
          BasicBlock *F2BB = dyn_cast<BasicBlock>(F2V);

          if (V1 != V2) {
            BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
            BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);

            // auto CacheKey = std::pair<BasicBlock *, BasicBlock *>(BB1, BB2);
            BasicBlock *SelectBB =
                BasicBlock::Create(Context, "bb.select", MergedFunc);
            IRBuilder<> BuilderBB(SelectBB);

            BlocksF1[SelectBB] = I1->getParent();
            BlocksF2[SelectBB] = I2->getParent();

            /*
            if (F1BB->isLandingPad() || F2BB->isLandingPad()) {
              LandingPadInst *LP1 = F1BB->getLandingPadInst();
              LandingPadInst *LP2 = F2BB->getLandingPadInst();
              assert((LP1 != nullptr && LP2 != nullptr) &&
                     "Should be both as per the BasicBlock match!");

              Instruction *NewLP = LP1->clone();
              BuilderBB.Insert(NewLP);

              VMap[LP1] = NewLP;
              VMap[LP2] = NewLP;
            }
            */

            BuilderBB.CreateCondBr(IsFunc1, BB1, BB2);
            // CacheBBSelect[CacheKey] = SelectBB;
            V = SelectBB;
          }

          if (F1BB->isLandingPad() || F2BB->isLandingPad()) {

            LandingPadInst *LP1 = F1BB->getLandingPadInst();
            LandingPadInst *LP2 = F2BB->getLandingPadInst();
            assert((LP1 != nullptr && LP2 != nullptr) &&
                   "Should be both as per the BasicBlock match!");

            BasicBlock *LPadBB =
                BasicBlock::Create(Context, "lpad.bb", MergedFunc);
            IRBuilder<> BuilderBB(LPadBB);

            Instruction *NewLP = LP1->clone();
            BuilderBB.Insert(NewLP);

            BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));

            BlocksF1[LPadBB] = I1->getParent();
            BlocksF2[LPadBB] = I2->getParent();

            VMap[F1BB->getLandingPadInst()] = NewLP;
            VMap[F2BB->getLandingPadInst()] = NewLP;

            V = LPadBB;
          }
          NewI->setOperand(i, V);
        }
      }

    } else {

      auto AssignLabelOperands =
          [&](Instruction *I,
              std::map<BasicBlock *, BasicBlock *> &BlocksReMap) -> bool {
        Instruction *NewI = dyn_cast<Instruction>(VMap[I]);

        IRBuilder<> Builder(NewI);
        for (unsigned i = 0; i < I->getNumOperands(); i++) {

          // handling just label operands for now
          if (!isa<BasicBlock>(I->getOperand(i)))
            continue;
          BasicBlock *FXBB = dyn_cast<BasicBlock>(I->getOperand(i));

          Value *V = MapValue(FXBB, VMap);
          // assert( V!=nullptr && "Mapped value should NOT be NULL!");
          if (V == nullptr)
            return false; // ErrorResponse;

          if (FXBB->isLandingPad()) {

            LandingPadInst *LP = FXBB->getLandingPadInst();
            assert(LP != nullptr && "Should have a landingpad inst!");

            BasicBlock *LPadBB =
                BasicBlock::Create(Context, "lpad.bb", MergedFunc);
            IRBuilder<> BuilderBB(LPadBB);

            Instruction *NewLP = LP->clone();
            BuilderBB.Insert(NewLP);
            VMap[LP] = NewLP;
            BlocksReMap[LPadBB] = I->getParent();

            BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));

            V = LPadBB;
          }

          NewI->setOperand(i, V);
        }
        return true;
      };

      if (I1 != nullptr && !AssignLabelOperands(I1, BlocksF1)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
          // MergedFunc->eraseFromParent();

#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
      if (I2 != nullptr && !AssignLabelOperands(I2, BlocksF2)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
          // MergedFunc->eraseFromParent();

#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
    }
  }

  // errs() << "Operand Assignment:\n";
  // MergedFunc->dump();

  DominatorTree DT(*MergedFunc);

  auto MergeValues = [&](Value *V1, Value *V2,
                         Instruction *InsertPt) -> Value * {
    if (V1 == V2)
      return V1;

    if (V1 == ConstantInt::getTrue(Context) &&
        V2 == ConstantInt::getFalse(Context)) {
      return IsFunc1;
    } else if (V1 == ConstantInt::getFalse(Context) &&
               V2 == ConstantInt::getTrue(Context)) {
      IRBuilder<> Builder(InsertPt);
      return Builder.CreateNot(
          IsFunc1); /// TODO: create a single not(IsFunc1) for each merged
                    /// function that needs it
    }

    Instruction *IV1 = dyn_cast<Instruction>(V1);
    Instruction *IV2 = dyn_cast<Instruction>(V2);

    bool Dom1 = IV1 != nullptr ? DT.dominates(IV1, InsertPt) : true;
    bool Dom2 = IV2 != nullptr ? DT.dominates(IV2, InsertPt) : true;
    if (!Dom1)
      if (OffendingInsts.count(IV1) == 0) {
        OffendingInsts.insert(IV1);
        LinearOffendingInsts.push_back(IV1);
      }
    if (!Dom2)
      if (OffendingInsts.count(IV2) == 0) {
        OffendingInsts.insert(IV2);
        LinearOffendingInsts.push_back(IV2);
      }

    if (IV1 && IV2) {
      // if both IV1 and IV2 are non-merged values
      if (BlocksF2.find(IV1->getParent()) == BlocksF2.end() &&
          BlocksF1.find(IV2->getParent()) == BlocksF1.end()) {
        CoalescingCandidates[IV1][IV2]++;
        CoalescingCandidates[IV2][IV1]++;
      }
    }

    IRBuilder<> Builder(InsertPt);
    Instruction *Sel = (Instruction *)Builder.CreateSelect(IsFunc1, V1, V2);
    ListSelects.push_back(Sel);

    return Sel;
  };

  auto AssignOperands = [&](Instruction *I, bool IsFuncId1) -> bool {
    Instruction *NewI = dyn_cast<Instruction>(VMap[I]);
    IRBuilder<> Builder(NewI);

    if (I->getOpcode() == Instruction::Ret && RequiresUnifiedReturn) {
      Value *V = MapValue(I->getOperand(0), VMap);
      if (V == nullptr) {
        return false; // ErrorResponse;
      }

      Instruction *IV = dyn_cast<Instruction>(V);
      bool Dom =
          IV != nullptr
              ? DT.dominates(
                    IV,
                    NewI) // DT.dominates(IV->getParent(), NewI->getParent())
              : true;
      if (!Dom) {
        if (OffendingInsts.count(IV) == 0) {
          OffendingInsts.insert(IV);
          LinearOffendingInsts.push_back(IV);
        }
        // OffendingInsts.insert(IV);
      }

      if (V->getType() != ReturnType) {
        // Value *Addr = (IsFuncId1 ? RetAddr1 : RetAddr2);
        Value *Addr = Builder.CreateAlloca(V->getType());
        Builder.CreateStore(V, Addr);
        Value *CastedAddr =
            Builder.CreatePointerCast(Addr, RetUnifiedAddr->getType());
        V = Builder.CreateLoad(ReturnType, CastedAddr);
      }
      NewI->setOperand(0, V);
    } else {
      for (unsigned i = 0; i < I->getNumOperands(); i++) {
        if (isa<BasicBlock>(I->getOperand(i)))
          continue;

        Value *V = MapValue(I->getOperand(i), VMap);
        // assert( V!=nullptr && "Mapped value should NOT be NULL!");
        if (V == nullptr) {
          return false; // ErrorResponse;
        }

        Instruction *IV = dyn_cast<Instruction>(V);
        bool Dom = IV == nullptr ? true : DT.dominates(IV, NewI);
        if (!Dom) {
          if (OffendingInsts.count(IV) == 0) {
            OffendingInsts.insert(IV);
            LinearOffendingInsts.push_back(IV);
          }
          // OffendingInsts.insert(IV);
        }

        // Value *CastedV = createCastIfNeeded(V,
        // NewI->getOperand(i)->getType(), Builder, IntPtrTy);
        NewI->setOperand(i, V);
      }
    }

    return true;
  };

  auto AssignPHIOperandsInBlock =
      [&](BasicBlock *BB, std::set<PHINode *> &AllPhis,
          std::map<BasicBlock *, BasicBlock *> &BlocksReMap) -> bool {
    for (Instruction &I : *BB) {
      if (PHINode *PHI = dyn_cast<PHINode>(&I)) {
        PHINode *NewPHI = dyn_cast<PHINode>(VMap[PHI]);

        std::set<int> FoundIndices;

        for (auto It = pred_begin(NewPHI->getParent()),
                  E = pred_end(NewPHI->getParent());
             It != E; It++) {

          BasicBlock *NewPredBB = *It;

          Value *V = nullptr;

          if (BlocksReMap.find(NewPredBB) != BlocksReMap.end()) {
            int Index = PHI->getBasicBlockIndex(BlocksReMap[NewPredBB]);
            if (Index >= 0) {
              V = MapValue(PHI->getIncomingValue(Index), VMap);
              FoundIndices.insert(Index);
            }
          }

          if (V) {
            Instruction *IV = dyn_cast<Instruction>(V);
            bool Dom = IV == nullptr
                           ? true
                           : ((IV == NewPredBB->getTerminator()) ||
                              //(IV->getParent()==NewPredBB) ||
                              DT.dominates(IV, NewPredBB->getTerminator()));
            if (!Dom) {
              if (OffendingInsts.count(IV) == 0) {
                OffendingInsts.insert(IV);
                LinearOffendingInsts.push_back(IV);
              }
              // OffendingInsts.insert(IV);
            }
          } else
            V = GetAnyValue(NewPHI->getType());

          // IRBuilder<> Builder(NewPredBB->getTerminator());
          // Value *CastedV = createCastIfNeeded(V, NewPHI->getType(), Builder,
          // IntPtrTy);
          NewPHI->addIncoming(V, NewPredBB);
        }
        if (FoundIndices.size() != PHI->getNumIncomingValues())
          return false;

        if (NewPHI)
          AllPhis.insert(NewPHI);
      }
    }
    return true;
  };

  for (auto &Entry : AlignedSeq) {
    Instruction *I1 = nullptr;
    Instruction *I2 = nullptr;

    if (Entry.get(0) != nullptr)
      I1 = dyn_cast<Instruction>(Entry.get(0));
    if (Entry.get(1) != nullptr)
      I2 = dyn_cast<Instruction>(Entry.get(1));

    if (I1 == nullptr &&
        I2 == nullptr) { // assigning operands for PHIs in Block

      BasicBlock *BB1 = nullptr;
      BasicBlock *BB2 = nullptr;

      if (Entry.get(0) != nullptr)
        BB1 = dyn_cast<BasicBlock>(Entry.get(0));
      if (Entry.get(1) != nullptr)
        BB2 = dyn_cast<BasicBlock>(Entry.get(1));

      std::set<PHINode *> AllPhis;
      if (BB1 != nullptr && !AssignPHIOperandsInBlock(BB1, AllPhis, BlocksF1)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
          // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
      if (BB2 != nullptr && !AssignPHIOperandsInBlock(BB2, AllPhis, BlocksF2)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
          // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }

    } else if (I1 != nullptr && I2 != nullptr) {

      // Instruction *I1 = dyn_cast<Instruction>(MN->N1->getValue());
      // Instruction *I2 = dyn_cast<Instruction>(MN->N2->getValue());

      Instruction *I = I1;
      if (I1->getOpcode() == Instruction::Ret) {
        I = (I1->getNumOperands() >= I2->getNumOperands()) ? I1 : I2;
      } else {
        assert(I1->getNumOperands() == I2->getNumOperands() &&
               "Num of Operands SHOULD be EQUAL\n");
      }

      Instruction *NewI = dyn_cast<Instruction>(VMap[I]);

      IRBuilder<> Builder(NewI);

      if (EnableOperandReordering && isa<BinaryOperator>(NewI) &&
          I->isCommutative()) {

        BinaryOperator *BO1 = dyn_cast<BinaryOperator>(I1);
        BinaryOperator *BO2 = dyn_cast<BinaryOperator>(I2);
        Value *VL1 = MapValue(BO1->getOperand(0), VMap);
        Value *VL2 = MapValue(BO2->getOperand(0), VMap);
        Value *VR1 = MapValue(BO1->getOperand(1), VMap);
        Value *VR2 = MapValue(BO2->getOperand(1), VMap);
        if (VL1 == VR2 && VL2 != VR2) {
          std::swap(VL2, VR2);
          // CountOpReorder++;
        } else if (VL2 == VR1 && VL1 != VR1) {
          std::swap(VL1, VR1);
        }

        std::vector<std::pair<Value *, Value *>> Vs;
        Vs.push_back(std::pair<Value *, Value *>(VL1, VL2));
        Vs.push_back(std::pair<Value *, Value *>(VR1, VR2));

        for (unsigned i = 0; i < Vs.size(); i++) {
          Value *V1 = Vs[i].first;
          Value *V2 = Vs[i].second;

          Value *V = MergeValues(V1, V2, NewI);
          if (V == nullptr) {
            if (Debug) {
              errs() << "Could Not select:\n";
              errs() << "ERROR: Value should NOT be null\n";
            }
            // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
            TimeCodeGen.stopTimer();
#endif
            return false; // ErrorResponse;
          }

          // TODO: cache the created instructions
          // Value *CastedV = CreateCast(Builder, V,
          // NewI->getOperand(i)->getType());
          Value *CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(),
                                              Builder, IntPtrTy);
          NewI->setOperand(i, CastedV);
        }
      } else {
        for (unsigned i = 0; i < I->getNumOperands(); i++) {
          if (isa<BasicBlock>(I->getOperand(i)))
            continue;

          Value *V1 = nullptr;
          if (i < I1->getNumOperands()) {
            V1 = MapValue(I1->getOperand(i), VMap);
            // assert(V1!=nullptr && "Mapped value should NOT be NULL!");
            if (V1 == nullptr) {
              if (Debug)
                errs() << "ERROR: Null value mapped: V1 = "
                          "MapValue(I1->getOperand(i), "
                          "VMap);\n";
                // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
              TimeCodeGen.stopTimer();
#endif
              return false;
            }
          } else {
            V1 = GetAnyValue(I2->getOperand(i)->getType());
          }

          Value *V2 = nullptr;
          if (i < I2->getNumOperands()) {
            V2 = MapValue(I2->getOperand(i), VMap);
            // assert(V2!=nullptr && "Mapped value should NOT be NULL!");

            if (V2 == nullptr) {
              if (Debug)
                errs() << "ERROR: Null value mapped: V2 = "
                          "MapValue(I2->getOperand(i), "
                          "VMap);\n";
                // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
              TimeCodeGen.stopTimer();
#endif
              return false;
            }

          } else {
            V2 = GetAnyValue(I1->getOperand(i)->getType());
          }

          assert(V1 != nullptr && "Value should NOT be null!");
          assert(V2 != nullptr && "Value should NOT be null!");

          Value *V = MergeValues(V1, V2, NewI);
          if (V == nullptr) {
            if (Debug) {
              errs() << "Could Not select:\n";
              errs() << "ERROR: Value should NOT be null\n";
            }
            // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
            TimeCodeGen.stopTimer();
#endif
            return false; // ErrorResponse;
          }

          // Value *CastedV = createCastIfNeeded(V,
          // NewI->getOperand(i)->getType(), Builder, IntPtrTy);
          NewI->setOperand(i, V);

        } // end for operands
      }
    } // end if isomorphic
    else {
      // PDGNode *N = MN->getUniqueNode();
      if (I1 != nullptr && !AssignOperands(I1, true)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
          // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
      if (I2 != nullptr && !AssignOperands(I2, false)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
          // MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
    } // end 'if-else' non-isomorphic

  } // end for nodes

  // errs() << "ValueOperand Assignment:\n";
  // MergedFunc->dump();

  for (BranchInst *NewBr : XorBrConds) {
    IRBuilder<> Builder(NewBr);
    Value *XorCond = Builder.CreateXor(NewBr->getCondition(), IsFunc1);
    NewBr->setCondition(XorCond);
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif

  errs() << "NumSelects: " << ListSelects.size() << "\n";
  if (ListSelects.size() > MaxNumSelection) {
    errs() << "Bailing out: Operand selection threshold\n";
    return false;
  }

#ifdef TIME_STEPS_DEBUG
  TimeSimplify.startTimer();
#endif

  auto StoreInstIntoAddr = [](Instruction *IV, Value *Addr) {
    IRBuilder<> Builder(IV->getParent());
    if (IV->isTerminator()) {
      BasicBlock *SrcBB = IV->getParent();
      if (InvokeInst *II = dyn_cast<InvokeInst>(IV)) {
        BasicBlock *DestBB = II->getNormalDest();

        Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
        // create PHI
        PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
        for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
             PredIt != PredE; PredIt++) {
          BasicBlock *PredBB = *PredIt;
          if (PredBB == SrcBB) {
            PHI->addIncoming(IV, PredBB);
          } else {
            PHI->addIncoming(GetAnyValue(IV->getType()), PredBB);
          }
        }
        Builder.CreateStore(PHI, Addr);
      } else {
        for (auto SuccIt = succ_begin(SrcBB), SuccE = succ_end(SrcBB);
             SuccIt != SuccE; SuccIt++) {
          BasicBlock *DestBB = *SuccIt;

          Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
          // create PHI
          PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
          for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
               PredIt != PredE; PredIt++) {
            BasicBlock *PredBB = *PredIt;
            if (PredBB == SrcBB) {
              PHI->addIncoming(IV, PredBB);
            } else {
              PHI->addIncoming(GetAnyValue(IV->getType()), PredBB);
            }
          }
          Builder.CreateStore(PHI, Addr);
        }
      }
    } else {
      Instruction *LastI = nullptr;
      Instruction *InsertPt = nullptr;
      for (Instruction &I : *IV->getParent()) {
        InsertPt = &I;
        if (LastI == IV)
          break;
        LastI = &I;
      }
      if (isa<PHINode>(InsertPt) || isa<LandingPadInst>(InsertPt)) {
        // Builder.SetInsertPoint(&*IV->getParent()->getFirstInsertionPt());
        Builder.SetInsertPoint(IV->getParent()->getTerminator());
      } else
        Builder.SetInsertPoint(InsertPt);

      Builder.CreateStore(IV, Addr);
    }
  };

  auto MemfyInst = [&](std::set<Instruction *> &InstSet) -> AllocaInst * {
    if (InstSet.empty())
      return nullptr;
    IRBuilder<> Builder(&*PreBB->getFirstInsertionPt());
    AllocaInst *Addr = Builder.CreateAlloca((*InstSet.begin())->getType());

    for (Instruction *I : InstSet) {
      for (auto UIt = I->use_begin(), E = I->use_end(); UIt != E;) {
        Use &UI = *UIt;
        UIt++;

        Instruction *User = cast<Instruction>(UI.getUser());

        if (PHINode *PHI = dyn_cast<PHINode>(User)) {
          /// TODO: make sure getOperandNo is getting the correct incoming edge
          IRBuilder<> Builder(
              PHI->getIncomingBlock(UI.getOperandNo())->getTerminator());
          UI.set(Builder.CreateLoad(Addr));
        } else {
          IRBuilder<> Builder(User);
          UI.set(Builder.CreateLoad(Addr));
        }
      }
    }

    for (Instruction *I : InstSet)
      StoreInstIntoAddr(I, Addr);

    return Addr;
  };

  auto isCoalescingProfitable = [&](Instruction *I1, Instruction *I2) -> bool {
    std::set<BasicBlock *> BBSet1;
    std::set<BasicBlock *> UnionBB;
    for (User *U : I1->users()) {
      if (Instruction *UI = dyn_cast<Instruction>(U)) {
        BasicBlock *BB1 = UI->getParent();
        BBSet1.insert(BB1);
        UnionBB.insert(BB1);
      }
    }

    unsigned Intersection = 0;
    for (User *U : I2->users()) {
      if (Instruction *UI = dyn_cast<Instruction>(U)) {
        BasicBlock *BB2 = UI->getParent();
        UnionBB.insert(BB2);
        if (BBSet1.find(BB2) != BBSet1.end())
          Intersection++;
      }
    }

    const float Threshold = 0.7;
    return (float(Intersection) / float(UnionBB.size()) > Threshold);
  };

  auto OptimizeCoalescing =
      [&](Instruction *I, std::set<Instruction *> &InstSet,
          std::map<Instruction *, std::map<Instruction *, unsigned>>
              &CoalescingCandidates,
          std::set<Instruction *> &Visited) {
        Instruction *OtherI = nullptr;
        unsigned Score = 0;
        if (CoalescingCandidates.find(I) != CoalescingCandidates.end()) {
          for (auto &Pair : CoalescingCandidates[I]) {
            if (Pair.second > Score &&
                Visited.find(Pair.first) == Visited.end()) {
              if (isCoalescingProfitable(I, Pair.first)) {
                OtherI = Pair.first;
                Score = Pair.second;
              }
            }
          }
        }
        /*
        if (OtherI==nullptr) {
          for (Instruction *OI : OffendingInsts) {
            if (OI->getType()!=I->getType()) continue;
            if (Visited.find(OI)!=Visited.end()) continue;
            if (CoalescingCandidates.find(OI)!=CoalescingCandidates.end())
        continue; if( (BlocksF2.find(I->getParent())==BlocksF2.end() &&
        BlocksF1.find(OI->getParent())==BlocksF1.end()) ||
                (BlocksF2.find(OI->getParent())==BlocksF2.end() &&
        BlocksF1.find(I->getParent())==BlocksF1.end()) ) { OtherI = OI; break;
            }
          }
        }
        */
        if (OtherI) {
          InstSet.insert(OtherI);
          // errs() << "Coalescing: " << GetValueName(I->getParent()) << ":";
          // I->dump(); errs() << "With: " << GetValueName(OtherI->getParent())
          // << ":"; OtherI->dump();
        }
      };

  /*
  //simplification
  if (MergedFunc!=nullptr) {
    //MergedFunc->dump();
    std::set<BasicBlock *> DeleteBlocks;

    auto FuseBBsForward = [&](BasicBlock *BB) {
      BranchInst *Br = dyn_cast<BranchInst>(BB->getTerminator());
      if (Br==nullptr) return;

      if (!Br->isConditional() || Br->getSuccessor(0)==Br->getSuccessor(1)) {
        BasicBlock *SuccBB = Br->getSuccessor(0);

        if (SuccBB->hasAddressTaken()) return;

        std::set<BasicBlock*> Preds;
        for (auto It = pred_begin(SuccBB), E = pred_end(SuccBB); It!=E; It++) {
          Preds.insert(*It);
        }

        if (Preds.size()!=1) return;

        IRBuilder<> Builder(Br);
        SuccBB->replaceAllUsesWith(BB);
        SuccBB->replaceSuccessorsPhiUsesWith(BB);

        for (auto It = SuccBB->begin(), E = SuccBB->end(); It!=E; ) {
          Instruction *I = &*It;
          It++;

          I->removeFromParent();
          Builder.Insert(I);
        }

        Br->eraseFromParent();
        DeleteBlocks.insert(SuccBB);
      }
    };

    auto FuseBBsBackward = [](BasicBlock *SuccBB) -> bool {
      if (SuccBB->hasAddressTaken()) return false;

      std::set<BasicBlock*> Preds;
      for (auto It = pred_begin(SuccBB), E = pred_end(SuccBB); It!=E; It++) {
        Preds.insert(*It);
      }

      if (Preds.size()!=1) return false;

      BasicBlock *BB = *Preds.begin();

      BranchInst *Br = dyn_cast<BranchInst>(BB->getTerminator());
      if (Br==nullptr) return false;

      if (!Br->isConditional() || Br->getSuccessor(0)==Br->getSuccessor(1)) {

        IRBuilder<> Builder(Br);
        SuccBB->replaceAllUsesWith(BB);
        SuccBB->replaceSuccessorsPhiUsesWith(BB);

        for (auto It = SuccBB->begin(), E = SuccBB->end(); It!=E; ) {
          Instruction *I = &*It;
          It++;

          I->removeFromParent();
          Builder.Insert(I);
        }

        Br->eraseFromParent();
        return true;
      }
      return false;
    };

    for (auto &Pair : MaterialNodes) if (!isa<BasicBlock>(Pair.first) &&
  FuseBBsBackward(Pair.second)) DeleteBlocks.insert(Pair.second); for
  (BasicBlock *BB : DeleteBlocks) BB->eraseFromParent();
    //MergedFunc->dump();
  }
  */

  if (MergedFunc != nullptr) {
    // errs() << "Allocas: " << Allocas.size() << " ";
    // errs() << "Offending: " << OffendingInsts.size() << " ";
    if (Allocas.size() > 750 || OffendingInsts.size() > 750) {
      if (Debug)
        errs() << "Bailing out\n";
#ifdef TIME_STEPS_DEBUG
      TimeSimplify.stopTimer();
#endif
      return false;
    } else {
      std::set<Instruction *> Visited;
      for (Instruction *I : LinearOffendingInsts) {
        if (Visited.find(I) != Visited.end())
          continue;

        std::set<Instruction *> InstSet;
        InstSet.insert(I);

        // Create a coalescing group in InstSet
        if (EnableSALSSACoalescing)
          OptimizeCoalescing(I, InstSet, CoalescingCandidates, Visited);

        for (Instruction *OtherI : InstSet)
          Visited.insert(OtherI);

        AllocaInst *Addr = MemfyInst(InstSet);
        if (Addr)
          Allocas.push_back(Addr);
      }

      // errs() << "Fixed Domination:\n";
      // MergedFunc->dump();

#ifdef OPTIMIZE_SALSSA_CODEGEN
      DominatorTree DT(*MergedFunc);
      PromoteMemToReg(Allocas, DT, nullptr);

      if (verifyFunction(*MergedFunc)) {
#ifdef TIME_STEPS_DEBUG
        TimeSimplify.stopTimer();
#endif
        return false;
      }
      // errs() << "Mem2Reg:\n";
      // MergedFunc->dump();

      // errs() << "PostProcessing:\n";
      postProcessFunction(*MergedFunc);
// MergedFunc->dump();
#endif
    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeSimplify.stopTimer();
#endif

  return MergedFunc != nullptr;
}
