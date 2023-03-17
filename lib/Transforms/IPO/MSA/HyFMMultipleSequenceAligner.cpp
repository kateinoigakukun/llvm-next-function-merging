#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/Fingerprint.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"

using namespace llvm;

#define DEBUG_TYPE "msa-hyfm"

class HyFMMultipleSequenceAlignerImpl {
  bool EnableBlockProfitabilityEstimation;
  OptimizationRemarkEmitter *ORE;

public:
  HyFMMultipleSequenceAlignerImpl(bool EnableBlockProfitabilityEstimation,
                                  OptimizationRemarkEmitter *ORE)
      : EnableBlockProfitabilityEstimation(EnableBlockProfitabilityEstimation),
        ORE(ORE) {}

  using BlockAlignment = SmallVector<BasicBlock *, 4>;

  void alignBasicBlocks(ArrayRef<Function *> Functions,
                        const SmallVectorImpl<std::vector<BlockFingerprint>>
                            &FingerprintsByFunction,
                        SmallVectorImpl<BlockAlignment> &Alignments);
  bool align(ArrayRef<Function *> Functions,
             std::vector<MSAAlignmentEntry> &Alignment, bool &isProfitable,
             OptimizationRemarkEmitter *ORE);

  void dumpBlockAlignments(ArrayRef<BlockAlignment> Alignments);
};

void HyFMMultipleSequenceAlignerImpl::alignBasicBlocks(
    ArrayRef<Function *> Functions,
    const SmallVectorImpl<std::vector<BlockFingerprint>>
        &FingerprintsByFunction,
    SmallVectorImpl<BlockAlignment> &BlockAlignments) {

  SmallPtrSet<BasicBlock *, 16> Used;

  for (size_t BaseFuncId = 0; BaseFuncId < Functions.size(); BaseFuncId++) {
    Function *F = Functions[BaseFuncId];
    auto &Fingerprints = FingerprintsByFunction[BaseFuncId];
    for (auto &BaseBF : Fingerprints) {
      if (Used.count(BaseBF.BB))
        continue;

      double MinDistance = std::numeric_limits<double>::max();
      BlockAlignment BestAlignment(Functions.size(), nullptr);
      BestAlignment[BaseFuncId] = BaseBF.BB;

      for (size_t OtherFuncId = 0; OtherFuncId < Functions.size();
           OtherFuncId++) {
        // Don't compare a function to itself.
        if (OtherFuncId == BaseFuncId)
          continue;
        Function *OtherF = Functions[OtherFuncId];
        auto &OtherFingerprints = FingerprintsByFunction[OtherFuncId];
        for (auto &OtherBF : OtherFingerprints) {
          if (Used.count(OtherBF.BB))
            continue;

          double Distance = BaseBF.distance(OtherBF);
          if (Distance < MinDistance) {
            MinDistance = Distance;
            BestAlignment[OtherFuncId] = OtherBF.BB;
          }
        }
      }

      for (BasicBlock *BB : BestAlignment) {
        if (!BB) {
          // This function doesn't have a block that matches the base
          continue;
        }
        Used.insert(BB);
      }

      BlockAlignments.push_back(std::move(BestAlignment));
    }
  }
}

bool HyFMMultipleSequenceAlignerImpl::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {

  // 1. Compute the fingerprints for each basic block in each function.
  SmallVector<std::vector<BlockFingerprint>, 4> FingerprintsByFunction;

  for (Function *F : Functions) {
    auto &Fingerprints = FingerprintsByFunction.emplace_back();
    for (BasicBlock &BB : *F) {
      BlockFingerprint BF(&BB);
      Fingerprints.push_back(std::move(BF));
    }
  }

  // 2. Find the nearest neighbors for each basic block in each function: O(n^k)
  // where n is the number of basic blocks in a function and k is the number of
  // functions.
  SmallVector<BlockAlignment, 16> BlockAlignments;
  alignBasicBlocks(Functions, FingerprintsByFunction, BlockAlignments);

  LLVM_DEBUG(dumpBlockAlignments(BlockAlignments));

  return true;
}

void HyFMMultipleSequenceAlignerImpl::dumpBlockAlignments(
    ArrayRef<BlockAlignment> Alignments) {
  for (auto &BA : Alignments) {
    llvm::dbgs() << "Alignment:\n";
    for (size_t i = 0; i < BA.size(); i++) {
      dbgs() << "- ";
      auto &BB = BA[i];
      if (BB) {
        dbgs() << BB->getName();
        BB->dump();
      } else {
        dbgs() << "null";
      }
      dbgs() << "\n";
    }
  }
}

bool HyFMMultipleSequenceAligner::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {
  HyFMMultipleSequenceAlignerImpl Impl(
      Options.EnableHyFMBlockProfitabilityEstimation, ORE);
  return Impl.align(Functions, Alignment, isProfitable, ORE);
}
