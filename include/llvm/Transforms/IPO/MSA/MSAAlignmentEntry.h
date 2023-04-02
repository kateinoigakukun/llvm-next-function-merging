#ifndef LLVM_TRANSFORMS_IPO_MSA_MSAALIGNMENTENTRY_H
#define LLVM_TRANSFORMS_IPO_MSA_MSAALIGNMENTENTRY_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include <vector>

namespace llvm {

enum class MSAAlignmentEntryType {
  Fixed2,
  Variable,
};

template <MSAAlignmentEntryType Type> struct MSAAlignmentEntryTypeTraits {};

template <> struct MSAAlignmentEntryTypeTraits<MSAAlignmentEntryType::Fixed2> {
  using ValuesTy = Value *[2];
};

template <>
struct MSAAlignmentEntryTypeTraits<MSAAlignmentEntryType::Variable> {
  using ValuesTy = std::vector<Value *>;
};

template <MSAAlignmentEntryType Type = MSAAlignmentEntryType::Variable>
class MSAAlignmentEntry {
  using Trait = MSAAlignmentEntryTypeTraits<Type>;
  using ValuesTy = typename Trait::ValuesTy;

  ValuesTy Values;
  bool IsMatched;

public:
  MSAAlignmentEntry(ValuesTy Values, bool IsMatched)
      : Values(Values), IsMatched(IsMatched) {}

  MSAAlignmentEntry(Value *V, size_t FuncSize, size_t FuncId)
      : IsMatched(false) {
    std::vector<Value *> Values(FuncSize, nullptr);
    Values[FuncId] = V;
    this->Values = Values;
  }

  bool match() const { return IsMatched; }
  ArrayRef<Value *> getValues() const { return Values; }
  /// Collect all instructions from the values.
  /// Returns true if all values are instructions. Otherwise returns false.
  bool collectInstructions(std::vector<Instruction *> &Instructions) const;
  void verify() const;
  void print(raw_ostream &OS) const;
  void dump() const { print(dbgs()); }
};

inline raw_ostream &operator<<(raw_ostream &OS,
                               const MSAAlignmentEntry<> &Entry) {
  Entry.print(OS);
  return OS;
}

}; // namespace llvm

#endif
