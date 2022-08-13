//===- FunctionMerging.h - A function merging pass ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the general function merging optimization.
//
// It identifies similarities between functions, and If profitable, merges them
// into a single function, replacing the original ones. Functions do not need
// to be identical to be merged. In fact, there is very little restriction to
// merge two function, however, the produced merged function can be larger than
// the two original functions together. For that reason, it uses the
// TargetTransformInfo analysis to estimate the code-size costs of instructions
// in order to estimate the profitability of merging two functions.
//
// This function merging transformation has three major parts:
// 1. The input functions are linearized, representing their CFGs as sequences
//    of labels and instructions.
// 2. We apply a sequence alignment algorithm, namely, the Needleman-Wunsch
//    algorithm, to identify similar code between the two linearized functions.
// 3. We use the aligned sequences to perform code generate, producing the new
//    merged function, using an extra parameter to represent the function
//    identifier.
//
// This pass integrates the function merging transformation with an exploration
// framework. For every function, the other functions are ranked based their
// degree of similarity, which is computed from the functions' fingerprints.
// Only the top candidates are analyzed in a greedy manner and if one of them
// produces a profitable result, the merged function is taken.
//
//===----------------------------------------------------------------------===//
//
// This optimization was proposed in
//
// Function Merging by Sequence Alignment: An Interprocedural Code-Size
// Optimization
// Rodrigo C. O. Rocha, Pavlos Petoumenos, Zheng Wang, Murray Cole, Hugh Leather
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_IPO_FUNCTIONMERGING_H
#define LLVM_TRANSFORMS_IPO_FUNCTIONMERGING_H

//#include "llvm/ADT/KeyValueCache.h"

#include "llvm/InitializePasses.h"

#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/ProfileSummaryInfo.h"
#include "llvm/Analysis/TargetTransformInfo.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringSet.h"

#include "llvm/Transforms/Utils/Cloning.h"

#include "llvm/ADT/SequenceAlignment.h"

#include "llvm/Transforms/IPO/SearchStrategy.h"
#include "llvm/Transforms/IPO/tsl/robin_map.h"

#include <map>
#include <vector>

namespace llvm {

/// A set of parameters used to control the transforms by MergeFunctions.
struct FunctionMergingOptions {
  bool MaximizeParamScore;
  bool IdenticalTypesOnly;
  bool EnableUnifiedReturnType;
  bool EnableOperandReordering;

  FunctionMergingOptions(bool MaximizeParamScore = true,
                         bool IdenticalTypesOnly = true,
                         bool EnableUnifiedReturnType = true,
                         bool EnableOperandReordering = true)
      : MaximizeParamScore(MaximizeParamScore),
        IdenticalTypesOnly(IdenticalTypesOnly),
        EnableUnifiedReturnType(EnableUnifiedReturnType),
        EnableOperandReordering(EnableOperandReordering) {}

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

class FunctionMergeResult {
private:
  Function *F1;
  Function *F2;
  Function *MergedFunction;
  bool HasIdArg;
  bool NeedUnifiedReturn;
  std::map<unsigned, unsigned> ParamMap1;
  std::map<unsigned, unsigned> ParamMap2;

  FunctionMergeResult()
      : F1(nullptr), F2(nullptr), MergedFunction(nullptr), HasIdArg(false),
        NeedUnifiedReturn(false) {}

public:
  FunctionMergeResult(Function *F1, Function *F2, Function *MergedFunction,
                      bool NeedUnifiedReturn = false)
      : F1(F1), F2(F2), MergedFunction(MergedFunction), HasIdArg(true),
        NeedUnifiedReturn(NeedUnifiedReturn) {}

  std::pair<Function *, Function *> getFunctions() {
    return std::pair<Function *, Function *>(F1, F2);
  }

  std::map<unsigned, unsigned> &getArgumentMapping(Function *F) {
    return (F1 == F) ? ParamMap1 : ParamMap2;
  }

  Value *getFunctionIdValue(Function *F) {
    if (F == F2)
      return ConstantInt::getTrue(IntegerType::get(F2->getContext(), 1));
    else if (F == F1)
      return ConstantInt::getFalse(IntegerType::get(F1->getContext(), 1));
    else
      return nullptr;
  }

  void setFunctionIdArgument(bool HasFuncIdArg) { HasIdArg = HasFuncIdArg; }

  bool hasFunctionIdArgument() { return HasIdArg; }

  void setUnifiedReturn(bool NeedUnifiedReturn) {
    this->NeedUnifiedReturn = NeedUnifiedReturn;
  }

  bool needUnifiedReturn() { return NeedUnifiedReturn; }

  // returns whether or not the merge operation was successful
  operator bool() const { return (MergedFunction != nullptr); }

  void setArgumentMapping(Function *F, std::map<unsigned, unsigned> &ParamMap) {
    if (F == F1)
      ParamMap1 = ParamMap;
    else if (F == F2)
      ParamMap2 = ParamMap;
  }

  void addArgumentMapping(Function *F, unsigned SrcArg, unsigned DstArg) {
    if (F == F1)
      ParamMap1[SrcArg] = DstArg;
    else if (F == F2)
      ParamMap2[SrcArg] = DstArg;
  }

  Function *getMergedFunction() { return MergedFunction; }

  //  static const FunctionMergeResult Error;
};

struct AlignmentStats {
  int Insts{0};
  int Matches{0};
  int CoreMatches{0};
  bool isProfitable() const {return (Matches == Insts) || (CoreMatches > 0);};
};


template <class T> class MatchInfo {
public:
  T candidate{nullptr};
  size_t Size{0};
  size_t OtherSize{0};
  size_t MergedSize{0};
  size_t Magnitude{0};
  size_t OtherMagnitude{0};
  float Distance{0};
  bool Valid{false};
  bool Profitable{false};


  MatchInfo() = default;
  MatchInfo(T candidate) : candidate(candidate) {};
  MatchInfo(T candidate, size_t Size) : candidate(candidate), Size(Size) {};
};

template <class T> class Matcher {
public:
  Matcher() = default;
  virtual ~Matcher() = default;

  virtual void add_candidate(T candidate, size_t size) = 0;
  virtual void remove_candidate(T candidate) = 0;
  virtual T next_candidate() = 0;
  virtual std::vector<MatchInfo<T>> &get_matches(T candidate) = 0;
  virtual size_t size() = 0;
  virtual void print_stats() = 0;
};

class FunctionMerger;

std::unique_ptr<Matcher<Function *>>
createMatcherLSH(FunctionMerger &FM, FunctionMergingOptions &Options, size_t rows, size_t bands);

FunctionMergeResult MergeFunctions(Function *F1, Function *F2,
                                   const FunctionMergingOptions &Options = {});

class FunctionMergingPass : public PassInfoMixin<FunctionMergingPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};

} // namespace llvm
#endif
