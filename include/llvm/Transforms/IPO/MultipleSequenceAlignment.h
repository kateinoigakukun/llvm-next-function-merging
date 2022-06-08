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

  bool match() const;
  ArrayRef<Value *> getValues() const;
  Optional<ArrayRef<Instruction *>> getAsInstructions() const;
  void verify() const;
  void dump() const;
};

struct MSAFunctionMergeResult {
  Function *MergedFunction;
};

/// \brief This pass merges multiple functions into a single function by
/// multiple sequence alignment algorithm.
class MSAFunctionMerger {
  ArrayRef<Function *> Functions;
  Module *M;
  FunctionMerger &PairMerger;
  ScoringSystem Scoring;

public:
  MSAFunctionMerger(ArrayRef<Function *> Functions, FunctionMerger &PM)
      : Functions(Functions), PairMerger(PM),
        Scoring(/*Gap*/ -1, /*Match*/ 0,
                /*Mismatch*/ std::numeric_limits<ScoreSystemType>::min()) {
    assert(!Functions.empty() && "No functions to merge");
    M = Functions[0]->getParent();
  }

  FunctionMerger &getPairMerger() { return PairMerger; }

  MSAFunctionMergeResult merge();
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

  friend class MSAGenFunctionBody;

public:
  MSAGenFunction(Module *M, const std::vector<MSAAlignmentEntry> &Alignment,
                 const ArrayRef<Function *> &Functions)
      : M(M), C(M->getContext()), Alignment(Alignment), Functions(Functions),
        DiscriminatorTy(IntegerType::getInt32Ty(C)), Builder(C){};

  void layoutParameters(std::vector<std::pair<Type *, AttributeSet>> &Args,
                        ValueMap<Argument *, unsigned> &ArgToMergedIndex) const;
  bool layoutReturnType(Type *&RetTy);
  FunctionType *
  createFunctionType(ArrayRef<std::pair<Type *, AttributeSet>> Args,
                     Type *RetTy);

  StringRef getFunctionName();

  Function *emit(const FunctionMergingOptions &Options = {});
};

class MultipleFunctionMergingPass
    : public PassInfoMixin<MultipleFunctionMergingPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};

} // namespace llvm

#endif
