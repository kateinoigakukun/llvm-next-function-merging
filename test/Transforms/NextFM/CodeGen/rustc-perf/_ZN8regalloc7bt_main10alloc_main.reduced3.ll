; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging %s | FileCheck %s
; CHECK:      --- !Missed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            UnprofitableMerge

; ModuleID = 'test/Transforms/NextFM/CodeGen/rustc-perf/_ZN8regalloc7bt_main10alloc_main.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%A = type { i64, [2 x i64] }
%B = type { i64, [2 x i64] }

declare hidden void @take_a_ptr(%A*)
declare hidden void @take_b_ptr(%B*)

define hidden void @_ZN8regalloc7bt_main10alloc_main17hff001664e8376445E() {
  %1 = alloca %A, align 8
  call void @take_a_ptr(%A* %1)
  ret void
}

define hidden void @_ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E() {
  %1 = alloca %B, align 8
  call void @take_b_ptr(%B* %1)
  ret void
}
