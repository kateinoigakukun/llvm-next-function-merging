#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SANeedlemanWunsch.h"
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
#include "llvm/Transforms/IPO/FunctionMergingOptions.h"
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
  void withAlignment(Module &M, const std::vector<std::string> &FuncNames,
                     function_ref<void(std::vector<MSAAlignmentEntry<>> &,
                                       ArrayRef<Function *>)>
                         Test,
                     const FunctionMergingOptions &Options = {}) {
    ASSERT_GT(M.getFunctionList().size(), 0);

    FunctionMerger PairMerger(&M);
    std::vector<Function *> Functions;
    for (auto &FuncName : FuncNames) {
      Functions.push_back(M.getFunction(FuncName));
    }
    OptimizationRemarkEmitter ORE(Functions[0]);
    FunctionAnalysisManager FAM;
    MSAFunctionMerger Merger(Functions, PairMerger, ORE, FAM);
    std::vector<MSAAlignmentEntry<>> Alignment;
    bool _isProfitable = true;
    Merger.align(Alignment, _isProfitable, Options);
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

      NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(
          ScoringSystem(-1, 2),
          [&](auto *F1, auto *F2) { return FunctionMerger::match(F1, F2); });
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
    ASSERT_FALSE(Alignment[1].match());
    ASSERT_EQ(Alignment[1].getValues()[0], nullptr);

    ASSERT_TRUE(Alignment[2].match());
    ASSERT_TRUE(isa<StoreInst>(Alignment[2].getValues()[0]));

    ASSERT_FALSE(Alignment[3].match());
    ASSERT_EQ(Alignment[3].getValues()[1], nullptr);
    ASSERT_TRUE(isa<CallInst>(Alignment[3].getValues()[0]));

    ASSERT_TRUE(Alignment[4].match());
  });
}

TEST_F(MSAFunctionMergerAlignmentTest, HyFMBasic) {
  LLVMContext Ctx;
  SMDiagnostic Error;
  auto M = parseAssemblyString(R"(
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%"class.xercesc_2_5::TranscodingException" = type { %"class.xercesc_2_5::XMLException" }
%"class.xercesc_2_5::XMLException" = type { i32 (...)**, i32, i8*, i32, i16*, %"class.xalanc_1_8::XalanNode"* }

@.str.1705 = external hidden unnamed_addr constant [27 x i8], align 1
@_ZTIN11xercesc_2_525XMLPlatformUtilsExceptionE = external constant { i8*, i8*, i8* }, align 8

declare i32 @__gxx_personality_v0(...)

declare i8* @__cxa_allocate_exception(i64) local_unnamed_addr

declare void @__cxa_throw(i8*, i8*, i8*) local_unnamed_addr

declare void @__cxa_free_exception(i8*) local_unnamed_addr

; Function Attrs: noinline optsize uwtable
define i32 @_ZN11xercesc_2_516XMLPlatformUtils10curFilePosEPvPNS_13MemoryManagerE(i8* nocapture %theFile, %"class.xalanc_1_8::XalanNode"* %manager) local_unnamed_addr #0 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = bitcast i8* %theFile to %struct._IO_FILE*
  %call = tail call i64 @ftell(%struct._IO_FILE* %0) #3
  %conv = trunc i64 %call to i32
  %cmp = icmp eq i32 %conv, -1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %exception = tail call i8* @__cxa_allocate_exception(i64 48) #4
  %1 = bitcast i8* %exception to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_525XMLPlatformUtilsExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %1, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1705, i64 0, i64 0), i32 363, i32 40, %"class.xalanc_1_8::XalanNode"* %manager) #3
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %if.then
  tail call void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_525XMLPlatformUtilsExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #5
  unreachable

lpad:                                             ; preds = %if.then
  %2 = landingpad { i8*, i32 }
          cleanup
  tail call void @__cxa_free_exception(i8* %exception) #4
  resume { i8*, i32 } %2

if.end:                                           ; preds = %entry
  ret i32 %conv
}

; Function Attrs: nofree nounwind optsize
declare noundef i64 @ftell(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_525XMLPlatformUtilsExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48), i8*, i32, i32, %"class.xalanc_1_8::XalanNode"*) unnamed_addr #0 align 2

; Function Attrs: noinline optsize uwtable
define i32 @_ZN11xercesc_2_516XMLPlatformUtils14readFileBufferEPvjPhPNS_13MemoryManagerE(i8* nocapture %theFile, i32 %toRead, i8* nocapture %toFill, %"class.xalanc_1_8::XalanNode"* %manager) local_unnamed_addr #0 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %conv = zext i32 %toRead to i64
  %0 = bitcast i8* %theFile to %struct._IO_FILE*
  %call = tail call i64 @fread(i8* %toFill, i64 1, i64 %conv, %struct._IO_FILE* %0) #3
  %call1 = tail call i32 @ferror(%struct._IO_FILE* %0) #6
  %tobool.not = icmp eq i32 %call1, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %exception = tail call i8* @__cxa_allocate_exception(i64 48) #4
  %1 = bitcast i8* %exception to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_525XMLPlatformUtilsExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %1, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1705, i64 0, i64 0), i32 456, i32 37, %"class.xalanc_1_8::XalanNode"* %manager) #3
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %if.then
  tail call void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_525XMLPlatformUtilsExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #5
  unreachable

lpad:                                             ; preds = %if.then
  %2 = landingpad { i8*, i32 }
          cleanup
  tail call void @__cxa_free_exception(i8* %exception) #4
  resume { i8*, i32 } %2

if.end:                                           ; preds = %entry
  %conv2 = trunc i64 %call to i32
  ret i32 %conv2
}

; Function Attrs: nofree nounwind optsize
declare noundef i64 @fread(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #1

; Function Attrs: nofree nounwind optsize readonly
declare noundef i32 @ferror(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_512XMLExceptionD2Ev(%"class.xercesc_2_5::XMLException"* nocapture nonnull align 8 dereferenceable(48)) unnamed_addr #0 align 2

attributes #0 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind optsize readonly "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { optsize }
attributes #4 = { nounwind }
attributes #5 = { noreturn }
attributes #6 = { nounwind optsize }
  )",
                               Error, Ctx);

  ASSERT_TRUE(M);
  FunctionMergingOptions Options;
  Options.EnableHyFMAlignment = true;
  Options.EnableHyFMBlockProfitabilityEstimation = true;

  withAlignment(
      *M,
      {"_ZN11xercesc_2_516XMLPlatformUtils10curFilePosEPvPNS_13MemoryManagerE",
       "_ZN11xercesc_2_516XMLPlatformUtils14readFileBufferEPvjPhPNS_"
       "13MemoryManagerE"},
      [&](auto Alignment, auto) {
        LLVM_DEBUG(for (auto &Entry : Alignment) { Entry.dump(); });
      },
      Options);
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
