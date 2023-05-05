; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -multiple-func-merging-allow-unprofitable < %s | FileCheck %s
; RUN: %opt -S --passes="func-merging" < %s | FileCheck %s --check-prefix=F3M
; FIXME(katei) Two merge is more profitable than three merge now.
; XFAIL: *

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

; CHECK-LABEL: define internal i64 @__mf_merge_Cfunc_Bfunc_Afunc(i2 %discriminator, i32* %m.P.P.P, i32* %m.Q.Q.Q, i32* %m.R.R.R, i32* %m.S.S.S) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i2 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i2 0, label %m.inst.bb
; CHECK-NEXT:      i2 1, label %bb.select.values.Bfunc7
; CHECK-NEXT:      i2 -2, label %bb.select.values.Afunc8
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  bb.select.values.Bfunc7:                          ; preds = %entry
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-EMPTY:
; CHECK-NEXT:  bb.select.values.Afunc8:                          ; preds = %entry
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb:                                        ; preds = %bb.select.values.Bfunc7, %bb.select.values.Afunc8, %entry
; CHECK-NEXT:    %0 = phi i32 [ 4, %bb.select.values.Bfunc7 ], [ 4, %bb.select.values.Afunc8 ], [ 2, %entry ]
; CHECK-NEXT:    store i32 %0, i32* %m.P.P.P, align 4
; CHECK-NEXT:    switch i2 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i2 0, label %Cfunc..split
; CHECK-NEXT:      i2 1, label %Bfunc..split
; CHECK-NEXT:      i2 -2, label %Afunc..split
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb1:                                       ; preds = %Afunc..split, %Bfunc..split, %Cfunc..split
; CHECK-NEXT:    store i32 6, i32* %m.Q.Q.Q, align 4
; CHECK-NEXT:    store i32 7, i32* %m.R.R.R, align 4
; CHECK-NEXT:    store i32 8, i32* %m.S.S.S, align 4
; CHECK-NEXT:    %discriminator.off = add i2 %discriminator, -1
; CHECK-NEXT:    %switch = icmp ult i2 %discriminator.off, 1
; CHECK-NEXT:    %spec.select = select i1 %switch, i64 42, i64 0
; CHECK-NEXT:    ret i64 %spec.select
; CHECK-EMPTY:
; CHECK-NEXT:  Cfunc..split:                                     ; preds = %m.inst.bb
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  Bfunc..split:                                     ; preds = %m.inst.bb
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  Afunc..split:                                     ; preds = %m.inst.bb
; CHECK-NEXT:    call void @extern_func_1()
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  switch.blackhole:                                 ; preds = %entry, %m.inst.bb
; CHECK-NEXT:    unreachable
; CHECK-NEXT:  }

; F3M-LABEL: define internal i64 @Bfunc(i32* %P, i32* %Q, i32* %R, i32* %S)
; F3M-NEXT:    store i32 4, i32* %P, align 4
; F3M-NEXT:    call void @extern_func_2()
; F3M-NEXT:    store i32 6, i32* %Q, align 4
; F3M-NEXT:    store i32 7, i32* %R, align 4
; F3M-NEXT:    store i32 8, i32* %S, align 4
; F3M-NEXT:    ret i64 42
; F3M-NEXT:  }
;
; F3M-LABEL: define internal i64 @__fm_merge_Cfunc_Afunc(i1 %discriminator, i32* %m.P.P, i32* %m.Q.Q, i32* %m.R.R, i32* %m.S.S) {
; F3M-NEXT:  entry:
; F3M-NEXT:    %0 = select i1 %discriminator, i32 2, i32 4
; F3M-NEXT:    store i32 %0, i32* %m.P.P, align 4
; F3M-NEXT:    br i1 %discriminator, label %Cfunc..split, label %Afunc..split
; F3M-EMPTY:
; F3M-NEXT:  m.inst.bb1:                                       ; preds = %Afunc..split, %Cfunc..split
; F3M-NEXT:    store i32 6, i32* %m.Q.Q, align 4
; F3M-NEXT:    store i32 7, i32* %m.R.R, align 4
; F3M-NEXT:    store i32 8, i32* %m.S.S, align 4
; F3M-NEXT:    ret i64 0
; F3M-EMPTY:
; F3M-NEXT:  Cfunc..split:                                     ; preds = %entry
; F3M-NEXT:    call void @extern_func_2()
; F3M-NEXT:    call void @extern_func_2()
; F3M-NEXT:    br label %m.inst.bb1
; F3M-EMPTY:
; F3M-NEXT:  Afunc..split:                                     ; preds = %entry
; F3M-NEXT:    call void @extern_func_1()
; F3M-NEXT:    br label %m.inst.bb1
; F3M-NEXT:  }
