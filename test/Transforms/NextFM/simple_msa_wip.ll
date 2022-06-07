; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 3 -disable-verify < %s | FileCheck %s

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

; CHECK-LABEL: define internal i64 @__msa_merge_Cfunc_Bfunc_Afunc_(i32 %discriminator, i32* %0, i32* %1, i32* %2, i32* %3) {
; CHECK-NEXT:  switch.blackhole:
; CHECK-NEXT:    unreachable
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb:                                        ; preds = %src.bb6, %src.bb4, %src.bb
; CHECK-NEXT:    store i32 2, <null operand!>, align 4
; CHECK-NEXT:    switch i32 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i32 0, label %m.inst.bb1
; CHECK-NEXT:      i32 1, label %m.inst.bb1
; CHECK-NEXT:      i32 2, label %m.inst.bb1
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb1:                                       ; preds = %m.inst.bb, %m.inst.bb, %m.inst.bb
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    switch i32 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i32 0, label %split.bb
; CHECK-NEXT:      i32 1, label %split.bb5
; CHECK-NEXT:      i32 2, label %split.bb7
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb2:                                       ; preds = %split.bb7, %split.bb5, %split.bb
; CHECK-NEXT:    store i32 7, <null operand!>, align 4
; CHECK-NEXT:    switch i32 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i32 0, label %m.inst.bb3
; CHECK-NEXT:      i32 1, label %m.inst.bb3
; CHECK-NEXT:      i32 2, label %m.inst.bb3
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb3:                                       ; preds = %m.inst.bb2, %m.inst.bb2, %m.inst.bb2
; CHECK-NEXT:    store i32 8, <null operand!>, align 4
; CHECK-NEXT:    switch i32 %discriminator, label %switch.blackhole [
; CHECK-NEXT:      i32 0, label %m.term.bb
; CHECK-NEXT:      i32 1, label %m.term.bb
; CHECK-NEXT:      i32 2, label %m.term.bb
; CHECK-NEXT:    ]
; CHECK-EMPTY:
; CHECK-NEXT:  m.term.bb:                                        ; preds = %m.inst.bb3, %m.inst.bb3, %m.inst.bb3
; CHECK-NEXT:    ret i64 undef
; CHECK-EMPTY:
; CHECK-NEXT:  src.bb:                                           ; No predecessors!
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb:                                         ; preds = %m.inst.bb1
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    store i32 6, <null operand!>, align 4
; CHECK-NEXT:    br label %m.inst.bb2
; CHECK-EMPTY:
; CHECK-NEXT:  src.bb4:                                          ; No predecessors!
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb5:                                        ; preds = %m.inst.bb1
; CHECK-NEXT:    store i32 6, <null operand!>, align 4
; CHECK-NEXT:    br label %m.inst.bb2
; CHECK-EMPTY:
; CHECK-NEXT:  src.bb6:                                          ; No predecessors!
; CHECK-NEXT:    br label %m.inst.bb
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb7:                                        ; preds = %m.inst.bb1
; CHECK-NEXT:    store i32 6, <null operand!>, align 4
; CHECK-NEXT:    br label %m.inst.bb2
; CHECK-NEXT:  }
