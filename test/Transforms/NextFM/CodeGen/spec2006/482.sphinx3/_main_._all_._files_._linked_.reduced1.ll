; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-identical-type=true -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -pass-remarks-output=- %s -o /dev/null | FileCheck %s --check-prefix=CHECK-MFM
; RUN: %opt -mergefunc -func-merging -func-merging-operand-reorder=false -func-merging-coalescing=false -func-merging-whole-program=true -func-merging-matcher-report=false -func-merging-debug=false -func-merging-verbose=false  -pass-remarks-filter=func-merging -hyfm-profitability=true -func-merging-f3m=true -adaptive-threshold=false -adaptive-bands=false -hyfm-f3m-rows=2 -hyfm-f3m-bands=100 -shingling-cross-basic-blocks=true -ranking-distance=1.0 -bucket-size-cap=100 -func-merging-report=false -func-merging-hyfm-nw=true -pass-remarks-output=- %s -o /dev/null | FileCheck %s --check-prefix=CHECK-F3M
; CHECK-MFM:      Function:        __mf_merge_glist_add_float64_glist_add_float32
; CHECK-MFM-NEXT: Args:
; CHECK-MFM-NEXT:   - Function:        glist_add_float64
; CHECK-MFM-NEXT:   - Function:        glist_add_float32
; CHECK-F3M:      Function:        __fm_merge_glist_add_float64_glist_add_float32
; CHECK-F3M-NEXT: Args:
; CHECK-F3M-NEXT:   - Function:        glist_add_float64
; CHECK-F3M-NEXT:   - Function:        glist_add_float32
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/CodeGen/spec2006/482.sphinx3/_main_._all_._files_._linked_.reduced0.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.mylist_s = type { i8**, %struct.mylist_s*, i32, i32, i32 }
%struct.gnode_s = type { %union.anytype_s, %struct.gnode_s* }
%union.anytype_s = type { i8* }

@head = external unnamed_addr global %struct.mylist_s*, align 8

define %struct.gnode_s* @glist_add_float32(%struct.gnode_s* %g, float %val) local_unnamed_addr {
entry:
  %call = tail call i8* @__mymalloc__(i32 16, i8* poison, i32 102)
  %0 = bitcast i8* %call to %struct.gnode_s*
  %float32 = bitcast i8* %call to float*
  store float %val, float* %float32, align 8, !tbaa !0
  %next = getelementptr inbounds i8, i8* %call, i64 8
  %1 = bitcast i8* %next to %struct.gnode_s**
  store %struct.gnode_s* %g, %struct.gnode_s** %1, align 8, !tbaa !3
  ret %struct.gnode_s* %0
}

define %struct.gnode_s* @glist_add_float64(%struct.gnode_s* %g, double %val) local_unnamed_addr {
entry:
  %call = tail call i8* @__mymalloc__(i32 16, i8* poison, i32 113)
  %0 = bitcast i8* %call to %struct.gnode_s*
  %float64 = bitcast i8* %call to double*
  store double %val, double* %float64, align 8, !tbaa !0
  %next = getelementptr inbounds i8, i8* %call, i64 8
  %1 = bitcast i8* %next to %struct.gnode_s**
  store %struct.gnode_s* %g, %struct.gnode_s** %1, align 8, !tbaa !3
  ret %struct.gnode_s* %0
}

declare i8* @__ckd_calloc__() local_unnamed_addr

define i8* @__mymalloc__(i32 %elemsize, i8* %caller_file, i32 %caller_line) local_unnamed_addr {
entry:
  %list.0109 = load %struct.mylist_s*, %struct.mylist_s** @head, align 8, !tbaa !6
  br label %land.rhs.preheader

land.rhs.preheader:                               ; preds = %entry
  br i1 undef, label %if.else, label %for.body

for.body:                                         ; preds = %land.rhs.preheader
  %tobool.not = icmp eq %struct.mylist_s* undef, null
  ret i8* undef

if.else:                                          ; preds = %land.rhs.preheader
  ret i8* undef
}

define void @__myfree__() local_unnamed_addr {
entry:
  %list.028 = load %struct.mylist_s*, %struct.mylist_s** @head, align 8, !tbaa !6
  %tobool.not29 = icmp eq %struct.mylist_s* %list.028, null
  ret void
}

declare void @_E__pr_header() local_unnamed_addr

!0 = !{!1, !1, i64 0}
!1 = !{!"omnipotent char", !2, i64 0}
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!4, !5, i64 8}
!4 = !{!"gnode_s", !1, i64 0, !5, i64 8}
!5 = !{!"any pointer", !1, i64 0}
!6 = !{!5, !5, i64 0}
