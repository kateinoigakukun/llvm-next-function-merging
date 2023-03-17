#ifndef LLVM_TRANSFORMS_IPO_FUNCTIONMERGINGOPTIONS_H
#define LLVM_TRANSFORMS_IPO_FUNCTIONMERGINGOPTIONS_H

/// A set of parameters used to control the transforms by MergeFunctions.
struct FunctionMergingOptions {
  bool MaximizeParamScore;
  bool IdenticalTypesOnly;
  bool EnableUnifiedReturnType;
  bool EnableOperandReordering;
  bool EnableHyFMAlignment;
  bool EnableHyFMBlockProfitabilityEstimation;

  FunctionMergingOptions(bool MaximizeParamScore = true,
                         bool IdenticalTypesOnly = true,
                         bool EnableUnifiedReturnType = true,
                         bool EnableOperandReordering = true,
                         bool EnableHyFMAlignment = false,
                         bool EnableHyFMBlockProfitabilityEstimation = true)
      : MaximizeParamScore(MaximizeParamScore),
        IdenticalTypesOnly(IdenticalTypesOnly),
        EnableUnifiedReturnType(EnableUnifiedReturnType),
        EnableOperandReordering(EnableOperandReordering),
        EnableHyFMAlignment(EnableHyFMAlignment),
        EnableHyFMBlockProfitabilityEstimation(
            EnableHyFMBlockProfitabilityEstimation) {}

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
