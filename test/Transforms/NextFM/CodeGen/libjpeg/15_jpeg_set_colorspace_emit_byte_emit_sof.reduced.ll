; RUN: %opt --passes='multiple-func-merging' --multiple-func-merging-disable-post-opt -func-merging-explore=2 '--multiple-func-merging-only=jpeg_set_colorspace' '--multiple-func-merging-only=emit_byte' '--multiple-func-merging-only=emit_sof' %s -o %t.opt.three.bc

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define hidden void @emit_byte() {
  %1 = icmp eq i64 undef, 0
  br i1 %1, label %2, label %3

2:                                                ; preds = %0
  ret void

3:                                                ; preds = %0
  ret void
}

define hidden void @emit_sof() {
  %1 = icmp sgt i64 undef, 65535
  br i1 %1, label %3, label %2

2:                                                ; preds = %0
  br label %3

3:                                                ; preds = %2, %0
  ret void
}

define void @jpeg_set_colorspace() {
  ret void
}
