#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/TensorTable.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "gtest/gtest.h"
#include <vector>

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

TEST(MSAFunctionMergerTest, Alignment) {
  LLVMContext Ctx;
  StringRef Text = R"(
declare void @extern_func_1()
define internal void @Afunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  call void @extern_func_1()
  ret void
}

define internal void @Bfunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret void
}
  )";

  std::unique_ptr<Module> M;
  {
    SMDiagnostic Error;
    M = parseAssemblyString(Text, Error, Ctx);
  }
  ASSERT_TRUE(M);
  ASSERT_GT(M->getFunctionList().size(), 0);

  FunctionMerger PairMerger(M.get());
  std::vector<Function *> Functions{M->getFunction("Afunc"),
                                    M->getFunction("Bfunc")};
  MSAFunctionMerger Merger(Functions, PairMerger);

  std::vector<MSAAlignmentEntry> Alignment;
  Merger.align(Alignment);
  ASSERT_EQ(Alignment.size(), 4);
}
