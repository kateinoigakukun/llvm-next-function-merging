#ifndef LLVM_TRANSFORMS_IPO_MSA_MULTIPLESEQUENCEALIGNER_H
#define LLVM_TRANSFORMS_IPO_MSA_MULTIPLESEQUENCEALIGNER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/FixedBitVector.h"
#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/FunctionMergingOptions.h"
#include "llvm/Transforms/IPO/SALSSACodeGen.h"

#include <vector>

namespace llvm {

namespace fmutils {

/// Nullable 31-bit signed integer.
class OptionalScore {
  uint32_t Value;

  static const uint32_t HasValueBitMask = 0x00000001;

  OptionalScore() : Value(0) {}

public:
  OptionalScore(int32_t value)
      : Value((static_cast<uint32_t>(value << 1)) | HasValueBitMask) {
    assert(value >= min() && value <= max());
  }
  static OptionalScore None() { return OptionalScore(); }

  bool hasValue() const { return Value & HasValueBitMask; }
  operator bool() const { return hasValue(); }
  int32_t operator*() const { return static_cast<int32_t>(Value) >> 1; }

  static int32_t min() { return INT32_MIN / 2; }
  static int32_t max() { return INT32_MAX / 2; }

  void print(raw_ostream &OS) const {
    if (hasValue()) {
      if (**this == min())
        OS << "min";
      else if (**this == max())
        OS << "max";
      else
        OS << **this;
    } else {
      OS << "None";
    }
  }
};

} // namespace fmutils

enum class MSAAlignmentEntryType {
  Fixed2,
  Variable,
};

template <MSAAlignmentEntryType Type> struct MSAAlignmentEntryTypeTraits {};

template <> struct MSAAlignmentEntryTypeTraits<MSAAlignmentEntryType::Fixed2> {
  using ValuesTy = Value *[2];
};

template <>
struct MSAAlignmentEntryTypeTraits<MSAAlignmentEntryType::Variable> {
  using ValuesTy = std::vector<Value *>;
};

template <MSAAlignmentEntryType Type = MSAAlignmentEntryType::Variable>
class MSAAlignmentEntry {
  using Trait = MSAAlignmentEntryTypeTraits<Type>;
  using ValuesTy = typename Trait::ValuesTy;

  ValuesTy Values;
  bool IsMatched;

public:
  MSAAlignmentEntry(ValuesTy Values, bool IsMatched)
      : Values(Values), IsMatched(IsMatched) {}

  MSAAlignmentEntry(Value *V, size_t FuncSize, size_t FuncId)
      : IsMatched(false) {
    std::vector<Value *> Values(FuncSize, nullptr);
    Values[FuncId] = V;
    this->Values = Values;
  }

  bool match() const { return IsMatched; }
  ArrayRef<Value *> getValues() const { return Values; }
  /// Collect all instructions from the values.
  /// Returns true if all values are instructions. Otherwise returns false.
  bool collectInstructions(std::vector<Instruction *> &Instructions) const;
  void verify() const;
  void print(raw_ostream &OS) const;
  void dump() const { print(dbgs()); }
};

inline raw_ostream &operator<<(raw_ostream &OS,
                               const MSAAlignmentEntry<> &Entry) {
  Entry.print(OS);
  return OS;
}

class MultipleSequenceAligner {
public:
  virtual ~MultipleSequenceAligner() = default;
  virtual bool align(ArrayRef<Function *> Functions,
                     std::vector<MSAAlignmentEntry<>> &Alignment,
                     bool &isProfitable,
                     OptimizationRemarkEmitter *ORE = nullptr) = 0;
};

class NeedlemanWunschMultipleSequenceAligner : public MultipleSequenceAligner {
  FunctionMerger &PairMerger;
  ScoringSystem &Scoring;
  size_t ShapeSizeLimit;
  const FunctionMergingOptions &Options;

public:
  bool align(ArrayRef<Function *> Functions,
             std::vector<MSAAlignmentEntry<>> &Alignment, bool &isProfitable,
             OptimizationRemarkEmitter *ORE) override;

  inline static void linearizeBasicBlock(BasicBlock *B,
                                         std::function<void(Value *)> Append) {
    // The first element of the sequence should be the basic block itself
    // because the aligned sequences will be joined into a single alignment
    // sequence without any separator.
    Append(B);
    for (Instruction &I : *B) {
      // Those instructions are part of the SSA form and don't have any
      // size-effect, so we just skip them. They will be handled by
      // assignMergedInstLabelOperands.
      // This follows FunctionMerger::linearize's behavior.
      if (isa<PHINode>(I) || isa<LandingPadInst>(I)) {
        continue;
      }
      Append(&I);
    }
  }

  bool alignBasicBlocks(ArrayRef<BasicBlock *> BBs,
                        std::vector<MSAAlignmentEntry<>> &Alignment,
                        bool &isProfitable,
                        OptimizationRemarkEmitter *ORE) const;

  NeedlemanWunschMultipleSequenceAligner(
      FunctionMerger &PairMerger, ScoringSystem &Scoring, size_t ShapeSizeLimit,
      const FunctionMergingOptions &Options = {})
      : PairMerger(PairMerger), Scoring(Scoring),
        ShapeSizeLimit(ShapeSizeLimit), Options(Options){};
};

class HyFMMultipleSequenceAligner : public MultipleSequenceAligner {
  const FunctionMergingOptions &Options;
  /// The underlying Needleman-Wunsch aligner used to estimate the profitablity
  /// of the basic block alignment. nullptr if profitablity estimation is
  /// disabled.
  const NeedlemanWunschMultipleSequenceAligner &NWAligner;

public:
  bool align(ArrayRef<Function *> Functions,
             std::vector<MSAAlignmentEntry<>> &Alignment, bool &isProfitable,
             OptimizationRemarkEmitter *ORE) override;

  HyFMMultipleSequenceAligner(
      const NeedlemanWunschMultipleSequenceAligner &NWAligner,
      const FunctionMergingOptions &Options = {})
      : Options(Options), NWAligner(NWAligner){};
};

} // namespace llvm

#endif
