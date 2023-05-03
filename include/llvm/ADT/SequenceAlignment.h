//===-- llvm/ADT/SequenceAlignment.h - Sequence Alignment -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Provides efficient implementations of different algorithms for sequence
// alignment.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ADT_SEQUENCE_ALIGNMENT_H
#define LLVM_ADT_SEQUENCE_ALIGNMENT_H

#include "llvm/ADT/ArrayView.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/MSA/MSAAlignmentEntry.h"

#include <cassert>
#include <list>
#include <algorithm>
#include <functional>
#include <limits.h> // INT_MIN

#define ScoreSystemType  int

// Store alignment result here
template<typename Ty, Ty Blank=Ty(0)>
class AlignedSequence {
public:

  using Entry = llvm::MSAAlignmentEntry<llvm::MSAAlignmentEntryType::Fixed2>;

  std::list< Entry > Data;
  size_t LargestMatch;

  AlignedSequence() : LargestMatch(0) {}

  AlignedSequence(const AlignedSequence<Ty, Blank> &Other) : Data(Other.Data), LargestMatch(Other.LargestMatch) {}
  AlignedSequence(AlignedSequence<Ty, Blank> &&Other) : Data(std::move(Other.Data)), LargestMatch(Other.LargestMatch) {}

  AlignedSequence<Ty> &operator=(const AlignedSequence<Ty, Blank> &Other) {
    Data = Other.Data;
    LargestMatch = Other.LargestMatch;
    return (*this);
  }

  void append(const AlignedSequence<Ty, Blank> &Other) {
    Data.insert(Data.end(), Other.Data.begin(), Other.Data.end());
  }

  void splice(AlignedSequence<Ty, Blank> &Other) {
    Data.splice(Data.end(), Other.Data);
  }

  typename std::list< Entry >::iterator begin() { return Data.begin(); }
  typename std::list< Entry >::iterator end() { return Data.end(); }

  size_t size() { return Data.size(); }
  void dump() {
    for (auto &E : Data) {
      E.dump();
    }
  }

  static void verifyTwoAreSame(AlignedSequence<Ty> &Seq0,
                               AlignedSequence<Ty> &Seq1) {
    if (Seq0.size() != Seq1.size()) {
      llvm::errs() << "Seq0.size() = " << Seq0.size()
                   << ", Seq1.size() = " << Seq1.size() << "\n";
      __builtin_trap();
    }

    auto It0 = Seq0.begin();
    auto It1 = Seq1.begin();

    while (It0 != Seq0.end() && It1 != Seq1.end()) {

      auto &E0 = *It0;
      auto &E1 = *It1;

      if (E0.match() != E1.match()) {
        llvm::errs() << "E0.match() = " << E0.match()
                     << ", E1.match() = " << E1.match() << "\n";
        __builtin_trap();
      }

      auto &Values0 = E0.getValues();
      auto &Values1 = E1.getValues();

      if (Values0.size() != Values1.size()) {
        llvm::errs() << "Values0.size() = " << Values0.size()
                     << ", Values1.size() = " << Values1.size() << "\n";
        __builtin_trap();
      }

      auto ItValues0 = Values0.begin();
      auto ItValues1 = Values1.begin();

      while (ItValues0 != Values0.end() && ItValues1 != Values1.end()) {
        Ty V0 = *ItValues0;
        Ty V1 = *ItValues1;

        if (V0 != V1) {
          __builtin_trap();
        }

        ++ItValues0;
        ++ItValues1;
      }
    }
  }
};

class ScoringSystem {
public:
  ScoreSystemType Gap;
  ScoreSystemType Match;
  ScoreSystemType Mismatch;
  bool AllowMismatch;
  ScoringSystem(ScoreSystemType Gap, ScoreSystemType Match) {
    this->Gap = Gap;
    this->Match = Match;
    this->Mismatch = std::numeric_limits<ScoreSystemType>::min();
    this->AllowMismatch = false;
  }

  ScoringSystem(ScoreSystemType Gap, ScoreSystemType Match, ScoreSystemType Mismatch, bool AllowMismatch = true) {
    this->Gap = Gap;
    this->Match = Match;
    this->Mismatch = Mismatch;
    this->AllowMismatch = AllowMismatch;
  }

  bool getAllowMismatch() {
    return AllowMismatch;
  }

  ScoreSystemType getMismatchPenalty() {
    return Mismatch;
  }

  ScoreSystemType getGapPenalty() {
    return Gap;
  }

  ScoreSystemType getMatchProfit() {
    return Match;
  }
};

template<typename ContainerType, typename Ty=typename ContainerType::value_type, Ty Blank=Ty(0), typename MatchFnTy=std::function<bool(Ty,Ty)>>
class SequenceAligner {
private:
  ScoringSystem Scoring;
  MatchFnTy Match;

public:

  using EntryType = typename AlignedSequence<Ty,Blank>::Entry;

  SequenceAligner(ScoringSystem Scoring, MatchFnTy Match = nullptr)
    : Scoring(Scoring), Match(Match) {}  

  virtual ~SequenceAligner() = default;

  ScoringSystem &getScoring() { return Scoring; }

  bool match(Ty Val1, Ty Val2) {
    return Match(Val1,Val2);
  }

  MatchFnTy getMatchOperation() { return Match; }

  Ty getBlank() { return Blank; }

  virtual AlignedSequence<Ty,Blank> getAlignment(ContainerType &Seq0, ContainerType &Seq1) = 0;
  virtual size_t getMemoryRequirement(ContainerType &Seq0, ContainerType &Seq1) = 0;
};

#endif
