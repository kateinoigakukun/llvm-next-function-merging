#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Transforms/IPO/Fingerprint.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"

using namespace llvm;

class HyFMMultipleSequenceAlignerImpl {};

bool HyFMMultipleSequenceAligner::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {

  SmallVector<std::vector<BlockFingerprint>, 4> FingerprintsByFunction;

  for (Function *F : Functions) {
    auto &Fingerprints = FingerprintsByFunction.emplace_back();
    for (BasicBlock &BB : *F) {
      BlockFingerprint BF(&BB);
      Fingerprints.push_back(std::move(BF));
    }
  }

  using BlockAlignment = SmallVector<BasicBlock *, 4>;
  SmallPtrSet<BasicBlock *, 16> Used;
  SmallVector<BlockAlignment, 16> BlockAlignments;

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

  return true;
}
