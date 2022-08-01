#include "FunctionMergingUtils.h"
#include <llvm/IR/IRBuilder.h>

using namespace llvm;
using namespace llvm::fmutils;

void SwitchChainer::chainBlocks(BasicBlock *SrcBB, BasicBlock *TargetBB,
                                FuncId FuncId) {
  if (ChainBySrcBB.find(SrcBB) == ChainBySrcBB.end()) {
    ChainBySrcBB[SrcBB] = SwitchChain();
  }
  ChainBySrcBB[SrcBB].push_back(std::make_pair(FuncId, TargetBB));
};

void SwitchChainer::finalizeChain(BasicBlock *SrcBB, SwitchChain &Chain) {
  assert(!Chain.empty() && "Chain should have at least one dest!");

  bool singleTarget =
      std::all_of(Chain.begin(), Chain.end(),
                  [&](const std::pair<FuncId, BasicBlock *> &Pair) {
                    auto *TargetBB = Pair.second;
                    return Chain[0].second == TargetBB;
                  });

  IRBuilder<> Builder(SrcBB);
  if (singleTarget) {
    Builder.CreateBr(Chain[0].second);
    return;
  }

  // fast-path for simple conditional branch
  auto optimizeSimpleCondBr = [&]() {
    if (Chain.size() != 2) {
      return false;
    }
    // switch %discriminator, [
    //  i32 0 label %targetBB0,
    //  i32 1 label %targetBB1
    // ]
    // => br %discriminator, label %targetBB1, label %targetBB0
    BasicBlock *TrueBB;
    BasicBlock *FalseBB;
    if (Chain[0].first == 0 && Chain[1].first != 0) {
      TrueBB = Chain[1].second;
      FalseBB = Chain[0].second;
    } else if (Chain[0].first != 0 && Chain[1].first != 1) {
      TrueBB = Chain[0].second;
      FalseBB = Chain[1].second;
    } else {
      return false;
    }
    Builder.CreateCondBr(Discriminator, TrueBB, FalseBB);
    return true;
  };

  if (optimizeSimpleCondBr()) {
    return;
  }

  SwitchInst *Switch = Builder.CreateSwitch(Discriminator, getBlackholeBB());

  for (auto &FuncIdAndBB : Chain) {
    auto *TargetBB = FuncIdAndBB.second;
    auto *Var = ConstantInt::get(
        dyn_cast<IntegerType>(Discriminator->getType()), FuncIdAndBB.first);
    Switch->addCase(Var, TargetBB);
  }
}

void SwitchChainer::finalize() {
  for (auto &P : ChainBySrcBB) {
    finalizeChain(P.first, P.second);
  }
}
