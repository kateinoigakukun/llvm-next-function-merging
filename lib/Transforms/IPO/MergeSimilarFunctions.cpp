//===- MergeSimilarFunctions.cpp - Merge similar functions ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass merges both equivalent and similar functions to reduce code size.
//
// For a more detailed explanation of the approach, see:
// Edler von Koch et al. "Exploiting Function Similarity for Code Size
// Reduction", LCTES 2014.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "mergesimilarfunc"
#include "llvm/InitializePasses.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/FoldingSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/Statistic.h"
//#include "llvm/IR/CallSite.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InlineAsm.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include <vector>
#include <list>
using namespace llvm;

#define DEBUG(_X_)

STATISTIC(NumFunctionsMerged, "Number of functions merged");
STATISTIC(NumThunksWritten, "Number of thunks generated");
STATISTIC(NumAliasesWritten, "Number of aliases generated");
STATISTIC(NumDoubleWeak, "Number of new functions created");
STATISTIC(NumMultiMerged, "Number of multi-merged functions");

STATISTIC(NumSimilarFunctionsMerged, "Number of similar functions merged");

static cl::opt<unsigned> MergeMinInsts(
    "mergesimilarfunc-min-insts", cl::Hidden, cl::init(4),
    cl::desc("Min instructions required to even consider single block fns"));

static cl::opt<unsigned> MergeDifferingMinInsts(
    "mergesimilarfunc-diff-min-insts", cl::Hidden, cl::init(15),
    cl::desc("Min instructions required to try merging differing functions"));

static cl::opt<unsigned> MergeMaxDiffering(
    "mergesimilarfunc-max-diff", cl::Hidden, cl::init(8),
    cl::desc("Maximum number of differing instructions allowed"));

static cl::opt<unsigned> MergeMinSimilarity(
    "mergesimilarfunc-min-similarity", cl::Hidden, cl::init(70),
    cl::desc("Minimum percentage of similar instructions required"));

static cl::opt<bool> OptPrintMerges("mergesimilarfunc-print-merges", cl::Hidden,
                                    cl::init(false));

static cl::opt<bool> UseGlobalAliases(
    "mergesimilarfunc-global-aliases", cl::Hidden, cl::init(false),
    cl::desc("Enable writing alias by enabling global aliases"));

static cl::opt<bool> MSFDebug("mergesimilarfunc-debug", cl::Hidden,
                                    cl::init(false));

void PrintMerges(const char *Desc, Function *Old, Function *New) {
  if (OptPrintMerges) {
    dbgs() << "=== [" << Desc << "] replacing " << Old->getName() << " with "
           << New->getName() << "\n";
  }
}

// Minimize the name pollution caused by the enum values.
namespace Opt {
enum MergeLevelEnum { none, size, all };
static cl::opt<enum MergeLevelEnum> MergeLevel(
    "mergesimilarfunc-level", cl::Hidden, cl::ZeroOrMore,
    cl::desc("Level of function merging:"), cl::init(size),
    cl::values(clEnumVal(none, "function merging disabled"),
               clEnumVal(size, "only try to merge functions that are optimized "
                               "for size"),
               //clEnumVal(all, "attempt to merge all similar functions"),
               //clEnumValEnd));
               clEnumVal(all, "attempt to merge all similar functions")));
}

static const char *MERGED_SUFFIX = "__merged";

/// Returns the type id for a type to be hashed. We turn pointer types into
/// integers here because the actual compare logic below considers pointers and
/// integers of the same size as equal.
static Type::TypeID getTypeIDForHash(Type *Ty) {
  if (Ty->isPointerTy())
    return Type::IntegerTyID;
  return Ty->getTypeID();
}

/// Creates a hash-code for the function which is the same for any two
/// functions that will compare equal, without looking at the instructions
/// inside the function.
static unsigned profileFunction(const Function *F) {
  FunctionType *FTy = F->getFunctionType();

  FoldingSetNodeID ID;
  ID.AddInteger(F->size());
  ID.AddInteger(F->getCallingConv());
  ID.AddBoolean(F->hasGC());
  ID.AddBoolean(F->isInterposable());
  ID.AddBoolean(FTy->isVarArg());
  ID.AddInteger(getTypeIDForHash(FTy->getReturnType()));
  for (unsigned i = 0, e = FTy->getNumParams(); i != e; ++i)
    ID.AddInteger(getTypeIDForHash(FTy->getParamType(i)));
  return ID.ComputeHash();
}


/// Replace Inst1 by a switch statement that executes Inst1 or one of Inst2s
/// depending on the value of SwitchVal. If a value in Inst2s is NULL, it
/// defaults to executing Inst1. Returns set of terminator instructions of newly
/// created switch blocks in Ret.
///
/// For instance, the transformation may look as follows:
///         ...Head...
///           Inst1           with all of Insts2s without parents
///         ...Tail...
///  into
///         ...Head...
///           Switch
///         /     |       \                    .
///    (default) (1)       (2)
///      Inst1   Inst2s[0] Inst2s[1]
///     Ret[0]   Ret[1]    Ret[2]
///        \      |       /
///         ...Tail...
///
static void SplitBlockAndInsertSwitch(
    Value *SwitchVal, Instruction *Inst1,
    SmallVectorImpl<Instruction *> &Inst2s,
    SmallVectorImpl<Instruction *> &Ret) {
  // Split block
  BasicBlock *Head = Inst1->getParent();
  BasicBlock *Tail = Head->splitBasicBlock(Inst1);

  // Create default block
  LLVMContext &C = Head->getContext();
  BasicBlock *DefaultBlock = BasicBlock::Create(C, "", Head->getParent(), Tail);

  // Insert switch instruction at end of Head
  Instruction *HeadOldTerm = Head->getTerminator();
  SwitchInst *Switch = SwitchInst::Create(SwitchVal, DefaultBlock,
                                               Inst2s.size());
  ReplaceInstWithInst(HeadOldTerm, Switch);

  // Move instructions into the blocks
  if (Inst1->isTerminator()) {
    Inst1->removeFromParent();
    DefaultBlock->getInstList().push_back(Inst1);
    Ret.push_back(cast<Instruction>(Inst1));
  } else {
    Instruction *DefaultTerm = BranchInst::Create(Tail, DefaultBlock);
    Inst1->moveBefore(DefaultTerm);
    Ret.push_back(DefaultTerm);
  }

  for (unsigned InstPos = 0, InstNum = Inst2s.size(); InstPos < InstNum;
       ++InstPos) {
    Instruction *Inst2 = Inst2s[InstPos];
    if (!Inst2) {
      Ret.push_back(NULL);
      continue;
    }

    BasicBlock *CaseBlock = BasicBlock::Create(C, "", Head->getParent(), Tail);

    // Update the debug information of the merged instruction by marking it as
    // 'inlined' at this location. If only Inst1 or Inst2 has debug
    // information, we try to do something sensible that won't break the
    // verifier.
    if (Inst1->getDebugLoc()) {
      if (Inst2->getDebugLoc()) {
        const DebugLoc &I2Loc = Inst2->getDebugLoc();
        //Inst2->setDebugLoc(
        //    DebugLoc::get(I2Loc.getLine(), I2Loc.getCol(), I2Loc.getScope(),
        //                  /*InlinedAt*/ Inst1->getDebugLoc().getAsMDNode()));
      } else {
        Inst2->setDebugLoc(Inst1->getDebugLoc());
      }
    } else if (Inst2->getDebugLoc()) {
      Inst2->setDebugLoc(DebugLoc());
    }

    if (Inst2->isTerminator()) {
      assert(Inst1->isTerminator() &&
        "Inst1 and Inst2 must both be terminators or non-terminators!");
      CaseBlock->getInstList().push_back(Inst2);
      Ret.push_back(cast<Instruction>(Inst2));
    } else {
      Instruction *CaseTerm = BranchInst::Create(Tail, CaseBlock);
      Inst2->insertBefore(CaseTerm);
      Ret.push_back(CaseTerm);
    }

    Switch->addCase(ConstantInt::get(cast<IntegerType>(SwitchVal->getType()),
                                     InstPos+1),
                    CaseBlock);
  }

  // If Inst1 (and Inst2s) are TerminatorInst's, Tail will be empty and can be
  // deleted now. We also need to update PHI nodes to add the additional
  // incoming blocks from the SwitchInst.
  if (Inst1->isTerminator()) {
    for (succ_iterator I = succ_begin(DefaultBlock), E = succ_end(DefaultBlock);
         I != E; ++I) {
      BasicBlock *Successor = *I;
      PHINode *Phi;

      for (BasicBlock::iterator II = Successor->begin();
           (Phi = dyn_cast<PHINode>(II)); ++II)
        for (unsigned ValId = 0, ValEnd = Phi->getNumIncomingValues();
             ValId != ValEnd; ++ValId)
          if (Phi->getIncomingBlock(ValId) == Tail) {
            Phi->setIncomingBlock(ValId, DefaultBlock);
            SmallVectorImpl<Instruction *>::iterator
              SwitchI = Ret.begin(), SwitchE = Ret.end();
            for (++SwitchI; SwitchI != SwitchE; ++SwitchI) {
              if (!*SwitchI)
                continue;
              Phi->addIncoming(Phi->getIncomingValue(ValId),
                               (*SwitchI)->getParent());
            }
          }
    }

    Tail->eraseFromParent();
  }
}

/// Insert function NewF into module, placing it immediately after the
/// existing function PredF. If PredF does not exist, insert at the end.
static void insertFunctionAfter(Function *NewF, Function *PredF) {
  Module *M = PredF->getParent();
  Module::FunctionListType &FList = M->getFunctionList();

  for (Module::FunctionListType::iterator I = FList.begin(), E = FList.end();
      I != E; ++I) {
    if (PredF == &*I) {
      FList.insertAfter(I, NewF);
      return;
    }
  }

  // Couldn't find PredF, insert at end
  FList.push_back(NewF);
}

/// Create a cast instruction if needed to cast V to type DstType. We treat
/// pointer and integer types of the same bitwidth as equivalent, so this can be
/// used to cast them to each other where needed. The function returns the Value
/// itself if no cast is needed, or a new CastInst instance inserted before
/// InsertBefore. The integer type equivalent to pointers must be passed as
/// IntPtrType (get it from DataLayout). This is guaranteed to generate no-op
/// casts, otherwise it will assert.
static Value *createCastIfNeeded(Value *V, Type *DstType,
                                 Value *InstrOrBB, Type *IntPtrType) {
  if (V->getType() == DstType)
    return V;

  BasicBlock *InsertAtEnd = dyn_cast<BasicBlock>(InstrOrBB);
  Instruction *InsertBefore = dyn_cast<Instruction>(InstrOrBB);
  BasicBlock *InsertBB = InsertAtEnd ? InsertAtEnd : InsertBefore->getParent();

  CastInst *Result;
  Type *OrigType = V->getType();

  if (OrigType->isStructTy()) {
    assert(DstType->isStructTy());
    assert(OrigType->getStructNumElements() == DstType->getStructNumElements());

    IRBuilder<> Builder(InsertBB);
    if (InsertBefore)
      Builder.SetInsertPoint(InsertBefore);
    Value *Result = UndefValue::get(DstType);
    for (unsigned int I = 0, E = OrigType->getStructNumElements(); I < E; ++I) {
      Value *ExtractedValue
        = Builder.CreateExtractValue(V, ArrayRef<unsigned int>(I));
      Value *Element = createCastIfNeeded(ExtractedValue,
                                          DstType->getStructElementType(I),
                                          InstrOrBB, IntPtrType);
      Result =
          Builder.CreateInsertValue(Result, Element, ArrayRef<unsigned int>(I));
    }
    return Result;
  }
  assert(!DstType->isStructTy());

  if (OrigType->isPointerTy()
      && (DstType->isIntegerTy() || DstType->isPointerTy())) {
    if (InsertBefore)
      Result = CastInst::CreatePointerCast(V, DstType, "", InsertBefore);
    else
      Result = CastInst::CreatePointerCast(V, DstType, "", InsertAtEnd);
  } else if (OrigType->isIntegerTy() && DstType->isPointerTy()
             && OrigType == IntPtrType) {
    // Int -> Ptr
    if (InsertBefore) {
      Result = CastInst::Create(CastInst::IntToPtr, V, DstType, "",
                                InsertBefore);
    } else {
      Result = CastInst::Create(CastInst::IntToPtr, V, DstType, "",
                                InsertAtEnd);
    }
  } else {
    llvm_unreachable("Can only cast int -> ptr or ptr -> (ptr or int)");
  }

  //assert(cast<CastInst>(Result)->isNoopCast(InsertAtEnd->getParent()->getParent()->getDataLayout()) &&
  //    "Cast is not a no-op cast. Potential loss of precision");

  return Result;
}

namespace {

/// ComparableFunction - A struct that pairs together functions with a
/// DataLayout so that we can keep them together as elements in the DenseSet.
class ComparableFunction {
public:
  ComparableFunction() : Func(0), IsNew(false) { }

  ComparableFunction(const ComparableFunction &that)
    : Func(that.Func), IsNew(that.IsNew) {
  }

  ComparableFunction(Function *Func) : Func(Func), IsNew(true) { }

  ~ComparableFunction() { }

  ComparableFunction &operator=(const ComparableFunction &that) {
    Func = that.Func;
    IsNew = that.IsNew;
    return *this;
  }

  Function *getFunc() const { return Func; }
  bool isNew() const { return IsNew; }

  // Drops AssertingVH reference to the function. Outside of debug mode, this
  // does nothing.
  void release() {
    assert(Func &&
           "Attempted to release function twice, or release empty/tombstone!");
    Func = NULL;
  }

  void markCompared() {
    IsNew = false;
  }
private:
  AssertingVH<Function> Func;
  bool IsNew;
};

}

namespace {

/// FunctionComparator - Compares two functions to determine whether or not
/// they will generate machine code with the same behaviour. DataLayout is
/// used if available. The comparator always fails conservatively (erring on the
/// side of claiming that two functions are different).
class FunctionComparator {
public:
  FunctionComparator(const DataLayout *DL, Function *F1, Function *F2)
    : isDifferent(false), isNotMergeable(false),
      BasicBlockCount(0), InstructionCount(0), DifferingInstructionsCount(0),
      F1(F1), F2(F2), SimilarityMetric(0), DL(DL), ID(CurID++) {}

  ~FunctionComparator() {}

  /// Test whether the two functions have equivalent behaviour. Returns true if
  /// they are equal or can be merged, false if not.
  bool compare();

  /// Indicate whether the two functions are an exact match after comparison
  bool isExactMatch();

  /// Indicate whether the two functions candidates for merging after comparison
  bool isMergeCandidate();

  /// Get a similarity metric between the two functions. Higher means more
  /// similar.
  unsigned getSimilarityMetric() {
    if (!SimilarityMetric)
      SimilarityMetric = (unsigned)(((float)InstructionCount -
            DifferingInstructionsCount)/InstructionCount*10000);
    return SimilarityMetric;
  }

  Function *getF1() { return F1; }
  Function *getF2() { return F2; }
  ValueToValueMapTy &getF1toF2Map() { return id_map; }
  ValueToValueMapTy &getF2toF1Map() { return seen_values; }
  const DataLayout *getDataLayout() { return DL; }

  /// Assign or look up previously assigned numbers for the two values, and
  /// return whether the numbers are equal. Numbers are assigned in the order
  /// visited. If NoSelfRef is set, F1 and F2 are not assigned to each other
  /// (treated as 'equal').
  bool enumerate(const Value *V1, const Value *V2, bool NoSelfRef=false);

  /// Compare two Types, treating all pointer types as equal.
  bool isEquivalentType(Type *Ty1, Type *Ty2) const;

  /// Instructions that differ between the two functions (F1's -> F2's inst).
  MapVector<const Instruction *, const Instruction *> DifferingInstructions;

  /// Instructions that reference F1/F2 itself (recursive calls etc.)
  /// These may need special treatment when merging differing functions.
  MapVector<const Instruction *, const Instruction *> SelfRefInstructions;

  /// Return the unique ID for the object.
  unsigned getID() { return ID; }

  bool isDifferent;
  bool isNotMergeable;

  // Comparison statistics
  unsigned BasicBlockCount;
  unsigned InstructionCount;
  unsigned DifferingInstructionsCount;

private:
  /// Test whether two basic blocks have equivalent behaviour. Returns true if
  /// they are equal or can be merged, false if not. PHINodes are not compared
  /// in this function, but added to the PHIsFound list for delayed processing.
  bool compare(const BasicBlock *BB1, const BasicBlock *BB2,
      std::list<std::pair<const PHINode*,const PHINode*> > *PHIsFound);

  /// Compare pairs of PHI nodes. Returns true if all pairs are equal or can
  /// be merged, false if not.
  bool comparePHIs(
      const std::list<std::pair<const PHINode*,const PHINode*> > &PHIs);

  /// Compare two Instructions for equivalence, similar to
  /// Instruction::isSameOperationAs but with modifications to the type
  /// comparison.
  bool isEquivalentOperation(const Instruction *I1,
                             const Instruction *I2) const;

  /// Compare two GEPs for equivalent pointer arithmetic.
  bool isEquivalentGEP(const GEPOperator *GEP1, const GEPOperator *GEP2);
  bool isEquivalentGEP(const GetElementPtrInst *GEP1,
                       const GetElementPtrInst *GEP2) {
    return isEquivalentGEP(cast<GEPOperator>(GEP1), cast<GEPOperator>(GEP2));
  }

  // The two functions undergoing comparison.
  Function *F1, *F2;

  unsigned SimilarityMetric;

  const DataLayout *DL;

  ValueToValueMapTy id_map;
  ValueToValueMapTy seen_values;

  // Maintain a unique ID for each object.
  static unsigned CurID;
  unsigned ID;
};

}

unsigned FunctionComparator::CurID = 0;

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
bool FunctionComparator::isEquivalentType(Type *Ty1, Type *Ty2) const {
  if (Ty1 == Ty2)
    return true;
  if (Ty1->getTypeID() != Ty2->getTypeID()) {
    LLVMContext &Ctx = Ty1->getContext();
    if (isa<PointerType>(Ty1) && Ty2 == DL->getIntPtrType(Ctx)) return true;
    if (isa<PointerType>(Ty2) && Ty1 == DL->getIntPtrType(Ctx)) return true;
    return false;
  }

  switch (Ty1->getTypeID()) {
  default:
    llvm_unreachable("Unknown type!");
    // Fall through in Release mode.
  case Type::IntegerTyID:
  //case Type::VectorTyID:
  case Type::FixedVectorTyID:
  case Type::ScalableVectorTyID:
    // Ty1 == Ty2 would have returned true earlier.
    return false;

  case Type::VoidTyID:
  case Type::FloatTyID:
  case Type::DoubleTyID:
  case Type::X86_FP80TyID:
  case Type::FP128TyID:
  case Type::PPC_FP128TyID:
  case Type::LabelTyID:
  case Type::MetadataTyID:
    return true;

  case Type::PointerTyID: {
    PointerType *PTy1 = cast<PointerType>(Ty1);
    PointerType *PTy2 = cast<PointerType>(Ty2);
    return PTy1->getAddressSpace() == PTy2->getAddressSpace();
  }

  case Type::StructTyID: {
    StructType *STy1 = cast<StructType>(Ty1);
    StructType *STy2 = cast<StructType>(Ty2);
    if (STy1->getNumElements() != STy2->getNumElements())
      return false;

    if (STy1->isPacked() != STy2->isPacked())
      return false;

    for (unsigned i = 0, e = STy1->getNumElements(); i != e; ++i) {
      if (!isEquivalentType(STy1->getElementType(i), STy2->getElementType(i)))
        return false;
    }
    return true;
  }

  case Type::FunctionTyID: {
    FunctionType *FTy1 = cast<FunctionType>(Ty1);
    FunctionType *FTy2 = cast<FunctionType>(Ty2);
    if (FTy1->getNumParams() != FTy2->getNumParams() ||
        FTy1->isVarArg() != FTy2->isVarArg())
      return false;

    if (!isEquivalentType(FTy1->getReturnType(), FTy2->getReturnType()))
      return false;

    for (unsigned i = 0, e = FTy1->getNumParams(); i != e; ++i) {
      if (!isEquivalentType(FTy1->getParamType(i), FTy2->getParamType(i)))
        return false;
    }
    return true;
  }

  case Type::ArrayTyID: {
    ArrayType *ATy1 = cast<ArrayType>(Ty1);
    ArrayType *ATy2 = cast<ArrayType>(Ty2);
    return ATy1->getNumElements() == ATy2->getNumElements() &&
           isEquivalentType(ATy1->getElementType(), ATy2->getElementType());
  }
  }
}

// Determine whether the two operations are the same except that pointer-to-A
// and pointer-to-B are equivalent. This should be kept in sync with
// Instruction::isSameOperationAs.
bool FunctionComparator::isEquivalentOperation(const Instruction *I1,
                                               const Instruction *I2) const {
  // Differences from Instruction::isSameOperationAs:
  //  * replace type comparison with calls to isEquivalentType.
  //  * we test for I->hasSameSubclassOptionalData (nuw/nsw/tail) at the top
  //  * because of the above, we don't test for the tail bit on calls later on
  if (I1->getOpcode() != I2->getOpcode() ||
      I1->getNumOperands() != I2->getNumOperands() ||
      !isEquivalentType(I1->getType(), I2->getType()) ||
      !I1->hasSameSubclassOptionalData(I2))
    return false;

  // We have two instructions of identical opcode and #operands.  Check to see
  // if all operands are the same type
  for (unsigned i = 0, e = I1->getNumOperands(); i != e; ++i)
    if (!isEquivalentType(I1->getOperand(i)->getType(),
                          I2->getOperand(i)->getType()))
      return false;

  // Check special state that is a part of some instructions.
  if (const LoadInst *LI = dyn_cast<LoadInst>(I1)) {
    const LoadInst *LI2 = cast<LoadInst>(I2);
    return LI->isVolatile() == LI2->isVolatile() &&
           LI->getAlignment() == LI2->getAlignment() &&
           LI->getOrdering() == LI2->getOrdering() &&
           //LI->getSynchScope() == LI2->getSynchScope() &&
           LI->getSyncScopeID() == LI2->getSyncScopeID() &&
           LI->getMetadata(LLVMContext::MD_range)
             == LI2->getMetadata(LLVMContext::MD_range);
  }
  if (const StoreInst *SI = dyn_cast<StoreInst>(I1))
    return SI->isVolatile() == cast<StoreInst>(I2)->isVolatile() &&
           SI->getAlignment() == cast<StoreInst>(I2)->getAlignment() &&
           SI->getOrdering() == cast<StoreInst>(I2)->getOrdering() &&
           //SI->getSynchScope() == cast<StoreInst>(I2)->getSynchScope();
           SI->getSyncScopeID() == cast<StoreInst>(I2)->getSyncScopeID();
  if (const AllocaInst *AI = dyn_cast<AllocaInst>(I1)) {
    if (AI->getArraySize() != cast<AllocaInst>(I2)->getArraySize() ||
        AI->getAlignment() != cast<AllocaInst>(I2)->getAlignment())
      return false;

    // If size is known, I2 can be seen as equivalent to I1 if it allocates
    // the same or less memory.
    if (DL->getTypeAllocSize(AI->getAllocatedType())
          < DL->getTypeAllocSize(cast<AllocaInst>(I2)->getAllocatedType()))
      return false;

    return true;
  }
  if (const CmpInst *CI = dyn_cast<CmpInst>(I1))
    return CI->getPredicate() == cast<CmpInst>(I2)->getPredicate();
  if (const CallInst *CI = dyn_cast<CallInst>(I1))
    return CI->getCallingConv() == cast<CallInst>(I2)->getCallingConv() &&
           CI->getAttributes() == cast<CallInst>(I2)->getAttributes();
  if (const InvokeInst *CI = dyn_cast<InvokeInst>(I1))
    return CI->getCallingConv() == cast<InvokeInst>(I2)->getCallingConv() &&
           CI->getAttributes() == cast<InvokeInst>(I2)->getAttributes();
  if (const InsertValueInst *IVI = dyn_cast<InsertValueInst>(I1))
    return IVI->getIndices() == cast<InsertValueInst>(I2)->getIndices();
  if (const ExtractValueInst *EVI = dyn_cast<ExtractValueInst>(I1))
    return EVI->getIndices() == cast<ExtractValueInst>(I2)->getIndices();
  if (const FenceInst *FI = dyn_cast<FenceInst>(I1))
    return FI->getOrdering() == cast<FenceInst>(I2)->getOrdering() &&
           //FI->getSynchScope() == cast<FenceInst>(I2)->getSynchScope();
           FI->getSyncScopeID() == cast<FenceInst>(I2)->getSyncScopeID();
  if (const AtomicCmpXchgInst *CXI = dyn_cast<AtomicCmpXchgInst>(I1)) {
    const AtomicCmpXchgInst *CXI2 = cast<AtomicCmpXchgInst>(I2);
    return CXI->isVolatile() == CXI2->isVolatile() &&
           CXI->isWeak() == CXI2->isWeak() &&
           CXI->getSuccessOrdering() == CXI2->getSuccessOrdering() &&
           CXI->getFailureOrdering() == CXI2->getFailureOrdering() &&
           //CXI->getSynchScope() == CXI2->getSynchScope();
           CXI->getSyncScopeID() == CXI2->getSyncScopeID();
  }
  if (const AtomicRMWInst *RMWI = dyn_cast<AtomicRMWInst>(I1))
    return RMWI->getOperation() == cast<AtomicRMWInst>(I2)->getOperation() &&
           RMWI->isVolatile() == cast<AtomicRMWInst>(I2)->isVolatile() &&
           RMWI->getOrdering() == cast<AtomicRMWInst>(I2)->getOrdering() &&
           //RMWI->getSynchScope() == cast<AtomicRMWInst>(I2)->getSynchScope();
           RMWI->getSyncScopeID() == cast<AtomicRMWInst>(I2)->getSyncScopeID();

  return true;
}

// Determine whether two GEP operations perform the same underlying arithmetic.
bool FunctionComparator::isEquivalentGEP(const GEPOperator *GEP1,
                                         const GEPOperator *GEP2) {
  // When we have target data, we can reduce the GEP down to the value in bytes
  // added to the address.
  if (GEP1->hasAllConstantIndices() && GEP2->hasAllConstantIndices()) {
    SmallVector<Value *, 8> Indices1(GEP1->idx_begin(), GEP1->idx_end());
    SmallVector<Value *, 8> Indices2(GEP2->idx_begin(), GEP2->idx_end());
    uint64_t Offset1 = DL->getIndexedOffsetInType(GEP1->getSourceElementType(),
                                            Indices1);
    uint64_t Offset2 = DL->getIndexedOffsetInType(GEP2->getSourceElementType(),
                                            Indices2);
    return Offset1 == Offset2;
  }

  if (GEP1->getPointerOperand()->getType() !=
      GEP2->getPointerOperand()->getType())
    return false;

  if (GEP1->getNumOperands() != GEP2->getNumOperands())
    return false;

  for (unsigned i = 0, e = GEP1->getNumOperands(); i != e; ++i) {
    if (!enumerate(GEP1->getOperand(i), GEP2->getOperand(i)))
      return false;
  }

  return true;
}

// Compare two values used by the two functions under pair-wise comparison. If
// this is the first time the values are seen, they're added to the mapping so
// that we will detect mismatches on next use.
bool FunctionComparator::enumerate(const Value *V1, const Value *V2,
    bool NoSelfRef/*=false*/) {
  // Check for function @f1 referring to itself and function @f2 referring to
  // itself. For compatibility with llvm's MergeFunctions, disallow referring to
  // each other, or both referring to either of them.
  if (!NoSelfRef && V1 == F1 && V2 == F2)
    return true;

  if (const Constant *C1 = dyn_cast<Constant>(V1)) {
    if (V1 == V2) return true;
    const Constant *C2 = dyn_cast<Constant>(V2);
    if (!C2) return false;
    // TODO: constant expressions with GEP or references to F1 or F2.
    if (C1->isNullValue() && C2->isNullValue() &&
        isEquivalentType(C1->getType(), C2->getType()))
      return true;
    // Try bitcasting C2 to C1's type. If the bitcast is legal and returns C1
    // then they must have equal bit patterns. Aggregate types cannot be
    // bitcast.
    if (C1->getType()->isAggregateType() || C2->getType()->isAggregateType())
      return false;
    return C1->getType()->canLosslesslyBitCastTo(C2->getType()) &&
      C1 == ConstantExpr::getBitCast(const_cast<Constant*>(C2), C1->getType());
  }

  if (isa<InlineAsm>(V1) || isa<InlineAsm>(V2))
    return V1 == V2;

  // Check that V1 maps to V2. If we find a value that V1 maps to then we simply
  // check whether it's equal to V2. When there is no mapping then we need to
  // ensure that V2 isn't already equivalent to something else. For this
  // purpose, we track the V2 values in a set.

  ValueToValueMapTy::iterator I = id_map.find(V1);
  if (I != id_map.end())
    return V2 == I->second;
  // FIXME: Const casts!!!
  if (!seen_values.insert(std::make_pair(V2, const_cast<Value *>(V1))).second)
    return false;
  id_map[V1] = const_cast<Value *>(V2);
  return true;
}

/// Test whether two basic blocks have equivalent behaviour. Returns true if the
/// blocks can be merged, false if they cannot. Differing instructions are
/// recorded in DifferingInstructions.
bool FunctionComparator::compare(const BasicBlock *BB1, const BasicBlock *BB2,
    std::list<std::pair<const PHINode*,const PHINode*> > *PHIsFound) {
  BasicBlock::const_iterator F1I, F1E, F2I, F2E;

  for (F1I = BB1->begin(), F1E = BB1->end(),
       F2I = BB2->begin(), F2E = BB2->end();
       F1I != F1E && F2I != F2E; ++F1I, ++F2I) {
    // Skip debug information
    const CallInst *DbgCall;
    while (F1I != F1E && (DbgCall = dyn_cast<CallInst>(F1I)) &&
           DbgCall->getCalledFunction() &&
           DbgCall->getCalledFunction()->hasName() &&
           DbgCall->getCalledFunction()->getName().startswith("llvm.dbg."))
      ++F1I;

    while (F2I != F2E && (DbgCall = dyn_cast<CallInst>(F2I)) &&
           DbgCall->getCalledFunction() &&
           DbgCall->getCalledFunction()->hasName() &&
           DbgCall->getCalledFunction()->getName().startswith("llvm.dbg."))
      ++F2I;

    if (F1I == F1E || F2I == F2E)
      break;

    // Ok, we're dealing with real instructions. Check a few cases that will
    // prevent merging first.
    const Instruction *F1In = &*F1I;
    const Instruction *F2In = &*F2I;

    // Cannot merge insts that differ in whether they have uses
    if (F1In->use_empty() != F2In->use_empty()) {
      // TODO: Could implement merging for this case (would need to introduce a
      // dummy value in the PHI node etc.)
      return false;
    }

    // Cannot merge insts whose types are non-equivalent
    if (!isEquivalentType(F1In->getType(), F2In->getType())) {
      return false;
    }

    // TODO:  Currently cannot merge InvokeInsts with differing result types
    //        that have uses. We cannot push up a bitcast into their block after
    //        them because they are terminators. Would need to insert an
    //        additional BB.
    if (isa<InvokeInst>(F1In) && !F1In->use_empty() &&
        F1In->getType() != F2In->getType())
      return false;

    if (!enumerate(F1In, F2In))
      goto differing_instructions;

    if (const GetElementPtrInst *GEP1 = dyn_cast<GetElementPtrInst>(F1In)) {
      const GetElementPtrInst *GEP2 = dyn_cast<GetElementPtrInst>(F2In);
      if (!GEP2)
        goto differing_instructions;

      if (!enumerate(GEP1->getPointerOperand(), GEP2->getPointerOperand()))
        goto differing_instructions;

      if (!isEquivalentGEP(GEP1, GEP2))
        goto differing_instructions;
    } else if (const PHINode *Phi1 = dyn_cast<PHINode>(F1In)) {
      const PHINode *Phi2 = dyn_cast<PHINode>(F2In);
      // We can't currently merge a PHI and non-PHI instruction
      if (!Phi2)
        return false;

      // We can't currently merge PHI nodes with different numbers of incoming
      // values
      if (F1In->getNumOperands() != F2In->getNumOperands())
        return false;

      // We need to treat PHI nodes specially. Their incoming values may be in a
      // different order even if they are equivalent. We can't compare them
      // until we've seen the incoming blocks and know which values are
      // equivalent. Therefore postpone PHINode comparison until the end.
      PHIsFound->push_back(std::make_pair(Phi1, Phi2));
    } else {
      if (!isEquivalentOperation(F1In, F2In))
        goto differing_instructions;

      bool IsCall = isa<CallInst>(F1In);
      assert(F1In->getNumOperands() == F2In->getNumOperands());
      for (unsigned i = 0, e = F1In->getNumOperands(); i != e; ++i) {
        Value *OpF1 = F1In->getOperand(i);
        Value *OpF2 = F2In->getOperand(i);

        // Allow self-reference if this is a call instruction and the last
        // operand which is the called function
        bool AllowSelfRef = IsCall && (i + 1) == e;

        if (!enumerate(OpF1, OpF2, !AllowSelfRef))
          goto differing_instructions;

        if (!isEquivalentType(OpF1->getType(), OpF2->getType()))
          goto differing_instructions;

        if ((OpF1 == F1 && OpF2 == F2) || (OpF1 == F2 && OpF2 == F1))
          SelfRefInstructions[F1In] = F2In;
      }
    }

    continue;

differing_instructions:
    // Cannot merge functions with differing landing pad instructions yet. They
    // would need special treatment which involves updating the corresponding
    // invoke instructions.
    if (isa<LandingPadInst>(F1In))
      return false;
    if (isa<InvokeInst>(F1In))
      return false;

    DifferingInstructions[F1In] = F2In;
  }

  // We cannot currently merge basic blocks with different instruction counts
  return F1I == F1E && F2I == F2E;
}

bool FunctionComparator::comparePHIs(
  const std::list<std::pair<const PHINode*,const PHINode*> > &PHIs) {
  if (PHIs.empty())
    return true;

  for (std::list<std::pair<const PHINode*,const PHINode*> >::const_iterator
         I = PHIs.begin(), E = PHIs.end(); I != E; ++I) {
    const PHINode *Phi1 = I->first, *Phi2 = I->second;

    for (unsigned ValId = 0, ValNum = Phi1->getNumIncomingValues();
         ValId < ValNum; ++ValId) {
      Value *Phi1Val = Phi1->getIncomingValue(ValId);

      // Get corresponding Phi2Val
      Value *BBinPhi2Val = getF1toF2Map()[Phi1->getIncomingBlock(ValId)];

      if (!BBinPhi2Val)
        return false; // Currently can't handle differing predecessor blocks

      BasicBlock *BBinPhi2 = cast<BasicBlock>(BBinPhi2Val);
      Value *Phi2Val = Phi2->getIncomingValueForBlock(BBinPhi2);

      // Enumerate the values. If the PHI node references the function itself (a
      // very rare case), we mark it as different (NoSelfRef). This is only
      // necessary for outline merging, not equiv merging. TODO: Make equal
      // merging possible with such PHI nodes.
      if (!enumerate(Phi1Val, Phi2Val,/*NoSelfRef=*/true)) {
        DifferingInstructions[Phi1] = Phi2;
        break;
      }
    }
  }

  return true;
}

// Test whether the two functions have equivalent behaviour.
bool FunctionComparator::compare() {
  // We need to recheck everything, but check the things that weren't included
  // in the hash first.
  if (F1->getAttributes() != F2->getAttributes())
    goto not_mergeable;

  if (F1->hasGC() != F2->hasGC())
    goto not_mergeable;

  if (F1->hasGC() && F1->getGC() != F2->getGC())
    goto not_mergeable;

  if (!F1->getSection().equals(F2->getSection()))
    goto not_mergeable;

  if (F1->isVarArg() != F2->isVarArg())
    goto not_mergeable;

  if (F1->isInterposable() != F2->isInterposable())
    goto not_mergeable;

  if (F1->size() != F2->size())
    goto not_mergeable;

  // TODO: if it's internal and only used in direct calls, we could handle
  // this case too.
  if (F1->getCallingConv() != F2->getCallingConv())
    goto not_mergeable;

  if (!isEquivalentType(F1->getFunctionType(), F2->getFunctionType()))
    goto not_mergeable;

  assert(F1->arg_size() == F2->arg_size() &&
         "Identically typed functions have different numbers of args!");

  // Visit the arguments so that they get enumerated in the order they're
  // passed in.
  for (Function::const_arg_iterator f1i = F1->arg_begin(),
         f2i = F2->arg_begin(), f1e = F1->arg_end(); f1i != f1e; ++f1i, ++f2i) {
    if (!enumerate(&*f1i, &*f2i))
      llvm_unreachable("Arguments repeat!");
  }

  // We do a CFG-ordered walk since the actual ordering of the blocks in the
  // linked list is immaterial. Our walk starts at the entry block for both
  // functions, then takes each block from each terminator in order. As an
  // artifact, this also means that unreachable blocks are ignored.
  {
    SmallVector<const BasicBlock *, 8> F1BBs, F2BBs;
    SmallSet<const BasicBlock *, 32> VisitedBBs; // in terms of F1.
    std::list<std::pair<const PHINode*,const PHINode*> > PHIsFound;

    F1BBs.push_back(&F1->getEntryBlock());
    F2BBs.push_back(&F2->getEntryBlock());

    VisitedBBs.insert(F1BBs[0]);
    while (!F1BBs.empty()) {
      const BasicBlock *F1BB = F1BBs.pop_back_val();
      const BasicBlock *F2BB = F2BBs.pop_back_val();

      // Check for control flow divergence
      if (!enumerate(F1BB, F2BB))
        goto not_mergeable;

      const Instruction *F1TI = F1BB->getTerminator();
      const Instruction *F2TI = F2BB->getTerminator();

      // TODO: Implement merging of blocks with different numbers of
      // instructions.
      if (F1TI->getNumSuccessors() != F2TI->getNumSuccessors() ||
          F1BB->size() != F2BB->size())
        goto not_mergeable;

      // The actual instruction-by-instruction comparison
      if (!compare(F1BB, F2BB, &PHIsFound))
        goto not_mergeable;

      // FIXME: Count this in compare(F1BB,F2BB) so it doesn't include debug
      // instructions.
      InstructionCount += std::max(F1BB->size(), F2BB->size());

      assert(F1TI->getNumSuccessors() == F2TI->getNumSuccessors());
      for (unsigned i = 0, e = F1TI->getNumSuccessors(); i != e; ++i) {
        if (!VisitedBBs.insert(F1TI->getSuccessor(i)).second)
          continue;

        F1BBs.push_back(F1TI->getSuccessor(i));
        F2BBs.push_back(F2TI->getSuccessor(i));
      }
    }

    BasicBlockCount = VisitedBBs.size();

    // After we've seen all values and BBs, compare the PHI nodes
    if (!comparePHIs(PHIsFound))
      goto not_mergeable;
  }

  if (DifferingInstructions.size()) {
    // Currently we can't merge vararg functions with differing instructions.
    // TODO: Explore whether this is feasible; the difficult bit is the
    // additional argument we need to add.
    if (F1->isVarArg())
      goto not_mergeable;

    isDifferent = true;
    DifferingInstructionsCount += DifferingInstructions.size();

    DEBUG(float Metric = ((float)InstructionCount - DifferingInstructionsCount)
                         / InstructionCount*100;
          dbgs() << "Similar fns: " << F1->getName() << " and " << F2->getName()
                 << " bbs=" << BasicBlockCount << " insts=" << InstructionCount
                 << " failed=" << DifferingInstructionsCount << " metric="
                 << format("%0.2f", Metric)
                 << '\n');
  }

  return true;

not_mergeable:
  // Fail: cannot merge the two functions
  isNotMergeable = true;
  return false;
}

bool FunctionComparator::isExactMatch() {
  return (!isNotMergeable && !isDifferent);
}

bool FunctionComparator::isMergeCandidate() {
  if (isNotMergeable)
    return false;

  if (!isDifferent)
    return true;

  // Heuristic when to attempt merging
  if (InstructionCount > MergeDifferingMinInsts &&
      DifferingInstructionsCount <= MergeMaxDiffering &&
      getSimilarityMetric() > MergeMinSimilarity)
    return true;

  // Tolerate higher difference with higher similarity.
  if (InstructionCount > 100 &&
      DifferingInstructionsCount <= 60 &&
      getSimilarityMetric() > 90 )
    return true;

  return false;
}

namespace {

struct FunctionComparatorOrdering {
  bool operator () (FunctionComparator *LHS, FunctionComparator *RHS) const {
    unsigned MetricLHS = LHS->getSimilarityMetric(),
             MetricRHS = RHS->getSimilarityMetric();

    // If the metric is the same, then default to the unique ID. We need
    // to use a unique value instead of the object address to ensure
    // deterministic ordering.
    if (MetricLHS == MetricRHS)
      return LHS->getID() > RHS->getID();
    return MetricLHS > MetricRHS;
  }
};

class MergeRegistry {
public:
  typedef MapVector<unsigned, std::list<ComparableFunction> > FnCompareMap;
  typedef std::set<FunctionComparator *, FunctionComparatorOrdering>
    FnComparatorSet;
  typedef std::map<Function *, FnComparatorSet> SimilarFnMap;

  ~MergeRegistry();

  void clear();

  /// Defer a function for consideration in the next round.
  void defer(Function *F);

  /// Return true if we have deferred functions that can be enqueued.
  bool haveDeferred() { return !Deferred.empty(); }

  /// Move all the deferred functions into buckets to consider them for merging.
  /// Returns number of functions that have been added.
  unsigned enqueue();

  /// Add a candidate for merging
  void insertCandidate(FunctionComparator *Comp);

  /// Remove a Function from the FnSet and queue it up for a second sweep of
  /// analysis if Reanalyze is set. If it is a candidate for merging, remove it
  /// from consideration.
  void remove(Function *F, bool Reanalyze=true);

  /// Return the similarity metric of the most similar function to F that is
  /// not listed in the Ignore set.
  unsigned getMaxSimilarity(Function *F, const DenseSet<Function *> &Ignore);

  /// The collection of buckets that contain functions that may be similar to
  /// each other (same hash value).
  FnCompareMap FunctionsToCompare;

  std::list<FunctionComparator *> FunctionsToMerge;
  SimilarFnMap SimilarFunctions;

private:
  typedef std::vector<WeakVH> FnDeferredQueue;

  /// A work queue of functions that may have been modified and should be
  /// analyzed again.
  FnDeferredQueue Deferred;
};

}  // end anonymous namespace

MergeRegistry::~MergeRegistry() {
  this->clear();
}

void MergeRegistry::clear() {
  Deferred.clear();
  SimilarFunctions.clear();
  for (std::list<FunctionComparator *>::iterator
        I = FunctionsToMerge.begin(), E = FunctionsToMerge.end();
       I != E; ++I) {
    FunctionComparator *FC = *I;
    delete FC;
  }
  FunctionsToMerge.clear();
  FunctionsToCompare.clear();
}

static bool isAliasCapable(Function* G) {
  return
    UseGlobalAliases && G->hasGlobalUnnamedAddr()
    && (G->hasExternalLinkage() || G->hasLocalLinkage() || G->hasWeakLinkage());
}

static bool isComparisonCandidate(Function *F) {
  if (Opt::MergeLevel == Opt::size) {
    // Only consider functions that are to be optimized for size.
    // By default, that is all functions at -Os/-Oz and nothing at -O2.
    bool Os = F->getAttributes().
      //hasAttribute(AttributeSet::FunctionIndex, Attribute::OptimizeForSize);
      hasAttribute(AttributeList::FunctionIndex, Attribute::OptimizeForSize);
    bool Oz = F->getAttributes().
     //hasAttribute(AttributeSet::FunctionIndex, Attribute::MinSize);
      hasAttribute(AttributeList::FunctionIndex, Attribute::MinSize);
    if (!Os && !Oz)
      return false;
  }

  // Ignore declarations and tiny functions - no point in merging those
  if (F->isDeclaration()) return false;
  if (F->getName().endswith(MERGED_SUFFIX)) return false;
  if (F->size() == 1 && F->begin()->size() < MergeMinInsts)
    return isAliasCapable(F);
  if (F->hasAvailableExternallyLinkage()) return false;
  if (F->hasFnAttribute(Attribute::AlwaysInline)) return false;

  return true;
}

void MergeRegistry::defer(Function *F) {
  if (isComparisonCandidate(F))
    Deferred.push_back(F);
}

// Move functions from Deferred into buckets. remove() may have been called
// multiple times for the same function, so eliminate duplicates using the
// set. We reverse them because MergeSimilarFunctions::insert inserts at the
// front of each bucket.
unsigned MergeRegistry::enqueue() {
  DenseSet<Function *> InsertedFuncs;

  for (std::vector<WeakVH>::reverse_iterator
      DefI = Deferred.rbegin(), DefE = Deferred.rend();
      DefI != DefE; ++DefI) {
    Value *V = *DefI;
    Function *F = dyn_cast_or_null<Function>(V);
    if (!F) continue;
    if (InsertedFuncs.find(F) != InsertedFuncs.end()) continue;
    if (!isComparisonCandidate(F)) continue;

    unsigned Hash = profileFunction(F);
    FunctionsToCompare[Hash].push_front(F);

    InsertedFuncs.insert(F);
  }

  Deferred.clear();

  return InsertedFuncs.size();
}

void MergeRegistry::insertCandidate(FunctionComparator *Comp) {
  FunctionsToMerge.push_back(Comp);
  SimilarFunctions[Comp->getF1()].insert(Comp);
}

static void removeFromBucket(Function *F,
    std::list<ComparableFunction> &Bucket) {
  for (std::list<ComparableFunction>::iterator
      I = Bucket.begin(), E = Bucket.end(); I != E; ++I) {
    if (I->getFunc() == F) {
      Bucket.erase(I);
      return;
    }
  }
}

void MergeRegistry::remove(Function *F, bool Reanalyze/*=true*/) {
  // There is no need to remove a function that is not already
  // in a bucket.
  if (!isComparisonCandidate(F))
    return;

  unsigned Hash = profileFunction(F);
  std::list<ComparableFunction> &Bucket = FunctionsToCompare[Hash];

  removeFromBucket(F, Bucket);

  if (Reanalyze)
    Deferred.push_back(F);

  // Check whether we have any existing FunctionComparator objects for this fn.
  // If yes, discard them because F has changed. Retry merging for those
  // functions by adding them to Deferred.
  std::list<FunctionComparator *>::iterator I = FunctionsToMerge.begin();
  while (I != FunctionsToMerge.end()) {
    FunctionComparator *Comp = *I;
    if (Comp->getF1() == F) {
      Function *OtherF = Comp->getF2();
      Deferred.push_back(OtherF);
      removeFromBucket(OtherF, Bucket);
      if (!SimilarFunctions[F].erase(Comp))
        llvm_unreachable("Inconsistent SimilarFunctions set");
      I = FunctionsToMerge.erase(I);
      delete Comp;
    } else if (Comp->getF2() == F) {
      Function *OtherF = Comp->getF1();
      Deferred.push_back(OtherF);
      removeFromBucket(OtherF, Bucket);
      if (!SimilarFunctions[OtherF].erase(Comp))
        llvm_unreachable("Inconsistent SimilarFunctions set");
      I = FunctionsToMerge.erase(I);
      delete Comp;
    } else {
      ++I;
    }
  }
}

unsigned MergeRegistry::getMaxSimilarity(Function *F,
    const DenseSet<Function *> &Ignore) {
  FnComparatorSet &Similar = SimilarFunctions[F];

  for (FnComparatorSet::iterator I = Similar.begin(), E = Similar.end();
       I != E; ++I) {
    FunctionComparator *Comp = *I;
    if (Ignore.count(Comp->getF2()))
      continue;

    return Comp->getSimilarityMetric();
  }

  return 0;
}

namespace {

class MergeSimilarFunctions : public ModulePass {
public:
 static char ID;
  MergeSimilarFunctions()
    : ModulePass(ID) {
#ifndef LLVM_NEXT_FM_STANDALONE
    initializeMergeSimilarFunctionsPass(*PassRegistry::getPassRegistry());
#endif
  }

  bool runOnModule(Module &M);

private:
  /// Find the functions that use this Value and remove them from FnSet and
  /// queue the functions.
  void removeUsers(Value *V);

  /// Replace all direct calls of Old with calls of New. Will bitcast New if
  /// necessary to make types match.
  void replaceDirectCallers(Function *Old, Function *New);

  /// Process functions in the specified bucket, by either doing equiv merging
  /// marking them for diff merging. Returns false if the bucket needs to be
  /// re-scanned after an equiv merge. Sets Changed if the module was changed by
  /// equiv merge.
  bool mergeBucket(std::list<ComparableFunction> &Fns, bool &Changed);

  /// Exhaustively compare all functions in each bucket and do equiv merging
  /// where possible. Functions that have already been compared will not be
  /// compared again. Returns true if the module was modified.
  bool doExhaustiveCompareMerge();

  /// Merge all the functions marked for diff merging. Returns true if the
  /// module was modified.
  bool doDiffMerge();

  /// Merge two equivalent functions. Upon completion, G may be deleted, or may
  /// be converted into a thunk. In either case, it should never be visited
  /// again.
  void mergeTwoFunctions(Function *F, Function *G);

  /// Merge a set of functions with differences.
  void outlineAndMergeFunctions(SmallVectorImpl<FunctionComparator *> &Fns);

  /// Replace G with a thunk or an alias to F. Deletes G.
  void writeThunkOrAlias(Function *F, Function *G);

  /// Replace G with a simple tail call to bitcast(F). Also replace direct uses
  /// of G with bitcast(F). Deletes G.
  void writeThunk(Function *F, Function *G);

  /// Replace G with a tail call to F with an additional argument.
  ///
  void writeThunkWithChoice(Function *NewF, Function *OldF, int Choice);

  /// Replace G with an alias to F. Deletes G.
  void writeAlias(Function *F, Function *G);

  /// DataLayout for more accurate GEP comparisons. May be NULL.
  const DataLayout *DL;

  /// Merge registry. Stores all the information about functions being
  /// considered for merging as well as current candidates for merging.
  MergeRegistry Registry;

};

}  // end anonymous namespace

char MergeSimilarFunctions::ID = 0;
#if LLVM_NEXT_FM_STANDALONE
static RegisterPass<MergeSimilarFunctions> X("mergesimilarfunc", "Merge Similar Functions",
                                             false, false);
#else
INITIALIZE_PASS(MergeSimilarFunctions, "mergesimilarfunc",
                "Merge Similar Functions", false, false)

ModulePass *llvm::createMergeSimilarFunctionsPass() {
  return new MergeSimilarFunctions();
}
#endif

bool MergeSimilarFunctions::runOnModule(Module &M) {
  if (Opt::MergeLevel == Opt::none)
    return false;

  bool Changed = false;

  DL = &M.getDataLayout();

  for (auto &I : M)
    Registry.defer(&I);

  do {
    unsigned InsertCount = Registry.enqueue();

    DEBUG(dbgs() << "size of module: " << M.size() << '\n');
    DEBUG(dbgs() << "size of worklist: " << InsertCount << '\n');
    (void)InsertCount;

    Changed |= doExhaustiveCompareMerge();
  } while (Registry.haveDeferred());

  Changed |= doDiffMerge();

  Registry.clear();
  return Changed;
}

// Replace direct callers of Old with New.
void MergeSimilarFunctions::replaceDirectCallers(Function *Old, Function *New) {
  Constant *BitcastNew = ConstantExpr::getBitCast(New, Old->getType());
  for (Value::use_iterator UI = Old->use_begin(), UE = Old->use_end();
       UI != UE;) {
    Use *U = &*UI;
    ++UI;
    //CallSite CS(U->getUser());
    //if (CS && CS.isCallee(U)) {
    //  Registry.remove(CS.getInstruction()->getParent()->getParent());
    CallBase *CB = dyn_cast<CallBase>(U->getUser());
    if (CB && CB->isCallee(U)) {
      Registry.remove(CB->getParent()->getParent());
      U->set(BitcastNew);
    }
  }
}

// Replace G with an alias to F if possible, or else a thunk to F. Deletes G.
void MergeSimilarFunctions::writeThunkOrAlias(Function *F, Function *G) {
  if (isAliasCapable(G)) {
    writeAlias(F, G);
    return;
  }

  writeThunk(F, G);
}

static void writeThunkBody(Function *Thunk, Function *F,
                           ConstantInt *Choice, const DataLayout *DL) {
  BasicBlock *BB = &Thunk->getEntryBlock();
  IRBuilder<> Builder(BB);

  SmallVector<Value *, 16> Args;
  unsigned i = 0;
  FunctionType *FFTy = F->getFunctionType();
  Type *IntPtrTy = DL->getIntPtrType(FFTy->getContext());
  for (auto &AI : Thunk->args()) {
    Value *Cast = createCastIfNeeded(&AI, FFTy->getParamType(i), BB, IntPtrTy);
    Args.push_back(Cast);
    ++i;
  }
  if (Choice)
    Args.push_back(Choice);

  CallInst *CI = Builder.CreateCall(F, Args);
  CI->setTailCall();
  CI->setCallingConv(F->getCallingConv());
  CI->setAttributes(F->getAttributes());
  CI->setIsNoInline();
  if (Thunk->getReturnType()->isVoidTy()) {
    Builder.CreateRetVoid();
  } else {
    Type *RetTy = Thunk->getReturnType();
    if (CI->getType()->isIntegerTy() && RetTy->isPointerTy())
      Builder.CreateRet(Builder.CreateIntToPtr(CI, RetTy));
    else if (CI->getType()->isPointerTy() && RetTy->isIntegerTy())
      Builder.CreateRet(Builder.CreatePtrToInt(CI, RetTy));
    else {
      Value *Cast = createCastIfNeeded(CI, RetTy, BB, IntPtrTy);
      Builder.CreateRet(Cast);
    }
  }
}

// Replace G with a simple tail call to bitcast(F). Also replace direct uses
// of G with bitcast(F). Deletes G.
void MergeSimilarFunctions::writeThunk(Function *F, Function *G) {
  if (!G->isInterposable()) {
    // Redirect direct callers of G to F.
    replaceDirectCallers(G, F);
  }

  // If G was internal then we may have replaced all uses of G with F. If so,
  // stop here and delete G. There's no need for a thunk.
  if (G->hasLocalLinkage() && G->use_empty()) {
    DEBUG(dbgs() << "All uses of " << G->getName() << " replaced by "
                 << F->getName() << ". Removing it.\n");
    G->eraseFromParent();
    return;
  }

  Function *NewG = Function::Create(G->getFunctionType(), G->getLinkage(), "",
                                    G->getParent());
  BasicBlock::Create(F->getContext(), "", NewG);

  writeThunkBody(NewG, F, nullptr, DL);

  NewG->copyAttributesFrom(G);
  NewG->takeName(G);
  removeUsers(G);
  G->replaceAllUsesWith(NewG);
  G->eraseFromParent();

  DEBUG(dbgs() << "writeThunk: " << NewG->getName() << " calling "
               << F->getName() << '\n');
  ++NumThunksWritten;
}

void MergeSimilarFunctions::writeThunkWithChoice(Function *NewF, Function *OldF,
                                          int Choice) {
  // Deleting the body of a function sets its linkage to External. Save the old
  // one here and restore it at the end.
  GlobalValue::LinkageTypes OldFLinkage = OldF->getLinkage();

  // Delete OldF's body
  OldF->deleteBody();
  BasicBlock::Create(OldF->getContext(), "", OldF);

  // Insert single BB with tail call
  IntegerType *Int32Ty = Type::getInt32Ty(OldF->getContext());
  ConstantInt *ChoiceConst = ConstantInt::get(Int32Ty, Choice);
  writeThunkBody(OldF, NewF, ChoiceConst, DL);
  OldF->setLinkage(OldFLinkage);
}

// Replace G with an alias to F and delete G.
void MergeSimilarFunctions::writeAlias(Function *F, Function *G) {

  // Replace all current uses of G in constants with F. This handles virtual
  // table and other references. Do this first so that we don't modify thge
  // global alias we're about to create.
  SmallVector<Use *, 8> Uses;
  for (auto I = G->use_begin(), E = G->use_end(); I != E; ++I) {
    Use *U = I.operator->();
    Constant *CV = dyn_cast<Constant>(U->getUser());
    if (!CV) continue;
    Uses.push_back(U);
  }
  for (auto I = Uses.begin(), E= Uses.end(); I != E; ++I) {
    Use *U = *I;
    U->set(F);
  }

  PointerType *PTy = G->getType();
  auto *GA = GlobalAlias::create(PTy->getElementType(), PTy->getAddressSpace(),
                                 G->getLinkage(), "", F);
  F->setAlignment(Align(std::max(F->getAlignment(), G->getAlignment())));
  GA->takeName(G);
  GA->setVisibility(G->getVisibility());
  removeUsers(G);
  G->replaceAllUsesWith(GA);
  G->eraseFromParent();

  DEBUG(dbgs() << "writeAlias: " << GA->getName() << '\n');
  ++NumAliasesWritten;
}

static std::string getVertexName(const Value *V){
   if(V){
      std::string name;
      raw_string_ostream namestream(name);
      V->printAsOperand(namestream,false);
      return namestream.str();
   }else return "[nullptr]";
}

// Merge two equivalent functions. Upon completion, Function G is deleted.
void MergeSimilarFunctions::mergeTwoFunctions(Function *F, Function *G) {
  std::string F1Name = getVertexName(F);
  std::string F2Name = getVertexName(G);
  std::string F12Name;
  //if (MSFDebug) {
  //  F->dump();
  //  G->dump();
  //}
  if (F->isInterposable()) {
    assert(G->isInterposable());

    if (UseGlobalAliases) {
      // Make them both thunks to the same internal function.
      Function *H = Function::Create(F->getFunctionType(), F->getLinkage(), "",
                                     F->getParent());
      H->copyAttributesFrom(F);
      H->takeName(F);
      removeUsers(F);
      F->replaceAllUsesWith(H);

      unsigned MaxAlignment = std::max(G->getAlignment(), H->getAlignment());

      writeAlias(F, G);
      writeAlias(F, H);

      F->setAlignment(Align(MaxAlignment));
      F->setLinkage(GlobalValue::PrivateLinkage);

      F12Name = getVertexName(F);
    } else {
      // We can't merge them. Instead, pick one and update all direct callers
      // to call it and hope that we improve the instruction cache hit rate.
      replaceDirectCallers(G, F);
      F12Name = getVertexName(F);
    }

    ++NumDoubleWeak;
  } else {
    writeThunkOrAlias(F, G);
    F12Name = getVertexName(F);
  }

  errs() << "Merged: " << F1Name << ", " << F2Name << " = " << F12Name << "\n";
  ++NumFunctionsMerged;
}

static Value *getLastArg(Function *F) {
  auto it = F->arg_begin();
  std::advance(it, F->arg_size()-1);
  return it;
}

static void insertCondAndRemapInstructions(
    Instruction *F1InstInNewF, const std::vector<const Instruction *> &F2Insts,
    Function *NewF, ValueToValueMapTy &F1toNewF,
    const SmallVectorImpl<FunctionComparator *> &Comps,
    Type *IntPtrTy) {
  assert(F2Insts.size() == Comps.size() &&
      "Mis-match between F2Insts & Comps!");

  SmallVector<Instruction *, 8> F2InstsInNewF;
  for (unsigned FnI = 0, FnE = F2Insts.size(); FnI != FnE; ++FnI) {
    const Instruction *F2Inst = F2Insts[FnI];
    if (!F2Inst) {
      F2InstsInNewF.push_back(NULL);
      continue;
    }

    Instruction *F2InstInNewF = F2Inst->clone();

    // Remap F2Inst: F2 values -> F1 values
    RemapInstruction(F2InstInNewF, Comps[FnI]->getF2toF1Map(),
                     RF_NoModuleLevelChanges);
    // Remap F2Inst: F1 values -> NewF values
    RemapInstruction(F2InstInNewF, F1toNewF, RF_NoModuleLevelChanges);

    F2InstsInNewF.push_back(F2InstInNewF);
  }

  SmallVector<Instruction *, 8> Terminators;
  //SplitBlockAndInsertSwitch(&NewF->getArgumentList().back(), F1InstInNewF,
  SplitBlockAndInsertSwitch(getLastArg(NewF), F1InstInNewF,
                            F2InstsInNewF, Terminators);

  assert(Terminators.size() == F2InstsInNewF.size() + 1 &&
      "Not enough terminators returned");

  // F2InstsInNewF are now hooked up to the correct values in NewF. However,
  // some of their operands may be pointers/integers so they could potentially
  // have the wrong type in NewF (since we treat all pointers and integers of
  // same size as equal). Insert casts if needed.
  for (unsigned FnI = 0, FnE = F2InstsInNewF.size(); FnI != FnE; ++FnI) {
    Instruction *F2InstInNewF = F2InstsInNewF[FnI];
    if (!F2InstInNewF)
      continue;
    const Instruction *F2Inst = F2Insts[FnI];

    for (unsigned OpId=0; OpId < F2InstInNewF->getNumOperands(); ++OpId) {
      Value *F2NewFOperand = F2InstInNewF->getOperand(OpId);
      Value *F2OrigOperand = F2Inst->getOperand(OpId);

      if (F2NewFOperand->getType() != F2OrigOperand->getType()) {
        Value *Cast = createCastIfNeeded(F2NewFOperand,
            F2OrigOperand->getType(),
            F2InstInNewF,
            IntPtrTy);
        F2InstInNewF->setOperand(OpId, Cast);
      }
    }
  }

  if (ReturnInst *F1Ret = dyn_cast<ReturnInst>(F1InstInNewF)) {
    // If we're handling differing return instructions, we need to ensure that
    // they all return the same type. Since we treat pointer types as equal, we
    // may need to insert a bitcast.
    for (Instruction *F2Inst : F2InstsInNewF) {
      if (!F2Inst)
        continue;

      // F2Inst must also be a return instruction due to control flow
      // isomorphism.
      ReturnInst *F2Ret = cast<ReturnInst>(F2Inst);

      if (F2Ret->getReturnValue()->getType() !=
          F1Ret->getReturnValue()->getType())
        F2Ret->setOperand(0,
                          createCastIfNeeded(F2Ret->getReturnValue(),
                                             F1Ret->getReturnValue()->getType(),
                                             F2Ret, IntPtrTy));
    }
  } else if (!F1InstInNewF->use_empty()) {
    // If the instructions have uses, we need to insert a PHI node.
    //
    // We treat all pointer types as equal, so we may need to insert
    // a bitcast to ensure that all incoming values of the PHI node have the
    // same type
    Type *F1IType = F1InstInNewF->getType();
    BasicBlock *TailBB = Terminators[0]->getSuccessor(0);
    PHINode *Phi =
        PHINode::Create(F1IType, F2InstsInNewF.size(), "", &TailBB->front());
    F1InstInNewF->replaceAllUsesWith(Phi);

    Phi->addIncoming(F1InstInNewF, F1InstInNewF->getParent());
    for (unsigned FnI = 0, FnE = F2InstsInNewF.size(); FnI != FnE; ++FnI) {
      Instruction *F2InstInNewF = F2InstsInNewF[FnI];
      if (!F2InstInNewF)
        continue;

      if (F2InstInNewF->getType() != F1IType) {
        assert(!F2InstInNewF->isTerminator() &&
            "Cannot cast result of terminator instruction");

        F2InstInNewF = cast<Instruction>(
            createCastIfNeeded(F2InstInNewF,
              F1IType,
              Terminators[FnI+1],
              IntPtrTy));
      }

      Phi->addIncoming(F2InstInNewF, F2InstInNewF->getParent());
    }
  }
}

static void mergePHINode(const SmallVectorImpl<FunctionComparator *> &Fns,
                         Function *NewF,
                         ValueToValueMapTy &VMap, /* F1->FNew */
                         const PHINode *F1PhiInst,
                         std::vector<const Instruction *> F2PhiInsts) {
  PHINode *F1PhiInNewF = dyn_cast<PHINode>(VMap[F1PhiInst]);
  assert(F1PhiInNewF && "Cannot find F1Inst in NewF!");

  // The incoming blocks in any of the F2PhiInsts may be in a different order.
  // If this is the case, we have to reorder them. F2PhiInsts is intentionally a
  // copy, so we can modify it
  SmallVector<PHINode *, 4> GCInsts; // so we can delete them later.
  for (unsigned FnI = 0, FnE = F2PhiInsts.size(); FnI != FnE; ++FnI) {
    const PHINode *F2PhiInst = dyn_cast_or_null<const PHINode>(F2PhiInsts[FnI]);
    if (!F2PhiInst)
      continue;

    for (unsigned I = 0, E = F1PhiInNewF->getNumIncomingValues(); I < E; ++I) {
      if (!Fns[FnI]->enumerate(F1PhiInst->getIncomingBlock(I),
                               F2PhiInst->getIncomingBlock(I))) {
        // Non-equivalent blocks in the same position - need to reorder PhiInst
        PHINode *ReorderedF2PhiInst = PHINode::Create(F2PhiInst->getType(), E);

        for (unsigned II = 0; II < E; ++II) {
          Value *BBVal =
            Fns[FnI]->getF1toF2Map()[F1PhiInst->getIncomingBlock(II)];
          BasicBlock *BB = cast<BasicBlock>(BBVal);
          Value *Val = F2PhiInst->getIncomingValueForBlock(BB);
          ReorderedF2PhiInst->addIncoming(Val, BB);
        }

        F2PhiInsts[FnI] = ReorderedF2PhiInst;
        GCInsts.push_back(ReorderedF2PhiInst);
        break;
      }
    }
  }

  // Now merge the PHI nodes.
  for (unsigned i = 0; i < F1PhiInNewF->getNumIncomingValues(); ++i) {
    Value *F1InValNewF = F1PhiInNewF->getIncomingValue(i),
          *F1InVal = F1PhiInst->getIncomingValue(i);
    BasicBlock *F1NewFInBlock = F1PhiInNewF->getIncomingBlock(i);
    // If this is a repeat occurrence of the same incoming BasicBlock, we
    // will have already dealt with it in a previous iteration.
    if (F1PhiInNewF->getBasicBlockIndex(F1PhiInNewF->getIncomingBlock(i)) !=
        (int)i)
      continue;

    Value *NewIncoming = F1InValNewF;

    Instruction *InsertPt = F1NewFInBlock->getTerminator();

    // Build up a chain of cmps and selects that pick the correct incoming
    // value.
    for (unsigned FnI = 0, FnE = F2PhiInsts.size(); FnI != FnE; ++FnI) {
      if (!F2PhiInsts[FnI])
        continue;
      const PHINode *F2PhiInst = cast<const PHINode>(F2PhiInsts[FnI]);
      Value *F2InVal = F2PhiInst->getIncomingValue(i);

      // If we know these are equivalent, there's no further work to do
      if (Fns[FnI]->enumerate(F1InVal, F2InVal,/*NoSelfRef=*/true) &&
          Fns[FnI]->enumerate(F1PhiInst->getIncomingBlock(i),
            F2PhiInst->getIncomingBlock(i)))
        continue;

      assert(Fns[FnI]->enumerate(F1PhiInst->getIncomingBlock(i),
                                 F2PhiInst->getIncomingBlock(i)) &&
             "Non-equivalent incoming BBs in PHI.");

      // We have different incoming values from the same block
      // Translate F2's incoming value to NewF if needed
      Value *F2InValNewF = F2InVal;
      if (!isa<Constant>(F2InVal)) {
        Value *V = Fns[FnI]->getF2toF1Map()[F2InVal]; // F2->F1
        F2InValNewF = VMap[V]; // F1->NewF
        assert(V && F2InValNewF && "Cannot map F2InVal to NewF");
      }

      // Cast F2InValNewF to the correct type if needed
      LLVMContext &Ctx = F1InValNewF->getType()->getContext();
      const DataLayout *FTD = Fns[FnI]->getDataLayout();
      Type *IntPtrTy = FTD ? FTD->getIntPtrType(Ctx) : NULL;
      F2InValNewF = createCastIfNeeded(F2InValNewF, F1InValNewF->getType(),
                                       InsertPt, IntPtrTy);

      // Create compare & select
      //Value *ChoiceArg = &NewF->getArgumentList().back();
      Value *ChoiceArg = getLastArg(NewF);
      Value *SelectBit = new ICmpInst(InsertPt,
                                      ICmpInst::ICMP_EQ,
                                      //&NewF->getArgumentList().back(),
                                      getLastArg(NewF),
                                      ConstantInt::get(ChoiceArg->getType(),
                                                       FnI+1));

      // SelectBit true -> F2InValNewF, SelectBit false -> existing NewIncoming.
      NewIncoming = SelectInst::Create(SelectBit, F2InValNewF, NewIncoming, "",
          InsertPt);
    }

    if (NewIncoming == F1InValNewF)
      continue; // no change for this incoming value

    // Replace all occurrences of this incoming value/block by the new
    // ones (phi nodes can have repeated arguments)
    for (unsigned j=i; j < F1PhiInNewF->getNumIncomingValues(); ++j) {
      if (F1PhiInNewF->getIncomingBlock(j) == F1NewFInBlock) {
        F1PhiInNewF->setIncomingValue(j, NewIncoming);
      }
    }
  }

  // Garbage-collect the reordered PHI nodes we temporarily created.
  for (SmallVectorImpl<PHINode *>::iterator I = GCInsts.begin(),
        E = GCInsts.end(); I != E; ++I)
    delete *I;
}

static bool rewriteRecursiveCall(
    const CallInst *F1I, const CallInst *F2I, CallInst *NewFI,
    const Function *F1, const Function *F2, Function *NewF) {
  if (!(F1I->getCalledFunction() == F1 && F2I->getCalledFunction() == F2) &&
      !(F1I->getCalledFunction() == F2 && F2I->getCalledFunction() == F1))
    return false; // not a recursive/mutually recursive call

  // Replace NewFI by recursive call to NewF with additional choice argument
  SmallVector<Value *, 16> Args;
  for (unsigned AI = 0, End = NewFI->getNumArgOperands(); AI < End; ++AI) {
    Value *Arg = NewFI->getArgOperand(AI);

    // Check if F1 or F2 is one of the arguments (veeery unusual case, don't
    // handle it for now).
    if (Arg == F1 || Arg == F2)
      return false;

    Args.push_back(Arg);
  }

  if (F1I->getCalledFunction() == F1 && F2I->getCalledFunction() == F2) {
    //Args.push_back(&NewF->getArgumentList().back());
    Args.push_back(getLastArg(NewF));
  } else {
    // Need to invert the choice argument
    //Value *ChoiceArg = &NewF->getArgumentList().back();
    Value *ChoiceArg = getLastArg(NewF);
    Constant *One = ConstantInt::get(ChoiceArg->getType(), 1);
    Args.push_back(BinaryOperator::Create(Instruction::Xor, ChoiceArg, One, "",
          NewFI));
  }

  CallInst *CI = CallInst::Create(NewF, Args);
  CI->setCallingConv(NewF->getCallingConv());

  ReplaceInstWithInst(NewFI, CI);

  return true;
}

/// Clone F1 into a new function with F1's name + MERGE_SUFFIX. Adds an
/// additional i32 argument to the function.
static Function *cloneAndAddArgument(Function *F1, ValueToValueMapTy &VMap) {
  LLVMContext &Context = F1->getContext();

  std::vector<Type*> ArgTypes;
  for (const auto &Arg : F1->args())
    ArgTypes.push_back(Arg.getType());
  ArgTypes.push_back(Type::getInt32Ty(Context));

  FunctionType *FTy = FunctionType::get(F1->getFunctionType()->getReturnType(),
                                        ArgTypes,
                                        F1->getFunctionType()->isVarArg());
  Function *NewF = Function::Create(FTy, F1->getLinkage(),
                                    F1->getName()+MERGED_SUFFIX);

  insertFunctionAfter(NewF, F1);

  if (F1->hasSection())
    NewF->setSection(F1->getSection());

  NewF->setCallingConv(CallingConv::Fast);

  Function::arg_iterator DestI = NewF->arg_begin();
  for (auto &Arg : F1->args()) {
    Argument *DestIn = &*DestI;
    DestIn->setName(Arg.getName()); // Copy the name over...
    VMap[&Arg] = DestIn;            // Add mapping to VMap
    ++DestI;
  }

  // Name the selector argument
  (*DestI).setName("__merge_arg");

  SmallVector<ReturnInst*, 8> Returns;
  CloneFunctionInto(NewF, F1, VMap, CloneFunctionChangeType::LocalChangesOnly, Returns);
  // Set linkage to set visibility to default.
  NewF->setLinkage(GlobalValue::InternalLinkage);

  return NewF;
}

typedef MapVector<const Instruction *, std::vector<const Instruction *> >
  CombinedDiffMap;

void MergeSimilarFunctions::outlineAndMergeFunctions(
    SmallVectorImpl<FunctionComparator *> &Fns) {
  assert(!Fns.empty() && "Cannot merge empty set of functions");

  // All comparator instances in Fns share the same F1
  Function *F1 = Fns.front()->getF1();

  // Clone F1 into new function with an additional i32 argument
  ValueToValueMapTy VMap; // maps F1 values -> NewF values
  Function *NewF = cloneAndAddArgument(F1, VMap);

  // Combine all the DifferingInstructions maps in Fns into one single map of
  // lists to aid the merging process.
  //
  // Map F1 instruction -> list of F2 instructions indexed by position in Fns.
  CombinedDiffMap AllDifferingInstructions;
  for (unsigned I = 0, E = Fns.size(); I != E; ++I) {
    FunctionComparator *Comp = Fns[I];
    for (MapVector<const Instruction *, const Instruction *>::iterator
          DiffI = Comp->DifferingInstructions.begin(),
          DiffE = Comp->DifferingInstructions.end();
         DiffI != DiffE; ++DiffI) {
      AllDifferingInstructions[DiffI->first].resize(Fns.size());
      AllDifferingInstructions[DiffI->first][I] = DiffI->second;
    }
  }

  // Merge differing PHI nodes. We need to handle these first because they could
  // be affected later on when we split basic blocks, thus making them
  // impossible to merge.
  for (CombinedDiffMap::const_iterator I = AllDifferingInstructions.begin(),
         E = AllDifferingInstructions.end();
       I != E; ++I) {
    const PHINode *F1PhiInst = dyn_cast<PHINode>(I->first);
    if (!F1PhiInst)
      continue;

    const std::vector<const Instruction *> &F2PhiInsts = I->second;

    mergePHINode(Fns, NewF, VMap, F1PhiInst, F2PhiInsts);
  }

  // Merge recursive calls
  //
  // TODO: We currently only support this optimization for pairs of functions.
  // If more than two functions are merged, we mark the recursive calls as
  // DifferingInstructions which causes switch statements to be inserted and
  // recursive calls going through thunks. It wouldn't be too hard to implement
  // self-recursive calls for multi-merges. *Mutually* recursive calls with
  // multi-merges are a little trickier - that's why we leave it for now.
  if (Fns.size() == 1) {
    FunctionComparator *Comp = Fns.front();
    for (MapVector<const Instruction *, const Instruction *>::const_iterator
        I = Comp->SelfRefInstructions.begin(),
        E = Comp->SelfRefInstructions.end();
        I != E; ++I) {
      const Instruction *F1I = I->first;
      if (Comp->DifferingInstructions.count(F1I))
        continue; // Differing in other ways too, so deal with it later.

      // Attempt recursive call rewriting
      if (isa<CallInst>(F1I)) {
        const CallInst *F1Call = cast<const CallInst>(F1I);
        const CallInst *F2Call = dyn_cast<const CallInst>(I->second);
        CallInst *NewFCall = dyn_cast<CallInst>(VMap[F1I]);

        if (F1Call && F2Call && NewFCall &&
            rewriteRecursiveCall(F1Call, F2Call, NewFCall,
                                 Comp->getF1(), Comp->getF2(), NewF))
          continue;
      }

      // Can't rewrite it. Mark as differing and insert conditional later
      Comp->DifferingInstructions[F1I] = I->second;
    }
  } else {
    for (unsigned I = 0, E = Fns.size(); I != E; ++I) {
      FunctionComparator *Comp = Fns[I];
      for (MapVector<const Instruction *, const Instruction *>::const_iterator
          II = Comp->SelfRefInstructions.begin(),
          EE = Comp->SelfRefInstructions.end();
          II != EE; ++II) {
        const Instruction *F1I = II->first;
        if (Comp->DifferingInstructions.count(F1I))
          continue; // Differing in other ways too, so deal with it later.

        AllDifferingInstructions[F1I].resize(Fns.size());
        AllDifferingInstructions[F1I][I] = II->second;
      }
    }
  }

  // For each differing instruction, splice basic block, and insert conditional
  LLVMContext &Context = NewF->getContext();
  Type *IntPtrType = DL->getIntPtrType(Context);
  for (CombinedDiffMap::const_iterator I = AllDifferingInstructions.begin(),
         E = AllDifferingInstructions.end();
       I != E; ++I) {
    const Instruction *F1Inst = I->first;
    const std::vector<const Instruction *> &F2Insts = I->second;

    assert(VMap.find(F1Inst) != VMap.end() &&
      "Cannot find differing inst!");
    Instruction *F1InstInNewF = cast<Instruction>(VMap[F1Inst]);

    if (isa<PHINode>(F1InstInNewF))
      continue; // we already handled these above

    insertCondAndRemapInstructions(F1InstInNewF, F2Insts,
      NewF, VMap, Fns, IntPtrType);
  }

  // Replace functions with thunks
  PrintMerges("FNSM", F1, NewF);

  errs() << "Merged: " << getVertexName(F1);
#ifdef LLVM_ENABLE_DUMP
  if (MSFDebug) F1->dump();
#endif

  writeThunkWithChoice(NewF, F1, 0);
  for (unsigned FnI = 0, FnE = Fns.size(); FnI != FnE; ++FnI) {
    Function *F2 = Fns[FnI]->getF2();

    errs() << ", " << getVertexName(F2);
#ifdef LLVM_ENABLE_DUMP
    if (MSFDebug) F2->dump();
#endif

    PrintMerges("FNSM", F2, NewF);
    writeThunkWithChoice(NewF, F2, FnI + 1);
  }

  errs() << " = " << getVertexName(NewF) << "\n";
#ifdef LLVM_ENABLE_DUMP
  if (MSFDebug) NewF->dump();
#endif

  NumSimilarFunctionsMerged += Fns.size() + 1;
}

// For each instruction used by the value, remove() the function that contains
// the instruction. This should happen right before a call to RAUW.
void MergeSimilarFunctions::removeUsers(Value *V) {
  std::vector<Value *> Worklist;
  Worklist.push_back(V);
  while (!Worklist.empty()) {
    Value *V = Worklist.back();
    Worklist.pop_back();

    for (User *U : V->users()) {
      if (Instruction *I = dyn_cast<Instruction>(U)) {
        Registry.remove(I->getParent()->getParent());
      } else if (isa<GlobalValue>(U)) {
        // do nothing
      } else if (Constant *C = dyn_cast<Constant>(U)) {
        for (User *UU : C->users())
          Worklist.push_back(UU);
      }
    }
  }
}

bool MergeSimilarFunctions::mergeBucket(std::list<ComparableFunction> &Fns,
    bool &Changed) {
  for (std::list<ComparableFunction>::iterator FnI = Fns.begin(),
      FnE = Fns.end(); FnI != FnE; ++FnI) {
    if (!FnI->isNew())
      continue;

    if (!FnI->getFunc())
      continue;

    SmallVector<FunctionComparator *, 8> DiffMergeCandidates;

    std::list<ComparableFunction>::iterator Fn2I = FnI;
    for (++Fn2I; Fn2I != FnE; ++Fn2I) {
      if (!Fn2I->getFunc())
        continue;

      assert(FnI->getFunc() != Fn2I->getFunc() &&
          "Duplicate function in list!");

      FunctionComparator *Comp = new FunctionComparator(DL, FnI->getFunc(),
          Fn2I->getFunc());

      if (!Comp->compare() || !Comp->isMergeCandidate()) {
        delete Comp;
        continue;
      }

      // Never thunk a strong function to a weak function.
      assert(!FnI->getFunc()->isInterposable() ||
          Fn2I->getFunc()->isInterposable());

      if (Comp->isExactMatch()) {
        // Equiv merge the two functions. Throw away any diff merge
        // candidate we might have found so far.
        delete Comp;

        DEBUG(dbgs() << "- Equiv merge " << FnI->getFunc()->getName()
            << " == " << Fn2I->getFunc()->getName() << '\n');

        PrintMerges("FNEQ", FnI->getFunc(), Fn2I->getFunc());

        Function *DeleteF = Fn2I->getFunc();
        Registry.remove(DeleteF, /*reanalyze=*/false);

        mergeTwoFunctions(FnI->getFunc(), DeleteF);

        Changed = true;

        // mergeTwoFunctions may have removed functions from this bucket and
        // invalidated the iterators. Rescan the whole bucket, continuing
        // from the current function (previous ones will have been
        // markCompared())
        for (SmallVector<FunctionComparator *, 8>::iterator
            I = DiffMergeCandidates.begin(), E = DiffMergeCandidates.end();
           I != E; ++I)
          delete *I;

        return false;
      } else {
        DiffMergeCandidates.push_back(Comp);
      }
    }

    if (!DiffMergeCandidates.empty()) {
      // Add to our list of candidates for diff merging
      for (SmallVector<FunctionComparator *, 8>::iterator
            I = DiffMergeCandidates.begin(), E = DiffMergeCandidates.end();
           I != E; ++I) {
        Registry.insertCandidate(*I);
      }
    }

    FnI->markCompared();
  }

  return true;
}

bool MergeSimilarFunctions::doExhaustiveCompareMerge() {
  bool Changed = false;

  // Process buckets with strong functions first.
  for (MergeRegistry::FnCompareMap::iterator
        BucketsI = Registry.FunctionsToCompare.begin(),
        BucketsE = Registry.FunctionsToCompare.end();
       BucketsI != BucketsE; ++BucketsI) {
    std::list<ComparableFunction> &Fns = BucketsI->second;
    if (Fns.size() < 2 || Fns.front().getFunc()->isInterposable())
      continue;

    DEBUG(dbgs() << "Processing strong bucket " << BucketsI->first << " with "
                 << Fns.size() << " functions\n");
    // Repeatedly scan this bucket, until we find no more functions to equiv
    // merge.
    while (!mergeBucket(Fns, Changed) && Fns.size() > 1) {
      DEBUG(dbgs() << "Rescanning bucket.\n");
    }
  }

  // Process buckets with weak functions.
  for (MergeRegistry::FnCompareMap::iterator
        BucketsI = Registry.FunctionsToCompare.begin(),
        BucketsE = Registry.FunctionsToCompare.end();
       BucketsI != BucketsE; ++BucketsI) {
    std::list<ComparableFunction> &Fns = BucketsI->second;
    if (Fns.size() < 2 || !Fns.front().getFunc()->isInterposable())
      continue;

    DEBUG(dbgs() << "Processing weak bucket " << BucketsI->first << " with "
                 << Fns.size() << " functions\n");
    // Repeatedly scan this bucket, until we find no more functions to equiv
    // merge.
    while (!mergeBucket(Fns, Changed) && Fns.size() > 1) {
      DEBUG(dbgs() << "Rescanning bucket.\n");
    }
  }

  return Changed;
}

static bool orderComparatorsByMetric(FunctionComparator *Cmp1,
                                     FunctionComparator *Cmp2) {
  return (Cmp1->getSimilarityMetric() > Cmp2->getSimilarityMetric());
}

bool MergeSimilarFunctions::doDiffMerge() {
  if (Registry.FunctionsToMerge.empty())
    return false;

  bool Changed = false;
  DenseSet<Function *> MergedFns; // Functions that have already been merged
  Registry.FunctionsToMerge.sort(orderComparatorsByMetric);

  for (std::list<FunctionComparator *>::iterator
        I = Registry.FunctionsToMerge.begin(),
        E = Registry.FunctionsToMerge.end();
       I != E; ++I) {
    FunctionComparator *Comp = *I;
    Function *F1 = Comp->getF1();
    // Ignore it if we've already merged this fn
    if (MergedFns.count(F1) || MergedFns.count(Comp->getF2()))
      continue;

    assert(Registry.SimilarFunctions.count(F1) &&
        "Comparator doesn't exist in SimilarFunctions map");

    // Look at all functions F that F1 could be merged with. Merge with each F,
    // unless there is another function F' that is more similar to F than F1.
    MergeRegistry::FnComparatorSet &SimilarFns = Registry.SimilarFunctions[F1];
    SmallVector<FunctionComparator *, 4> CurrentMerge;

    for (MergeRegistry::FnComparatorSet::iterator
          CandidateI = SimilarFns.begin(), CandidateE = SimilarFns.end();
        CandidateI != CandidateE; ++CandidateI) {
      FunctionComparator *Comp2 = *CandidateI;
      assert(Comp2->getF1() == F1 && "Inconsistency in SimilarFunctions");
      Function *F2 = Comp2->getF2();

      // Ignore it if we've already merged this fn
      if (MergedFns.count(F2))
        continue;

      // Check whether there is a better merge candidate for F2
      if (Registry.getMaxSimilarity(F2, MergedFns) >
          Comp2->getSimilarityMetric())
        continue;

      // Ok, we actually want to merge with F2
      CurrentMerge.push_back(Comp2);
      MergedFns.insert(F2);
    }

    if (CurrentMerge.empty())
      continue;

    MergedFns.insert(F1);

    NumMultiMerged += CurrentMerge.size();

    DEBUG(dbgs() << "- Multi merge of " << F1->getName() << " with "
                 << CurrentMerge.size() << " functions.\n");

    Changed = true;
    outlineAndMergeFunctions(CurrentMerge);
  }

  return Changed;
}
