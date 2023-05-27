; RUN: %opt -S --passes="mergefunc,multiple-func-merging" -func-merging-explore=1 --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm2-hyfm.ll %s
; RUN: %opt -S --passes="mergefunc,multiple-func-merging" -func-merging-explore=3 --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm4-hyfm.ll %s
; RUN: %llc --filetype=obj %t.mfm2-hyfm.ll -o %t.mfm2-hyfm.o
; RUN: %llc --filetype=obj %t.mfm4-hyfm.ll -o %t.mfm4-hyfm.o
; RUN: test $(stat -c%%s %t.mfm4-hyfm.o) -le $(stat -c%%s %t.mfm2-hyfm.o)

; When N=2
;   1. 2 similar functions found, and merged into __mf_merge_dslash_fn_on_temp_dslash_fn_on_temp_special
;      - Function:        dslash_fn_on_temp
;      - Function:        dslash_fn_on_temp_special
;   2. 2 similar functions found, but unprofitable to merge.
;      - Function:        __mf_merge_dslash_fn_on_temp_dslash_fn_on_temp_special
;      - Function:        dslash_fn_special
;   3. 2 similar functions found, and merged into __mf_merge_dslash_fn_special_dslash_fn
;      - Function:        dslash_fn_special
;      - Function:        dslash_fn

; When N=4
;   1. 4 similar functions found in the pairing phase.
;      - Function:        dslash_fn_on_temp
;      - Function:        dslash_fn_special
;      - Function:        dslash_fn
;      - Function:        dslash_fn_on_temp_special
;   1.1. Not profitable to merge
;      - Function:        dslash_fn_on_temp
;      - Function:        dslash_fn_special
;      - Function:        dslash_fn
;      - Function:        dslash_fn_on_temp_special
;   1.2. Not profitable to merge
;     - Function:        dslash_fn_on_temp
;     - Function:        dslash_fn_special
;     - Function:        dslash_fn_on_temp_special
;   1.3. Not profitable to merge
;     - Function:        dslash_fn_on_temp
;     - Function:        dslash_fn_special
;   1.4. Not profitable to merge
;     - Function:        dslash_fn_on_temp
;     - Function:        dslash_fn
;     - Function:        dslash_fn_on_temp_special
;   1.5. Not profitable to merge
;     - Function:        dslash_fn_on_temp
;     - Function:        dslash_fn
;   1.6. Not profitable to merge (14528 -> 13960 (-568))
;     - Function:        dslash_fn_on_temp
;     - Function:        dslash_fn_on_temp_special
;   1.7. Profitable to merge (15616 -> 14440 (-1176))
;     - Function:        dslash_fn_on_temp
;     - Function:        dslash_fn_special
;     - Function:        dslash_fn




; ModuleID = '../llvm-nextfm-benchmark/benchmarks/spec2006/433.milc/_main_._all_._files_._linked_.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.su3_vector = type { [3 x %struct.complex] }
%struct.complex = type { double, double }
%struct.su3_matrix = type { [3 x [3 x %struct.complex]] }
%struct.site = type { i16, i16, i16, i16, i8, i32, %struct.double_prn, i32, [4 x %struct.su3_matrix], [4 x %struct.su3_matrix], [4 x %struct.su3_matrix], [4 x %struct.anti_hermitmat], [4 x double], %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, [4 x %struct.su3_vector], [4 x %struct.su3_vector], %struct.su3_vector, %struct.su3_matrix, %struct.su3_matrix }
%struct.double_prn = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, double }
%struct.anti_hermitmat = type { %struct.complex, %struct.complex, %struct.complex, double, double, double, double }
%struct.su2_matrix = type { [2 x [2 x %struct.complex]] }
%struct.msg_tag = type { i32, i32, i8*, i32 }

@temp_not_allocated = external hidden unnamed_addr global i1, align 4
@temp = external hidden unnamed_addr global [9 x %struct.su3_vector*], align 16
@diffmat_offset = external local_unnamed_addr global i32, align 4
@diffmatp = external local_unnamed_addr global %struct.su3_matrix*, align 8
@sumvec_offset = external local_unnamed_addr global i32, align 4
@sumvecp = external local_unnamed_addr global %struct.su3_vector*, align 8
@even_sites_on_node = external local_unnamed_addr global i32, align 4
@valid_longlinks = external local_unnamed_addr global i32, align 4
@valid_fatlinks = external local_unnamed_addr global i32, align 4
@sites_on_node = external local_unnamed_addr global i32, align 4
@lattice = external local_unnamed_addr global %struct.site*, align 8
@gen_pt = external local_unnamed_addr global [16 x i8**], align 16

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @mult_adj_su3_mat_4vec(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector*, %struct.su3_vector*, %struct.su3_vector*, %struct.su3_vector*) local_unnamed_addr #2

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @sqrt(double) local_unnamed_addr #3

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare void @mult_su2_mat_vec_elem_n(%struct.su2_matrix* nocapture readonly, %struct.complex* nocapture, %struct.complex* nocapture) local_unnamed_addr #4

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare noalias noundef align 16 i8* @calloc(i64 noundef, i64 noundef) local_unnamed_addr #3

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #5

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare noalias %struct.msg_tag* @start_gather(i32, i32, i32, i32, i8** nocapture) local_unnamed_addr #6

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @restart_gather(i32, i32, i32, i32, i8** nocapture, %struct.msg_tag* nocapture) local_unnamed_addr #7

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare noalias %struct.msg_tag* @start_gather_from_temp(i8*, i32, i32, i32, i8** nocapture) local_unnamed_addr #6

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @restart_gather_from_temp(i8* nocapture, i32, i32, i32, i8** nocapture, %struct.msg_tag* nocapture) local_unnamed_addr #7

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @wait_gather(%struct.msg_tag* nocapture) local_unnamed_addr #7

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @cleanup_gather(%struct.msg_tag* nocapture) local_unnamed_addr #7

; Function Attrs: noinline nounwind optsize uwtable
define void @dslash_fn(i32 %src, i32 %dest, i32 %parity) local_unnamed_addr #8 {
entry:
  %tag = alloca [16 x %struct.msg_tag*], align 16
  %0 = bitcast [16 x %struct.msg_tag*]* %tag to i8*
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %0) #10
  %1 = load i32, i32* @valid_longlinks, align 4, !tbaa !4
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  tail call void (...) bitcast (void ()* @load_longlinks to void (...)*)() #11
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %2 = load i32, i32* @valid_fatlinks, align 4, !tbaa !4
  %tobool1.not = icmp eq i32 %2, 0
  br i1 %tobool1.not, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  tail call void (...) bitcast (void ()* @load_fatlinks to void (...)*)() #11
  br label %if.end3

if.end3:                                          ; preds = %if.then2, %if.end
  switch i32 %parity, label %sw.epilog [
    i32 3, label %sw.bb5
    i32 1, label %sw.bb4
  ]

sw.bb4:                                           ; preds = %if.end3
  br label %sw.epilog

sw.bb5:                                           ; preds = %if.end3
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end3, %sw.bb5, %sw.bb4
  %cmp15 = phi i1 [ false, %sw.bb5 ], [ true, %sw.bb4 ], [ false, %if.end3 ]
  %cmp16 = phi i1 [ false, %sw.bb5 ], [ false, %sw.bb4 ], [ true, %if.end3 ]
  br label %for.body

for.body:                                         ; preds = %sw.epilog, %for.body
  %indvars.iv351 = phi i64 [ 0, %sw.epilog ], [ %indvars.iv.next352, %for.body ]
  %arrayidx = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %indvars.iv351
  %3 = load i8**, i8*** %arrayidx, align 8, !tbaa !8
  %4 = trunc i64 %indvars.iv351 to i32
  %call = tail call %struct.msg_tag* @start_gather(i32 %src, i32 48, i32 %4, i32 %parity, i8** %3) #11
  %arrayidx7 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv351
  store %struct.msg_tag* %call, %struct.msg_tag** %arrayidx7, align 8, !tbaa !8
  %5 = add nuw nsw i64 %indvars.iv351, 8
  %arrayidx10 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %5
  %6 = load i8**, i8*** %arrayidx10, align 8, !tbaa !8
  %7 = trunc i64 %5 to i32
  %call11 = tail call %struct.msg_tag* @start_gather(i32 %src, i32 48, i32 %7, i32 %parity, i8** %6) #11
  %arrayidx14 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %5
  store %struct.msg_tag* %call11, %struct.msg_tag** %arrayidx14, align 8, !tbaa !8
  %indvars.iv.next352 = add nuw nsw i64 %indvars.iv351, 1
  %exitcond354.not = icmp eq i64 %indvars.iv.next352, 4
  br i1 %exitcond354.not, label %for.end, label %for.body, !llvm.loop !10

for.end:                                          ; preds = %for.body
  %8 = load i32, i32* @even_sites_on_node, align 4
  %9 = load i32, i32* @sites_on_node, align 4
  %cond = select i1 %cmp15, i32 %8, i32 %9
  %cond20 = select i1 %cmp16, i32 %8, i32 0
  %idx.ext = sext i32 %src to i64
  %cmp24315 = icmp slt i32 %cond20, %cond
  br i1 %cmp24315, label %for.body25.preheader, label %for.body36.preheader

for.body25.preheader:                             ; preds = %for.end
  %10 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %idxprom21 = sext i32 %cond20 to i64
  %arrayidx22 = getelementptr inbounds %struct.site, %struct.site* %10, i64 %idxprom21
  br label %for.body25

for.body25:                                       ; preds = %for.body25.preheader, %for.body25
  %i.0317 = phi i32 [ %inc32, %for.body25 ], [ %cond20, %for.body25.preheader ]
  %s.0316 = phi %struct.site* [ %incdec.ptr, %for.body25 ], [ %arrayidx22, %for.body25.preheader ]
  %arraydecay = getelementptr inbounds %struct.site, %struct.site* %s.0316, i64 0, i32 10, i64 0
  %arraydecay26 = getelementptr inbounds %struct.site, %struct.site* %s.0316, i64 0, i32 9, i64 0
  %11 = bitcast %struct.site* %s.0316 to i8*
  %add.ptr = getelementptr inbounds i8, i8* %11, i64 %idx.ext
  %12 = bitcast i8* %add.ptr to %struct.su3_vector*
  %arraydecay27 = getelementptr inbounds %struct.site, %struct.site* %s.0316, i64 0, i32 19, i64 0
  tail call void @mult_adj_su3_mat_vec_4dir(%struct.su3_matrix* nonnull %arraydecay, %struct.su3_vector* %12, %struct.su3_vector* nonnull %arraydecay27) #11
  %arraydecay30 = getelementptr inbounds %struct.site, %struct.site* %s.0316, i64 0, i32 20, i64 0
  tail call void @mult_adj_su3_mat_vec_4dir(%struct.su3_matrix* nonnull %arraydecay26, %struct.su3_vector* %12, %struct.su3_vector* nonnull %arraydecay30) #11
  %inc32 = add i32 %i.0317, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %s.0316, i64 1
  %exitcond350.not = icmp eq i32 %inc32, %cond
  br i1 %exitcond350.not, label %for.body36.preheader, label %for.body25, !llvm.loop !12

for.body36.preheader:                             ; preds = %for.body25, %for.end
  br label %for.body36

for.body36:                                       ; preds = %for.body36.preheader, %for.body36
  %indvars.iv344 = phi i64 [ %indvars.iv.next345, %for.body36 ], [ 0, %for.body36.preheader ]
  %dir.1314 = phi i32 [ %inc50, %for.body36 ], [ 0, %for.body36.preheader ]
  %13 = sub nuw nsw i64 7, %indvars.iv344
  %sub = sub nuw nsw i32 7, %dir.1314
  %arrayidx44 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %13
  %14 = load i8**, i8*** %arrayidx44, align 8, !tbaa !8
  %15 = trunc i64 %indvars.iv344 to i32
  %16 = mul i32 %15, 48
  %17 = add i32 %16, 2480
  %call45 = tail call %struct.msg_tag* @start_gather(i32 %17, i32 48, i32 %sub, i32 %parity, i8** %14) #11
  %arrayidx48 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %13
  store %struct.msg_tag* %call45, %struct.msg_tag** %arrayidx48, align 8, !tbaa !8
  %indvars.iv.next345 = add nuw nsw i64 %indvars.iv344, 1
  %inc50 = add nuw nsw i32 %dir.1314, 1
  %exitcond349.not = icmp eq i64 %indvars.iv.next345, 4
  br i1 %exitcond349.not, label %for.body55, label %for.body36, !llvm.loop !13

for.body55:                                       ; preds = %for.body36, %for.body55
  %indvars.iv339 = phi i64 [ %indvars.iv.next340, %for.body55 ], [ 8, %for.body36 ]
  %dir.2313 = phi i32 [ %inc75, %for.body55 ], [ 8, %for.body36 ]
  %18 = sub nuw nsw i64 23, %indvars.iv339
  %sub66 = sub nuw nsw i32 23, %dir.2313
  %arrayidx69 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %18
  %19 = load i8**, i8*** %arrayidx69, align 8, !tbaa !8
  %20 = trunc i64 %indvars.iv339 to i32
  %21 = mul i32 %20, 48
  %22 = add i32 %21, 2288
  %call70 = tail call %struct.msg_tag* @start_gather(i32 %22, i32 48, i32 %sub66, i32 %parity, i8** %19) #11
  %arrayidx73 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %18
  store %struct.msg_tag* %call70, %struct.msg_tag** %arrayidx73, align 8, !tbaa !8
  %indvars.iv.next340 = add nuw nsw i64 %indvars.iv339, 1
  %inc75 = add nuw nsw i32 %dir.2313, 1
  %exitcond343.not = icmp eq i64 %indvars.iv.next340, 12
  br i1 %exitcond343.not, label %for.body80, label %for.body55, !llvm.loop !14

for.body80:                                       ; preds = %for.body55, %for.body80
  %indvars.iv335 = phi i64 [ %indvars.iv.next336, %for.body80 ], [ 0, %for.body55 ]
  %arrayidx82 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv335
  %23 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx82, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %23) #11
  %24 = add nuw nsw i64 %indvars.iv335, 8
  %arrayidx85 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %24
  %25 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx85, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %25) #11
  %indvars.iv.next336 = add nuw nsw i64 %indvars.iv335, 1
  %exitcond338.not = icmp eq i64 %indvars.iv.next336, 4
  br i1 %exitcond338.not, label %for.body92, label %for.body80, !llvm.loop !15

for.body92:                                       ; preds = %for.body80, %for.body92
  %indvars.iv331 = phi i64 [ %indvars.iv.next332, %for.body92 ], [ 0, %for.body80 ]
  %26 = sub nuw nsw i64 7, %indvars.iv331
  %arrayidx95 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %26
  %27 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx95, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %27) #11
  %indvars.iv.next332 = add nuw nsw i64 %indvars.iv331, 1
  %exitcond334.not = icmp eq i64 %indvars.iv.next332, 4
  br i1 %exitcond334.not, label %for.body102, label %for.body92, !llvm.loop !16

for.body102:                                      ; preds = %for.body92, %for.body102
  %indvars.iv327 = phi i64 [ %indvars.iv.next328, %for.body102 ], [ 8, %for.body92 ]
  %28 = sub nuw nsw i64 23, %indvars.iv327
  %arrayidx105 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %28
  %29 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx105, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %29) #11
  %indvars.iv.next328 = add nuw nsw i64 %indvars.iv327, 1
  %exitcond330.not = icmp eq i64 %indvars.iv.next328, 12
  br i1 %exitcond330.not, label %for.end108, label %for.body102, !llvm.loop !17

for.end108:                                       ; preds = %for.body102
  %cmp110 = icmp eq i32 %parity, 2
  %30 = load i32, i32* @even_sites_on_node, align 4
  %31 = load i32, i32* @sites_on_node, align 4
  %cond115 = select i1 %cmp110, i32 %30, i32 %31
  %cmp116 = icmp eq i32 %parity, 1
  %cond121 = select i1 %cmp116, i32 %30, i32 0
  %idxprom122 = sext i32 %cond121 to i64
  %idx.ext140 = sext i32 %dest to i64
  %cmp125307 = icmp slt i32 %cond121, %cond115
  br i1 %cmp125307, label %for.body127.preheader, label %for.body181.preheader

for.body127.preheader:                            ; preds = %for.end108
  %32 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx123 = getelementptr inbounds %struct.site, %struct.site* %32, i64 %idxprom122
  br label %for.body127

for.body127:                                      ; preds = %for.body127.preheader, %for.body127
  %indvars.iv324 = phi i64 [ %idxprom122, %for.body127.preheader ], [ %indvars.iv.next325, %for.body127 ]
  %s.1308 = phi %struct.site* [ %arrayidx123, %for.body127.preheader ], [ %incdec.ptr176, %for.body127 ]
  %arraydecay129 = getelementptr inbounds %struct.site, %struct.site* %s.1308, i64 0, i32 10, i64 0
  %arraydecay131 = getelementptr inbounds %struct.site, %struct.site* %s.1308, i64 0, i32 9, i64 0
  %33 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 0), align 16, !tbaa !8
  %arrayidx133 = getelementptr inbounds i8*, i8** %33, i64 %indvars.iv324
  %34 = bitcast i8** %arrayidx133 to %struct.su3_vector**
  %35 = load %struct.su3_vector*, %struct.su3_vector** %34, align 8, !tbaa !8
  %36 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 1), align 8, !tbaa !8
  %arrayidx135 = getelementptr inbounds i8*, i8** %36, i64 %indvars.iv324
  %37 = bitcast i8** %arrayidx135 to %struct.su3_vector**
  %38 = load %struct.su3_vector*, %struct.su3_vector** %37, align 8, !tbaa !8
  %39 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 2), align 16, !tbaa !8
  %arrayidx137 = getelementptr inbounds i8*, i8** %39, i64 %indvars.iv324
  %40 = bitcast i8** %arrayidx137 to %struct.su3_vector**
  %41 = load %struct.su3_vector*, %struct.su3_vector** %40, align 8, !tbaa !8
  %42 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 3), align 8, !tbaa !8
  %arrayidx139 = getelementptr inbounds i8*, i8** %42, i64 %indvars.iv324
  %43 = bitcast i8** %arrayidx139 to %struct.su3_vector**
  %44 = load %struct.su3_vector*, %struct.su3_vector** %43, align 8, !tbaa !8
  %45 = bitcast %struct.site* %s.1308 to i8*
  %add.ptr141 = getelementptr inbounds i8, i8* %45, i64 %idx.ext140
  %46 = bitcast i8* %add.ptr141 to %struct.su3_vector*
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay129, %struct.su3_vector* %35, %struct.su3_vector* %38, %struct.su3_vector* %41, %struct.su3_vector* %44, %struct.su3_vector* %46) #11
  %47 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx143 = getelementptr inbounds i8*, i8** %47, i64 %indvars.iv324
  %48 = bitcast i8** %arrayidx143 to %struct.su3_vector**
  %49 = load %struct.su3_vector*, %struct.su3_vector** %48, align 8, !tbaa !8
  %50 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 9), align 8, !tbaa !8
  %arrayidx145 = getelementptr inbounds i8*, i8** %50, i64 %indvars.iv324
  %51 = bitcast i8** %arrayidx145 to %struct.su3_vector**
  %52 = load %struct.su3_vector*, %struct.su3_vector** %51, align 8, !tbaa !8
  %53 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 10), align 16, !tbaa !8
  %arrayidx147 = getelementptr inbounds i8*, i8** %53, i64 %indvars.iv324
  %54 = bitcast i8** %arrayidx147 to %struct.su3_vector**
  %55 = load %struct.su3_vector*, %struct.su3_vector** %54, align 8, !tbaa !8
  %56 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 11), align 8, !tbaa !8
  %arrayidx149 = getelementptr inbounds i8*, i8** %56, i64 %indvars.iv324
  %57 = bitcast i8** %arrayidx149 to %struct.su3_vector**
  %58 = load %struct.su3_vector*, %struct.su3_vector** %57, align 8, !tbaa !8
  %templongv1 = getelementptr inbounds %struct.site, %struct.site* %s.1308, i64 0, i32 21
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay131, %struct.su3_vector* %49, %struct.su3_vector* %52, %struct.su3_vector* %55, %struct.su3_vector* %58, %struct.su3_vector* nonnull %templongv1) #11
  %59 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 7), align 8, !tbaa !8
  %arrayidx153 = getelementptr inbounds i8*, i8** %59, i64 %indvars.iv324
  %60 = bitcast i8** %arrayidx153 to %struct.su3_vector**
  %61 = load %struct.su3_vector*, %struct.su3_vector** %60, align 8, !tbaa !8
  %62 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 6), align 16, !tbaa !8
  %arrayidx155 = getelementptr inbounds i8*, i8** %62, i64 %indvars.iv324
  %63 = bitcast i8** %arrayidx155 to %struct.su3_vector**
  %64 = load %struct.su3_vector*, %struct.su3_vector** %63, align 8, !tbaa !8
  %65 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 5), align 8, !tbaa !8
  %arrayidx157 = getelementptr inbounds i8*, i8** %65, i64 %indvars.iv324
  %66 = bitcast i8** %arrayidx157 to %struct.su3_vector**
  %67 = load %struct.su3_vector*, %struct.su3_vector** %66, align 8, !tbaa !8
  %68 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 4), align 16, !tbaa !8
  %arrayidx159 = getelementptr inbounds i8*, i8** %68, i64 %indvars.iv324
  %69 = bitcast i8** %arrayidx159 to %struct.su3_vector**
  %70 = load %struct.su3_vector*, %struct.su3_vector** %69, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* %46, %struct.su3_vector* %61, %struct.su3_vector* %64, %struct.su3_vector* %67, %struct.su3_vector* %70) #11
  %71 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 15), align 8, !tbaa !8
  %arrayidx162 = getelementptr inbounds i8*, i8** %71, i64 %indvars.iv324
  %72 = bitcast i8** %arrayidx162 to %struct.su3_vector**
  %73 = load %struct.su3_vector*, %struct.su3_vector** %72, align 8, !tbaa !8
  %74 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 14), align 16, !tbaa !8
  %arrayidx164 = getelementptr inbounds i8*, i8** %74, i64 %indvars.iv324
  %75 = bitcast i8** %arrayidx164 to %struct.su3_vector**
  %76 = load %struct.su3_vector*, %struct.su3_vector** %75, align 8, !tbaa !8
  %77 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 13), align 8, !tbaa !8
  %arrayidx166 = getelementptr inbounds i8*, i8** %77, i64 %indvars.iv324
  %78 = bitcast i8** %arrayidx166 to %struct.su3_vector**
  %79 = load %struct.su3_vector*, %struct.su3_vector** %78, align 8, !tbaa !8
  %80 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 12), align 16, !tbaa !8
  %arrayidx168 = getelementptr inbounds i8*, i8** %80, i64 %indvars.iv324
  %81 = bitcast i8** %arrayidx168 to %struct.su3_vector**
  %82 = load %struct.su3_vector*, %struct.su3_vector** %81, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* nonnull %templongv1, %struct.su3_vector* %73, %struct.su3_vector* %76, %struct.su3_vector* %79, %struct.su3_vector* %82) #11
  tail call void @add_su3_vector(%struct.su3_vector* %46, %struct.su3_vector* nonnull %templongv1, %struct.su3_vector* %46) #11
  %indvars.iv.next325 = add nsw i64 %indvars.iv324, 1
  %incdec.ptr176 = getelementptr inbounds %struct.site, %struct.site* %s.1308, i64 1
  %lftr.wideiv = trunc i64 %indvars.iv.next325 to i32
  %exitcond326.not = icmp eq i32 %cond115, %lftr.wideiv
  br i1 %exitcond326.not, label %for.body181.preheader, label %for.body127, !llvm.loop !18

for.body181.preheader:                            ; preds = %for.body127, %for.end108
  br label %for.body181

for.body181:                                      ; preds = %for.body181.preheader, %for.body181
  %indvars.iv320 = phi i64 [ %indvars.iv.next321, %for.body181 ], [ 0, %for.body181.preheader ]
  %arrayidx183 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv320
  %83 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx183, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %83) #11
  %84 = sub nuw nsw i64 7, %indvars.iv320
  %arrayidx186 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %84
  %85 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx186, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %85) #11
  %indvars.iv.next321 = add nuw nsw i64 %indvars.iv320, 1
  %exitcond323.not = icmp eq i64 %indvars.iv.next321, 4
  br i1 %exitcond323.not, label %for.body193, label %for.body181, !llvm.loop !19

for.body193:                                      ; preds = %for.body181, %for.body193
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body193 ], [ 8, %for.body181 ]
  %arrayidx195 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv
  %86 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx195, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %86) #11
  %87 = sub nuw nsw i64 23, %indvars.iv
  %arrayidx198 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %87
  %88 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx198, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %88) #11
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 12
  br i1 %exitcond.not, label %for.end201, label %for.body193, !llvm.loop !20

for.end201:                                       ; preds = %for.body193
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %0) #10
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @dslash_fn_special(i32 %src, i32 %dest, i32 %parity, %struct.msg_tag** nocapture %tag, i32 %start) local_unnamed_addr #8 {
entry:
  %0 = load i32, i32* @valid_longlinks, align 4, !tbaa !4
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  tail call void (...) bitcast (void ()* @load_longlinks to void (...)*)() #11
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %1 = load i32, i32* @valid_fatlinks, align 4, !tbaa !4
  %tobool1.not = icmp eq i32 %1, 0
  br i1 %tobool1.not, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  tail call void (...) bitcast (void ()* @load_fatlinks to void (...)*)() #11
  br label %if.end3

if.end3:                                          ; preds = %if.then2, %if.end
  switch i32 %parity, label %sw.epilog [
    i32 3, label %sw.bb5
    i32 1, label %sw.bb4
  ]

sw.bb4:                                           ; preds = %if.end3
  br label %sw.epilog

sw.bb5:                                           ; preds = %if.end3
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end3, %sw.bb5, %sw.bb4
  %cmp34 = phi i1 [ false, %sw.bb5 ], [ true, %sw.bb4 ], [ false, %if.end3 ]
  %cmp35 = phi i1 [ false, %sw.bb5 ], [ false, %sw.bb4 ], [ true, %if.end3 ]
  %cmp6 = icmp eq i32 %start, 1
  br label %for.body

for.body:                                         ; preds = %sw.epilog, %for.inc
  %indvars.iv430 = phi i64 [ 0, %sw.epilog ], [ %indvars.iv.next431, %for.inc ]
  %arrayidx = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %indvars.iv430
  %2 = load i8**, i8*** %arrayidx, align 8, !tbaa !8
  br i1 %cmp6, label %if.then7, label %if.else

if.then7:                                         ; preds = %for.body
  %3 = trunc i64 %indvars.iv430 to i32
  %call = tail call %struct.msg_tag* @start_gather(i32 %src, i32 48, i32 %3, i32 %parity, i8** %2) #11
  %arrayidx9 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv430
  store %struct.msg_tag* %call, %struct.msg_tag** %arrayidx9, align 8, !tbaa !8
  br label %for.inc

if.else:                                          ; preds = %for.body
  %arrayidx13 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv430
  %4 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx13, align 8, !tbaa !8
  %5 = trunc i64 %indvars.iv430 to i32
  tail call void @restart_gather(i32 %src, i32 48, i32 %5, i32 %parity, i8** %2, %struct.msg_tag* %4) #11
  br label %for.inc

for.inc:                                          ; preds = %if.then7, %if.else
  %indvars.iv.next431 = add nuw nsw i64 %indvars.iv430, 1
  %exitcond432.not = icmp eq i64 %indvars.iv.next431, 4
  br i1 %exitcond432.not, label %for.body17, label %for.body, !llvm.loop !21

for.body17:                                       ; preds = %for.inc, %for.inc31
  %indvars.iv427 = phi i64 [ %indvars.iv.next428, %for.inc31 ], [ 8, %for.inc ]
  %arrayidx21 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %indvars.iv427
  %6 = load i8**, i8*** %arrayidx21, align 8, !tbaa !8
  br i1 %cmp6, label %if.then19, label %if.else25

if.then19:                                        ; preds = %for.body17
  %7 = trunc i64 %indvars.iv427 to i32
  %call22 = tail call %struct.msg_tag* @start_gather(i32 %src, i32 48, i32 %7, i32 %parity, i8** %6) #11
  %arrayidx24 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv427
  store %struct.msg_tag* %call22, %struct.msg_tag** %arrayidx24, align 8, !tbaa !8
  br label %for.inc31

if.else25:                                        ; preds = %for.body17
  %arrayidx29 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv427
  %8 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx29, align 8, !tbaa !8
  %9 = trunc i64 %indvars.iv427 to i32
  tail call void @restart_gather(i32 %src, i32 48, i32 %9, i32 %parity, i8** %6, %struct.msg_tag* %8) #11
  br label %for.inc31

for.inc31:                                        ; preds = %if.then19, %if.else25
  %indvars.iv.next428 = add nuw nsw i64 %indvars.iv427, 1
  %exitcond429.not = icmp eq i64 %indvars.iv.next428, 12
  br i1 %exitcond429.not, label %for.end33, label %for.body17, !llvm.loop !22

for.end33:                                        ; preds = %for.inc31
  %10 = load i32, i32* @even_sites_on_node, align 4
  %11 = load i32, i32* @sites_on_node, align 4
  %cond = select i1 %cmp34, i32 %10, i32 %11
  %cond39 = select i1 %cmp35, i32 %10, i32 0
  %idx.ext = sext i32 %src to i64
  %cmp43389 = icmp slt i32 %cond39, %cond
  br i1 %cmp43389, label %for.body44.preheader, label %for.body55.preheader

for.body44.preheader:                             ; preds = %for.end33
  %12 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %idxprom40 = sext i32 %cond39 to i64
  %arrayidx41 = getelementptr inbounds %struct.site, %struct.site* %12, i64 %idxprom40
  br label %for.body44

for.body44:                                       ; preds = %for.body44.preheader, %for.body44
  %i.0391 = phi i32 [ %inc51, %for.body44 ], [ %cond39, %for.body44.preheader ]
  %s.0390 = phi %struct.site* [ %incdec.ptr, %for.body44 ], [ %arrayidx41, %for.body44.preheader ]
  %arraydecay = getelementptr inbounds %struct.site, %struct.site* %s.0390, i64 0, i32 10, i64 0
  %arraydecay45 = getelementptr inbounds %struct.site, %struct.site* %s.0390, i64 0, i32 9, i64 0
  %13 = bitcast %struct.site* %s.0390 to i8*
  %add.ptr = getelementptr inbounds i8, i8* %13, i64 %idx.ext
  %14 = bitcast i8* %add.ptr to %struct.su3_vector*
  %arraydecay46 = getelementptr inbounds %struct.site, %struct.site* %s.0390, i64 0, i32 19, i64 0
  tail call void @mult_adj_su3_mat_vec_4dir(%struct.su3_matrix* nonnull %arraydecay, %struct.su3_vector* %14, %struct.su3_vector* nonnull %arraydecay46) #11
  %arraydecay49 = getelementptr inbounds %struct.site, %struct.site* %s.0390, i64 0, i32 20, i64 0
  tail call void @mult_adj_su3_mat_vec_4dir(%struct.su3_matrix* nonnull %arraydecay45, %struct.su3_vector* %14, %struct.su3_vector* nonnull %arraydecay49) #11
  %inc51 = add i32 %i.0391, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %s.0390, i64 1
  %exitcond426.not = icmp eq i32 %inc51, %cond
  br i1 %exitcond426.not, label %for.body55.preheader, label %for.body44, !llvm.loop !23

for.body55.preheader:                             ; preds = %for.body44, %for.end33
  br label %for.body55

for.body55:                                       ; preds = %for.body55.preheader, %for.inc88
  %indvars.iv417 = phi i64 [ %indvars.iv.next418, %for.inc88 ], [ 0, %for.body55.preheader ]
  %dir.2387 = phi i32 [ %inc89, %for.inc88 ], [ 0, %for.body55.preheader ]
  %15 = sub nuw nsw i64 7, %indvars.iv417
  %sub = sub nuw nsw i32 7, %dir.2387
  %arrayidx65 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %15
  %16 = load i8**, i8*** %arrayidx65, align 8, !tbaa !8
  br i1 %cmp6, label %if.then57, label %if.else70

if.then57:                                        ; preds = %for.body55
  %17 = trunc i64 %indvars.iv417 to i32
  %18 = mul i32 %17, 48
  %19 = add i32 %18, 2480
  %call66 = tail call %struct.msg_tag* @start_gather(i32 %19, i32 48, i32 %sub, i32 %parity, i8** %16) #11
  %arrayidx69 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %15
  store %struct.msg_tag* %call66, %struct.msg_tag** %arrayidx69, align 8, !tbaa !8
  br label %for.inc88

if.else70:                                        ; preds = %for.body55
  %arrayidx86 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %15
  %20 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx86, align 8, !tbaa !8
  %21 = trunc i64 %indvars.iv417 to i32
  %22 = mul i32 %21, 48
  %23 = add i32 %22, 2480
  tail call void @restart_gather(i32 %23, i32 48, i32 %sub, i32 %parity, i8** %16, %struct.msg_tag* %20) #11
  br label %for.inc88

for.inc88:                                        ; preds = %if.then57, %if.else70
  %indvars.iv.next418 = add nuw nsw i64 %indvars.iv417, 1
  %inc89 = add nuw nsw i32 %dir.2387, 1
  %exitcond425.not = icmp eq i64 %indvars.iv.next418, 4
  br i1 %exitcond425.not, label %for.body94, label %for.body55, !llvm.loop !24

for.body94:                                       ; preds = %for.inc88, %for.inc135
  %indvars.iv410 = phi i64 [ %indvars.iv.next411, %for.inc135 ], [ 8, %for.inc88 ]
  %dir.3385 = phi i32 [ %inc136, %for.inc135 ], [ 8, %for.inc88 ]
  %24 = sub nuw nsw i64 23, %indvars.iv410
  %sub108 = sub nuw nsw i32 23, %dir.3385
  %arrayidx111 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %24
  %25 = load i8**, i8*** %arrayidx111, align 8, !tbaa !8
  br i1 %cmp6, label %if.then97, label %if.else116

if.then97:                                        ; preds = %for.body94
  %26 = trunc i64 %indvars.iv410 to i32
  %27 = mul i32 %26, 48
  %28 = add i32 %27, 2288
  %call112 = tail call %struct.msg_tag* @start_gather(i32 %28, i32 48, i32 %sub108, i32 %parity, i8** %25) #11
  %arrayidx115 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %24
  store %struct.msg_tag* %call112, %struct.msg_tag** %arrayidx115, align 8, !tbaa !8
  br label %for.inc135

if.else116:                                       ; preds = %for.body94
  %arrayidx133 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %24
  %29 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx133, align 8, !tbaa !8
  %30 = trunc i64 %indvars.iv410 to i32
  %31 = mul i32 %30, 48
  %32 = add i32 %31, 2288
  tail call void @restart_gather(i32 %32, i32 48, i32 %sub108, i32 %parity, i8** %25, %struct.msg_tag* %29) #11
  br label %for.inc135

for.inc135:                                       ; preds = %if.then97, %if.else116
  %indvars.iv.next411 = add nuw nsw i64 %indvars.iv410, 1
  %inc136 = add nuw nsw i32 %dir.3385, 1
  %exitcond416.not = icmp eq i64 %indvars.iv.next411, 12
  br i1 %exitcond416.not, label %for.body141, label %for.body94, !llvm.loop !25

for.body141:                                      ; preds = %for.inc135, %for.body141
  %indvars.iv407 = phi i64 [ %indvars.iv.next408, %for.body141 ], [ 0, %for.inc135 ]
  %arrayidx143 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv407
  %33 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx143, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %33) #11
  %indvars.iv.next408 = add nuw nsw i64 %indvars.iv407, 1
  %exitcond409.not = icmp eq i64 %indvars.iv.next408, 4
  br i1 %exitcond409.not, label %for.body150, label %for.body141, !llvm.loop !26

for.body150:                                      ; preds = %for.body141, %for.body150
  %indvars.iv404 = phi i64 [ %indvars.iv.next405, %for.body150 ], [ 8, %for.body141 ]
  %arrayidx152 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv404
  %34 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx152, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %34) #11
  %indvars.iv.next405 = add nuw nsw i64 %indvars.iv404, 1
  %exitcond406.not = icmp eq i64 %indvars.iv.next405, 12
  br i1 %exitcond406.not, label %for.body159, label %for.body150, !llvm.loop !27

for.body159:                                      ; preds = %for.body150, %for.body159
  %indvars.iv400 = phi i64 [ %indvars.iv.next401, %for.body159 ], [ 0, %for.body150 ]
  %35 = sub nuw nsw i64 7, %indvars.iv400
  %arrayidx162 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %35
  %36 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx162, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %36) #11
  %indvars.iv.next401 = add nuw nsw i64 %indvars.iv400, 1
  %exitcond403.not = icmp eq i64 %indvars.iv.next401, 4
  br i1 %exitcond403.not, label %for.body169, label %for.body159, !llvm.loop !28

for.body169:                                      ; preds = %for.body159, %for.body169
  %indvars.iv396 = phi i64 [ %indvars.iv.next397, %for.body169 ], [ 8, %for.body159 ]
  %37 = sub nuw nsw i64 23, %indvars.iv396
  %arrayidx172 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %37
  %38 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx172, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %38) #11
  %indvars.iv.next397 = add nuw nsw i64 %indvars.iv396, 1
  %exitcond399.not = icmp eq i64 %indvars.iv.next397, 12
  br i1 %exitcond399.not, label %for.end175, label %for.body169, !llvm.loop !29

for.end175:                                       ; preds = %for.body169
  %cmp177 = icmp eq i32 %parity, 2
  %39 = load i32, i32* @even_sites_on_node, align 4
  %40 = load i32, i32* @sites_on_node, align 4
  %cond182 = select i1 %cmp177, i32 %39, i32 %40
  %cmp183 = icmp eq i32 %parity, 1
  %cond188 = select i1 %cmp183, i32 %39, i32 0
  %idxprom189 = sext i32 %cond188 to i64
  %idx.ext207 = sext i32 %dest to i64
  %cmp192378 = icmp slt i32 %cond188, %cond182
  br i1 %cmp192378, label %for.body194.preheader, label %for.end244

for.body194.preheader:                            ; preds = %for.end175
  %41 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx190 = getelementptr inbounds %struct.site, %struct.site* %41, i64 %idxprom189
  br label %for.body194

for.body194:                                      ; preds = %for.body194.preheader, %for.body194
  %indvars.iv = phi i64 [ %idxprom189, %for.body194.preheader ], [ %indvars.iv.next, %for.body194 ]
  %s.1379 = phi %struct.site* [ %arrayidx190, %for.body194.preheader ], [ %incdec.ptr243, %for.body194 ]
  %arraydecay196 = getelementptr inbounds %struct.site, %struct.site* %s.1379, i64 0, i32 10, i64 0
  %arraydecay198 = getelementptr inbounds %struct.site, %struct.site* %s.1379, i64 0, i32 9, i64 0
  %42 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 0), align 16, !tbaa !8
  %arrayidx200 = getelementptr inbounds i8*, i8** %42, i64 %indvars.iv
  %43 = bitcast i8** %arrayidx200 to %struct.su3_vector**
  %44 = load %struct.su3_vector*, %struct.su3_vector** %43, align 8, !tbaa !8
  %45 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 1), align 8, !tbaa !8
  %arrayidx202 = getelementptr inbounds i8*, i8** %45, i64 %indvars.iv
  %46 = bitcast i8** %arrayidx202 to %struct.su3_vector**
  %47 = load %struct.su3_vector*, %struct.su3_vector** %46, align 8, !tbaa !8
  %48 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 2), align 16, !tbaa !8
  %arrayidx204 = getelementptr inbounds i8*, i8** %48, i64 %indvars.iv
  %49 = bitcast i8** %arrayidx204 to %struct.su3_vector**
  %50 = load %struct.su3_vector*, %struct.su3_vector** %49, align 8, !tbaa !8
  %51 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 3), align 8, !tbaa !8
  %arrayidx206 = getelementptr inbounds i8*, i8** %51, i64 %indvars.iv
  %52 = bitcast i8** %arrayidx206 to %struct.su3_vector**
  %53 = load %struct.su3_vector*, %struct.su3_vector** %52, align 8, !tbaa !8
  %54 = bitcast %struct.site* %s.1379 to i8*
  %add.ptr208 = getelementptr inbounds i8, i8* %54, i64 %idx.ext207
  %55 = bitcast i8* %add.ptr208 to %struct.su3_vector*
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay196, %struct.su3_vector* %44, %struct.su3_vector* %47, %struct.su3_vector* %50, %struct.su3_vector* %53, %struct.su3_vector* %55) #11
  %56 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx210 = getelementptr inbounds i8*, i8** %56, i64 %indvars.iv
  %57 = bitcast i8** %arrayidx210 to %struct.su3_vector**
  %58 = load %struct.su3_vector*, %struct.su3_vector** %57, align 8, !tbaa !8
  %59 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 9), align 8, !tbaa !8
  %arrayidx212 = getelementptr inbounds i8*, i8** %59, i64 %indvars.iv
  %60 = bitcast i8** %arrayidx212 to %struct.su3_vector**
  %61 = load %struct.su3_vector*, %struct.su3_vector** %60, align 8, !tbaa !8
  %62 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 10), align 16, !tbaa !8
  %arrayidx214 = getelementptr inbounds i8*, i8** %62, i64 %indvars.iv
  %63 = bitcast i8** %arrayidx214 to %struct.su3_vector**
  %64 = load %struct.su3_vector*, %struct.su3_vector** %63, align 8, !tbaa !8
  %65 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 11), align 8, !tbaa !8
  %arrayidx216 = getelementptr inbounds i8*, i8** %65, i64 %indvars.iv
  %66 = bitcast i8** %arrayidx216 to %struct.su3_vector**
  %67 = load %struct.su3_vector*, %struct.su3_vector** %66, align 8, !tbaa !8
  %templongv1 = getelementptr inbounds %struct.site, %struct.site* %s.1379, i64 0, i32 21
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay198, %struct.su3_vector* %58, %struct.su3_vector* %61, %struct.su3_vector* %64, %struct.su3_vector* %67, %struct.su3_vector* nonnull %templongv1) #11
  %68 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 7), align 8, !tbaa !8
  %arrayidx220 = getelementptr inbounds i8*, i8** %68, i64 %indvars.iv
  %69 = bitcast i8** %arrayidx220 to %struct.su3_vector**
  %70 = load %struct.su3_vector*, %struct.su3_vector** %69, align 8, !tbaa !8
  %71 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 6), align 16, !tbaa !8
  %arrayidx222 = getelementptr inbounds i8*, i8** %71, i64 %indvars.iv
  %72 = bitcast i8** %arrayidx222 to %struct.su3_vector**
  %73 = load %struct.su3_vector*, %struct.su3_vector** %72, align 8, !tbaa !8
  %74 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 5), align 8, !tbaa !8
  %arrayidx224 = getelementptr inbounds i8*, i8** %74, i64 %indvars.iv
  %75 = bitcast i8** %arrayidx224 to %struct.su3_vector**
  %76 = load %struct.su3_vector*, %struct.su3_vector** %75, align 8, !tbaa !8
  %77 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 4), align 16, !tbaa !8
  %arrayidx226 = getelementptr inbounds i8*, i8** %77, i64 %indvars.iv
  %78 = bitcast i8** %arrayidx226 to %struct.su3_vector**
  %79 = load %struct.su3_vector*, %struct.su3_vector** %78, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* %55, %struct.su3_vector* %70, %struct.su3_vector* %73, %struct.su3_vector* %76, %struct.su3_vector* %79) #11
  %80 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 15), align 8, !tbaa !8
  %arrayidx229 = getelementptr inbounds i8*, i8** %80, i64 %indvars.iv
  %81 = bitcast i8** %arrayidx229 to %struct.su3_vector**
  %82 = load %struct.su3_vector*, %struct.su3_vector** %81, align 8, !tbaa !8
  %83 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 14), align 16, !tbaa !8
  %arrayidx231 = getelementptr inbounds i8*, i8** %83, i64 %indvars.iv
  %84 = bitcast i8** %arrayidx231 to %struct.su3_vector**
  %85 = load %struct.su3_vector*, %struct.su3_vector** %84, align 8, !tbaa !8
  %86 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 13), align 8, !tbaa !8
  %arrayidx233 = getelementptr inbounds i8*, i8** %86, i64 %indvars.iv
  %87 = bitcast i8** %arrayidx233 to %struct.su3_vector**
  %88 = load %struct.su3_vector*, %struct.su3_vector** %87, align 8, !tbaa !8
  %89 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 12), align 16, !tbaa !8
  %arrayidx235 = getelementptr inbounds i8*, i8** %89, i64 %indvars.iv
  %90 = bitcast i8** %arrayidx235 to %struct.su3_vector**
  %91 = load %struct.su3_vector*, %struct.su3_vector** %90, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* nonnull %templongv1, %struct.su3_vector* %82, %struct.su3_vector* %85, %struct.su3_vector* %88, %struct.su3_vector* %91) #11
  tail call void @add_su3_vector(%struct.su3_vector* %55, %struct.su3_vector* nonnull %templongv1, %struct.su3_vector* %55) #11
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %incdec.ptr243 = getelementptr inbounds %struct.site, %struct.site* %s.1379, i64 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond.not = icmp eq i32 %cond182, %lftr.wideiv
  br i1 %exitcond.not, label %for.end244, label %for.body194, !llvm.loop !30

for.end244:                                       ; preds = %for.body194, %for.end175
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @dslash_fn_on_temp(%struct.su3_vector* %src, %struct.su3_vector* %dest, i32 %parity) local_unnamed_addr #8 {
entry:
  %tag = alloca [16 x %struct.msg_tag*], align 16
  %tempvec = alloca [4 x %struct.su3_vector*], align 16
  %templongvec = alloca [4 x %struct.su3_vector*], align 16
  %0 = bitcast [16 x %struct.msg_tag*]* %tag to i8*
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %0) #10
  %1 = bitcast [4 x %struct.su3_vector*]* %tempvec to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %1) #10
  %2 = bitcast [4 x %struct.su3_vector*]* %templongvec to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %2) #10
  %3 = load i32, i32* @sites_on_node, align 4, !tbaa !4
  %conv = sext i32 %3 to i64
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv464 = phi i64 [ 0, %entry ], [ %indvars.iv.next465, %for.body ]
  %call = tail call noalias align 16 i8* @calloc(i64 %conv, i64 48) #11
  %arrayidx = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 %indvars.iv464
  %4 = bitcast %struct.su3_vector** %arrayidx to i8**
  store i8* %call, i8** %4, align 8, !tbaa !8
  %call2 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 48) #11
  %arrayidx4 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 %indvars.iv464
  %5 = bitcast %struct.su3_vector** %arrayidx4 to i8**
  store i8* %call2, i8** %5, align 8, !tbaa !8
  %indvars.iv.next465 = add nuw nsw i64 %indvars.iv464, 1
  %exitcond466.not = icmp eq i64 %indvars.iv.next465, 4
  br i1 %exitcond466.not, label %for.end, label %for.body, !llvm.loop !31

for.end:                                          ; preds = %for.body
  %call6 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 48) #11
  %6 = bitcast i8* %call6 to %struct.su3_vector*
  %7 = load i32, i32* @valid_longlinks, align 4, !tbaa !4
  %tobool.not = icmp eq i32 %7, 0
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  tail call void (...) bitcast (void ()* @load_longlinks to void (...)*)() #11
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  %8 = load i32, i32* @valid_fatlinks, align 4, !tbaa !4
  %tobool7.not = icmp eq i32 %8, 0
  br i1 %tobool7.not, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end
  tail call void (...) bitcast (void ()* @load_fatlinks to void (...)*)() #11
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.end
  switch i32 %parity, label %sw.epilog [
    i32 3, label %sw.bb11
    i32 1, label %sw.bb10
  ]

sw.bb10:                                          ; preds = %if.end9
  br label %sw.epilog

sw.bb11:                                          ; preds = %if.end9
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end9, %sw.bb11, %sw.bb10
  %cmp31 = phi i1 [ false, %sw.bb11 ], [ true, %sw.bb10 ], [ false, %if.end9 ]
  %cmp33 = phi i1 [ false, %sw.bb11 ], [ false, %sw.bb10 ], [ true, %if.end9 ]
  %9 = bitcast %struct.su3_vector* %src to i8*
  br label %for.body15

for.body15:                                       ; preds = %sw.epilog, %for.body15
  %indvars.iv460 = phi i64 [ 0, %sw.epilog ], [ %indvars.iv.next461, %for.body15 ]
  %arrayidx17 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %indvars.iv460
  %10 = load i8**, i8*** %arrayidx17, align 8, !tbaa !8
  %11 = trunc i64 %indvars.iv460 to i32
  %call18 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %9, i32 48, i32 %11, i32 %parity, i8** %10) #11
  %arrayidx20 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv460
  store %struct.msg_tag* %call18, %struct.msg_tag** %arrayidx20, align 8, !tbaa !8
  %12 = add nuw nsw i64 %indvars.iv460, 8
  %arrayidx23 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %12
  %13 = load i8**, i8*** %arrayidx23, align 8, !tbaa !8
  %14 = trunc i64 %12 to i32
  %call24 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %9, i32 48, i32 %14, i32 %parity, i8** %13) #11
  %arrayidx27 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %12
  store %struct.msg_tag* %call24, %struct.msg_tag** %arrayidx27, align 8, !tbaa !8
  %indvars.iv.next461 = add nuw nsw i64 %indvars.iv460, 1
  %exitcond463.not = icmp eq i64 %indvars.iv.next461, 4
  br i1 %exitcond463.not, label %for.end30, label %for.body15, !llvm.loop !32

for.end30:                                        ; preds = %for.body15
  %15 = load i32, i32* @even_sites_on_node, align 4
  %16 = load i32, i32* @sites_on_node, align 4
  %cond = select i1 %cmp31, i32 %15, i32 %16
  %cond38 = select i1 %cmp33, i32 %15, i32 0
  %idxprom39 = sext i32 %cond38 to i64
  %arrayidx48 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 0
  %17 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx48, align 16
  %arrayidx51 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 1
  %18 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx51, align 8
  %arrayidx54 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 2
  %19 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx54, align 16
  %arrayidx57 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 3
  %20 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx57, align 8
  %arrayidx62 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 0
  %21 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx62, align 16
  %arrayidx65 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 1
  %22 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx65, align 8
  %arrayidx68 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 2
  %23 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx68, align 16
  %arrayidx71 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 3
  %24 = load %struct.su3_vector*, %struct.su3_vector** %arrayidx71, align 8
  %cmp42415 = icmp slt i32 %cond38, %cond
  br i1 %cmp42415, label %for.body44.preheader, label %for.body80.preheader

for.body44.preheader:                             ; preds = %for.end30
  %25 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx40 = getelementptr inbounds %struct.site, %struct.site* %25, i64 %idxprom39
  br label %for.body44

for.body44:                                       ; preds = %for.body44.preheader, %for.body44
  %indvars.iv456 = phi i64 [ %idxprom39, %for.body44.preheader ], [ %indvars.iv.next457, %for.body44 ]
  %s.0416 = phi %struct.site* [ %arrayidx40, %for.body44.preheader ], [ %incdec.ptr, %for.body44 ]
  %arraydecay = getelementptr inbounds %struct.site, %struct.site* %s.0416, i64 0, i32 10, i64 0
  %arraydecay45 = getelementptr inbounds %struct.site, %struct.site* %s.0416, i64 0, i32 9, i64 0
  %arrayidx47 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %src, i64 %indvars.iv456
  %arrayidx50 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %17, i64 %indvars.iv456
  %arrayidx53 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %18, i64 %indvars.iv456
  %arrayidx56 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %19, i64 %indvars.iv456
  %arrayidx59 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %20, i64 %indvars.iv456
  tail call void @mult_adj_su3_mat_4vec(%struct.su3_matrix* nonnull %arraydecay, %struct.su3_vector* %arrayidx47, %struct.su3_vector* %arrayidx50, %struct.su3_vector* %arrayidx53, %struct.su3_vector* %arrayidx56, %struct.su3_vector* %arrayidx59) #11
  %arrayidx64 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %21, i64 %indvars.iv456
  %arrayidx67 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %22, i64 %indvars.iv456
  %arrayidx70 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %23, i64 %indvars.iv456
  %arrayidx73 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %24, i64 %indvars.iv456
  tail call void @mult_adj_su3_mat_4vec(%struct.su3_matrix* nonnull %arraydecay45, %struct.su3_vector* %arrayidx47, %struct.su3_vector* %arrayidx64, %struct.su3_vector* %arrayidx67, %struct.su3_vector* %arrayidx70, %struct.su3_vector* %arrayidx73) #11
  %indvars.iv.next457 = add nsw i64 %indvars.iv456, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %s.0416, i64 1
  %lftr.wideiv458 = trunc i64 %indvars.iv.next457 to i32
  %exitcond459.not = icmp eq i32 %cond, %lftr.wideiv458
  br i1 %exitcond459.not, label %for.body80.preheader, label %for.body44, !llvm.loop !33

for.body80.preheader:                             ; preds = %for.body44, %for.end30
  br label %for.body80

for.body80:                                       ; preds = %for.body80.preheader, %for.body80
  %indvars.iv452 = phi i64 [ %indvars.iv.next453, %for.body80 ], [ 0, %for.body80.preheader ]
  %arrayidx82 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 %indvars.iv452
  %26 = bitcast %struct.su3_vector** %arrayidx82 to i8**
  %27 = load i8*, i8** %26, align 8, !tbaa !8
  %28 = sub nuw nsw i64 7, %indvars.iv452
  %arrayidx85 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %28
  %29 = load i8**, i8*** %arrayidx85, align 8, !tbaa !8
  %30 = trunc i64 %28 to i32
  %call86 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %27, i32 48, i32 %30, i32 %parity, i8** %29) #11
  %arrayidx89 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %28
  store %struct.msg_tag* %call86, %struct.msg_tag** %arrayidx89, align 8, !tbaa !8
  %indvars.iv.next453 = add nuw nsw i64 %indvars.iv452, 1
  %exitcond455.not = icmp eq i64 %indvars.iv.next453, 4
  br i1 %exitcond455.not, label %for.body96, label %for.body80, !llvm.loop !34

for.body96:                                       ; preds = %for.body80, %for.body96
  %indvars.iv447 = phi i64 [ %indvars.iv.next448, %for.body96 ], [ 8, %for.body80 ]
  %31 = add nsw i64 %indvars.iv447, -8
  %arrayidx99 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 %31
  %32 = bitcast %struct.su3_vector** %arrayidx99 to i8**
  %33 = load i8*, i8** %32, align 8, !tbaa !8
  %34 = sub nuw nsw i64 23, %indvars.iv447
  %arrayidx103 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %34
  %35 = load i8**, i8*** %arrayidx103, align 8, !tbaa !8
  %36 = trunc i64 %34 to i32
  %call104 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %33, i32 48, i32 %36, i32 %parity, i8** %35) #11
  %arrayidx107 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %34
  store %struct.msg_tag* %call104, %struct.msg_tag** %arrayidx107, align 8, !tbaa !8
  %indvars.iv.next448 = add nuw nsw i64 %indvars.iv447, 1
  %exitcond451.not = icmp eq i64 %indvars.iv.next448, 12
  br i1 %exitcond451.not, label %for.body114, label %for.body96, !llvm.loop !35

for.body114:                                      ; preds = %for.body96, %for.body114
  %indvars.iv443 = phi i64 [ %indvars.iv.next444, %for.body114 ], [ 0, %for.body96 ]
  %arrayidx116 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv443
  %37 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx116, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %37) #11
  %38 = add nuw nsw i64 %indvars.iv443, 8
  %arrayidx119 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %38
  %39 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx119, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %39) #11
  %indvars.iv.next444 = add nuw nsw i64 %indvars.iv443, 1
  %exitcond446.not = icmp eq i64 %indvars.iv.next444, 4
  br i1 %exitcond446.not, label %for.end122, label %for.body114, !llvm.loop !36

for.end122:                                       ; preds = %for.body114
  %cmp124 = icmp eq i32 %parity, 2
  %40 = load i32, i32* @even_sites_on_node, align 4
  %41 = load i32, i32* @sites_on_node, align 4
  %cond129 = select i1 %cmp124, i32 %40, i32 %41
  %cmp130 = icmp eq i32 %parity, 1
  %cond135 = select i1 %cmp130, i32 %40, i32 0
  %idxprom136 = sext i32 %cond135 to i64
  %cmp139409 = icmp slt i32 %cond135, %cond129
  br i1 %cmp139409, label %for.body141.preheader, label %for.body173.preheader

for.body141.preheader:                            ; preds = %for.end122
  %42 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx137 = getelementptr inbounds %struct.site, %struct.site* %42, i64 %idxprom136
  br label %for.body141

for.body141:                                      ; preds = %for.body141.preheader, %for.body141
  %indvars.iv439 = phi i64 [ %idxprom136, %for.body141.preheader ], [ %indvars.iv.next440, %for.body141 ]
  %s.1410 = phi %struct.site* [ %arrayidx137, %for.body141.preheader ], [ %incdec.ptr168, %for.body141 ]
  %arraydecay143 = getelementptr inbounds %struct.site, %struct.site* %s.1410, i64 0, i32 10, i64 0
  %arraydecay145 = getelementptr inbounds %struct.site, %struct.site* %s.1410, i64 0, i32 9, i64 0
  %43 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 0), align 16, !tbaa !8
  %arrayidx147 = getelementptr inbounds i8*, i8** %43, i64 %indvars.iv439
  %44 = bitcast i8** %arrayidx147 to %struct.su3_vector**
  %45 = load %struct.su3_vector*, %struct.su3_vector** %44, align 8, !tbaa !8
  %46 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 1), align 8, !tbaa !8
  %arrayidx149 = getelementptr inbounds i8*, i8** %46, i64 %indvars.iv439
  %47 = bitcast i8** %arrayidx149 to %struct.su3_vector**
  %48 = load %struct.su3_vector*, %struct.su3_vector** %47, align 8, !tbaa !8
  %49 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 2), align 16, !tbaa !8
  %arrayidx151 = getelementptr inbounds i8*, i8** %49, i64 %indvars.iv439
  %50 = bitcast i8** %arrayidx151 to %struct.su3_vector**
  %51 = load %struct.su3_vector*, %struct.su3_vector** %50, align 8, !tbaa !8
  %52 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 3), align 8, !tbaa !8
  %arrayidx153 = getelementptr inbounds i8*, i8** %52, i64 %indvars.iv439
  %53 = bitcast i8** %arrayidx153 to %struct.su3_vector**
  %54 = load %struct.su3_vector*, %struct.su3_vector** %53, align 8, !tbaa !8
  %arrayidx155 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %dest, i64 %indvars.iv439
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay143, %struct.su3_vector* %45, %struct.su3_vector* %48, %struct.su3_vector* %51, %struct.su3_vector* %54, %struct.su3_vector* %arrayidx155) #11
  %55 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx157 = getelementptr inbounds i8*, i8** %55, i64 %indvars.iv439
  %56 = bitcast i8** %arrayidx157 to %struct.su3_vector**
  %57 = load %struct.su3_vector*, %struct.su3_vector** %56, align 8, !tbaa !8
  %58 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 9), align 8, !tbaa !8
  %arrayidx159 = getelementptr inbounds i8*, i8** %58, i64 %indvars.iv439
  %59 = bitcast i8** %arrayidx159 to %struct.su3_vector**
  %60 = load %struct.su3_vector*, %struct.su3_vector** %59, align 8, !tbaa !8
  %61 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 10), align 16, !tbaa !8
  %arrayidx161 = getelementptr inbounds i8*, i8** %61, i64 %indvars.iv439
  %62 = bitcast i8** %arrayidx161 to %struct.su3_vector**
  %63 = load %struct.su3_vector*, %struct.su3_vector** %62, align 8, !tbaa !8
  %64 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 11), align 8, !tbaa !8
  %arrayidx163 = getelementptr inbounds i8*, i8** %64, i64 %indvars.iv439
  %65 = bitcast i8** %arrayidx163 to %struct.su3_vector**
  %66 = load %struct.su3_vector*, %struct.su3_vector** %65, align 8, !tbaa !8
  %arrayidx165 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %6, i64 %indvars.iv439
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay145, %struct.su3_vector* %57, %struct.su3_vector* %60, %struct.su3_vector* %63, %struct.su3_vector* %66, %struct.su3_vector* %arrayidx165) #11
  %indvars.iv.next440 = add nsw i64 %indvars.iv439, 1
  %incdec.ptr168 = getelementptr inbounds %struct.site, %struct.site* %s.1410, i64 1
  %lftr.wideiv441 = trunc i64 %indvars.iv.next440 to i32
  %exitcond442.not = icmp eq i32 %cond129, %lftr.wideiv441
  br i1 %exitcond442.not, label %for.body173.preheader, label %for.body141, !llvm.loop !37

for.body173.preheader:                            ; preds = %for.body141, %for.end122
  br label %for.body173

for.body173:                                      ; preds = %for.body173.preheader, %for.body173
  %indvars.iv435 = phi i64 [ %indvars.iv.next436, %for.body173 ], [ 0, %for.body173.preheader ]
  %67 = sub nuw nsw i64 7, %indvars.iv435
  %arrayidx176 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %67
  %68 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx176, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %68) #11
  %indvars.iv.next436 = add nuw nsw i64 %indvars.iv435, 1
  %exitcond438.not = icmp eq i64 %indvars.iv.next436, 4
  br i1 %exitcond438.not, label %for.body183, label %for.body173, !llvm.loop !38

for.body183:                                      ; preds = %for.body173, %for.body183
  %indvars.iv431 = phi i64 [ %indvars.iv.next432, %for.body183 ], [ 8, %for.body173 ]
  %69 = sub nuw nsw i64 23, %indvars.iv431
  %arrayidx186 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %69
  %70 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx186, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %70) #11
  %indvars.iv.next432 = add nuw nsw i64 %indvars.iv431, 1
  %exitcond434.not = icmp eq i64 %indvars.iv.next432, 12
  br i1 %exitcond434.not, label %for.end189, label %for.body183, !llvm.loop !39

for.end189:                                       ; preds = %for.body183
  %71 = load i32, i32* @even_sites_on_node, align 4
  %72 = load i32, i32* @sites_on_node, align 4
  %cond196 = select i1 %cmp124, i32 %71, i32 %72
  %cond202 = select i1 %cmp130, i32 %71, i32 0
  %cmp206405 = icmp slt i32 %cond202, %cond196
  br i1 %cmp206405, label %for.body208.preheader, label %for.body242.preheader

for.body208.preheader:                            ; preds = %for.end189
  %73 = sext i32 %cond202 to i64
  br label %for.body208

for.body208:                                      ; preds = %for.body208.preheader, %for.body208
  %indvars.iv428 = phi i64 [ %73, %for.body208.preheader ], [ %indvars.iv.next429, %for.body208 ]
  %arrayidx210 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %dest, i64 %indvars.iv428
  %74 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 7), align 8, !tbaa !8
  %arrayidx212 = getelementptr inbounds i8*, i8** %74, i64 %indvars.iv428
  %75 = bitcast i8** %arrayidx212 to %struct.su3_vector**
  %76 = load %struct.su3_vector*, %struct.su3_vector** %75, align 8, !tbaa !8
  %77 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 6), align 16, !tbaa !8
  %arrayidx214 = getelementptr inbounds i8*, i8** %77, i64 %indvars.iv428
  %78 = bitcast i8** %arrayidx214 to %struct.su3_vector**
  %79 = load %struct.su3_vector*, %struct.su3_vector** %78, align 8, !tbaa !8
  %80 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 5), align 8, !tbaa !8
  %arrayidx216 = getelementptr inbounds i8*, i8** %80, i64 %indvars.iv428
  %81 = bitcast i8** %arrayidx216 to %struct.su3_vector**
  %82 = load %struct.su3_vector*, %struct.su3_vector** %81, align 8, !tbaa !8
  %83 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 4), align 16, !tbaa !8
  %arrayidx218 = getelementptr inbounds i8*, i8** %83, i64 %indvars.iv428
  %84 = bitcast i8** %arrayidx218 to %struct.su3_vector**
  %85 = load %struct.su3_vector*, %struct.su3_vector** %84, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* %arrayidx210, %struct.su3_vector* %76, %struct.su3_vector* %79, %struct.su3_vector* %82, %struct.su3_vector* %85) #11
  %arrayidx220 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %6, i64 %indvars.iv428
  %86 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 15), align 8, !tbaa !8
  %arrayidx222 = getelementptr inbounds i8*, i8** %86, i64 %indvars.iv428
  %87 = bitcast i8** %arrayidx222 to %struct.su3_vector**
  %88 = load %struct.su3_vector*, %struct.su3_vector** %87, align 8, !tbaa !8
  %89 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 14), align 16, !tbaa !8
  %arrayidx224 = getelementptr inbounds i8*, i8** %89, i64 %indvars.iv428
  %90 = bitcast i8** %arrayidx224 to %struct.su3_vector**
  %91 = load %struct.su3_vector*, %struct.su3_vector** %90, align 8, !tbaa !8
  %92 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 13), align 8, !tbaa !8
  %arrayidx226 = getelementptr inbounds i8*, i8** %92, i64 %indvars.iv428
  %93 = bitcast i8** %arrayidx226 to %struct.su3_vector**
  %94 = load %struct.su3_vector*, %struct.su3_vector** %93, align 8, !tbaa !8
  %95 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 12), align 16, !tbaa !8
  %arrayidx228 = getelementptr inbounds i8*, i8** %95, i64 %indvars.iv428
  %96 = bitcast i8** %arrayidx228 to %struct.su3_vector**
  %97 = load %struct.su3_vector*, %struct.su3_vector** %96, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* %arrayidx220, %struct.su3_vector* %88, %struct.su3_vector* %91, %struct.su3_vector* %94, %struct.su3_vector* %97) #11
  tail call void @add_su3_vector(%struct.su3_vector* %arrayidx210, %struct.su3_vector* %arrayidx220, %struct.su3_vector* %arrayidx210) #11
  %indvars.iv.next429 = add nsw i64 %indvars.iv428, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next429 to i32
  %exitcond430.not = icmp eq i32 %cond196, %lftr.wideiv
  br i1 %exitcond430.not, label %for.body242.preheader, label %for.body208, !llvm.loop !40

for.body242.preheader:                            ; preds = %for.body208, %for.end189
  br label %for.body242

for.body242:                                      ; preds = %for.body242.preheader, %for.body242
  %indvars.iv424 = phi i64 [ %indvars.iv.next425, %for.body242 ], [ 0, %for.body242.preheader ]
  %arrayidx244 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv424
  %98 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx244, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %98) #11
  %99 = sub nuw nsw i64 7, %indvars.iv424
  %arrayidx247 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %99
  %100 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx247, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %100) #11
  %indvars.iv.next425 = add nuw nsw i64 %indvars.iv424, 1
  %exitcond427.not = icmp eq i64 %indvars.iv.next425, 4
  br i1 %exitcond427.not, label %for.body254, label %for.body242, !llvm.loop !41

for.body254:                                      ; preds = %for.body242, %for.body254
  %indvars.iv420 = phi i64 [ %indvars.iv.next421, %for.body254 ], [ 8, %for.body242 ]
  %arrayidx256 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %indvars.iv420
  %101 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx256, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %101) #11
  %102 = sub nuw nsw i64 23, %indvars.iv420
  %arrayidx259 = getelementptr inbounds [16 x %struct.msg_tag*], [16 x %struct.msg_tag*]* %tag, i64 0, i64 %102
  %103 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx259, align 8, !tbaa !8
  tail call void @cleanup_gather(%struct.msg_tag* %103) #11
  %indvars.iv.next421 = add nuw nsw i64 %indvars.iv420, 1
  %exitcond423.not = icmp eq i64 %indvars.iv.next421, 12
  br i1 %exitcond423.not, label %for.body266, label %for.body254, !llvm.loop !42

for.body266:                                      ; preds = %for.body254, %for.body266
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body266 ], [ 0, %for.body254 ]
  %arrayidx268 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %tempvec, i64 0, i64 %indvars.iv
  %104 = bitcast %struct.su3_vector** %arrayidx268 to i8**
  %105 = load i8*, i8** %104, align 8, !tbaa !8
  tail call void @free(i8* %105) #11
  %arrayidx270 = getelementptr inbounds [4 x %struct.su3_vector*], [4 x %struct.su3_vector*]* %templongvec, i64 0, i64 %indvars.iv
  %106 = bitcast %struct.su3_vector** %arrayidx270 to i8**
  %107 = load i8*, i8** %106, align 8, !tbaa !8
  tail call void @free(i8* %107) #11
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 4
  br i1 %exitcond.not, label %for.end273, label %for.body266, !llvm.loop !43

for.end273:                                       ; preds = %for.body266
  tail call void @free(i8* %call6) #11
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %2) #10
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %1) #10
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %0) #10
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @dslash_fn_on_temp_special(%struct.su3_vector* %src, %struct.su3_vector* %dest, i32 %parity, %struct.msg_tag** nocapture %tag, i32 %start) local_unnamed_addr #8 {
entry:
  %.b = load i1, i1* @temp_not_allocated, align 4
  br i1 %.b, label %if.end, label %for.cond.preheader

for.cond.preheader:                               ; preds = %entry
  %0 = load i32, i32* @sites_on_node, align 4, !tbaa !4
  %conv = sext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.cond.preheader, %for.body
  %indvars.iv481 = phi i64 [ 0, %for.cond.preheader ], [ %indvars.iv.next482, %for.body ]
  %call = tail call noalias align 16 i8* @calloc(i64 %conv, i64 48) #11
  %arrayidx = getelementptr inbounds [9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 %indvars.iv481
  %1 = bitcast %struct.su3_vector** %arrayidx to i8**
  store i8* %call, i8** %1, align 8, !tbaa !8
  %call2 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 48) #11
  %2 = add nuw nsw i64 %indvars.iv481, 4
  %arrayidx4 = getelementptr inbounds [9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 %2
  %3 = bitcast %struct.su3_vector** %arrayidx4 to i8**
  store i8* %call2, i8** %3, align 8, !tbaa !8
  %indvars.iv.next482 = add nuw nsw i64 %indvars.iv481, 1
  %exitcond484.not = icmp eq i64 %indvars.iv.next482, 4
  br i1 %exitcond484.not, label %for.end, label %for.body, !llvm.loop !44

for.end:                                          ; preds = %for.body
  %call6 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 48) #11
  store i8* %call6, i8** bitcast (%struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 8) to i8**), align 16, !tbaa !8
  store i1 true, i1* @temp_not_allocated, align 4
  br label %if.end

if.end:                                           ; preds = %for.end, %entry
  %4 = load i32, i32* @valid_longlinks, align 4, !tbaa !4
  %tobool7.not = icmp eq i32 %4, 0
  br i1 %tobool7.not, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end
  tail call void (...) bitcast (void ()* @load_longlinks to void (...)*)() #11
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.end
  %5 = load i32, i32* @valid_fatlinks, align 4, !tbaa !4
  %tobool10.not = icmp eq i32 %5, 0
  br i1 %tobool10.not, label %if.then11, label %if.end12

if.then11:                                        ; preds = %if.end9
  tail call void (...) bitcast (void ()* @load_fatlinks to void (...)*)() #11
  br label %if.end12

if.end12:                                         ; preds = %if.then11, %if.end9
  switch i32 %parity, label %sw.epilog [
    i32 3, label %sw.bb14
    i32 1, label %sw.bb13
  ]

sw.bb13:                                          ; preds = %if.end12
  br label %sw.epilog

sw.bb14:                                          ; preds = %if.end12
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end12, %sw.bb14, %sw.bb13
  %cmp50 = phi i1 [ false, %sw.bb14 ], [ true, %sw.bb13 ], [ false, %if.end12 ]
  %cmp52 = phi i1 [ false, %sw.bb14 ], [ false, %sw.bb13 ], [ true, %if.end12 ]
  %cmp19 = icmp eq i32 %start, 1
  %6 = bitcast %struct.su3_vector* %src to i8*
  br label %for.body18

for.body18:                                       ; preds = %sw.epilog, %for.inc47
  %indvars.iv476 = phi i64 [ 0, %sw.epilog ], [ %indvars.iv.next477, %for.inc47 ]
  %arrayidx23 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %indvars.iv476
  %7 = load i8**, i8*** %arrayidx23, align 8, !tbaa !8
  br i1 %cmp19, label %if.then21, label %if.else

if.then21:                                        ; preds = %for.body18
  %8 = trunc i64 %indvars.iv476 to i32
  %call24 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %6, i32 48, i32 %8, i32 %parity, i8** %7) #11
  %arrayidx26 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv476
  store %struct.msg_tag* %call24, %struct.msg_tag** %arrayidx26, align 8, !tbaa !8
  %9 = add nuw nsw i64 %indvars.iv476, 8
  %arrayidx30 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %9
  %10 = load i8**, i8*** %arrayidx30, align 8, !tbaa !8
  %11 = trunc i64 %9 to i32
  %call31 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %6, i32 48, i32 %11, i32 %parity, i8** %10) #11
  %arrayidx34 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %9
  store %struct.msg_tag* %call31, %struct.msg_tag** %arrayidx34, align 8, !tbaa !8
  br label %for.inc47

if.else:                                          ; preds = %for.body18
  %arrayidx38 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv476
  %12 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx38, align 8, !tbaa !8
  %13 = trunc i64 %indvars.iv476 to i32
  tail call void @restart_gather_from_temp(i8* %6, i32 48, i32 %13, i32 %parity, i8** %7, %struct.msg_tag* %12) #11
  %14 = add nuw nsw i64 %indvars.iv476, 8
  %arrayidx42 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %14
  %15 = load i8**, i8*** %arrayidx42, align 8, !tbaa !8
  %arrayidx45 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %14
  %16 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx45, align 8, !tbaa !8
  %17 = trunc i64 %14 to i32
  tail call void @restart_gather_from_temp(i8* %6, i32 48, i32 %17, i32 %parity, i8** %15, %struct.msg_tag* %16) #11
  br label %for.inc47

for.inc47:                                        ; preds = %if.then21, %if.else
  %indvars.iv.next477 = add nuw nsw i64 %indvars.iv476, 1
  %exitcond480.not = icmp eq i64 %indvars.iv.next477, 4
  br i1 %exitcond480.not, label %for.end49, label %for.body18, !llvm.loop !45

for.end49:                                        ; preds = %for.inc47
  %18 = load i32, i32* @even_sites_on_node, align 4
  %19 = load i32, i32* @sites_on_node, align 4
  %cond = select i1 %cmp50, i32 %18, i32 %19
  %cond57 = select i1 %cmp52, i32 %18, i32 0
  %idxprom58 = sext i32 %cond57 to i64
  %cmp61438 = icmp slt i32 %cond57, %cond
  br i1 %cmp61438, label %for.body63.preheader, label %for.body91.preheader

for.body63.preheader:                             ; preds = %for.end49
  %20 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx59 = getelementptr inbounds %struct.site, %struct.site* %20, i64 %idxprom58
  br label %for.body63

for.body63:                                       ; preds = %for.body63.preheader, %for.body63
  %indvars.iv472 = phi i64 [ %idxprom58, %for.body63.preheader ], [ %indvars.iv.next473, %for.body63 ]
  %s.0439 = phi %struct.site* [ %arrayidx59, %for.body63.preheader ], [ %incdec.ptr, %for.body63 ]
  %arraydecay = getelementptr inbounds %struct.site, %struct.site* %s.0439, i64 0, i32 10, i64 0
  %arraydecay64 = getelementptr inbounds %struct.site, %struct.site* %s.0439, i64 0, i32 9, i64 0
  %arrayidx66 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %src, i64 %indvars.iv472
  %21 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 0), align 16, !tbaa !8
  %arrayidx68 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %21, i64 %indvars.iv472
  %22 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 1), align 8, !tbaa !8
  %arrayidx70 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %22, i64 %indvars.iv472
  %23 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 2), align 16, !tbaa !8
  %arrayidx72 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %23, i64 %indvars.iv472
  %24 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 3), align 8, !tbaa !8
  %arrayidx74 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %24, i64 %indvars.iv472
  tail call void @mult_adj_su3_mat_4vec(%struct.su3_matrix* nonnull %arraydecay, %struct.su3_vector* %arrayidx66, %struct.su3_vector* %arrayidx68, %struct.su3_vector* %arrayidx70, %struct.su3_vector* %arrayidx72, %struct.su3_vector* %arrayidx74) #11
  %25 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 4), align 16, !tbaa !8
  %arrayidx78 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %25, i64 %indvars.iv472
  %26 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 5), align 8, !tbaa !8
  %arrayidx80 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %26, i64 %indvars.iv472
  %27 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 6), align 16, !tbaa !8
  %arrayidx82 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %27, i64 %indvars.iv472
  %28 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 7), align 8, !tbaa !8
  %arrayidx84 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %28, i64 %indvars.iv472
  tail call void @mult_adj_su3_mat_4vec(%struct.su3_matrix* nonnull %arraydecay64, %struct.su3_vector* %arrayidx66, %struct.su3_vector* %arrayidx78, %struct.su3_vector* %arrayidx80, %struct.su3_vector* %arrayidx82, %struct.su3_vector* %arrayidx84) #11
  %indvars.iv.next473 = add nsw i64 %indvars.iv472, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %s.0439, i64 1
  %lftr.wideiv474 = trunc i64 %indvars.iv.next473 to i32
  %exitcond475.not = icmp eq i32 %cond, %lftr.wideiv474
  br i1 %exitcond475.not, label %for.body91.preheader, label %for.body63, !llvm.loop !46

for.body91.preheader:                             ; preds = %for.body63, %for.end49
  br label %for.body91

for.body91:                                       ; preds = %for.body91.preheader, %for.inc115
  %indvars.iv467 = phi i64 [ %indvars.iv.next468, %for.inc115 ], [ 0, %for.body91.preheader ]
  %arrayidx96 = getelementptr inbounds [9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 %indvars.iv467
  %29 = bitcast %struct.su3_vector** %arrayidx96 to i8**
  %30 = load i8*, i8** %29, align 8, !tbaa !8
  %31 = sub nuw nsw i64 7, %indvars.iv467
  %arrayidx99 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %31
  %32 = load i8**, i8*** %arrayidx99, align 8, !tbaa !8
  br i1 %cmp19, label %if.then94, label %if.else104

if.then94:                                        ; preds = %for.body91
  %33 = trunc i64 %31 to i32
  %call100 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %30, i32 48, i32 %33, i32 %parity, i8** %32) #11
  %arrayidx103 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %31
  store %struct.msg_tag* %call100, %struct.msg_tag** %arrayidx103, align 8, !tbaa !8
  br label %for.inc115

if.else104:                                       ; preds = %for.body91
  %arrayidx113 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %31
  %34 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx113, align 8, !tbaa !8
  %35 = trunc i64 %31 to i32
  tail call void @restart_gather_from_temp(i8* %30, i32 48, i32 %35, i32 %parity, i8** %32, %struct.msg_tag* %34) #11
  br label %for.inc115

for.inc115:                                       ; preds = %if.then94, %if.else104
  %indvars.iv.next468 = add nuw nsw i64 %indvars.iv467, 1
  %exitcond471.not = icmp eq i64 %indvars.iv.next468, 4
  br i1 %exitcond471.not, label %for.body121, label %for.body91, !llvm.loop !47

for.body121:                                      ; preds = %for.inc115, %for.inc150
  %indvars.iv460 = phi i64 [ %indvars.iv.next461, %for.inc150 ], [ 8, %for.inc115 ]
  %36 = add nsw i64 %indvars.iv460, -4
  %arrayidx128 = getelementptr inbounds [9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 %36
  %37 = bitcast %struct.su3_vector** %arrayidx128 to i8**
  %38 = load i8*, i8** %37, align 8, !tbaa !8
  %39 = sub nuw nsw i64 23, %indvars.iv460
  %arrayidx132 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %39
  %40 = load i8**, i8*** %arrayidx132, align 8, !tbaa !8
  br i1 %cmp19, label %if.then124, label %if.else137

if.then124:                                       ; preds = %for.body121
  %41 = trunc i64 %39 to i32
  %call133 = tail call %struct.msg_tag* @start_gather_from_temp(i8* %38, i32 48, i32 %41, i32 %parity, i8** %40) #11
  %arrayidx136 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %39
  store %struct.msg_tag* %call133, %struct.msg_tag** %arrayidx136, align 8, !tbaa !8
  br label %for.inc150

if.else137:                                       ; preds = %for.body121
  %arrayidx148 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %39
  %42 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx148, align 8, !tbaa !8
  %43 = trunc i64 %39 to i32
  tail call void @restart_gather_from_temp(i8* %38, i32 48, i32 %43, i32 %parity, i8** %40, %struct.msg_tag* %42) #11
  br label %for.inc150

for.inc150:                                       ; preds = %if.then124, %if.else137
  %indvars.iv.next461 = add nuw nsw i64 %indvars.iv460, 1
  %exitcond466.not = icmp eq i64 %indvars.iv.next461, 12
  br i1 %exitcond466.not, label %for.body156, label %for.body121, !llvm.loop !48

for.body156:                                      ; preds = %for.inc150, %for.body156
  %indvars.iv456 = phi i64 [ %indvars.iv.next457, %for.body156 ], [ 0, %for.inc150 ]
  %arrayidx158 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %indvars.iv456
  %44 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx158, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %44) #11
  %45 = add nuw nsw i64 %indvars.iv456, 8
  %arrayidx161 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %45
  %46 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx161, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %46) #11
  %indvars.iv.next457 = add nuw nsw i64 %indvars.iv456, 1
  %exitcond459.not = icmp eq i64 %indvars.iv.next457, 4
  br i1 %exitcond459.not, label %for.end164, label %for.body156, !llvm.loop !49

for.end164:                                       ; preds = %for.body156
  %cmp166 = icmp eq i32 %parity, 2
  %47 = load i32, i32* @even_sites_on_node, align 4
  %48 = load i32, i32* @sites_on_node, align 4
  %cond171 = select i1 %cmp166, i32 %47, i32 %48
  %cmp172 = icmp eq i32 %parity, 1
  %cond177 = select i1 %cmp172, i32 %47, i32 0
  %idxprom178 = sext i32 %cond177 to i64
  %cmp181430 = icmp slt i32 %cond177, %cond171
  br i1 %cmp181430, label %for.body183.preheader, label %for.body215.preheader

for.body183.preheader:                            ; preds = %for.end164
  %49 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx179 = getelementptr inbounds %struct.site, %struct.site* %49, i64 %idxprom178
  br label %for.body183

for.body183:                                      ; preds = %for.body183.preheader, %for.body183
  %indvars.iv452 = phi i64 [ %idxprom178, %for.body183.preheader ], [ %indvars.iv.next453, %for.body183 ]
  %s.1431 = phi %struct.site* [ %arrayidx179, %for.body183.preheader ], [ %incdec.ptr210, %for.body183 ]
  %arraydecay185 = getelementptr inbounds %struct.site, %struct.site* %s.1431, i64 0, i32 10, i64 0
  %arraydecay187 = getelementptr inbounds %struct.site, %struct.site* %s.1431, i64 0, i32 9, i64 0
  %50 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 0), align 16, !tbaa !8
  %arrayidx189 = getelementptr inbounds i8*, i8** %50, i64 %indvars.iv452
  %51 = bitcast i8** %arrayidx189 to %struct.su3_vector**
  %52 = load %struct.su3_vector*, %struct.su3_vector** %51, align 8, !tbaa !8
  %53 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 1), align 8, !tbaa !8
  %arrayidx191 = getelementptr inbounds i8*, i8** %53, i64 %indvars.iv452
  %54 = bitcast i8** %arrayidx191 to %struct.su3_vector**
  %55 = load %struct.su3_vector*, %struct.su3_vector** %54, align 8, !tbaa !8
  %56 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 2), align 16, !tbaa !8
  %arrayidx193 = getelementptr inbounds i8*, i8** %56, i64 %indvars.iv452
  %57 = bitcast i8** %arrayidx193 to %struct.su3_vector**
  %58 = load %struct.su3_vector*, %struct.su3_vector** %57, align 8, !tbaa !8
  %59 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 3), align 8, !tbaa !8
  %arrayidx195 = getelementptr inbounds i8*, i8** %59, i64 %indvars.iv452
  %60 = bitcast i8** %arrayidx195 to %struct.su3_vector**
  %61 = load %struct.su3_vector*, %struct.su3_vector** %60, align 8, !tbaa !8
  %arrayidx197 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %dest, i64 %indvars.iv452
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay185, %struct.su3_vector* %52, %struct.su3_vector* %55, %struct.su3_vector* %58, %struct.su3_vector* %61, %struct.su3_vector* %arrayidx197) #11
  %62 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx199 = getelementptr inbounds i8*, i8** %62, i64 %indvars.iv452
  %63 = bitcast i8** %arrayidx199 to %struct.su3_vector**
  %64 = load %struct.su3_vector*, %struct.su3_vector** %63, align 8, !tbaa !8
  %65 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 9), align 8, !tbaa !8
  %arrayidx201 = getelementptr inbounds i8*, i8** %65, i64 %indvars.iv452
  %66 = bitcast i8** %arrayidx201 to %struct.su3_vector**
  %67 = load %struct.su3_vector*, %struct.su3_vector** %66, align 8, !tbaa !8
  %68 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 10), align 16, !tbaa !8
  %arrayidx203 = getelementptr inbounds i8*, i8** %68, i64 %indvars.iv452
  %69 = bitcast i8** %arrayidx203 to %struct.su3_vector**
  %70 = load %struct.su3_vector*, %struct.su3_vector** %69, align 8, !tbaa !8
  %71 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 11), align 8, !tbaa !8
  %arrayidx205 = getelementptr inbounds i8*, i8** %71, i64 %indvars.iv452
  %72 = bitcast i8** %arrayidx205 to %struct.su3_vector**
  %73 = load %struct.su3_vector*, %struct.su3_vector** %72, align 8, !tbaa !8
  %74 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx207 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %74, i64 %indvars.iv452
  tail call void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nonnull %arraydecay187, %struct.su3_vector* %64, %struct.su3_vector* %67, %struct.su3_vector* %70, %struct.su3_vector* %73, %struct.su3_vector* %arrayidx207) #11
  %indvars.iv.next453 = add nsw i64 %indvars.iv452, 1
  %incdec.ptr210 = getelementptr inbounds %struct.site, %struct.site* %s.1431, i64 1
  %lftr.wideiv454 = trunc i64 %indvars.iv.next453 to i32
  %exitcond455.not = icmp eq i32 %cond171, %lftr.wideiv454
  br i1 %exitcond455.not, label %for.body215.preheader, label %for.body183, !llvm.loop !50

for.body215.preheader:                            ; preds = %for.body183, %for.end164
  br label %for.body215

for.body215:                                      ; preds = %for.body215.preheader, %for.body215
  %indvars.iv448 = phi i64 [ %indvars.iv.next449, %for.body215 ], [ 0, %for.body215.preheader ]
  %75 = sub nuw nsw i64 7, %indvars.iv448
  %arrayidx218 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %75
  %76 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx218, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %76) #11
  %indvars.iv.next449 = add nuw nsw i64 %indvars.iv448, 1
  %exitcond451.not = icmp eq i64 %indvars.iv.next449, 4
  br i1 %exitcond451.not, label %for.body225, label %for.body215, !llvm.loop !51

for.body225:                                      ; preds = %for.body215, %for.body225
  %indvars.iv444 = phi i64 [ %indvars.iv.next445, %for.body225 ], [ 8, %for.body215 ]
  %77 = sub nuw nsw i64 23, %indvars.iv444
  %arrayidx228 = getelementptr inbounds %struct.msg_tag*, %struct.msg_tag** %tag, i64 %77
  %78 = load %struct.msg_tag*, %struct.msg_tag** %arrayidx228, align 8, !tbaa !8
  tail call void @wait_gather(%struct.msg_tag* %78) #11
  %indvars.iv.next445 = add nuw nsw i64 %indvars.iv444, 1
  %exitcond447.not = icmp eq i64 %indvars.iv.next445, 12
  br i1 %exitcond447.not, label %for.end231, label %for.body225, !llvm.loop !52

for.end231:                                       ; preds = %for.body225
  %79 = load i32, i32* @even_sites_on_node, align 4
  %80 = load i32, i32* @sites_on_node, align 4
  %cond238 = select i1 %cmp166, i32 %79, i32 %80
  %cond244 = select i1 %cmp172, i32 %79, i32 0
  %cmp248426 = icmp slt i32 %cond244, %cond238
  br i1 %cmp248426, label %for.body250.preheader, label %for.end280

for.body250.preheader:                            ; preds = %for.end231
  %81 = sext i32 %cond244 to i64
  br label %for.body250

for.body250:                                      ; preds = %for.body250.preheader, %for.body250
  %indvars.iv = phi i64 [ %81, %for.body250.preheader ], [ %indvars.iv.next, %for.body250 ]
  %arrayidx252 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %dest, i64 %indvars.iv
  %82 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 7), align 8, !tbaa !8
  %arrayidx254 = getelementptr inbounds i8*, i8** %82, i64 %indvars.iv
  %83 = bitcast i8** %arrayidx254 to %struct.su3_vector**
  %84 = load %struct.su3_vector*, %struct.su3_vector** %83, align 8, !tbaa !8
  %85 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 6), align 16, !tbaa !8
  %arrayidx256 = getelementptr inbounds i8*, i8** %85, i64 %indvars.iv
  %86 = bitcast i8** %arrayidx256 to %struct.su3_vector**
  %87 = load %struct.su3_vector*, %struct.su3_vector** %86, align 8, !tbaa !8
  %88 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 5), align 8, !tbaa !8
  %arrayidx258 = getelementptr inbounds i8*, i8** %88, i64 %indvars.iv
  %89 = bitcast i8** %arrayidx258 to %struct.su3_vector**
  %90 = load %struct.su3_vector*, %struct.su3_vector** %89, align 8, !tbaa !8
  %91 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 4), align 16, !tbaa !8
  %arrayidx260 = getelementptr inbounds i8*, i8** %91, i64 %indvars.iv
  %92 = bitcast i8** %arrayidx260 to %struct.su3_vector**
  %93 = load %struct.su3_vector*, %struct.su3_vector** %92, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* %arrayidx252, %struct.su3_vector* %84, %struct.su3_vector* %87, %struct.su3_vector* %90, %struct.su3_vector* %93) #11
  %94 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx262 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %94, i64 %indvars.iv
  %95 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 15), align 8, !tbaa !8
  %arrayidx264 = getelementptr inbounds i8*, i8** %95, i64 %indvars.iv
  %96 = bitcast i8** %arrayidx264 to %struct.su3_vector**
  %97 = load %struct.su3_vector*, %struct.su3_vector** %96, align 8, !tbaa !8
  %98 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 14), align 16, !tbaa !8
  %arrayidx266 = getelementptr inbounds i8*, i8** %98, i64 %indvars.iv
  %99 = bitcast i8** %arrayidx266 to %struct.su3_vector**
  %100 = load %struct.su3_vector*, %struct.su3_vector** %99, align 8, !tbaa !8
  %101 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 13), align 8, !tbaa !8
  %arrayidx268 = getelementptr inbounds i8*, i8** %101, i64 %indvars.iv
  %102 = bitcast i8** %arrayidx268 to %struct.su3_vector**
  %103 = load %struct.su3_vector*, %struct.su3_vector** %102, align 8, !tbaa !8
  %104 = load i8**, i8*** getelementptr inbounds ([16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 12), align 16, !tbaa !8
  %arrayidx270 = getelementptr inbounds i8*, i8** %104, i64 %indvars.iv
  %105 = bitcast i8** %arrayidx270 to %struct.su3_vector**
  %106 = load %struct.su3_vector*, %struct.su3_vector** %105, align 8, !tbaa !8
  tail call void @sub_four_su3_vecs(%struct.su3_vector* %arrayidx262, %struct.su3_vector* %97, %struct.su3_vector* %100, %struct.su3_vector* %103, %struct.su3_vector* %106) #11
  %107 = load %struct.su3_vector*, %struct.su3_vector** getelementptr inbounds ([9 x %struct.su3_vector*], [9 x %struct.su3_vector*]* @temp, i64 0, i64 8), align 16, !tbaa !8
  %arrayidx274 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %107, i64 %indvars.iv
  tail call void @add_su3_vector(%struct.su3_vector* %arrayidx252, %struct.su3_vector* %arrayidx274, %struct.su3_vector* %arrayidx252) #11
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond.not = icmp eq i32 %cond238, %lftr.wideiv
  br i1 %exitcond.not, label %for.end280, label %for.body250, !llvm.loop !53

for.end280:                                       ; preds = %for.body250, %for.end231
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
declare void @accum_gauge_hit(i32, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
define void @do_hit(i32 %gauge_dir, i32 %parity, i32 %p, i32 %q, double %relax_boost, i32 %nvector, i32* nocapture readonly %vector_offset, i32* nocapture readonly %vector_parity, i32 %nantiherm, i32* nocapture readonly %antiherm_offset, i32* nocapture readonly %antiherm_parity) local_unnamed_addr #8 {
entry:
  %u = alloca %struct.su2_matrix, align 8
  %htemp = alloca %struct.su3_matrix, align 8
  %0 = bitcast %struct.su2_matrix* %u to i8*
  call void @llvm.lifetime.start.p0i8(i64 64, i8* nonnull %0) #10
  %1 = bitcast %struct.su3_matrix* %htemp to i8*
  call void @llvm.lifetime.start.p0i8(i64 144, i8* nonnull %1) #10
  tail call void @accum_gauge_hit(i32 %gauge_dir, i32 %parity) #12
  %cmp = icmp eq i32 %parity, 1
  %2 = load i32, i32* @even_sites_on_node, align 4
  %cond = select i1 %cmp, i32 %2, i32 0
  %idxprom = sext i32 %cond to i64
  %cmp1 = icmp eq i32 %parity, 2
  %idxprom19 = sext i32 %p to i64
  %idxprom25 = sext i32 %q to i64
  %tmp.sroa.0.0..sroa_idx = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 0, i64 0, i32 0
  %tmp.sroa.4.0..sroa_idx243 = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 0, i64 0, i32 1
  %tmp150.sroa.0.0..sroa_idx = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 0, i64 1, i32 0
  %tmp150.sroa.4.0..sroa_idx240 = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 0, i64 1, i32 1
  %tmp155.sroa.0.0..sroa_idx = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 1, i64 0, i32 0
  %tmp155.sroa.4.0..sroa_idx237 = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 1, i64 0, i32 1
  %tmp161.sroa.0.0..sroa_idx = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 1, i64 1, i32 0
  %tmp161.sroa.4.0..sroa_idx234 = getelementptr inbounds %struct.su2_matrix, %struct.su2_matrix* %u, i64 0, i32 0, i64 1, i64 1, i32 1
  %cmp180375 = icmp sgt i32 %nvector, 0
  %cmp208377 = icmp sgt i32 %nantiherm, 0
  %3 = load i32, i32* @sites_on_node, align 4
  %cond5379 = select i1 %cmp1, i32 %2, i32 %3
  %cmp6380 = icmp slt i32 %cond, %cond5379
  br i1 %cmp6380, label %for.body.preheader, label %for.end232

for.body.preheader:                               ; preds = %entry
  %4 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !8
  %arrayidx = getelementptr inbounds %struct.site, %struct.site* %4, i64 %idxprom
  %wide.trip.count = zext i32 %nvector to i64
  %wide.trip.count391 = zext i32 %nantiherm to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc230
  %indvars.iv393 = phi i64 [ %idxprom, %for.body.preheader ], [ %indvars.iv.next394, %for.inc230 ]
  %s.0381 = phi %struct.site* [ %arrayidx, %for.body.preheader ], [ %incdec.ptr, %for.inc230 ]
  %5 = load i32, i32* @sumvec_offset, align 4, !tbaa !4
  %cmp7 = icmp sgt i32 %5, -1
  br i1 %cmp7, label %if.then, label %if.else

if.then:                                          ; preds = %for.body
  %6 = bitcast %struct.site* %s.0381 to i8*
  %idx.ext371 = zext i32 %5 to i64
  %add.ptr = getelementptr inbounds i8, i8* %6, i64 %idx.ext371
  %c = bitcast i8* %add.ptr to [3 x %struct.complex]*
  %real = getelementptr inbounds [3 x %struct.complex], [3 x %struct.complex]* %c, i64 0, i64 %idxprom19, i32 0
  %real15 = getelementptr inbounds [3 x %struct.complex], [3 x %struct.complex]* %c, i64 0, i64 %idxprom25, i32 0
  br label %if.end

if.else:                                          ; preds = %for.body
  %7 = load %struct.su3_vector*, %struct.su3_vector** @sumvecp, align 8, !tbaa !8
  %real21 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %7, i64 %indvars.iv393, i32 0, i64 %idxprom19, i32 0
  %real27 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %7, i64 %indvars.iv393, i32 0, i64 %idxprom25, i32 0
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %real27.sink = phi double* [ %real27, %if.else ], [ %real15, %if.then ]
  %.sink.in = phi double* [ %real21, %if.else ], [ %real, %if.then ]
  %.sink = load double, double* %.sink.in, align 8, !tbaa !54
  %8 = load double, double* %real27.sink, align 8, !tbaa !54
  %add28 = fadd double %.sink, %8
  %9 = load i32, i32* @diffmat_offset, align 4, !tbaa !4
  %cmp29 = icmp sgt i32 %9, -1
  br i1 %cmp29, label %if.then30, label %if.else79

if.then30:                                        ; preds = %if.end
  %10 = bitcast %struct.site* %s.0381 to i8*
  %idx.ext31372 = zext i32 %9 to i64
  %add.ptr32 = getelementptr inbounds i8, i8* %10, i64 %idx.ext31372
  %e = bitcast i8* %add.ptr32 to [3 x [3 x %struct.complex]]*
  %imag = getelementptr inbounds [3 x [3 x %struct.complex]], [3 x [3 x %struct.complex]]* %e, i64 0, i64 %idxprom25, i64 %idxprom19, i32 1
  %11 = load double, double* %imag, align 8, !tbaa !57
  %imag44 = getelementptr inbounds [3 x [3 x %struct.complex]], [3 x [3 x %struct.complex]]* %e, i64 0, i64 %idxprom19, i64 %idxprom25, i32 1
  %12 = load double, double* %imag44, align 8, !tbaa !57
  %add45 = fadd double %11, %12
  %real53 = getelementptr inbounds [3 x [3 x %struct.complex]], [3 x [3 x %struct.complex]]* %e, i64 0, i64 %idxprom25, i64 %idxprom19, i32 0
  %13 = load double, double* %real53, align 8, !tbaa !54
  %real61 = getelementptr inbounds [3 x [3 x %struct.complex]], [3 x [3 x %struct.complex]]* %e, i64 0, i64 %idxprom19, i64 %idxprom25, i32 0
  %14 = load double, double* %real61, align 8, !tbaa !54
  %add62 = fsub double %14, %13
  %imag70 = getelementptr inbounds [3 x [3 x %struct.complex]], [3 x [3 x %struct.complex]]* %e, i64 0, i64 %idxprom19, i64 %idxprom19, i32 1
  %imag78 = getelementptr inbounds [3 x [3 x %struct.complex]], [3 x [3 x %struct.complex]]* %e, i64 0, i64 %idxprom25, i64 %idxprom25, i32 1
  br label %if.end132

if.else79:                                        ; preds = %if.end
  %15 = load %struct.su3_matrix*, %struct.su3_matrix** @diffmatp, align 8, !tbaa !8
  %imag87 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %15, i64 %indvars.iv393, i32 0, i64 %idxprom25, i64 %idxprom19, i32 1
  %16 = load double, double* %imag87, align 8, !tbaa !57
  %imag95 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %15, i64 %indvars.iv393, i32 0, i64 %idxprom19, i64 %idxprom25, i32 1
  %17 = load double, double* %imag95, align 8, !tbaa !57
  %add96 = fadd double %16, %17
  %real104 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %15, i64 %indvars.iv393, i32 0, i64 %idxprom25, i64 %idxprom19, i32 0
  %18 = load double, double* %real104, align 8, !tbaa !54
  %real113 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %15, i64 %indvars.iv393, i32 0, i64 %idxprom19, i64 %idxprom25, i32 0
  %19 = load double, double* %real113, align 8, !tbaa !54
  %add114 = fsub double %19, %18
  %imag122 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %15, i64 %indvars.iv393, i32 0, i64 %idxprom19, i64 %idxprom19, i32 1
  %imag130 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %15, i64 %indvars.iv393, i32 0, i64 %idxprom25, i64 %idxprom25, i32 1
  br label %if.end132

if.end132:                                        ; preds = %if.else79, %if.then30
  %imag130.sink = phi double* [ %imag130, %if.else79 ], [ %imag78, %if.then30 ]
  %.sink396.in = phi double* [ %imag122, %if.else79 ], [ %imag70, %if.then30 ]
  %a2.0 = phi double [ %add114, %if.else79 ], [ %add62, %if.then30 ]
  %a1.0 = phi double [ %add96, %if.else79 ], [ %add45, %if.then30 ]
  %.sink396 = load double, double* %.sink396.in, align 8, !tbaa !57
  %20 = load double, double* %imag130.sink, align 8, !tbaa !57
  %sub131 = fsub double %.sink396, %20
  %mul133 = fmul double %a2.0, %a2.0
  %21 = call double @llvm.fmuladd.f64(double %a1.0, double %a1.0, double %mul133)
  %22 = call double @llvm.fmuladd.f64(double %sub131, double %sub131, double %21)
  %mul = fmul double %add28, %add28
  %23 = call double @llvm.fmuladd.f64(double %relax_boost, double %mul, double %22)
  %add135 = fadd double %mul, %22
  %div = fdiv double %23, %add135
  %mul136 = fmul double %div, %div
  %24 = call double @llvm.fmuladd.f64(double %mul136, double %22, double %mul)
  %call = call double @sqrt(double %24) #11
  %div138 = fdiv double %div, %call
  %div139 = fdiv double %add28, %call
  %mul140 = fmul double %a1.0, %div138
  %mul141 = fmul double %a2.0, %div138
  %mul142 = fmul double %sub131, %div138
  %call146 = call { double, double } @cmplx(double %div139, double %mul142) #11
  %25 = extractvalue { double, double } %call146, 0
  %26 = extractvalue { double, double } %call146, 1
  store double %25, double* %tmp.sroa.0.0..sroa_idx, align 8, !tbaa.struct !58
  store double %26, double* %tmp.sroa.4.0..sroa_idx243, align 8, !tbaa.struct !60
  %call151 = call { double, double } @cmplx(double %mul141, double %mul140) #11
  %27 = extractvalue { double, double } %call151, 0
  %28 = extractvalue { double, double } %call151, 1
  store double %27, double* %tmp150.sroa.0.0..sroa_idx, align 8, !tbaa.struct !58
  store double %28, double* %tmp150.sroa.4.0..sroa_idx240, align 8, !tbaa.struct !60
  %fneg156 = fneg double %mul141
  %call157 = call { double, double } @cmplx(double %fneg156, double %mul140) #11
  %29 = extractvalue { double, double } %call157, 0
  %30 = extractvalue { double, double } %call157, 1
  store double %29, double* %tmp155.sroa.0.0..sroa_idx, align 8, !tbaa.struct !58
  store double %30, double* %tmp155.sroa.4.0..sroa_idx237, align 8, !tbaa.struct !60
  %fneg162 = fneg double %mul142
  %call163 = call { double, double } @cmplx(double %div139, double %fneg162) #11
  %31 = extractvalue { double, double } %call163, 0
  %32 = extractvalue { double, double } %call163, 1
  store double %31, double* %tmp161.sroa.0.0..sroa_idx, align 8, !tbaa.struct !58
  store double %32, double* %tmp161.sroa.4.0..sroa_idx234, align 8, !tbaa.struct !60
  br label %for.body166

for.body166:                                      ; preds = %if.end132, %for.body166
  %indvars.iv = phi i64 [ 0, %if.end132 ], [ %indvars.iv.next, %for.body166 ]
  %arrayidx168 = getelementptr inbounds %struct.site, %struct.site* %s.0381, i64 0, i32 8, i64 %indvars.iv
  call void @left_su2_hit_n(%struct.su2_matrix* nonnull %u, i32 %p, i32 %q, %struct.su3_matrix* nonnull %arrayidx168) #11
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 4
  br i1 %exitcond.not, label %for.body171, label %for.body166, !llvm.loop !61

for.cond179.preheader:                            ; preds = %for.body171
  %33 = bitcast %struct.site* %s.0381 to i8*
  br i1 %cmp180375, label %for.body181, label %for.cond207.preheader

for.body171:                                      ; preds = %for.body166, %for.body171
  %indvars.iv383 = phi i64 [ %indvars.iv.next384, %for.body171 ], [ 0, %for.body166 ]
  %arrayidx173 = getelementptr inbounds [16 x i8**], [16 x i8**]* @gen_pt, i64 0, i64 %indvars.iv383
  %34 = load i8**, i8*** %arrayidx173, align 8, !tbaa !8
  %arrayidx175 = getelementptr inbounds i8*, i8** %34, i64 %indvars.iv393
  %35 = bitcast i8** %arrayidx175 to %struct.su3_matrix**
  %36 = load %struct.su3_matrix*, %struct.su3_matrix** %35, align 8, !tbaa !8
  call void @right_su2_hit_a(%struct.su2_matrix* nonnull %u, i32 %p, i32 %q, %struct.su3_matrix* %36) #11
  %indvars.iv.next384 = add nuw nsw i64 %indvars.iv383, 1
  %exitcond385.not = icmp eq i64 %indvars.iv.next384, 4
  br i1 %exitcond385.not, label %for.cond179.preheader, label %for.body171, !llvm.loop !62

for.cond207.preheader:                            ; preds = %for.inc204, %for.cond179.preheader
  br i1 %cmp208377, label %for.body209, label %for.inc230

for.body181:                                      ; preds = %for.cond179.preheader, %for.inc204
  %indvars.iv386 = phi i64 [ %indvars.iv.next387, %for.inc204 ], [ 0, %for.cond179.preheader ]
  %arrayidx183 = getelementptr inbounds i32, i32* %vector_parity, i64 %indvars.iv386
  %37 = load i32, i32* %arrayidx183, align 4, !tbaa !4
  %cmp184 = icmp eq i32 %37, 3
  %cmp187 = icmp eq i32 %37, %parity
  %or.cond = select i1 %cmp184, i1 true, i1 %cmp187
  br i1 %or.cond, label %if.then188, label %for.inc204

if.then188:                                       ; preds = %for.body181
  %arrayidx190 = getelementptr inbounds i32, i32* %vector_offset, i64 %indvars.iv386
  %38 = load i32, i32* %arrayidx190, align 4, !tbaa !4
  %idx.ext191 = sext i32 %38 to i64
  %add.ptr192 = getelementptr inbounds i8, i8* %33, i64 %idx.ext191
  %c193 = bitcast i8* %add.ptr192 to [3 x %struct.complex]*
  %arrayidx195 = getelementptr inbounds [3 x %struct.complex], [3 x %struct.complex]* %c193, i64 0, i64 %idxprom19
  %arrayidx202 = getelementptr inbounds [3 x %struct.complex], [3 x %struct.complex]* %c193, i64 0, i64 %idxprom25
  call void @mult_su2_mat_vec_elem_n(%struct.su2_matrix* nonnull %u, %struct.complex* %arrayidx195, %struct.complex* %arrayidx202) #11
  br label %for.inc204

for.inc204:                                       ; preds = %for.body181, %if.then188
  %indvars.iv.next387 = add nuw nsw i64 %indvars.iv386, 1
  %exitcond388.not = icmp eq i64 %indvars.iv.next387, %wide.trip.count
  br i1 %exitcond388.not, label %for.cond207.preheader, label %for.body181, !llvm.loop !63

for.body209:                                      ; preds = %for.cond207.preheader, %for.inc227
  %indvars.iv389 = phi i64 [ %indvars.iv.next390, %for.inc227 ], [ 0, %for.cond207.preheader ]
  %arrayidx211 = getelementptr inbounds i32, i32* %antiherm_parity, i64 %indvars.iv389
  %39 = load i32, i32* %arrayidx211, align 4, !tbaa !4
  %cmp212 = icmp eq i32 %39, 3
  %cmp216 = icmp eq i32 %39, %parity
  %or.cond370 = select i1 %cmp212, i1 true, i1 %cmp216
  br i1 %or.cond370, label %if.then217, label %for.inc227

if.then217:                                       ; preds = %for.body209
  %arrayidx219 = getelementptr inbounds i32, i32* %antiherm_offset, i64 %indvars.iv389
  %40 = load i32, i32* %arrayidx219, align 4, !tbaa !4
  %idx.ext220 = sext i32 %40 to i64
  %add.ptr221 = getelementptr inbounds i8, i8* %33, i64 %idx.ext220
  %41 = bitcast i8* %add.ptr221 to %struct.anti_hermitmat*
  call void @uncompress_anti_hermitian(%struct.anti_hermitmat* %41, %struct.su3_matrix* nonnull %htemp) #11
  call void @left_su2_hit_n(%struct.su2_matrix* nonnull %u, i32 %p, i32 %q, %struct.su3_matrix* nonnull %htemp) #11
  call void @right_su2_hit_a(%struct.su2_matrix* nonnull %u, i32 %p, i32 %q, %struct.su3_matrix* nonnull %htemp) #11
  %42 = load i32, i32* %arrayidx219, align 4, !tbaa !4
  %idx.ext224 = sext i32 %42 to i64
  %add.ptr225 = getelementptr inbounds i8, i8* %33, i64 %idx.ext224
  %43 = bitcast i8* %add.ptr225 to %struct.anti_hermitmat*
  call void @make_anti_hermitian(%struct.su3_matrix* nonnull %htemp, %struct.anti_hermitmat* %43) #11
  br label %for.inc227

for.inc227:                                       ; preds = %for.body209, %if.then217
  %indvars.iv.next390 = add nuw nsw i64 %indvars.iv389, 1
  %exitcond392.not = icmp eq i64 %indvars.iv.next390, %wide.trip.count391
  br i1 %exitcond392.not, label %for.inc230, label %for.body209, !llvm.loop !64

for.inc230:                                       ; preds = %for.inc227, %for.cond207.preheader
  %indvars.iv.next394 = add nsw i64 %indvars.iv393, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %s.0381, i64 1
  %44 = load i32, i32* @even_sites_on_node, align 4
  %45 = load i32, i32* @sites_on_node, align 4
  %cond5 = select i1 %cmp1, i32 %44, i32 %45
  %46 = sext i32 %cond5 to i64
  %cmp6 = icmp slt i64 %indvars.iv.next394, %46
  br i1 %cmp6, label %for.body, label %for.end232, !llvm.loop !65

for.end232:                                       ; preds = %for.inc230, %entry
  call void @llvm.lifetime.end.p0i8(i64 144, i8* nonnull %1) #10
  call void @llvm.lifetime.end.p0i8(i64 64, i8* nonnull %0) #10
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @add_su3_vector(%struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #6

; Function Attrs: noinline nounwind optsize uwtable
declare void @right_su2_hit_a(%struct.su2_matrix*, i32, i32, %struct.su3_matrix*) local_unnamed_addr #8

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #6

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @make_anti_hermitian(%struct.su3_matrix* nocapture readonly, %struct.anti_hermitmat* nocapture) local_unnamed_addr #9

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @mult_adj_su3_mat_vec_4dir(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #2

; Function Attrs: noinline nounwind optsize uwtable
declare void @left_su2_hit_n(%struct.su2_matrix*, i32, i32, %struct.su3_matrix*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
declare void @load_longlinks() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
declare void @load_fatlinks() local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @uncompress_anti_hermitian(%struct.anti_hermitmat* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #9

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare { double, double } @cmplx(double, double) local_unnamed_addr #7

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @sub_four_su3_vecs(%struct.su3_vector* nocapture, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly) local_unnamed_addr #9

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nofree noinline nosync nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree noinline nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree noinline norecurse nosync nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { nounwind }
attributes #11 = { nounwind optsize }
attributes #12 = { optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
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
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !11}
!13 = distinct !{!13, !11}
!14 = distinct !{!14, !11}
!15 = distinct !{!15, !11}
!16 = distinct !{!16, !11}
!17 = distinct !{!17, !11}
!18 = distinct !{!18, !11}
!19 = distinct !{!19, !11}
!20 = distinct !{!20, !11}
!21 = distinct !{!21, !11}
!22 = distinct !{!22, !11}
!23 = distinct !{!23, !11}
!24 = distinct !{!24, !11}
!25 = distinct !{!25, !11}
!26 = distinct !{!26, !11}
!27 = distinct !{!27, !11}
!28 = distinct !{!28, !11}
!29 = distinct !{!29, !11}
!30 = distinct !{!30, !11}
!31 = distinct !{!31, !11}
!32 = distinct !{!32, !11}
!33 = distinct !{!33, !11}
!34 = distinct !{!34, !11}
!35 = distinct !{!35, !11}
!36 = distinct !{!36, !11}
!37 = distinct !{!37, !11}
!38 = distinct !{!38, !11}
!39 = distinct !{!39, !11}
!40 = distinct !{!40, !11}
!41 = distinct !{!41, !11}
!42 = distinct !{!42, !11}
!43 = distinct !{!43, !11}
!44 = distinct !{!44, !11}
!45 = distinct !{!45, !11}
!46 = distinct !{!46, !11}
!47 = distinct !{!47, !11}
!48 = distinct !{!48, !11}
!49 = distinct !{!49, !11}
!50 = distinct !{!50, !11}
!51 = distinct !{!51, !11}
!52 = distinct !{!52, !11}
!53 = distinct !{!53, !11}
!54 = !{!55, !56, i64 0}
!55 = !{!"", !56, i64 0, !56, i64 8}
!56 = !{!"double", !6, i64 0}
!57 = !{!55, !56, i64 8}
!58 = !{i64 0, i64 8, !59, i64 8, i64 8, !59}
!59 = !{!56, !56, i64 0}
!60 = !{i64 0, i64 8, !59}
!61 = distinct !{!61, !11}
!62 = distinct !{!62, !11}
!63 = distinct !{!63, !11}
!64 = distinct !{!64, !11}
!65 = distinct !{!65, !11}
