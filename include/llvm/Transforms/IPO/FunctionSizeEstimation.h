#ifndef LLVM_TRANSFORMS_IPO_FUNCTION_SIZE_ESTIMATION_H
#define LLVM_TRANSFORMS_IPO_FUNCTION_SIZE_ESTIMATION_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"

namespace llvm {

class FunctionSizeEstimation {
  FunctionAnalysisManager &FAM;
  DenseMap<Function *, size_t> SizeCache;

public:
  FunctionSizeEstimation(FunctionAnalysisManager &FAM) : FAM(FAM) {}

  enum class EstimationMethod { Approximate, Exact };

  size_t estimate(Function &F, EstimationMethod Method) {
    return estimate({&F}, Method);
  }
  size_t estimate(const std::vector<Function *> &Functions,
                  EstimationMethod Method);
  size_t estimateApproximateFunctionSize(Function &F);
  static Optional<size_t>
  estimateExactFunctionSize(const std::vector<Function *> &Functions);
};
} // end namespace llvm

#endif
