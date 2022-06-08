#ifndef LLLVM_ADT_TENSORTABLE_H
#define LLLVM_ADT_TENSORTABLE_H

#include <vector>
#include <assert.h>

namespace llvm {

template <typename T> class TensorTable {
  std::vector<T> Data;
  std::vector<size_t> Shape;

  size_t getIndex(const std::vector<size_t> &Point, std::vector<size_t> Offset,
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

public:
  TensorTable(std::vector<size_t> Shape, T DefaultValue) : Shape(Shape) {
    size_t Size = 1;
    for (size_t i = 0; i < Shape.size(); i++) {
      Size *= Shape[i];
    }
    Data = std::vector<T>(Size, DefaultValue);
  }

  const T &operator[](const std::vector<size_t> &Point) const {
    return get(Point, std::vector<size_t>(Shape.size(), 0), false);
  }

  const T &get(const std::vector<size_t> &Point, std::vector<size_t> Offset,
               bool NegativeOffset) const {
    return Data[getIndex(Point, Offset, NegativeOffset)];
  }

  T &operator[](const std::vector<size_t> &Point) {
    return get(Point, std::vector<size_t>(Shape.size(), 0), false);
  }

  T &get(const std::vector<size_t> &Point, std::vector<size_t> Offset,
         bool NegativeOffset) {
    return Data[getIndex(Point, Offset, NegativeOffset)];
  }

  void set(const std::vector<size_t> &Point, std::vector<size_t> Offset,
           bool NegativeOffset, T NewValue) {
    Data[getIndex(Point, Offset, NegativeOffset)] = NewValue;
  }

  bool contains(const std::vector<size_t> &Point,
                std::vector<size_t> Offset) const {
    assert(Point.size() == Shape.size() && "Point and shape have different "
                                           "dimensions");
    for (size_t i = 0; i < Shape.size(); i++) {
      if (Point[i] + Offset[i] >= Shape[i]) {
        return false;
      }
    }
    return true;
  }

  const std::vector<size_t> &getShape() const { return Shape; }
};

} // namespace llvm

#endif