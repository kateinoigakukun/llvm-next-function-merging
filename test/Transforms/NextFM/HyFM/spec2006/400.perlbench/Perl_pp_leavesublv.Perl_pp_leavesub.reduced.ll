; RUN: %opt -S --passes="mergefunc,multiple-func-merging" --debug-only=multiple-func-merging --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false -o %t.mfm.ll %s 2>%t.mfm.log | FileCheck %s
; RUN: %opt -S --passes="mergefunc,multiple-func-merging" --debug-only=multiple-func-merging --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.ll %s 2>%t.mfm-hyfm.log | FileCheck %s
; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.ll -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006/400.perlbench/Perl_pp_leavesublv.Perl_pp_leavesub.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.op.136 = type { %struct.op.136*, %struct.op.136*, {}*, i64, i16, i16, i8, i8 }
%struct.sv = type { i8*, i64, i64 }

define %struct.op.136* @Perl_pp_leavesub() {
if.then:
  br i1 undef, label %if.else57, label %if.then19

if.then19:                                        ; preds = %if.then
  br label %if.else51

if.else51:                                        ; preds = %if.then19
  br label %cond.end

cond.end:                                         ; preds = %if.else51
  br label %if.end84

if.else57:                                        ; preds = %if.then
  ret %struct.op.136* undef

if.end84:                                         ; preds = %cond.end
  tail call void @Perl_pop_scope()
  ret %struct.op.136* undef
}

define %struct.op.136* @Perl_pp_leavesublv() {
if.else741:
  switch i8 undef, label %if.end844 [
    i8 0, label %temporise
  ]

temporise:                                        ; preds = %if.else741
  ret %struct.op.136* undef

if.end844:                                        ; preds = %if.else741
  tail call void @Perl_pop_scope()
  store i64 undef, i64* undef, align 8, !tbaa !0
  ret %struct.op.136* undef
}

declare %struct.sv** @Perl_stack_grow() local_unnamed_addr

declare void @Perl_pop_scope() local_unnamed_addr

!0 = !{!1, !5, i64 16}
!1 = !{!"stackinfo", !2, i64 0, !2, i64 8, !5, i64 16, !5, i64 24, !5, i64 32, !2, i64 40, !2, i64 48, !5, i64 56}
!2 = !{!"any pointer", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!"long", !3, i64 0}
