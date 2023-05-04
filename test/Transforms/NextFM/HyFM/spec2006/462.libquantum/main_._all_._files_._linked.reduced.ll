; RUN: %opt --passes="mergefunc,func-merging" --func-merging-f3m -func-merging-explore=1 --func-merging-debug=false --func-merging-whole-program=true --func-merging-coalescing=false --func-merging-hyfm-nw -hyfm-profitability=true  -o %t.f3m-hyfm.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" -func-merging-explore=1 --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm-hyfm.bc %s
; RUN: %llc --filetype=obj %t.f3m-hyfm.bc -o %t.f3m-hyfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.f3m-hyfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -lt $(stat -c%%s %t.f3m-hyfm.o)
; XFAIL: *
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006/462.libquantum/main_._all_._files_._linked.reduced.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @quantum_char2int() local_unnamed_addr {
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %mul3 = shl i32 undef, undef
  %cmp.not = icmp eq i64 undef, 0
  br i1 %cmp.not, label %for.end, label %for.body, !llvm.loop !0

for.end:                                          ; preds = %for.body
  ret i32 undef
}

define void @emul(i32 %a, i32 %width) local_unnamed_addr {
entry:
  %mul = shl nsw i32 %width, 1
  %add = add nsw i32 %mul, 2
  %cmp10 = icmp sgt i32 %width, 0
  br i1 %cmp10, label %for.body, label %for.end

for.body:                                         ; preds = %for.inc, %entry
  %i.011.in = phi i32 [ %i.011, %for.inc ], [ %width, %entry ]
  %i.011 = add nsw i32 %i.011.in, -1
  %0 = shl nuw i32 1, %i.011
  %1 = and i32 %0, %a
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %for.inc, label %if.then

if.then:                                          ; preds = %for.body
  %add1 = add nsw i32 %i.011, %width
  br label %for.inc

for.inc:                                          ; preds = %if.then, %for.body
  %cmp = icmp sgt i32 %i.011.in, 1
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !2

for.end:                                          ; preds = %for.inc, %entry
  ret void
}

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
!2 = distinct !{!2, !1}
