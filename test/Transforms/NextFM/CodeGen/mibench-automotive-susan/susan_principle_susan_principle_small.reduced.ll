; RUN: %opt -S --passes="multiple-func-merging,default<Oz>" -func-merging-explore 1 -o %t.mfm.ll %s
; RUN: %opt -S --passes="func-merging,default<Oz>" -func-merging-explore 1 -o %t.fm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.fm.ll -o %t.fm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.fm.o
; RUN: [[ $(stat -c%%s %t.mfm.o) -le $(stat -c%%s %t.fm.o) ]]
; XFAIL: *

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline optnone
define i32 @susan_principle() #0 {
  br label %1

1:                                                ; preds = %6, %0
  %2 = sub nsw i32 undef, 3
  br label %3

3:                                                ; preds = %1
  store i32 3, i32* undef, align 4
  br label %4

4:                                                ; preds = %3
  br label %5

5:                                                ; preds = %4
  br label %6

6:                                                ; preds = %5
  br label %1, !llvm.loop !0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: noinline optnone
define i32 @susan_principle_small() #2 {
  %1 = alloca i32, align 4
  call void @llvm.memset.p0i8.i64(i8* undef, i8 0, i64 undef, i1 false)
  store i32 730, i32* %1, align 4
  br label %2

2:                                                ; preds = %0
  br label %3

3:                                                ; preds = %2
  br label %4

4:                                                ; preds = %3
  br label %5

5:                                                ; preds = %4
  ret i32 undef
}

attributes #0 = { noinline optnone }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
attributes #2 = { noinline optnone "frame-pointer"="all" }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.mustprogress"}
