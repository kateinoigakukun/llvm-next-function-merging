#include "llvm/Transforms/IPO/MSA/MultipleSequenceAligner.h"
#include "llvm/IR/BasicBlock.h"

using namespace llvm;

template <MSAAlignmentEntryType Type>
bool MSAAlignmentEntry<Type>::collectInstructions(
    std::vector<Instruction *> &Instructions) const {
  bool allInstructions = true;
  for (auto *V : Values) {
    if (V && isa<Instruction>(V)) {
      Instructions.push_back(cast<Instruction>(V));
    } else {
      allInstructions = false;
      Instructions.push_back(nullptr);
    }
  }
  return allInstructions;
}

template <MSAAlignmentEntryType Type>
bool MSAAlignmentEntry<Type>::hasInstruction() const {
  for (auto *V : Values) {
    if (V && isa<Instruction>(V)) {
      return true;
    }
  }
  return false;
}

template <MSAAlignmentEntryType Type>
void MSAAlignmentEntry<Type>::verify() const {
  if (!match() || Values.empty()) {
    return;
  }
  bool isBB = isa<BasicBlock>(Values[0]);
  for (size_t i = 1; i < Values.size(); i++) {
    if (isBB != isa<BasicBlock>(Values[i])) {
      llvm_unreachable(
          "all values must be either basic blocks or instructions");
    }
  }
}

template <MSAAlignmentEntryType Type>
void MSAAlignmentEntry<Type>::print(raw_ostream &OS) const {
  OS << "MSAAlignmentEntry:\n";
  for (auto *V : Values) {
    if (V) {
      if (auto *BB = dyn_cast<BasicBlock>(V)) {
        OS << "- bb" << BB->getName() << "\n";
      } else {
        OS << "- " << *V << "\n";
      }
    } else {
      OS << "-   nullptr\n";
    }
  }
}

template struct llvm::MSAAlignmentEntry<MSAAlignmentEntryType::Variable>;
template struct llvm::MSAAlignmentEntry<MSAAlignmentEntryType::Fixed2>;
template class llvm::MultipleSequenceAligner<MSAAlignmentEntryType::Variable>;
template class llvm::MultipleSequenceAligner<MSAAlignmentEntryType::Fixed2>;
