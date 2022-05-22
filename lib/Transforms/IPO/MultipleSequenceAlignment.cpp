#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instruction.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <functional>
#include <numeric>
#include <utility>
#include <vector>

namespace llvm {

struct MSAFunctionMergeResult {};

class MSAAlignmentEntry {
  std::vector<Value *> Instrs;
  bool IsMatched;

public:
  MSAAlignmentEntry(std::vector<Value *> Instrs, bool IsMatched) : Instrs(Instrs), IsMatched(IsMatched) {}

  bool match() const;
};

/// \brief This pass merges multiple functions into a single function by
/// multiple sequence alignment algorithm.
class MSAFunctionMerger {
  FunctionMerger PairMerger;
  ScoringSystem Scoring;
  Module *M;

public:
  MSAFunctionMerger(Module *M)
      : PairMerger(M), Scoring(/*Gap*/ -1, /*Match*/ 0, /*Mismatch*/ -1), M(M) {
  }

  void align(const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
             std::vector<MSAAlignmentEntry> &Alignment);
  MSAFunctionMergeResult merge(ArrayRef<Function *> Functions);
  void merge(const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
             const std::vector<MSAAlignmentEntry> &Alignment);
};

}; // namespace llvm

using namespace llvm;

namespace {

static bool advancePointInShape(std::vector<size_t> &Point,
                                const std::vector<size_t> &Shape) {
  for (size_t i = 0; i < Point.size(); i++) {
    if (Point[i] < Shape[i] - 1) {
      Point[i]++;
      return true;
    }
    Point[i] = 0;
  }
  return false;
}

template <typename T> class TensorTable {
  std::vector<T> Data;
  std::vector<size_t> Shape;

  size_t getIndex(const std::vector<size_t> &Point, std::vector<size_t> Offset,
                  bool NegativeOffset) const {
    size_t Index = 0;
    for (size_t dim = 0; dim < Shape.size(); dim++) {
      size_t Term = 1;
      for (size_t i = dim; i < Shape.size() - 1; i++) {
        Term *= Shape[i];
      }
      Term *= Point[dim] + (NegativeOffset ? -Offset[dim] : Offset[dim]);
      Index += Term;
    }
    return Index;
  }

public:
  TensorTable(std::vector<size_t> Shape, T DefaultValue) : Shape(Shape) {
    size_t Size = 1;
    for (size_t i = 0; i < Shape.size(); i++) {
      Size *= Shape[i];
    }
    Data = std::vector<T>(Size, DefaultValue);
  }

  const T &operator[](const std::vector<size_t> &Point) const {
    return get(Point, std::vector<size_t>(Shape.size(), 0), false);
  }

  const T &get(const std::vector<size_t> &Point, std::vector<size_t> Offset,
               bool NegativeOffset) const {
    return Data[getIndex(Point, Offset, NegativeOffset)];
  }

  T &operator[](const std::vector<size_t> &Point) {
    return get(Point, std::vector<size_t>(Shape.size(), 0), false);
  }

  T &get(const std::vector<size_t> &Point, std::vector<size_t> Offset,
         bool NegativeOffset) {
    return Data[getIndex(Point, Offset, NegativeOffset)];
  }

  const std::vector<size_t> &getShape() const { return Shape; }

  bool advance(std::vector<size_t> &Point) const {
    return advancePointInShape(Point, Shape);
  }
};

using TransitionOffset = std::vector<size_t>;
using TransitionEntry = std::pair<TransitionOffset, /*Match*/ bool>;

static void initScoreTable(TensorTable<int32_t> &ScoreTable,
                           ScoringSystem &Scoring) {
  auto &Shape = ScoreTable.getShape();
  for (size_t dim = 0; dim < Shape.size(); dim++) {
    std::vector<size_t> Point(Shape.size(), 0);
    for (size_t i = 0; i < Shape[dim]; i++) {
      Point[dim] = i;
      ScoreTable[Point] = Scoring.getGapPenalty() * i;
    }
  }
}

static void computeBestTransition(
    TensorTable<int32_t> &ScoreTable,
    TensorTable<TransitionEntry> &BestTransTable,
    const std::vector<size_t> &Point, ScoringSystem &Scoring,
    const std::function<bool(std::vector<size_t> Point)> Match) {

  // Build a virtual tensor table for transition scores.
  std::vector<int32_t> TransScore{Scoring.getMatchProfit(),
                                  Scoring.getGapPenalty()};
  std::vector<size_t> TransTableShape(ScoreTable.getShape().size(),
                                      TransScore.size());
  // The current visiting point
  std::vector<size_t> TransOffset(ScoreTable.getShape().size(), 0);

  // Visit all possible transitions except for the current point itself.
  while (advancePointInShape(TransOffset, TransTableShape)) {
    int32_t Similarity =
        std::accumulate(TransOffset.begin(), TransOffset.end(), 0,
                        [&TransScore](int32_t Acc, size_t Val) {
                          return Acc + TransScore[Val];
                        });
    bool IsMatched = false;
    // If diagonal transition, add the match score.
    if (std::all_of(TransOffset.begin(), TransOffset.end(),
                    [](size_t v) { return v == 1; })) {
      IsMatched = Match(Point);
      Similarity = IsMatched ? Scoring.getMatchProfit()
                                : Scoring.getMismatchPenalty();
    }
    int32_t FromScore =
        ScoreTable.get(Point, /*Offset*/ TransOffset, /*NegativeOffset*/ true);
    int32_t Score = FromScore + Similarity;
    int32_t MaxScore = std::max(ScoreTable[Point], Score);
    ScoreTable[Point] = MaxScore;
    if (MaxScore == Score) {
      BestTransTable[Point] = std::make_pair(TransOffset, IsMatched);
    }
  }
}

static MSAAlignmentEntry buildAlignmentEntry(
    const TransitionEntry &Entry, std::vector<size_t> Cursor,
    const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList) {

  std::vector<Value *> Instrs;
  const std::vector<size_t> &TransOffset = Entry.first;
  for (int FuncIdx = 0; FuncIdx < TransOffset.size(); FuncIdx++) {
    size_t diff = TransOffset[FuncIdx];
    if (diff == 1) {
      Value *I = (*InstrVecRefList[FuncIdx])[Cursor[FuncIdx]];
      Instrs.push_back(I);
    } else {
      assert(diff == 0);
      Instrs.push_back(nullptr);
    }
  }
  return MSAAlignmentEntry(Instrs, Entry.second);
}

static void buildAlignment(
    const TensorTable<TransitionEntry> &BestTransTable,
    const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
    std::vector<llvm::MSAAlignmentEntry> &Alignment) {
  size_t MaxDim = BestTransTable.getShape().size();
  std::vector<size_t> Cursor(MaxDim, 0);

  // Set the first point to the end edge of the table.
  for (size_t dim = 0; dim < MaxDim; dim++) {
    Cursor[dim] = BestTransTable.getShape()[dim] - 1;
  }

  while (true) {
    // If the current point is the start edge of the table, we are done.
    if (std::all_of(Cursor.begin(), Cursor.end(),
                    [](size_t v) { return v == 0; })) {
      break;
    }

    auto &Entry = BestTransTable[Cursor];
    auto &Offset = Entry.first;
    assert(!Offset.empty() && "not visited yet!?");
    Alignment.emplace_back(
        buildAlignmentEntry(Entry, Cursor, InstrVecRefList));
    for (size_t dim = 0; dim < MaxDim; dim++) {
      Cursor[dim] -= Offset[dim];
    }
  }
}

}; // namespace

MSAFunctionMergeResult
MSAFunctionMerger::merge(ArrayRef<Function *> Functions) {
  std::vector<SmallVector<Value *, 16>> InstrVecList(Functions.size());
  SmallVector<SmallVectorImpl<Value *> *, 16> InstrVecRefList;

  for (size_t i = 0; i < Functions.size(); i++) {
    PairMerger.linearize(Functions[i], InstrVecList[i]);
    InstrVecRefList.push_back(&InstrVecList[i]);
  }

  std::vector<MSAAlignmentEntry> Alignment;
  align(InstrVecRefList, Alignment);

  merge(InstrVecRefList, Alignment);

  return MSAFunctionMergeResult();
}

void MSAFunctionMerger::align(
    const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
    std::vector<MSAAlignmentEntry> &Alignment) {

  /* ===== Needleman–Wunsch algorithm ======= */
  std::vector<size_t> Shape;
  for (auto *InstrVec : InstrVecRefList) {
    Shape.push_back(InstrVec->size());
  }
  TensorTable<int32_t> ScoreTable(Shape, 0);
  TensorTable<TransitionEntry> BestTransTable(Shape, {});
  initScoreTable(ScoreTable, Scoring);

  std::vector<size_t> Cursor(Shape.size(), 1);
  do {
    computeBestTransition(
        ScoreTable, BestTransTable, Cursor, Scoring,
        [&InstrVecRefList](std::vector<size_t> Point) {
          auto *TheInstr = (*InstrVecRefList[0])[Point[0]];
          for (size_t i = 1; i < InstrVecRefList.size(); i++) {
            auto *OtherInstr = (*InstrVecRefList[i])[Point[i]];
            if (!FunctionMerger::match(OtherInstr, TheInstr)) {
              return false;
            }
          }
          return true;
        });
  } while (ScoreTable.advance(Cursor));

  buildAlignment(BestTransTable, InstrVecRefList, Alignment);

  return;
}

bool MSAAlignmentEntry::match() const {
  return IsMatched;
}

void MSAFunctionMerger::merge(
    const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
    const std::vector<MSAAlignmentEntry> &Alignment) {
  // Create a new function.
  Function *F =
      Function::Create(nullptr, GlobalValue::LinkageTypes::PrivateLinkage);

  for (auto &Entry : Alignment) {
    if (Entry.match()) {

      // auto *I1 = dyn_cast<Instruction>(Entry.get(0));
      // auto *I2 = dyn_cast<Instruction>(Entry.get(1));

      // std::string BBName =
      //     (I1 == nullptr) ? "m.label.bb"
      //                     : (I1->isTerminator() ? "m.term.bb" : "m.inst.bb");

      // BasicBlock *MergedBB =
      //     BasicBlock::Create(F->getContext(), BBName, MergedFunc);

      // MaterialNodes[Entry.get(0)] = MergedBB;
      // MaterialNodes[Entry.get(1)] = MergedBB;

      // if (I1 != nullptr && I2 != nullptr) {
      //   IRBuilder<> Builder(MergedBB);
      //   Instruction *NewI = CloneInst(Builder, MergedFunc, I1);

      //   VMap[I1] = NewI;
      //   VMap[I2] = NewI;
      //   BlocksF1[MergedBB] = I1->getParent();
      //   BlocksF2[MergedBB] = I2->getParent();
      // } else {
      //   assert(isa<BasicBlock>(Entry.get(0)) && isa<BasicBlock>(Entry.get(1))
      //   &&
      //          "Both nodes must be basic blocks!");
      //   auto *BB1 = dyn_cast<BasicBlock>(Entry.get(0));
      //   auto *BB2 = dyn_cast<BasicBlock>(Entry.get(1));

      //   VMap[BB1] = MergedBB;
      //   VMap[BB2] = MergedBB;
      //   BlocksF1[MergedBB] = BB1;
      //   BlocksF2[MergedBB] = BB2;

      //   // IMPORTANT: make sure any use in a blockaddress constant
      //   // operation is updated correctly
      //   for (User *U : BB1->users()) {
      //     if (auto *BA = dyn_cast<BlockAddress>(U)) {
      //       VMap[BA] = BlockAddress::get(MergedFunc, MergedBB);
      //     }
      //   }
      //   for (User *U : BB2->users()) {
      //     if (auto *BA = dyn_cast<BlockAddress>(U)) {
      //       VMap[BA] = BlockAddress::get(MergedFunc, MergedBB);
      //     }
      //   }

      //   IRBuilder<> Builder(MergedBB);
      //   for (Instruction &I : *BB1) {
      //     if (isa<PHINode>(&I)) {
      //       VMap[&I] = Builder.CreatePHI(I.getType(), 0);
      //     }
      //   }
      //   for (Instruction &I : *BB2) {
      //     if (isa<PHINode>(&I)) {
      //       VMap[&I] = Builder.CreatePHI(I.getType(), 0);
      //     }
      //   }
      // } // end if(instruction)-else
    }
  }
}
