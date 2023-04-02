#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/None.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/Fingerprint.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include <algorithm>

using namespace llvm;

#define DEBUG_TYPE "msa-hyfm"

class HyFMMultipleSequenceAlignerImpl {
  OptimizationRemarkEmitter *ORE;
  const NeedlemanWunschMultipleSequenceAligner &NWAligner;
  bool EnableHyFMBlockProfitabilityEstimation;

public:
  HyFMMultipleSequenceAlignerImpl(
      const NeedlemanWunschMultipleSequenceAligner &NWAligner,
      OptimizationRemarkEmitter *ORE,
      bool EnableHyFMBlockProfitabilityEstimation)
      : ORE(ORE), NWAligner(NWAligner),
        EnableHyFMBlockProfitabilityEstimation(
            EnableHyFMBlockProfitabilityEstimation) {}

  class BlockAlignment {
    SmallVector<BasicBlock *, 4> Blocks;
    Optional<std::vector<MSAAlignmentEntry<>>> InstAlignment;

  public:
    BlockAlignment(size_t Size) : Blocks(Size, nullptr), InstAlignment(None) {}

    BasicBlock *operator[](size_t Idx) const { return Blocks[Idx]; }
    BasicBlock *&operator[](size_t Idx) { return Blocks[Idx]; }
    decltype(Blocks)::iterator begin() { return Blocks.begin(); }
    decltype(Blocks)::iterator end() { return Blocks.end(); }
    decltype(Blocks)::const_iterator begin() const { return Blocks.begin(); }
    decltype(Blocks)::const_iterator end() const { return Blocks.end(); }
    size_t size() const { return Blocks.size(); }

    bool isMatched() const {
      // fast-path for the case after alignment is done.
      if (InstAlignment.hasValue())
        return true;
      return std::all_of(Blocks.begin(), Blocks.end(),
                         [](BasicBlock *BB) { return BB != nullptr; });
    }

    void setInstAlignment(std::vector<MSAAlignmentEntry<>> &&Alignment) {
      InstAlignment = std::move(Alignment);
    }

    void appendInstAlignment(std::vector<MSAAlignmentEntry<>> &Dest) const {
      assert(isMatched() &&
             "Cannot append inst alignment for unmatched blocks");
      Dest.insert(Dest.end(), InstAlignment->begin(), InstAlignment->end());
    }
  };

  /// Returns true if the given BBs have at least one profitable BB merge.
  bool alignBasicBlocks(ArrayRef<Function *> Functions,
                        const SmallVectorImpl<std::vector<BlockFingerprint>>
                            &FingerprintsByFunction,
                        SmallVectorImpl<BlockAlignment> &Alignments);
  void
  appendAlignmentEntries(const BlockAlignment &BA,
                         std::vector<MSAAlignmentEntry<>> &Alignment) const;
  bool align(ArrayRef<Function *> Functions,
             std::vector<MSAAlignmentEntry<>> &Alignment, bool &isProfitable,
             OptimizationRemarkEmitter *ORE);
  bool isBlockAlignmentProfitable(
      const BlockAlignment &BA,
      std::vector<MSAAlignmentEntry<>> &InstAlignment) const;

  static void dumpBlockAlignments(ArrayRef<BlockAlignment> Alignments);
  static bool
  isInstructionAlignmentProfitable(ArrayRef<MSAAlignmentEntry<>> Alignments);
};

bool HyFMMultipleSequenceAlignerImpl::alignBasicBlocks(
    ArrayRef<Function *> Functions,
    const SmallVectorImpl<std::vector<BlockFingerprint>>
        &FingerprintsByFunction,
    SmallVectorImpl<BlockAlignment> &BlockAlignments) {

  SmallPtrSet<BasicBlock *, 16> Used;
  bool HasProfitableBBMerge = false;

  // 1. Fix the base function and basic block.
  for (size_t BaseFuncId = 0; BaseFuncId < Functions.size(); BaseFuncId++) {
    Function *F = Functions[BaseFuncId];
    auto &Fingerprints = FingerprintsByFunction[BaseFuncId];
    for (auto &BaseBF : Fingerprints) {
      if (Used.count(BaseBF.BB))
        continue;

      double MinDistance = std::numeric_limits<double>::max();
      BlockAlignment BestAlignment(Functions.size());
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
      std::vector<MSAAlignmentEntry<>> InstAlignment;
      bool ShouldMerge =
          BestAlignment.isMatched() &&
          isBlockAlignmentProfitable(BestAlignment, InstAlignment);
      if (!ShouldMerge) {
        for (size_t FuncId = 0; FuncId < Functions.size(); FuncId++) {
          BasicBlock *BB = BestAlignment[FuncId];
          if (!BB) {
            continue;
          }
          Used.insert(BB);
          // If we don't merge, append the BB as a non-matched BB.
          BlockAlignment NonMatchedAlignment(Functions.size());
          NonMatchedAlignment[FuncId] = BB;
          BlockAlignments.push_back(std::move(NonMatchedAlignment));
        }
        continue;
      }

      // 4. We can assume that the BB merge is profitable.
      BestAlignment.setInstAlignment(std::move(InstAlignment));
      HasProfitableBBMerge = true;

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
  return HasProfitableBBMerge;
}

bool HyFMMultipleSequenceAlignerImpl::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry<>> &Alignment,
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
  bool HasAtLeastOneMerge =
      alignBasicBlocks(Functions, FingerprintsByFunction, BlockAlignments);
  if (!HasAtLeastOneMerge) {
    isProfitable = false;
    ORE->emit([&]() {
      auto remark = OptimizationRemarkMissed(DEBUG_TYPE, "UnprofitableMerge",
                                             Functions[0]);
      remark << ore::NV("Reason", "No profitable BB merge");
      for (auto *F : Functions) {
        remark << ore::NV("Function", F);
      }
      return remark;
    });
    return true;
  }

  LLVM_DEBUG(dumpBlockAlignments(BlockAlignments));

  // 3. Align the instructions in each basic block.
  {
    // FIXME(katei): We depend on the order of "invoke" instruction and "lpad" BB,
    // and we have to visit the "invoke" instruction first to handle its operands
    // in "assignMergedInstLabelOperands". The "assignMergedInstLabelOperands" must
    // visit the "lpad" BB as an operand of "invoke" instruction, then create a new
    // "lpad.bb" basic block and its "lpad" instruction. All "lpad" instructions
    // are ignored at alignment time, so we have to handle them differently.
    for (auto It = BlockAlignments.rbegin(), E = BlockAlignments.rend();
         It != E; ++It) {
      BlockAlignment &BA = *It;
      appendAlignmentEntries(BA, Alignment);
    }
  }

  LLVM_DEBUG(for (auto &AE : Alignment) { AE.dump(); });
  return true;
}

void HyFMMultipleSequenceAlignerImpl::appendAlignmentEntries(
    const BlockAlignment &BA,
    std::vector<MSAAlignmentEntry<>> &Alignment) const {
  if (BA.isMatched()) {
    BA.appendInstAlignment(Alignment);
  } else {
    for (size_t FuncId = 0; FuncId < BA.size(); FuncId++) {
      BasicBlock *BB = BA[FuncId];
      if (!BB) {
        continue;
      }
      // Append non-matched BBs as a single entry **in the reverse order** to
      // follow the order of NW aligner.
      std::vector<Value *> Values;
      NeedlemanWunschMultipleSequenceAligner::linearizeBasicBlock(
          BB, [&Values](Value *V) { Values.push_back(V); });

      size_t FuncSize = BA.size();
      for (auto I = Values.rbegin(), E = Values.rend(); I != E; ++I) {
        Value *V = *I;
        MSAAlignmentEntry<> AE(V, FuncSize, FuncId);
        Alignment.push_back(std::move(AE));
      }
    }
  }
}

void HyFMMultipleSequenceAlignerImpl::dumpBlockAlignments(
    ArrayRef<BlockAlignment> Alignments) {
  for (auto &BA : Alignments) {
    llvm::dbgs() << "Alignment:\n";
    for (size_t i = 0; i < BA.size(); i++) {
      dbgs() << "- ";
      auto BB = BA[i];
      if (BB) {
        dbgs() << BB->getName();
        BB->dump();
      } else {
        dbgs() << "null\n";
      }
    }
    dbgs() << "\n";
  }
}

bool HyFMMultipleSequenceAlignerImpl::isBlockAlignmentProfitable(
    const BlockAlignment &BA,
    std::vector<MSAAlignmentEntry<>> &InstAlignment) const {
  // Needleman Wunsch Aligner does not check the profitability, so just ignore
  // it.
  bool _isProfitable = true;
  ArrayRef<BasicBlock *> BBs(BA.begin(), BA.end());
  if (NWAligner.alignBasicBlocks(BBs, InstAlignment, _isProfitable, ORE)) {
    if (!EnableHyFMBlockProfitabilityEstimation) {
      return true;
    }
    return isInstructionAlignmentProfitable(InstAlignment);
  } else {
    // If the alignment failed for some reason, don't merge.
    return false;
  }
}

bool HyFMMultipleSequenceAlignerImpl::isInstructionAlignmentProfitable(
    ArrayRef<MSAAlignmentEntry<>> Alignments) {
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
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry<>> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {
  HyFMMultipleSequenceAlignerImpl Impl(
      NWAligner, ORE, Options.EnableHyFMBlockProfitabilityEstimation);
  return Impl.align(Functions, Alignment, isProfitable, ORE);
}
