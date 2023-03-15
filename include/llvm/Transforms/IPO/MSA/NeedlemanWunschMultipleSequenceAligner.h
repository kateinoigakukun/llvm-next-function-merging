#ifndef LLVM_TRANSFORMS_IPO_MSA_NEEDLEMANWUNSCHMULTIPLESEQUENCEALIGNER_H
#define LLVM_TRANSFORMS_IPO_MSA_NEEDLEMANWUNSCHMULTIPLESEQUENCEALIGNER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/IR/Function.h"
#include "llvm/Transforms/IPO/FunctionMergingOptions.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"

namespace llvm {

class NeedlemanWunschMultipleSequenceAligner : public MultipleSequenceAligner {
  FunctionMerger &PairMerger;
  ScoringSystem &Scoring;
  ArrayRef<Function *> Functions;
  size_t ShapeSizeLimit;
  const FunctionMergingOptions &Options;

public:
  bool align(std::vector<MSAAlignmentEntry> &Alignment, bool &isProfitable,
             OptimizationRemarkEmitter *ORE) override;

  NeedlemanWunschMultipleSequenceAligner(
      FunctionMerger &PairMerger, ScoringSystem &Scoring,
      ArrayRef<Function *> Functions, size_t ShapeSizeLimit,
      const FunctionMergingOptions &Options = {})
      : PairMerger(PairMerger), Scoring(Scoring), Functions(Functions),
        ShapeSizeLimit(ShapeSizeLimit), Options(Options){};
};

} // namespace llvm

#endif
