#include "../../../lib/Transforms/IPO/FunctionMergingUtils.h"
#include "gtest/gtest.h"

using namespace llvm::fmutils;

TEST(OptionalScoreTest, Basic) {
  OptionalScore S1(1);
  ASSERT_TRUE(S1.hasValue());
  ASSERT_EQ(*S1, 1);

  OptionalScore S2 = OptionalScore::min();
  ASSERT_TRUE(S2.hasValue());
  ASSERT_EQ(*S2, OptionalScore::min());

  OptionalScore S3 = OptionalScore::None();
  ASSERT_FALSE(S3.hasValue());
}
