//===-- ExtractGV2.cpp - Global Value extraction pass
//----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass extracts global values
// This pass is taken from ExtractGV.cpp in LLVM 13.0.0 because the object file
// is not linked to opt tool and it's not possible to use the pass in plugins.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/SetVector.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Transforms/IPO.h"
#include <algorithm>
using namespace llvm;

/// Make sure GV is visible from both modules. Delete is true if it is
/// being deleted from this module.
/// This also makes sure GV cannot be dropped so that references from
/// the split module remain valid.
static void makeVisible(GlobalValue &GV, bool Delete) {
  bool Local = GV.hasLocalLinkage();
  if (Local || Delete) {
    GV.setLinkage(GlobalValue::ExternalLinkage);
    if (Local)
      GV.setVisibility(GlobalValue::HiddenVisibility);
    return;
  }

  if (!GV.hasLinkOnceLinkage()) {
    assert(!GV.isDiscardableIfUnused());
    return;
  }

  // Map linkonce* to weak* so that llvm doesn't drop this GV.
  switch (GV.getLinkage()) {
  default:
    llvm_unreachable("Unexpected linkage");
  case GlobalValue::LinkOnceAnyLinkage:
    GV.setLinkage(GlobalValue::WeakAnyLinkage);
    return;
  case GlobalValue::LinkOnceODRLinkage:
    GV.setLinkage(GlobalValue::WeakODRLinkage);
    return;
  }
}

namespace {
/// A pass to extract specific global values and their dependencies.
class GVExtractorPass : public ModulePass {
  SetVector<GlobalValue *> Named;
  bool deleteStuff;
  bool keepConstInit;

public:
  static char ID; // Pass identification, replacement for typeid

  /// If deleteS is true, this pass deletes the specified global values.
  /// Otherwise, it deletes as much of the module as possible, except for the
  /// global values specified.
  explicit GVExtractorPass(std::vector<GlobalValue *> &GVs, bool deleteS = true,
                           bool keepConstInit = false)
      : ModulePass(ID), Named(GVs.begin(), GVs.end()), deleteStuff(deleteS),
        keepConstInit(keepConstInit) {}

  bool runOnModule(Module &M) override {
    if (skipModule(M))
      return false;

    // Visit the global inline asm.
    if (!deleteStuff)
      M.setModuleInlineAsm("");

    // For simplicity, just give all GlobalValues ExternalLinkage. A trickier
    // implementation could figure out which GlobalValues are actually
    // referenced by the Named set, and which GlobalValues in the rest of
    // the module are referenced by the NamedSet, and get away with leaving
    // more internal and private things internal and private. But for now,
    // be conservative and simple.

    // Visit the GlobalVariables.
    for (GlobalVariable &GV : M.globals()) {
      bool Delete = deleteStuff == (bool)Named.count(&GV) &&
                    !GV.isDeclaration() && (!GV.isConstant() || !keepConstInit);
      if (!Delete) {
        if (GV.hasAvailableExternallyLinkage())
          continue;
        if (GV.getName() == "llvm.global_ctors")
          continue;
      }

      makeVisible(GV, Delete);

      if (Delete) {
        // Make this a declaration and drop it's comdat.
        GV.setInitializer(nullptr);
        GV.setComdat(nullptr);
      }
    }

    // Visit the Functions.
    for (Function &F : M) {
      bool Delete = deleteStuff == (bool)Named.count(&F) && !F.isDeclaration();
      if (!Delete) {
        if (F.hasAvailableExternallyLinkage())
          continue;
      }

      makeVisible(F, Delete);

      if (Delete) {
        // Make this a declaration and drop it's comdat.
        F.deleteBody();
        F.setComdat(nullptr);
      }
    }

    // Visit the Aliases.
    for (Module::alias_iterator I = M.alias_begin(), E = M.alias_end();
         I != E;) {
      Module::alias_iterator CurI = I;
      ++I;

      bool Delete = deleteStuff == (bool)Named.count(&*CurI);
      makeVisible(*CurI, Delete);

      if (Delete) {
        Type *Ty = CurI->getValueType();

        CurI->removeFromParent();
        llvm::Value *Declaration;
        if (FunctionType *FTy = dyn_cast<FunctionType>(Ty)) {
          Declaration =
              Function::Create(FTy, GlobalValue::ExternalLinkage,
                               CurI->getAddressSpace(), CurI->getName(), &M);

        } else {
          Declaration =
              new GlobalVariable(M, Ty, false, GlobalValue::ExternalLinkage,
                                 nullptr, CurI->getName());
        }
        CurI->replaceAllUsesWith(Declaration);
        delete &*CurI;
      }
    }

    return true;
  }
};

char GVExtractorPass::ID = 0;
} // namespace

namespace llvm {
ModulePass *createGVExtraction2Pass(std::vector<GlobalValue *> &GVs,
                                    bool deleteFn, bool keepConstInit) {
  return new GVExtractorPass(GVs, deleteFn, keepConstInit);
}
}; // namespace llvm
