; RUN: %opt -S --passes=func-merging -func-merging-f3m < %s | FileCheck %s

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
; CHECK-NEXT:    %switch.select = select i1 %m.discriminator, i32 4, i32 2
; CHECK-NEXT:    %memfy.0 = select i1 %discriminator, i32 undef, i32 %switch.select
; CHECK-NEXT:    %switch.select5 = select i1 %discriminator, i32 4, i32 %memfy.0
; CHECK-NEXT:    store i32 %switch.select5, i32* %m.m.P.P.P, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 6, i32* %m.m.Q.Q.Q, align 4
; CHECK-NEXT:    %switch.select6 = select i1 %discriminator, i64 42, i64 0
; CHECK-NEXT:    ret i64 %switch.select6
; CHECK-NEXT:  }

