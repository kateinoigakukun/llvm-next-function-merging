; RUN: %opt -S --passes=func-merging < %s | FileCheck %s  --check-prefix=F3M
; RUN: %opt -S --passes=multiple-func-merging < %s | FileCheck %s

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

; F3M-LABEL: define internal i64 @_m_f_0(i1 %0, i32* %1, i32* %2) {
; F3M-NEXT:  entry:
; F3M-NEXT:    store i32 4, i32* %1, align 4
; F3M-NEXT:    store i32 6, i32* %2, align 4
; F3M-NEXT:    %3 = select i1 %0, i64 42, i64 0
; F3M-NEXT:    ret i64 %3
; F3M-NEXT:  }

; CHECK-LABEL: define internal i64 @__msa_merge_Bfunc_Afunc(i32 %discriminator, i32* %m.P.P, i32* %m.Q.Q) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 4, i32* %m.P.P, align 4
; CHECK-NEXT:    store i32 6, i32* %m.Q.Q, align 4
; CHECK-NEXT:    %discriminator.bit = trunc i32 %discriminator to i1
; CHECK-NEXT:    %switch.select = select i1 %discriminator.bit, i64 0, i64 42
; CHECK-NEXT:    ret i64 %switch.select
; CHECK-NEXT:  }
