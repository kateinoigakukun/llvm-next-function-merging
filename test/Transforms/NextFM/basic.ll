; RUN: %opt -S --func-merging < %s | FileCheck %s

; Afunc and Bfunc differ only in that one returns 0, the other 42.
; These should be merged.
define internal i64 @Afunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret i64 0
}

define internal i64 @Bfunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret i64 42
}

; CHECK-LABEL: define internal i64 @_m_f_0(i1 %0, i32* %1, i32* %2) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 4, i32* %1, align 4
; CHECK-NEXT:    store i32 6, i32* %2, align 4
; CHECK-NEXT:    %3 = select i1 %0, i64 42, i64 0
; CHECK-NEXT:    ret i64 %3
; CHECK-NEXT:  }
