; RUN: %opt -S --passes="func-merging" --pass-remarks-output=- --pass-remarks-filter=func-merging --func-merging-whole-program=true --multiple-func-merging-coalescing=false --hyfm-profitability=true --func-merging-hyfm-nw --func-merging-disable-post-opt --func-merging-allow-unprofitable  -o %t.hyfm.ll %s 2> %t.hyfm.log | FileCheck %s --check-prefix=CHECK-HYFM
; RUN: %opt -S --passes="multiple-func-merging" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw --multiple-func-merging-hyfm-profitability --multiple-func-merging-disable-post-opt --multiple-func-merging-allow-unprofitable --multiple-func-merging-identical-type=true -o %t.mfm-hyfm.ll %s 2> %t.mfm-hyfm.log | FileCheck %s --check-prefix=CHECK-MFM
; CHECK-HYFM:      --- !Passed
; CHECK-HYFM-NEXT: Pass:            func-merging
; CHECK-HYFM-NEXT: Name:            Merge
; CHECK-MFM:      --- !Passed
; CHECK-MFM-NEXT: Pass:            multiple-func-merging
; CHECK-MFM-NEXT: Name:            Merge
; RUN: %llc --filetype=obj %t.hyfm.ll -o %t.hyfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.ll -o %t.mfm-hyfm.o
; RUN: %strip %t.hyfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.hyfm.o)
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006/444.namd/ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_fepEP9nonbonded__ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_lesEP9nonbonded.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.CompAtom = type { %class.Vector, float, i32 }
%class.Vector = type { double, double, double }
%class.ExclusionCheck = type { i32, i32, i8* }

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

define void @_ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_fepEP9nonbonded() align 2 {
cond.end29:
  %arraydecay = getelementptr inbounds [1005 x i32], [1005 x i32]* undef, i64 0, i64 0
  %arraydecay11 = getelementptr inbounds [1005 x i32], [1005 x i32]* undef, i64 0, i64 0
  br label %for.body.preheader

for.body.preheader:                               ; preds = %cond.end29
  %wide.trip.count2816 = zext i32 undef to i64
  br label %for.body

for.body:                                         ; preds = %for.inc, %for.body.preheader
  %indvars.iv2814 = phi i64 [ 0, %for.body.preheader ], [ undef, %for.inc ]
  %g.02722 = phi i32 [ 0, %for.body.preheader ], [ %g.02722, %for.inc ]
  %hydrogenGroupSize = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* undef, i64 %indvars.iv2814, i32 2
  %bf.load = load i32, i32* %hydrogenGroupSize, align 4
  %0 = and i32 %bf.load, 62914560
  %1 = icmp eq i32 %0, 0
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br i1 undef, label %for.end, label %for.body, !llvm.loop !0

for.end:                                          ; preds = %for.inc
  %tobool45.not = icmp eq i32 %g.02722, 0
  ret void
}

define void @_ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_lesEP9nonbonded() align 2 {
for.end:
  %tobool45.not = icmp eq i32 undef, 0
  br i1 %tobool45.not, label %if.end52, label %if.then46

if.then46:                                        ; preds = %for.end
  %idxprom48 = sext i32 undef to i64
  %arrayidx49 = getelementptr inbounds i32, i32* undef, i64 %idxprom48
  %0 = load i32, i32* %arrayidx49, align 4, !tbaa !2
  %idxprom50 = sext i32 undef to i64
  br label %if.end52

if.end52:                                         ; preds = %if.then46, %for.end
  br label %for.cond55.preheader

for.cond55.preheader:                             ; preds = %if.end52
  br label %for.body57.preheader

for.body57.preheader:                             ; preds = %for.cond55.preheader
  br label %for.body57

for.body57:                                       ; preds = %for.body57.preheader
  %idxprom60 = sext i32 undef to i64
  %groupFixed = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* undef, i64 %idxprom60, i32 2
  %bf.load62 = load i32, i32* %groupFixed, align 4
  %1 = and i32 %bf.load62, 134217728
  %tobool65.not = icmp eq i32 %1, 0
  ret void
}

declare %class.ExclusionCheck* @_ZNK8Molecule23get_excl_check_for_atomEi() local_unnamed_addr align 2

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C++ TBAA"}
