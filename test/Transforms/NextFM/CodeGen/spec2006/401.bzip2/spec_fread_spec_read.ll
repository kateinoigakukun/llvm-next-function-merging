; RUN: %opt -S --passes="mergefunc,multiple-func-merging" -multiple-func-merging-whole-program=true -multiple-func-merging-identical-type=true -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -pass-remarks-output=- %s -o %t.mfm.ll
; RUN: %opt -S --passes="mergefunc,func-merging" -func-merging-operand-reorder=false -func-merging-coalescing=false -func-merging-whole-program=true -func-merging-matcher-report=false -func-merging-debug=false -func-merging-verbose=false -hyfm-profitability=true -func-merging-f3m=true -adaptive-threshold=false -adaptive-bands=false -hyfm-f3m-rows=2 -hyfm-f3m-bands=100 -shingling-cross-basic-blocks=true -ranking-distance=1.0 -bucket-size-cap=100 -func-merging-report=false -func-merging-hyfm-nw=true -func-merging-explore 2 -pass-remarks-output=- -pass-remarks-filter=func-merging %s -o %t.fm.ll

; ModuleID = './.x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/401.bzip2/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.spec_fd_t = type { i32, i32, i32, i8* }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@dbglvl = external local_unnamed_addr global i32, align 4
@spec_fd = external local_unnamed_addr global [3 x %struct.spec_fd_t], align 16
@.str.8.51 = external hidden unnamed_addr constant [25 x i8], align 1
@.str.9 = external hidden unnamed_addr constant [34 x i8], align 1
@.str.11.52 = external hidden unnamed_addr constant [4 x i8], align 1
@.str.12.55 = external hidden unnamed_addr constant [34 x i8], align 1
@.str.13.56 = external hidden unnamed_addr constant [35 x i8], align 1
@str.39 = external hidden unnamed_addr constant [4 x i8], align 1
@stderr = external local_unnamed_addr global %struct._IO_FILE*, align 8

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fprintf(%struct._IO_FILE* nocapture noundef, i8* nocapture noundef readonly, ...) local_unnamed_addr #0

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noreturn nounwind optsize
declare void @exit(i32) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #3

; Function Attrs: nofree nounwind optsize
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
define i32 @spec_read(i32 %fd, i8* %buf, i32 %size) local_unnamed_addr #4 {
entry:
  %0 = load i32, i32* @dbglvl, align 4, !tbaa !4
  %cmp = icmp sgt i32 %0, 4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([25 x i8], [25 x i8]* @.str.8.51, i64 0, i64 0), i32 %fd, i8* %buf, i32 %size) #5
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %cmp1 = icmp sgt i32 %fd, 3
  br i1 %cmp1, label %if.then2, label %if.end4

if.then2:                                         ; preds = %if.end
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !8
  %call3 = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.9, i64 0, i64 0), i32 %fd) #6
  tail call void @exit(i32 0) #7
  unreachable

if.end4:                                          ; preds = %if.end
  %idxprom = sext i32 %fd to i64
  %pos = getelementptr inbounds [3 x %struct.spec_fd_t], [3 x %struct.spec_fd_t]* @spec_fd, i64 0, i64 %idxprom, i32 2
  %2 = load i32, i32* %pos, align 8, !tbaa !10
  %len = getelementptr inbounds [3 x %struct.spec_fd_t], [3 x %struct.spec_fd_t]* @spec_fd, i64 0, i64 %idxprom, i32 1
  %3 = load i32, i32* %len, align 4, !tbaa !12
  %cmp7.not = icmp sgt i32 %3, %2
  br i1 %cmp7.not, label %if.end13, label %if.then8

if.then8:                                         ; preds = %if.end4
  %4 = load i32, i32* @dbglvl, align 4, !tbaa !4
  %cmp9 = icmp sgt i32 %4, 4
  br i1 %cmp9, label %if.then10, label %cleanup

if.then10:                                        ; preds = %if.then8
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @str.39, i64 0, i64 0))
  br label %cleanup

if.end13:                                         ; preds = %if.end4
  %add = add nsw i32 %2, %size
  %cmp20.not = icmp slt i32 %add, %3
  %sub = sub nsw i32 %3, %2
  %rc.0 = select i1 %cmp20.not, i32 %size, i32 %sub
  %buf31 = getelementptr inbounds [3 x %struct.spec_fd_t], [3 x %struct.spec_fd_t]* @spec_fd, i64 0, i64 %idxprom, i32 3
  %5 = load i8*, i8** %buf31, align 8, !tbaa !13
  %idxprom35 = sext i32 %2 to i64
  %arrayidx36 = getelementptr inbounds i8, i8* %5, i64 %idxprom35
  %conv = sext i32 %rc.0 to i64
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %buf, i8* align 1 %arrayidx36, i64 %conv, i1 false)
  %6 = load i32, i32* %pos, align 8, !tbaa !10
  %add40 = add nsw i32 %6, %rc.0
  store i32 %add40, i32* %pos, align 8, !tbaa !10
  %7 = load i32, i32* @dbglvl, align 4, !tbaa !4
  %cmp41 = icmp sgt i32 %7, 4
  br i1 %cmp41, label %if.then43, label %cleanup

if.then43:                                        ; preds = %if.end13
  %call44 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11.52, i64 0, i64 0), i32 %rc.0) #5
  br label %cleanup

cleanup:                                          ; preds = %if.end13, %if.then43, %if.then8, %if.then10
  %retval.0 = phi i32 [ -1, %if.then10 ], [ -1, %if.then8 ], [ %rc.0, %if.then43 ], [ %rc.0, %if.end13 ]
  ret i32 %retval.0
}

; Function Attrs: noinline nounwind optsize uwtable
define i32 @spec_fread(i8* %buf, i32 %size, i32 %num, i32 %fd) local_unnamed_addr #4 {
entry:
  %0 = load i32, i32* @dbglvl, align 4, !tbaa !4
  %cmp = icmp sgt i32 %0, 4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([34 x i8], [34 x i8]* @.str.12.55, i64 0, i64 0), i8* %buf, i32 %size, i32 %num, i32 %fd) #5
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %cmp1 = icmp sgt i32 %fd, 3
  br i1 %cmp1, label %if.then2, label %if.end4

if.then2:                                         ; preds = %if.end
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !8
  %call3 = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.13.56, i64 0, i64 0), i32 %fd) #6
  tail call void @exit(i32 0) #7
  unreachable

if.end4:                                          ; preds = %if.end
  %idxprom = sext i32 %fd to i64
  %pos = getelementptr inbounds [3 x %struct.spec_fd_t], [3 x %struct.spec_fd_t]* @spec_fd, i64 0, i64 %idxprom, i32 2
  %2 = load i32, i32* %pos, align 8, !tbaa !10
  %len = getelementptr inbounds [3 x %struct.spec_fd_t], [3 x %struct.spec_fd_t]* @spec_fd, i64 0, i64 %idxprom, i32 1
  %3 = load i32, i32* %len, align 4, !tbaa !12
  %cmp7.not = icmp sgt i32 %3, %2
  br i1 %cmp7.not, label %if.end13, label %if.then8

if.then8:                                         ; preds = %if.end4
  %4 = load i32, i32* @dbglvl, align 4, !tbaa !4
  %cmp9 = icmp sgt i32 %4, 4
  br i1 %cmp9, label %if.then10, label %cleanup

if.then10:                                        ; preds = %if.then8
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @str.39, i64 0, i64 0))
  br label %cleanup

if.end13:                                         ; preds = %if.end4
  %mul = mul nsw i32 %num, %size
  %add = add nsw i32 %2, %mul
  %cmp20.not = icmp slt i32 %add, %3
  br i1 %cmp20.not, label %if.end28, label %if.then21

if.then21:                                        ; preds = %if.end13
  %sub = sub nsw i32 %3, %2
  %div = sdiv i32 %sub, %size
  %.pre = mul nsw i32 %div, %size
  br label %if.end28

if.end28:                                         ; preds = %if.end13, %if.then21
  %mul37.pre-phi = phi i32 [ %mul, %if.end13 ], [ %.pre, %if.then21 ]
  %rc.0 = phi i32 [ %num, %if.end13 ], [ %div, %if.then21 ]
  %buf31 = getelementptr inbounds [3 x %struct.spec_fd_t], [3 x %struct.spec_fd_t]* @spec_fd, i64 0, i64 %idxprom, i32 3
  %5 = load i8*, i8** %buf31, align 8, !tbaa !13
  %idxprom35 = sext i32 %2 to i64
  %arrayidx36 = getelementptr inbounds i8, i8* %5, i64 %idxprom35
  %conv = sext i32 %rc.0 to i64
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %buf, i8* align 1 %arrayidx36, i64 %conv, i1 false)
  %6 = load i32, i32* %pos, align 8, !tbaa !10
  %add41 = add nsw i32 %6, %mul37.pre-phi
  store i32 %add41, i32* %pos, align 8, !tbaa !10
  %7 = load i32, i32* @dbglvl, align 4, !tbaa !4
  %cmp42 = icmp sgt i32 %7, 4
  br i1 %cmp42, label %if.then44, label %cleanup

if.then44:                                        ; preds = %if.end28
  %call46 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11.52, i64 0, i64 0), i32 %mul37.pre-phi) #5
  br label %cleanup

cleanup:                                          ; preds = %if.end28, %if.then44, %if.then8, %if.then10
  %retval.0 = phi i32 [ -1, %if.then10 ], [ -1, %if.then8 ], [ %rc.0, %if.then44 ], [ %rc.0, %if.end28 ]
  ret i32 %retval.0
}

attributes #0 = { nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { noreturn nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind }
attributes #4 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { optsize }
attributes #6 = { cold optsize }
attributes #7 = { noreturn nounwind optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"any pointer", !6, i64 0}
!10 = !{!11, !5, i64 8}
!11 = !{!"spec_fd_t", !5, i64 0, !5, i64 4, !5, i64 8, !9, i64 16}
!12 = !{!11, !5, i64 4}
!13 = !{!11, !9, i64 16}
