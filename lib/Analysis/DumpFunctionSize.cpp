//===-- DumpFunctionSize.cpp - Collects the function size ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/DumpFunctionSize.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/JSON.h"
#include "llvm/Transforms/IPO/FunctionSizeEstimation.h"

using namespace llvm;

static cl::opt<FunctionSizeEstimation::EstimationMethod> SizeEstimationMethod(
    "size-estimation", cl::Hidden, cl::desc("Function size estimation method"),
    cl::init(FunctionSizeEstimation::EstimationMethod::Approximate),
    cl::values(clEnumValN(FunctionSizeEstimation::EstimationMethod::Approximate,
                          "approximate", "Approximate estimation"),
               clEnumValN(FunctionSizeEstimation::EstimationMethod::Exact,
                          "exact", "Exact estimation")));

static cl::opt<std::string> OutputPath("dump-funcsize-output", cl::Hidden,
                                       cl::desc("Output path"), cl::init("-"));

#define DEBUG_TYPE "instcount2"

PreservedAnalyses DumpFunctionSizePass::run(Module &M,
                                            ModuleAnalysisManager &MAM) {
  // Dump each function size to a JSON file.
  std::error_code EC;
  raw_fd_ostream OS(OutputPath, EC, sys::fs::OF_Text);
  if (EC) {
    errs() << "Error: " << EC.message() << "\n";
    return PreservedAnalyses::all();
  }
  FunctionAnalysisManager &FAM =
      MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
  FunctionSizeEstimation FSE(FAM);

  json::OStream J(OS);
  J.object([&] {
    for (auto &F : M) {
      J.attributeObject(F.getName(), [&] {
        J.attribute("size", (int64_t)FSE.estimate(F, SizeEstimationMethod));
      });
    }
  });

  return PreservedAnalyses::all();
}
