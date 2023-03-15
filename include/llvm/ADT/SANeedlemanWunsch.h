#ifndef LLVM_ADT_SEQUENCE_ALIGNMENT_NEEDLEMANWUNSCH_H
#define LLVM_ADT_SEQUENCE_ALIGNMENT_NEEDLEMANWUNSCH_H

#include "llvm/ADT/SequenceAlignment.h"
#include <functional>

template <typename ContainerType,
          typename Ty = typename ContainerType::value_type, Ty Blank = Ty(0),
          typename MatchFnTy = std::function<bool(Ty, Ty)>>
class NeedlemanWunschSA
    : public SequenceAligner<ContainerType, Ty, Blank, MatchFnTy> {
private:
  ScoreSystemType *Matrix;
  size_t MatrixRows;
  size_t MatrixCols;
  bool *Matches;
  size_t MatchesRows;
  size_t MatchesCols;

  using BaseType = SequenceAligner<ContainerType, Ty, Blank, MatchFnTy>;

  void cacheAllMatches(ContainerType &Seq1, ContainerType &Seq2) {
    if (BaseType::getMatchOperation() == nullptr) {
      Matches = nullptr;
      return;
    }
    const size_t SizeSeq1 = Seq1.size();
    const size_t SizeSeq2 = Seq2.size();

    MatchesRows = SizeSeq1;
    MatchesCols = SizeSeq2;
    Matches = new bool[MatchesRows * MatchesCols];
    for (unsigned i = 0; i < MatchesRows; i++)
      for (unsigned j = 0; j < MatchesCols; j++)
        Matches[i * MatchesCols + j] = BaseType::match(Seq1[i], Seq2[j]);
  }

  void computeScoreMatrix(ContainerType &Seq1, ContainerType &Seq2) {
    const size_t SizeSeq1 = Seq1.size();
    const size_t SizeSeq2 = Seq2.size();

    const size_t NumRows = MatchesRows + 1;
    const size_t NumCols = MatchesCols + 1;
    Matrix = new ScoreSystemType[NumRows * NumCols];
    MatrixRows = NumRows;
    MatrixCols = NumCols;

    ScoringSystem &Scoring = BaseType::getScoring();
    const ScoreSystemType Gap = Scoring.getGapPenalty();
    const ScoreSystemType Match = Scoring.getMatchProfit();
    const bool AllowMismatch = Scoring.getAllowMismatch();
    const ScoreSystemType Mismatch = Scoring.getMismatchPenalty();

    for (unsigned i = 0; i < NumRows; i++)
      Matrix[i * NumCols + 0] = i * Gap;
    for (unsigned j = 0; j < NumCols; j++)
      Matrix[0 * NumCols + j] = j * Gap;

    ScoreSystemType MaxScore = std::numeric_limits<ScoreSystemType>::min();
    for (unsigned i = 1; i < NumRows; i++) {
      for (unsigned j = 1; j < NumCols; j++) {
        ScoreSystemType Diagonal =
            Matches[(i - 1) * MatchesCols + j - 1]
                ? (Matrix[(i - 1) * NumCols + j - 1] + Match)
                : Mismatch;
        ScoreSystemType Upper = Matrix[(i - 1) * NumCols + j] + Gap;
        ScoreSystemType Left = Matrix[i * NumCols + j - 1] + Gap;
        ScoreSystemType Score = std::max(std::max(Diagonal, Upper), Left);
        Matrix[i * NumCols + j] = Score;
        if (Score >= MaxScore) {
          MaxScore = Score;
        }
      }
    }
  }

  void print(llvm::raw_ostream &OS) {
    for (unsigned i = 0; i < MatrixRows; i++) {
      for (unsigned j = 0; j < MatrixCols; j++) {
        OS << j << "," << i << "=" << Matrix[i * MatrixCols + j] << " ";
      }
      OS << "\n";
    }
  }

  void buildResult(ContainerType &Seq1, ContainerType &Seq2,
                   AlignedSequence<Ty, Blank> &Result) {
    auto &Data = Result.Data;

    ScoringSystem &Scoring = BaseType::getScoring();
    const ScoreSystemType Gap = Scoring.getGapPenalty();
    const ScoreSystemType Match = Scoring.getMatchProfit();
    const ScoreSystemType Mismatch = Scoring.getMismatchPenalty();

    int rowCursor = MatrixRows - 1, columnCursor = MatrixCols - 1;

    while (rowCursor > 0 || columnCursor > 0) {
      auto Left = rowCursor > 0 ? Seq1[rowCursor - 1] : nullptr;
      auto Right = columnCursor > 0 ? Seq2[columnCursor - 1] : nullptr;
      if (rowCursor > 0 && columnCursor > 0) {
        // Diagonal

        bool IsValidMatch =
            Matches[(rowCursor - 1) * MatchesCols + columnCursor - 1];
        ScoreSystemType Score =
            IsValidMatch
                ? (Matrix[(rowCursor - 1) * MatrixCols + columnCursor - 1] +
                   Match)
                : Mismatch;

        if (Matrix[rowCursor * MatrixCols + columnCursor] == Score) {
          if (IsValidMatch) {
            Data.push_front(
                typename BaseType::EntryType(Left, Right, IsValidMatch));
          } else {
            Data.push_front(typename BaseType::EntryType(Left, Blank, false));
            Data.push_front(typename BaseType::EntryType(Blank, Right, false));
          }

          rowCursor--;
          columnCursor--;
          continue;
        }
      }
      if (rowCursor > 0 &&
          Matrix[rowCursor * MatrixCols + columnCursor] ==
              (Matrix[(rowCursor - 1) * MatrixCols + columnCursor] + Gap)) {
        // Up
        Data.push_front(typename BaseType::EntryType(Left, Blank, false));
        rowCursor--;
      } else if (columnCursor > 0 &&
                 Matrix[rowCursor * MatrixCols + columnCursor] ==
                     (Matrix[rowCursor * MatrixCols + (columnCursor - 1)] +
                      Gap)) {
        // Left
        Data.push_front(typename BaseType::EntryType(Blank, Right, false));
        columnCursor--;
      }
    }
  }

  void clearAll() {
    if (Matrix)
      delete[] Matrix;
    if (Matches)
      delete[] Matches;
    Matrix = nullptr;
    Matches = nullptr;
  }

public:
  static ScoringSystem getDefaultScoring() { return ScoringSystem(-1, 2, -1); }

  NeedlemanWunschSA()
      : BaseType(getDefaultScoring(), nullptr), Matrix(nullptr),
        Matches(nullptr) {}

  NeedlemanWunschSA(ScoringSystem Scoring, MatchFnTy Match = nullptr)
      : BaseType(Scoring, Match), Matrix(nullptr), Matches(nullptr) {}

  ~NeedlemanWunschSA() {clearAll();}

  virtual size_t getMemoryRequirement(ContainerType &Seq1,
                                      ContainerType &Seq2) override {
    const size_t SizeSeq1 = Seq1.size();
    const size_t SizeSeq2 = Seq2.size();
    size_t MemorySize = 0;

    MemorySize += sizeof(ScoreSystemType)*(SizeSeq1+1)*(SizeSeq2+1);

    if (BaseType::getMatchOperation() != nullptr)
      MemorySize += SizeSeq1*SizeSeq2*sizeof(bool);

    return MemorySize;
  }

  virtual AlignedSequence<Ty, Blank> getAlignment(ContainerType &Seq1,
                                                  ContainerType &Seq2) override {
    AlignedSequence<Ty, Blank> Result;
    cacheAllMatches(Seq1, Seq2);
    computeScoreMatrix(Seq1, Seq2);
    buildResult(Seq1, Seq2, Result);
    clearAll();
    return Result;
  }
};

#endif
