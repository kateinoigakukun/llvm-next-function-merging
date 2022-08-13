#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "gtest/gtest.h"
#include <algorithm>
#include <cstddef>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "msa-tests"

class MSAFunctionMergerAlignmentTest : public ::testing::Test {
protected:
  void withAlignment(
      Module &M, const std::vector<std::string> &FuncNames,
      function_ref<void(ArrayRef<MSAAlignmentEntry>, ArrayRef<Function *>)>
          Test) {
    ASSERT_GT(M.getFunctionList().size(), 0);

    FunctionMerger PairMerger(&M);
    std::vector<Function *> Functions;
    for (auto &FuncName : FuncNames) {
      Functions.push_back(M.getFunction(FuncName));
    }
    OptimizationRemarkEmitter ORE(Functions[0]);
    FunctionAnalysisManager FAM;
    MSAFunctionMerger Merger(Functions, PairMerger, ORE, FAM);
    std::vector<MSAAlignmentEntry> Alignment;
    Merger.align(Alignment);
    std::reverse(Alignment.begin(), Alignment.end());
    Test(Alignment, Functions);
  }

  void checkCompatibility(Module &M,
                          const std::vector<std::string> &FuncNames) {
    withAlignment(M, FuncNames, [&](auto Alignment, auto Funcs) {
      AlignedSequence<Value *> LegacySeq;
      SmallVector<Value *, 8> F1Vec;
      SmallVector<Value *, 8> F2Vec;

      FunctionMerger PairMerger(&M);
      PairMerger.linearize(Funcs[0], F1Vec);
      PairMerger.linearize(Funcs[1], F2Vec);

      NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(ScoringSystem(-1, 2),
                                                     FunctionMerger::match);
      LegacySeq = SA.getAlignment(F1Vec, F2Vec);

      if (Alignment.size() != LegacySeq.size()) {
        llvm::errs() << "Alignment size: " << Alignment.size()
                     << " LegacySeq size: " << LegacySeq.size() << "\n";
        for (auto &Entry : Alignment) {
          Entry.dump();
        }
        for (auto &Entry : LegacySeq) {
          Entry.dump();
        }
      }
      ASSERT_EQ(Alignment.size(), LegacySeq.size());
      auto actualIt = Alignment.begin();
      auto legacyIt = LegacySeq.begin();

      for (; actualIt != Alignment.end() && legacyIt != LegacySeq.end();
           ++actualIt, ++legacyIt) {
        auto actual = *actualIt;
        auto expected = *legacyIt;

        std::string actualStr;
        llvm::raw_string_ostream actualOS(actualStr);
        std::string expectedStr;
        llvm::raw_string_ostream expectedOS(expectedStr);
        actual.print(actualOS);
        expected.print(expectedOS);
        SCOPED_TRACE("actual=" + actualStr + " expected=" + expectedStr);

        ASSERT_EQ(actual.match(), expected.match());
        ASSERT_EQ(actual.getValues()[0], expected.get(0));
        ASSERT_EQ(actual.getValues()[1], expected.get(1));
      }
    });
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
  withAlignment(*M, {"Afunc", "Bfunc"}, [&](auto Alignment, auto) {
    LLVM_DEBUG(for (auto &Entry : Alignment) { Entry.dump(); });
    ASSERT_EQ(Alignment.size(), 5);
    ASSERT_TRUE(Alignment[0].match());
    ASSERT_TRUE(Alignment[1].match());

    ASSERT_FALSE(Alignment[2].match());
    ASSERT_TRUE(isa<CallInst>(Alignment[2].getValues()[0]));
    ASSERT_EQ(Alignment[2].getValues()[1], nullptr);

    ASSERT_FALSE(Alignment[3].match());
    ASSERT_EQ(Alignment[3].getValues()[0], nullptr);
    ASSERT_TRUE(isa<StoreInst>(Alignment[3].getValues()[1]));

    ASSERT_TRUE(Alignment[4].match());
  });
}

TEST_F(MSAFunctionMergerAlignmentTest, Regression1) {
  LLVMContext Ctx;
  SMDiagnostic Error;
  auto M = parseAssemblyString(R"(
; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

; Function Attrs: noinline optnone
define i32 @susan_edges(i8* %0, i8* %1) #1 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i8, align 1
  %11 = alloca i8*, align 8
  br label %12

12:                                               ; preds = %21
  ret i32 undef
}

declare double @sqrt()

; Function Attrs: noinline optnone
define i32 @susan_edges_small() #1 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8*, align 8
  call void @llvm.memset.p0i8.i64(i8* undef, i8 0, i64 undef, i1 false)
  store i32 730, i32* undef, align 4
  br label %4

4:                                               ; preds = %10
  ret i32 undef
}
  )",
                               Error, Ctx);

  ASSERT_TRUE(M);
  checkCompatibility(*M, {"susan_edges", "susan_edges_small"});
}

TEST_F(MSAFunctionMergerAlignmentTest, Regression2) {
  LLVMContext Ctx;
  SMDiagnostic Error;
  auto M = parseAssemblyString(R"(
define hidden i32 @get_interlaced_row() {
  switch i32 undef, label %2 [
    i32 0, label %1
  ]

1:
  ret i32 undef

2:
  ret i32 undef
}

define hidden i32 @get_8bit_row.267() {
  %1 = load i32*, i32** undef, align 8
  ret i32 undef
}
  )",
                               Error, Ctx);

  ASSERT_TRUE(M);
  checkCompatibility(*M, {"get_interlaced_row", "get_8bit_row.267"});
}

/* XFAIL: 2 merge is better than 3 merge now unfortunately.
TEST_F(MSAFunctionMergerAlignmentTest, BasicThree) {
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
  withAlignment(*M, {"Afunc", "Bfunc", "Cfunc"}, [&](auto Alignment, auto) {
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
*/

TEST_F(MSAFunctionMergerAlignmentTest, ParameterLayout) {
  LLVMContext Ctx;
  SMDiagnostic Error;
  auto M = parseAssemblyString(R"(
define void @Afunc(i32 %x, i32* %P, i32* %Q, i32* %R, i32* %S) {
  ret void
}

define void @Bfunc(i32 %x, i32* %P, i32* %Q, i32* %R, i32* %S) {
  ret void
}

define void @Cfunc(i32 %x, i32* %P, i32* %Q, i32* %R, i32* %S) {
  ret void
}
  )",
                               Error, Ctx);

  ASSERT_TRUE(M);
  withAlignment(*M, {"Afunc", "Bfunc", "Cfunc"},
                [&](auto Alignment, ArrayRef<Function *> Functions) {
                  LLVM_DEBUG(for (auto &Entry : Alignment) { Entry.dump(); });
                  OptimizationRemarkEmitter ORE(Functions[0]);
                  MSAGenFunction Generator(
                      M.get(), Alignment, Functions,
                      IntegerType::getInt32Ty(M->getContext()), ORE);
                  std::vector<std::pair<Type *, AttributeSet>> Args;
                  ValueMap<Argument *, unsigned int> ArgToMergedIndex;
                  Generator.layoutParameters(Args, ArgToMergedIndex);

                  std::vector<std::set<Value *>> MergedIndexToArgs(Args.size());
                  for (auto P : ArgToMergedIndex) {
                    MergedIndexToArgs[P.second].insert(P.first);
                  }

                  ASSERT_EQ(Args.size(), 6);
                  // Start from 1 because 0 is the discriminator
                  for (size_t i = 1; i < Args.size(); ++i) {
                    SCOPED_TRACE("i=" + std::to_string(i));
                    auto &srcArgs = MergedIndexToArgs[i];
                    ASSERT_EQ(srcArgs.size(), 3);
                  }
                });
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  llvm::cl::ParseCommandLineOptions(argc, argv);

  return RUN_ALL_TESTS();
}
