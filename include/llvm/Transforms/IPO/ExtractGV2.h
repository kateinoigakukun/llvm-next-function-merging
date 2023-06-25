//===-- ExtractGV2.cpp - Global Value extraction pass
//----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/IR/GlobalValue.h"
#include "llvm/Pass.h"
#include <vector>

namespace llvm {
ModulePass *createGVExtraction2Pass(std::vector<GlobalValue *> &GVs,
                                    bool deleteFn = false,
                                    bool keepConstInit = false);
}; // namespace llvm
