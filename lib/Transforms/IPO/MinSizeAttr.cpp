
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Use.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/IPO/MergeFunctions.h"
#include "llvm/Transforms/Utils/FunctionComparator.h"
#include <algorithm>
#include <cassert>
#include <iterator>
#include <set>
#include <utility>
#include <vector>

using namespace llvm;

namespace {

class MinSizeAttrLegacyPass : public ModulePass {
public:
  static char ID;

   MinSizeAttrLegacyPass(): ModulePass(ID) {
    initializeMergeFunctionsLegacyPassPass(*PassRegistry::getPassRegistry());
  }

  bool runOnModule(Module &M) override {
    bool Changed = false;

    for (Function &F : M) {
      if (!F.hasFnAttribute(Attribute::MinSize)) {
        F.addFnAttr(Attribute::MinSize);
        Changed = true;
      }
    }

    return Changed;
  }
};

} // end anonymous namespace

char MinSizeAttrLegacyPass::ID = 0;

#ifdef LLVM_NEXT_FM_STANDALONE
static RegisterPass<MinSizeAttrLegacyPass> X("minsize-all", "Min size everything",
                                             false, false);
#else
INITIALIZE_PASS(MinSizeAttrLegacyPass, "minsize-all",
                "Min size everything", false, false)

ModulePass *llvm::createMinSizeAttrPass() {
  return new MinSizeAttrLegacyPass();
}
#endif
