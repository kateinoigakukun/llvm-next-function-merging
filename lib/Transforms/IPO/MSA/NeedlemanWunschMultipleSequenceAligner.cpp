#include "llvm/ADT/TensorTable.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"

#define DEBUG_TYPE "msa-nw"

using namespace llvm;

static OptimizationRemarkMissed
createMissedRemark(StringRef RemarkName, StringRef Reason,
                   ArrayRef<Function *> Functions) {
  auto remark = OptimizationRemarkMissed(DEBUG_TYPE, RemarkName, Functions[0]);
  if (!Reason.empty())
    remark << ore::NV("Reason", Reason);
  for (auto *F : Functions) {
    remark << ore::NV("Function", F);
  }
  return remark;
}

static OptimizationRemarkMissed createMissedRemark(StringRef RemarkName,
                                                   StringRef Reason,
                                                   ArrayRef<BasicBlock *> BBs) {
  auto remark =
      OptimizationRemarkMissed(DEBUG_TYPE, RemarkName, BBs[0]->getParent());
  if (!Reason.empty())
    remark << ore::NV("Reason", Reason);
  for (auto *B : BBs) {
    remark << ore::NV("Function", B->getParent());
    remark << ore::NV("BasicBlock", B);
  }
  return remark;
}

class NeedlemanWunschMultipleSequenceAlignerImpl {
  ScoringSystem &Scoring;
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

public:
  NeedlemanWunschMultipleSequenceAlignerImpl(
      ScoringSystem &Scoring, std::vector<size_t> Shape,
      std::vector<SmallVector<Value *, 16>> &InstrVecList,
      const FunctionMergingOptions &Options)
      : Scoring(Scoring), Shape(Shape), ShapeSize(Shape.size()),
        Options(Options), InstrVecList(InstrVecList),
        BestTransTable(Shape, {}) {

    initScoreTable();
  }

  void align(std::vector<MSAAlignmentEntry> &Alignment, bool &isProfitable);
};

void NeedlemanWunschMultipleSequenceAlignerImpl::initScoreTable() {

  {
    // Initialize {0,0,...,0}
    std::vector<size_t> Point(Shape.size(), 0);
    TransitionOffset transOffset(Shape.size(), 0);
    BestTransTable[Point] = TransitionEntry(transOffset, false, 0);
  }

  for (size_t dim = 0; dim < Shape.size(); dim++) {
    std::vector<size_t> Point(Shape.size(), 0);
    for (size_t i = 1; i < Shape[dim]; i++) {
      Point[dim] = i;
      auto score = Scoring.getGapPenalty() * i;
      TransitionOffset transOffset(Shape.size(), 0);
      transOffset.set(dim);
      BestTransTable[Point] = TransitionEntry(transOffset, false, score);
    }
  }
}

namespace MSAlignerUtilites {
static int32_t addScore(int32_t Score, int32_t addend) {
  if (addend > 0 && Score >= fmutils::OptionalScore::max() - addend)
    return fmutils::OptionalScore::max();
  if (addend < 0 && Score <= fmutils::OptionalScore::min() - addend)
    return fmutils::OptionalScore::min();
  return Score + addend;
};

inline SmallVector<size_t, 4>
minusOffsetFromPoint(const TransitionOffset &Offset,
                     const SmallVector<size_t, 4> &Point, size_t ShapeSize) {
  SmallVector<size_t, 4> Result(ShapeSize);
  for (size_t i = 0; i < ShapeSize; i++) {
    Result[i] = Point[i] - Offset[i];
  }
  return Result;
};
}; // namespace MSAlignerUtilites

void NeedlemanWunschMultipleSequenceAlignerImpl::computeBestTransition(
    const TensorTableCursor &Cursor, const SmallVector<size_t, 4> &Point) {

  // Build a virtual tensor table for transition scores.
  // e.g. If the shape is (2, 2, 2), the virtual tensor table is:
  //
  //       +-----------+-----------+
  //      / (0, 0, 1) / (0, 1, 1) /|
  //     /           /           / |
  //    +-----------+-----------+  |
  //   /           /           /|  +
  //  /           /           / | /|
  // +-----------+-----------+  |/ |
  // |           |           |  +  |
  // | (0, 0, 0) | (0, 1, 0) | /|  +
  // |           |           |/ | /
  // +-----------+-----------+  |/
  // |           |           |  +
  // | (1, 0, 0) | (1, 1, 0) | /
  // |           |           |/
  // +-----------+-----------+
  // The current visiting point in the virtual tensor table.
  assert(ShapeSize < 32 && "Shape size is too large");
  TransitionOffset TransOffset(ShapeSize, true);
  TransitionOffset DiagnoalOffset(ShapeSize, true);

  // Visit all possible transitions except for the current point itself.
  TransitionEntry BestTransition;

  do {
    if (!BestTransTable.contains(Point, TransOffset, true))
      continue;

    int32_t similarity = 0;
    bool IsMatched = false;
    // If diagonal transition, add the match score.
    if (TransOffset == DiagnoalOffset) {
      auto result = matchInstructions(MSAlignerUtilites::minusOffsetFromPoint(
          TransOffset, Point, ShapeSize));
      IsMatched = result.Match;
      similarity = IsMatched ? (result.IdenticalTypes ? Scoring.Match
                                                      : Scoring.Match / 2)
                             : Scoring.Mismatch;
    } else {
      similarity = Scoring.getGapPenalty() * TransOffset.count();
    }
    assert(BestTransTable.get(Point, TransOffset, true).Score &&
           "non-visited point");
    auto fromScore = *BestTransTable.get(Point, TransOffset, true).Score;
    int32_t newScore = MSAlignerUtilites::addScore(fromScore, similarity);
    auto bestScore = BestTransition.Score;
    if (!bestScore.hasValue() || newScore > *bestScore) {
      BestTransition = TransitionEntry(TransOffset, IsMatched, newScore);
    }
  } while (TransOffset.decrement());

  BestTransTable.set(Cursor, BestTransition);
}

void NeedlemanWunschMultipleSequenceAlignerImpl::buildScoreTable() {
  // Start visiting from (0, 0, ..., 0)
  auto Cursor = TensorTableCursor::zero();
  SmallVector<size_t, 4> Point(Shape.size(), 0);

  while (advancePointInShape(Point)) {
    Cursor.advance();
    computeBestTransition(Cursor, Point);
  };
}

void NeedlemanWunschMultipleSequenceAlignerImpl::buildAlignment(
    std::vector<llvm::MSAAlignmentEntry> &Alignment) {
  TimeTraceScope TimeScope("BuildAlignment");
  size_t MaxDim = BestTransTable.getShape().size();
  std::vector<size_t> Cursor(MaxDim, 0);

  auto BuildAlignmentEntry = [&](const TransitionEntry &Entry,
                                 std::vector<size_t> Cursor) {
    std::vector<Value *> Instrs;
    const TransitionOffset &TransOffset = Entry.Offset;
    for (int FuncIdx = 0; FuncIdx < Shape.size(); FuncIdx++) {
      size_t diff = TransOffset[FuncIdx];
      if (diff == 1) {
        Value *I = InstrVecList[FuncIdx][Cursor[FuncIdx] - 1];
        Instrs.push_back(I);
      } else {
        assert(diff == 0);
        Instrs.push_back(nullptr);
      }
    }
    return MSAAlignmentEntry(Instrs, Entry.Match);
  };

  // Set the first point to the end edge of the table.
  for (size_t dim = 0; dim < MaxDim; dim++) {
    Cursor[dim] = BestTransTable.getShape()[dim] - 1;
  }

  while (true) {
    LLVM_DEBUG(
        dbgs() << "BackCursor: "; for (size_t dim = 0; dim < MaxDim; dim++) {
          dbgs() << Cursor[dim] << " ";
        } dbgs() << "\n");
    // If the current point is the start edge of the table, we are done.
    if (std::all_of(Cursor.begin(), Cursor.end(),
                    [](size_t v) { return v == 0; })) {
      break;
    }

    auto &Entry = BestTransTable[Cursor];
    LLVM_DEBUG(dbgs() << "Entry: " << Entry << "\n");
    auto &Offset = Entry.Offset;
    auto alignEntry = BuildAlignmentEntry(Entry, Cursor);
    Alignment.emplace_back(alignEntry);
    for (size_t dim = 0; dim < MaxDim; dim++) {
      assert(Cursor[dim] >= Offset[dim] && "cursor is moving to outside the "
                                           "table!");
      Cursor[dim] -= Offset[dim];
    }
  }
}

void NeedlemanWunschMultipleSequenceAlignerImpl::align(
    std::vector<MSAAlignmentEntry> &Alignment, bool &isProfitable) {
  /* ===== Needleman–Wunsch algorithm ======= */

  buildScoreTable();
  LLVM_DEBUG(llvm::dbgs() << "BestTransTable:\n";
             BestTransTable.print(llvm::dbgs()));

  buildAlignment(Alignment);

  return;
}

bool NeedlemanWunschMultipleSequenceAligner::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {
  std::vector<SmallVector<Value *, 16>> InstrVecList(Functions.size());
  std::vector<size_t> Shape;
  size_t ShapeSize = 1;

  {
    TimeTraceScope TimeScope("Linearize");
    for (size_t i = 0; i < Functions.size(); i++) {
      auto &F = *Functions[i];
      PairMerger.linearize(&F, InstrVecList[i]);
      Shape.push_back(InstrVecList[i].size() + 1);
      ShapeSize *= Shape[i];
    }
  }

  // FIXME(katei): The current algorithm is not optimal and consumes too much
  // memory. We should use more efficient algorithm and unlock this limitation.
  if (ShapeSize > ShapeSizeLimit) {
    if (ORE) {
      ORE->emit([&] {
        auto remark =
            createMissedRemark("Alignment", "Too large table size", Functions);
        for (size_t i = 0; i < Shape.size(); i++) {
          remark << ore::NV("Shape", Shape[i]);
        }
        return remark;
      });
    }
    return false;
  }

  NeedlemanWunschMultipleSequenceAlignerImpl Aligner(Scoring, Shape,
                                                     InstrVecList, Options);
  Aligner.align(Alignment, isProfitable);
  return true;
}

bool NeedlemanWunschMultipleSequenceAligner::alignBasicBlocks(
    ArrayRef<BasicBlock *> BBs, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) const {
  std::vector<SmallVector<Value *, 16>> InstrVecList(BBs.size());
  std::vector<size_t> Shape;
  size_t ShapeSize = 1;

  {
    TimeTraceScope TimeScope("Linearize");
    for (size_t i = 0; i < BBs.size(); i++) {
      auto *B = BBs[i];
      auto &InstrVec = InstrVecList[i];
      linearizeBasicBlock(B, [&InstrVec](Value *I) { InstrVec.push_back(I); });
      Shape.push_back(InstrVecList[i].size() + 1);
      ShapeSize *= Shape[i];
    }
  }

  if (ShapeSize > ShapeSizeLimit) {
    if (ORE) {
      ORE->emit([&] {
        auto remark =
            createMissedRemark("Alignment", "Too large table size", BBs);
        for (size_t i = 0; i < Shape.size(); i++) {
          remark << ore::NV("Shape", Shape[i]);
        }
        return remark;
      });
    }
    return false;
  }

  NeedlemanWunschMultipleSequenceAlignerImpl Aligner(Scoring, Shape,
                                                     InstrVecList, Options);
  Aligner.align(Alignment, isProfitable);
  return true;
}
