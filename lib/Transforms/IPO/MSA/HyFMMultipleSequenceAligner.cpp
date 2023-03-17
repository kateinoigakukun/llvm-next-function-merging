#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/Fingerprint.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"

using namespace llvm;

#define DEBUG_TYPE "msa-hyfm"

class HyFMMultipleSequenceAlignerImpl {
  OptimizationRemarkEmitter *ORE;
  const NeedlemanWunschMultipleSequenceAligner *NWAligner;

public:
  HyFMMultipleSequenceAlignerImpl(
      const NeedlemanWunschMultipleSequenceAligner *NWAligner,
      OptimizationRemarkEmitter *ORE)
      : ORE(ORE), NWAligner(NWAligner) {}

  using BlockAlignment = SmallVector<BasicBlock *, 4>;

  void alignBasicBlocks(ArrayRef<Function *> Functions,
                        const SmallVectorImpl<std::vector<BlockFingerprint>>
                            &FingerprintsByFunction,
                        SmallVectorImpl<BlockAlignment> &Alignments);
  bool align(ArrayRef<Function *> Functions,
             std::vector<MSAAlignmentEntry> &Alignment, bool &isProfitable,
             OptimizationRemarkEmitter *ORE);
  bool isBlockAlignmentProfitable(const BlockAlignment &BA) const;

  static void dumpBlockAlignments(ArrayRef<BlockAlignment> Alignments);
  static bool
  isInstructionAlignmentProfitable(ArrayRef<MSAAlignmentEntry> Alignments);
};

void HyFMMultipleSequenceAlignerImpl::alignBasicBlocks(
    ArrayRef<Function *> Functions,
    const SmallVectorImpl<std::vector<BlockFingerprint>>
        &FingerprintsByFunction,
    SmallVectorImpl<BlockAlignment> &BlockAlignments) {

  SmallPtrSet<BasicBlock *, 16> Used;

  // 1. Fix the base function and basic block.
  for (size_t BaseFuncId = 0; BaseFuncId < Functions.size(); BaseFuncId++) {
    Function *F = Functions[BaseFuncId];
    auto &Fingerprints = FingerprintsByFunction[BaseFuncId];
    for (auto &BaseBF : Fingerprints) {
      if (Used.count(BaseBF.BB))
        continue;

      double MinDistance = std::numeric_limits<double>::max();
      BlockAlignment BestAlignment(Functions.size(), nullptr);
      BestAlignment[BaseFuncId] = BaseBF.BB;

      // 2. Find the best match for each other basic block in other functions.
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

      // 3. Okay, we have the best match for the base basic block.
      // Then, estimate the BB merge is profitable or not.
      // TODO(katei): For now, we merge only if all BBs are matched. Unlcok
      // partial merge later.
      bool ShouldMerge = BestAlignment.size() == Functions.size() &&
                         isBlockAlignmentProfitable(BestAlignment);
      if (!ShouldMerge) {
        for (size_t FuncId = 0; FuncId < Functions.size(); FuncId++) {
          BasicBlock *BB = BestAlignment[FuncId];
          if (!BB) {
            continue;
          }
          Used.insert(BB);
          // If we don't merge, append the BB as a non-matched BB.
          BlockAlignment NonMatchedAlignment(Functions.size(), nullptr);
          NonMatchedAlignment[FuncId] = BB;
          BlockAlignments.push_back(std::move(NonMatchedAlignment));
        }
        continue;
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

bool HyFMMultipleSequenceAlignerImpl::isBlockAlignmentProfitable(
    const BlockAlignment &BA) const {
  if (NWAligner) {
    std::vector<MSAAlignmentEntry> InstAlignment;
    // Needleman Wunsch Aligner does not check the profitability, so just ignore
    // it.
    bool _isProfitable = true;
    if (NWAligner->alignBasicBlocks(BA, InstAlignment, _isProfitable, ORE)) {
      return isInstructionAlignmentProfitable(InstAlignment);
    } else {
      // If the alignment failed for some reason, don't merge.
      return false;
    }
  } else {
    return true;
  }
}

bool HyFMMultipleSequenceAlignerImpl::isInstructionAlignmentProfitable(
    ArrayRef<MSAAlignmentEntry> Alignments) {
  int OriginalCost = 0;
  int MergedCost = 0;

  bool InsideSplit = false;

  for (auto &Entry : Alignments) {
    std::vector<Instruction *> Instructions;
    Entry.collectInstructions(Instructions);

    bool IsInstruction = Instructions.size() > 0;
    if (Entry.match()) {
      if (IsInstruction) {
        OriginalCost += 2;
        MergedCost += 1;
      }
      if (InsideSplit) {
        InsideSplit = false;
        MergedCost += 2;
      }
    } else {
      if (IsInstruction) {
        OriginalCost += 1;
        MergedCost += 1;
      }
      if (!InsideSplit) {
        InsideSplit = true;
        MergedCost += 1;
      }
    }
  }

  bool Profitable = (MergedCost <= OriginalCost);
  return Profitable;
}

bool HyFMMultipleSequenceAligner::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {
  HyFMMultipleSequenceAlignerImpl Impl(NWAligner, ORE);
  return Impl.align(Functions, Alignment, isProfitable, ORE);
}
