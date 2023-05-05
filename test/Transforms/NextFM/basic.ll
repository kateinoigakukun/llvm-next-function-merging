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

; F3M-LABEL: define internal i64 @__fm_merge_Bfunc_Afunc(i1 %discriminator, i32* %m.P.P, i32* %m.Q.Q) {
; F3M-NEXT:  entry:
; F3M-NEXT:    store i32 4, i32* %m.P.P, align 4
; F3M-NEXT:    store i32 6, i32* %m.Q.Q, align 4
; F3M-NEXT:    %switch.select = select i1 %discriminator, i64 0, i64 42
; F3M-NEXT:    ret i64 %switch.select
; F3M-NEXT:  }

; CHECK-LABEL: define internal i64 @__mf_merge_Bfunc_Afunc(i1 %discriminator, i32* %m.P.P, i32* %m.Q.Q) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 4, i32* %m.P.P, align 4
; CHECK-NEXT:    store i32 6, i32* %m.Q.Q, align 4
; CHECK-NEXT:    %switch.select = select i1 %discriminator, i64 0, i64 42
; CHECK-NEXT:    ret i64 %switch.select
; CHECK-NEXT:  }
