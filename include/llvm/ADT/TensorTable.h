#ifndef LLLVM_ADT_TENSORTABLE_H
#define LLLVM_ADT_TENSORTABLE_H

#include "llvm/Support/raw_ostream.h"
#include <assert.h>
#include <vector>

namespace llvm {

template <typename T> class TensorTable {
  std::vector<T> Data;
  std::vector<size_t> Shape;

  template <typename OffsetVec>
  size_t getIndex(const std::vector<size_t> &Point, const OffsetVec &Offset,
                  bool NegativeOffset) const {
    size_t Index = 0;
    for (size_t dim = 0; dim < Shape.size(); dim++) {
      assert(Point[dim] < Shape[dim] && "Point out of bounds");
      size_t Term = 1;
      for (size_t i = 0; i < dim; i++) {
        Term *= Shape[i];
      }
      Term *= Point[dim] + (NegativeOffset ? -Offset[dim] : Offset[dim]);
      Index += Term;
    }
    return Index;
  }

  size_t getIndex(const std::vector<size_t> &Point) const {
    size_t Index = 0;
    for (size_t dim = 0; dim < Shape.size(); dim++) {
      assert(Point[dim] < Shape[dim] && "Point out of bounds");
      size_t Term = 1;
      for (size_t i = 0; i < dim; i++) {
        Term *= Shape[i];
      }
      Term *= Point[dim];
      Index += Term;
    }
    return Index;
  }

public:
  TensorTable(std::vector<size_t> Shape, T DefaultValue) : Shape(Shape) {
    size_t Size = 1;
    for (size_t i = 0; i < Shape.size(); i++) {
      Size *= Shape[i];
    }
    Data = std::vector<T>(Size, DefaultValue);
  }

  const T &operator[](const std::vector<size_t> &Point) const {
    return get(Point);
  }

  const T &get(const std::vector<size_t> &Point,
               const std::vector<size_t> &Offset, bool NegativeOffset) const {
    return Data[getIndex(Point, Offset, NegativeOffset)];
  }

  const T &get(const std::vector<size_t> &Point) const {
    return Data[getIndex(Point)];
  }

  T &operator[](const std::vector<size_t> &Point) { return get(Point); }

  template <typename OffsetVec>
  T &get(const std::vector<size_t> &Point, const OffsetVec &Offset,
         bool NegativeOffset) {
    return Data[getIndex(Point, Offset, NegativeOffset)];
  }

  T &get(const std::vector<size_t> &Point) { return Data[getIndex(Point)]; }

  template <typename OffsetVec>
  void set(const std::vector<size_t> &Point, const OffsetVec &Offset,
           bool NegativeOffset, T NewValue) {
    Data[getIndex(Point, Offset, NegativeOffset)] = NewValue;
  }

  void set(const std::vector<size_t> &Point, T NewValue) {
    Data[getIndex(Point)] = NewValue;
  }

  template <typename OffsetVec>
  bool contains(const std::vector<size_t> &Point, const OffsetVec &Offset,
                bool NegativeOffset = false) const {
    assert(Point.size() == Shape.size() && "Point and shape have different "
                                           "dimensions");
    for (size_t i = 0; i < Shape.size(); i++) {
      if (Point[i] + (NegativeOffset ? -Offset[i] : Offset[i]) >= Shape[i]) {
        return false;
      }
    }
    return true;
  }

  const std::vector<size_t> &getShape() const { return Shape; }

  void print(raw_ostream &OS) const {
    if (Shape.size() != 2) {
      OS << "TensorTable is not 2D\n";
      return;
    }
    for (size_t y = 0; y < Shape[1]; y++) {
      for (size_t x = 0; x < Shape[0]; x++) {
        std::vector<size_t> P({x, y});
        OS << x << "," << y << "=";
        this->operator[](P).print(OS);
        OS << " ";
      }
      OS << "\n";
    }
  }
  void dump() const { print(llvm::errs()); }
};

} // namespace llvm

#endif
