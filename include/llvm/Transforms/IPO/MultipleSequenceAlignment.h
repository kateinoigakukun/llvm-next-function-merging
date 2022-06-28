#ifndef LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H
#define LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"

namespace llvm {

class MSAAlignmentEntry {
  std::vector<Value *> Values;
  bool IsMatched;

public:
  MSAAlignmentEntry(std::vector<Value *> Values, bool IsMatched)
      : Values(Values), IsMatched(IsMatched) {}

  bool match() const { return IsMatched; }
  ArrayRef<Value *> getValues() const { return Values; }
  Optional<ArrayRef<Instruction *>> getAsInstructions() const;
  void verify() const;
  void dump() const;
};

struct MSAStats {
  unsigned NumSelection;
};

/// \brief This pass merges multiple functions into a single function by
/// multiple sequence alignment algorithm.
class MSAFunctionMerger {
  ArrayRef<Function *> Functions;
  Module *M;
  FunctionMerger &PairMerger;
  ScoringSystem Scoring;
  OptimizationRemarkEmitter &ORE;

  IntegerType *DiscriminatorTy;

public:
  MSAFunctionMerger(ArrayRef<Function *> Functions, FunctionMerger &PM,
                    OptimizationRemarkEmitter &ORE)
      : Functions(Functions), PairMerger(PM), ORE(ORE),
        Scoring(/*Gap*/ -1, /*Match*/ 0,
                /*Mismatch*/ std::numeric_limits<ScoreSystemType>::min()) {
    assert(!Functions.empty() && "No functions to merge");
    M = Functions[0]->getParent();
    DiscriminatorTy = IntegerType::getInt32Ty(M->getContext());
  }

  FunctionMerger &getPairMerger() { return PairMerger; }

  Function *writeThunk(Function *MergedFunction, Function *SrcFunction,
                       unsigned FuncId,
                       ValueMap<Argument *, unsigned int> &ArgToMergedArgNo);
  Function *merge(MSAStats &Stats);
  void align(std::vector<MSAAlignmentEntry> &Alignment);
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

  OptimizationRemarkEmitter &ORE;

  friend class MSAGenFunctionBody;

public:
  MSAGenFunction(Module *M, const std::vector<MSAAlignmentEntry> &Alignment,
                 const ArrayRef<Function *> &Functions,
                 IntegerType *DiscriminatorTy, OptimizationRemarkEmitter &ORE)
      : M(M), C(M->getContext()), Alignment(Alignment), Functions(Functions),
        DiscriminatorTy(DiscriminatorTy), Builder(C), ORE(ORE){};

  void layoutParameters(std::vector<std::pair<Type *, AttributeSet>> &Args,
                        ValueMap<Argument *, unsigned> &ArgToMergedIndex) const;
  bool layoutReturnType(Type *&RetTy);
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
