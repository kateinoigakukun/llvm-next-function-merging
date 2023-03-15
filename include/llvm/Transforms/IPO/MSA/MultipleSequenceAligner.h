#ifndef LLVM_TRANSFORMS_IPO_MSA_MULTIPLESEQUENCEALIGNER_H
#define LLVM_TRANSFORMS_IPO_MSA_MULTIPLESEQUENCEALIGNER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/FixedBitVector.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#include <vector>

namespace llvm {

namespace fmutils {

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

} // namespace fmutils

using TransitionOffset = FixedBitVector;
struct TransitionEntry {
  TransitionOffset Offset;
  bool Match;
  bool Invalid;
  fmutils::OptionalScore Score;

  TransitionEntry(TransitionOffset Offset, bool Match, uint32_t Score)
      : Offset(Offset), Match(Match), Invalid(false), Score(Score) {}
  TransitionEntry()
      : Offset({}), Match(false), Invalid(true),
        Score(fmutils::OptionalScore::None()) {}

  void print(raw_ostream &OS) const {
    OS << "(";
    OS << "{";
    for (size_t i = 0; i < 32; i++) {
      if (i != 0)
        OS << ", ";
      OS << Offset[i];
    }
    OS << "},";
    if (Match)
      OS << "T";
    else
      OS << "F";
    OS << ")";
  }
  void dump() const { print(llvm::errs()); }
};

class MSAAlignmentEntry {
  std::vector<Value *> Values;
  bool IsMatched;

public:
  MSAAlignmentEntry(std::vector<Value *> Values, bool IsMatched)
      : Values(Values), IsMatched(IsMatched) {}

  bool match() const { return IsMatched; }
  ArrayRef<Value *> getValues() const { return Values; }
  /// Collect all instructions from the values.
  /// Returns true if all values are instructions. Otherwise returns false.
  bool collectInstructions(std::vector<Instruction *> &Instructions) const;
  void verify() const;
  void print(raw_ostream &OS) const;
  void dump() const { print(dbgs()); }
};

inline raw_ostream &operator<<(raw_ostream &OS, const TransitionEntry &Entry) {
  Entry.print(OS);
  return OS;
}

inline raw_ostream &operator<<(raw_ostream &OS,
                               const MSAAlignmentEntry &Entry) {
  Entry.print(OS);
  return OS;
}

class MultipleSequenceAligner {
  virtual void align(std::vector<MSAAlignmentEntry> &Alignment,
                     bool &isProfitable) = 0;
};

} // namespace llvm

#endif
