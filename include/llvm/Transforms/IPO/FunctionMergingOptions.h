#ifndef LLVM_TRANSFORMS_IPO_FUNCTIONMERGINGOPTIONS_H
#define LLVM_TRANSFORMS_IPO_FUNCTIONMERGINGOPTIONS_H

#include "llvm/Transforms/IPO/FunctionSizeEstimation.h"

/// A set of parameters used to control the transforms by MergeFunctions.
struct FunctionMergingOptions {
  bool MaximizeParamScore;
  bool IdenticalTypesOnly;
  bool EnableUnifiedReturnType;
  bool EnableOperandReordering;
  bool EnableHyFMAlignment;
  bool EnableHyFMBlockProfitabilityEstimation;
  llvm::FunctionSizeEstimation::EstimationMethod SizeEstimationMethod =
      llvm::FunctionSizeEstimation::EstimationMethod::Approximate;

  FunctionMergingOptions(
      bool MaximizeParamScore = true, bool IdenticalTypesOnly = true,
      bool EnableUnifiedReturnType = true, bool EnableOperandReordering = true,
      bool EnableHyFMAlignment = false,
      bool EnableHyFMBlockProfitabilityEstimation = true,
      llvm::FunctionSizeEstimation::EstimationMethod SizeEstimationMethod =
          llvm::FunctionSizeEstimation::EstimationMethod::Approximate)
      : MaximizeParamScore(MaximizeParamScore),
        IdenticalTypesOnly(IdenticalTypesOnly),
        EnableUnifiedReturnType(EnableUnifiedReturnType),
        EnableOperandReordering(EnableOperandReordering),
        EnableHyFMAlignment(EnableHyFMAlignment),
        EnableHyFMBlockProfitabilityEstimation(
            EnableHyFMBlockProfitabilityEstimation),
        SizeEstimationMethod(SizeEstimationMethod) {}

  FunctionMergingOptions &maximizeParameterScore(bool MPS) {
    MaximizeParamScore = MPS;
    return *this;
  }

  FunctionMergingOptions &matchOnlyIdenticalTypes(bool IT) {
    IdenticalTypesOnly = IT;
    return *this;
  }

  FunctionMergingOptions &enableUnifiedReturnTypes(bool URT) {
    EnableUnifiedReturnType = URT;
    return *this;
  }
};

#endif
