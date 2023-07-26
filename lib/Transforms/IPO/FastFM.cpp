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
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/IPO/FastFM.h"

#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
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
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Analysis/IteratedDominanceFrontier.h"
#include "llvm/Analysis/InstructionSimplify.h"

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

#include <cstdlib>
#include <fstream>

#include <algorithm>
#include <list>
#include <unordered_set>
#include <unordered_map>

#include <limits.h>

#include <functional>
#include <queue>
#include <vector>

#include <algorithm>
#include <stdlib.h>
#include <time.h>

#define DEBUG_TYPE "MyFuncMerge"

#define ENABLE_DEBUG_CODE

//#define FMSA_USE_JACCARD
//#define FINGERPRINT_USE_TYPE

#define TIME_STEPS_DEBUG

using namespace llvm;
using namespace fastfm;

//#ifdef TIME_STEPS_DEBUG
namespace fastfmglobs {
Timer TimeAlign("Merge::Align", "Merge::Align");
Timer TimeParam("Merge::Param", "Merge::Param");
Timer TimeCodeGen("Merge::CodeGen", "Merge::CodeGen");
Timer TimeCodeGenFix("Merge::CodeGenFix", "Merge::CodeGenFix");

Timer TimePreProcess("Merge::Preprocess", "Merge::Preprocess");
Timer TimeLin("Merge::Lin", "Merge::Lin");
Timer TimeRank("Merge::Rank", "Merge::Rank");
Timer TimeUpdate("Merge::Update", "Merge::Update");

int CountBinOps = 0;
int CountOpReorder = 0;
}
//#endif

using namespace fastfmglobs;

static cl::opt<unsigned> ExplorationThreshold(
    "fastfm-explore", cl::init(1), cl::Hidden,
    cl::desc("Exploration threshold of evaluated functions"));


static cl::opt<unsigned> RankingThreshold(
    "fastfm-ranking-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of how many candidates should be ranked"));


static cl::opt<int> MergingOverheadThreshold(
    "fastfm-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of allowed overhead for merging function"));

static cl::opt<bool>
    MaxParamScore("fastfm-max-param", cl::init(true), cl::Hidden,
                  cl::desc("Maximizing the score for merging parameters"));

static cl::opt<bool> Debug("fastfm-debug", cl::init(true), cl::Hidden,
                           cl::desc("Outputs debug information"));

static cl::opt<bool> Verbose("fastfm-verbose", cl::init(false),
                             cl::Hidden, cl::desc("Outputs debug information"));

static cl::opt<bool>
    IdenticalType("fastfm-identic-type", cl::init(true), cl::Hidden,
                  cl::desc("Match only values with identical types"));

static cl::opt<bool> ApplySimilarityHeuristic(
    "fastfm-similarity-pruning", cl::init(true), cl::Hidden,
    cl::desc("Prune the candidates based on their fingerprint similarity"));


static cl::opt<bool>
    EnableUnifiedReturnType("fastfm-unify-return", cl::init(false), cl::Hidden,
                  cl::desc("Enable unified return types"));

static cl::opt<bool>
    EnableOperandReordering("fastfm-operand-reorder", cl::init(true), cl::Hidden,
                  cl::desc("Enable operand reordering"));

static cl::opt<bool>
    HasWholeProgram("fastfm-whole-program", cl::init(false), cl::Hidden,
                  cl::desc("Function merging applied on whole program"));

static cl::opt<bool>
    EnablePHICoalescing("fastfm-coalescing", cl::init(true), cl::Hidden,
                  cl::desc("Enable phi-node coalescing during SSA reconstruction"));

static cl::opt<bool> ReuseMergedFunctions (
    "fastfm-reuse-merges", cl::init(true), cl::Hidden,
    cl::desc("Try to reuse merged functions for another merge operation"));

static std::string GetValueName(const Value *V);

FunctionMergeResult MergeFunctions(Function *F1, Function *F2,
 const FunctionMergingOptions &Options) {
  if (F1->getParent()!=F2->getParent()) return FunctionMergeResult(F1,F2,nullptr);
  FunctionMerger Merger(F1->getParent());
 std::vector<MatchingBlocks> AlignedBlocks;
  return Merger.merge(F1,F2,"",AlignedBlocks,Options);
}

static bool CmpNumbers(uint64_t L, uint64_t R) {
  return L==R;
}

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
static bool CmpTypes(Type *TyL, Type *TyR, const DataLayout *DL) {
  PointerType *PTyL = dyn_cast<PointerType>(TyL);
  PointerType *PTyR = dyn_cast<PointerType>(TyR);

  //const DataLayout &DL = FnL->getParent()->getDataLayout();
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
      if (int Res = CmpTypes(STyL->getElementType(i), STyR->getElementType(i), DL))
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
  case Type::FixedVectorTyID:
  case Type::ScalableVectorTyID: {
    auto *STyL = cast<VectorType>(TyL);
    auto *STyR = cast<VectorType>(TyR);
    if (STyL->getElementCount().isScalable() !=
        STyR->getElementCount().isScalable())
      return CmpNumbers(STyL->getElementCount().isScalable(),
                        STyR->getElementCount().isScalable());
    if (STyL->getElementCount() != STyR->getElementCount())
      return CmpNumbers(STyL->getElementCount().getKnownMinValue(),
                        STyR->getElementCount().getKnownMinValue());
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL);
  }
  }
}

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
bool FunctionMerger::areTypesEquivalent(Type *Ty1, Type *Ty2, const DataLayout *DL, const FunctionMergingOptions &Options) {
 if (Ty1 == Ty2)
   return true;
 if (Options.IdenticalTypesOnly)
   return false;

 return CmpTypes(Ty1, Ty2, DL);
}

static bool matchIntrinsicCalls(Intrinsic::ID ID, const CallBase *CI1,
                                const CallBase *CI2) {
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
    //is_zero_undef argument of bit counting intrinsics must be a constant int
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
    //isvolatile argument of memory intrinsics must be a constant int
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

    return (ElementSizeCI1!=nullptr && ElementSizeCI1==ElementSizeCI2);
  }
  case Intrinsic::gcroot:
  case Intrinsic::gcwrite:
  case Intrinsic::gcread:
    //llvm.gcroot parameter #2 must be a constant.
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::init_trampoline:
    break;
  case Intrinsic::prefetch:
    //arguments #2 and #3 in llvm.prefetch must be constants
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
    //size argument of memory use markers must be a constant integer
    return CI1->getArgOperand(0) == CI2->getArgOperand(0);
  case Intrinsic::invariant_end:
    //llvm.invariant.end parameter #2 must be a constant integer
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

//bool FunctionMerger::matchLandingPad(LandingPadInst *LP1, LandingPadInst *LP2) {
static  bool matchLandingPad(LandingPadInst *LP1, LandingPadInst *LP2) {
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
         LI1->getAlign() == LI2->getAlign() &&
         LI1->getOrdering() == LI2->getOrdering();
}

static bool matchStoreInsts(const StoreInst *SI1, const StoreInst *SI2) {
  return SI1->isVolatile() == SI2->isVolatile() &&
         SI1->getAlign() == SI2->getAlign() &&
         SI1->getOrdering() == SI2->getOrdering();
}

static bool matchAllocaInsts(const AllocaInst *AI1, const AllocaInst *AI2) {
  if (AI1->getArraySize() != AI2->getArraySize() ||
      AI1->getAlign() != AI2->getAlign())
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

static bool matchGetElementPtrInsts(const GetElementPtrInst *GEP1, const GetElementPtrInst *GEP2) {
  Type *Ty1 = GEP1->getSourceElementType();
  SmallVector<Value*, 16> Idxs1(GEP1->idx_begin(), GEP1->idx_end());

  Type *Ty2 = GEP2->getSourceElementType();
  SmallVector<Value*, 16> Idxs2(GEP2->idx_begin(), GEP2->idx_end());

  if (Ty1!=Ty2) return false;
  if (Idxs1.size()!=Idxs2.size()) return false;

  if (Idxs1.empty())
    return true;

  for (unsigned i = 1; i<Idxs1.size(); i++) {
    Value *V1 = Idxs1[i];
    Value *V2 = Idxs2[i];

    //structs must have constant indices, therefore they must be constants and must be identical when merging
    if (isa<StructType>(Ty1)) {
      if (V1!=V2) return false;
    }
    Ty1 = GetElementPtrInst::getTypeAtIndex(Ty1, V1);
    Ty2 = GetElementPtrInst::getTypeAtIndex(Ty2, V2);
    if (Ty1!=Ty2) return false;
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

  //if (CI1->getCalledFunction()==nullptr) return false;

  if (CI1->getCalledFunction() != CI2->getCalledFunction())
    return false;
 
  if (Function *F = CI1->getCalledFunction()) {
    if (Intrinsic::ID ID = (Intrinsic::ID)F->getIntrinsicID()) {
      if (!matchIntrinsicCalls(ID, CI1, CI2))
        return false;
    }
  }

  return CI1->arg_size() == CI2->arg_size() &&
         CI1->getCallingConv() == CI2->getCallingConv() &&
         CI1->getAttributes() == CI2->getAttributes();
}

static bool matchInvokeInsts(const InvokeInst *II1, const InvokeInst *II2) {
    return matchCallInsts(II1,II2) && II1->getCallingConv() == II2->getCallingConv()
        && II1->getAttributes() == II2->getAttributes()
        && matchLandingPad(II1->getLandingPadInst(), II2->getLandingPadInst());
}

static bool matchInsertValueInsts(const InsertValueInst *IV1, const InsertValueInst *IV2) {
    return IV1->getIndices() == IV2->getIndices();
}

static bool matchExtractValueInsts(const ExtractValueInst *EV1, const ExtractValueInst *EV2) {
    return EV1->getIndices() == EV2->getIndices();
}

static bool matchFenceInsts(const FenceInst *FI1, const FenceInst *FI2) {
    return FI1->getOrdering() == FI2->getOrdering() &&
           FI1->getSyncScopeID() == FI2->getSyncScopeID();
}

bool FunctionMerger::matchInstructions(Instruction *I1, Instruction *I2, const FunctionMergingOptions &Options) {

  if (I1->getOpcode() != I2->getOpcode()) return false;

  //Returns are special cases that can differ in the number of operands
  if (I1->getOpcode() == Instruction::Ret)
    return true;

  if (I1->getNumOperands() != I2->getNumOperands())
    return false;

  const DataLayout *DL = &I1->getParent()->getParent()->getParent()->getDataLayout();

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
      sameType = sameType && areTypesEquivalent(I1->getOperand(i)->getType(),
                                              I2->getOperand(i)->getType(), DL, Options);
    }
  }
  if (!sameType)
    return false;

  switch (I1->getOpcode()) {
  //case Instruction::Br: return false; //{ return (I1->getNumOperands()==1); }

  //#define MatchCaseInst(Kind, I1, I2) case Instruction::#Kind 

  case Instruction::Load: return matchLoadInsts(dyn_cast<LoadInst>(I1), dyn_cast<LoadInst>(I2));
  case Instruction::Store: return matchStoreInsts(dyn_cast<StoreInst>(I1), dyn_cast<StoreInst>(I2));
  case Instruction::Alloca: return matchAllocaInsts(dyn_cast<AllocaInst>(I1), dyn_cast<AllocaInst>(I2));
  case Instruction::GetElementPtr: 
    return matchGetElementPtrInsts(dyn_cast<GetElementPtrInst>(I1), dyn_cast<GetElementPtrInst>(I2));
  case Instruction::Switch: return matchSwitchInsts(dyn_cast<SwitchInst>(I1), dyn_cast<SwitchInst>(I2));
  case Instruction::Call: return matchCallInsts(dyn_cast<CallInst>(I1), dyn_cast<CallInst>(I2));
  case Instruction::Invoke: return matchInvokeInsts(dyn_cast<InvokeInst>(I1), dyn_cast<InvokeInst>(I2));
  case Instruction::InsertValue: return matchInsertValueInsts(dyn_cast<InsertValueInst>(I1), dyn_cast<InsertValueInst>(I2));
  case Instruction::ExtractValue: return matchExtractValueInsts(dyn_cast<ExtractValueInst>(I1), dyn_cast<ExtractValueInst>(I2));
  case Instruction::Fence: return matchFenceInsts(dyn_cast<FenceInst>(I1), dyn_cast<FenceInst>(I2));
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
      if (!isa<OverflowingBinaryOperator>(I2)) return false;
      if (I1->hasNoUnsignedWrap()!=I2->hasNoUnsignedWrap()) return false;
      if (I1->hasNoSignedWrap()!=I2->hasNoSignedWrap()) return false;
    }
    if (isa<PossiblyExactOperator>(I1)) {
      if (!isa<PossiblyExactOperator>(I2)) return false;
      if (I1->isExact()!=I2->isExact()) return false;
    }
    if (isa<FPMathOperator>(I1)) {
      if (!isa<FPMathOperator>(I2)) return false;
      if (I1->isFast()!=I2->isFast()) return false;
      if (I1->hasAllowReassoc()!=I2->hasAllowReassoc()) return false;
      if (I1->hasNoNaNs()!=I2->hasNoNaNs()) return false;
      if (I1->hasNoInfs()!=I2->hasNoInfs()) return false;
      if (I1->hasNoSignedZeros()!=I2->hasNoSignedZeros()) return false;
      if (I1->hasAllowReciprocal()!=I2->hasAllowReciprocal()) return false;
      if (I1->hasAllowContract()!=I2->hasAllowContract()) return false;
      if (I1->hasApproxFunc()!=I2->hasApproxFunc()) return false;
    }
  }

  return true;
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
      if (!matchLandingPad(LP1, LP2)) return false;
    }
    
    auto It1 = BB1->begin();
    auto It2 = BB2->begin();

    while(It1!=BB1->end() && (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1))) It1++;
    while(It2!=BB2->end() && (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2))) It2++;

    while (It1!=BB1->end() && It2!=BB2->end()) {
      Instruction *I1 = &*It1;
      Instruction *I2 = &*It2;

      if (!matchInstructions(I1,I2)) return false;
      
      It1++;
      It2++;
    }

    if (It1!=BB1->end() || It2!=BB2->end()) return false;
    
    return true;
  }
  return false;
}

bool FunctionMerger::validMergeTypes(Function *F1, Function *F2, const FunctionMergingOptions &Options) {
  bool EquivTypes = areTypesEquivalent(F1->getReturnType(), F2->getReturnType(), DL, 
                                       Options);
  if (!EquivTypes &&
      !F1->getReturnType()->isVoidTy() && !F2->getReturnType()->isVoidTy()) {
      return false;
  }
  return true;
}

static bool validMergePair(Function *F1, Function *F2) {
  if (!HasWholeProgram && (F1->hasAvailableExternallyLinkage() ||
      F2->hasAvailableExternallyLinkage())) return false;

  if (!HasWholeProgram && (F1->hasLinkOnceLinkage() ||
      F2->hasLinkOnceLinkage())) return false;

  //if (!F1->getSection().equals(F2->getSection())) return false;
//  if (F1->hasSection()!=F2->hasSection()) return false;
//  if (F1->hasSection() && !F1->getSection().equals(F2->getSection())) return false;

  //if (F1->hasComdat()!=F2->hasComdat()) return false;
  //if (F1->hasComdat() && F1->getComdat() != F2->getComdat()) return false;
  
  if (F1->hasPersonalityFn()!=F2->hasPersonalityFn()) return false;
  if (F1->hasPersonalityFn()) {
    Constant *PersonalityFn1 = F1->getPersonalityFn();
    Constant *PersonalityFn2 = F2->getPersonalityFn();
    if (PersonalityFn1 != PersonalityFn2) return false;
  }
  
  return true;
}

static void MergeArguments(LLVMContext &Context, Function *F1, Function *F2,
  std::vector<MatchingBlocks> &AlignedBlocks,
  std::map<unsigned, unsigned> &ParamMap1, std::map<unsigned, unsigned> &ParamMap2, std::vector<Type *> &Args, const FunctionMergingOptions &Options) {

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

  auto AttrList1 = F1->getAttributes();
  auto AttrList2 = F2->getAttributes();

  // merge arguments from Function2 with Function1
  ArgId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {

    std::map<unsigned, int> MatchingScore;
    // first try to find an argument with the same name/type
    // otherwise try to match by type only
    for (unsigned i = 0; i < ArgsList1.size(); i++) {
      if (ArgsList1[i]->getType() == (*I).getType()) {

        auto AttrSet1 = AttrList1.getParamAttrs(ArgsList1[i]->getArgNo());
        auto AttrSet2 = AttrList2.getParamAttrs((*I).getArgNo());
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
    }

    
    if (MatchingScore.size() > 0) { // maximize scores
      for (auto &MB : AlignedBlocks) {
        BasicBlock *BB1 = MB[0];
        BasicBlock *BB2 = MB[1];
	if (BB1==nullptr || BB2==nullptr) continue;

        auto It1 = BB1->begin();
        auto It2 = BB2->begin();

        while(isa<PHINode>(*It1) || isa<LandingPadInst>(*It1)) It1++;
        while(isa<PHINode>(*It2) || isa<LandingPadInst>(*It2)) It2++;

        while (It1!=BB1->end() && It2!=BB2->end()) {
          Instruction *I1 = &*It1;
          Instruction *I2 = &*It2;

          for (unsigned i = 0; i < I1->getNumOperands(); i++) {
            for (auto KV : MatchingScore) {
              if (I1->getOperand(i) == ArgsList1[KV.first]) {
                if (i < I2->getNumOperands() && I2->getOperand(i) == &(*I)) {
                  MatchingScore[KV.first]++;
                }
              }
            }
          }

          It1++;
          It2++;
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

static void SetFunctionAttributes(Function *F1, Function *F2, Function *MergedFunc) {
  unsigned MaxAlignment = std::max(F1->getAlignment(), F2->getAlignment());
  if (F1->getAlignment()!=F2->getAlignment()) {
  if (Debug) errs() << "WARNING: different function alignment!\n";
  }
  if (MaxAlignment) MergedFunc->setAlignment(Align(MaxAlignment));

  if (F1->getCallingConv() == F2->getCallingConv()) {
    MergedFunc->setCallingConv(F1->getCallingConv());
  } else {
    if (Debug) errs() << "WARNING: different calling convention!\n";
    //MergedFunc->setCallingConv(CallingConv::Fast);
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
    if (Debug) errs() << "WARNING: different subprograms!\n";
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
#ifdef LLVM_ENABLE_DUMP
      PersonalityFn1->dump();
      PersonalityFn2->dump();
#endif
      //errs() << "ERROR: different personality function!\n";
      if (Debug) errs() << "WARNING: different personality function!\n";
    }
  } else if (F1->hasPersonalityFn()) {
    //errs() << "Only F1 has PersonalityFn\n";
    // TODO: check if this is valid: merge function with personality with function without it
    MergedFunc->setPersonalityFn(F1->getPersonalityFn());
    if (Debug) errs() << "WARNING: only one personality function!\n";
  } else if (F2->hasPersonalityFn()) {
    //errs() << "Only F2 has PersonalityFn\n";
    // TODO: check if this is valid: merge function with personality with function without it
    MergedFunc->setPersonalityFn(F2->getPersonalityFn());
    if (Debug) errs() << "WARNING: only one personality function!\n";
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
    //errs() << "Only F1 has Comdat\n";
    MergedFunc->setComdat(F1->getComdat()); // TODO: check if this is valid:
                                            // merge function with comdat with
                                            // function without it
    if (Debug) errs() << "WARNING: only one comdat!\n";
  } else if (F2->hasComdat()) {
    //errs() << "Only F2 has Comdat\n";
    MergedFunc->setComdat(F2->getComdat()); // TODO: check if this is valid:
                                            // merge function with comdat with
                                            // function without it
    if (Debug) errs() << "WARNING: only one comdat!\n";
  }

  if (F1->hasSection()) {
    MergedFunc->setSection(F1->getSection());
  }

}

static Function *RemoveFuncIdArg(Function *F, std::vector<Argument *> &ArgsList) {

   // Start by computing a new prototype for the function, which is the same as
   // the old function, but doesn't have isVarArg set.
   FunctionType *FTy = F->getFunctionType();

   std::vector<Type *> NewArgs;
   for (unsigned i = 1; i < ArgsList.size(); i++) {
     NewArgs.push_back(ArgsList[i]->getType());
   }
   ArrayRef<llvm::Type *> Params(NewArgs);

   //std::vector<Type *> Params(FTy->param_begin(), FTy->param_end());
   FunctionType *NFTy = FunctionType::get(FTy->getReturnType(), Params, false);
   //unsigned NumArgs = Params.size();
 
   // Create the new function body and insert it into the module...
   Function *NF = Function::Create(NFTy, F->getLinkage());

   NF->copyAttributesFrom(F);

   if (F->getAlignment())
    NF->setAlignment(Align(F->getAlignment()));
   NF->setCallingConv(F->getCallingConv());
   //NF->setLinkage(F->getLinkage());
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
   NF->splice(NF->begin(), F);

   std::vector<Argument *> NewArgsList;
   for (Argument &arg : NF->args()) {
     NewArgsList.push_back(&arg);
   }

   // Loop over the argument list, transferring uses of the old arguments over to
   // the new arguments, also transferring over the names as well.  While we're at
   // it, remove the dead arguments from the DeadArguments list.
   /*
   for (Function::arg_iterator I = F->arg_begin(), E = F->arg_end(),
        I2 = NF->arg_begin(); I != E; ++I, ++I2) {
     // Move the name and users over to the new version.
     I->replaceAllUsesWith(&*I2);
     I2->takeName(&*I);
   }
   */

   for (unsigned i = 0; i<NewArgsList.size(); i++) {
     ArgsList[i+1]->replaceAllUsesWith(NewArgsList[i]);
     NewArgsList[i]->takeName(ArgsList[i+1]);
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

static Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder, Type *IntPtrTy, const FunctionMergingOptions &Options = {});

/*
bool CodeGenerator(Value *IsFunc1, BasicBlock *EntryBB1, BasicBlock *EntryBB2, BasicBlock *PreBB,
                   std::list<std::pair<Value *, Value *>> &AlignedInsts,
                   ValueToValueMapTy &VMap, Function *MergedFunc,
Type *RetType1, Type *RetType2, Type *ReturnType, bool RequiresUnifiedReturn, LLVMContext &Context, Type *IntPtrTy, const FunctionMergingOptions &Options = {}) {
*/

template<typename BlockListType>
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

class BlockData {
public:
  BasicBlock *BB;
  size_t Size;
  int Encoding;

  BlockData() : BB(nullptr), Size(0), Encoding(0) {}

  BlockData(BasicBlock *BB) : BB(BB) {
    Size = 0;
    for (Instruction &I : *BB) {
      if (!isa<LandingPadInst>(&I) && !isa<PHINode>(&I)) {
        Size++;
        Encoding += I.getOpcode();
      } else if (isa<LandingPadInst>(&I)) Encoding += I.getOpcode();
    }
  }
};

class MergedInstruction {
public:
  Instruction *NewI;
  Instruction *Insts[2];

  MergedInstruction() : NewI(nullptr) {
    Insts[0] = Insts[1] = nullptr;
  }

  MergedInstruction(Instruction *NewI, Instruction *I1, Instruction *I2) : NewI(NewI) {
    Insts[0] = I1;
    Insts[1] = I2;
  }

  Instruction *get() { return NewI; }
  Instruction *operator[](size_t i) { return Insts[i]; }
};

FunctionMergeResult FunctionMerger::merge(Function *F1, Function *F2, std::string Name,std::vector<MatchingBlocks> &AlignedBlocks, const FunctionMergingOptions &Options) {
  LLVMContext &Context = *ContextPtr;
  FunctionMergeResult ErrorResponse(F1, F2, nullptr);

  if (!validMergePair(F1,F2))
    return ErrorResponse;

#ifdef TIME_STEPS_DEBUG
  TimeAlign.startTimer();
#endif

  //std::vector<MatchingBlocks> AlignedBlocks;

  errs() << "Match making\n";

  std::map<size_t, std::vector<BlockData> > BlocksF1;
  for (BasicBlock &BB1 : *F1) {
    BlockData BD1(&BB1);
    BlocksF1[BD1.Size].push_back(BD1);
  }
  
  unsigned CountMergedInsts = 0;
  for (BasicBlock &BIt : *F2) {
    BasicBlock *BB2 = &BIt;
    BlockData BD2(BB2);
    auto &SetRef = BlocksF1[BD2.Size];
    std::sort(SetRef.begin(), SetRef.end(), [&](auto &A, auto &B) -> bool {
       int VA = std::abs(A.Encoding - BD2.Encoding);
       int VB = std::abs(B.Encoding - BD2.Encoding);
       return VA < VB;
    });

    for (auto BDIt = SetRef.begin(), E = SetRef.end(); BDIt!=E; BDIt++) {
      BlockData &BD1 = *BDIt;
      BasicBlock *BB1 = BD1.BB;
      if (FunctionMerger::matchWholeBlocks(BB1,BB2)) {
        AlignedBlocks.push_back(MatchingBlocks(BB1,BB2));

	CountMergedInsts += BD2.Size;

        SetRef.erase(BDIt);
        break;
      }
    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeAlign.stopTimer();
#endif

  if (AlignedBlocks.empty()) {
    errs() << "No blocks were matched\n";
    return ErrorResponse;
  }
  if ((CountMergedInsts / AlignedBlocks.size()) == 1 &&
      (F1->size() > 1 || F2->size() > 1)) {
    errs() << "Only tiny blocks merged\n";
    return ErrorResponse;
  }

#ifdef TIME_STEPS_DEBUG
  TimeParam.startTimer();
#endif

  errs() << "Creating function type\n";

  // Merging parameters
  std::map<unsigned, unsigned> ParamMap1;
  std::map<unsigned, unsigned> ParamMap2;
  std::vector<Type *> Args;


  //errs() << "Merging arguments\n";
  MergeArguments(Context, F1, F2, AlignedBlocks, ParamMap1,ParamMap2,Args,Options);

  Type *RetType1 = F1->getReturnType();
  Type *RetType2 = F2->getReturnType();
  Type *ReturnType = nullptr;

  bool RequiresUnifiedReturn = false;

  //Value *RetUnifiedAddr = nullptr;
  //Value *RetAddr1 = nullptr;
  //Value *RetAddr2 = nullptr;
  
  if (validMergeTypes(F1, F2, Options)) {
    errs() << "Simple return types\n";
    ReturnType = RetType1;
    if (ReturnType->isVoidTy()) {
      ReturnType = RetType2;
    }
  } else if (Options.EnableUnifiedReturnType) {
    errs() << "Unifying return types\n";
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
  FunctionType *FTy = FunctionType::get(ReturnType, ArrayRef<Type*>(Args), false);

  if (Name.empty()) {
    Name = ".m.f";
  }
/*
  if (!HasWholeProgram) {
    Name = M->getModuleIdentifier() + std::string(".");
  }
  Name = Name + std::string("m.f");
*/
  Function *MergedFunc =
    Function::Create(FTy, //GlobalValue::LinkageTypes::InternalLinkage,
                          GlobalValue::LinkageTypes::PrivateLinkage,
                       Twine(Name), M); // merged.function

  
  errs() << "Initializing VMap\n";
  ValueToValueMapTy VMap;

  std::vector<Argument *> ArgsList;
  for (Argument &arg : MergedFunc->args()) {
    ArgsList.push_back(&arg);
  }
  Value *FuncId = ArgsList[0];


  auto AttrList1 = F1->getAttributes();
  auto AttrList2 = F2->getAttributes();
  auto AttrListM = MergedFunc->getAttributes();

  int ArgId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    VMap[&(*I)] = ArgsList[ParamMap1[ArgId]];

    auto AttrSet1 = AttrList1.getParamAttrs((*I).getArgNo());
    AttrBuilder Attrs(Context, AttrSet1);
    AttrListM = AttrListM.addParamAttributes(Context, ArgsList[ParamMap1[ArgId]]->getArgNo(), Attrs );

    ArgId++;
  }

  ArgId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {
    VMap[&(*I)] = ArgsList[ParamMap2[ArgId]];

    auto AttrSet2 = AttrList2.getParamAttrs((*I).getArgNo());
    AttrBuilder Attrs(Context, AttrSet2);
    AttrListM = AttrListM.addParamAttributes(Context, ArgsList[ParamMap2[ArgId]]->getArgNo(), Attrs );

    ArgId++;
  }
  MergedFunc->setAttributes(AttrListM);


#ifdef TIME_STEPS_DEBUG
  TimeParam.stopTimer();
#endif

  errs() << "Setting attributes\n";
  SetFunctionAttributes(F1,F2,MergedFunc);

  Value *IsFunc1 = FuncId;

  errs() << "Running code generator\n";

  auto Gen = [&](auto &CG) {
    CG.setFunctionIdentifier(IsFunc1)
      .setEntryPoints(&F1->getEntryBlock(), &F2->getEntryBlock())
      .setReturnTypes(RetType1,RetType2)
      .setMergedFunction(MergedFunc)
      .setMergedEntryPoint(BasicBlock::Create(Context, "entry", MergedFunc))
      .setMergedReturnType(ReturnType, RequiresUnifiedReturn)
      .setContext(ContextPtr)
      .setIntPtrType(IntPtrTy);
    if (!CG.generate(AlignedBlocks, VMap, Options)) {
      MergedFunc->eraseFromParent();
      MergedFunc = nullptr;
      if (Debug) errs() << "ERROR: Failed to generate the merged function!\n";
    }
  };

  SALSSACodeGen<Function> CG(*F1, *F2);
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

void FunctionMerger::replaceByCall(Function *F, FunctionMergeResult &MFR, const FunctionMergingOptions &Options) {
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
      args[i] = UndefValue::get(MergedF->getFunctionType()->getParamType(i));
    }
  }

  CallInst *CI =
      (CallInst *)Builder.CreateCall(MergedF, ArrayRef<Value *>(args));
  CI->setTailCall();
  CI->setCallingConv(MergedF->getCallingConv());
  CI->setAttributes(MergedF->getAttributes());
  CI->setIsNoInline();

  if (F->getReturnType()->isVoidTy()) {
    Builder.CreateRetVoid();
  } else {
    Value *CastedV = CI;
    if (MFR.needUnifiedReturn()) {
      Value *AddrCI = Builder.CreateAlloca(CI->getType());
      Builder.CreateStore(CI,AddrCI);
      Value *CastedAddr = Builder.CreatePointerCast(AddrCI, PointerType::get(F->getReturnType(), DL->getAllocaAddrSpace()));
      CastedV = Builder.CreateLoad(F->getReturnType(), CastedAddr);
    } else {
      CastedV = createCastIfNeeded(CI, F->getReturnType(), Builder, IntPtrTy, Options);
    }
    Builder.CreateRet(CastedV);
  }
}

bool FunctionMerger::replaceCallsWith(Function *F, FunctionMergeResult &MFR, const FunctionMergingOptions &Options) {

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
        Calls.push_back(II);
      }
    }
  }

  if (Calls.size()<CountUsers)
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
    if (CI->getOpcode()==Instruction::Call) {
      NewCB = (CallInst *)Builder.CreateCall(MergedF->getFunctionType(),
                                                      MergedF, args);
    } else if (CI->getOpcode()==Instruction::Invoke) {
      InvokeInst *II = dyn_cast<InvokeInst>(CI);
      NewCB = (InvokeInst *)Builder.CreateInvoke(MergedF->getFunctionType(),
                                                      MergedF, II->getNormalDest(), II->getUnwindDest(), args);
      //MergedF->dump();
      //MergedF->getFunctionType()->dump();
      //errs() << "Invoke CallUpdate:\n";
      //II->dump();
      //NewCB->dump();
    }
    NewCB->setCallingConv(MergedF->getCallingConv());
    NewCB->setAttributes(MergedF->getAttributes());
    NewCB->setIsNoInline();
    Value *CastedV = NewCB;
    if (!F->getReturnType()->isVoidTy()) {
      if (MFR.needUnifiedReturn()) {
        Value *AddrCI = Builder.CreateAlloca(NewCB->getType());
        Builder.CreateStore(NewCB,AddrCI);
        Value *CastedAddr = Builder.CreatePointerCast(AddrCI, PointerType::get(F->getReturnType(), DL->getAllocaAddrSpace()));
        CastedV = Builder.CreateLoad(F->getReturnType(), CastedAddr);
      } else {
        CastedV = createCastIfNeeded(NewCB, F->getReturnType(), Builder, IntPtrTy, Options);
      }
    }

    // if (F->getReturnType()==MergedF->getReturnType())
    if (CI->getNumUses() > 0) {
      CI->replaceAllUsesWith(CastedV);
    }
    //assert( (CI->getNumUses()>0) && "ERROR: Function Call has uses!");
    CI->eraseFromParent();
  }

  return true;
}

static bool ShouldPreserveGV(const GlobalValue *GV) {
  // Function must be defined here
  if (GV->isDeclaration())
    return true;

  // Available externally is really just a "declaration with a body".
  //if (GV->hasAvailableExternallyLinkage())
  //  return true;

  // Assume that dllexported symbols are referenced elsewhere
  if (GV->hasDLLExportStorageClass())
    return true;

  // Already local, has nothing to do.
  if (GV->hasLocalLinkage())
    return false;

  return false;
}

static int RequiresOriginalInterface(Function *F, FunctionMergeResult &MFR, StringSet<> &AlwaysPreserved) {
  bool CanErase = !F->hasAddressTaken();
  CanErase = CanErase && (AlwaysPreserved.find(F->getName())==AlwaysPreserved.end());
  if (!HasWholeProgram) {
    CanErase = CanErase && F->isDiscardableIfUnused();
  }
  return !CanErase;
}

static int RequiresOriginalInterfaces(FunctionMergeResult &MFR, StringSet<> &AlwaysPreserved) {
  auto FPair = MFR.getFunctions();
  Function *F1 = FPair.first;
  Function *F2 = FPair.second;
  return (RequiresOriginalInterface(F1, MFR, AlwaysPreserved)?1:0) +
         (RequiresOriginalInterface(F2, MFR, AlwaysPreserved)?1:0);
}

void FunctionMerger::updateCallGraph(Function *F, FunctionMergeResult &MFR, StringSet<> &AlwaysPreserved, const FunctionMergingOptions &Options) {
  replaceByCall(F, MFR, Options);
  if (!RequiresOriginalInterface(F,MFR, AlwaysPreserved)) {
    ///TODO: don't update call graph when dynamically tracing calls
    //bool CanErase = false; //replaceCallsWith(F, MFR, Options);
    bool CanErase = replaceCallsWith(F, MFR, Options);
    CanErase = CanErase && F->use_empty();
    CanErase = CanErase && (AlwaysPreserved.find(F->getName())==AlwaysPreserved.end());
    if (!HasWholeProgram) {
      CanErase = CanErase && !ShouldPreserveGV(F);
      CanErase = CanErase && F->isDiscardableIfUnused();
    }
    if (CanErase) F->eraseFromParent();
  }
}

void FunctionMerger::updateCallGraph(FunctionMergeResult &MFR, StringSet<> &AlwaysPreserved, const FunctionMergingOptions &Options) {
  auto FPair = MFR.getFunctions();
  Function *F1 = FPair.first;
  Function *F2 = FPair.second;
  updateCallGraph(F1, MFR, AlwaysPreserved, Options);
  updateCallGraph(F2, MFR, AlwaysPreserved, Options);
}

static int EstimateThunkOverhead(FunctionMergeResult &MFR, StringSet<> &AlwaysPreserved) {
  //return RequiresOriginalInterfaces(MFR, AlwaysPreserved) * 3;
  return RequiresOriginalInterfaces(MFR, AlwaysPreserved)*(2+MFR.getMergedFunction()->getFunctionType()->getNumParams());
}

/*
static bool CompareFunctionScores(const std::pair<Function *, unsigned> &F1,
                                  const std::pair<Function *, unsigned> &F2) {
  return F1.second > F2.second;
}
*/
//#define FMSA_USE_JACCARD

class Fingerprint {
public:
  static const size_t MaxOpcode = 68;
  int OpcodeFreq[MaxOpcode];
  //std::map<unsigned, int> OpcodeFreq;
  // size_t NumOfInstructions;
  // size_t NumOfBlocks;

#ifdef FINGERPRINT_USE_TYPE
  #ifdef FMSA_USE_JACCARD
  std::set<Type *> Types;
  #else
  std::map<Type*, int> TypeFreq;
  #endif
#endif

  Function *F;

  Fingerprint(Function *F) {
    this->F = F;

    //memset(OpcodeFreq, 0, sizeof(int) * MaxOpcode);
    for (unsigned i = 0; i<MaxOpcode; i++) OpcodeFreq[i] = 0;

    // NumOfInstructions = 0;
    for (Instruction &I : instructions(F)) {
      OpcodeFreq[I.getOpcode()]++;

      //if (OpcodeFreq.find(I.getOpcode()) != OpcodeFreq.end())
      //  OpcodeFreq[I.getOpcode()]++;
      //else OpcodeFreq[I.getOpcode()] = 1;
 
      // NumOfInstructions++;
      
#ifdef FINGERPRINT_USE_TYPE
      #ifdef FMSA_USE_JACCARD
      Types.insert(I.getType());
      #else
      TypeFreq[I.getType()]++;
      #endif
#endif
    }
    // NumOfBlocks = F->size();
  }
};

class FunctionData {
public:
  Function *F;
  Fingerprint *FP;
  size_t Size;
  std::list<FunctionData>::iterator iterator;

  FunctionData() : F(nullptr), FP(nullptr), Size(0) {}
  FunctionData(Function *F, Fingerprint *FP, size_t Size) : F(F), FP(FP), Size(Size) {}
};


template<typename T, typename SimilarityT>
class BaseFingerprintSimilarity {
public:
  FunctionData FD1;
  FunctionData FD2;
  T Score;

  BaseFingerprintSimilarity() : Score(0) {}

  BaseFingerprintSimilarity(FunctionData &FD1, FunctionData &FD2) : FD1(FD1), FD2(FD2), Score(0) {}

  bool operator<(const SimilarityT &FS) const {
    return Score < FS.Score;
  }

  bool operator>(const SimilarityT &FS) const {
    return Score > FS.Score;
  }

  bool operator<=(const SimilarityT &FS) const {
    return Score <= FS.Score;
  }

  bool operator>=(const SimilarityT &FS) const {
    return Score >= FS.Score;
  }

  bool operator==(const SimilarityT &FS) const {
    return Score == FS.Score;
  }
};

class FingerprintSimilarity : public BaseFingerprintSimilarity<float,FingerprintSimilarity> {
public:
  int Similarity;
  int LeftOver;
#ifdef FINGERPRINT_USE_TYPE
  int TypesDiff;
  int TypesSim;
#endif
  using Base = BaseFingerprintSimilarity<float,FingerprintSimilarity>;

  FingerprintSimilarity() : Base() {}

  FingerprintSimilarity(FunctionData &FD1, FunctionData &FD2) : Base(FD1,FD2) {
    Fingerprint *FP1 = FD1.FP;
    Fingerprint *FP2 = FD2.FP;
    Similarity = 0;
    LeftOver = 0;
#ifdef FINGERPRINT_USE_TYPE
    TypesDiff = 0;
    TypesSim = 0;
#endif

    for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
      int Freq1 = FP1->OpcodeFreq[i];
      int Freq2 = FP2->OpcodeFreq[i];
      int MinFreq = std::min(Freq1, Freq2);
      Similarity += MinFreq;
      LeftOver += std::max(Freq1, Freq2) - MinFreq;
    }
    
    /*
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
    */
    
#ifdef FINGERPRINT_USE_TYPE
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
        TypesDiff +=
            std::max(Pair.second, FP2->TypeFreq[Pair.first]) - MinFreq;
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
#endif
    float UpperBound =
        ((float)Similarity) / ((float)(Similarity * 2.0f + LeftOver));

#ifdef FINGERPRINT_USE_TYPE
    #ifdef FMSA_USE_JACCARD
    Score = UpperBound * TypeScore;
    #else
    Score = std::min(UpperBound,TypeScore);
    #endif
#else
    Score = UpperBound;
#endif
  }

  static bool accept(const FingerprintSimilarity &Item) {
  if (!ApplySimilarityHeuristic)
    return true;

  if ( ((float)Item.Similarity) < 0.8f*Item.LeftOver)
    return false;

#ifdef FINGERPRINT_USE_TYPE
  float TypesDiffRatio = (((float)Item.TypesDiff) / ((float)Item.TypesSim));
  if (TypesDiffRatio > 2.f)
    return false;
#endif
  return true;
  }

};

class FingerprintManhattanSimilarity : public BaseFingerprintSimilarity<int,FingerprintManhattanSimilarity> {
public:
  using Base = BaseFingerprintSimilarity<int,FingerprintManhattanSimilarity>;

  FingerprintManhattanSimilarity() : Base() { Score = std::numeric_limits<int>::min(); }

  FingerprintManhattanSimilarity(FunctionData &FD1, FunctionData &FD2) : Base(FD1,FD2) {
    Fingerprint *FP1 = FD1.FP;
    Fingerprint *FP2 = FD2.FP;
    for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
      int Freq1 = FP1->OpcodeFreq[i];
      int Freq2 = FP2->OpcodeFreq[i];
      Score += std::abs(Freq1-Freq2);
    }
    Score = -Score;
  }

  static bool accept(const FingerprintManhattanSimilarity &Item) { return true; }
};

class FingerprintCosineSimilarity : public BaseFingerprintSimilarity<float,FingerprintCosineSimilarity> {
public:
  using Base = BaseFingerprintSimilarity<float,FingerprintCosineSimilarity>;

  FingerprintCosineSimilarity() : Base() {}

  FingerprintCosineSimilarity(FunctionData &FD1, FunctionData &FD2) : Base(FD1,FD2) {
    Fingerprint *FP1 = FD1.FP;
    Fingerprint *FP2 = FD2.FP;
    int AB = 0;
    int A2 = 0;
    int B2 = 0;
    for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
      int Freq1 = FP1->OpcodeFreq[i];
      int Freq2 = FP2->OpcodeFreq[i];
      AB += Freq1*Freq2;
      A2 += Freq1*Freq1;
      B2 += Freq2*Freq2;
    }
    Score = ((float)AB)/(std::sqrt((float)A2)*std::sqrt((float)B2));
  }

  static bool accept(const FingerprintCosineSimilarity &Item) { return true; }
};

class FingerprintEuclideanSimilarity : public BaseFingerprintSimilarity<float,FingerprintEuclideanSimilarity> {
public:
  using Base = BaseFingerprintSimilarity<float,FingerprintEuclideanSimilarity>;

  FingerprintEuclideanSimilarity() : Base() { Score = std::numeric_limits<int>::min(); }

  FingerprintEuclideanSimilarity(FunctionData &FD1, FunctionData &FD2) : Base(FD1,FD2) {
    Fingerprint *FP1 = FD1.FP;
    Fingerprint *FP2 = FD2.FP;
    int Sum = 0;
    for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
      int Freq1 = FP1->OpcodeFreq[i];
      int Freq2 = FP2->OpcodeFreq[i];
      int Sub = Freq1-Freq2;
      Sum += Sub*Sub;
    }
    Score = - std::sqrt((float)Sum);
  }

  static bool accept(const FingerprintEuclideanSimilarity &Item) { return true; }
};

static size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI) {
  float size = 0;
  for (Instruction &I : instructions(F)) {
    switch(I.getOpcode()) {
    case Instruction::Alloca:
    case Instruction::PHI:
      size += 0.2;
      break;
    case Instruction::Select:
      size += 1.2;
      break;
    default:
      size += TTI->getInstructionCost(
                     &I, TargetTransformInfo::TargetCostKind::TCK_CodeSize)
                  .getValue()
                  .value();
    }
  }
  
  return std::ceil(size);
}

static bool CompareFunctionDataScores(const FunctionData &F1,
                                  const FunctionData &F2) {
  return F1.Size > F2.Size;
}

bool FastFM::runOnModule(Module &M) {

  //errs() << "Running FMSA\n";

  StringSet<> AlwaysPreserved;
  AlwaysPreserved.insert("main");

  srand(time(NULL));

  FunctionMergingOptions Options = FunctionMergingOptions()
                                    .maximizeParameterScore(MaxParamScore)
                                    .matchOnlyIdenticalTypes(IdenticalType)
                                    .enableUnifiedReturnTypes(EnableUnifiedReturnType);

  //auto *PSI = &this->getAnalysis<ProfileSummaryInfoWrapperPass>().getPSI();
  //auto LookupBFI = [this](Function &F) {
  //  return &this->getAnalysis<BlockFrequencyInfoWrapperPass>(F).getBFI();
  //};

  //TODO: We could use a TTI ModulePass instead but current TTI analysis pass is
  //a FunctionPass.
  TargetTransformInfo TTI(M.getDataLayout());

  std::vector<FunctionData> FunctionsToProcess;

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.startTimer();
#endif

  for (auto &F : M) {
    if (F.isDeclaration() || F.isVarArg() || (!HasWholeProgram && F.hasAvailableExternallyLinkage()))
      continue;
    
    FunctionData FD(&F, new Fingerprint(&F), EstimateFunctionSize(&F, &TTI));
    FunctionsToProcess.push_back(FD);
  }

  errs() << "Number of Functions: " << FunctionsToProcess.size() << "\n";

  
  std::sort(FunctionsToProcess.begin(), FunctionsToProcess.end(),
            CompareFunctionDataScores);

  std::stable_sort(FunctionsToProcess.begin(), FunctionsToProcess.end(),
      [&](auto &FD1, auto &FD2) -> bool {
        unsigned Sum1 = 0;
        for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
          Sum1 += FD1.FP->OpcodeFreq[i];
	}
        unsigned Sum2 = 0;
        for (unsigned i = 0; i < Fingerprint::MaxOpcode; i++) {
          Sum2 += FD2.FP->OpcodeFreq[i];
	}
	float Avg1 = ((float)Sum1)/((float)Fingerprint::MaxOpcode);
	float Avg2 = ((float)Sum2)/((float)Fingerprint::MaxOpcode);
	return Avg1 > Avg2;
  });
  

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.stopTimer();
#endif

  std::list<FunctionData> WorkList;

  for (auto &FD : FunctionsToProcess) {
    WorkList.push_back(FD);
  }

  unsigned TotalMerges = 0;
  unsigned TotalOpReorder = 0;
  unsigned TotalBinOps = 0;

  FunctionMerger FM(&M);//,PSI,LookupBFI);

  //#define SIMILARITY_TYPE FingerprintSimilarity
  #define SIMILARITY_TYPE FingerprintManhattanSimilarity
  //#define SIMILARITY_TYPE FingerprintCosineSimilarity
  //#define SIMILARITY_TYPE FingerprintEuclideanSimilarity

  std::vector<SIMILARITY_TYPE> Rank;
  if (ExplorationThreshold > 1)
    Rank.reserve(FunctionsToProcess.size());

  FunctionsToProcess.clear();

  while (!WorkList.empty()) {
    FunctionData FD1 = WorkList.front();
    WorkList.pop_front();

    Rank.clear();

#ifdef TIME_STEPS_DEBUG
    TimeRank.startTimer();
#endif

    Function *F1 = FD1.F;

    if (ExplorationThreshold > 1) {
      unsigned CountCandidates = 0;
      for (auto It = WorkList.begin(), E = WorkList.end(); It!=E; It++) {
	FunctionData &FD2 = *It;
	Function *F2 = FD2.F;

        if ((!FM.validMergeTypes(F1, F2, Options) && !Options.EnableUnifiedReturnType) || !validMergePair(F1, F2))
          continue;

	FD2.iterator = It;
        SIMILARITY_TYPE PairSim(FD1, FD2);
        if (SIMILARITY_TYPE::accept(PairSim))
          Rank.push_back(PairSim);
        if (RankingThreshold && CountCandidates>RankingThreshold) {
          break;
        }
        CountCandidates++;
      }
      std::make_heap(Rank.begin(), Rank.end());
    } else {

      bool FoundCandidate = false;
      SIMILARITY_TYPE BestPair;

      unsigned CountCandidates = 0;
      for (auto It = WorkList.begin(), E = WorkList.end(); It!=E; It++) {
	FunctionData &FD2 = *It;
	Function *F2 = FD2.F;

        if ((!FM.validMergeTypes(F1, F2, Options) && !Options.EnableUnifiedReturnType) || !validMergePair(F1, F2))
          continue;

	FD2.iterator = It;
        SIMILARITY_TYPE PairSim(FD1, FD2);
        if (PairSim > BestPair && SIMILARITY_TYPE::accept(PairSim)) {
          BestPair = PairSim;
          FoundCandidate = true;
        }
        if (RankingThreshold && CountCandidates>RankingThreshold) {
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

    delete FD1.FP;
    FD1.FP = nullptr;

    while (!Rank.empty()) {
      auto RankEntry = Rank.front();

      FunctionData FD2 = RankEntry.FD2;
      Function *F2 = FD2.F;

      std::pop_heap(Rank.begin(), Rank.end());
      Rank.pop_back();

      CountBinOps = 0;
      CountOpReorder = 0;

      MergingTrialsCount++;

      if (Debug || Verbose) {
        errs() << "Attempting: " << GetValueName(F1) << ", " << GetValueName(F2) << " : " << RankEntry.Score
               << "\n";
      }

      std::vector<MatchingBlocks> AlignedBlocks;

      std::string Name = ".m.f." + std::to_string(TotalMerges);
      FunctionMergeResult Result = FM.merge(F1,F2,Name,AlignedBlocks,Options);

      bool validFunction = true;

      if (Result.getMergedFunction() != nullptr && verifyFunction(*Result.getMergedFunction())) {
        if (Debug || Verbose) {
          errs() << "Invalid Function: " << GetValueName(F1) << ", "
                 << GetValueName(F2) << "\n";
         // Result.getMergedFunction()->dump();
        }

        Result.getMergedFunction()->eraseFromParent();
        validFunction = false;
      }

      if (Result.getMergedFunction() && validFunction) {

        size_t SizeF1 = FD1.Size;
        size_t SizeF2 = FD2.Size;

        int SizeF12 = EstimateThunkOverhead(Result, AlwaysPreserved) +
                      EstimateFunctionSize(Result.getMergedFunction(), &TTI);


        int SizeF1F2 = SizeF1+SizeF2;

	bool Profitable = (SizeF12 + MergingOverheadThreshold) <= SizeF1F2;

        if (Debug || Verbose) {
          errs() << "Estimated Sizes: " << SizeF1 << " + " << SizeF2 << " <= " << SizeF12 << "? " << ( ((int)SizeF1F2)- ((int)SizeF12) ) << " (" << Profitable << ") ";
          errs() << "Reduction: "
                 << (int)( (( ((double)SizeF1F2) - ((double)SizeF12) ) / SizeF1F2) * 100 )
                 << "% "
                 << MergingTrialsCount << " : " << GetValueName(F1)
                 << "; " << GetValueName(F2) << "\n";
        }

        if (Profitable) {

          TotalOpReorder += CountOpReorder;
          TotalBinOps += CountBinOps;

	  for (auto &MB : AlignedBlocks) {
            BasicBlock *BB1 = MB[0];
            BasicBlock *BB2 = MB[1];

	    errs() << "Merged Blocks: " << GetValueName(BB1) << "; " << GetValueName(BB2) << "\n";

            auto It1 = BB1->begin();
            auto It2 = BB2->begin();


            while( It1!=BB1->end() && (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1)) ) {
              It1++;
            }
            while( It2!=BB2->end() && (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2)) ) {
              It2++;
            }

            while (It1!=BB1->end() && It2!=BB2->end()) {
              Instruction *I1 = &*It1;
              Instruction *I2 = &*It2;

#ifdef LLVM_ENABLE_DUMP
              if (Verbose) {
                I1->dump();
                I2->dump();
                errs() << "-----------\n";
              }
#endif
              It1++;
              It2++;
            }

	    errs() << "=========================\n";
	  }

          if (Debug || Verbose) {
            errs() << "Merged: " << GetValueName(F1) << ", " << GetValueName(F2)
                   << " = " << GetValueName(Result.getMergedFunction()) << "\n";
          }

#ifdef LLVM_ENABLE_DUMP
        if (Verbose) {
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
          if (Result.getMergedFunction() != nullptr) {
            errs() << "F1-F2:\n";
            Result.getMergedFunction()->dump();
	  } else errs() << "F1-F2: Invalid\n";
        }
#endif

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.startTimer();
#endif

          FM.updateCallGraph(Result, AlwaysPreserved, Options);

          TotalMerges++;

          WorkList.erase(FD2.iterator);
	  delete FD2.FP;
          FD2.FP = nullptr;

	  if (ReuseMergedFunctions) {
            // feed new function back into the working lists
	    FunctionData MFD(Result.getMergedFunction(),
                            new Fingerprint(Result.getMergedFunction()),
			    EstimateFunctionSize(Result.getMergedFunction(), &TTI));
            WorkList.push_front(MFD);
          }
#ifdef TIME_STEPS_DEBUG
          TimeUpdate.stopTimer();
#endif

          break; // end exploration with F1
        } else {
          if (Result.getMergedFunction() != nullptr)
            Result.getMergedFunction()->eraseFromParent();
        }
      }

      if (MergingTrialsCount >= ExplorationThreshold) {
        break;
      }
    }
  }

  WorkList.clear();

  double MergingAverageDistance = 0;
  unsigned MergingMaxDistance = 0;

  if (Debug || Verbose) {
    errs() << "Total operand reordering: " << TotalOpReorder << "/"
           << TotalBinOps << " ("
           << 100.0 * (((double)TotalOpReorder) / ((double)TotalBinOps))
           << " %)\n";

//    errs() << "Total parameter score: " << TotalParamScore << "\n";
//    errs() << "Total number of merges: " << MergingDistance.size() << "\n";

    errs() << "Average number of trials before merging: "
           << MergingAverageDistance << "\n";
    errs() << "Maximum number of trials before merging: " << MergingMaxDistance
           << "\n";
  }

#ifdef TIME_STEPS_DEBUG
  errs() << "Timer:Align: " << TimeAlign.getTotalTime().getWallTime() << "\n";
  TimeAlign.clear();

  errs() << "Timer:Param: " << TimeParam.getTotalTime().getWallTime() << "\n";
  TimeParam.clear();

  errs() << "Timer:CodeGen: " << TimeCodeGen.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen.clear();

  errs() << "Timer:CodeGenFix: " << TimeCodeGenFix.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGenFix.clear();

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

void FastFM::getAnalysisUsage(AnalysisUsage &AU) const {
  ModulePass::getAnalysisUsage(AU);
  //AU.addRequired<ProfileSummaryInfoWrapperPass>();
  //AU.addRequired<BlockFrequencyInfoWrapperPass>();
}

char FastFM::ID = 0;
#ifdef LLVM_NEXT_FM_STANDALONE
static RegisterPass<FastFM> X("fastfm", "New Function Merging", false, false);
#else
INITIALIZE_PASS(FastFM, "fastfm", "New Function Merging", false,
                false)

ModulePass *llvm::createFastFMPass() {
  return new FastFM();
}
#endif

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
//Value *FunctionMerger::createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder, const FunctionMergingOptions &Options) {
Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder, Type *IntPtrTy, const FunctionMergingOptions &Options) {

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


template<typename BlockListType>
void FunctionMerger::CodeGenerator<BlockListType>::removeRedundantInstructions(std::vector<Instruction *> &WorkInst, DominatorTree &DT) {
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

static void postProcessFunction(Function &F) {
  legacy::FunctionPassManager FPM(F.getParent());

  //FPM.add(createPromoteMemoryToRegisterPass());
  FPM.add(createCFGSimplificationPass());
  FPM.add(createInstructionCombiningPass());
  //FPM.add(createCFGSimplificationPass());

  FPM.doInitialization();
  FPM.run(F);
  FPM.doFinalization();
}

template<typename BlockListType>
static void CodeGen(BlockListType &Blocks1, BlockListType &Blocks2,
                    BasicBlock *EntryBB1, BasicBlock *EntryBB2,
                    Function *MergedFunc, Value *IsFunc1, BasicBlock *PreBB,
                    std::vector<MatchingBlocks> &AlignedBlocks,
                    ValueToValueMapTy &VMap,
                    std::unordered_map<BasicBlock *, BasicBlock *> &BlocksF1,
                    std::unordered_map<BasicBlock *, BasicBlock *> &BlocksF2,
                    std::list<MergedInstruction> &MergedInsts
		    ) {


  auto CloneInst = [](IRBuilder<> &Builder, Function *MF, Instruction *I) -> Instruction* {
    Instruction *NewI = nullptr;
    if (I->getOpcode() == Instruction::Ret) {
      if (MF->getReturnType()->isVoidTy()) {
        NewI = Builder.CreateRetVoid();
      } else {
        NewI = Builder.CreateRet(
            UndefValue::get(MF->getReturnType()));
      }
    } else {
      //assert(I1->getNumOperands() == I2->getNumOperands() &&
      //      "Num of Operands SHOULD be EQUAL!");
      NewI = I->clone();
      for(unsigned i = 0; i<NewI->getNumOperands(); i++) {
	if (!isa<Constant>(I->getOperand(i)))
          NewI->setOperand(i,nullptr);
      }
      Builder.Insert(NewI);

    }
    
    //NewI->dropPoisonGeneratingFlags(); //TODO: NOT SURE IF THIS IS VALID

    // TODO: temporarily removing metadata
    
    SmallVector<std::pair<unsigned, MDNode *>, 8> MDs;
    NewI->getAllMetadata(MDs);
    for (std::pair<unsigned, MDNode *> MDPair : MDs) {
      NewI->setMetadata(MDPair.first, nullptr);
    }

    if (isa<GetElementPtrInst>(NewI)) {
      GetElementPtrInst * GEP = dyn_cast<GetElementPtrInst>(I);
      //GetElementPtrInst * GEP2 = dyn_cast<GetElementPtrInst>(I2);
      dyn_cast<GetElementPtrInst>(NewI)->setIsInBounds(GEP->isInBounds());
    }
    
    if (auto *CB = dyn_cast<CallBase>(I)) {
      auto *NewCB = dyn_cast<CallBase>(NewI);
      auto AttrList = CB->getAttributes();
      NewCB->setAttributes(AttrList);
    }
    
    return NewI;
  };


  std::unordered_set<BasicBlock *> BlocksCloned;

  errs() << "Cloning Merged Blocks \n";
  for (auto &MB : AlignedBlocks) {
    BasicBlock *BB1 = MB[0];
    BasicBlock *BB2 = MB[1];

    if (BB1 && BB2) {
      BasicBlock *MergedBB = BasicBlock::Create(MergedFunc->getContext(), "merged.bb", MergedFunc);

      VMap[BB1] = MergedBB;
      VMap[BB2] = MergedBB;
      
      BlocksF1[MergedBB] = BB1;
      BlocksF2[MergedBB] = BB2;

      IRBuilder<> Builder(MergedBB);

      auto It1 = BB1->begin();

      while( It1!=BB1->end() && (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1)) ) {
        if (isa<PHINode>(*It1)) {
          auto *PHI = Builder.CreatePHI((*It1).getType(), 0);
          VMap[&(*It1)] = PHI;
          MergedInsts.push_back(MergedInstruction(PHI,&(*It1),nullptr));
        }
        It1++;
      }

      auto It2 = BB2->begin();
      while( It2!=BB2->end() && (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2)) ) {
        if (isa<PHINode>(*It2)) {
          auto *PHI = Builder.CreatePHI((*It2).getType(), 0);
          VMap[&(*It2)] = PHI;
          MergedInsts.push_back(MergedInstruction(PHI,nullptr,&(*It2)));
        }
        It2++;
      }

      while (It1!=BB1->end() && It2!=BB2->end()) {
        Instruction *I1 = &*It1;
        Instruction *I2 = &*It2;

        Instruction *NewI = CloneInst(Builder,MergedFunc,I1);

        VMap[I1] = NewI;
        VMap[I2] = NewI;
        MergedInsts.push_back(MergedInstruction(NewI,I1,I2));

        It1++;
        It2++;
      }
    }
  }


  errs() << "Cloning Blocks Function 1 \n";
  for (BasicBlock *BB1 : Blocks1) {

    if (BlocksCloned.find(BB1)==BlocksCloned.end()) {
      BlocksCloned.insert(BB1);

      std::string BBName = std::string("f1.")+BB1->getName().str();
      BasicBlock *NewBB = BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);
      BlocksF1[NewBB] = BB1;
      VMap[BB1] = NewBB;
      
      IRBuilder<> Builder(NewBB);
      for (Instruction &I : *BB1) {
        if (isa<LandingPadInst>(&I))
          continue;
        if (isa<PHINode>(&I)) {
          auto *PHI = Builder.CreatePHI(I.getType(), 0);
          VMap[&I] = PHI;
          MergedInsts.push_back(MergedInstruction(PHI,&I,nullptr));
        } else {
          Instruction *NewI = CloneInst(Builder,MergedFunc,&I);
          VMap[&I] = NewI;
          MergedInsts.push_back(MergedInstruction(NewI,&I,nullptr));
	}
      }
    }
  }


  errs() << "Cloning Blocks Function 2 \n";
  for (BasicBlock *BB2 : Blocks2) {

    if (BlocksCloned.find(BB2)==BlocksCloned.end()) {
      BlocksCloned.insert(BB2);

      std::string BBName = std::string("f2.")+BB2->getName().str();
      BasicBlock *NewBB = BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);
      BlocksF2[NewBB] = BB2;
      VMap[BB2] = NewBB;
      
      IRBuilder<> Builder(NewBB);
      for (Instruction &I : *BB2) {
        if (isa<LandingPadInst>(&I))
          continue;
        if (isa<PHINode>(&I)) {
          auto *PHI = Builder.CreatePHI(I.getType(), 0);
          VMap[&I] = PHI;
          MergedInsts.push_back(MergedInstruction(PHI,nullptr,&I));
        } else {
          Instruction *NewI = CloneInst(Builder,MergedFunc,&I);
          VMap[&I] = NewI;
          MergedInsts.push_back(MergedInstruction(NewI,nullptr,&I));
	}
      }
    }
  }

  errs() << "Generating wiring with entry block\n";

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

template<typename BlockListType>
bool FunctionMerger::SALSSACodeGen<BlockListType>::generate(std::vector<MatchingBlocks> &AlignedBlocks,
                  ValueToValueMapTy &VMap,
                  const FunctionMergingOptions &Options) {

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.startTimer();
#endif

  LLVMContext &Context = CodeGenerator<BlockListType>::getContext();
  Function *MergedFunc = CodeGenerator<BlockListType>::getMergedFunction();
  Value *IsFunc1 = CodeGenerator<BlockListType>::getFunctionIdentifier();
  Type *ReturnType = CodeGenerator<BlockListType>::getMergedReturnType();
  bool RequiresUnifiedReturn = CodeGenerator<BlockListType>::getRequiresUnifiedReturn();
  BasicBlock *EntryBB1 = CodeGenerator<BlockListType>::getEntryBlock1();
  BasicBlock *EntryBB2 = CodeGenerator<BlockListType>::getEntryBlock2();
  BasicBlock *PreBB = CodeGenerator<BlockListType>::getPreBlock();
  
  Type *RetType1 = CodeGenerator<BlockListType>::getReturnType1();
  Type *RetType2 = CodeGenerator<BlockListType>::getReturnType2();

  Type *IntPtrTy = CodeGenerator<BlockListType>::getIntPtrType();

  //BlockListType &Blocks1 = CodeGenerator<BlockListType>::getBlocks1();
  //BlockListType &Blocks2 = CodeGenerator<BlockListType>::getBlocks2();
  std::vector<BasicBlock*> &Blocks1 = CodeGenerator<BlockListType>::getBlocks1();
  std::vector<BasicBlock*> &Blocks2 = CodeGenerator<BlockListType>::getBlocks2();

  std::list<Instruction *> LinearOffendingInsts;
  std::set<Instruction *> OffendingInsts;
  std::map<Instruction *, std::map<Instruction *,unsigned>> CoalescingCandidates;

  std::vector<AllocaInst *> Allocas;

  Value *RetUnifiedAddr = nullptr;
  Value *RetAddr1 = nullptr;
  Value *RetAddr2 = nullptr;

  //maps new basic blocks in the merged function to their original correspondents
  std::unordered_map<BasicBlock *, BasicBlock *> BlocksF1;
  std::unordered_map<BasicBlock *, BasicBlock *> BlocksF2;
  std::list<MergedInstruction> MergedInsts;

  CodeGen(Blocks1,Blocks2,EntryBB1,EntryBB2,MergedFunc,IsFunc1,PreBB,AlignedBlocks,VMap,BlocksF1,BlocksF2,MergedInsts);

  if (RequiresUnifiedReturn) {
    IRBuilder<> Builder(PreBB);
    RetUnifiedAddr = Builder.CreateAlloca(ReturnType);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetUnifiedAddr));

    RetAddr1 = Builder.CreateAlloca(RetType1);
    RetAddr2 = Builder.CreateAlloca(RetType2);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr1));
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr2));
  }

  errs() << "Assigning label operands\n";
  
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
      return Builder.CreateNot(IsFunc1); /// TODO: create a single not(IsFunc1) for each merged function that needs it
    }

    Instruction *IV1 = dyn_cast<Instruction>(V1);
    Instruction *IV2 = dyn_cast<Instruction>(V2);

    if (IV1 && IV2) {
      // if both IV1 and IV2 are non-merged values
      if( BlocksF2.find(IV1->getParent())==BlocksF2.end() && BlocksF1.find(IV2->getParent())==BlocksF1.end() ) {
        CoalescingCandidates[IV1][IV2]++;
        CoalescingCandidates[IV2][IV1]++;
      }
    }

    IRBuilder<> Builder(InsertPt);
    Instruction *Sel = (Instruction *)Builder.CreateSelect(IsFunc1, V1, V2);
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
        if (V->getType() != ReturnType) {
          //Value *Addr = (IsFuncId1 ? RetAddr1 : RetAddr2);
          Value *Addr = Builder.CreateAlloca(V->getType());
          Builder.CreateStore(V, Addr);
          Value *CastedAddr = Builder.CreatePointerCast(Addr, RetUnifiedAddr->getType());
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

          //Value *CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(), Builder, IntPtrTy);
          NewI->setOperand(i, V);
        }
      }
    
    return true;
  };

  std::set<BranchInst*> XorBrConds;
  //assigning label operands
  
  for (auto &MI : MergedInsts) {
    Instruction *I1 = MI[0];
    Instruction *I2 = MI[1];

    // Skip non-instructions
    if (I1==nullptr && I2==nullptr) {
      errs() << "ERROR: NULL Instructions\n";
      continue;
    }
    
    if (I1!=nullptr && I2!=nullptr) {

      Instruction *I = I1;
      if (I1->getOpcode() == Instruction::Ret) {
        I = (I1->getNumOperands() >= I2->getNumOperands())? I1 : I2 ;
      } else {
        assert(I1->getNumOperands() == I2->getNumOperands() &&
               "Num of Operands SHOULD be EQUAL\n");
      }

      Instruction *NewI = MI.get();

      bool Handled = false;
      
      BranchInst *NewBr = dyn_cast<BranchInst>(NewI);    
      if (EnableOperandReordering && NewBr!=nullptr && NewBr->isConditional()) { 
         BranchInst *Br1 = dyn_cast<BranchInst>(I1);       
         BranchInst *Br2 = dyn_cast<BranchInst>(I2);
         
         BasicBlock *SuccBB10 = dyn_cast<BasicBlock>(MapValue(Br1->getSuccessor(0), VMap));
         BasicBlock *SuccBB11 = dyn_cast<BasicBlock>(MapValue(Br1->getSuccessor(1), VMap));

         BasicBlock *SuccBB20 = dyn_cast<BasicBlock>(MapValue(Br2->getSuccessor(0), VMap));
         BasicBlock *SuccBB21 = dyn_cast<BasicBlock>(MapValue(Br2->getSuccessor(1), VMap));

         if (SuccBB10!=nullptr && SuccBB11!=nullptr && SuccBB10==SuccBB21 && SuccBB20==SuccBB11) {
             if (Debug) errs() << "OptimizationTriggered: Labels of Conditional Branch Reordering\n";

             XorBrConds.insert(NewBr);
             NewBr->setSuccessor(0,SuccBB20);
             NewBr->setSuccessor(1,SuccBB21);
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
              if (Debug) errs() << "ERROR: Null value mapped: V1 = "
                        "MapValue(I1->getOperand(i), "
                        "VMap);\n";
              //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
          TimeCodeGen.stopTimer();
#endif
              return false;
            }
          } else {
            V1 = UndefValue::get(I2->getOperand(i)->getType());
          }

          Value *F2V = nullptr;
          Value *V2 = nullptr;
          if (i < I2->getNumOperands()) {
            F2V = I2->getOperand(i);
            V2 = MapValue(F2V, VMap);
            // assert(V2!=nullptr && "Mapped value should NOT be NULL!");

            if (V2 == nullptr) {
              if (Debug) errs() << "ERROR: Null value mapped: V2 = "
                        "MapValue(I2->getOperand(i), "
                        "VMap);\n";
              //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
          TimeCodeGen.stopTimer();
#endif
              return false;
            }

          } else {
            V2 = UndefValue::get(I1->getOperand(i)->getType());
          }

          assert(V1 != nullptr && "Value should NOT be null!");
          assert(V2 != nullptr && "Value should NOT be null!");

          Value *V = V1; // first assume that V1==V2

          //handling just label operands for now
          if (!isa<BasicBlock>(V))
            continue;

          BasicBlock *F1BB = dyn_cast<BasicBlock>(F1V);
          BasicBlock *F2BB = dyn_cast<BasicBlock>(F2V);

          if (V1 != V2) {
            BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
            BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);

            //auto CacheKey = std::pair<BasicBlock *, BasicBlock *>(BB1, BB2);
            BasicBlock *SelectBB = BasicBlock::Create(Context, "bb.select", MergedFunc);
            IRBuilder<> BuilderBB(SelectBB);

            BlocksF1[SelectBB] = I1->getParent();
            BlocksF2[SelectBB] = I2->getParent();

            BuilderBB.CreateCondBr(IsFunc1, BB1, BB2);
            V = SelectBB;
          }
          
          if (F1BB->isLandingPad() || F2BB->isLandingPad()) {
            LandingPadInst *LP1 = F1BB->getLandingPadInst();
            LandingPadInst *LP2 = F2BB->getLandingPadInst();
            assert((LP1 != nullptr && LP2 != nullptr) &&
                   "Should be both as per the BasicBlock match!");

            BasicBlock *LPadBB = BasicBlock::Create(Context, "lpad.bb", MergedFunc);
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

    } else { // if(entry.match())-else

      auto AssignLabelOperands = [&](Instruction *I, std::unordered_map<BasicBlock*, BasicBlock *> &BlocksReMap) -> bool {
       Instruction *NewI = dyn_cast<Instruction>(VMap[I]);
       //if (isa<BranchInst>(I))
       //  errs() << "Setting operand in " << NewI->getParent()->getName() << " : " << NewI->getName() << " " << NewI->getOpcodeName() << "\n";

       for (unsigned i = 0; i < I->getNumOperands(); i++) {
          //handling just label operands for now
          if (!isa<BasicBlock>(I->getOperand(i))) continue;
          BasicBlock *FXBB = dyn_cast<BasicBlock>(I->getOperand(i));

          Value *V = MapValue(FXBB, VMap);
          // assert( V!=nullptr && "Mapped value should NOT be NULL!");
          if (V == nullptr)
            return false; // ErrorResponse;

          if (FXBB->isLandingPad()) {

            LandingPadInst *LP = FXBB->getLandingPadInst();
            assert(LP != nullptr &&
		           "Should have a landingpad inst!");
 

            BasicBlock *LPadBB = BasicBlock::Create(Context, "lpad.bb", MergedFunc);
            IRBuilder<> BuilderBB(LPadBB);
 
            Instruction *NewLP = LP->clone();
            BuilderBB.Insert(NewLP);
            VMap[LP] = NewLP;
            BlocksReMap[LPadBB] = FXBB; //I->getParent();
 
            BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));
 
            V = LPadBB;
          }

          NewI->setOperand(i, V);
	  //if (isa<BranchInst>(NewI))
	  //  errs() << "Operand " << i << ": " << V->getName() << "\n";
        }
        return true;
      };

      if (I1 != nullptr && !AssignLabelOperands(I1, BlocksF1)) {
        if (Debug) errs() << "ERROR: Value should NOT be null\n";
        //MergedFunc->eraseFromParent();

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif
        return false;
      }
      if (I2 != nullptr && !AssignLabelOperands(I2, BlocksF2)) {
        if (Debug) errs() << "ERROR: Value should NOT be null\n";
        //MergedFunc->eraseFromParent();

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif
        return false;
      }
    }

  }

  errs() << "Assigning value operands\n";

  for (auto &MI : MergedInsts) {
    Instruction *I1 = MI[0];
    Instruction *I2 = MI[1];

    // Skip non-instructions
    if (I1==nullptr && I2==nullptr) {
      errs() << "ERROR: NULL Instructions\n";
      continue;
    }
 
    if ( isa<PHINode>(MI.get()) ) continue;

    if (I1!=nullptr && I2!=nullptr) {

      //Instruction *I1 = dyn_cast<Instruction>(MN->N1->getValue());
      //Instruction *I2 = dyn_cast<Instruction>(MN->N2->getValue());

      Instruction *I = I1;
      if (I1->getOpcode() == Instruction::Ret) {
        I = (I1->getNumOperands() >= I2->getNumOperands()) ? I1 : I2;
      } else {
        assert(I1->getNumOperands() == I2->getNumOperands() &&
               "Num of Operands SHOULD be EQUAL\n");
      }

      //Instruction *NewI = dyn_cast<Instruction>(VMap[I]);
      Instruction *NewI = MI.get();

      IRBuilder<> Builder(NewI);

      if (EnableOperandReordering && isa<BinaryOperator>(NewI) && NewI->isCommutative()) {
        //errs() << "Handling BinOp\n"; 
        CountBinOps++;

        BinaryOperator *BO1 = dyn_cast<BinaryOperator>(I1);
        BinaryOperator *BO2 = dyn_cast<BinaryOperator>(I2);
        Value *VL1 = MapValue(BO1->getOperand(0), VMap);
        Value *VL2 = MapValue(BO2->getOperand(0), VMap);
        Value *VR1 = MapValue(BO1->getOperand(1), VMap);
        Value *VR2 = MapValue(BO2->getOperand(1), VMap);
        if (VL1 == VR2 && VL2 != VR2) {
          std::swap(VL2, VR2);
           CountOpReorder++;
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
            //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
            return false; // ErrorResponse;
          }

          // TODO: cache the created instructions
          //Value *CastedV = CreateCast(Builder, V, NewI->getOperand(i)->getType());
          Value *CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(), Builder, IntPtrTy); 
          NewI->setOperand(i, CastedV);
        }
      } else {
        for (unsigned i = 0; i < NewI->getNumOperands(); i++) {
          if (isa<BasicBlock>(I->getOperand(i)))
            continue;

          Value *V1 = nullptr;
          if (i < I1->getNumOperands()) {
            V1 = MapValue(I1->getOperand(i), VMap);
            // assert(V1!=nullptr && "Mapped value should NOT be NULL!");
            if (V1 == nullptr) {
              if (Debug) errs() << "ERROR: Null value mapped: V1 = "
                        "MapValue(I1->getOperand(i), "
                        "VMap);\n";
              //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
              return false;
            }
          } else {
            V1 = UndefValue::get(I2->getOperand(i)->getType());
          }

          Value *V2 = nullptr;
          if (i < I2->getNumOperands()) {
            V2 = MapValue(I2->getOperand(i), VMap);
            // assert(V2!=nullptr && "Mapped value should NOT be NULL!");

            if (V2 == nullptr) {
              if (Debug) errs() << "ERROR: Null value mapped: V2 = "
                        "MapValue(I2->getOperand(i), "
                        "VMap);\n";
              //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
              return false;
            }

          } else {
            V2 = UndefValue::get(I1->getOperand(i)->getType());
          }

          assert(V1 != nullptr && "Value should NOT be null!");
          assert(V2 != nullptr && "Value should NOT be null!");

          Value *V = MergeValues(V1, V2, NewI);
          if (V == nullptr) {
            if (Debug) {
               errs() << "Could Not select:\n";
               errs() << "ERROR: Value should NOT be null\n";
	    }
            //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
            return false; // ErrorResponse;
          }

          //Value *CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(), Builder, IntPtrTy);
          NewI->setOperand(i, V);

        } // end for operands
      }
    } // end if isomorphic
    else {

      // PDGNode *N = MN->getUniqueNode();
      if (I1 != nullptr && !AssignOperands(I1, true)) {
        if (Debug) errs() << "ERROR: Value should NOT be null\n";
        //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
      if (I2 != nullptr && !AssignOperands(I2, false)) {
        if (Debug) errs() << "ERROR: Value should NOT be null\n";
        //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
        TimeCodeGen.stopTimer();
#endif
        return false;
      }
    } // end 'if-else' non-isomorphic

  } // end for nodes

  errs() << "Assigning PHI operands\n";
  
  auto AssignPHIOperandsInBlock = [&](BasicBlock *BB, std::unordered_map<BasicBlock*, BasicBlock *> &BlocksReMap) -> bool {
    for (Instruction &I : *BB) {
      if (PHINode *PHI = dyn_cast<PHINode>(&I)) {
        PHINode *NewPHI = dyn_cast<PHINode>(VMap[PHI]);

        std::set<int> FoundIndices;

        for (auto It = pred_begin(NewPHI->getParent()),
                  E = pred_end(NewPHI->getParent());
             It != E; It++) {

          BasicBlock *NewPredBB = *It;

          Value *V = nullptr;

          if (BlocksReMap.find(NewPredBB)!=BlocksReMap.end()) {
            int Index = PHI->getBasicBlockIndex(BlocksReMap[NewPredBB]);
            if (Index>=0) {
              V = MapValue(PHI->getIncomingValue(Index), VMap);
              FoundIndices.insert(Index);
            }
          }

          if (V==nullptr) V = UndefValue::get(NewPHI->getType());

          //IRBuilder<> Builder(NewPredBB->getTerminator());
          //Value *CastedV = createCastIfNeeded(V, NewPHI->getType(), Builder, IntPtrTy);
          NewPHI->addIncoming(V, NewPredBB);
        }
        if (FoundIndices.size()!=PHI->getNumIncomingValues())
          return false;
      }
    }
    return true;
  };

  for (BasicBlock *BB1 : Blocks1) {
      if (!AssignPHIOperandsInBlock(BB1, BlocksF1)) {
          if (Debug) errs() << "ERROR: PHI assignment\n";
          //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif
          return false;
      }
  }
  for (BasicBlock *BB2 : Blocks2) {
      if (!AssignPHIOperandsInBlock(BB2, BlocksF2)) {
          if (Debug) errs() << "ERROR: PHI assignment\n";
          //MergedFunc->eraseFromParent();
#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif
          return false;
      }
  }

  errs() << "Collecting offending instructions\n";
  DominatorTree DT(*MergedFunc);

  for (Instruction &I : instructions(MergedFunc)) {
    if (PHINode *PHI = dyn_cast<PHINode>(&I)) {
      for (unsigned i = 0; i<PHI->getNumIncomingValues(); i++) {
        BasicBlock *BB = PHI->getIncomingBlock(i);
	if (BB==nullptr) errs() << "Null incoming block\n";
	Value *V = PHI->getIncomingValue(i);
	if (V==nullptr) errs() << "Null incoming value\n";
        if (Instruction *IV = dyn_cast<Instruction>(V)) {
	  if (BB->getTerminator()==nullptr) errs() << "Null terminator\n";
          if (!DT.dominates(IV,BB->getTerminator())) {
            if (OffendingInsts.count(IV)==0) { OffendingInsts.insert(IV); LinearOffendingInsts.push_back(IV); }
	  }
	}
      }
    } else {
      for (unsigned i = 0; i<I.getNumOperands(); i++) {
	if (I.getOperand(i)==nullptr) {
#ifdef LLVM_ENABLE_DUMP
		//MergedFunc->dump();
		I.getParent()->dump();
		errs() << "Null operand\n";
		I.dump();
#endif
	}
        if (Instruction *IV = dyn_cast<Instruction>(I.getOperand(i))) {
	  if (!DT.dominates(IV, &I)) {
            if (OffendingInsts.count(IV)==0) { OffendingInsts.insert(IV); LinearOffendingInsts.push_back(IV); }
          }
        }
      }
    }
  }


  for (BranchInst *NewBr : XorBrConds) {
    IRBuilder<> Builder(NewBr);
    Value *XorCond = Builder.CreateXor(NewBr->getCondition(),IsFunc1);
    NewBr->setCondition(XorCond);
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.stopTimer();
#endif

#ifdef TIME_STEPS_DEBUG
  TimeCodeGenFix.startTimer();
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
        for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB); PredIt != PredE; PredIt++) {
          BasicBlock *PredBB = *PredIt;
          if (PredBB == SrcBB) {
            PHI->addIncoming(IV, PredBB);
          } else {
            PHI->addIncoming(UndefValue::get(IV->getType()), PredBB);
          }
        }
        Builder.CreateStore(PHI, Addr);
      } else {
        for (auto SuccIt = succ_begin(SrcBB), SuccE = succ_end(SrcBB); SuccIt!=SuccE; SuccIt++) {
          BasicBlock *DestBB = *SuccIt;

          Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
          // create PHI
          PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
          for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB); PredIt != PredE; PredIt++) {
            BasicBlock *PredBB = *PredIt;
            if (PredBB == SrcBB) {
              PHI->addIncoming(IV, PredBB);
            } else {
              PHI->addIncoming(UndefValue::get(IV->getType()), PredBB);
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
        //Builder.SetInsertPoint(&*IV->getParent()->getFirstInsertionPt());
        Builder.SetInsertPoint(IV->getParent()->getTerminator());
      } else
        Builder.SetInsertPoint(InsertPt);

      Builder.CreateStore(IV, Addr);
    }
  };

  auto MemfyInst = [&](std::set<Instruction *> &InstSet) -> AllocaInst* {
    if (InstSet.empty()) return nullptr;
    IRBuilder<> Builder(&*PreBB->getFirstInsertionPt());
    Type *AddrType = (*InstSet.begin())->getType();
    AllocaInst *Addr = Builder.CreateAlloca(AddrType);

    for (Instruction *I : InstSet) {
      for (auto UIt = I->use_begin(), E = I->use_end(); UIt != E;) {
        Use &UI = *UIt;
        UIt++;

        Instruction *User = cast<Instruction>(UI.getUser());

        if (PHINode *PHI = dyn_cast<PHINode>(User)) {
          ///TODO: make sure getOperandNo is getting the correct incoming edge
          IRBuilder<> Builder(PHI->getIncomingBlock(UI.getOperandNo())->getTerminator());
          UI.set(Builder.CreateLoad(AddrType, Addr));
        } else {
          IRBuilder<> Builder(User);
          UI.set(Builder.CreateLoad(AddrType, Addr));
        }
      }
    }

    for (Instruction *I : InstSet)
      StoreInstIntoAddr(I, Addr);

    return Addr;
  };

  auto isCoalescingProfitable = [&](Instruction *I1, Instruction *I2) -> bool {
    std::set<BasicBlock*> BBSet1;
    std::set<BasicBlock*> UnionBB;
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
        if (BBSet1.find(BB2)!=BBSet1.end())
          Intersection++;
      }
    }

    const float Threshold = 0.7;
    return ( float(Intersection)/float(UnionBB.size()) > Threshold );
  };

  auto OptimizeCoalescing = [&](Instruction *I, std::set<Instruction *> &InstSet, std::map<Instruction*,std::map<Instruction*,unsigned> > &CoalescingCandidates, std::set<Instruction *> &Visited) {    
    Instruction *OtherI = nullptr;
    unsigned Score = 0;
    if (CoalescingCandidates.find(I)!=CoalescingCandidates.end()) {
      for (auto &Pair : CoalescingCandidates[I]) {
        if (Pair.second>Score && Visited.find(Pair.first)==Visited.end()) {
          if (isCoalescingProfitable(I,Pair.first)) {
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
        if (CoalescingCandidates.find(OI)!=CoalescingCandidates.end()) continue;
        if( (BlocksF2.find(I->getParent())==BlocksF2.end() && BlocksF1.find(OI->getParent())==BlocksF1.end()) ||
            (BlocksF2.find(OI->getParent())==BlocksF2.end() && BlocksF1.find(I->getParent())==BlocksF1.end()) ) {
          OtherI = OI;
          break;
        }
      }
    }
    */
    if (OtherI) {
      InstSet.insert(OtherI);
      //errs() << "Coalescing: " << GetValueName(I->getParent()) << ":"; I->dump();
      //errs() << "With: " << GetValueName(OtherI->getParent()) << ":"; OtherI->dump();
    }
  };

  errs() << "Finishing code\n";
  if (MergedFunc!=nullptr) {
    errs() << "Offending: " << OffendingInsts.size() << " ";
    //errs() << ((float)OffendingInsts.size())/((float)AlignedSeq.size()) << " : ";
    if (OffendingInsts.size()>1000) {
    //if (false) {
    //if ( ((float)OffendingInsts.size())/((float)AlignedSeq.size()) > 4.5 ) {
      if (Debug) errs() << "Bailing out\n";
#ifdef TIME_STEPS_DEBUG
  TimeCodeGenFix.stopTimer();
#endif
      return false;
    } else {
      std::set<Instruction*> Visited;
      for (Instruction *I : LinearOffendingInsts) {
        if (Visited.find(I)!=Visited.end()) continue;

        std::set<Instruction*> InstSet;
        InstSet.insert(I);

      	//Create a coalescing group in InstSet
        if (EnablePHICoalescing)
      	  OptimizeCoalescing(I,InstSet,CoalescingCandidates,Visited);

        for (Instruction *OtherI : InstSet)
      	  Visited.insert(OtherI);

        AllocaInst *Addr = MemfyInst(InstSet);
        if (Addr) Allocas.push_back( Addr );
      }

      //errs() << "Fixed Domination:\n";
      //MergedFunc->dump();
      
      DominatorTree DT(*MergedFunc);
      PromoteMemToReg(Allocas, DT, nullptr);

      //errs() << "Mem2Reg:\n";
      //MergedFunc->dump();

      if ( verifyFunction(*MergedFunc) ) {
	errs() << "ERROR: Produced Broken Function!\n";
#ifdef TIME_STEPS_DEBUG
  TimeCodeGenFix.stopTimer();
#endif
        return false;
      }
      postProcessFunction(*MergedFunc);
      //errs() << "PostProcessing:\n";
      //MergedFunc->dump();
    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGenFix.stopTimer();
#endif

  return MergedFunc!=nullptr;
}

