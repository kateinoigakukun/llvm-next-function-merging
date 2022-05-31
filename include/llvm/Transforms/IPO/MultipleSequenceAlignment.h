#ifndef LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H
#define LLVM_TRANSFORMS_IPO_MULTIPLESEQUENCEALIGNMENT_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class MultipleFunctionMergingPass
    : public PassInfoMixin<MultipleFunctionMergingPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};

} // namespace llvm

#endif
