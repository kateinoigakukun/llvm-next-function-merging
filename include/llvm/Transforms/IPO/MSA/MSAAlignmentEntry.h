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
  struct ValuesTy {
    Value *V1;
    Value *V2;
    Value *operator[](size_t Idx) const {
      assert(Idx < 2 && "Index out of range");
      return Idx == 0 ? V1 : V2;
    }

    struct iterator {
      Value *V1;
      Value *V2;
      size_t Idx;
      iterator(Value *V1, Value *V2, size_t Idx) : V1(V1), V2(V2), Idx(Idx) {}
      iterator &operator++() {
        ++Idx;
        return *this;
      }
      bool operator!=(const iterator &Other) const {
        return Idx != Other.Idx;
      }
      Value *operator*() const { return Idx == 0 ? V1 : V2; }
    };

    iterator begin() const { return iterator(V1, V2, 0); }
    iterator end() const { return iterator(V1, V2, 2); }

    bool empty() const { return false; }
    size_t size() const { return 2; }
  };

  static ValuesTy createWithSingleValue(Value *V, size_t Size, size_t FuncId) {
    assert(Size == 2 && "Size must be 2 for Fixed2 type");
    if (FuncId == 0) {
      return ValuesTy{V, nullptr};
    } else if (FuncId == 1) {
      return ValuesTy{nullptr, V};
    } else {
      llvm_unreachable("FuncId must be 0 or 1");
    }
  }

  template <typename ClaimValueFn>
  inline static ValuesTy createWithValues(ClaimValueFn ClaimValue,
                                          size_t Size) {
    return ValuesTy{ClaimValue(0), ClaimValue(1)};
  }
};

template <>
struct MSAAlignmentEntryTypeTraits<MSAAlignmentEntryType::Variable> {
  using ValuesTy = std::vector<Value *>;

  static ValuesTy createWithSingleValue(Value *V, size_t Size, size_t FuncId) {
    std::vector<Value *> Values(Size, nullptr);
    Values[FuncId] = V;
    return Values;
  }

  template <typename ClaimValueFn>
  inline static ValuesTy createWithValues(ClaimValueFn ClaimValue,
                                          size_t Size) {
    std::vector<Value *> Values;
    for (int FuncIdx = 0; FuncIdx < Size; FuncIdx++) {
      Value *V = ClaimValue(FuncIdx);
      Values.push_back(V);
    }
    return Values;
  }
};

template <MSAAlignmentEntryType Type = MSAAlignmentEntryType::Variable>
class MSAAlignmentEntry {
public:
  using Trait = MSAAlignmentEntryTypeTraits<Type>;
  using ValuesTy = typename Trait::ValuesTy;

private:
  ValuesTy Values;
  bool IsMatched;

public:
  MSAAlignmentEntry(ValuesTy Values, bool IsMatched)
      : Values(Values), IsMatched(IsMatched) {}

  MSAAlignmentEntry(Value *V, size_t FuncSize, size_t FuncId)
      : Values(Trait::createWithSingleValue(V, FuncSize, FuncId)),
        IsMatched(false) {}

  template <typename ClaimValueFn>
  static inline MSAAlignmentEntry<Type> create(size_t FuncSize, bool IsMatched,
                                               ClaimValueFn ClaimValue) {
    return MSAAlignmentEntry<Type>(
        Trait::createWithValues(ClaimValue, FuncSize), IsMatched);
  }

  bool match() const { return IsMatched; }
  inline const ValuesTy &getValues() const { return Values; }

  // NOTE: This function is only used for code sharing with F3M.
  Value *get(size_t FuncId) const { return Values[FuncId]; }
  /// Collect all instructions from the values.
  /// Returns true if all values are instructions. Otherwise returns false.
  bool collectInstructions(std::vector<Instruction *> &Instructions) const;
  bool hasInstruction() const;
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
