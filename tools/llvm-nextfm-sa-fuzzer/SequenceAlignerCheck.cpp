#include "llvm/IR/Value.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Transforms/IPO/FunctionMergingOptions.h"
#include "llvm/Transforms/IPO/LegacySequenceAligner.h"
#include "llvm/Transforms/IPO/MSA/MSAAlignmentEntry.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include <memory>

using namespace llvm;

enum AlignerTy {
  NeedlemanWunsch,
  HyFM,
};

static cl::opt<AlignerTy> AlignerType(
    "aligner", cl::desc("Aligner type"), cl::init(HyFM),
    cl::values(clEnumValN(NeedlemanWunsch, "nw", "Needleman-Wunsch"),
               clEnumValN(HyFM, "hyfm", "HyFM")));

class AlignerFactory {
  static constexpr auto Ty = MSAAlignmentEntryType::Fixed2;

  std::unique_ptr<NeedlemanWunschMultipleSequenceAligner<Ty>> NWAligner;
  FunctionMergingOptions Options;
  size_t ShapeSizeLimit;
  ScoringSystem Scoring;

public:
  AlignerFactory()
      : Scoring(/*Gap*/ -1, /*Match*/ 2,
                /*Mismatch*/ fmutils::OptionalScore::min()) {
    this->Options = FunctionMergingOptions();
    Options.MaximizeParamScore = true;
    Options.IdenticalTypesOnly = true;
    Options.EnableUnifiedReturnType = true;
    Options.EnableHyFMBlockProfitabilityEstimation = true;
    this->ShapeSizeLimit = 24 * 1024 * 1024;
    this->NWAligner =
        std::make_unique<NeedlemanWunschMultipleSequenceAligner<Ty>>(
            Scoring, this->ShapeSizeLimit, Options);
  }

  std::pair<std::unique_ptr<Aligner>, std::unique_ptr<Aligner>>
  makeAligners(AlignerTy AlignerType) {
    switch (AlignerType) {
    case NeedlemanWunsch:
      return std::make_pair(
          std::make_unique<MSAAlignerAdapter>(
              std::make_unique<NeedlemanWunschMultipleSequenceAligner<Ty>>(
                  Scoring, ShapeSizeLimit, Options)),
          std::make_unique<SALSSAAligner>());
    case HyFM:
      return std::make_pair(
          std::make_unique<MSAAlignerAdapter>(
              std::make_unique<HyFMMultipleSequenceAligner<Ty>>(
                  *NWAligner.get(), Options)),
          std::make_unique<HyFMNWAligner>(
              Options.EnableHyFMBlockProfitabilityEstimation));
    }
  }
};

void SequenceAlignerCheck(Module *M) {
  auto &Functions = M->getFunctionList();
  auto F1 = &Functions.front();
  auto F2 = &Functions.back();

  AlignerFactory Factory;
  std::unique_ptr<Aligner> NewAligner, OldAligner;
  std::tie(NewAligner, OldAligner) = Factory.makeAligners(AlignerType);

  bool NewIsProfitable = false;
  auto NewResult = NewAligner->align(F1, F2, NewIsProfitable);

  bool OldIsProfitable = false;
  auto OldResult = OldAligner->align(F1, F2, OldIsProfitable);

  if (NewIsProfitable != OldIsProfitable) {
    llvm::errs() << "NewIsProfitable: " << NewIsProfitable
                 << " OldIsProfitable: " << OldIsProfitable << "\n";
    __builtin_trap();
  }
  if (!NewIsProfitable) {
    // Early exit if both are not profitable because the results won't be used
    // so we don't care the difference between them.
    return;
  }

  AlignedSequence<Value *>::verifyTwoAreSame(NewResult, OldResult);
}
