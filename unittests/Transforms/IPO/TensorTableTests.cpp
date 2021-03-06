#include "llvm/ADT/TensorTable.h"
#include "gtest/gtest.h"

using namespace llvm;

TEST(TensorTableTest, DefaultValue) {
  TensorTable<int32_t> t(std::vector<size_t>{2, 2}, 0);
  for (size_t x = 0; x < 2; x++) {
    for (size_t y = 0; y < 2; y++) {
      auto v = t[{x, y}];
      EXPECT_EQ(v, 0);
    }
  }
}

TEST(TensorTableTest, GetSet) {
  TensorTable<int32_t> t(std::vector<size_t>{2, 2}, 0);
  t.set({1, 0}, {0, 0}, false, 42);
  auto v = t.get({1, 0}, {0, 0}, false);
  EXPECT_EQ(v, 42);

  v = t.get({0, 0}, {1, 0}, false);
  EXPECT_EQ(v, 42);
}

TEST(TensorTableTest, Contains) {
  TensorTable<int32_t> t(std::vector<size_t>{2, 2}, 0);
  EXPECT_TRUE(t.contains({0, 0}, {0, 0}));
  EXPECT_FALSE(t.contains({2, 0}, {0, 0}));
}
