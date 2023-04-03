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
