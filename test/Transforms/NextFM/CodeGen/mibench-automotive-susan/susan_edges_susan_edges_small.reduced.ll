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

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

; Function Attrs: noinline optnone
define i32 @susan_edges(i8* %0, i8* %1) #1 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  br label %6

6:                                                ; preds = %2
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  br label %10

10:                                               ; preds = %9
  br label %11

11:                                               ; preds = %10
  br label %12

12:                                               ; preds = %11
  br i1 undef, label %13, label %14

13:                                               ; preds = %12
  ret i32 undef

14:                                               ; preds = %12
  br label %15

15:                                               ; preds = %14
  br label %16

16:                                               ; preds = %15
  store i32 undef, i32* %5, align 4
  %17 = load i8*, i8** undef, align 8
  ret i32 undef
}

declare double @sqrt()

; Function Attrs: noinline optnone
define i32 @susan_edges_small() #1 {
  br label %1

1:                                                ; preds = %0
  br label %2

2:                                                ; preds = %1
  br label %3

3:                                                ; preds = %2
  br label %4

4:                                                ; preds = %3
  br label %5

5:                                                ; preds = %4
  br label %6

6:                                                ; preds = %5
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  store i32 undef, i32* undef, align 4
  store i32 undef, i32* undef, align 4
  %9 = load i8*, i8** undef, align 8
  ret i32 undef
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
attributes #1 = { noinline optnone }
