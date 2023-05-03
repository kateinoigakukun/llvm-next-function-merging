#include "llvm/IR/Value.h"

#include "llvm/Transforms/IPO/LegacySequenceAligner.h"
#include "llvm/Transforms/IPO/MSA/MSAAlignmentEntry.h"

using namespace llvm;

void SequenceAlignerCheck(Module *M) {
  FunctionMergingOptions Options = FunctionMergingOptions()
                                       .maximizeParameterScore(true)
                                       .matchOnlyIdenticalTypes(false)
                                       .enableUnifiedReturnTypes(true);
  Options.EnableHyFMBlockProfitabilityEstimation = true;
  ScoringSystem Scoring(/*Gap*/ -1, /*Match*/ 2,
                        /*Mismatch*/ fmutils::OptionalScore::min());

  constexpr auto Ty = MSAAlignmentEntryType::Fixed2;
  auto NWAligner = std::make_unique<NeedlemanWunschMultipleSequenceAligner<Ty>>(
      Scoring, 24 * 1024 * 1024, Options);

  std::unique_ptr<Aligner> NewAligner = std::make_unique<MSAAlignerAdapter>(
      std::make_unique<HyFMMultipleSequenceAligner<Ty>>(*NWAligner.get(),
                                                        Options));
  std::unique_ptr<Aligner> OldAligner = std::make_unique<HyFMNWAligner>(
      Options.EnableHyFMBlockProfitabilityEstimation);

  auto &Functions = M->getFunctionList();
  auto F1 = &Functions.front();
  auto F2 = &Functions.back();

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
