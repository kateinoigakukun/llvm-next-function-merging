; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=get_interlaced_row --multiple-func-merging-only=get_8bit_row.267 -o %t.mfm.ll %s
; RUN: %opt -S --passes="func-merging" --func-merging-only=get_interlaced_row --func-merging-only=get_8bit_row.267 -o %t.fm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.fm.ll -o %t.fm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.fm.o
; RUN: test $(stat -c%%s %t.mfm.o) -le $(stat -c%%s %t.fm.o)

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define hidden i32 @get_interlaced_row() {
  switch i32 undef, label %2 [
    i32 0, label %1
  ]

1:                                                ; preds = %0
  ret i32 undef

2:                                                ; preds = %0
  ret i32 undef
}

define hidden i32 @get_8bit_row.267() {
  %1 = load i32*, i32** undef, align 8
  ret i32 undef
}
