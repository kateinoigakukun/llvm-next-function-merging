#ifndef LLVM_ADT_ARRAY_VIEW
#define LLVM_ADT_ARRAY_VIEW

template<typename ArrayBaseType>
class ArrayView {
public:
  using iterator = typename ArrayBaseType::iterator;
  using reverse_iterator = typename ArrayBaseType::reverse_iterator;
  using value_type = typename ArrayBaseType::value_type;

private:
  iterator  Begin;
  iterator  End;
  reverse_iterator RBegin;
  reverse_iterator REnd;
  size_t Size;

public:

  ArrayView(ArrayBaseType &Arr) {
    Begin=Arr.begin();
    End=Arr.end();
    RBegin=Arr.rbegin();
    REnd=Arr.rend();
    Size=End-Begin;
  }

  ArrayView(iterator  Begin, iterator  End,
            reverse_iterator RBegin, reverse_iterator REnd)
            : Begin(Begin), End(End), RBegin(RBegin), REnd(REnd) {
    Size = End-Begin;
  }

  iterator  begin() { return Begin; }
  iterator  end() { return End; }
  reverse_iterator rbegin() { return RBegin; }
  reverse_iterator rend() { return REnd; }

  size_t size() { return Size; }

  void sliceWindow(size_t StartOffset, size_t EndOffset) {
    End    = Begin+EndOffset;
    Begin  = Begin+StartOffset;
    REnd   = RBegin+(Size-StartOffset);
    RBegin = RBegin+(Size-EndOffset);
    Size = End-Begin;
  }

  value_type &operator[](size_t Index) {
    return *(Begin+Index);
  }

};

#endif
