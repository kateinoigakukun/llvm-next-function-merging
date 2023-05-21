; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-size-estimation=exact -func-merging-explore=1 -pass-remarks-output=%t.mfm2-hyfm.yaml -pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm2-hyfm.bc %s
; RUN: cat %t.mfm2-hyfm.yaml | FileCheck %s
; CHECK: --- !Passed

; ModuleID = '../llvm-nextfm-benchmark/benchmarks/spec2006/400.perlbench/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.cop.164 = type { %struct.op.136*, %struct.op.136*, %struct.op.136* ()*, i64, i16, i16, i8, i8, i8*, %struct.hv.152*, %struct.gv.163*, i64, i64, i64, %struct.sv*, %struct.sv* }
%struct.op.136 = type { %struct.op.136*, %struct.op.136*, {}*, i64, i16, i16, i8, i8 }
%struct.hv.152 = type { %struct.xpvhv.151*, i64, i64 }
%struct.xpvhv.151 = type { i8*, i64, i64, i64, double, %struct.magic.143*, %struct.hv.152*, i64, %struct.he*, %struct.pmop.150*, i8* }
%struct.magic.143 = type { %struct.magic.143*, %struct.mgvtbl.142*, i16, i8, i8, %struct.sv*, i8*, i64 }
%struct.mgvtbl.142 = type { i32 (%struct.sv*, %struct.magic.143*)*, i32 (%struct.sv*, %struct.magic.143*)*, i64 (%struct.sv*, %struct.magic.143*)*, i32 (%struct.sv*, %struct.magic.143*)*, i32 (%struct.sv*, %struct.magic.143*)*, i32 (%struct.sv*, %struct.magic.143*, %struct.sv*, i8*, i32)*, i32 (%struct.magic.143*, %struct.clone_params.141*)* }
%struct.clone_params.141 = type { %struct.av.139*, i64, %struct.interpreter* }
%struct.av.139 = type { %struct.xpvav.138*, i64, i64 }
%struct.xpvav.138 = type { i8*, i64, i64, i64, double, %struct.magic.143*, %struct.hv.152*, %struct.sv**, %struct.sv*, i8 }
%struct.interpreter = type { i8 }
%struct.he = type { %struct.he*, %struct.hek*, %struct.sv* }
%struct.hek = type { i64, i64, [1 x i8] }
%struct.pmop.150 = type { %struct.op.136*, %struct.op.136*, %struct.op.136* ()*, i64, i16, i16, i8, i8, %struct.op.136*, %struct.op.136*, %struct.op.136*, %struct.op.136*, %struct.pmop.150*, %struct.regexp*, i64, i64, i8, %struct.hv.152* }
%struct.regexp = type { i64*, i64*, %struct.regnode*, %struct.reg_substr_data*, i8*, %struct.reg_data*, i8*, i64*, i64, i64, i64, i64, i64, i64, i64, i64, [1 x %struct.regnode] }
%struct.regnode = type { i8, i8, i16 }
%struct.reg_substr_data = type { [3 x %struct.reg_substr_datum] }
%struct.reg_substr_datum = type { i64, i64, %struct.sv*, %struct.sv* }
%struct.reg_data = type { i64, i8*, [1 x i8*] }
%struct.gv.163 = type { %struct.xpvgv.162*, i64, i64 }
%struct.xpvgv.162 = type { i8*, i64, i64, i64, double, %struct.magic.143*, %struct.hv.152*, %struct.gp.161*, i8*, i64, %struct.hv.152*, i8 }
%struct.gp.161 = type { %struct.sv*, i64, %struct.io.157*, %struct.cv.160*, %struct.av.139*, %struct.hv.152*, %struct.gv.163*, %struct.cv.160*, i64, i64, i64, i8* }
%struct.io.157 = type { %struct.xpvio.156*, i64, i64 }
%struct.xpvio.156 = type { i8*, i64, i64, i64, double, %struct.magic.143*, %struct.hv.152*, %struct._PerlIO**, %struct._PerlIO**, %union.anon.0, i64, i64, i64, i64, i8*, %struct.gv.163*, i8*, %struct.gv.163*, i8*, %struct.gv.163*, i16, i8, i8 }
%struct._PerlIO = type { %struct._PerlIO*, %struct._PerlIO_funcs*, i64 }
%struct._PerlIO_funcs = type { i64, i8*, i64, i64, i64 (%struct._PerlIO**, i8*, %struct.sv*, %struct._PerlIO_funcs*)*, i64 (%struct._PerlIO**)*, %struct._PerlIO** (%struct._PerlIO_funcs*, %struct.PerlIO_list_s*, i64, i8*, i32, i32, i32, %struct._PerlIO**, i32, %struct.sv**)*, i64 (%struct._PerlIO**)*, %struct.sv* (%struct._PerlIO**, %struct.clone_params*, i32)*, i64 (%struct._PerlIO**)*, %struct._PerlIO** (%struct._PerlIO**, %struct._PerlIO**, %struct.clone_params*, i32)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i64, i32)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, void (%struct._PerlIO**)*, void (%struct._PerlIO**)*, i8* (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i8* (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, void (%struct._PerlIO**, i8*, i64)* }
%struct.PerlIO_list_s = type { i64, i64, i64, %struct.PerlIO_pair_t* }
%struct.PerlIO_pair_t = type { %struct._PerlIO_funcs*, %struct.sv* }
%struct.clone_params = type { %struct.av*, i64, %struct.interpreter* }
%struct.av = type { %struct.xpvav*, i64, i64 }
%struct.xpvav = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.sv**, %struct.sv*, i8 }
%struct.magic = type { %struct.magic*, %struct.mgvtbl*, i16, i8, i8, %struct.sv*, i8*, i64 }
%struct.mgvtbl = type { i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i64 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*, %struct.sv*, i8*, i32)*, i32 (%struct.magic*, %struct.clone_params*)* }
%struct.hv = type { %struct.xpvhv*, i64, i64 }
%struct.xpvhv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, i64, %struct.he*, %struct.pmop*, i8* }
%struct.pmop = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8, %struct.op*, %struct.op*, %struct.op*, %struct.op*, %struct.pmop*, %struct.regexp*, i64, i64, i8, %struct.hv* }
%struct.op = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8 }
%union.anon.0 = type { %struct.__dirstream* }
%struct.__dirstream = type opaque
%struct.cv.160 = type { %struct.xpvcv.159*, i64, i64 }
%struct.xpvcv.159 = type { i8*, i64, i64, i64, double, %struct.magic.143*, %struct.hv.152*, %struct.hv.152*, %struct.op.136*, %struct.op.136*, void (%struct.cv.160*)*, %union.any, %struct.gv.163*, i8*, i64, %struct.av.139*, %struct.cv.160*, i16, i64 }
%union.any = type { i8* }
%struct.sv = type { i8*, i64, i64 }
%struct.xpviv = type { i8*, i64, i64, i64 }
%struct.xpvnv = type { i8*, i64, i64, i64, double }
%struct.cop = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8, i8*, %struct.hv*, %struct.gv*, i64, i64, i64, %struct.sv*, %struct.sv* }
%struct.gv = type { %struct.xpvgv*, i64, i64 }
%struct.xpvgv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.gp*, i8*, i64, %struct.hv*, i8 }
%struct.gp = type { %struct.sv*, i64, %struct.io*, %struct.cv*, %struct.av*, %struct.hv*, %struct.gv*, %struct.cv*, i64, i64, i64, i8* }
%struct.io = type { %struct.xpvio*, i64, i64 }
%struct.xpvio = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct._PerlIO**, %struct._PerlIO**, %union.anon.0, i64, i64, i64, i64, i8*, %struct.gv*, i8*, %struct.gv*, i8*, %struct.gv*, i16, i8, i8 }
%struct.cv = type { %struct.xpvcv*, i64, i64 }
%struct.xpvcv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.hv*, %struct.op*, %struct.op*, void (%struct.cv*)*, %union.any, %struct.gv*, i8*, i64, %struct.av*, %struct.cv*, i16, i64 }
%struct.xrv = type { %struct.sv* }

@PL_localizing = external local_unnamed_addr global i32, align 4
@PL_curcop = external global %struct.cop.164*, align 8
@PL_dowarn = external local_unnamed_addr global i8, align 1
@PL_sv_undef = external global %struct.sv, align 8

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.sv* @Perl_amagic_call(%struct.sv*, %struct.sv*, i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @Perl_mg_get(%struct.sv*) local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare i64 @Perl_cast_iv(double) local_unnamed_addr #2

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare i64 @Perl_cast_uv(double) local_unnamed_addr #2

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @Perl_grok_number(i8*, i64, i64*) local_unnamed_addr #3

; Function Attrs: nofree noinline nounwind optsize uwtable
declare double @Perl_my_atof(i8*) local_unnamed_addr #3

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare i32 @Perl_sv_backoff(%struct.sv* nocapture) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare signext i8 @Perl_sv_upgrade(%struct.sv*, i64) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_sv_force_normal(%struct.sv*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_report_uninit() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
define i64 @Perl_sv_2iv(%struct.sv* %sv) local_unnamed_addr #1 {
entry:
  %value = alloca i64, align 8
  %tobool.not = icmp eq %struct.sv* %sv, null
  br i1 %tobool.not, label %return, label %if.end

if.end:                                           ; preds = %entry
  %sv_flags = getelementptr inbounds %struct.sv, %struct.sv* %sv, i64 0, i32 2
  %0 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and = and i64 %0, 8192
  %tobool1.not = icmp eq i64 %and, 0
  br i1 %tobool1.not, label %if.end55, label %if.then2

if.then2:                                         ; preds = %if.end
  %call = tail call i32 @Perl_mg_get(%struct.sv* nonnull %sv) #5
  %1 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and4 = and i64 %1, 16777216
  %tobool5.not = icmp eq i64 %and4, 0
  br i1 %tobool5.not, label %if.end7, label %if.then6

if.then6:                                         ; preds = %if.then2
  %2 = bitcast %struct.sv* %sv to %struct.xpviv**
  %3 = load %struct.xpviv*, %struct.xpviv** %2, align 8, !tbaa !10
  %xiv_iv = getelementptr inbounds %struct.xpviv, %struct.xpviv* %3, i64 0, i32 3
  %4 = load i64, i64* %xiv_iv, align 8, !tbaa !11
  br label %return

if.end7:                                          ; preds = %if.then2
  %and9 = and i64 %1, 33554432
  %tobool10.not = icmp eq i64 %and9, 0
  br i1 %tobool10.not, label %if.end14, label %if.then11

if.then11:                                        ; preds = %if.end7
  %5 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %6 = load %struct.xpvnv*, %struct.xpvnv** %5, align 8, !tbaa !10
  %xnv_nv = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %6, i64 0, i32 4
  %7 = load double, double* %xnv_nv, align 8, !tbaa !13
  %call13 = tail call i64 @Perl_cast_iv(double %7) #5
  br label %return

if.end14:                                         ; preds = %if.end7
  %and16 = and i64 %1, 67108864
  %tobool17.not = icmp eq i64 %and16, 0
  br i1 %tobool17.not, label %if.end22, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.end14
  %8 = bitcast %struct.sv* %sv to %struct.sv**
  %9 = load %struct.sv*, %struct.sv** %8, align 8, !tbaa !10
  %xpv_len = getelementptr inbounds %struct.sv, %struct.sv* %9, i64 0, i32 2
  %10 = load i64, i64* %xpv_len, align 8, !tbaa !16
  %tobool19.not = icmp eq i64 %10, 0
  br i1 %tobool19.not, label %if.end22, label %if.then20

if.then20:                                        ; preds = %land.lhs.true
  %call21 = tail call fastcc i64 @S_asIV(%struct.sv* nonnull %sv) #6
  br label %return

if.end22:                                         ; preds = %land.lhs.true, %if.end14
  %and24 = and i64 %1, 524288
  %tobool25.not = icmp eq i64 %and24, 0
  br i1 %tobool25.not, label %if.then26, label %if.end55

if.then26:                                        ; preds = %if.end22
  %and28 = and i64 %1, 512
  %tobool29.not = icmp eq i64 %and28, 0
  br i1 %tobool29.not, label %if.then30, label %return

if.then30:                                        ; preds = %if.then26
  %11 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings = getelementptr inbounds %struct.cop, %struct.cop* %11, i64 0, i32 14
  %12 = load %struct.sv*, %struct.sv** %cop_warnings, align 8, !tbaa !19
  %cmp.not = icmp eq %struct.sv* %12, null
  br i1 %cmp.not, label %lor.lhs.false41, label %land.lhs.true31

land.lhs.true31:                                  ; preds = %if.then30
  %13 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings32 = getelementptr inbounds %struct.cop, %struct.cop* %13, i64 0, i32 14
  %14 = load %struct.sv*, %struct.sv** %cop_warnings32, align 8, !tbaa !19
  %cmp33.not = icmp eq %struct.sv* %14, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp33.not, label %lor.lhs.false41, label %land.lhs.true34

land.lhs.true34:                                  ; preds = %land.lhs.true31
  %15 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings35 = getelementptr inbounds %struct.cop, %struct.cop* %15, i64 0, i32 14
  %16 = load %struct.sv*, %struct.sv** %cop_warnings35, align 8, !tbaa !19
  %cmp36 = icmp eq %struct.sv* %16, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp36, label %land.lhs.true49, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true34
  %17 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings37 = getelementptr inbounds %struct.cop, %struct.cop* %17, i64 0, i32 14
  %18 = bitcast %struct.sv** %cop_warnings37 to %struct.sv***
  %19 = load %struct.sv**, %struct.sv*** %18, align 8, !tbaa !19
  %20 = load %struct.sv*, %struct.sv** %19, align 8, !tbaa !10
  %xpv_pv = getelementptr inbounds %struct.sv, %struct.sv* %20, i64 0, i32 0
  %21 = load i8*, i8** %xpv_pv, align 8, !tbaa !22
  %arrayidx = getelementptr inbounds i8, i8* %21, i64 10
  %22 = load i8, i8* %arrayidx, align 1, !tbaa !23
  %23 = and i8 %22, 4
  %tobool40.not = icmp eq i8 %23, 0
  br i1 %tobool40.not, label %lor.lhs.false41, label %land.lhs.true49

lor.lhs.false41:                                  ; preds = %lor.lhs.false, %land.lhs.true31, %if.then30
  %24 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings42 = getelementptr inbounds %struct.cop, %struct.cop* %24, i64 0, i32 14
  %25 = load %struct.sv*, %struct.sv** %cop_warnings42, align 8, !tbaa !19
  %cmp43 = icmp eq %struct.sv* %25, null
  br i1 %cmp43, label %land.lhs.true45, label %return

land.lhs.true45:                                  ; preds = %lor.lhs.false41
  %26 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %27 = and i8 %26, 1
  %tobool48 = icmp eq i8 %27, 0
  %28 = load i32, i32* @PL_localizing, align 4
  %tobool50 = icmp ne i32 %28, 0
  %or.cond = select i1 %tobool48, i1 true, i1 %tobool50
  br i1 %or.cond, label %return, label %if.then51

land.lhs.true49:                                  ; preds = %lor.lhs.false, %land.lhs.true34
  %.old = load i32, i32* @PL_localizing, align 4, !tbaa !24
  %tobool50.old.not = icmp eq i32 %.old, 0
  br i1 %tobool50.old.not, label %if.then51, label %return

if.then51:                                        ; preds = %land.lhs.true45, %land.lhs.true49
  tail call void @Perl_report_uninit() #6
  br label %return

if.end55:                                         ; preds = %if.end22, %if.end
  %29 = phi i64 [ %1, %if.end22 ], [ %0, %if.end ]
  %and57 = and i64 %29, 9961472
  %tobool58.not = icmp eq i64 %and57, 0
  br i1 %tobool58.not, label %if.end138, label %if.then59

if.then59:                                        ; preds = %if.end55
  %and61 = and i64 %29, 524288
  %tobool62.not = icmp eq i64 %and61, 0
  br i1 %tobool62.not, label %if.end90, label %if.then63

if.then63:                                        ; preds = %if.then59
  %and65 = and i64 %29, 268435456
  %tobool66.not = icmp eq i64 %and65, 0
  br i1 %tobool66.not, label %if.end87, label %land.lhs.true67

land.lhs.true67:                                  ; preds = %if.then63
  %call68 = tail call %struct.sv* @Perl_amagic_call(%struct.sv* nonnull %sv, %struct.sv* nonnull @PL_sv_undef, i32 5, i32 9) #5
  %tobool69.not = icmp eq %struct.sv* %call68, null
  br i1 %tobool69.not, label %if.end87, label %land.lhs.true70

land.lhs.true70:                                  ; preds = %land.lhs.true67
  %sv_flags71 = getelementptr inbounds %struct.sv, %struct.sv* %call68, i64 0, i32 2
  %30 = load i64, i64* %sv_flags71, align 8, !tbaa !4
  %and72 = and i64 %30, 524288
  %tobool73.not = icmp eq i64 %and72, 0
  br i1 %tobool73.not, label %if.then80, label %lor.lhs.false74

lor.lhs.false74:                                  ; preds = %land.lhs.true70
  %31 = bitcast %struct.sv* %call68 to %struct.xrv**
  %32 = load %struct.xrv*, %struct.xrv** %31, align 8, !tbaa !10
  %xrv_rv = getelementptr inbounds %struct.xrv, %struct.xrv* %32, i64 0, i32 0
  %33 = load %struct.sv*, %struct.sv** %xrv_rv, align 8, !tbaa !26
  %34 = bitcast %struct.sv* %sv to %struct.xrv**
  %35 = load %struct.xrv*, %struct.xrv** %34, align 8, !tbaa !10
  %xrv_rv77 = getelementptr inbounds %struct.xrv, %struct.xrv* %35, i64 0, i32 0
  %36 = load %struct.sv*, %struct.sv** %xrv_rv77, align 8, !tbaa !26
  %cmp78.not = icmp eq %struct.sv* %33, %36
  br i1 %cmp78.not, label %if.end87, label %if.then80

if.then80:                                        ; preds = %lor.lhs.false74, %land.lhs.true70
  %and82 = and i64 %30, 65536
  %tobool83.not = icmp eq i64 %and82, 0
  br i1 %tobool83.not, label %cond.false, label %cond.true

cond.true:                                        ; preds = %if.then80
  %37 = bitcast %struct.sv* %call68 to %struct.xpviv**
  %38 = load %struct.xpviv*, %struct.xpviv** %37, align 8, !tbaa !10
  %xiv_iv85 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %38, i64 0, i32 3
  %39 = load i64, i64* %xiv_iv85, align 8, !tbaa !11
  br label %return

cond.false:                                       ; preds = %if.then80
  %call86 = tail call i64 @Perl_sv_2iv(%struct.sv* nonnull %call68) #6
  br label %return

if.end87:                                         ; preds = %lor.lhs.false74, %land.lhs.true67, %if.then63
  %40 = bitcast %struct.sv* %sv to %struct.xrv**
  %41 = load %struct.xrv*, %struct.xrv** %40, align 8, !tbaa !10
  %xrv_rv89 = getelementptr inbounds %struct.xrv, %struct.xrv* %41, i64 0, i32 0
  %42 = load %struct.sv*, %struct.sv** %xrv_rv89, align 8, !tbaa !26
  %43 = ptrtoint %struct.sv* %42 to i64
  br label %return

if.end90:                                         ; preds = %if.then59
  %44 = and i64 %29, 9437184
  %.not = icmp eq i64 %44, 9437184
  br i1 %.not, label %if.then98, label %if.end99

if.then98:                                        ; preds = %if.end90
  tail call void @Perl_sv_force_normal(%struct.sv* nonnull %sv) #6
  %.pre = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end99

if.end99:                                         ; preds = %if.then98, %if.end90
  %45 = phi i64 [ %.pre, %if.then98 ], [ %29, %if.end90 ]
  %46 = and i64 %45, 126812160
  %47 = icmp eq i64 %46, 8388608
  br i1 %47, label %if.then107, label %if.end138

if.then107:                                       ; preds = %if.end99
  %48 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings108 = getelementptr inbounds %struct.cop, %struct.cop* %48, i64 0, i32 14
  %49 = load %struct.sv*, %struct.sv** %cop_warnings108, align 8, !tbaa !19
  %cmp109.not = icmp eq %struct.sv* %49, null
  br i1 %cmp109.not, label %lor.lhs.false127, label %land.lhs.true111

land.lhs.true111:                                 ; preds = %if.then107
  %50 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings112 = getelementptr inbounds %struct.cop, %struct.cop* %50, i64 0, i32 14
  %51 = load %struct.sv*, %struct.sv** %cop_warnings112, align 8, !tbaa !19
  %cmp113.not = icmp eq %struct.sv* %51, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp113.not, label %lor.lhs.false127, label %land.lhs.true115

land.lhs.true115:                                 ; preds = %land.lhs.true111
  %52 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings116 = getelementptr inbounds %struct.cop, %struct.cop* %52, i64 0, i32 14
  %53 = load %struct.sv*, %struct.sv** %cop_warnings116, align 8, !tbaa !19
  %cmp117 = icmp eq %struct.sv* %53, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp117, label %if.then135, label %lor.lhs.false119

lor.lhs.false119:                                 ; preds = %land.lhs.true115
  %54 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings120 = getelementptr inbounds %struct.cop, %struct.cop* %54, i64 0, i32 14
  %55 = bitcast %struct.sv** %cop_warnings120 to %struct.sv***
  %56 = load %struct.sv**, %struct.sv*** %55, align 8, !tbaa !19
  %57 = load %struct.sv*, %struct.sv** %56, align 8, !tbaa !10
  %xpv_pv122 = getelementptr inbounds %struct.sv, %struct.sv* %57, i64 0, i32 0
  %58 = load i8*, i8** %xpv_pv122, align 8, !tbaa !22
  %arrayidx123 = getelementptr inbounds i8, i8* %58, i64 10
  %59 = load i8, i8* %arrayidx123, align 1, !tbaa !23
  %60 = and i8 %59, 4
  %tobool126.not = icmp eq i8 %60, 0
  br i1 %tobool126.not, label %lor.lhs.false127, label %if.then135

lor.lhs.false127:                                 ; preds = %lor.lhs.false119, %land.lhs.true111, %if.then107
  %61 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings128 = getelementptr inbounds %struct.cop, %struct.cop* %61, i64 0, i32 14
  %62 = load %struct.sv*, %struct.sv** %cop_warnings128, align 8, !tbaa !19
  %cmp129 = icmp eq %struct.sv* %62, null
  br i1 %cmp129, label %land.lhs.true131, label %return

land.lhs.true131:                                 ; preds = %lor.lhs.false127
  %63 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %64 = and i8 %63, 1
  %tobool134.not = icmp eq i8 %64, 0
  br i1 %tobool134.not, label %return, label %if.then135

if.then135:                                       ; preds = %land.lhs.true131, %lor.lhs.false119, %land.lhs.true115
  tail call void @Perl_report_uninit() #6
  br label %return

if.end138:                                        ; preds = %if.end99, %if.end55
  %65 = phi i64 [ %45, %if.end99 ], [ %29, %if.end55 ]
  %and140 = and i64 %65, 16777216
  %tobool141.not = icmp eq i64 %and140, 0
  br i1 %tobool141.not, label %if.end150, label %if.then142

if.then142:                                       ; preds = %if.end138
  %66 = trunc i64 %65 to i32
  %tobool145.not = icmp sgt i32 %66, -1
  br i1 %tobool145.not, label %if.else, label %if.then146

if.then146:                                       ; preds = %if.then142
  %67 = bitcast %struct.sv* %sv to %struct.xpviv**
  %68 = load %struct.xpviv*, %struct.xpviv** %67, align 8, !tbaa !10
  %xuv_uv = getelementptr inbounds %struct.xpviv, %struct.xpviv* %68, i64 0, i32 3
  %69 = load i64, i64* %xuv_uv, align 8, !tbaa !28
  br label %return

if.else:                                          ; preds = %if.then142
  %70 = bitcast %struct.sv* %sv to %struct.xpviv**
  %71 = load %struct.xpviv*, %struct.xpviv** %70, align 8, !tbaa !10
  %xiv_iv149 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %71, i64 0, i32 3
  %72 = load i64, i64* %xiv_iv149, align 8, !tbaa !11
  br label %return

if.end150:                                        ; preds = %if.end138
  %and152 = and i64 %65, 33554432
  %tobool153.not = icmp eq i64 %and152, 0
  br i1 %tobool153.not, label %if.else228, label %if.then154

if.then154:                                       ; preds = %if.end150
  %and156 = and i64 %65, 255
  %cmp157 = icmp eq i64 %and156, 2
  br i1 %cmp157, label %if.then159, label %if.end161

if.then159:                                       ; preds = %if.then154
  %call160 = tail call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 6) #6
  %.pre656 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end161

if.end161:                                        ; preds = %if.then159, %if.then154
  %73 = phi i64 [ %.pre656, %if.then159 ], [ %65, %if.then154 ]
  %and163 = and i64 %73, 2097152
  %tobool164.not = icmp eq i64 %and163, 0
  br i1 %tobool164.not, label %land.end, label %land.rhs

land.rhs:                                         ; preds = %if.end161
  %call165 = tail call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre657 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end

land.end:                                         ; preds = %land.rhs, %if.end161
  %74 = phi i64 [ %.pre657, %land.rhs ], [ %73, %if.end161 ]
  %or = or i64 %74, 16777216
  store i64 %or, i64* %sv_flags, align 8, !tbaa !4
  %75 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %76 = load %struct.xpvnv*, %struct.xpvnv** %75, align 8, !tbaa !10
  %xnv_nv169 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %76, i64 0, i32 4
  %77 = load double, double* %xnv_nv169, align 8, !tbaa !13
  %cmp170 = fcmp olt double %77, 0x43E0000000000000
  br i1 %cmp170, label %if.then172, label %if.else198

if.then172:                                       ; preds = %land.end
  %call175 = tail call i64 @Perl_cast_iv(double %77) #5
  %78 = bitcast %struct.sv* %sv to %struct.xpviv**
  %79 = load %struct.xpviv*, %struct.xpviv** %78, align 8, !tbaa !10
  %xiv_iv177 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %79, i64 0, i32 3
  store i64 %call175, i64* %xiv_iv177, align 8, !tbaa !11
  %xnv_nv179 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %79, i64 1
  %80 = bitcast %struct.xpviv* %xnv_nv179 to double*
  %81 = load double, double* %80, align 8, !tbaa !13
  %conv182 = sitofp i64 %call175 to double
  %cmp183 = fcmp oeq double %81, %conv182
  br i1 %cmp183, label %if.then185, label %if.end508

if.then185:                                       ; preds = %if.then172
  %82 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and187 = and i64 %82, 2097152
  %tobool188.not = icmp eq i64 %and187, 0
  br i1 %tobool188.not, label %land.end192, label %land.rhs189

land.rhs189:                                      ; preds = %if.then185
  %call190 = tail call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre660 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end192

land.end192:                                      ; preds = %land.rhs189, %if.then185
  %83 = phi i64 [ %.pre660, %land.rhs189 ], [ %82, %if.then185 ]
  %or195 = or i64 %83, 16842752
  store i64 %or195, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end508

if.else198:                                       ; preds = %land.end
  %call201 = tail call i64 @Perl_cast_uv(double %77) #5
  %84 = bitcast %struct.sv* %sv to %struct.xpviv**
  %85 = load %struct.xpviv*, %struct.xpviv** %84, align 8, !tbaa !10
  %xuv_uv203 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %85, i64 0, i32 3
  store i64 %call201, i64* %xuv_uv203, align 8, !tbaa !28
  %xnv_nv205 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %85, i64 1
  %86 = bitcast %struct.xpviv* %xnv_nv205 to double*
  %87 = load double, double* %86, align 8, !tbaa !13
  %conv208 = uitofp i64 %call201 to double
  %cmp209 = fcmp oeq double %87, %conv208
  %88 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br i1 %cmp209, label %if.then211, label %if.end222

if.then211:                                       ; preds = %if.else198
  %and213 = and i64 %88, 2097152
  %tobool214.not = icmp eq i64 %and213, 0
  br i1 %tobool214.not, label %land.end218, label %land.rhs215

land.rhs215:                                      ; preds = %if.then211
  %call216 = tail call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre658 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end218

land.end218:                                      ; preds = %land.rhs215, %if.then211
  %89 = phi i64 [ %.pre658, %land.rhs215 ], [ %88, %if.then211 ]
  %or221 = or i64 %89, 16842752
  br label %if.end222

if.end222:                                        ; preds = %if.else198, %land.end218
  %90 = phi i64 [ %or221, %land.end218 ], [ %88, %if.else198 ]
  %or224 = or i64 %90, 2147483648
  store i64 %or224, i64* %sv_flags, align 8, !tbaa !4
  br label %ret_iv_max

ret_iv_max:                                       ; preds = %if.then422, %if.else455, %land.end449, %if.end222
  %.pre-phi = bitcast %struct.sv* %sv to %struct.xpviv**
  %91 = load %struct.xpviv*, %struct.xpviv** %.pre-phi, align 8, !tbaa !10
  %xuv_uv226 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %91, i64 0, i32 3
  %92 = load i64, i64* %xuv_uv226, align 8, !tbaa !28
  br label %return

if.else228:                                       ; preds = %if.end150
  %and230 = and i64 %65, 67108864
  %tobool231.not = icmp eq i64 %and230, 0
  br i1 %tobool231.not, label %if.else464, label %land.lhs.true232

land.lhs.true232:                                 ; preds = %if.else228
  %93 = bitcast %struct.sv* %sv to %struct.sv**
  %94 = load %struct.sv*, %struct.sv** %93, align 8, !tbaa !10
  %xpv_len234 = getelementptr inbounds %struct.sv, %struct.sv* %94, i64 0, i32 2
  %95 = load i64, i64* %xpv_len234, align 8, !tbaa !16
  %tobool235.not = icmp eq i64 %95, 0
  br i1 %tobool235.not, label %if.else464, label %if.then236

if.then236:                                       ; preds = %land.lhs.true232
  %96 = bitcast i64* %value to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %96) #7
  %xpv_pv238 = getelementptr inbounds %struct.sv, %struct.sv* %94, i64 0, i32 0
  %97 = load i8*, i8** %xpv_pv238, align 8, !tbaa !22
  %xpv_cur = getelementptr inbounds %struct.sv, %struct.sv* %94, i64 0, i32 1
  %98 = load i64, i64* %xpv_cur, align 8, !tbaa !30
  %call240 = call i32 @Perl_grok_number(i8* %97, i64 %98, i64* nonnull %value) #5
  %and241 = and i32 %call240, 5
  %cmp242 = icmp eq i32 %and241, 1
  %99 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br i1 %cmp242, label %if.then244, label %if.else262

if.then244:                                       ; preds = %if.then236
  %and246 = and i64 %99, 255
  %cmp247 = icmp ult i64 %and246, 5
  br i1 %cmp247, label %if.then249, label %if.end251

if.then249:                                       ; preds = %if.then244
  %call250 = call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 5) #6
  %.pre664 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end251

if.end251:                                        ; preds = %if.then249, %if.then244
  %100 = phi i64 [ %.pre664, %if.then249 ], [ %99, %if.then244 ]
  %and253 = and i64 %100, 2097152
  %tobool254.not = icmp eq i64 %and253, 0
  br i1 %tobool254.not, label %if.then274.thread, label %if.then274

if.then274.thread:                                ; preds = %if.end251
  %or261672 = or i64 %100, 16842752
  br label %land.end281

if.else262:                                       ; preds = %if.then236
  %and264 = and i64 %99, 254
  %cmp265 = icmp ult i64 %and264, 6
  br i1 %cmp265, label %if.then267, label %if.then338

if.then267:                                       ; preds = %if.else262
  %call268 = call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 6) #6
  br label %if.then338

if.then274:                                       ; preds = %if.end251
  %call256 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre665 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %.pre670 = and i64 %.pre665, 2097152
  %or261 = or i64 %.pre665, 16842752
  store i64 %or261, i64* %sv_flags, align 8, !tbaa !4
  %tobool277.not = icmp eq i64 %.pre670, 0
  br i1 %tobool277.not, label %land.end281, label %land.rhs278

land.rhs278:                                      ; preds = %if.then274
  %call279 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre666 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end281

land.end281:                                      ; preds = %if.then274.thread, %land.rhs278, %if.then274
  %101 = phi i64 [ %.pre666, %land.rhs278 ], [ %or261, %if.then274 ], [ %or261672, %if.then274.thread ]
  %or284 = or i64 %101, 16777216
  store i64 %or284, i64* %sv_flags, align 8, !tbaa !4
  %and285 = and i32 %call240, 8
  %tobool286.not = icmp eq i32 %and285, 0
  %102 = load i64, i64* %value, align 8, !tbaa !31
  br i1 %tobool286.not, label %if.then287, label %if.else299

if.then287:                                       ; preds = %land.end281
  %cmp288 = icmp sgt i64 %102, -1
  br i1 %cmp288, label %if.then290, label %if.else293

if.then290:                                       ; preds = %if.then287
  %103 = bitcast %struct.sv* %sv to %struct.xpviv**
  %104 = load %struct.xpviv*, %struct.xpviv** %103, align 8, !tbaa !10
  %xiv_iv292 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %104, i64 0, i32 3
  store i64 %102, i64* %xiv_iv292, align 8, !tbaa !11
  br label %cleanup462

if.else293:                                       ; preds = %if.then287
  %105 = bitcast %struct.sv* %sv to %struct.xpviv**
  %106 = load %struct.xpviv*, %struct.xpviv** %105, align 8, !tbaa !10
  %xuv_uv295 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %106, i64 0, i32 3
  store i64 %102, i64* %xuv_uv295, align 8, !tbaa !28
  %or297 = or i64 %101, 2164260864
  store i64 %or297, i64* %sv_flags, align 8, !tbaa !4
  br label %cleanup462

if.else299:                                       ; preds = %land.end281
  %cmp300 = icmp ult i64 %102, -9223372036854775807
  br i1 %cmp300, label %if.then302, label %if.else305

if.then302:                                       ; preds = %if.else299
  %sub = sub nsw i64 0, %102
  %107 = bitcast %struct.sv* %sv to %struct.xpviv**
  %108 = load %struct.xpviv*, %struct.xpviv** %107, align 8, !tbaa !10
  %xiv_iv304 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %108, i64 0, i32 3
  store i64 %sub, i64* %xiv_iv304, align 8, !tbaa !11
  br label %cleanup462

if.else305:                                       ; preds = %if.else299
  %and307 = and i64 %101, 254
  %cmp308 = icmp ult i64 %and307, 6
  br i1 %cmp308, label %if.then310, label %if.end312

if.then310:                                       ; preds = %if.else305
  %call311 = call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 6) #6
  %.pre667 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end312

if.end312:                                        ; preds = %if.then310, %if.else305
  %109 = phi i64 [ %.pre667, %if.then310 ], [ %or284, %if.else305 ]
  %or314 = and i64 %109, 2096955391
  %and316 = or i64 %or314, 33685504
  store i64 %and316, i64* %sv_flags, align 8, !tbaa !4
  %and318 = and i64 %109, 2097152
  %tobool319.not = icmp eq i64 %and318, 0
  br i1 %tobool319.not, label %land.end323, label %land.rhs320

land.rhs320:                                      ; preds = %if.end312
  %call321 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre668 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end323

land.end323:                                      ; preds = %land.rhs320, %if.end312
  %110 = phi i64 [ %.pre668, %land.rhs320 ], [ %and316, %if.end312 ]
  %or326 = or i64 %110, 16777216
  store i64 %or326, i64* %sv_flags, align 8, !tbaa !4
  %111 = load i64, i64* %value, align 8, !tbaa !31
  %conv327 = uitofp i64 %111 to double
  %fneg = fneg double %conv327
  %112 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %113 = load %struct.xpvnv*, %struct.xpvnv** %112, align 8, !tbaa !10
  %xnv_nv329 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %113, i64 0, i32 4
  store double %fneg, double* %xnv_nv329, align 8, !tbaa !13
  %114 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %113, i64 0, i32 3
  store i64 -9223372036854775808, i64* %114, align 8, !tbaa !11
  br label %cleanup462

if.then338:                                       ; preds = %if.then267, %if.else262
  %115 = load %struct.sv*, %struct.sv** %93, align 8, !tbaa !10
  %xpv_pv340 = getelementptr inbounds %struct.sv, %struct.sv* %115, i64 0, i32 0
  %116 = load i8*, i8** %xpv_pv340, align 8, !tbaa !22
  %call341 = call double @Perl_my_atof(i8* %116) #5
  %117 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %118 = load %struct.xpvnv*, %struct.xpvnv** %117, align 8, !tbaa !10
  %xnv_nv343 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %118, i64 0, i32 4
  store double %call341, double* %xnv_nv343, align 8, !tbaa !13
  %tobool344.not = icmp eq i32 %call240, 0
  br i1 %tobool344.not, label %land.lhs.true345, label %if.end374

land.lhs.true345:                                 ; preds = %if.then338
  %119 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings346 = getelementptr inbounds %struct.cop, %struct.cop* %119, i64 0, i32 14
  %120 = load %struct.sv*, %struct.sv** %cop_warnings346, align 8, !tbaa !19
  %cmp347.not = icmp eq %struct.sv* %120, null
  br i1 %cmp347.not, label %lor.lhs.false365, label %land.lhs.true349

land.lhs.true349:                                 ; preds = %land.lhs.true345
  %121 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings350 = getelementptr inbounds %struct.cop, %struct.cop* %121, i64 0, i32 14
  %122 = load %struct.sv*, %struct.sv** %cop_warnings350, align 8, !tbaa !19
  %cmp351.not = icmp eq %struct.sv* %122, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp351.not, label %lor.lhs.false365, label %land.lhs.true353

land.lhs.true353:                                 ; preds = %land.lhs.true349
  %123 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings354 = getelementptr inbounds %struct.cop, %struct.cop* %123, i64 0, i32 14
  %124 = load %struct.sv*, %struct.sv** %cop_warnings354, align 8, !tbaa !19
  %cmp355 = icmp eq %struct.sv* %124, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp355, label %if.then373, label %lor.lhs.false357

lor.lhs.false357:                                 ; preds = %land.lhs.true353
  %125 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings358 = getelementptr inbounds %struct.cop, %struct.cop* %125, i64 0, i32 14
  %126 = bitcast %struct.sv** %cop_warnings358 to %struct.sv***
  %127 = load %struct.sv**, %struct.sv*** %126, align 8, !tbaa !19
  %128 = load %struct.sv*, %struct.sv** %127, align 8, !tbaa !10
  %xpv_pv360 = getelementptr inbounds %struct.sv, %struct.sv* %128, i64 0, i32 0
  %129 = load i8*, i8** %xpv_pv360, align 8, !tbaa !22
  %arrayidx361 = getelementptr inbounds i8, i8* %129, i64 3
  %130 = load i8, i8* %arrayidx361, align 1, !tbaa !23
  %131 = and i8 %130, 4
  %tobool364.not = icmp eq i8 %131, 0
  br i1 %tobool364.not, label %lor.lhs.false365, label %if.then373

lor.lhs.false365:                                 ; preds = %lor.lhs.false357, %land.lhs.true349, %land.lhs.true345
  %132 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings366 = getelementptr inbounds %struct.cop, %struct.cop* %132, i64 0, i32 14
  %133 = load %struct.sv*, %struct.sv** %cop_warnings366, align 8, !tbaa !19
  %cmp367 = icmp eq %struct.sv* %133, null
  br i1 %cmp367, label %land.lhs.true369, label %if.end374

land.lhs.true369:                                 ; preds = %lor.lhs.false365
  %134 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %135 = and i8 %134, 1
  %tobool372.not = icmp eq i8 %135, 0
  br i1 %tobool372.not, label %if.end374, label %if.then373

if.then373:                                       ; preds = %land.lhs.true369, %lor.lhs.false357, %land.lhs.true353
  call fastcc void @S_not_a_number(%struct.sv* nonnull %sv) #6
  br label %if.end374

if.end374:                                        ; preds = %if.then373, %land.lhs.true369, %lor.lhs.false365, %if.then338
  %136 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and376 = and i64 %136, 2097152
  %tobool377.not = icmp eq i64 %and376, 0
  br i1 %tobool377.not, label %land.end381, label %land.rhs378

land.rhs378:                                      ; preds = %if.end374
  %call379 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre661 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end381

land.end381:                                      ; preds = %land.rhs378, %if.end374
  %137 = phi i64 [ %.pre661, %land.rhs378 ], [ %136, %if.end374 ]
  %or386 = or i64 %137, 50462720
  store i64 %or386, i64* %sv_flags, align 8, !tbaa !4
  %138 = load %struct.xpvnv*, %struct.xpvnv** %117, align 8, !tbaa !10
  %xnv_nv388 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %138, i64 0, i32 4
  %139 = load double, double* %xnv_nv388, align 8, !tbaa !13
  %cmp389 = fcmp olt double %139, 0x43E0000000000000
  br i1 %cmp389, label %if.then391, label %if.else417

if.then391:                                       ; preds = %land.end381
  %call394 = call i64 @Perl_cast_iv(double %139) #5
  %140 = bitcast %struct.sv* %sv to %struct.xpviv**
  %141 = load %struct.xpviv*, %struct.xpviv** %140, align 8, !tbaa !10
  %xiv_iv396 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %141, i64 0, i32 3
  store i64 %call394, i64* %xiv_iv396, align 8, !tbaa !11
  %conv399 = sitofp i64 %call394 to double
  %xnv_nv401 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %141, i64 1
  %142 = bitcast %struct.xpviv* %xnv_nv401 to double*
  %143 = load double, double* %142, align 8, !tbaa !13
  %cmp402 = fcmp oeq double %143, %conv399
  br i1 %cmp402, label %if.then404, label %cleanup462

if.then404:                                       ; preds = %if.then391
  %144 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and406 = and i64 %144, 2097152
  %tobool407.not = icmp eq i64 %and406, 0
  br i1 %tobool407.not, label %land.end411, label %land.rhs408

land.rhs408:                                      ; preds = %if.then404
  %call409 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre663 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end411

land.end411:                                      ; preds = %land.rhs408, %if.then404
  %145 = phi i64 [ %.pre663, %land.rhs408 ], [ %144, %if.then404 ]
  %or414 = or i64 %145, 16842752
  store i64 %or414, i64* %sv_flags, align 8, !tbaa !4
  br label %cleanup462

if.else417:                                       ; preds = %land.end381
  %cmp420 = fcmp ogt double %139, 0x43F0000000000000
  br i1 %cmp420, label %if.then422, label %if.else429

if.then422:                                       ; preds = %if.else417
  %or424 = or i64 %137, 2197946368
  %146 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %138, i64 0, i32 3
  store i64 -1, i64* %146, align 8, !tbaa !28
  store i64 %or424, i64* %sv_flags, align 8, !tbaa !4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %96) #7
  br label %ret_iv_max

if.else429:                                       ; preds = %if.else417
  %call432 = call i64 @Perl_cast_uv(double %139) #5
  %147 = bitcast %struct.sv* %sv to %struct.xpviv**
  %148 = load %struct.xpviv*, %struct.xpviv** %147, align 8, !tbaa !10
  %xuv_uv434 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %148, i64 0, i32 3
  store i64 %call432, i64* %xuv_uv434, align 8, !tbaa !28
  %conv437 = uitofp i64 %call432 to double
  %xnv_nv439 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %148, i64 1
  %149 = bitcast %struct.xpviv* %xnv_nv439 to double*
  %150 = load double, double* %149, align 8, !tbaa !13
  %cmp440 = fcmp oeq double %150, %conv437
  %151 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br i1 %cmp440, label %if.then442, label %if.else455

if.then442:                                       ; preds = %if.else429
  %and444 = and i64 %151, 2097152
  %tobool445.not = icmp eq i64 %and444, 0
  br i1 %tobool445.not, label %land.end449, label %land.rhs446

land.rhs446:                                      ; preds = %if.then442
  %call447 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre662 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end449

land.end449:                                      ; preds = %land.rhs446, %if.then442
  %152 = phi i64 [ %.pre662, %land.rhs446 ], [ %151, %if.then442 ]
  %or454 = or i64 %152, 2164326400
  store i64 %or454, i64* %sv_flags, align 8, !tbaa !4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %96) #7
  br label %ret_iv_max

if.else455:                                       ; preds = %if.else429
  %or457 = or i64 %151, 2147483648
  store i64 %or457, i64* %sv_flags, align 8, !tbaa !4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %96) #7
  br label %ret_iv_max

cleanup462:                                       ; preds = %if.then302, %land.end323, %if.then290, %if.else293, %land.end411, %if.then391
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %96) #7
  br label %if.end508

if.else464:                                       ; preds = %land.lhs.true232, %if.else228
  %153 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings465 = getelementptr inbounds %struct.cop, %struct.cop* %153, i64 0, i32 14
  %154 = load %struct.sv*, %struct.sv** %cop_warnings465, align 8, !tbaa !19
  %cmp466.not = icmp eq %struct.sv* %154, null
  br i1 %cmp466.not, label %lor.lhs.false484, label %land.lhs.true468

land.lhs.true468:                                 ; preds = %if.else464
  %155 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings469 = getelementptr inbounds %struct.cop, %struct.cop* %155, i64 0, i32 14
  %156 = load %struct.sv*, %struct.sv** %cop_warnings469, align 8, !tbaa !19
  %cmp470.not = icmp eq %struct.sv* %156, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp470.not, label %lor.lhs.false484, label %land.lhs.true472

land.lhs.true472:                                 ; preds = %land.lhs.true468
  %157 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings473 = getelementptr inbounds %struct.cop, %struct.cop* %157, i64 0, i32 14
  %158 = load %struct.sv*, %struct.sv** %cop_warnings473, align 8, !tbaa !19
  %cmp474 = icmp eq %struct.sv* %158, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp474, label %land.lhs.true492, label %lor.lhs.false476

lor.lhs.false476:                                 ; preds = %land.lhs.true472
  %159 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings477 = getelementptr inbounds %struct.cop, %struct.cop* %159, i64 0, i32 14
  %160 = bitcast %struct.sv** %cop_warnings477 to %struct.sv***
  %161 = load %struct.sv**, %struct.sv*** %160, align 8, !tbaa !19
  %162 = load %struct.sv*, %struct.sv** %161, align 8, !tbaa !10
  %xpv_pv479 = getelementptr inbounds %struct.sv, %struct.sv* %162, i64 0, i32 0
  %163 = load i8*, i8** %xpv_pv479, align 8, !tbaa !22
  %arrayidx480 = getelementptr inbounds i8, i8* %163, i64 10
  %164 = load i8, i8* %arrayidx480, align 1, !tbaa !23
  %165 = and i8 %164, 4
  %tobool483.not = icmp eq i8 %165, 0
  br i1 %tobool483.not, label %lor.lhs.false484, label %land.lhs.true492

lor.lhs.false484:                                 ; preds = %lor.lhs.false476, %land.lhs.true468, %if.else464
  %166 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings485 = getelementptr inbounds %struct.cop, %struct.cop* %166, i64 0, i32 14
  %167 = load %struct.sv*, %struct.sv** %cop_warnings485, align 8, !tbaa !19
  %cmp486 = icmp eq %struct.sv* %167, null
  br i1 %cmp486, label %land.lhs.true488, label %if.end499

land.lhs.true488:                                 ; preds = %lor.lhs.false484
  %168 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %169 = and i8 %168, 1
  %tobool491 = icmp eq i8 %169, 0
  %170 = load i32, i32* @PL_localizing, align 4
  %tobool493 = icmp ne i32 %170, 0
  %or.cond522 = select i1 %tobool491, i1 true, i1 %tobool493
  br i1 %or.cond522, label %if.end499, label %land.lhs.true494

land.lhs.true492:                                 ; preds = %lor.lhs.false476, %land.lhs.true472
  %.old521 = load i32, i32* @PL_localizing, align 4, !tbaa !24
  %tobool493.old.not = icmp eq i32 %.old521, 0
  br i1 %tobool493.old.not, label %land.lhs.true494, label %if.end499

land.lhs.true494:                                 ; preds = %land.lhs.true488, %land.lhs.true492
  %and496 = and i64 %65, 512
  %tobool497.not = icmp eq i64 %and496, 0
  br i1 %tobool497.not, label %if.then498, label %if.end499

if.then498:                                       ; preds = %land.lhs.true494
  tail call void @Perl_report_uninit() #6
  %.pre669 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end499

if.end499:                                        ; preds = %if.then498, %land.lhs.true494, %land.lhs.true492, %land.lhs.true488, %lor.lhs.false484
  %171 = phi i64 [ %.pre669, %if.then498 ], [ %65, %land.lhs.true494 ], [ %65, %land.lhs.true492 ], [ %65, %land.lhs.true488 ], [ %65, %lor.lhs.false484 ]
  %and501 = and i64 %171, 255
  %cmp502 = icmp eq i64 %and501, 0
  br i1 %cmp502, label %if.then504, label %return

if.then504:                                       ; preds = %if.end499
  %call505 = tail call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 1) #6
  br label %return

if.end508:                                        ; preds = %cleanup462, %if.then172, %land.end192
  %172 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %173 = trunc i64 %172 to i32
  %tobool511.not = icmp sgt i32 %173, -1
  br i1 %tobool511.not, label %cond.false515, label %cond.true512

cond.true512:                                     ; preds = %if.end508
  %174 = bitcast %struct.sv* %sv to %struct.xpviv**
  %175 = load %struct.xpviv*, %struct.xpviv** %174, align 8, !tbaa !10
  %xuv_uv514 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %175, i64 0, i32 3
  br label %cond.end518

cond.false515:                                    ; preds = %if.end508
  %176 = bitcast %struct.sv* %sv to %struct.xpviv**
  %177 = load %struct.xpviv*, %struct.xpviv** %176, align 8, !tbaa !10
  %xiv_iv517 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %177, i64 0, i32 3
  br label %cond.end518

cond.end518:                                      ; preds = %cond.false515, %cond.true512
  %cond519.in = phi i64* [ %xuv_uv514, %cond.true512 ], [ %xiv_iv517, %cond.false515 ]
  %cond519 = load i64, i64* %cond519.in, align 8, !tbaa !31
  br label %return

return:                                           ; preds = %if.end499, %if.then504, %lor.lhs.false127, %land.lhs.true131, %if.then135, %if.end87, %cond.false, %cond.true, %if.then26, %if.then51, %land.lhs.true49, %land.lhs.true45, %lor.lhs.false41, %entry, %cond.end518, %ret_iv_max, %if.else, %if.then146, %if.then20, %if.then11, %if.then6
  %retval.1 = phi i64 [ %4, %if.then6 ], [ %call13, %if.then11 ], [ %call21, %if.then20 ], [ %69, %if.then146 ], [ %72, %if.else ], [ %cond519, %cond.end518 ], [ %92, %ret_iv_max ], [ 0, %entry ], [ 0, %lor.lhs.false41 ], [ 0, %land.lhs.true45 ], [ 0, %land.lhs.true49 ], [ 0, %if.then51 ], [ 0, %if.then26 ], [ %43, %if.end87 ], [ %39, %cond.true ], [ %call86, %cond.false ], [ 0, %if.then135 ], [ 0, %land.lhs.true131 ], [ 0, %lor.lhs.false127 ], [ 0, %if.then504 ], [ 0, %if.end499 ]
  ret i64 %retval.1
}

; Function Attrs: noinline nounwind optsize uwtable
define i64 @Perl_sv_2uv(%struct.sv* %sv) local_unnamed_addr #1 {
entry:
  %value = alloca i64, align 8
  %tobool.not = icmp eq %struct.sv* %sv, null
  br i1 %tobool.not, label %return, label %if.end

if.end:                                           ; preds = %entry
  %sv_flags = getelementptr inbounds %struct.sv, %struct.sv* %sv, i64 0, i32 2
  %0 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and = and i64 %0, 8192
  %tobool1.not = icmp eq i64 %and, 0
  br i1 %tobool1.not, label %if.end55, label %if.then2

if.then2:                                         ; preds = %if.end
  %call = tail call i32 @Perl_mg_get(%struct.sv* nonnull %sv) #5
  %1 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and4 = and i64 %1, 16777216
  %tobool5.not = icmp eq i64 %and4, 0
  br i1 %tobool5.not, label %if.end7, label %if.then6

if.then6:                                         ; preds = %if.then2
  %2 = bitcast %struct.sv* %sv to %struct.xpviv**
  %3 = load %struct.xpviv*, %struct.xpviv** %2, align 8, !tbaa !10
  %xuv_uv = getelementptr inbounds %struct.xpviv, %struct.xpviv* %3, i64 0, i32 3
  %4 = load i64, i64* %xuv_uv, align 8, !tbaa !28
  br label %return

if.end7:                                          ; preds = %if.then2
  %and9 = and i64 %1, 33554432
  %tobool10.not = icmp eq i64 %and9, 0
  br i1 %tobool10.not, label %if.end14, label %if.then11

if.then11:                                        ; preds = %if.end7
  %5 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %6 = load %struct.xpvnv*, %struct.xpvnv** %5, align 8, !tbaa !10
  %xnv_nv = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %6, i64 0, i32 4
  %7 = load double, double* %xnv_nv, align 8, !tbaa !13
  %call13 = tail call i64 @Perl_cast_uv(double %7) #5
  br label %return

if.end14:                                         ; preds = %if.end7
  %and16 = and i64 %1, 67108864
  %tobool17.not = icmp eq i64 %and16, 0
  br i1 %tobool17.not, label %if.end22, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.end14
  %8 = bitcast %struct.sv* %sv to %struct.sv**
  %9 = load %struct.sv*, %struct.sv** %8, align 8, !tbaa !10
  %xpv_len = getelementptr inbounds %struct.sv, %struct.sv* %9, i64 0, i32 2
  %10 = load i64, i64* %xpv_len, align 8, !tbaa !16
  %tobool19.not = icmp eq i64 %10, 0
  br i1 %tobool19.not, label %if.end22, label %if.then20

if.then20:                                        ; preds = %land.lhs.true
  %call21 = tail call fastcc i64 @S_asUV(%struct.sv* nonnull %sv) #6
  br label %return

if.end22:                                         ; preds = %land.lhs.true, %if.end14
  %and24 = and i64 %1, 524288
  %tobool25.not = icmp eq i64 %and24, 0
  br i1 %tobool25.not, label %if.then26, label %if.end55

if.then26:                                        ; preds = %if.end22
  %and28 = and i64 %1, 512
  %tobool29.not = icmp eq i64 %and28, 0
  br i1 %tobool29.not, label %if.then30, label %return

if.then30:                                        ; preds = %if.then26
  %11 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings = getelementptr inbounds %struct.cop, %struct.cop* %11, i64 0, i32 14
  %12 = load %struct.sv*, %struct.sv** %cop_warnings, align 8, !tbaa !19
  %cmp.not = icmp eq %struct.sv* %12, null
  br i1 %cmp.not, label %lor.lhs.false41, label %land.lhs.true31

land.lhs.true31:                                  ; preds = %if.then30
  %13 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings32 = getelementptr inbounds %struct.cop, %struct.cop* %13, i64 0, i32 14
  %14 = load %struct.sv*, %struct.sv** %cop_warnings32, align 8, !tbaa !19
  %cmp33.not = icmp eq %struct.sv* %14, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp33.not, label %lor.lhs.false41, label %land.lhs.true34

land.lhs.true34:                                  ; preds = %land.lhs.true31
  %15 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings35 = getelementptr inbounds %struct.cop, %struct.cop* %15, i64 0, i32 14
  %16 = load %struct.sv*, %struct.sv** %cop_warnings35, align 8, !tbaa !19
  %cmp36 = icmp eq %struct.sv* %16, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp36, label %land.lhs.true49, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true34
  %17 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings37 = getelementptr inbounds %struct.cop, %struct.cop* %17, i64 0, i32 14
  %18 = bitcast %struct.sv** %cop_warnings37 to %struct.sv***
  %19 = load %struct.sv**, %struct.sv*** %18, align 8, !tbaa !19
  %20 = load %struct.sv*, %struct.sv** %19, align 8, !tbaa !10
  %xpv_pv = getelementptr inbounds %struct.sv, %struct.sv* %20, i64 0, i32 0
  %21 = load i8*, i8** %xpv_pv, align 8, !tbaa !22
  %arrayidx = getelementptr inbounds i8, i8* %21, i64 10
  %22 = load i8, i8* %arrayidx, align 1, !tbaa !23
  %23 = and i8 %22, 4
  %tobool40.not = icmp eq i8 %23, 0
  br i1 %tobool40.not, label %lor.lhs.false41, label %land.lhs.true49

lor.lhs.false41:                                  ; preds = %lor.lhs.false, %land.lhs.true31, %if.then30
  %24 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings42 = getelementptr inbounds %struct.cop, %struct.cop* %24, i64 0, i32 14
  %25 = load %struct.sv*, %struct.sv** %cop_warnings42, align 8, !tbaa !19
  %cmp43 = icmp eq %struct.sv* %25, null
  br i1 %cmp43, label %land.lhs.true45, label %return

land.lhs.true45:                                  ; preds = %lor.lhs.false41
  %26 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %27 = and i8 %26, 1
  %tobool48 = icmp eq i8 %27, 0
  %28 = load i32, i32* @PL_localizing, align 4
  %tobool50 = icmp ne i32 %28, 0
  %or.cond = select i1 %tobool48, i1 true, i1 %tobool50
  br i1 %or.cond, label %return, label %if.then51

land.lhs.true49:                                  ; preds = %lor.lhs.false, %land.lhs.true34
  %.old = load i32, i32* @PL_localizing, align 4, !tbaa !24
  %tobool50.old.not = icmp eq i32 %.old, 0
  br i1 %tobool50.old.not, label %if.then51, label %return

if.then51:                                        ; preds = %land.lhs.true45, %land.lhs.true49
  tail call void @Perl_report_uninit() #6
  br label %return

if.end55:                                         ; preds = %if.end22, %if.end
  %29 = phi i64 [ %1, %if.end22 ], [ %0, %if.end ]
  %and57 = and i64 %29, 9961472
  %tobool58.not = icmp eq i64 %and57, 0
  br i1 %tobool58.not, label %if.end138, label %if.then59

if.then59:                                        ; preds = %if.end55
  %and61 = and i64 %29, 524288
  %tobool62.not = icmp eq i64 %and61, 0
  br i1 %tobool62.not, label %if.end90, label %if.then63

if.then63:                                        ; preds = %if.then59
  %and65 = and i64 %29, 268435456
  %tobool66.not = icmp eq i64 %and65, 0
  br i1 %tobool66.not, label %if.end87, label %land.lhs.true67

land.lhs.true67:                                  ; preds = %if.then63
  %call68 = tail call %struct.sv* @Perl_amagic_call(%struct.sv* nonnull %sv, %struct.sv* nonnull @PL_sv_undef, i32 5, i32 9) #5
  %tobool69.not = icmp eq %struct.sv* %call68, null
  br i1 %tobool69.not, label %if.end87, label %land.lhs.true70

land.lhs.true70:                                  ; preds = %land.lhs.true67
  %sv_flags71 = getelementptr inbounds %struct.sv, %struct.sv* %call68, i64 0, i32 2
  %30 = load i64, i64* %sv_flags71, align 8, !tbaa !4
  %and72 = and i64 %30, 524288
  %tobool73.not = icmp eq i64 %and72, 0
  br i1 %tobool73.not, label %if.then80, label %lor.lhs.false74

lor.lhs.false74:                                  ; preds = %land.lhs.true70
  %31 = bitcast %struct.sv* %call68 to %struct.xrv**
  %32 = load %struct.xrv*, %struct.xrv** %31, align 8, !tbaa !10
  %xrv_rv = getelementptr inbounds %struct.xrv, %struct.xrv* %32, i64 0, i32 0
  %33 = load %struct.sv*, %struct.sv** %xrv_rv, align 8, !tbaa !26
  %34 = bitcast %struct.sv* %sv to %struct.xrv**
  %35 = load %struct.xrv*, %struct.xrv** %34, align 8, !tbaa !10
  %xrv_rv77 = getelementptr inbounds %struct.xrv, %struct.xrv* %35, i64 0, i32 0
  %36 = load %struct.sv*, %struct.sv** %xrv_rv77, align 8, !tbaa !26
  %cmp78.not = icmp eq %struct.sv* %33, %36
  br i1 %cmp78.not, label %if.end87, label %if.then80

if.then80:                                        ; preds = %lor.lhs.false74, %land.lhs.true70
  %and82 = and i64 %30, 65536
  %tobool83.not = icmp eq i64 %and82, 0
  br i1 %tobool83.not, label %cond.false, label %cond.true

cond.true:                                        ; preds = %if.then80
  %37 = bitcast %struct.sv* %call68 to %struct.xpviv**
  %38 = load %struct.xpviv*, %struct.xpviv** %37, align 8, !tbaa !10
  %xuv_uv85 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %38, i64 0, i32 3
  %39 = load i64, i64* %xuv_uv85, align 8, !tbaa !28
  br label %return

cond.false:                                       ; preds = %if.then80
  %call86 = tail call i64 @Perl_sv_2uv(%struct.sv* nonnull %call68) #6
  br label %return

if.end87:                                         ; preds = %lor.lhs.false74, %land.lhs.true67, %if.then63
  %40 = bitcast %struct.sv* %sv to %struct.xrv**
  %41 = load %struct.xrv*, %struct.xrv** %40, align 8, !tbaa !10
  %xrv_rv89 = getelementptr inbounds %struct.xrv, %struct.xrv* %41, i64 0, i32 0
  %42 = load %struct.sv*, %struct.sv** %xrv_rv89, align 8, !tbaa !26
  %43 = ptrtoint %struct.sv* %42 to i64
  br label %return

if.end90:                                         ; preds = %if.then59
  %44 = and i64 %29, 9437184
  %.not = icmp eq i64 %44, 9437184
  br i1 %.not, label %if.then98, label %if.end99

if.then98:                                        ; preds = %if.end90
  tail call void @Perl_sv_force_normal(%struct.sv* nonnull %sv) #6
  %.pre = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end99

if.end99:                                         ; preds = %if.then98, %if.end90
  %45 = phi i64 [ %.pre, %if.then98 ], [ %29, %if.end90 ]
  %46 = and i64 %45, 126812160
  %47 = icmp eq i64 %46, 8388608
  br i1 %47, label %if.then107, label %if.end138

if.then107:                                       ; preds = %if.end99
  %48 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings108 = getelementptr inbounds %struct.cop, %struct.cop* %48, i64 0, i32 14
  %49 = load %struct.sv*, %struct.sv** %cop_warnings108, align 8, !tbaa !19
  %cmp109.not = icmp eq %struct.sv* %49, null
  br i1 %cmp109.not, label %lor.lhs.false127, label %land.lhs.true111

land.lhs.true111:                                 ; preds = %if.then107
  %50 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings112 = getelementptr inbounds %struct.cop, %struct.cop* %50, i64 0, i32 14
  %51 = load %struct.sv*, %struct.sv** %cop_warnings112, align 8, !tbaa !19
  %cmp113.not = icmp eq %struct.sv* %51, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp113.not, label %lor.lhs.false127, label %land.lhs.true115

land.lhs.true115:                                 ; preds = %land.lhs.true111
  %52 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings116 = getelementptr inbounds %struct.cop, %struct.cop* %52, i64 0, i32 14
  %53 = load %struct.sv*, %struct.sv** %cop_warnings116, align 8, !tbaa !19
  %cmp117 = icmp eq %struct.sv* %53, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp117, label %if.then135, label %lor.lhs.false119

lor.lhs.false119:                                 ; preds = %land.lhs.true115
  %54 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings120 = getelementptr inbounds %struct.cop, %struct.cop* %54, i64 0, i32 14
  %55 = bitcast %struct.sv** %cop_warnings120 to %struct.sv***
  %56 = load %struct.sv**, %struct.sv*** %55, align 8, !tbaa !19
  %57 = load %struct.sv*, %struct.sv** %56, align 8, !tbaa !10
  %xpv_pv122 = getelementptr inbounds %struct.sv, %struct.sv* %57, i64 0, i32 0
  %58 = load i8*, i8** %xpv_pv122, align 8, !tbaa !22
  %arrayidx123 = getelementptr inbounds i8, i8* %58, i64 10
  %59 = load i8, i8* %arrayidx123, align 1, !tbaa !23
  %60 = and i8 %59, 4
  %tobool126.not = icmp eq i8 %60, 0
  br i1 %tobool126.not, label %lor.lhs.false127, label %if.then135

lor.lhs.false127:                                 ; preds = %lor.lhs.false119, %land.lhs.true111, %if.then107
  %61 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings128 = getelementptr inbounds %struct.cop, %struct.cop* %61, i64 0, i32 14
  %62 = load %struct.sv*, %struct.sv** %cop_warnings128, align 8, !tbaa !19
  %cmp129 = icmp eq %struct.sv* %62, null
  br i1 %cmp129, label %land.lhs.true131, label %return

land.lhs.true131:                                 ; preds = %lor.lhs.false127
  %63 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %64 = and i8 %63, 1
  %tobool134.not = icmp eq i8 %64, 0
  br i1 %tobool134.not, label %return, label %if.then135

if.then135:                                       ; preds = %land.lhs.true131, %lor.lhs.false119, %land.lhs.true115
  tail call void @Perl_report_uninit() #6
  br label %return

if.end138:                                        ; preds = %if.end99, %if.end55
  %65 = phi i64 [ %45, %if.end99 ], [ %29, %if.end55 ]
  %and140 = and i64 %65, 16777216
  %tobool141.not = icmp eq i64 %and140, 0
  br i1 %tobool141.not, label %if.end150, label %if.then142

if.then142:                                       ; preds = %if.end138
  %66 = trunc i64 %65 to i32
  %tobool145.not = icmp sgt i32 %66, -1
  br i1 %tobool145.not, label %if.else, label %if.then146

if.then146:                                       ; preds = %if.then142
  %67 = bitcast %struct.sv* %sv to %struct.xpviv**
  %68 = load %struct.xpviv*, %struct.xpviv** %67, align 8, !tbaa !10
  %xuv_uv148 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %68, i64 0, i32 3
  %69 = load i64, i64* %xuv_uv148, align 8, !tbaa !28
  br label %return

if.else:                                          ; preds = %if.then142
  %70 = bitcast %struct.sv* %sv to %struct.xpviv**
  %71 = load %struct.xpviv*, %struct.xpviv** %70, align 8, !tbaa !10
  %xiv_iv = getelementptr inbounds %struct.xpviv, %struct.xpviv* %71, i64 0, i32 3
  %72 = load i64, i64* %xiv_iv, align 8, !tbaa !11
  br label %return

if.end150:                                        ; preds = %if.end138
  %and152 = and i64 %65, 33554432
  %tobool153.not = icmp eq i64 %and152, 0
  br i1 %tobool153.not, label %if.else226, label %if.then154

if.then154:                                       ; preds = %if.end150
  %and156 = and i64 %65, 255
  %cmp157 = icmp eq i64 %and156, 2
  br i1 %cmp157, label %if.then159, label %if.end161

if.then159:                                       ; preds = %if.then154
  %call160 = tail call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 6) #6
  %.pre649 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end161

if.end161:                                        ; preds = %if.then159, %if.then154
  %73 = phi i64 [ %.pre649, %if.then159 ], [ %65, %if.then154 ]
  %and163 = and i64 %73, 2097152
  %tobool164.not = icmp eq i64 %and163, 0
  br i1 %tobool164.not, label %land.end, label %land.rhs

land.rhs:                                         ; preds = %if.end161
  %call165 = tail call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre650 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end

land.end:                                         ; preds = %land.rhs, %if.end161
  %74 = phi i64 [ %.pre650, %land.rhs ], [ %73, %if.end161 ]
  %or = or i64 %74, 16777216
  store i64 %or, i64* %sv_flags, align 8, !tbaa !4
  %75 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %76 = load %struct.xpvnv*, %struct.xpvnv** %75, align 8, !tbaa !10
  %xnv_nv169 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %76, i64 0, i32 4
  %77 = load double, double* %xnv_nv169, align 8, !tbaa !13
  %cmp170 = fcmp olt double %77, 0x43E0000000000000
  br i1 %cmp170, label %if.then172, label %if.else198

if.then172:                                       ; preds = %land.end
  %call175 = tail call i64 @Perl_cast_iv(double %77) #5
  %78 = bitcast %struct.sv* %sv to %struct.xpviv**
  %79 = load %struct.xpviv*, %struct.xpviv** %78, align 8, !tbaa !10
  %xiv_iv177 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %79, i64 0, i32 3
  store i64 %call175, i64* %xiv_iv177, align 8, !tbaa !11
  %xnv_nv179 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %79, i64 1
  %80 = bitcast %struct.xpviv* %xnv_nv179 to double*
  %81 = load double, double* %80, align 8, !tbaa !13
  %conv182 = sitofp i64 %call175 to double
  %cmp183 = fcmp oeq double %81, %conv182
  br i1 %cmp183, label %if.then185, label %if.end505

if.then185:                                       ; preds = %if.then172
  %82 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and187 = and i64 %82, 2097152
  %tobool188.not = icmp eq i64 %and187, 0
  br i1 %tobool188.not, label %land.end192, label %land.rhs189

land.rhs189:                                      ; preds = %if.then185
  %call190 = tail call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre653 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end192

land.end192:                                      ; preds = %land.rhs189, %if.then185
  %83 = phi i64 [ %.pre653, %land.rhs189 ], [ %82, %if.then185 ]
  %or195 = or i64 %83, 16842752
  store i64 %or195, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end505

if.else198:                                       ; preds = %land.end
  %call201 = tail call i64 @Perl_cast_uv(double %77) #5
  %84 = bitcast %struct.sv* %sv to %struct.xpviv**
  %85 = load %struct.xpviv*, %struct.xpviv** %84, align 8, !tbaa !10
  %xuv_uv203 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %85, i64 0, i32 3
  store i64 %call201, i64* %xuv_uv203, align 8, !tbaa !28
  %xnv_nv205 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %85, i64 1
  %86 = bitcast %struct.xpviv* %xnv_nv205 to double*
  %87 = load double, double* %86, align 8, !tbaa !13
  %conv208 = uitofp i64 %call201 to double
  %cmp209 = fcmp oeq double %87, %conv208
  %88 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br i1 %cmp209, label %if.then211, label %if.end222

if.then211:                                       ; preds = %if.else198
  %and213 = and i64 %88, 2097152
  %tobool214.not = icmp eq i64 %and213, 0
  br i1 %tobool214.not, label %land.end218, label %land.rhs215

land.rhs215:                                      ; preds = %if.then211
  %call216 = tail call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre651 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end218

land.end218:                                      ; preds = %land.rhs215, %if.then211
  %89 = phi i64 [ %.pre651, %land.rhs215 ], [ %88, %if.then211 ]
  %or221 = or i64 %89, 16842752
  br label %if.end222

if.end222:                                        ; preds = %if.else198, %land.end218
  %90 = phi i64 [ %or221, %land.end218 ], [ %88, %if.else198 ]
  %or224 = or i64 %90, 2147483648
  store i64 %or224, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end505

if.else226:                                       ; preds = %if.end150
  %and228 = and i64 %65, 67108864
  %tobool229.not = icmp eq i64 %and228, 0
  br i1 %tobool229.not, label %if.else460, label %land.lhs.true230

land.lhs.true230:                                 ; preds = %if.else226
  %91 = bitcast %struct.sv* %sv to %struct.sv**
  %92 = load %struct.sv*, %struct.sv** %91, align 8, !tbaa !10
  %xpv_len232 = getelementptr inbounds %struct.sv, %struct.sv* %92, i64 0, i32 2
  %93 = load i64, i64* %xpv_len232, align 8, !tbaa !16
  %tobool233.not = icmp eq i64 %93, 0
  br i1 %tobool233.not, label %if.else460, label %if.then234

if.then234:                                       ; preds = %land.lhs.true230
  %94 = bitcast i64* %value to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %94) #7
  %xpv_pv236 = getelementptr inbounds %struct.sv, %struct.sv* %92, i64 0, i32 0
  %95 = load i8*, i8** %xpv_pv236, align 8, !tbaa !22
  %xpv_cur = getelementptr inbounds %struct.sv, %struct.sv* %92, i64 0, i32 1
  %96 = load i64, i64* %xpv_cur, align 8, !tbaa !30
  %call238 = call i32 @Perl_grok_number(i8* %95, i64 %96, i64* nonnull %value) #5
  %and239 = and i32 %call238, 5
  %cmp240 = icmp eq i32 %and239, 1
  %97 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br i1 %cmp240, label %if.then242, label %if.else260

if.then242:                                       ; preds = %if.then234
  %and244 = and i64 %97, 255
  %cmp245 = icmp ult i64 %and244, 5
  br i1 %cmp245, label %if.then247, label %if.end249

if.then247:                                       ; preds = %if.then242
  %call248 = call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 5) #6
  %.pre657 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end249

if.end249:                                        ; preds = %if.then247, %if.then242
  %98 = phi i64 [ %.pre657, %if.then247 ], [ %97, %if.then242 ]
  %and251 = and i64 %98, 2097152
  %tobool252.not = icmp eq i64 %and251, 0
  br i1 %tobool252.not, label %if.then272.thread, label %if.then272

if.then272.thread:                                ; preds = %if.end249
  %or259665 = or i64 %98, 16842752
  br label %land.end279

if.else260:                                       ; preds = %if.then234
  %and262 = and i64 %97, 254
  %cmp263 = icmp ult i64 %and262, 6
  br i1 %cmp263, label %if.then265, label %if.then336

if.then265:                                       ; preds = %if.else260
  %call266 = call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 6) #6
  br label %if.then336

if.then272:                                       ; preds = %if.end249
  %call254 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre658 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %.pre663 = and i64 %.pre658, 2097152
  %or259 = or i64 %.pre658, 16842752
  store i64 %or259, i64* %sv_flags, align 8, !tbaa !4
  %tobool275.not = icmp eq i64 %.pre663, 0
  br i1 %tobool275.not, label %land.end279, label %land.rhs276

land.rhs276:                                      ; preds = %if.then272
  %call277 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre659 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end279

land.end279:                                      ; preds = %if.then272.thread, %land.rhs276, %if.then272
  %99 = phi i64 [ %.pre659, %land.rhs276 ], [ %or259, %if.then272 ], [ %or259665, %if.then272.thread ]
  %or282 = or i64 %99, 16777216
  store i64 %or282, i64* %sv_flags, align 8, !tbaa !4
  %and283 = and i32 %call238, 8
  %tobool284.not = icmp eq i32 %and283, 0
  %100 = load i64, i64* %value, align 8, !tbaa !31
  br i1 %tobool284.not, label %if.then285, label %if.else297

if.then285:                                       ; preds = %land.end279
  %cmp286 = icmp sgt i64 %100, -1
  br i1 %cmp286, label %if.then288, label %if.else291

if.then288:                                       ; preds = %if.then285
  %101 = bitcast %struct.sv* %sv to %struct.xpviv**
  %102 = load %struct.xpviv*, %struct.xpviv** %101, align 8, !tbaa !10
  %xiv_iv290 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %102, i64 0, i32 3
  store i64 %100, i64* %xiv_iv290, align 8, !tbaa !11
  br label %if.end459

if.else291:                                       ; preds = %if.then285
  %103 = bitcast %struct.sv* %sv to %struct.xpviv**
  %104 = load %struct.xpviv*, %struct.xpviv** %103, align 8, !tbaa !10
  %xuv_uv293 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %104, i64 0, i32 3
  store i64 %100, i64* %xuv_uv293, align 8, !tbaa !28
  %or295 = or i64 %99, 2164260864
  store i64 %or295, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end459

if.else297:                                       ; preds = %land.end279
  %cmp298 = icmp ult i64 %100, -9223372036854775807
  br i1 %cmp298, label %if.then300, label %if.else303

if.then300:                                       ; preds = %if.else297
  %sub = sub nsw i64 0, %100
  %105 = bitcast %struct.sv* %sv to %struct.xpviv**
  %106 = load %struct.xpviv*, %struct.xpviv** %105, align 8, !tbaa !10
  %xiv_iv302 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %106, i64 0, i32 3
  store i64 %sub, i64* %xiv_iv302, align 8, !tbaa !11
  br label %if.end459

if.else303:                                       ; preds = %if.else297
  %and305 = and i64 %99, 254
  %cmp306 = icmp ult i64 %and305, 6
  br i1 %cmp306, label %if.then308, label %if.end310

if.then308:                                       ; preds = %if.else303
  %call309 = call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 6) #6
  %.pre660 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end310

if.end310:                                        ; preds = %if.then308, %if.else303
  %107 = phi i64 [ %.pre660, %if.then308 ], [ %or282, %if.else303 ]
  %or312 = and i64 %107, 2096955391
  %and314 = or i64 %or312, 33685504
  store i64 %and314, i64* %sv_flags, align 8, !tbaa !4
  %and316 = and i64 %107, 2097152
  %tobool317.not = icmp eq i64 %and316, 0
  br i1 %tobool317.not, label %land.end321, label %land.rhs318

land.rhs318:                                      ; preds = %if.end310
  %call319 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre661 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end321

land.end321:                                      ; preds = %land.rhs318, %if.end310
  %108 = phi i64 [ %.pre661, %land.rhs318 ], [ %and314, %if.end310 ]
  %or324 = or i64 %108, 16777216
  store i64 %or324, i64* %sv_flags, align 8, !tbaa !4
  %109 = load i64, i64* %value, align 8, !tbaa !31
  %conv325 = uitofp i64 %109 to double
  %fneg = fneg double %conv325
  %110 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %111 = load %struct.xpvnv*, %struct.xpvnv** %110, align 8, !tbaa !10
  %xnv_nv327 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %111, i64 0, i32 4
  store double %fneg, double* %xnv_nv327, align 8, !tbaa !13
  %112 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %111, i64 0, i32 3
  store i64 -9223372036854775808, i64* %112, align 8, !tbaa !11
  br label %if.end459

if.then336:                                       ; preds = %if.then265, %if.else260
  %113 = load %struct.sv*, %struct.sv** %91, align 8, !tbaa !10
  %xpv_pv338 = getelementptr inbounds %struct.sv, %struct.sv* %113, i64 0, i32 0
  %114 = load i8*, i8** %xpv_pv338, align 8, !tbaa !22
  %call339 = call double @Perl_my_atof(i8* %114) #5
  %115 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %116 = load %struct.xpvnv*, %struct.xpvnv** %115, align 8, !tbaa !10
  %xnv_nv341 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %116, i64 0, i32 4
  store double %call339, double* %xnv_nv341, align 8, !tbaa !13
  %tobool342.not = icmp eq i32 %call238, 0
  br i1 %tobool342.not, label %land.lhs.true343, label %if.end372

land.lhs.true343:                                 ; preds = %if.then336
  %117 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings344 = getelementptr inbounds %struct.cop, %struct.cop* %117, i64 0, i32 14
  %118 = load %struct.sv*, %struct.sv** %cop_warnings344, align 8, !tbaa !19
  %cmp345.not = icmp eq %struct.sv* %118, null
  br i1 %cmp345.not, label %lor.lhs.false363, label %land.lhs.true347

land.lhs.true347:                                 ; preds = %land.lhs.true343
  %119 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings348 = getelementptr inbounds %struct.cop, %struct.cop* %119, i64 0, i32 14
  %120 = load %struct.sv*, %struct.sv** %cop_warnings348, align 8, !tbaa !19
  %cmp349.not = icmp eq %struct.sv* %120, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp349.not, label %lor.lhs.false363, label %land.lhs.true351

land.lhs.true351:                                 ; preds = %land.lhs.true347
  %121 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings352 = getelementptr inbounds %struct.cop, %struct.cop* %121, i64 0, i32 14
  %122 = load %struct.sv*, %struct.sv** %cop_warnings352, align 8, !tbaa !19
  %cmp353 = icmp eq %struct.sv* %122, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp353, label %if.then371, label %lor.lhs.false355

lor.lhs.false355:                                 ; preds = %land.lhs.true351
  %123 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings356 = getelementptr inbounds %struct.cop, %struct.cop* %123, i64 0, i32 14
  %124 = bitcast %struct.sv** %cop_warnings356 to %struct.sv***
  %125 = load %struct.sv**, %struct.sv*** %124, align 8, !tbaa !19
  %126 = load %struct.sv*, %struct.sv** %125, align 8, !tbaa !10
  %xpv_pv358 = getelementptr inbounds %struct.sv, %struct.sv* %126, i64 0, i32 0
  %127 = load i8*, i8** %xpv_pv358, align 8, !tbaa !22
  %arrayidx359 = getelementptr inbounds i8, i8* %127, i64 3
  %128 = load i8, i8* %arrayidx359, align 1, !tbaa !23
  %129 = and i8 %128, 4
  %tobool362.not = icmp eq i8 %129, 0
  br i1 %tobool362.not, label %lor.lhs.false363, label %if.then371

lor.lhs.false363:                                 ; preds = %lor.lhs.false355, %land.lhs.true347, %land.lhs.true343
  %130 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings364 = getelementptr inbounds %struct.cop, %struct.cop* %130, i64 0, i32 14
  %131 = load %struct.sv*, %struct.sv** %cop_warnings364, align 8, !tbaa !19
  %cmp365 = icmp eq %struct.sv* %131, null
  br i1 %cmp365, label %land.lhs.true367, label %if.end372

land.lhs.true367:                                 ; preds = %lor.lhs.false363
  %132 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %133 = and i8 %132, 1
  %tobool370.not = icmp eq i8 %133, 0
  br i1 %tobool370.not, label %if.end372, label %if.then371

if.then371:                                       ; preds = %land.lhs.true367, %lor.lhs.false355, %land.lhs.true351
  call fastcc void @S_not_a_number(%struct.sv* nonnull %sv) #6
  br label %if.end372

if.end372:                                        ; preds = %if.then371, %land.lhs.true367, %lor.lhs.false363, %if.then336
  %134 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and374 = and i64 %134, 2097152
  %tobool375.not = icmp eq i64 %and374, 0
  br i1 %tobool375.not, label %land.end379, label %land.rhs376

land.rhs376:                                      ; preds = %if.end372
  %call377 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre654 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end379

land.end379:                                      ; preds = %land.rhs376, %if.end372
  %135 = phi i64 [ %.pre654, %land.rhs376 ], [ %134, %if.end372 ]
  %or384 = or i64 %135, 50462720
  store i64 %or384, i64* %sv_flags, align 8, !tbaa !4
  %136 = load %struct.xpvnv*, %struct.xpvnv** %115, align 8, !tbaa !10
  %xnv_nv386 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %136, i64 0, i32 4
  %137 = load double, double* %xnv_nv386, align 8, !tbaa !13
  %cmp387 = fcmp olt double %137, 0x43E0000000000000
  br i1 %cmp387, label %if.then389, label %if.else415

if.then389:                                       ; preds = %land.end379
  %call392 = call i64 @Perl_cast_iv(double %137) #5
  %138 = bitcast %struct.sv* %sv to %struct.xpviv**
  %139 = load %struct.xpviv*, %struct.xpviv** %138, align 8, !tbaa !10
  %xiv_iv394 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %139, i64 0, i32 3
  store i64 %call392, i64* %xiv_iv394, align 8, !tbaa !11
  %conv397 = sitofp i64 %call392 to double
  %xnv_nv399 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %139, i64 1
  %140 = bitcast %struct.xpviv* %xnv_nv399 to double*
  %141 = load double, double* %140, align 8, !tbaa !13
  %cmp400 = fcmp oeq double %141, %conv397
  br i1 %cmp400, label %if.then402, label %if.end459

if.then402:                                       ; preds = %if.then389
  %142 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %and404 = and i64 %142, 2097152
  %tobool405.not = icmp eq i64 %and404, 0
  br i1 %tobool405.not, label %land.end409, label %land.rhs406

land.rhs406:                                      ; preds = %if.then402
  %call407 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre656 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end409

land.end409:                                      ; preds = %land.rhs406, %if.then402
  %143 = phi i64 [ %.pre656, %land.rhs406 ], [ %142, %if.then402 ]
  %or412 = or i64 %143, 16842752
  store i64 %or412, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end459

if.else415:                                       ; preds = %land.end379
  %cmp418 = fcmp ogt double %137, 0x43F0000000000000
  br i1 %cmp418, label %if.then420, label %if.else427

if.then420:                                       ; preds = %if.else415
  %or422 = or i64 %135, 2197946368
  %144 = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %136, i64 0, i32 3
  store i64 -1, i64* %144, align 8, !tbaa !28
  store i64 %or422, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end459

if.else427:                                       ; preds = %if.else415
  %call430 = call i64 @Perl_cast_uv(double %137) #5
  %145 = bitcast %struct.sv* %sv to %struct.xpviv**
  %146 = load %struct.xpviv*, %struct.xpviv** %145, align 8, !tbaa !10
  %xuv_uv432 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %146, i64 0, i32 3
  store i64 %call430, i64* %xuv_uv432, align 8, !tbaa !28
  %conv435 = uitofp i64 %call430 to double
  %xnv_nv437 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %146, i64 1
  %147 = bitcast %struct.xpviv* %xnv_nv437 to double*
  %148 = load double, double* %147, align 8, !tbaa !13
  %cmp438 = fcmp oeq double %148, %conv435
  %149 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br i1 %cmp438, label %if.then440, label %if.else453

if.then440:                                       ; preds = %if.else427
  %and442 = and i64 %149, 2097152
  %tobool443.not = icmp eq i64 %and442, 0
  br i1 %tobool443.not, label %land.end447, label %land.rhs444

land.rhs444:                                      ; preds = %if.then440
  %call445 = call i32 @Perl_sv_backoff(%struct.sv* nonnull %sv) #6
  %.pre655 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %land.end447

land.end447:                                      ; preds = %land.rhs444, %if.then440
  %150 = phi i64 [ %.pre655, %land.rhs444 ], [ %149, %if.then440 ]
  %or452 = or i64 %150, 2164326400
  store i64 %or452, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end459

if.else453:                                       ; preds = %if.else427
  %or455 = or i64 %149, 2147483648
  store i64 %or455, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end459

if.end459:                                        ; preds = %if.then300, %land.end321, %if.then288, %if.else291, %if.then389, %land.end409, %land.end447, %if.else453, %if.then420
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %94) #7
  br label %if.end505

if.else460:                                       ; preds = %land.lhs.true230, %if.else226
  %and462 = and i64 %65, 512
  %tobool463.not = icmp eq i64 %and462, 0
  br i1 %tobool463.not, label %if.then464, label %if.end496

if.then464:                                       ; preds = %if.else460
  %151 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings465 = getelementptr inbounds %struct.cop, %struct.cop* %151, i64 0, i32 14
  %152 = load %struct.sv*, %struct.sv** %cop_warnings465, align 8, !tbaa !19
  %cmp466.not = icmp eq %struct.sv* %152, null
  br i1 %cmp466.not, label %lor.lhs.false484, label %land.lhs.true468

land.lhs.true468:                                 ; preds = %if.then464
  %153 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings469 = getelementptr inbounds %struct.cop, %struct.cop* %153, i64 0, i32 14
  %154 = load %struct.sv*, %struct.sv** %cop_warnings469, align 8, !tbaa !19
  %cmp470.not = icmp eq %struct.sv* %154, inttoptr (i64 48 to %struct.sv*)
  br i1 %cmp470.not, label %lor.lhs.false484, label %land.lhs.true472

land.lhs.true472:                                 ; preds = %land.lhs.true468
  %155 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings473 = getelementptr inbounds %struct.cop, %struct.cop* %155, i64 0, i32 14
  %156 = load %struct.sv*, %struct.sv** %cop_warnings473, align 8, !tbaa !19
  %cmp474 = icmp eq %struct.sv* %156, inttoptr (i64 24 to %struct.sv*)
  br i1 %cmp474, label %land.lhs.true492, label %lor.lhs.false476

lor.lhs.false476:                                 ; preds = %land.lhs.true472
  %157 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings477 = getelementptr inbounds %struct.cop, %struct.cop* %157, i64 0, i32 14
  %158 = bitcast %struct.sv** %cop_warnings477 to %struct.sv***
  %159 = load %struct.sv**, %struct.sv*** %158, align 8, !tbaa !19
  %160 = load %struct.sv*, %struct.sv** %159, align 8, !tbaa !10
  %xpv_pv479 = getelementptr inbounds %struct.sv, %struct.sv* %160, i64 0, i32 0
  %161 = load i8*, i8** %xpv_pv479, align 8, !tbaa !22
  %arrayidx480 = getelementptr inbounds i8, i8* %161, i64 10
  %162 = load i8, i8* %arrayidx480, align 1, !tbaa !23
  %163 = and i8 %162, 4
  %tobool483.not = icmp eq i8 %163, 0
  br i1 %tobool483.not, label %lor.lhs.false484, label %land.lhs.true492

lor.lhs.false484:                                 ; preds = %lor.lhs.false476, %land.lhs.true468, %if.then464
  %164 = load volatile %struct.cop*, %struct.cop** bitcast (%struct.cop.164** @PL_curcop to %struct.cop**), align 8, !tbaa !18
  %cop_warnings485 = getelementptr inbounds %struct.cop, %struct.cop* %164, i64 0, i32 14
  %165 = load %struct.sv*, %struct.sv** %cop_warnings485, align 8, !tbaa !19
  %cmp486 = icmp eq %struct.sv* %165, null
  br i1 %cmp486, label %land.lhs.true488, label %if.end496

land.lhs.true488:                                 ; preds = %lor.lhs.false484
  %166 = load i8, i8* @PL_dowarn, align 1, !tbaa !23
  %167 = and i8 %166, 1
  %tobool491 = icmp eq i8 %167, 0
  %168 = load i32, i32* @PL_localizing, align 4
  %tobool493 = icmp ne i32 %168, 0
  %or.cond518 = select i1 %tobool491, i1 true, i1 %tobool493
  br i1 %or.cond518, label %if.end496, label %if.then494

land.lhs.true492:                                 ; preds = %lor.lhs.false476, %land.lhs.true472
  %.old517 = load i32, i32* @PL_localizing, align 4, !tbaa !24
  %tobool493.old.not = icmp eq i32 %.old517, 0
  br i1 %tobool493.old.not, label %if.then494, label %if.end496

if.then494:                                       ; preds = %land.lhs.true488, %land.lhs.true492
  tail call void @Perl_report_uninit() #6
  %.pre662 = load i64, i64* %sv_flags, align 8, !tbaa !4
  br label %if.end496

if.end496:                                        ; preds = %lor.lhs.false484, %land.lhs.true488, %land.lhs.true492, %if.then494, %if.else460
  %169 = phi i64 [ %65, %lor.lhs.false484 ], [ %65, %land.lhs.true488 ], [ %65, %land.lhs.true492 ], [ %.pre662, %if.then494 ], [ %65, %if.else460 ]
  %and498 = and i64 %169, 255
  %cmp499 = icmp eq i64 %and498, 0
  br i1 %cmp499, label %if.then501, label %return

if.then501:                                       ; preds = %if.end496
  %call502 = tail call signext i8 @Perl_sv_upgrade(%struct.sv* nonnull %sv, i64 1) #6
  br label %return

if.end505:                                        ; preds = %if.end222, %if.then172, %land.end192, %if.end459
  %170 = load i64, i64* %sv_flags, align 8, !tbaa !4
  %171 = trunc i64 %170 to i32
  %tobool508.not = icmp sgt i32 %171, -1
  br i1 %tobool508.not, label %cond.false512, label %cond.true509

cond.true509:                                     ; preds = %if.end505
  %172 = bitcast %struct.sv* %sv to %struct.xpviv**
  %173 = load %struct.xpviv*, %struct.xpviv** %172, align 8, !tbaa !10
  %xuv_uv511 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %173, i64 0, i32 3
  br label %cond.end515

cond.false512:                                    ; preds = %if.end505
  %174 = bitcast %struct.sv* %sv to %struct.xpviv**
  %175 = load %struct.xpviv*, %struct.xpviv** %174, align 8, !tbaa !10
  %xiv_iv514 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %175, i64 0, i32 3
  br label %cond.end515

cond.end515:                                      ; preds = %cond.false512, %cond.true509
  %cond516.in = phi i64* [ %xuv_uv511, %cond.true509 ], [ %xiv_iv514, %cond.false512 ]
  %cond516 = load i64, i64* %cond516.in, align 8, !tbaa !31
  br label %return

return:                                           ; preds = %if.end496, %if.then501, %lor.lhs.false127, %land.lhs.true131, %if.then135, %if.end87, %cond.false, %cond.true, %if.then26, %if.then51, %land.lhs.true49, %land.lhs.true45, %lor.lhs.false41, %entry, %cond.end515, %if.else, %if.then146, %if.then20, %if.then11, %if.then6
  %retval.1 = phi i64 [ %4, %if.then6 ], [ %call13, %if.then11 ], [ %call21, %if.then20 ], [ %69, %if.then146 ], [ %72, %if.else ], [ %cond516, %cond.end515 ], [ 0, %entry ], [ 0, %lor.lhs.false41 ], [ 0, %land.lhs.true45 ], [ 0, %land.lhs.true49 ], [ 0, %if.then51 ], [ 0, %if.then26 ], [ %43, %if.end87 ], [ %39, %cond.true ], [ %call86, %cond.false ], [ 0, %if.then135 ], [ 0, %land.lhs.true131 ], [ 0, %lor.lhs.false127 ], [ 0, %if.then501 ], [ 0, %if.end496 ]
  ret i64 %retval.1
}

; Function Attrs: noinline nounwind optsize uwtable
declare hidden fastcc i64 @S_asUV(%struct.sv*) unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare hidden fastcc void @S_not_a_number(%struct.sv*) unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare hidden fastcc i64 @S_asIV(%struct.sv*) unnamed_addr #1

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree noinline nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind optsize }
attributes #6 = { optsize }
attributes #7 = { nounwind }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 13.0.0 (git@github.com:ppetoumenos/llvm-project.git 70a9fb72f98c9897c164fba3d27e76821498d6e1)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !9, i64 16}
!5 = !{!"sv", !6, i64 0, !9, i64 8, !9, i64 16}
!6 = !{!"any pointer", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"long", !7, i64 0}
!10 = !{!5, !6, i64 0}
!11 = !{!12, !9, i64 24}
!12 = !{!"xpviv", !6, i64 0, !9, i64 8, !9, i64 16, !9, i64 24}
!13 = !{!14, !15, i64 32}
!14 = !{!"xpvnv", !6, i64 0, !9, i64 8, !9, i64 16, !9, i64 24, !15, i64 32}
!15 = !{!"double", !7, i64 0}
!16 = !{!17, !9, i64 16}
!17 = !{!"xpv", !6, i64 0, !9, i64 8, !9, i64 16}
!18 = !{!6, !6, i64 0}
!19 = !{!20, !6, i64 88}
!20 = !{!"cop", !6, i64 0, !6, i64 8, !6, i64 16, !9, i64 24, !21, i64 32, !21, i64 34, !7, i64 36, !7, i64 37, !6, i64 40, !6, i64 48, !6, i64 56, !9, i64 64, !9, i64 72, !9, i64 80, !6, i64 88, !6, i64 96}
!21 = !{!"short", !7, i64 0}
!22 = !{!17, !6, i64 0}
!23 = !{!7, !7, i64 0}
!24 = !{!25, !25, i64 0}
!25 = !{!"int", !7, i64 0}
!26 = !{!27, !6, i64 0}
!27 = !{!"xrv", !6, i64 0}
!28 = !{!29, !9, i64 24}
!29 = !{!"xpvuv", !6, i64 0, !9, i64 8, !9, i64 16, !9, i64 24}
!30 = !{!17, !9, i64 8}
!31 = !{!9, !9, i64 0}
