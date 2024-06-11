#ifndef LLVM_TRANSFORMS_IPO_FUNCTIONMERGINGOPTIONS_H
#define LLVM_TRANSFORMS_IPO_FUNCTIONMERGINGOPTIONS_H

#include "llvm/Transforms/IPO/FunctionSizeEstimation.h"
#include <llvm-13/llvm/Support/raw_ostream.h>

/// A set of parameters used to control the transforms by MergeFunctions.
struct FunctionMergingOptions {
  bool MaximizeParamScore;
  bool IdenticalTypesOnly;
  bool EnableUnifiedReturnType;
  bool EnableOperandReordering;
  bool EnableHyFMAlignment;
  bool EnableHyFMBlockProfitabilityEstimation;
  size_t LSHRows = 2;
  size_t LSHBands = 100;
  double RankingDistance = 1.0;

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

  static FunctionMergingOptions derive(size_t numberOfFunctions);

  void dump(llvm::raw_ostream &OS = llvm::errs()) const {
    OS << "Threshold: " << RankingDistance << "\n";
    OS << "LSHRows: " << LSHRows << "\n";
    OS << "LSHBands: " << LSHBands << "\n";
  }

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
