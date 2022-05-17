template<typename ContainerType, typename Ty=typename ContainerType::value_type, Ty Blank=Ty(0), typename MatchFnTy=std::function<bool(Ty,Ty)>>
class DiagonalWindowsSA : public SequenceAligner<ContainerType,Ty,Blank,MatchFnTy> {
private:
  using BaseType = SequenceAligner<ContainerType,Ty,Blank,MatchFnTy>;

  size_t WindowSize;

public:
  DiagonalWindowsSA(ScoringSystem Scoring, MatchFnTy Match, size_t WindowSize) : BaseType(Scoring, Match), WindowSize(WindowSize) {}

  virtual size_t getMemoryRequirement(ContainerType &Seq1,
                                      ContainerType &Seq2) {
    size_t MemorySize = sizeof(ScoreSystemType)*(WindowSize+1)*(WindowSize+1);

    if (BaseType::getMatchOperation() != nullptr)
      MemorySize += WindowSize*WindowSize*sizeof(bool);

    return MemorySize;
  }

  virtual AlignedSequence<Ty,Blank> getAlignment(ContainerType &Seq1, ContainerType &Seq2) {
      
    AlignedSequence<Ty,Blank> Res;
    
    size_t Offset1 = 0;
    size_t Offset2 = 0;

    
    while (Offset1<Seq1.size() && Offset2<Seq2.size()) {

      ArrayView< ContainerType > View1(Seq1);
      size_t EndWindow1 = ((Offset1+WindowSize)>View1.size())?View1.size():(Offset1+WindowSize);
      View1.sliceWindow(Offset1, EndWindow1);

      ArrayView< ContainerType > View2(Seq2);
      size_t EndWindow2 = ((Offset2+WindowSize)>View2.size())?View2.size():(Offset2+WindowSize);
      View2.sliceWindow(Offset2, EndWindow2);

      NeedlemanWunschSA<ArrayView<ContainerType>, Ty, Blank, MatchFnTy> SA(
                               BaseType::getScoring(),
                               BaseType::getMatchOperation());

      AlignedSequence<Ty,Blank> NWRes = SA.getAlignment(View1, View2);

      Res.splice(NWRes);

      Offset1 = EndWindow1;
      Offset2 = EndWindow2;

      //Finished Seq1 or Seq2
      if (Offset1>=Seq1.size()) {
        //Copy the remaining entries from Seq2
        if (Offset2<Seq2.size()) {
		      ArrayView< ContainerType > View2(Seq2);
		      View2.sliceWindow(Offset2, Seq2.size());
          for (auto Char : View2)
            Res.Data.push_back(typename BaseType::EntryType(Blank,Char,false));
        }
      } else if (Offset2>=Seq2.size()) {
        //Copy the remaining entries from Seq1
        if (Offset1<Seq1.size()) {
		      ArrayView< ContainerType > View1(Seq1);
		      View1.sliceWindow(Offset1, Seq1.size());
          for (auto Char : View1)
            Res.Data.push_back(typename BaseType::EntryType(Char,Blank,false));
        }
      }
    }

    return Res;
  }

};

