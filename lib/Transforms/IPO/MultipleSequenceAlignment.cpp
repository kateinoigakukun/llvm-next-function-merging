#include "llvm/Transforms/IPO/MultipleSequenceAlignment.h"
#include "FunctionMergingUtils.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/ADT/SmallBitVector.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
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
#include "llvm/Transforms/IPO/MSA/MSAAlignmentEntry.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"
#include "llvm/Transforms/Scalar/InstSimplifyPass.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include "llvm/Transforms/Utils/PromoteMemToReg.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <memory>
#include <numeric>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

#define DEBUG_TYPE "multiple-func-merging"
#define MSA_VERBOSE(X) DEBUG_WITH_TYPE("multiple-func-merging-verbose", X)

using namespace llvm;

static cl::opt<size_t> DefaultShapeSizeLimit(
    "multiple-func-merging-shape-limit", cl::init(24 * 1024 * 1024), cl::Hidden,
    cl::desc("The shape size limit for the multiple function merging"));

static cl::opt<size_t>
    MaxNumSelection("multiple-func-merging-max-selects", cl::init(500),
                    cl::Hidden,
                    cl::desc("Maximum number of allowed operand selection"));

static cl::opt<bool> AllowUnprofitableMerge(
    "multiple-func-merging-allow-unprofitable", cl::init(false), cl::Hidden,
    cl::desc("Allow merging functions that are not profitable"));

static cl::opt<bool>
    IdenticalType("multiple-func-merging-identical-type", cl::init(false), cl::Hidden,
                  cl::desc("Match only values with identical types"));

static cl::opt<bool>
    EnableHyFMNW("multiple-func-merging-hyfm-nw", cl::init(false), cl::Hidden,
                 cl::desc("Enable HyFM with the Pairwise Alignment"));

static cl::opt<bool> EnableSALSSACoalescing(
    "multiple-func-merging-coalescing", cl::init(true), cl::Hidden,
    cl::desc("Enable phi-node coalescing during SSA reconstruction"));

static cl::opt<bool>
    HasWholeProgram("multiple-func-merging-whole-program", cl::init(false),
                    cl::Hidden,
                    cl::desc("Function merging applied on whole program"));

static cl::list<std::string>
    OnlyFunctions("multiple-func-merging-only", cl::Hidden,
                  cl::desc("Merge only the specified functions"));

static cl::opt<bool> DisablePostOpt(
    "multiple-func-merging-disable-post-opt", cl::init(false), cl::Hidden,
    cl::desc("Disable post-optimization of the merged function"));

static cl::opt<bool> EnableStats(
    "multiple-func-merging-stats", cl::init(false), cl::Hidden,
    cl::desc("Enable statistics for the multiple function merging"));

namespace {

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


}; // namespace

bool MSAFunctionMerger::align(std::vector<MSAAlignmentEntry<>> &Alignment,
                              bool &isProfitable,
                              const FunctionMergingOptions &Options) {
  TimeTraceScope TimeScope("Align");

  constexpr auto Ty = MSAAlignmentEntryType::Variable;
  std::unique_ptr<MultipleSequenceAligner<Ty>> Aligner;
  std::unique_ptr<NeedlemanWunschMultipleSequenceAligner<Ty>> NWAligner;
  if (Options.EnableHyFMAlignment) {
    NWAligner = std::make_unique<NeedlemanWunschMultipleSequenceAligner<Ty>>(
        PairMerger, Scoring, DefaultShapeSizeLimit, Options);
    Aligner = std::make_unique<HyFMMultipleSequenceAligner<Ty>>(
        *NWAligner.get(), Options);
  } else {
    Aligner = std::make_unique<NeedlemanWunschMultipleSequenceAligner<Ty>>(
        PairMerger, Scoring, DefaultShapeSizeLimit, Options);
  }
  return Aligner->align(Functions, Alignment, isProfitable, &ORE);
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
MSAFunctionMerger::planMerge(FunctionMergingOptions Options) {
  MSAStats Stats;
  std::vector<MSAAlignmentEntry<>> Alignment;
  bool isProfitable = true;
  if (!align(Alignment, isProfitable, Options)) {
    return None;
  }
  if (!isProfitable && !AllowUnprofitableMerge) {
    ORE.emit([&] {
      return createMissedRemark("UnprofitableMerge", "Unprofitable alignment",
                                Functions);
    });
    return None;
  }

  LLVM_DEBUG(for (auto &AE : Alignment) { AE.dump(); };);

  ValueMap<Argument *, unsigned> ArgToMergedArgNo;
  MSAGenFunction Generator(M, Alignment, Functions, DiscriminatorTy, ORE);
  auto *Merged = Generator.emit(Options, Stats, ArgToMergedArgNo);
  if (!Merged) {
    return None;
  }

  {
    TimeTraceScope TimeScope("VerifyMerge");
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
  }

  if (!DisablePostOpt) {
    TimeTraceScope TimeScope("PostOpt");
    FunctionPassManager FPM;
    FPM.addPass(SimplifyCFGPass());
    FPM.addPass(InstSimplifyPass());

    FPM.run(*Merged, FAM);
  }

  MSAMergePlan plan(*Merged, Functions, Options, Stats);

  for (size_t FuncId = 0; FuncId < Functions.size(); FuncId++) {
    auto *F = Functions[FuncId];
    if (!F->hasAddressTaken() &&
        (HasWholeProgram || F->isDiscardableIfUnused())) {
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

  static Instruction *cloneInstruction(IRBuilder<> &Builder,
                                       const Instruction *I);
  static Value *tryBitcast(IRBuilder<> &Builder, Value *V, Type *Ty,
                           const Twine &Name = "");

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

Instruction *MSAGenFunctionBody::cloneInstruction(IRBuilder<> &Builder,
                                                  const Instruction *I) {
  return fmutils::InstructionCloner::clone(Builder, I);
}

Value *MSAGenFunctionBody::tryBitcast(IRBuilder<> &Builder, Value *V,
                                      Type *DestTy, const Twine &Name) {
  // 1. If the value type is already the same as the destination type, return it
  // as is.
  if (V->getType() == DestTy) {
    return V;
  }
  // 2. If the value type is a pointer type, and the destination type is a
  // pointer type, and the value type and the destination type have the same
  // address space, ptrcast it.
  if (V->getType()->isPointerTy() && DestTy->isPointerTy() &&
      V->getType()->getPointerAddressSpace() ==
          DestTy->getPointerAddressSpace()) {
    return Builder.CreatePointerCast(V, DestTy, Name);
  }
  // 3. If the value type is a pointer type, and the destination type is an
  // integer type, ptrtoint the value and return it.
  if (V->getType()->isPointerTy() && DestTy->isIntegerTy()) {
    return Builder.CreatePtrToInt(V, DestTy, Name);
  }
  // 4. If the value type is an integer type, and the destination type is a
  // pointer type, inttoptr the value and return it.
  if (V->getType()->isIntegerTy() && DestTy->isPointerTy()) {
    return Builder.CreateIntToPtr(V, DestTy, Name);
  }
  return Builder.CreateBitCast(V, DestTy, Name);
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
        if (V == nullptr && isa<LandingPadInst>(FV)) {
          // FIXME(katei): SalSSA unsoundness?
          // SalSSA depends on the order of "invoke" and "landingpad"
          // instructions. In most cases, "invoke" is processed before
          // "landingpad", thanks to the order of the invoker BB and the
          // landingpad BB **in linearized aligned instruction sequence**.
          // e.g. SalSSA works well for the following code:
          //   entry:
          //   invoke void @foo() to label %invoke.cont unwind label %lpad
          //   lpad:
          //   (%l = landingpad { i8*, i32 })
          //   %e = extractvalue { i8*, i32 } %l, 0
          //
          // In this case, SalSSA's label operand assignment phase visits the
          // top BB first and then the bottom BB at last. So "invoke" is visited
          // at first, then its landingpad label is recognized and a new
          // landingpad BB is created. "landingpad" instruction itself is
          // ignored at alignment phase, so it's skipped. (see Section "4.2.2
          // Landing Blocks" in the SalSSA paper). Finally, the use of the
          // landingpad instruction "%e" is visited and the label operand is
          // already in VMap, so it works well.
          //
          // However, the linear order of the BBs is not guaranteed and can have
          // different orders for the same CFG like:
          //   lpad:
          //   (%l = landingpad { i8*, i32 })
          //   %e = extractvalue { i8*, i32 } %l, 0
          //   entry:
          //   invoke void @foo() to label %invoke.cont unwind label %lpad
          //
          // In this case, the use of the landingpad instruction "%e" is visited
          // before "landingpad" is assigned in VMap. So the below assertion can
          // fails.
          //
          // We leave this as a known issue for now to follow the baseline
          // codegen behavior.
          return false;
        }
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
    MSAAlignmentEntry<> Entry = *it;
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
    V2 = tryBitcast(BuilderBB, V2, V1->getType(), "select.bitcast");
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
    Stats.NumSelection++;
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
    V = tryBitcast(BuilderBB, V, PHI->getType(), "switch.select.bitcast");
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
      if (!fmutils::InstructionCloner::isLocalValue(Op))
        continue;

      Value *V = MapValue(Op, VMap);
      if (V == nullptr) {
        return false; // ErrorResponse;
      }
      V = tryBitcast(Builder, V, Op->getType(), "valuemap.bitcast");
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
    if (EnableSALSSACoalescing) {
      OptimizeCoalescing(I, InstSet, CoalescingCandidates, Visited);
    }

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
      auto *PHI = dyn_cast<PHINode>(&I);
      if (!PHI) {
        continue; // Not a PHI node.
      }
      auto *NewPHI = dyn_cast<PHINode>(VMap[PHI]);

      // Reuse the incoming values if already computed.
      // Without this, PHI node can have multiple entries for the
      // same basic block with different incoming values due to bitcast
      // insertions.
      SmallDenseMap<BasicBlock *, Value *> IncomingValuesCache;

      for (auto It = pred_begin(NewPHI->getParent()),
                E = pred_end(NewPHI->getParent());
           It != E; It++) {

        BasicBlock *NewPredBB = *It;

        Value *V = IncomingValuesCache[NewPredBB];

        if (V == nullptr) {
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
          IRBuilder<> Builder(NewPredBB->getTerminator());
          V = tryBitcast(Builder, V, NewPHI->getType(), "phicoalesce.bitcast");
          IncomingValuesCache[NewPredBB] = V;
        }

        NewPHI->addIncoming(V, NewPredBB);
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

  DenseMap<size_t, SmallVector<Argument *, 4>> IndexToMergedArgs;

  auto ComputeMatchScore = [&](Argument *srcArg, size_t candArgIdx) -> size_t {
    auto &otherArgs = IndexToMergedArgs[candArgIdx];
    size_t score = 0;
    for (auto &Entry : Alignment) {
      if (!Entry.match()) {
        continue;
      }
      bool argUsed = false;
      size_t argUsedOperandIdx = 0;

      // 1. Check if the srcArg is used in the matching instructions.
      for (Value *V : Entry.getValues()) {
        auto *I = dyn_cast<Instruction>(V);
        if (!I) {
          continue;
        }
        for (size_t i = 0; i < I->getNumOperands(); i++) {
          if (I->getOperand(i) == srcArg) {
            argUsed = true;
            argUsedOperandIdx = i;
            break;
          }
        }
        if (argUsed) {
          break;
        }
      }
      if (!argUsed) {
        continue;
      }
      // 2. Check how mnay the instructions that do not use the srcArg use
      //    other arguments.
      size_t matchingInsts = 0;
      for (Value *V : Entry.getValues()) {
        auto *I = dyn_cast<Instruction>(V);
        if (!I) {
          continue;
        }
        if (I->getNumOperands() <= argUsedOperandIdx) {
          continue;
        }
        for (auto *otherArg : otherArgs) {
          if (I->getOperand(argUsedOperandIdx) != otherArg) {
            continue;
          }
          matchingInsts++;
        }
      }

      if (!argUsed) {
        continue;
      }
      score += matchingInsts;
    }
    return score;
  };

  size_t preservedArgs = Args.size();
  auto FindReusableArg =
      [&](Argument *srcArg, AttributeSet srcAttr,
          const std::set<unsigned> &reusedArgs) -> Optional<size_t> {
    // Find the best argument to reuse based on the uses to
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

    Optional<size_t> bestScore;
    Optional<size_t> bestArgIndex;
    for (size_t i = preservedArgs; i < Args.size(); i++) {
      Type *ty;
      AttributeSet attr;
      std::tie(ty, attr) = Args[i];

      if (ty != srcArg->getType())
        continue;
      if (attr != srcAttr)
        continue;
      // If the argument is already reused, we can't reuse it again for the
      // function.
      if (reusedArgs.find(i) != reusedArgs.end())
        continue;

      size_t score = ComputeMatchScore(srcArg, i);
      if (!bestScore || score > bestScore) {
        bestScore = score;
        bestArgIndex = i;
      }
    }
    return bestArgIndex;
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
        if (IndexToMergedArgs.find(*found) == IndexToMergedArgs.end()) {
          IndexToMergedArgs[*found] = {&arg};
        } else {
          IndexToMergedArgs[*found].push_back(&arg);
        }
        auto inserted = usedArgIndices.insert(*found).second;
        assert(inserted && "Argument already reused!");
      } else {
        Args.emplace_back(arg.getType(), argAttr);
        auto newArgIdx = Args.size() - 1;
        ArgToMergedIndex[&arg] = newArgIdx;
        if (IndexToMergedArgs.find(newArgIdx) == IndexToMergedArgs.end()) {
          IndexToMergedArgs[newArgIdx] = {&arg};
        } else {
          llvm_unreachable("Argument must not be used before");
        }
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
    Type *Ty = F->getReturnType();
    if (TheReTy == nullptr) {
      if (Ty->isVoidTy()) {
        return true;
      }
      TheReTy = Ty;
      return true;
    } else if (TheReTy == Ty || Ty->isVoidTy()) {
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
  if (TheReTy == nullptr)
    TheReTy = Type::getVoidTy(M->getContext());
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
  TimeTraceScope TimeScope("CodeGen");
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
    // Insert the new call after the old one. The old call will be
    // replaced/erased
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

    // If the source return type is void, we can just discard the unified return
    // value. Otherwise, we need to cast it to the source return type.
    if (!SrcFunction->getReturnType()->isVoidTy()) {
      auto Replacement = MSAGenFunctionBody::tryBitcast(
          Builder, NewCB, SrcFunction->getReturnType());
      CI->replaceAllUsesWith(Replacement);
    } else {
      assert(CI->getNumUses() == 0 && "void function should not have any uses");
    }

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
    ThunkOverhead += Merged.getFunctionType()->getNumParams();
  }
  return Score{
      .MergedSize = MergedSize,
      .ThunkOverhead = ThunkOverhead,
      .OriginalTotalSize = OriginalTotalSize,
      .Options = Options,
      .Stats = Stats,
  };
}

bool MSAMergePlan::Score::isProfitableMerge() const {
  if (AllowUnprofitableMerge || !OnlyFunctions.empty()) {
    return true;
  }
  if (Stats.NumSelection > MaxNumSelection) {
    return false;
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
                << ore::NV("OriginalTotalSize", OriginalTotalSize)
                << ore::NV("IdenticalTypesOnly", Options.IdenticalTypesOnly)
                << ore::NV("NumSelection", Stats.NumSelection);
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
           << ore::NV("OriginalTotalSize", OriginalTotalSize)
           << ore::NV("IdenticalTypesOnly", Options.IdenticalTypesOnly);
    return remark;
  });
}

bool MSAMergePlan::Score::isBetterThan(const MSAMergePlan::Score &Other) const {
  return (MergedSize + ThunkOverhead + Other.OriginalTotalSize) <
         (Other.MergedSize + Other.ThunkOverhead + OriginalTotalSize);
}

Function &MSAMergePlan::applyMerge(FunctionAnalysisManager &FAM,
                                   OptimizationRemarkEmitter &ORE) {
  TimeTraceScope TimeScope("ApplyMerge");
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

/// Check whether \p F is eligible to be a function merging candidate.
static bool isEligibleToBeMergeCandidate(Function &F) {
  if (F.isDeclaration() || F.hasAvailableExternallyLinkage()) {
    return false;
  }
  if (F.isVarArg()) {
    return false;
  }
  if (!HasWholeProgram && F.hasAvailableExternallyLinkage()) {
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
    MSAOptions Opt = BaseOpt;
    Opt.matchOnlyIdenticalTypes(IdenticalTypesOnly);
    Opt.EnableHyFMAlignment = EnableHyFMNW;

    MSAFunctionMerger FM(Functions, PairMerger, ORE, FAM);
    auto maybePlan = FM.planMerge(Opt);
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

  timeTraceProfilerBegin("MultipleFunctionMergingPass", "run");
  FunctionAnalysisManager &FAM =
      MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

  FunctionMerger PairMerger(&M);
  auto Options = MSAOptions();

  std::unique_ptr<Matcher<Function *>> MatchFinder;
  {
    TimeTraceScope TimeScope("CreateMatcher");
    MatchFinder = createMatcherLSH(PairMerger, Options, Options.LSHRows,
                                   Options.LSHBands);
  }

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
    Planner.tryPlanMerge(Functions, false);
    Planner.tryPlanMerge(Functions, true);
    MSAFunctionMerger FM(Functions, PairMerger, ORE, FAM);
    if (auto result = Planner.getBestPlan()) {
      auto &plan = result->Plan;
      auto score = plan.computeScore(FAM);
      score.emitPassedRemark(plan, ORE);
      auto &Merged = plan.applyMerge(FAM, ORE);
    }
    return PreservedAnalyses::none();
  }

  {
    TimeTraceScope TimeScope("IndexCandidates");
    for (auto &F : M) {
      if (!isEligibleToBeMergeCandidate(F))
        continue;
      MatchFinder->add_candidate(
          &F, EstimateFunctionSize(&F, &FAM.getResult<TargetIRAnalysis>(F)));
    }
  }

  bool Changed = false;

  while (MatchFinder->size() > 0) {
    TimeTraceScope TimeScope("ProcessSimilarSet");
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
              if (!IdenticalType) {
                Planner.tryPlanMerge(MergingSet, false);
              }
              Planner.tryPlanMerge(MergingSet, true);
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

  timeTraceProfilerEnd();

  if (EnableStats) {
    std::unique_ptr<raw_ostream> OutStream = llvm::CreateInfoOutputFile();
    llvm::PrintStatistics(*OutStream);
  }
  return PreservedAnalyses::none();
}
