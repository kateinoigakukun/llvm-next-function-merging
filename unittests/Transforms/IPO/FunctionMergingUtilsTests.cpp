#include "../../../lib/Transforms/IPO/FunctionMergingUtils.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
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

TEST(SetPartitions, Basic) {
  using PartitionSetTy = SetPartitions::PartitionSetTy;
  llvm::SmallVector<PartitionSetTy, 16> Result;
  const auto Collect = [&](size_t SourceSize) {
    Result.clear();
    SetPartitions S(SourceSize,
                    [&](const auto &Set) { Result.push_back(Set); });
    S.iterateOverPartitions();
  };

  Collect(2);
  ASSERT_EQ(Result.size(), 1);
  ASSERT_EQ(Result[0], PartitionSetTy({{0, 1}}));

  Collect(3);
  ASSERT_EQ(Result.size(), 3);
  ASSERT_EQ(Result[0], PartitionSetTy({{0, 1}}));
  ASSERT_EQ(Result[1], PartitionSetTy({{0, 2}}));
  ASSERT_EQ(Result[2], PartitionSetTy({{0, 1, 2}}));

  Collect(4);
  ASSERT_EQ(Result.size(), 7);
  ASSERT_EQ(Result[0], PartitionSetTy({{0, 1}, {2, 3}}));
  ASSERT_EQ(Result[1], PartitionSetTy({{0, 2}, {1, 3}}));
  ASSERT_EQ(Result[2], PartitionSetTy({{0, 3}, {1, 2}}));
  ASSERT_EQ(Result[3], PartitionSetTy({{0, 1, 2}}));
  ASSERT_EQ(Result[4], PartitionSetTy({{0, 1, 3}}));
  ASSERT_EQ(Result[5], PartitionSetTy({{0, 2, 3}}));
  ASSERT_EQ(Result[6], PartitionSetTy({{0, 1, 2, 3}}));
}