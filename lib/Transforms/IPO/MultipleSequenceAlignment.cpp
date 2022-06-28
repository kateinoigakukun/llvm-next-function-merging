#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/TensorTable.h"
#include "llvm/ADT/Twine.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/InstIterator.h"
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

namespace {

using TransitionOffset = std::vector<size_t>;
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

class MSAligner {
  ScoringSystem &Scoring;
  ArrayRef<Function *> Functions;
  std::vector<size_t> Shape;

  std::vector<SmallVector<Value *, 16>> &InstrVecList;
  TensorTable<Optional<int32_t>> ScoreTable;
  TensorTable<TransitionEntry> BestTransTable;

  void initScoreTable();
  void buildAlignment(std::vector<llvm::MSAAlignmentEntry> &Alignment);
  void computeBestTransition(
      const std::vector<size_t> &Point,
      const std::function<bool(std::vector<size_t> Point)> Match);
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
        InstrVecList(InstrVecList), ScoreTable(Shape, None),
        BestTransTable(Shape, {}) {

    initScoreTable();
  }

public:
  static void align(FunctionMerger &PairMerger, ScoringSystem &Scoring,
                    ArrayRef<Function *> Functions,
                    std::vector<MSAAlignmentEntry> &Alignment);
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

  auto AddScore = [](int32_t Score, int32_t addend) {
    if (addend > 0 && Score >= INT32_MAX - addend)
      return INT32_MAX;
    if (addend < 0 && Score <= INT32_MIN - addend)
      return INT32_MIN;
    return Score + addend;
  };

  // Visit all possible transitions except for the current point itself.
  while (advancePointInShape(TransOffset, TransTableShape)) {
    if (!ScoreTable.contains(Point, TransOffset))
      continue;

    int32_t similarity =
        std::accumulate(TransOffset.begin(), TransOffset.end(), 0,
                        [&](int32_t Acc, size_t Val) {
                          return AddScore(Acc, TransScore[Val]);
                        });
    bool IsMatched = false;
    // If diagonal transition, add the match score.
    if (std::all_of(TransOffset.begin(), TransOffset.end(),
                    [](size_t v) { return v == 1; })) {
      IsMatched = Match(Point);
      similarity =
          IsMatched ? Scoring.getMatchProfit() : Scoring.getMismatchPenalty();
    }
    assert(ScoreTable[Point] && "non-visited point");
    auto fromScore = *ScoreTable[Point];
    int32_t newScore = AddScore(fromScore, similarity);
    int32_t maxScore;
    if (auto existingScore = ScoreTable.get(Point, TransOffset, false)) {
      maxScore = std::max(*existingScore, newScore);
    } else {
      maxScore = newScore;
    }
    if (maxScore == newScore) {
      ScoreTable.set(Point, TransOffset, false, maxScore);
      BestTransTable.set(Point, TransOffset, false,
                         TransitionEntry(TransOffset, IsMatched));
    }
  }
}

void MSAligner::buildAlignment(
    std::vector<llvm::MSAAlignmentEntry> &Alignment) {
  size_t MaxDim = BestTransTable.getShape().size();
  std::vector<size_t> Cursor(MaxDim, 0);

  auto BuildAlignmentEntry = [&](const TransitionEntry &Entry,
                                 std::vector<size_t> Cursor) {
    std::vector<Value *> Instrs;
    const std::vector<size_t> &TransOffset = Entry.Offset;
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
    Alignment.emplace_back(BuildAlignmentEntry(Entry, Cursor));
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
  do {
    computeBestTransition(Cursor, [&](std::vector<size_t> Point) {
      auto *TheInstr = InstrVecList[0][Point[0]];
      for (size_t i = 1; i < InstrVecList.size(); i++) {
        auto *OtherInstr = InstrVecList[i][Point[i]];
        if (!FunctionMerger::match(OtherInstr, TheInstr)) {
          return false;
        }
      }
      return true;
    });
  } while (advancePointInShape(Cursor, ScoreTable.getShape()));
  MSA_VERBOSE(llvm::dbgs() << "ScoreTable:\n"; ScoreTable.print(llvm::dbgs()));
  MSA_VERBOSE(llvm::dbgs() << "BestTransTable:\n";
              BestTransTable.print(llvm::dbgs()));

  buildAlignment(Alignment);

  return;
}

void MSAligner::align(FunctionMerger &PairMerger, ScoringSystem &Scoring,
                      ArrayRef<Function *> Functions,
                      std::vector<MSAAlignmentEntry> &Alignment) {
  std::vector<SmallVector<Value *, 16>> InstrVecList(Functions.size());
  std::vector<size_t> Shape;
  for (size_t i = 0; i < Functions.size(); i++) {
    auto &F = *Functions[i];
    PairMerger.linearize(&F, InstrVecList[i]);
    Shape.push_back(InstrVecList[i].size() + 1);
  }

  MSAligner Aligner(Scoring, Functions, Shape, InstrVecList);
  Aligner.align(Alignment);
}

}; // namespace

Optional<ArrayRef<Instruction *>> MSAAlignmentEntry::getAsInstructions() const {
  for (auto *V : Values) {
    if (!(V && isa<Instruction>(V))) {
      return None;
    }
  }
  return makeArrayRef((Instruction **)Values.data(), Values.size());
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

void MSAAlignmentEntry::dump() const {
  llvm::dbgs() << "MSAAlignmentEntry:\n";
  for (auto *V : Values) {
    if (V) {
      llvm::dbgs() << "- " << *V << "\n";
    } else {
      llvm::dbgs() << "-   nullptr\n";
    }
  }
}

void MSAFunctionMerger::align(std::vector<MSAAlignmentEntry> &Alignment) {
  MSAligner::align(PairMerger, Scoring, Functions, Alignment);
}

Function *MSAFunctionMerger::writeThunk(
    Function *MergedFunction, Function *SrcFunction, unsigned int FuncId,
    ValueMap<Argument *, unsigned int> &ArgToMergedArgNo) {
  auto *thunk = Function::Create(SrcFunction->getFunctionType(),
                                 SrcFunction->getLinkage(), "", M);
  thunk->setCallingConv(SrcFunction->getCallingConv());
  auto *BB = BasicBlock::Create(thunk->getContext(), "", thunk);
  IRBuilder<> Builder(BB);

  SmallVector<Value *, 16> Args(MergedFunction->arg_size(), nullptr);

  Args[0] = ConstantInt::get(DiscriminatorTy, FuncId);

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
  Call->setIsNoInline();

  if (SrcFunction->getReturnType()->isVoidTy()) {
    Builder.CreateRetVoid();
  } else {
    Builder.CreateRet(Call);
  }
  SrcFunction->replaceAllUsesWith(thunk);
  SrcFunction->eraseFromParent();
  thunk->takeName(SrcFunction);

  return thunk;
}

Function *MSAFunctionMerger::merge(MSAStats &Stats) {

  std::vector<MSAAlignmentEntry> Alignment;
  align(Alignment);

  FunctionMergingOptions Options;
  ValueMap<Argument *, unsigned> ArgToMergedArgNo;
  MSAGenFunction Generator(M, Alignment, Functions, DiscriminatorTy);
  auto *Merged = Generator.emit(Options, Stats, ArgToMergedArgNo);
  if (!Merged) {
    return nullptr;
  }

  if (verifyFunction(*Merged, &llvm::errs())) {
    LLVM_DEBUG(dbgs() << "Invalid merged function:\n");
    Merged->dump();
    Merged->removeFromParent();
    return nullptr;
  }

  for (size_t FuncId = 0; FuncId < Functions.size(); FuncId++) {
    auto *F = Functions[FuncId];
    writeThunk(Merged, F, FuncId, ArgToMergedArgNo);
  }

  return Merged;
}

namespace {

struct MSAOptions : public FunctionMergingOptions {
  size_t LSHRows = 2;
  size_t LSHBands = 100;

  MSAOptions() : FunctionMergingOptions() {}
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
  DenseMap<BasicBlock *, BasicBlock *> BBToMergedBB;
  std::vector<DenseMap<BasicBlock *, BasicBlock *>> MergedBBToBB;
  BasicBlock *EntryBB;
  BasicBlock *BlackholeBB;

public:
  MSAGenFunctionBody(const MSAGenFunction &Parent,
                     const FunctionMergingOptions &Options, MSAStats &Stats,
                     Value *Discriminator, ValueToValueMapTy &VMap,
                     Function *MergedF)
      : Parent(Parent), Options(Options), Stats(Stats), MergedFunc(MergedF),
        Discriminator(Discriminator), VMap(VMap), MaterialNodes(),
        BBToMergedBB(), MergedBBToBB(Parent.Functions.size()) {

    EntryBB = BasicBlock::Create(Parent.C, "entry", MergedFunc);
    BlackholeBB = BasicBlock::Create(Parent.C, "switch.blackhole", MergedFunc);
    {
      IRBuilder<> B(BlackholeBB);
      B.CreateUnreachable();
    }
  };

  inline LLVMContext &getContext() const { return Parent.C; }
  Type *getReturnType() const { return MergedFunc->getReturnType(); }
  IntegerType *getIntPtrType() const {
    return Parent.M->getDataLayout().getIntPtrType(Parent.C);
  }

  Instruction *cloneInstruction(IRBuilder<> &Builder, Instruction *I);
  BasicBlock *cloneBasicBlock(IRBuilder<> &Builder, BasicBlock *I);

  void layoutSharedBasicBlocks();
  void chainBasicBlocks();
  void chainEntryBlock();

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
    for (unsigned i = 0; i < NewI->getNumOperands(); i++) {
      if (!isa<Constant>(I->getOperand(i)))
        NewI->setOperand(i, nullptr);
    }
    Builder.Insert(NewI);
  }

  SmallVector<std::pair<unsigned, MDNode *>, 8> MDs;
  NewI->getAllMetadata(MDs);
  for (std::pair<unsigned, MDNode *> MDPair : MDs) {
    NewI->setMetadata(MDPair.first, nullptr);
  }

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

    auto *HeadV = Entry.getValues().front();
    StringRef BBName = [&]() {
      if (auto *BB = dyn_cast<BasicBlock>(HeadV)) {
        return BB->getName();
      } else if (auto *I = dyn_cast<Instruction>(HeadV)) {
        if (I->isTerminator()) {
          return StringRef("m.term.bb");
        } else {
          return StringRef("m.inst.bb");
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
      for (auto &I : Entry.getValues()) {
        VMap[I] = NewI;
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
            VMap[PI] = Builder.CreatePHI(PI->getType(), 0);
          }
        }

        MergedBBToBB[i][MergedBB] = BB;
      }
    }
  }
}

void MSAGenFunctionBody::chainBasicBlocks() {
  using FuncId = size_t;

  class SwitchChainer {
    using SwitchChain = std::vector<std::pair<FuncId, BasicBlock *>>;
    DenseMap<BasicBlock *, SwitchChain> ChainBySrcBB;
    const MSAGenFunctionBody &Parent;
  public:
    SwitchChainer(const MSAGenFunctionBody &Parent) : Parent(Parent) {}

    void chainBlocks(BasicBlock *SrcBB, BasicBlock *TargetBB, FuncId FuncId) {
      if (ChainBySrcBB.find(SrcBB) == ChainBySrcBB.end()) {
        ChainBySrcBB[SrcBB] = SwitchChain();
      }
      ChainBySrcBB[SrcBB].push_back(std::make_pair(FuncId, TargetBB));
    };

    void finalizeChain(BasicBlock *SrcBB, SwitchChain &Chain) {
      assert(!Chain.empty() && "Chain should have at least one dest!");

      bool singleTarget =
          std::all_of(Chain.begin(), Chain.end(),
                      [&](const std::pair<FuncId, BasicBlock *> &Pair) {
                        auto *TargetBB = Pair.second;
                        return Chain[0].second == TargetBB;
                      });

      IRBuilder<> Builder(SrcBB);
      if (singleTarget) {
        Builder.CreateBr(Chain[0].second);
        return;
      }

      SwitchInst *Switch =
          Builder.CreateSwitch(Parent.Discriminator, Parent.BlackholeBB);

      for (auto &FuncIdAndBB : Chain) {
        auto *TargetBB = FuncIdAndBB.second;
        auto *Var =
            ConstantInt::get(Parent.Parent.DiscriminatorTy, FuncIdAndBB.first);
        Switch->addCase(Var, TargetBB);
      }
    }

    void finalize() {
      for (auto &P : ChainBySrcBB) {
        finalizeChain(P.first, P.second);
      }
    }
  };

  SwitchChainer chainer(*this);

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

  auto ProcessBasicBlock = [&](BasicBlock *SrcBB,
                               DenseMap<BasicBlock *, BasicBlock *> &BlocksFX,
                               FuncId FuncId) {
    BasicBlock *LastMergedBB = nullptr;
    BasicBlock *NewBB = nullptr;
    auto FoundMerged = MaterialNodes.find(SrcBB);
    if (FoundMerged != MaterialNodes.end()) {
      LastMergedBB = FoundMerged->second;
    } else {
      std::string BBName = std::string("src.bb");
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
          VMap[PI] = Builder.CreatePHI(PI->getType(), 0);
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
          std::string BBName = "split.bb";
          NewBB =
              BasicBlock::Create(MergedFunc->getContext(), BBName);
          MergedFunc->getBasicBlockList().insertAfter(
              LastMergedBB->getIterator(), NewBB);
          chainer.chainBlocks(LastMergedBB, NewBB, FuncId);
          BlocksFX[NewBB] = SrcBB;
        }
        LastMergedBB = nullptr;

        IRBuilder<> Builder(NewBB);
        Instruction *NewI = this->cloneInstruction(Builder, &I);
        VMap[&I] = NewI;
      }
    }
  };

  for (size_t i = 0, e = Parent.Functions.size(); i < e; ++i) {
    auto *F = Parent.Functions[i];
    for (auto &BB : *F) {
      ProcessBasicBlock(&BB, MergedBBToBB[i], i);
    }
  }
  chainer.finalize();
}

void MSAGenFunctionBody::chainEntryBlock() {
  auto *MergedEntryV = MapValue(&Parent.Functions[0]->getEntryBlock(), VMap);
  assert(MergedEntryV && "Entry block not found! This method should be called "
                         "after chainBasicBlocks()");
  auto *MergedEntryBB = dyn_cast<BasicBlock>(MergedEntryV);
  assert(MergedEntryBB && "Merged entry block should be a basic block!");
  IRBuilder<> Builder(EntryBB);
  Builder.CreateBr(MergedEntryBB);
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
        if (V == nullptr) {
          LLVM_DEBUG(errs() << "ERROR: Null value mapped: V1 = "
                               "MapValue(I1->getOperand(i), VMap);\n");
          return false;
        }
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
    } else {
      auto *SelectBB = BasicBlock::Create(Parent.C, "bb.select", MergedFunc);
      IRBuilder<> BuilderBB(SelectBB);
      auto *Switch = BuilderBB.CreateSwitch(Discriminator, BlackholeBB);

      for (size_t FuncId = 0, e = Instructions.size(); FuncId < e; ++FuncId) {
        auto *I = Instructions[FuncId];
        // XXX: is this correct?
        MergedBBToBB[FuncId][SelectBB] = I->getParent();

        auto *Case = ConstantInt::get(Parent.DiscriminatorTy, FuncId);
        auto *BB = dyn_cast<BasicBlock>(Vs[FuncId]);
        Switch->addCase(Case, BB);
      }

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
        MergedBBToBB[FuncId][LPadBB] = Instructions[FuncId]->getParent();
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
  auto &BlocksReMap = MergedBBToBB[FuncId];

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

      BuilderBB.CreateBr(dyn_cast<BasicBlock>(V));

      V = LPadBB;
    }

    NewI->setOperand(i, V);
  }
  return true;
}

bool MSAGenFunctionBody::assignLabelOperands() {
  for (auto &Entry : Parent.Alignment) {
    ArrayRef<Instruction *> Instructions;
    if (auto Succeed = Entry.getAsInstructions()) {
      Instructions = *Succeed;
    } else {
      // Skip non-instructions
      continue;
    }

    // If instructions are merged, select new operand values by switch-phi.
    // Otherwise, just map original operand value to new value for each
    // instruction.
    if (Entry.match()) {
      if (!assignMergedInstLabelOperands(Instructions)) {
        LLVM_DEBUG(
            errs() << "ERROR: Failed to assign matching label operands\n";);
        return false;
      }
    } else {
      for (size_t FuncId = 0; FuncId < Parent.Functions.size(); ++FuncId) {
        auto *F = Parent.Functions[FuncId];
        auto *I = Instructions[FuncId];
        assert(I != nullptr && "Instruction should not be null!");
        if (!assignSingleInstLabelOperands(I, FuncId)) {
          return false;
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

  // TODO(katei): Handle 0, 1, .., n => Discriminator

  // TODO(katei): Priotize optimizable cases?
  // auto *IV1 = dyn_cast<Instruction>(V1);
  // auto *IV2 = dyn_cast<Instruction>(V2);

  // if (IV1 && IV2) {
  //   // if both IV1 and IV2 are non-merged values
  //   if (BlocksF2.find(IV1->getParent()) == BlocksF2.end() &&
  //       BlocksF1.find(IV2->getParent()) == BlocksF1.end()) {
  //     CoalescingCandidates[IV1][IV2]++;
  //     CoalescingCandidates[IV2][IV1]++;
  //   }
  // }

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
  auto *Switch = SwitchB.CreateSwitch(Discriminator, BlackholeBB);

  MergedI->getParent()->replaceAllUsesWith(SwitchBB);

  auto *AggregateBB = BasicBlock::Create(Parent.C, "bb.aggregate.values",
                                         MergedFunc, MergedI->getParent());
  IRBuilder<> AggregateB(AggregateBB);

  auto *PHI = AggregateB.CreatePHI(Values[0]->getType(), Values.size());
  AggregateB.CreateBr(MergedI->getParent());

  for (size_t FuncId = 0, e = Values.size(); FuncId < e; ++FuncId) {
    auto *Case = ConstantInt::get(Parent.DiscriminatorTy, FuncId);
    auto *BB = BasicBlock::Create(Parent.C, "bb.select.values", MergedFunc,
                                  AggregateBB);

    IRBuilder<> BuilderBB(BB);
    BuilderBB.CreateBr(AggregateBB);
    Switch->addCase(Case, BB);
    auto *V = Values[FuncId];
    assert(V != nullptr && "value should not be null!");
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
      // BB operands should be handled separately by assignLabelOperands
      if (isa<BasicBlock>(SrcI->getOperand(i)))
        continue;

      Value *V = MapValue(SrcI->getOperand(i), VMap);
      if (V == nullptr) {
        return false; // ErrorResponse;
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
    ArrayRef<Instruction *> Instructions;
    if (auto Succeed = Entry.getAsInstructions()) {
      Instructions = *Succeed;
    } else {
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
  // TODO(katei): Collect candidates in `mergeOperandValues`
  std::map<Instruction *, std::map<Instruction *, unsigned>>
      CoalescingCandidates;

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
          LLVM_DEBUG(errs() << "ERROR: Null operand\n");
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
        PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
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
          PHINode *PHI = Builder.CreatePHI(IV->getType(), 0);
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
    AllocaInst *Addr = Builder.CreateAlloca((*InstSet.begin())->getType());

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
        }
      };

  if (((float)OffendingInsts.size()) / ((float)Parent.Alignment.size()) > 4.5) {
    LLVM_DEBUG(errs() << "Bailing out\n");
    return false;
  }

  // errs() << "Fixing Domination:\n";
  // MergedFunc->dump();
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
    LLVM_DEBUG(errs() << "ERROR: Failed to assign label operands\n";);
    return false;
  }

  // 2. Assign value operands.
  if (!assignValueOperands()) {
    LLVM_DEBUG(errs() << "ERROR: Failed to assign value operands\n";);
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

        std::set<int> FoundIndices;

        for (auto It = pred_begin(NewPHI->getParent()),
                  E = pred_end(NewPHI->getParent());
             It != E; It++) {

          BasicBlock *NewPredBB = *It;

          Value *V = nullptr;

          if (BlocksReMap.find(NewPredBB) != BlocksReMap.end()) {
            int Index = PHI->getBasicBlockIndex(BlocksReMap[NewPredBB]);
            if (Index >= 0) {
              V = MapValue(PHI->getIncomingValue(Index), VMap);
              FoundIndices.insert(Index);
            }
          }

          if (V == nullptr)
            V = UndefValue::get(NewPHI->getType());

          // IRBuilder<> Builder(NewPredBB->getTerminator());
          // Value *CastedV = createCastIfNeeded(V, NewPHI->getType(), Builder,
          // IntPtrTy);
          NewPHI->addIncoming(V, NewPredBB);
        }
        if (FoundIndices.size() != PHI->getNumIncomingValues())
          return false;
      }
    }
    return true;
  };

  for (size_t FuncId = 0; FuncId < Parent.Functions.size(); FuncId++) {
    auto *F = Parent.Functions[FuncId];
    for (auto &BB : *F) {
      if (!AssignPHIOperandsInBlock(&BB, MergedBBToBB[FuncId])) {
        return false;
      }
    }
  }
  return true;
}

bool MSAGenFunctionBody::emit() {
  layoutSharedBasicBlocks();
  chainBasicBlocks();
  chainEntryBlock();
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

    for (size_t i = 0; i < Args.size(); i++) {
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

Function *
MSAGenFunction::emit(const FunctionMergingOptions &Options, MSAStats &Stats,
                     ValueMap<Argument *, unsigned> &ArgToMergedArgNo) {
  Type *RetTy;
  std::vector<std::pair<Type *, AttributeSet>> MergedArgs;

  layoutParameters(MergedArgs, ArgToMergedArgNo);
  if (!layoutReturnType(RetTy)) {
    // TODO(katei): should emit remarks?
    return nullptr;
  }
  auto *Sig = createFunctionType(MergedArgs, RetTy);

  auto *MergedF = Function::Create(Sig, llvm::GlobalValue::InternalLinkage,
                                   getFunctionName(), M);
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
    MergedF->removeFromParent();
    return nullptr;
  }

  return MergedF;
}

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI);

/// Check whether \p F is eligible to be a function merging candidate.
static bool isEligibleToBeMergeCandidate(Function &F) {
  return !F.isDeclaration() && !F.hasAvailableExternallyLinkage();
}

PreservedAnalyses MultipleFunctionMergingPass::run(Module &M,
                                                   ModuleAnalysisManager &MAM) {

  FunctionAnalysisManager &FAM =
      MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

  FunctionMerger PairMerger(&M);
  auto Options = MSAOptions();

  std::unique_ptr<Matcher<Function *>> MatchFinder =
      createMatcherLSH(PairMerger, Options, Options.LSHRows, Options.LSHBands);

  size_t count = 0;
  for (auto &F : M) {
    if (!isEligibleToBeMergeCandidate(F))
      continue;
    MatchFinder->add_candidate(
        &F, EstimateFunctionSize(&F, &FAM.getResult<TargetIRAnalysis>(F)));
    count++;
  }

  FunctionPassManager FPM;
  FPM.addPass(SimplifyCFGPass());

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

    LLVM_DEBUG(dbgs() << "Try to merge\n");
    LLVM_DEBUG(for (auto *F
                    : Functions) { dbgs() << " - " << F->getName() << "\n"; });
    MSAStats Stats;
    MSAFunctionMerger FM(Functions, PairMerger);
    auto MergedFunction = FM.merge(Stats);
    if (!MergedFunction) {
      LLVM_DEBUG(dbgs() << "Merge failed\n");
      continue;
    }
    for (auto *F : Functions) {
      if (F == F1)
        continue;
      MatchFinder->remove_candidate(F);
    }
    FPM.run(*MergedFunction, FAM);
  }

  return PreservedAnalyses::none();
}
