; RUN: %opt --passes="mergefunc,multiple-func-merging" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false -o %t.mfm.bc %s | FileCheck %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" --pass-remarks-output=- --pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.bc %s | FileCheck %s
; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge

; RUN: %llc --filetype=obj %t.mfm.bc -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)

; ModuleID = '.x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/400.perlbench/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.pmop.150 = type { %struct.op.136*, %struct.op.136*, %struct.op.136* ()*, i64, i16, i16, i8, i8, %struct.op.136*, %struct.op.136*, %struct.op.136*, %struct.op.136*, %struct.pmop.150*, %struct.regexp*, i64, i64, i8, %struct.hv.152* }
%struct.op.136 = type { %struct.op.136*, %struct.op.136*, {}*, i64, i16, i16, i8, i8 }
%struct.regexp = type { i64*, i64*, %struct.regnode*, %struct.reg_substr_data*, i8*, %struct.reg_data*, i8*, i64*, i64, i64, i64, i64, i64, i64, i64, i64, [1 x %struct.regnode] }
%struct.regnode = type { i8, i8, i16 }
%struct.reg_substr_data = type { [3 x %struct.reg_substr_datum] }
%struct.reg_substr_datum = type { i64, i64, %struct.sv*, %struct.sv* }
%struct.sv = type { i8*, i64, i64 }
%struct.reg_data = type { i64, i8*, [1 x i8*] }
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
%struct.stackinfo.177 = type { %struct.av.139*, %struct.context.176*, i64, i64, i64, %struct.stackinfo.177*, %struct.stackinfo.177*, i64 }
%struct.context.176 = type { i64, %union.anon.0.175 }
%union.anon.0.175 = type { %struct.block.174 }
%struct.block.174 = type { i64, %struct.cop.164*, i64, i64, i64, %struct.pmop.150*, i8, %union.anon.1.173 }
%struct.cop.164 = type { %struct.op.136*, %struct.op.136*, %struct.op.136* ()*, i64, i16, i16, i8, i8, i8*, %struct.hv.152*, %struct.gv.163*, i64, i64, i64, %struct.sv*, %struct.sv* }
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
%union.anon.1.173 = type { %struct.block_loop.172 }
%struct.block_loop.172 = type { i8*, i64, %struct.op.136*, %struct.op.136*, %struct.op.136*, %struct.sv**, %struct.sv*, %struct.sv*, %struct.av.139*, i64, i64 }
%struct.block_sub = type { %struct.cv.160*, %struct.gv.163*, %struct.gv.163*, %struct.av.139*, %struct.av.139*, i64, i8, i8, %struct.av.139* }

@.str.28.2199 = external hidden unnamed_addr constant [40 x i8], align 1
@.str.29.2203 = external hidden unnamed_addr constant [39 x i8], align 1
@.str.30.2200 = external hidden unnamed_addr constant [6 x i8], align 1
@.str.31.2201 = external hidden unnamed_addr constant [17 x i8], align 1
@.str.32.2202 = external hidden unnamed_addr constant [12 x i8], align 1
@.str.33.2206 = external hidden unnamed_addr constant [53 x i8], align 1
@.str.34.2204 = external hidden unnamed_addr constant [12 x i8], align 1
@.str.35.2205 = external hidden unnamed_addr constant [6 x i8], align 1
@.str.36.2209 = external hidden unnamed_addr constant [41 x i8], align 1
@.str.37.2208 = external hidden unnamed_addr constant [15 x i8], align 1
@.str.38.2207 = external hidden unnamed_addr constant [10 x i8], align 1
@PL_curpm = external global %struct.pmop.150*, align 8
@PL_retstack_ix = external local_unnamed_addr global i64, align 8
@PL_scopestack_ix = external local_unnamed_addr global i64, align 8
@PL_markstack = external local_unnamed_addr global i64*, align 8
@PL_tmps_max = external local_unnamed_addr global i64, align 8
@PL_tmps_stack = external local_unnamed_addr global %struct.sv**, align 8
@PL_curstackinfo = external local_unnamed_addr global %struct.stackinfo.177*, align 8
@PL_curcop = external global %struct.cop.164*, align 8
@PL_tainted = external local_unnamed_addr global i8, align 1
@PL_tmps_floor = external global i64, align 8
@PL_tmps_ix = external local_unnamed_addr global i64, align 8
@PL_sv_undef = external global %struct.sv, align 8
@PL_stack_sp = external local_unnamed_addr global %struct.sv**, align 8
@PL_stack_base = external local_unnamed_addr global %struct.sv**, align 8
@PL_markstack_ptr = external local_unnamed_addr global i64*, align 8
@PL_defgv = external local_unnamed_addr global %struct.gv.163*, align 8
@PL_Sv = external local_unnamed_addr global %struct.sv*, align 8
@PL_stack_max = external local_unnamed_addr global %struct.sv**, align 8

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_av_extend(%struct.av*, i64) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.av* @Perl_newAV() local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
define %struct.op.136* @Perl_pp_leavesub() #0 {
entry:
  %0 = load %struct.sv**, %struct.sv*** @PL_stack_sp, align 8, !tbaa !4
  %1 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxstack = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %1, i64 0, i32 1
  %2 = load %struct.context.176*, %struct.context.176** %si_cxstack, align 8, !tbaa !8
  %si_cxix = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %1, i64 0, i32 2
  %3 = load i64, i64* %si_cxix, align 8, !tbaa !11
  %dec = add nsw i64 %3, -1
  store i64 %dec, i64* %si_cxix, align 8, !tbaa !11
  %4 = load %struct.sv**, %struct.sv*** @PL_stack_base, align 8, !tbaa !4
  %blku_oldsp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 0
  %5 = load i64, i64* %blku_oldsp, align 8, !tbaa !12
  %add.ptr = getelementptr inbounds %struct.sv*, %struct.sv** %4, i64 %5
  %blku_oldcop = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 1
  %6 = load %struct.cop.164*, %struct.cop.164** %blku_oldcop, align 8, !tbaa !12
  store volatile %struct.cop.164* %6, %struct.cop.164** @PL_curcop, align 8, !tbaa !4
  %7 = load i64*, i64** @PL_markstack, align 8, !tbaa !4
  %blku_oldmarksp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 3
  %8 = load i64, i64* %blku_oldmarksp, align 8, !tbaa !12
  %add.ptr5 = getelementptr inbounds i64, i64* %7, i64 %8
  store i64* %add.ptr5, i64** @PL_markstack_ptr, align 8, !tbaa !4
  %blku_oldscopesp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 4
  %9 = load i64, i64* %blku_oldscopesp, align 8, !tbaa !12
  store i64 %9, i64* @PL_scopestack_ix, align 8, !tbaa !13
  %blku_oldretsp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 2
  %10 = load i64, i64* %blku_oldretsp, align 8, !tbaa !12
  store i64 %10, i64* @PL_retstack_ix, align 8, !tbaa !13
  %blku_oldpm = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 5
  %11 = load %struct.pmop.150*, %struct.pmop.150** %blku_oldpm, align 8, !tbaa !12
  %blku_gimme = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 6
  %12 = load i8, i8* %blku_gimme, align 8, !tbaa !12
  store i64 %3, i64* %si_cxix, align 8, !tbaa !11
  store i8 0, i8* @PL_tainted, align 1, !tbaa !12
  switch i8 %12, label %if.end84 [
    i8 0, label %if.then
    i8 1, label %for.cond.preheader
  ]

for.cond.preheader:                               ; preds = %entry
  %mark.2289 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %cmp75.not290 = icmp ugt %struct.sv** %mark.2289, %0
  br i1 %cmp75.not290, label %if.end84, label %for.body

if.then:                                          ; preds = %entry
  %add.ptr16 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %cmp17.not = icmp ugt %struct.sv** %add.ptr16, %0
  br i1 %cmp17.not, label %if.else57, label %if.then19

if.then19:                                        ; preds = %if.then
  %blk_u = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7
  %cv = bitcast %union.anon.1.173* %blk_u to %struct.cv.160**
  %13 = load %struct.cv.160*, %struct.cv.160** %cv, align 8, !tbaa !12
  %tobool.not = icmp eq %struct.cv.160* %13, null
  br i1 %tobool.not, label %if.else51, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.then19
  %sv_any = getelementptr inbounds %struct.cv.160, %struct.cv.160* %13, i64 0, i32 0
  %14 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any, align 8, !tbaa !14
  %xcv_depth = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %14, i64 0, i32 14
  %15 = load i64, i64* %xcv_depth, align 8, !tbaa !16
  %cmp27 = icmp sgt i64 %15, 1
  br i1 %cmp27, label %if.then29, label %if.else51

if.then29:                                        ; preds = %land.lhs.true
  %16 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags = getelementptr inbounds %struct.sv, %struct.sv* %16, i64 0, i32 2
  %17 = load i64, i64* %sv_flags, align 8, !tbaa !20
  %and = and i64 %17, 2048
  %tobool30.not = icmp eq i64 %and, 0
  store %struct.sv* %16, %struct.sv** @PL_Sv, align 8, !tbaa !4
  %sv_refcnt40 = getelementptr inbounds %struct.sv, %struct.sv* %16, i64 0, i32 1
  %18 = load i64, i64* %sv_refcnt40, align 8, !tbaa !22
  %inc41 = add i64 %18, 1
  store i64 %inc41, i64* %sv_refcnt40, align 8, !tbaa !22
  br i1 %tobool30.not, label %land.end43, label %land.end

land.end:                                         ; preds = %if.then29
  store %struct.sv* %16, %struct.sv** %add.ptr16, align 8, !tbaa !4
  %19 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %20 = load i64, i64* @PL_tmps_floor, align 8, !tbaa !13
  %cmp35 = icmp sgt i64 %19, %20
  br i1 %cmp35, label %if.then37, label %if.end

if.then37:                                        ; preds = %land.end
  tail call void @Perl_free_tmps() #2
  %.pre = load %struct.sv*, %struct.sv** %add.ptr16, align 8, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.then37, %land.end
  %21 = phi %struct.sv* [ %.pre, %if.then37 ], [ %16, %land.end ]
  %call = tail call %struct.sv* @Perl_sv_2mortal(%struct.sv* %21) #2
  br label %if.end84

land.end43:                                       ; preds = %if.then29
  %22 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %23 = load i64, i64* @PL_tmps_floor, align 8, !tbaa !13
  %cmp45 = icmp sgt i64 %22, %23
  br i1 %cmp45, label %if.then47, label %if.end48

if.then47:                                        ; preds = %land.end43
  tail call void @Perl_free_tmps() #2
  br label %if.end48

if.end48:                                         ; preds = %if.then47, %land.end43
  %call49 = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %16) #2
  store %struct.sv* %call49, %struct.sv** %add.ptr16, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %16) #2
  br label %if.end84

if.else51:                                        ; preds = %land.lhs.true, %if.then19
  %24 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags52 = getelementptr inbounds %struct.sv, %struct.sv* %24, i64 0, i32 2
  %25 = load i64, i64* %sv_flags52, align 8, !tbaa !20
  %and53 = and i64 %25, 2048
  %tobool54.not = icmp eq i64 %and53, 0
  br i1 %tobool54.not, label %cond.false, label %cond.end

cond.false:                                       ; preds = %if.else51
  %call55 = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %24) #2
  br label %cond.end

cond.end:                                         ; preds = %if.else51, %cond.false
  %cond = phi %struct.sv* [ %call55, %cond.false ], [ %24, %if.else51 ]
  store %struct.sv* %cond, %struct.sv** %add.ptr16, align 8, !tbaa !4
  br label %if.end84

if.else57:                                        ; preds = %if.then
  %26 = load %struct.sv**, %struct.sv*** @PL_stack_max, align 8, !tbaa !4
  %sub.ptr.lhs.cast = ptrtoint %struct.sv** %26 to i64
  %sub.ptr.rhs.cast = ptrtoint %struct.sv** %add.ptr16 to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %cmp58 = icmp slt i64 %sub.ptr.sub, 0
  br i1 %cmp58, label %if.then60, label %if.end68

if.then60:                                        ; preds = %if.else57
  %sub.ptr.rhs.cast62 = ptrtoint %struct.sv** %4 to i64
  %sub.ptr.sub63 = sub i64 %sub.ptr.rhs.cast, %sub.ptr.rhs.cast62
  %call66 = tail call %struct.sv** @Perl_stack_grow(%struct.sv** %0, %struct.sv** nonnull %add.ptr16, i32 0) #2
  %27 = load %struct.sv**, %struct.sv*** @PL_stack_base, align 8, !tbaa !4
  %sext = shl i64 %sub.ptr.sub63, 29
  %idx.ext = ashr i64 %sext, 32
  %add.ptr67 = getelementptr inbounds %struct.sv*, %struct.sv** %27, i64 %idx.ext
  br label %if.end68

if.end68:                                         ; preds = %if.then60, %if.else57
  %mark.0 = phi %struct.sv** [ %add.ptr67, %if.then60 ], [ %add.ptr16, %if.else57 ]
  store %struct.sv* @PL_sv_undef, %struct.sv** %mark.0, align 8, !tbaa !4
  br label %if.end84

for.body:                                         ; preds = %for.cond.preheader, %for.inc
  %mark.2291 = phi %struct.sv** [ %mark.2, %for.inc ], [ %mark.2289, %for.cond.preheader ]
  %28 = load %struct.sv*, %struct.sv** %mark.2291, align 8, !tbaa !4
  %sv_flags77 = getelementptr inbounds %struct.sv, %struct.sv* %28, i64 0, i32 2
  %29 = load i64, i64* %sv_flags77, align 8, !tbaa !20
  %and78 = and i64 %29, 2048
  %tobool79.not = icmp eq i64 %and78, 0
  br i1 %tobool79.not, label %if.then80, label %for.inc

if.then80:                                        ; preds = %for.body
  %call81 = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %28) #2
  store %struct.sv* %call81, %struct.sv** %mark.2291, align 8, !tbaa !4
  store i8 0, i8* @PL_tainted, align 1, !tbaa !12
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then80
  %mark.2 = getelementptr inbounds %struct.sv*, %struct.sv** %mark.2291, i64 1
  %cmp75.not = icmp ugt %struct.sv** %mark.2, %0
  br i1 %cmp75.not, label %if.end84, label %for.body, !llvm.loop !23

if.end84:                                         ; preds = %for.inc, %for.cond.preheader, %entry, %if.end68, %if.end, %if.end48, %cond.end
  %sp.0 = phi %struct.sv** [ %add.ptr16, %if.end ], [ %add.ptr16, %if.end48 ], [ %add.ptr16, %cond.end ], [ %mark.0, %if.end68 ], [ %0, %entry ], [ %0, %for.cond.preheader ], [ %0, %for.inc ]
  store %struct.sv** %sp.0, %struct.sv*** @PL_stack_sp, align 8, !tbaa !4
  tail call void @Perl_pop_scope() #2
  %30 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxix85 = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %30, i64 0, i32 2
  %31 = load i64, i64* %si_cxix85, align 8, !tbaa !11
  %dec86 = add nsw i64 %31, -1
  store i64 %dec86, i64* %si_cxix85, align 8, !tbaa !11
  %blk_u89 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7
  %hasargs = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 6
  %32 = bitcast %struct.sv** %hasargs to i8*
  %33 = load i8, i8* %32, align 8, !tbaa !12
  %tobool91.not = icmp eq i8 %33, 0
  br i1 %tobool91.not, label %if.end196, label %if.then92

if.then92:                                        ; preds = %if.end84
  %34 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any93 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %34, i64 0, i32 0
  %35 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any93, align 8, !tbaa !25
  %xgv_gp = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %35, i64 0, i32 7
  %36 = load %struct.gp.161*, %struct.gp.161** %xgv_gp, align 8, !tbaa !27
  %gp_av = getelementptr inbounds %struct.gp.161, %struct.gp.161* %36, i64 0, i32 4
  %37 = bitcast %struct.av.139** %gp_av to %struct.sv**
  %38 = load %struct.sv*, %struct.sv** %37, align 8, !tbaa !29
  tail call void @Perl_sv_free(%struct.sv* %38) #2
  %savearray = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 3
  %39 = bitcast %struct.op.136** %savearray to %struct.av.139**
  %40 = load %struct.av.139*, %struct.av.139** %39, align 8, !tbaa !12
  %41 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any98 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %41, i64 0, i32 0
  %42 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any98, align 8, !tbaa !25
  %xgv_gp99 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %42, i64 0, i32 7
  %43 = load %struct.gp.161*, %struct.gp.161** %xgv_gp99, align 8, !tbaa !27
  %gp_av100 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %43, i64 0, i32 4
  store %struct.av.139* %40, %struct.av.139** %gp_av100, align 8, !tbaa !29
  %argarray = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 4
  %44 = bitcast %struct.op.136** %argarray to %struct.av.139**
  %45 = load %struct.av.139*, %struct.av.139** %44, align 8, !tbaa !12
  %sv_any105 = getelementptr inbounds %struct.av.139, %struct.av.139* %45, i64 0, i32 0
  %46 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any105, align 8, !tbaa !31
  %xav_flags = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %46, i64 0, i32 9
  %47 = load i8, i8* %xav_flags, align 8, !tbaa !33
  %48 = and i8 %47, 1
  %tobool108.not = icmp eq i8 %48, 0
  br i1 %tobool108.not, label %if.else150, label %if.then109

if.then109:                                       ; preds = %if.then92
  %xav_fill = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %46, i64 0, i32 1
  %49 = load i64, i64* %xav_fill, align 8, !tbaa !35
  %50 = bitcast %struct.av.139* %45 to %struct.sv*
  tail call void @Perl_sv_free(%struct.sv* %50) #2
  %call121 = tail call %struct.av.139* bitcast (%struct.av* ()* @Perl_newAV to %struct.av.139* ()*)() #2
  store %struct.av.139* %call121, %struct.av.139** %44, align 8, !tbaa !12
  tail call void bitcast (void (%struct.av*, i64)* @Perl_av_extend to void (%struct.av.139*, i64)*)(%struct.av.139* %call121, i64 %49) #2
  %51 = load %struct.av.139*, %struct.av.139** %44, align 8, !tbaa !12
  %sv_any137 = getelementptr inbounds %struct.av.139, %struct.av.139* %51, i64 0, i32 0
  %52 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any137, align 8, !tbaa !31
  %xav_flags138 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %52, i64 0, i32 9
  store i8 2, i8* %xav_flags138, align 8, !tbaa !33
  %53 = bitcast %struct.op.136** %argarray to %struct.sv**
  %54 = load %struct.sv*, %struct.sv** %53, align 8, !tbaa !12
  %oldcomppad = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 7
  %55 = bitcast %struct.sv** %oldcomppad to %struct.sv*****
  %56 = load %struct.sv****, %struct.sv***** %55, align 8, !tbaa !12
  %57 = load %struct.sv***, %struct.sv**** %56, align 8, !tbaa !31
  %58 = load %struct.sv**, %struct.sv*** %57, align 8, !tbaa !36
  store %struct.sv* %54, %struct.sv** %58, align 8, !tbaa !4
  br label %if.end196

if.else150:                                       ; preds = %if.then92
  %59 = bitcast %struct.xpvav.138* %46 to %struct.sv***
  %60 = load %struct.sv**, %struct.sv*** %59, align 8, !tbaa !36
  %xav_alloc = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %46, i64 0, i32 7
  %61 = load %struct.sv**, %struct.sv*** %xav_alloc, align 8, !tbaa !37
  %sub.ptr.lhs.cast164 = ptrtoint %struct.sv** %60 to i64
  %sub.ptr.rhs.cast165 = ptrtoint %struct.sv** %61 to i64
  %sub.ptr.sub166 = sub i64 %sub.ptr.lhs.cast164, %sub.ptr.rhs.cast165
  %sub.ptr.div167 = ashr exact i64 %sub.ptr.sub166, 3
  %xav_max = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %46, i64 0, i32 2
  %62 = load i64, i64* %xav_max, align 8, !tbaa !38
  %add = add nsw i64 %sub.ptr.div167, %62
  store i64 %add, i64* %xav_max, align 8, !tbaa !38
  %63 = load %struct.av.139*, %struct.av.139** %44, align 8, !tbaa !12
  %sv_any179 = getelementptr inbounds %struct.av.139, %struct.av.139* %63, i64 0, i32 0
  %64 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any179, align 8, !tbaa !31
  %xav_alloc180 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %64, i64 0, i32 7
  %65 = bitcast %struct.sv*** %xav_alloc180 to i8**
  %66 = load i8*, i8** %65, align 8, !tbaa !37
  %xpv_pv = getelementptr %struct.xpvav.138, %struct.xpvav.138* %64, i64 0, i32 0
  store i8* %66, i8** %xpv_pv, align 8, !tbaa !39
  %67 = load %struct.av.139*, %struct.av.139** %44, align 8, !tbaa !12
  %sv_any193 = getelementptr inbounds %struct.av.139, %struct.av.139* %67, i64 0, i32 0
  %68 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any193, align 8, !tbaa !31
  %xav_fill194 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %68, i64 0, i32 1
  store i64 -1, i64* %xav_fill194, align 8, !tbaa !35
  br label %if.end196

if.end196:                                        ; preds = %if.then109, %if.else150, %if.end84
  %cv201 = bitcast %union.anon.1.173* %blk_u89 to %struct.cv.160**
  %69 = load %struct.cv.160*, %struct.cv.160** %cv201, align 8, !tbaa !12
  %tobool202.not = icmp eq %struct.cv.160* %69, null
  br i1 %tobool202.not, label %if.end212.thread, label %land.lhs.true203

land.lhs.true203:                                 ; preds = %if.end196
  %olddepth = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 5
  %70 = bitcast %struct.sv*** %olddepth to i64*
  %71 = load i64, i64* %70, align 8, !tbaa !12
  %sv_any208 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %69, i64 0, i32 0
  %72 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any208, align 8, !tbaa !14
  %xcv_depth209 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %72, i64 0, i32 14
  store i64 %71, i64* %xcv_depth209, align 8, !tbaa !16
  %tobool210.not = icmp eq i64 %71, 0
  br i1 %tobool210.not, label %if.then214, label %if.end212.thread

if.end212.thread:                                 ; preds = %if.end196, %land.lhs.true203
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  br label %if.end215

if.then214:                                       ; preds = %land.lhs.true203
  %73 = bitcast %struct.cv.160* %69 to %struct.sv*
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %73) #2
  br label %if.end215

if.end215:                                        ; preds = %if.end212.thread, %if.then214
  %call216 = tail call %struct.op.136* bitcast (%struct.op* ()* @Perl_pop_return to %struct.op.136* ()*)() #2
  ret %struct.op.136* %call216
}

; Function Attrs: noinline nounwind optsize uwtable
define %struct.op.136* @Perl_pp_leavesublv() #0 {
entry:
  %0 = load %struct.sv**, %struct.sv*** @PL_stack_sp, align 8, !tbaa !4
  %1 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxstack = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %1, i64 0, i32 1
  %2 = load %struct.context.176*, %struct.context.176** %si_cxstack, align 8, !tbaa !8
  %si_cxix = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %1, i64 0, i32 2
  %3 = load i64, i64* %si_cxix, align 8, !tbaa !11
  %dec = add nsw i64 %3, -1
  store i64 %dec, i64* %si_cxix, align 8, !tbaa !11
  %4 = load %struct.sv**, %struct.sv*** @PL_stack_base, align 8, !tbaa !4
  %blku_oldsp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 0
  %5 = load i64, i64* %blku_oldsp, align 8, !tbaa !12
  %add.ptr = getelementptr inbounds %struct.sv*, %struct.sv** %4, i64 %5
  %blku_oldcop = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 1
  %6 = load %struct.cop.164*, %struct.cop.164** %blku_oldcop, align 8, !tbaa !12
  store volatile %struct.cop.164* %6, %struct.cop.164** @PL_curcop, align 8, !tbaa !4
  %7 = load i64*, i64** @PL_markstack, align 8, !tbaa !4
  %blku_oldmarksp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 3
  %8 = load i64, i64* %blku_oldmarksp, align 8, !tbaa !12
  %add.ptr5 = getelementptr inbounds i64, i64* %7, i64 %8
  store i64* %add.ptr5, i64** @PL_markstack_ptr, align 8, !tbaa !4
  %blku_oldscopesp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 4
  %9 = load i64, i64* %blku_oldscopesp, align 8, !tbaa !12
  store i64 %9, i64* @PL_scopestack_ix, align 8, !tbaa !13
  %blku_oldretsp = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 2
  %10 = load i64, i64* %blku_oldretsp, align 8, !tbaa !12
  store i64 %10, i64* @PL_retstack_ix, align 8, !tbaa !13
  %blku_oldpm = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 5
  %11 = load %struct.pmop.150*, %struct.pmop.150** %blku_oldpm, align 8, !tbaa !12
  %blku_gimme = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 6
  %12 = load i8, i8* %blku_gimme, align 8, !tbaa !12
  store i64 %3, i64* %si_cxix, align 8, !tbaa !11
  store i8 0, i8* @PL_tainted, align 1, !tbaa !12
  %blk_u = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7
  %blku_sub = bitcast %union.anon.1.173* %blk_u to %struct.block_sub*
  %lval = getelementptr inbounds %struct.block_sub, %struct.block_sub* %blku_sub, i64 0, i32 7
  %13 = load i8, i8* %lval, align 1, !tbaa !12
  %14 = and i8 %13, 4
  %tobool.not = icmp eq i8 %14, 0
  br i1 %tobool.not, label %if.else59, label %if.then

if.then:                                          ; preds = %entry
  switch i8 %12, label %if.end844 [
    i8 0, label %temporise
    i8 1, label %if.then22
  ]

if.then22:                                        ; preds = %if.then
  %cv = bitcast %union.anon.1.173* %blk_u to %struct.cv.160**
  %15 = load %struct.cv.160*, %struct.cv.160** %cv, align 8, !tbaa !12
  %sv_any = getelementptr inbounds %struct.cv.160, %struct.cv.160* %15, i64 0, i32 0
  %16 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any, align 8, !tbaa !14
  %xcv_flags = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %16, i64 0, i32 17
  %17 = load i16, i16* %xcv_flags, align 8, !tbaa !41
  %18 = and i16 %17, 256
  %tobool29.not = icmp eq i16 %18, 0
  br i1 %tobool29.not, label %temporise_array, label %if.end31

if.end31:                                         ; preds = %if.then22
  %19 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %sub.ptr.lhs.cast = ptrtoint %struct.sv** %0 to i64
  %sub.ptr.rhs.cast = ptrtoint %struct.sv** %add.ptr to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %sub.ptr.div = ashr exact i64 %sub.ptr.sub, 3
  %add = add nsw i64 %19, %sub.ptr.div
  %20 = load i64, i64* @PL_tmps_max, align 8, !tbaa !13
  %cmp32.not = icmp slt i64 %add, %20
  br i1 %cmp32.not, label %if.end39, label %if.then34

if.then34:                                        ; preds = %if.end31
  tail call void @Perl_tmps_grow(i64 %sub.ptr.div) #2
  br label %if.end39

if.end39:                                         ; preds = %if.then34, %if.end31
  %mark.01252 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %cmp41.not1253 = icmp ugt %struct.sv** %mark.01252, %0
  br i1 %cmp41.not1253, label %if.end844, label %for.body

for.body:                                         ; preds = %if.end39, %for.inc
  %mark.01254 = phi %struct.sv** [ %mark.0, %for.inc ], [ %mark.01252, %if.end39 ]
  %21 = load %struct.sv*, %struct.sv** %mark.01254, align 8, !tbaa !4
  %sv_flags = getelementptr inbounds %struct.sv, %struct.sv* %21, i64 0, i32 2
  %22 = load i64, i64* %sv_flags, align 8, !tbaa !20
  %and43 = and i64 %22, 2048
  %tobool44.not = icmp eq i64 %and43, 0
  br i1 %tobool44.not, label %if.else, label %for.inc

if.else:                                          ; preds = %for.body
  %and47 = and i64 %22, 8389120
  %tobool48.not = icmp eq i64 %and47, 0
  br i1 %tobool48.not, label %if.else50, label %if.then49

if.then49:                                        ; preds = %if.else
  %call = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %21) #2
  store %struct.sv* %call, %struct.sv** %mark.01254, align 8, !tbaa !4
  br label %for.inc

if.else50:                                        ; preds = %if.else
  %23 = load %struct.sv**, %struct.sv*** @PL_tmps_stack, align 8, !tbaa !4
  %24 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %inc51 = add nsw i64 %24, 1
  store i64 %inc51, i64* @PL_tmps_ix, align 8, !tbaa !13
  %arrayidx52 = getelementptr inbounds %struct.sv*, %struct.sv** %23, i64 %inc51
  store %struct.sv* %21, %struct.sv** %arrayidx52, align 8, !tbaa !4
  %25 = load %struct.sv*, %struct.sv** %mark.01254, align 8, !tbaa !4
  store %struct.sv* %25, %struct.sv** @PL_Sv, align 8, !tbaa !4
  %tobool53.not = icmp eq %struct.sv* %25, null
  br i1 %tobool53.not, label %for.inc, label %land.rhs

land.rhs:                                         ; preds = %if.else50
  %sv_refcnt = getelementptr inbounds %struct.sv, %struct.sv* %25, i64 0, i32 1
  %26 = load i64, i64* %sv_refcnt, align 8, !tbaa !22
  %inc54 = add i64 %26, 1
  store i64 %inc54, i64* %sv_refcnt, align 8, !tbaa !22
  br label %for.inc

for.inc:                                          ; preds = %if.else50, %land.rhs, %for.body, %if.then49
  %mark.0 = getelementptr inbounds %struct.sv*, %struct.sv** %mark.01254, i64 1
  %cmp41.not = icmp ugt %struct.sv** %mark.0, %0
  br i1 %cmp41.not, label %if.end844, label %for.body, !llvm.loop !42

if.else59:                                        ; preds = %entry
  %tobool65.not = icmp eq i8 %13, 0
  br i1 %tobool65.not, label %if.else741, label %if.then66

if.then66:                                        ; preds = %if.else59
  %cv71 = bitcast %union.anon.1.173* %blk_u to %struct.cv.160**
  %27 = load %struct.cv.160*, %struct.cv.160** %cv71, align 8, !tbaa !12
  %sv_any72 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %27, i64 0, i32 0
  %28 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any72, align 8, !tbaa !14
  %xcv_flags73 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %28, i64 0, i32 17
  %29 = load i16, i16* %xcv_flags73, align 8, !tbaa !41
  %30 = and i16 %29, 256
  %tobool76.not = icmp eq i16 %30, 0
  br i1 %tobool76.not, label %if.then77, label %if.end209

if.then77:                                        ; preds = %if.then66
  tail call void @Perl_pop_scope() #2
  %31 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxix78 = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %31, i64 0, i32 2
  %32 = load i64, i64* %si_cxix78, align 8, !tbaa !11
  %dec79 = add nsw i64 %32, -1
  store i64 %dec79, i64* %si_cxix78, align 8, !tbaa !11
  %hasargs = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 6
  %33 = bitcast %struct.sv** %hasargs to i8*
  %34 = load i8, i8* %33, align 8, !tbaa !12
  %tobool84.not = icmp eq i8 %34, 0
  br i1 %tobool84.not, label %if.end190, label %if.then85

if.then85:                                        ; preds = %if.then77
  %35 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any86 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %35, i64 0, i32 0
  %36 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any86, align 8, !tbaa !25
  %xgv_gp = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %36, i64 0, i32 7
  %37 = load %struct.gp.161*, %struct.gp.161** %xgv_gp, align 8, !tbaa !27
  %gp_av = getelementptr inbounds %struct.gp.161, %struct.gp.161* %37, i64 0, i32 4
  %38 = bitcast %struct.av.139** %gp_av to %struct.sv**
  %39 = load %struct.sv*, %struct.sv** %38, align 8, !tbaa !29
  tail call void @Perl_sv_free(%struct.sv* %39) #2
  %savearray = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 3
  %40 = bitcast %struct.op.136** %savearray to %struct.av.139**
  %41 = load %struct.av.139*, %struct.av.139** %40, align 8, !tbaa !12
  %42 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any91 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %42, i64 0, i32 0
  %43 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any91, align 8, !tbaa !25
  %xgv_gp92 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %43, i64 0, i32 7
  %44 = load %struct.gp.161*, %struct.gp.161** %xgv_gp92, align 8, !tbaa !27
  %gp_av93 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %44, i64 0, i32 4
  store %struct.av.139* %41, %struct.av.139** %gp_av93, align 8, !tbaa !29
  %argarray = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 4
  %45 = bitcast %struct.op.136** %argarray to %struct.av.139**
  %46 = load %struct.av.139*, %struct.av.139** %45, align 8, !tbaa !12
  %sv_any98 = getelementptr inbounds %struct.av.139, %struct.av.139* %46, i64 0, i32 0
  %47 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any98, align 8, !tbaa !31
  %xav_flags = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %47, i64 0, i32 9
  %48 = load i8, i8* %xav_flags, align 8, !tbaa !33
  %49 = and i8 %48, 1
  %tobool101.not = icmp eq i8 %49, 0
  br i1 %tobool101.not, label %if.else143, label %if.then102

if.then102:                                       ; preds = %if.then85
  %xav_fill = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %47, i64 0, i32 1
  %50 = load i64, i64* %xav_fill, align 8, !tbaa !35
  %51 = bitcast %struct.av.139* %46 to %struct.sv*
  tail call void @Perl_sv_free(%struct.sv* %51) #2
  %call114 = tail call %struct.av.139* bitcast (%struct.av* ()* @Perl_newAV to %struct.av.139* ()*)() #2
  store %struct.av.139* %call114, %struct.av.139** %45, align 8, !tbaa !12
  tail call void bitcast (void (%struct.av*, i64)* @Perl_av_extend to void (%struct.av.139*, i64)*)(%struct.av.139* %call114, i64 %50) #2
  %52 = load %struct.av.139*, %struct.av.139** %45, align 8, !tbaa !12
  %sv_any130 = getelementptr inbounds %struct.av.139, %struct.av.139* %52, i64 0, i32 0
  %53 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any130, align 8, !tbaa !31
  %xav_flags131 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %53, i64 0, i32 9
  store i8 2, i8* %xav_flags131, align 8, !tbaa !33
  %54 = bitcast %struct.op.136** %argarray to %struct.sv**
  %55 = load %struct.sv*, %struct.sv** %54, align 8, !tbaa !12
  %oldcomppad = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 7
  %56 = bitcast %struct.sv** %oldcomppad to %struct.sv*****
  %57 = load %struct.sv****, %struct.sv***** %56, align 8, !tbaa !12
  %58 = load %struct.sv***, %struct.sv**** %57, align 8, !tbaa !31
  %59 = load %struct.sv**, %struct.sv*** %58, align 8, !tbaa !36
  store %struct.sv* %55, %struct.sv** %59, align 8, !tbaa !4
  br label %if.end190

if.else143:                                       ; preds = %if.then85
  %60 = bitcast %struct.xpvav.138* %47 to %struct.sv***
  %61 = load %struct.sv**, %struct.sv*** %60, align 8, !tbaa !36
  %xav_alloc = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %47, i64 0, i32 7
  %62 = load %struct.sv**, %struct.sv*** %xav_alloc, align 8, !tbaa !37
  %sub.ptr.lhs.cast157 = ptrtoint %struct.sv** %61 to i64
  %sub.ptr.rhs.cast158 = ptrtoint %struct.sv** %62 to i64
  %sub.ptr.sub159 = sub i64 %sub.ptr.lhs.cast157, %sub.ptr.rhs.cast158
  %sub.ptr.div160 = ashr exact i64 %sub.ptr.sub159, 3
  %xav_max = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %47, i64 0, i32 2
  %63 = load i64, i64* %xav_max, align 8, !tbaa !38
  %add167 = add nsw i64 %sub.ptr.div160, %63
  store i64 %add167, i64* %xav_max, align 8, !tbaa !38
  %64 = load %struct.av.139*, %struct.av.139** %45, align 8, !tbaa !12
  %sv_any173 = getelementptr inbounds %struct.av.139, %struct.av.139* %64, i64 0, i32 0
  %65 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any173, align 8, !tbaa !31
  %xav_alloc174 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %65, i64 0, i32 7
  %66 = bitcast %struct.sv*** %xav_alloc174 to i8**
  %67 = load i8*, i8** %66, align 8, !tbaa !37
  %xpv_pv = getelementptr %struct.xpvav.138, %struct.xpvav.138* %65, i64 0, i32 0
  store i8* %67, i8** %xpv_pv, align 8, !tbaa !39
  %68 = load %struct.av.139*, %struct.av.139** %45, align 8, !tbaa !12
  %sv_any187 = getelementptr inbounds %struct.av.139, %struct.av.139* %68, i64 0, i32 0
  %69 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any187, align 8, !tbaa !31
  %xav_fill188 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %69, i64 0, i32 1
  store i64 -1, i64* %xav_fill188, align 8, !tbaa !35
  br label %if.end190

if.end190:                                        ; preds = %if.then102, %if.else143, %if.then77
  %70 = load %struct.cv.160*, %struct.cv.160** %cv71, align 8, !tbaa !12
  %tobool196.not = icmp eq %struct.cv.160* %70, null
  br i1 %tobool196.not, label %if.end204.thread, label %land.lhs.true

land.lhs.true:                                    ; preds = %if.end190
  %olddepth = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 5
  %71 = bitcast %struct.sv*** %olddepth to i64*
  %72 = load i64, i64* %71, align 8, !tbaa !12
  %sv_any201 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %70, i64 0, i32 0
  %73 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any201, align 8, !tbaa !14
  %xcv_depth = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %73, i64 0, i32 14
  store i64 %72, i64* %xcv_depth, align 8, !tbaa !16
  %tobool202.not = icmp eq i64 %72, 0
  br i1 %tobool202.not, label %if.then206, label %if.end204.thread

if.end204.thread:                                 ; preds = %if.end190, %land.lhs.true
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  br label %if.end207

if.then206:                                       ; preds = %land.lhs.true
  %74 = bitcast %struct.cv.160* %70 to %struct.sv*
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %74) #2
  br label %if.end207

if.end207:                                        ; preds = %if.end204.thread, %if.then206
  %call208 = tail call %struct.op.136* (i8*, ...) bitcast (%struct.op* (i8*, ...)* @Perl_die to %struct.op.136* (i8*, ...)*)(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.28.2199, i64 0, i64 0)) #2
  br label %cleanup

if.end209:                                        ; preds = %if.then66
  switch i8 %12, label %if.end844 [
    i8 0, label %if.then212
    i8 1, label %if.then547
  ]

if.then212:                                       ; preds = %if.end209
  %add.ptr213 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %75 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %add214 = add nsw i64 %75, 1
  %76 = load i64, i64* @PL_tmps_max, align 8, !tbaa !13
  %cmp215.not = icmp slt i64 %add214, %76
  br i1 %cmp215.not, label %if.end218, label %if.then217

if.then217:                                       ; preds = %if.then212
  tail call void @Perl_tmps_grow(i64 1) #2
  br label %if.end218

if.end218:                                        ; preds = %if.then217, %if.then212
  %cmp219 = icmp eq %struct.sv** %add.ptr213, %0
  br i1 %cmp219, label %if.then221, label %if.else391

if.then221:                                       ; preds = %if.end218
  %77 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags222 = getelementptr inbounds %struct.sv, %struct.sv* %77, i64 0, i32 2
  %78 = load i64, i64* %sv_flags222, align 8, !tbaa !20
  %and223 = and i64 %78, 8391168
  %tobool224.not = icmp eq i64 %and223, 0
  br i1 %tobool224.not, label %if.else380, label %if.then225

if.then225:                                       ; preds = %if.then221
  tail call void @Perl_pop_scope() #2
  %79 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxix226 = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %79, i64 0, i32 2
  %80 = load i64, i64* %si_cxix226, align 8, !tbaa !11
  %dec227 = add nsw i64 %80, -1
  store i64 %dec227, i64* %si_cxix226, align 8, !tbaa !11
  %hasargs232 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 6
  %81 = bitcast %struct.sv** %hasargs232 to i8*
  %82 = load i8, i8* %81, align 8, !tbaa !12
  %tobool233.not = icmp eq i8 %82, 0
  br i1 %tobool233.not, label %if.end352, label %if.then234

if.then234:                                       ; preds = %if.then225
  %83 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any235 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %83, i64 0, i32 0
  %84 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any235, align 8, !tbaa !25
  %xgv_gp236 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %84, i64 0, i32 7
  %85 = load %struct.gp.161*, %struct.gp.161** %xgv_gp236, align 8, !tbaa !27
  %gp_av237 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %85, i64 0, i32 4
  %86 = bitcast %struct.av.139** %gp_av237 to %struct.sv**
  %87 = load %struct.sv*, %struct.sv** %86, align 8, !tbaa !29
  tail call void @Perl_sv_free(%struct.sv* %87) #2
  %savearray243 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 3
  %88 = bitcast %struct.op.136** %savearray243 to %struct.av.139**
  %89 = load %struct.av.139*, %struct.av.139** %88, align 8, !tbaa !12
  %90 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any244 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %90, i64 0, i32 0
  %91 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any244, align 8, !tbaa !25
  %xgv_gp245 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %91, i64 0, i32 7
  %92 = load %struct.gp.161*, %struct.gp.161** %xgv_gp245, align 8, !tbaa !27
  %gp_av246 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %92, i64 0, i32 4
  store %struct.av.139* %89, %struct.av.139** %gp_av246, align 8, !tbaa !29
  %argarray251 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 4
  %93 = bitcast %struct.op.136** %argarray251 to %struct.av.139**
  %94 = load %struct.av.139*, %struct.av.139** %93, align 8, !tbaa !12
  %sv_any252 = getelementptr inbounds %struct.av.139, %struct.av.139* %94, i64 0, i32 0
  %95 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any252, align 8, !tbaa !31
  %xav_flags253 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %95, i64 0, i32 9
  %96 = load i8, i8* %xav_flags253, align 8, !tbaa !33
  %97 = and i8 %96, 1
  %tobool256.not = icmp eq i8 %97, 0
  br i1 %tobool256.not, label %if.else302, label %if.then257

if.then257:                                       ; preds = %if.then234
  %xav_fill265 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %95, i64 0, i32 1
  %98 = load i64, i64* %xav_fill265, align 8, !tbaa !35
  %99 = bitcast %struct.av.139* %94 to %struct.sv*
  tail call void @Perl_sv_free(%struct.sv* %99) #2
  %call271 = tail call %struct.av.139* bitcast (%struct.av* ()* @Perl_newAV to %struct.av.139* ()*)() #2
  store %struct.av.139* %call271, %struct.av.139** %93, align 8, !tbaa !12
  tail call void bitcast (void (%struct.av*, i64)* @Perl_av_extend to void (%struct.av.139*, i64)*)(%struct.av.139* %call271, i64 %98) #2
  %100 = load %struct.av.139*, %struct.av.139** %93, align 8, !tbaa !12
  %sv_any287 = getelementptr inbounds %struct.av.139, %struct.av.139* %100, i64 0, i32 0
  %101 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any287, align 8, !tbaa !31
  %xav_flags288 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %101, i64 0, i32 9
  store i8 2, i8* %xav_flags288, align 8, !tbaa !33
  %102 = bitcast %struct.op.136** %argarray251 to %struct.sv**
  %103 = load %struct.sv*, %struct.sv** %102, align 8, !tbaa !12
  %oldcomppad298 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 7
  %104 = bitcast %struct.sv** %oldcomppad298 to %struct.sv*****
  %105 = load %struct.sv****, %struct.sv***** %104, align 8, !tbaa !12
  %106 = load %struct.sv***, %struct.sv**** %105, align 8, !tbaa !31
  %107 = load %struct.sv**, %struct.sv*** %106, align 8, !tbaa !36
  store %struct.sv* %103, %struct.sv** %107, align 8, !tbaa !4
  br label %if.end352

if.else302:                                       ; preds = %if.then234
  %108 = bitcast %struct.xpvav.138* %95 to %struct.sv***
  %109 = load %struct.sv**, %struct.sv*** %108, align 8, !tbaa !36
  %xav_alloc316 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %95, i64 0, i32 7
  %110 = load %struct.sv**, %struct.sv*** %xav_alloc316, align 8, !tbaa !37
  %sub.ptr.lhs.cast317 = ptrtoint %struct.sv** %109 to i64
  %sub.ptr.rhs.cast318 = ptrtoint %struct.sv** %110 to i64
  %sub.ptr.sub319 = sub i64 %sub.ptr.lhs.cast317, %sub.ptr.rhs.cast318
  %sub.ptr.div320 = ashr exact i64 %sub.ptr.sub319, 3
  %xav_max327 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %95, i64 0, i32 2
  %111 = load i64, i64* %xav_max327, align 8, !tbaa !38
  %add328 = add nsw i64 %sub.ptr.div320, %111
  store i64 %add328, i64* %xav_max327, align 8, !tbaa !38
  %112 = load %struct.av.139*, %struct.av.139** %93, align 8, !tbaa !12
  %sv_any334 = getelementptr inbounds %struct.av.139, %struct.av.139* %112, i64 0, i32 0
  %113 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any334, align 8, !tbaa !31
  %xav_alloc335 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %113, i64 0, i32 7
  %114 = bitcast %struct.sv*** %xav_alloc335 to i8**
  %115 = load i8*, i8** %114, align 8, !tbaa !37
  %xpv_pv342 = getelementptr %struct.xpvav.138, %struct.xpvav.138* %113, i64 0, i32 0
  store i8* %115, i8** %xpv_pv342, align 8, !tbaa !39
  %116 = load %struct.av.139*, %struct.av.139** %93, align 8, !tbaa !12
  %sv_any349 = getelementptr inbounds %struct.av.139, %struct.av.139* %116, i64 0, i32 0
  %117 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any349, align 8, !tbaa !31
  %xav_fill350 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %117, i64 0, i32 1
  store i64 -1, i64* %xav_fill350, align 8, !tbaa !35
  br label %if.end352

if.end352:                                        ; preds = %if.then257, %if.else302, %if.then225
  %118 = load %struct.cv.160*, %struct.cv.160** %cv71, align 8, !tbaa !12
  %tobool358.not = icmp eq %struct.cv.160* %118, null
  br i1 %tobool358.not, label %if.end369.thread, label %land.lhs.true359

land.lhs.true359:                                 ; preds = %if.end352
  %olddepth364 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 5
  %119 = bitcast %struct.sv*** %olddepth364 to i64*
  %120 = load i64, i64* %119, align 8, !tbaa !12
  %sv_any365 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %118, i64 0, i32 0
  %121 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any365, align 8, !tbaa !14
  %xcv_depth366 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %121, i64 0, i32 14
  store i64 %120, i64* %xcv_depth366, align 8, !tbaa !16
  %tobool367.not = icmp eq i64 %120, 0
  br i1 %tobool367.not, label %if.then371, label %if.end369.thread

if.end369.thread:                                 ; preds = %if.end352, %land.lhs.true359
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  br label %if.end372

if.then371:                                       ; preds = %land.lhs.true359
  %122 = bitcast %struct.cv.160* %118 to %struct.sv*
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %122) #2
  br label %if.end372

if.end372:                                        ; preds = %if.end369.thread, %if.then371
  %123 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags373 = getelementptr inbounds %struct.sv, %struct.sv* %123, i64 0, i32 2
  %124 = load i64, i64* %sv_flags373, align 8, !tbaa !20
  %and374 = and i64 %124, 8388608
  %tobool375.not = icmp eq i64 %and374, 0
  %cmp376 = icmp eq %struct.sv* %123, @PL_sv_undef
  %cond = select i1 %cmp376, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.30.2200, i64 0, i64 0), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.31.2201, i64 0, i64 0)
  %cond378 = select i1 %tobool375.not, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.32.2202, i64 0, i64 0), i8* %cond
  %call379 = tail call %struct.op.136* (i8*, ...) bitcast (%struct.op* (i8*, ...)* @Perl_die to %struct.op.136* (i8*, ...)*)(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.29.2203, i64 0, i64 0), i8* %cond378) #2
  br label %cleanup

if.else380:                                       ; preds = %if.then221
  %125 = load %struct.sv**, %struct.sv*** @PL_tmps_stack, align 8, !tbaa !4
  %126 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %inc381 = add nsw i64 %126, 1
  store i64 %inc381, i64* @PL_tmps_ix, align 8, !tbaa !13
  %arrayidx382 = getelementptr inbounds %struct.sv*, %struct.sv** %125, i64 %inc381
  store %struct.sv* %77, %struct.sv** %arrayidx382, align 8, !tbaa !4
  %127 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  store %struct.sv* %127, %struct.sv** @PL_Sv, align 8, !tbaa !4
  %tobool383.not = icmp eq %struct.sv* %127, null
  br i1 %tobool383.not, label %if.end844, label %land.rhs384

land.rhs384:                                      ; preds = %if.else380
  %sv_refcnt385 = getelementptr inbounds %struct.sv, %struct.sv* %127, i64 0, i32 1
  %128 = load i64, i64* %sv_refcnt385, align 8, !tbaa !22
  %inc386 = add i64 %128, 1
  store i64 %inc386, i64* %sv_refcnt385, align 8, !tbaa !22
  br label %if.end844

if.else391:                                       ; preds = %if.end218
  tail call void @Perl_pop_scope() #2
  %129 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxix392 = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %129, i64 0, i32 2
  %130 = load i64, i64* %si_cxix392, align 8, !tbaa !11
  %dec393 = add nsw i64 %130, -1
  store i64 %dec393, i64* %si_cxix392, align 8, !tbaa !11
  %hasargs398 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 6
  %131 = bitcast %struct.sv** %hasargs398 to i8*
  %132 = load i8, i8* %131, align 8, !tbaa !12
  %tobool399.not = icmp eq i8 %132, 0
  br i1 %tobool399.not, label %if.end518, label %if.then400

if.then400:                                       ; preds = %if.else391
  %133 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any401 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %133, i64 0, i32 0
  %134 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any401, align 8, !tbaa !25
  %xgv_gp402 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %134, i64 0, i32 7
  %135 = load %struct.gp.161*, %struct.gp.161** %xgv_gp402, align 8, !tbaa !27
  %gp_av403 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %135, i64 0, i32 4
  %136 = bitcast %struct.av.139** %gp_av403 to %struct.sv**
  %137 = load %struct.sv*, %struct.sv** %136, align 8, !tbaa !29
  tail call void @Perl_sv_free(%struct.sv* %137) #2
  %savearray409 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 3
  %138 = bitcast %struct.op.136** %savearray409 to %struct.av.139**
  %139 = load %struct.av.139*, %struct.av.139** %138, align 8, !tbaa !12
  %140 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any410 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %140, i64 0, i32 0
  %141 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any410, align 8, !tbaa !25
  %xgv_gp411 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %141, i64 0, i32 7
  %142 = load %struct.gp.161*, %struct.gp.161** %xgv_gp411, align 8, !tbaa !27
  %gp_av412 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %142, i64 0, i32 4
  store %struct.av.139* %139, %struct.av.139** %gp_av412, align 8, !tbaa !29
  %argarray417 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 4
  %143 = bitcast %struct.op.136** %argarray417 to %struct.av.139**
  %144 = load %struct.av.139*, %struct.av.139** %143, align 8, !tbaa !12
  %sv_any418 = getelementptr inbounds %struct.av.139, %struct.av.139* %144, i64 0, i32 0
  %145 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any418, align 8, !tbaa !31
  %xav_flags419 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %145, i64 0, i32 9
  %146 = load i8, i8* %xav_flags419, align 8, !tbaa !33
  %147 = and i8 %146, 1
  %tobool422.not = icmp eq i8 %147, 0
  br i1 %tobool422.not, label %if.else468, label %if.then423

if.then423:                                       ; preds = %if.then400
  %xav_fill431 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %145, i64 0, i32 1
  %148 = load i64, i64* %xav_fill431, align 8, !tbaa !35
  %149 = bitcast %struct.av.139* %144 to %struct.sv*
  tail call void @Perl_sv_free(%struct.sv* %149) #2
  %call437 = tail call %struct.av.139* bitcast (%struct.av* ()* @Perl_newAV to %struct.av.139* ()*)() #2
  store %struct.av.139* %call437, %struct.av.139** %143, align 8, !tbaa !12
  tail call void bitcast (void (%struct.av*, i64)* @Perl_av_extend to void (%struct.av.139*, i64)*)(%struct.av.139* %call437, i64 %148) #2
  %150 = load %struct.av.139*, %struct.av.139** %143, align 8, !tbaa !12
  %sv_any453 = getelementptr inbounds %struct.av.139, %struct.av.139* %150, i64 0, i32 0
  %151 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any453, align 8, !tbaa !31
  %xav_flags454 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %151, i64 0, i32 9
  store i8 2, i8* %xav_flags454, align 8, !tbaa !33
  %152 = bitcast %struct.op.136** %argarray417 to %struct.sv**
  %153 = load %struct.sv*, %struct.sv** %152, align 8, !tbaa !12
  %oldcomppad464 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 7
  %154 = bitcast %struct.sv** %oldcomppad464 to %struct.sv*****
  %155 = load %struct.sv****, %struct.sv***** %154, align 8, !tbaa !12
  %156 = load %struct.sv***, %struct.sv**** %155, align 8, !tbaa !31
  %157 = load %struct.sv**, %struct.sv*** %156, align 8, !tbaa !36
  store %struct.sv* %153, %struct.sv** %157, align 8, !tbaa !4
  br label %if.end518

if.else468:                                       ; preds = %if.then400
  %158 = bitcast %struct.xpvav.138* %145 to %struct.sv***
  %159 = load %struct.sv**, %struct.sv*** %158, align 8, !tbaa !36
  %xav_alloc482 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %145, i64 0, i32 7
  %160 = load %struct.sv**, %struct.sv*** %xav_alloc482, align 8, !tbaa !37
  %sub.ptr.lhs.cast483 = ptrtoint %struct.sv** %159 to i64
  %sub.ptr.rhs.cast484 = ptrtoint %struct.sv** %160 to i64
  %sub.ptr.sub485 = sub i64 %sub.ptr.lhs.cast483, %sub.ptr.rhs.cast484
  %sub.ptr.div486 = ashr exact i64 %sub.ptr.sub485, 3
  %xav_max493 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %145, i64 0, i32 2
  %161 = load i64, i64* %xav_max493, align 8, !tbaa !38
  %add494 = add nsw i64 %sub.ptr.div486, %161
  store i64 %add494, i64* %xav_max493, align 8, !tbaa !38
  %162 = load %struct.av.139*, %struct.av.139** %143, align 8, !tbaa !12
  %sv_any500 = getelementptr inbounds %struct.av.139, %struct.av.139* %162, i64 0, i32 0
  %163 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any500, align 8, !tbaa !31
  %xav_alloc501 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %163, i64 0, i32 7
  %164 = bitcast %struct.sv*** %xav_alloc501 to i8**
  %165 = load i8*, i8** %164, align 8, !tbaa !37
  %xpv_pv508 = getelementptr %struct.xpvav.138, %struct.xpvav.138* %163, i64 0, i32 0
  store i8* %165, i8** %xpv_pv508, align 8, !tbaa !39
  %166 = load %struct.av.139*, %struct.av.139** %143, align 8, !tbaa !12
  %sv_any515 = getelementptr inbounds %struct.av.139, %struct.av.139* %166, i64 0, i32 0
  %167 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any515, align 8, !tbaa !31
  %xav_fill516 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %167, i64 0, i32 1
  store i64 -1, i64* %xav_fill516, align 8, !tbaa !35
  br label %if.end518

if.end518:                                        ; preds = %if.then423, %if.else468, %if.else391
  %168 = load %struct.cv.160*, %struct.cv.160** %cv71, align 8, !tbaa !12
  %tobool524.not = icmp eq %struct.cv.160* %168, null
  br i1 %tobool524.not, label %if.end535.thread, label %land.lhs.true525

land.lhs.true525:                                 ; preds = %if.end518
  %olddepth530 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 5
  %169 = bitcast %struct.sv*** %olddepth530 to i64*
  %170 = load i64, i64* %169, align 8, !tbaa !12
  %sv_any531 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %168, i64 0, i32 0
  %171 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any531, align 8, !tbaa !14
  %xcv_depth532 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %171, i64 0, i32 14
  store i64 %170, i64* %xcv_depth532, align 8, !tbaa !16
  %tobool533.not = icmp eq i64 %170, 0
  br i1 %tobool533.not, label %if.then537, label %if.end535.thread

if.end535.thread:                                 ; preds = %if.end518, %land.lhs.true525
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  br label %if.end538

if.then537:                                       ; preds = %land.lhs.true525
  %172 = bitcast %struct.cv.160* %168 to %struct.sv*
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %172) #2
  br label %if.end538

if.end538:                                        ; preds = %if.end535.thread, %if.then537
  %cmp539 = icmp ugt %struct.sv** %add.ptr213, %0
  %cond541 = select i1 %cmp539, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.34.2204, i64 0, i64 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.35.2205, i64 0, i64 0)
  %call542 = tail call %struct.op.136* (i8*, ...) bitcast (%struct.op* (i8*, ...)* @Perl_die to %struct.op.136* (i8*, ...)*)(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.33.2206, i64 0, i64 0), i8* %cond541) #2
  br label %cleanup

if.then547:                                       ; preds = %if.end209
  %173 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %sub.ptr.lhs.cast548 = ptrtoint %struct.sv** %0 to i64
  %sub.ptr.rhs.cast549 = ptrtoint %struct.sv** %add.ptr to i64
  %sub.ptr.sub550 = sub i64 %sub.ptr.lhs.cast548, %sub.ptr.rhs.cast549
  %sub.ptr.div551 = ashr exact i64 %sub.ptr.sub550, 3
  %add552 = add nsw i64 %173, %sub.ptr.div551
  %174 = load i64, i64* @PL_tmps_max, align 8, !tbaa !13
  %cmp553.not = icmp slt i64 %add552, %174
  br i1 %cmp553.not, label %if.end560, label %if.then555

if.then555:                                       ; preds = %if.then547
  tail call void @Perl_tmps_grow(i64 %sub.ptr.div551) #2
  br label %if.end560

if.end560:                                        ; preds = %if.then555, %if.then547
  %mark.11249 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %cmp563.not1250 = icmp ugt %struct.sv** %mark.11249, %0
  br i1 %cmp563.not1250, label %if.end844, label %for.body565

for.body565:                                      ; preds = %if.end560, %land.end733
  %mark.11251 = phi %struct.sv** [ %mark.1, %land.end733 ], [ %mark.11249, %if.end560 ]
  %175 = load %struct.sv*, %struct.sv** %mark.11251, align 8, !tbaa !4
  %cmp566.not = icmp eq %struct.sv* %175, @PL_sv_undef
  br i1 %cmp566.not, label %if.else725, label %land.lhs.true568

land.lhs.true568:                                 ; preds = %for.body565
  %sv_flags569 = getelementptr inbounds %struct.sv, %struct.sv* %175, i64 0, i32 2
  %176 = load i64, i64* %sv_flags569, align 8, !tbaa !20
  %and570 = and i64 %176, 8391168
  %tobool571.not = icmp eq i64 %and570, 0
  br i1 %tobool571.not, label %if.else725, label %if.then572

if.then572:                                       ; preds = %land.lhs.true568
  store %struct.sv** %0, %struct.sv*** @PL_stack_sp, align 8, !tbaa !4
  tail call void @Perl_pop_scope() #2
  %177 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxix573 = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %177, i64 0, i32 2
  %178 = load i64, i64* %si_cxix573, align 8, !tbaa !11
  %dec574 = add nsw i64 %178, -1
  store i64 %dec574, i64* %si_cxix573, align 8, !tbaa !11
  %hasargs579 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 6
  %179 = bitcast %struct.sv** %hasargs579 to i8*
  %180 = load i8, i8* %179, align 8, !tbaa !12
  %tobool580.not = icmp eq i8 %180, 0
  br i1 %tobool580.not, label %if.end699, label %if.then581

if.then581:                                       ; preds = %if.then572
  %181 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any582 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %181, i64 0, i32 0
  %182 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any582, align 8, !tbaa !25
  %xgv_gp583 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %182, i64 0, i32 7
  %183 = load %struct.gp.161*, %struct.gp.161** %xgv_gp583, align 8, !tbaa !27
  %gp_av584 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %183, i64 0, i32 4
  %184 = bitcast %struct.av.139** %gp_av584 to %struct.sv**
  %185 = load %struct.sv*, %struct.sv** %184, align 8, !tbaa !29
  tail call void @Perl_sv_free(%struct.sv* %185) #2
  %savearray590 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 3
  %186 = bitcast %struct.op.136** %savearray590 to %struct.av.139**
  %187 = load %struct.av.139*, %struct.av.139** %186, align 8, !tbaa !12
  %188 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any591 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %188, i64 0, i32 0
  %189 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any591, align 8, !tbaa !25
  %xgv_gp592 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %189, i64 0, i32 7
  %190 = load %struct.gp.161*, %struct.gp.161** %xgv_gp592, align 8, !tbaa !27
  %gp_av593 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %190, i64 0, i32 4
  store %struct.av.139* %187, %struct.av.139** %gp_av593, align 8, !tbaa !29
  %argarray598 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 4
  %191 = bitcast %struct.op.136** %argarray598 to %struct.av.139**
  %192 = load %struct.av.139*, %struct.av.139** %191, align 8, !tbaa !12
  %sv_any599 = getelementptr inbounds %struct.av.139, %struct.av.139* %192, i64 0, i32 0
  %193 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any599, align 8, !tbaa !31
  %xav_flags600 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %193, i64 0, i32 9
  %194 = load i8, i8* %xav_flags600, align 8, !tbaa !33
  %195 = and i8 %194, 1
  %tobool603.not = icmp eq i8 %195, 0
  br i1 %tobool603.not, label %if.else649, label %if.then604

if.then604:                                       ; preds = %if.then581
  %xav_fill612 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %193, i64 0, i32 1
  %196 = load i64, i64* %xav_fill612, align 8, !tbaa !35
  %197 = bitcast %struct.av.139* %192 to %struct.sv*
  tail call void @Perl_sv_free(%struct.sv* %197) #2
  %call618 = tail call %struct.av.139* bitcast (%struct.av* ()* @Perl_newAV to %struct.av.139* ()*)() #2
  store %struct.av.139* %call618, %struct.av.139** %191, align 8, !tbaa !12
  tail call void bitcast (void (%struct.av*, i64)* @Perl_av_extend to void (%struct.av.139*, i64)*)(%struct.av.139* %call618, i64 %196) #2
  %198 = load %struct.av.139*, %struct.av.139** %191, align 8, !tbaa !12
  %sv_any634 = getelementptr inbounds %struct.av.139, %struct.av.139* %198, i64 0, i32 0
  %199 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any634, align 8, !tbaa !31
  %xav_flags635 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %199, i64 0, i32 9
  store i8 2, i8* %xav_flags635, align 8, !tbaa !33
  %200 = bitcast %struct.op.136** %argarray598 to %struct.sv**
  %201 = load %struct.sv*, %struct.sv** %200, align 8, !tbaa !12
  %oldcomppad645 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 7
  %202 = bitcast %struct.sv** %oldcomppad645 to %struct.sv*****
  %203 = load %struct.sv****, %struct.sv***** %202, align 8, !tbaa !12
  %204 = load %struct.sv***, %struct.sv**** %203, align 8, !tbaa !31
  %205 = load %struct.sv**, %struct.sv*** %204, align 8, !tbaa !36
  store %struct.sv* %201, %struct.sv** %205, align 8, !tbaa !4
  br label %if.end699

if.else649:                                       ; preds = %if.then581
  %206 = bitcast %struct.xpvav.138* %193 to %struct.sv***
  %207 = load %struct.sv**, %struct.sv*** %206, align 8, !tbaa !36
  %xav_alloc663 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %193, i64 0, i32 7
  %208 = load %struct.sv**, %struct.sv*** %xav_alloc663, align 8, !tbaa !37
  %sub.ptr.lhs.cast664 = ptrtoint %struct.sv** %207 to i64
  %sub.ptr.rhs.cast665 = ptrtoint %struct.sv** %208 to i64
  %sub.ptr.sub666 = sub i64 %sub.ptr.lhs.cast664, %sub.ptr.rhs.cast665
  %sub.ptr.div667 = ashr exact i64 %sub.ptr.sub666, 3
  %xav_max674 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %193, i64 0, i32 2
  %209 = load i64, i64* %xav_max674, align 8, !tbaa !38
  %add675 = add nsw i64 %sub.ptr.div667, %209
  store i64 %add675, i64* %xav_max674, align 8, !tbaa !38
  %210 = load %struct.av.139*, %struct.av.139** %191, align 8, !tbaa !12
  %sv_any681 = getelementptr inbounds %struct.av.139, %struct.av.139* %210, i64 0, i32 0
  %211 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any681, align 8, !tbaa !31
  %xav_alloc682 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %211, i64 0, i32 7
  %212 = bitcast %struct.sv*** %xav_alloc682 to i8**
  %213 = load i8*, i8** %212, align 8, !tbaa !37
  %xpv_pv689 = getelementptr %struct.xpvav.138, %struct.xpvav.138* %211, i64 0, i32 0
  store i8* %213, i8** %xpv_pv689, align 8, !tbaa !39
  %214 = load %struct.av.139*, %struct.av.139** %191, align 8, !tbaa !12
  %sv_any696 = getelementptr inbounds %struct.av.139, %struct.av.139* %214, i64 0, i32 0
  %215 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any696, align 8, !tbaa !31
  %xav_fill697 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %215, i64 0, i32 1
  store i64 -1, i64* %xav_fill697, align 8, !tbaa !35
  br label %if.end699

if.end699:                                        ; preds = %if.then604, %if.else649, %if.then572
  %216 = load %struct.cv.160*, %struct.cv.160** %cv71, align 8, !tbaa !12
  %tobool705.not = icmp eq %struct.cv.160* %216, null
  br i1 %tobool705.not, label %if.end716.thread, label %land.lhs.true706

land.lhs.true706:                                 ; preds = %if.end699
  %olddepth711 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 5
  %217 = bitcast %struct.sv*** %olddepth711 to i64*
  %218 = load i64, i64* %217, align 8, !tbaa !12
  %sv_any712 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %216, i64 0, i32 0
  %219 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any712, align 8, !tbaa !14
  %xcv_depth713 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %219, i64 0, i32 14
  store i64 %218, i64* %xcv_depth713, align 8, !tbaa !16
  %tobool714.not = icmp eq i64 %218, 0
  br i1 %tobool714.not, label %if.then718, label %if.end716.thread

if.end716.thread:                                 ; preds = %if.end699, %land.lhs.true706
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  br label %if.end719

if.then718:                                       ; preds = %land.lhs.true706
  %220 = bitcast %struct.cv.160* %216 to %struct.sv*
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %220) #2
  br label %if.end719

if.end719:                                        ; preds = %if.end716.thread, %if.then718
  %221 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags720 = getelementptr inbounds %struct.sv, %struct.sv* %221, i64 0, i32 2
  %222 = load i64, i64* %sv_flags720, align 8, !tbaa !20
  %and721 = and i64 %222, 8388608
  %tobool722.not = icmp eq i64 %and721, 0
  %cond723 = select i1 %tobool722.not, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.38.2207, i64 0, i64 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.37.2208, i64 0, i64 0)
  %call724 = tail call %struct.op.136* (i8*, ...) bitcast (%struct.op* (i8*, ...)* @Perl_die to %struct.op.136* (i8*, ...)*)(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.36.2209, i64 0, i64 0), i8* %cond723) #2
  br label %cleanup

if.else725:                                       ; preds = %land.lhs.true568, %for.body565
  %223 = load %struct.sv**, %struct.sv*** @PL_tmps_stack, align 8, !tbaa !4
  %224 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %inc726 = add nsw i64 %224, 1
  store i64 %inc726, i64* @PL_tmps_ix, align 8, !tbaa !13
  %arrayidx727 = getelementptr inbounds %struct.sv*, %struct.sv** %223, i64 %inc726
  store %struct.sv* %175, %struct.sv** %arrayidx727, align 8, !tbaa !4
  %225 = load %struct.sv*, %struct.sv** %mark.11251, align 8, !tbaa !4
  store %struct.sv* %225, %struct.sv** @PL_Sv, align 8, !tbaa !4
  %tobool728.not = icmp eq %struct.sv* %225, null
  br i1 %tobool728.not, label %land.end733, label %land.rhs729

land.rhs729:                                      ; preds = %if.else725
  %sv_refcnt730 = getelementptr inbounds %struct.sv, %struct.sv* %225, i64 0, i32 1
  %226 = load i64, i64* %sv_refcnt730, align 8, !tbaa !22
  %inc731 = add i64 %226, 1
  store i64 %inc731, i64* %sv_refcnt730, align 8, !tbaa !22
  br label %land.end733

land.end733:                                      ; preds = %land.rhs729, %if.else725
  %mark.1 = getelementptr inbounds %struct.sv*, %struct.sv** %mark.11251, i64 1
  %cmp563.not = icmp ugt %struct.sv** %mark.1, %0
  br i1 %cmp563.not, label %if.end844, label %for.body565, !llvm.loop !43

if.else741:                                       ; preds = %if.else59
  switch i8 %12, label %if.end844 [
    i8 0, label %temporise
    i8 1, label %temporise_array
  ]

temporise:                                        ; preds = %if.else741, %if.then
  %add.ptr745 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %cmp746.not = icmp ugt %struct.sv** %add.ptr745, %0
  br i1 %cmp746.not, label %if.else806, label %if.then748

if.then748:                                       ; preds = %temporise
  %cv753 = bitcast %union.anon.1.173* %blk_u to %struct.cv.160**
  %227 = load %struct.cv.160*, %struct.cv.160** %cv753, align 8, !tbaa !12
  %tobool754.not = icmp eq %struct.cv.160* %227, null
  br i1 %tobool754.not, label %if.else796, label %land.lhs.true755

land.lhs.true755:                                 ; preds = %if.then748
  %sv_any761 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %227, i64 0, i32 0
  %228 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any761, align 8, !tbaa !14
  %xcv_depth762 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %228, i64 0, i32 14
  %229 = load i64, i64* %xcv_depth762, align 8, !tbaa !16
  %cmp763 = icmp sgt i64 %229, 1
  br i1 %cmp763, label %if.then765, label %if.else796

if.then765:                                       ; preds = %land.lhs.true755
  %230 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags766 = getelementptr inbounds %struct.sv, %struct.sv* %230, i64 0, i32 2
  %231 = load i64, i64* %sv_flags766, align 8, !tbaa !20
  %and767 = and i64 %231, 2048
  %tobool768.not = icmp eq i64 %and767, 0
  store %struct.sv* %230, %struct.sv** @PL_Sv, align 8, !tbaa !4
  %sv_refcnt785 = getelementptr inbounds %struct.sv, %struct.sv* %230, i64 0, i32 1
  %232 = load i64, i64* %sv_refcnt785, align 8, !tbaa !22
  %inc786 = add i64 %232, 1
  store i64 %inc786, i64* %sv_refcnt785, align 8, !tbaa !22
  br i1 %tobool768.not, label %land.end788, label %land.end775

land.end775:                                      ; preds = %if.then765
  store %struct.sv* %230, %struct.sv** %add.ptr745, align 8, !tbaa !4
  %233 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %234 = load i64, i64* @PL_tmps_floor, align 8, !tbaa !13
  %cmp777 = icmp sgt i64 %233, %234
  br i1 %cmp777, label %if.then779, label %if.end780

if.then779:                                       ; preds = %land.end775
  tail call void @Perl_free_tmps() #2
  %.pre = load %struct.sv*, %struct.sv** %add.ptr745, align 8, !tbaa !4
  br label %if.end780

if.end780:                                        ; preds = %if.then779, %land.end775
  %235 = phi %struct.sv* [ %.pre, %if.then779 ], [ %230, %land.end775 ]
  %call781 = tail call %struct.sv* @Perl_sv_2mortal(%struct.sv* %235) #2
  br label %if.end844

land.end788:                                      ; preds = %if.then765
  %236 = load i64, i64* @PL_tmps_ix, align 8, !tbaa !13
  %237 = load i64, i64* @PL_tmps_floor, align 8, !tbaa !13
  %cmp790 = icmp sgt i64 %236, %237
  br i1 %cmp790, label %if.then792, label %if.end793

if.then792:                                       ; preds = %land.end788
  tail call void @Perl_free_tmps() #2
  br label %if.end793

if.end793:                                        ; preds = %if.then792, %land.end788
  %call794 = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %230) #2
  store %struct.sv* %call794, %struct.sv** %add.ptr745, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %230) #2
  br label %if.end844

if.else796:                                       ; preds = %land.lhs.true755, %if.then748
  %238 = load %struct.sv*, %struct.sv** %0, align 8, !tbaa !4
  %sv_flags797 = getelementptr inbounds %struct.sv, %struct.sv* %238, i64 0, i32 2
  %239 = load i64, i64* %sv_flags797, align 8, !tbaa !20
  %and798 = and i64 %239, 2048
  %tobool799.not = icmp eq i64 %and798, 0
  br i1 %tobool799.not, label %cond.false801, label %cond.end803

cond.false801:                                    ; preds = %if.else796
  %call802 = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %238) #2
  br label %cond.end803

cond.end803:                                      ; preds = %if.else796, %cond.false801
  %cond804 = phi %struct.sv* [ %call802, %cond.false801 ], [ %238, %if.else796 ]
  store %struct.sv* %cond804, %struct.sv** %add.ptr745, align 8, !tbaa !4
  br label %if.end844

if.else806:                                       ; preds = %temporise
  %240 = load %struct.sv**, %struct.sv*** @PL_stack_max, align 8, !tbaa !4
  %sub.ptr.lhs.cast807 = ptrtoint %struct.sv** %240 to i64
  %sub.ptr.rhs.cast808 = ptrtoint %struct.sv** %add.ptr745 to i64
  %sub.ptr.sub809 = sub i64 %sub.ptr.lhs.cast807, %sub.ptr.rhs.cast808
  %cmp811 = icmp slt i64 %sub.ptr.sub809, 0
  br i1 %cmp811, label %if.then813, label %if.end821

if.then813:                                       ; preds = %if.else806
  %sub.ptr.rhs.cast815 = ptrtoint %struct.sv** %4 to i64
  %sub.ptr.sub816 = sub i64 %sub.ptr.rhs.cast808, %sub.ptr.rhs.cast815
  %call819 = tail call %struct.sv** @Perl_stack_grow(%struct.sv** %0, %struct.sv** nonnull %add.ptr745, i32 0) #2
  %241 = load %struct.sv**, %struct.sv*** @PL_stack_base, align 8, !tbaa !4
  %sext = shl i64 %sub.ptr.sub816, 29
  %idx.ext = ashr i64 %sext, 32
  %add.ptr820 = getelementptr inbounds %struct.sv*, %struct.sv** %241, i64 %idx.ext
  br label %if.end821

if.end821:                                        ; preds = %if.then813, %if.else806
  %mark.2 = phi %struct.sv** [ %add.ptr820, %if.then813 ], [ %add.ptr745, %if.else806 ]
  store %struct.sv* @PL_sv_undef, %struct.sv** %mark.2, align 8, !tbaa !4
  br label %if.end844

temporise_array:                                  ; preds = %if.else741, %if.then22
  %mark.41246 = getelementptr inbounds %struct.sv*, %struct.sv** %add.ptr, i64 1
  %cmp829.not1247 = icmp ugt %struct.sv** %mark.41246, %0
  br i1 %cmp829.not1247, label %if.end844, label %for.body831

for.body831:                                      ; preds = %temporise_array, %for.inc838
  %mark.41248 = phi %struct.sv** [ %mark.4, %for.inc838 ], [ %mark.41246, %temporise_array ]
  %242 = load %struct.sv*, %struct.sv** %mark.41248, align 8, !tbaa !4
  %sv_flags832 = getelementptr inbounds %struct.sv, %struct.sv* %242, i64 0, i32 2
  %243 = load i64, i64* %sv_flags832, align 8, !tbaa !20
  %and833 = and i64 %243, 2048
  %tobool834.not = icmp eq i64 %and833, 0
  br i1 %tobool834.not, label %if.then835, label %for.inc838

if.then835:                                       ; preds = %for.body831
  %call836 = tail call %struct.sv* @Perl_sv_mortalcopy(%struct.sv* nonnull %242) #2
  store %struct.sv* %call836, %struct.sv** %mark.41248, align 8, !tbaa !4
  store i8 0, i8* @PL_tainted, align 1, !tbaa !12
  br label %for.inc838

for.inc838:                                       ; preds = %for.body831, %if.then835
  %mark.4 = getelementptr inbounds %struct.sv*, %struct.sv** %mark.41248, i64 1
  %cmp829.not = icmp ugt %struct.sv** %mark.4, %0
  br i1 %cmp829.not, label %if.end844, label %for.body831, !llvm.loop !44

if.end844:                                        ; preds = %for.inc, %land.end733, %for.inc838, %if.end39, %if.end560, %temporise_array, %if.else741, %if.end821, %if.end780, %if.end793, %cond.end803, %if.end209, %if.else380, %land.rhs384, %if.then
  %sp.0 = phi %struct.sv** [ %0, %if.then ], [ %0, %land.rhs384 ], [ %0, %if.else380 ], [ %0, %if.end209 ], [ %add.ptr745, %if.end780 ], [ %add.ptr745, %if.end793 ], [ %add.ptr745, %cond.end803 ], [ %mark.2, %if.end821 ], [ %0, %if.else741 ], [ %0, %temporise_array ], [ %0, %if.end560 ], [ %0, %if.end39 ], [ %0, %for.inc838 ], [ %0, %land.end733 ], [ %0, %for.inc ]
  store %struct.sv** %sp.0, %struct.sv*** @PL_stack_sp, align 8, !tbaa !4
  tail call void @Perl_pop_scope() #2
  %244 = load %struct.stackinfo.177*, %struct.stackinfo.177** @PL_curstackinfo, align 8, !tbaa !4
  %si_cxix845 = getelementptr inbounds %struct.stackinfo.177, %struct.stackinfo.177* %244, i64 0, i32 2
  %245 = load i64, i64* %si_cxix845, align 8, !tbaa !11
  %dec846 = add nsw i64 %245, -1
  store i64 %dec846, i64* %si_cxix845, align 8, !tbaa !11
  %hasargs851 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 6
  %246 = bitcast %struct.sv** %hasargs851 to i8*
  %247 = load i8, i8* %246, align 8, !tbaa !12
  %tobool852.not = icmp eq i8 %247, 0
  br i1 %tobool852.not, label %if.end971, label %if.then853

if.then853:                                       ; preds = %if.end844
  %248 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any854 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %248, i64 0, i32 0
  %249 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any854, align 8, !tbaa !25
  %xgv_gp855 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %249, i64 0, i32 7
  %250 = load %struct.gp.161*, %struct.gp.161** %xgv_gp855, align 8, !tbaa !27
  %gp_av856 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %250, i64 0, i32 4
  %251 = bitcast %struct.av.139** %gp_av856 to %struct.sv**
  %252 = load %struct.sv*, %struct.sv** %251, align 8, !tbaa !29
  tail call void @Perl_sv_free(%struct.sv* %252) #2
  %savearray862 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 3
  %253 = bitcast %struct.op.136** %savearray862 to %struct.av.139**
  %254 = load %struct.av.139*, %struct.av.139** %253, align 8, !tbaa !12
  %255 = load %struct.gv.163*, %struct.gv.163** @PL_defgv, align 8, !tbaa !4
  %sv_any863 = getelementptr inbounds %struct.gv.163, %struct.gv.163* %255, i64 0, i32 0
  %256 = load %struct.xpvgv.162*, %struct.xpvgv.162** %sv_any863, align 8, !tbaa !25
  %xgv_gp864 = getelementptr inbounds %struct.xpvgv.162, %struct.xpvgv.162* %256, i64 0, i32 7
  %257 = load %struct.gp.161*, %struct.gp.161** %xgv_gp864, align 8, !tbaa !27
  %gp_av865 = getelementptr inbounds %struct.gp.161, %struct.gp.161* %257, i64 0, i32 4
  store %struct.av.139* %254, %struct.av.139** %gp_av865, align 8, !tbaa !29
  %argarray870 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 4
  %258 = bitcast %struct.op.136** %argarray870 to %struct.av.139**
  %259 = load %struct.av.139*, %struct.av.139** %258, align 8, !tbaa !12
  %sv_any871 = getelementptr inbounds %struct.av.139, %struct.av.139* %259, i64 0, i32 0
  %260 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any871, align 8, !tbaa !31
  %xav_flags872 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %260, i64 0, i32 9
  %261 = load i8, i8* %xav_flags872, align 8, !tbaa !33
  %262 = and i8 %261, 1
  %tobool875.not = icmp eq i8 %262, 0
  br i1 %tobool875.not, label %if.else921, label %if.then876

if.then876:                                       ; preds = %if.then853
  %xav_fill884 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %260, i64 0, i32 1
  %263 = load i64, i64* %xav_fill884, align 8, !tbaa !35
  %264 = bitcast %struct.av.139* %259 to %struct.sv*
  tail call void @Perl_sv_free(%struct.sv* %264) #2
  %call890 = tail call %struct.av.139* bitcast (%struct.av* ()* @Perl_newAV to %struct.av.139* ()*)() #2
  store %struct.av.139* %call890, %struct.av.139** %258, align 8, !tbaa !12
  tail call void bitcast (void (%struct.av*, i64)* @Perl_av_extend to void (%struct.av.139*, i64)*)(%struct.av.139* %call890, i64 %263) #2
  %265 = load %struct.av.139*, %struct.av.139** %258, align 8, !tbaa !12
  %sv_any906 = getelementptr inbounds %struct.av.139, %struct.av.139* %265, i64 0, i32 0
  %266 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any906, align 8, !tbaa !31
  %xav_flags907 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %266, i64 0, i32 9
  store i8 2, i8* %xav_flags907, align 8, !tbaa !33
  %267 = bitcast %struct.op.136** %argarray870 to %struct.sv**
  %268 = load %struct.sv*, %struct.sv** %267, align 8, !tbaa !12
  %oldcomppad917 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 7
  %269 = bitcast %struct.sv** %oldcomppad917 to %struct.sv*****
  %270 = load %struct.sv****, %struct.sv***** %269, align 8, !tbaa !12
  %271 = load %struct.sv***, %struct.sv**** %270, align 8, !tbaa !31
  %272 = load %struct.sv**, %struct.sv*** %271, align 8, !tbaa !36
  store %struct.sv* %268, %struct.sv** %272, align 8, !tbaa !4
  br label %if.end971

if.else921:                                       ; preds = %if.then853
  %273 = bitcast %struct.xpvav.138* %260 to %struct.sv***
  %274 = load %struct.sv**, %struct.sv*** %273, align 8, !tbaa !36
  %xav_alloc935 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %260, i64 0, i32 7
  %275 = load %struct.sv**, %struct.sv*** %xav_alloc935, align 8, !tbaa !37
  %sub.ptr.lhs.cast936 = ptrtoint %struct.sv** %274 to i64
  %sub.ptr.rhs.cast937 = ptrtoint %struct.sv** %275 to i64
  %sub.ptr.sub938 = sub i64 %sub.ptr.lhs.cast936, %sub.ptr.rhs.cast937
  %sub.ptr.div939 = ashr exact i64 %sub.ptr.sub938, 3
  %xav_max946 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %260, i64 0, i32 2
  %276 = load i64, i64* %xav_max946, align 8, !tbaa !38
  %add947 = add nsw i64 %sub.ptr.div939, %276
  store i64 %add947, i64* %xav_max946, align 8, !tbaa !38
  %277 = load %struct.av.139*, %struct.av.139** %258, align 8, !tbaa !12
  %sv_any953 = getelementptr inbounds %struct.av.139, %struct.av.139* %277, i64 0, i32 0
  %278 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any953, align 8, !tbaa !31
  %xav_alloc954 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %278, i64 0, i32 7
  %279 = bitcast %struct.sv*** %xav_alloc954 to i8**
  %280 = load i8*, i8** %279, align 8, !tbaa !37
  %xpv_pv961 = getelementptr %struct.xpvav.138, %struct.xpvav.138* %278, i64 0, i32 0
  store i8* %280, i8** %xpv_pv961, align 8, !tbaa !39
  %281 = load %struct.av.139*, %struct.av.139** %258, align 8, !tbaa !12
  %sv_any968 = getelementptr inbounds %struct.av.139, %struct.av.139* %281, i64 0, i32 0
  %282 = load %struct.xpvav.138*, %struct.xpvav.138** %sv_any968, align 8, !tbaa !31
  %xav_fill969 = getelementptr inbounds %struct.xpvav.138, %struct.xpvav.138* %282, i64 0, i32 1
  store i64 -1, i64* %xav_fill969, align 8, !tbaa !35
  br label %if.end971

if.end971:                                        ; preds = %if.then876, %if.else921, %if.end844
  %cv976 = bitcast %union.anon.1.173* %blk_u to %struct.cv.160**
  %283 = load %struct.cv.160*, %struct.cv.160** %cv976, align 8, !tbaa !12
  %tobool977.not = icmp eq %struct.cv.160* %283, null
  br i1 %tobool977.not, label %if.end988.thread, label %land.lhs.true978

land.lhs.true978:                                 ; preds = %if.end971
  %olddepth983 = getelementptr inbounds %struct.context.176, %struct.context.176* %2, i64 %3, i32 1, i32 0, i32 7, i32 0, i32 5
  %284 = bitcast %struct.sv*** %olddepth983 to i64*
  %285 = load i64, i64* %284, align 8, !tbaa !12
  %sv_any984 = getelementptr inbounds %struct.cv.160, %struct.cv.160* %283, i64 0, i32 0
  %286 = load %struct.xpvcv.159*, %struct.xpvcv.159** %sv_any984, align 8, !tbaa !14
  %xcv_depth985 = getelementptr inbounds %struct.xpvcv.159, %struct.xpvcv.159* %286, i64 0, i32 14
  store i64 %285, i64* %xcv_depth985, align 8, !tbaa !16
  %tobool986.not = icmp eq i64 %285, 0
  br i1 %tobool986.not, label %if.then990, label %if.end988.thread

if.end988.thread:                                 ; preds = %if.end971, %land.lhs.true978
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  br label %if.end991

if.then990:                                       ; preds = %land.lhs.true978
  %287 = bitcast %struct.cv.160* %283 to %struct.sv*
  store %struct.pmop.150* %11, %struct.pmop.150** @PL_curpm, align 8, !tbaa !4
  tail call void @Perl_sv_free(%struct.sv* nonnull %287) #2
  br label %if.end991

if.end991:                                        ; preds = %if.end988.thread, %if.then990
  %call992 = tail call %struct.op.136* bitcast (%struct.op* ()* @Perl_pop_return to %struct.op.136* ()*)() #2
  br label %cleanup

cleanup:                                          ; preds = %if.end991, %if.end719, %if.end538, %if.end372, %if.end207
  %retval.0 = phi %struct.op.136* [ %call992, %if.end991 ], [ %call379, %if.end372 ], [ %call542, %if.end538 ], [ %call724, %if.end719 ], [ %call208, %if.end207 ]
  ret %struct.op.136* %retval.0
}

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.sv** @Perl_stack_grow(%struct.sv**, %struct.sv**, i32) local_unnamed_addr #0

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare %struct.op* @Perl_pop_return() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_pop_scope() local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_tmps_grow(i64) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_free_tmps() local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_sv_free(%struct.sv*) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.sv* @Perl_sv_2mortal(%struct.sv* returned) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.sv* @Perl_sv_mortalcopy(%struct.sv*) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.op* @Perl_die(i8*, ...) local_unnamed_addr #0

attributes #0 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 13.0.0 (git@github.com:ppetoumenos/llvm-project.git 70a9fb72f98c9897c164fba3d27e76821498d6e1)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !5, i64 8}
!9 = !{!"stackinfo", !5, i64 0, !5, i64 8, !10, i64 16, !10, i64 24, !10, i64 32, !5, i64 40, !5, i64 48, !10, i64 56}
!10 = !{!"long", !6, i64 0}
!11 = !{!9, !10, i64 16}
!12 = !{!6, !6, i64 0}
!13 = !{!10, !10, i64 0}
!14 = !{!15, !5, i64 0}
!15 = !{!"cv", !5, i64 0, !10, i64 8, !10, i64 16}
!16 = !{!17, !10, i64 112}
!17 = !{!"xpvcv", !5, i64 0, !10, i64 8, !10, i64 16, !10, i64 24, !18, i64 32, !5, i64 40, !5, i64 48, !5, i64 56, !5, i64 64, !5, i64 72, !5, i64 80, !6, i64 88, !5, i64 96, !5, i64 104, !10, i64 112, !5, i64 120, !5, i64 128, !19, i64 136, !10, i64 144}
!18 = !{!"double", !6, i64 0}
!19 = !{!"short", !6, i64 0}
!20 = !{!21, !10, i64 16}
!21 = !{!"sv", !5, i64 0, !10, i64 8, !10, i64 16}
!22 = !{!21, !10, i64 8}
!23 = distinct !{!23, !24}
!24 = !{!"llvm.loop.unroll.disable"}
!25 = !{!26, !5, i64 0}
!26 = !{!"gv", !5, i64 0, !10, i64 8, !10, i64 16}
!27 = !{!28, !5, i64 56}
!28 = !{!"xpvgv", !5, i64 0, !10, i64 8, !10, i64 16, !10, i64 24, !18, i64 32, !5, i64 40, !5, i64 48, !5, i64 56, !5, i64 64, !10, i64 72, !5, i64 80, !6, i64 88}
!29 = !{!30, !5, i64 32}
!30 = !{!"gp", !5, i64 0, !10, i64 8, !5, i64 16, !5, i64 24, !5, i64 32, !5, i64 40, !5, i64 48, !5, i64 56, !10, i64 64, !10, i64 72, !10, i64 80, !5, i64 88}
!31 = !{!32, !5, i64 0}
!32 = !{!"av", !5, i64 0, !10, i64 8, !10, i64 16}
!33 = !{!34, !6, i64 72}
!34 = !{!"xpvav", !5, i64 0, !10, i64 8, !10, i64 16, !10, i64 24, !18, i64 32, !5, i64 40, !5, i64 48, !5, i64 56, !5, i64 64, !6, i64 72}
!35 = !{!34, !10, i64 8}
!36 = !{!34, !5, i64 0}
!37 = !{!34, !5, i64 56}
!38 = !{!34, !10, i64 16}
!39 = !{!40, !5, i64 0}
!40 = !{!"xpv", !5, i64 0, !10, i64 8, !10, i64 16}
!41 = !{!17, !19, i64 136}
!42 = distinct !{!42, !24}
!43 = distinct !{!43, !24}
!44 = distinct !{!44, !24}
