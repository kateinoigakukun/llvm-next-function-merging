; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false -o %t.mfm.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.bc %s
; RUN: %llc --filetype=obj %t.mfm.bc -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006_400.perlbench_main_._all_._files_._linked.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.hv = type { %struct.xpvhv*, i64, i64 }
%struct.xpvhv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, i64, %struct.he*, %struct.pmop*, i8* }
%struct.magic = type { %struct.magic*, %struct.mgvtbl*, i16, i8, i8, %struct.sv*, i8*, i64 }
%struct.mgvtbl = type { i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i64 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*, %struct.sv*, i8*, i32)*, i32 (%struct.magic*, %struct.clone_params*)* }
%struct.clone_params = type { %struct.av*, i64, %struct.interpreter* }
%struct.av = type { %struct.xpvav*, i64, i64 }
%struct.xpvav = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.sv**, %struct.sv*, i8 }
%struct.interpreter = type { i8 }
%struct.sv = type { i8*, i64, i64 }
%struct.he = type { %struct.he*, %struct.hek*, %struct.sv* }
%struct.hek = type { i64, i64, [1 x i8] }
%struct.pmop = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8, %struct.op*, %struct.op*, %struct.op*, %struct.op*, %struct.pmop*, %struct.regexp*, i64, i64, i8, %struct.hv* }
%struct.op = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8 }
%struct.regexp = type { i64*, i64*, %struct.regnode*, %struct.reg_substr_data*, i8*, %struct.reg_data*, i8*, i64*, i64, i64, i64, i64, i64, i64, i64, i64, [1 x %struct.regnode] }
%struct.regnode = type { i8, i8, i16 }
%struct.reg_substr_data = type { [3 x %struct.reg_substr_datum] }
%struct.reg_substr_datum = type { i64, i64, %struct.sv*, %struct.sv* }
%struct.reg_data = type { i64, i8*, [1 x i8*] }

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

define internal fastcc void @S_hsplit(%struct.hv* %hv) unnamed_addr {
entry:
  %sv_any = getelementptr inbounds %struct.hv, %struct.hv* %hv, i64 0, i32 0
  br i1 undef, label %land.lhs.true, label %if.end

land.lhs.true:                                    ; preds = %entry
  %and = and i64 undef, 8388608
  %tobool3.not = icmp eq i64 %and, 0
  br i1 %tobool3.not, label %if.then, label %if.end

if.then:                                          ; preds = %land.lhs.true
  tail call void @Perl_hv_clear_placeholders(%struct.hv* %hv)
  br label %if.end

if.end:                                           ; preds = %if.then, %land.lhs.true, %entry
  %call = tail call i8* undef(i64 undef)
  ret void
}

declare void @Perl_hv_clear_placeholders(%struct.hv*) local_unnamed_addr

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.smax.i64(i64, i64) #2

; Function Attrs: nounwind
define void @Perl_hv_ksplit(i64 %newmax) local_unnamed_addr #3 {
entry:
  %0 = load i64, i64* undef, align 8, !tbaa !0
  %add = add i64 %0, 1
  %cmp2.not = icmp slt i64 %add, %newmax
  br i1 %cmp2.not, label %while.cond, label %cleanup

while.cond:                                       ; preds = %while.cond, %entry
  %newsize.0 = phi i64 [ %and9, %while.cond ], [ %newmax, %entry ]
  %and = and i64 %newsize.0, undef
  %cmp4.not = icmp eq i64 %and, %newsize.0
  %and9 = xor i64 %and, %newsize.0
  br label %while.cond

cleanup:                                          ; preds = %entry
  ret void
}

attributes #0 = { argmemonly nofree nounwind willreturn }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!0 = !{!1, !5, i64 16}
!1 = !{!"xpvhv", !2, i64 0, !5, i64 8, !5, i64 16, !5, i64 24, !6, i64 32, !2, i64 40, !2, i64 48, !5, i64 56, !2, i64 64, !2, i64 72, !2, i64 80}
!2 = !{!"any pointer", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!"long", !3, i64 0}
!6 = !{!"double", !3, i64 0}
