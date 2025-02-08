; RUN: %opt -S --passes=func-merging < %s | FileCheck %s  --check-prefix=F3M
; RUN: %opt -S --passes=multiple-func-merging < %s | FileCheck %s

; Afunc and Bfunc differ only in that one returns 0, the other 42.
; These should be merged.
define internal i32 @Afunc(i32* %P, i32* %Q, i1 %Y, i1 %Z, i32 %W) {
entry:
  store i32 4, i32* %P
  store i32 6, i32* %Q
  %A = load i32, i32* %P
  br i1 %Y, label %b0, label %b2
b0:
  store i32 0, i32* %P
  %B = load i32, i32* %Q
  br i1 %Z, label %b1, label %b2
b1:
  store i32 42, i32* %P
  br label %b2
b2:
  %X = phi i32 [ %A, %entry ], [ %B, %b0 ]; , [ %W, %b1 ]
  ret i32 %X
}

define internal i32 @Bfunc(i32* %P, i32* %Q, i1 %Y) {
entry:
  store i32 4, i32* %P
  store i32 6, i32* %Q
  %A = load i32, i32* %P
  br i1 %Y, label %b0, label %b1
b0:
  store i32 42, i32* %P
  %B = load i32, i32* %Q
  br label %b1
b1:
  %X = phi i32 [ %A, %entry ], [ %B, %b0 ]
  ret i32 %X
}

