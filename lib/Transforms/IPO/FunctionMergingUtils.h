#ifndef LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H
#define LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H

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
public:
  static BasicBlock *merge(ArrayRef<Value *> NewOperands,
                           ArrayRef<Instruction *> Instructions,
                           Value *Discriminator, Function *MergedFunc,
                           DenseMap<BasicBlock *, bool> &IsMergedBB,
                           std::function<BasicBlock *()> getBlackholeBB);
};

inline BasicBlock *
LabelOperandMerger::merge(ArrayRef<Value *> NewOperands,
                          ArrayRef<Instruction *> Instructions,
                          Value *Discriminator, Function *MergedFunc,
                          DenseMap<BasicBlock *, bool> &IsMergedBB,
                          std::function<BasicBlock *()> getBlackholeBB) {
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

} // namespace fmutils
} // namespace llvm
#endif
