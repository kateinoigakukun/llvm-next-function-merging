#include "llvm/Transforms/IPO/LegacySequenceAligner.h"
#include "llvm/ADT/SANeedlemanWunsch.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/IPO/Fingerprint.h"

using namespace llvm;

#define DEBUG_TYPE "legacy-sequence-aligner"

AlignedSequence<Value *> SALSSAAligner::align(Function *F1, Function *F2,
                                              bool &isProfitable) {
  SmallVector<Value *, 8> F1Vec;
  SmallVector<Value *, 8> F2Vec;

  FunctionMerger::linearize(F1, F1Vec);
  FunctionMerger::linearize(F2, F2Vec);

  NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(
      ScoringSystem(-1, 2),
      [&](auto *F1, auto *F2) { return FunctionMerger::match(F1, F2); });
  isProfitable = true;
  return SA.getAlignment(F1Vec, F2Vec);
}

AlignedSequence<Value *> HyFMNWAligner::align(Function *F1, Function *F2,
                                              bool &isProfitable) {
  AlignedSequence<Value *> AlignedSeq;
  AlignmentStats TotalAlignmentStats;

  int B1Max = 0;
  int B2Max = 0;
  size_t MaxMem = 0;

  int NumBB1 = 0;
  int NumBB2 = 0;
  size_t MemSize = 0;

#ifdef TIME_STEPS_DEBUG
  TimeAlignRank.startTimer();
#endif
  LLVM_DEBUG(dbgs() << "Comparing Base=" << F1->getName()
                    << ", Other=" << F2->getName() << "\n");
  std::vector<BlockFingerprint> B1Blocks;
  for (BasicBlock &BB1 : *F1) {
    BlockFingerprint BD1(&BB1);
    MemSize += BD1.footprint();
    NumBB1++;
    B1Blocks.push_back(std::move(BD1));
  }
#ifdef TIME_STEPS_DEBUG
  TimeAlignRank.stopTimer();
#endif

  for (BasicBlock &BIt : *F2) {
#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.startTimer();
#endif
    NumBB2++;
    BasicBlock *BB2 = &BIt;
    BlockFingerprint BD2(BB2);

    auto BestIt = B1Blocks.end();
    float BestDist = std::numeric_limits<float>::max();
    for (auto B1BDIt = B1Blocks.begin(), E = B1Blocks.end(); B1BDIt != E;
         B1BDIt++) {
      auto D = BD2.distance(*B1BDIt);
      LLVM_DEBUG(dbgs() << "  Comparing BBs: Base=" << B1BDIt->BB->getName()
                        << ", Other=" << BD2.BB->getName() << "\n"
                        << "    Distance: " << D << "\n");
      if (D < BestDist) {
        BestDist = D;
        BestIt = B1BDIt;
      }
    }
#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.stopTimer();
#endif

    LLVM_DEBUG(dbgs() << "  Checking if the alignment is profitable..\n");

    bool MergedBlock = false;
    if (BestIt != B1Blocks.end()) {
      auto &BD1 = *BestIt;
      BasicBlock *BB1 = BD1.BB;

      SmallVector<Value *, 8> BB1Vec;
      SmallVector<Value *, 8> BB2Vec;

      BB1Vec.push_back(BB1);
      for (auto &I : *BB1)
        if (!isa<PHINode>(&I) && !isa<LandingPadInst>(&I))
          BB1Vec.push_back(&I);

      BB2Vec.push_back(BB2);
      for (auto &I : *BB2)
        if (!isa<PHINode>(&I) && !isa<LandingPadInst>(&I))
          BB2Vec.push_back(&I);

      NeedlemanWunschSA<SmallVectorImpl<Value *>> SA(
          ScoringSystem(-1, 2),
          [&](auto *F1, auto *F2) { return FunctionMerger::match(F1, F2); });

      auto MemReq = SA.getMemoryRequirement(BB1Vec, BB2Vec);
      LLVM_DEBUG(errs() << "PStats: " << BB1Vec.size() << " , " << BB2Vec.size()
                        << " , " << MemReq << "\n");

      if (MemReq > MaxMem) {
        MaxMem = MemReq;
        B1Max = BB1Vec.size();
        B2Max = BB2Vec.size();
      }

      AlignedSequence<Value *> AlignedBlocks = SA.getAlignment(BB1Vec, BB2Vec);

      if (!HyFMProfitability || FunctionMerger::isSAProfitable(AlignedBlocks)) {
        LLVM_DEBUG(dbgs() << "The alignment is profitable.\n");
        extendAlignedSeq(AlignedSeq, AlignedBlocks, TotalAlignmentStats);
        LLVM_DEBUG(dumpBlockAlignment(BB1, BB2));
        B1Blocks.erase(BestIt);
        MergedBlock = true;
      } else {
        LLVM_DEBUG(dbgs() << "The alignment is not profitable.\n");
      }
    }

    if (!MergedBlock) {
      LLVM_DEBUG(dumpBlockAlignment(nullptr, BB2));
      extendAlignedSeq(AlignedSeq, nullptr, BB2, TotalAlignmentStats);
    }
  }

  for (auto &BD1 : B1Blocks) {
    LLVM_DEBUG(dumpBlockAlignment(BD1.BB, nullptr));
    extendAlignedSeq(AlignedSeq, BD1.BB, nullptr, TotalAlignmentStats);
  }

  LLVM_DEBUG(errs() << "Stats: " << B1Max << " , " << B2Max << " , " << MaxMem
                    << "\n";
             errs() << "RStats: " << NumBB1 << " , " << NumBB2 << " , "
                    << MemSize << "\n");

  isProfitable = TotalAlignmentStats.isProfitable();
  return AlignedSeq;
}

AlignedSequence<Value *> HyFMPAAligner::align(Function *F1, Function *F2,
                                              bool &isProfitable) {
  AlignedSequence<Value *> AlignedSeq;
  AlignmentStats TotalAlignmentStats;

  int NumBB1 = 0;
  int NumBB2 = 0;
  size_t MemSize = 0;

#ifdef TIME_STEPS_DEBUG
  TimeAlignRank.startTimer();
#endif
  std::map<size_t, std::vector<BlockFingerprint>> BlocksF1;
  for (BasicBlock &BB1 : *F1) {
    BlockFingerprint BD1(&BB1);
    NumBB1++;
    MemSize += BD1.footprint();
    BlocksF1[BD1.Size].push_back(std::move(BD1));
  }
#ifdef TIME_STEPS_DEBUG
  TimeAlignRank.stopTimer();
#endif

  for (BasicBlock &BIt : *F2) {
#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.startTimer();
#endif
    NumBB2++;
    BasicBlock *BB2 = &BIt;
    BlockFingerprint BD2(BB2);

    auto &SetRef = BlocksF1[BD2.Size];

    auto BestIt = SetRef.end();
    float BestDist = std::numeric_limits<float>::max();
    for (auto BDIt = SetRef.begin(), E = SetRef.end(); BDIt != E; BDIt++) {
      auto D = BD2.distance(*BDIt);
      if (D < BestDist) {
        BestDist = D;
        BestIt = BDIt;
      }
    }
#ifdef TIME_STEPS_DEBUG
    TimeAlignRank.stopTimer();
#endif

    bool MergedBlock = false;
    if (BestIt != SetRef.end()) {
      BasicBlock *BB1 = BestIt->BB;

      if (!HyFMProfitability || FunctionMerger::isPAProfitable(BB1, BB2)) {
        extendAlignedSeq(AlignedSeq, BB1, BB2, TotalAlignmentStats);
        SetRef.erase(BestIt);
        MergedBlock = true;
      }
    }

    if (!MergedBlock)
      extendAlignedSeq(AlignedSeq, nullptr, BB2, TotalAlignmentStats);
  }

  for (auto &Pair : BlocksF1)
    for (auto &BD1 : Pair.second)
      extendAlignedSeq(AlignedSeq, BD1.BB, nullptr, TotalAlignmentStats);

  LLVM_DEBUG(errs() << "RStats: " << NumBB1 << " , " << NumBB2 << " , "
                    << MemSize << "\n");

  isProfitable = TotalAlignmentStats.isProfitable();
  return AlignedSeq;
}
