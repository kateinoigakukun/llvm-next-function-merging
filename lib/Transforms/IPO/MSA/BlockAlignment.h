#ifndef LLVM_TRANSFORMS_IPO_MSA_BLOCKALIGNMENT_H
#define LLVM_TRANSFORMS_IPO_MSA_BLOCKALIGNMENT_H

#include "llvm/IR/BasicBlock.h"
#include "llvm/Transforms/IPO/MSA/MSAAlignmentEntry.h"

namespace llvm {

struct BlockAlignmentStats {
  int32_t Insts = 0;
  int32_t Matches = 0;
  int32_t CoreMatches = 0;

  bool isProfitable() const { return (Matches == Insts) || (CoreMatches > 0); };
};

template <MSAAlignmentEntryType Type> class BlockAlignment {
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
  typename decltype(Blocks)::const_iterator begin() const {
    return Blocks.begin();
  }
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
    assert(isMatched() && "Cannot append inst alignment for unmatched blocks");
    Dest.insert(Dest.end(), InstAlignment->begin(), InstAlignment->end());
  }

  template <typename AlignmentsTy>
  static void updateStatsMatching(BlockAlignmentStats &Stats,
                                  AlignmentsTy &InstAlignment) {
    for (const MSAAlignmentEntry<Type> &Entry : InstAlignment) {
      if (!Entry.hasInstruction()) {
        continue;
      }
      Stats.Insts++;
      if (Entry.match()) {
        Stats.Matches++;
      }
      for (auto *V : Entry.getValues()) {
        if (!V) {
          continue;
        }
        if (auto *I = dyn_cast<Instruction>(V)) {
          if (I->isTerminator()) {
            Stats.CoreMatches++;
            break;
          }
        }
      }
    }
  }

  template <typename BlocksTy>
  static void updateStatsNotMatching(BlockAlignmentStats &Stats,
                                     BlocksTy &Blocks) {
    for (BasicBlock *BB : Blocks) {
      if (!BB) {
        continue;
      }
      for (auto &I : *BB) {
        if (isa<PHINode>(&I) || isa<LandingPadInst>(&I)) {
          continue;
        }
        Stats.Insts++;
      }
    }
  }

  void updateStats(BlockAlignmentStats &Stats) const {
    if (isMatched()) {
      updateStatsMatching(Stats, *InstAlignment);
    } else {
      updateStatsNotMatching(Stats, Blocks);
    }
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

} // namespace llvm

#endif // LLVM_TRANSFORMS_IPO_MSA_BLOCKALIGNMENT_H
