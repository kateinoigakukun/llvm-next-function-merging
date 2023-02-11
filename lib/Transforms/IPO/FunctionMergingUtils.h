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
  uint32_t Value;

  static const uint32_t HasValueBitMask = 0x00000001;

  OptionalScore() : Value(0) {}

public:
  OptionalScore(int32_t value)
      : Value((static_cast<uint32_t>(value << 1)) | HasValueBitMask) {
    assert(value >= min() && value <= max());
  }
  static OptionalScore None() { return OptionalScore(); }

  bool hasValue() const { return Value & HasValueBitMask; }
  operator bool() const { return hasValue(); }
  int32_t operator*() const { return static_cast<int32_t>(Value) >> 1; }

  static int32_t min() { return INT32_MIN / 2; }
  static int32_t max() { return INT32_MAX / 2; }

  void print(raw_ostream &OS) const {
    if (hasValue()) {
      if (**this == min())
        OS << "min";
      else if (**this == max())
        OS << "max";
      else
        OS << **this;
    } else {
      OS << "None";
    }
  }
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
