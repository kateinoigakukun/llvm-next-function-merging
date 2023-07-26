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

  enum class EstimationMethod { Approximate, Exact, GlobalExact };

  size_t estimate(const std::vector<Function *> &Functions,
                  const std::vector<Function *> &Exclusions,
                  EstimationMethod Method);
  size_t estimateApproximateFunctionSize(Function &F);
  static std::optional<size_t>
  estimateExactFunctionSize(const std::vector<Function *> &Functions,
                            const std::vector<Function *> &Exclusions,
                            bool GlobalExact);
};
} // end namespace llvm

#endif
