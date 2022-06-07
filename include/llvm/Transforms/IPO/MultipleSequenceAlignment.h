#ifndef LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H
#define LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H

#include "llvm/ADT/ArrayRef.h"
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
};

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

class MultipleFunctionMergingPass
    : public PassInfoMixin<MultipleFunctionMergingPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};

} // namespace llvm

#endif
