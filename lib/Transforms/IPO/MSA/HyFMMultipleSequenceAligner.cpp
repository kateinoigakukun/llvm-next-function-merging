#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"

using namespace llvm;

class HyFMMultipleSequenceAlignerImpl {};

bool HyFMMultipleSequenceAligner::align(
    ArrayRef<Function *> Functions, std::vector<MSAAlignmentEntry> &Alignment,
    bool &isProfitable, OptimizationRemarkEmitter *ORE) {
  return true;
}
