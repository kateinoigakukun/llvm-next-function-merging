; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 3 < %s | FileCheck %s

declare void @extern_func_1()
declare void @extern_func_2()
; Afunc and Bfunc differ only in that one returns 0, the other 42.
; These should be merged.
define internal i64 @Afunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 4, i32* %P
  call void @extern_func_1()
  store i32 6, i32* %Q
  store i32 7, i32* %R
  store i32 8, i32* %S
  ret i64 0
}

define internal i64 @Bfunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 4, i32* %P
  call void @extern_func_2()
  store i32 6, i32* %Q
  store i32 7, i32* %R
  store i32 8, i32* %S
  ret i64 42
}

define internal i64 @Cfunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 2, i32* %P
  call void @extern_func_2()
  call void @extern_func_2()
  store i32 6, i32* %Q
  store i32 7, i32* %R
  store i32 8, i32* %S
  ret i64 0
}

define void @public_call(i32* %P, i32* %Q, i32* %R, i32* %S) {
  call i64 @Afunc(i32* %P, i32* %Q, i32* %R, i32* %S)
  call i64 @Bfunc(i32* %P, i32* %Q, i32* %R, i32* %S)
  call i64 @Cfunc(i32* %P, i32* %Q, i32* %R, i32* %S)
  ret void
}

; CHECK-LABEL: define internal i64 @__msa_merge_Cfunc_Bfunc_Afunc_(i32 %discriminator, i32* %m.P.P.P, i32* %m.Q.Q.Q, i32* %m.R.R.R, i32* %m.S.S.S) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i32 0, label %m.inst.bb
; CHECK-NEXT:      i32 1, label %bb.select10
; CHECK-NEXT:      i32 2, label %bb.select11
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  switch.blackhole:                                 ; preds = %entry, %m.inst.bb
; CHECK-NEXT:    unreachable
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb:                                        ; preds = %entry, %bb.select11, %bb.select10
; CHECK-NEXT:    %0 = phi i32 [ 4, %bb.select10 ], [ 4, %bb.select11 ], [ 2, %entry ]
; CHECK-NEXT:    store i32 %0, i32* %m.P.P.P, align 4
; CHECK-NEXT:    switch i32 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i32 0, label %split.bb
; CHECK-NEXT:      i32 1, label %split.bb4
; CHECK-NEXT:      i32 2, label %split.bb5
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb1:                                       ; preds = %split.bb5, %split.bb4, %split.bb
; CHECK-NEXT:    store i32 6, i32* %m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 7, i32* %m.R.R.R, align 4
; CHECK-NEXT:    store i32 8, i32* %m.S.S.S, align 4
; CHECK-NEXT:    %discriminator.off = add i32 %discriminator, -1
; CHECK-NEXT:    %switch = icmp ult i32 %discriminator.off, 1
; CHECK-NEXT:    %spec.select = select i1 %switch, i64 42, i64 0
; CHECK-NEXT:    ret i64 %spec.select
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb:                                         ; preds = %m.inst.bb
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb4:                                        ; preds = %m.inst.bb
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb5:                                        ; preds = %m.inst.bb
; CHECK-NEXT:    call void @extern_func_1()
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  bb.select10:                                      ; preds = %entry
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-EMPTY:
; CHECK-NEXT:  bb.select11:                                      ; preds = %entry
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-NEXT:  }

