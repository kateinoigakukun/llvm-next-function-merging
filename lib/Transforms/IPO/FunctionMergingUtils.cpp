#include "FunctionMergingUtils.h"
#include <llvm/IR/IRBuilder.h>

using namespace llvm;
using namespace llvm::fmutils;

void SwitchChainer::chainBlocks(BasicBlock *SrcBB, BasicBlock *TargetBB,
                                FuncId FuncId) {
  if (ChainBySrcBB.find(SrcBB) == ChainBySrcBB.end()) {
    ChainBySrcBB[SrcBB] = SwitchChain();
  }
  ChainBySrcBB[SrcBB].push_back(std::make_pair(FuncId, TargetBB));
};

void SwitchChainer::finalizeChain(BasicBlock *SrcBB, SwitchChain &Chain) {
  assert(!Chain.empty() && "Chain should have at least one dest!");
  assert(SrcBB->getTerminator() == nullptr &&
         "SrcBB should have no terminator yet!");

  bool singleTarget =
      std::all_of(Chain.begin(), Chain.end(),
                  [&](const std::pair<FuncId, BasicBlock *> &Pair) {
                    auto *TargetBB = Pair.second;
                    return Chain[0].second == TargetBB;
                  });

  IRBuilder<> Builder(SrcBB);
  if (singleTarget) {
    Builder.CreateBr(Chain[0].second);
    return;
  }

  // fast-path for simple conditional branch
  auto optimizeSimpleCondBr = [&]() {
    if (Chain.size() != 2) {
      return false;
    }
    // switch %discriminator, [
    //  i32 0 label %targetBB0,
    //  i32 1 label %targetBB1
    // ]
    // => br %discriminator, label %targetBB1, label %targetBB0
    BasicBlock *TrueBB;
    BasicBlock *FalseBB;
    if (Chain[0].first == 0 && Chain[1].first != 0) {
      TrueBB = Chain[1].second;
      FalseBB = Chain[0].second;
    } else if (Chain[0].first != 0 && Chain[1].first != 1) {
      TrueBB = Chain[0].second;
      FalseBB = Chain[1].second;
    } else {
      return false;
    }
    Builder.CreateCondBr(Discriminator, TrueBB, FalseBB);
    return true;
  };

  if (optimizeSimpleCondBr()) {
    return;
  }

  SwitchInst *Switch = Builder.CreateSwitch(Discriminator, getBlackholeBB());

  for (auto &FuncIdAndBB : Chain) {
    auto *TargetBB = FuncIdAndBB.second;
    auto *Var = ConstantInt::get(
        dyn_cast<IntegerType>(Discriminator->getType()), FuncIdAndBB.first);
    Switch->addCase(Var, TargetBB);
  }
}

void SwitchChainer::finalize() {
  for (auto &P : ChainBySrcBB) {
    finalizeChain(P.first, P.second);
  }
}

static bool hasLocalValueInMetadata(Metadata *MD) {
  if (auto *LMD = dyn_cast<LocalAsMetadata>(MD)) {
    auto *V = LMD->getValue();
    if (auto *MDV = dyn_cast<MetadataAsValue>(V)) {
      return hasLocalValueInMetadata(MDV->getMetadata());
    }
    return true;
  } else {
    return false;
  }
}

/// Return true if the value can be updated after merging operands.
/// Otherwise, the value is a constant or a global value.
bool InstructionCloner::isLocalValue(const Value *V) {
  if (isa<Constant>(V)) {
    return false;
  }
  // TODO(katei): Should we merge metadata as well?
  if (auto *MDV = dyn_cast<MetadataAsValue>(V)) {
    // if metadata holds an inner value, clear it.
    if (!hasLocalValueInMetadata(MDV->getMetadata())) {
      return false;
    }
  }
  return true;
}

Instruction *InstructionCloner::clone(IRBuilder<> &Builder,
                                      const Instruction *I) {
  Instruction *NewI = nullptr;
  if (I->getOpcode() == Instruction::Ret) {
    Type *RetTy = Builder.getCurrentFunctionReturnType();
    if (RetTy->isVoidTy()) {
      NewI = Builder.CreateRetVoid();
    } else {
      NewI = Builder.CreateRet(UndefValue::get(RetTy));
    }
  } else {
    NewI = I->clone();
    Builder.Insert(NewI);
    for (unsigned i = 0; i < NewI->getNumOperands(); i++) {
      auto Op = I->getOperand(i);
      if (isLocalValue(Op)) {
        NewI->setOperand(i, nullptr);
      }
    }
  }

  NewI->copyMetadata(*I);

  NewI->setName(I->getName());
  return NewI;
}

void SetPartitions::groupCombinationsRecursive(
    const IndicesTy &Items, const PartitionTy &Partition,
    const PartitionSetTy &PartitionSet, size_t I, bool Pick, size_t Depth) {

  PartitionTy NewPartition = Partition;

  if (Pick) {
    NewPartition.insert(Items[I]);
    if (NewPartition.size() == this->PartitionSize) {
      PartitionSetTy NewPartitionSet = PartitionSet;
      NewPartitionSet.insert(NewPartition);

      if (NewPartitionSet.size() == this->PartitionsSetSize) {
        bool New = this->SeenPartitionSet.insert(NewPartitionSet).second;
        if (New) {
          this->Callback(NewPartitionSet);
        }
        return;
      }
      IndicesTy NewItems;
      for (size_t Idx : Items) {
        if (NewPartition.find(Idx) == NewPartition.end()) {
          NewItems.push_back(Idx);
        }
      }

      if (NewItems.size() < this->PartitionSize) {
        return;
      }
      groupCombinationsRecursive(NewItems, PartitionTy(), NewPartitionSet, 0,
                                 true, Depth + 1);
      groupCombinationsRecursive(NewItems, PartitionTy(), NewPartitionSet, 0,
                                 false, Depth + 1);
      return;
    }
  }

  if (I + 1 >= Items.size()) {
    return;
  }

  groupCombinationsRecursive(Items, NewPartition, PartitionSet, I + 1, true,
                             Depth + 1);
  groupCombinationsRecursive(Items, NewPartition, PartitionSet, I + 1, false,
                             Depth + 1);
}

void SetPartitions::groupCombinationsN(const IndicesTy &Items, size_t N) {
  this->PartitionSize = N;
  this->PartitionsSetSize = SourceSize / N;
  groupCombinationsRecursive(Items, PartitionTy(), PartitionSetTy(), 0, true,
                             0);
  groupCombinationsRecursive(Items, PartitionTy(), PartitionSetTy(), 0, false,
                             0);
}

void SetPartitions::iterateOverPartitionsImpl() {
  IndicesTy Items;
  for (size_t i = 0; i < SourceSize; i++) {
    Items.push_back(i);
  }

  for (size_t n = 2; n <= SourceSize; n++) {
    groupCombinationsN(Items, n);
  }
}