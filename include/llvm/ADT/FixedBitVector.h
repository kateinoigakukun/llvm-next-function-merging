#ifndef LLVM_ADT_FIXEDBITVECTOR_H
#define LLVM_ADT_FIXEDBITVECTOR_H

#include "llvm/Support/raw_ostream.h"
#include <cassert>
#include <cstddef>
#include <cstdint>

namespace llvm {

struct FixedBitVector {
  uint32_t Value;

  FixedBitVector(size_t Size, bool Value)
      : Value(Value ? (1 << Size) - 1 : 0) {}

  FixedBitVector(uint32_t Value) : Value(Value) {}

  static FixedBitVector fill(size_t Size) {
    assert(Size <= 32 && "Size is too large");
    return {static_cast<uint32_t>((1 << Size) - 1)};
  }

  static FixedBitVector zero(size_t Size) {
    assert(Size <= 32 && "Size is too large");
    return {0};
  }

  bool decrement() { return Value-- != 0; }

  bool none() const { return Value == 0; }
  size_t count() const { return __builtin_popcount(Value); }

  bool operator==(const FixedBitVector &Other) const {
    return Value == Other.Value;
  }

  bool operator[](size_t Idx) const { return (Value >> Idx) & 1; }

  void set(size_t Idx) { Value |= (1 << Idx); }

  void reset(size_t Idx) { Value &= ~(1 << Idx); }

  void set(size_t Idx, bool E) {
    if (E)
      set(Idx);
    else
      reset(Idx);
  }

  void print(raw_ostream &OS) const { OS << Value; }
};

} // namespace llvm

#endif
