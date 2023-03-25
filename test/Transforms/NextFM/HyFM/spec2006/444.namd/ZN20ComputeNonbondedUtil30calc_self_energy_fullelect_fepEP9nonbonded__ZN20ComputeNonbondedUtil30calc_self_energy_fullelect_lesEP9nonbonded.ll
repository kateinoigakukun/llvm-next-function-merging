; RUN: %opt --passes="mergefunc,multiple-func-merging,simplifycfg" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false -o %t.mfm.bc %s | FileCheck %s
; RUN: %opt --passes="mergefunc,multiple-func-merging,simplifycfg" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.bc %s | FileCheck %s
; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge

; RUN: %llc --filetype=obj %t.mfm.bc -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)

; ModuleID = '_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%class.LJTable = type <{ i8*, %"struct.LJTable::TableEntry"*, i32, [4 x i8] }>
%"struct.LJTable::TableEntry" = type { double, double }
%class.Molecule = type { %class.ObjectArena*, %class.ExclusionCheck*, i32, i32, i32* }
%class.ObjectArena = type { i32, i32, %class.ResizeArray, i8*, i8* }
%class.ResizeArray = type { i32 (...)**, %class.ResizeArrayRaw* }
%class.ResizeArrayRaw = type <{ i8**, i8*, i32, i32, i32, float, i32, [4 x i8] }>
%class.ExclusionCheck = type { i32, i32, i8* }
%struct.nonbonded = type { [2 x %struct.CompAtom*], [2 x %class.Vector*], [2 x %class.Vector*], [2 x i32], double*, double*, %class.Vector, i32, i32, i32, i32 }
%struct.CompAtom = type { %class.Vector, float, i32 }
%class.Vector = type { double, double, double }

@_ZN20ComputeNonbondedUtil8commOnlyE = external local_unnamed_addr global i32, align 4
@_ZN20ComputeNonbondedUtil12fixedAtomsOnE = external local_unnamed_addr global i32, align 4
@_ZN20ComputeNonbondedUtil7cutoff2E = external local_unnamed_addr global double, align 8
@_ZN20ComputeNonbondedUtil12groupcutoff2E = external local_unnamed_addr global double, align 8
@_ZN20ComputeNonbondedUtil12dielectric_1E = external local_unnamed_addr global double, align 8
@_ZN20ComputeNonbondedUtil7ljTableE = external local_unnamed_addr global %class.LJTable*, align 8
@_ZN20ComputeNonbondedUtil3molE = external local_unnamed_addr global %class.Molecule*, align 8
@_ZN20ComputeNonbondedUtil8r2_deltaE = external local_unnamed_addr global double, align 8
@_ZN20ComputeNonbondedUtil12r2_delta_expE = external local_unnamed_addr global i32, align 4
@_ZN20ComputeNonbondedUtil11table_shortE = external local_unnamed_addr global double*, align 8
@_ZN20ComputeNonbondedUtil10slow_tableE = external local_unnamed_addr global double*, align 8
@_ZN20ComputeNonbondedUtil7scalingE = external local_unnamed_addr global double, align 8
@_ZN20ComputeNonbondedUtil7scale14E = external local_unnamed_addr global double, align 8
@_ZN20ComputeNonbondedUtil9lesFactorE = external local_unnamed_addr global i32, align 4
@_ZN20ComputeNonbondedUtil12lambda_tableE = external local_unnamed_addr global double*, align 8

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: nobuiltin optsize allocsize(0)
declare nonnull i8* @_Znam(i64) local_unnamed_addr #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: nobuiltin nounwind optsize
declare void @_ZdaPv(i8*) local_unnamed_addr #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #3

; Function Attrs: noinline optsize uwtable
define void @_ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_fepEP9nonbonded(%struct.nonbonded* nocapture readonly %params) #4 align 2 {
entry:
  %grouplist_std = alloca [1005 x i32], align 16
  %fixglist_std = alloca [1005 x i32], align 16
  %goodglist_std = alloca [1005 x i32], align 16
  %pairlist_std = alloca [1005 x i32], align 16
  %pairlist2_std = alloca [1005 x i32], align 16
  %pairlistn_std = alloca [1005 x i32], align 16
  %pairlistx_std = alloca [1005 x i32], align 16
  %pairlistm_std = alloca [1005 x i32], align 16
  %0 = load i32, i32* @_ZN20ComputeNonbondedUtil8commOnlyE, align 4, !tbaa !4
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %if.end, label %cleanup.cont1391

if.end:                                           ; preds = %entry
  %reduction1 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 4
  %1 = load double*, double** %reduction1, align 8, !tbaa !8
  %2 = load double, double* @_ZN20ComputeNonbondedUtil7cutoff2E, align 8, !tbaa !13
  %3 = load double, double* @_ZN20ComputeNonbondedUtil12groupcutoff2E, align 8, !tbaa !13
  %4 = load double, double* @_ZN20ComputeNonbondedUtil12dielectric_1E, align 8, !tbaa !13
  %5 = load %class.LJTable*, %class.LJTable** @_ZN20ComputeNonbondedUtil7ljTableE, align 8, !tbaa !14
  %6 = load %class.Molecule*, %class.Molecule** @_ZN20ComputeNonbondedUtil3molE, align 8, !tbaa !14
  %7 = load double*, double** @_ZN20ComputeNonbondedUtil11table_shortE, align 8, !tbaa !14
  %8 = load double*, double** @_ZN20ComputeNonbondedUtil10slow_tableE, align 8, !tbaa !14
  %9 = load double, double* @_ZN20ComputeNonbondedUtil7scalingE, align 8, !tbaa !13
  %10 = load double, double* @_ZN20ComputeNonbondedUtil7scale14E, align 8, !tbaa !13
  %sub = fsub double 1.000000e+00, %10
  %11 = load double, double* @_ZN20ComputeNonbondedUtil8r2_deltaE, align 8, !tbaa !13
  %12 = load i32, i32* @_ZN20ComputeNonbondedUtil12r2_delta_expE, align 4, !tbaa !4
  %sub2 = shl i32 %12, 6
  %mul = add i32 %sub2, -8128
  %arrayidx = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 3, i64 0
  %13 = load i32, i32* %arrayidx, align 8, !tbaa !4
  %arrayidx4 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 3, i64 1
  %14 = load i32, i32* %arrayidx4, align 4, !tbaa !4
  %arrayidx5 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 0, i64 0
  %15 = load %struct.CompAtom*, %struct.CompAtom** %arrayidx5, align 8, !tbaa !14
  %arrayidx7 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 0, i64 1
  %16 = load %struct.CompAtom*, %struct.CompAtom** %arrayidx7, align 8, !tbaa !14
  %17 = bitcast [1005 x i32]* %grouplist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %17) #6
  %18 = bitcast [1005 x i32]* %fixglist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %18) #6
  %19 = bitcast [1005 x i32]* %goodglist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %19) #6
  %cmp = icmp slt i32 %14, 1000
  br i1 %cmp, label %cond.end29, label %cond.end29.thread

cond.end29.thread:                                ; preds = %if.end
  %add = add nuw nsw i32 %14, 5
  %20 = zext i32 %add to i64
  %21 = shl nuw nsw i64 %20, 2
  %call = tail call noalias nonnull i8* @_Znam(i64 %21) #7
  %22 = bitcast i8* %call to i32*
  %call14 = tail call noalias nonnull i8* @_Znam(i64 %21) #7
  %23 = bitcast i8* %call14 to i32*
  %call25 = tail call noalias nonnull i8* @_Znam(i64 %21) #7
  %24 = bitcast i8* %call25 to i32*
  br label %for.body.preheader

cond.end29:                                       ; preds = %if.end
  %arraydecay = getelementptr inbounds [1005 x i32], [1005 x i32]* %grouplist_std, i64 0, i64 0
  %arraydecay11 = getelementptr inbounds [1005 x i32], [1005 x i32]* %fixglist_std, i64 0, i64 0
  %arraydecay22 = getelementptr inbounds [1005 x i32], [1005 x i32]* %goodglist_std, i64 0, i64 0
  %cmp312721 = icmp sgt i32 %14, 0
  br i1 %cmp312721, label %for.body.preheader, label %if.end52.thread

for.body.preheader:                               ; preds = %cond.end29.thread, %cond.end29
  %cond302828 = phi i32* [ %24, %cond.end29.thread ], [ %arraydecay22, %cond.end29 ]
  %cond245424582826 = phi i32* [ %22, %cond.end29.thread ], [ %arraydecay, %cond.end29 ]
  %cond1924602824 = phi i32* [ %23, %cond.end29.thread ], [ %arraydecay11, %cond.end29 ]
  %wide.trip.count2816 = zext i32 %14 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %indvars.iv2814 = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next2815, %for.inc ]
  %g.02722 = phi i32 [ 0, %for.body.preheader ], [ %g.1, %for.inc ]
  %hydrogenGroupSize = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %indvars.iv2814, i32 2
  %bf.load = load i32, i32* %hydrogenGroupSize, align 4
  %25 = and i32 %bf.load, 62914560
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %for.inc, label %if.then40

if.then40:                                        ; preds = %for.body
  %inc = add nsw i32 %g.02722, 1
  %idxprom41 = sext i32 %g.02722 to i64
  %arrayidx42 = getelementptr inbounds i32, i32* %cond245424582826, i64 %idxprom41
  %27 = trunc i64 %indvars.iv2814 to i32
  store i32 %27, i32* %arrayidx42, align 4, !tbaa !4
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then40
  %g.1 = phi i32 [ %inc, %if.then40 ], [ %g.02722, %for.body ]
  %indvars.iv.next2815 = add nuw nsw i64 %indvars.iv2814, 1
  %exitcond2817.not = icmp eq i64 %indvars.iv.next2815, %wide.trip.count2816
  br i1 %exitcond2817.not, label %for.end, label %for.body, !llvm.loop !15

for.end:                                          ; preds = %for.inc
  %tobool45.not = icmp eq i32 %g.1, 0
  br i1 %tobool45.not, label %if.end52, label %if.then46

if.then46:                                        ; preds = %for.end
  %sub47 = add nsw i32 %g.1, -1
  %idxprom48 = sext i32 %sub47 to i64
  %arrayidx49 = getelementptr inbounds i32, i32* %cond245424582826, i64 %idxprom48
  %28 = load i32, i32* %arrayidx49, align 4, !tbaa !4
  %idxprom50 = sext i32 %g.1 to i64
  %arrayidx51 = getelementptr inbounds i32, i32* %cond245424582826, i64 %idxprom50
  store i32 %28, i32* %arrayidx51, align 4, !tbaa !4
  br label %if.end52

if.end52:                                         ; preds = %if.then46, %for.end
  %29 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool53.not = icmp eq i32 %29, 0
  br i1 %tobool53.not, label %if.end103, label %for.cond55.preheader

if.end52.thread:                                  ; preds = %cond.end29
  %30 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool53.not2842 = icmp eq i32 %30, 0
  br i1 %tobool53.not2842, label %if.end103, label %cleanup1338

for.cond55.preheader:                             ; preds = %if.end52
  %cmp562715 = icmp sgt i32 %g.1, 0
  br i1 %cmp562715, label %for.body57.preheader, label %if.then75

for.body57.preheader:                             ; preds = %for.cond55.preheader
  %wide.trip.count2812 = zext i32 %g.1 to i64
  br label %for.body57

for.body57:                                       ; preds = %for.body57.preheader, %for.inc71
  %indvars.iv2810 = phi i64 [ 0, %for.body57.preheader ], [ %indvars.iv.next2811, %for.inc71 ]
  %fixg.02717 = phi i32 [ 0, %for.body57.preheader ], [ %fixg.1, %for.inc71 ]
  %all_fixed.02716 = phi i32 [ 1, %for.body57.preheader ], [ %all_fixed.1, %for.inc71 ]
  %arrayidx59 = getelementptr inbounds i32, i32* %cond245424582826, i64 %indvars.iv2810
  %31 = load i32, i32* %arrayidx59, align 4, !tbaa !4
  %idxprom60 = sext i32 %31 to i64
  %groupFixed = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom60, i32 2
  %bf.load62 = load i32, i32* %groupFixed, align 4
  %32 = and i32 %bf.load62, 134217728
  %tobool65.not = icmp eq i32 %32, 0
  br i1 %tobool65.not, label %if.then66, label %for.inc71

if.then66:                                        ; preds = %for.body57
  %inc67 = add nsw i32 %fixg.02717, 1
  %idxprom68 = sext i32 %fixg.02717 to i64
  %arrayidx69 = getelementptr inbounds i32, i32* %cond1924602824, i64 %idxprom68
  store i32 %31, i32* %arrayidx69, align 4, !tbaa !4
  br label %for.inc71

for.inc71:                                        ; preds = %for.body57, %if.then66
  %all_fixed.1 = phi i32 [ %all_fixed.02716, %for.body57 ], [ 0, %if.then66 ]
  %fixg.1 = phi i32 [ %fixg.02717, %for.body57 ], [ %inc67, %if.then66 ]
  %indvars.iv.next2811 = add nuw nsw i64 %indvars.iv2810, 1
  %exitcond2813.not = icmp eq i64 %indvars.iv.next2811, %wide.trip.count2812
  br i1 %exitcond2813.not, label %for.end73, label %for.body57, !llvm.loop !17

for.end73:                                        ; preds = %for.inc71
  %tobool74.not = icmp eq i32 %all_fixed.1, 0
  br i1 %tobool74.not, label %if.end95, label %if.then75

if.then75:                                        ; preds = %for.cond55.preheader, %for.end73
  %arraydecay76 = getelementptr inbounds [1005 x i32], [1005 x i32]* %grouplist_std, i64 0, i64 0
  %cmp77 = icmp eq i32* %cond245424582826, %arraydecay76
  br i1 %cmp77, label %if.end79, label %delete.notnull

delete.notnull:                                   ; preds = %if.then75
  %33 = bitcast i32* %cond245424582826 to i8*
  call void @_ZdaPv(i8* %33) #8
  br label %if.end79

if.end79:                                         ; preds = %delete.notnull, %if.then75
  %arraydecay80 = getelementptr inbounds [1005 x i32], [1005 x i32]* %fixglist_std, i64 0, i64 0
  %cmp81 = icmp eq i32* %cond1924602824, %arraydecay80
  br i1 %cmp81, label %if.end86, label %delete.notnull84

delete.notnull84:                                 ; preds = %if.end79
  %34 = bitcast i32* %cond1924602824 to i8*
  call void @_ZdaPv(i8* %34) #8
  br label %if.end86

if.end86:                                         ; preds = %delete.notnull84, %if.end79
  %arraydecay87 = getelementptr inbounds [1005 x i32], [1005 x i32]* %goodglist_std, i64 0, i64 0
  %cmp88 = icmp eq i32* %cond302828, %arraydecay87
  br i1 %cmp88, label %cleanup1338, label %delete.notnull91

delete.notnull91:                                 ; preds = %if.end86
  %35 = bitcast i32* %cond302828 to i8*
  call void @_ZdaPv(i8* %35) #8
  br label %cleanup1338

if.end95:                                         ; preds = %for.end73
  %tobool96.not = icmp eq i32 %fixg.1, 0
  br i1 %tobool96.not, label %if.end103, label %if.then97

if.then97:                                        ; preds = %if.end95
  %sub98 = add nsw i32 %fixg.1, -1
  %idxprom99 = sext i32 %sub98 to i64
  %arrayidx100 = getelementptr inbounds i32, i32* %cond1924602824, i64 %idxprom99
  %36 = load i32, i32* %arrayidx100, align 4, !tbaa !4
  %idxprom101 = sext i32 %fixg.1 to i64
  %arrayidx102 = getelementptr inbounds i32, i32* %cond1924602824, i64 %idxprom101
  store i32 %36, i32* %arrayidx102, align 4, !tbaa !4
  br label %if.end103

if.end103:                                        ; preds = %if.end52.thread, %if.end52, %if.then97, %if.end95
  %cond30282728342850 = phi i32* [ %cond302828, %if.then97 ], [ %cond302828, %if.end95 ], [ %cond302828, %if.end52 ], [ %arraydecay22, %if.end52.thread ]
  %cond24542458282528352848 = phi i32* [ %cond245424582826, %if.then97 ], [ %cond245424582826, %if.end95 ], [ %cond245424582826, %if.end52 ], [ %arraydecay, %if.end52.thread ]
  %cond192460282328362846 = phi i32* [ %cond1924602824, %if.then97 ], [ %cond1924602824, %if.end95 ], [ %cond1924602824, %if.end52 ], [ %arraydecay11, %if.end52.thread ]
  %g.0.lcssa28372844 = phi i32 [ %g.1, %if.then97 ], [ %g.1, %if.end95 ], [ %g.1, %if.end52 ], [ 0, %if.end52.thread ]
  %fixg.22464 = phi i32 [ %fixg.1, %if.then97 ], [ 0, %if.end95 ], [ 0, %if.end52 ], [ 0, %if.end52.thread ]
  %37 = bitcast [1005 x i32]* %pairlist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %37) #6
  %38 = bitcast [1005 x i32]* %pairlist2_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %38) #6
  %39 = bitcast [1005 x i32]* %pairlistn_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %39) #6
  %40 = bitcast [1005 x i32]* %pairlistx_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %40) #6
  %41 = bitcast [1005 x i32]* %pairlistm_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %41) #6
  br i1 %cmp, label %cond.true149, label %cond.false151

cond.true149:                                     ; preds = %if.end103
  %arraydecay106 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist_std, i64 0, i64 0
  %arraydecay117 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist2_std, i64 0, i64 0
  %arraydecay128 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistn_std, i64 0, i64 0
  %arraydecay139 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistx_std, i64 0, i64 0
  %arraydecay150 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistm_std, i64 0, i64 0
  br label %cond.end157

cond.false151:                                    ; preds = %if.end103
  %add108 = add nuw nsw i32 %14, 5
  %42 = zext i32 %add108 to i64
  %43 = shl nuw nsw i64 %42, 2
  %call109 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %44 = bitcast i8* %call109 to i32*
  %call120 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %45 = bitcast i8* %call120 to i32*
  %call131 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %46 = bitcast i8* %call131 to i32*
  %call142 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %47 = bitcast i8* %call142 to i32*
  %call153 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %48 = bitcast i8* %call153 to i32*
  br label %cond.end157

cond.end157:                                      ; preds = %cond.false151, %cond.true149
  %cond1472493 = phi i32* [ %arraydecay139, %cond.true149 ], [ %47, %cond.false151 ]
  %cond125247224772491 = phi i32* [ %arraydecay117, %cond.true149 ], [ %45, %cond.false151 ]
  %cond1142466247024792489 = phi i32* [ %arraydecay106, %cond.true149 ], [ %44, %cond.false151 ]
  %cond13624812487 = phi i32* [ %arraydecay128, %cond.true149 ], [ %46, %cond.false151 ]
  %cond158 = phi i32* [ %arraydecay150, %cond.true149 ], [ %48, %cond.false151 ]
  %arrayidx159 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 1, i64 0
  %49 = load %class.Vector*, %class.Vector** %arrayidx159, align 8, !tbaa !14
  %arrayidx161 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 1, i64 1
  %50 = load %class.Vector*, %class.Vector** %arrayidx161, align 8, !tbaa !14
  %arrayidx162 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 2, i64 0
  %51 = load %class.Vector*, %class.Vector** %arrayidx162, align 8, !tbaa !14
  %arrayidx164 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 2, i64 1
  %52 = load %class.Vector*, %class.Vector** %arrayidx164, align 8, !tbaa !14
  %sub165 = add nsw i32 %13, -1
  %mul166 = mul nsw i32 %sub165, %14
  %div = sdiv i32 %mul166, 2
  %minPart = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 8
  %53 = load i32, i32* %minPart, align 4, !tbaa !18
  %mul167 = mul nsw i32 %53, %div
  %numParts = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 10
  %54 = load i32, i32* %numParts, align 4, !tbaa !19
  %div168 = sdiv i32 %mul167, %54
  %maxPart = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 9
  %55 = load i32, i32* %maxPart, align 8, !tbaa !20
  %mul169 = mul nsw i32 %55, %div
  %div171 = sdiv i32 %mul169, %54
  %sub.ptr.rhs.cast = ptrtoint i32* %cond30282728342850 to i64
  %sub.ptr.rhs.cast375 = ptrtoint i32* %cond1142466247024792489 to i64
  %sub.ptr.rhs.cast555 = ptrtoint i32* %cond125247224772491 to i64
  %sub.ptr.rhs.cast617 = ptrtoint i32* %cond1472493 to i64
  %sub.ptr.rhs.cast624 = ptrtoint i32* %cond158 to i64
  %56 = fneg double %9
  %sub956 = fsub double 1.000000e+00, %sub
  %neg1024 = fneg double %sub
  %cmp1742668 = icmp sgt i32 %13, 1
  br i1 %cmp1742668, label %for.body175.preheader, label %for.end1230

for.body175.preheader:                            ; preds = %cond.end157
  %57 = sext i32 %g.0.lcssa28372844 to i64
  %58 = sext i32 %fixg.22464 to i64
  br label %for.body175

for.body175:                                      ; preds = %for.body175.preheader, %cleanup1216
  %exclChecksum.02695 = phi i32 [ %exclChecksum.11, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %vdwEnergy.02694 = phi double [ %vdwEnergy.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %electEnergy.02693 = phi double [ %electEnergy.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %vdwEnergy_s.02692 = phi double [ %vdwEnergy_s.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %electEnergy_s.02691 = phi double [ %electEnergy_s.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_xx.02690 = phi double [ %virial_xx.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_xy.02689 = phi double [ %virial_xy.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_xz.02688 = phi double [ %virial_xz.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_yy.02687 = phi double [ %virial_yy.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_yz.02686 = phi double [ %virial_yz.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_zz.02685 = phi double [ %virial_zz.3, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectEnergy.02684 = phi double [ %fullElectEnergy.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectEnergy_s.02683 = phi double [ %fullElectEnergy_s.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_xx.02682 = phi double [ %fullElectVirial_xx.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_xy.02681 = phi double [ %fullElectVirial_xy.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_xz.02680 = phi double [ %fullElectVirial_xz.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_yy.02679 = phi double [ %fullElectVirial_yy.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_yz.02678 = phi double [ %fullElectVirial_yz.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_zz.02677 = phi double [ %fullElectVirial_zz.4, %cleanup1216 ], [ 0.000000e+00, %for.body175.preheader ]
  %i.02675 = phi i32 [ %inc1229, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %j_hgroup.02674 = phi i32 [ %j_hgroup.3, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %g_lower.02673 = phi i32 [ %g_lower.4, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %fixg_lower.02672 = phi i32 [ %fixg_lower.4, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %pairlistindex.02671 = phi i32 [ %pairlistindex.3, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %pairlistoffset.02670 = phi i32 [ %pairlistoffset.2, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %pairCount.02669 = phi i32 [ %pairCount.3, %cleanup1216 ], [ 0, %for.body175.preheader ]
  %idxprom176 = sext i32 %i.02675 to i64
  %id = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 2
  %bf.load178 = load i32, i32* %id, align 4
  %bf.clear179 = and i32 %bf.load178, 4194303
  %call180 = call %class.ExclusionCheck* @_ZNK8Molecule23get_excl_check_for_atomEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear179) #9
  %min = getelementptr inbounds %class.ExclusionCheck, %class.ExclusionCheck* %call180, i64 0, i32 0
  %59 = load i32, i32* %min, align 8, !tbaa !21
  %max = getelementptr inbounds %class.ExclusionCheck, %class.ExclusionCheck* %call180, i64 0, i32 1
  %60 = load i32, i32* %max, align 4, !tbaa !23
  %flags = getelementptr inbounds %class.ExclusionCheck, %class.ExclusionCheck* %call180, i64 0, i32 2
  %61 = load i8*, i8** %flags, align 8, !tbaa !24
  %idx.ext = sext i32 %59 to i64
  %x = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 0, i32 0
  %62 = load double, double* %x, align 8, !tbaa !25
  %y = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 0, i32 1
  %63 = load double, double* %y, align 8, !tbaa !28
  %z = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 0, i32 2
  %64 = load double, double* %z, align 8, !tbaa !29
  %bf.load188 = load i32, i32* %id, align 4
  %65 = and i32 %bf.load188, 62914560
  %66 = icmp eq i32 %65, 0
  br i1 %66, label %if.else, label %if.then198

if.then198:                                       ; preds = %for.body175
  %bf.lshr201 = lshr i32 %bf.load188, 22
  %bf.clear202 = and i32 %bf.lshr201, 7
  %tobool203.not = icmp eq i32 %bf.clear202, 0
  br i1 %tobool203.not, label %if.end228.thread, label %if.then204

if.end228.thread:                                 ; preds = %if.then198
  %67 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool229.not2871 = icmp ne i32 %67, 0
  %68 = and i32 %bf.load188, 134217728
  %tobool2342872 = icmp ne i32 %68, 0
  %69 = select i1 %tobool229.not2871, i1 %tobool2342872, i1 false
  br label %if.end263

if.then204:                                       ; preds = %if.then198
  %sub210 = sub nsw i32 %sub165, %i.02675
  %mul211 = mul nsw i32 %bf.clear202, %sub210
  %add212 = add nsw i32 %mul211, %pairCount.02669
  %sub213 = add nsw i32 %bf.clear202, -1
  %mul214 = mul nuw nsw i32 %sub213, %bf.clear202
  %div215.neg24952496 = lshr i32 %mul214, 1
  %sub216 = sub i32 %add212, %div215.neg24952496
  %cmp217 = icmp sge i32 %pairCount.02669, %div168
  %cmp219.not = icmp slt i32 %pairCount.02669, %div171
  %or.cond2448 = select i1 %cmp217, i1 %cmp219.not, i1 false
  %add222 = add nsw i32 %sub213, %i.02675
  br i1 %or.cond2448, label %if.then240, label %cleanup1216

if.then240:                                       ; preds = %if.then204
  %70 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool229.not = icmp ne i32 %70, 0
  %71 = and i32 %bf.load188, 134217728
  %tobool234 = icmp ne i32 %71, 0
  %72 = select i1 %tobool229.not, i1 %tobool234, i1 false
  %add245 = add nsw i32 %bf.clear202, %i.02675
  %cmp2462498 = icmp slt i32 %g_lower.02673, %g.0.lcssa28372844
  br i1 %cmp2462498, label %land.rhs247.preheader, label %while.end

land.rhs247.preheader:                            ; preds = %if.then240
  %73 = sext i32 %g_lower.02673 to i64
  br label %land.rhs247

land.rhs247:                                      ; preds = %land.rhs247.preheader, %while.body
  %indvars.iv = phi i64 [ %73, %land.rhs247.preheader ], [ %indvars.iv.next, %while.body ]
  %arrayidx249 = getelementptr inbounds i32, i32* %cond24542458282528352848, i64 %indvars.iv
  %74 = load i32, i32* %arrayidx249, align 4, !tbaa !4
  %cmp250 = icmp slt i32 %74, %add245
  br i1 %cmp250, label %while.body, label %while.end.loopexit.split.loop.exit2943

while.body:                                       ; preds = %land.rhs247
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %57
  br i1 %exitcond.not, label %while.end, label %land.rhs247, !llvm.loop !30

while.end.loopexit.split.loop.exit2943:           ; preds = %land.rhs247
  %75 = trunc i64 %indvars.iv to i32
  br label %while.end

while.end:                                        ; preds = %while.body, %while.end.loopexit.split.loop.exit2943, %if.then240
  %g_lower.1.lcssa = phi i32 [ %g_lower.02673, %if.then240 ], [ %75, %while.end.loopexit.split.loop.exit2943 ], [ %g.0.lcssa28372844, %while.body ]
  %cmp2542501 = icmp slt i32 %fixg_lower.02672, %fixg.22464
  br i1 %cmp2542501, label %land.rhs255.preheader, label %if.end263

land.rhs255.preheader:                            ; preds = %while.end
  %76 = sext i32 %fixg_lower.02672 to i64
  br label %land.rhs255

land.rhs255:                                      ; preds = %land.rhs255.preheader, %while.body260
  %indvars.iv2770 = phi i64 [ %76, %land.rhs255.preheader ], [ %indvars.iv.next2771, %while.body260 ]
  %arrayidx257 = getelementptr inbounds i32, i32* %cond192460282328362846, i64 %indvars.iv2770
  %77 = load i32, i32* %arrayidx257, align 4, !tbaa !4
  %cmp258 = icmp slt i32 %77, %add245
  br i1 %cmp258, label %while.body260, label %if.end263.loopexit.split.loop.exit

while.body260:                                    ; preds = %land.rhs255
  %indvars.iv.next2771 = add nsw i64 %indvars.iv2770, 1
  %exitcond2772.not = icmp eq i64 %indvars.iv.next2771, %58
  br i1 %exitcond2772.not, label %if.end263, label %land.rhs255, !llvm.loop !31

if.end263.loopexit.split.loop.exit:               ; preds = %land.rhs255
  %78 = trunc i64 %indvars.iv2770 to i32
  br label %if.end263

if.end263:                                        ; preds = %while.body260, %if.end263.loopexit.split.loop.exit, %if.end228.thread, %while.end
  %79 = phi i1 [ %72, %while.end ], [ %69, %if.end228.thread ], [ %72, %if.end263.loopexit.split.loop.exit ], [ %72, %while.body260 ]
  %pairCount.12873 = phi i32 [ %sub216, %while.end ], [ %pairCount.02669, %if.end228.thread ], [ %sub216, %if.end263.loopexit.split.loop.exit ], [ %sub216, %while.body260 ]
  %fixg_lower.2 = phi i32 [ %fixg_lower.02672, %while.end ], [ %fixg_lower.02672, %if.end228.thread ], [ %78, %if.end263.loopexit.split.loop.exit ], [ %fixg.22464, %while.body260 ]
  %g_lower.2 = phi i32 [ %g_lower.1.lcssa, %while.end ], [ %g_lower.02673, %if.end228.thread ], [ %g_lower.1.lcssa, %if.end263.loopexit.split.loop.exit ], [ %g_lower.1.lcssa, %while.body260 ]
  %j_hgroup.1 = phi i32 [ %add245, %while.end ], [ %j_hgroup.02674, %if.end228.thread ], [ %add245, %if.end263.loopexit.split.loop.exit ], [ %add245, %while.body260 ]
  %j.12505 = add nsw i32 %i.02675, 1
  %cmp2662506 = icmp slt i32 %j.12505, %j_hgroup.1
  br i1 %cmp2662506, label %for.body267.preheader, label %for.end273

for.body267.preheader:                            ; preds = %if.end263
  %80 = xor i32 %i.02675, -1
  %81 = add i32 %j_hgroup.1, %80
  %wide.trip.count = zext i32 %81 to i64
  br label %for.body267

for.body267:                                      ; preds = %for.body267.preheader, %for.body267
  %indvars.iv2773 = phi i64 [ 0, %for.body267.preheader ], [ %indvars.iv.next2774, %for.body267 ]
  %j.12508 = phi i32 [ %j.12505, %for.body267.preheader ], [ %j.1, %for.body267 ]
  %indvars.iv.next2774 = add nuw nsw i64 %indvars.iv2773, 1
  %arrayidx270 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %indvars.iv2773
  store i32 %j.12508, i32* %arrayidx270, align 4, !tbaa !4
  %j.1 = add nsw i32 %j.12508, 1
  %exitcond2775.not = icmp eq i64 %indvars.iv.next2774, %wide.trip.count
  br i1 %exitcond2775.not, label %for.end273, label %for.body267, !llvm.loop !32

for.end273:                                       ; preds = %for.body267, %if.end263
  %pairlistindex.1.lcssa = phi i32 [ 0, %if.end263 ], [ %81, %for.body267 ]
  %idx.ext274 = zext i32 %pairlistindex.1.lcssa to i64
  %add.ptr275 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %idx.ext274
  %cond280 = select i1 %79, i32* %cond192460282328362846, i32* %cond24542458282528352848
  %cond285 = select i1 %79, i32 %fixg_lower.2, i32 %g_lower.2
  %cond290 = select i1 %79, i32 %fixg.22464, i32 %g.0.lcssa28372844
  %cmp291 = icmp slt i32 %cond285, %cond290
  br i1 %cmp291, label %if.then292, label %if.end373

if.then292:                                       ; preds = %for.end273
  %idxprom293 = sext i32 %cond285 to i64
  %arrayidx294 = getelementptr inbounds i32, i32* %cond280, i64 %idxprom293
  %82 = load i32, i32* %arrayidx294, align 4, !tbaa !4
  %idxprom295 = sext i32 %82 to i64
  %x298 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom295, i32 0, i32 0
  %83 = load double, double* %x298, align 8, !tbaa !25
  %y302 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom295, i32 0, i32 1
  %84 = load double, double* %y302, align 8, !tbaa !28
  %z306 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom295, i32 0, i32 2
  %85 = load double, double* %z306, align 8, !tbaa !29
  %wide.trip.count2778 = sext i32 %cond290 to i64
  br label %while.body309

while.body309:                                    ; preds = %if.then292, %if.end333
  %indvars.iv2776 = phi i64 [ %idxprom293, %if.then292 ], [ %indvars.iv.next2777, %if.end333 ]
  %gli.02515 = phi i32* [ %cond30282728342850, %if.then292 ], [ %gli.1, %if.end333 ]
  %j2.02514 = phi i32 [ %82, %if.then292 ], [ %86, %if.end333 ]
  %p_j_x.02513 = phi double [ %83, %if.then292 ], [ %87, %if.end333 ]
  %p_j_y.02512 = phi double [ %84, %if.then292 ], [ %89, %if.end333 ]
  %p_j_z.02511 = phi double [ %85, %if.then292 ], [ %91, %if.end333 ]
  %indvars.iv.next2777 = add nsw i64 %indvars.iv2776, 1
  %arrayidx312 = getelementptr inbounds i32, i32* %cond280, i64 %indvars.iv.next2777
  %86 = load i32, i32* %arrayidx312, align 4, !tbaa !4
  %sub313 = fsub double %62, %p_j_x.02513
  %mul314 = fmul double %sub313, %sub313
  %idxprom315 = sext i32 %86 to i64
  %x318 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom315, i32 0, i32 0
  %87 = load double, double* %x318, align 8, !tbaa !25
  %sub319 = fsub double %63, %p_j_y.02512
  %88 = call double @llvm.fmuladd.f64(double %sub319, double %sub319, double %mul314)
  %y324 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom315, i32 0, i32 1
  %89 = load double, double* %y324, align 8, !tbaa !28
  %sub325 = fsub double %64, %p_j_z.02511
  %90 = call double @llvm.fmuladd.f64(double %sub325, double %sub325, double %88)
  %z330 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom315, i32 0, i32 2
  %91 = load double, double* %z330, align 8, !tbaa !29
  %cmp331 = fcmp ugt double %90, %3
  br i1 %cmp331, label %if.end333, label %if.then332

if.then332:                                       ; preds = %while.body309
  store i32 %j2.02514, i32* %gli.02515, align 4, !tbaa !4
  %incdec.ptr = getelementptr inbounds i32, i32* %gli.02515, i64 1
  br label %if.end333

if.end333:                                        ; preds = %if.then332, %while.body309
  %gli.1 = phi i32* [ %incdec.ptr, %if.then332 ], [ %gli.02515, %while.body309 ]
  %exitcond2779.not = icmp eq i64 %indvars.iv.next2777, %wide.trip.count2778
  br i1 %exitcond2779.not, label %while.end334, label %while.body309, !llvm.loop !33

while.end334:                                     ; preds = %if.end333
  %sub.ptr.lhs.cast = ptrtoint i32* %gli.1 to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %92 = lshr exact i64 %sub.ptr.sub, 2
  %conv335 = trunc i64 %92 to i32
  %cmp3372518 = icmp sgt i32 %conv335, 0
  br i1 %cmp3372518, label %for.body338.preheader, label %if.end373

for.body338.preheader:                            ; preds = %while.end334
  %wide.trip.count2782 = and i64 %92, 4294967295
  br label %for.body338

for.body338:                                      ; preds = %for.body338.preheader, %for.body338
  %indvars.iv2780 = phi i64 [ 0, %for.body338.preheader ], [ %indvars.iv.next2781, %for.body338 ]
  %pli.02520 = phi i32* [ %add.ptr275, %for.body338.preheader ], [ %add.ptr368, %for.body338 ]
  %arrayidx341 = getelementptr inbounds i32, i32* %cond30282728342850, i64 %indvars.iv2780
  %93 = load i32, i32* %arrayidx341, align 4, !tbaa !4
  %idxprom343 = sext i32 %93 to i64
  %nonbondedGroupIsAtom345 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom343, i32 2
  %bf.load346 = load i32, i32* %nonbondedGroupIsAtom345, align 4
  %94 = and i32 %bf.load346, 33554432
  %tobool349.not = icmp eq i32 %94, 0
  %bf.lshr356 = lshr i32 %bf.load346, 22
  %bf.clear357 = and i32 %bf.lshr356, 7
  %cond359 = select i1 %tobool349.not, i32 %bf.clear357, i32 1
  store i32 %93, i32* %pli.02520, align 4, !tbaa !4
  %add361 = add nsw i32 %93, 1
  %arrayidx362 = getelementptr inbounds i32, i32* %pli.02520, i64 1
  store i32 %add361, i32* %arrayidx362, align 4, !tbaa !4
  %add363 = add nsw i32 %93, 2
  %arrayidx364 = getelementptr inbounds i32, i32* %pli.02520, i64 2
  store i32 %add363, i32* %arrayidx364, align 4, !tbaa !4
  %add365 = add nsw i32 %93, 3
  %arrayidx366 = getelementptr inbounds i32, i32* %pli.02520, i64 3
  store i32 %add365, i32* %arrayidx366, align 4, !tbaa !4
  %95 = zext i32 %cond359 to i64
  %add.ptr368 = getelementptr inbounds i32, i32* %pli.02520, i64 %95
  %indvars.iv.next2781 = add nuw nsw i64 %indvars.iv2780, 1
  %exitcond2783.not = icmp eq i64 %indvars.iv.next2781, %wide.trip.count2782
  br i1 %exitcond2783.not, label %if.end373, label %for.body338, !llvm.loop !34

if.end373:                                        ; preds = %for.body338, %while.end334, %for.end273
  %pli.1 = phi i32* [ %add.ptr275, %for.end273 ], [ %add.ptr275, %while.end334 ], [ %add.ptr368, %for.body338 ]
  %sub.ptr.lhs.cast374 = ptrtoint i32* %pli.1 to i64
  %sub.ptr.sub376 = sub i64 %sub.ptr.lhs.cast374, %sub.ptr.rhs.cast375
  %96 = lshr exact i64 %sub.ptr.sub376, 2
  %conv378 = trunc i64 %96 to i32
  %tobool379.not = icmp eq i32 %conv378, 0
  br i1 %tobool379.not, label %if.end388, label %if.then380

if.then380:                                       ; preds = %if.end373
  %sub381 = shl i64 %sub.ptr.sub376, 30
  %sext2445 = add i64 %sub381, -4294967296
  %idxprom382 = ashr i64 %sext2445, 32
  %arrayidx383 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %idxprom382
  %97 = load i32, i32* %arrayidx383, align 4, !tbaa !4
  %idxprom384 = ashr i64 %sub381, 32
  %arrayidx385 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %idxprom384
  store i32 %97, i32* %arrayidx385, align 4, !tbaa !4
  br label %if.end388

if.else:                                          ; preds = %for.body175
  %inc387 = add nsw i32 %pairlistoffset.02670, 1
  br label %if.end388

if.end388:                                        ; preds = %if.end373, %if.then380, %if.else
  %pairCount.2 = phi i32 [ %pairCount.02669, %if.else ], [ %pairCount.12873, %if.then380 ], [ %pairCount.12873, %if.end373 ]
  %pairlistoffset.1 = phi i32 [ %inc387, %if.else ], [ 0, %if.then380 ], [ 0, %if.end373 ]
  %pairlistindex.2 = phi i32 [ %pairlistindex.02671, %if.else ], [ %conv378, %if.then380 ], [ 0, %if.end373 ]
  %fixg_lower.3 = phi i32 [ %fixg_lower.02672, %if.else ], [ %fixg_lower.2, %if.then380 ], [ %fixg_lower.2, %if.end373 ]
  %g_lower.3 = phi i32 [ %g_lower.02673, %if.else ], [ %g_lower.2, %if.then380 ], [ %g_lower.2, %if.end373 ]
  %j_hgroup.2 = phi i32 [ %j_hgroup.02674, %if.else ], [ %j_hgroup.1, %if.then380 ], [ %j_hgroup.1, %if.end373 ]
  %98 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool389.not = icmp ne i32 %98, 0
  %bf.load397.pre = load i32, i32* %id, align 4
  %99 = and i32 %bf.load397.pre, 67108864
  %tobool394 = icmp ne i32 %99, 0
  %100 = select i1 %tobool389.not, i1 %tobool394, i1 false
  %101 = load double*, double** @_ZN20ComputeNonbondedUtil12lambda_tableE, align 8, !tbaa !14
  %bf.lshr398 = lshr i32 %bf.load397.pre, 28
  %mul399 = mul nuw nsw i32 %bf.lshr398, 6
  %102 = zext i32 %mul399 to i64
  %add.ptr401 = getelementptr inbounds double, double* %101, i64 %102
  %charge = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 1
  %103 = load float, float* %charge, align 8, !tbaa !35
  %conv402 = fpext float %103 to double
  %mul403 = fmul double %conv402, 0x4074C104816F0069
  %mul404 = fmul double %9, %mul403
  %mul405 = fmul double %4, %mul404
  %bf.clear408 = and i32 %bf.load397.pre, 4194303
  %call409 = call zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear408) #9
  %conv410 = zext i16 %call409 to i32
  %call411 = call %"struct.LJTable::TableEntry"* @_ZNK7LJTable9table_rowEj(%class.LJTable* nonnull align 8 dereferenceable(20) %5, i32 %conv410) #9
  %cmp4162538 = icmp slt i32 %pairlistoffset.1, %pairlistindex.2
  br i1 %100, label %for.cond415.preheader, label %if.else476

for.cond415.preheader:                            ; preds = %if.end388
  br i1 %cmp4162538, label %for.body418.preheader, label %if.end553

for.body418.preheader:                            ; preds = %for.cond415.preheader
  %104 = sext i32 %pairlistoffset.1 to i64
  %wide.trip.count2790 = sext i32 %pairlistindex.2 to i64
  br label %for.body418

for.body418:                                      ; preds = %for.body418.preheader, %if.end471
  %indvars.iv2788 = phi i64 [ %104, %for.body418.preheader ], [ %indvars.iv.next2789, %if.end471 ]
  %exclChecksum.12542 = phi i32 [ %exclChecksum.02695, %for.body418.preheader ], [ %exclChecksum.3, %if.end471 ]
  %pli412.02541 = phi i32* [ %cond125247224772491, %for.body418.preheader ], [ %pli412.2, %if.end471 ]
  %plin.02540 = phi i32* [ %cond13624812487, %for.body418.preheader ], [ %plin.2, %if.end471 ]
  %arrayidx420 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %indvars.iv2788
  %105 = load i32, i32* %arrayidx420, align 4, !tbaa !4
  %idxprom422 = sext i32 %105 to i64
  %x425 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom422, i32 0, i32 0
  %106 = load double, double* %x425, align 8, !tbaa !25
  %sub427 = fsub double %62, %106
  %mul428 = fmul double %sub427, %sub427
  %y433 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom422, i32 0, i32 1
  %107 = load double, double* %y433, align 8, !tbaa !28
  %sub435 = fsub double %63, %107
  %108 = call double @llvm.fmuladd.f64(double %sub435, double %sub435, double %mul428)
  %z441 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom422, i32 0, i32 2
  %109 = load double, double* %z441, align 8, !tbaa !29
  %sub442 = fsub double %64, %109
  %110 = call double @llvm.fmuladd.f64(double %sub442, double %sub442, double %108)
  %atomFixed446 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom422, i32 2
  %bf.load447 = load i32, i32* %atomFixed446, align 4
  %111 = and i32 %bf.load447, 67108864
  %tobool450.not = icmp ne i32 %111, 0
  %cmp451 = fcmp ugt double %110, %2
  %or.cond2449 = select i1 %tobool450.not, i1 true, i1 %cmp451
  br i1 %or.cond2449, label %if.end471, label %land.lhs.true452

land.lhs.true452:                                 ; preds = %for.body418
  %cmp453 = fcmp ugt double %110, %11
  br i1 %cmp453, label %if.then457, label %land.lhs.true454

land.lhs.true454:                                 ; preds = %land.lhs.true452
  %inc455 = add nsw i32 %exclChecksum.12542, 1
  %tobool456.not = icmp eq i32 %inc455, 0
  br i1 %tobool456.not, label %if.then457, label %if.end471

if.then457:                                       ; preds = %land.lhs.true454, %land.lhs.true452
  %exclChecksum.2 = phi i32 [ 0, %land.lhs.true454 ], [ %exclChecksum.12542, %land.lhs.true452 ]
  %bf.clear462 = and i32 %bf.load447, 4194303
  %cmp463.not = icmp slt i32 %bf.clear462, %59
  %cmp465.not = icmp sgt i32 %bf.clear462, %60
  %or.cond2450 = select i1 %cmp463.not, i1 true, i1 %cmp465.not
  %pli412.02541.sink = select i1 %or.cond2450, i32* %plin.02540, i32* %pli412.02541
  %plin.2.ph.idx = zext i1 %or.cond2450 to i64
  %plin.2.ph = getelementptr i32, i32* %plin.02540, i64 %plin.2.ph.idx
  %not.or.cond2450 = xor i1 %or.cond2450, true
  %pli412.2.ph.idx = zext i1 %not.or.cond2450 to i64
  %pli412.2.ph = getelementptr i32, i32* %pli412.02541, i64 %pli412.2.ph.idx
  store i32 %105, i32* %pli412.02541.sink, align 4, !tbaa !4
  br label %if.end471

if.end471:                                        ; preds = %if.then457, %land.lhs.true454, %for.body418
  %plin.2 = phi i32* [ %plin.02540, %for.body418 ], [ %plin.02540, %land.lhs.true454 ], [ %plin.2.ph, %if.then457 ]
  %pli412.2 = phi i32* [ %pli412.02541, %for.body418 ], [ %pli412.02541, %land.lhs.true454 ], [ %pli412.2.ph, %if.then457 ]
  %exclChecksum.3 = phi i32 [ %exclChecksum.12542, %for.body418 ], [ %inc455, %land.lhs.true454 ], [ %exclChecksum.2, %if.then457 ]
  %indvars.iv.next2789 = add nsw i64 %indvars.iv2788, 1
  %exitcond2791.not = icmp eq i64 %indvars.iv.next2789, %wide.trip.count2790
  br i1 %exitcond2791.not, label %if.end553, label %for.body418, !llvm.loop !36

if.else476:                                       ; preds = %if.end388
  br i1 %cmp4162538, label %if.then479, label %if.end553

if.then479:                                       ; preds = %if.else476
  %idxprom481 = sext i32 %pairlistoffset.1 to i64
  %arrayidx482 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %idxprom481
  %112 = load i32, i32* %arrayidx482, align 4, !tbaa !4
  %idxprom484 = sext i32 %112 to i64
  %x487 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom484, i32 0, i32 0
  %113 = load double, double* %x487, align 8, !tbaa !25
  %y492 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom484, i32 0, i32 1
  %114 = load double, double* %y492, align 8, !tbaa !28
  %z497 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom484, i32 0, i32 2
  %115 = load double, double* %z497, align 8, !tbaa !29
  %wide.trip.count2786 = sext i32 %pairlistindex.2 to i64
  br label %while.body506

while.body506:                                    ; preds = %if.then479, %if.end545
  %indvars.iv2784 = phi i64 [ %idxprom481, %if.then479 ], [ %indvars.iv.next2785, %if.end545 ]
  %idxprom484.pn = phi i64 [ %idxprom484, %if.then479 ], [ %idxprom513, %if.end545 ]
  %exclChecksum.42533 = phi i32 [ %exclChecksum.02695, %if.then479 ], [ %exclChecksum.6, %if.end545 ]
  %pli412.32532 = phi i32* [ %cond125247224772491, %if.then479 ], [ %pli412.4, %if.end545 ]
  %plin.32531 = phi i32* [ %cond13624812487, %if.then479 ], [ %plin.4, %if.end545 ]
  %j2480.02529 = phi i32 [ %112, %if.then479 ], [ %116, %if.end545 ]
  %p_j_x483.02528 = phi double [ %113, %if.then479 ], [ %117, %if.end545 ]
  %p_j_y488.02527 = phi double [ %114, %if.then479 ], [ %119, %if.end545 ]
  %p_j_z493.02526 = phi double [ %115, %if.then479 ], [ %121, %if.end545 ]
  %atom2498.02534.in.in = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom484.pn, i32 2
  %atom2498.02534.in = load i32, i32* %atom2498.02534.in.in, align 4
  %atom2498.02534 = and i32 %atom2498.02534.in, 4194303
  %indvars.iv.next2785 = add nsw i64 %indvars.iv2784, 1
  %arrayidx509 = getelementptr inbounds i32, i32* %cond1142466247024792489, i64 %indvars.iv.next2785
  %116 = load i32, i32* %arrayidx509, align 4, !tbaa !4
  %sub511 = fsub double %62, %p_j_x483.02528
  %mul512 = fmul double %sub511, %sub511
  %idxprom513 = sext i32 %116 to i64
  %x516 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom513, i32 0, i32 0
  %117 = load double, double* %x516, align 8, !tbaa !25
  %sub518 = fsub double %63, %p_j_y488.02527
  %118 = call double @llvm.fmuladd.f64(double %sub518, double %sub518, double %mul512)
  %y523 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom513, i32 0, i32 1
  %119 = load double, double* %y523, align 8, !tbaa !28
  %sub524 = fsub double %64, %p_j_z493.02526
  %120 = call double @llvm.fmuladd.f64(double %sub524, double %sub524, double %118)
  %z529 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom513, i32 0, i32 2
  %121 = load double, double* %z529, align 8, !tbaa !29
  %cmp530 = fcmp ugt double %120, %2
  br i1 %cmp530, label %if.end545, label %land.lhs.true531

land.lhs.true531:                                 ; preds = %while.body506
  %cmp532 = fcmp ugt double %120, %11
  br i1 %cmp532, label %if.then536, label %land.lhs.true533

land.lhs.true533:                                 ; preds = %land.lhs.true531
  %inc534 = add nsw i32 %exclChecksum.42533, 1
  %tobool535.not = icmp eq i32 %inc534, 0
  br i1 %tobool535.not, label %if.then536, label %if.end545

if.then536:                                       ; preds = %land.lhs.true533, %land.lhs.true531
  %exclChecksum.5 = phi i32 [ 0, %land.lhs.true533 ], [ %exclChecksum.42533, %land.lhs.true531 ]
  %cmp537.not = icmp slt i32 %atom2498.02534, %59
  %cmp539.not = icmp sgt i32 %atom2498.02534, %60
  %or.cond2451 = select i1 %cmp537.not, i1 true, i1 %cmp539.not
  %pli412.32532.sink = select i1 %or.cond2451, i32* %plin.32531, i32* %pli412.32532
  %plin.4.ph.idx = zext i1 %or.cond2451 to i64
  %plin.4.ph = getelementptr i32, i32* %plin.32531, i64 %plin.4.ph.idx
  %not.or.cond2451 = xor i1 %or.cond2451, true
  %pli412.4.ph.idx = zext i1 %not.or.cond2451 to i64
  %pli412.4.ph = getelementptr i32, i32* %pli412.32532, i64 %pli412.4.ph.idx
  store i32 %j2480.02529, i32* %pli412.32532.sink, align 4, !tbaa !4
  br label %if.end545

if.end545:                                        ; preds = %if.then536, %land.lhs.true533, %while.body506
  %plin.4 = phi i32* [ %plin.32531, %land.lhs.true533 ], [ %plin.32531, %while.body506 ], [ %plin.4.ph, %if.then536 ]
  %pli412.4 = phi i32* [ %pli412.32532, %land.lhs.true533 ], [ %pli412.32532, %while.body506 ], [ %pli412.4.ph, %if.then536 ]
  %exclChecksum.6 = phi i32 [ %inc534, %land.lhs.true533 ], [ %exclChecksum.42533, %while.body506 ], [ %exclChecksum.5, %if.then536 ]
  %exitcond2787.not = icmp eq i64 %indvars.iv.next2785, %wide.trip.count2786
  br i1 %exitcond2787.not, label %if.end553, label %while.body506, !llvm.loop !37

if.end553:                                        ; preds = %if.end545, %if.end471, %for.cond415.preheader, %if.else476
  %plin.6 = phi i32* [ %cond13624812487, %if.else476 ], [ %cond13624812487, %for.cond415.preheader ], [ %plin.2, %if.end471 ], [ %plin.4, %if.end545 ]
  %pli412.6 = phi i32* [ %cond125247224772491, %if.else476 ], [ %cond125247224772491, %for.cond415.preheader ], [ %pli412.2, %if.end471 ], [ %pli412.4, %if.end545 ]
  %exclChecksum.8 = phi i32 [ %exclChecksum.02695, %if.else476 ], [ %exclChecksum.02695, %for.cond415.preheader ], [ %exclChecksum.3, %if.end471 ], [ %exclChecksum.6, %if.end545 ]
  %sub.ptr.lhs.cast554 = ptrtoint i32* %pli412.6 to i64
  %sub.ptr.sub556 = sub i64 %sub.ptr.lhs.cast554, %sub.ptr.rhs.cast555
  %122 = lshr exact i64 %sub.ptr.sub556, 2
  %conv558 = trunc i64 %122 to i32
  %tobool559.not = icmp eq i32 %conv558, 0
  br i1 %tobool559.not, label %if.end566, label %if.then560

if.then560:                                       ; preds = %if.end553
  %sub561 = shl i64 %sub.ptr.sub556, 30
  %sext = add i64 %sub561, -4294967296
  %idxprom562 = ashr i64 %sext, 32
  %arrayidx563 = getelementptr inbounds i32, i32* %cond125247224772491, i64 %idxprom562
  %123 = load i32, i32* %arrayidx563, align 4, !tbaa !4
  %idxprom564 = ashr i64 %sub561, 32
  %arrayidx565 = getelementptr inbounds i32, i32* %cond125247224772491, i64 %idxprom564
  store i32 %123, i32* %arrayidx565, align 4, !tbaa !4
  br label %if.end566

if.end566:                                        ; preds = %if.then560, %if.end553
  %cmp5692546 = icmp ult i32* %cond13624812487, %plin.6
  br i1 %cmp5692546, label %land.rhs570, label %for.end577

land.rhs570:                                      ; preds = %if.end566, %for.body573
  %exclChecksum.92549 = phi i32 [ %dec, %for.body573 ], [ %exclChecksum.8, %if.end566 ]
  %plix.02548 = phi i32* [ %incdec.ptr574, %for.body573 ], [ %cond1472493, %if.end566 ]
  %pln.02547 = phi i32* [ %incdec.ptr576, %for.body573 ], [ %cond13624812487, %if.end566 ]
  %124 = load i32, i32* %pln.02547, align 4, !tbaa !4
  %cmp571 = icmp slt i32 %124, %j_hgroup.2
  br i1 %cmp571, label %for.body573, label %for.end577

for.body573:                                      ; preds = %land.rhs570
  %incdec.ptr574 = getelementptr inbounds i32, i32* %plix.02548, i64 1
  store i32 %124, i32* %plix.02548, align 4, !tbaa !4
  %dec = add nsw i32 %exclChecksum.92549, -1
  %incdec.ptr576 = getelementptr inbounds i32, i32* %pln.02547, i64 1
  %cmp569 = icmp ult i32* %incdec.ptr576, %plin.6
  br i1 %cmp569, label %land.rhs570, label %for.end577, !llvm.loop !38

for.end577:                                       ; preds = %land.rhs570, %for.body573, %if.end566
  %pln.0.lcssa = phi i32* [ %cond13624812487, %if.end566 ], [ %incdec.ptr576, %for.body573 ], [ %pln.02547, %land.rhs570 ]
  %plix.0.lcssa = phi i32* [ %cond1472493, %if.end566 ], [ %incdec.ptr574, %for.body573 ], [ %plix.02548, %land.rhs570 ]
  %exclChecksum.9.lcssa = phi i32 [ %exclChecksum.8, %if.end566 ], [ %dec, %for.body573 ], [ %exclChecksum.92549, %land.rhs570 ]
  %cmp5792556 = icmp sgt i32 %conv558, 0
  br i1 %cmp5792556, label %land.rhs580.preheader, label %for.end592

land.rhs580.preheader:                            ; preds = %for.end577
  %125 = sub i32 %exclChecksum.9.lcssa, %conv558
  %wide.trip.count2794 = and i64 %122, 4294967295
  br label %land.rhs580

land.rhs580:                                      ; preds = %land.rhs580.preheader, %for.body585
  %indvars.iv2792 = phi i64 [ 0, %land.rhs580.preheader ], [ %indvars.iv.next2793, %for.body585 ]
  %exclChecksum.102559 = phi i32 [ %exclChecksum.9.lcssa, %land.rhs580.preheader ], [ %dec589, %for.body585 ]
  %plix.12558 = phi i32* [ %plix.0.lcssa, %land.rhs580.preheader ], [ %incdec.ptr588, %for.body585 ]
  %arrayidx582 = getelementptr inbounds i32, i32* %cond125247224772491, i64 %indvars.iv2792
  %126 = load i32, i32* %arrayidx582, align 4, !tbaa !4
  %cmp583 = icmp slt i32 %126, %j_hgroup.2
  br i1 %cmp583, label %for.body585, label %for.end592.loopexit

for.body585:                                      ; preds = %land.rhs580
  %incdec.ptr588 = getelementptr inbounds i32, i32* %plix.12558, i64 1
  store i32 %126, i32* %plix.12558, align 4, !tbaa !4
  %dec589 = add nsw i32 %exclChecksum.102559, -1
  %indvars.iv.next2793 = add nuw nsw i64 %indvars.iv2792, 1
  %exitcond2795.not = icmp eq i64 %indvars.iv.next2793, %wide.trip.count2794
  br i1 %exitcond2795.not, label %for.end615, label %land.rhs580, !llvm.loop !39

for.end592.loopexit:                              ; preds = %land.rhs580
  %127 = trunc i64 %indvars.iv2792 to i32
  br label %for.end592

for.end592:                                       ; preds = %for.end592.loopexit, %for.end577
  %k567.0.lcssa = phi i32 [ 0, %for.end577 ], [ %127, %for.end592.loopexit ]
  %plix.1.lcssa = phi i32* [ %plix.0.lcssa, %for.end577 ], [ %plix.12558, %for.end592.loopexit ]
  %exclChecksum.10.lcssa = phi i32 [ %exclChecksum.9.lcssa, %for.end577 ], [ %exclChecksum.102559, %for.end592.loopexit ]
  %cmp5942566 = icmp slt i32 %k567.0.lcssa, %conv558
  br i1 %cmp5942566, label %for.body595.preheader, label %for.end615

for.body595.preheader:                            ; preds = %for.end592
  %128 = zext i32 %k567.0.lcssa to i64
  br label %for.body595

for.body595:                                      ; preds = %for.body595.preheader, %sw.epilog
  %indvars.iv2796 = phi i64 [ %128, %for.body595.preheader ], [ %indvars.iv.next2797, %sw.epilog ]
  %plin.72570 = phi i32* [ %plin.6, %for.body595.preheader ], [ %plin.8, %sw.epilog ]
  %plix.22569 = phi i32* [ %plix.1.lcssa, %for.body595.preheader ], [ %plix.3, %sw.epilog ]
  %plim.02568 = phi i32* [ %cond158, %for.body595.preheader ], [ %plim.1, %sw.epilog ]
  %arrayidx598 = getelementptr inbounds i32, i32* %cond125247224772491, i64 %indvars.iv2796
  %129 = load i32, i32* %arrayidx598, align 4, !tbaa !4
  %idxprom600 = sext i32 %129 to i64
  %id602 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom600, i32 2
  %bf.load603 = load i32, i32* %id602, align 4
  %bf.clear604 = and i32 %bf.load603, 4194303
  %130 = zext i32 %bf.clear604 to i64
  %arrayidx606.idx = sub nsw i64 %130, %idx.ext
  %arrayidx606 = getelementptr inbounds i8, i8* %61, i64 %arrayidx606.idx
  %131 = load i8, i8* %arrayidx606, align 1, !tbaa !40
  %conv607 = sext i8 %131 to i32
  switch i32 %conv607, label %sw.epilog [
    i32 0, label %sw.bb
    i32 1, label %sw.bb609
    i32 2, label %sw.bb611
  ]

sw.bb:                                            ; preds = %for.body595
  %incdec.ptr608 = getelementptr inbounds i32, i32* %plin.72570, i64 1
  br label %sw.epilog.sink.split

sw.bb609:                                         ; preds = %for.body595
  %incdec.ptr610 = getelementptr inbounds i32, i32* %plix.22569, i64 1
  br label %sw.epilog.sink.split

sw.bb611:                                         ; preds = %for.body595
  %incdec.ptr612 = getelementptr inbounds i32, i32* %plim.02568, i64 1
  br label %sw.epilog.sink.split

sw.epilog.sink.split:                             ; preds = %sw.bb, %sw.bb609, %sw.bb611
  %plim.02568.sink = phi i32* [ %plim.02568, %sw.bb611 ], [ %plix.22569, %sw.bb609 ], [ %plin.72570, %sw.bb ]
  %plim.1.ph = phi i32* [ %incdec.ptr612, %sw.bb611 ], [ %plim.02568, %sw.bb609 ], [ %plim.02568, %sw.bb ]
  %plix.3.ph = phi i32* [ %plix.22569, %sw.bb611 ], [ %incdec.ptr610, %sw.bb609 ], [ %plix.22569, %sw.bb ]
  %plin.8.ph = phi i32* [ %plin.72570, %sw.bb611 ], [ %plin.72570, %sw.bb609 ], [ %incdec.ptr608, %sw.bb ]
  store i32 %129, i32* %plim.02568.sink, align 4, !tbaa !4
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.epilog.sink.split, %for.body595
  %plim.1 = phi i32* [ %plim.02568, %for.body595 ], [ %plim.1.ph, %sw.epilog.sink.split ]
  %plix.3 = phi i32* [ %plix.22569, %for.body595 ], [ %plix.3.ph, %sw.epilog.sink.split ]
  %plin.8 = phi i32* [ %plin.72570, %for.body595 ], [ %plin.8.ph, %sw.epilog.sink.split ]
  %indvars.iv.next2797 = add nuw nsw i64 %indvars.iv2796, 1
  %132 = trunc i64 %indvars.iv.next2797 to i32
  %cmp594 = icmp slt i32 %132, %conv558
  br i1 %cmp594, label %for.body595, label %for.end615.loopexit, !llvm.loop !41

for.end615.loopexit:                              ; preds = %sw.epilog
  %.pre = ptrtoint i32* %plim.1 to i64
  br label %for.end615

for.end615:                                       ; preds = %for.body585, %for.end615.loopexit, %for.end592
  %exclChecksum.10.lcssa2878 = phi i32 [ %exclChecksum.10.lcssa, %for.end615.loopexit ], [ %exclChecksum.10.lcssa, %for.end592 ], [ %125, %for.body585 ]
  %sub.ptr.lhs.cast623.pre-phi = phi i64 [ %.pre, %for.end615.loopexit ], [ %sub.ptr.rhs.cast624, %for.end592 ], [ %sub.ptr.rhs.cast624, %for.body585 ]
  %plix.2.lcssa = phi i32* [ %plix.3, %for.end615.loopexit ], [ %plix.1.lcssa, %for.end592 ], [ %incdec.ptr588, %for.body585 ]
  %plin.7.lcssa = phi i32* [ %plin.8, %for.end615.loopexit ], [ %plin.6, %for.end592 ], [ %plin.6, %for.body585 ]
  %sub.ptr.lhs.cast616 = ptrtoint i32* %plix.2.lcssa to i64
  %sub.ptr.sub618 = sub i64 %sub.ptr.lhs.cast616, %sub.ptr.rhs.cast617
  %133 = lshr exact i64 %sub.ptr.sub618, 2
  %134 = trunc i64 %133 to i32
  %sub.ptr.sub625 = sub i64 %sub.ptr.lhs.cast623.pre-phi, %sub.ptr.rhs.cast624
  %135 = lshr exact i64 %sub.ptr.sub625, 2
  %136 = trunc i64 %135 to i32
  %conv622 = add i32 %exclChecksum.10.lcssa2878, %136
  %conv629 = add i32 %conv622, %134
  %sub.ptr.lhs.cast630 = ptrtoint i32* %plin.7.lcssa to i64
  %sub.ptr.rhs.cast631 = ptrtoint i32* %pln.0.lcssa to i64
  %sub.ptr.sub632 = sub i64 %sub.ptr.lhs.cast630, %sub.ptr.rhs.cast631
  %137 = lshr exact i64 %sub.ptr.sub632, 2
  %conv634 = trunc i64 %137 to i32
  %x760 = getelementptr inbounds %class.Vector, %class.Vector* %49, i64 %idxprom176, i32 0
  %y767 = getelementptr inbounds %class.Vector, %class.Vector* %49, i64 %idxprom176, i32 1
  %z773 = getelementptr inbounds %class.Vector, %class.Vector* %49, i64 %idxprom176, i32 2
  %x802 = getelementptr inbounds %class.Vector, %class.Vector* %51, i64 %idxprom176, i32 0
  %y810 = getelementptr inbounds %class.Vector, %class.Vector* %51, i64 %idxprom176, i32 1
  %z817 = getelementptr inbounds %class.Vector, %class.Vector* %51, i64 %idxprom176, i32 2
  %cmp6362574 = icmp sgt i32 %conv634, 0
  br i1 %cmp6362574, label %for.body637.preheader, label %for.cond829.preheader

for.body637.preheader:                            ; preds = %for.end615
  %wide.trip.count2800 = and i64 %137, 4294967295
  br label %for.body637

for.cond829.preheader:                            ; preds = %for.body637, %for.end615
  %fullElectVirial_zz.1.lcssa = phi double [ %fullElectVirial_zz.02677, %for.end615 ], [ %215, %for.body637 ]
  %fullElectVirial_yz.1.lcssa = phi double [ %fullElectVirial_yz.02678, %for.end615 ], [ %212, %for.body637 ]
  %fullElectVirial_yy.1.lcssa = phi double [ %fullElectVirial_yy.02679, %for.end615 ], [ %211, %for.body637 ]
  %fullElectVirial_xz.1.lcssa = phi double [ %fullElectVirial_xz.02680, %for.end615 ], [ %208, %for.body637 ]
  %fullElectVirial_xy.1.lcssa = phi double [ %fullElectVirial_xy.02681, %for.end615 ], [ %207, %for.body637 ]
  %fullElectVirial_xx.1.lcssa = phi double [ %fullElectVirial_xx.02682, %for.end615 ], [ %206, %for.body637 ]
  %fullElectEnergy_s.1.lcssa = phi double [ %fullElectEnergy_s.02683, %for.end615 ], [ %203, %for.body637 ]
  %fullElectEnergy.1.lcssa = phi double [ %fullElectEnergy.02684, %for.end615 ], [ %202, %for.body637 ]
  %virial_zz.1.lcssa = phi double [ %virial_zz.02685, %for.end615 ], [ %193, %for.body637 ]
  %virial_yz.1.lcssa = phi double [ %virial_yz.02686, %for.end615 ], [ %190, %for.body637 ]
  %virial_yy.1.lcssa = phi double [ %virial_yy.02687, %for.end615 ], [ %189, %for.body637 ]
  %virial_xz.1.lcssa = phi double [ %virial_xz.02688, %for.end615 ], [ %186, %for.body637 ]
  %virial_xy.1.lcssa = phi double [ %virial_xy.02689, %for.end615 ], [ %185, %for.body637 ]
  %virial_xx.1.lcssa = phi double [ %virial_xx.02690, %for.end615 ], [ %184, %for.body637 ]
  %electEnergy_s.1.lcssa = phi double [ %electEnergy_s.02691, %for.end615 ], [ %181, %for.body637 ]
  %vdwEnergy_s.1.lcssa = phi double [ %vdwEnergy_s.02692, %for.end615 ], [ %173, %for.body637 ]
  %electEnergy.1.lcssa = phi double [ %electEnergy.02693, %for.end615 ], [ %180, %for.body637 ]
  %vdwEnergy.1.lcssa = phi double [ %vdwEnergy.02694, %for.end615 ], [ %172, %for.body637 ]
  %cmp8302612 = icmp sgt i32 %136, 0
  br i1 %cmp8302612, label %for.body831.preheader, label %for.cond1087.preheader

for.body831.preheader:                            ; preds = %for.cond829.preheader
  %wide.trip.count2804 = and i64 %135, 4294967295
  br label %for.body831

for.body637:                                      ; preds = %for.body637.preheader, %for.body637
  %indvars.iv2798 = phi i64 [ 0, %for.body637.preheader ], [ %indvars.iv.next2799, %for.body637 ]
  %vdwEnergy.12593 = phi double [ %vdwEnergy.02694, %for.body637.preheader ], [ %172, %for.body637 ]
  %electEnergy.12592 = phi double [ %electEnergy.02693, %for.body637.preheader ], [ %180, %for.body637 ]
  %vdwEnergy_s.12591 = phi double [ %vdwEnergy_s.02692, %for.body637.preheader ], [ %173, %for.body637 ]
  %electEnergy_s.12590 = phi double [ %electEnergy_s.02691, %for.body637.preheader ], [ %181, %for.body637 ]
  %virial_xx.12589 = phi double [ %virial_xx.02690, %for.body637.preheader ], [ %184, %for.body637 ]
  %virial_xy.12588 = phi double [ %virial_xy.02689, %for.body637.preheader ], [ %185, %for.body637 ]
  %virial_xz.12587 = phi double [ %virial_xz.02688, %for.body637.preheader ], [ %186, %for.body637 ]
  %virial_yy.12586 = phi double [ %virial_yy.02687, %for.body637.preheader ], [ %189, %for.body637 ]
  %virial_yz.12585 = phi double [ %virial_yz.02686, %for.body637.preheader ], [ %190, %for.body637 ]
  %virial_zz.12584 = phi double [ %virial_zz.02685, %for.body637.preheader ], [ %193, %for.body637 ]
  %fullElectEnergy.12583 = phi double [ %fullElectEnergy.02684, %for.body637.preheader ], [ %202, %for.body637 ]
  %fullElectEnergy_s.12582 = phi double [ %fullElectEnergy_s.02683, %for.body637.preheader ], [ %203, %for.body637 ]
  %fullElectVirial_xx.12581 = phi double [ %fullElectVirial_xx.02682, %for.body637.preheader ], [ %206, %for.body637 ]
  %fullElectVirial_xy.12580 = phi double [ %fullElectVirial_xy.02681, %for.body637.preheader ], [ %207, %for.body637 ]
  %fullElectVirial_xz.12579 = phi double [ %fullElectVirial_xz.02680, %for.body637.preheader ], [ %208, %for.body637 ]
  %fullElectVirial_yy.12578 = phi double [ %fullElectVirial_yy.02679, %for.body637.preheader ], [ %211, %for.body637 ]
  %fullElectVirial_yz.12577 = phi double [ %fullElectVirial_yz.02678, %for.body637.preheader ], [ %212, %for.body637 ]
  %fullElectVirial_zz.12576 = phi double [ %fullElectVirial_zz.02677, %for.body637.preheader ], [ %215, %for.body637 ]
  %arrayidx640 = getelementptr inbounds i32, i32* %pln.0.lcssa, i64 %indvars.iv2798
  %138 = load i32, i32* %arrayidx640, align 4, !tbaa !4
  %idx.ext641 = sext i32 %138 to i64
  %x644 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext641, i32 0, i32 0
  %139 = load double, double* %x644, align 8, !tbaa !25
  %sub645 = fsub double %62, %139
  %mul647 = fmul double %sub645, %sub645
  %y649 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext641, i32 0, i32 1
  %140 = load double, double* %y649, align 8, !tbaa !28
  %sub650 = fsub double %63, %140
  %141 = call double @llvm.fmuladd.f64(double %sub650, double %sub650, double %mul647)
  %z653 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext641, i32 0, i32 2
  %142 = load double, double* %z653, align 8, !tbaa !29
  %sub654 = fsub double %64, %142
  %143 = call double @llvm.fmuladd.f64(double %sub654, double %sub654, double %141)
  %conv656 = fptrunc double %143 to float
  %144 = bitcast float %conv656 to i32
  %shr = ashr i32 %144, 17
  %add658 = add nsw i32 %shr, %mul
  %id659 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext641, i32 2
  %bf.load660 = load i32, i32* %id659, align 4
  %bf.clear661 = and i32 %bf.load660, 4194303
  %call662 = call zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear661) #9
  %conv663 = zext i16 %call662 to i64
  %mul664 = shl nuw nsw i64 %conv663, 1
  %mul667 = shl nsw i32 %add658, 4
  %idx.ext668 = sext i32 %mul667 to i64
  %add.ptr669 = getelementptr inbounds double, double* %7, i64 %idx.ext668
  %145 = load double, double* %add.ptr669, align 8, !tbaa !13
  %add.ptr674 = getelementptr inbounds double, double* %add.ptr669, i64 4
  %146 = load double, double* %add.ptr674, align 8, !tbaa !13
  %add.ptr679 = getelementptr inbounds double, double* %add.ptr669, i64 8
  %147 = load double, double* %add.ptr679, align 8, !tbaa !13
  %add.ptr685 = getelementptr inbounds double, double* %add.ptr679, i64 4
  %148 = load double, double* %add.ptr685, align 8, !tbaa !13
  %and = and i32 %144, -131072
  %149 = bitcast i32 %and to float
  %charge688 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext641, i32 1
  %150 = load float, float* %charge688, align 8, !tbaa !35
  %conv689 = fpext float %150 to double
  %mul690 = fmul double %mul405, %conv689
  %conv692 = fpext float %149 to double
  %sub693 = fsub double %143, %conv692
  %bf.load695 = load i32, i32* %id659, align 4
  %151 = lshr i32 %bf.load695, 27
  %mul697 = and i32 %151, 30
  %152 = zext i32 %mul697 to i64
  %arrayidx699 = getelementptr inbounds double, double* %add.ptr401, i64 %152
  %153 = load double, double* %arrayidx699, align 8, !tbaa !13
  %add701 = or i32 %151, 1
  %154 = zext i32 %add701 to i64
  %arrayidx703 = getelementptr inbounds double, double* %add.ptr401, i64 %154
  %155 = load double, double* %arrayidx703, align 8, !tbaa !13
  %A705 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call411, i64 %mul664, i32 0
  %156 = load double, double* %A705, align 8, !tbaa !42
  %mul706 = fmul double %9, %156
  %B708 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call411, i64 %mul664, i32 1
  %157 = load double, double* %B708, align 8, !tbaa !44
  %158 = fmul double %157, %56
  %neg = fmul double %146, %158
  %159 = call double @llvm.fmuladd.f64(double %mul706, double %145, double %neg)
  %arrayidx712 = getelementptr inbounds double, double* %add.ptr669, i64 3
  %160 = load double, double* %arrayidx712, align 8, !tbaa !13
  %arrayidx714 = getelementptr inbounds double, double* %add.ptr674, i64 3
  %161 = load double, double* %arrayidx714, align 8, !tbaa !13
  %neg716 = fmul double %158, %161
  %162 = call double @llvm.fmuladd.f64(double %mul706, double %160, double %neg716)
  %arrayidx717 = getelementptr inbounds double, double* %add.ptr669, i64 2
  %163 = load double, double* %arrayidx717, align 8, !tbaa !13
  %arrayidx719 = getelementptr inbounds double, double* %add.ptr674, i64 2
  %164 = load double, double* %arrayidx719, align 8, !tbaa !13
  %neg721 = fmul double %158, %164
  %165 = call double @llvm.fmuladd.f64(double %mul706, double %163, double %neg721)
  %arrayidx722 = getelementptr inbounds double, double* %add.ptr669, i64 1
  %166 = load double, double* %arrayidx722, align 8, !tbaa !13
  %arrayidx724 = getelementptr inbounds double, double* %add.ptr674, i64 1
  %167 = load double, double* %arrayidx724, align 8, !tbaa !13
  %neg726 = fmul double %158, %167
  %168 = call double @llvm.fmuladd.f64(double %mul706, double %166, double %neg726)
  %169 = call double @llvm.fmuladd.f64(double %sub693, double %162, double %165)
  %170 = call double @llvm.fmuladd.f64(double %169, double %sub693, double %168)
  %171 = call double @llvm.fmuladd.f64(double %170, double %sub693, double %159)
  %172 = call double @llvm.fmuladd.f64(double %153, double %171, double %vdwEnergy.12593)
  %173 = call double @llvm.fmuladd.f64(double %155, double %171, double %vdwEnergy_s.12591)
  %mul732 = fmul double %147, %mul690
  %arrayidx733 = getelementptr inbounds double, double* %add.ptr679, i64 3
  %174 = load double, double* %arrayidx733, align 8, !tbaa !13
  %mul734 = fmul double %mul690, %174
  %arrayidx735 = getelementptr inbounds double, double* %add.ptr679, i64 2
  %175 = load double, double* %arrayidx735, align 8, !tbaa !13
  %mul736 = fmul double %mul690, %175
  %arrayidx737 = getelementptr inbounds double, double* %add.ptr679, i64 1
  %176 = load double, double* %arrayidx737, align 8, !tbaa !13
  %mul738 = fmul double %mul690, %176
  %177 = call double @llvm.fmuladd.f64(double %sub693, double %mul734, double %mul736)
  %178 = call double @llvm.fmuladd.f64(double %177, double %sub693, double %mul738)
  %179 = call double @llvm.fmuladd.f64(double %178, double %sub693, double %mul732)
  %180 = call double @llvm.fmuladd.f64(double %153, double %179, double %electEnergy.12592)
  %181 = call double @llvm.fmuladd.f64(double %155, double %179, double %electEnergy_s.12590)
  %add744 = fadd double %162, %mul734
  %add745 = fadd double %165, %mul736
  %add746 = fadd double %168, %mul738
  %mul748 = fmul double %sub693, 3.000000e+00
  %mul750 = fmul double %add745, 2.000000e+00
  %182 = call double @llvm.fmuladd.f64(double %mul748, double %add744, double %mul750)
  %183 = call double @llvm.fmuladd.f64(double %182, double %sub693, double %add746)
  %mul752 = fmul double %153, -2.000000e+00
  %mul753 = fmul double %mul752, %183
  %mul756 = fmul double %sub645, %mul753
  %184 = call double @llvm.fmuladd.f64(double %mul756, double %sub645, double %virial_xx.12589)
  %185 = call double @llvm.fmuladd.f64(double %mul756, double %sub650, double %virial_xy.12588)
  %186 = call double @llvm.fmuladd.f64(double %mul756, double %sub654, double %virial_xz.12587)
  %187 = load double, double* %x760, align 8, !tbaa !45
  %add761 = fadd double %187, %mul756
  store double %add761, double* %x760, align 8, !tbaa !45
  %x762 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext641, i32 0
  %188 = load double, double* %x762, align 8, !tbaa !45
  %sub763 = fsub double %188, %mul756
  store double %sub763, double* %x762, align 8, !tbaa !45
  %mul764 = fmul double %sub650, %mul753
  %189 = call double @llvm.fmuladd.f64(double %mul764, double %sub650, double %virial_yy.12586)
  %190 = call double @llvm.fmuladd.f64(double %mul764, double %sub654, double %virial_yz.12585)
  %191 = load double, double* %y767, align 8, !tbaa !46
  %add768 = fadd double %191, %mul764
  store double %add768, double* %y767, align 8, !tbaa !46
  %y769 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext641, i32 1
  %192 = load double, double* %y769, align 8, !tbaa !46
  %sub770 = fsub double %192, %mul764
  store double %sub770, double* %y769, align 8, !tbaa !46
  %mul771 = fmul double %sub654, %mul753
  %193 = call double @llvm.fmuladd.f64(double %mul771, double %sub654, double %virial_zz.12584)
  %194 = load double, double* %z773, align 8, !tbaa !47
  %add774 = fadd double %mul771, %194
  store double %add774, double* %z773, align 8, !tbaa !47
  %z775 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext641, i32 2
  %195 = load double, double* %z775, align 8, !tbaa !47
  %sub776 = fsub double %195, %mul771
  store double %sub776, double* %z775, align 8, !tbaa !47
  %arrayidx777 = getelementptr inbounds double, double* %add.ptr685, i64 1
  %196 = load double, double* %arrayidx777, align 8, !tbaa !13
  %arrayidx778 = getelementptr inbounds double, double* %add.ptr685, i64 2
  %197 = load double, double* %arrayidx778, align 8, !tbaa !13
  %arrayidx779 = getelementptr inbounds double, double* %add.ptr685, i64 3
  %198 = load double, double* %arrayidx779, align 8, !tbaa !13
  %mul780 = fmul double %mul690, %198
  %mul781 = fmul double %mul690, %197
  %mul782 = fmul double %mul690, %196
  %mul783 = fmul double %148, %mul690
  %199 = call double @llvm.fmuladd.f64(double %sub693, double %mul780, double %mul781)
  %200 = call double @llvm.fmuladd.f64(double %199, double %sub693, double %mul782)
  %201 = call double @llvm.fmuladd.f64(double %200, double %sub693, double %mul783)
  %202 = call double @llvm.fmuladd.f64(double %153, double %201, double %fullElectEnergy.12583)
  %203 = call double @llvm.fmuladd.f64(double %155, double %201, double %fullElectEnergy_s.12582)
  %mul791 = fmul double %mul781, 2.000000e+00
  %204 = call double @llvm.fmuladd.f64(double %mul748, double %mul780, double %mul791)
  %205 = call double @llvm.fmuladd.f64(double %204, double %sub693, double %mul782)
  %mul793 = fmul double %205, -2.000000e+00
  %mul794 = fmul double %153, %mul793
  %mul798 = fmul double %sub645, %mul794
  %206 = call double @llvm.fmuladd.f64(double %mul798, double %sub645, double %fullElectVirial_xx.12581)
  %207 = call double @llvm.fmuladd.f64(double %mul798, double %sub650, double %fullElectVirial_xy.12580)
  %208 = call double @llvm.fmuladd.f64(double %mul798, double %sub654, double %fullElectVirial_xz.12579)
  %209 = load double, double* %x802, align 8, !tbaa !45
  %add803 = fadd double %209, %mul798
  store double %add803, double* %x802, align 8, !tbaa !45
  %x804 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext641, i32 0
  %210 = load double, double* %x804, align 8, !tbaa !45
  %sub805 = fsub double %210, %mul798
  store double %sub805, double* %x804, align 8, !tbaa !45
  %mul807 = fmul double %sub650, %mul794
  %211 = call double @llvm.fmuladd.f64(double %mul807, double %sub650, double %fullElectVirial_yy.12578)
  %212 = call double @llvm.fmuladd.f64(double %mul807, double %sub654, double %fullElectVirial_yz.12577)
  %213 = load double, double* %y810, align 8, !tbaa !46
  %add811 = fadd double %213, %mul807
  store double %add811, double* %y810, align 8, !tbaa !46
  %y812 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext641, i32 1
  %214 = load double, double* %y812, align 8, !tbaa !46
  %sub813 = fsub double %214, %mul807
  store double %sub813, double* %y812, align 8, !tbaa !46
  %mul815 = fmul double %sub654, %mul794
  %215 = call double @llvm.fmuladd.f64(double %mul815, double %sub654, double %fullElectVirial_zz.12576)
  %216 = load double, double* %z817, align 8, !tbaa !47
  %add818 = fadd double %mul815, %216
  store double %add818, double* %z817, align 8, !tbaa !47
  %z819 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext641, i32 2
  %217 = load double, double* %z819, align 8, !tbaa !47
  %sub820 = fsub double %217, %mul815
  store double %sub820, double* %z819, align 8, !tbaa !47
  %indvars.iv.next2799 = add nuw nsw i64 %indvars.iv2798, 1
  %exitcond2801.not = icmp eq i64 %indvars.iv.next2799, %wide.trip.count2800
  br i1 %exitcond2801.not, label %for.cond829.preheader, label %for.body637, !llvm.loop !48

for.cond1087.preheader:                           ; preds = %for.body831, %for.cond829.preheader
  %fullElectVirial_zz.2.lcssa = phi double [ %fullElectVirial_zz.1.lcssa, %for.cond829.preheader ], [ %303, %for.body831 ]
  %fullElectVirial_yz.2.lcssa = phi double [ %fullElectVirial_yz.1.lcssa, %for.cond829.preheader ], [ %300, %for.body831 ]
  %fullElectVirial_yy.2.lcssa = phi double [ %fullElectVirial_yy.1.lcssa, %for.cond829.preheader ], [ %299, %for.body831 ]
  %fullElectVirial_xz.2.lcssa = phi double [ %fullElectVirial_xz.1.lcssa, %for.cond829.preheader ], [ %296, %for.body831 ]
  %fullElectVirial_xy.2.lcssa = phi double [ %fullElectVirial_xy.1.lcssa, %for.cond829.preheader ], [ %295, %for.body831 ]
  %fullElectVirial_xx.2.lcssa = phi double [ %fullElectVirial_xx.1.lcssa, %for.cond829.preheader ], [ %294, %for.body831 ]
  %fullElectEnergy_s.2.lcssa = phi double [ %fullElectEnergy_s.1.lcssa, %for.cond829.preheader ], [ %291, %for.body831 ]
  %fullElectEnergy.2.lcssa = phi double [ %fullElectEnergy.1.lcssa, %for.cond829.preheader ], [ %290, %for.body831 ]
  %virial_zz.2.lcssa = phi double [ %virial_zz.1.lcssa, %for.cond829.preheader ], [ %273, %for.body831 ]
  %virial_yz.2.lcssa = phi double [ %virial_yz.1.lcssa, %for.cond829.preheader ], [ %270, %for.body831 ]
  %virial_yy.2.lcssa = phi double [ %virial_yy.1.lcssa, %for.cond829.preheader ], [ %269, %for.body831 ]
  %virial_xz.2.lcssa = phi double [ %virial_xz.1.lcssa, %for.cond829.preheader ], [ %266, %for.body831 ]
  %virial_xy.2.lcssa = phi double [ %virial_xy.1.lcssa, %for.cond829.preheader ], [ %265, %for.body831 ]
  %virial_xx.2.lcssa = phi double [ %virial_xx.1.lcssa, %for.cond829.preheader ], [ %264, %for.body831 ]
  %electEnergy_s.2.lcssa = phi double [ %electEnergy_s.1.lcssa, %for.cond829.preheader ], [ %261, %for.body831 ]
  %vdwEnergy_s.2.lcssa = phi double [ %vdwEnergy_s.1.lcssa, %for.cond829.preheader ], [ %253, %for.body831 ]
  %electEnergy.2.lcssa = phi double [ %electEnergy.1.lcssa, %for.cond829.preheader ], [ %260, %for.body831 ]
  %vdwEnergy.2.lcssa = phi double [ %vdwEnergy.1.lcssa, %for.cond829.preheader ], [ %252, %for.body831 ]
  %cmp10882650 = icmp sgt i32 %134, 0
  br i1 %cmp10882650, label %for.body1089.preheader, label %cleanup1216

for.body1089.preheader:                           ; preds = %for.cond1087.preheader
  %wide.trip.count2808 = and i64 %133, 4294967295
  br label %for.body1089

for.body831:                                      ; preds = %for.body831.preheader, %for.body831
  %indvars.iv2802 = phi i64 [ 0, %for.body831.preheader ], [ %indvars.iv.next2803, %for.body831 ]
  %vdwEnergy.22631 = phi double [ %vdwEnergy.1.lcssa, %for.body831.preheader ], [ %252, %for.body831 ]
  %electEnergy.22630 = phi double [ %electEnergy.1.lcssa, %for.body831.preheader ], [ %260, %for.body831 ]
  %vdwEnergy_s.22629 = phi double [ %vdwEnergy_s.1.lcssa, %for.body831.preheader ], [ %253, %for.body831 ]
  %electEnergy_s.22628 = phi double [ %electEnergy_s.1.lcssa, %for.body831.preheader ], [ %261, %for.body831 ]
  %virial_xx.22627 = phi double [ %virial_xx.1.lcssa, %for.body831.preheader ], [ %264, %for.body831 ]
  %virial_xy.22626 = phi double [ %virial_xy.1.lcssa, %for.body831.preheader ], [ %265, %for.body831 ]
  %virial_xz.22625 = phi double [ %virial_xz.1.lcssa, %for.body831.preheader ], [ %266, %for.body831 ]
  %virial_yy.22624 = phi double [ %virial_yy.1.lcssa, %for.body831.preheader ], [ %269, %for.body831 ]
  %virial_yz.22623 = phi double [ %virial_yz.1.lcssa, %for.body831.preheader ], [ %270, %for.body831 ]
  %virial_zz.22622 = phi double [ %virial_zz.1.lcssa, %for.body831.preheader ], [ %273, %for.body831 ]
  %fullElectEnergy.22621 = phi double [ %fullElectEnergy.1.lcssa, %for.body831.preheader ], [ %290, %for.body831 ]
  %fullElectEnergy_s.22620 = phi double [ %fullElectEnergy_s.1.lcssa, %for.body831.preheader ], [ %291, %for.body831 ]
  %fullElectVirial_xx.22619 = phi double [ %fullElectVirial_xx.1.lcssa, %for.body831.preheader ], [ %294, %for.body831 ]
  %fullElectVirial_xy.22618 = phi double [ %fullElectVirial_xy.1.lcssa, %for.body831.preheader ], [ %295, %for.body831 ]
  %fullElectVirial_xz.22617 = phi double [ %fullElectVirial_xz.1.lcssa, %for.body831.preheader ], [ %296, %for.body831 ]
  %fullElectVirial_yy.22616 = phi double [ %fullElectVirial_yy.1.lcssa, %for.body831.preheader ], [ %299, %for.body831 ]
  %fullElectVirial_yz.22615 = phi double [ %fullElectVirial_yz.1.lcssa, %for.body831.preheader ], [ %300, %for.body831 ]
  %fullElectVirial_zz.22614 = phi double [ %fullElectVirial_zz.1.lcssa, %for.body831.preheader ], [ %303, %for.body831 ]
  %arrayidx834 = getelementptr inbounds i32, i32* %cond158, i64 %indvars.iv2802
  %218 = load i32, i32* %arrayidx834, align 4, !tbaa !4
  %idx.ext836 = sext i32 %218 to i64
  %x840 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext836, i32 0, i32 0
  %219 = load double, double* %x840, align 8, !tbaa !25
  %sub841 = fsub double %62, %219
  %mul843 = fmul double %sub841, %sub841
  %y846 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext836, i32 0, i32 1
  %220 = load double, double* %y846, align 8, !tbaa !28
  %sub847 = fsub double %63, %220
  %221 = call double @llvm.fmuladd.f64(double %sub847, double %sub847, double %mul843)
  %z851 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext836, i32 0, i32 2
  %222 = load double, double* %z851, align 8, !tbaa !29
  %sub852 = fsub double %64, %222
  %223 = call double @llvm.fmuladd.f64(double %sub852, double %sub852, double %221)
  %conv855 = fptrunc double %223 to float
  %224 = bitcast float %conv855 to i32
  %shr859 = ashr i32 %224, 17
  %add860 = add nsw i32 %shr859, %mul
  %id862 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext836, i32 2
  %bf.load863 = load i32, i32* %id862, align 4
  %bf.clear864 = and i32 %bf.load863, 4194303
  %call865 = call zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear864) #9
  %conv866 = zext i16 %call865 to i64
  %mul867 = shl nuw nsw i64 %conv866, 1
  %add.ptr870.idx = or i64 %mul867, 1
  %mul872 = shl nsw i32 %add860, 4
  %idx.ext873 = sext i32 %mul872 to i64
  %add.ptr874 = getelementptr inbounds double, double* %7, i64 %idx.ext873
  %225 = load double, double* %add.ptr874, align 8, !tbaa !13
  %add.ptr881 = getelementptr inbounds double, double* %add.ptr874, i64 4
  %226 = load double, double* %add.ptr881, align 8, !tbaa !13
  %add.ptr888 = getelementptr inbounds double, double* %add.ptr874, i64 8
  %227 = load double, double* %add.ptr888, align 8, !tbaa !13
  %add.ptr896 = getelementptr inbounds double, double* %add.ptr888, i64 4
  %228 = load double, double* %add.ptr896, align 8, !tbaa !13
  %and900 = and i32 %224, -131072
  %229 = bitcast i32 %and900 to float
  %charge902 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext836, i32 1
  %230 = load float, float* %charge902, align 8, !tbaa !35
  %conv903 = fpext float %230 to double
  %mul904 = fmul double %mul405, %conv903
  %conv907 = fpext float %229 to double
  %sub908 = fsub double %223, %conv907
  %bf.load911 = load i32, i32* %id862, align 4
  %231 = lshr i32 %bf.load911, 27
  %mul914 = and i32 %231, 30
  %232 = zext i32 %mul914 to i64
  %arrayidx916 = getelementptr inbounds double, double* %add.ptr401, i64 %232
  %233 = load double, double* %arrayidx916, align 8, !tbaa !13
  %add919 = or i32 %231, 1
  %234 = zext i32 %add919 to i64
  %arrayidx921 = getelementptr inbounds double, double* %add.ptr401, i64 %234
  %235 = load double, double* %arrayidx921, align 8, !tbaa !13
  %A923 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call411, i64 %add.ptr870.idx, i32 0
  %236 = load double, double* %A923, align 8, !tbaa !42
  %mul924 = fmul double %9, %236
  %B926 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call411, i64 %add.ptr870.idx, i32 1
  %237 = load double, double* %B926, align 8, !tbaa !44
  %238 = fmul double %237, %56
  %neg931 = fmul double %226, %238
  %239 = call double @llvm.fmuladd.f64(double %mul924, double %225, double %neg931)
  %arrayidx933 = getelementptr inbounds double, double* %add.ptr874, i64 3
  %240 = load double, double* %arrayidx933, align 8, !tbaa !13
  %arrayidx935 = getelementptr inbounds double, double* %add.ptr881, i64 3
  %241 = load double, double* %arrayidx935, align 8, !tbaa !13
  %neg937 = fmul double %238, %241
  %242 = call double @llvm.fmuladd.f64(double %mul924, double %240, double %neg937)
  %arrayidx939 = getelementptr inbounds double, double* %add.ptr874, i64 2
  %243 = load double, double* %arrayidx939, align 8, !tbaa !13
  %arrayidx941 = getelementptr inbounds double, double* %add.ptr881, i64 2
  %244 = load double, double* %arrayidx941, align 8, !tbaa !13
  %neg943 = fmul double %238, %244
  %245 = call double @llvm.fmuladd.f64(double %mul924, double %243, double %neg943)
  %arrayidx945 = getelementptr inbounds double, double* %add.ptr874, i64 1
  %246 = load double, double* %arrayidx945, align 8, !tbaa !13
  %arrayidx947 = getelementptr inbounds double, double* %add.ptr881, i64 1
  %247 = load double, double* %arrayidx947, align 8, !tbaa !13
  %neg949 = fmul double %238, %247
  %248 = call double @llvm.fmuladd.f64(double %mul924, double %246, double %neg949)
  %249 = call double @llvm.fmuladd.f64(double %sub908, double %242, double %245)
  %250 = call double @llvm.fmuladd.f64(double %249, double %sub908, double %248)
  %251 = call double @llvm.fmuladd.f64(double %250, double %sub908, double %239)
  %252 = call double @llvm.fmuladd.f64(double %233, double %251, double %vdwEnergy.22631)
  %253 = call double @llvm.fmuladd.f64(double %235, double %251, double %vdwEnergy_s.22629)
  %mul957 = fmul double %sub956, %mul904
  %mul958 = fmul double %227, %mul957
  %arrayidx960 = getelementptr inbounds double, double* %add.ptr888, i64 3
  %254 = load double, double* %arrayidx960, align 8, !tbaa !13
  %mul961 = fmul double %mul957, %254
  %arrayidx963 = getelementptr inbounds double, double* %add.ptr888, i64 2
  %255 = load double, double* %arrayidx963, align 8, !tbaa !13
  %mul964 = fmul double %mul957, %255
  %arrayidx966 = getelementptr inbounds double, double* %add.ptr888, i64 1
  %256 = load double, double* %arrayidx966, align 8, !tbaa !13
  %mul967 = fmul double %mul957, %256
  %257 = call double @llvm.fmuladd.f64(double %sub908, double %mul961, double %mul964)
  %258 = call double @llvm.fmuladd.f64(double %257, double %sub908, double %mul967)
  %259 = call double @llvm.fmuladd.f64(double %258, double %sub908, double %mul958)
  %260 = call double @llvm.fmuladd.f64(double %233, double %259, double %electEnergy.22630)
  %261 = call double @llvm.fmuladd.f64(double %235, double %259, double %electEnergy_s.22628)
  %add974 = fadd double %242, %mul961
  %add975 = fadd double %245, %mul964
  %add976 = fadd double %248, %mul967
  %mul979 = fmul double %sub908, 3.000000e+00
  %mul981 = fmul double %add975, 2.000000e+00
  %262 = call double @llvm.fmuladd.f64(double %mul979, double %add974, double %mul981)
  %263 = call double @llvm.fmuladd.f64(double %262, double %sub908, double %add976)
  %mul984 = fmul double %233, -2.000000e+00
  %mul985 = fmul double %mul984, %263
  %mul990 = fmul double %sub841, %mul985
  %264 = call double @llvm.fmuladd.f64(double %mul990, double %sub841, double %virial_xx.22627)
  %265 = call double @llvm.fmuladd.f64(double %mul990, double %sub847, double %virial_xy.22626)
  %266 = call double @llvm.fmuladd.f64(double %mul990, double %sub852, double %virial_xz.22625)
  %267 = load double, double* %x760, align 8, !tbaa !45
  %add995 = fadd double %267, %mul990
  store double %add995, double* %x760, align 8, !tbaa !45
  %x996 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext836, i32 0
  %268 = load double, double* %x996, align 8, !tbaa !45
  %sub997 = fsub double %268, %mul990
  store double %sub997, double* %x996, align 8, !tbaa !45
  %mul999 = fmul double %sub847, %mul985
  %269 = call double @llvm.fmuladd.f64(double %mul999, double %sub847, double %virial_yy.22624)
  %270 = call double @llvm.fmuladd.f64(double %mul999, double %sub852, double %virial_yz.22623)
  %271 = load double, double* %y767, align 8, !tbaa !46
  %add1003 = fadd double %271, %mul999
  store double %add1003, double* %y767, align 8, !tbaa !46
  %y1004 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext836, i32 1
  %272 = load double, double* %y1004, align 8, !tbaa !46
  %sub1005 = fsub double %272, %mul999
  store double %sub1005, double* %y1004, align 8, !tbaa !46
  %mul1007 = fmul double %sub852, %mul985
  %273 = call double @llvm.fmuladd.f64(double %mul1007, double %sub852, double %virial_zz.22622)
  %274 = load double, double* %z773, align 8, !tbaa !47
  %add1010 = fadd double %mul1007, %274
  store double %add1010, double* %z773, align 8, !tbaa !47
  %z1011 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext836, i32 2
  %275 = load double, double* %z1011, align 8, !tbaa !47
  %sub1012 = fsub double %275, %mul1007
  store double %sub1012, double* %z1011, align 8, !tbaa !47
  %arrayidx1014 = getelementptr inbounds double, double* %add.ptr896, i64 1
  %276 = load double, double* %arrayidx1014, align 8, !tbaa !13
  %arrayidx1016 = getelementptr inbounds double, double* %add.ptr896, i64 2
  %277 = load double, double* %arrayidx1016, align 8, !tbaa !13
  %arrayidx1018 = getelementptr inbounds double, double* %add.ptr896, i64 3
  %278 = load double, double* %arrayidx1018, align 8, !tbaa !13
  %mul1019 = shl nsw i32 %add860, 2
  %idx.ext1020 = sext i32 %mul1019 to i64
  %add.ptr1021 = getelementptr inbounds double, double* %8, i64 %idx.ext1020
  %279 = load double, double* %add.ptr1021, align 8, !tbaa !13
  %280 = call double @llvm.fmuladd.f64(double %neg1024, double %279, double %228)
  %arrayidx1025 = getelementptr inbounds double, double* %add.ptr1021, i64 1
  %281 = load double, double* %arrayidx1025, align 8, !tbaa !13
  %282 = call double @llvm.fmuladd.f64(double %neg1024, double %281, double %276)
  %arrayidx1028 = getelementptr inbounds double, double* %add.ptr1021, i64 2
  %283 = load double, double* %arrayidx1028, align 8, !tbaa !13
  %284 = call double @llvm.fmuladd.f64(double %neg1024, double %283, double %277)
  %arrayidx1031 = getelementptr inbounds double, double* %add.ptr1021, i64 3
  %285 = load double, double* %arrayidx1031, align 8, !tbaa !13
  %286 = call double @llvm.fmuladd.f64(double %neg1024, double %285, double %278)
  %mul1034 = fmul double %mul904, %286
  %mul1035 = fmul double %mul904, %284
  %mul1036 = fmul double %mul904, %282
  %mul1037 = fmul double %mul904, %280
  %287 = call double @llvm.fmuladd.f64(double %sub908, double %mul1034, double %mul1035)
  %288 = call double @llvm.fmuladd.f64(double %287, double %sub908, double %mul1036)
  %289 = call double @llvm.fmuladd.f64(double %288, double %sub908, double %mul1037)
  %290 = call double @llvm.fmuladd.f64(double %233, double %289, double %fullElectEnergy.22621)
  %291 = call double @llvm.fmuladd.f64(double %235, double %289, double %fullElectEnergy_s.22620)
  %mul1047 = fmul double %mul1035, 2.000000e+00
  %292 = call double @llvm.fmuladd.f64(double %mul979, double %mul1034, double %mul1047)
  %293 = call double @llvm.fmuladd.f64(double %292, double %sub908, double %mul1036)
  %mul1050 = fmul double %293, -2.000000e+00
  %mul1051 = fmul double %233, %mul1050
  %mul1056 = fmul double %sub841, %mul1051
  %294 = call double @llvm.fmuladd.f64(double %mul1056, double %sub841, double %fullElectVirial_xx.22619)
  %295 = call double @llvm.fmuladd.f64(double %mul1056, double %sub847, double %fullElectVirial_xy.22618)
  %296 = call double @llvm.fmuladd.f64(double %mul1056, double %sub852, double %fullElectVirial_xz.22617)
  %297 = load double, double* %x802, align 8, !tbaa !45
  %add1061 = fadd double %297, %mul1056
  store double %add1061, double* %x802, align 8, !tbaa !45
  %x1062 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext836, i32 0
  %298 = load double, double* %x1062, align 8, !tbaa !45
  %sub1063 = fsub double %298, %mul1056
  store double %sub1063, double* %x1062, align 8, !tbaa !45
  %mul1065 = fmul double %sub847, %mul1051
  %299 = call double @llvm.fmuladd.f64(double %mul1065, double %sub847, double %fullElectVirial_yy.22616)
  %300 = call double @llvm.fmuladd.f64(double %mul1065, double %sub852, double %fullElectVirial_yz.22615)
  %301 = load double, double* %y810, align 8, !tbaa !46
  %add1069 = fadd double %301, %mul1065
  store double %add1069, double* %y810, align 8, !tbaa !46
  %y1070 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext836, i32 1
  %302 = load double, double* %y1070, align 8, !tbaa !46
  %sub1071 = fsub double %302, %mul1065
  store double %sub1071, double* %y1070, align 8, !tbaa !46
  %mul1073 = fmul double %sub852, %mul1051
  %303 = call double @llvm.fmuladd.f64(double %mul1073, double %sub852, double %fullElectVirial_zz.22614)
  %304 = load double, double* %z817, align 8, !tbaa !47
  %add1076 = fadd double %mul1073, %304
  store double %add1076, double* %z817, align 8, !tbaa !47
  %z1077 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext836, i32 2
  %305 = load double, double* %z1077, align 8, !tbaa !47
  %sub1078 = fsub double %305, %mul1073
  store double %sub1078, double* %z1077, align 8, !tbaa !47
  %indvars.iv.next2803 = add nuw nsw i64 %indvars.iv2802, 1
  %exitcond2805.not = icmp eq i64 %indvars.iv.next2803, %wide.trip.count2804
  br i1 %exitcond2805.not, label %for.cond1087.preheader, label %for.body831, !llvm.loop !49

for.body1089:                                     ; preds = %for.body1089.preheader, %for.body1089
  %indvars.iv2806 = phi i64 [ 0, %for.body1089.preheader ], [ %indvars.iv.next2807, %for.body1089 ]
  %fullElectEnergy.32659 = phi double [ %fullElectEnergy.2.lcssa, %for.body1089.preheader ], [ %332, %for.body1089 ]
  %fullElectEnergy_s.32658 = phi double [ %fullElectEnergy_s.2.lcssa, %for.body1089.preheader ], [ %333, %for.body1089 ]
  %fullElectVirial_xx.32657 = phi double [ %fullElectVirial_xx.2.lcssa, %for.body1089.preheader ], [ %336, %for.body1089 ]
  %fullElectVirial_xy.32656 = phi double [ %fullElectVirial_xy.2.lcssa, %for.body1089.preheader ], [ %337, %for.body1089 ]
  %fullElectVirial_xz.32655 = phi double [ %fullElectVirial_xz.2.lcssa, %for.body1089.preheader ], [ %338, %for.body1089 ]
  %fullElectVirial_yy.32654 = phi double [ %fullElectVirial_yy.2.lcssa, %for.body1089.preheader ], [ %341, %for.body1089 ]
  %fullElectVirial_yz.32653 = phi double [ %fullElectVirial_yz.2.lcssa, %for.body1089.preheader ], [ %342, %for.body1089 ]
  %fullElectVirial_zz.32652 = phi double [ %fullElectVirial_zz.2.lcssa, %for.body1089.preheader ], [ %345, %for.body1089 ]
  %arrayidx1092 = getelementptr inbounds i32, i32* %cond1472493, i64 %indvars.iv2806
  %306 = load i32, i32* %arrayidx1092, align 4, !tbaa !4
  %idx.ext1094 = sext i32 %306 to i64
  %x1098 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1094, i32 0, i32 0
  %307 = load double, double* %x1098, align 8, !tbaa !25
  %sub1099 = fsub double %62, %307
  %mul1101 = fmul double %sub1099, %sub1099
  %y1104 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1094, i32 0, i32 1
  %308 = load double, double* %y1104, align 8, !tbaa !28
  %sub1105 = fsub double %63, %308
  %309 = call double @llvm.fmuladd.f64(double %sub1105, double %sub1105, double %mul1101)
  %z1109 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1094, i32 0, i32 2
  %310 = load double, double* %z1109, align 8, !tbaa !29
  %sub1110 = fsub double %64, %310
  %311 = call double @llvm.fmuladd.f64(double %sub1110, double %sub1110, double %309)
  %conv1113 = fptrunc double %311 to float
  %312 = bitcast float %conv1113 to i32
  %shr1117 = ashr i32 %312, 17
  %add1118 = add nsw i32 %shr1117, %mul
  %mul1120 = shl nsw i32 %add1118, 4
  %313 = or i32 %mul1120, 12
  %add.ptr1124.idx = sext i32 %313 to i64
  %add.ptr1124 = getelementptr inbounds double, double* %7, i64 %add.ptr1124.idx
  %314 = load double, double* %add.ptr1124, align 8, !tbaa !13
  %and1128 = and i32 %312, -131072
  %315 = bitcast i32 %and1128 to float
  %charge1130 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1094, i32 1
  %316 = load float, float* %charge1130, align 8, !tbaa !35
  %conv1131 = fpext float %316 to double
  %mul1132 = fmul double %mul405, %conv1131
  %conv1135 = fpext float %315 to double
  %sub1136 = fsub double %311, %conv1135
  %partition1138 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1094, i32 2
  %bf.load1139 = load i32, i32* %partition1138, align 4
  %317 = lshr i32 %bf.load1139, 27
  %mul1142 = and i32 %317, 30
  %318 = zext i32 %mul1142 to i64
  %arrayidx1144 = getelementptr inbounds double, double* %add.ptr401, i64 %318
  %319 = load double, double* %arrayidx1144, align 8, !tbaa !13
  %add1147 = or i32 %317, 1
  %320 = zext i32 %add1147 to i64
  %arrayidx1149 = getelementptr inbounds double, double* %add.ptr401, i64 %320
  %321 = load double, double* %arrayidx1149, align 8, !tbaa !13
  %arrayidx1151 = getelementptr inbounds double, double* %add.ptr1124, i64 1
  %322 = load double, double* %arrayidx1151, align 8, !tbaa !13
  %arrayidx1153 = getelementptr inbounds double, double* %add.ptr1124, i64 2
  %323 = load double, double* %arrayidx1153, align 8, !tbaa !13
  %arrayidx1155 = getelementptr inbounds double, double* %add.ptr1124, i64 3
  %324 = load double, double* %arrayidx1155, align 8, !tbaa !13
  %mul1157 = shl nsw i32 %add1118, 2
  %idx.ext1158 = sext i32 %mul1157 to i64
  %add.ptr1159 = getelementptr inbounds double, double* %8, i64 %idx.ext1158
  %325 = load double, double* %add.ptr1159, align 8, !tbaa !13
  %sub1161 = fsub double %314, %325
  %arrayidx1162 = getelementptr inbounds double, double* %add.ptr1159, i64 1
  %326 = load double, double* %arrayidx1162, align 8, !tbaa !13
  %sub1163 = fsub double %322, %326
  %arrayidx1164 = getelementptr inbounds double, double* %add.ptr1159, i64 2
  %327 = load double, double* %arrayidx1164, align 8, !tbaa !13
  %sub1165 = fsub double %323, %327
  %arrayidx1166 = getelementptr inbounds double, double* %add.ptr1159, i64 3
  %328 = load double, double* %arrayidx1166, align 8, !tbaa !13
  %sub1167 = fsub double %324, %328
  %mul1168 = fmul double %mul1132, %sub1167
  %mul1169 = fmul double %mul1132, %sub1165
  %mul1170 = fmul double %mul1132, %sub1163
  %mul1171 = fmul double %mul1132, %sub1161
  %329 = call double @llvm.fmuladd.f64(double %sub1136, double %mul1168, double %mul1169)
  %330 = call double @llvm.fmuladd.f64(double %329, double %sub1136, double %mul1170)
  %331 = call double @llvm.fmuladd.f64(double %330, double %sub1136, double %mul1171)
  %332 = call double @llvm.fmuladd.f64(double %319, double %331, double %fullElectEnergy.32659)
  %333 = call double @llvm.fmuladd.f64(double %321, double %331, double %fullElectEnergy_s.32658)
  %mul1179 = fmul double %sub1136, 3.000000e+00
  %mul1181 = fmul double %mul1169, 2.000000e+00
  %334 = call double @llvm.fmuladd.f64(double %mul1179, double %mul1168, double %mul1181)
  %335 = call double @llvm.fmuladd.f64(double %334, double %sub1136, double %mul1170)
  %mul1184 = fmul double %335, -2.000000e+00
  %mul1185 = fmul double %319, %mul1184
  %mul1190 = fmul double %sub1099, %mul1185
  %336 = call double @llvm.fmuladd.f64(double %mul1190, double %sub1099, double %fullElectVirial_xx.32657)
  %337 = call double @llvm.fmuladd.f64(double %mul1190, double %sub1105, double %fullElectVirial_xy.32656)
  %338 = call double @llvm.fmuladd.f64(double %mul1190, double %sub1110, double %fullElectVirial_xz.32655)
  %339 = load double, double* %x802, align 8, !tbaa !45
  %add1195 = fadd double %339, %mul1190
  store double %add1195, double* %x802, align 8, !tbaa !45
  %x1196 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext1094, i32 0
  %340 = load double, double* %x1196, align 8, !tbaa !45
  %sub1197 = fsub double %340, %mul1190
  store double %sub1197, double* %x1196, align 8, !tbaa !45
  %mul1199 = fmul double %sub1105, %mul1185
  %341 = call double @llvm.fmuladd.f64(double %mul1199, double %sub1105, double %fullElectVirial_yy.32654)
  %342 = call double @llvm.fmuladd.f64(double %mul1199, double %sub1110, double %fullElectVirial_yz.32653)
  %343 = load double, double* %y810, align 8, !tbaa !46
  %add1203 = fadd double %343, %mul1199
  store double %add1203, double* %y810, align 8, !tbaa !46
  %y1204 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext1094, i32 1
  %344 = load double, double* %y1204, align 8, !tbaa !46
  %sub1205 = fsub double %344, %mul1199
  store double %sub1205, double* %y1204, align 8, !tbaa !46
  %mul1207 = fmul double %sub1110, %mul1185
  %345 = call double @llvm.fmuladd.f64(double %mul1207, double %sub1110, double %fullElectVirial_zz.32652)
  %346 = load double, double* %z817, align 8, !tbaa !47
  %add1210 = fadd double %mul1207, %346
  store double %add1210, double* %z817, align 8, !tbaa !47
  %z1211 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext1094, i32 2
  %347 = load double, double* %z1211, align 8, !tbaa !47
  %sub1212 = fsub double %347, %mul1207
  store double %sub1212, double* %z1211, align 8, !tbaa !47
  %indvars.iv.next2807 = add nuw nsw i64 %indvars.iv2806, 1
  %exitcond2809.not = icmp eq i64 %indvars.iv.next2807, %wide.trip.count2808
  br i1 %exitcond2809.not, label %cleanup1216, label %for.body1089, !llvm.loop !50

cleanup1216:                                      ; preds = %for.body1089, %for.cond1087.preheader, %if.then204
  %pairCount.3 = phi i32 [ %sub216, %if.then204 ], [ %pairCount.2, %for.cond1087.preheader ], [ %pairCount.2, %for.body1089 ]
  %pairlistoffset.2 = phi i32 [ %pairlistoffset.02670, %if.then204 ], [ %pairlistoffset.1, %for.cond1087.preheader ], [ %pairlistoffset.1, %for.body1089 ]
  %pairlistindex.3 = phi i32 [ %pairlistindex.02671, %if.then204 ], [ %pairlistindex.2, %for.cond1087.preheader ], [ %pairlistindex.2, %for.body1089 ]
  %fixg_lower.4 = phi i32 [ %fixg_lower.02672, %if.then204 ], [ %fixg_lower.3, %for.cond1087.preheader ], [ %fixg_lower.3, %for.body1089 ]
  %g_lower.4 = phi i32 [ %g_lower.02673, %if.then204 ], [ %g_lower.3, %for.cond1087.preheader ], [ %g_lower.3, %for.body1089 ]
  %j_hgroup.3 = phi i32 [ %j_hgroup.02674, %if.then204 ], [ %j_hgroup.2, %for.cond1087.preheader ], [ %j_hgroup.2, %for.body1089 ]
  %i.4 = phi i32 [ %add222, %if.then204 ], [ %i.02675, %for.cond1087.preheader ], [ %i.02675, %for.body1089 ]
  %fullElectVirial_zz.4 = phi double [ %fullElectVirial_zz.02677, %if.then204 ], [ %fullElectVirial_zz.2.lcssa, %for.cond1087.preheader ], [ %345, %for.body1089 ]
  %fullElectVirial_yz.4 = phi double [ %fullElectVirial_yz.02678, %if.then204 ], [ %fullElectVirial_yz.2.lcssa, %for.cond1087.preheader ], [ %342, %for.body1089 ]
  %fullElectVirial_yy.4 = phi double [ %fullElectVirial_yy.02679, %if.then204 ], [ %fullElectVirial_yy.2.lcssa, %for.cond1087.preheader ], [ %341, %for.body1089 ]
  %fullElectVirial_xz.4 = phi double [ %fullElectVirial_xz.02680, %if.then204 ], [ %fullElectVirial_xz.2.lcssa, %for.cond1087.preheader ], [ %338, %for.body1089 ]
  %fullElectVirial_xy.4 = phi double [ %fullElectVirial_xy.02681, %if.then204 ], [ %fullElectVirial_xy.2.lcssa, %for.cond1087.preheader ], [ %337, %for.body1089 ]
  %fullElectVirial_xx.4 = phi double [ %fullElectVirial_xx.02682, %if.then204 ], [ %fullElectVirial_xx.2.lcssa, %for.cond1087.preheader ], [ %336, %for.body1089 ]
  %fullElectEnergy_s.4 = phi double [ %fullElectEnergy_s.02683, %if.then204 ], [ %fullElectEnergy_s.2.lcssa, %for.cond1087.preheader ], [ %333, %for.body1089 ]
  %fullElectEnergy.4 = phi double [ %fullElectEnergy.02684, %if.then204 ], [ %fullElectEnergy.2.lcssa, %for.cond1087.preheader ], [ %332, %for.body1089 ]
  %virial_zz.3 = phi double [ %virial_zz.02685, %if.then204 ], [ %virial_zz.2.lcssa, %for.cond1087.preheader ], [ %virial_zz.2.lcssa, %for.body1089 ]
  %virial_yz.3 = phi double [ %virial_yz.02686, %if.then204 ], [ %virial_yz.2.lcssa, %for.cond1087.preheader ], [ %virial_yz.2.lcssa, %for.body1089 ]
  %virial_yy.3 = phi double [ %virial_yy.02687, %if.then204 ], [ %virial_yy.2.lcssa, %for.cond1087.preheader ], [ %virial_yy.2.lcssa, %for.body1089 ]
  %virial_xz.3 = phi double [ %virial_xz.02688, %if.then204 ], [ %virial_xz.2.lcssa, %for.cond1087.preheader ], [ %virial_xz.2.lcssa, %for.body1089 ]
  %virial_xy.3 = phi double [ %virial_xy.02689, %if.then204 ], [ %virial_xy.2.lcssa, %for.cond1087.preheader ], [ %virial_xy.2.lcssa, %for.body1089 ]
  %virial_xx.3 = phi double [ %virial_xx.02690, %if.then204 ], [ %virial_xx.2.lcssa, %for.cond1087.preheader ], [ %virial_xx.2.lcssa, %for.body1089 ]
  %electEnergy_s.3 = phi double [ %electEnergy_s.02691, %if.then204 ], [ %electEnergy_s.2.lcssa, %for.cond1087.preheader ], [ %electEnergy_s.2.lcssa, %for.body1089 ]
  %vdwEnergy_s.3 = phi double [ %vdwEnergy_s.02692, %if.then204 ], [ %vdwEnergy_s.2.lcssa, %for.cond1087.preheader ], [ %vdwEnergy_s.2.lcssa, %for.body1089 ]
  %electEnergy.3 = phi double [ %electEnergy.02693, %if.then204 ], [ %electEnergy.2.lcssa, %for.cond1087.preheader ], [ %electEnergy.2.lcssa, %for.body1089 ]
  %vdwEnergy.3 = phi double [ %vdwEnergy.02694, %if.then204 ], [ %vdwEnergy.2.lcssa, %for.cond1087.preheader ], [ %vdwEnergy.2.lcssa, %for.body1089 ]
  %exclChecksum.11 = phi i32 [ %exclChecksum.02695, %if.then204 ], [ %conv629, %for.cond1087.preheader ], [ %conv629, %for.body1089 ]
  %inc1229 = add nsw i32 %i.4, 1
  %cmp174 = icmp sgt i32 %sub165, %inc1229
  br i1 %cmp174, label %for.body175, label %for.end1230, !llvm.loop !51

for.end1230:                                      ; preds = %cleanup1216, %cond.end157
  %fullElectVirial_zz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_zz.4, %cleanup1216 ]
  %fullElectVirial_yz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_yz.4, %cleanup1216 ]
  %fullElectVirial_yy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_yy.4, %cleanup1216 ]
  %fullElectVirial_xz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_xz.4, %cleanup1216 ]
  %fullElectVirial_xy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_xy.4, %cleanup1216 ]
  %fullElectVirial_xx.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_xx.4, %cleanup1216 ]
  %fullElectEnergy_s.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectEnergy_s.4, %cleanup1216 ]
  %fullElectEnergy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectEnergy.4, %cleanup1216 ]
  %virial_zz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_zz.3, %cleanup1216 ]
  %virial_yz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_yz.3, %cleanup1216 ]
  %virial_yy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_yy.3, %cleanup1216 ]
  %virial_xz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_xz.3, %cleanup1216 ]
  %virial_xy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_xy.3, %cleanup1216 ]
  %virial_xx.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_xx.3, %cleanup1216 ]
  %electEnergy_s.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %electEnergy_s.3, %cleanup1216 ]
  %vdwEnergy_s.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %vdwEnergy_s.3, %cleanup1216 ]
  %electEnergy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %electEnergy.3, %cleanup1216 ]
  %vdwEnergy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %vdwEnergy.3, %cleanup1216 ]
  %exclChecksum.0.lcssa = phi i32 [ 0, %cond.end157 ], [ %exclChecksum.11, %cleanup1216 ]
  %arraydecay1231 = getelementptr inbounds [1005 x i32], [1005 x i32]* %grouplist_std, i64 0, i64 0
  %cmp1232 = icmp eq i32* %cond24542458282528352848, %arraydecay1231
  br i1 %cmp1232, label %if.end1237, label %delete.notnull1235

delete.notnull1235:                               ; preds = %for.end1230
  %348 = bitcast i32* %cond24542458282528352848 to i8*
  call void @_ZdaPv(i8* %348) #8
  br label %if.end1237

if.end1237:                                       ; preds = %delete.notnull1235, %for.end1230
  %arraydecay1238 = getelementptr inbounds [1005 x i32], [1005 x i32]* %fixglist_std, i64 0, i64 0
  %cmp1239 = icmp eq i32* %cond192460282328362846, %arraydecay1238
  br i1 %cmp1239, label %if.end1244, label %delete.notnull1242

delete.notnull1242:                               ; preds = %if.end1237
  %349 = bitcast i32* %cond192460282328362846 to i8*
  call void @_ZdaPv(i8* %349) #8
  br label %if.end1244

if.end1244:                                       ; preds = %delete.notnull1242, %if.end1237
  %arraydecay1245 = getelementptr inbounds [1005 x i32], [1005 x i32]* %goodglist_std, i64 0, i64 0
  %cmp1246 = icmp eq i32* %cond30282728342850, %arraydecay1245
  br i1 %cmp1246, label %if.end1251, label %delete.notnull1249

delete.notnull1249:                               ; preds = %if.end1244
  %350 = bitcast i32* %cond30282728342850 to i8*
  call void @_ZdaPv(i8* %350) #8
  br label %if.end1251

if.end1251:                                       ; preds = %delete.notnull1249, %if.end1244
  %arraydecay1252 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist_std, i64 0, i64 0
  %cmp1253 = icmp eq i32* %cond1142466247024792489, %arraydecay1252
  br i1 %cmp1253, label %if.end1258, label %delete.notnull1256

delete.notnull1256:                               ; preds = %if.end1251
  %351 = bitcast i32* %cond1142466247024792489 to i8*
  call void @_ZdaPv(i8* %351) #8
  br label %if.end1258

if.end1258:                                       ; preds = %delete.notnull1256, %if.end1251
  %arraydecay1259 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist2_std, i64 0, i64 0
  %cmp1260 = icmp eq i32* %cond125247224772491, %arraydecay1259
  br i1 %cmp1260, label %if.end1265, label %delete.notnull1263

delete.notnull1263:                               ; preds = %if.end1258
  %352 = bitcast i32* %cond125247224772491 to i8*
  call void @_ZdaPv(i8* %352) #8
  br label %if.end1265

if.end1265:                                       ; preds = %delete.notnull1263, %if.end1258
  %arraydecay1266 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistn_std, i64 0, i64 0
  %cmp1267 = icmp eq i32* %cond13624812487, %arraydecay1266
  br i1 %cmp1267, label %if.end1272, label %delete.notnull1270

delete.notnull1270:                               ; preds = %if.end1265
  %353 = bitcast i32* %cond13624812487 to i8*
  call void @_ZdaPv(i8* %353) #8
  br label %if.end1272

if.end1272:                                       ; preds = %delete.notnull1270, %if.end1265
  %arraydecay1273 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistx_std, i64 0, i64 0
  %cmp1274 = icmp eq i32* %cond1472493, %arraydecay1273
  br i1 %cmp1274, label %if.end1279, label %delete.notnull1277

delete.notnull1277:                               ; preds = %if.end1272
  %354 = bitcast i32* %cond1472493 to i8*
  call void @_ZdaPv(i8* %354) #8
  br label %if.end1279

if.end1279:                                       ; preds = %delete.notnull1277, %if.end1272
  %arraydecay1280 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistm_std, i64 0, i64 0
  %cmp1281 = icmp eq i32* %cond158, %arraydecay1280
  br i1 %cmp1281, label %if.end1286, label %delete.notnull1284

delete.notnull1284:                               ; preds = %if.end1279
  %355 = bitcast i32* %cond158 to i8*
  call void @_ZdaPv(i8* %355) #8
  br label %if.end1286

if.end1286:                                       ; preds = %delete.notnull1284, %if.end1279
  %conv1287 = sitofp i32 %exclChecksum.0.lcssa to double
  %arrayidx1288 = getelementptr inbounds double, double* %1, i64 22
  %356 = load double, double* %arrayidx1288, align 8, !tbaa !13
  %add1289 = fadd double %356, %conv1287
  store double %add1289, double* %arrayidx1288, align 8, !tbaa !13
  %arrayidx1290 = getelementptr inbounds double, double* %1, i64 2
  %357 = load double, double* %arrayidx1290, align 8, !tbaa !13
  %add1291 = fadd double %vdwEnergy.0.lcssa, %357
  store double %add1291, double* %arrayidx1290, align 8, !tbaa !13
  %358 = load double, double* %1, align 8, !tbaa !13
  %add1293 = fadd double %electEnergy.0.lcssa, %358
  store double %add1293, double* %1, align 8, !tbaa !13
  %arrayidx1294 = getelementptr inbounds double, double* %1, i64 25
  %359 = load double, double* %arrayidx1294, align 8, !tbaa !13
  %add1295 = fadd double %vdwEnergy_s.0.lcssa, %359
  store double %add1295, double* %arrayidx1294, align 8, !tbaa !13
  %arrayidx1296 = getelementptr inbounds double, double* %1, i64 23
  %360 = load double, double* %arrayidx1296, align 8, !tbaa !13
  %add1297 = fadd double %electEnergy_s.0.lcssa, %360
  store double %add1297, double* %arrayidx1296, align 8, !tbaa !13
  %arrayidx1298 = getelementptr inbounds double, double* %1, i64 3
  %361 = load double, double* %arrayidx1298, align 8, !tbaa !13
  %add1299 = fadd double %virial_xx.0.lcssa, %361
  store double %add1299, double* %arrayidx1298, align 8, !tbaa !13
  %arrayidx1300 = getelementptr inbounds double, double* %1, i64 4
  %362 = load double, double* %arrayidx1300, align 8, !tbaa !13
  %add1301 = fadd double %virial_xy.0.lcssa, %362
  store double %add1301, double* %arrayidx1300, align 8, !tbaa !13
  %arrayidx1302 = getelementptr inbounds double, double* %1, i64 5
  %363 = load double, double* %arrayidx1302, align 8, !tbaa !13
  %add1303 = fadd double %virial_xz.0.lcssa, %363
  store double %add1303, double* %arrayidx1302, align 8, !tbaa !13
  %arrayidx1304 = getelementptr inbounds double, double* %1, i64 6
  %364 = load double, double* %arrayidx1304, align 8, !tbaa !13
  %add1305 = fadd double %virial_xy.0.lcssa, %364
  store double %add1305, double* %arrayidx1304, align 8, !tbaa !13
  %arrayidx1306 = getelementptr inbounds double, double* %1, i64 7
  %365 = load double, double* %arrayidx1306, align 8, !tbaa !13
  %add1307 = fadd double %virial_yy.0.lcssa, %365
  store double %add1307, double* %arrayidx1306, align 8, !tbaa !13
  %arrayidx1308 = getelementptr inbounds double, double* %1, i64 8
  %366 = load double, double* %arrayidx1308, align 8, !tbaa !13
  %add1309 = fadd double %virial_yz.0.lcssa, %366
  store double %add1309, double* %arrayidx1308, align 8, !tbaa !13
  %arrayidx1310 = getelementptr inbounds double, double* %1, i64 9
  %367 = load double, double* %arrayidx1310, align 8, !tbaa !13
  %add1311 = fadd double %virial_xz.0.lcssa, %367
  store double %add1311, double* %arrayidx1310, align 8, !tbaa !13
  %arrayidx1312 = getelementptr inbounds double, double* %1, i64 10
  %368 = load double, double* %arrayidx1312, align 8, !tbaa !13
  %add1313 = fadd double %virial_yz.0.lcssa, %368
  store double %add1313, double* %arrayidx1312, align 8, !tbaa !13
  %arrayidx1314 = getelementptr inbounds double, double* %1, i64 11
  %369 = load double, double* %arrayidx1314, align 8, !tbaa !13
  %add1315 = fadd double %virial_zz.0.lcssa, %369
  store double %add1315, double* %arrayidx1314, align 8, !tbaa !13
  %arrayidx1316 = getelementptr inbounds double, double* %1, i64 1
  %370 = load double, double* %arrayidx1316, align 8, !tbaa !13
  %add1317 = fadd double %fullElectEnergy.0.lcssa, %370
  store double %add1317, double* %arrayidx1316, align 8, !tbaa !13
  %arrayidx1318 = getelementptr inbounds double, double* %1, i64 24
  %371 = load double, double* %arrayidx1318, align 8, !tbaa !13
  %add1319 = fadd double %fullElectEnergy_s.0.lcssa, %371
  store double %add1319, double* %arrayidx1318, align 8, !tbaa !13
  %arrayidx1320 = getelementptr inbounds double, double* %1, i64 12
  %372 = load double, double* %arrayidx1320, align 8, !tbaa !13
  %add1321 = fadd double %fullElectVirial_xx.0.lcssa, %372
  store double %add1321, double* %arrayidx1320, align 8, !tbaa !13
  %arrayidx1322 = getelementptr inbounds double, double* %1, i64 13
  %373 = load double, double* %arrayidx1322, align 8, !tbaa !13
  %add1323 = fadd double %fullElectVirial_xy.0.lcssa, %373
  store double %add1323, double* %arrayidx1322, align 8, !tbaa !13
  %arrayidx1324 = getelementptr inbounds double, double* %1, i64 14
  %374 = load double, double* %arrayidx1324, align 8, !tbaa !13
  %add1325 = fadd double %fullElectVirial_xz.0.lcssa, %374
  store double %add1325, double* %arrayidx1324, align 8, !tbaa !13
  %arrayidx1326 = getelementptr inbounds double, double* %1, i64 15
  %375 = load double, double* %arrayidx1326, align 8, !tbaa !13
  %add1327 = fadd double %fullElectVirial_xy.0.lcssa, %375
  store double %add1327, double* %arrayidx1326, align 8, !tbaa !13
  %arrayidx1328 = getelementptr inbounds double, double* %1, i64 16
  %376 = load double, double* %arrayidx1328, align 8, !tbaa !13
  %add1329 = fadd double %fullElectVirial_yy.0.lcssa, %376
  store double %add1329, double* %arrayidx1328, align 8, !tbaa !13
  %arrayidx1330 = getelementptr inbounds double, double* %1, i64 17
  %377 = load double, double* %arrayidx1330, align 8, !tbaa !13
  %add1331 = fadd double %fullElectVirial_yz.0.lcssa, %377
  store double %add1331, double* %arrayidx1330, align 8, !tbaa !13
  %arrayidx1332 = getelementptr inbounds double, double* %1, i64 18
  %378 = load double, double* %arrayidx1332, align 8, !tbaa !13
  %add1333 = fadd double %fullElectVirial_xz.0.lcssa, %378
  store double %add1333, double* %arrayidx1332, align 8, !tbaa !13
  %arrayidx1334 = getelementptr inbounds double, double* %1, i64 19
  %379 = load double, double* %arrayidx1334, align 8, !tbaa !13
  %add1335 = fadd double %fullElectVirial_yz.0.lcssa, %379
  store double %add1335, double* %arrayidx1334, align 8, !tbaa !13
  %arrayidx1336 = getelementptr inbounds double, double* %1, i64 20
  %380 = load double, double* %arrayidx1336, align 8, !tbaa !13
  %add1337 = fadd double %fullElectVirial_zz.0.lcssa, %380
  store double %add1337, double* %arrayidx1336, align 8, !tbaa !13
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %41) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %40) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %39) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %38) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %37) #6
  br label %cleanup1338

cleanup1338:                                      ; preds = %if.end52.thread, %delete.notnull91, %if.end86, %if.end1286
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %19) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %18) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %17) #6
  br label %cleanup.cont1391

cleanup.cont1391:                                 ; preds = %entry, %cleanup1338
  ret void
}

; Function Attrs: noinline optsize uwtable
define void @_ZN20ComputeNonbondedUtil30calc_self_energy_fullelect_lesEP9nonbonded(%struct.nonbonded* nocapture readonly %params) #4 align 2 {
entry:
  %grouplist_std = alloca [1005 x i32], align 16
  %fixglist_std = alloca [1005 x i32], align 16
  %goodglist_std = alloca [1005 x i32], align 16
  %pairlist_std = alloca [1005 x i32], align 16
  %pairlist2_std = alloca [1005 x i32], align 16
  %pairlistn_std = alloca [1005 x i32], align 16
  %pairlistx_std = alloca [1005 x i32], align 16
  %pairlistm_std = alloca [1005 x i32], align 16
  %0 = load i32, i32* @_ZN20ComputeNonbondedUtil8commOnlyE, align 4, !tbaa !4
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %if.end, label %cleanup.cont1357

if.end:                                           ; preds = %entry
  %reduction1 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 4
  %1 = load double*, double** %reduction1, align 8, !tbaa !8
  %2 = load double, double* @_ZN20ComputeNonbondedUtil7cutoff2E, align 8, !tbaa !13
  %3 = load double, double* @_ZN20ComputeNonbondedUtil12groupcutoff2E, align 8, !tbaa !13
  %4 = load double, double* @_ZN20ComputeNonbondedUtil12dielectric_1E, align 8, !tbaa !13
  %5 = load %class.LJTable*, %class.LJTable** @_ZN20ComputeNonbondedUtil7ljTableE, align 8, !tbaa !14
  %6 = load %class.Molecule*, %class.Molecule** @_ZN20ComputeNonbondedUtil3molE, align 8, !tbaa !14
  %7 = load double*, double** @_ZN20ComputeNonbondedUtil11table_shortE, align 8, !tbaa !14
  %8 = load double*, double** @_ZN20ComputeNonbondedUtil10slow_tableE, align 8, !tbaa !14
  %9 = load double, double* @_ZN20ComputeNonbondedUtil7scalingE, align 8, !tbaa !13
  %10 = load double, double* @_ZN20ComputeNonbondedUtil7scale14E, align 8, !tbaa !13
  %sub = fsub double 1.000000e+00, %10
  %11 = load double, double* @_ZN20ComputeNonbondedUtil8r2_deltaE, align 8, !tbaa !13
  %12 = load i32, i32* @_ZN20ComputeNonbondedUtil12r2_delta_expE, align 4, !tbaa !4
  %sub2 = shl i32 %12, 6
  %mul = add i32 %sub2, -8128
  %arrayidx = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 3, i64 0
  %13 = load i32, i32* %arrayidx, align 8, !tbaa !4
  %arrayidx4 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 3, i64 1
  %14 = load i32, i32* %arrayidx4, align 4, !tbaa !4
  %arrayidx5 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 0, i64 0
  %15 = load %struct.CompAtom*, %struct.CompAtom** %arrayidx5, align 8, !tbaa !14
  %arrayidx7 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 0, i64 1
  %16 = load %struct.CompAtom*, %struct.CompAtom** %arrayidx7, align 8, !tbaa !14
  %17 = bitcast [1005 x i32]* %grouplist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %17) #6
  %18 = bitcast [1005 x i32]* %fixglist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %18) #6
  %19 = bitcast [1005 x i32]* %goodglist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %19) #6
  %cmp = icmp slt i32 %14, 1000
  br i1 %cmp, label %cond.end29, label %cond.end29.thread

cond.end29.thread:                                ; preds = %if.end
  %add = add nuw nsw i32 %14, 5
  %20 = zext i32 %add to i64
  %21 = shl nuw nsw i64 %20, 2
  %call = tail call noalias nonnull i8* @_Znam(i64 %21) #7
  %22 = bitcast i8* %call to i32*
  %call14 = tail call noalias nonnull i8* @_Znam(i64 %21) #7
  %23 = bitcast i8* %call14 to i32*
  %call25 = tail call noalias nonnull i8* @_Znam(i64 %21) #7
  %24 = bitcast i8* %call25 to i32*
  br label %for.body.preheader

cond.end29:                                       ; preds = %if.end
  %arraydecay = getelementptr inbounds [1005 x i32], [1005 x i32]* %grouplist_std, i64 0, i64 0
  %arraydecay11 = getelementptr inbounds [1005 x i32], [1005 x i32]* %fixglist_std, i64 0, i64 0
  %arraydecay22 = getelementptr inbounds [1005 x i32], [1005 x i32]* %goodglist_std, i64 0, i64 0
  %cmp312631 = icmp sgt i32 %14, 0
  br i1 %cmp312631, label %for.body.preheader, label %if.end52.thread

for.body.preheader:                               ; preds = %cond.end29.thread, %cond.end29
  %cond302731 = phi i32* [ %24, %cond.end29.thread ], [ %arraydecay22, %cond.end29 ]
  %cond238423882729 = phi i32* [ %22, %cond.end29.thread ], [ %arraydecay, %cond.end29 ]
  %cond1923902727 = phi i32* [ %23, %cond.end29.thread ], [ %arraydecay11, %cond.end29 ]
  %wide.trip.count2719 = zext i32 %14 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %indvars.iv2717 = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next2718, %for.inc ]
  %g.02632 = phi i32 [ 0, %for.body.preheader ], [ %g.1, %for.inc ]
  %hydrogenGroupSize = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %indvars.iv2717, i32 2
  %bf.load = load i32, i32* %hydrogenGroupSize, align 4
  %25 = and i32 %bf.load, 62914560
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %for.inc, label %if.then40

if.then40:                                        ; preds = %for.body
  %inc = add nsw i32 %g.02632, 1
  %idxprom41 = sext i32 %g.02632 to i64
  %arrayidx42 = getelementptr inbounds i32, i32* %cond238423882729, i64 %idxprom41
  %27 = trunc i64 %indvars.iv2717 to i32
  store i32 %27, i32* %arrayidx42, align 4, !tbaa !4
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then40
  %g.1 = phi i32 [ %inc, %if.then40 ], [ %g.02632, %for.body ]
  %indvars.iv.next2718 = add nuw nsw i64 %indvars.iv2717, 1
  %exitcond2720.not = icmp eq i64 %indvars.iv.next2718, %wide.trip.count2719
  br i1 %exitcond2720.not, label %for.end, label %for.body, !llvm.loop !52

for.end:                                          ; preds = %for.inc
  %tobool45.not = icmp eq i32 %g.1, 0
  br i1 %tobool45.not, label %if.end52, label %if.then46

if.then46:                                        ; preds = %for.end
  %sub47 = add nsw i32 %g.1, -1
  %idxprom48 = sext i32 %sub47 to i64
  %arrayidx49 = getelementptr inbounds i32, i32* %cond238423882729, i64 %idxprom48
  %28 = load i32, i32* %arrayidx49, align 4, !tbaa !4
  %idxprom50 = sext i32 %g.1 to i64
  %arrayidx51 = getelementptr inbounds i32, i32* %cond238423882729, i64 %idxprom50
  store i32 %28, i32* %arrayidx51, align 4, !tbaa !4
  br label %if.end52

if.end52:                                         ; preds = %if.then46, %for.end
  %29 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool53.not = icmp eq i32 %29, 0
  br i1 %tobool53.not, label %if.end103, label %for.cond55.preheader

if.end52.thread:                                  ; preds = %cond.end29
  %30 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool53.not2745 = icmp eq i32 %30, 0
  br i1 %tobool53.not2745, label %if.end103, label %cleanup1307

for.cond55.preheader:                             ; preds = %if.end52
  %cmp562625 = icmp sgt i32 %g.1, 0
  br i1 %cmp562625, label %for.body57.preheader, label %if.then75

for.body57.preheader:                             ; preds = %for.cond55.preheader
  %wide.trip.count2715 = zext i32 %g.1 to i64
  br label %for.body57

for.body57:                                       ; preds = %for.body57.preheader, %for.inc71
  %indvars.iv2713 = phi i64 [ 0, %for.body57.preheader ], [ %indvars.iv.next2714, %for.inc71 ]
  %fixg.02627 = phi i32 [ 0, %for.body57.preheader ], [ %fixg.1, %for.inc71 ]
  %all_fixed.02626 = phi i32 [ 1, %for.body57.preheader ], [ %all_fixed.1, %for.inc71 ]
  %arrayidx59 = getelementptr inbounds i32, i32* %cond238423882729, i64 %indvars.iv2713
  %31 = load i32, i32* %arrayidx59, align 4, !tbaa !4
  %idxprom60 = sext i32 %31 to i64
  %groupFixed = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom60, i32 2
  %bf.load62 = load i32, i32* %groupFixed, align 4
  %32 = and i32 %bf.load62, 134217728
  %tobool65.not = icmp eq i32 %32, 0
  br i1 %tobool65.not, label %if.then66, label %for.inc71

if.then66:                                        ; preds = %for.body57
  %inc67 = add nsw i32 %fixg.02627, 1
  %idxprom68 = sext i32 %fixg.02627 to i64
  %arrayidx69 = getelementptr inbounds i32, i32* %cond1923902727, i64 %idxprom68
  store i32 %31, i32* %arrayidx69, align 4, !tbaa !4
  br label %for.inc71

for.inc71:                                        ; preds = %for.body57, %if.then66
  %all_fixed.1 = phi i32 [ %all_fixed.02626, %for.body57 ], [ 0, %if.then66 ]
  %fixg.1 = phi i32 [ %fixg.02627, %for.body57 ], [ %inc67, %if.then66 ]
  %indvars.iv.next2714 = add nuw nsw i64 %indvars.iv2713, 1
  %exitcond2716.not = icmp eq i64 %indvars.iv.next2714, %wide.trip.count2715
  br i1 %exitcond2716.not, label %for.end73, label %for.body57, !llvm.loop !53

for.end73:                                        ; preds = %for.inc71
  %tobool74.not = icmp eq i32 %all_fixed.1, 0
  br i1 %tobool74.not, label %if.end95, label %if.then75

if.then75:                                        ; preds = %for.cond55.preheader, %for.end73
  %arraydecay76 = getelementptr inbounds [1005 x i32], [1005 x i32]* %grouplist_std, i64 0, i64 0
  %cmp77 = icmp eq i32* %cond238423882729, %arraydecay76
  br i1 %cmp77, label %if.end79, label %delete.notnull

delete.notnull:                                   ; preds = %if.then75
  %33 = bitcast i32* %cond238423882729 to i8*
  call void @_ZdaPv(i8* %33) #8
  br label %if.end79

if.end79:                                         ; preds = %delete.notnull, %if.then75
  %arraydecay80 = getelementptr inbounds [1005 x i32], [1005 x i32]* %fixglist_std, i64 0, i64 0
  %cmp81 = icmp eq i32* %cond1923902727, %arraydecay80
  br i1 %cmp81, label %if.end86, label %delete.notnull84

delete.notnull84:                                 ; preds = %if.end79
  %34 = bitcast i32* %cond1923902727 to i8*
  call void @_ZdaPv(i8* %34) #8
  br label %if.end86

if.end86:                                         ; preds = %delete.notnull84, %if.end79
  %arraydecay87 = getelementptr inbounds [1005 x i32], [1005 x i32]* %goodglist_std, i64 0, i64 0
  %cmp88 = icmp eq i32* %cond302731, %arraydecay87
  br i1 %cmp88, label %cleanup1307, label %delete.notnull91

delete.notnull91:                                 ; preds = %if.end86
  %35 = bitcast i32* %cond302731 to i8*
  call void @_ZdaPv(i8* %35) #8
  br label %cleanup1307

if.end95:                                         ; preds = %for.end73
  %tobool96.not = icmp eq i32 %fixg.1, 0
  br i1 %tobool96.not, label %if.end103, label %if.then97

if.then97:                                        ; preds = %if.end95
  %sub98 = add nsw i32 %fixg.1, -1
  %idxprom99 = sext i32 %sub98 to i64
  %arrayidx100 = getelementptr inbounds i32, i32* %cond1923902727, i64 %idxprom99
  %36 = load i32, i32* %arrayidx100, align 4, !tbaa !4
  %idxprom101 = sext i32 %fixg.1 to i64
  %arrayidx102 = getelementptr inbounds i32, i32* %cond1923902727, i64 %idxprom101
  store i32 %36, i32* %arrayidx102, align 4, !tbaa !4
  br label %if.end103

if.end103:                                        ; preds = %if.end52.thread, %if.end52, %if.then97, %if.end95
  %cond30273027372753 = phi i32* [ %cond302731, %if.then97 ], [ %cond302731, %if.end95 ], [ %cond302731, %if.end52 ], [ %arraydecay22, %if.end52.thread ]
  %cond23842388272827382751 = phi i32* [ %cond238423882729, %if.then97 ], [ %cond238423882729, %if.end95 ], [ %cond238423882729, %if.end52 ], [ %arraydecay, %if.end52.thread ]
  %cond192390272627392749 = phi i32* [ %cond1923902727, %if.then97 ], [ %cond1923902727, %if.end95 ], [ %cond1923902727, %if.end52 ], [ %arraydecay11, %if.end52.thread ]
  %g.0.lcssa27402747 = phi i32 [ %g.1, %if.then97 ], [ %g.1, %if.end95 ], [ %g.1, %if.end52 ], [ 0, %if.end52.thread ]
  %fixg.22394 = phi i32 [ %fixg.1, %if.then97 ], [ 0, %if.end95 ], [ 0, %if.end52 ], [ 0, %if.end52.thread ]
  %37 = bitcast [1005 x i32]* %pairlist_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %37) #6
  %38 = bitcast [1005 x i32]* %pairlist2_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %38) #6
  %39 = bitcast [1005 x i32]* %pairlistn_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %39) #6
  %40 = bitcast [1005 x i32]* %pairlistx_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %40) #6
  %41 = bitcast [1005 x i32]* %pairlistm_std to i8*
  call void @llvm.lifetime.start.p0i8(i64 4020, i8* nonnull %41) #6
  br i1 %cmp, label %cond.true149, label %cond.false151

cond.true149:                                     ; preds = %if.end103
  %arraydecay106 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist_std, i64 0, i64 0
  %arraydecay117 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist2_std, i64 0, i64 0
  %arraydecay128 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistn_std, i64 0, i64 0
  %arraydecay139 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistx_std, i64 0, i64 0
  %arraydecay150 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistm_std, i64 0, i64 0
  br label %cond.end157

cond.false151:                                    ; preds = %if.end103
  %add108 = add nuw nsw i32 %14, 5
  %42 = zext i32 %add108 to i64
  %43 = shl nuw nsw i64 %42, 2
  %call109 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %44 = bitcast i8* %call109 to i32*
  %call120 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %45 = bitcast i8* %call120 to i32*
  %call131 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %46 = bitcast i8* %call131 to i32*
  %call142 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %47 = bitcast i8* %call142 to i32*
  %call153 = tail call noalias nonnull i8* @_Znam(i64 %43) #7
  %48 = bitcast i8* %call153 to i32*
  br label %cond.end157

cond.end157:                                      ; preds = %cond.false151, %cond.true149
  %cond1472423 = phi i32* [ %arraydecay139, %cond.true149 ], [ %47, %cond.false151 ]
  %cond125240224072421 = phi i32* [ %arraydecay117, %cond.true149 ], [ %45, %cond.false151 ]
  %cond1142396240024092419 = phi i32* [ %arraydecay106, %cond.true149 ], [ %44, %cond.false151 ]
  %cond13624112417 = phi i32* [ %arraydecay128, %cond.true149 ], [ %46, %cond.false151 ]
  %cond158 = phi i32* [ %arraydecay150, %cond.true149 ], [ %48, %cond.false151 ]
  %arrayidx159 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 1, i64 0
  %49 = load %class.Vector*, %class.Vector** %arrayidx159, align 8, !tbaa !14
  %arrayidx161 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 1, i64 1
  %50 = load %class.Vector*, %class.Vector** %arrayidx161, align 8, !tbaa !14
  %arrayidx162 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 2, i64 0
  %51 = load %class.Vector*, %class.Vector** %arrayidx162, align 8, !tbaa !14
  %arrayidx164 = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 2, i64 1
  %52 = load %class.Vector*, %class.Vector** %arrayidx164, align 8, !tbaa !14
  %sub165 = add nsw i32 %13, -1
  %mul166 = mul nsw i32 %sub165, %14
  %div = sdiv i32 %mul166, 2
  %minPart = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 8
  %53 = load i32, i32* %minPart, align 4, !tbaa !18
  %mul167 = mul nsw i32 %53, %div
  %numParts = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 10
  %54 = load i32, i32* %numParts, align 4, !tbaa !19
  %div168 = sdiv i32 %mul167, %54
  %maxPart = getelementptr inbounds %struct.nonbonded, %struct.nonbonded* %params, i64 0, i32 9
  %55 = load i32, i32* %maxPart, align 8, !tbaa !20
  %mul169 = mul nsw i32 %55, %div
  %div171 = sdiv i32 %mul169, %54
  %sub.ptr.rhs.cast = ptrtoint i32* %cond30273027372753 to i64
  %sub.ptr.rhs.cast375 = ptrtoint i32* %cond1142396240024092419 to i64
  %sub.ptr.rhs.cast556 = ptrtoint i32* %cond125240224072421 to i64
  %sub.ptr.rhs.cast618 = ptrtoint i32* %cond1472423 to i64
  %sub.ptr.rhs.cast625 = ptrtoint i32* %cond158 to i64
  %56 = fneg double %9
  %sub941 = fsub double 1.000000e+00, %sub
  %neg1008 = fneg double %sub
  %cmp1742584 = icmp sgt i32 %13, 1
  br i1 %cmp1742584, label %for.body175.preheader, label %for.end1205

for.body175.preheader:                            ; preds = %cond.end157
  %57 = sext i32 %g.0.lcssa27402747 to i64
  %58 = sext i32 %fixg.22394 to i64
  br label %for.body175

for.body175:                                      ; preds = %for.body175.preheader, %cleanup1191
  %exclChecksum.02608 = phi i32 [ %exclChecksum.11, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %vdwEnergy.02607 = phi double [ %vdwEnergy.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %electEnergy.02606 = phi double [ %electEnergy.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_xx.02605 = phi double [ %virial_xx.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_xy.02604 = phi double [ %virial_xy.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_xz.02603 = phi double [ %virial_xz.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_yy.02602 = phi double [ %virial_yy.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_yz.02601 = phi double [ %virial_yz.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %virial_zz.02600 = phi double [ %virial_zz.3, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectEnergy.02599 = phi double [ %fullElectEnergy.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_xx.02598 = phi double [ %fullElectVirial_xx.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_xy.02597 = phi double [ %fullElectVirial_xy.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_xz.02596 = phi double [ %fullElectVirial_xz.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_yy.02595 = phi double [ %fullElectVirial_yy.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_yz.02594 = phi double [ %fullElectVirial_yz.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %fullElectVirial_zz.02593 = phi double [ %fullElectVirial_zz.4, %cleanup1191 ], [ 0.000000e+00, %for.body175.preheader ]
  %i.02591 = phi i32 [ %inc1204, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %j_hgroup.02590 = phi i32 [ %j_hgroup.3, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %g_lower.02589 = phi i32 [ %g_lower.4, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %fixg_lower.02588 = phi i32 [ %fixg_lower.4, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %pairlistindex.02587 = phi i32 [ %pairlistindex.3, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %pairlistoffset.02586 = phi i32 [ %pairlistoffset.2, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %pairCount.02585 = phi i32 [ %pairCount.3, %cleanup1191 ], [ 0, %for.body175.preheader ]
  %idxprom176 = sext i32 %i.02591 to i64
  %id = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 2
  %bf.load178 = load i32, i32* %id, align 4
  %bf.clear179 = and i32 %bf.load178, 4194303
  %call180 = call %class.ExclusionCheck* @_ZNK8Molecule23get_excl_check_for_atomEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear179) #9
  %min = getelementptr inbounds %class.ExclusionCheck, %class.ExclusionCheck* %call180, i64 0, i32 0
  %59 = load i32, i32* %min, align 8, !tbaa !21
  %max = getelementptr inbounds %class.ExclusionCheck, %class.ExclusionCheck* %call180, i64 0, i32 1
  %60 = load i32, i32* %max, align 4, !tbaa !23
  %flags = getelementptr inbounds %class.ExclusionCheck, %class.ExclusionCheck* %call180, i64 0, i32 2
  %61 = load i8*, i8** %flags, align 8, !tbaa !24
  %idx.ext = sext i32 %59 to i64
  %x = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 0, i32 0
  %62 = load double, double* %x, align 8, !tbaa !25
  %y = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 0, i32 1
  %63 = load double, double* %y, align 8, !tbaa !28
  %z = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 0, i32 2
  %64 = load double, double* %z, align 8, !tbaa !29
  %bf.load188 = load i32, i32* %id, align 4
  %65 = and i32 %bf.load188, 62914560
  %66 = icmp eq i32 %65, 0
  br i1 %66, label %if.else, label %if.then198

if.then198:                                       ; preds = %for.body175
  %bf.lshr201 = lshr i32 %bf.load188, 22
  %bf.clear202 = and i32 %bf.lshr201, 7
  %tobool203.not = icmp eq i32 %bf.clear202, 0
  br i1 %tobool203.not, label %if.end228.thread, label %if.then204

if.end228.thread:                                 ; preds = %if.then198
  %67 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool229.not2774 = icmp ne i32 %67, 0
  %68 = and i32 %bf.load188, 134217728
  %tobool2342775 = icmp ne i32 %68, 0
  %69 = select i1 %tobool229.not2774, i1 %tobool2342775, i1 false
  br label %if.end263

if.then204:                                       ; preds = %if.then198
  %sub210 = sub nsw i32 %sub165, %i.02591
  %mul211 = mul nsw i32 %bf.clear202, %sub210
  %add212 = add nsw i32 %mul211, %pairCount.02585
  %sub213 = add nsw i32 %bf.clear202, -1
  %mul214 = mul nuw nsw i32 %sub213, %bf.clear202
  %div215.neg24252426 = lshr i32 %mul214, 1
  %sub216 = sub i32 %add212, %div215.neg24252426
  %cmp217 = icmp sge i32 %pairCount.02585, %div168
  %cmp219.not = icmp slt i32 %pairCount.02585, %div171
  %or.cond2378 = select i1 %cmp217, i1 %cmp219.not, i1 false
  %add222 = add nsw i32 %sub213, %i.02591
  br i1 %or.cond2378, label %if.then240, label %cleanup1191

if.then240:                                       ; preds = %if.then204
  %70 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool229.not = icmp ne i32 %70, 0
  %71 = and i32 %bf.load188, 134217728
  %tobool234 = icmp ne i32 %71, 0
  %72 = select i1 %tobool229.not, i1 %tobool234, i1 false
  %add245 = add nsw i32 %bf.clear202, %i.02591
  %cmp2462428 = icmp slt i32 %g_lower.02589, %g.0.lcssa27402747
  br i1 %cmp2462428, label %land.rhs247.preheader, label %while.end

land.rhs247.preheader:                            ; preds = %if.then240
  %73 = sext i32 %g_lower.02589 to i64
  br label %land.rhs247

land.rhs247:                                      ; preds = %land.rhs247.preheader, %while.body
  %indvars.iv = phi i64 [ %73, %land.rhs247.preheader ], [ %indvars.iv.next, %while.body ]
  %arrayidx249 = getelementptr inbounds i32, i32* %cond23842388272827382751, i64 %indvars.iv
  %74 = load i32, i32* %arrayidx249, align 4, !tbaa !4
  %cmp250 = icmp slt i32 %74, %add245
  br i1 %cmp250, label %while.body, label %while.end.loopexit.split.loop.exit2839

while.body:                                       ; preds = %land.rhs247
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %57
  br i1 %exitcond.not, label %while.end, label %land.rhs247, !llvm.loop !54

while.end.loopexit.split.loop.exit2839:           ; preds = %land.rhs247
  %75 = trunc i64 %indvars.iv to i32
  br label %while.end

while.end:                                        ; preds = %while.body, %while.end.loopexit.split.loop.exit2839, %if.then240
  %g_lower.1.lcssa = phi i32 [ %g_lower.02589, %if.then240 ], [ %75, %while.end.loopexit.split.loop.exit2839 ], [ %g.0.lcssa27402747, %while.body ]
  %cmp2542431 = icmp slt i32 %fixg_lower.02588, %fixg.22394
  br i1 %cmp2542431, label %land.rhs255.preheader, label %if.end263

land.rhs255.preheader:                            ; preds = %while.end
  %76 = sext i32 %fixg_lower.02588 to i64
  br label %land.rhs255

land.rhs255:                                      ; preds = %land.rhs255.preheader, %while.body260
  %indvars.iv2673 = phi i64 [ %76, %land.rhs255.preheader ], [ %indvars.iv.next2674, %while.body260 ]
  %arrayidx257 = getelementptr inbounds i32, i32* %cond192390272627392749, i64 %indvars.iv2673
  %77 = load i32, i32* %arrayidx257, align 4, !tbaa !4
  %cmp258 = icmp slt i32 %77, %add245
  br i1 %cmp258, label %while.body260, label %if.end263.loopexit.split.loop.exit

while.body260:                                    ; preds = %land.rhs255
  %indvars.iv.next2674 = add nsw i64 %indvars.iv2673, 1
  %exitcond2675.not = icmp eq i64 %indvars.iv.next2674, %58
  br i1 %exitcond2675.not, label %if.end263, label %land.rhs255, !llvm.loop !55

if.end263.loopexit.split.loop.exit:               ; preds = %land.rhs255
  %78 = trunc i64 %indvars.iv2673 to i32
  br label %if.end263

if.end263:                                        ; preds = %while.body260, %if.end263.loopexit.split.loop.exit, %if.end228.thread, %while.end
  %79 = phi i1 [ %72, %while.end ], [ %69, %if.end228.thread ], [ %72, %if.end263.loopexit.split.loop.exit ], [ %72, %while.body260 ]
  %pairCount.12776 = phi i32 [ %sub216, %while.end ], [ %pairCount.02585, %if.end228.thread ], [ %sub216, %if.end263.loopexit.split.loop.exit ], [ %sub216, %while.body260 ]
  %fixg_lower.2 = phi i32 [ %fixg_lower.02588, %while.end ], [ %fixg_lower.02588, %if.end228.thread ], [ %78, %if.end263.loopexit.split.loop.exit ], [ %fixg.22394, %while.body260 ]
  %g_lower.2 = phi i32 [ %g_lower.1.lcssa, %while.end ], [ %g_lower.02589, %if.end228.thread ], [ %g_lower.1.lcssa, %if.end263.loopexit.split.loop.exit ], [ %g_lower.1.lcssa, %while.body260 ]
  %j_hgroup.1 = phi i32 [ %add245, %while.end ], [ %j_hgroup.02590, %if.end228.thread ], [ %add245, %if.end263.loopexit.split.loop.exit ], [ %add245, %while.body260 ]
  %j.12435 = add nsw i32 %i.02591, 1
  %cmp2662436 = icmp slt i32 %j.12435, %j_hgroup.1
  br i1 %cmp2662436, label %for.body267.preheader, label %for.end273

for.body267.preheader:                            ; preds = %if.end263
  %80 = xor i32 %i.02591, -1
  %81 = add i32 %j_hgroup.1, %80
  %wide.trip.count = zext i32 %81 to i64
  br label %for.body267

for.body267:                                      ; preds = %for.body267.preheader, %for.body267
  %indvars.iv2676 = phi i64 [ 0, %for.body267.preheader ], [ %indvars.iv.next2677, %for.body267 ]
  %j.12438 = phi i32 [ %j.12435, %for.body267.preheader ], [ %j.1, %for.body267 ]
  %indvars.iv.next2677 = add nuw nsw i64 %indvars.iv2676, 1
  %arrayidx270 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %indvars.iv2676
  store i32 %j.12438, i32* %arrayidx270, align 4, !tbaa !4
  %j.1 = add nsw i32 %j.12438, 1
  %exitcond2678.not = icmp eq i64 %indvars.iv.next2677, %wide.trip.count
  br i1 %exitcond2678.not, label %for.end273, label %for.body267, !llvm.loop !56

for.end273:                                       ; preds = %for.body267, %if.end263
  %pairlistindex.1.lcssa = phi i32 [ 0, %if.end263 ], [ %81, %for.body267 ]
  %idx.ext274 = zext i32 %pairlistindex.1.lcssa to i64
  %add.ptr275 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %idx.ext274
  %cond280 = select i1 %79, i32* %cond192390272627392749, i32* %cond23842388272827382751
  %cond285 = select i1 %79, i32 %fixg_lower.2, i32 %g_lower.2
  %cond290 = select i1 %79, i32 %fixg.22394, i32 %g.0.lcssa27402747
  %cmp291 = icmp slt i32 %cond285, %cond290
  br i1 %cmp291, label %if.then292, label %if.end373

if.then292:                                       ; preds = %for.end273
  %idxprom293 = sext i32 %cond285 to i64
  %arrayidx294 = getelementptr inbounds i32, i32* %cond280, i64 %idxprom293
  %82 = load i32, i32* %arrayidx294, align 4, !tbaa !4
  %idxprom295 = sext i32 %82 to i64
  %x298 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom295, i32 0, i32 0
  %83 = load double, double* %x298, align 8, !tbaa !25
  %y302 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom295, i32 0, i32 1
  %84 = load double, double* %y302, align 8, !tbaa !28
  %z306 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom295, i32 0, i32 2
  %85 = load double, double* %z306, align 8, !tbaa !29
  %wide.trip.count2681 = sext i32 %cond290 to i64
  br label %while.body309

while.body309:                                    ; preds = %if.then292, %if.end333
  %indvars.iv2679 = phi i64 [ %idxprom293, %if.then292 ], [ %indvars.iv.next2680, %if.end333 ]
  %gli.02445 = phi i32* [ %cond30273027372753, %if.then292 ], [ %gli.1, %if.end333 ]
  %j2.02444 = phi i32 [ %82, %if.then292 ], [ %86, %if.end333 ]
  %p_j_x.02443 = phi double [ %83, %if.then292 ], [ %87, %if.end333 ]
  %p_j_y.02442 = phi double [ %84, %if.then292 ], [ %89, %if.end333 ]
  %p_j_z.02441 = phi double [ %85, %if.then292 ], [ %91, %if.end333 ]
  %indvars.iv.next2680 = add nsw i64 %indvars.iv2679, 1
  %arrayidx312 = getelementptr inbounds i32, i32* %cond280, i64 %indvars.iv.next2680
  %86 = load i32, i32* %arrayidx312, align 4, !tbaa !4
  %sub313 = fsub double %62, %p_j_x.02443
  %mul314 = fmul double %sub313, %sub313
  %idxprom315 = sext i32 %86 to i64
  %x318 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom315, i32 0, i32 0
  %87 = load double, double* %x318, align 8, !tbaa !25
  %sub319 = fsub double %63, %p_j_y.02442
  %88 = call double @llvm.fmuladd.f64(double %sub319, double %sub319, double %mul314)
  %y324 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom315, i32 0, i32 1
  %89 = load double, double* %y324, align 8, !tbaa !28
  %sub325 = fsub double %64, %p_j_z.02441
  %90 = call double @llvm.fmuladd.f64(double %sub325, double %sub325, double %88)
  %z330 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom315, i32 0, i32 2
  %91 = load double, double* %z330, align 8, !tbaa !29
  %cmp331 = fcmp ugt double %90, %3
  br i1 %cmp331, label %if.end333, label %if.then332

if.then332:                                       ; preds = %while.body309
  store i32 %j2.02444, i32* %gli.02445, align 4, !tbaa !4
  %incdec.ptr = getelementptr inbounds i32, i32* %gli.02445, i64 1
  br label %if.end333

if.end333:                                        ; preds = %if.then332, %while.body309
  %gli.1 = phi i32* [ %incdec.ptr, %if.then332 ], [ %gli.02445, %while.body309 ]
  %exitcond2682.not = icmp eq i64 %indvars.iv.next2680, %wide.trip.count2681
  br i1 %exitcond2682.not, label %while.end334, label %while.body309, !llvm.loop !57

while.end334:                                     ; preds = %if.end333
  %sub.ptr.lhs.cast = ptrtoint i32* %gli.1 to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %92 = lshr exact i64 %sub.ptr.sub, 2
  %conv335 = trunc i64 %92 to i32
  %cmp3372448 = icmp sgt i32 %conv335, 0
  br i1 %cmp3372448, label %for.body338.preheader, label %if.end373

for.body338.preheader:                            ; preds = %while.end334
  %wide.trip.count2685 = and i64 %92, 4294967295
  br label %for.body338

for.body338:                                      ; preds = %for.body338.preheader, %for.body338
  %indvars.iv2683 = phi i64 [ 0, %for.body338.preheader ], [ %indvars.iv.next2684, %for.body338 ]
  %pli.02450 = phi i32* [ %add.ptr275, %for.body338.preheader ], [ %add.ptr368, %for.body338 ]
  %arrayidx341 = getelementptr inbounds i32, i32* %cond30273027372753, i64 %indvars.iv2683
  %93 = load i32, i32* %arrayidx341, align 4, !tbaa !4
  %idxprom343 = sext i32 %93 to i64
  %nonbondedGroupIsAtom345 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom343, i32 2
  %bf.load346 = load i32, i32* %nonbondedGroupIsAtom345, align 4
  %94 = and i32 %bf.load346, 33554432
  %tobool349.not = icmp eq i32 %94, 0
  %bf.lshr356 = lshr i32 %bf.load346, 22
  %bf.clear357 = and i32 %bf.lshr356, 7
  %cond359 = select i1 %tobool349.not, i32 %bf.clear357, i32 1
  store i32 %93, i32* %pli.02450, align 4, !tbaa !4
  %add361 = add nsw i32 %93, 1
  %arrayidx362 = getelementptr inbounds i32, i32* %pli.02450, i64 1
  store i32 %add361, i32* %arrayidx362, align 4, !tbaa !4
  %add363 = add nsw i32 %93, 2
  %arrayidx364 = getelementptr inbounds i32, i32* %pli.02450, i64 2
  store i32 %add363, i32* %arrayidx364, align 4, !tbaa !4
  %add365 = add nsw i32 %93, 3
  %arrayidx366 = getelementptr inbounds i32, i32* %pli.02450, i64 3
  store i32 %add365, i32* %arrayidx366, align 4, !tbaa !4
  %95 = zext i32 %cond359 to i64
  %add.ptr368 = getelementptr inbounds i32, i32* %pli.02450, i64 %95
  %indvars.iv.next2684 = add nuw nsw i64 %indvars.iv2683, 1
  %exitcond2686.not = icmp eq i64 %indvars.iv.next2684, %wide.trip.count2685
  br i1 %exitcond2686.not, label %if.end373, label %for.body338, !llvm.loop !58

if.end373:                                        ; preds = %for.body338, %while.end334, %for.end273
  %pli.1 = phi i32* [ %add.ptr275, %for.end273 ], [ %add.ptr275, %while.end334 ], [ %add.ptr368, %for.body338 ]
  %sub.ptr.lhs.cast374 = ptrtoint i32* %pli.1 to i64
  %sub.ptr.sub376 = sub i64 %sub.ptr.lhs.cast374, %sub.ptr.rhs.cast375
  %96 = lshr exact i64 %sub.ptr.sub376, 2
  %conv378 = trunc i64 %96 to i32
  %tobool379.not = icmp eq i32 %conv378, 0
  br i1 %tobool379.not, label %if.end388, label %if.then380

if.then380:                                       ; preds = %if.end373
  %sub381 = shl i64 %sub.ptr.sub376, 30
  %sext2375 = add i64 %sub381, -4294967296
  %idxprom382 = ashr i64 %sext2375, 32
  %arrayidx383 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %idxprom382
  %97 = load i32, i32* %arrayidx383, align 4, !tbaa !4
  %idxprom384 = ashr i64 %sub381, 32
  %arrayidx385 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %idxprom384
  store i32 %97, i32* %arrayidx385, align 4, !tbaa !4
  br label %if.end388

if.else:                                          ; preds = %for.body175
  %inc387 = add nsw i32 %pairlistoffset.02586, 1
  br label %if.end388

if.end388:                                        ; preds = %if.end373, %if.then380, %if.else
  %pairCount.2 = phi i32 [ %pairCount.02585, %if.else ], [ %pairCount.12776, %if.then380 ], [ %pairCount.12776, %if.end373 ]
  %pairlistoffset.1 = phi i32 [ %inc387, %if.else ], [ 0, %if.then380 ], [ 0, %if.end373 ]
  %pairlistindex.2 = phi i32 [ %pairlistindex.02587, %if.else ], [ %conv378, %if.then380 ], [ 0, %if.end373 ]
  %fixg_lower.3 = phi i32 [ %fixg_lower.02588, %if.else ], [ %fixg_lower.2, %if.then380 ], [ %fixg_lower.2, %if.end373 ]
  %g_lower.3 = phi i32 [ %g_lower.02589, %if.else ], [ %g_lower.2, %if.then380 ], [ %g_lower.2, %if.end373 ]
  %j_hgroup.2 = phi i32 [ %j_hgroup.02590, %if.else ], [ %j_hgroup.1, %if.then380 ], [ %j_hgroup.1, %if.end373 ]
  %98 = load i32, i32* @_ZN20ComputeNonbondedUtil12fixedAtomsOnE, align 4, !tbaa !4
  %tobool389.not = icmp ne i32 %98, 0
  %bf.load398.pre = load i32, i32* %id, align 4
  %99 = and i32 %bf.load398.pre, 67108864
  %tobool394 = icmp ne i32 %99, 0
  %100 = select i1 %tobool389.not, i1 %tobool394, i1 false
  %101 = load double*, double** @_ZN20ComputeNonbondedUtil12lambda_tableE, align 8, !tbaa !14
  %102 = load i32, i32* @_ZN20ComputeNonbondedUtil9lesFactorE, align 4, !tbaa !4
  %add397 = add nsw i32 %102, 1
  %bf.lshr399 = lshr i32 %bf.load398.pre, 28
  %mul400 = mul nsw i32 %bf.lshr399, %add397
  %idx.ext401 = sext i32 %mul400 to i64
  %add.ptr402 = getelementptr inbounds double, double* %101, i64 %idx.ext401
  %charge = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %15, i64 %idxprom176, i32 1
  %103 = load float, float* %charge, align 8, !tbaa !35
  %conv403 = fpext float %103 to double
  %mul404 = fmul double %conv403, 0x4074C104816F0069
  %mul405 = fmul double %9, %mul404
  %mul406 = fmul double %4, %mul405
  %bf.clear409 = and i32 %bf.load398.pre, 4194303
  %call410 = call zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear409) #9
  %conv411 = zext i16 %call410 to i32
  %call412 = call %"struct.LJTable::TableEntry"* @_ZNK7LJTable9table_rowEj(%class.LJTable* nonnull align 8 dereferenceable(20) %5, i32 %conv411) #9
  %cmp4172468 = icmp slt i32 %pairlistoffset.1, %pairlistindex.2
  br i1 %100, label %for.cond416.preheader, label %if.else477

for.cond416.preheader:                            ; preds = %if.end388
  br i1 %cmp4172468, label %for.body419.preheader, label %if.end554

for.body419.preheader:                            ; preds = %for.cond416.preheader
  %104 = sext i32 %pairlistoffset.1 to i64
  %wide.trip.count2693 = sext i32 %pairlistindex.2 to i64
  br label %for.body419

for.body419:                                      ; preds = %for.body419.preheader, %if.end472
  %indvars.iv2691 = phi i64 [ %104, %for.body419.preheader ], [ %indvars.iv.next2692, %if.end472 ]
  %exclChecksum.12472 = phi i32 [ %exclChecksum.02608, %for.body419.preheader ], [ %exclChecksum.3, %if.end472 ]
  %pli413.02471 = phi i32* [ %cond125240224072421, %for.body419.preheader ], [ %pli413.2, %if.end472 ]
  %plin.02470 = phi i32* [ %cond13624112417, %for.body419.preheader ], [ %plin.2, %if.end472 ]
  %arrayidx421 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %indvars.iv2691
  %105 = load i32, i32* %arrayidx421, align 4, !tbaa !4
  %idxprom423 = sext i32 %105 to i64
  %x426 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom423, i32 0, i32 0
  %106 = load double, double* %x426, align 8, !tbaa !25
  %sub428 = fsub double %62, %106
  %mul429 = fmul double %sub428, %sub428
  %y434 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom423, i32 0, i32 1
  %107 = load double, double* %y434, align 8, !tbaa !28
  %sub436 = fsub double %63, %107
  %108 = call double @llvm.fmuladd.f64(double %sub436, double %sub436, double %mul429)
  %z442 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom423, i32 0, i32 2
  %109 = load double, double* %z442, align 8, !tbaa !29
  %sub443 = fsub double %64, %109
  %110 = call double @llvm.fmuladd.f64(double %sub443, double %sub443, double %108)
  %atomFixed447 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom423, i32 2
  %bf.load448 = load i32, i32* %atomFixed447, align 4
  %111 = and i32 %bf.load448, 67108864
  %tobool451.not = icmp ne i32 %111, 0
  %cmp452 = fcmp ugt double %110, %2
  %or.cond2379 = select i1 %tobool451.not, i1 true, i1 %cmp452
  br i1 %or.cond2379, label %if.end472, label %land.lhs.true453

land.lhs.true453:                                 ; preds = %for.body419
  %cmp454 = fcmp ugt double %110, %11
  br i1 %cmp454, label %if.then458, label %land.lhs.true455

land.lhs.true455:                                 ; preds = %land.lhs.true453
  %inc456 = add nsw i32 %exclChecksum.12472, 1
  %tobool457.not = icmp eq i32 %inc456, 0
  br i1 %tobool457.not, label %if.then458, label %if.end472

if.then458:                                       ; preds = %land.lhs.true455, %land.lhs.true453
  %exclChecksum.2 = phi i32 [ 0, %land.lhs.true455 ], [ %exclChecksum.12472, %land.lhs.true453 ]
  %bf.clear463 = and i32 %bf.load448, 4194303
  %cmp464.not = icmp slt i32 %bf.clear463, %59
  %cmp466.not = icmp sgt i32 %bf.clear463, %60
  %or.cond2380 = select i1 %cmp464.not, i1 true, i1 %cmp466.not
  %pli413.02471.sink = select i1 %or.cond2380, i32* %plin.02470, i32* %pli413.02471
  %plin.2.ph.idx = zext i1 %or.cond2380 to i64
  %plin.2.ph = getelementptr i32, i32* %plin.02470, i64 %plin.2.ph.idx
  %not.or.cond2380 = xor i1 %or.cond2380, true
  %pli413.2.ph.idx = zext i1 %not.or.cond2380 to i64
  %pli413.2.ph = getelementptr i32, i32* %pli413.02471, i64 %pli413.2.ph.idx
  store i32 %105, i32* %pli413.02471.sink, align 4, !tbaa !4
  br label %if.end472

if.end472:                                        ; preds = %if.then458, %land.lhs.true455, %for.body419
  %plin.2 = phi i32* [ %plin.02470, %for.body419 ], [ %plin.02470, %land.lhs.true455 ], [ %plin.2.ph, %if.then458 ]
  %pli413.2 = phi i32* [ %pli413.02471, %for.body419 ], [ %pli413.02471, %land.lhs.true455 ], [ %pli413.2.ph, %if.then458 ]
  %exclChecksum.3 = phi i32 [ %exclChecksum.12472, %for.body419 ], [ %inc456, %land.lhs.true455 ], [ %exclChecksum.2, %if.then458 ]
  %indvars.iv.next2692 = add nsw i64 %indvars.iv2691, 1
  %exitcond2694.not = icmp eq i64 %indvars.iv.next2692, %wide.trip.count2693
  br i1 %exitcond2694.not, label %if.end554, label %for.body419, !llvm.loop !59

if.else477:                                       ; preds = %if.end388
  br i1 %cmp4172468, label %if.then480, label %if.end554

if.then480:                                       ; preds = %if.else477
  %idxprom482 = sext i32 %pairlistoffset.1 to i64
  %arrayidx483 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %idxprom482
  %112 = load i32, i32* %arrayidx483, align 4, !tbaa !4
  %idxprom485 = sext i32 %112 to i64
  %x488 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom485, i32 0, i32 0
  %113 = load double, double* %x488, align 8, !tbaa !25
  %y493 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom485, i32 0, i32 1
  %114 = load double, double* %y493, align 8, !tbaa !28
  %z498 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom485, i32 0, i32 2
  %115 = load double, double* %z498, align 8, !tbaa !29
  %wide.trip.count2689 = sext i32 %pairlistindex.2 to i64
  br label %while.body507

while.body507:                                    ; preds = %if.then480, %if.end546
  %indvars.iv2687 = phi i64 [ %idxprom482, %if.then480 ], [ %indvars.iv.next2688, %if.end546 ]
  %idxprom485.pn = phi i64 [ %idxprom485, %if.then480 ], [ %idxprom514, %if.end546 ]
  %exclChecksum.42463 = phi i32 [ %exclChecksum.02608, %if.then480 ], [ %exclChecksum.6, %if.end546 ]
  %pli413.32462 = phi i32* [ %cond125240224072421, %if.then480 ], [ %pli413.4, %if.end546 ]
  %plin.32461 = phi i32* [ %cond13624112417, %if.then480 ], [ %plin.4, %if.end546 ]
  %j2481.02459 = phi i32 [ %112, %if.then480 ], [ %116, %if.end546 ]
  %p_j_x484.02458 = phi double [ %113, %if.then480 ], [ %117, %if.end546 ]
  %p_j_y489.02457 = phi double [ %114, %if.then480 ], [ %119, %if.end546 ]
  %p_j_z494.02456 = phi double [ %115, %if.then480 ], [ %121, %if.end546 ]
  %atom2499.02464.in.in = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom485.pn, i32 2
  %atom2499.02464.in = load i32, i32* %atom2499.02464.in.in, align 4
  %atom2499.02464 = and i32 %atom2499.02464.in, 4194303
  %indvars.iv.next2688 = add nsw i64 %indvars.iv2687, 1
  %arrayidx510 = getelementptr inbounds i32, i32* %cond1142396240024092419, i64 %indvars.iv.next2688
  %116 = load i32, i32* %arrayidx510, align 4, !tbaa !4
  %sub512 = fsub double %62, %p_j_x484.02458
  %mul513 = fmul double %sub512, %sub512
  %idxprom514 = sext i32 %116 to i64
  %x517 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom514, i32 0, i32 0
  %117 = load double, double* %x517, align 8, !tbaa !25
  %sub519 = fsub double %63, %p_j_y489.02457
  %118 = call double @llvm.fmuladd.f64(double %sub519, double %sub519, double %mul513)
  %y524 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom514, i32 0, i32 1
  %119 = load double, double* %y524, align 8, !tbaa !28
  %sub525 = fsub double %64, %p_j_z494.02456
  %120 = call double @llvm.fmuladd.f64(double %sub525, double %sub525, double %118)
  %z530 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom514, i32 0, i32 2
  %121 = load double, double* %z530, align 8, !tbaa !29
  %cmp531 = fcmp ugt double %120, %2
  br i1 %cmp531, label %if.end546, label %land.lhs.true532

land.lhs.true532:                                 ; preds = %while.body507
  %cmp533 = fcmp ugt double %120, %11
  br i1 %cmp533, label %if.then537, label %land.lhs.true534

land.lhs.true534:                                 ; preds = %land.lhs.true532
  %inc535 = add nsw i32 %exclChecksum.42463, 1
  %tobool536.not = icmp eq i32 %inc535, 0
  br i1 %tobool536.not, label %if.then537, label %if.end546

if.then537:                                       ; preds = %land.lhs.true534, %land.lhs.true532
  %exclChecksum.5 = phi i32 [ 0, %land.lhs.true534 ], [ %exclChecksum.42463, %land.lhs.true532 ]
  %cmp538.not = icmp slt i32 %atom2499.02464, %59
  %cmp540.not = icmp sgt i32 %atom2499.02464, %60
  %or.cond2381 = select i1 %cmp538.not, i1 true, i1 %cmp540.not
  %pli413.32462.sink = select i1 %or.cond2381, i32* %plin.32461, i32* %pli413.32462
  %plin.4.ph.idx = zext i1 %or.cond2381 to i64
  %plin.4.ph = getelementptr i32, i32* %plin.32461, i64 %plin.4.ph.idx
  %not.or.cond2381 = xor i1 %or.cond2381, true
  %pli413.4.ph.idx = zext i1 %not.or.cond2381 to i64
  %pli413.4.ph = getelementptr i32, i32* %pli413.32462, i64 %pli413.4.ph.idx
  store i32 %j2481.02459, i32* %pli413.32462.sink, align 4, !tbaa !4
  br label %if.end546

if.end546:                                        ; preds = %if.then537, %land.lhs.true534, %while.body507
  %plin.4 = phi i32* [ %plin.32461, %land.lhs.true534 ], [ %plin.32461, %while.body507 ], [ %plin.4.ph, %if.then537 ]
  %pli413.4 = phi i32* [ %pli413.32462, %land.lhs.true534 ], [ %pli413.32462, %while.body507 ], [ %pli413.4.ph, %if.then537 ]
  %exclChecksum.6 = phi i32 [ %inc535, %land.lhs.true534 ], [ %exclChecksum.42463, %while.body507 ], [ %exclChecksum.5, %if.then537 ]
  %exitcond2690.not = icmp eq i64 %indvars.iv.next2688, %wide.trip.count2689
  br i1 %exitcond2690.not, label %if.end554, label %while.body507, !llvm.loop !60

if.end554:                                        ; preds = %if.end546, %if.end472, %for.cond416.preheader, %if.else477
  %plin.6 = phi i32* [ %cond13624112417, %if.else477 ], [ %cond13624112417, %for.cond416.preheader ], [ %plin.2, %if.end472 ], [ %plin.4, %if.end546 ]
  %pli413.6 = phi i32* [ %cond125240224072421, %if.else477 ], [ %cond125240224072421, %for.cond416.preheader ], [ %pli413.2, %if.end472 ], [ %pli413.4, %if.end546 ]
  %exclChecksum.8 = phi i32 [ %exclChecksum.02608, %if.else477 ], [ %exclChecksum.02608, %for.cond416.preheader ], [ %exclChecksum.3, %if.end472 ], [ %exclChecksum.6, %if.end546 ]
  %sub.ptr.lhs.cast555 = ptrtoint i32* %pli413.6 to i64
  %sub.ptr.sub557 = sub i64 %sub.ptr.lhs.cast555, %sub.ptr.rhs.cast556
  %122 = lshr exact i64 %sub.ptr.sub557, 2
  %conv559 = trunc i64 %122 to i32
  %tobool560.not = icmp eq i32 %conv559, 0
  br i1 %tobool560.not, label %if.end567, label %if.then561

if.then561:                                       ; preds = %if.end554
  %sub562 = shl i64 %sub.ptr.sub557, 30
  %sext = add i64 %sub562, -4294967296
  %idxprom563 = ashr i64 %sext, 32
  %arrayidx564 = getelementptr inbounds i32, i32* %cond125240224072421, i64 %idxprom563
  %123 = load i32, i32* %arrayidx564, align 4, !tbaa !4
  %idxprom565 = ashr i64 %sub562, 32
  %arrayidx566 = getelementptr inbounds i32, i32* %cond125240224072421, i64 %idxprom565
  store i32 %123, i32* %arrayidx566, align 4, !tbaa !4
  br label %if.end567

if.end567:                                        ; preds = %if.then561, %if.end554
  %cmp5702476 = icmp ult i32* %cond13624112417, %plin.6
  br i1 %cmp5702476, label %land.rhs571, label %for.end578

land.rhs571:                                      ; preds = %if.end567, %for.body574
  %exclChecksum.92479 = phi i32 [ %dec, %for.body574 ], [ %exclChecksum.8, %if.end567 ]
  %plix.02478 = phi i32* [ %incdec.ptr575, %for.body574 ], [ %cond1472423, %if.end567 ]
  %pln.02477 = phi i32* [ %incdec.ptr577, %for.body574 ], [ %cond13624112417, %if.end567 ]
  %124 = load i32, i32* %pln.02477, align 4, !tbaa !4
  %cmp572 = icmp slt i32 %124, %j_hgroup.2
  br i1 %cmp572, label %for.body574, label %for.end578

for.body574:                                      ; preds = %land.rhs571
  %incdec.ptr575 = getelementptr inbounds i32, i32* %plix.02478, i64 1
  store i32 %124, i32* %plix.02478, align 4, !tbaa !4
  %dec = add nsw i32 %exclChecksum.92479, -1
  %incdec.ptr577 = getelementptr inbounds i32, i32* %pln.02477, i64 1
  %cmp570 = icmp ult i32* %incdec.ptr577, %plin.6
  br i1 %cmp570, label %land.rhs571, label %for.end578, !llvm.loop !61

for.end578:                                       ; preds = %land.rhs571, %for.body574, %if.end567
  %pln.0.lcssa = phi i32* [ %cond13624112417, %if.end567 ], [ %incdec.ptr577, %for.body574 ], [ %pln.02477, %land.rhs571 ]
  %plix.0.lcssa = phi i32* [ %cond1472423, %if.end567 ], [ %incdec.ptr575, %for.body574 ], [ %plix.02478, %land.rhs571 ]
  %exclChecksum.9.lcssa = phi i32 [ %exclChecksum.8, %if.end567 ], [ %dec, %for.body574 ], [ %exclChecksum.92479, %land.rhs571 ]
  %cmp5802486 = icmp sgt i32 %conv559, 0
  br i1 %cmp5802486, label %land.rhs581.preheader, label %for.end593

land.rhs581.preheader:                            ; preds = %for.end578
  %125 = sub i32 %exclChecksum.9.lcssa, %conv559
  %wide.trip.count2697 = and i64 %122, 4294967295
  br label %land.rhs581

land.rhs581:                                      ; preds = %land.rhs581.preheader, %for.body586
  %indvars.iv2695 = phi i64 [ 0, %land.rhs581.preheader ], [ %indvars.iv.next2696, %for.body586 ]
  %exclChecksum.102489 = phi i32 [ %exclChecksum.9.lcssa, %land.rhs581.preheader ], [ %dec590, %for.body586 ]
  %plix.12488 = phi i32* [ %plix.0.lcssa, %land.rhs581.preheader ], [ %incdec.ptr589, %for.body586 ]
  %arrayidx583 = getelementptr inbounds i32, i32* %cond125240224072421, i64 %indvars.iv2695
  %126 = load i32, i32* %arrayidx583, align 4, !tbaa !4
  %cmp584 = icmp slt i32 %126, %j_hgroup.2
  br i1 %cmp584, label %for.body586, label %for.end593.loopexit

for.body586:                                      ; preds = %land.rhs581
  %incdec.ptr589 = getelementptr inbounds i32, i32* %plix.12488, i64 1
  store i32 %126, i32* %plix.12488, align 4, !tbaa !4
  %dec590 = add nsw i32 %exclChecksum.102489, -1
  %indvars.iv.next2696 = add nuw nsw i64 %indvars.iv2695, 1
  %exitcond2698.not = icmp eq i64 %indvars.iv.next2696, %wide.trip.count2697
  br i1 %exitcond2698.not, label %for.end616, label %land.rhs581, !llvm.loop !62

for.end593.loopexit:                              ; preds = %land.rhs581
  %127 = trunc i64 %indvars.iv2695 to i32
  br label %for.end593

for.end593:                                       ; preds = %for.end593.loopexit, %for.end578
  %k568.0.lcssa = phi i32 [ 0, %for.end578 ], [ %127, %for.end593.loopexit ]
  %plix.1.lcssa = phi i32* [ %plix.0.lcssa, %for.end578 ], [ %plix.12488, %for.end593.loopexit ]
  %exclChecksum.10.lcssa = phi i32 [ %exclChecksum.9.lcssa, %for.end578 ], [ %exclChecksum.102489, %for.end593.loopexit ]
  %cmp5952496 = icmp slt i32 %k568.0.lcssa, %conv559
  br i1 %cmp5952496, label %for.body596.preheader, label %for.end616

for.body596.preheader:                            ; preds = %for.end593
  %128 = zext i32 %k568.0.lcssa to i64
  br label %for.body596

for.body596:                                      ; preds = %for.body596.preheader, %sw.epilog
  %indvars.iv2699 = phi i64 [ %128, %for.body596.preheader ], [ %indvars.iv.next2700, %sw.epilog ]
  %plin.72500 = phi i32* [ %plin.6, %for.body596.preheader ], [ %plin.8, %sw.epilog ]
  %plix.22499 = phi i32* [ %plix.1.lcssa, %for.body596.preheader ], [ %plix.3, %sw.epilog ]
  %plim.02498 = phi i32* [ %cond158, %for.body596.preheader ], [ %plim.1, %sw.epilog ]
  %arrayidx599 = getelementptr inbounds i32, i32* %cond125240224072421, i64 %indvars.iv2699
  %129 = load i32, i32* %arrayidx599, align 4, !tbaa !4
  %idxprom601 = sext i32 %129 to i64
  %id603 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idxprom601, i32 2
  %bf.load604 = load i32, i32* %id603, align 4
  %bf.clear605 = and i32 %bf.load604, 4194303
  %130 = zext i32 %bf.clear605 to i64
  %arrayidx607.idx = sub nsw i64 %130, %idx.ext
  %arrayidx607 = getelementptr inbounds i8, i8* %61, i64 %arrayidx607.idx
  %131 = load i8, i8* %arrayidx607, align 1, !tbaa !40
  %conv608 = sext i8 %131 to i32
  switch i32 %conv608, label %sw.epilog [
    i32 0, label %sw.bb
    i32 1, label %sw.bb610
    i32 2, label %sw.bb612
  ]

sw.bb:                                            ; preds = %for.body596
  %incdec.ptr609 = getelementptr inbounds i32, i32* %plin.72500, i64 1
  br label %sw.epilog.sink.split

sw.bb610:                                         ; preds = %for.body596
  %incdec.ptr611 = getelementptr inbounds i32, i32* %plix.22499, i64 1
  br label %sw.epilog.sink.split

sw.bb612:                                         ; preds = %for.body596
  %incdec.ptr613 = getelementptr inbounds i32, i32* %plim.02498, i64 1
  br label %sw.epilog.sink.split

sw.epilog.sink.split:                             ; preds = %sw.bb, %sw.bb610, %sw.bb612
  %plim.02498.sink = phi i32* [ %plim.02498, %sw.bb612 ], [ %plix.22499, %sw.bb610 ], [ %plin.72500, %sw.bb ]
  %plim.1.ph = phi i32* [ %incdec.ptr613, %sw.bb612 ], [ %plim.02498, %sw.bb610 ], [ %plim.02498, %sw.bb ]
  %plix.3.ph = phi i32* [ %plix.22499, %sw.bb612 ], [ %incdec.ptr611, %sw.bb610 ], [ %plix.22499, %sw.bb ]
  %plin.8.ph = phi i32* [ %plin.72500, %sw.bb612 ], [ %plin.72500, %sw.bb610 ], [ %incdec.ptr609, %sw.bb ]
  store i32 %129, i32* %plim.02498.sink, align 4, !tbaa !4
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.epilog.sink.split, %for.body596
  %plim.1 = phi i32* [ %plim.02498, %for.body596 ], [ %plim.1.ph, %sw.epilog.sink.split ]
  %plix.3 = phi i32* [ %plix.22499, %for.body596 ], [ %plix.3.ph, %sw.epilog.sink.split ]
  %plin.8 = phi i32* [ %plin.72500, %for.body596 ], [ %plin.8.ph, %sw.epilog.sink.split ]
  %indvars.iv.next2700 = add nuw nsw i64 %indvars.iv2699, 1
  %132 = trunc i64 %indvars.iv.next2700 to i32
  %cmp595 = icmp slt i32 %132, %conv559
  br i1 %cmp595, label %for.body596, label %for.end616.loopexit, !llvm.loop !63

for.end616.loopexit:                              ; preds = %sw.epilog
  %.pre = ptrtoint i32* %plim.1 to i64
  br label %for.end616

for.end616:                                       ; preds = %for.body586, %for.end616.loopexit, %for.end593
  %exclChecksum.10.lcssa2781 = phi i32 [ %exclChecksum.10.lcssa, %for.end616.loopexit ], [ %exclChecksum.10.lcssa, %for.end593 ], [ %125, %for.body586 ]
  %sub.ptr.lhs.cast624.pre-phi = phi i64 [ %.pre, %for.end616.loopexit ], [ %sub.ptr.rhs.cast625, %for.end593 ], [ %sub.ptr.rhs.cast625, %for.body586 ]
  %plix.2.lcssa = phi i32* [ %plix.3, %for.end616.loopexit ], [ %plix.1.lcssa, %for.end593 ], [ %incdec.ptr589, %for.body586 ]
  %plin.7.lcssa = phi i32* [ %plin.8, %for.end616.loopexit ], [ %plin.6, %for.end593 ], [ %plin.6, %for.body586 ]
  %sub.ptr.lhs.cast617 = ptrtoint i32* %plix.2.lcssa to i64
  %sub.ptr.sub619 = sub i64 %sub.ptr.lhs.cast617, %sub.ptr.rhs.cast618
  %133 = lshr exact i64 %sub.ptr.sub619, 2
  %134 = trunc i64 %133 to i32
  %sub.ptr.sub626 = sub i64 %sub.ptr.lhs.cast624.pre-phi, %sub.ptr.rhs.cast625
  %135 = lshr exact i64 %sub.ptr.sub626, 2
  %136 = trunc i64 %135 to i32
  %conv623 = add i32 %exclChecksum.10.lcssa2781, %136
  %conv630 = add i32 %conv623, %134
  %sub.ptr.lhs.cast631 = ptrtoint i32* %plin.7.lcssa to i64
  %sub.ptr.rhs.cast632 = ptrtoint i32* %pln.0.lcssa to i64
  %sub.ptr.sub633 = sub i64 %sub.ptr.lhs.cast631, %sub.ptr.rhs.cast632
  %137 = lshr exact i64 %sub.ptr.sub633, 2
  %conv635 = trunc i64 %137 to i32
  %x754 = getelementptr inbounds %class.Vector, %class.Vector* %49, i64 %idxprom176, i32 0
  %y761 = getelementptr inbounds %class.Vector, %class.Vector* %49, i64 %idxprom176, i32 1
  %z767 = getelementptr inbounds %class.Vector, %class.Vector* %49, i64 %idxprom176, i32 2
  %x795 = getelementptr inbounds %class.Vector, %class.Vector* %51, i64 %idxprom176, i32 0
  %y803 = getelementptr inbounds %class.Vector, %class.Vector* %51, i64 %idxprom176, i32 1
  %z810 = getelementptr inbounds %class.Vector, %class.Vector* %51, i64 %idxprom176, i32 2
  %cmp6372504 = icmp sgt i32 %conv635, 0
  br i1 %cmp6372504, label %for.body638.preheader, label %for.cond822.preheader

for.body638.preheader:                            ; preds = %for.end616
  %wide.trip.count2703 = and i64 %137, 4294967295
  br label %for.body638

for.cond822.preheader:                            ; preds = %for.body638, %for.end616
  %fullElectVirial_zz.1.lcssa = phi double [ %fullElectVirial_zz.02593, %for.end616 ], [ %208, %for.body638 ]
  %fullElectVirial_yz.1.lcssa = phi double [ %fullElectVirial_yz.02594, %for.end616 ], [ %205, %for.body638 ]
  %fullElectVirial_yy.1.lcssa = phi double [ %fullElectVirial_yy.02595, %for.end616 ], [ %204, %for.body638 ]
  %fullElectVirial_xz.1.lcssa = phi double [ %fullElectVirial_xz.02596, %for.end616 ], [ %201, %for.body638 ]
  %fullElectVirial_xy.1.lcssa = phi double [ %fullElectVirial_xy.02597, %for.end616 ], [ %200, %for.body638 ]
  %fullElectVirial_xx.1.lcssa = phi double [ %fullElectVirial_xx.02598, %for.end616 ], [ %199, %for.body638 ]
  %fullElectEnergy.1.lcssa = phi double [ %fullElectEnergy.02599, %for.end616 ], [ %196, %for.body638 ]
  %virial_zz.1.lcssa = phi double [ %virial_zz.02600, %for.end616 ], [ %187, %for.body638 ]
  %virial_yz.1.lcssa = phi double [ %virial_yz.02601, %for.end616 ], [ %184, %for.body638 ]
  %virial_yy.1.lcssa = phi double [ %virial_yy.02602, %for.end616 ], [ %183, %for.body638 ]
  %virial_xz.1.lcssa = phi double [ %virial_xz.02603, %for.end616 ], [ %180, %for.body638 ]
  %virial_xy.1.lcssa = phi double [ %virial_xy.02604, %for.end616 ], [ %179, %for.body638 ]
  %virial_xx.1.lcssa = phi double [ %virial_xx.02605, %for.end616 ], [ %178, %for.body638 ]
  %electEnergy.1.lcssa = phi double [ %electEnergy.02606, %for.end616 ], [ %175, %for.body638 ]
  %vdwEnergy.1.lcssa = phi double [ %vdwEnergy.02607, %for.end616 ], [ %168, %for.body638 ]
  %cmp8232536 = icmp sgt i32 %136, 0
  br i1 %cmp8232536, label %for.body824.preheader, label %for.cond1070.preheader

for.body824.preheader:                            ; preds = %for.cond822.preheader
  %wide.trip.count2707 = and i64 %135, 4294967295
  br label %for.body824

for.body638:                                      ; preds = %for.body638.preheader, %for.body638
  %indvars.iv2701 = phi i64 [ 0, %for.body638.preheader ], [ %indvars.iv.next2702, %for.body638 ]
  %vdwEnergy.12520 = phi double [ %vdwEnergy.02607, %for.body638.preheader ], [ %168, %for.body638 ]
  %electEnergy.12519 = phi double [ %electEnergy.02606, %for.body638.preheader ], [ %175, %for.body638 ]
  %virial_xx.12518 = phi double [ %virial_xx.02605, %for.body638.preheader ], [ %178, %for.body638 ]
  %virial_xy.12517 = phi double [ %virial_xy.02604, %for.body638.preheader ], [ %179, %for.body638 ]
  %virial_xz.12516 = phi double [ %virial_xz.02603, %for.body638.preheader ], [ %180, %for.body638 ]
  %virial_yy.12515 = phi double [ %virial_yy.02602, %for.body638.preheader ], [ %183, %for.body638 ]
  %virial_yz.12514 = phi double [ %virial_yz.02601, %for.body638.preheader ], [ %184, %for.body638 ]
  %virial_zz.12513 = phi double [ %virial_zz.02600, %for.body638.preheader ], [ %187, %for.body638 ]
  %fullElectEnergy.12512 = phi double [ %fullElectEnergy.02599, %for.body638.preheader ], [ %196, %for.body638 ]
  %fullElectVirial_xx.12511 = phi double [ %fullElectVirial_xx.02598, %for.body638.preheader ], [ %199, %for.body638 ]
  %fullElectVirial_xy.12510 = phi double [ %fullElectVirial_xy.02597, %for.body638.preheader ], [ %200, %for.body638 ]
  %fullElectVirial_xz.12509 = phi double [ %fullElectVirial_xz.02596, %for.body638.preheader ], [ %201, %for.body638 ]
  %fullElectVirial_yy.12508 = phi double [ %fullElectVirial_yy.02595, %for.body638.preheader ], [ %204, %for.body638 ]
  %fullElectVirial_yz.12507 = phi double [ %fullElectVirial_yz.02594, %for.body638.preheader ], [ %205, %for.body638 ]
  %fullElectVirial_zz.12506 = phi double [ %fullElectVirial_zz.02593, %for.body638.preheader ], [ %208, %for.body638 ]
  %arrayidx641 = getelementptr inbounds i32, i32* %pln.0.lcssa, i64 %indvars.iv2701
  %138 = load i32, i32* %arrayidx641, align 4, !tbaa !4
  %idx.ext642 = sext i32 %138 to i64
  %x645 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext642, i32 0, i32 0
  %139 = load double, double* %x645, align 8, !tbaa !25
  %sub646 = fsub double %62, %139
  %mul648 = fmul double %sub646, %sub646
  %y650 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext642, i32 0, i32 1
  %140 = load double, double* %y650, align 8, !tbaa !28
  %sub651 = fsub double %63, %140
  %141 = call double @llvm.fmuladd.f64(double %sub651, double %sub651, double %mul648)
  %z654 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext642, i32 0, i32 2
  %142 = load double, double* %z654, align 8, !tbaa !29
  %sub655 = fsub double %64, %142
  %143 = call double @llvm.fmuladd.f64(double %sub655, double %sub655, double %141)
  %conv657 = fptrunc double %143 to float
  %144 = bitcast float %conv657 to i32
  %shr = ashr i32 %144, 17
  %add659 = add nsw i32 %shr, %mul
  %id660 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext642, i32 2
  %bf.load661 = load i32, i32* %id660, align 4
  %bf.clear662 = and i32 %bf.load661, 4194303
  %call663 = call zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear662) #9
  %conv664 = zext i16 %call663 to i64
  %mul665 = shl nuw nsw i64 %conv664, 1
  %mul668 = shl nsw i32 %add659, 4
  %idx.ext669 = sext i32 %mul668 to i64
  %add.ptr670 = getelementptr inbounds double, double* %7, i64 %idx.ext669
  %145 = load double, double* %add.ptr670, align 8, !tbaa !13
  %add.ptr675 = getelementptr inbounds double, double* %add.ptr670, i64 4
  %146 = load double, double* %add.ptr675, align 8, !tbaa !13
  %add.ptr680 = getelementptr inbounds double, double* %add.ptr670, i64 8
  %147 = load double, double* %add.ptr680, align 8, !tbaa !13
  %add.ptr686 = getelementptr inbounds double, double* %add.ptr680, i64 4
  %148 = load double, double* %add.ptr686, align 8, !tbaa !13
  %and = and i32 %144, -131072
  %149 = bitcast i32 %and to float
  %charge689 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext642, i32 1
  %150 = load float, float* %charge689, align 8, !tbaa !35
  %conv690 = fpext float %150 to double
  %mul691 = fmul double %mul406, %conv690
  %conv693 = fpext float %149 to double
  %sub694 = fsub double %143, %conv693
  %bf.load696 = load i32, i32* %id660, align 4
  %bf.lshr697 = lshr i32 %bf.load696, 28
  %idxprom698 = zext i32 %bf.lshr697 to i64
  %arrayidx699 = getelementptr inbounds double, double* %add.ptr402, i64 %idxprom698
  %151 = load double, double* %arrayidx699, align 8, !tbaa !13
  %A701 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call412, i64 %mul665, i32 0
  %152 = load double, double* %A701, align 8, !tbaa !42
  %mul702 = fmul double %9, %152
  %B704 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call412, i64 %mul665, i32 1
  %153 = load double, double* %B704, align 8, !tbaa !44
  %154 = fmul double %153, %56
  %neg = fmul double %146, %154
  %155 = call double @llvm.fmuladd.f64(double %mul702, double %145, double %neg)
  %arrayidx708 = getelementptr inbounds double, double* %add.ptr670, i64 3
  %156 = load double, double* %arrayidx708, align 8, !tbaa !13
  %arrayidx710 = getelementptr inbounds double, double* %add.ptr675, i64 3
  %157 = load double, double* %arrayidx710, align 8, !tbaa !13
  %neg712 = fmul double %154, %157
  %158 = call double @llvm.fmuladd.f64(double %mul702, double %156, double %neg712)
  %arrayidx713 = getelementptr inbounds double, double* %add.ptr670, i64 2
  %159 = load double, double* %arrayidx713, align 8, !tbaa !13
  %arrayidx715 = getelementptr inbounds double, double* %add.ptr675, i64 2
  %160 = load double, double* %arrayidx715, align 8, !tbaa !13
  %neg717 = fmul double %154, %160
  %161 = call double @llvm.fmuladd.f64(double %mul702, double %159, double %neg717)
  %arrayidx718 = getelementptr inbounds double, double* %add.ptr670, i64 1
  %162 = load double, double* %arrayidx718, align 8, !tbaa !13
  %arrayidx720 = getelementptr inbounds double, double* %add.ptr675, i64 1
  %163 = load double, double* %arrayidx720, align 8, !tbaa !13
  %neg722 = fmul double %154, %163
  %164 = call double @llvm.fmuladd.f64(double %mul702, double %162, double %neg722)
  %165 = call double @llvm.fmuladd.f64(double %sub694, double %158, double %161)
  %166 = call double @llvm.fmuladd.f64(double %165, double %sub694, double %164)
  %167 = call double @llvm.fmuladd.f64(double %166, double %sub694, double %155)
  %168 = call double @llvm.fmuladd.f64(double %151, double %167, double %vdwEnergy.12520)
  %mul727 = fmul double %147, %mul691
  %arrayidx728 = getelementptr inbounds double, double* %add.ptr680, i64 3
  %169 = load double, double* %arrayidx728, align 8, !tbaa !13
  %mul729 = fmul double %mul691, %169
  %arrayidx730 = getelementptr inbounds double, double* %add.ptr680, i64 2
  %170 = load double, double* %arrayidx730, align 8, !tbaa !13
  %mul731 = fmul double %mul691, %170
  %arrayidx732 = getelementptr inbounds double, double* %add.ptr680, i64 1
  %171 = load double, double* %arrayidx732, align 8, !tbaa !13
  %mul733 = fmul double %mul691, %171
  %172 = call double @llvm.fmuladd.f64(double %sub694, double %mul729, double %mul731)
  %173 = call double @llvm.fmuladd.f64(double %172, double %sub694, double %mul733)
  %174 = call double @llvm.fmuladd.f64(double %173, double %sub694, double %mul727)
  %175 = call double @llvm.fmuladd.f64(double %151, double %174, double %electEnergy.12519)
  %add738 = fadd double %158, %mul729
  %add739 = fadd double %161, %mul731
  %add740 = fadd double %164, %mul733
  %mul742 = fmul double %sub694, 3.000000e+00
  %mul744 = fmul double %add739, 2.000000e+00
  %176 = call double @llvm.fmuladd.f64(double %mul742, double %add738, double %mul744)
  %177 = call double @llvm.fmuladd.f64(double %176, double %sub694, double %add740)
  %mul746 = fmul double %151, -2.000000e+00
  %mul747 = fmul double %mul746, %177
  %mul750 = fmul double %sub646, %mul747
  %178 = call double @llvm.fmuladd.f64(double %mul750, double %sub646, double %virial_xx.12518)
  %179 = call double @llvm.fmuladd.f64(double %mul750, double %sub651, double %virial_xy.12517)
  %180 = call double @llvm.fmuladd.f64(double %mul750, double %sub655, double %virial_xz.12516)
  %181 = load double, double* %x754, align 8, !tbaa !45
  %add755 = fadd double %181, %mul750
  store double %add755, double* %x754, align 8, !tbaa !45
  %x756 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext642, i32 0
  %182 = load double, double* %x756, align 8, !tbaa !45
  %sub757 = fsub double %182, %mul750
  store double %sub757, double* %x756, align 8, !tbaa !45
  %mul758 = fmul double %sub651, %mul747
  %183 = call double @llvm.fmuladd.f64(double %mul758, double %sub651, double %virial_yy.12515)
  %184 = call double @llvm.fmuladd.f64(double %mul758, double %sub655, double %virial_yz.12514)
  %185 = load double, double* %y761, align 8, !tbaa !46
  %add762 = fadd double %185, %mul758
  store double %add762, double* %y761, align 8, !tbaa !46
  %y763 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext642, i32 1
  %186 = load double, double* %y763, align 8, !tbaa !46
  %sub764 = fsub double %186, %mul758
  store double %sub764, double* %y763, align 8, !tbaa !46
  %mul765 = fmul double %sub655, %mul747
  %187 = call double @llvm.fmuladd.f64(double %mul765, double %sub655, double %virial_zz.12513)
  %188 = load double, double* %z767, align 8, !tbaa !47
  %add768 = fadd double %mul765, %188
  store double %add768, double* %z767, align 8, !tbaa !47
  %z769 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext642, i32 2
  %189 = load double, double* %z769, align 8, !tbaa !47
  %sub770 = fsub double %189, %mul765
  store double %sub770, double* %z769, align 8, !tbaa !47
  %arrayidx771 = getelementptr inbounds double, double* %add.ptr686, i64 1
  %190 = load double, double* %arrayidx771, align 8, !tbaa !13
  %arrayidx772 = getelementptr inbounds double, double* %add.ptr686, i64 2
  %191 = load double, double* %arrayidx772, align 8, !tbaa !13
  %arrayidx773 = getelementptr inbounds double, double* %add.ptr686, i64 3
  %192 = load double, double* %arrayidx773, align 8, !tbaa !13
  %mul774 = fmul double %mul691, %192
  %mul775 = fmul double %mul691, %191
  %mul776 = fmul double %mul691, %190
  %mul777 = fmul double %148, %mul691
  %193 = call double @llvm.fmuladd.f64(double %sub694, double %mul774, double %mul775)
  %194 = call double @llvm.fmuladd.f64(double %193, double %sub694, double %mul776)
  %195 = call double @llvm.fmuladd.f64(double %194, double %sub694, double %mul777)
  %196 = call double @llvm.fmuladd.f64(double %151, double %195, double %fullElectEnergy.12512)
  %mul784 = fmul double %mul775, 2.000000e+00
  %197 = call double @llvm.fmuladd.f64(double %mul742, double %mul774, double %mul784)
  %198 = call double @llvm.fmuladd.f64(double %197, double %sub694, double %mul776)
  %mul786 = fmul double %198, -2.000000e+00
  %mul787 = fmul double %151, %mul786
  %mul791 = fmul double %sub646, %mul787
  %199 = call double @llvm.fmuladd.f64(double %mul791, double %sub646, double %fullElectVirial_xx.12511)
  %200 = call double @llvm.fmuladd.f64(double %mul791, double %sub651, double %fullElectVirial_xy.12510)
  %201 = call double @llvm.fmuladd.f64(double %mul791, double %sub655, double %fullElectVirial_xz.12509)
  %202 = load double, double* %x795, align 8, !tbaa !45
  %add796 = fadd double %202, %mul791
  store double %add796, double* %x795, align 8, !tbaa !45
  %x797 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext642, i32 0
  %203 = load double, double* %x797, align 8, !tbaa !45
  %sub798 = fsub double %203, %mul791
  store double %sub798, double* %x797, align 8, !tbaa !45
  %mul800 = fmul double %sub651, %mul787
  %204 = call double @llvm.fmuladd.f64(double %mul800, double %sub651, double %fullElectVirial_yy.12508)
  %205 = call double @llvm.fmuladd.f64(double %mul800, double %sub655, double %fullElectVirial_yz.12507)
  %206 = load double, double* %y803, align 8, !tbaa !46
  %add804 = fadd double %206, %mul800
  store double %add804, double* %y803, align 8, !tbaa !46
  %y805 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext642, i32 1
  %207 = load double, double* %y805, align 8, !tbaa !46
  %sub806 = fsub double %207, %mul800
  store double %sub806, double* %y805, align 8, !tbaa !46
  %mul808 = fmul double %sub655, %mul787
  %208 = call double @llvm.fmuladd.f64(double %mul808, double %sub655, double %fullElectVirial_zz.12506)
  %209 = load double, double* %z810, align 8, !tbaa !47
  %add811 = fadd double %mul808, %209
  store double %add811, double* %z810, align 8, !tbaa !47
  %z812 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext642, i32 2
  %210 = load double, double* %z812, align 8, !tbaa !47
  %sub813 = fsub double %210, %mul808
  store double %sub813, double* %z812, align 8, !tbaa !47
  %indvars.iv.next2702 = add nuw nsw i64 %indvars.iv2701, 1
  %exitcond2704.not = icmp eq i64 %indvars.iv.next2702, %wide.trip.count2703
  br i1 %exitcond2704.not, label %for.cond822.preheader, label %for.body638, !llvm.loop !64

for.cond1070.preheader:                           ; preds = %for.body824, %for.cond822.preheader
  %fullElectVirial_zz.2.lcssa = phi double [ %fullElectVirial_zz.1.lcssa, %for.cond822.preheader ], [ %289, %for.body824 ]
  %fullElectVirial_yz.2.lcssa = phi double [ %fullElectVirial_yz.1.lcssa, %for.cond822.preheader ], [ %286, %for.body824 ]
  %fullElectVirial_yy.2.lcssa = phi double [ %fullElectVirial_yy.1.lcssa, %for.cond822.preheader ], [ %285, %for.body824 ]
  %fullElectVirial_xz.2.lcssa = phi double [ %fullElectVirial_xz.1.lcssa, %for.cond822.preheader ], [ %282, %for.body824 ]
  %fullElectVirial_xy.2.lcssa = phi double [ %fullElectVirial_xy.1.lcssa, %for.cond822.preheader ], [ %281, %for.body824 ]
  %fullElectVirial_xx.2.lcssa = phi double [ %fullElectVirial_xx.1.lcssa, %for.cond822.preheader ], [ %280, %for.body824 ]
  %fullElectEnergy.2.lcssa = phi double [ %fullElectEnergy.1.lcssa, %for.cond822.preheader ], [ %277, %for.body824 ]
  %virial_zz.2.lcssa = phi double [ %virial_zz.1.lcssa, %for.cond822.preheader ], [ %260, %for.body824 ]
  %virial_yz.2.lcssa = phi double [ %virial_yz.1.lcssa, %for.cond822.preheader ], [ %257, %for.body824 ]
  %virial_yy.2.lcssa = phi double [ %virial_yy.1.lcssa, %for.cond822.preheader ], [ %256, %for.body824 ]
  %virial_xz.2.lcssa = phi double [ %virial_xz.1.lcssa, %for.cond822.preheader ], [ %253, %for.body824 ]
  %virial_xy.2.lcssa = phi double [ %virial_xy.1.lcssa, %for.cond822.preheader ], [ %252, %for.body824 ]
  %virial_xx.2.lcssa = phi double [ %virial_xx.1.lcssa, %for.cond822.preheader ], [ %251, %for.body824 ]
  %electEnergy.2.lcssa = phi double [ %electEnergy.1.lcssa, %for.cond822.preheader ], [ %248, %for.body824 ]
  %vdwEnergy.2.lcssa = phi double [ %vdwEnergy.1.lcssa, %for.cond822.preheader ], [ %241, %for.body824 ]
  %cmp10712568 = icmp sgt i32 %134, 0
  br i1 %cmp10712568, label %for.body1072.preheader, label %cleanup1191

for.body1072.preheader:                           ; preds = %for.cond1070.preheader
  %wide.trip.count2711 = and i64 %133, 4294967295
  br label %for.body1072

for.body824:                                      ; preds = %for.body824.preheader, %for.body824
  %indvars.iv2705 = phi i64 [ 0, %for.body824.preheader ], [ %indvars.iv.next2706, %for.body824 ]
  %vdwEnergy.22552 = phi double [ %vdwEnergy.1.lcssa, %for.body824.preheader ], [ %241, %for.body824 ]
  %electEnergy.22551 = phi double [ %electEnergy.1.lcssa, %for.body824.preheader ], [ %248, %for.body824 ]
  %virial_xx.22550 = phi double [ %virial_xx.1.lcssa, %for.body824.preheader ], [ %251, %for.body824 ]
  %virial_xy.22549 = phi double [ %virial_xy.1.lcssa, %for.body824.preheader ], [ %252, %for.body824 ]
  %virial_xz.22548 = phi double [ %virial_xz.1.lcssa, %for.body824.preheader ], [ %253, %for.body824 ]
  %virial_yy.22547 = phi double [ %virial_yy.1.lcssa, %for.body824.preheader ], [ %256, %for.body824 ]
  %virial_yz.22546 = phi double [ %virial_yz.1.lcssa, %for.body824.preheader ], [ %257, %for.body824 ]
  %virial_zz.22545 = phi double [ %virial_zz.1.lcssa, %for.body824.preheader ], [ %260, %for.body824 ]
  %fullElectEnergy.22544 = phi double [ %fullElectEnergy.1.lcssa, %for.body824.preheader ], [ %277, %for.body824 ]
  %fullElectVirial_xx.22543 = phi double [ %fullElectVirial_xx.1.lcssa, %for.body824.preheader ], [ %280, %for.body824 ]
  %fullElectVirial_xy.22542 = phi double [ %fullElectVirial_xy.1.lcssa, %for.body824.preheader ], [ %281, %for.body824 ]
  %fullElectVirial_xz.22541 = phi double [ %fullElectVirial_xz.1.lcssa, %for.body824.preheader ], [ %282, %for.body824 ]
  %fullElectVirial_yy.22540 = phi double [ %fullElectVirial_yy.1.lcssa, %for.body824.preheader ], [ %285, %for.body824 ]
  %fullElectVirial_yz.22539 = phi double [ %fullElectVirial_yz.1.lcssa, %for.body824.preheader ], [ %286, %for.body824 ]
  %fullElectVirial_zz.22538 = phi double [ %fullElectVirial_zz.1.lcssa, %for.body824.preheader ], [ %289, %for.body824 ]
  %arrayidx827 = getelementptr inbounds i32, i32* %cond158, i64 %indvars.iv2705
  %211 = load i32, i32* %arrayidx827, align 4, !tbaa !4
  %idx.ext829 = sext i32 %211 to i64
  %x833 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext829, i32 0, i32 0
  %212 = load double, double* %x833, align 8, !tbaa !25
  %sub834 = fsub double %62, %212
  %mul836 = fmul double %sub834, %sub834
  %y839 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext829, i32 0, i32 1
  %213 = load double, double* %y839, align 8, !tbaa !28
  %sub840 = fsub double %63, %213
  %214 = call double @llvm.fmuladd.f64(double %sub840, double %sub840, double %mul836)
  %z844 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext829, i32 0, i32 2
  %215 = load double, double* %z844, align 8, !tbaa !29
  %sub845 = fsub double %64, %215
  %216 = call double @llvm.fmuladd.f64(double %sub845, double %sub845, double %214)
  %conv848 = fptrunc double %216 to float
  %217 = bitcast float %conv848 to i32
  %shr852 = ashr i32 %217, 17
  %add853 = add nsw i32 %shr852, %mul
  %id855 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext829, i32 2
  %bf.load856 = load i32, i32* %id855, align 4
  %bf.clear857 = and i32 %bf.load856, 4194303
  %call858 = call zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32) %6, i32 %bf.clear857) #9
  %conv859 = zext i16 %call858 to i64
  %mul860 = shl nuw nsw i64 %conv859, 1
  %add.ptr863.idx = or i64 %mul860, 1
  %mul865 = shl nsw i32 %add853, 4
  %idx.ext866 = sext i32 %mul865 to i64
  %add.ptr867 = getelementptr inbounds double, double* %7, i64 %idx.ext866
  %218 = load double, double* %add.ptr867, align 8, !tbaa !13
  %add.ptr874 = getelementptr inbounds double, double* %add.ptr867, i64 4
  %219 = load double, double* %add.ptr874, align 8, !tbaa !13
  %add.ptr881 = getelementptr inbounds double, double* %add.ptr867, i64 8
  %220 = load double, double* %add.ptr881, align 8, !tbaa !13
  %add.ptr889 = getelementptr inbounds double, double* %add.ptr881, i64 4
  %221 = load double, double* %add.ptr889, align 8, !tbaa !13
  %and893 = and i32 %217, -131072
  %222 = bitcast i32 %and893 to float
  %charge895 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext829, i32 1
  %223 = load float, float* %charge895, align 8, !tbaa !35
  %conv896 = fpext float %223 to double
  %mul897 = fmul double %mul406, %conv896
  %conv900 = fpext float %222 to double
  %sub901 = fsub double %216, %conv900
  %bf.load904 = load i32, i32* %id855, align 4
  %bf.lshr905 = lshr i32 %bf.load904, 28
  %idxprom906 = zext i32 %bf.lshr905 to i64
  %arrayidx907 = getelementptr inbounds double, double* %add.ptr402, i64 %idxprom906
  %224 = load double, double* %arrayidx907, align 8, !tbaa !13
  %A909 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call412, i64 %add.ptr863.idx, i32 0
  %225 = load double, double* %A909, align 8, !tbaa !42
  %mul910 = fmul double %9, %225
  %B912 = getelementptr inbounds %"struct.LJTable::TableEntry", %"struct.LJTable::TableEntry"* %call412, i64 %add.ptr863.idx, i32 1
  %226 = load double, double* %B912, align 8, !tbaa !44
  %227 = fmul double %226, %56
  %neg917 = fmul double %219, %227
  %228 = call double @llvm.fmuladd.f64(double %mul910, double %218, double %neg917)
  %arrayidx919 = getelementptr inbounds double, double* %add.ptr867, i64 3
  %229 = load double, double* %arrayidx919, align 8, !tbaa !13
  %arrayidx921 = getelementptr inbounds double, double* %add.ptr874, i64 3
  %230 = load double, double* %arrayidx921, align 8, !tbaa !13
  %neg923 = fmul double %227, %230
  %231 = call double @llvm.fmuladd.f64(double %mul910, double %229, double %neg923)
  %arrayidx925 = getelementptr inbounds double, double* %add.ptr867, i64 2
  %232 = load double, double* %arrayidx925, align 8, !tbaa !13
  %arrayidx927 = getelementptr inbounds double, double* %add.ptr874, i64 2
  %233 = load double, double* %arrayidx927, align 8, !tbaa !13
  %neg929 = fmul double %227, %233
  %234 = call double @llvm.fmuladd.f64(double %mul910, double %232, double %neg929)
  %arrayidx931 = getelementptr inbounds double, double* %add.ptr867, i64 1
  %235 = load double, double* %arrayidx931, align 8, !tbaa !13
  %arrayidx933 = getelementptr inbounds double, double* %add.ptr874, i64 1
  %236 = load double, double* %arrayidx933, align 8, !tbaa !13
  %neg935 = fmul double %227, %236
  %237 = call double @llvm.fmuladd.f64(double %mul910, double %235, double %neg935)
  %238 = call double @llvm.fmuladd.f64(double %sub901, double %231, double %234)
  %239 = call double @llvm.fmuladd.f64(double %238, double %sub901, double %237)
  %240 = call double @llvm.fmuladd.f64(double %239, double %sub901, double %228)
  %241 = call double @llvm.fmuladd.f64(double %224, double %240, double %vdwEnergy.22552)
  %mul942 = fmul double %sub941, %mul897
  %mul943 = fmul double %220, %mul942
  %arrayidx945 = getelementptr inbounds double, double* %add.ptr881, i64 3
  %242 = load double, double* %arrayidx945, align 8, !tbaa !13
  %mul946 = fmul double %mul942, %242
  %arrayidx948 = getelementptr inbounds double, double* %add.ptr881, i64 2
  %243 = load double, double* %arrayidx948, align 8, !tbaa !13
  %mul949 = fmul double %mul942, %243
  %arrayidx951 = getelementptr inbounds double, double* %add.ptr881, i64 1
  %244 = load double, double* %arrayidx951, align 8, !tbaa !13
  %mul952 = fmul double %mul942, %244
  %245 = call double @llvm.fmuladd.f64(double %sub901, double %mul946, double %mul949)
  %246 = call double @llvm.fmuladd.f64(double %245, double %sub901, double %mul952)
  %247 = call double @llvm.fmuladd.f64(double %246, double %sub901, double %mul943)
  %248 = call double @llvm.fmuladd.f64(double %224, double %247, double %electEnergy.22551)
  %add958 = fadd double %231, %mul946
  %add959 = fadd double %234, %mul949
  %add960 = fadd double %237, %mul952
  %mul963 = fmul double %sub901, 3.000000e+00
  %mul965 = fmul double %add959, 2.000000e+00
  %249 = call double @llvm.fmuladd.f64(double %mul963, double %add958, double %mul965)
  %250 = call double @llvm.fmuladd.f64(double %249, double %sub901, double %add960)
  %mul968 = fmul double %224, -2.000000e+00
  %mul969 = fmul double %mul968, %250
  %mul974 = fmul double %sub834, %mul969
  %251 = call double @llvm.fmuladd.f64(double %mul974, double %sub834, double %virial_xx.22550)
  %252 = call double @llvm.fmuladd.f64(double %mul974, double %sub840, double %virial_xy.22549)
  %253 = call double @llvm.fmuladd.f64(double %mul974, double %sub845, double %virial_xz.22548)
  %254 = load double, double* %x754, align 8, !tbaa !45
  %add979 = fadd double %254, %mul974
  store double %add979, double* %x754, align 8, !tbaa !45
  %x980 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext829, i32 0
  %255 = load double, double* %x980, align 8, !tbaa !45
  %sub981 = fsub double %255, %mul974
  store double %sub981, double* %x980, align 8, !tbaa !45
  %mul983 = fmul double %sub840, %mul969
  %256 = call double @llvm.fmuladd.f64(double %mul983, double %sub840, double %virial_yy.22547)
  %257 = call double @llvm.fmuladd.f64(double %mul983, double %sub845, double %virial_yz.22546)
  %258 = load double, double* %y761, align 8, !tbaa !46
  %add987 = fadd double %258, %mul983
  store double %add987, double* %y761, align 8, !tbaa !46
  %y988 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext829, i32 1
  %259 = load double, double* %y988, align 8, !tbaa !46
  %sub989 = fsub double %259, %mul983
  store double %sub989, double* %y988, align 8, !tbaa !46
  %mul991 = fmul double %sub845, %mul969
  %260 = call double @llvm.fmuladd.f64(double %mul991, double %sub845, double %virial_zz.22545)
  %261 = load double, double* %z767, align 8, !tbaa !47
  %add994 = fadd double %mul991, %261
  store double %add994, double* %z767, align 8, !tbaa !47
  %z995 = getelementptr inbounds %class.Vector, %class.Vector* %50, i64 %idx.ext829, i32 2
  %262 = load double, double* %z995, align 8, !tbaa !47
  %sub996 = fsub double %262, %mul991
  store double %sub996, double* %z995, align 8, !tbaa !47
  %arrayidx998 = getelementptr inbounds double, double* %add.ptr889, i64 1
  %263 = load double, double* %arrayidx998, align 8, !tbaa !13
  %arrayidx1000 = getelementptr inbounds double, double* %add.ptr889, i64 2
  %264 = load double, double* %arrayidx1000, align 8, !tbaa !13
  %arrayidx1002 = getelementptr inbounds double, double* %add.ptr889, i64 3
  %265 = load double, double* %arrayidx1002, align 8, !tbaa !13
  %mul1003 = shl nsw i32 %add853, 2
  %idx.ext1004 = sext i32 %mul1003 to i64
  %add.ptr1005 = getelementptr inbounds double, double* %8, i64 %idx.ext1004
  %266 = load double, double* %add.ptr1005, align 8, !tbaa !13
  %267 = call double @llvm.fmuladd.f64(double %neg1008, double %266, double %221)
  %arrayidx1009 = getelementptr inbounds double, double* %add.ptr1005, i64 1
  %268 = load double, double* %arrayidx1009, align 8, !tbaa !13
  %269 = call double @llvm.fmuladd.f64(double %neg1008, double %268, double %263)
  %arrayidx1012 = getelementptr inbounds double, double* %add.ptr1005, i64 2
  %270 = load double, double* %arrayidx1012, align 8, !tbaa !13
  %271 = call double @llvm.fmuladd.f64(double %neg1008, double %270, double %264)
  %arrayidx1015 = getelementptr inbounds double, double* %add.ptr1005, i64 3
  %272 = load double, double* %arrayidx1015, align 8, !tbaa !13
  %273 = call double @llvm.fmuladd.f64(double %neg1008, double %272, double %265)
  %mul1018 = fmul double %mul897, %273
  %mul1019 = fmul double %mul897, %271
  %mul1020 = fmul double %mul897, %269
  %mul1021 = fmul double %mul897, %267
  %274 = call double @llvm.fmuladd.f64(double %sub901, double %mul1018, double %mul1019)
  %275 = call double @llvm.fmuladd.f64(double %274, double %sub901, double %mul1020)
  %276 = call double @llvm.fmuladd.f64(double %275, double %sub901, double %mul1021)
  %277 = call double @llvm.fmuladd.f64(double %224, double %276, double %fullElectEnergy.22544)
  %mul1030 = fmul double %mul1019, 2.000000e+00
  %278 = call double @llvm.fmuladd.f64(double %mul963, double %mul1018, double %mul1030)
  %279 = call double @llvm.fmuladd.f64(double %278, double %sub901, double %mul1020)
  %mul1033 = fmul double %279, -2.000000e+00
  %mul1034 = fmul double %224, %mul1033
  %mul1039 = fmul double %sub834, %mul1034
  %280 = call double @llvm.fmuladd.f64(double %mul1039, double %sub834, double %fullElectVirial_xx.22543)
  %281 = call double @llvm.fmuladd.f64(double %mul1039, double %sub840, double %fullElectVirial_xy.22542)
  %282 = call double @llvm.fmuladd.f64(double %mul1039, double %sub845, double %fullElectVirial_xz.22541)
  %283 = load double, double* %x795, align 8, !tbaa !45
  %add1044 = fadd double %283, %mul1039
  store double %add1044, double* %x795, align 8, !tbaa !45
  %x1045 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext829, i32 0
  %284 = load double, double* %x1045, align 8, !tbaa !45
  %sub1046 = fsub double %284, %mul1039
  store double %sub1046, double* %x1045, align 8, !tbaa !45
  %mul1048 = fmul double %sub840, %mul1034
  %285 = call double @llvm.fmuladd.f64(double %mul1048, double %sub840, double %fullElectVirial_yy.22540)
  %286 = call double @llvm.fmuladd.f64(double %mul1048, double %sub845, double %fullElectVirial_yz.22539)
  %287 = load double, double* %y803, align 8, !tbaa !46
  %add1052 = fadd double %287, %mul1048
  store double %add1052, double* %y803, align 8, !tbaa !46
  %y1053 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext829, i32 1
  %288 = load double, double* %y1053, align 8, !tbaa !46
  %sub1054 = fsub double %288, %mul1048
  store double %sub1054, double* %y1053, align 8, !tbaa !46
  %mul1056 = fmul double %sub845, %mul1034
  %289 = call double @llvm.fmuladd.f64(double %mul1056, double %sub845, double %fullElectVirial_zz.22538)
  %290 = load double, double* %z810, align 8, !tbaa !47
  %add1059 = fadd double %mul1056, %290
  store double %add1059, double* %z810, align 8, !tbaa !47
  %z1060 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext829, i32 2
  %291 = load double, double* %z1060, align 8, !tbaa !47
  %sub1061 = fsub double %291, %mul1056
  store double %sub1061, double* %z1060, align 8, !tbaa !47
  %indvars.iv.next2706 = add nuw nsw i64 %indvars.iv2705, 1
  %exitcond2708.not = icmp eq i64 %indvars.iv.next2706, %wide.trip.count2707
  br i1 %exitcond2708.not, label %for.cond1070.preheader, label %for.body824, !llvm.loop !65

for.body1072:                                     ; preds = %for.body1072.preheader, %for.body1072
  %indvars.iv2709 = phi i64 [ 0, %for.body1072.preheader ], [ %indvars.iv.next2710, %for.body1072 ]
  %fullElectEnergy.32576 = phi double [ %fullElectEnergy.2.lcssa, %for.body1072.preheader ], [ %314, %for.body1072 ]
  %fullElectVirial_xx.32575 = phi double [ %fullElectVirial_xx.2.lcssa, %for.body1072.preheader ], [ %317, %for.body1072 ]
  %fullElectVirial_xy.32574 = phi double [ %fullElectVirial_xy.2.lcssa, %for.body1072.preheader ], [ %318, %for.body1072 ]
  %fullElectVirial_xz.32573 = phi double [ %fullElectVirial_xz.2.lcssa, %for.body1072.preheader ], [ %319, %for.body1072 ]
  %fullElectVirial_yy.32572 = phi double [ %fullElectVirial_yy.2.lcssa, %for.body1072.preheader ], [ %322, %for.body1072 ]
  %fullElectVirial_yz.32571 = phi double [ %fullElectVirial_yz.2.lcssa, %for.body1072.preheader ], [ %323, %for.body1072 ]
  %fullElectVirial_zz.32570 = phi double [ %fullElectVirial_zz.2.lcssa, %for.body1072.preheader ], [ %326, %for.body1072 ]
  %arrayidx1075 = getelementptr inbounds i32, i32* %cond1472423, i64 %indvars.iv2709
  %292 = load i32, i32* %arrayidx1075, align 4, !tbaa !4
  %idx.ext1077 = sext i32 %292 to i64
  %x1081 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1077, i32 0, i32 0
  %293 = load double, double* %x1081, align 8, !tbaa !25
  %sub1082 = fsub double %62, %293
  %mul1084 = fmul double %sub1082, %sub1082
  %y1087 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1077, i32 0, i32 1
  %294 = load double, double* %y1087, align 8, !tbaa !28
  %sub1088 = fsub double %63, %294
  %295 = call double @llvm.fmuladd.f64(double %sub1088, double %sub1088, double %mul1084)
  %z1092 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1077, i32 0, i32 2
  %296 = load double, double* %z1092, align 8, !tbaa !29
  %sub1093 = fsub double %64, %296
  %297 = call double @llvm.fmuladd.f64(double %sub1093, double %sub1093, double %295)
  %conv1096 = fptrunc double %297 to float
  %298 = bitcast float %conv1096 to i32
  %shr1100 = ashr i32 %298, 17
  %add1101 = add nsw i32 %shr1100, %mul
  %mul1103 = shl nsw i32 %add1101, 4
  %299 = or i32 %mul1103, 12
  %add.ptr1107.idx = sext i32 %299 to i64
  %add.ptr1107 = getelementptr inbounds double, double* %7, i64 %add.ptr1107.idx
  %300 = load double, double* %add.ptr1107, align 8, !tbaa !13
  %and1111 = and i32 %298, -131072
  %301 = bitcast i32 %and1111 to float
  %charge1113 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1077, i32 1
  %302 = load float, float* %charge1113, align 8, !tbaa !35
  %conv1114 = fpext float %302 to double
  %mul1115 = fmul double %mul406, %conv1114
  %conv1118 = fpext float %301 to double
  %sub1119 = fsub double %297, %conv1118
  %partition1121 = getelementptr inbounds %struct.CompAtom, %struct.CompAtom* %16, i64 %idx.ext1077, i32 2
  %bf.load1122 = load i32, i32* %partition1121, align 4
  %bf.lshr1123 = lshr i32 %bf.load1122, 28
  %idxprom1124 = zext i32 %bf.lshr1123 to i64
  %arrayidx1125 = getelementptr inbounds double, double* %add.ptr402, i64 %idxprom1124
  %303 = load double, double* %arrayidx1125, align 8, !tbaa !13
  %arrayidx1127 = getelementptr inbounds double, double* %add.ptr1107, i64 1
  %304 = load double, double* %arrayidx1127, align 8, !tbaa !13
  %arrayidx1129 = getelementptr inbounds double, double* %add.ptr1107, i64 2
  %305 = load double, double* %arrayidx1129, align 8, !tbaa !13
  %arrayidx1131 = getelementptr inbounds double, double* %add.ptr1107, i64 3
  %306 = load double, double* %arrayidx1131, align 8, !tbaa !13
  %mul1133 = shl nsw i32 %add1101, 2
  %idx.ext1134 = sext i32 %mul1133 to i64
  %add.ptr1135 = getelementptr inbounds double, double* %8, i64 %idx.ext1134
  %307 = load double, double* %add.ptr1135, align 8, !tbaa !13
  %sub1137 = fsub double %300, %307
  %arrayidx1138 = getelementptr inbounds double, double* %add.ptr1135, i64 1
  %308 = load double, double* %arrayidx1138, align 8, !tbaa !13
  %sub1139 = fsub double %304, %308
  %arrayidx1140 = getelementptr inbounds double, double* %add.ptr1135, i64 2
  %309 = load double, double* %arrayidx1140, align 8, !tbaa !13
  %sub1141 = fsub double %305, %309
  %arrayidx1142 = getelementptr inbounds double, double* %add.ptr1135, i64 3
  %310 = load double, double* %arrayidx1142, align 8, !tbaa !13
  %sub1143 = fsub double %306, %310
  %mul1144 = fmul double %mul1115, %sub1143
  %mul1145 = fmul double %mul1115, %sub1141
  %mul1146 = fmul double %mul1115, %sub1139
  %mul1147 = fmul double %mul1115, %sub1137
  %311 = call double @llvm.fmuladd.f64(double %sub1119, double %mul1144, double %mul1145)
  %312 = call double @llvm.fmuladd.f64(double %311, double %sub1119, double %mul1146)
  %313 = call double @llvm.fmuladd.f64(double %312, double %sub1119, double %mul1147)
  %314 = call double @llvm.fmuladd.f64(double %303, double %313, double %fullElectEnergy.32576)
  %mul1154 = fmul double %sub1119, 3.000000e+00
  %mul1156 = fmul double %mul1145, 2.000000e+00
  %315 = call double @llvm.fmuladd.f64(double %mul1154, double %mul1144, double %mul1156)
  %316 = call double @llvm.fmuladd.f64(double %315, double %sub1119, double %mul1146)
  %mul1159 = fmul double %316, -2.000000e+00
  %mul1160 = fmul double %303, %mul1159
  %mul1165 = fmul double %sub1082, %mul1160
  %317 = call double @llvm.fmuladd.f64(double %mul1165, double %sub1082, double %fullElectVirial_xx.32575)
  %318 = call double @llvm.fmuladd.f64(double %mul1165, double %sub1088, double %fullElectVirial_xy.32574)
  %319 = call double @llvm.fmuladd.f64(double %mul1165, double %sub1093, double %fullElectVirial_xz.32573)
  %320 = load double, double* %x795, align 8, !tbaa !45
  %add1170 = fadd double %320, %mul1165
  store double %add1170, double* %x795, align 8, !tbaa !45
  %x1171 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext1077, i32 0
  %321 = load double, double* %x1171, align 8, !tbaa !45
  %sub1172 = fsub double %321, %mul1165
  store double %sub1172, double* %x1171, align 8, !tbaa !45
  %mul1174 = fmul double %sub1088, %mul1160
  %322 = call double @llvm.fmuladd.f64(double %mul1174, double %sub1088, double %fullElectVirial_yy.32572)
  %323 = call double @llvm.fmuladd.f64(double %mul1174, double %sub1093, double %fullElectVirial_yz.32571)
  %324 = load double, double* %y803, align 8, !tbaa !46
  %add1178 = fadd double %324, %mul1174
  store double %add1178, double* %y803, align 8, !tbaa !46
  %y1179 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext1077, i32 1
  %325 = load double, double* %y1179, align 8, !tbaa !46
  %sub1180 = fsub double %325, %mul1174
  store double %sub1180, double* %y1179, align 8, !tbaa !46
  %mul1182 = fmul double %sub1093, %mul1160
  %326 = call double @llvm.fmuladd.f64(double %mul1182, double %sub1093, double %fullElectVirial_zz.32570)
  %327 = load double, double* %z810, align 8, !tbaa !47
  %add1185 = fadd double %mul1182, %327
  store double %add1185, double* %z810, align 8, !tbaa !47
  %z1186 = getelementptr inbounds %class.Vector, %class.Vector* %52, i64 %idx.ext1077, i32 2
  %328 = load double, double* %z1186, align 8, !tbaa !47
  %sub1187 = fsub double %328, %mul1182
  store double %sub1187, double* %z1186, align 8, !tbaa !47
  %indvars.iv.next2710 = add nuw nsw i64 %indvars.iv2709, 1
  %exitcond2712.not = icmp eq i64 %indvars.iv.next2710, %wide.trip.count2711
  br i1 %exitcond2712.not, label %cleanup1191, label %for.body1072, !llvm.loop !66

cleanup1191:                                      ; preds = %for.body1072, %for.cond1070.preheader, %if.then204
  %pairCount.3 = phi i32 [ %sub216, %if.then204 ], [ %pairCount.2, %for.cond1070.preheader ], [ %pairCount.2, %for.body1072 ]
  %pairlistoffset.2 = phi i32 [ %pairlistoffset.02586, %if.then204 ], [ %pairlistoffset.1, %for.cond1070.preheader ], [ %pairlistoffset.1, %for.body1072 ]
  %pairlistindex.3 = phi i32 [ %pairlistindex.02587, %if.then204 ], [ %pairlistindex.2, %for.cond1070.preheader ], [ %pairlistindex.2, %for.body1072 ]
  %fixg_lower.4 = phi i32 [ %fixg_lower.02588, %if.then204 ], [ %fixg_lower.3, %for.cond1070.preheader ], [ %fixg_lower.3, %for.body1072 ]
  %g_lower.4 = phi i32 [ %g_lower.02589, %if.then204 ], [ %g_lower.3, %for.cond1070.preheader ], [ %g_lower.3, %for.body1072 ]
  %j_hgroup.3 = phi i32 [ %j_hgroup.02590, %if.then204 ], [ %j_hgroup.2, %for.cond1070.preheader ], [ %j_hgroup.2, %for.body1072 ]
  %i.4 = phi i32 [ %add222, %if.then204 ], [ %i.02591, %for.cond1070.preheader ], [ %i.02591, %for.body1072 ]
  %fullElectVirial_zz.4 = phi double [ %fullElectVirial_zz.02593, %if.then204 ], [ %fullElectVirial_zz.2.lcssa, %for.cond1070.preheader ], [ %326, %for.body1072 ]
  %fullElectVirial_yz.4 = phi double [ %fullElectVirial_yz.02594, %if.then204 ], [ %fullElectVirial_yz.2.lcssa, %for.cond1070.preheader ], [ %323, %for.body1072 ]
  %fullElectVirial_yy.4 = phi double [ %fullElectVirial_yy.02595, %if.then204 ], [ %fullElectVirial_yy.2.lcssa, %for.cond1070.preheader ], [ %322, %for.body1072 ]
  %fullElectVirial_xz.4 = phi double [ %fullElectVirial_xz.02596, %if.then204 ], [ %fullElectVirial_xz.2.lcssa, %for.cond1070.preheader ], [ %319, %for.body1072 ]
  %fullElectVirial_xy.4 = phi double [ %fullElectVirial_xy.02597, %if.then204 ], [ %fullElectVirial_xy.2.lcssa, %for.cond1070.preheader ], [ %318, %for.body1072 ]
  %fullElectVirial_xx.4 = phi double [ %fullElectVirial_xx.02598, %if.then204 ], [ %fullElectVirial_xx.2.lcssa, %for.cond1070.preheader ], [ %317, %for.body1072 ]
  %fullElectEnergy.4 = phi double [ %fullElectEnergy.02599, %if.then204 ], [ %fullElectEnergy.2.lcssa, %for.cond1070.preheader ], [ %314, %for.body1072 ]
  %virial_zz.3 = phi double [ %virial_zz.02600, %if.then204 ], [ %virial_zz.2.lcssa, %for.cond1070.preheader ], [ %virial_zz.2.lcssa, %for.body1072 ]
  %virial_yz.3 = phi double [ %virial_yz.02601, %if.then204 ], [ %virial_yz.2.lcssa, %for.cond1070.preheader ], [ %virial_yz.2.lcssa, %for.body1072 ]
  %virial_yy.3 = phi double [ %virial_yy.02602, %if.then204 ], [ %virial_yy.2.lcssa, %for.cond1070.preheader ], [ %virial_yy.2.lcssa, %for.body1072 ]
  %virial_xz.3 = phi double [ %virial_xz.02603, %if.then204 ], [ %virial_xz.2.lcssa, %for.cond1070.preheader ], [ %virial_xz.2.lcssa, %for.body1072 ]
  %virial_xy.3 = phi double [ %virial_xy.02604, %if.then204 ], [ %virial_xy.2.lcssa, %for.cond1070.preheader ], [ %virial_xy.2.lcssa, %for.body1072 ]
  %virial_xx.3 = phi double [ %virial_xx.02605, %if.then204 ], [ %virial_xx.2.lcssa, %for.cond1070.preheader ], [ %virial_xx.2.lcssa, %for.body1072 ]
  %electEnergy.3 = phi double [ %electEnergy.02606, %if.then204 ], [ %electEnergy.2.lcssa, %for.cond1070.preheader ], [ %electEnergy.2.lcssa, %for.body1072 ]
  %vdwEnergy.3 = phi double [ %vdwEnergy.02607, %if.then204 ], [ %vdwEnergy.2.lcssa, %for.cond1070.preheader ], [ %vdwEnergy.2.lcssa, %for.body1072 ]
  %exclChecksum.11 = phi i32 [ %exclChecksum.02608, %if.then204 ], [ %conv630, %for.cond1070.preheader ], [ %conv630, %for.body1072 ]
  %inc1204 = add nsw i32 %i.4, 1
  %cmp174 = icmp sgt i32 %sub165, %inc1204
  br i1 %cmp174, label %for.body175, label %for.end1205, !llvm.loop !67

for.end1205:                                      ; preds = %cleanup1191, %cond.end157
  %fullElectVirial_zz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_zz.4, %cleanup1191 ]
  %fullElectVirial_yz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_yz.4, %cleanup1191 ]
  %fullElectVirial_yy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_yy.4, %cleanup1191 ]
  %fullElectVirial_xz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_xz.4, %cleanup1191 ]
  %fullElectVirial_xy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_xy.4, %cleanup1191 ]
  %fullElectVirial_xx.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectVirial_xx.4, %cleanup1191 ]
  %fullElectEnergy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %fullElectEnergy.4, %cleanup1191 ]
  %virial_zz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_zz.3, %cleanup1191 ]
  %virial_yz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_yz.3, %cleanup1191 ]
  %virial_yy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_yy.3, %cleanup1191 ]
  %virial_xz.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_xz.3, %cleanup1191 ]
  %virial_xy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_xy.3, %cleanup1191 ]
  %virial_xx.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %virial_xx.3, %cleanup1191 ]
  %electEnergy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %electEnergy.3, %cleanup1191 ]
  %vdwEnergy.0.lcssa = phi double [ 0.000000e+00, %cond.end157 ], [ %vdwEnergy.3, %cleanup1191 ]
  %exclChecksum.0.lcssa = phi i32 [ 0, %cond.end157 ], [ %exclChecksum.11, %cleanup1191 ]
  %arraydecay1206 = getelementptr inbounds [1005 x i32], [1005 x i32]* %grouplist_std, i64 0, i64 0
  %cmp1207 = icmp eq i32* %cond23842388272827382751, %arraydecay1206
  br i1 %cmp1207, label %if.end1212, label %delete.notnull1210

delete.notnull1210:                               ; preds = %for.end1205
  %329 = bitcast i32* %cond23842388272827382751 to i8*
  call void @_ZdaPv(i8* %329) #8
  br label %if.end1212

if.end1212:                                       ; preds = %delete.notnull1210, %for.end1205
  %arraydecay1213 = getelementptr inbounds [1005 x i32], [1005 x i32]* %fixglist_std, i64 0, i64 0
  %cmp1214 = icmp eq i32* %cond192390272627392749, %arraydecay1213
  br i1 %cmp1214, label %if.end1219, label %delete.notnull1217

delete.notnull1217:                               ; preds = %if.end1212
  %330 = bitcast i32* %cond192390272627392749 to i8*
  call void @_ZdaPv(i8* %330) #8
  br label %if.end1219

if.end1219:                                       ; preds = %delete.notnull1217, %if.end1212
  %arraydecay1220 = getelementptr inbounds [1005 x i32], [1005 x i32]* %goodglist_std, i64 0, i64 0
  %cmp1221 = icmp eq i32* %cond30273027372753, %arraydecay1220
  br i1 %cmp1221, label %if.end1226, label %delete.notnull1224

delete.notnull1224:                               ; preds = %if.end1219
  %331 = bitcast i32* %cond30273027372753 to i8*
  call void @_ZdaPv(i8* %331) #8
  br label %if.end1226

if.end1226:                                       ; preds = %delete.notnull1224, %if.end1219
  %arraydecay1227 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist_std, i64 0, i64 0
  %cmp1228 = icmp eq i32* %cond1142396240024092419, %arraydecay1227
  br i1 %cmp1228, label %if.end1233, label %delete.notnull1231

delete.notnull1231:                               ; preds = %if.end1226
  %332 = bitcast i32* %cond1142396240024092419 to i8*
  call void @_ZdaPv(i8* %332) #8
  br label %if.end1233

if.end1233:                                       ; preds = %delete.notnull1231, %if.end1226
  %arraydecay1234 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlist2_std, i64 0, i64 0
  %cmp1235 = icmp eq i32* %cond125240224072421, %arraydecay1234
  br i1 %cmp1235, label %if.end1240, label %delete.notnull1238

delete.notnull1238:                               ; preds = %if.end1233
  %333 = bitcast i32* %cond125240224072421 to i8*
  call void @_ZdaPv(i8* %333) #8
  br label %if.end1240

if.end1240:                                       ; preds = %delete.notnull1238, %if.end1233
  %arraydecay1241 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistn_std, i64 0, i64 0
  %cmp1242 = icmp eq i32* %cond13624112417, %arraydecay1241
  br i1 %cmp1242, label %if.end1247, label %delete.notnull1245

delete.notnull1245:                               ; preds = %if.end1240
  %334 = bitcast i32* %cond13624112417 to i8*
  call void @_ZdaPv(i8* %334) #8
  br label %if.end1247

if.end1247:                                       ; preds = %delete.notnull1245, %if.end1240
  %arraydecay1248 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistx_std, i64 0, i64 0
  %cmp1249 = icmp eq i32* %cond1472423, %arraydecay1248
  br i1 %cmp1249, label %if.end1254, label %delete.notnull1252

delete.notnull1252:                               ; preds = %if.end1247
  %335 = bitcast i32* %cond1472423 to i8*
  call void @_ZdaPv(i8* %335) #8
  br label %if.end1254

if.end1254:                                       ; preds = %delete.notnull1252, %if.end1247
  %arraydecay1255 = getelementptr inbounds [1005 x i32], [1005 x i32]* %pairlistm_std, i64 0, i64 0
  %cmp1256 = icmp eq i32* %cond158, %arraydecay1255
  br i1 %cmp1256, label %if.end1261, label %delete.notnull1259

delete.notnull1259:                               ; preds = %if.end1254
  %336 = bitcast i32* %cond158 to i8*
  call void @_ZdaPv(i8* %336) #8
  br label %if.end1261

if.end1261:                                       ; preds = %delete.notnull1259, %if.end1254
  %conv1262 = sitofp i32 %exclChecksum.0.lcssa to double
  %arrayidx1263 = getelementptr inbounds double, double* %1, i64 22
  %337 = load double, double* %arrayidx1263, align 8, !tbaa !13
  %add1264 = fadd double %337, %conv1262
  store double %add1264, double* %arrayidx1263, align 8, !tbaa !13
  %arrayidx1265 = getelementptr inbounds double, double* %1, i64 2
  %338 = load double, double* %arrayidx1265, align 8, !tbaa !13
  %add1266 = fadd double %vdwEnergy.0.lcssa, %338
  store double %add1266, double* %arrayidx1265, align 8, !tbaa !13
  %339 = load double, double* %1, align 8, !tbaa !13
  %add1268 = fadd double %electEnergy.0.lcssa, %339
  store double %add1268, double* %1, align 8, !tbaa !13
  %arrayidx1269 = getelementptr inbounds double, double* %1, i64 3
  %340 = load double, double* %arrayidx1269, align 8, !tbaa !13
  %add1270 = fadd double %virial_xx.0.lcssa, %340
  store double %add1270, double* %arrayidx1269, align 8, !tbaa !13
  %arrayidx1271 = getelementptr inbounds double, double* %1, i64 4
  %341 = load double, double* %arrayidx1271, align 8, !tbaa !13
  %add1272 = fadd double %virial_xy.0.lcssa, %341
  store double %add1272, double* %arrayidx1271, align 8, !tbaa !13
  %arrayidx1273 = getelementptr inbounds double, double* %1, i64 5
  %342 = load double, double* %arrayidx1273, align 8, !tbaa !13
  %add1274 = fadd double %virial_xz.0.lcssa, %342
  store double %add1274, double* %arrayidx1273, align 8, !tbaa !13
  %arrayidx1275 = getelementptr inbounds double, double* %1, i64 6
  %343 = load double, double* %arrayidx1275, align 8, !tbaa !13
  %add1276 = fadd double %virial_xy.0.lcssa, %343
  store double %add1276, double* %arrayidx1275, align 8, !tbaa !13
  %arrayidx1277 = getelementptr inbounds double, double* %1, i64 7
  %344 = load double, double* %arrayidx1277, align 8, !tbaa !13
  %add1278 = fadd double %virial_yy.0.lcssa, %344
  store double %add1278, double* %arrayidx1277, align 8, !tbaa !13
  %arrayidx1279 = getelementptr inbounds double, double* %1, i64 8
  %345 = load double, double* %arrayidx1279, align 8, !tbaa !13
  %add1280 = fadd double %virial_yz.0.lcssa, %345
  store double %add1280, double* %arrayidx1279, align 8, !tbaa !13
  %arrayidx1281 = getelementptr inbounds double, double* %1, i64 9
  %346 = load double, double* %arrayidx1281, align 8, !tbaa !13
  %add1282 = fadd double %virial_xz.0.lcssa, %346
  store double %add1282, double* %arrayidx1281, align 8, !tbaa !13
  %arrayidx1283 = getelementptr inbounds double, double* %1, i64 10
  %347 = load double, double* %arrayidx1283, align 8, !tbaa !13
  %add1284 = fadd double %virial_yz.0.lcssa, %347
  store double %add1284, double* %arrayidx1283, align 8, !tbaa !13
  %arrayidx1285 = getelementptr inbounds double, double* %1, i64 11
  %348 = load double, double* %arrayidx1285, align 8, !tbaa !13
  %add1286 = fadd double %virial_zz.0.lcssa, %348
  store double %add1286, double* %arrayidx1285, align 8, !tbaa !13
  %arrayidx1287 = getelementptr inbounds double, double* %1, i64 1
  %349 = load double, double* %arrayidx1287, align 8, !tbaa !13
  %add1288 = fadd double %fullElectEnergy.0.lcssa, %349
  store double %add1288, double* %arrayidx1287, align 8, !tbaa !13
  %arrayidx1289 = getelementptr inbounds double, double* %1, i64 12
  %350 = load double, double* %arrayidx1289, align 8, !tbaa !13
  %add1290 = fadd double %fullElectVirial_xx.0.lcssa, %350
  store double %add1290, double* %arrayidx1289, align 8, !tbaa !13
  %arrayidx1291 = getelementptr inbounds double, double* %1, i64 13
  %351 = load double, double* %arrayidx1291, align 8, !tbaa !13
  %add1292 = fadd double %fullElectVirial_xy.0.lcssa, %351
  store double %add1292, double* %arrayidx1291, align 8, !tbaa !13
  %arrayidx1293 = getelementptr inbounds double, double* %1, i64 14
  %352 = load double, double* %arrayidx1293, align 8, !tbaa !13
  %add1294 = fadd double %fullElectVirial_xz.0.lcssa, %352
  store double %add1294, double* %arrayidx1293, align 8, !tbaa !13
  %arrayidx1295 = getelementptr inbounds double, double* %1, i64 15
  %353 = load double, double* %arrayidx1295, align 8, !tbaa !13
  %add1296 = fadd double %fullElectVirial_xy.0.lcssa, %353
  store double %add1296, double* %arrayidx1295, align 8, !tbaa !13
  %arrayidx1297 = getelementptr inbounds double, double* %1, i64 16
  %354 = load double, double* %arrayidx1297, align 8, !tbaa !13
  %add1298 = fadd double %fullElectVirial_yy.0.lcssa, %354
  store double %add1298, double* %arrayidx1297, align 8, !tbaa !13
  %arrayidx1299 = getelementptr inbounds double, double* %1, i64 17
  %355 = load double, double* %arrayidx1299, align 8, !tbaa !13
  %add1300 = fadd double %fullElectVirial_yz.0.lcssa, %355
  store double %add1300, double* %arrayidx1299, align 8, !tbaa !13
  %arrayidx1301 = getelementptr inbounds double, double* %1, i64 18
  %356 = load double, double* %arrayidx1301, align 8, !tbaa !13
  %add1302 = fadd double %fullElectVirial_xz.0.lcssa, %356
  store double %add1302, double* %arrayidx1301, align 8, !tbaa !13
  %arrayidx1303 = getelementptr inbounds double, double* %1, i64 19
  %357 = load double, double* %arrayidx1303, align 8, !tbaa !13
  %add1304 = fadd double %fullElectVirial_yz.0.lcssa, %357
  store double %add1304, double* %arrayidx1303, align 8, !tbaa !13
  %arrayidx1305 = getelementptr inbounds double, double* %1, i64 20
  %358 = load double, double* %arrayidx1305, align 8, !tbaa !13
  %add1306 = fadd double %fullElectVirial_zz.0.lcssa, %358
  store double %add1306, double* %arrayidx1305, align 8, !tbaa !13
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %41) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %40) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %39) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %38) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %37) #6
  br label %cleanup1307

cleanup1307:                                      ; preds = %if.end52.thread, %delete.notnull91, %if.end86, %if.end1261
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %19) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %18) #6
  call void @llvm.lifetime.end.p0i8(i64 4020, i8* nonnull %17) #6
  br label %cleanup.cont1357

cleanup.cont1357:                                 ; preds = %entry, %cleanup1307
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
declare %class.ExclusionCheck* @_ZNK8Molecule23get_excl_check_for_atomEi(%class.Molecule* nonnull align 8 dereferenceable(32), i32) local_unnamed_addr #5 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare zeroext i16 @_ZNK8Molecule11atomvdwtypeEi(%class.Molecule* nonnull align 8 dereferenceable(32), i32) local_unnamed_addr #5 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare %"struct.LJTable::TableEntry"* @_ZNK7LJTable9table_rowEj(%class.LJTable* nonnull align 8 dereferenceable(20), i32) local_unnamed_addr #5 align 2

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { nobuiltin optsize allocsize(0) "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nobuiltin nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }
attributes #7 = { builtin optsize allocsize(0) }
attributes #8 = { builtin nounwind optsize }
attributes #9 = { optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !10, i64 56}
!9 = !{!"_ZTS9nonbonded", !6, i64 0, !6, i64 16, !6, i64 32, !6, i64 48, !10, i64 56, !10, i64 64, !11, i64 72, !5, i64 96, !5, i64 100, !5, i64 104, !5, i64 108}
!10 = !{!"any pointer", !6, i64 0}
!11 = !{!"_ZTS6Vector", !12, i64 0, !12, i64 8, !12, i64 16}
!12 = !{!"double", !6, i64 0}
!13 = !{!12, !12, i64 0}
!14 = !{!10, !10, i64 0}
!15 = distinct !{!15, !16}
!16 = !{!"llvm.loop.unroll.disable"}
!17 = distinct !{!17, !16}
!18 = !{!9, !5, i64 100}
!19 = !{!9, !5, i64 108}
!20 = !{!9, !5, i64 104}
!21 = !{!22, !5, i64 0}
!22 = !{!"_ZTS14ExclusionCheck", !5, i64 0, !5, i64 4, !10, i64 8}
!23 = !{!22, !5, i64 4}
!24 = !{!22, !10, i64 8}
!25 = !{!26, !12, i64 0}
!26 = !{!"_ZTS8CompAtom", !11, i64 0, !27, i64 24, !5, i64 28, !5, i64 30, !5, i64 31, !5, i64 31, !5, i64 31, !5, i64 31}
!27 = !{!"float", !6, i64 0}
!28 = !{!26, !12, i64 8}
!29 = !{!26, !12, i64 16}
!30 = distinct !{!30, !16}
!31 = distinct !{!31, !16}
!32 = distinct !{!32, !16}
!33 = distinct !{!33, !16}
!34 = distinct !{!34, !16}
!35 = !{!26, !27, i64 24}
!36 = distinct !{!36, !16}
!37 = distinct !{!37, !16}
!38 = distinct !{!38, !16}
!39 = distinct !{!39, !16}
!40 = !{!6, !6, i64 0}
!41 = distinct !{!41, !16}
!42 = !{!43, !12, i64 0}
!43 = !{!"_ZTSN7LJTable10TableEntryE", !12, i64 0, !12, i64 8}
!44 = !{!43, !12, i64 8}
!45 = !{!11, !12, i64 0}
!46 = !{!11, !12, i64 8}
!47 = !{!11, !12, i64 16}
!48 = distinct !{!48, !16}
!49 = distinct !{!49, !16}
!50 = distinct !{!50, !16}
!51 = distinct !{!51, !16}
!52 = distinct !{!52, !16}
!53 = distinct !{!53, !16}
!54 = distinct !{!54, !16}
!55 = distinct !{!55, !16}
!56 = distinct !{!56, !16}
!57 = distinct !{!57, !16}
!58 = distinct !{!58, !16}
!59 = distinct !{!59, !16}
!60 = distinct !{!60, !16}
!61 = distinct !{!61, !16}
!62 = distinct !{!62, !16}
!63 = distinct !{!63, !16}
!64 = distinct !{!64, !16}
!65 = distinct !{!65, !16}
!66 = distinct !{!66, !16}
!67 = distinct !{!67, !16}
