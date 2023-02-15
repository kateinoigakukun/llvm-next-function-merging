; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-identical-type=true -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -pass-remarks-output=- %s -o /dev/null | FileCheck %s --check-prefix=CHECK-MFM
; RUN: %opt -mergefunc -func-merging -func-merging-operand-reorder=false -func-merging-coalescing=false -func-merging-whole-program=true -func-merging-matcher-report=false -func-merging-debug=false -func-merging-verbose=false  -pass-remarks-filter=func-merging -hyfm-profitability=true -func-merging-f3m=true -adaptive-threshold=false -adaptive-bands=false -hyfm-f3m-rows=2 -hyfm-f3m-bands=100 -shingling-cross-basic-blocks=true -ranking-distance=1.0 -bucket-size-cap=100 -func-merging-report=false -func-merging-hyfm-nw=true -pass-remarks-output=- %s -o /dev/null | FileCheck %s --check-prefix=CHECK-F3M
; CHECK-MFM:      Function:        __msa_merge___ckd_realloc_____ckd_malloc__
; CHECK-MFM-NEXT: Args:
; CHECK-MFM-NEXT:   - Function:        __ckd_realloc__
; CHECK-MFM-NEXT:   - Function:        __ckd_malloc__
; CHECK-MFM-NEXT:   - MergedSize:      '23'
; CHECK-MFM-NEXT:   - ThunkOverhead:   '0'
; CHECK-MFM-NEXT:   - OriginalTotalSize: '25'
; CHECK-F3M:      Function:        __fm_merge___ckd_realloc_____ckd_malloc__
; CHECK-F3M-NEXT: Args:
; CHECK-F3M-NEXT:   - Function:        __ckd_realloc__
; CHECK-F3M-NEXT:   - Function:        __ckd_malloc__
; CHECK-F3M-NEXT:   - MergedSize:      '23'
; CHECK-F3M-NEXT:   - ThunkOverhead:   '0'
; CHECK-F3M-NEXT:   - OriginalTotalSize: '25'
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/CodeGen/spec2006/482.sphinx3/_main_._all_._files_._linked_.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.__va_list_tag = type { i32, i32, i8*, i8* }

@.str.3.433 = external dso_local unnamed_addr constant [31 x i8], align 1
@.str.4.436 = external dso_local unnamed_addr constant [32 x i8], align 1
@stderr = external local_unnamed_addr global %struct._IO_FILE*, align 8

declare i32 @fflush() local_unnamed_addr

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

declare void @exit() local_unnamed_addr

declare void @perror() local_unnamed_addr

define i8* @__ckd_malloc__(i64 %size, i8* %caller_file, i32 %caller_line) local_unnamed_addr {
entry:
  %call = tail call i8* @malloc(i64 %size)
  %cmp = icmp eq i8* %call, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  tail call void @_E__pr_header(i8* poison, i64 109, i8* poison)
  tail call void (i8*, ...) @_E__die_error(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.3.433, i64 0, i64 0), i64 %size, i8* %caller_file, i32 %caller_line)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret i8* %call
}

declare i8* @malloc(i64) local_unnamed_addr

define i8* @__ckd_realloc__(i8* %ptr, i64 %new_size, i8* %caller_file, i32 %caller_line) local_unnamed_addr {
entry:
  %call = tail call i8* @realloc(i8* %ptr, i64 %new_size)
  %cmp = icmp eq i8* %call, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  tail call void @_E__pr_header(i8* poison, i64 121, i8* poison)
  tail call void (i8*, ...) @_E__die_error(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4.436, i64 0, i64 0), i64 %new_size, i8* %caller_file, i32 %caller_line)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret i8* %call
}

declare i8* @realloc(i8*, i64) local_unnamed_addr

declare void @_E__pr_header(i8*, i64, i8*) local_unnamed_addr

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.va_start(i8*) #1

declare i32 @vfprintf(%struct._IO_FILE*, %struct.__va_list_tag*) local_unnamed_addr

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.va_end(i8*) #1

define void @_E__die_error(i8* %fmt, ...) local_unnamed_addr {
entry:
  %pvar = alloca [1 x %struct.__va_list_tag], align 16
  %0 = bitcast [1 x %struct.__va_list_tag]* %pvar to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %0) #2
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %pvar, i64 0, i64 0
  call void @llvm.va_start(i8* %0)
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !0
  %call = call i32 @vfprintf(%struct._IO_FILE* %1, %struct.__va_list_tag* %arraydecay)
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !0
  %call3 = call i32 @fflush()
  %call6 = call i32 @fflush()
  call void @exit()
  unreachable
}

define void @_E__fatal_sys_error(i8* nocapture %fmt, ...) local_unnamed_addr {
entry:
  %pvar = alloca [1 x %struct.__va_list_tag], align 16
  %0 = bitcast [1 x %struct.__va_list_tag]* %pvar to i8*
  call void @exit()
  unreachable
}

declare i32 @_IO_putc() local_unnamed_addr

define void @_E__sys_error(...) local_unnamed_addr {
entry:
  %pvar = alloca [1 x %struct.__va_list_tag], align 16
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull undef) #2
  %arraydecay = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %pvar, i64 0, i64 0
  call void @llvm.va_start(i8* undef)
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !0
  %call = call i32 @vfprintf(%struct._IO_FILE* %0, %struct.__va_list_tag* %arraydecay)
  call void @llvm.va_end(i8* undef)
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !0
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !0
  %call7 = call i32 @fflush()
  call void @llvm.lifetime.end.p0i8(i64 24, i8* undef)
  ret void
}

define void @_E__abort_error(i8* nocapture %fmt, ...) local_unnamed_addr {
entry:
  %pvar = alloca [1 x %struct.__va_list_tag], align 16
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !0
  %call = call i32 @vfprintf(%struct._IO_FILE* %0, %struct.__va_list_tag* undef)
  unreachable
}

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync nounwind willreturn }
attributes #2 = { nounwind }

!0 = !{!1, !1, i64 0}
!1 = !{!"any pointer", !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C/C++ TBAA"}
