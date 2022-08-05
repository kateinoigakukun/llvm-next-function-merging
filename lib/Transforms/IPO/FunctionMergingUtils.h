#ifndef LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H
#define LLVM_TRANSFORMS_IPO_FUNCTION_MERGING_UTILS_H

#include "llvm/IR/BasicBlock.h"
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

/// Nullable 31-bit signed integer.
class OptionalScore {
  int32_t Value;
  bool HasValue;
  OptionalScore() : HasValue(false), Value(0) {}

public:
  OptionalScore(int32_t value) : HasValue(true), Value(value * 2) {
    assert(value >= min() && value <= max());
  }
  static OptionalScore None() { return OptionalScore(); }

  bool hasValue() const { return HasValue; }
  operator bool() const { return HasValue; }
  int32_t operator*() const { return Value / 2; }

  static int32_t min() { return INT32_MIN / 2; }
  static int32_t max() { return INT32_MAX / 2; }

  void print(raw_ostream &OS) const {
    if (hasValue()) {
      if (*this == min())
        OS << "min";
      else if (*this == max())
        OS << "max";
      else
        OS << *this;
    } else {
      OS << "None";
    }
  }
};

} // namespace fmutils
} // namespace llvm
#endif
