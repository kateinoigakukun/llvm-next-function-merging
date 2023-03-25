; RUN: %opt --passes="mergefunc,multiple-func-merging" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-disable-post-opt --multiple-func-merging-allow-unprofitable --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false -o %t.mfm.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-disable-post-opt --multiple-func-merging-allow-unprofitable --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.bc %s
; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge
; RUN: %llc --filetype=obj %t.mfm.bc -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006/444.namd/ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_fepEP9nonbonded__ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_lesEP9nonbonded.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%class.ExclusionCheck = type { i32, i32, i8* }
%"struct.LJTable::TableEntry" = type { double, double }

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

define void @_ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_fepEP9nonbonded() align 2 {
entry:
  br i1 undef, label %if.end, label %cleanup.cont1391

if.end:                                           ; preds = %entry
  br label %cond.end29

cond.end29:                                       ; preds = %if.end
  br label %for.body.preheader

for.body.preheader:                               ; preds = %cond.end29
  %wide.trip.count2816 = zext i32 undef to i64
  br label %for.body

for.body:                                         ; preds = %for.inc, %for.body.preheader
  br i1 undef, label %for.inc, label %if.then40

if.then40:                                        ; preds = %for.body
  %arrayidx42 = getelementptr inbounds i32, i32* undef, i64 undef
  br label %for.inc

for.inc:                                          ; preds = %if.then40, %for.body
  %exitcond2817.not = icmp eq i64 undef, %wide.trip.count2816
  br label %for.body

cleanup.cont1391:                                 ; preds = %entry
  ret void
}

define void @_ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_lesEP9nonbonded() align 2 {
for.body.preheader:
  %wide.trip.count2719 = zext i32 undef to i64
  br label %for.body

for.body:                                         ; preds = %for.inc, %for.body.preheader
  br i1 undef, label %for.inc, label %if.then40

if.then40:                                        ; preds = %for.body
  %idxprom41 = sext i32 undef to i64
  br label %for.inc

for.inc:                                          ; preds = %if.then40, %for.body
  %exitcond2720.not = icmp eq i64 undef, %wide.trip.count2719
  br label %for.body
}

declare %class.ExclusionCheck* @_ZNK8Molecule23get_excl_check_for_atomEi() local_unnamed_addr align 2

declare i16 @_ZNK8Molecule11atomvdwtypeEi() local_unnamed_addr align 2

declare %"struct.LJTable::TableEntry"* @_ZNK7LJTable9table_rowEj() local_unnamed_addr align 2

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
