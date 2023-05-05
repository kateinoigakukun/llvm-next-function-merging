; RUN: %opt -S --passes=multiple-func-merging < %s | FileCheck %s

define internal i64 @Afunc(i32* %Q, i32* %P) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret i64 0
}

define internal i64 @Bfunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret i64 42
}

; CHECK-LABEL: define internal i64 @__mf_merge_Bfunc_Afunc(i1 %discriminator, i32* %m.P.P, i32* %m.Q.Q) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 4, i32* %m.P.P, align 4
; CHECK-NEXT:    store i32 6, i32* %m.Q.Q, align 4
; CHECK-NEXT:    %switch.select = select i1 %discriminator, i64 0, i64 42
; CHECK-NEXT:    ret i64 %switch.select
; CHECK-NEXT:  }
