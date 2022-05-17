//===-NextFMLoader.cpp - LLVM Link Time Optimizer Backend -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"

using namespace llvm;

llvm::PassPluginLibraryInfo getNextFMPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "NextFM", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &PM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "func-merging") {
                    PM.addPass(FunctionMergingPass());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  llvm::dbgs() << "plugin loaded\n";
  return getNextFMPluginInfo();
}

