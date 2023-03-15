#ifndef LLVM_TRANSFORMS_IPO_MSA_NEEDLEMANWUNSCHMULTIPLESEQUENCEALIGNER_H
#define LLVM_TRANSFORMS_IPO_MSA_NEEDLEMANWUNSCHMULTIPLESEQUENCEALIGNER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/TensorTable.h"
#include "llvm/IR/Function.h"
#include "llvm/Transforms/IPO/FunctionMergingOptions.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"

namespace llvm {

class NeedlemanWunschMultipleSequenceAligner : public MultipleSequenceAligner {
  ScoringSystem &Scoring;
  ArrayRef<Function *> Functions;
  const std::vector<size_t> Shape;
  const size_t ShapeSize;
  const FunctionMergingOptions &Options;

  std::vector<SmallVector<Value *, 16>> &InstrVecList;
  TensorTable<TransitionEntry> BestTransTable;

  struct MatchResult {
    bool Match;
    bool IdenticalTypes;
  };

  void initScoreTable();
  void buildScoreTable();
  void buildAlignment(std::vector<llvm::MSAAlignmentEntry> &Alignment);
  void computeBestTransition(const TensorTableCursor &Cursor,
                             const SmallVector<size_t, 4> &Point);
  inline void updateBestScore(const TensorTableCursor &Point,
                              TransitionOffset TransOffset,
                              fmutils::OptionalScore newScore, bool IsMatched) {
    BestTransTable.set(Point,
                       TransitionEntry(TransOffset, IsMatched, newScore));
  }
  void align(std::vector<MSAAlignmentEntry> &Alignment,
             bool &isProfitable) override;

  bool advancePointInShape(SmallVector<size_t, 4> &Point) const {
    for (size_t i = 0; i < ShapeSize; i++) {
      if (Point[i] < Shape[i] - 1) {
        Point[i]++;
        return true;
      }
      Point[i] = 0;
    }
    return false;
  }

  MatchResult matchInstructions(const SmallVector<size_t, 4> &Point) const {
    auto *TheInstr = InstrVecList[0][Point[0]];
    bool IdenticalTypes = true;
    for (size_t i = 1; i < ShapeSize; i++) {
      auto *OtherInstr = InstrVecList[i][Point[i]];
      IdenticalTypes &= TheInstr->getType() == OtherInstr->getType();
      if (!FunctionMerger::match(OtherInstr, TheInstr, Options)) {
        return MatchResult{.Match = false, .IdenticalTypes = IdenticalTypes};
      }
    }
    return MatchResult{.Match = true, .IdenticalTypes = IdenticalTypes};
  }

  NeedlemanWunschMultipleSequenceAligner(
      ScoringSystem &Scoring, ArrayRef<Function *> Functions,
      std::vector<size_t> Shape,
      std::vector<SmallVector<Value *, 16>> &InstrVecList,
      const FunctionMergingOptions &Options)
      : Scoring(Scoring), Functions(Functions), Shape(Shape),
        ShapeSize(Shape.size()), Options(Options), InstrVecList(InstrVecList),
        BestTransTable(Shape, {}) {

    initScoreTable();
  }

public:
  static bool align(FunctionMerger &PairMerger, ScoringSystem &Scoring,
                    ArrayRef<Function *> Functions,
                    std::vector<MSAAlignmentEntry> &Alignment,
                    size_t ShapeSizeLimit,
                    OptimizationRemarkEmitter *ORE = nullptr,
                    const FunctionMergingOptions &Options = {});
};

} // namespace llvm

#endif
