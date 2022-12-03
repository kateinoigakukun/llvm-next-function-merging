; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=get_app0 --multiple-func-merging-only=get_app14 -o %t.mfm.ll %s

; ModuleID = 'test/Transforms/NextFM/CodeGen/libjpeg/get_app0_get_app14.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define hidden i32 @get_app0() {
  %1 = icmp eq i32 undef, 74
  ret i32 undef
}

define hidden i32 @get_app14() {
  %1 = load i64, i64* undef, align 8
  %2 = icmp eq i64 %1, 0
  ret i32 undef
}
