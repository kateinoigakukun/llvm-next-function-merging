#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
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
      : PairMerger(M), Scoring(/*Gap*/ 1, /*Match*/ 0, /*Mismatch*/ 1), M(M) {}

  FunctionMerger &getPairMerger() { return PairMerger; }

  void align(const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
             std::vector<MSAAlignmentEntry> &Alignment);
  MSAFunctionMergeResult merge(ArrayRef<Function *> Functions);
  void merge(ArrayRef<Function *> Functions,
             const SmallVectorImpl<SmallVectorImpl<Value *> *> &InstrVecRefList,
             const std::vector<MSAAlignmentEntry> &Alignment);
};

class MSAGenFunctionBody;

class MSAGenFunction {
  Module *M;
  LLVMContext &C;
  const std::vector<MSAAlignmentEntry> &Alignment;
  const ArrayRef<Function *> &Functions;
  Optional<std::string> NameCache;
  IntegerType *DiscriminatorTy;

  IRBuilder<> Builder;

  friend class MSAGenFunctionBody;

public:
  MSAGenFunction(Module *M, const std::vector<MSAAlignmentEntry> &Alignment,
                 const ArrayRef<Function *> &Functions)
      : M(M), C(M->getContext()), Alignment(Alignment), Functions(Functions),
        DiscriminatorTy(IntegerType::getInt32Ty(C)), Builder(C){};

  void layoutParameters(std::vector<std::pair<Type *, AttributeSet>> &Args,
                        ValueMap<Argument *, unsigned> &ArgToMergedIndex);
  bool layoutReturnType(Type *&RetTy);
  FunctionType *
  createFunctionType(ArrayRef<std::pair<Type *, AttributeSet>> Args,
                     Type *RetTy);

  StringRef getFunctionName();

  Function *emit(const FunctionMergingOptions &Options = {});
};

class MSAGenFunctionBody {
  const MSAGenFunction &Parent;
  const FunctionMergingOptions &Options;
  Function *MergedFunc;

  Value *Discriminator;
  ValueToValueMapTy &VMap;
  // FIXME(katei): Better name?
  DenseMap<Value *, BasicBlock *> MaterialNodes;
  DenseMap<BasicBlock *, BasicBlock *> BBToMergedBB;
  std::vector<DenseMap<BasicBlock *, BasicBlock *>> MergedBBToBB;
  BasicBlock *BlackholeBB;

public:
  MSAGenFunctionBody(const MSAGenFunction &Parent,
                     const FunctionMergingOptions &Options,
                     Value *Discriminator, ValueToValueMapTy &VMap,
                     Function *MergedF)
      : Parent(Parent), Options(Options), MergedFunc(MergedF),
        Discriminator(Discriminator), VMap(VMap), MaterialNodes(),
        BBToMergedBB(), MergedBBToBB(Parent.Functions.size()) {

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

  // XXX(katei): This method name is wrong and should be changed to something
  // more descriptive.
  bool assignMatchingLabelOperands(ArrayRef<Instruction *> Instructions);
  bool assignMismatchingLabelOperands(
      Instruction *I, DenseMap<BasicBlock *, BasicBlock *> &BlocksReMap);
  Value *mergeValues(ArrayRef<Value *> Values, Instruction *InsertPt);
  bool assignValueOperands();
  /// Assign new value operands. Return true if all operands are assigned.
  /// Return false if failed to assign any operand.
  bool assignOperands(Instruction *I);
  bool assignOperands();

  void emit();

  /// Reorder the operands to minimize the number of `select`
  static void operandReordering(std::vector<std::vector<Value *>> Operands);
  static Instruction *
  maxNumOperandsInstOf(ArrayRef<Instruction *> Instructions);
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

  bool contains(const std::vector<size_t> &Point,
                std::vector<size_t> Offset) const {
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
      similarity =
          IsMatched ? Scoring.getMatchProfit() : Scoring.getMismatchPenalty();
    }
    int32_t fromCost = ScoreTable[Point];
    assert(fromCost != INT32_MAX && "non-visited point");
    int32_t cost = fromCost + similarity;
    int32_t minCost = std::min(ScoreTable.get(Point, TransOffset, false), cost);
    if (minCost == cost) {
      ScoreTable.set(Point, TransOffset, false, minCost);
      BestTransTable.set(Point, TransOffset, false,
                         std::make_pair(TransOffset, IsMatched));
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
    Alignment.emplace_back(buildAlignmentEntry(Entry, Cursor, InstrVecRefList));
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

bool MSAAlignmentEntry::match() const { return IsMatched; }

ArrayRef<Value *> MSAAlignmentEntry::getValues() const { return Values; }

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

} // namespace

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI);

/// Check whether \p F is eligible to be a function merging candidate.
static bool isEligibleToBeMergeCandidate(Function &F) {
  return !F.isDeclaration() && !F.hasAvailableExternallyLinkage();
}

PreservedAnalyses MultipleFunctionMergingPass::run(Module &M,
                                                   ModuleAnalysisManager &MAM) {

  FunctionAnalysisManager &FAM =
      MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

  MSAFunctionMerger FM(&M);
  auto Options = MSAOptions();

  std::unique_ptr<Matcher<Function *>> MatchFinder = createMatcherLSH(
      FM.getPairMerger(), Options, Options.LSHRows, Options.LSHBands);

  size_t count = 0;
  for (auto &F : M) {
    if (!isEligibleToBeMergeCandidate(F))
      continue;
    MatchFinder->add_candidate(
        &F, EstimateFunctionSize(&F, &FAM.getResult<TargetIRAnalysis>(F)));
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

    LLVM_DEBUG(dbgs() << "Try to merge\n");
    LLVM_DEBUG(for (auto *F : Functions) { dbgs() << " - " << F->getName() << "\n"; });
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

  std::string Name = "__msa_merge_";
  for (auto &F : Functions) {
    Name += F->getName();
    Name += "_";
  }
  this->NameCache = Name;
  return *this->NameCache;
}

Function *MSAGenFunction::emit(const FunctionMergingOptions &Options) {
  Type *RetTy;
  std::vector<std::pair<Type *, AttributeSet>> MergedArgs;
  ValueMap<Argument *, unsigned> ArgToMergedIndex;

  layoutParameters(MergedArgs, ArgToMergedIndex);
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
      VMap[&arg] = MergedF->getArg(ArgToMergedIndex[&arg]);
    }
  }

  MSAGenFunctionBody BodyEmitter(*this, Options, discriminator, VMap, MergedF);
  BodyEmitter.emit();

  MergedF->dump();
  return MergedF;
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

  auto ChainBlocks = [&](BasicBlock *SrcBB, BasicBlock *TargetBB,
                         size_t FuncId) {
    IRBuilder<> Builder(SrcBB);
    SwitchInst *Switch;
    if (SrcBB->getTerminator() == nullptr) {
      Switch = Builder.CreateSwitch(Discriminator, BlackholeBB);
    } else {
      Switch = dyn_cast<SwitchInst>(SrcBB->getTerminator());
    }
    auto *Var = ConstantInt::get(Parent.DiscriminatorTy, FuncId);
    Switch->addCase(Var, TargetBB);
  };

  auto ProcessBasicBlock = [&](BasicBlock *SrcBB,
                               DenseMap<BasicBlock *, BasicBlock *> &BlocksFX,
                               size_t FuncId) {
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
          ChainBlocks(LastMergedBB, NodeBB, FuncId);
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
              BasicBlock::Create(MergedFunc->getContext(), BBName, MergedFunc);
          ChainBlocks(LastMergedBB, NewBB, FuncId);
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

bool MSAGenFunctionBody::assignMatchingLabelOperands(
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

bool MSAGenFunctionBody::assignMismatchingLabelOperands(
    Instruction *I, DenseMap<BasicBlock *, BasicBlock *> &BlocksReMap) {
  auto *NewI = dyn_cast<Instruction>(VMap[I]);

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

Value *MSAGenFunctionBody::mergeValues(ArrayRef<Value *> Values,
                                       Instruction *InsertPt) {
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

  IRBuilder<> Builder(InsertPt);
  auto *Switch = Builder.CreateSwitch(Discriminator, BlackholeBB);
  auto *PHI = Builder.CreatePHI(Values[0]->getType(), Values.size());
  for (size_t FuncId = 0, e = Values.size(); FuncId < e; ++FuncId) {
    auto *Case = ConstantInt::get(Parent.DiscriminatorTy, FuncId);
    auto *BB = BasicBlock::Create(Parent.C, "bb.select", MergedFunc);
    IRBuilder<> BuilderBB(BB);
    Switch->addCase(Case, BB);
    auto *V = Values[FuncId];
    assert(V != nullptr && "value should not be null!");
    PHI->addIncoming(V, BB);
  }
  return PHI;
}

/// Taken from FunctionMergable.cpp
/// TODO(katei): share the declaration with the original function.
Value *createCastIfNeeded(Value *V, Type *DstType, IRBuilder<> &Builder,
                          Type *IntPtrTy,
                          const FunctionMergingOptions &Options = {});

bool MSAGenFunctionBody::assignOperands(Instruction *I) {
  auto *NewI = dyn_cast<Instruction>(VMap[I]);
  IRBuilder<> Builder(NewI);

  if (I->getOpcode() == Instruction::Ret && Options.EnableUnifiedReturnType) {
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
    for (unsigned i = 0; i < I->getNumOperands(); i++) {
      if (isa<BasicBlock>(I->getOperand(i)))
        continue;

      Value *V = MapValue(I->getOperand(i), VMap);
      if (V == nullptr) {
        return false; // ErrorResponse;
      }

      NewI->setOperand(i, V);
    }
  }

  return true;
}

bool MSAGenFunctionBody::assignValueOperands() {
  for (auto &Entry : Parent.Alignment) {
    ArrayRef<Instruction *> Instructions;
    if (auto Succeed = Entry.getAsInstructions()) {
      Instructions = *Succeed;
    } else {
      for (auto *V : Entry.getValues()) {
        if (V == nullptr)
          continue;

        auto *I = dyn_cast<Instruction>(V);
        if (I != nullptr && !assignOperands(I)) {
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

      std::vector<std::vector<Value *>> Operands;
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
        Value *V = mergeValues(Vs, NewI);

        if (V == nullptr) {
          LLVM_DEBUG(errs() << "Could Not select:\n"
                            << "ERROR: Value should NOT be null\n");
          return false; // ErrorResponse;
        }

        Value *CastedV = createCastIfNeeded(V, NewI->getOperand(i)->getType(),
                                            Builder, getIntPtrType());
        NewI->setOperand(i, CastedV);
      }
    } else {
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

        Value *V = mergeValues(Vs, NewI);
        if (V == nullptr) {
          LLVM_DEBUG(errs() << "Could Not select:\n"
                            << "ERROR: Value should NOT be null\n";);
          return false; // ErrorResponse;
        }

        NewI->setOperand(OperandIdx, V);
      }
    }
  }
  return true;
}

bool MSAGenFunctionBody::assignOperands() {
  for (auto &Entry : Parent.Alignment) {
    ArrayRef<Instruction *> Instructions;
    if (auto Succeed = Entry.getAsInstructions()) {
      Instructions = *Succeed;
    } else {
      // Skip non-instructions
      continue;
    }

    if (Entry.match()) {
      if (!assignMatchingLabelOperands(Instructions)) {
        LLVM_DEBUG(
            errs() << "ERROR: Failed to assign matching label operands\n";);
        return false;
      }
    } else {
      for (size_t FuncId = 0; FuncId < Parent.Functions.size(); ++FuncId) {
        auto *F = Parent.Functions[FuncId];
        auto *I = Instructions[FuncId];
        assert(I != nullptr && "Instruction should not be null!");
        if (!assignMismatchingLabelOperands(I, MergedBBToBB[FuncId])) {
          return false;
        }
      }
    }
  }
  /* TODO(katei): enable after fixing the misalignment issue
  if (!assignValueOperands()) {
    LLVM_DEBUG(errs() << "ERROR: Failed to assign value operands\n";);
    return false;
  }
  */
  return true;
}

void MSAGenFunctionBody::emit() {
  layoutSharedBasicBlocks();
  chainBasicBlocks();
  assert(assignOperands() && "Failed to assign operands!");
}
