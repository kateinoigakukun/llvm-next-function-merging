#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/TensorTable.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "gtest/gtest.h"
#include <algorithm>
#include <cstddef>
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

class MSAFunctionMergerAlignmentTest : public ::testing::Test {
protected:
  void withAlignment(Module &M, const std::vector<std::string> &FuncNames,
                     function_ref<void(ArrayRef<MSAAlignmentEntry>)> Test) {
    ASSERT_GT(M.getFunctionList().size(), 0);

    FunctionMerger PairMerger(&M);
    std::vector<Function *> Functions;
    for (auto &FuncName : FuncNames) {
      Functions.push_back(M.getFunction(FuncName));
    }
    MSAFunctionMerger Merger(Functions, PairMerger);
    std::vector<MSAAlignmentEntry> Alignment;
    Merger.align(Alignment);
    std::reverse(Alignment.begin(), Alignment.end());
    Test(Alignment);
  }
};

TEST_F(MSAFunctionMergerAlignmentTest, Basic) {
  LLVMContext Ctx;
  SMDiagnostic Error;
  auto M = parseAssemblyString(R"(
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
  )",
                               Error, Ctx);

  ASSERT_TRUE(M);
  withAlignment(*M, {"Afunc", "Bfunc"}, [&](auto Alignment) {
    ASSERT_EQ(Alignment.size(), 3);
    for (auto &Entry : Alignment) {
      Entry.dump();
    }
    ASSERT_TRUE(Alignment[0].match());
    ASSERT_TRUE(Alignment[1].match());
    ASSERT_FALSE(Alignment[2].match());
    // ASSERT_TRUE(Alignment[3].match());
  });
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  llvm::cl::ParseCommandLineOptions(argc, argv);

  return RUN_ALL_TESTS();
}
