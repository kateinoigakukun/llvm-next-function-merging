#ifndef LLVM_TRANSFORMS_IPO_FINGERPRINT_H
#define LLVM_TRANSFORMS_IPO_FINGERPRINT_H

#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include <array>
#include <cstdint>
#include <cstdlib>

namespace llvm {

namespace {

inline inst_range getInstructions(Function *F) { return instructions(F); }
inline iterator_range<BasicBlock::iterator> getInstructions(BasicBlock *BB) {
  return make_range(BB->begin(), BB->end());
}

} // namespace

template <class T> class Fingerprint {
public:
  uint64_t magnitude{0};
  static const size_t MaxOpcode = 68;
  std::array<uint32_t, MaxOpcode> OpcodeFreq;

  Fingerprint() = default;

  Fingerprint(T owner) {
    // memset(OpcodeFreq, 0, sizeof(int) * MaxOpcode);
    for (size_t i = 0; i < MaxOpcode; i++)
      OpcodeFreq[i] = 0;

    for (Instruction &I : getInstructions(owner)) {
      OpcodeFreq[I.getOpcode()]++;
      if (I.isTerminator())
        OpcodeFreq[0] += I.getNumSuccessors();
    }
    for (size_t i = 0; i < MaxOpcode; i++) {
      uint64_t val = OpcodeFreq[i];
      magnitude += val * val;
    }
  }

  uint32_t footprint() const { return sizeof(int) * MaxOpcode; }

  float distance(const Fingerprint &FP2) const {
    int Distance = 0;
    for (size_t i = 0; i < MaxOpcode; i++) {
      int Freq1 = OpcodeFreq[i];
      int Freq2 = FP2.OpcodeFreq[i];
      Distance += std::abs(Freq1 - Freq2);
    }
    return static_cast<float>(Distance);
  }
};

class BlockFingerprint : public Fingerprint<BasicBlock *> {
public:
  BasicBlock *BB{nullptr};
  size_t Size{0};

  BlockFingerprint(BasicBlock *BB) : Fingerprint(BB), BB(BB) {
    for (Instruction &I : *BB) {
      if (!isa<LandingPadInst>(&I) && !isa<PHINode>(&I)) {
        Size++;
      }
    }
  }
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_IPO_FINGERPRINT_H
