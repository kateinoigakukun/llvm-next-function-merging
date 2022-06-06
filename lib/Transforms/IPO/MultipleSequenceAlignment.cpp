#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <numeric>
#include <tuple>
#include <utility>
#include <vector>

#define DEBUG_TYPE "multiple-func-merging"

namespace llvm {

struct MSAFunctionMergeResult {};

/// \brief This pass merges multiple functions into a single function by
/// multiple sequence alignment algorithm.
class MSAFunctionMerger {
  FunctionMerger PairMerger;
  ScoringSystem Scoring;
  Module *M;

public:
  MSAFunctionMerger(Module *M)
      : PairMerger(M), Scoring(/*Gap*/ 1, /*Match*/ 0, /*Mismatch*/ 1), M(M) {
  }

  FunctionMerger &getPairMerger() { return PairMerger; }

  void align(const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
             std::vector<MSAAlignmentEntry> &Alignment);
  MSAFunctionMergeResult merge(ArrayRef<Function *> Functions);
  void merge(ArrayRef<Function *> Functions,
             const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
             const std::vector<MSAAlignmentEntry> &Alignment);
};

class MSAGenFunction {
  Module *M;
  const std::vector<MSAAlignmentEntry> &Alignment;
  const ArrayRef<Function *> &Functions;

  IRBuilder<> Builder;

public:
  MSAGenFunction(Module *M, const std::vector<MSAAlignmentEntry> &Alignment,
                 const ArrayRef<Function *> &Functions)
      : M(M), Alignment(Alignment), Functions(Functions),
        Builder(M->getContext()){};

  void layoutParameters(std::vector<std::pair<Type *, AttributeSet>> &Args,
                        ValueMap<Argument *, unsigned> &ArgToMergedIndex);

  void emit(const FunctionMergingOptions &Options = {});
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
      assert(Point[dim] < Shape[dim] && "Point out of bounds");
      size_t Term = 1;
      for (size_t i = 0; i < dim; i++) {
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

  void set(const std::vector<size_t> &Point, std::vector<size_t> Offset,
           bool NegativeOffset, T NewValue) {
    Data[getIndex(Point, Offset, NegativeOffset)] = NewValue;
  }

  bool contains(const std::vector<size_t> &Point, std::vector<size_t> Offset) const {
    assert(Point.size() == Shape.size() && "Point and shape have different "
                                            "dimensions");
    for (size_t i = 0; i < Shape.size(); i++) {
      if (Point[i] + Offset[i] >= Shape[i]) {
        return false;
      }
    }
    return true;
  }

  const std::vector<size_t> &getShape() const { return Shape; }

  bool advance(std::vector<size_t> &Point) const {
    return advancePointInShape(Point, Shape);
  }
};

using TransitionOffset = std::vector<size_t>;
using TransitionEntry = std::pair<TransitionOffset, /*Match*/ bool>;

static void initScoreTable(TensorTable<int32_t> &ScoreTable,
                           TensorTable<TransitionEntry> &BestTransTable,
                           ScoringSystem &Scoring) {
  auto &Shape = ScoreTable.getShape();
  for (size_t dim = 0; dim < Shape.size(); dim++) {
    std::vector<size_t> Point(Shape.size(), 0);
    for (size_t i = 0; i < Shape[dim]; i++) {
      Point[dim] = i;
      ScoreTable[Point] = Scoring.getGapPenalty() * i;
      TransitionOffset transOffset(Shape.size(), 0);
      transOffset[dim] = 1;
      BestTransTable[Point] = std::make_pair(transOffset, false);
    }
  }
}

static void computeBestTransition(
    TensorTable<int32_t> &ScoreTable,
    TensorTable<TransitionEntry> &BestTransTable,
    const std::vector<size_t> &Point, ScoringSystem &Scoring,
    const std::function<bool(std::vector<size_t> Point)> Match) {

  // Build a virtual tensor table for transition scores.
  // e.g. If the shape is (3, 3), the virtual tensor table is:
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
  const std::vector<int32_t> TransScore{Scoring.getMatchProfit(),
                                        Scoring.getGapPenalty()};
  const std::vector<size_t> TransTableShape(ScoreTable.getShape().size(),
                                            TransScore.size());
  // The current visiting point in the virtual tensor table.
  std::vector<size_t> TransOffset(ScoreTable.getShape().size(), 0);

  // Visit all possible transitions except for the current point itself.
  while (advancePointInShape(TransOffset, TransTableShape)) {
    if (!ScoreTable.contains(Point, TransOffset))
      continue;

    LLVM_DEBUG(dbgs() << "TransOffset: "; for (auto v : TransOffset) { dbgs() << v << " "; } dbgs() << "\n");
    int32_t similarity =
        std::accumulate(TransOffset.begin(), TransOffset.end(), 0,
                        [&TransScore](int32_t Acc, size_t Val) {
                          return Acc + TransScore[Val];
                        });
    bool IsMatched = false;
    // If diagonal transition, add the match score.
    if (std::all_of(TransOffset.begin(), TransOffset.end(),
                    [](size_t v) { return v == 1; })) {
      IsMatched = Match(Point);
      similarity = IsMatched ? Scoring.getMatchProfit()
                                : Scoring.getMismatchPenalty();
    }
    int32_t fromCost = ScoreTable[Point];
    assert(fromCost != INT32_MAX && "non-visited point");
    int32_t cost = fromCost + similarity;
    int32_t minCost = std::min(ScoreTable.get(Point, TransOffset, false), cost);
    if (minCost == cost) {
      ScoreTable.set(Point, TransOffset, false, minCost);
      BestTransTable.set(Point, TransOffset, false, std::make_pair(TransOffset, IsMatched));
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
    LLVM_DEBUG(dbgs() << "BackCursor: "; for (auto v : Cursor) { dbgs() << v << " "; } dbgs() << "\n");
    // If the current point is the start edge of the table, we are done.
    if (std::all_of(Cursor.begin(), Cursor.end(),
                    [](size_t v) { return v == 0; })) {
      break;
    }

    auto &Entry = BestTransTable[Cursor];
    auto &Offset = Entry.first;
    assert(!Offset.empty() && "not transitioned yet!?");
    Alignment.emplace_back(
        buildAlignmentEntry(Entry, Cursor, InstrVecRefList));
    for (size_t dim = 0; dim < MaxDim; dim++) {
      assert(Cursor[dim] >= Offset[dim] && "cursor is moving to outside the "
                                           "table!");
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
    auto &F = *Functions[i];
    PairMerger.linearize(&F, InstrVecList[i]);
    InstrVecRefList.push_back(&InstrVecList[i]);
  }

  std::vector<MSAAlignmentEntry> Alignment;
  align(InstrVecRefList, Alignment);

  merge(Functions, InstrVecRefList, Alignment);

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
  TensorTable<int32_t> ScoreTable(Shape, INT32_MAX);
  TensorTable<TransitionEntry> BestTransTable(Shape, {});
  initScoreTable(ScoreTable, BestTransTable, Scoring);
  LLVM_DEBUG(dbgs() << "Shape: "; for (auto v : Shape) { dbgs() << v << " "; } dbgs() << "\n");

  std::vector<size_t> Cursor(Shape.size(), 0);
  do {
    LLVM_DEBUG(dbgs() << "Cursor: "; for (auto v : Cursor) { dbgs() << v << " "; } dbgs() << "\n");
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
  LLVM_DEBUG(dbgs() << "Cursor: "; for (auto v : Cursor) { dbgs() << v << " "; } dbgs() << "\n");

  buildAlignment(BestTransTable, InstrVecRefList, Alignment);

  return;
}

bool MSAAlignmentEntry::match() const {
  return IsMatched;
}

void MSAFunctionMerger::merge(
    ArrayRef<Function *> Functions,
    const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
    const std::vector<MSAAlignmentEntry> &Alignment) {

  MSAGenFunction Generator(M, Alignment, Functions);
  Generator.emit();
}

namespace {

struct MSAOptions : public FunctionMergingOptions {
  size_t LSHRows = 2;
  size_t LSHBands = 100;

  MSAOptions() : FunctionMergingOptions() {}
};

}

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI);

/// Check whether \p F is eligible to be a function merging candidate.
static bool isEligibleToBeMergeCandidate(Function &F) {
  return !F.isDeclaration() && !F.hasAvailableExternallyLinkage();
}

PreservedAnalyses MultipleFunctionMergingPass::run(Module &M,
                                                   ModuleAnalysisManager &MAM) {

  FunctionAnalysisManager &FAM = MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

  MSAFunctionMerger FM(&M);
  auto Options = MSAOptions();

  std::unique_ptr<Matcher<Function *>> MatchFinder = createMatcherLSH(
      FM.getPairMerger(), Options, Options.LSHRows, Options.LSHBands);

  size_t count = 0;
  for (auto &F : M) {
    if (!isEligibleToBeMergeCandidate(F)) continue;
    MatchFinder->add_candidate(&F, EstimateFunctionSize(&F, &FAM.getResult<TargetIRAnalysis>(F)));
    count++;
  }

  while (MatchFinder->size() > 0) {
    Function *F1 = MatchFinder->next_candidate();
    auto &Rank = MatchFinder->get_matches(F1);
    MatchFinder->remove_candidate(F1);

    SmallVector<Function *, 16> Functions{F1};
    for (auto &Match : Rank) {
      Functions.push_back(Match.candidate);
    }
    if (Functions.size() < 2) continue;
    FM.merge(Functions);
  }

  return PreservedAnalyses::none();
}

/// Layout the merged function parameters while minimizing the length.
void MSAGenFunction::layoutParameters(
    std::vector<std::pair<Type *, AttributeSet>> &Args,
    ValueMap<Argument *, unsigned> &ArgToMergedIndex) {
  assert(Functions.size() <= (1 << 8) && "Too many functions!");
  assert(Functions.size() > 0 && "No functions to merge!");
  Args.emplace_back(IntegerType::get(M->getContext(), 8), AttributeSet());

  auto FindReusableArg = [&](Argument *NewArg, AttributeSet NewAttr,
                             const std::set<unsigned> &reusedArgs) -> Optional<int> {
    // TODO(katei): Find the best argument to reuse based on the uses to minimize selections.
    // Ex:
    // ```
    // void @f(i32 %a, i8 %b, i32 %c) {
    //   %x = add i32 %a, 1
    // }
    // void @g(i32 %d) {
    //   %x = add i32 %d, 1
    // }
    // ```
    //
    // In the above example, %d can be reused with both %c and %a,
    // but %a is better to avoid additonal select.

    for (size_t i = 0; i < Args.size(); i++) {
      Type *ty;
      AttributeSet attr;
      std::tie(ty, attr) = Args[i];

      if(ty != NewArg->getType())
        continue;
      if (attr != NewAttr)
        continue;
      // If the argument is already reused, we can't reuse it again for the function.
      if (reusedArgs.find(i) != reusedArgs.end())
        continue;

      return i;
    }
    return None;
  };

  auto MergeArgs = [&](Function *F) {
    auto attrList = F->getAttributes();
    std::set<unsigned> reusedArgIndices;

    for (auto &arg : F->args()) {
      auto argAttr = attrList.getParamAttributes(arg.getArgNo());
      if (auto found = FindReusableArg(&arg, argAttr, reusedArgIndices)) {
        ArgToMergedIndex[&arg] = *found;
        auto inserted = reusedArgIndices.insert(*found).second;
        assert(inserted && "Argument already reused!");
      } else {
        Args.emplace_back(arg.getType(), argAttr);
        ArgToMergedIndex[&arg] = Args.size() - 1;
      }
    }
    return true;
  };

  for (auto &F : Functions) {
    MergeArgs(F);
  }
}

void MSAGenFunction::emit(const FunctionMergingOptions &Options) {
  std::vector<std::pair<Type *, AttributeSet>> Args;
  ValueMap<Argument *, unsigned> ArgToMergedIndex;

  layoutParameters(Args, ArgToMergedIndex);
}
