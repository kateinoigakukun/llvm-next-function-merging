#ifndef LLVM_ANALYSIS_DUMP_FUNCTION_SIZE_H
#define LLVM_ANALYSIS_DUMP_FUNCTION_SIZE_H

#include "llvm/IR/PassManager.h"

namespace llvm {

struct DumpFunctionSizePass : PassInfoMixin<DumpFunctionSizePass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &);
};

}; // namespace llvm

#endif
