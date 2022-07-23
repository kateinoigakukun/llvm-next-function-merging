; RUN: %opt --passes='multiple-func-merging' -func-merging-explore=1 -multiple-func-merging-allow-unprofitable --multiple-func-merging-disable-post-opt %s -o %t.opt.bc
; RUN: %llc --filetype=obj %t.opt.bc -o %t.opt.o
; RUN: %clang -Wno-all -Wno-pointer-sign -Wno-literal-conversion %t.opt.o %S/Inputs/0_multiple-func-merging_Alignment.reduced.driver.c -lm -o %t.opt
; RUN: %clang -Wno-all -Wno-pointer-sign -Wno-literal-conversion %s %S/Inputs/0_multiple-func-merging_Alignment.reduced.driver.c -lm -o %t.safe
; RUN: %t.safe %S/Inputs/input_small.pgm %t.output_small.edges.pgm -e
; RUN: not %t.opt %S/Inputs/input_small.pgm %t.output_small.edges.pgm -e
; RUN: %t.opt %S/Inputs/input_small.pgm %t.output_small.edges.pgm -e
; XFAIL: *

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @susan_edges(i8* %in, i32 %x_size, i32 %y_size) {
entry:
  %in.addr = alloca i8*, align 8
  %x_size.addr = alloca i32, align 4
  %y_size.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i8* %in, i8** %in.addr, align 8
  store i32 %x_size, i32* %x_size.addr, align 4
  store i32 %y_size, i32* %y_size.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* %y_size.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i8*, i8** %in.addr, align 8
  %3 = load i8, i8* %2, align 1
  %conv = zext i8 %3 to i32
  %4 = load i32, i32* %x_size.addr, align 4
  %add = add nsw i32 %4, %conv
  store i32 %add, i32* %x_size.addr, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %5 = load i32, i32* %i, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond, !llvm.loop !4

for.end:                                          ; preds = %for.cond
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @susan_edges_small(i8* %in, i32 %x_size, i32 %y_size) {
entry:
  %in.addr = alloca i8*, align 8
  %x_size.addr = alloca i32, align 4
  %y_size.addr = alloca i32, align 4
  %n = alloca i32, align 4
  %p = alloca i8*, align 8
  %i = alloca i32, align 4
  store i8* %in, i8** %in.addr, align 8
  store i32 %x_size, i32* %x_size.addr, align 4
  store i32 %y_size, i32* %y_size.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* %y_size.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i8*, i8** %p, align 8
  %3 = load i8, i8* %2, align 1
  %conv = zext i8 %3 to i32
  %4 = load i32, i32* %n, align 4
  %add = add nsw i32 %4, %conv
  store i32 %add, i32* %n, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %5 = load i32, i32* %i, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond, !llvm.loop !6

for.end:                                          ; preds = %for.cond
  ret i32 0
}

!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.mustprogress"}
!6 = distinct !{!6, !5}
