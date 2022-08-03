#ifndef LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H
#define LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H

#include <cstddef>
#include <functional>
#include <llvm/IR/BasicBlock.h>
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
} // namespace fmutils
} // namespace llvm
#endif
