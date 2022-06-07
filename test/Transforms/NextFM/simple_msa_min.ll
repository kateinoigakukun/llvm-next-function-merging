; RUN: %opt -S --enable-new-pm=false --func-merging < %s | FileCheck %s
; XFAIL: *

declare void @extern_func_1()
declare void @extern_func_2()
; Afunc and Bfunc differ only in that one returns 0, the other 42.
; These should be merged.
define internal i64 @Afunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret i64 0
}

define internal i64 @Bfunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 4, i32* %P
  store i32 6, i32* %Q
  ret i64 42
}

define internal i64 @Cfunc(i32* %P, i32* %Q, i32* %R, i32* %S) {
  store i32 2, i32* %P
  call void @extern_func_1()
  store i32 6, i32* %Q
  ret i64 0
}

define void @public_call(i32* %P, i32* %Q, i32* %R, i32* %S) {
  call i64 @Afunc(i32* %P, i32* %Q, i32* %R, i32* %S)
  call i64 @Bfunc(i32* %P, i32* %Q, i32* %R, i32* %S)
  call i64 @Cfunc(i32* %P, i32* %Q, i32* %R, i32* %S)
  ret void
}

; CHECK-LABEL: define internal i64 @_m_f_{{.*}}(i1 %0, i1 %1, i32* %2, i32* %3) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %3 = select i1 %0, i32 2, i32 4
; CHECK-NEXT:    store i32 %3, i32* %1, align 4
; CHECK-NEXT:    br i1 %0, label %fm.Cfunc.bb1, label %fm.Afunc.Bfunc.bb1
;
; CHECK-NEXT:  fm.Afunc.Bfunc.bb1:
; CHECK-NEXT:    br i1 %1, label %fm.Afunc.bb1, label %fm.Bfunc.bb1
;
; CHECK-NEXT:  fm.shared.bb1:
; CHECK-NEXT:    store i32 6, i32* %2, align 4
; CHECK-NEXT:    store i32 6, i32* %2, align 4
; CHECK-NEXT:    store i32 6, i32* %2, align 4
; CHECK-NEXT:    store i32 6, i32* %2, align 4
; CHECK-NEXT:    %4 = select i1 %0, i64 0, i64 42
; CHECK-NEXT:    ret i64 %4
;
; CHECK-NEXT:  fm.Afunc.bb1:
; CHECK-NEXT:    call void @extern_func_1()
; CHECK-NEXT:    br label %fm.shared.bb1
;
; CHECK-NEXT:  fm.Bfunc.bb1:
; CHECK-NEXT:    call void @extern_func_2()
; CHECK-NEXT:    br label %fm.shared.bb1
;
; CHECK-NEXT:  fm.Cfunc.bb1:
; CHECK-NEXT:    store i32 6, i32* %2, align 4
; CHECK-NEXT:    br label %fm.shared.bb1
; CHECK-NEXT: }

