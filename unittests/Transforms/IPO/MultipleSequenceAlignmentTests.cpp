#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/TensorTable.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "gtest/gtest.h"
#include <algorithm>
#include <cstddef>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "msa-tests"

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
    LLVM_DEBUG(for (auto &Entry : Alignment) { Entry.dump(); });
    ASSERT_EQ(Alignment.size(), 5);
    ASSERT_TRUE(Alignment[0].match());
    ASSERT_TRUE(Alignment[1].match());

    ASSERT_FALSE(Alignment[2].match());
    ASSERT_EQ(Alignment[2].getValues()[0], nullptr);
    ASSERT_TRUE(isa<StoreInst>(Alignment[2].getValues()[1]));

    ASSERT_FALSE(Alignment[3].match());
    ASSERT_TRUE(isa<CallInst>(Alignment[3].getValues()[0]));
    ASSERT_EQ(Alignment[3].getValues()[1], nullptr);

    ASSERT_TRUE(Alignment[4].match());
  });
}

TEST_F(MSAFunctionMergerAlignmentTest, Three) {
  LLVMContext Ctx;
  SMDiagnostic Error;
  auto M = parseAssemblyString(R"(
declare void @extern_func_1()
declare void @extern_func_2()

define internal i64 @Afunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 4, i32* %P
  call void @extern_func_1()
  store i32 6, i32* %Q
  store i32 7, i32* %R
  store i32 8, i32* %S
  ret i64 0
}

define internal i64 @Bfunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 4, i32* %P
  call void @extern_func_2()
  store i32 6, i32* %Q
  store i32 7, i32* %R
  store i32 8, i32* %S
  ret i64 42
}

define internal i64 @Cfunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 2, i32* %P
  call void @extern_func_2()
  call void @extern_func_2()
  store i32 6, i32* %Q
  store i32 7, i32* %R
  store i32 8, i32* %S
  ret i64 0
}
  )",
                               Error, Ctx);

  ASSERT_TRUE(M);
  withAlignment(*M, {"Afunc", "Bfunc", "Cfunc"}, [&](auto Alignment) {
    LLVM_DEBUG(for (auto &Entry : Alignment) { Entry.dump(); });
    // Expected alignment:
    // [o] 0. entryBB
    // [o] 1. store 4, %P
    // [x] 2. null,           null,           @extern_func_2
    // [x] 3. null,           null,           @extern_func_2
    // [x] 4. null,           @extern_func_2, null
    // [x] 5. @extern_func_1, null,           null
    // [o] 6. store 6, %Q
    // [o] 7. store 7, %R
    // [o] 8. store 8, %S
    // [o] 9. ret
    // TODO: ideally, 3 and 4 can be merged

    struct Expected {
      bool isBB = false;
      int opcodes[3];
    };
    // clang-format off
    std::vector<Expected> ExpectedItems = {
        Expected{.isBB = true},
        Expected{.opcodes = {Instruction::Store, Instruction::Store, Instruction::Store}},
        Expected{.opcodes = {0,                  0,                  Instruction::Call }},
        Expected{.opcodes = {0,                  0,                  Instruction::Call }},
        Expected{.opcodes = {0,                  Instruction::Call,  0                 }},
        Expected{.opcodes = {Instruction::Call,  0,                  0                 }},
        Expected{.opcodes = {Instruction::Store, Instruction::Store, Instruction::Store}},
        Expected{.opcodes = {Instruction::Store, Instruction::Store, Instruction::Store}},
        Expected{.opcodes = {Instruction::Store, Instruction::Store, Instruction::Store}},
        Expected{.opcodes = {Instruction::Ret,   Instruction::Ret,   Instruction::Ret  }}
    };
    // clang-format on

    ASSERT_EQ(Alignment.size(), ExpectedItems.size());

    for (size_t i = 0; i < ExpectedItems.size(); ++i) {
      auto &E = ExpectedItems[i];
      auto &A = Alignment[i];
      for (size_t FuncId = 0; FuncId < 3; ++FuncId) {
        SCOPED_TRACE("i=" + std::to_string(i) +
                     " FuncId=" + std::to_string(FuncId));
        auto *V = A.getValues()[FuncId];
        if (E.isBB) {
          ASSERT_TRUE(isa<BasicBlock>(V));
        } else {
          if (E.opcodes[FuncId] == 0) {
            ASSERT_EQ(V, nullptr);
          } else {
            ASSERT_NE(V, nullptr);
            ASSERT_TRUE(isa<Instruction>(V));
            auto *I = dyn_cast<Instruction>(V);
            ASSERT_EQ(I->getOpcode(), E.opcodes[FuncId]);
          }
        }
      }
    }
  });
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  llvm::cl::ParseCommandLineOptions(argc, argv);

  return RUN_ALL_TESTS();
}
