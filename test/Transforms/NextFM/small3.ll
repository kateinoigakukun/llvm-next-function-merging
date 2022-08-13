; RUN: %opt -S --passes=func-merging < %s | FileCheck %s

; Afunc and Bfunc differ only in that one returns 0, the other 42.
; These should be merged.
define internal i64 @Afunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  ret i64 0
}

define internal i64 @Bfunc(i32* %P, i32* %Q) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  ret i64 42
}

define internal i64 @Cfunc(i32* %P, i32* %Q) {
  store i32 2, i32* %P
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  store i32 6, i32* %Q
  ret i64 0
}

define void @public_call(i32* %P, i32* %Q) {
  call i64 @Afunc(i32* %P, i32* %Q)
  call i64 @Bfunc(i32* %P, i32* %Q)
  call i64 @Cfunc(i32* %P, i32* %Q)
  ret void
}

; CHECK-LABEL: define internal i64 @__fm_merge___fm_merge_Cfunc_Afunc_Bfunc(i1 %discriminator, i1 %m.discriminator, i32* %m.m.P.P.P, i32* %m.m.Q.Q.Q) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = select i1 %m.discriminator, i32 4, i32 2
; CHECK-NEXT:    %.0 = select i1 %discriminator, i32 undef, i32 %0
; CHECK-NEXT:    %1 = select i1 %discriminator, i32 4, i32 %.0
; CHECK-NEXT:    store i32 %1, i32* %m.m.P.P.P, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    %2 = select i1 %discriminator, i64 42, i64 0
; CHECK-NEXT:    ret i64 %2
; CHECK-NEXT:  }

