#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "FunctionMergingUtils.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils/PromoteMemToReg.h"

#include <unordered_map>
#include <set>

#define DEBUG_TYPE "salssa-codegen"

using namespace llvm;

static cl::opt<bool>
    EnableOperandReordering("func-merging-operand-reorder", cl::init(false),
                            cl::Hidden, cl::desc("Enable operand reordering"));

static cl::opt<unsigned>
    MaxNumSelection("func-merging-max-selects", cl::init(500), cl::Hidden,
                    cl::desc("Maximum number of allowed operand selection"));

static cl::opt<bool> EnableSALSSACoalescing(
    "func-merging-coalescing", cl::init(true), cl::Hidden,
    cl::desc("Enable phi-node coalescing during SSA reconstruction"));

static cl::opt<bool> DisablePostOpt(
    "func-merging-disable-post-opt", cl::init(false), cl::Hidden,
    cl::desc("Disable post-optimization of the merged function"));

Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
                          Type *IntPtrTy,
                          const FunctionMergingOptions &Options = {});

////////////////////////////////////   SALSSA   ////////////////////////////////

static void postProcessFunction(Function &F) {
  legacy::FunctionPassManager FPM(F.getParent());

  // FPM.add(createPromoteMemoryToRegisterPass());
  if (!DisablePostOpt) {
    FPM.add(createCFGSimplificationPass());
    FPM.add(createInstSimplifyLegacyPass());
  }
  // FPM.add(createInstructionCombiningPass(2));
  // FPM.add(createCFGSimplificationPass());

  FPM.doInitialization();
  FPM.run(F);
  FPM.doFinalization();
}

template <typename BlockListType>
static void CodeGen(BlockListType &Blocks1, BlockListType &Blocks2,
                    BasicBlock *EntryBB1, BasicBlock *EntryBB2,
                    Function *MergedFunc, Value *FuncId, BasicBlock *PreBB,
                    AlignedSequence<Value *> &AlignedSeq,
                    ValueToValueMapTy &VMap,
                    std::unordered_map<BasicBlock *, BasicBlock *> &BlocksF1,
                    std::unordered_map<BasicBlock *, BasicBlock *> &BlocksF2,
                    DenseMap<BasicBlock *, bool> &IsMergedBB,
                    std::unordered_map<Value *, BasicBlock *> &MaterialNodes) {

  auto CloneInst = [](IRBuilder<> &Builder, Function *MF,
                      Instruction *I) -> Instruction * {
    return fmutils::InstructionCloner::clone(Builder, I);
  };

  for (auto &Entry : AlignedSeq) {
    if (Entry.match()) {

      auto *I1 = dyn_cast<Instruction>(Entry.get(0));
      auto *I2 = dyn_cast<Instruction>(Entry.get(1));

      Twine BBName = [&]() {
        Value *HeadV = Entry.get(0);
        if (auto *BB = dyn_cast<BasicBlock>(HeadV)) {
          return "m.bb." + BB->getName();
        } else if (auto *I = dyn_cast<Instruction>(HeadV)) {
          if (I->isTerminator()) {
            return Twine("m.term.bb");
          } else {
            return Twine("m.inst.bb");
          }
        }
        llvm_unreachable("Unknown value type!");
      }();

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
        IsMergedBB[MergedBB] = true;
      } else {
        assert(isa<BasicBlock>(Entry.get(0)) && isa<BasicBlock>(Entry.get(1)) &&
               "Both nodes must be basic blocks!");
        auto *BB1 = dyn_cast<BasicBlock>(Entry.get(0));
        auto *BB2 = dyn_cast<BasicBlock>(Entry.get(1));

        VMap[BB1] = MergedBB;
        VMap[BB2] = MergedBB;
        BlocksF1[MergedBB] = BB1;
        BlocksF2[MergedBB] = BB2;
        IsMergedBB[MergedBB] = true;

        // IMPORTANT: make sure any use in a blockaddress constant
        // operation is updated correctly
        for (User *U : BB1->users()) {
          if (auto *BA = dyn_cast<BlockAddress>(U)) {
            VMap[BA] = BlockAddress::get(MergedFunc, MergedBB);
          }
        }
        for (User *U : BB2->users()) {
          if (auto *BA = dyn_cast<BlockAddress>(U)) {
            VMap[BA] = BlockAddress::get(MergedFunc, MergedBB);
          }
        }

        IRBuilder<> Builder(MergedBB);
        for (Instruction &I : *BB1) {
          if (isa<PHINode>(&I)) {
            VMap[&I] = Builder.CreatePHI(I.getType(), 0, I.getName());
          }
        }
        for (Instruction &I : *BB2) {
          if (isa<PHINode>(&I)) {
            VMap[&I] = Builder.CreatePHI(I.getType(), 0, I.getName());
          }
        }
      } // end if(instruction)-else
    }
  }

  fmutils::SwitchChainer chainer(FuncId, [&]() { return nullptr; });
  auto ChainBlocks = [&](BasicBlock *SrcBB, BasicBlock *TargetBB,
                         fmutils::FuncId FuncId) {
    chainer.chainBlocks(SrcBB, TargetBB, FuncId);
  };

  auto ProcessEachFunction =
      [&](BlockListType &Blocks,
          std::unordered_map<BasicBlock *, BasicBlock *> &BlocksFX,
          fmutils::FuncId FuncId) {
        for (BasicBlock *BB : Blocks) {
          BasicBlock *LastMergedBB = nullptr;
          BasicBlock *NewBB = nullptr;
          bool HasBeenMerged = MaterialNodes.find(BB) != MaterialNodes.end();
          if (HasBeenMerged) {
            LastMergedBB = MaterialNodes[BB];
          } else {
            SmallString<128> BBName(BB->getParent()->getName());
            BBName.append(".");
            BBName.append(BB->getName());
            NewBB = BasicBlock::Create(MergedFunc->getContext(), BBName,
                                       MergedFunc);
            VMap[BB] = NewBB;
            BlocksFX[NewBB] = BB;

            // IMPORTANT: make sure any use in a blockaddress constant
            // operation is updated correctly
            for (User *U : BB->users()) {
              if (auto *BA = dyn_cast<BlockAddress>(U)) {
                VMap[BA] = BlockAddress::get(MergedFunc, NewBB);
              }
            }

            // errs() << "NewBB: " << NewBB->getName() << "\n";
            IRBuilder<> Builder(NewBB);
            for (Instruction &I : *BB) {
              if (isa<PHINode>(&I)) {
                VMap[&I] = Builder.CreatePHI(I.getType(), 0, I.getName());
              }
            }
          }
          for (Instruction &I : *BB) {
            if (isa<LandingPadInst>(&I))
              continue;
            if (isa<PHINode>(&I))
              continue;

            bool HasBeenMerged = MaterialNodes.find(&I) != MaterialNodes.end();
            if (HasBeenMerged) {
              BasicBlock *NodeBB = MaterialNodes[&I];
              if (LastMergedBB) {
                // errs() << "Chaining last merged " << LastMergedBB->getName()
                // << " with " << NodeBB->getName() << "\n";
                ChainBlocks(LastMergedBB, NodeBB, FuncId);
              } else {
                IRBuilder<> Builder(NewBB);
                Builder.CreateBr(NodeBB);
                // errs() << "Chaining newBB " << NewBB->getName() << " with "
                // << NodeBB->getName() << "\n";
              }
              // end keep track
              LastMergedBB = NodeBB;
            } else {
              if (LastMergedBB) {
                SmallString<128> BBName(BB->getParent()->getName());
                BBName.append(".");
                BBName.append(BB->getName());
                BBName.append(".split");
                NewBB = BasicBlock::Create(MergedFunc->getContext(), BBName,
                                           MergedFunc);
                ChainBlocks(LastMergedBB, NewBB, FuncId);
                BlocksFX[NewBB] = BB;
                // errs() << "Splitting last merged " << LastMergedBB->getName()
                // << " into " << NewBB->getName() << "\n";
              }
              LastMergedBB = nullptr;

              IRBuilder<> Builder(NewBB);
              Instruction *NewI = CloneInst(Builder, MergedFunc, &I);
              VMap[&I] = NewI;
              // errs() << "Cloned into " << NewBB->getName() << " : " <<
              // NewI->getName() << " " << NewI->getOpcodeName() << "\n";
              // I.dump();
            }
          }
        }
      };
  ProcessEachFunction(Blocks1, BlocksF1, 0);
  ProcessEachFunction(Blocks2, BlocksF2, 1);
  chainer.finalize();

  auto *BB1 = dyn_cast<BasicBlock>(VMap[EntryBB1]);
  auto *BB2 = dyn_cast<BasicBlock>(VMap[EntryBB2]);

  BlocksF1[PreBB] = BB1;
  BlocksF2[PreBB] = BB2;

  if (BB1 == BB2) {
    IRBuilder<> Builder(PreBB);
    Builder.CreateBr(BB1);
  } else {
    IRBuilder<> Builder(PreBB);
    Builder.CreateCondBr(FuncId, BB2, BB1);
  }
}

template <class BlockListType>
bool FunctionMerger::SALSSACodeGen<BlockListType>::generate(
    AlignedSequence<Value *> &AlignedSeq, ValueToValueMapTy &VMap,
    const FunctionMergingOptions &Options) {

  bool Debug = false;
  bool Verbose = false;
  LLVM_DEBUG(Debug = true; Verbose = true;);

#ifdef TIME_STEPS_DEBUG
  TimeCodeGen.startTimer();
#endif

  LLVMContext &Context = CodeGenerator<BlockListType>::getContext();
  Function *MergedFunc = CodeGenerator<BlockListType>::getMergedFunction();
  Value *FuncId = CodeGenerator<BlockListType>::getFunctionIdentifier();
  Type *ReturnType = CodeGenerator<BlockListType>::getMergedReturnType();
  bool RequiresUnifiedReturn =
      CodeGenerator<BlockListType>::getRequiresUnifiedReturn();
  BasicBlock *EntryBB1 = CodeGenerator<BlockListType>::getEntryBlock1();
  BasicBlock *EntryBB2 = CodeGenerator<BlockListType>::getEntryBlock2();
  BasicBlock *PreBB = CodeGenerator<BlockListType>::getPreBlock();

  Type *RetType1 = CodeGenerator<BlockListType>::getReturnType1();
  Type *RetType2 = CodeGenerator<BlockListType>::getReturnType2();

  Type *IntPtrTy = CodeGenerator<BlockListType>::getIntPtrType();

  // BlockListType &Blocks1 = CodeGenerator<BlockListType>::getBlocks1();
  // BlockListType &Blocks2 = CodeGenerator<BlockListType>::getBlocks2();
  std::vector<BasicBlock *> &Blocks1 =
      CodeGenerator<BlockListType>::getBlocks1();
  std::vector<BasicBlock *> &Blocks2 =
      CodeGenerator<BlockListType>::getBlocks2();

  std::list<Instruction *> LinearOffendingInsts;
  std::set<Instruction *> OffendingInsts;
  std::map<Instruction *, std::map<Instruction *, unsigned>>
      CoalescingCandidates;

  std::vector<Instruction *> ListSelects;

  std::vector<AllocaInst *> Allocas;

  Value *RetUnifiedAddr = nullptr;
  Value *RetAddr1 = nullptr;
  Value *RetAddr2 = nullptr;

  // maps new basic blocks in the merged function to their original
  // correspondents
  std::unordered_map<BasicBlock *, BasicBlock *> BlocksF1;
  std::unordered_map<BasicBlock *, BasicBlock *> BlocksF2;
  DenseMap<BasicBlock *, bool> IsMergedBB;
  std::unordered_map<Value *, BasicBlock *> MaterialNodes;

  CodeGen(Blocks1, Blocks2, EntryBB1, EntryBB2, MergedFunc, FuncId, PreBB,
          AlignedSeq, VMap, BlocksF1, BlocksF2, IsMergedBB, MaterialNodes);

  if (RequiresUnifiedReturn) {
    IRBuilder<> Builder(PreBB);
    RetUnifiedAddr = Builder.CreateAlloca(ReturnType);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetUnifiedAddr));

    RetAddr1 = Builder.CreateAlloca(RetType1);
    RetAddr2 = Builder.CreateAlloca(RetType2);
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr1));
    CodeGenerator<BlockListType>::insert(dyn_cast<Instruction>(RetAddr2));
  }

  // errs() << "Assigning label operands\n";

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

      auto *NewI = dyn_cast<Instruction>(VMap[I]);

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
            if (Debug)
              errs() << "ERROR: Null value mapped: V2 = "
                        "MapValue(I2->getOperand(i), "
                        "VMap);\n";
            return false;
          }

        } else {
          V2 = UndefValue::get(I1->getOperand(i)->getType());
        }

        assert(V1 != nullptr && "Value should NOT be null!");
        assert(V2 != nullptr && "Value should NOT be null!");

        Value *V = V1; // first assume that V1==V2

        // handling just label operands for now
        if (!isa<BasicBlock>(V))
          continue;

        auto *F1BB = dyn_cast<BasicBlock>(F1V);
        auto *F2BB = dyn_cast<BasicBlock>(F2V);

        if (V1 != V2) {
          auto *BB1 = dyn_cast<BasicBlock>(V1);
          auto *BB2 = dyn_cast<BasicBlock>(V2);

          // auto CacheKey = std::pair<BasicBlock *, BasicBlock *>(BB1, BB2);
          BasicBlock *SelectBB =
              BasicBlock::Create(Context, "bb.select", MergedFunc);
          IRBuilder<> BuilderBB(SelectBB);

          BlocksF1[SelectBB] = I1->getParent();
          BlocksF2[SelectBB] = I2->getParent();

          BuilderBB.CreateCondBr(FuncId, BB2, BB1);
          IsMergedBB[SelectBB] = true;
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
          IsMergedBB[LPadBB] = true; // XXX: is this really merged?

          VMap[F1BB->getLandingPadInst()] = NewLP;
          VMap[F2BB->getLandingPadInst()] = NewLP;

          V = LPadBB;
        }
        NewI->setOperand(i, V);
      }

    } else { // if(entry.match())-else

      auto AssignLabelOperands =
          [&](Instruction *I,
              std::unordered_map<BasicBlock *, BasicBlock *> &BlocksReMap)
          -> bool {
        auto *NewI = dyn_cast<Instruction>(VMap[I]);
        // if (isa<BranchInst>(I))
        //  errs() << "Setting operand in " << NewI->getParent()->getName() << "
        //  : " << NewI->getName() << " " << NewI->getOpcodeName() << "\n";
        for (unsigned i = 0; i < I->getNumOperands(); i++) {
          // handling just label operands for now
          if (!isa<BasicBlock>(I->getOperand(i)))
            continue;
          auto *FXBB = dyn_cast<BasicBlock>(I->getOperand(i));

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
            BlocksReMap[LPadBB] = I->getParent(); //FXBB;

            BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));

            V = LPadBB;
          }

          NewI->setOperand(i, V);
          // if (isa<BranchInst>(NewI))
          //  errs() << "Operand " << i << ": " << V->getName() << "\n";
        }
        return true;
      };

      if (I1 != nullptr && !AssignLabelOperands(I1, BlocksF1)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
        return false;
      }
      if (I2 != nullptr && !AssignLabelOperands(I2, BlocksF2)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
        return false;
      }
    }
  }

  // errs() << "Assigning value operands\n";

  auto MergeValues = [&](Value *V1, Value *V2,
                         Instruction *InsertPt) -> Value * {
    if (V1 == V2)
      return V1;

    if (V1 == ConstantInt::getTrue(Context) && V2 == ConstantInt::getFalse(Context)) {
      IRBuilder<> Builder(InsertPt);
      /// TODO: create a single not(IsFunc1) for each merged function that needs it
      return Builder.CreateNot(FuncId);
    }

    if (V1 == ConstantInt::getFalse(Context) && V2 == ConstantInt::getTrue(Context)) {
      return FuncId;
    }

    auto *IV1 = dyn_cast<Instruction>(V1);
    auto *IV2 = dyn_cast<Instruction>(V2);

    if (IV1 && IV2) {
      // if both IV1 and IV2 are non-merged values
      if (!IsMergedBB[IV1->getParent()] && !IsMergedBB[IV2->getParent()]) {
        CoalescingCandidates[IV1][IV2]++;
        CoalescingCandidates[IV2][IV1]++;
      }
    }

    IRBuilder<> Builder(InsertPt);
    Instruction *Sel =
        (Instruction *)Builder.CreateSelect(FuncId, V2, V1, "switch.select");
    ListSelects.push_back(dyn_cast<Instruction>(Sel));
    return Sel;
  };

  auto AssignOperands = [&](Instruction *I) -> bool {
    auto *NewI = dyn_cast<Instruction>(VMap[I]);
    IRBuilder<> Builder(NewI);

    if (I->getOpcode() == Instruction::Ret && RequiresUnifiedReturn) {
      Value *V = MapValue(I->getOperand(0), VMap);
      if (V == nullptr) {
        return false; // ErrorResponse;
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

        // Value *CastedV = createCastIfNeeded(V,
        // NewI->getOperand(i)->getType(), Builder, IntPtrTy);
        NewI->setOperand(i, V);
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

    if (I1 != nullptr && I2 != nullptr) {

      // Instruction *I1 = dyn_cast<Instruction>(MN->N1->getValue());
      // Instruction *I2 = dyn_cast<Instruction>(MN->N2->getValue());

      Instruction *I = I1;
      if (I1->getOpcode() == Instruction::Ret) {
        I = (I1->getNumOperands() >= I2->getNumOperands()) ? I1 : I2;
      } else {
        assert(I1->getNumOperands() == I2->getNumOperands() &&
               "Num of Operands SHOULD be EQUAL\n");
      }

      auto *NewI = dyn_cast<Instruction>(VMap[I]);

      IRBuilder<> Builder(NewI);

      if (EnableOperandReordering && isa<BinaryOperator>(NewI) &&
          I->isCommutative()) {

        auto *BO1 = dyn_cast<BinaryOperator>(I1);
        auto *BO2 = dyn_cast<BinaryOperator>(I2);
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
        Vs.emplace_back(VL1, VL2);
        Vs.emplace_back(VR1, VR2);

        for (unsigned i = 0; i < Vs.size(); i++) {
          Value *V1 = Vs[i].first;
          Value *V2 = Vs[i].second;

          Value *V = MergeValues(V1, V2, NewI);
          if (V == nullptr) {
            if (Debug) {
              errs() << "Could Not select:\n";
              errs() << "ERROR: Value should NOT be null\n";
            }
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
              if (Debug)
                errs() << "ERROR: Null value mapped: V2 = "
                          "MapValue(I2->getOperand(i), "
                          "VMap);\n";
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
      if (I1 != nullptr && !AssignOperands(I1)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
        return false;
      }
      if (I2 != nullptr && !AssignOperands(I2)) {
        if (Debug)
          errs() << "ERROR: Value should NOT be null\n";
        return false;
      }
    } // end 'if-else' non-isomorphic

  } // end for nodes

  // errs() << "NumSelects: " << ListSelects.size() << "\n";
  if (ListSelects.size() > MaxNumSelection) {
    errs() << "Bailing out: Operand selection threshold\n";
    return false;
  }

  // errs() << "Assigning PHI operands\n";

  auto AssignPHIOperandsInBlock =
      [&](BasicBlock *BB,
          std::unordered_map<BasicBlock *, BasicBlock *> &BlocksReMap) -> bool {
    for (Instruction &I : *BB) {
      if (auto *PHI = dyn_cast<PHINode>(&I)) {
        auto *NewPHI = dyn_cast<PHINode>(VMap[PHI]);

        for (auto It = pred_begin(NewPHI->getParent()),
                  E = pred_end(NewPHI->getParent());
             It != E; It++) {

          BasicBlock *NewPredBB = *It;

          Value *V = nullptr;

          if (BlocksReMap.find(NewPredBB) != BlocksReMap.end()) {
            int Index = PHI->getBasicBlockIndex(BlocksReMap[NewPredBB]);
            if (Index >= 0) {
              V = MapValue(PHI->getIncomingValue(Index), VMap);
            }
          }

          if (V == nullptr)
            V = UndefValue::get(NewPHI->getType());

          // IRBuilder<> Builder(NewPredBB->getTerminator());
          // Value *CastedV = createCastIfNeeded(V, NewPHI->getType(), Builder,
          // IntPtrTy);
          NewPHI->addIncoming(V, NewPredBB);
        }
      }
    }
    return true;
  };

  for (BasicBlock *BB1 : Blocks1) {
    if (!AssignPHIOperandsInBlock(BB1, BlocksF1)) {
      if (Debug)
        errs() << "ERROR: PHI assignment\n";
      return false;
    }
  }
  for (BasicBlock *BB2 : Blocks2) {
    if (!AssignPHIOperandsInBlock(BB2, BlocksF2)) {
      if (Debug)
        errs() << "ERROR: PHI assignment\n";
      return false;
    }
  }

  // errs() << "Collecting offending instructions\n";
  DominatorTree DT(*MergedFunc);

  for (Instruction &I : instructions(MergedFunc)) {
    if (auto *PHI = dyn_cast<PHINode>(&I)) {
      for (unsigned i = 0; i < PHI->getNumIncomingValues(); i++) {
        BasicBlock *BB = PHI->getIncomingBlock(i);
        if (BB == nullptr)
          errs() << "Null incoming block\n";
        Value *V = PHI->getIncomingValue(i);
        if (V == nullptr)
          errs() << "Null incoming value\n";
        if (auto *IV = dyn_cast<Instruction>(V)) {
          if (BB->getTerminator() == nullptr) {
            if (Debug)
              errs() << "ERROR: Null terminator\n";
            return false;
          }
          if (!DT.dominates(IV, BB->getTerminator())) {
            if (OffendingInsts.count(IV) == 0) {
              OffendingInsts.insert(IV);
              LinearOffendingInsts.push_back(IV);
            }
          }
        }
      }
    } else {
      for (unsigned i = 0; i < I.getNumOperands(); i++) {
        if (I.getOperand(i) == nullptr) {
          if (Debug)
            errs() << "ERROR: Null operand\n";
          return false;
        }
        if (auto *IV = dyn_cast<Instruction>(I.getOperand(i))) {
          if (!DT.dominates(IV, &I)) {
            if (OffendingInsts.count(IV) == 0) {
              OffendingInsts.insert(IV);
              LinearOffendingInsts.push_back(IV);
            }
          }
        }
      }
    }
  }

  auto StoreInstIntoAddr = [](Instruction *IV, Value *Addr) {
    IRBuilder<> Builder(IV->getParent());
    if (IV->isTerminator()) {
      BasicBlock *SrcBB = IV->getParent();
      if (auto *II = dyn_cast<InvokeInst>(IV)) {
        BasicBlock *DestBB = II->getNormalDest();

        Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
        // create PHI
        PHINode *PHI = Builder.CreatePHI(IV->getType(), 0, "store2addr");
        for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
             PredIt != PredE; PredIt++) {
          BasicBlock *PredBB = *PredIt;
          if (PredBB == SrcBB) {
            PHI->addIncoming(IV, PredBB);
          } else {
            PHI->addIncoming(UndefValue::get(IV->getType()), PredBB);
          }
        }
        Builder.CreateStore(PHI, Addr);
      } else {
        for (auto SuccIt = succ_begin(SrcBB), SuccE = succ_end(SrcBB);
             SuccIt != SuccE; SuccIt++) {
          BasicBlock *DestBB = *SuccIt;

          Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
          // create PHI
          PHINode *PHI = Builder.CreatePHI(IV->getType(), 0, "store2addr");
          for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
               PredIt != PredE; PredIt++) {
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
        Builder.SetInsertPoint(&*IV->getParent()->getFirstInsertionPt());
        //Builder.SetInsertPoint(IV->getParent()->getTerminator());
      } else
        Builder.SetInsertPoint(InsertPt);

      Builder.CreateStore(IV, Addr);
    }
  };

  auto MemfyInst = [&](std::set<Instruction *> &InstSet) -> AllocaInst * {
    if (InstSet.empty())
      return nullptr;
    IRBuilder<> Builder(&*PreBB->getFirstInsertionPt());
    AllocaInst *Addr =
        Builder.CreateAlloca((*InstSet.begin())->getType(), nullptr, "memfy");

    for (Instruction *I : InstSet) {
      for (auto UIt = I->use_begin(), E = I->use_end(); UIt != E;) {
        Use &UI = *UIt;
        UIt++;

        auto *User = cast<Instruction>(UI.getUser());

        if (auto *PHI = dyn_cast<PHINode>(User)) {
          /// TODO: make sure getOperandNo is getting the correct incoming edge
          auto InsertionPt = PHI->getIncomingBlock(UI.getOperandNo())->getTerminator();
          /// TODO: If the terminator of the incoming block is the producer of
          //        the value we want to store, the load cannot be inserted between
          //        the producer and the user. Something more complex is needed.
          if (InsertionPt == I)
            continue;
          IRBuilder<> Builder(InsertionPt);
          UI.set(Builder.CreateLoad(Addr->getType()->getPointerElementType(), Addr));
        } else {
          IRBuilder<> Builder(User);
          UI.set(Builder.CreateLoad(Addr->getType()->getPointerElementType(), Addr));
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
      if (auto *UI = dyn_cast<Instruction>(U)) {
        BasicBlock *BB1 = UI->getParent();
        BBSet1.insert(BB1);
        UnionBB.insert(BB1);
      }
    }

    unsigned Intersection = 0;
    for (User *U : I2->users()) {
      if (auto *UI = dyn_cast<Instruction>(U)) {
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
        if (OtherI) {
          InstSet.insert(OtherI);
        }
      };

  // errs() << "Finishing code\n";
  if (MergedFunc != nullptr) {
    if (((float)OffendingInsts.size()) / ((float)AlignedSeq.size()) > 4.5) {
      if (Debug)
        errs() << "Bailing out\n";
      return false;
    } 
    //errs() << "Fixing Domination:\n";
    //MergedFunc->dump();
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

    DominatorTree DT(*MergedFunc);
    PromoteMemToReg(Allocas, DT, nullptr);

    if (verifyFunction(*MergedFunc)) {
      if (Verbose)
        errs() << "ERROR: Produced Broken Function!\n";
      return false;
    }
    postProcessFunction(*MergedFunc);
  }
  return MergedFunc != nullptr;
}

template class FunctionMerger::SALSSACodeGen<llvm::SymbolTableList<llvm::BasicBlock>>;
