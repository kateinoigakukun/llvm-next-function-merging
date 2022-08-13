; RUN: %opt %s -S --passes=multiple-func-merging --func-merging-explore=4 \
; RUN:   --multiple-func-merging-only=bitcount \
; RUN:   --multiple-func-merging-only=ntbl_bitcount \
; RUN:   --multiple-func-merging-only=AR_btbl_bitcount \
; RUN:   --multiple-func-merging-only=ntbl_bitcnt | not FileCheck %s

; CHECK-LABEL: define internal i32 @__msa_merge_bitcount_ntbl_bitcount_AR_btbl_bitcount_ntbl_bitcnt(i2 %discriminator, i64 %m.0.0.0.0) 
; CHECK-NEXT:  entry:
; CHECK:         unreachable
; CHECK:       }


target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@bits = external hidden global [256 x i8], align 16
@bits.1 = external hidden global [256 x i8], align 16

define i32 @bitcount(i64 %0) {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  store i64 undef, i64* %2, align 8
  ret i32 undef
}

define i32 @ntbl_bitcount(i64 %0) {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  ret i32 undef
}

define i32 @AR_btbl_bitcount(i64 %0) {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  ret i32 undef
}

define i32 @ntbl_bitcnt(i64 %0) {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  ret i32 undef
}
