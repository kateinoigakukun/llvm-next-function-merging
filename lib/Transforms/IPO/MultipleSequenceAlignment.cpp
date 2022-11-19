#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "FunctionMergingUtils.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/SmallBitVector.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/TensorTable.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include "llvm/Transforms/Utils/PromoteMemToReg.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <numeric>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

#define DEBUG_TYPE "multiple-func-merging"
#define MSA_VERBOSE(X) DEBUG_WITH_TYPE("multiple-func-merging-verbose", X)

using namespace llvm;

static cl::opt<size_t> DefaultShapeSizeLimit(
    "multiple-func-merging-shape-limit", cl::init(10 * 1024 * 1024), cl::Hidden,
    cl::desc("The shape size limit for the multiple function merging"));

static cl::opt<bool> AllowUnprofitableMerge(
    "multiple-func-merging-allow-unprofitable", cl::init(false), cl::Hidden,
    cl::desc("Allow merging functions that are not profitable"));

static cl::list<std::string>
    OnlyFunctions("multiple-func-merging-only", cl::Hidden,
                  cl::desc("Merge only the specified functions"));

static cl::opt<bool> DisablePostOpt(
    "multiple-func-merging-disable-post-opt", cl::init(false), cl::Hidden,
    cl::desc("Disable post-optimization of the merged function"));

namespace {

using TransitionOffset = SmallBitVector;
struct TransitionEntry {
  TransitionOffset Offset;
  bool Match;
  bool Invalid;

  TransitionEntry(TransitionOffset Offset, bool Match)
      : Offset(Offset), Match(Match), Invalid(false) {}
  TransitionEntry() : Offset({}), Match(false), Invalid(true) {}

  void print(raw_ostream &OS) const {
    OS << "(";
    OS << "{";
    for (size_t i = 0; i < Offset.size(); i++) {
      if (i != 0)
        OS << ", ";
      OS << Offset[i];
    }
    OS << "},";
    if (Match)
      OS << "T";
    else
      OS << "F";
    OS << ")";
  }
  void dump() const { print(llvm::errs()); }
};

raw_ostream &operator<<(raw_ostream &OS, const TransitionEntry &Entry) {
  Entry.print(OS);
  return OS;
}

raw_ostream &operator<<(raw_ostream &OS, const MSAAlignmentEntry &Entry) {
  Entry.print(OS);
  return OS;
}

class MSAligner {
  ScoringSystem &Scoring;
  ArrayRef<Function *> Functions;
  std::vector<size_t> Shape;

  std::vector<SmallVector<Value *, 16>> &InstrVecList;
  TensorTable<fmutils::OptionalScore> ScoreTable;
  TensorTable<TransitionEntry> BestTransTable;

  struct MatchResult {
    bool Match;
    bool IdenticalTypes;
  };

  void initScoreTable();
  void buildAlignment(std::vector<llvm::MSAAlignmentEntry> &Alignment);
  void computeBestTransition(
      const std::vector<size_t> &Point,
      const std::function<MatchResult(std::vector<size_t> Point)> Match);
  void align(std::vector<MSAAlignmentEntry> &Alignment);

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

  MSAligner(ScoringSystem &Scoring, ArrayRef<Function *> Functions,
            std::vector<size_t> Shape,
            std::vector<SmallVector<Value *, 16>> &InstrVecList)
      : Scoring(Scoring), Functions(Functions), Shape(Shape),
        InstrVecList(InstrVecList),
        ScoreTable(Shape, fmutils::OptionalScore::None()),
        BestTransTable(Shape, {}) {

    initScoreTable();
  }

public:
  static bool align(FunctionMerger &PairMerger, ScoringSystem &Scoring,
                    ArrayRef<Function *> Functions,
                    std::vector<MSAAlignmentEntry> &Alignment,
                    size_t ShapeSizeLimit = DefaultShapeSizeLimit,
                    OptimizationRemarkEmitter *ORE = nullptr);
};

void MSAligner::initScoreTable() {

  {
    // Initialize {0,0,...,0}
    std::vector<size_t> Point(Shape.size(), 0);
    ScoreTable[Point] = 0;
    TransitionOffset transOffset(Shape.size(), 0);
    BestTransTable[Point] = TransitionEntry(transOffset, false);
  }

  for (size_t dim = 0; dim < Shape.size(); dim++) {
    std::vector<size_t> Point(Shape.size(), 0);
    for (size_t i = 1; i < Shape[dim]; i++) {
      Point[dim] = i;
      ScoreTable[Point] = Scoring.getGapPenalty() * i;
      TransitionOffset transOffset(Shape.size(), 0);
      transOffset[dim] = 1;
      BestTransTable[Point] = TransitionEntry(transOffset, false);
    }
  }
}

void MSAligner::computeBestTransition(
    const std::vector<size_t> &Point,
    const std::function<MatchResult(std::vector<size_t> Point)> Match) {

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
  const std::vector<int32_t> TransScore{0, Scoring.getGapPenalty()};
  const std::vector<size_t> TransTableShape(ScoreTable.getShape().size(),
                                            TransScore.size());
  // The current visiting point in the virtual tensor table.
  TransitionOffset TransOffset(ScoreTable.getShape().size(), 1);

  auto AddScore = [](int32_t Score, int32_t addend) {
    if (addend > 0 && Score >= fmutils::OptionalScore::max() - addend)
      return fmutils::OptionalScore::max();
    if (addend < 0 && Score <= fmutils::OptionalScore::min() - addend)
      return fmutils::OptionalScore::min();
    return Score + addend;
  };

  // If Point.size() == 2
  // [1, 1] -> [1, 0] -> [0, 1] -> [0, 0] -> STOP
  //
  // If Point.size() == 3
  // [1, 1, 1] -> [0, 1, 1] -> [1, 0, 1] -> [0, 0, 1]
  // -> [1, 1, 0] -> [0, 1, 0] -> [1, 0, 0] -> STOP
  auto decrementOffset = [&](SmallBitVector &Point) {
    for (int i = Point.size() - 1; i >= 0; i--) {
      if (Point[i]) {
        Point[i] = false;
        return true;
      }
      Point[i] = true;
    }
    return false;
  };

  auto minusOffsetFromPoint = [&](const TransitionOffset &Offset,
                                  const std::vector<size_t> &Point) {
    std::vector<size_t> Result(Point.size());
    for (size_t i = 0; i < Point.size(); i++) {
      Result[i] = Point[i] - Offset[i];
    }
    return Result;
  };

  // Visit all possible transitions except for the current point itself.
  do {
    if (TransOffset.none())
      break;
    if (!ScoreTable.contains(Point, TransOffset, true))
      continue;

    int32_t similarity = 0;
    for (size_t i = 0; i < TransOffset.size(); i++) {
      similarity = AddScore(similarity, TransScore[TransOffset[i]]);
    }
    bool IsMatched = false;
    // If diagonal transition, add the match score.
    if (TransOffset.all()) {
      auto result = Match(minusOffsetFromPoint(TransOffset, Point));
      IsMatched = result.Match;
      similarity = IsMatched
                       ? (result.IdenticalTypes ? Scoring.getMatchProfit()
                                                : Scoring.getMatchProfit() / 2)
                       : Scoring.getMismatchPenalty();
    }
    assert(ScoreTable.get(Point, TransOffset, true) && "non-visited point");
    auto fromScore = *ScoreTable.get(Point, TransOffset, true);
    int32_t newScore = AddScore(fromScore, similarity);
    auto updateBestScore = [&](int32_t newScore) {
      ScoreTable.set(Point, newScore);
      BestTransTable.set(Point, TransitionEntry(TransOffset, IsMatched));
    };
    if (auto existingScore = ScoreTable[Point]) {
      if (newScore > *existingScore) {
        updateBestScore(newScore);
      }
    } else {
      updateBestScore(newScore);
    }
  } while (decrementOffset(TransOffset));
}

void MSAligner::buildAlignment(
    std::vector<llvm::MSAAlignmentEntry> &Alignment) {
  size_t MaxDim = BestTransTable.getShape().size();
  std::vector<size_t> Cursor(MaxDim, 0);

  auto BuildAlignmentEntry = [&](const TransitionEntry &Entry,
                                 std::vector<size_t> Cursor) {
    std::vector<Value *> Instrs;
    const TransitionOffset &TransOffset = Entry.Offset;
    for (int FuncIdx = 0; FuncIdx < TransOffset.size(); FuncIdx++) {
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
    MSA_VERBOSE(dbgs() << "BackCursor: "; for (auto v : Cursor) { dbgs() << v << " "; } dbgs() << "\n");
    // If the current point is the start edge of the table, we are done.
    if (std::all_of(Cursor.begin(), Cursor.end(),
                    [](size_t v) { return v == 0; })) {
      break;
    }

    auto &Entry = BestTransTable[Cursor];
    MSA_VERBOSE(dbgs() << "Entry: " << Entry << "\n");
    auto &Offset = Entry.Offset;
    assert(!Offset.empty() && "not transitioned yet!?");
    auto alignEntry = BuildAlignmentEntry(Entry, Cursor);
    Alignment.emplace_back(alignEntry);
    for (size_t dim = 0; dim < MaxDim; dim++) {
      assert(Cursor[dim] >= Offset[dim] && "cursor is moving to outside the "
                                           "table!");
      Cursor[dim] -= Offset[dim];
    }
  }
}

void MSAligner::align(std::vector<MSAAlignmentEntry> &Alignment) {
  /* ===== Needleman–Wunsch algorithm ======= */

  // Start visiting from (0, 0, ..., 0)
  std::vector<size_t> Cursor(Shape.size(), 0);
  FunctionMergingOptions Options;
  Options.matchOnlyIdenticalTypes(false);

  while (advancePointInShape(Cursor, ScoreTable.getShape())) {
    computeBestTransition(Cursor, [&](std::vector<size_t> Point) {
      auto *TheInstr = InstrVecList[0][Point[0]];
      bool IdenticalTypes = true;
      for (size_t i = 1; i < InstrVecList.size(); i++) {
        auto *OtherInstr = InstrVecList[i][Point[i]];
        IdenticalTypes &= TheInstr->getType() == OtherInstr->getType();
        if (!FunctionMerger::match(OtherInstr, TheInstr, Options)) {
          return MatchResult{.Match = false, .IdenticalTypes = IdenticalTypes};
        }
      }
      return MatchResult{.Match = true, .IdenticalTypes = IdenticalTypes};
    });
  };
  MSA_VERBOSE(llvm::dbgs() << "ScoreTable:\n"; ScoreTable.print(llvm::dbgs()));
  MSA_VERBOSE(llvm::dbgs() << "BestTransTable:\n";
              BestTransTable.print(llvm::dbgs()));

  buildAlignment(Alignment);

  return;
}

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

static OptimizationRemarkAnalysis
createAnalysisRemark(StringRef RemarkName, ArrayRef<Function *> Functions) {
  auto remark =
      OptimizationRemarkAnalysis(DEBUG_TYPE, RemarkName, Functions[0]);
  for (auto *F : Functions) {
    remark << ore::NV("Function", F);
  }
  return remark;
}

bool MSAligner::align(FunctionMerger &PairMerger, ScoringSystem &Scoring,
                      ArrayRef<Function *> Functions,
                      std::vector<MSAAlignmentEntry> &Alignment,
                      size_t ShapeSizeLimit, OptimizationRemarkEmitter *ORE) {
  std::vector<SmallVector<Value *, 16>> InstrVecList(Functions.size());
  std::vector<size_t> Shape;
  size_t ShapeSize = 1;

  for (size_t i = 0; i < Functions.size(); i++) {
    auto &F = *Functions[i];
    PairMerger.linearize(&F, InstrVecList[i]);
    Shape.push_back(InstrVecList[i].size() + 1);
    ShapeSize *= Shape[i];
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

  MSAligner Aligner(Scoring, Functions, Shape, InstrVecList);
  Aligner.align(Alignment);
  return true;
}

}; // namespace

bool MSAAlignmentEntry::collectInstructions(
    std::vector<Instruction *> &Instructions) const {
  bool allInstructions = true;
  for (auto *V : Values) {
    if (V && isa<Instruction>(V)) {
      Instructions.push_back(cast<Instruction>(V));
    } else {
      allInstructions = false;
      Instructions.push_back(nullptr);
    }
  }
  return allInstructions;
}

void MSAAlignmentEntry::verify() const {
  if (!match() || Values.empty()) {
    return;
  }
  bool isBB = isa<BasicBlock>(Values[0]);
  for (size_t i = 1; i < Values.size(); i++) {
    if (isBB != isa<BasicBlock>(Values[i])) {
      llvm_unreachable(
          "all values must be either basic blocks or instructions");
    }
  }
}

void MSAAlignmentEntry::print(raw_ostream &OS) const {
  OS << "MSAAlignmentEntry:\n";
  for (auto *V : Values) {
    if (V) {
      if (auto *BB = dyn_cast<BasicBlock>(V)) {
        OS << "- bb" << BB->getName() << "\n";
      } else {
        OS << "- " << *V << "\n";
      }
    } else {
      OS << "-   nullptr\n";
    }
  }
}

bool MSAFunctionMerger::align(std::vector<MSAAlignmentEntry> &Alignment) {
  return MSAligner::align(PairMerger, Scoring, Functions, Alignment,
                          DefaultShapeSizeLimit, &ORE);
}

MSAThunkFunction
MSAThunkFunction::create(Function *MergedFunction, Function *SrcFunction,
                         unsigned int FuncId,
                         ValueMap<Argument *, unsigned int> &ArgToMergedArgNo) {
  auto *M = MergedFunction->getParent();
  auto *thunk = Function::Create(SrcFunction->getFunctionType(),
                                 SrcFunction->getLinkage(), "");
  M->getFunctionList().insertAfter(SrcFunction->getIterator(), thunk);
  // In order to preserve function order, we move Clone after old Function
  thunk->setCallingConv(SrcFunction->getCallingConv());
  thunk->copyAttributesFrom(SrcFunction);
  auto *BB = BasicBlock::Create(thunk->getContext(), "", thunk);
  IRBuilder<> Builder(BB);

  SmallVector<Value *, 16> Args(MergedFunction->arg_size(), nullptr);

  Args[0] = ConstantInt::get(MergedFunction->getFunctionType()->getParamType(0),
                             FuncId);

  for (auto &srcArg : SrcFunction->args()) {
    unsigned newArgNo = ArgToMergedArgNo[&srcArg];
    Args[newArgNo] = thunk->getArg(srcArg.getArgNo());
  }
  for (size_t i = 0; i < Args.size(); i++) {
    if (!Args[i]) {
      Args[i] = UndefValue::get(MergedFunction->getArg(i)->getType());
    }
  }

  auto *Call = Builder.CreateCall(MergedFunction, Args);
  Call->setTailCall();
  Call->setIsNoInline();

  if (SrcFunction->getReturnType()->isVoidTy()) {
    Builder.CreateRetVoid();
  } else {
    Builder.CreateRet(Call);
  }
  return MSAThunkFunction(SrcFunction, thunk);
}

void MSAThunkFunction::applyReplacements() {
  SrcFunction->replaceAllUsesWith(Thunk);
  Thunk->takeName(SrcFunction);
  SrcFunction->eraseFromParent();
}

void MSAThunkFunction::discard() { Thunk->eraseFromParent(); }

Optional<MSACallReplacement> MSACallReplacement::create(
    size_t FuncId, Function *SrcFunction,
    ValueMap<Argument *, unsigned int> &ArgToMergedArgNo) {
  std::vector<WeakTrackingVH> Calls;
  for (User *U : SrcFunction->users()) {
    if (auto *Call = dyn_cast<CallBase>(U)) {
      if (Call->getCalledFunction() != SrcFunction) {
        return None;
      }
      Calls.emplace_back(Call);
    } else {
      return None;
    }
  }

  SmallDenseMap<unsigned, unsigned> SrcArgNoToMergedArgNo;
  for (auto &srcArg : SrcFunction->args()) {
    unsigned srcArgNo = srcArg.getArgNo();
    unsigned newArgNo = ArgToMergedArgNo[&srcArg];
    SrcArgNoToMergedArgNo[srcArgNo] = newArgNo;
  }

  return MSACallReplacement(FuncId, SrcFunction, std::move(Calls),
                            std::move(SrcArgNoToMergedArgNo));
}

void MSACallReplacement::applyReplacements(Function *MergedFunction) {

  for (auto V : Calls) {
    if (!V) {
      continue;
    }

    auto *CI = cast<CallBase>(V);
    IRBuilder<> Builder(CI);

    SmallVector<Value *, 16> Args(MergedFunction->arg_size(), nullptr);

    Args[0] = ConstantInt::get(
        MergedFunction->getFunctionType()->getParamType(0), FuncId);

    for (auto &srcArg : SrcFunction->args()) {
      unsigned srcArgNo = srcArg.getArgNo();
      unsigned newArgNo = SrcArgNoToMergedArgNo[srcArgNo];
      Args[newArgNo] = CI->getArgOperand(srcArgNo);
    }
    for (size_t i = 0; i < Args.size(); i++) {
      if (!Args[i]) {
        Args[i] = UndefValue::get(MergedFunction->getArg(i)->getType());
      }
    }

    CallBase *NewCB = nullptr;
    if (auto *Call = dyn_cast<CallInst>(CI)) {
      NewCB = Builder.CreateCall(MergedFunction, Args);
    } else if (auto *Invoke = dyn_cast<InvokeInst>(CI)) {
      NewCB = Builder.CreateInvoke(MergedFunction, Invoke->getNormalDest(),
                                   Invoke->getUnwindDest(), Args);
    } else {
      llvm_unreachable("unsupported call instruction");
    }
    NewCB->setCallingConv(MergedFunction->getCallingConv());
    NewCB->setIsNoInline();

    CI->replaceAllUsesWith(NewCB);
    CI->eraseFromParent();
  }
  SrcFunction->eraseFromParent();
}

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI);

MSAMergePlan::Score MSAMergePlan::computeScore(FunctionAnalysisManager &FAM) {
  size_t MergedSize =
      EstimateFunctionSize(&Merged, &FAM.getResult<TargetIRAnalysis>(Merged));
  size_t OriginalTotalSize = 0;
  for (auto *F : Functions) {
    OriginalTotalSize +=
        EstimateFunctionSize(F, &FAM.getResult<TargetIRAnalysis>(*F));
  }
  // This magic number respects `EstimateThunkOverhead`
  size_t ThunkOverhead = Thunks.empty() ? 0 : 2;

  for (auto &thunk : Thunks) {
    auto *F = thunk.getFunction();
    ThunkOverhead += Merged.getFunctionType()->getNumParams();
  }
  return Score{
      .MergedSize = MergedSize,
      .ThunkOverhead = ThunkOverhead,
      .OriginalTotalSize = OriginalTotalSize,
  };
}

bool MSAMergePlan::Score::isProfitableMerge() const {
  if (AllowUnprofitableMerge) {
    return true;
  }
  if (MergedSize + ThunkOverhead < OriginalTotalSize) {
    return true;
  }
  return false;
}

void MSAMergePlan::Score::emitMissedRemark(ArrayRef<Function *> Functions,
                                           OptimizationRemarkEmitter &ORE) {
  auto remark = createMissedRemark("UnprofitableMerge", "", Functions)
                << ore::NV("MergedSize", MergedSize)
                << ore::NV("ThunkOverhead", ThunkOverhead)
                << ore::NV("OriginalTotalSize", OriginalTotalSize);
  ORE.emit(remark);
}

void MSAMergePlan::Score::emitPassedRemark(MSAMergePlan &plan,
                                           OptimizationRemarkEmitter &ORE) {
  ORE.emit([&] {
    auto remark = OptimizationRemark(DEBUG_TYPE, "Merge", &plan.getMerged());
    for (auto *F : plan.getFunctions()) {
      remark << ore::NV("Function", F->getName());
    }
    remark << ore::NV("MergedSize", MergedSize)
           << ore::NV("ThunkOverhead", ThunkOverhead)
           << ore::NV("OriginalTotalSize", OriginalTotalSize);
    return remark;
  });
}

bool MSAMergePlan::Score::isBetterThan(const MSAMergePlan::Score &Other) const {
  return (MergedSize + ThunkOverhead + Other.OriginalTotalSize) <
         (Other.MergedSize + Other.ThunkOverhead + OriginalTotalSize);
}

Function &MSAMergePlan::applyMerge(FunctionAnalysisManager &FAM,
                                   OptimizationRemarkEmitter &ORE) {
  for (auto replacement : CallReplacements) {
    replacement.applyReplacements(&Merged);
  }

  for (auto &thunk : Thunks) {
    thunk.applyReplacements();
  }
  return Merged;
}

void MSAMergePlan::discard() {
  for (auto &thunk : Thunks) {
    thunk.discard();
  }
  Merged.eraseFromParent();
}

MSAFunctionMerger::MSAFunctionMerger(ArrayRef<Function *> Functions,
                                     FunctionMerger &PM,
                                     OptimizationRemarkEmitter &ORE,
                                     FunctionAnalysisManager &FAM)
    : Functions(Functions), PairMerger(PM), ORE(ORE), FAM(FAM),
      Scoring(/*Gap*/ -1, /*Match*/ 2,
              /*Mismatch*/ fmutils::OptionalScore::min()) {
  assert(!Functions.empty() && "No functions to merge");
  M = Functions[0]->getParent();
  size_t noOfBits = std::ceil(std::log2(Functions.size()));
  DiscriminatorTy = IntegerType::getIntNTy(M->getContext(), noOfBits);
}

Optional<MSAMergePlan>
MSAFunctionMerger::planMerge(MSAStats &Stats, FunctionMergingOptions Options) {

  std::vector<MSAAlignmentEntry> Alignment;
  if (!align(Alignment)) {
    return None;
  }

  ValueMap<Argument *, unsigned> ArgToMergedArgNo;
  MSAGenFunction Generator(M, Alignment, Functions, DiscriminatorTy, ORE);
  auto *Merged = Generator.emit(Options, Stats, ArgToMergedArgNo);
  if (!Merged) {
    return None;
  }

  if (verifyFunction(*Merged, &llvm::errs())) {
    LLVM_DEBUG(dbgs() << "Invalid merged function:\n");
    LLVM_DEBUG(Merged->dump());
    Merged->eraseFromParent();

    ORE.emit([&] {
      return createMissedRemark("CodeGen", "Invalid merged function",
                                Functions);
    });
    return None;
  }

  if (!DisablePostOpt) {
    FunctionPassManager FPM;
    FPM.addPass(SimplifyCFGPass());

    FPM.run(*Merged, FAM);
  }

  MSAMergePlan plan(*Merged, Functions);

  for (size_t FuncId = 0; FuncId < Functions.size(); FuncId++) {
    auto *F = Functions[FuncId];
    if (!F->hasAddressTaken() && F->isDiscardableIfUnused()) {
      if (auto replacement =
              MSACallReplacement::create(FuncId, F, ArgToMergedArgNo)) {
        // We don't need to create a thunk if we can just replace calls.
        plan.addCallReplacement(*replacement);
        continue;
      }
    }
    plan.addThunk(
        MSAThunkFunction::create(Merged, F, FuncId, ArgToMergedArgNo));
  }
  return plan;
}

namespace {

struct MSAOptions : public FunctionMergingOptions {
  size_t LSHRows = 2;
  size_t LSHBands = 100;

  MSAOptions() : FunctionMergingOptions() { EnableUnifiedReturnType = false; }
};

} // namespace

namespace llvm {

class MSAGenFunctionBody {
  const MSAGenFunction &Parent;
  const FunctionMergingOptions &Options;
  MSAStats &Stats;
  Function *MergedFunc;

  Value *Discriminator;
  ValueToValueMapTy &VMap;
  // FIXME(katei): Better name?
  DenseMap<Value *, BasicBlock *> MaterialNodes;
  std::vector<DenseMap<BasicBlock *, BasicBlock *>> FinalBBToBB;
  // IsMerged flag by final BB.
  DenseMap<BasicBlock *, bool> IsMergedBB;
  BasicBlock *EntryBB;
  mutable BasicBlock *BlackholeBBCache;
  // See `fixupCoalescingPHI` for details.
  std::map<Instruction *, std::map<Instruction *, unsigned>>
      CoalescingCandidates;

public:
  MSAGenFunctionBody(const MSAGenFunction &Parent,
                     const FunctionMergingOptions &Options, MSAStats &Stats,
                     Value *Discriminator, ValueToValueMapTy &VMap,
                     Function *MergedF)
      : Parent(Parent), Options(Options), Stats(Stats), MergedFunc(MergedF),
        Discriminator(Discriminator), VMap(VMap), MaterialNodes(),
        FinalBBToBB(Parent.Functions.size()) {

    EntryBB = BasicBlock::Create(Parent.C, "entry", MergedFunc);
    BlackholeBBCache = nullptr;
  };

  inline LLVMContext &getContext() const { return Parent.C; }
  Type *getReturnType() const { return MergedFunc->getReturnType(); }
  IntegerType *getIntPtrType() const {
    return Parent.M->getDataLayout().getIntPtrType(Parent.C);
  }

  BasicBlock *getBlackholeBB() const {
    if (BlackholeBBCache) {
      return BlackholeBBCache;
    }
    BlackholeBBCache =
        BasicBlock::Create(Parent.C, "switch.blackhole", MergedFunc);
    {
      IRBuilder<> B(BlackholeBBCache);
      B.CreateUnreachable();
    }
    return BlackholeBBCache;
  }

  Instruction *cloneInstruction(IRBuilder<> &Builder, Instruction *I);

  void layoutSharedBasicBlocks();
  void chainBasicBlocks();

  bool assignMergedInstLabelOperands(ArrayRef<Instruction *> Instructions);
  bool assignSingleInstLabelOperands(Instruction *I, size_t FuncId);
  bool assignLabelOperands();

  Value *mergeOperandValues(ArrayRef<Value *> Values, Instruction *MergedI);
  bool assignValueOperands();
  /// Assign new value operands. Return true if all operands are assigned.
  /// Return false if failed to assign any operand.
  /// \param SrcI Instruction to assign operands from.
  bool assignValueOperands(Instruction *SrcI);
  /// Assign new value operands
  bool assignOperands();
  bool assignPHIOperandsInBlock();

  bool fixupCoalescingPHI();

  bool emit();

  /// Reorder the operands to minimize the number of `select`
  static void operandReordering(std::vector<std::vector<Value *>> Operands){
      // TODO(katei): noop for now.
  };
  static Instruction *
  maxNumOperandsInstOf(ArrayRef<Instruction *> Instructions);
};

}; // namespace llvm

static bool hasLocalValueInMetadata(Metadata *MD) {
  if (auto *LMD = dyn_cast<LocalAsMetadata>(MD)) {
    auto *V = LMD->getValue();
    if (auto *MDV = dyn_cast<MetadataAsValue>(V)) {
      return hasLocalValueInMetadata(MDV->getMetadata());
    }
    return true;
  } else {
    return false;
  }
}

/// Return true if the value can be updated after merging operands.
/// Otherwise, the value is a constant or a global value.
static bool isLocalValue(Value *V) {
  if (isa<Constant>(V)) {
    return false;
  }
  // TODO(katei): Should we merge metadata as well?
  if (auto *MDV = dyn_cast<MetadataAsValue>(V)) {
    // if metadata holds an inner value, clear it.
    if (!hasLocalValueInMetadata(MDV->getMetadata())) {
      return false;
    }
  }
  return true;
}

Instruction *MSAGenFunctionBody::cloneInstruction(IRBuilder<> &Builder,
                                                  Instruction *I) {
  Instruction *NewI = nullptr;
  auto *MF = MergedFunc;
  if (I->getOpcode() == Instruction::Ret) {
    if (MF->getReturnType()->isVoidTy()) {
      NewI = Builder.CreateRetVoid();
    } else {
      NewI = Builder.CreateRet(UndefValue::get(MF->getReturnType()));
    }
  } else {
    NewI = I->clone();
    Builder.Insert(NewI);
    for (unsigned i = 0; i < NewI->getNumOperands(); i++) {
      auto Op = I->getOperand(i);
      if (isLocalValue(Op)) {
        NewI->setOperand(i, nullptr);
      }
    }
  }

  NewI->copyMetadata(*I);

  NewI->setName(I->getName());
  return NewI;
}

// Corresponding to `CodeGen` in SALSSACodeGen.cpp
void MSAGenFunctionBody::layoutSharedBasicBlocks() {
  // This pass splits the basic blocks into multiple basic blocks per single
  // instruction or BB label only for merge-able instruction or BB label.

  // ```
  // define double @f0(i32 %0) {
  //   %1 = add i32 %0, 3
  //   %2 = add i32 %1, 1
  //   %3 = sub i32 %2, 1  <--------
  //   call void @f2(i32 %3)       |
  // }                             |
  // define double @f1(i32 %0) {   |
  //   %1 = add i32 %0, 1          |
  //   %2 = add i32 %1, 2          |
  //   %3 = div i32 %2, 2  <------ not mergeable
  //   call void @f2(i32 %3)
  // }
  // ```
  //
  // is transformed into
  //
  // ```
  // define double @f01(i32 %0) {
  // m.inst.bb0:
  //   %1 = add i32 <null>, <null>
  // m.inst.bb1:
  //   %2 = add i32 <null>, <null>
  // m.inst.bb2:
  //   call void @f2(i32 <null>)
  // }
  // ```
  //

  auto &Alignment = Parent.Alignment;
  for (auto it = Alignment.rbegin(), end = Alignment.rend(); it != end; ++it) {
    auto &Entry = *it;
    Entry.verify();
    if (!Entry.match()) {
      continue;
    }
    MSA_VERBOSE(dbgs() << "Layout shared alignment entry";
                Entry.print(dbgs()););

    auto *HeadV = Entry.getValues().front();
    Twine BBName = [&]() {
      if (auto *BB = dyn_cast<BasicBlock>(HeadV)) {
        return "m.bb." + BB->getName();
      } else if (auto *I = dyn_cast<Instruction>(HeadV)) {
        if (I->isTerminator()) {
          return Twine("m.term.bb");
        } else {
          return Twine("m.inst.bb");
        }
      }
      llvm_unreachable("Unknown value type!");
    }();

    auto *MergedBB = BasicBlock::Create(Parent.C, BBName, MergedFunc);
    for (auto *V : Entry.getValues()) {
      MaterialNodes[V] = MergedBB;
    }

    IRBuilder<> Builder(MergedBB);

    if (auto *HeadI = dyn_cast<Instruction>(HeadV)) {
      Instruction *NewI = cloneInstruction(Builder, HeadI);
      auto Vs = Entry.getValues();
      for (size_t i = 0, e = Vs.size(); i < e; ++i) {
        if (!Vs[i])
          continue;
        auto *I = dyn_cast<Instruction>(Vs[i]);
        VMap[I] = NewI;
        FinalBBToBB[i][MergedBB] = I->getParent();
        IsMergedBB[MergedBB] = true;
      }
    } else {
      assert(isa<BasicBlock>(HeadV) && "Unknown value type!");
      auto Vs = Entry.getValues();
      for (size_t i = 0, e = Vs.size(); i < e; ++i) {
        auto *BB = dyn_cast<BasicBlock>(Vs[i]);
        VMap[BB] = MergedBB;

        // IMPORTANT: make sure any use in a blockaddress constant
        // operation is updated correctly
        for (User *U : BB->users()) {
          if (auto *BA = dyn_cast<BlockAddress>(U)) {
            VMap[BA] = BlockAddress::get(MergedFunc, MergedBB);
          }
        }
        for (Instruction &I : *BB) {
          if (auto *PI = dyn_cast<PHINode>(&I)) {
            VMap[PI] = Builder.CreatePHI(PI->getType(), 0, PI->getName());
          }
        }

        FinalBBToBB[i][MergedBB] = BB;
        IsMergedBB[MergedBB] = true;
      }
    }
  }
}

void MSAGenFunctionBody::chainBasicBlocks() {
  fmutils::SwitchChainer chainer(Discriminator,
                                 [&]() { return this->getBlackholeBB(); });

  // Chain BBs splitted from `SrcBB` by `br` and `switch` instructions
  // and insert un-merged instructions.
  //
  // e.g.
  // source two functions:
  // ```
  // define double @f0(i32 %0) {
  //   %1 = add i32 %0, 3
  //   %2 = sub i32 %1, 1
  //   br i32 %0, label %bb0, label %bb1
  // bb0:
  //   call void @f2(i32 %3)
  // bb1:
  //   call void @f3(i32 %3)
  // }
  //
  // define double @f1(i32 %0) {
  //   %1 = add i32 %0, 1
  //   %2 = add i32 %1, 2
  //   call void @f2(i32 %3)
  // }
  // ```
  // current merging function:
  // ```
  // define double @f01(i32 %0) {
  // m.inst.bb0:
  //   %1 = add i32 <null>, <null>
  // m.inst.bb1:
  //   call void @f2(i32 <null>)
  // }
  // ```
  //
  // Then it will be transformed to:
  // ```
  // define double @f01(i32 %0, i32 %discriminator) {
  // m.inst.bb0:
  //   %1 = add i32 <null>, <null>
  //   br %split.bb0
  // split.bb0:
  //   %2 = sub i32 <null>, 1
  //   switch i32 %discriminator, label %switch.blackhole [
  //     i32 0, label %split.bb1  <-- if @f0
  //     i32 1, label %m.inst.bb1 <-- if @f1
  //   ]
  // split.bb1:
  //   %2 = sub i32 <null>, 1
  //   br i32 <null>, label <null>, label <null>
  // m.inst.bb1: <-- merged from @f0#bb0 and @f1#entry
  //   call void @f2(i32 <null>)
  // src.bb0:
  //   call void @f3(i32 <null>)
  // }
  // ```

  struct ClonedInst {
    Instruction *SrcI;
    Instruction *NewI;
    ClonedInst(Instruction *SrcI, Instruction *NewI) : SrcI(SrcI), NewI(NewI) {}
  };

  std::vector<ClonedInst> ClonedInsts;

  auto ProcessBasicBlock = [&](BasicBlock *SrcBB,
                               DenseMap<BasicBlock *, BasicBlock *> &BlocksFX,
                               fmutils::FuncId FuncId) {
    BasicBlock *LastMergedBB = nullptr;
    BasicBlock *NewBB = nullptr;
    auto FoundMerged = MaterialNodes.find(SrcBB);
    if (FoundMerged != MaterialNodes.end()) {
      LastMergedBB = FoundMerged->second;
    } else {
      SmallString<128> BBName(SrcBB->getParent()->getName());
      BBName.append(".");
      BBName.append(SrcBB->getName());
      NewBB = BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);
      VMap[SrcBB] = NewBB;
      BlocksFX[NewBB] = SrcBB;

      // IMPORTANT: make sure any use in a blockaddress constant
      // operation is updated correctly
      for (User *U : SrcBB->users()) {
        if (auto *BA = dyn_cast<BlockAddress>(U)) {
          VMap[BA] = BlockAddress::get(MergedFunc, NewBB);
        }
      }

      IRBuilder<> Builder(NewBB);
      for (Instruction &I : *SrcBB) {
        if (auto *PI = dyn_cast<PHINode>(&I)) {
          VMap[PI] = Builder.CreatePHI(PI->getType(), 0, PI->getName());
        }
      }
    }
    for (Instruction &I : *SrcBB) {
      if (isa<LandingPadInst>(&I))
        continue;
      if (isa<PHINode>(&I))
        continue;

      bool HasBeenMerged = MaterialNodes.find(&I) != MaterialNodes.end();
      if (HasBeenMerged) {
        BasicBlock *NodeBB = MaterialNodes[&I];
        if (LastMergedBB) {
          chainer.chainBlocks(LastMergedBB, NodeBB, FuncId);
        } else {
          IRBuilder<> Builder(NewBB);
          Builder.CreateBr(NodeBB);
        }
        // end keep track
        LastMergedBB = NodeBB;
      } else {
        if (LastMergedBB) {
          SmallString<128> BBName(SrcBB->getParent()->getName());
          BBName.append(".");
          BBName.append(SrcBB->getName());
          BBName.append(".split");
          NewBB =
              BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);
          chainer.chainBlocks(LastMergedBB, NewBB, FuncId);
          BlocksFX[NewBB] = SrcBB;
        }
        LastMergedBB = nullptr;

        IRBuilder<> Builder(NewBB);
        Instruction *NewI = this->cloneInstruction(Builder, &I);
        ClonedInsts.emplace_back(&I, NewI);
        VMap[&I] = NewI;
      }
    }
  };

  for (size_t i = 0, e = Parent.Functions.size(); i < e; ++i) {
    auto *F = Parent.Functions[i];
    for (auto &BB : *F) {
      ProcessBasicBlock(&BB, FinalBBToBB[i], i);
    }
    auto *MergedEntryV = MapValue(&F->getEntryBlock(), VMap);
    chainer.chainBlocks(EntryBB, dyn_cast<BasicBlock>(MergedEntryV), i);

    // Assign BB operands to the mapped BBs here because
    // assignLabelOperands() only iterates over alignment entries
    // and doesn't visit orphan blocks.
    for (auto &CI : ClonedInsts) {
      for (unsigned i = 0, e = CI.SrcI->getNumOperands(); i < e; ++i) {
        Value *Op = CI.SrcI->getOperand(i);
        if (auto *OpB = dyn_cast<BasicBlock>(Op)) {
          auto *NewOpB = MapValue(OpB, VMap);
          CI.NewI->setOperand(i, NewOpB);
        }
      }
    }
    ClonedInsts.clear();
  }
  chainer.finalize();
}

Instruction *
MSAGenFunctionBody::maxNumOperandsInstOf(ArrayRef<Instruction *> Instructions) {
  Instruction *MaxNumOperandsInst = nullptr;
  assert(!Instructions.empty() && "Empty instruction list!");
  for (auto *I : Instructions) {
    if (MaxNumOperandsInst == nullptr ||
        I->getNumOperands() > MaxNumOperandsInst->getNumOperands()) {
      MaxNumOperandsInst = I;
    }
  }
  assert(MaxNumOperandsInst && "No instruction found!?");
  return MaxNumOperandsInst;
}

bool MSAGenFunctionBody::assignMergedInstLabelOperands(
    ArrayRef<Instruction *> Instructions) {

  Instruction *I = Instructions[0];
  auto *NewI = dyn_cast<Instruction>(VMap[I]);

  auto *MaxNumOperandsInst = maxNumOperandsInstOf(Instructions);

  for (unsigned OperandIdx = 0;
       OperandIdx < MaxNumOperandsInst->getNumOperands(); OperandIdx++) {
    std::vector<Value *> FVs;
    std::vector<Value *> Vs;
    for (auto *I : Instructions) {
      Value *FV = nullptr;
      Value *V = nullptr;
      if (OperandIdx < I->getNumOperands()) {
        FV = I->getOperand(OperandIdx);
        // FIXME(katei): `VMap[FV]` is enough?
        V = MapValue(FV, VMap);
        assert(V && "Operand not found in VMap!");
      } else {
        V = UndefValue::get(
            MaxNumOperandsInst->getOperand(OperandIdx)->getType());
      }
      assert(V != nullptr && "Value should NOT be null!");
      FVs.push_back(FV);
      Vs.push_back(V);
    }

    Value *V = nullptr;

    // handling just label operands for now
    if (!isa<BasicBlock>(Vs[0]))
      continue;

    bool areAllOperandsEqual =
        std::all_of(Vs.begin(), Vs.end(), [&](Value *V) { return V == Vs[0]; });

    if (areAllOperandsEqual) {
      V = Vs[0]; // assume that V1 == V2 == ... == Vn
    } else if (Vs.size() == 2) {
      assert(Instructions.size() == 2 && "Invalid number of instructions!");
      // if there are only two instructions, we can just use cond_br
      auto *SelectBB = BasicBlock::Create(Parent.C, "bb.select.bb", MergedFunc);
      IRBuilder<> Builder(SelectBB);
      Builder.CreateCondBr(Discriminator, dyn_cast<BasicBlock>(Vs[1]),
                           dyn_cast<BasicBlock>(Vs[0]));
      for (size_t FuncId = 0, e = Instructions.size(); FuncId < e; ++FuncId) {
        FinalBBToBB[FuncId][SelectBB] = Instructions[FuncId]->getParent();
      }
      FinalBBToBB[0][SelectBB] = I->getParent();
      IsMergedBB[SelectBB] = true;
      V = SelectBB;
    } else {
      auto *SelectBB = BasicBlock::Create(Parent.C, "bb.select.bb", MergedFunc);
      IRBuilder<> BuilderBB(SelectBB);
      auto *Switch = BuilderBB.CreateSwitch(Discriminator, getBlackholeBB());

      for (size_t FuncId = 0, e = Instructions.size(); FuncId < e; ++FuncId) {
        auto *I = Instructions[FuncId];
        // XXX: is this correct?
        FinalBBToBB[FuncId][SelectBB] = I->getParent();

        auto *Case = ConstantInt::get(Parent.DiscriminatorTy, FuncId);
        auto *BB = dyn_cast<BasicBlock>(Vs[FuncId]);
        Switch->addCase(Case, BB);
      }

      IsMergedBB[SelectBB] = true;
      V = SelectBB;
    }

    assert(V != nullptr && "Label operand value should be merged!");

    bool isAnyOperandLandingPad =
        std::any_of(FVs.begin(), FVs.end(), [&](Value *FV) {
          return dyn_cast<BasicBlock>(FV)->isLandingPad();
        });

    if (isAnyOperandLandingPad) {
      for (auto *FV : FVs) {
        auto *BB = dyn_cast<BasicBlock>(FV);
        assert(BB->getLandingPadInst() != nullptr &&
               "Should be both as per the BasicBlock match!");
      }
      BasicBlock *LPadBB = BasicBlock::Create(Parent.C, "lpad.bb", MergedFunc);
      IRBuilder<> BuilderBB(LPadBB);

      auto *LP1 = dyn_cast<BasicBlock>(FVs[0])->getLandingPadInst();

      Instruction *NewLP = LP1->clone();
      BuilderBB.Insert(NewLP);

      BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));

      for (size_t FuncId = 0, e = Instructions.size(); FuncId < e; ++FuncId) {
        FinalBBToBB[FuncId][LPadBB] = Instructions[FuncId]->getParent();
        // XXX: is this really merged?
        IsMergedBB[LPadBB] = true;
        auto *FBB = dyn_cast<BasicBlock>(FVs[FuncId]);
        VMap[FBB->getLandingPadInst()] = NewLP;
      }

      V = LPadBB;
    }
    NewI->setOperand(OperandIdx, V);
  }
  return true;
}

bool MSAGenFunctionBody::assignSingleInstLabelOperands(Instruction *I,
                                                       size_t FuncId) {
  auto *NewI = dyn_cast<Instruction>(VMap[I]);
  auto &BlocksReMap = FinalBBToBB[FuncId];

  for (unsigned i = 0; i < I->getNumOperands(); i++) {
    // handling just label operands for now
    if (!isa<BasicBlock>(I->getOperand(i)))
      continue;
    auto *FXBB = dyn_cast<BasicBlock>(I->getOperand(i));

    Value *V = MapValue(FXBB, VMap);
    if (V == nullptr)
      return false; // ErrorResponse;

    if (FXBB->isLandingPad()) {

      LandingPadInst *LP = FXBB->getLandingPadInst();
      assert(LP != nullptr && "Should have a landingpad inst!");

      BasicBlock *LPadBB = BasicBlock::Create(Parent.C, "lpad.bb", MergedFunc);
      IRBuilder<> BuilderBB(LPadBB);

      Instruction *NewLP = LP->clone();
      BuilderBB.Insert(NewLP);
      VMap[LP] = NewLP;
      BlocksReMap[LPadBB] = I->getParent(); // FXBB;
      IsMergedBB[LPadBB] = true;            // XXX: is this really merged?

      BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));

      V = LPadBB;
    }

    NewI->setOperand(i, V);
  }
  return true;
}

bool MSAGenFunctionBody::assignLabelOperands() {
  // iterator over reverse order so that the first inst is visited first
  // to see use of landingpad BB before the actual landingpad inst.
  for (auto it = Parent.Alignment.rbegin(); it != Parent.Alignment.rend();
       ++it) {
    MSAAlignmentEntry Entry = *it;
    std::vector<Instruction *> Instructions;
    bool allInsts = Entry.collectInstructions(Instructions);
    // If instructions are merged, select new operand values by switch-phi.
    // Otherwise, just map original operand value to new value for each
    // instruction.
    // TODO(katei): Allow partially merged instructions when two of three
    // instructions are merged.
    if (Entry.match() && allInsts) {
      if (!assignMergedInstLabelOperands(Instructions)) {
        LLVM_DEBUG(
            errs() << "ERROR: Failed to assign matching label operands\n";);
        return false;
      }
    } else {
      for (size_t FuncId = 0; FuncId < Parent.Functions.size(); ++FuncId) {
        if (auto *I = Instructions[FuncId]) {
          if (!assignSingleInstLabelOperands(I, FuncId)) {
            return false;
          }
        }
      }
    }
  }
  return true;
}

Value *MSAGenFunctionBody::mergeOperandValues(ArrayRef<Value *> Values,
                                              Instruction *MergedI) {
  bool areAllEqual = std::all_of(Values.begin(), Values.end(),
                                 [&](Value *V) { return V == Values[0]; });
  if (areAllEqual)
    return Values[0];

  if (isa<UndefValue>(Values[0])) {
    bool allSameTypes = true;
    FunctionMergingOptions Options;
    Options.matchOnlyIdenticalTypes(false);
    for (size_t i = 1; i < Values.size(); ++i) {
      if (!isa<UndefValue>(Values[i])) {
        allSameTypes = false;
        break;
      }
      allSameTypes &= FunctionMerger::areTypesEquivalent(
          Values[i]->getType(), Values[0]->getType(),
          &Parent.M->getDataLayout(), Options);
      if (!allSameTypes)
        break;
    }
    if (allSameTypes)
      return UndefValue::get(Values[0]->getType());
  }

  if (Values.size() == 2) {
    // TODO(katei): Extend to more than two functions.
    auto *V1 = Values[0];
    auto *V2 = Values[1];
    IRBuilder<> BuilderBB(MergedI);
    if (V1->getType() != V2->getType()) {
      V2 = (BitCastInst *)BuilderBB.CreateBitCast(V2, V1->getType());
    }
    {
      auto *IV1 = dyn_cast<Instruction>(V1);
      auto *IV2 = dyn_cast<Instruction>(V2);
      if (IV1 && IV2) {
        // if both IV1 and IV2 are non-merged values
        if (!IsMergedBB[IV1->getParent()] && !IsMergedBB[IV2->getParent()]) {
          CoalescingCandidates[IV1][IV2]++;
          CoalescingCandidates[IV2][IV1]++;
        }
      }
    }

    assert(Parent.Functions.size() == 2 && "Expected two functions!");
    auto DiscriminatorBit = BuilderBB.CreateTrunc(
        Discriminator, IntegerType::get(Parent.C, 1), "discriminator.bit");
    return BuilderBB.CreateSelect(DiscriminatorBit, V2, V1, "switch.select");
  }

  // TODO(katei): Handle 0, 1, .., n => Discriminator

  // pred.0:
  //   ...
  //   br label %insert.pt
  // insert.pt:
  //   add <i32 0 or i32 42>, i32 0
  //
  // ====>
  //
  // pred.0:
  //   ...
  //   br label %bb.switch.values
  // bb.switch.values:
  //   switch i1 %discriminator, label %bb.0 [
  //     i32 0, label %bb.select0
  //     i32 1, label %bb.select1
  //   ]
  // bb.select0:
  //   br label %insert.pt
  // bb.select1:
  //   br label %insert.pt
  // bb.aggregate.values:
  //   %4 = phi i32 [ 0, %bb.select0 ], [ 42, %bb.select1 ]
  //   br label %insert.pt
  // merged.i:
  //   add %4, i32 0

  auto *SwitchBB = BasicBlock::Create(Parent.C, "bb.switch.values", MergedFunc,
                                      MergedI->getParent());
  IRBuilder<> SwitchB(SwitchBB);
  auto *Switch = SwitchB.CreateSwitch(Discriminator, getBlackholeBB());

  MergedI->getParent()->replaceAllUsesWith(SwitchBB);

  auto *AggregateBB = BasicBlock::Create(Parent.C, "bb.aggregate.values",
                                         MergedFunc, MergedI->getParent());
  IRBuilder<> AggregateB(AggregateBB);

  auto *PHI = AggregateB.CreatePHI(Values[0]->getType(), Values.size(), "phi.aggregate.values");
  AggregateB.CreateBr(MergedI->getParent());

  for (size_t FuncId = 0, e = Values.size(); FuncId < e; ++FuncId) {
    auto *Case = ConstantInt::get(Parent.DiscriminatorTy, FuncId);
    SmallString<128> BBName("bb.select.values.");
    BBName.append(Parent.Functions[FuncId]->getName());
    auto *BB = BasicBlock::Create(Parent.C, BBName, MergedFunc, AggregateBB);

    IRBuilder<> BuilderBB(BB);
    BuilderBB.CreateBr(AggregateBB);
    Switch->addCase(Case, BB);
    auto *V = Values[FuncId];
    assert(V != nullptr && "value should not be null!");
    if (V->getType() != PHI->getType()) {
      V = BuilderBB.CreateBitCast(V, PHI->getType());
    }
    PHI->addIncoming(V, BB);
  }

  Stats.NumSelection++;

  return PHI;
}

bool MSAGenFunctionBody::assignValueOperands(Instruction *SrcI) {
  auto *NewI = dyn_cast<Instruction>(VMap[SrcI]);
  IRBuilder<> Builder(NewI);

  if (SrcI->getOpcode() == Instruction::Ret &&
      Options.EnableUnifiedReturnType) {
    llvm_unreachable("Unified return type is not supported yet!");
    /*
    Value *V = MapValue(I->getOperand(0), VMap);
    if (V == nullptr) {
      return false; // ErrorResponse;
    }
    if (V->getType() != getReturnType()) {
      Value *Addr = Builder.CreateAlloca(V->getType());
      Builder.CreateStore(V, Addr);
      Value *CastedAddr =
          Builder.CreatePointerCast(Addr, RetUnifiedAddr->getType());
      V = Builder.CreateLoad(getReturnType(), CastedAddr);
    }
    NewI->setOperand(0, V);
    */
  } else {
    for (unsigned i = 0; i < SrcI->getNumOperands(); i++) {
      auto *Op = SrcI->getOperand(i);
      // BB operands should be handled separately by assignLabelOperands
      if (isa<BasicBlock>(Op))
        continue;
      // Metadata or constant operands should be cloned correctly by
      // cloneInstruction
      if (!isLocalValue(Op))
        continue;

      Value *V = MapValue(Op, VMap);
      if (V == nullptr) {
        return false; // ErrorResponse;
      }
      if (V->getType() != Op->getType()) {
        V = Builder.CreateBitCast(V, Op->getType());
      }

      NewI->setOperand(i, V);
    }
  }

  return true;
}

/// Taken from FunctionMergable.cpp
/// TODO(katei): share the declaration with the original function.
Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
                          Type *IntPtrTy,
                          const FunctionMergingOptions &Options = {});

bool MSAGenFunctionBody::assignValueOperands() {
  for (auto &Entry : Parent.Alignment) {
    std::vector<Instruction *> Instructions;
    bool allValuesAreInstruction = Entry.collectInstructions(Instructions);
    if (!allValuesAreInstruction) {
      // If instructions and BBs are mixed, assign only instructions.
      for (auto *V : Entry.getValues()) {
        if (V == nullptr)
          continue;

        auto *I = dyn_cast<Instruction>(V);
        if (I != nullptr && !assignValueOperands(I)) {
          LLVM_DEBUG(errs() << "ERROR: Failed to assign value operands\n");
          return false;
        }
      }
      continue;
    }

    // Process the case where all values are instructions.

    auto *MaxNumOperandsInst = maxNumOperandsInstOf(Instructions);
    auto *NewI = dyn_cast<Instruction>(VMap[MaxNumOperandsInst]);
    IRBuilder<> Builder(NewI);

    if (Options.EnableOperandReordering && isa<BinaryOperator>(NewI) &&
        MaxNumOperandsInst->isCommutative()) {
      // Optimizable case:

      std::vector<std::vector<Value *>> Operands(
          MaxNumOperandsInst->getNumOperands());
      for (auto *I : Instructions) {
        auto *BO = dyn_cast<BinaryOperator>(I);
        for (size_t OpIdx = 0, e = I->getNumOperands(); OpIdx < e; ++OpIdx) {
          auto *NewO = MapValue(I->getOperand(OpIdx), VMap);
          Operands[OpIdx].push_back(NewO);
        }
      }
      operandReordering(Operands);

      for (unsigned i = 0; i < Operands.size(); i++) {
        auto Vs = Operands[i];
        Value *V = mergeOperandValues(Vs, NewI);
        assert(V != nullptr && "value should not be null!");

        if (auto *LiteralOp = NewI->getOperand(i)) {
          assert(V->getType() == LiteralOp->getType() &&
                 "TODO(katei): Handle type mismatch?");
        }
        NewI->setOperand(i, V);
      }
    } else {
      // Baseline case:

      auto *I = MaxNumOperandsInst;
      for (unsigned OperandIdx = 0; OperandIdx < I->getNumOperands();
           OperandIdx++) {
        if (isa<BasicBlock>(I->getOperand(OperandIdx)))
          continue;

        std::vector<Value *> FVs;
        std::vector<Value *> Vs;
        for (auto *I : Instructions) {
          Value *FV = nullptr;
          Value *V = nullptr;
          if (OperandIdx < I->getNumOperands()) {
            FV = I->getOperand(OperandIdx);
            // FIXME(katei): `VMap[FV]` is enough?
            V = MapValue(FV, VMap);
            assert(V != nullptr && "Value should NOT be null!");
          } else {
            V = UndefValue::get(
                MaxNumOperandsInst->getOperand(OperandIdx)->getType());
          }
          assert(V != nullptr && "Value should NOT be null!");
          FVs.push_back(FV);
          Vs.push_back(V);
        }

        Value *V = mergeOperandValues(Vs, NewI);
        assert(V != nullptr && "Value should NOT be null!");

        NewI->setOperand(OperandIdx, V);
      }
    }
  }
  return true;
}

bool MSAGenFunctionBody::fixupCoalescingPHI() {
  // This pass fixes up PHI nodes where its incoming BBs are non-dominated by
  // PHI node e.g.
  //   o   <--- switch %discriminator, [bb2, ...]
  //  / \
  // o   o <--- bb2: %3 = ...
  //  \ /
  //   o   <--- switch %discriminator, [bb4, ...]
  //  / \
  // o   o <--- bb4: ...
  //  \ /
  //   o   <--- bb5: %6 = phi [%3, bb4], ...
  //
  // `bb5` dominates `bb2` in theory, it is not dominated in LLVM verification.
  // This pass fixes up the PHI node by escaping the values like %3 into
  // alloca-ed space. This pass was taken from SALSSACodeGen.cpp as is.

  std::list<Instruction *> LinearOffendingInsts;
  std::set<Instruction *> OffendingInsts;
  BasicBlock *PreBB = EntryBB;

  DominatorTree DT(*MergedFunc);

  for (Instruction &I : instructions(MergedFunc)) {
    if (auto *PHI = dyn_cast<PHINode>(&I)) {
      for (unsigned i = 0; i < PHI->getNumIncomingValues(); i++) {
        BasicBlock *BB = PHI->getIncomingBlock(i);
        if (BB == nullptr)
          errs() << "Null incoming block\n";
        Value *V = PHI->getIncomingValue(i);
        if (V == nullptr)
          errs() << "Null incoming value\n";
        if (auto *IV = dyn_cast<Instruction>(V)) {
          if (BB->getTerminator() == nullptr) {
            LLVM_DEBUG(errs() << "ERROR: Null terminator\n");
            return false;
          }
          if (!DT.dominates(IV, BB->getTerminator())) {
            if (OffendingInsts.count(IV) == 0) {
              OffendingInsts.insert(IV);
              LinearOffendingInsts.push_back(IV);
            }
          }
        }
      }
    } else {
      for (unsigned i = 0; i < I.getNumOperands(); i++) {
        if (I.getOperand(i) == nullptr) {
          Parent.ORE.emit([&]() {
            return createMissedRemark("CodeGen", "PHICoalescing: Null operand",
                                      Parent.Functions)
                   << ore::NV("Instruction", &I);
          });
          return false;
        }
        if (auto *IV = dyn_cast<Instruction>(I.getOperand(i))) {
          if (!DT.dominates(IV, &I)) {
            if (OffendingInsts.count(IV) == 0) {
              OffendingInsts.insert(IV);
              LinearOffendingInsts.push_back(IV);
            }
          }
        }
      }
    }
  }

  auto StoreInstIntoAddr = [](Instruction *IV, Value *Addr) {
    IRBuilder<> Builder(IV->getParent());
    if (IV->isTerminator()) {
      BasicBlock *SrcBB = IV->getParent();
      if (auto *II = dyn_cast<InvokeInst>(IV)) {
        BasicBlock *DestBB = II->getNormalDest();

        Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
        // create PHI
        PHINode *PHI = Builder.CreatePHI(IV->getType(), 0, "store2addr");
        for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
             PredIt != PredE; PredIt++) {
          BasicBlock *PredBB = *PredIt;
          if (PredBB == SrcBB) {
            PHI->addIncoming(IV, PredBB);
          } else {
            PHI->addIncoming(UndefValue::get(IV->getType()), PredBB);
          }
        }
        Builder.CreateStore(PHI, Addr);
      } else {
        for (auto SuccIt = succ_begin(SrcBB), SuccE = succ_end(SrcBB);
             SuccIt != SuccE; SuccIt++) {
          BasicBlock *DestBB = *SuccIt;

          Builder.SetInsertPoint(&*DestBB->getFirstInsertionPt());
          // create PHI
          PHINode *PHI = Builder.CreatePHI(IV->getType(), 0, "store2addr");
          for (auto PredIt = pred_begin(DestBB), PredE = pred_end(DestBB);
               PredIt != PredE; PredIt++) {
            BasicBlock *PredBB = *PredIt;
            if (PredBB == SrcBB) {
              PHI->addIncoming(IV, PredBB);
            } else {
              PHI->addIncoming(UndefValue::get(IV->getType()), PredBB);
            }
          }
          Builder.CreateStore(PHI, Addr);
        }
      }
    } else {
      Instruction *LastI = nullptr;
      Instruction *InsertPt = nullptr;
      for (Instruction &I : *IV->getParent()) {
        InsertPt = &I;
        if (LastI == IV)
          break;
        LastI = &I;
      }
      if (isa<PHINode>(InsertPt) || isa<LandingPadInst>(InsertPt)) {
        Builder.SetInsertPoint(&*IV->getParent()->getFirstInsertionPt());
        // Builder.SetInsertPoint(IV->getParent()->getTerminator());
      } else
        Builder.SetInsertPoint(InsertPt);

      Builder.CreateStore(IV, Addr);
    }
  };

  auto MemfyInst = [&](std::set<Instruction *> &InstSet) -> AllocaInst * {
    if (InstSet.empty())
      return nullptr;
    IRBuilder<> Builder(&*PreBB->getFirstInsertionPt());
    AllocaInst *Addr =
        Builder.CreateAlloca((*InstSet.begin())->getType(), nullptr, "memfy");

    for (Instruction *I : InstSet) {
      for (auto UIt = I->use_begin(), E = I->use_end(); UIt != E;) {
        Use &UI = *UIt;
        UIt++;

        auto *User = cast<Instruction>(UI.getUser());

        if (auto *PHI = dyn_cast<PHINode>(User)) {
          /// TODO: make sure getOperandNo is getting the correct incoming edge
          auto InsertionPt =
              PHI->getIncomingBlock(UI.getOperandNo())->getTerminator();
          /// TODO: If the terminator of the incoming block is the producer of
          //        the value we want to store, the load cannot be inserted
          //        between the producer and the user. Something more complex is
          //        needed.
          if (InsertionPt == I)
            continue;
          IRBuilder<> Builder(InsertionPt);
          UI.set(Builder.CreateLoad(Addr->getType()->getPointerElementType(),
                                    Addr));
        } else {
          IRBuilder<> Builder(User);
          UI.set(Builder.CreateLoad(Addr->getType()->getPointerElementType(),
                                    Addr));
        }
      }
    }

    for (Instruction *I : InstSet)
      StoreInstIntoAddr(I, Addr);

    return Addr;
  };

  auto isCoalescingProfitable = [&](Instruction *I1, Instruction *I2) -> bool {
    std::set<BasicBlock *> BBSet1;
    std::set<BasicBlock *> UnionBB;
    for (User *U : I1->users()) {
      if (auto *UI = dyn_cast<Instruction>(U)) {
        BasicBlock *BB1 = UI->getParent();
        BBSet1.insert(BB1);
        UnionBB.insert(BB1);
      }
    }

    unsigned Intersection = 0;
    for (User *U : I2->users()) {
      if (auto *UI = dyn_cast<Instruction>(U)) {
        BasicBlock *BB2 = UI->getParent();
        UnionBB.insert(BB2);
        if (BBSet1.find(BB2) != BBSet1.end())
          Intersection++;
      }
    }

    const float Threshold = 0.7;
    return (float(Intersection) / float(UnionBB.size()) > Threshold);
  };

  auto OptimizeCoalescing =
      [&](Instruction *I, std::set<Instruction *> &InstSet,
          std::map<Instruction *, std::map<Instruction *, unsigned>>
              &CoalescingCandidates,
          std::set<Instruction *> &Visited) {
        Instruction *OtherI = nullptr;
        unsigned Score = 0;
        if (CoalescingCandidates.find(I) != CoalescingCandidates.end()) {
          for (auto &Pair : CoalescingCandidates[I]) {
            if (Pair.second > Score &&
                Visited.find(Pair.first) == Visited.end()) {
              if (isCoalescingProfitable(I, Pair.first)) {
                OtherI = Pair.first;
                Score = Pair.second;
              }
            }
          }
        }
        if (OtherI) {
          InstSet.insert(OtherI);
          Parent.ORE.emit([&]() {
            auto remark =
                createAnalysisRemark("PHICoalescing", Parent.Functions);
            for (auto *IV : InstSet) {
              remark << ore::NV("Instruction", IV);
            }
            return remark;
          });
        }
      };

  if (((float)OffendingInsts.size()) / ((float)Parent.Alignment.size()) > 4.5) {
    Parent.ORE.emit([&] {
      return createMissedRemark("FixupCoalescingPHI", "Too many OffendingInsts",
                                Parent.Functions);
    });
    return false;
  }

  std::set<Instruction *> Visited;
  std::vector<AllocaInst *> Allocas;

  for (Instruction *I : LinearOffendingInsts) {
    if (Visited.find(I) != Visited.end())
      continue;

    std::set<Instruction *> InstSet;
    InstSet.insert(I);

    // Create a coalescing group in InstSet
    OptimizeCoalescing(I, InstSet, CoalescingCandidates, Visited);

    for (Instruction *OtherI : InstSet)
      Visited.insert(OtherI);

    AllocaInst *Addr = MemfyInst(InstSet);
    if (Addr)
      Allocas.push_back(Addr);
  }

  {
    DominatorTree DT(*MergedFunc);
    PromoteMemToReg(Allocas, DT, nullptr);
  }

  return true;
}

bool MSAGenFunctionBody::assignOperands() {
  // This pass assigns BB label operands and value operands.

  // 1. Assign BB label operands.
  // This phase is separated from value operands because landing pads need to
  // be handled specially.
  if (!assignLabelOperands()) {
    Parent.ORE.emit([&] {
      return createMissedRemark(
          "CodeGen", "AssignLabelOperands: Failed to assign label operands",
          Parent.Functions);
    });
    return false;
  }

  // 2. Assign value operands.
  if (!assignValueOperands()) {
    Parent.ORE.emit([&] {
      return createMissedRemark(
          "CodeGen", "AssignValueOperands: Failed to assign value operands",
          Parent.Functions);
    });
    return false;
  }
  return true;
}

bool MSAGenFunctionBody::assignPHIOperandsInBlock() {
  // Update incoming BB info of PHI that are come from original instructions
  auto AssignPHIOperandsInBlock =
      [&](BasicBlock *BB,
          DenseMap<BasicBlock *, BasicBlock *> &BlocksReMap) -> bool {
    for (Instruction &I : *BB) {
      if (auto *PHI = dyn_cast<PHINode>(&I)) {
        auto *NewPHI = dyn_cast<PHINode>(VMap[PHI]);

        for (auto It = pred_begin(NewPHI->getParent()),
                  E = pred_end(NewPHI->getParent());
             It != E; It++) {

          BasicBlock *NewPredBB = *It;

          Value *V = nullptr;

          if (BlocksReMap.find(NewPredBB) != BlocksReMap.end()) {
            int Index = PHI->getBasicBlockIndex(BlocksReMap[NewPredBB]);
            if (Index >= 0) {
              V = MapValue(PHI->getIncomingValue(Index), VMap);
            } else {
              LLVM_DEBUG(dbgs()
                         << "ERROR: Cannot find incoming value for BB\n");
            }
          } else {
            LLVM_DEBUG(
                dbgs()
                << "ERROR: Cannot find the original BB for the new BB\n");
          }

          if (V == nullptr)
            V = UndefValue::get(NewPHI->getType());

          // IRBuilder<> Builder(NewPredBB->getTerminator());
          // Value *CastedV = createCastIfNeeded(V, NewPHI->getType(), Builder,
          // IntPtrTy);
          NewPHI->addIncoming(V, NewPredBB);
        }
      }
    }
    return true;
  };

  for (size_t FuncId = 0; FuncId < Parent.Functions.size(); FuncId++) {
    auto *F = Parent.Functions[FuncId];
    for (auto &BB : *F) {
      if (!AssignPHIOperandsInBlock(&BB, FinalBBToBB[FuncId])) {
        return false;
      }
    }
  }
  return true;
}

bool MSAGenFunctionBody::emit() {
  layoutSharedBasicBlocks();
  chainBasicBlocks();
  if (!assignOperands()) {
    return false;
  }
  if (!assignPHIOperandsInBlock()) {
    return false;
  }
  if (!fixupCoalescingPHI()) {
    return false;
  }
  return true;
}

/// Layout the merged function parameters while minimizing the length.
void MSAGenFunction::layoutParameters(
    std::vector<std::pair<Type *, AttributeSet>> &Args,
    ValueMap<Argument *, unsigned> &ArgToMergedIndex) const {
  assert(Functions.size() <= (1 << 8) && "Too many functions!");
  assert(Functions.size() > 0 && "No functions to merge!");
  Args.emplace_back(DiscriminatorTy, AttributeSet());

  size_t preservedArgs = Args.size();
  auto FindReusableArg =
      [&](Argument *NewArg, AttributeSet NewAttr,
          const std::set<unsigned> &reusedArgs) -> Optional<int> {
    // TODO(katei): Find the best argument to reuse based on the uses to
    // minimize selections. Ex:
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

    for (size_t i = preservedArgs; i < Args.size(); i++) {
      Type *ty;
      AttributeSet attr;
      std::tie(ty, attr) = Args[i];

      if (ty != NewArg->getType())
        continue;
      if (attr != NewAttr)
        continue;
      // If the argument is already reused, we can't reuse it again for the
      // function.
      if (reusedArgs.find(i) != reusedArgs.end())
        continue;

      return i;
    }
    return None;
  };

  auto MergeArgs = [&](Function *F) {
    auto attrList = F->getAttributes();
    std::set<unsigned> usedArgIndices;

    for (auto &arg : F->args()) {
      auto argAttr = attrList.getParamAttributes(arg.getArgNo());
      if (auto found = FindReusableArg(&arg, argAttr, usedArgIndices)) {
        LLVM_DEBUG(dbgs() << "Reuse arg %" << *found << " for " << arg << " of "
                          << F->getName() << "\n");
        ArgToMergedIndex[&arg] = *found;
        auto inserted = usedArgIndices.insert(*found).second;
        assert(inserted && "Argument already reused!");
      } else {
        Args.emplace_back(arg.getType(), argAttr);
        auto newArgIdx = Args.size() - 1;
        ArgToMergedIndex[&arg] = newArgIdx;
        usedArgIndices.insert(newArgIdx);
      }
    }
    return true;
  };

  for (auto &F : Functions) {
    MergeArgs(F);
  }
}

bool MSAGenFunction::layoutReturnType(Type *&RetTy) {
  // TODO(katei): This accepts only the same return type for all functions.
  Type *TheReTy = nullptr;
  auto MergeRetTy = [&](Function *F) -> bool {
    if (TheReTy == nullptr) {
      TheReTy = F->getReturnType();
      return true;
    } else if (TheReTy == F->getReturnType()) {
      return true;
    } else {
      return false;
    }
  };
  for (auto &F : Functions) {
    if (!MergeRetTy(F)) {
      return false;
    }
  }
  RetTy = TheReTy;
  return true;
}

FunctionType *MSAGenFunction::createFunctionType(
    ArrayRef<std::pair<Type *, AttributeSet>> Args, Type *RetTy) {
  SmallVector<Type *, 16> ArgTys;
  for (auto &Arg : Args) {
    ArgTys.push_back(Arg.first);
  }
  return FunctionType::get(RetTy, ArgTys, false);
}

StringRef MSAGenFunction::getFunctionName() {
  if (this->NameCache)
    return *this->NameCache;

  std::string Name = "__msa_merge";
  for (auto &F : Functions) {
    Name += "_";
    Name += F->getName();
  }
  this->NameCache = Name;
  return *this->NameCache;
}

Optional<Constant *> MSAGenFunction::computePersonalityFn() const {
  Constant *PersonalityFn = nullptr;
  for (auto &F : Functions) {
    if (!F->hasPersonalityFn())
      continue;
    if (PersonalityFn == nullptr) {
      PersonalityFn = F->getPersonalityFn();
    } else if (PersonalityFn != F->getPersonalityFn()) {
      return None;
    }
  }
  return PersonalityFn;
}

Function *
MSAGenFunction::emit(const FunctionMergingOptions &Options, MSAStats &Stats,
                     ValueMap<Argument *, unsigned> &ArgToMergedArgNo) {
  Type *RetTy;
  std::vector<std::pair<Type *, AttributeSet>> MergedArgs;

  layoutParameters(MergedArgs, ArgToMergedArgNo);
  if (!layoutReturnType(RetTy)) {
    ORE.emit([&] {
      auto remark =
          OptimizationRemarkMissed(DEBUG_TYPE, "ReturnTypeLayout", Functions[0])
          << "Return type of functions are not compatible";
      for (auto &F : Functions) {
        remark << ore::NV("Function", F);
        remark << ore::NV("Type", F->getReturnType());
      }
      return remark;
    });
    return nullptr;
  }
  auto *Sig = createFunctionType(MergedArgs, RetTy);

  auto *MergedF = Function::Create(Sig, llvm::GlobalValue::InternalLinkage,
                                   getFunctionName(), M);
  if (auto PersonalityFn = computePersonalityFn()) {
    MergedF->setPersonalityFn(*PersonalityFn);
  } else {
    ORE.emit([&] {
      auto remark =
          OptimizationRemarkMissed(DEBUG_TYPE, "PersonalityFn", Functions[0])
          << "Personality function of functions are not compatible";
      for (auto &F : Functions) {
        remark << ore::NV("Function", F);
        remark << ore::NV("PersonalityFn", F->getPersonalityFn());
      }
      return remark;
    });
    return nullptr;
  }
  auto *discriminator = MergedF->getArg(0);
  discriminator->setName("discriminator");

  ValueToValueMapTy VMap;
  for (auto &F : Functions) {
    for (auto &arg : F->args()) {
      Argument *MergeArg = MergedF->getArg(ArgToMergedArgNo[&arg]);
      VMap[&arg] = MergeArg;

      std::string displayName;
      if (arg.getName().empty()) {
        displayName = std::to_string(arg.getArgNo());
      } else {
        displayName = arg.getName().str();
      }
      if (MergeArg->getName().empty()) {
        MergeArg->setName("m." + displayName);
      } else {
        MergeArg->setName(MergeArg->getName() + Twine(".") + displayName);
      }
    }
  }

  MSAGenFunctionBody BodyEmitter(*this, Options, Stats, discriminator, VMap,
                                 MergedF);
  if (!BodyEmitter.emit()) {
    MergedF->eraseFromParent();
    ORE.emit([&] {
      return createMissedRemark("CodeGen", "Something went wrong", Functions);
    });
    return nullptr;
  }

  return MergedF;
}

/// Check whether \p F is eligible to be a function merging candidate.
static bool isEligibleToBeMergeCandidate(Function &F) {
  if (F.isDeclaration() || F.hasAvailableExternallyLinkage()) {
    return false;
  }
  return true;
}

class MergePlanner {
public:
  struct PlanResult {
    MSAMergePlan Plan;
    MSAMergePlan::Score Score;

    PlanResult(MSAMergePlan Plan, MSAMergePlan::Score Score)
        : Plan(std::move(Plan)), Score(Score) {}
  };

private:
  Optional<PlanResult> bestPlan;
  const MSAOptions &BaseOpt;
  FunctionMerger &PairMerger;
  OptimizationRemarkEmitter &ORE;
  FunctionAnalysisManager &FAM;

public:
  MergePlanner(const MSAOptions &BaseOpt, FunctionMerger &PairMerger,
               OptimizationRemarkEmitter &ORE, FunctionAnalysisManager &FAM)
      : BaseOpt(BaseOpt), PairMerger(PairMerger), ORE(ORE), FAM(FAM) {}

  void tryPlanMerge(SmallVectorImpl<Function *> &Functions,
                    bool IdenticalTypesOnly = true) {
    MSAStats Stats;
    MSAOptions Opt = BaseOpt;
    Opt.matchOnlyIdenticalTypes(IdenticalTypesOnly);
    MSAFunctionMerger FM(Functions, PairMerger, ORE, FAM);
    auto maybePlan = FM.planMerge(Stats, Opt);
    if (!maybePlan) {
      return;
    }
    auto disposePlan = [&](MSAMergePlan &plan, MSAMergePlan::Score &score) {
      score.emitMissedRemark(plan.getFunctions(), ORE);
      plan.discard();
    };
    auto plan = *maybePlan;
    auto score = plan.computeScore(FAM);
    if (!score.isProfitableMerge()) {
      disposePlan(plan, score);
      return;
    }

    if (bestPlan) {
      if (score.isBetterThan(bestPlan->Score)) {
        disposePlan(bestPlan->Plan, bestPlan->Score);
        bestPlan.emplace(plan, score);
      } else {
        disposePlan(plan, score);
        return;
      }
    } else {
      bestPlan.emplace(plan, score);
    }
  };

  Optional<PlanResult> getBestPlan() { return bestPlan; }
};

PreservedAnalyses MultipleFunctionMergingPass::run(Module &M,
                                                   ModuleAnalysisManager &MAM) {

  FunctionAnalysisManager &FAM =
      MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

  FunctionMerger PairMerger(&M);
  auto Options = MSAOptions();

  std::unique_ptr<Matcher<Function *>> MatchFinder =
      createMatcherLSH(PairMerger, Options, Options.LSHRows, Options.LSHBands);

  if (!OnlyFunctions.empty()) {
    SmallVector<Function *, 16> Functions;
    for (auto &FuncName : OnlyFunctions) {
      auto *F = M.getFunction(FuncName);
      if (!F) {
        errs() << "Function " << FuncName << " not found\n";
        continue;
      }
      Functions.push_back(F);
    }
    auto &ORE = FAM.getResult<OptimizationRemarkEmitterAnalysis>(*Functions[0]);
    MergePlanner Planner(Options, PairMerger, ORE, FAM);
    Planner.tryPlanMerge(Functions);
    MSAFunctionMerger FM(Functions, PairMerger, ORE, FAM);
    if (auto result = Planner.getBestPlan()) {
      auto &plan = result->Plan;
      auto score = plan.computeScore(FAM);
      score.emitPassedRemark(plan, ORE);
      auto &Merged = plan.applyMerge(FAM, ORE);
    }
    return PreservedAnalyses::none();
  }

  size_t count = 0;
  for (auto &F : M) {
    if (!isEligibleToBeMergeCandidate(F))
      continue;
    MatchFinder->add_candidate(
        &F, EstimateFunctionSize(&F, &FAM.getResult<TargetIRAnalysis>(F)));
    count++;
  }

  bool Changed = false;

  while (MatchFinder->size() > 0) {
    Function *F1 = MatchFinder->next_candidate();
    auto &Rank = MatchFinder->get_matches(F1);
    MatchFinder->remove_candidate(F1);

    SmallVector<Function *, 16> Functions{F1};
    for (auto &Match : Rank) {
      Functions.push_back(Match.candidate);
    }
    if (Functions.size() < 2)
      continue;

    auto &ORE = FAM.getResult<OptimizationRemarkEmitterAnalysis>(*F1);
    MergePlanner Planner(Options, PairMerger, ORE, FAM);

    SmallVector<Function *, 16> MergingSet{F1};
    // Find a set of functions to merge beneficialy by DFS.
    std::function<void(int32_t, bool)> FindProfitableSet =
        [&](int32_t selectCursor, bool pick) {
          if (pick) {
            MergingSet.push_back(Functions[selectCursor]);
          }
          if (selectCursor == Functions.size() - 1) {
            if (MergingSet.size() >= 2) {
              Planner.tryPlanMerge(MergingSet);
            }
          } else {
            FindProfitableSet(selectCursor + 1, true);
            FindProfitableSet(selectCursor + 1, false);
          }
          if (pick) {
            assert(MergingSet.back() == Functions[selectCursor]);
            MergingSet.pop_back();
          }
        };
    FindProfitableSet(1, true);
    FindProfitableSet(1, false);

    if (auto bestPlan = Planner.getBestPlan()) {
      auto plan = bestPlan->Plan;
      auto score = bestPlan->Score;

      // Emit remarks before replacing original functions with thunks.
      score.emitPassedRemark(plan, ORE);

      auto &Merged = plan.applyMerge(FAM, ORE);
      for (auto *F : plan.getFunctions()) {
        if (F == F1)
          continue;
        MatchFinder->remove_candidate(F);
      }
      MatchFinder->add_candidate(&Merged, score.MergedSize);
    }
  }

  return PreservedAnalyses::none();
}
