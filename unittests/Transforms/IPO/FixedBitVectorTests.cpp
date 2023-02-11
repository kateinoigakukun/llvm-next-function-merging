#include "../../../lib/Transforms/IPO/FunctionMergingUtils.h"
#include "llvm/ADT/FixedBitVector.h"
#include "gtest/gtest.h"
#include <vector>

using namespace llvm;

TEST(FixedBitVectorTests, Decrement) {
  size_t Size = 2;
  FixedBitVector v1(Size, true);
  FixedBitVector v2(Size, true);
  EXPECT_EQ(v1[0], v2[0]);
  EXPECT_EQ(v1[1], v2[1]);

  bool r1 = v1.decrement();
  bool r2 = fmutils::decrementOffset(v2, 2);
  EXPECT_EQ(r1, r2);
  EXPECT_EQ(v1[0], v2[0]);
  EXPECT_EQ(v1[1], v2[1]);
}
