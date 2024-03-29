#ifndef LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H
#define LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/FunctionMergingOptions.h"
#include "llvm/Transforms/IPO/FunctionSizeEstimation.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include "llvm/Transforms/IPO/MergeAnnotation.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"

namespace llvm {

struct MSAStats {
  size_t NumSelection = 0;
};

class MSAThunkFunction {
  Function *SrcFunction;
  Function *Thunk;

  MSAThunkFunction(Function *SrcFunction, Function *Thunk)
      : SrcFunction(SrcFunction), Thunk(Thunk) {}

public:
  static MSAThunkFunction
  create(Function *MergedFunction, Function *SrcFunction, unsigned int FuncId,
         ValueMap<Argument *, unsigned int> &ArgToMergedArgNo);
  void applyReplacements();
  void discard();
  Function *getFunction() const { return Thunk; }
};

class MSACallReplacement {
  size_t FuncId;
  Function *SrcFunction;
  std::vector<WeakTrackingVH> Calls;
  SmallDenseMap<unsigned, unsigned> SrcArgNoToMergedArgNo;

  MSACallReplacement(size_t FuncId, Function *SrcFunction,
                     std::vector<WeakTrackingVH> Calls,
                     SmallDenseMap<unsigned, unsigned> SrcArgNoToMergedArgNo)
      : FuncId(FuncId), SrcFunction(SrcFunction), Calls(Calls),
        SrcArgNoToMergedArgNo(SrcArgNoToMergedArgNo) {}

public:
  static Optional<MSACallReplacement>
  create(size_t FuncId, Function *SrcFunction,
         ValueMap<Argument *, unsigned int> &ArgToMergedArgNo);
  void applyReplacements(Function *MergedFunction);
};

class MSAMergePlan {
  Function &Merged;
  std::vector<MSAThunkFunction> Thunks;
  std::vector<MSACallReplacement> CallReplacements;
  std::vector<Function *> Functions;
  FunctionMergingOptions Options;
  MSAStats Stats;

public:
  MSAMergePlan(Function &Merged, ArrayRef<Function *> Functions,
               FunctionMergingOptions Options, MSAStats Stats)
      : Merged(Merged), Functions(Functions), Options(Options), Stats(Stats) {}

  ArrayRef<Function *> getFunctions() const { return Functions; }
  Function &getMerged() const { return Merged; }
  void addThunk(MSAThunkFunction Thunk) { Thunks.push_back(Thunk); }
  void addCallReplacement(MSACallReplacement CallReplacement) {
    CallReplacements.push_back(CallReplacement);
  }

  struct Score {
    size_t MergedSize;
    size_t ThunkOverhead;
    size_t OriginalTotalSize;
    FunctionMergingOptions Options;
    MSAStats Stats;

    bool isProfitableMerge() const;
    bool isBetterThan(const Score &Other) const;
    void emitMissedRemark(ArrayRef<Function *> Functions,
                          OptimizationRemarkEmitter &ORE);
    void emitPassedRemark(MSAMergePlan &plan, OptimizationRemarkEmitter &ORE);
    size_t scalarScore() const {
      return OriginalTotalSize - MergedSize - ThunkOverhead;
    }

    void composite(const Score &Other);
  };

  Score computeScore(FunctionSizeEstimation &FSE);

  Function &applyMerge(OptimizationRemarkEmitter &ORE);
  void discard();
};

/// \brief This pass merges multiple functions into a single function by
/// multiple sequence alignment algorithm.
class MSAFunctionMerger {
  ArrayRef<Function *> Functions;
  Module *M;
  FunctionMerger &PairMerger;
  OptimizationRemarkEmitter &ORE;
  FunctionAnalysisManager &FAM;
  MergeAnnotations &Annotations;

  IntegerType *DiscriminatorTy;

public:
  MSAFunctionMerger(ArrayRef<Function *> Functions, FunctionMerger &PM,
                    OptimizationRemarkEmitter &ORE,
                    FunctionAnalysisManager &FAM,
                    MergeAnnotations &Annotations);

  FunctionMerger &getPairMerger() { return PairMerger; }

  Optional<MSAMergePlan> planMerge(FunctionMergingOptions Options = {});

  /// Returns `true` if successful and set Alignment. Otherwise, returns
  /// `false`.
  bool align(std::vector<MSAAlignmentEntry<>> &Alignment, bool &isProfitable,
             const FunctionMergingOptions Options = {});
};

class MSAGenFunctionBody;

class MSAGenFunction {
  Module *M;
  LLVMContext &C;
  const std::vector<MSAAlignmentEntry<>> &Alignment;
  const ArrayRef<Function *> &Functions;
  Optional<std::string> NameCache;
  IntegerType *DiscriminatorTy;

  IRBuilder<> Builder;

  OptimizationRemarkEmitter &ORE;

  friend class MSAGenFunctionBody;

public:
  MSAGenFunction(Module *M, const std::vector<MSAAlignmentEntry<>> &Alignment,
                 const ArrayRef<Function *> &Functions,
                 IntegerType *DiscriminatorTy, OptimizationRemarkEmitter &ORE)
      : M(M), C(M->getContext()), Alignment(Alignment), Functions(Functions),
        DiscriminatorTy(DiscriminatorTy), Builder(C), ORE(ORE) {
    assert(Functions.size() >= 2 && "At least two functions are required");
  };

  void layoutParameters(std::vector<std::pair<Type *, AttributeSet>> &Args,
                        ValueMap<Argument *, unsigned> &ArgToMergedIndex) const;
  bool layoutReturnType(Type *&RetTy);

  // Returns None if functions are not compatible.
  // Returns nullptr if no personality function is found.
  // Otherwise, returns a personality function pointer.
  Optional<Constant *> computePersonalityFn() const;

  FunctionType *
  createFunctionType(ArrayRef<std::pair<Type *, AttributeSet>> Args,
                     Type *RetTy);

  StringRef getFunctionName();

  Function *emit(const FunctionMergingOptions &Options, MSAStats &Stats,
                 ValueMap<Argument *, unsigned> &ArgToMergedArgNo);
};

class MultipleFunctionMergingPass
    : public PassInfoMixin<MultipleFunctionMergingPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};

} // namespace llvm

#endif
