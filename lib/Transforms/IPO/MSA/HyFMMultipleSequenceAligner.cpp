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

template <MSAAlignmentEntryType Type> class HyFMMultipleSequenceAlignerImpl {
  OptimizationRemarkEmitter *ORE;
  const NeedlemanWunschMultipleSequenceAligner<Type> &NWAligner;
  bool EnableHyFMBlockProfitabilityEstimation;

public:
  HyFMMultipleSequenceAlignerImpl(
      const NeedlemanWunschMultipleSequenceAligner<Type> &NWAligner,
      OptimizationRemarkEmitter *ORE,
      bool EnableHyFMBlockProfitabilityEstimation)
      : ORE(ORE), NWAligner(NWAligner),
        EnableHyFMBlockProfitabilityEstimation(
            EnableHyFMBlockProfitabilityEstimation) {}

  class BlockAlignment {
    SmallVector<BasicBlock *, 4> Blocks;
    Optional<std::vector<MSAAlignmentEntry<Type>>> InstAlignment;

  public:
    BlockAlignment(size_t Size) : Blocks(Size, nullptr), InstAlignment(None) {
      assert(Size > 0 && "BlockAlignment must have at least one block");
    }

    BasicBlock *operator[](size_t Idx) const { return Blocks[Idx]; }
    BasicBlock *&operator[](size_t Idx) { return Blocks[Idx]; }
    typename decltype(Blocks)::iterator begin() { return Blocks.begin(); }
    typename decltype(Blocks)::iterator end() { return Blocks.end(); }
    typename decltype(Blocks)::const_iterator begin() const { return Blocks.begin(); }
    typename decltype(Blocks)::const_iterator end() const { return Blocks.end(); }
    size_t size() const { return Blocks.size(); }

    bool isMatched() const {
      // fast-path for the case after alignment is done.
      if (InstAlignment.hasValue())
        return true;
      return std::all_of(Blocks.begin(), Blocks.end(),
                         [](BasicBlock *BB) { return BB != nullptr; });
    }

    void setInstAlignment(std::vector<MSAAlignmentEntry<Type>> &&Alignment) {
      InstAlignment = std::move(Alignment);
    }

    void appendInstAlignment(std::vector<MSAAlignmentEntry<Type>> &Dest) const {
      assert(isMatched() &&
             "Cannot append inst alignment for unmatched blocks");
      Dest.insert(Dest.end(), InstAlignment->begin(), InstAlignment->end());
    }

    void print(raw_ostream &OS) const {
      OS << "BlockAlignment:\n";
      for (size_t i = 0; i < size(); i++) {
        OS << "- ";
        const BasicBlock *BB = Blocks[i];
        if (BB) {
          OS << BB->getName();
          BB->print(OS);
        } else {
          OS << "null\n";
        }
      }
      OS << "\n";
    }
  };

  /// Returns true if the given BBs have at least one profitable BB merge.
  bool alignBasicBlocks(ArrayRef<Function *> Functions,
                        const SmallVectorImpl<std::vector<BlockFingerprint>>
                            &FingerprintsByFunction,
                        SmallVectorImpl<BlockAlignment> &Alignments);
  void
  appendAlignmentEntries(const BlockAlignment &BA,
                         std::vector<MSAAlignmentEntry<Type>> &Alignment) const;
  bool align(ArrayRef<Function *> Functions,
             std::vector<MSAAlignmentEntry<Type>> &Alignment,
             bool &isProfitable, OptimizationRemarkEmitter *ORE);
  bool isBlockAlignmentProfitable(
      const BlockAlignment &BA,
      std::vector<MSAAlignmentEntry<Type>> &InstAlignment) const;

  static void dumpBlockAlignments(ArrayRef<BlockAlignment> Alignments);
  static bool isInstructionAlignmentProfitable(
      ArrayRef<MSAAlignmentEntry<Type>> Alignments);
};

template <MSAAlignmentEntryType Type>
bool HyFMMultipleSequenceAlignerImpl<Type>::alignBasicBlocks(
    ArrayRef<Function *> Functions,
    const SmallVectorImpl<std::vector<BlockFingerprint>>
        &FingerprintsByFunction,
    SmallVectorImpl<BlockAlignment> &BlockAlignments) {

  SmallPtrSet<BasicBlock *, 16> Used;
  bool HasProfitableBBMerge = false;

  auto AddNonMatchingEntry = [&](BasicBlock *BB, size_t FuncId) {
    BlockAlignment BA(Functions.size());
    BA[FuncId] = BB;
    LLVM_DEBUG(BA.print(dbgs()));
    BlockAlignments.push_back(std::move(BA));
    Used.insert(BB);
  };

  // 1. Fix the base function and basic block.
  LLVM_DEBUG(dbgs() << "Aligning basic blocks:\n");
  // NOTE: The base function is taken from the back of the list to be consistent
  // with the original implementation. But the order should not matter in
  // theory.
  for (int32_t BaseFuncId = Functions.size() - 1; BaseFuncId > 0;
       BaseFuncId--) {
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
        LLVM_DEBUG(
            dbgs() << "Comparing Base=" << Functions[BaseFuncId]->getName()
                   << ", Other=" << Functions[OtherFuncId]->getName() << "\n");
        auto &OtherFingerprints = FingerprintsByFunction[OtherFuncId];
        for (auto &OtherBF : OtherFingerprints) {
          if (Used.count(OtherBF.BB))
            continue;

          LLVM_DEBUG(dbgs()
                     << "  Comparing BBs: Base=" << BaseBF.BB->getName()
                     << ", Other=" << OtherBF.BB->getName() << "\n"
                     << "    Distance: " << BaseBF.distance(OtherBF) << "\n");
          double Distance = BaseBF.distance(OtherBF);
          if (Distance < MinDistance) {
            MinDistance = Distance;
            BestAlignment[OtherFuncId] = OtherBF.BB;
          }
        }
      }

      LLVM_DEBUG(dbgs() << "  Checking if the alignment is profitable..\n");

      // 3. Okay, we have the best match for the base basic block.
      // Then, estimate the BB merge is profitable or not.
      // TODO(katei): For now, we merge only if all BBs are matched. Unlcok
      // partial merge later.
      std::vector<MSAAlignmentEntry<Type>> InstAlignment;
      bool ShouldMerge =
          BestAlignment.isMatched() &&
          isBlockAlignmentProfitable(BestAlignment, InstAlignment);
      if (!ShouldMerge) {
        LLVM_DEBUG(dbgs() << "The alignment is not profitable.\n");
        // If we don't merge, append the BB as a non-matched BB.
        AddNonMatchingEntry(BaseBF.BB, BaseFuncId);
        continue;
      }
      LLVM_DEBUG(dbgs() << "The alignment is profitable.\n");

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

      LLVM_DEBUG(BestAlignment.print(dbgs()));
      BlockAlignments.push_back(std::move(BestAlignment));
    }
  }
  for (size_t FuncId = 0; FuncId < Functions.size(); FuncId++) {
    auto &Fingerprints = FingerprintsByFunction[FuncId];
    for (auto &BF : Fingerprints) {
      if (Used.count(BF.BB))
        continue;
      AddNonMatchingEntry(BF.BB, FuncId);
    }
  }
  return HasProfitableBBMerge;
}

template <MSAAlignmentEntryType Type>
bool HyFMMultipleSequenceAlignerImpl<Type>::align(
    ArrayRef<Function *> Functions,
    std::vector<MSAAlignmentEntry<Type>> &Alignment, bool &isProfitable,
    OptimizationRemarkEmitter *ORE) {

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
    if (ORE) {
      ORE->emit([&]() {
        auto remark = OptimizationRemarkMissed(DEBUG_TYPE, "UnprofitableMerge",
                                               Functions[0]);
        remark << ore::NV("Reason", "No profitable BB merge");
        for (auto *F : Functions) {
          remark << ore::NV("Function", F);
        }
        return remark;
      });
    }
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

template <MSAAlignmentEntryType Type>
void HyFMMultipleSequenceAlignerImpl<Type>::appendAlignmentEntries(
    const BlockAlignment &BA,
    std::vector<MSAAlignmentEntry<Type>> &Alignment) const {
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
      NeedlemanWunschMultipleSequenceAligner<Type>::linearizeBasicBlock(
          BB, [&Values](Value *V) { Values.push_back(V); });

      size_t FuncSize = BA.size();
      for (auto I = Values.rbegin(), E = Values.rend(); I != E; ++I) {
        Value *V = *I;
        MSAAlignmentEntry<Type> AE(V, FuncSize, FuncId);
        Alignment.push_back(std::move(AE));
      }
    }
  }
}

template <MSAAlignmentEntryType Type>
void HyFMMultipleSequenceAlignerImpl<Type>::dumpBlockAlignments(
    ArrayRef<BlockAlignment> Alignments) {
  for (auto &BA : Alignments) {
    BA.print(dbgs());
  }
}

template <MSAAlignmentEntryType Type>
bool HyFMMultipleSequenceAlignerImpl<Type>::isBlockAlignmentProfitable(
    const BlockAlignment &BA,
    std::vector<MSAAlignmentEntry<Type>> &InstAlignment) const {
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

template <MSAAlignmentEntryType Type>
bool HyFMMultipleSequenceAlignerImpl<Type>::isInstructionAlignmentProfitable(
    ArrayRef<MSAAlignmentEntry<Type>> Alignments) {
  int OriginalCost = 0;
  int MergedCost = 0;

  bool InsideSplit = false;

  for (auto It = Alignments.rbegin(), E = Alignments.rend(); It != E; ++It) {
    auto &Entry = *It;

    bool IsInstruction = Entry.hasInstruction();
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

template <MSAAlignmentEntryType Type>
bool HyFMMultipleSequenceAligner<Type>::align(
    ArrayRef<Function *> Functions,
    std::vector<MSAAlignmentEntry<Type>> &Alignment, bool &isProfitable,
    OptimizationRemarkEmitter *ORE) {
  HyFMMultipleSequenceAlignerImpl<Type> Impl(
      NWAligner, ORE, Options.EnableHyFMBlockProfitabilityEstimation);
  return Impl.align(Functions, Alignment, isProfitable, ORE);
}

template class llvm::HyFMMultipleSequenceAligner<
    MSAAlignmentEntryType::Variable>;
template class llvm::HyFMMultipleSequenceAligner<MSAAlignmentEntryType::Fixed2>;
