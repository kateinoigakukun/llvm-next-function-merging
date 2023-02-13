//===-- InstCount2.cpp - Collects the count of all instructions -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass collects the count of all instructions and reports them
// This is a modified version of the InstCount pass to use with opt built with
// NDEBUG.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/InstCount2.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/Passes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "instcount2"

ALWAYS_ENABLED_STATISTIC(TotalInsts, "Number of instructions (of all types)");
ALWAYS_ENABLED_STATISTIC(TotalBlocks, "Number of basic blocks");
ALWAYS_ENABLED_STATISTIC(TotalFuncs, "Number of non-external functions");

#define HANDLE_INST(N, OPCODE, CLASS)                                          \
  ALWAYS_ENABLED_STATISTIC(Num##OPCODE##Inst, "Number of " #OPCODE " insts");

#include "llvm/IR/Instruction.def"

namespace {
class InstCount : public InstVisitor<InstCount> {
  friend class InstVisitor<InstCount>;

  void visitFunction(Function &F) { ++TotalFuncs; }
  void visitBasicBlock(BasicBlock &BB) { ++TotalBlocks; }

#define HANDLE_INST(N, OPCODE, CLASS)                                          \
  void visit##OPCODE(CLASS &) {                                                \
    ++Num##OPCODE##Inst;                                                       \
    ++TotalInsts;                                                              \
  }

#include "llvm/IR/Instruction.def"

  void visitInstruction(Instruction &I) {
    errs() << "Instruction Count does not know about " << I;
    llvm_unreachable(nullptr);
  }
};
} // namespace

PreservedAnalyses InstCount2Pass::run(Module &M, ModuleAnalysisManager &FAM) {
  EnableStatistics(false);
  for (Function &F : M)
    InstCount().visit(F);

  llvm::PrintStatisticsJSON(llvm::outs());

  return PreservedAnalyses::all();
}
