#ifndef LLVM_TRANSFORMS_LEGACY_LEGACYSEQUENCEALIGNER_H
#define LLVM_TRANSFORMS_LEGACY_LEGACYSEQUENCEALIGNER_H

#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"

namespace llvm {

struct AlignmentStats {
  int Insts{0};
  int Matches{0};
  int CoreMatches{0};
  bool isProfitable() const { return (Matches == Insts) || (CoreMatches > 0); };
};

class Aligner {
public:
  virtual ~Aligner() = default;
  virtual AlignedSequence<Value *> align(Function *F1, Function *F2,
                                         bool &isProfitable) = 0;

  static void extendAlignedSeq(AlignedSequence<Value *> &AlignedSeq,
                               AlignedSequence<Value *> &AlignedSubSeq,
                               AlignmentStats &stats) {
    for (auto &Entry : AlignedSubSeq) {
      Instruction *I1 = nullptr;
      if (Entry.get(0))
        I1 = dyn_cast<Instruction>(Entry.get(0));

      Instruction *I2 = nullptr;
      if (Entry.get(1))
        I2 = dyn_cast<Instruction>(Entry.get(1));

      bool IsInstruction = I1 != nullptr || I2 != nullptr;

      AlignedSeq.Data.emplace_back(Entry.getValues(), Entry.match());

      if (IsInstruction) {
        stats.Insts++;
        if (Entry.match())
          stats.Matches++;
        Instruction *I = I1 ? I1 : I2;
        if (I->isTerminator())
          stats.CoreMatches++;
      }
    }
  }

  static void extendAlignedSeq(AlignedSequence<Value *> &AlignedSeq,
                               BasicBlock *BB1, BasicBlock *BB2,
                               AlignmentStats &stats) {
    using ValuesTy = AlignedSequence<Value *>::Entry::ValuesTy;
    if (BB1 != nullptr && BB2 == nullptr) {
      AlignedSeq.Data.emplace_back((ValuesTy){BB1, nullptr}, false);
      for (Instruction &I : *BB1) {
        if (isa<PHINode>(&I) || isa<LandingPadInst>(&I))
          continue;
        stats.Insts++;
        AlignedSeq.Data.emplace_back((ValuesTy){&I, nullptr}, false);
      }
    } else if (BB1 == nullptr && BB2 != nullptr) {
      AlignedSeq.Data.emplace_back((ValuesTy){nullptr, BB2}, false);
      for (Instruction &I : *BB2) {
        if (isa<PHINode>(&I) || isa<LandingPadInst>(&I))
          continue;
        stats.Insts++;
        AlignedSeq.Data.emplace_back((ValuesTy){nullptr, &I}, false);
      }
    } else {
      AlignedSeq.Data.emplace_back((ValuesTy){BB1, BB2},
                                   FunctionMerger::match(BB1, BB2));

      auto It1 = BB1->begin();
      while (isa<PHINode>(*It1) || isa<LandingPadInst>(*It1))
        It1++;

      auto It2 = BB2->begin();
      while (isa<PHINode>(*It2) || isa<LandingPadInst>(*It2))
        It2++;

      while (It1 != BB1->end() && It2 != BB2->end()) {
        Instruction *I1 = &*It1;
        Instruction *I2 = &*It2;

        stats.Insts++;
        if (FunctionMerger::matchInstructions(I1, I2)) {
          AlignedSeq.Data.emplace_back((ValuesTy){I1, I2}, true);
          stats.Matches++;
          if (!I1->isTerminator())
            stats.CoreMatches++;
        } else {
          AlignedSeq.Data.emplace_back((ValuesTy){I1, nullptr}, false);
          AlignedSeq.Data.emplace_back((ValuesTy){nullptr, I2}, false);
        }

        It1++;
        It2++;
      }
      assert((It1 == BB1->end()) && (It2 == BB2->end()));
    }
  }
};

class MSAAlignerAdapter : public Aligner {
public:
  using InnerEntry = MSAAlignmentEntry<MSAAlignmentEntryType::Fixed2>;
  using InnerAligner = MultipleSequenceAligner<MSAAlignmentEntryType::Fixed2>;

private:
  std::unique_ptr<InnerAligner> Aligner;

public:
  MSAAlignerAdapter(std::unique_ptr<InnerAligner> Aligner)
      : Aligner(std::move(Aligner)) {}

  AlignedSequence<Value *> align(Function *F1, Function *F2,
                                 bool &isProfitable) override {

    std::vector<InnerEntry> Alignment;
    Aligner->align({F1, F2}, Alignment, isProfitable);
    AlignedSequence<Value *> AlignedSeq;
    // Append the whole entries in reverse order because the MSA aligner returns
    // the alignment sequence in the opposite order.
    AlignedSeq.Data.insert(AlignedSeq.Data.end(), Alignment.rbegin(),
                           Alignment.rend());
    return AlignedSeq;
  }
};

class SALSSAAligner : public Aligner {
public:
  AlignedSequence<Value *> align(Function *F1, Function *F2,
                                 bool &isProfitable) override;
};

class HyFMNWAligner : public Aligner {
  bool HyFMProfitability;

public:
  HyFMNWAligner(bool HyFMProfitability)
      : HyFMProfitability(HyFMProfitability) {}

private:
  static void dumpBlockAlignment(BasicBlock *BB1, BasicBlock *BB2) {
    dbgs() << "BlockAlignment:\n";
    auto printBB = [](BasicBlock *BB) {
      dbgs() << "- ";
      if (BB) {
        dbgs() << BB->getName();
        BB->dump();
      } else {
        dbgs() << "null\n";
      }
    };
    printBB(BB1);
    printBB(BB2);
  };

  AlignedSequence<Value *> align(Function *F1, Function *F2,
                                 bool &isProfitable) override;
};

class HyFMPAAligner : public Aligner {
  bool HyFMProfitability;

public:
  HyFMPAAligner(bool HyFMProfitability)
      : HyFMProfitability(HyFMProfitability) {}

private:
  virtual AlignedSequence<Value *> align(Function *F1, Function *F2,
                                         bool &isProfitable) override;
};

}; // namespace llvm

#endif
