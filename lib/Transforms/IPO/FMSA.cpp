
#include "llvm/Transforms/IPO/FMSA.h"

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

#include <algorithm>
#include <list>

#include <limits.h>

#include <functional>
#include <queue>
#include <vector>

#include <algorithm>
#include <stdlib.h>
#include <time.h>

#define DEBUG_TYPE "MyFuncMerge"
//#define ENABLE_DEBUG_CODE

//#define FMSA_USE_JACCARD

//#define TIME_STEPS_DEBUG

using namespace llvm;

/* REQUIRES MERGED RETURN FUNCTIONS. */

static cl::opt<unsigned> ExplorationThreshold(
    "fmsa-explore", cl::init(10), cl::Hidden,
    cl::desc("Exploration threshold of evaluated functions"));

static cl::opt<int> MergingOverheadThreshold(
    "fmsa-threshold", cl::init(0), cl::Hidden,
    cl::desc("Threshold of allowed overhead for merging function"));

static cl::opt<bool>
    MaxParamScore("fmsa-max-param", cl::init(true), cl::Hidden,
                  cl::desc("Maximizing the score for merging parameters"));

static cl::opt<bool> Debug("fmsa-debug", cl::init(false), cl::Hidden,
                           cl::desc("Outputs debug information"));

static cl::opt<bool> Verbose("fmsa-verbose", cl::init(false),
                             cl::Hidden, cl::desc("Outputs debug information"));

static cl::opt<bool>
    IdenticalType("fmsa-identic-type", cl::init(true), cl::Hidden,
                  cl::desc("Maximizing the score for merging parameters"));

static cl::opt<bool> ApplySimilarityHeuristic(
    "fmsa-similarity-pruning", cl::init(true), cl::Hidden,
    cl::desc("Maximizing the score for merging parameters"));


static cl::opt<bool>
    HasWholeProgram("fmsa-whole-program", cl::init(true), cl::Hidden,
                  cl::desc("Function merging applied on whole program"));

static cl::opt<bool>
    RunBruteForceExploration("fmsa-oracle", cl::init(false), cl::Hidden,
                  cl::desc("Run function merging's oracle"));



// static std::unique_ptr<RandomNumberGenerator> RandGen;

static std::list<unsigned> MergingDistance;

static unsigned LastMaxParamScore = 0;
static unsigned TotalParamScore = 0;

static int CountOpReorder = 0;
static int CountBinOps = 0;

static std::string GetValueName(const Value *V) {
  if (V) {
    std::string name;
    raw_string_ostream namestream(name);
    V->printAsOperand(namestream, false);
    return namestream.str();
  } else
    return "[null]";
}

static Value *GetAnyValue(Type *Ty) {
  /*
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
  */
  return UndefValue::get(Ty);
}

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
static bool isEquivalentType(Type *Ty1, Type *Ty2, const DataLayout *DL) {
  if (Ty1 == Ty2)
    return true;
  if (IdenticalType)
    return false;

  if (Ty1->getTypeID() != Ty2->getTypeID()) {
    LLVMContext &Ctx = Ty1->getContext();
    if (isa<PointerType>(Ty1) && Ty2 == DL->getIntPtrType(Ctx))
      return true;
    if (isa<PointerType>(Ty2) && Ty1 == DL->getIntPtrType(Ctx))
      return true;
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
    return (PTy1 == PTy2);
    // return isEquivalentType(PTy1->getElementType(),
    // PTy2->getElementType(),DL);  return PTy1->getAddressSpace() ==
    // PTy2->getAddressSpace();
  }

  case Type::StructTyID: {
    StructType *STy1 = cast<StructType>(Ty1);
    StructType *STy2 = cast<StructType>(Ty2);
    if (STy1->getNumElements() != STy2->getNumElements())
      return false;

    if (STy1->isPacked() != STy2->isPacked())
      return false;

    for (unsigned i = 0, e = STy1->getNumElements(); i != e; ++i) {
      if (!isEquivalentType(STy1->getElementType(i), STy2->getElementType(i),
                            DL))
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

    if (!isEquivalentType(FTy1->getReturnType(), FTy2->getReturnType(), DL))
      return false;

    for (unsigned i = 0, e = FTy1->getNumParams(); i != e; ++i) {
      if (!isEquivalentType(FTy1->getParamType(i), FTy2->getParamType(i), DL))
        return false;
    }
    return true;
  }

  case Type::ArrayTyID: {
    ArrayType *ATy1 = cast<ArrayType>(Ty1);
    ArrayType *ATy2 = cast<ArrayType>(Ty2);
    return ATy1->getNumElements() == ATy2->getNumElements() &&
           isEquivalentType(ATy1->getElementType(), ATy2->getElementType(), DL);
  }
  }
}

/// Create a cast instruction if needed to cast V to type DstType. We treat
/// pointer and integer types of the same bitwidth as equivalent, so this can be
/// used to cast them to each other where needed. The function returns the Value
/// itself if no cast is needed, or a new CastInst instance inserted before
/// InsertBefore. The integer type equivalent to pointers must be passed as
/// IntPtrType (get it from DataLayout). This is guaranteed to generate no-op
/// casts, otherwise it will assert.
static Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
                                 Type *IntPtrType) {
  if (V->getType() == DstType || IdenticalType)
    return V;
  // BasicBlock *InsertAtEnd = dyn_cast<BasicBlock>(InstrOrBB);
  // Instruction *InsertBefore = dyn_cast<Instruction>(InstrOrBB);
  // BasicBlock *InsertBB = InsertAtEnd ? InsertAtEnd :
  // InsertBefore->getParent();

  Value *Result;
  Type *OrigType = V->getType();

  if (OrigType->isStructTy()) {
    assert(DstType->isStructTy());
    assert(OrigType->getStructNumElements() == DstType->getStructNumElements());

    // IRBuilder<> Builder(InsertBB);
    // if (InsertBefore)
    //  Builder.SetInsertPoint(InsertBefore);
    Result = UndefValue::get(DstType);
    for (unsigned int I = 0, E = OrigType->getStructNumElements(); I < E; ++I) {
      Value *ExtractedValue =
          Builder.CreateExtractValue(V, ArrayRef<unsigned int>(I));
      Value *Element =
          createCastIfNeeded(ExtractedValue, DstType->getStructElementType(I),
                             Builder, IntPtrType);
      Result =
          Builder.CreateInsertValue(Result, Element, ArrayRef<unsigned int>(I));
    }
    return Result;
  }
  assert(!DstType->isStructTy());

  if (OrigType->isPointerTy() &&
      (DstType->isIntegerTy() || DstType->isPointerTy())) {
    Result = Builder.CreatePointerCast(V, DstType, "merge_cast");
    // if (InsertBefore) {
    // Result = CastInst::CreatePointerCast(V, DstType, "", InsertBefore);
    //} else {
    // Result = CastInst::CreatePointerCast(V, DstType, "", InsertAtEnd);
    //}
  } else if (OrigType->isIntegerTy() && DstType->isPointerTy() &&
             OrigType == IntPtrType) {
    // Int -> Ptr
    Result = Builder.CreateCast(CastInst::IntToPtr, V, DstType, "merge_cast");
    // if (InsertBefore) {
    //  Result = CastInst::Create(CastInst::IntToPtr, V, DstType, "",
    //                            InsertBefore);
    //} else {
    //  Result = CastInst::Create(CastInst::IntToPtr, V, DstType, "",
    //                            InsertAtEnd);
    //}
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

// Helper for writeThunk,
// Selects proper bitcast operation,
// but a bit simpler then CastInst::getCastOpcode.
static Value *createCast(IRBuilder<> &Builder, Value *V, Type *DestTy) {
  Type *SrcTy = V->getType();
  if (SrcTy->isStructTy()) {
    assert(DestTy->isStructTy());
    assert(SrcTy->getStructNumElements() == DestTy->getStructNumElements());
    Value *Result = UndefValue::get(DestTy);
    for (unsigned int I = 0, E = SrcTy->getStructNumElements(); I < E; ++I) {
      Value *Element =
          createCast(Builder, Builder.CreateExtractValue(V, ArrayRef(I)),
                     DestTy->getStructElementType(I));

      Result = Builder.CreateInsertValue(Result, Element, ArrayRef(I));
    }
    return Result;
  }
  assert(!DestTy->isStructTy());
  if (SrcTy->isIntegerTy() && DestTy->isPointerTy())
    return Builder.CreateIntToPtr(V, DestTy);
  else if (SrcTy->isPointerTy() && DestTy->isIntegerTy())
    return Builder.CreatePtrToInt(V, DestTy);
  else
    return Builder.CreateBitCast(V, DestTy);
}

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

//-mem2reg
static bool
promoteMemoryToRegister(Function &F,
                        DominatorTree &DT) { //, AssumptionCache &AC) {
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

static int estimateFunctionSize(Function &F, TargetTransformInfo *TTI) {
  InstructionCost size(0);
  for (Instruction &I : instructions(&F)) {
    size += TTI->getInstructionCost(
        &I, TargetTransformInfo::TargetCostKind::TCK_CodeSize);
  }
  return size.getValue().value();
}

static bool fixNotDominatedUses(Function *F, DominatorTree &DT) {

  std::list<Instruction *> WorkList;
  std::map<Instruction *, Value *> StoredAddress;

  std::map< Instruction *, std::map< Instruction *, std::list<unsigned> > >
      UpdateList;

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
      IRBuilder<> Builder(&*F->getEntryBlock().getFirstInsertionPt());
      StoredAddress[&I] = Builder.CreateAlloca(I.getType());
      //Builder.CreateStore(GetAnyValue(I.getType()), StoredAddress[&I]);
      Value *V = &I;
      if (I.getParent()->getTerminator()) {
        InvokeInst *II = dyn_cast<InvokeInst>(I.getParent()->getTerminator());
        if ((&I)==I.getParent()->getTerminator() && II!=nullptr) {
          BasicBlock *SrcBB = I.getParent();
          BasicBlock *DestBB = II->getNormalDest();
          Builder.SetInsertPoint(DestBB->getFirstNonPHI());
          //create PHI
          if (DestBB->getSinglePredecessor()==nullptr) {
            PHINode *PHI = Builder.CreatePHI( I.getType(), 0 );
            for (auto it = pred_begin(DestBB), et = pred_end(DestBB); it != et; ++it) {
              BasicBlock *BB = *it;
              if (BB==SrcBB) {
                PHI->addIncoming(&I,BB);
              } else {
                PHI->addIncoming( GetAnyValue(I.getType()) ,BB);
              }
            }
            V = PHI;
          }
        } else {
          Builder.SetInsertPoint(I.getParent()->getTerminator());
        }
      } else {
        Builder.SetInsertPoint(I.getParent());
      }
      Builder.CreateStore(V, StoredAddress[&I]);
    }
  }
  for (auto &kv1 : UpdateList) {
    Instruction *I = kv1.first;
    for (auto &kv : kv1.second) {
      Instruction *UI = kv.first;
      IRBuilder<> Builder(UI);
      Value *V = Builder.CreateLoad(I->getType(), StoredAddress[I]);
      for (unsigned i : kv.second) {
        UI->setOperand(i, V);
      }
    }
  }

  return true;
}

static void removeRedundantInstructions(Function *F, DominatorTree &DT,
                                   std::vector<Instruction *> &ListInsts) {

  std::set<Instruction *> SkipList;

  std::map<Instruction *, std::list<Instruction *>> UpdateList;

  for (Instruction *I1 : ListInsts) {
    if (SkipList.find(I1) != SkipList.end())
      continue;
    for (Instruction *I2 : ListInsts) {
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

  for (auto &kv : UpdateList) {
    for (auto *I : kv.second) {
      I->replaceAllUsesWith(kv.first);
      I->eraseFromParent();
    }
  }
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
    // Assert(isa<ConstantInt>(CS.getArgOperand(1)),
    //       "is_zero_undef argument of bit counting intrinsics must be a "
    //       "constant int",
    //       CS);
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
    break;
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
    /*
    const auto *MI = cast<MemIntrinsic>(CS.getInstruction());
    auto IsValidAlignment = [&](unsigned Alignment) -> bool {
      return Alignment == 0 || isPowerOf2_32(Alignment);
    };
    Assert(IsValidAlignment(MI->getDestAlignment()),
           "alignment of arg 0 of memory intrinsic must be 0 or a power of 2",
           CS);
    if (const auto *MTI = dyn_cast<MemTransferInst>(MI)) {
      Assert(IsValidAlignment(MTI->getSourceAlignment()),
             "alignment of arg 1 of memory intrinsic must be 0 or a power of 2",
             CS);
    }
    Assert(isa<ConstantInt>(CS.getArgOperand(3)),
           "isvolatile argument of memory intrinsics must be a constant int",
           CS);
    */

    /*//TODO: fix here
    const auto *MI1 = dyn_cast<MemIntrinsic>(CI1);
    const auto *MI2 = dyn_cast<MemIntrinsic>(CI2);
    if (MI1->getDestAlignment()!=MI2->getDestAlignment()) return false;
    const auto *MTI1 = dyn_cast<MemTransferInst>(CI1);
    const auto *MTI2 = dyn_cast<MemTransferInst>(CI2);
    if (MTI1!=nullptr) {
       if(MTI2==nullptr) return false;
       if (MTI1->getSourceAlignment()!=MTI2->getSourceAlignment()) return false;
    }
    */
    return CI1->getArgOperand(3) == CI2->getArgOperand(3);

    break;
  }
  case Intrinsic::memcpy_element_unordered_atomic:
  case Intrinsic::memmove_element_unordered_atomic:
  case Intrinsic::memset_element_unordered_atomic: {
    /*
    const auto *AMI = cast<AtomicMemIntrinsic>(CS.getInstruction());

    ConstantInt *ElementSizeCI =
        dyn_cast<ConstantInt>(AMI->getRawElementSizeInBytes());
    Assert(ElementSizeCI,
           "element size of the element-wise unordered atomic memory "
           "intrinsic must be a constant int",
           CS);
    const APInt &ElementSizeVal = ElementSizeCI->getValue();
    Assert(ElementSizeVal.isPowerOf2(),
           "element size of the element-wise atomic memory intrinsic "
           "must be a power of 2",
           CS);

    if (auto *LengthCI = dyn_cast<ConstantInt>(AMI->getLength())) {
      uint64_t Length = LengthCI->getZExtValue();
      uint64_t ElementSize = AMI->getElementSizeInBytes();
      Assert((Length % ElementSize) == 0,
             "constant length must be a multiple of the element size in the "
             "element-wise atomic memory intrinsic",
             CS);
    }

    auto IsValidAlignment = [&](uint64_t Alignment) {
      return isPowerOf2_64(Alignment) && ElementSizeVal.ule(Alignment);
    };
    uint64_t DstAlignment = AMI->getDestAlignment();
    Assert(IsValidAlignment(DstAlignment),
           "incorrect alignment of the destination argument", CS);
    if (const auto *AMT = dyn_cast<AtomicMemTransferInst>(AMI)) {
      uint64_t SrcAlignment = AMT->getSourceAlignment();
      Assert(IsValidAlignment(SrcAlignment),
             "incorrect alignment of the source argument", CS);
    }
    */
    break;
  }
  case Intrinsic::gcroot:
  case Intrinsic::gcwrite:
  case Intrinsic::gcread:
    /*
    if (ID == Intrinsic::gcroot) {
      AllocaInst *AI =
        dyn_cast<AllocaInst>(CS.getArgOperand(0)->stripPointerCasts());
      Assert(AI, "llvm.gcroot parameter #1 must be an alloca.", CS);
      Assert(isa<Constant>(CS.getArgOperand(1)),
             "llvm.gcroot parameter #2 must be a constant.", CS);
      if (!AI->getAllocatedType()->isPointerTy()) {
        Assert(!isa<ConstantPointerNull>(CS.getArgOperand(1)),
               "llvm.gcroot parameter #1 must either be a pointer alloca, "
               "or argument #2 must be a non-null constant.",
               CS);
      }
    }

    Assert(CS.getParent()->getParent()->hasGC(),
           "Enclosing function does not use GC.", CS);
    */
    break;
  case Intrinsic::init_trampoline:
    /*
    Assert(isa<Function>(CS.getArgOperand(1)->stripPointerCasts()),
           "llvm.init_trampoline parameter #2 must resolve to a function.",
           CS);
    */
    break;
  case Intrinsic::prefetch:
    /*
    Assert(isa<ConstantInt>(CS.getArgOperand(1)) &&
               isa<ConstantInt>(CS.getArgOperand(2)) &&
               cast<ConstantInt>(CS.getArgOperand(1))->getZExtValue() < 2 &&
               cast<ConstantInt>(CS.getArgOperand(2))->getZExtValue() < 4,
           "invalid arguments to llvm.prefetch", CS);
    */
    return (CI1->getArgOperand(1) == CI2->getArgOperand(1) &&
            CI1->getArgOperand(2) == CI2->getArgOperand(2));

    break;
  case Intrinsic::stackprotector:
    /*
    Assert(isa<AllocaInst>(CS.getArgOperand(1)->stripPointerCasts()),
           "llvm.stackprotector parameter #2 must resolve to an alloca.", CS);
    */
    break;
  case Intrinsic::lifetime_start:
  case Intrinsic::lifetime_end:
  case Intrinsic::invariant_start:
    /*
    Assert(isa<ConstantInt>(CS.getArgOperand(0)),
           "size argument of memory use markers must be a constant integer",
           CS);
    */
    return CI1->getArgOperand(0) == CI2->getArgOperand(0);
    break;
  case Intrinsic::invariant_end:
    /*
    Assert(isa<ConstantInt>(CS.getArgOperand(1)),
           "llvm.invariant.end parameter #2 must be a constant integer", CS);
    */
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
    break;

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


static bool match(Instruction *I1, Instruction *I2) {

  if (I1->getOpcode() != I2->getOpcode()) return false;

  //Returns are special cases that can differ in the number of operands
  if (I1->getOpcode() == Instruction::Ret)
    return true;

  if (I1->getNumOperands() != I2->getNumOperands())
    return false;

  bool sameType = false;
  if (IdenticalType) {
    sameType = (I1->getType() == I2->getType());
    for (unsigned i = 0; i < I1->getNumOperands(); i++) {
      sameType = sameType &&
                 (I1->getOperand(i)->getType() == I2->getOperand(i)->getType());
    }
  } else {
    const DataLayout *DT =
        &((Module *)I1->getParent()->getParent()->getParent())->getDataLayout();
    sameType = isEquivalentType(I1->getType(), I2->getType(), DT);
    for (unsigned i = 0; i < I1->getNumOperands(); i++) {
      sameType = sameType && isEquivalentType(I1->getOperand(i)->getType(),
                                              I2->getOperand(i)->getType(), DT);
    }
  }
  if (!sameType)
    return false;

  switch (I1->getOpcode()) {

  case Instruction::Load: {
    const LoadInst *LI = dyn_cast<LoadInst>(I1);
    const LoadInst *LI2 = cast<LoadInst>(I2);
    return LI->isVolatile() == LI2->isVolatile() &&
           LI->getAlign() == LI2->getAlign() &&
           LI->getOrdering() == LI2->getOrdering(); // &&
    // LI->getSyncScopeID() == LI2->getSyncScopeID() &&
    // LI->getMetadata(LLVMContext::MD_range)
    //  == LI2->getMetadata(LLVMContext::MD_range);
  }
  case Instruction::Store: {
    const StoreInst *SI = dyn_cast<StoreInst>(I1);
    return SI->isVolatile() == cast<StoreInst>(I2)->isVolatile() &&
           SI->getAlign() == cast<StoreInst>(I2)->getAlign() &&
           SI->getOrdering() == cast<StoreInst>(I2)->getOrdering(); // &&
    // SI->getSyncScopeID() == cast<StoreInst>(I2)->getSyncScopeID();
  }
  case Instruction::Alloca: {
    const AllocaInst *AI = dyn_cast<AllocaInst>(I1);
    if (AI->getArraySize() != cast<AllocaInst>(I2)->getArraySize() ||
        AI->getAlign() != cast<AllocaInst>(I2)->getAlign())
      return false;

    /*
    // If size is known, I2 can be seen as equivalent to I1 if it allocates
    // the same or less memory.
    if (DL->getTypeAllocSize(AI->getAllocatedType())
          < DL->getTypeAllocSize(cast<AllocaInst>(I2)->getAllocatedType()))
      return false;

    return true;
    */
    break;
  }
  case Instruction::GetElementPtr: {
    GetElementPtrInst *GEP1 = dyn_cast<GetElementPtrInst>(I1);
    GetElementPtrInst *GEP2 = dyn_cast<GetElementPtrInst>(I2);
    return matchGetElementPtrInsts(GEP1,GEP2);
    /*
    SmallVector<Value *, 8> Indices1(GEP1->idx_begin(), GEP1->idx_end());
    SmallVector<Value *, 8> Indices2(GEP2->idx_begin(), GEP2->idx_end());
    if (Indices1.size() != Indices2.size())
      return false;


    Type *AggTy1 = GEP1->getSourceElementType();
    Type *AggTy2 = GEP2->getSourceElementType();

    unsigned CurIdx = 1;
    for (; CurIdx != Indices1.size(); ++CurIdx) {
      CompositeType *CTy1 = dyn_cast<CompositeType>(AggTy1);
      CompositeType *CTy2 = dyn_cast<CompositeType>(AggTy2);
      if (!CTy1 || CTy1->isPointerTy()) return false;
      if (!CTy2 || CTy2->isPointerTy()) return false;
      Value *Idx1 = Indices1[CurIdx];
      Value *Idx2 = Indices2[CurIdx];
      //if (!CT->indexValid(Index)) return nullptr;
      
      //validate indices
      if (isa<StructType>(CTy1) || isa<StructType>(CTy2)) {
        //if types are structs, the indices must be and remain constants
        if (!isa<ConstantInt>(Idx1) || !isa<ConstantInt>(Idx2)) return false;
        if (Idx1!=Idx2) return false;
      }

      AggTy1 = CTy1->getTypeAtIndex(Idx1);
      AggTy2 = CTy2->getTypeAtIndex(Idx2);

      //sanity check: matching indexed types
      bool sameType = (AggTy1 == AggTy2);
      if (!IdenticalType) {
        const DataLayout *DT =
          &((Module *)GEP1->getParent()->getParent()->getParent())->getDataLayout();
        sameType = isEquivalentType(AggTy1, AggTy2, DT);
      }
      if (!sameType) return false;
    }
    */
    break;
  }
  case Instruction::Switch: {
    SwitchInst *SI1 = dyn_cast<SwitchInst>(I1);
    SwitchInst *SI2 = dyn_cast<SwitchInst>(I2);
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
  case Instruction::Call: {
    CallInst *CI1 = dyn_cast<CallInst>(I1);
    CallInst *CI2 = dyn_cast<CallInst>(I2);
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
  case Instruction::Invoke: {
    InvokeInst *CI1 = dyn_cast<InvokeInst>(I1);
    InvokeInst *CI2 = dyn_cast<InvokeInst>(I2);
    return CI1->getCallingConv() == CI2->getCallingConv() &&
           matchLandingPad(CI1->getLandingPadInst(), CI2->getLandingPadInst());
    // CI->getAttributes() == cast<InvokeInst>(I2)->getAttributes();
  }
  case Instruction::InsertValue: {
    const InsertValueInst *IVI = dyn_cast<InsertValueInst>(I1);
    return IVI->getIndices() == cast<InsertValueInst>(I2)->getIndices();
  }
  case Instruction::ExtractValue: {
    const ExtractValueInst *EVI = dyn_cast<ExtractValueInst>(I1);
    return EVI->getIndices() == cast<ExtractValueInst>(I2)->getIndices();
  }
  case Instruction::Fence: {
    const FenceInst *FI = dyn_cast<FenceInst>(I1);
    return FI->getOrdering() == cast<FenceInst>(I2)->getOrdering() &&
           FI->getSyncScopeID() == cast<FenceInst>(I2)->getSyncScopeID();
  }
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

static bool match(Value *V1, Value *V2) {
  if (isa<Instruction>(V1) && isa<Instruction>(V2)) {
    return match(dyn_cast<Instruction>(V1), dyn_cast<Instruction>(V2));
  } else if (isa<BasicBlock>(V1) && isa<BasicBlock>(V2)) {
    BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
    BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);
    if (BB1->isLandingPad() || BB2->isLandingPad()) {
      LandingPadInst *LP1 = BB1->getLandingPadInst();
      LandingPadInst *LP2 = BB2->getLandingPadInst();
      if (LP1 == nullptr || LP2 == nullptr)
        return false;
      return matchLandingPad(LP1, LP2);
    } else return true;
  }
  return false;
}

static bool match(std::vector<Value *> &F1, std::vector<Value *> &F2,
                  unsigned i, unsigned j) {
  return match(F1[i], F2[j]);
}

static bool match(SmallVectorImpl<Value *> &F1, SmallVectorImpl<Value *> &F2,
                  unsigned i, unsigned j) {
  return match(F1[i], F2[j]);
}

// Needleman-Wunsch's algorithm for sequence alignment
class NeedlemanWunschSimilarityMatrix {
public:
  SmallVectorImpl<Value *> &F1;
  SmallVectorImpl<Value *> &F2;

  bool *Match;
  int *Matrix;
  unsigned NumRows;
  unsigned NumCols;
  unsigned MaxScore;
  unsigned MaxRow;
  unsigned MaxCol;

  const static unsigned END = 0;
  const static unsigned DIAGONAL = 1;
  const static unsigned UP = 2;
  const static unsigned LEFT = 3;

  // scoring scheme
  const int matchAward = 2;
  const int mismatchPenalty = -1;
  const int gapPenalty = -1;

  NeedlemanWunschSimilarityMatrix(SmallVectorImpl<Value *> &F1,
                                  SmallVectorImpl<Value *> &F2)
      : F1(F1), F2(F2) {
    NumRows = F1.size() + 1;             // rows
    NumCols = F2.size() + 1;             // cols
    Matrix = new int[NumRows * NumCols]; // last element keeps the max
    Match = new bool[F1.size()*F2.size()]; // last element keeps the max
                                         // value
    // memset(Matrix,0, sizeof(int)*NumRows*NumCols);
    // for (unsigned i = 0; i < NumRows; i++)
    //  for (unsigned j = 0; j < NumCols; j++)
    //    Matrix[i * NumCols + j] = 0;

    #pragma omp parallel for
    for (unsigned i = 0; i < F1.size(); i++)
      for (unsigned j = 0; j < F2.size(); j++)
        Match[i * F2.size() + j] = match(F1[i], F2[j]);
    
    for (unsigned i = 0; i < NumRows; i++)
      Matrix[i * NumCols + 0] = i * gapPenalty;
    for (unsigned j = 0; j < NumCols; j++)
      Matrix[0 * NumCols + j] = j * gapPenalty;

    MaxScore = 0;
    MaxRow = 0;
    MaxCol = 0;

    /*
    unsigned blockIncr = 32;
    for (unsigned i = 1; i < NumRows; i++) {
      for (unsigned j = 1; j < NumCols; j++) {
        unsigned limitRow = std::min( i + blockIncr, NumRows );
        unsigned limitRow = std::min( i + blockIncr, NumRows );
        for (unsigned xi = i; xi < limitRow; xi++) {
        int score = calcScore(i, j);
        Matrix[i * NumCols + j] = score;
      }
    }
    */
    const unsigned blockIncr = 64;
    for (unsigned i = 1; i < NumRows; i += blockIncr) {
      for (unsigned j = 1; j < NumCols; j += blockIncr) {
        unsigned limitRows = std::min(i + blockIncr, NumRows);
        unsigned limitCols = std::min(j + blockIncr, NumCols);
        for (unsigned xi = i; xi < limitRows; xi++) {
          // Matrix[ xi*NumCols + 0 ] = xi*gapPenalty;
          for (unsigned xj = j; xj < limitCols; xj++) {
            // int score = calcScore(xi, xj);

            int similarity =
                Match[(xi - 1)*F2.size() + (xj - 1)] ? matchAward : mismatchPenalty;
            //    match(F1[xi - 1], F2[xj - 1]) ? matchAward : mismatchPenalty;
            int diagonal = Matrix[(xi - 1) * NumCols + xj - 1] + similarity;
            int upper = Matrix[(xi - 1) * NumCols + xj] + gapPenalty;
            int left = Matrix[xi * NumCols + xj - 1] + gapPenalty;
            int score = std::max(std::max(diagonal, upper), left);

            Matrix[xi * NumCols + xj] = score;
          }
        }
      }
    }

    MaxRow = NumRows - 1;
    MaxCol = NumCols - 1;
  }

  ~NeedlemanWunschSimilarityMatrix() {
    if (Matrix)
      delete Matrix;
    Matrix = nullptr;
    if (Match)
      delete Match;
    Match = nullptr;
  }

  int calcScore(unsigned i, unsigned j) {
    //int similarity = match(F1[i - 1], F2[j - 1]) ? matchAward : mismatchPenalty;
    int similarity = Match[(i - 1)*F2.size() + (j - 1)] ? matchAward : mismatchPenalty;
    int diagonal = Matrix[(i - 1) * NumCols + j - 1] + similarity;
    int upper = Matrix[(i - 1) * NumCols + j] + gapPenalty;
    int left = Matrix[i * NumCols + j - 1] + gapPenalty;
    return std::max(std::max(diagonal, upper), left);
  }

  unsigned nextMove(unsigned i, unsigned j) {
    if (i <= 0 || j <= 0)
      return END;
    int diagonal = Matrix[(i - 1) * NumCols + j - 1];
    int upper = Matrix[(i - 1) * NumCols + j];
    int left = Matrix[i * NumCols + j - 1];
    if (diagonal >= upper && diagonal >= left)
      return diagonal > 0 ? DIAGONAL : END; // Diagonal Move
    else if (upper > diagonal && upper >= left)
      return upper > 0 ? UP : END; // Up move
    else if (left > diagonal && left >= upper)
      return left > 0 ? LEFT : END; // Left move
    return END;
  }
};

class SearchItem {
public:
  unsigned row;
  unsigned col;
  int val;
  SearchItem(unsigned row, unsigned col, int val)
      : row(row), col(col), val(val) {}
  bool operator<(const SearchItem &SI) const { return val < SI.val; }
  bool operator>(const SearchItem &SI) const { return val > SI.val; }
};

class AStarSimilarityMatrix {
public:
  SmallVectorImpl<Value *> &F1;
  SmallVectorImpl<Value *> &F2;

  int *Matrix;
  unsigned NumRows;
  unsigned NumCols;
  unsigned MaxScore;
  unsigned MaxRow;
  unsigned MaxCol;

  const static unsigned END = 0;
  const static unsigned DIAGONAL = 1;
  const static unsigned UP = 2;
  const static unsigned LEFT = 3;

  // scoring scheme
  const int matchAward = 2;
  const int mismatchPenalty = -1;
  const int gapPenalty = -1;

  AStarSimilarityMatrix(SmallVectorImpl<Value *> &F1,
                        SmallVectorImpl<Value *> &F2)
      : F1(F1), F2(F2) {
    const unsigned N1 = F1.size();
    const unsigned N2 = F2.size();
    NumRows = N1 + 1;                    // rows
    NumCols = N2 + 1;                    // cols
    Matrix = new int[NumRows * NumCols]; // last element keeps the max
                                         // value
    // memset(Matrix,INT_MIN, sizeof(int)*NumRows*NumCols);
    for (unsigned i = 0; i < (NumRows * NumCols); i++)
      Matrix[i] = INT_MIN;
    for (unsigned i = 0; i < NumRows; i++)
      Matrix[i * NumCols + 0] = i * gapPenalty;
    for (unsigned j = 0; j < NumCols; j++)
      Matrix[0 * NumCols + j] = j * gapPenalty;

    std::priority_queue<SearchItem> q;

    {
      int similarity = match(F1[0], F2[0]) ? matchAward : mismatchPenalty;
      int diagonal = Matrix[0 * NumCols + 0] + similarity;
      int upper = Matrix[0 * NumCols + 1] + gapPenalty;
      int left = Matrix[1 * NumCols + 0] + gapPenalty;
      int score = std::max(std::max(diagonal, upper), left);
      Matrix[1 * NumCols + 1] = score;
      q.push(SearchItem(1, 1, score));
    }

    while (true) {
      SearchItem Item = q.top();
      q.pop();

      if (Item.row == N1 && Item.col == N2)
        break;

      unsigned i, j;

      // neighbor right
      i = Item.row;
      j = Item.col + 1;
      if (j < NumCols) {
        if (Matrix[i * NumCols + j] == INT_MIN) {
          int similarity =
              match(F1[i - 1], F2[j - 1]) ? matchAward : mismatchPenalty;
          int val;
          val = Matrix[(i - 1) * NumCols + j - 1];
          int diagonal = (val == INT_MIN) ? INT_MIN : (val + similarity);
          val = Matrix[(i - 1) * NumCols + j];
          int upper = (val == INT_MIN) ? INT_MIN : (val + gapPenalty);
          val = Matrix[i * NumCols + j - 1];
          int left = (val == INT_MIN) ? INT_MIN : (val + gapPenalty);
          int score = std::max(std::max(diagonal, upper), left);
          Matrix[i * NumCols + j] = score;
          if (i == N1 && j == N2)
            break;
          q.push(SearchItem(i, j, score));
        }
      }

      // neighbor down
      i = Item.row + 1;
      j = Item.col;
      if (i < NumRows) {
        if (Matrix[i * NumCols + j] == INT_MIN) {
          int similarity =
              match(F1[i - 1], F2[j - 1]) ? matchAward : mismatchPenalty;
          int val;
          val = Matrix[(i - 1) * NumCols + j - 1];
          int diagonal = (val == INT_MIN) ? INT_MIN : (val + similarity);
          val = Matrix[(i - 1) * NumCols + j];
          int upper = (val == INT_MIN) ? INT_MIN : (val + gapPenalty);
          val = Matrix[i * NumCols + j - 1];
          int left = (val == INT_MIN) ? INT_MIN : (val + gapPenalty);
          int score = std::max(std::max(diagonal, upper), left);
          Matrix[i * NumCols + j] = score;
          if (i == N1 && j == N2)
            break;
          q.push(SearchItem(i, j, score));
        }
      }

      // neighbor diagonal
      i = Item.row + 1;
      j = Item.col + 1;
      if (i < NumRows && j < NumCols) {
        if (Matrix[i * NumCols + j] == INT_MIN) {
          int similarity =
              match(F1[i - 1], F2[j - 1]) ? matchAward : mismatchPenalty;
          int val;
          val = Matrix[(i - 1) * NumCols + j - 1];
          int diagonal = (val == INT_MIN) ? INT_MIN : (val + similarity);
          val = Matrix[(i - 1) * NumCols + j];
          int upper = (val == INT_MIN) ? INT_MIN : (val + gapPenalty);
          val = Matrix[i * NumCols + j - 1];
          int left = (val == INT_MIN) ? INT_MIN : (val + gapPenalty);
          int score = std::max(std::max(diagonal, upper), left);
          Matrix[i * NumCols + j] = score;
          if (i == N1 && j == N2)
            break;
          q.push(SearchItem(i, j, score));
        }
      }
    }

    MaxRow = NumRows - 1;
    MaxCol = NumCols - 1;
    MaxScore = Matrix[MaxRow * NumCols + MaxCol];
  }

  ~AStarSimilarityMatrix() {
    if (Matrix)
      delete Matrix;
    Matrix = nullptr;
  }

  int calcScore(unsigned i, unsigned j) {
    int similarity = match(F1[i - 1], F2[j - 1]) ? matchAward : mismatchPenalty;
    int diagonal = Matrix[(i - 1) * NumCols + j - 1] + similarity;
    int upper = Matrix[(i - 1) * NumCols + j] + gapPenalty;
    int left = Matrix[i * NumCols + j - 1] + gapPenalty;
    return std::max(std::max(diagonal, upper), left);
  }

  unsigned nextMove(unsigned i, unsigned j) {
    if (i <= 0 || j <= 0)
      return END;
    int diagonal = Matrix[(i - 1) * NumCols + j - 1];
    int upper = Matrix[(i - 1) * NumCols + j];
    int left = Matrix[i * NumCols + j - 1];
    if (diagonal >= upper && diagonal >= left)
      return diagonal > 0 ? DIAGONAL : END; // Diagonal Move
    else if (upper > diagonal && upper >= left)
      return upper > 0 ? UP : END; // Up move
    else if (left > diagonal && left >= upper)
      return left > 0 ? LEFT : END; // Left move
    return END;
  }
};

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

enum LinearizationKind { LK_Random, LK_Canonical };

static void Linearization(Function *F, SmallVectorImpl<Value *> &FVec,
                          LinearizationKind LK) {
  std::list<BasicBlock *> OrderedBBs;

  unsigned FReserve = 0;
  switch (LK) {
  case LinearizationKind::LK_Random:
    FReserve = RandomLinearizationOfBlocks(F, OrderedBBs);
  case LinearizationKind::LK_Canonical:
  default:
    FReserve = CanonicalLinearizationOfBlocks(F, OrderedBBs);
  }

  FVec.reserve(FReserve + OrderedBBs.size());
  for (BasicBlock *BB : OrderedBBs) {
    FVec.push_back(BB);
    for (Instruction &I : *BB) {
      if (!isa<LandingPadInst>(&I))
        FVec.push_back(&I);
    }
  }
}

class MergedFunction {
public:
  Function *F1;
  Function *F2;
  Function *MergedFunc;
  bool hasFuncIdArg;
  double RoughReduction;

  std::map<unsigned, unsigned> ParamMap1;
  std::map<unsigned, unsigned> ParamMap2;

  MergedFunction(Function *F1, Function *F2, Function *MergedFunc)
      : F1(F1), F2(F2), MergedFunc(MergedFunc), hasFuncIdArg(false) {}
};

static bool validMergeTypes(Function *F1, Function *F2) {
  bool EquivTypes = isEquivalentType(F1->getReturnType(), F2->getReturnType(),
                                     &F1->getParent()->getDataLayout());
  if (!EquivTypes) {
    if (!F1->getReturnType()->isVoidTy() && !F2->getReturnType()->isVoidTy()) {
      return false;
    }
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

static double
AlignLinearizedCFGs(SmallVectorImpl<Value *> &F1Vec,
                    SmallVectorImpl<Value *> &F2Vec,
                    std::list<std::pair<Value *, Value *>> &AlignedInstsList) {
  int countMerges = 0;

  bool WasMerge = true;
  int EstimatedSize = 0;

  NeedlemanWunschSimilarityMatrix SimMat(F1Vec, F2Vec);
  // AStarSimilarityMatrix SimMat(F1Vec, F2Vec);
  // std::list< std::pair<Value *, Value *> > AlignedInstsList;

  for (unsigned i = SimMat.NumRows - 1; i > SimMat.MaxRow; i--) {
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(F1Vec[i - 1], nullptr));
    WasMerge = false;
    EstimatedSize++;
  }
  for (unsigned j = SimMat.NumCols - 1; j > SimMat.MaxCol; j--) {
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(nullptr, F2Vec[j - 1]));
    WasMerge = false;
    EstimatedSize++;
  }

  unsigned i = SimMat.MaxRow, j = SimMat.MaxCol;

  if (match(F1Vec, F2Vec, i - 1, j - 1)) {
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(F1Vec[i - 1], F2Vec[j - 1]));
    countMerges++;
    if (!WasMerge)
      EstimatedSize += 2;
    EstimatedSize++;
    WasMerge = true;
  } else {
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(F1Vec[i - 1], nullptr));
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(nullptr, F2Vec[j - 1]));
    WasMerge = false;
    EstimatedSize += 2;
  }

  unsigned move = SimMat.nextMove(i, j);
  while (move != SimMat.END) {
    switch (move) {
    case SimMat.DIAGONAL:
      i--;
      j--;
      //if (match(F1Vec, F2Vec, i - 1, j - 1)) {
      if (SimMat.Match[ (i-1)*F2Vec.size() + (j - 1)]) {
        AlignedInstsList.push_front(
            std::pair<Value *, Value *>(F1Vec[i - 1], F2Vec[j - 1]));
        countMerges++;
        if (!WasMerge)
          EstimatedSize += 2;
        EstimatedSize++;
        WasMerge = true;
      } else {
        AlignedInstsList.push_front(
            std::pair<Value *, Value *>(F1Vec[i - 1], nullptr));
        AlignedInstsList.push_front(
            std::pair<Value *, Value *>(nullptr, F2Vec[j - 1]));
        if (WasMerge)
          EstimatedSize++;
        EstimatedSize += 2;
        WasMerge = false;
      }
      break;
    case SimMat.UP:
      i--;
      AlignedInstsList.push_front(
          std::pair<Value *, Value *>(F1Vec[i - 1], nullptr));
      if (WasMerge)
        EstimatedSize += 2;
      EstimatedSize++;
      WasMerge = false;
      break;
    case SimMat.LEFT:
      j--;
      AlignedInstsList.push_front(
          std::pair<Value *, Value *>(nullptr, F2Vec[j - 1]));
      if (WasMerge)
        EstimatedSize += 2;
      EstimatedSize++;
      WasMerge = false;
      break;
    default:
      break;
    }
    move = SimMat.nextMove(i, j);
  }

  while (i > 1) {
    i--;
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(F1Vec[i - 1], nullptr));
    EstimatedSize++;
  }
  while (j > 1) {
    j--;
    AlignedInstsList.push_front(
        std::pair<Value *, Value *>(nullptr, F2Vec[j - 1]));
    EstimatedSize++;
  }

  // std::vector< std::pair<Value *, Value *> > AlignedInsts(
  //    AlignedInstsList.begin(), AlignedInstsList.end());

  double EstimatedReduction =
      ((1 - ((double)EstimatedSize) / (F1Vec.size() + F2Vec.size())) * 100);
  // errs() << "Rough Size: " << EstimatedSize << " F1 Size: " << F1Vec.size()
  // << " F2 Size: " << F2Vec.size() << " : " << EstimatedReduction << "%\n";

  return EstimatedReduction;
}


void optimizeAlignment(std::list<std::pair<Value *, Value *>> &AlignedInsts) {
  if (AlignedInsts.size()==0) return;

  std::list<std::pair<Value *, Value *>> NewAlignedInsts;

  auto It = AlignedInsts.begin();
  auto NextIt = AlignedInsts.begin();
  NextIt++;

  int countAlignedSize = 0;
  while (NextIt!=AlignedInsts.end()) {
    if (It->first!=nullptr && It->second!=nullptr) {
      countAlignedSize++;
      if ((NextIt->first==nullptr || NextIt->second==nullptr) && countAlignedSize==1 ) {
        NewAlignedInsts.push_back( std::pair<Value*,Value*>(It->first, nullptr) );
        NewAlignedInsts.push_back( std::pair<Value*,Value*>(nullptr, It->second) );
        countAlignedSize = 0;
      } else {
        NewAlignedInsts.push_back( std::pair<Value*,Value*>(*It) );
      }
    } else {
      countAlignedSize = 0;
      NewAlignedInsts.push_back( std::pair<Value*,Value*>(*It) );
    }
    It++;
    NextIt++;
  }
  NewAlignedInsts.push_back( std::pair<Value*,Value*>(*It) );
  AlignedInsts = NewAlignedInsts;
}


#ifdef TIME_STEPS_DEBUG
Timer TimeAlign("Merge::Align", "Merge::Align");
Timer TimeParam("Merge::Param", "Merge::Param");
Timer TimeCodeGen1("Merge::CodeGen1", "Merge::CodeGen1");
Timer TimeCodeGen2("Merge::CodeGen2", "Merge::CodeGen2");
Timer TimeCodeGenFix("Merge::CodeGenFix", "Merge::CodeGenFix");
#endif

bool filterMergePair(Function *F1, Function *F2) {
  if (!F1->getSection().equals(F2->getSection())) return true;

  if (F1->hasPersonalityFn() && F2->hasPersonalityFn()) {
    Constant *PersonalityFn1 = F1->getPersonalityFn();
    Constant *PersonalityFn2 = F2->getPersonalityFn();
    if (PersonalityFn1 != PersonalityFn2) return true;
  }

  return false;
}

static MergedFunction
mergeBySequenceAlignment(Function *F1, Function *F2,
                         SmallVectorImpl<Value *> &F1Vec,
                         SmallVectorImpl<Value *> &F2Vec) {
  LLVMContext &Context = F1->getContext();
  const DataLayout *DL = &F1->getParent()->getDataLayout();
  Type *IntPtrTy = DL ? DL->getIntPtrType(Context) : NULL;

  MergedFunction ErrorResponse(F1, F2, nullptr);

  if (!F1->getSection().equals(F2->getSection())) {
    if (Verbose) {
      errs() << "Functions differ in their sections! " << GetValueName(F1)
             << ", " << GetValueName(F2) << "\n";
    }
    return ErrorResponse;
  }


  if (F1->hasPersonalityFn() && F2->hasPersonalityFn()) {
    Constant *PersonalityFn1 = F1->getPersonalityFn();
    Constant *PersonalityFn2 = F2->getPersonalityFn();
    if (PersonalityFn1 != PersonalityFn2) {
      errs() << "Functions differ in their personality function!\n";
      return ErrorResponse;
    }
  }
#ifdef TIME_STEPS_DEBUG
  TimeAlign.startTimer();
#endif

  std::list<std::pair<Value *, Value *>> AlignedInsts;
  double RoughReduction = AlignLinearizedCFGs(F1Vec, F2Vec, AlignedInsts);

#ifdef TIME_STEPS_DEBUG
  TimeAlign.stopTimer();
#endif

  //optimizeAlignment(AlignedInsts);

#ifdef ENABLE_DEBUG_CODE
  if (Verbose) {
    for (auto Pair : AlignedInsts) {

      if (Pair.first != nullptr && Pair.second != nullptr) {

        errs() << "1: ";
        if (isa<BasicBlock>(Pair.first))
          errs() << "BB " << GetValueName(Pair.first) << "\n";
        else
          Pair.first->dump();
        errs() << "2: ";
        if (isa<BasicBlock>(Pair.second))
          errs() << "BB " << GetValueName(Pair.second) << "\n";
        else
          Pair.second->dump();
        errs() << "----\n";

      } else {

        if (Pair.first) {
          errs() << "1: ";
          if (isa<BasicBlock>(Pair.first))
            errs() << "BB " << GetValueName(Pair.first) << "\n";
          else
            Pair.first->dump();
          errs() << "2: -\n";
        } else if (Pair.second) {
          errs() << "1: -\n";
          errs() << "2: ";
          if (isa<BasicBlock>(Pair.second))
            errs() << "BB " << GetValueName(Pair.second) << "\n";
          else
            Pair.second->dump();
        }
        errs() << "----\n";
      }
    }
  }
#endif

  // TODO: tmp
  // int alignmentCount = optimizeAlignment(AlignedInsts);

  /*
  if (alignmentCount==0 && (F1Vec.size() >= 5 || F2Vec.size() >= 5)) {
     if (Verbose) {
       errs() << "Not worthy threshold: very small similarty for a relatively
  large function\n";
     }
     return ErrorResponse;
  }

  if (PredFunc1.PredicatedInsts.size() <= 3 &&
  !canReplaceAllCalls(PredFunc1.getFunction())) { if (Verbose) { errs() << "Not
  worthy threshold: too small and not replaceble: " <<
  GetValueName(PredFunc1.getFunction()) << "\n";
     }
     return ErrorResponse;
  }
  if (PredFunc2.PredicatedInsts.size() <= 3 &&
  !canReplaceAllCalls(PredFunc2.getFunction())) { if (Verbose) { errs() << "Not
  worthy threshold: too small and not replaceble: " <<
  GetValueName(PredFunc2.getFunction()) << "\n";
     }
     return ErrorResponse;
  }
  */

#ifdef TIME_STEPS_DEBUG
  TimeParam.startTimer();
#endif

  // Merging parameters
  std::map<unsigned, unsigned> ParamMap1;
  std::map<unsigned, unsigned> ParamMap2;

  std::vector<Argument *> ArgsList1;
  for (Argument &arg : F1->args()) {
    ArgsList1.push_back(&arg);
  }

  // std::vector<Argument *> ArgsList2;
  // for (Argument &arg : F2->args()) {
  //  ArgsList2.push_back(&arg);
  //}

  std::vector<Type *> args;
  args.push_back(IntegerType::get(Context, 1)); // push the function Id argument
  unsigned paramId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    ParamMap1[paramId] = args.size();
    args.push_back((*I).getType());
    paramId++;
  }

  // merge arguments from Function2 with Function1
  paramId = 0;
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

        if (!MaxParamScore)
          break; // if not maximize score, get the first one
      }
    }

    // if ( MaxParamScore && MatchingScore.size() > 0) { //maximize scores
    if (MatchingScore.size() > 0) { // maximize scores
      for (auto Pair : AlignedInsts) {
        if (Pair.first != nullptr && Pair.second != nullptr) {
          auto *I1 = dyn_cast<Instruction>(Pair.first);
          auto *I2 = dyn_cast<Instruction>(Pair.second);
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

      // LastMaxParamScore = MaxScore;

      ParamMap2[paramId] = ParamMap1[MaxId];
    } else {
      ParamMap2[paramId] = args.size();
      args.push_back((*I).getType());
    }

    paramId++;
  }

  assert(validMergeTypes(F1, F2) &&
         "Return type must be the same or one of them must be void!");

  Type *RetType1 = F1->getReturnType();
  Type *RetType2 = F2->getReturnType();
  Type *ReturnType = RetType1;
  if (ReturnType->isVoidTy()) {
    ReturnType = RetType2;
  }

  ArrayRef<llvm::Type *> params(args);
  FunctionType *funcType = FunctionType::get(ReturnType, params, false);
  std::string Name = "";
  /*std::string Name = std::string("m.") +
                     std::string(PredFunc1.getFunction()->getName().str()) +
                     std::string(".") +
                     std::string(PredFunc2.getFunction()->getName().str());
  */

  Function *MergedFunc =
      Function::Create(funcType, GlobalValue::LinkageTypes::InternalLinkage,
                       Twine(Name), F1->getParent());

  ValueToValueMapTy VMap;

  // SmallVector<AttributeSet, 4> NewArgAttrs(MergedFunc->arg_size());

  std::vector<Argument *> ArgsList;
  for (Argument &arg : MergedFunc->args()) {
    ArgsList.push_back(&arg);
  }
  Value *FuncId = ArgsList[0];
  // AttributeList OldAttrs1 = PredFunc1.getFunction()->getAttributes();
  // AttributeList OldAttrs2 = PredFunc2.getFunction()->getAttributes();

  paramId = 0;
  for (auto I = F1->arg_begin(), E = F1->arg_end(); I != E; I++) {
    VMap[&(*I)] = ArgsList[ParamMap1[paramId]];
    /*
    NewArgAttrs[ParamMap1[paramId]] =
                       OldAttrs1.getParamAttributes(paramId);
    */
    paramId++;
  }
  paramId = 0;
  for (auto I = F2->arg_begin(), E = F2->arg_end(); I != E; I++) {
    VMap[&(*I)] = ArgsList[ParamMap2[paramId]];
    /*
    if (ParamMap2[paramId]>PredFunc1.getFunction()->arg_size()) {
      NewArgAttrs[ParamMap2[paramId]] =
                       OldAttrs2.getParamAttributes(paramId);
    }
    */
    paramId++;
  }

#ifdef TIME_STEPS_DEBUG
  TimeParam.stopTimer();
#endif

  /*
         MergedFunc->setAttributes(
                  AttributeList::get(MergedFunc->getContext(),
     OldAttrs1.getFnAttributes(),
                                     (RetType1==ReturnType)?OldAttrs1.getRetAttributes():OldAttrs2.getRetAttributes(),
                           NewArgAttrs));

   */
  // MergedFunc->setAttributes(PredFunc1.getFunction()->getAttributes());

  unsigned MaxAlignment = std::max(F1->getAlignment(), F2->getAlignment());

  if (MaxAlignment) MergedFunc->setAlignment(Align(MaxAlignment));
  //MergedFunc->setAlignment(Align(MaxAlignment));
  //

  // F->setLinkage(GlobalValue::PrivateLinkage);

  if (F1->getAttributes() == F2->getAttributes()) {
    // MergedFunc->setAttributes(PredFunc1.getFunction()->getAttributes());
  }

  if (F1->getCallingConv() == F2->getCallingConv()) {
    MergedFunc->setCallingConv(F1->getCallingConv());
  } else {
    errs() << "ERROR: different calling convention!\n";
  }
  //MergedFunc->setCallingConv(CallingConv::Fast);

  if (F1->getLinkage() == F2->getLinkage()) {
    MergedFunc->setLinkage(F1->getLinkage());
  } else {
    // MergedFunc->setLinkage(PredFunc1.getFunction()->getLinkage());
    errs() << "ERROR: different linkage type!\n";
  }
  //MergedFunc->setLinkage(GlobalValue::LinkageTypes::InternalLinkage);

  if (F1->isDSOLocal() == F2->isDSOLocal()) {
    MergedFunc->setDSOLocal(F1->isDSOLocal());
  } else {
    // MergedFunc->setLinkage(PredFunc1.getFunction()->getLinkage());
    errs() << "ERROR: different DSO local!\n";
  }


  if (F1->getSubprogram() == F2->getSubprogram()) {
    MergedFunc->setSubprogram(F1->getSubprogram());
  } else {
    // MergedFunc->setLinkage(PredFunc1.getFunction()->getLinkage());
    errs() << "ERROR: different subprograms!\n";
  }


  if (F1->getUnnamedAddr() == F2->getUnnamedAddr()) {
    MergedFunc->setUnnamedAddr(F1->getUnnamedAddr());
  } else {
    // MergedFunc->setLinkage(PredFunc1.getFunction()->getLinkage());
    errs() << "ERROR: different unnamed addr!\n";
  }
  //MergedFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

  if (F1->getVisibility() == F2->getVisibility()) {
    MergedFunc->setVisibility(F1->getVisibility());
  } else {
    // MergedFunc->setLinkage(PredFunc1.getFunction()->getLinkage());
    errs() << "ERROR: different visibility!\n";
  }

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
      errs() << "ERROR: different personality function!\n";
    }
  } else if (F1->hasPersonalityFn()) {
    errs() << "Only F1 has PersonalityFn\n";
    MergedFunc->setPersonalityFn(F1->getPersonalityFn()); // TODO: check if this
                                                          // is valid: merge
                                                          // function with
                                                          // personality with
                                                          // function without it
  } else if (F2->hasPersonalityFn()) {
    errs() << "Only F2 has PersonalityFn\n";
    MergedFunc->setPersonalityFn(F2->getPersonalityFn()); // TODO: check if this
                                                          // is valid: merge
                                                          // function with
                                                          // personality with
                                                          // function without it
  }

  if (F1->hasComdat() && F2->hasComdat()) {
    auto *Comdat1 = F1->getComdat();
    auto *Comdat2 = F2->getComdat();
    if (Comdat1 == Comdat2) {
      MergedFunc->setComdat(Comdat1);
    } else {
      errs() << "ERROR: different comdats!\n";
    }
  } else if (F1->hasComdat()) {
    errs() << "Only F1 has Comdat\n";
    MergedFunc->setComdat(F1->getComdat()); // TODO: check if this is valid:
                                            // merge function with comdat with
                                            // function without it
  } else if (F2->hasComdat()) {
    errs() << "Only F2 has Comdat\n";
    MergedFunc->setComdat(F2->getComdat()); // TODO: check if this is valid:
                                            // merge function with comdat with
                                            // function without it
  }

  if (F1->hasSection())
    MergedFunc->setSection(F1->getSection());

  bool RequiresFuncId = false;

  Value *IsFunc1 = FuncId;

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen1.startTimer();
#endif

  BasicBlock *MergedBB = nullptr;
  BasicBlock *MergedBB1 = nullptr;
  BasicBlock *MergedBB2 = nullptr;

  std::map<BasicBlock *, BasicBlock *> TailBBs;

  std::map<SelectCacheEntry, Value *> SelectCache;
  std::map<std::pair<BasicBlock *, BasicBlock *>, BasicBlock *> CacheBBSelect;
  std::vector<Instruction *> ListSelects;

  if (AlignedInsts.front().first == nullptr ||
      AlignedInsts.front().second == nullptr) {
    MergedBB = BasicBlock::Create(Context, "", MergedFunc);
  }

  for (auto Pair : AlignedInsts) {
    if (Pair.first != nullptr && Pair.second != nullptr) {

      if (isa<BasicBlock>(Pair.first)) {
        BasicBlock *NewBB = BasicBlock::Create(Context, "", MergedFunc);

        BasicBlock *BB1 = dyn_cast<BasicBlock>(Pair.first);
        BasicBlock *BB2 = dyn_cast<BasicBlock>(Pair.second);
        VMap[BB1] = NewBB;
        VMap[BB2] = NewBB;

        if (BB1->isLandingPad() || BB2->isLandingPad()) {
          LandingPadInst *LP1 = BB1->getLandingPadInst();
          LandingPadInst *LP2 = BB2->getLandingPadInst();
          assert((LP1 != nullptr && LP2 != nullptr) &&
                 "Should be both as per the BasicBlock match!");
          Instruction *NewLP = LP1->clone();
          VMap[LP1] = NewLP;
          VMap[LP2] = NewLP;

          IRBuilder<> Builder(NewBB);
          Builder.Insert(NewLP);
        }
      }
    } else {
      Value *V = nullptr;
      if (Pair.first) {
        V = Pair.first;
      } else {
        V = Pair.second;
      }

      if (isa<BasicBlock>(V)) {
        BasicBlock *BB = dyn_cast<BasicBlock>(V);

        BasicBlock *NewBB = BasicBlock::Create(Context, "", MergedFunc);
        VMap[BB] = NewBB;
        TailBBs[dyn_cast<BasicBlock>(V)] = NewBB;

        if (BB->isLandingPad()) {
          LandingPadInst *LP = BB->getLandingPadInst();
          Instruction *NewLP = LP->clone();
          VMap[LP] = NewLP;

          IRBuilder<> Builder(NewBB);
          Builder.Insert(NewLP);
        }
      }
    }
  }

  if (AlignedInsts.front().first == nullptr ||
      AlignedInsts.front().second == nullptr) {
    // MergedBB = BasicBlock::Create(Context, "", MergedFunc);
    BasicBlock *EntryBB1 = dyn_cast<BasicBlock>(&F1->getEntryBlock());
    BasicBlock *EntryBB2 = dyn_cast<BasicBlock>(&F2->getEntryBlock());
    IRBuilder<> Builder(MergedBB);
    Builder.CreateCondBr(IsFunc1, dyn_cast<BasicBlock>(VMap[EntryBB1]),
                         dyn_cast<BasicBlock>(VMap[EntryBB2]));
  }
  MergedBB = nullptr;

  for (auto Pair : AlignedInsts) {
    // mergable instructions
    if (Pair.first != nullptr && Pair.second != nullptr) {

      if (isa<BasicBlock>(Pair.first)) {
        BasicBlock *NewBB =
            dyn_cast<BasicBlock>(VMap[dyn_cast<BasicBlock>(Pair.first)]);
        // VMap[dyn_cast<BasicBlock>(Pair.first)] = NewBB;
        // VMap[dyn_cast<BasicBlock>(Pair.second)] = NewBB;
        // BasicBlock *NewBB = BasicBlock::Create(Context, "", MergedFunc);
        // VMap[dyn_cast<BasicBlock>(Pair.first)] = NewBB;
        // VMap[dyn_cast<BasicBlock>(Pair.second)] = NewBB;

        MergedBB = NewBB;
        MergedBB1 = dyn_cast<BasicBlock>(Pair.first);
        MergedBB2 = dyn_cast<BasicBlock>(Pair.second);

      } else {
        assert(isa<Instruction>(Pair.first) && "Instruction expected!");
        Instruction *I1 = dyn_cast<Instruction>(Pair.first);
        Instruction *I2 = dyn_cast<Instruction>(Pair.second);


        if (MergedBB == nullptr) {
          MergedBB = BasicBlock::Create(Context, "", MergedFunc);
/*
          I1->dump();
          errs() << "Tail: " <<  GetValueName(dyn_cast<BasicBlock>(I1->getParent())) << " -> " << GetValueName(TailBBs[ dyn_cast<BasicBlock>(I1->getParent()) ]) << "\n";
          I2->dump();
          errs() << "Tail: " <<  GetValueName(dyn_cast<BasicBlock>(I2->getParent())) << " -> " << GetValueName(TailBBs[ dyn_cast<BasicBlock>(I2->getParent()) ]) << "\n";
*/
          {
            IRBuilder<> Builder(TailBBs[ dyn_cast<BasicBlock>(I1->getParent()) ]);
            Builder.CreateBr(MergedBB);
          }
          {
            IRBuilder<> Builder(TailBBs[ dyn_cast<BasicBlock>(I2->getParent()) ]);
            Builder.CreateBr(MergedBB);
          }
        }
        MergedBB1 = dyn_cast<BasicBlock>(I1->getParent());
        MergedBB2 = dyn_cast<BasicBlock>(I2->getParent());

        // if (
        // VMap[I1->getParent()]!=VMap[I2->getParent()]
        // )
        // {
        //   errs() << "Merged instructions not in the same BB\n";
        //}

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

        Instruction *NewI = I->clone();
        VMap[I1] = NewI;
        VMap[I2] = NewI;

        IRBuilder<> Builder(MergedBB);
        Builder.Insert(NewI);

        // TODO: temporary removal of metadata
        
        SmallVector<std::pair<unsigned, MDNode *>, 8> MDs;
        NewI->getAllMetadata(MDs);
        for (std::pair<unsigned, MDNode *> MDPair : MDs) {
          NewI->setMetadata(MDPair.first, nullptr);
        }

/*        
        for (Instruction &I : *MergedBB) {
          if (isa<LandingPadInst>(&I) && MergedBB->getFirstNonPHI()!=(&I)) {
            NewI->dump();
            errs() << "Broken BB: 1\n";
            MergedBB->dump();
          }
        }
*/

        //if (isa<TerminatorInst>(NewI)) {
        if (NewI->isTerminator()) {
          MergedBB = nullptr;
          MergedBB1 = nullptr;
          MergedBB2 = nullptr;
        }
      }
    } else {
      RequiresFuncId = true;

      if (MergedBB != nullptr) {

        BasicBlock *NewBB1 = BasicBlock::Create(Context, "", MergedFunc);
        BasicBlock *NewBB2 = BasicBlock::Create(Context, "", MergedFunc);

        TailBBs[MergedBB1] = NewBB1;
        TailBBs[MergedBB2] = NewBB2;

        IRBuilder<> Builder(MergedBB);
        Builder.CreateCondBr(IsFunc1, NewBB1, NewBB2);

        MergedBB = nullptr;
      }

      Value *V = nullptr;
      if (Pair.first) {
        V = Pair.first;
      } else {
        V = Pair.second;
      }

      if (isa<BasicBlock>(V)) {
        BasicBlock *NewBB = dyn_cast<BasicBlock>(VMap[dyn_cast<BasicBlock>(V)]);
        // BasicBlock *NewBB = BasicBlock::Create(Context, "", MergedFunc);
        // VMap[dyn_cast<BasicBlock>(V)] = NewBB;
        TailBBs[dyn_cast<BasicBlock>(V)] = NewBB;
      } else {
        assert(isa<Instruction>(V) && "Instruction expected!");
        Instruction *I = dyn_cast<Instruction>(V);

        // I->dump();

        Instruction *NewI = nullptr;
        if (I->getOpcode() == Instruction::Ret && !ReturnType->isVoidTy() &&
            I->getNumOperands() == 0) {
          NewI = ReturnInst::Create(Context, UndefValue::get(ReturnType));
        } else
          NewI = I->clone();
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

/*        
        auto *BB =TailBBs[dyn_cast<BasicBlock>(I->getParent())];
        for (Instruction &I : *BB) {
          if (isa<LandingPadInst>(&I) && BB->getFirstNonPHI()!=(&I)) {
            errs() << "Broken BB: 2\n";
            BB->dump();
          }
        }
*/

      }

    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen1.stopTimer();
#endif

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen2.startTimer();
#endif

  for (auto Pair : AlignedInsts) {
    // mergable instructions
    if (Pair.first != nullptr && Pair.second != nullptr) {

      if (isa<Instruction>(Pair.first)) {
        Instruction *I1 = dyn_cast<Instruction>(Pair.first);
        Instruction *I2 = dyn_cast<Instruction>(Pair.second);

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
          CountBinOps++;

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
            CountOpReorder++;
          }

          std::vector<std::pair<Value *, Value *>> Vs;
          Vs.push_back(std::pair<Value *, Value *>(VL1, VL2));
          Vs.push_back(std::pair<Value *, Value *>(VR1, VR2));

          for (unsigned i = 0; i < Vs.size(); i++) {
            Value *V1 = Vs[i].first;
            Value *V2 = Vs[i].second;

            Value *V = V1; // first assume that V1==V2
            if (V1 != V2) {
              RequiresFuncId = true;
              // create predicated select instruction
              if (V1 == ConstantInt::getTrue(Context) &&
                  V2 == ConstantInt::getFalse(Context)) {
                V = IsFunc1;
              } else if (V1 == ConstantInt::getFalse(Context) &&
                         V2 == ConstantInt::getTrue(Context)) {
                V = Builder.CreateNot(IsFunc1);
              } else {
                Value *SelectI = nullptr;

                SelectCacheEntry SCE(IsFunc1, V1, V2, NewI->getParent());
                if (SelectCache.find(SCE) != SelectCache.end()) {
                  SelectI = SelectCache[SCE];
                } else {
                  Value *CastedV2 =
                      createCastIfNeeded(V2, V1->getType(), Builder, IntPtrTy);
                  SelectI = Builder.CreateSelect(IsFunc1, V1, CastedV2);

                  ListSelects.push_back(dyn_cast<Instruction>(SelectI));

                  SelectCache[SCE] = SelectI;
                }

                V = SelectI;
              }
            }

            Value *CastedV = createCastIfNeeded(
                V, NewI->getOperand(i)->getType(), Builder, IntPtrTy);
            NewI->setOperand(i, CastedV);
          }
        } else {
          for (unsigned i = 0; i < I->getNumOperands(); i++) {
            Value *F1V = nullptr;
            Value *V1 = nullptr;
            if (i < I1->getNumOperands()) {
              F1V = I1->getOperand(i);
              V1 = MapValue(I1->getOperand(i), VMap);
              if (V1 == nullptr) {
                errs() << "ERROR: Null value mapped: V1 = "
                          "MapValue(I1->getOperand(i), "
                          "VMap);\n";
                MergedFunc->eraseFromParent();
                return ErrorResponse;
              }
            } else
              V1 = GetAnyValue(I2->getOperand(i)->getType());

            Value *F2V = nullptr;
            Value *V2 = nullptr;
            if (i < I2->getNumOperands()) {
              F2V = I2->getOperand(i);
              V2 = MapValue(I2->getOperand(i), VMap);
              if (V2 == nullptr) {
                errs() << "ERROR: Null value mapped: V2 = "
                          "MapValue(I2->getOperand(i), "
                          "VMap);\n";
                MergedFunc->eraseFromParent();
                return ErrorResponse;
              }
            } else
              V2 = GetAnyValue(I1->getOperand(i)->getType());

            // if (V1==nullptr) V1 = V2;
            // if (V2==nullptr) V2 = V1;
            assert(V1 != nullptr && "Value should NOT be null!");
            assert(V2 != nullptr && "Value should NOT be null!");

            Value *V = V1; // first assume that V1==V2

            if (V1 != V2) {
              RequiresFuncId = true;
              if (isa<BasicBlock>(V1) && isa<BasicBlock>(V2)) {
                auto CacheKey = std::pair<BasicBlock *, BasicBlock *>(
                    dyn_cast<BasicBlock>(V1), dyn_cast<BasicBlock>(V2));
                BasicBlock *SelectBB = nullptr;
                if (CacheBBSelect.find(CacheKey) != CacheBBSelect.end()) {
                  SelectBB = CacheBBSelect[CacheKey];
                } else {
                  SelectBB = BasicBlock::Create(Context, "", MergedFunc);
                  IRBuilder<> BuilderBB(SelectBB);

                  BasicBlock *BB1 = dyn_cast<BasicBlock>(V1);
                  BasicBlock *BB2 = dyn_cast<BasicBlock>(V2);

                  if (BB1->isLandingPad() || BB2->isLandingPad()) {
                    LandingPadInst *LP1 = BB1->getLandingPadInst();
                    LandingPadInst *LP2 = BB2->getLandingPadInst();
                    // assert ( (LP1!=nullptr && LP2!=nullptr) && "Should be
                    // both as per the BasicBlock match!");
                    if (LP1 == nullptr || LP2 == nullptr) {
                      errs() << "Should have two LandingPadInst as per the "
                                "BasicBlock match!\n";
#ifdef ENABLE_DEBUG_CODE
                      I1->dump();
                      I2->dump();
                      NewI->dump();
#endif
                      MergedFunc->eraseFromParent();
                      return ErrorResponse;
                    }

                    Instruction *NewLP = LP1->clone();
                    BuilderBB.Insert(NewLP);
                    
                    BasicBlock *F1BB = dyn_cast<BasicBlock>(F1V);
                    BasicBlock *F2BB = dyn_cast<BasicBlock>(F2V);

                    VMap[F1BB] = SelectBB;
                    VMap[F2BB] = SelectBB;
                    if (TailBBs[F1BB]==nullptr) TailBBs[F1BB]=BB1;
                    if (TailBBs[F2BB]==nullptr) TailBBs[F2BB]=BB2;
                    VMap[F1BB->getLandingPadInst()] = NewLP;
                    VMap[F2BB->getLandingPadInst()] = NewLP;
                    
                    /*
                    for (auto kv : VMap) {
                      if (kv.second == LP1 || kv.second == LP2) {
                        VMap[kv.first] = NewLP;
                      } else if(kv.second == BB1 || kv.second == B2) {
                        VMap[kv.first] = SelectBB;
                      }
                    }
                    */
                    
                    BB1->replaceAllUsesWith(SelectBB);
                    BB2->replaceAllUsesWith(SelectBB);

                    LP1->replaceAllUsesWith(NewLP);
                    LP1->eraseFromParent();
                    LP2->replaceAllUsesWith(NewLP);
                    LP2->eraseFromParent();
                  }

                  BuilderBB.CreateCondBr(IsFunc1, BB1, BB2);
                  CacheBBSelect[CacheKey] = SelectBB;
                }
                V = SelectBB;
              } else {
                // create predicated select instruction
                if (V1 == ConstantInt::getTrue(Context) &&
                    V2 == ConstantInt::getFalse(Context)) {
                  V = IsFunc1;
                } else if (V1 == ConstantInt::getFalse(Context) &&
                           V2 == ConstantInt::getTrue(Context)) {
                  V = Builder.CreateNot(IsFunc1);
                } else {
                  Value *SelectI = nullptr;

                  SelectCacheEntry SCE(IsFunc1, V1, V2, NewI->getParent());
                  if (SelectCache.find(SCE) != SelectCache.end()) {
                    SelectI = SelectCache[SCE];
                  } else {

                    Value *CastedV2 = createCastIfNeeded(V2, V1->getType(),
                                                         Builder, IntPtrTy);
                    SelectI = Builder.CreateSelect(IsFunc1, V1, CastedV2);

                    ListSelects.push_back(dyn_cast<Instruction>(SelectI));

                    SelectCache[SCE] = SelectI;
                  }

                  V = SelectI;
                }
              }
            }

            Value *CastedV = V;
            if (!isa<BasicBlock>(V))
              CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(),
                                           Builder, IntPtrTy);
            NewI->setOperand(i, CastedV);
          }
        } // TODO: end of commutative if-else

/*
        for (Instruction &I : *NewI->getParent()) {
          if (isa<LandingPadInst>(&I) && NewI->getParent()->getFirstNonPHI()!=(&I)) {
            NewI->dump();
            errs() << "Broken BB: 3\n";
            NewI->getParent()->dump();
          }
        }
*/

      }

    } else {
      RequiresFuncId = true;

      Value *V = nullptr;
      if (Pair.first) {
        V = Pair.first;
      } else {
        V = Pair.second;
      }

      if (isa<Instruction>(V)) {
        Instruction *I = dyn_cast<Instruction>(V);

        Instruction *NewI = dyn_cast<Instruction>(VMap[I]);

        IRBuilder<> Builder(NewI);

        for (unsigned i = 0; i < I->getNumOperands(); i++) {
          Value *V = MapValue(I->getOperand(i), VMap);
          if (V == nullptr) {
            errs() << "ERROR: Null value mapped: V = "
                      "MapValue(I->getOperand(i), VMap);\n";
            MergedFunc->eraseFromParent();
            return ErrorResponse;
          }

          Value *CastedV = V;
          if (!isa<BasicBlock>(V))
            CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(),
                                         Builder, IntPtrTy);
          NewI->setOperand(i, CastedV);
        }

/*
        for (Instruction &I : *NewI->getParent()) {
          if (isa<LandingPadInst>(&I) && NewI->getParent()->getFirstNonPHI()!=(&I)) {
            NewI->dump();
            errs() << "Broken BB: 4\n";
            NewI->getParent()->dump();
          }
        }
*/

      }
    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen2.stopTimer();
#endif

#ifdef TIME_STEPS_DEBUG
  TimeCodeGenFix.startTimer();
#endif

  {
    DominatorTree DT(*MergedFunc);
    removeRedundantInstructions(MergedFunc, DT, ListSelects);
  }

  {
    DominatorTree DT(*MergedFunc);
    if (!fixNotDominatedUses(MergedFunc, DT)) {
      MergedFunc->eraseFromParent();
      MergedFunc = nullptr;
    }
  }

#ifdef TIME_STEPS_DEBUG
  TimeCodeGenFix.stopTimer();
#endif

  MergedFunction Result(F1, F2, MergedFunc);
  Result.ParamMap1 = ParamMap1;
  Result.ParamMap2 = ParamMap2;
  Result.hasFuncIdArg = (FuncId != nullptr);
  Result.RoughReduction = RoughReduction;
  return Result;
}

static bool canReplaceAllCalls(Function *F) {
  for (User *U : F->users()) {
    if (CallInst *CI = dyn_cast<CallInst>(U)) {
      if (CI->getCalledFunction() != F)
        return false;
    } else
      return false;
  }
  return true;
}

void replaceByCall(Module *M, Function *F, MergedFunction &MergedFunc) {
  LLVMContext &Context = M->getContext();
  const DataLayout *DL = &M->getDataLayout();
  Type *IntPtrTy = DL ? DL->getIntPtrType(Context) : NULL;

  if (Verbose) {
    errs() << "replaceByCall\n";
  }

  Value *FuncId = (MergedFunc.F1 == F)
                      ? ConstantInt::getTrue(MergedFunc.F1->getContext())
                      : ConstantInt::getFalse(MergedFunc.F1->getContext());
  Function *MergedF = MergedFunc.MergedFunc;

  F->deleteBody();
  BasicBlock *NewBB = BasicBlock::Create(MergedFunc.F1->getContext(), "", F);
  IRBuilder<> Builder(NewBB);

  // if (Verbose) {
  //   F->dump();
  //}

  std::vector<Value *> args;
  for (unsigned i = 0; i < MergedF->getFunctionType()->getNumParams(); i++) {
    args.push_back(nullptr);
  }

  if (MergedFunc.hasFuncIdArg) {
    args[0] = FuncId;
    // args[0] = Builder.getInt32(FuncId);
  }

  std::vector<Argument *> ArgsList;
  for (Argument &arg : F->args()) {
    ArgsList.push_back(&arg);
  }

  if (MergedFunc.F1 == F) {
    for (auto Pair : MergedFunc.ParamMap1) {
      args[Pair.second] = ArgsList[Pair.first];
    }
  } else {
    for (auto Pair : MergedFunc.ParamMap2) {
      args[Pair.second] = ArgsList[Pair.first];
    }
  }
  for (unsigned i = 0; i < args.size(); i++) {
    if (args[i] == nullptr) {
      args[i] = GetAnyValue(MergedF->getFunctionType()->getParamType(i));
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
    Value *CastedV =
        createCastIfNeeded(CI, F->getReturnType(), Builder, IntPtrTy);
    Builder.CreateRet(CastedV);
  }
}

bool replaceCallsWith(Module *M, Function *F, MergedFunction &MergedFunc) {
  //return false;

  LLVMContext &Context = M->getContext();
  const DataLayout *DL = &M->getDataLayout();
  Type *IntPtrTy = DL ? DL->getIntPtrType(Context) : NULL;

  Value *FuncId = (MergedFunc.F1 == F) ? ConstantInt::getTrue(Context)
                                       : ConstantInt::getFalse(Context);
  Function *MergedF = MergedFunc.MergedFunc;

  if (Verbose) {
    errs() << "replaceCallsWith\n";
  }
  std::vector<CallInst *> Calls;
  for (User *U : F->users()) {
    if (CallInst *CI = dyn_cast<CallInst>(U)) {
      if (CI->getCalledFunction() == F) {
        CallInst *CI = dyn_cast<CallInst>(U); // CS.getInstruction());
        Calls.push_back(CI);
      } else
        return false;
    } else
      return false;
  }

  for (CallInst *CI : Calls) {
    IRBuilder<> Builder(CI);

    std::vector<Value *> args;
    for (unsigned i = 0; i < MergedF->getFunctionType()->getNumParams(); i++) {
      args.push_back(nullptr);
    }

    if (MergedFunc.hasFuncIdArg) {
      args[0] = FuncId;
    }

    if (MergedFunc.F1 == F) {
      for (auto Pair : MergedFunc.ParamMap1) {
        args[Pair.second] = CI->getArgOperand(Pair.first);
      }
    } else {
      for (auto Pair : MergedFunc.ParamMap2) {
        args[Pair.second] = CI->getArgOperand(Pair.first);
      }
    }
    for (unsigned i = 0; i < args.size(); i++) {
      if (args[i] == nullptr) {
        args[i] = GetAnyValue(MergedF->getFunctionType()->getParamType(i));
      }
    }

    CallInst *NewCI = (CallInst *)Builder.CreateCall(MergedF->getFunctionType(),
                                                     MergedF, args);
    NewCI->setCallingConv(MergedF->getCallingConv());
    NewCI->setAttributes(MergedF->getAttributes());
    NewCI->setIsNoInline();

    Value *CastedV = NewCI;
    if (!F->getReturnType()->isVoidTy()) {
      CastedV =
          createCastIfNeeded(NewCI, F->getReturnType(), Builder, IntPtrTy);
    }
    // if (F->getReturnType()==MergedF->getReturnType())
    if (CI->getNumUses() > 0) {
      CI->replaceAllUsesWith(CastedV);
    }

    if (CI->getNumUses() == 0) {
      CI->eraseFromParent();
    } else {
      if (CI->getNumUses() > 0) {

        if (Verbose) {
          errs() << "ERROR: Function Call has uses\n";
#ifdef ENABLE_DEBUG_CODE
          CI->dump();
          errs() << "Called type\n";
          F->getReturnType()->dump();
          errs() << "Merged type\n";
          MergedF->getReturnType()->dump();
#endif
        }
      }
    }
  }

  return true;
}

int requiresOriginalInterfaces(MergedFunction &MergedFunc) {
  return (canReplaceAllCalls(MergedFunc.F1) ? 0 : 1) +
         (canReplaceAllCalls(MergedFunc.F2) ? 0 : 1);
}

void static UpdateCallGraph(Module &M, MergedFunction &Result,
                            StringSet<> &AlwaysPreserved) {
  Function *F1 = Result.F1;
  Function *F2 = Result.F2;

  replaceByCall(&M, F1, Result);
  replaceByCall(&M, F2, Result);

  bool CanEraseF1 = replaceCallsWith(&M, F1, Result);
  bool CanEraseF2 = replaceCallsWith(&M, F2, Result);

  ////if (F1->getLinkage()==GlobalValue::LinkageTypes::InternalLinkage
  ///|| F1->getLinkage()==GlobalValue::LinkageTypes::PrivateLinkage) {
  // if (!shouldPreserveGV(*F1))
  if (CanEraseF1 && (F1->getNumUses() == 0) && (HasWholeProgram?true:F1->hasLocalLinkage()) &&
      (AlwaysPreserved.find(F1->getName()) == AlwaysPreserved.end())) {
    // CallSiteExtractedLoops.erase(F1);
    F1->eraseFromParent();
  }

  // if (!shouldPreserveGV(*F2))
  if (CanEraseF2 && (F2->getNumUses() == 0) && (HasWholeProgram?true:F2->hasLocalLinkage()) &&
      (AlwaysPreserved.find(F2->getName()) == AlwaysPreserved.end())) {
    // CallSiteExtractedLoops.erase(F2);
    F2->eraseFromParent();
  }
}

bool FMSA::shouldPreserveGV(const GlobalValue &GV) {
  // Function must be defined here
  if (GV.isDeclaration())
    return true;

  // Available externally is really just a "declaration with a body".
  if (GV.hasAvailableExternallyLinkage())
    return true;

  // Assume that dllexported symbols are referenced elsewhere
  if (GV.hasDLLExportStorageClass())
    return true;

  // Already local, has nothing to do.
  if (GV.hasLocalLinkage())
    return false;

  // Check some special cases
  if (AlwaysPreserved.find(GV.getName()) != AlwaysPreserved.end())
    return true;

  return false;
}

static bool compareFunctionScores(const std::pair<Function *, unsigned> &F1,
                                  const std::pair<Function *, unsigned> &F2) {
  return F1.second > F2.second;
}

//#define FMSA_USE_JACCARD

class Fingerprint {
public:
  static const size_t MaxOpcode = 68;
  int OpcodeFreq[MaxOpcode];
  // std::map<unsigned, int> OpcodeFreq;
  // size_t NumOfInstructions;
  // size_t NumOfBlocks;

  /*
  #ifdef FMSA_USE_JACCARD
  std::set<Type *> Types;
  #else
  std::map<Type*, int> TypeFreq;
  #endif
  */

  Function *F;

  Fingerprint(Function *F) {
    this->F = F;

    //memset(OpcodeFreq, 0, sizeof(int) * MaxOpcode);
    for (int i = 0; i<MaxOpcode; i++) OpcodeFreq[i] = 0;

    // NumOfInstructions = 0;
    for (Instruction &I : instructions(F)) {
      OpcodeFreq[I.getOpcode()]++;
      /*
            if (OpcodeFreq.find(I.getOpcode()) != OpcodeFreq.end())
              OpcodeFreq[I.getOpcode()]++;
            else
              OpcodeFreq[I.getOpcode()] = 1;
      */
      // NumOfInstructions++;

      
      //#ifdef FMSA_USE_JACCARD
      //Types.insert(I.getType());
      //#else
      //TypeFreq[I.getType()]++;
      //#endif
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
    
    /*
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
    */
    float UpperBound =
        ((float)Similarity) / ((float)(Similarity * 2.0f + LeftOver));

    Score = UpperBound;

    /*
    #ifdef FMSA_USE_JACCARD
    Score = UpperBound * TypeScore;
    #else
    Score = std::min(UpperBound,TypeScore);
    #endif
    */
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

  if (Item.Similarity < Item.LeftOver)
    return false;

  float TypesDiffRatio = (((float)Item.TypesDiff) / ((float)Item.TypesSim));
  if (TypesDiffRatio > 1.5f)
    return false;

  return true;
}

#ifdef TIME_STEPS_DEBUG
Timer TimePreProcess("Merge::Preprocess", "Merge::Preprocess");
Timer TimeLin("Merge::Lin", "Merge::Lin");
Timer TimeRank("Merge::Rank", "Merge::Rank");
Timer TimeUpdate("Merge::Update", "Merge::Update");
#endif

/*
bool FunctionMerging::runOnModule(Module &M) {
  AlwaysPreserved.clear();
  AlwaysPreserved.insert("main");

  std::set< std::string> BlackList;

  srand(time(NULL));

  TargetTransformInfo TTI(M.getDataLayout());

  std::vector<std::pair<Function *, unsigned>> FunctionsToProcess;

  unsigned TotalOpReorder = 0;
  unsigned TotalBinOps = 0;

  std::map<Function *, Fingerprint *> CachedFingerprints;
  std::map<Function *, unsigned> FuncSizes;

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.startTimer();
#endif

  for (auto &F : M) {
    if (F.isDeclaration() || F.isVarArg()) // || F.getSubprogram() != nullptr)
      continue;

    if ( BlackList.count( std::string(F.getName()) ) ) continue;

    FuncSizes[&F] = estimateFunctionSize(F, &TTI); /// TODO

    demoteRegToMem(F);

    FunctionsToProcess.push_back(
      std::pair<Function *, unsigned>(&F, FuncSizes[&F]) );

    CachedFingerprints[&F] = new Fingerprint(&F);
  }

  std::sort(FunctionsToProcess.begin(), FunctionsToProcess.end(),
            compareFunctionScores);

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.stopTimer();
#endif

  std::list<Function *> WorkList;

  std::set<Function *> AvailableCandidates;
  for (std::pair<Function *, unsigned> FuncAndSize1 : FunctionsToProcess) {
    Function *F1 = FuncAndSize1.first;
    WorkList.push_back(F1);
    AvailableCandidates.insert(F1);
  }

  std::vector<FingerprintSimilarity> Rank;
  if (ExplorationThreshold > 1)
    Rank.reserve(FunctionsToProcess.size());

  FunctionsToProcess.clear();

  while (!WorkList.empty()) {
    Function *F1 = WorkList.front();
    WorkList.pop_front();

    AvailableCandidates.erase(F1);

    Rank.clear();

#ifdef TIME_STEPS_DEBUG
    TimeRank.startTimer();
#endif

    Fingerprint *FP1 = CachedFingerprints[F1];

    if (ExplorationThreshold > 1) {
      for (Function *F2 : AvailableCandidates) {
        if (!validMergeTypes(F1, F2) || filterMergePair(F1, F2))
          continue;

        Fingerprint *FP2 = CachedFingerprints[F2];

        FingerprintSimilarity PairSim(FP1, FP2);
        if (SimilarityHeuristicFilter(PairSim))
          Rank.push_back(PairSim);
      }
      std::make_heap(Rank.begin(), Rank.end());
    } else {

      bool FoundCandidate = false;
      FingerprintSimilarity BestPair;

      for (Function *F2 : AvailableCandidates) {
        if (!validMergeTypes(F1, F2) || filterMergePair(F1, F2))
          continue;

        Fingerprint *FP2 = CachedFingerprints[F2];

        FingerprintSimilarity PairSim(FP1, FP2);
        if (PairSim > BestPair && SimilarityHeuristicFilter(PairSim)) {
          BestPair = PairSim;
          FoundCandidate = true;
        }
      }
      if (FoundCandidate)
        Rank.push_back(BestPair);
    }

#ifdef TIME_STEPS_DEBUG
    TimeRank.stopTimer();
    TimeLin.startTimer();
#endif

    SmallVector<Value *, 32> F1Vec;
    Linearization(F1, F1Vec, LinearizationKind::LK_Canonical);

#ifdef TIME_STEPS_DEBUG
    TimeLin.stopTimer();
#endif

    unsigned MergingTrialsCount = 0;

    while (!Rank.empty()) {
      auto RankEntry = Rank.front();
      Function *F2 = RankEntry.F2;
      std::pop_heap(Rank.begin(), Rank.end());
      Rank.pop_back();

      CountBinOps = 0;
      CountOpReorder = 0;

      MergingTrialsCount++;

      if (Debug || Verbose) {
        errs() << "Attempting: " << GetValueName(F1) << ", " << GetValueName(F2)
               << "\n";
      }

#ifdef TIME_STEPS_DEBUG
      TimeLin.startTimer();
#endif
      SmallVector<Value *, 32> F2Vec;
      F2Vec.reserve(F1Vec.size());
      Linearization(F2, F2Vec, LinearizationKind::LK_Canonical);

#ifdef TIME_STEPS_DEBUG
      TimeLin.stopTimer();
#endif

      MergedFunction Result = mergeBySequenceAlignment(F1, F2, F1Vec, F2Vec);

      if (Result.MergedFunc != nullptr && verifyFunction(*Result.MergedFunc)) {
        if (Debug || Verbose) {
          errs() << "Invalid Function: " << GetValueName(F1) << ", "
                 << GetValueName(F2) << "\n";
        }
#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          if (Result.MergedFunc != nullptr) {
            Result.MergedFunc->dump();
          }
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
        }
#endif
        Result.MergedFunc->eraseFromParent();
        Result.MergedFunc = nullptr;
      }

      if (Result.MergedFunc) {
        DominatorTree MergedDT(*Result.MergedFunc);
        promoteMemoryToRegister(*Result.MergedFunc, MergedDT);

        unsigned SizeF1 = FuncSizes[F1];
        unsigned SizeF2 = FuncSizes[F2];

        unsigned SizeF12 = requiresOriginalInterfaces(Result) * 3 +
                           estimateFunctionSize(*Result.MergedFunc, &TTI);

#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
          errs() << "F1-F2:\n";
          Result.MergedFunc->dump();
        }
#endif

        if (Debug || Verbose) {
          errs() << "Sizes: " << SizeF1 << " + " << SizeF2 << " <= " << SizeF12 << "?\n";
        }

        if (Debug || Verbose) {
          errs() << "Estimated reduction: "
                 << (int)((1 - ((double)SizeF12) / (SizeF1 + SizeF2)) * 100)
                 << "% ("
                 << (SizeF12 < (SizeF1 + SizeF2) *
                                   ((100.0 + MergingOverheadThreshold) / 100.0))
                 << ") " << MergingTrialsCount << " : " << GetValueName(F1)
                 << "; " << GetValueName(F2) << " | Score " << RankEntry.Score
                 << " | Rough " << Result.RoughReduction << "% ["
                 << (Result.RoughReduction > 1.0) << "]\n";
        }
        // NumOfMergedInsts += maxSimilarity;
        if (SizeF12 <
            (SizeF1 + SizeF2) * ((100.0 + MergingOverheadThreshold) / 100.0)) {

          MergingDistance.push_back(MergingTrialsCount);

          TotalOpReorder += CountOpReorder;
          TotalBinOps += CountBinOps;

          if (Debug || Verbose) {
            errs() << "Merged: " << GetValueName(F1) << ", " << GetValueName(F2)
                   << " = " << GetValueName(Result.MergedFunc) << "\n";
          }

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.startTimer();
#endif

          AvailableCandidates.erase(F2);
          WorkList.remove(F2);

          // update call graph
          UpdateCallGraph(M, Result, AlwaysPreserved);

          // feed new function back into the working lists
          WorkList.push_front(Result.MergedFunc);
          AvailableCandidates.insert(Result.MergedFunc);

          FuncSizes[Result.MergedFunc] =
              estimateFunctionSize(*Result.MergedFunc, &TTI);

          // demote phi instructions
          demoteRegToMem(*Result.MergedFunc);

          CachedFingerprints[Result.MergedFunc] =
              new Fingerprint(Result.MergedFunc);

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.stopTimer();
#endif

          break; // end exploration

        } else {
          if (Result.MergedFunc != nullptr)
            Result.MergedFunc->eraseFromParent();
        }
      }

      if (MergingTrialsCount >= ExplorationThreshold) {
        break;
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
  for (unsigned Distance : MergingDistance) {
    MergingAverageDistance += Distance;
    if (Distance > MergingMaxDistance)
      MergingMaxDistance = Distance;
  }
  if (MergingDistance.size() > 0) {
    MergingAverageDistance = MergingAverageDistance / MergingDistance.size();
  }

  if (Debug || Verbose) {
    errs() << "Total operand reordering: " << TotalOpReorder << "/"
           << TotalBinOps << " ("
           << 100.0 * (((double)TotalOpReorder) / ((double)TotalBinOps))
           << " %)\n";

    errs() << "Total parameter score: " << TotalParamScore << "\n";

    errs() << "Total number of merges: " << MergingDistance.size() << "\n";
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

  errs() << "Timer:CodeGen1: " << TimeCodeGen1.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen1.clear();

  errs() << "Timer:CodeGen2: " << TimeCodeGen2.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen2.clear();

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
*/

void FMSA::getAnalysisUsage(AnalysisUsage &AU) const {}

char FMSA::ID = 0;
#ifdef LLVM_NEXT_FM_STANDALONE
static RegisterPass<FMSA> X("fmsa", "New Function Merging", false, false);
#else
INITIALIZE_PASS(FMSA, "fmsa", "New Function Merging", false,
                false)
#endif


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

bool FMSA::runOnModule(Module &M) {
  AlwaysPreserved.clear();
  AlwaysPreserved.insert("main");

  //std::set< std::string> BlackList;

  srand(time(NULL));

  TargetTransformInfo TTI(M.getDataLayout());

  std::vector<std::pair<Function *, unsigned>> FunctionsToProcess;

  unsigned TotalOpReorder = 0;
  unsigned TotalBinOps = 0;

  std::map<Function *, Fingerprint *> CachedFingerprints;
  std::map<Function *, unsigned> FuncSizes;

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.startTimer();
#endif

  //errs() << "Creating fingerprints...\n";
  for (auto &F : M) {
    if (F.isDeclaration() || F.isVarArg()) // || F.getSubprogram() != nullptr)
      continue;

    //if ( BlackList.count( std::string(F.getName()) ) ) continue;

    FuncSizes[&F] = estimateFunctionSize(F, &TTI); /// TODO

    demoteRegToMem(F);

    FunctionsToProcess.push_back(
      std::pair<Function *, unsigned>(&F, FuncSizes[&F]) );

    CachedFingerprints[&F] = new Fingerprint(&F);
  }

  //errs() << "Sorting...\n";
  std::sort(FunctionsToProcess.begin(), FunctionsToProcess.end(),
            compareFunctionScores);

#ifdef TIME_STEPS_DEBUG
  TimePreProcess.stopTimer();
#endif

  std::list<Function *> WorkList;

  std::set<Function *> AvailableCandidates;
  for (std::pair<Function *, unsigned> FuncAndSize1 : FunctionsToProcess) {
    Function *F1 = FuncAndSize1.first;
    WorkList.push_back(F1);
    AvailableCandidates.insert(F1);
  }

  std::vector<FingerprintSimilarity> Rank;
  if (ExplorationThreshold > 1)
    Rank.reserve(FunctionsToProcess.size());

  FunctionsToProcess.clear();

  while (!WorkList.empty()) {
    Function *F1 = WorkList.front();
    WorkList.pop_front();

    AvailableCandidates.erase(F1);

    Rank.clear();

#ifdef TIME_STEPS_DEBUG
    TimeRank.startTimer();
#endif

    Fingerprint *FP1 = CachedFingerprints[F1];

    //errs() << "Ranking...\n";
    if (ExplorationThreshold > 1 || RunBruteForceExploration) {
      for (Function *F2 : AvailableCandidates) {
        if (!validMergeTypes(F1, F2) || filterMergePair(F1, F2))
          continue;

        Fingerprint *FP2 = CachedFingerprints[F2];

        FingerprintSimilarity PairSim(FP1, FP2);
        if (SimilarityHeuristicFilter(PairSim))
          Rank.push_back(PairSim);
      }
      if (!RunBruteForceExploration)
        std::make_heap(Rank.begin(), Rank.end());
    } else {
      bool FoundCandidate = false;
      FingerprintSimilarity BestPair;

      //errs() << "Evaluating candidates...\n";
      for (Function *F2 : AvailableCandidates) {
        if (!validMergeTypes(F1, F2) || filterMergePair(F1, F2))
          continue;

        //errs() << "cached fingerprint...\n";
        Fingerprint *FP2 = CachedFingerprints[F2];

        //errs() << "computing similarity...\n";
	//computing similarity
        FingerprintSimilarity PairSim(FP1, FP2);
        if (PairSim > BestPair && SimilarityHeuristicFilter(PairSim)) {
          BestPair = PairSim;
          FoundCandidate = true;
        }
      }
      //errs() << "done.\n";
      if (FoundCandidate)
        Rank.push_back(BestPair);
    }
#ifdef TIME_STEPS_DEBUG
    TimeRank.stopTimer();
    TimeLin.startTimer();
#endif

    SmallVector<Value *, 32> F1Vec;
    Linearization(F1, F1Vec, LinearizationKind::LK_Canonical);

#ifdef TIME_STEPS_DEBUG
    TimeLin.stopTimer();
#endif

    unsigned MergingTrialsCount = 0;

    Function *BestCandidate = nullptr;
    int BestReduction = INT_MIN;

    while (!Rank.empty()) {
      //errs() << "Next candidate...\n";

      Function *F2 = nullptr;
      if (RunBruteForceExploration) {
        auto RankEntry = Rank.back();
        F2 = RankEntry.F2;
        Rank.pop_back();
      } else {
        auto RankEntry = Rank.front();
        F2 = RankEntry.F2;
        std::pop_heap(Rank.begin(), Rank.end());
        Rank.pop_back();
      }

      CountBinOps = 0;
      CountOpReorder = 0;

      MergingTrialsCount++;

      if (Debug || Verbose) {
        errs() << "Attempting: " << GetValueName(F1) << ", " << GetValueName(F2)
               << "\n";
      }

#ifdef TIME_STEPS_DEBUG
      TimeLin.startTimer();
#endif
      SmallVector<Value *, 32> F2Vec;
      F2Vec.reserve(F1Vec.size());
      Linearization(F2, F2Vec, LinearizationKind::LK_Canonical);

#ifdef TIME_STEPS_DEBUG
      TimeLin.stopTimer();
#endif

      MergedFunction Result = mergeBySequenceAlignment(F1, F2, F1Vec, F2Vec);

      if (Result.MergedFunc != nullptr && verifyFunction(*Result.MergedFunc)) {
        if (Debug || Verbose) {
          errs() << "Invalid Function: " << GetValueName(F1) << ", "
                 << GetValueName(F2) << "\n";
        }
#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          if (Result.MergedFunc != nullptr) {
            Result.MergedFunc->dump();
          }
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
        }
#endif
        Result.MergedFunc->eraseFromParent();
        Result.MergedFunc = nullptr;
      }

      if (Result.MergedFunc) {
        DominatorTree MergedDT(*Result.MergedFunc);
        promoteMemoryToRegister(*Result.MergedFunc, MergedDT);

        unsigned SizeF1 = FuncSizes[F1];
        unsigned SizeF2 = FuncSizes[F2];

        unsigned SizeF12 = requiresOriginalInterfaces(Result) * 3 +
                           estimateFunctionSize(*Result.MergedFunc, &TTI);

#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
          errs() << "F1-F2:\n";
          Result.MergedFunc->dump();
        }
#endif

        if (Debug || Verbose) {
          errs() << "Sizes: " << SizeF1 << " + " << SizeF2 << " <= " << SizeF12 << "?\n";
        }

        if (Debug || Verbose) {
          errs() << "Estimated reduction: "
                 << (int)((1 - ((double)SizeF12) / (SizeF1 + SizeF2)) * 100)
                 << "% ("
                 << (SizeF12 < (SizeF1 + SizeF2) *
                                   ((100.0 + MergingOverheadThreshold) / 100.0))
                 << ") " << MergingTrialsCount << " : " << GetValueName(F1)
                 << "; " << GetValueName(F2) << "\n";
                 //<< "; " << GetValueName(F2) << " | Score " << RankEntry.Score
                 //<< " | Rough " << Result.RoughReduction << "% ["
                 //<< (Result.RoughReduction > 1.0) << "]\n";
        }
        // NumOfMergedInsts += maxSimilarity;
        if (SizeF12 <
            (SizeF1 + SizeF2) * ((100.0 + MergingOverheadThreshold) / 100.0)) {


          if (RunBruteForceExploration) {
            int Reduction = (int)(SizeF1 + SizeF2) - ((int)SizeF12);
            if (Reduction > BestReduction) {
               BestReduction = Reduction;
               BestCandidate = F2;
            }
            Result.MergedFunc->eraseFromParent();
            continue;
          }

          MergingDistance.push_back(MergingTrialsCount);

          TotalOpReorder += CountOpReorder;
          TotalBinOps += CountBinOps;

          if (Debug || Verbose) {
            errs() << "Merged: " << GetValueName(F1) << ", " << GetValueName(F2)
                   << " = " << GetValueName(Result.MergedFunc) << "\n";
          }

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.startTimer();
#endif

          AvailableCandidates.erase(F2);
          WorkList.remove(F2);

          // update call graph
          UpdateCallGraph(M, Result, AlwaysPreserved);

          // feed new function back into the working lists
          WorkList.push_front(Result.MergedFunc);
          AvailableCandidates.insert(Result.MergedFunc);

          FuncSizes[Result.MergedFunc] =
              estimateFunctionSize(*Result.MergedFunc, &TTI);

          // demote phi instructions
          demoteRegToMem(*Result.MergedFunc);

          CachedFingerprints[Result.MergedFunc] =
              new Fingerprint(Result.MergedFunc);

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.stopTimer();
#endif

          break; // end exploration

        } else {
          if (Result.MergedFunc != nullptr)
            Result.MergedFunc->eraseFromParent();
        }
      }

      if (MergingTrialsCount >= ExplorationThreshold && !RunBruteForceExploration) {
        break;
      }
    }
    if (BestCandidate!=nullptr && RunBruteForceExploration) {
      Function *F2 = BestCandidate;

      SmallVector<Value *, 32> F2Vec;
      F2Vec.reserve(F1Vec.size());
      Linearization(F2, F2Vec, LinearizationKind::LK_Canonical);

      MergedFunction Result = mergeBySequenceAlignment(F1, F2, F1Vec, F2Vec);

      if (Result.MergedFunc != nullptr && verifyFunction(*Result.MergedFunc)) {
        if (Debug || Verbose) {
          errs() << "Invalid Function: " << GetValueName(F1) << ", "
                 << GetValueName(F2) << "\n";
        }
#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          if (Result.MergedFunc != nullptr) {
            Result.MergedFunc->dump();
          }
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
        }
#endif
        Result.MergedFunc->eraseFromParent();
        Result.MergedFunc = nullptr;
      }

      if (Result.MergedFunc) {
        DominatorTree MergedDT(*Result.MergedFunc);
        promoteMemoryToRegister(*Result.MergedFunc, MergedDT);

        unsigned SizeF1 = FuncSizes[F1];
        unsigned SizeF2 = FuncSizes[F2];

        unsigned SizeF12 = requiresOriginalInterfaces(Result) * 3 +
                           estimateFunctionSize(*Result.MergedFunc, &TTI);

#ifdef ENABLE_DEBUG_CODE
        if (Verbose) {
          errs() << "F1:\n";
          F1->dump();
          errs() << "F2:\n";
          F2->dump();
          errs() << "F1-F2:\n";
          Result.MergedFunc->dump();
        }
#endif

        if (Debug || Verbose) {
          errs() << "Sizes: " << SizeF1 << " + " << SizeF2 << " <= " << SizeF12 << "?\n";
        }

        if (Debug || Verbose) {
          errs() << "Estimated reduction: "
                 << (int)((1 - ((double)SizeF12) / (SizeF1 + SizeF2)) * 100)
                 << "% ("
                 << (SizeF12 < (SizeF1 + SizeF2) *
                                   ((100.0 + MergingOverheadThreshold) / 100.0))
                 << ") " << MergingTrialsCount << " : " << GetValueName(F1)
                 << "; " << GetValueName(F2) << "\n";
                 //" | Score " << RankEntry.Score
                 //<< " | Rough " << Result.RoughReduction << "% ["
                 //<< (Result.RoughReduction > 1.0) << "]\n";
        }
        // NumOfMergedInsts += maxSimilarity;
        if (SizeF12 <
            (SizeF1 + SizeF2) * ((100.0 + MergingOverheadThreshold) / 100.0)) {

          MergingDistance.push_back(MergingTrialsCount);

          TotalOpReorder += CountOpReorder;
          TotalBinOps += CountBinOps;

          if (Debug || Verbose) {
            errs() << "Merged: " << GetValueName(F1) << ", " << GetValueName(F2)
                   << " = " << GetValueName(Result.MergedFunc) << "\n";
          }

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.startTimer();
#endif

          AvailableCandidates.erase(F2);
          WorkList.remove(F2);

          // update call graph
          UpdateCallGraph(M, Result, AlwaysPreserved);

          // feed new function back into the working lists
          WorkList.push_front(Result.MergedFunc);
          AvailableCandidates.insert(Result.MergedFunc);

          FuncSizes[Result.MergedFunc] =
              estimateFunctionSize(*Result.MergedFunc, &TTI);

          // demote phi instructions
          demoteRegToMem(*Result.MergedFunc);

          CachedFingerprints[Result.MergedFunc] =
              new Fingerprint(Result.MergedFunc);

#ifdef TIME_STEPS_DEBUG
          TimeUpdate.stopTimer();
#endif

        } else {
          if (Result.MergedFunc != nullptr)
            Result.MergedFunc->eraseFromParent();
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
  for (unsigned Distance : MergingDistance) {
    MergingAverageDistance += Distance;
    if (Distance > MergingMaxDistance)
      MergingMaxDistance = Distance;
  }
  if (MergingDistance.size() > 0) {
    MergingAverageDistance = MergingAverageDistance / MergingDistance.size();
  }

  if (Debug || Verbose) {
    errs() << "Total operand reordering: " << TotalOpReorder << "/"
           << TotalBinOps << " ("
           << 100.0 * (((double)TotalOpReorder) / ((double)TotalBinOps))
           << " %)\n";

    errs() << "Total parameter score: " << TotalParamScore << "\n";

    errs() << "Total number of merges: " << MergingDistance.size() << "\n";
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

  errs() << "Timer:CodeGen1: " << TimeCodeGen1.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen1.clear();

  errs() << "Timer:CodeGen2: " << TimeCodeGen2.getTotalTime().getWallTime()
         << "\n";
  TimeCodeGen2.clear();

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

