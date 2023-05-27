#ifndef LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H
#define LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H

#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/raw_ostream.h"
#include <cstddef>
#include <functional>
#include <vector>

namespace llvm {
namespace fmutils {

using FuncId = size_t;

class SwitchChainer {
  using SwitchChain = std::vector<std::pair<FuncId, BasicBlock *>>;
  DenseMap<BasicBlock *, SwitchChain> ChainBySrcBB;
  Value *Discriminator;
  std::function<BasicBlock *()> getBlackholeBB;

public:
  SwitchChainer(Value *Discriminator,
                std::function<BasicBlock *()> getBlackholeBB)
      : Discriminator(Discriminator), getBlackholeBB(getBlackholeBB) {}

  void chainBlocks(BasicBlock *SrcBB, BasicBlock *TargetBB, FuncId FuncId);

  void finalize();

private:
  void finalizeChain(BasicBlock *SrcBB, SwitchChain &Chain);
};

class InstructionCloner {
public:
  static bool isLocalValue(const Value *V);
  static Instruction *clone(IRBuilder<> &Builder, const Instruction *I);
};

class LabelOperandMerger {
  class MergedLabelOperand {
  public:
    SmallVector<Value *, 4> Operands;
    BasicBlock *MergedBB;

    MergedLabelOperand(SmallVector<Value *, 4> Operands, BasicBlock *MergedBB)
        : Operands(Operands), MergedBB(MergedBB) {}

    bool hasEqualOperands(const ArrayRef<Value *> &OtherOperands) const {
      if (Operands.size() != OtherOperands.size()) {
        return false;
      }
      for (size_t i = 0; i < Operands.size(); i++) {
        if (Operands[i] != OtherOperands[i]) {
          return false;
        }
      }
      return true;
    }
  };

  SmallVector<MergedLabelOperand, 16> MergedLabelOperands;
public:
  BasicBlock *merge(SmallVector<Value *, 4> NewOperands,
                    ArrayRef<Instruction *> Instructions, Value *Discriminator,
                    Function *MergedFunc,
                    DenseMap<BasicBlock *, bool> &IsMergedBB,
                    std::function<BasicBlock *()> getBlackholeBB);
};

inline BasicBlock *
LabelOperandMerger::merge(SmallVector<Value *, 4> NewOperands,
                          ArrayRef<Instruction *> Instructions,
                          Value *Discriminator, Function *MergedFunc,
                          DenseMap<BasicBlock *, bool> &IsMergedBB,
                          std::function<BasicBlock *()> getBlackholeBB) {
  for (auto &MergedInfo : MergedLabelOperands) {
    if (MergedInfo.hasEqualOperands(NewOperands)) {
      return MergedInfo.MergedBB;
    }
  }
  auto RecordForReuse = [&](BasicBlock *BB) {
    MergedLabelOperands.emplace_back(NewOperands, BB);
  };
  bool areAllOperandsEqual =
      std::all_of(NewOperands.begin(), NewOperands.end(),
                  [&](Value *V) { return V == NewOperands[0]; });

  auto &C = MergedFunc->getContext();
  if (areAllOperandsEqual) {
    return dyn_cast<BasicBlock>(
        NewOperands[0]); // assume that V1 == V2 == ... == Vn
  } else if (NewOperands.size() == 2) {
    assert(Instructions.size() == 2 && "Invalid number of instructions!");
    // if there are only two instructions, we can just use cond_br
    auto *SelectBB = BasicBlock::Create(C, "bb.select.bb", MergedFunc);
    IRBuilder<> Builder(SelectBB);
    Builder.CreateCondBr(Discriminator, dyn_cast<BasicBlock>(NewOperands[1]),
                         dyn_cast<BasicBlock>(NewOperands[0]));
    RecordForReuse(SelectBB);
    return SelectBB;
  } else {
    auto *SelectBB = BasicBlock::Create(C, "bb.select.bb", MergedFunc);
    IRBuilder<> BuilderBB(SelectBB);
    auto *Switch = BuilderBB.CreateSwitch(Discriminator, getBlackholeBB());
    IntegerType *DiscriminatorTy =
        dyn_cast<IntegerType>(Discriminator->getType());

    for (size_t FuncId = 0, e = Instructions.size(); FuncId < e; ++FuncId) {
      auto *Case = ConstantInt::get(DiscriminatorTy, FuncId);
      auto *BB = dyn_cast<BasicBlock>(NewOperands[FuncId]);
      Switch->addCase(Case, BB);
    }
    RecordForReuse(SelectBB);
    return SelectBB;
  }
}

// Decrement bit vector as a unsigned integer
// If Point.size() == 2
// [1, 1] -> [0, 1] -> [1, 0] -> [0, 0] -> STOP
//
// If Point.size() == 3
// [1, 1, 1] -> [0, 1, 1] -> [1, 0, 1] -> [0, 0, 1]
// -> [1, 1, 0] -> [0, 1, 0] -> [1, 0, 0] -> [0, 0, 0] -> STOP
template <typename OffsetVec>
static bool decrementOffset(OffsetVec &Offset, size_t Size) {
  for (int i = Size - 1; i >= 0; i--) {
    if (Offset[i]) {
      Offset.set(i, false);
      return true;
    }
    Offset.set(i, true);
  }
  return false;
};

class SetPartitions {
public:
  using IndicesTy = std::vector<size_t>;
  using PartitionTy = std::set<size_t>;
  using PartitionSetTy = std::set<PartitionTy>;
  using CallbackFuncTy = std::function<void(const PartitionSetTy &)>;

private:
  size_t SourceSize, PartitionsSetSize;
  size_t PartitionSize;
  std::set<PartitionSetTy> SeenPartitionSet;
  CallbackFuncTy Callback;

public:
  SetPartitions(size_t SourceSize, CallbackFuncTy Callback)
      : SourceSize(SourceSize), Callback(Callback){};

  void iterateOverPartitions() { iterateOverPartitionsImpl(); }

private:
  void groupCombinationsRecursive(const IndicesTy &Items,
                                  const PartitionTy &Partition,
                                  const PartitionSetTy &PartitionSet, size_t I,
                                  bool Pick, size_t Depth = 0);
  void groupCombinationsN(const IndicesTy &Items, size_t N);
  void iterateOverPartitionsImpl();
};
} // namespace fmutils
} // namespace llvm
#endif
