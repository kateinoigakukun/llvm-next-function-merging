; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=store_blessed --multiple-func-merging-only=store_scalar -o %t.mfm.ll %s
; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=store_blessed --multiple-func-merging-only=store_scalar --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.ll -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)

; ModuleID = '../../bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/400.perlbench/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.stcxt = type { i32, i32, %struct.hv*, %struct.av*, %struct.av*, i64, %struct.hv*, %struct.av*, %struct.hv*, i64, i64, i32, i32, i32, i32, %struct.sv*, i32, i32, i32, i32, %struct.extendable, %struct.extendable, %struct.extendable, %struct._PerlIO**, i32, i32, %struct.sv* (...)**, %struct.sv*, %struct.sv* }
%struct.av = type { %struct.xpvav*, i64, i64 }
%struct.xpvav = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.sv**, %struct.sv*, i8 }
%struct.magic = type { %struct.magic*, %struct.mgvtbl*, i16, i8, i8, %struct.sv*, i8*, i64 }
%struct.mgvtbl = type { i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i64 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*, %struct.sv*, i8*, i32)*, i32 (%struct.magic*, %struct.clone_params*)* }
%struct.clone_params = type { %struct.av*, i64, %struct.interpreter* }
%struct.interpreter = type { i8 }
%struct.hv = type { %struct.xpvhv*, i64, i64 }
%struct.xpvhv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, i64, %struct.he*, %struct.pmop*, i8* }
%struct.he = type { %struct.he*, %struct.hek*, %struct.sv* }
%struct.hek = type { i64, i64, [1 x i8] }
%struct.pmop = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8, %struct.op*, %struct.op*, %struct.op*, %struct.op*, %struct.pmop*, %struct.regexp*, i64, i64, i8, %struct.hv* }
%struct.op = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8 }
%struct.regexp = type { i64*, i64*, %struct.regnode*, %struct.reg_substr_data*, i8*, %struct.reg_data*, i8*, i64*, i64, i64, i64, i64, i64, i64, i64, i64, [1 x %struct.regnode] }
%struct.regnode = type { i8, i8, i16 }
%struct.reg_substr_data = type { [3 x %struct.reg_substr_datum] }
%struct.reg_substr_datum = type { i64, i64, %struct.sv*, %struct.sv* }
%struct.reg_data = type { i64, i8*, [1 x i8*] }
%struct.extendable = type { i8*, i64, i8*, i8* }
%struct._PerlIO = type { %struct._PerlIO*, %struct._PerlIO_funcs*, i64 }
%struct._PerlIO_funcs = type { i64, i8*, i64, i64, i64 (%struct._PerlIO**, i8*, %struct.sv*, %struct._PerlIO_funcs*)*, i64 (%struct._PerlIO**)*, %struct._PerlIO** (%struct._PerlIO_funcs*, %struct.PerlIO_list_s*, i64, i8*, i32, i32, i32, %struct._PerlIO**, i32, %struct.sv**)*, i64 (%struct._PerlIO**)*, %struct.sv* (%struct._PerlIO**, %struct.clone_params*, i32)*, i64 (%struct._PerlIO**)*, %struct._PerlIO** (%struct._PerlIO**, %struct._PerlIO**, %struct.clone_params*, i32)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i64, i32)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, void (%struct._PerlIO**)*, void (%struct._PerlIO**)*, i8* (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i8* (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, void (%struct._PerlIO**, i8*, i64)* }
%struct.PerlIO_list_s = type { i64, i64, i64, %struct.PerlIO_pair_t* }
%struct.PerlIO_pair_t = type { %struct._PerlIO_funcs*, %struct.sv* }
%struct.sv = type { i8*, i64, i64 }
%struct.xpviv = type { i8*, i64, i64, i64 }
%struct.xpvnv = type { i8*, i64, i64, i64, double }

@sv_store = external hidden unnamed_addr constant [8 x i32 (%struct.stcxt*, %struct.sv*)*], align 16
@.str.31.4125 = external hidden unnamed_addr constant [16 x i8], align 1
@.str.43.4124 = external hidden unnamed_addr constant [34 x i8], align 1
@PL_sv_no = external global %struct.sv, align 8
@PL_sv_undef = external global %struct.sv, align 8
@PL_sv_yes = external global %struct.sv, align 8

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nounwind optsize readonly willreturn
declare i64 @strlen(i8* nocapture) local_unnamed_addr #2

; Function Attrs: noinline nounwind optsize uwtable
declare i64 @Perl_PerlIO_write(%struct._PerlIO**, i8*, i64) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @PerlIO_putc(%struct._PerlIO**, i32) local_unnamed_addr #3

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare i8* @Perl_sv_reftype(%struct.sv* nocapture readonly, i32) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare i8* @Perl_sv_2pv_flags(%struct.sv*, i64* nocapture, i64) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare double @Perl_sv_2nv(%struct.sv*) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare i64 @Perl_sv_2iv(%struct.sv*) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare i64 @Perl_sv_2uv(%struct.sv*) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare noalias i8* @Perl_safesysrealloc(i8*, i64) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare void @Perl_croak(i8*, ...) local_unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
define hidden fastcc i32 @store_blessed(%struct.stcxt* %cxt, %struct.sv* %sv, i32 %type, %struct.hv* %pkg) unnamed_addr #3 {
entry:
  %len = alloca i64, align 8
  %classnum = alloca i64, align 8
  %y = alloca i32, align 4
  %y578 = alloca i32, align 4
  %0 = bitcast i64* %len to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %0) #5
  %1 = bitcast i64* %classnum to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %1) #5
  %hook1 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 8
  %2 = load %struct.hv*, %struct.hv** %hook1, align 8, !tbaa !4
  %call = tail call fastcc %struct.sv* @pkg_can(%struct.hv* %2, %struct.hv* %pkg, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.31.4125, i64 0, i64 0)) #6
  %tobool.not = icmp eq %struct.sv* %call, null
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call2 = tail call fastcc i32 @store_hook(%struct.stcxt* nonnull %cxt, %struct.sv* %sv, i32 %type, %struct.hv* %pkg, %struct.sv* nonnull %call) #6
  br label %cleanup828

if.end:                                           ; preds = %entry
  %sv_any = getelementptr inbounds %struct.hv, %struct.hv* %pkg, i64 0, i32 0
  %3 = load %struct.xpvhv*, %struct.xpvhv** %sv_any, align 8, !tbaa !12
  %xhv_name = getelementptr inbounds %struct.xpvhv, %struct.xpvhv* %3, i64 0, i32 10
  %4 = load i8*, i8** %xhv_name, align 8, !tbaa !14
  %call3 = tail call i64 @strlen(i8* noundef nonnull dereferenceable(1) %4) #6
  store i64 %call3, i64* %len, align 8, !tbaa !17
  %conv = trunc i64 %call3 to i32
  %call4 = call fastcc i32 @known_class(%struct.stcxt* nonnull %cxt, i8* %4, i32 %conv, i64* nonnull %classnum) #6
  %tobool5.not = icmp eq i32 %call4, 0
  %fio369 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %5 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool370.not = icmp eq %struct._PerlIO** %5, null
  br i1 %tobool5.not, label %if.else368, label %if.then6

if.then6:                                         ; preds = %if.end
  br i1 %tobool370.not, label %if.then8, label %if.else44

if.then8:                                         ; preds = %if.then6
  %aptr = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %6 = load i8*, i8** %aptr, align 8, !tbaa !19
  %aend = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %7 = load i8*, i8** %aend, align 8, !tbaa !20
  %cmp = icmp ult i8* %6, %7
  br i1 %cmp, label %if.end51.sink.split, label %if.else

if.else:                                          ; preds = %if.then8
  %asiz = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %8 = load i64, i64* %asiz, align 8, !tbaa !21
  %arena = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %9 = load i8*, i8** %arena, align 8, !tbaa !22
  %sub.ptr.lhs.cast = ptrtoint i8* %6 to i64
  %sub.ptr.rhs.cast = ptrtoint i8* %9 to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %10 = shl i64 %8, 32
  %conv16 = add i64 %10, 35184372088832
  %sext1145 = ashr exact i64 %conv16, 32
  %conv23 = and i64 %sext1145, -8192
  %call24 = tail call i8* @Perl_safesysrealloc(i8* %9, i64 %conv23) #7
  store i8* %call24, i8** %arena, align 8, !tbaa !22
  store i64 %conv23, i64* %asiz, align 8, !tbaa !21
  %sext1146 = shl i64 %sub.ptr.sub, 32
  %idx.ext = ashr exact i64 %sext1146, 32
  %add.ptr = getelementptr inbounds i8, i8* %call24, i64 %idx.ext
  %add.ptr37 = getelementptr inbounds i8, i8* %call24, i64 %conv23
  store i8* %add.ptr37, i8** %aend, align 8, !tbaa !20
  br label %if.end51.sink.split

if.else44:                                        ; preds = %if.then6
  %call46 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %5, i32 18) #7
  %cmp47 = icmp eq i32 %call46, -1
  br i1 %cmp47, label %cleanup828, label %if.end51

if.end51.sink.split:                              ; preds = %if.else, %if.then8
  %.sink1163 = phi i8* [ %add.ptr, %if.else ], [ %6, %if.then8 ]
  %incdec.ptr = getelementptr inbounds i8, i8* %.sink1163, i64 1
  store i8* %incdec.ptr, i8** %aptr, align 8, !tbaa !19
  store i8 18, i8* %.sink1163, align 1, !tbaa !23
  br label %if.end51

if.end51:                                         ; preds = %if.end51.sink.split, %if.else44
  %11 = load i64, i64* %classnum, align 8, !tbaa !17
  %cmp52 = icmp slt i64 %11, 128
  br i1 %cmp52, label %if.then54, label %if.else122

if.then54:                                        ; preds = %if.end51
  %conv55 = trunc i64 %11 to i8
  %12 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool57.not = icmp eq %struct._PerlIO** %12, null
  br i1 %tobool57.not, label %if.then58, label %if.else113

if.then58:                                        ; preds = %if.then54
  %aptr60 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %13 = load i8*, i8** %aptr60, align 8, !tbaa !19
  %aend62 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %14 = load i8*, i8** %aend62, align 8, !tbaa !20
  %cmp63 = icmp ult i8* %13, %14
  br i1 %cmp63, label %if.then65, label %if.else69

if.then65:                                        ; preds = %if.then58
  %incdec.ptr68 = getelementptr inbounds i8, i8* %13, i64 1
  store i8* %incdec.ptr68, i8** %aptr60, align 8, !tbaa !19
  store i8 %conv55, i8* %13, align 1, !tbaa !23
  br label %if.end826

if.else69:                                        ; preds = %if.then58
  %asiz72 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %15 = load i64, i64* %asiz72, align 8, !tbaa !21
  %arena81 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %16 = load i8*, i8** %arena81, align 8, !tbaa !22
  %sub.ptr.lhs.cast82 = ptrtoint i8* %13 to i64
  %sub.ptr.rhs.cast83 = ptrtoint i8* %16 to i64
  %sub.ptr.sub84 = sub i64 %sub.ptr.lhs.cast82, %sub.ptr.rhs.cast83
  %17 = shl i64 %15, 32
  %conv76 = add i64 %17, 35184372088832
  %sext1154 = ashr exact i64 %conv76, 32
  %conv88 = and i64 %sext1154, -8192
  %call90 = tail call i8* @Perl_safesysrealloc(i8* %16, i64 %conv88) #7
  store i8* %call90, i8** %arena81, align 8, !tbaa !22
  store i64 %conv88, i64* %asiz72, align 8, !tbaa !21
  %sext1155 = shl i64 %sub.ptr.sub84, 32
  %idx.ext98 = ashr exact i64 %sext1155, 32
  %add.ptr99 = getelementptr inbounds i8, i8* %call90, i64 %idx.ext98
  %add.ptr106 = getelementptr inbounds i8, i8* %call90, i64 %conv88
  store i8* %add.ptr106, i8** %aend62, align 8, !tbaa !20
  %incdec.ptr111 = getelementptr inbounds i8, i8* %add.ptr99, i64 1
  store i8* %incdec.ptr111, i8** %aptr60, align 8, !tbaa !19
  store i8 %conv55, i8* %add.ptr99, align 1, !tbaa !23
  br label %if.end826

if.else113:                                       ; preds = %if.then54
  %18 = trunc i64 %11 to i32
  %conv115 = and i32 %18, 255
  %call116 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %12, i32 %conv115) #7
  %cmp117 = icmp eq i32 %call116, -1
  br i1 %cmp117, label %cleanup828, label %if.end826

if.else122:                                       ; preds = %if.end51
  %19 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool124.not = icmp eq %struct._PerlIO** %19, null
  br i1 %tobool124.not, label %if.then125, label %if.else180

if.then125:                                       ; preds = %if.else122
  %aptr127 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %20 = load i8*, i8** %aptr127, align 8, !tbaa !19
  %aend129 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %21 = load i8*, i8** %aend129, align 8, !tbaa !20
  %cmp130 = icmp ult i8* %20, %21
  br i1 %cmp130, label %if.end188.sink.split, label %if.else136

if.else136:                                       ; preds = %if.then125
  %asiz139 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %22 = load i64, i64* %asiz139, align 8, !tbaa !21
  %arena148 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %23 = load i8*, i8** %arena148, align 8, !tbaa !22
  %sub.ptr.lhs.cast149 = ptrtoint i8* %20 to i64
  %sub.ptr.rhs.cast150 = ptrtoint i8* %23 to i64
  %sub.ptr.sub151 = sub i64 %sub.ptr.lhs.cast149, %sub.ptr.rhs.cast150
  %24 = shl i64 %22, 32
  %conv143 = add i64 %24, 35184372088832
  %sext1147 = ashr exact i64 %conv143, 32
  %conv155 = and i64 %sext1147, -8192
  %call157 = tail call i8* @Perl_safesysrealloc(i8* %23, i64 %conv155) #7
  store i8* %call157, i8** %arena148, align 8, !tbaa !22
  store i64 %conv155, i64* %asiz139, align 8, !tbaa !21
  %sext1148 = shl i64 %sub.ptr.sub151, 32
  %idx.ext165 = ashr exact i64 %sext1148, 32
  %add.ptr166 = getelementptr inbounds i8, i8* %call157, i64 %idx.ext165
  %add.ptr173 = getelementptr inbounds i8, i8* %call157, i64 %conv155
  store i8* %add.ptr173, i8** %aend129, align 8, !tbaa !20
  br label %if.end188.sink.split

if.else180:                                       ; preds = %if.else122
  %call183 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %19, i32 128) #7
  %cmp184 = icmp eq i32 %call183, -1
  br i1 %cmp184, label %cleanup828, label %if.end188

if.end188.sink.split:                             ; preds = %if.else136, %if.then125
  %.sink1165 = phi i8* [ %add.ptr166, %if.else136 ], [ %20, %if.then125 ]
  %incdec.ptr135 = getelementptr inbounds i8, i8* %.sink1165, i64 1
  store i8* %incdec.ptr135, i8** %aptr127, align 8, !tbaa !19
  store i8 -128, i8* %.sink1165, align 1, !tbaa !23
  br label %if.end188

if.end188:                                        ; preds = %if.end188.sink.split, %if.else180
  %netorder = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 11
  %25 = load i32, i32* %netorder, align 8, !tbaa !24
  %tobool189.not = icmp eq i32 %25, 0
  br i1 %tobool189.not, label %if.else284, label %if.then190

if.then190:                                       ; preds = %if.end188
  %26 = bitcast i32* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %26) #5
  %27 = load i64, i64* %classnum, align 8, !tbaa !17
  %conv191 = trunc i64 %27 to i32
  %28 = tail call i32 asm "bswap $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %conv191) #8, !srcloc !25
  store i32 %28, i32* %y, align 4, !tbaa !26
  %29 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool205.not = icmp eq %struct._PerlIO** %29, null
  br i1 %tobool205.not, label %if.then206, label %if.else273

if.then206:                                       ; preds = %if.then190
  %aptr208 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %30 = load i8*, i8** %aptr208, align 8, !tbaa !19
  %add.ptr209 = getelementptr inbounds i8, i8* %30, i64 4
  %aend211 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %31 = load i8*, i8** %aend211, align 8, !tbaa !20
  %cmp212 = icmp ugt i8* %add.ptr209, %31
  br i1 %cmp212, label %if.then214, label %if.end254

if.then214:                                       ; preds = %if.then206
  %asiz217 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %32 = load i64, i64* %asiz217, align 8, !tbaa !21
  %arena226 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %33 = load i8*, i8** %arena226, align 8, !tbaa !22
  %sub.ptr.lhs.cast227 = ptrtoint i8* %30 to i64
  %sub.ptr.rhs.cast228 = ptrtoint i8* %33 to i64
  %sub.ptr.sub229 = sub i64 %sub.ptr.lhs.cast227, %sub.ptr.rhs.cast228
  %34 = shl i64 %32, 32
  %conv221 = add i64 %34, 35197256990720
  %sext1151 = ashr exact i64 %conv221, 32
  %conv233 = and i64 %sext1151, -8192
  %call235 = tail call i8* @Perl_safesysrealloc(i8* %33, i64 %conv233) #7
  store i8* %call235, i8** %arena226, align 8, !tbaa !22
  store i64 %conv233, i64* %asiz217, align 8, !tbaa !21
  %sext1152 = shl i64 %sub.ptr.sub229, 32
  %idx.ext243 = ashr exact i64 %sext1152, 32
  %add.ptr244 = getelementptr inbounds i8, i8* %call235, i64 %idx.ext243
  store i8* %add.ptr244, i8** %aptr208, align 8, !tbaa !19
  %add.ptr251 = getelementptr inbounds i8, i8* %call235, i64 %conv233
  store i8* %add.ptr251, i8** %aend211, align 8, !tbaa !20
  br label %if.end254

if.end254:                                        ; preds = %if.then214, %if.then206
  %35 = phi i8* [ %add.ptr244, %if.then214 ], [ %30, %if.then206 ]
  %36 = ptrtoint i8* %35 to i64
  %and259 = and i64 %36, -4
  %cmp260 = icmp eq i64 %and259, %36
  %37 = bitcast i8* %35 to i32*
  br i1 %cmp260, label %if.then262, label %if.else265

if.then262:                                       ; preds = %if.end254
  store i32 %28, i32* %37, align 4, !tbaa !26
  br label %if.end268

if.else265:                                       ; preds = %if.end254
  store i32 %28, i32* %37, align 1
  %.pre = load i8*, i8** %aptr208, align 8, !tbaa !19
  br label %if.end268

if.end268:                                        ; preds = %if.else265, %if.then262
  %38 = phi i8* [ %.pre, %if.else265 ], [ %35, %if.then262 ]
  %add.ptr272 = getelementptr inbounds i8, i8* %38, i64 4
  store i8* %add.ptr272, i8** %aptr208, align 8, !tbaa !19
  br label %if.end280

if.else273:                                       ; preds = %if.then190
  %call275 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %29, i8* nonnull %26, i64 4) #7
  %cmp276.not = icmp eq i64 %call275, 4
  br i1 %cmp276.not, label %if.end280, label %cleanup281

if.end280:                                        ; preds = %if.else273, %if.end268
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %26) #5
  br label %if.end826

cleanup281:                                       ; preds = %if.else273
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %26) #5
  br label %cleanup828

if.else284:                                       ; preds = %if.end188
  %39 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool286.not = icmp eq %struct._PerlIO** %39, null
  br i1 %tobool286.not, label %if.then287, label %if.else355

if.then287:                                       ; preds = %if.else284
  %aptr289 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %40 = load i8*, i8** %aptr289, align 8, !tbaa !19
  %add.ptr290 = getelementptr inbounds i8, i8* %40, i64 4
  %aend292 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %41 = load i8*, i8** %aend292, align 8, !tbaa !20
  %cmp293 = icmp ugt i8* %add.ptr290, %41
  br i1 %cmp293, label %if.then295, label %if.end335

if.then295:                                       ; preds = %if.then287
  %asiz298 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %42 = load i64, i64* %asiz298, align 8, !tbaa !21
  %arena307 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %43 = load i8*, i8** %arena307, align 8, !tbaa !22
  %sub.ptr.lhs.cast308 = ptrtoint i8* %40 to i64
  %sub.ptr.rhs.cast309 = ptrtoint i8* %43 to i64
  %sub.ptr.sub310 = sub i64 %sub.ptr.lhs.cast308, %sub.ptr.rhs.cast309
  %44 = shl i64 %42, 32
  %conv302 = add i64 %44, 35197256990720
  %sext1149 = ashr exact i64 %conv302, 32
  %conv314 = and i64 %sext1149, -8192
  %call316 = tail call i8* @Perl_safesysrealloc(i8* %43, i64 %conv314) #7
  store i8* %call316, i8** %arena307, align 8, !tbaa !22
  store i64 %conv314, i64* %asiz298, align 8, !tbaa !21
  %sext1150 = shl i64 %sub.ptr.sub310, 32
  %idx.ext324 = ashr exact i64 %sext1150, 32
  %add.ptr325 = getelementptr inbounds i8, i8* %call316, i64 %idx.ext324
  store i8* %add.ptr325, i8** %aptr289, align 8, !tbaa !19
  %add.ptr332 = getelementptr inbounds i8, i8* %call316, i64 %conv314
  store i8* %add.ptr332, i8** %aend292, align 8, !tbaa !20
  br label %if.end335

if.end335:                                        ; preds = %if.then295, %if.then287
  %45 = phi i8* [ %add.ptr325, %if.then295 ], [ %40, %if.then287 ]
  %46 = ptrtoint i8* %45 to i64
  %and340 = and i64 %46, -4
  %cmp341 = icmp eq i64 %and340, %46
  br i1 %cmp341, label %if.then343, label %if.else347

if.then343:                                       ; preds = %if.end335
  %47 = load i64, i64* %classnum, align 8, !tbaa !17
  %conv344 = trunc i64 %47 to i32
  %48 = bitcast i8* %45 to i32*
  store i32 %conv344, i32* %48, align 4, !tbaa !26
  br label %if.end350

if.else347:                                       ; preds = %if.end335
  %49 = bitcast i64* %classnum to i32*
  %50 = bitcast i8* %45 to i32*
  %51 = load i32, i32* %49, align 8
  store i32 %51, i32* %50, align 1
  %.pre1159 = load i8*, i8** %aptr289, align 8, !tbaa !19
  br label %if.end350

if.end350:                                        ; preds = %if.else347, %if.then343
  %52 = phi i8* [ %.pre1159, %if.else347 ], [ %45, %if.then343 ]
  %add.ptr354 = getelementptr inbounds i8, i8* %52, i64 4
  store i8* %add.ptr354, i8** %aptr289, align 8, !tbaa !19
  br label %if.end826

if.else355:                                       ; preds = %if.else284
  %call357 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %39, i8* nonnull %1, i64 8) #7
  %cmp358.not = icmp eq i64 %call357, 8
  br i1 %cmp358.not, label %if.end826, label %cleanup828

if.else368:                                       ; preds = %if.end
  br i1 %tobool370.not, label %if.then371, label %if.else426

if.then371:                                       ; preds = %if.else368
  %aptr373 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %53 = load i8*, i8** %aptr373, align 8, !tbaa !19
  %aend375 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %54 = load i8*, i8** %aend375, align 8, !tbaa !20
  %cmp376 = icmp ult i8* %53, %54
  br i1 %cmp376, label %if.end433.sink.split, label %if.else382

if.else382:                                       ; preds = %if.then371
  %asiz385 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %55 = load i64, i64* %asiz385, align 8, !tbaa !21
  %arena394 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %56 = load i8*, i8** %arena394, align 8, !tbaa !22
  %sub.ptr.lhs.cast395 = ptrtoint i8* %53 to i64
  %sub.ptr.rhs.cast396 = ptrtoint i8* %56 to i64
  %sub.ptr.sub397 = sub i64 %sub.ptr.lhs.cast395, %sub.ptr.rhs.cast396
  %57 = shl i64 %55, 32
  %conv389 = add i64 %57, 35184372088832
  %sext = ashr exact i64 %conv389, 32
  %conv401 = and i64 %sext, -8192
  %call403 = tail call i8* @Perl_safesysrealloc(i8* %56, i64 %conv401) #7
  store i8* %call403, i8** %arena394, align 8, !tbaa !22
  store i64 %conv401, i64* %asiz385, align 8, !tbaa !21
  %sext1134 = shl i64 %sub.ptr.sub397, 32
  %idx.ext411 = ashr exact i64 %sext1134, 32
  %add.ptr412 = getelementptr inbounds i8, i8* %call403, i64 %idx.ext411
  %add.ptr419 = getelementptr inbounds i8, i8* %call403, i64 %conv401
  store i8* %add.ptr419, i8** %aend375, align 8, !tbaa !20
  br label %if.end433.sink.split

if.else426:                                       ; preds = %if.else368
  %call428 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %5, i32 17) #7
  %cmp429 = icmp eq i32 %call428, -1
  br i1 %cmp429, label %cleanup828, label %if.end433

if.end433.sink.split:                             ; preds = %if.else382, %if.then371
  %.sink1167 = phi i8* [ %add.ptr412, %if.else382 ], [ %53, %if.then371 ]
  %incdec.ptr381 = getelementptr inbounds i8, i8* %.sink1167, i64 1
  store i8* %incdec.ptr381, i8** %aptr373, align 8, !tbaa !19
  store i8 17, i8* %.sink1167, align 1, !tbaa !23
  br label %if.end433

if.end433:                                        ; preds = %if.end433.sink.split, %if.else426
  %58 = load i64, i64* %len, align 8, !tbaa !17
  %cmp434 = icmp slt i64 %58, 128
  br i1 %cmp434, label %if.then436, label %if.else507

if.then436:                                       ; preds = %if.end433
  %conv437 = trunc i64 %58 to i8
  %59 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool439.not = icmp eq %struct._PerlIO** %59, null
  br i1 %tobool439.not, label %if.then440, label %if.else495

if.then440:                                       ; preds = %if.then436
  %aptr442 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %60 = load i8*, i8** %aptr442, align 8, !tbaa !19
  %aend444 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %61 = load i8*, i8** %aend444, align 8, !tbaa !20
  %cmp445 = icmp ult i8* %60, %61
  br i1 %cmp445, label %if.then447, label %if.else451

if.then447:                                       ; preds = %if.then440
  %incdec.ptr450 = getelementptr inbounds i8, i8* %60, i64 1
  store i8* %incdec.ptr450, i8** %aptr442, align 8, !tbaa !19
  store i8 %conv437, i8* %60, align 1, !tbaa !23
  br label %if.end760

if.else451:                                       ; preds = %if.then440
  %asiz454 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %62 = load i64, i64* %asiz454, align 8, !tbaa !21
  %arena463 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %63 = load i8*, i8** %arena463, align 8, !tbaa !22
  %sub.ptr.lhs.cast464 = ptrtoint i8* %60 to i64
  %sub.ptr.rhs.cast465 = ptrtoint i8* %63 to i64
  %sub.ptr.sub466 = sub i64 %sub.ptr.lhs.cast464, %sub.ptr.rhs.cast465
  %64 = shl i64 %62, 32
  %conv458 = add i64 %64, 35184372088832
  %sext1143 = ashr exact i64 %conv458, 32
  %conv470 = and i64 %sext1143, -8192
  %call472 = tail call i8* @Perl_safesysrealloc(i8* %63, i64 %conv470) #7
  store i8* %call472, i8** %arena463, align 8, !tbaa !22
  store i64 %conv470, i64* %asiz454, align 8, !tbaa !21
  %sext1144 = shl i64 %sub.ptr.sub466, 32
  %idx.ext480 = ashr exact i64 %sext1144, 32
  %add.ptr481 = getelementptr inbounds i8, i8* %call472, i64 %idx.ext480
  %add.ptr488 = getelementptr inbounds i8, i8* %call472, i64 %conv470
  store i8* %add.ptr488, i8** %aend444, align 8, !tbaa !20
  %incdec.ptr493 = getelementptr inbounds i8, i8* %add.ptr481, i64 1
  store i8* %incdec.ptr493, i8** %aptr442, align 8, !tbaa !19
  store i8 %conv437, i8* %add.ptr481, align 1, !tbaa !23
  br label %if.end760

if.else495:                                       ; preds = %if.then436
  %65 = trunc i64 %58 to i32
  %conv497 = and i32 %65, 255
  %call498 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %59, i32 %conv497) #7
  %cmp499 = icmp eq i32 %call498, -1
  br i1 %cmp499, label %cleanup828, label %if.end760

if.else507:                                       ; preds = %if.end433
  %66 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool510.not = icmp eq %struct._PerlIO** %66, null
  br i1 %tobool510.not, label %if.then511, label %if.else566

if.then511:                                       ; preds = %if.else507
  %aptr513 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %67 = load i8*, i8** %aptr513, align 8, !tbaa !19
  %aend515 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %68 = load i8*, i8** %aend515, align 8, !tbaa !20
  %cmp516 = icmp ult i8* %67, %68
  br i1 %cmp516, label %if.end574.sink.split, label %if.else522

if.else522:                                       ; preds = %if.then511
  %asiz525 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %69 = load i64, i64* %asiz525, align 8, !tbaa !21
  %arena534 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %70 = load i8*, i8** %arena534, align 8, !tbaa !22
  %sub.ptr.lhs.cast535 = ptrtoint i8* %67 to i64
  %sub.ptr.rhs.cast536 = ptrtoint i8* %70 to i64
  %sub.ptr.sub537 = sub i64 %sub.ptr.lhs.cast535, %sub.ptr.rhs.cast536
  %71 = shl i64 %69, 32
  %conv529 = add i64 %71, 35184372088832
  %sext1135 = ashr exact i64 %conv529, 32
  %conv541 = and i64 %sext1135, -8192
  %call543 = tail call i8* @Perl_safesysrealloc(i8* %70, i64 %conv541) #7
  store i8* %call543, i8** %arena534, align 8, !tbaa !22
  store i64 %conv541, i64* %asiz525, align 8, !tbaa !21
  %sext1136 = shl i64 %sub.ptr.sub537, 32
  %idx.ext551 = ashr exact i64 %sext1136, 32
  %add.ptr552 = getelementptr inbounds i8, i8* %call543, i64 %idx.ext551
  %add.ptr559 = getelementptr inbounds i8, i8* %call543, i64 %conv541
  store i8* %add.ptr559, i8** %aend515, align 8, !tbaa !20
  br label %if.end574.sink.split

if.else566:                                       ; preds = %if.else507
  %call569 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %66, i32 128) #7
  %cmp570 = icmp eq i32 %call569, -1
  br i1 %cmp570, label %cleanup828, label %if.end574

if.end574.sink.split:                             ; preds = %if.else522, %if.then511
  %.sink1169 = phi i8* [ %add.ptr552, %if.else522 ], [ %67, %if.then511 ]
  %incdec.ptr521 = getelementptr inbounds i8, i8* %.sink1169, i64 1
  store i8* %incdec.ptr521, i8** %aptr513, align 8, !tbaa !19
  store i8 -128, i8* %.sink1169, align 1, !tbaa !23
  br label %if.end574

if.end574:                                        ; preds = %if.end574.sink.split, %if.else566
  %netorder575 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 11
  %72 = load i32, i32* %netorder575, align 8, !tbaa !24
  %tobool576.not = icmp eq i32 %72, 0
  br i1 %tobool576.not, label %if.else677, label %if.then577

if.then577:                                       ; preds = %if.end574
  %73 = bitcast i32* %y578 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %73) #5
  %74 = load i64, i64* %len, align 8, !tbaa !17
  %conv581 = trunc i64 %74 to i32
  %75 = tail call i32 asm "bswap $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %conv581) #8, !srcloc !27
  store i32 %75, i32* %y578, align 4, !tbaa !26
  %76 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool598.not = icmp eq %struct._PerlIO** %76, null
  br i1 %tobool598.not, label %if.then599, label %if.else666

if.then599:                                       ; preds = %if.then577
  %aptr601 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %77 = load i8*, i8** %aptr601, align 8, !tbaa !19
  %add.ptr602 = getelementptr inbounds i8, i8* %77, i64 4
  %aend604 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %78 = load i8*, i8** %aend604, align 8, !tbaa !20
  %cmp605 = icmp ugt i8* %add.ptr602, %78
  br i1 %cmp605, label %if.then607, label %if.end647

if.then607:                                       ; preds = %if.then599
  %asiz610 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %79 = load i64, i64* %asiz610, align 8, !tbaa !21
  %arena619 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %80 = load i8*, i8** %arena619, align 8, !tbaa !22
  %sub.ptr.lhs.cast620 = ptrtoint i8* %77 to i64
  %sub.ptr.rhs.cast621 = ptrtoint i8* %80 to i64
  %sub.ptr.sub622 = sub i64 %sub.ptr.lhs.cast620, %sub.ptr.rhs.cast621
  %81 = shl i64 %79, 32
  %conv614 = add i64 %81, 35197256990720
  %sext1141 = ashr exact i64 %conv614, 32
  %conv626 = and i64 %sext1141, -8192
  %call628 = tail call i8* @Perl_safesysrealloc(i8* %80, i64 %conv626) #7
  store i8* %call628, i8** %arena619, align 8, !tbaa !22
  store i64 %conv626, i64* %asiz610, align 8, !tbaa !21
  %sext1142 = shl i64 %sub.ptr.sub622, 32
  %idx.ext636 = ashr exact i64 %sext1142, 32
  %add.ptr637 = getelementptr inbounds i8, i8* %call628, i64 %idx.ext636
  store i8* %add.ptr637, i8** %aptr601, align 8, !tbaa !19
  %add.ptr644 = getelementptr inbounds i8, i8* %call628, i64 %conv626
  store i8* %add.ptr644, i8** %aend604, align 8, !tbaa !20
  br label %if.end647

if.end647:                                        ; preds = %if.then607, %if.then599
  %82 = phi i8* [ %add.ptr637, %if.then607 ], [ %77, %if.then599 ]
  %83 = ptrtoint i8* %82 to i64
  %and652 = and i64 %83, -4
  %cmp653 = icmp eq i64 %and652, %83
  %84 = bitcast i8* %82 to i32*
  br i1 %cmp653, label %if.then655, label %if.else658

if.then655:                                       ; preds = %if.end647
  store i32 %75, i32* %84, align 4, !tbaa !26
  br label %if.end661

if.else658:                                       ; preds = %if.end647
  store i32 %75, i32* %84, align 1
  %.pre1160 = load i8*, i8** %aptr601, align 8, !tbaa !19
  br label %if.end661

if.end661:                                        ; preds = %if.else658, %if.then655
  %85 = phi i8* [ %.pre1160, %if.else658 ], [ %82, %if.then655 ]
  %add.ptr665 = getelementptr inbounds i8, i8* %85, i64 4
  store i8* %add.ptr665, i8** %aptr601, align 8, !tbaa !19
  br label %if.end673

if.else666:                                       ; preds = %if.then577
  %call668 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %76, i8* nonnull %73, i64 4) #7
  %cmp669.not = icmp eq i64 %call668, 4
  br i1 %cmp669.not, label %if.end673, label %cleanup674

if.end673:                                        ; preds = %if.else666, %if.end661
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %73) #5
  br label %if.end760

cleanup674:                                       ; preds = %if.else666
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %73) #5
  br label %cleanup828

if.else677:                                       ; preds = %if.end574
  %86 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool679.not = icmp eq %struct._PerlIO** %86, null
  br i1 %tobool679.not, label %if.then680, label %if.else748

if.then680:                                       ; preds = %if.else677
  %aptr682 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %87 = load i8*, i8** %aptr682, align 8, !tbaa !19
  %add.ptr683 = getelementptr inbounds i8, i8* %87, i64 4
  %aend685 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %88 = load i8*, i8** %aend685, align 8, !tbaa !20
  %cmp686 = icmp ugt i8* %add.ptr683, %88
  br i1 %cmp686, label %if.then688, label %if.end728

if.then688:                                       ; preds = %if.then680
  %asiz691 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %89 = load i64, i64* %asiz691, align 8, !tbaa !21
  %arena700 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %90 = load i8*, i8** %arena700, align 8, !tbaa !22
  %sub.ptr.lhs.cast701 = ptrtoint i8* %87 to i64
  %sub.ptr.rhs.cast702 = ptrtoint i8* %90 to i64
  %sub.ptr.sub703 = sub i64 %sub.ptr.lhs.cast701, %sub.ptr.rhs.cast702
  %91 = shl i64 %89, 32
  %conv695 = add i64 %91, 35197256990720
  %sext1139 = ashr exact i64 %conv695, 32
  %conv707 = and i64 %sext1139, -8192
  %call709 = tail call i8* @Perl_safesysrealloc(i8* %90, i64 %conv707) #7
  store i8* %call709, i8** %arena700, align 8, !tbaa !22
  store i64 %conv707, i64* %asiz691, align 8, !tbaa !21
  %sext1140 = shl i64 %sub.ptr.sub703, 32
  %idx.ext717 = ashr exact i64 %sext1140, 32
  %add.ptr718 = getelementptr inbounds i8, i8* %call709, i64 %idx.ext717
  store i8* %add.ptr718, i8** %aptr682, align 8, !tbaa !19
  %add.ptr725 = getelementptr inbounds i8, i8* %call709, i64 %conv707
  store i8* %add.ptr725, i8** %aend685, align 8, !tbaa !20
  br label %if.end728

if.end728:                                        ; preds = %if.then688, %if.then680
  %92 = phi i8* [ %add.ptr718, %if.then688 ], [ %87, %if.then680 ]
  %93 = ptrtoint i8* %92 to i64
  %and733 = and i64 %93, -4
  %cmp734 = icmp eq i64 %and733, %93
  br i1 %cmp734, label %if.then736, label %if.else740

if.then736:                                       ; preds = %if.end728
  %94 = load i64, i64* %len, align 8, !tbaa !17
  %conv737 = trunc i64 %94 to i32
  %95 = bitcast i8* %92 to i32*
  store i32 %conv737, i32* %95, align 4, !tbaa !26
  br label %if.end743

if.else740:                                       ; preds = %if.end728
  %96 = bitcast i64* %len to i32*
  %97 = bitcast i8* %92 to i32*
  %98 = load i32, i32* %96, align 8
  store i32 %98, i32* %97, align 1
  %.pre1161 = load i8*, i8** %aptr682, align 8, !tbaa !19
  br label %if.end743

if.end743:                                        ; preds = %if.else740, %if.then736
  %99 = phi i8* [ %.pre1161, %if.else740 ], [ %92, %if.then736 ]
  %add.ptr747 = getelementptr inbounds i8, i8* %99, i64 4
  store i8* %add.ptr747, i8** %aptr682, align 8, !tbaa !19
  br label %if.end760

if.else748:                                       ; preds = %if.else677
  %call750 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %86, i8* nonnull %0, i64 8) #7
  %cmp751.not = icmp eq i64 %call750, 8
  br i1 %cmp751.not, label %if.end760, label %cleanup828

if.end760:                                        ; preds = %if.else748, %if.end743, %if.end673, %if.else495, %if.else451, %if.then447
  %100 = load %struct._PerlIO**, %struct._PerlIO*** %fio369, align 8, !tbaa !18
  %tobool762.not = icmp eq %struct._PerlIO** %100, null
  br i1 %tobool762.not, label %if.then763, label %if.else818

if.then763:                                       ; preds = %if.end760
  %aptr765 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %101 = load i8*, i8** %aptr765, align 8, !tbaa !19
  %102 = load i64, i64* %len, align 8, !tbaa !17
  %add.ptr766 = getelementptr inbounds i8, i8* %101, i64 %102
  %aend768 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %103 = load i8*, i8** %aend768, align 8, !tbaa !20
  %cmp769 = icmp ugt i8* %add.ptr766, %103
  br i1 %cmp769, label %if.then771, label %if.end811

if.then771:                                       ; preds = %if.then763
  %asiz774 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %104 = load i64, i64* %asiz774, align 8, !tbaa !21
  %add775 = add i64 %104, %102
  %arena783 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %105 = load i8*, i8** %arena783, align 8, !tbaa !22
  %sub.ptr.lhs.cast784 = ptrtoint i8* %101 to i64
  %sub.ptr.rhs.cast785 = ptrtoint i8* %105 to i64
  %sub.ptr.sub786 = sub i64 %sub.ptr.lhs.cast784, %sub.ptr.rhs.cast785
  %106 = shl i64 %add775, 32
  %conv778 = add i64 %106, 35180077121536
  %sext1137 = ashr exact i64 %conv778, 32
  %conv790 = and i64 %sext1137, -8192
  %call792 = call i8* @Perl_safesysrealloc(i8* %105, i64 %conv790) #7
  store i8* %call792, i8** %arena783, align 8, !tbaa !22
  store i64 %conv790, i64* %asiz774, align 8, !tbaa !21
  %sext1138 = shl i64 %sub.ptr.sub786, 32
  %idx.ext800 = ashr exact i64 %sext1138, 32
  %add.ptr801 = getelementptr inbounds i8, i8* %call792, i64 %idx.ext800
  store i8* %add.ptr801, i8** %aptr765, align 8, !tbaa !19
  %add.ptr808 = getelementptr inbounds i8, i8* %call792, i64 %conv790
  store i8* %add.ptr808, i8** %aend768, align 8, !tbaa !20
  %.pre1162 = load i64, i64* %len, align 8, !tbaa !17
  br label %if.end811

if.end811:                                        ; preds = %if.then771, %if.then763
  %107 = phi i64 [ %.pre1162, %if.then771 ], [ %102, %if.then763 ]
  %108 = phi i8* [ %add.ptr801, %if.then771 ], [ %101, %if.then763 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %108, i8* align 1 %4, i64 %107, i1 false)
  %109 = load i64, i64* %len, align 8, !tbaa !17
  %110 = load i8*, i8** %aptr765, align 8, !tbaa !19
  %add.ptr817 = getelementptr inbounds i8, i8* %110, i64 %109
  store i8* %add.ptr817, i8** %aptr765, align 8, !tbaa !19
  br label %if.end826

if.else818:                                       ; preds = %if.end760
  %111 = load i64, i64* %len, align 8, !tbaa !17
  %call820 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %100, i8* %4, i64 %111) #7
  %112 = load i64, i64* %len, align 8, !tbaa !17
  %cmp821.not = icmp eq i64 %call820, %112
  br i1 %cmp821.not, label %if.end826, label %cleanup828

if.end826:                                        ; preds = %if.else818, %if.end811, %if.else355, %if.end350, %if.end280, %if.else113, %if.else69, %if.then65
  %113 = zext i32 %type to i64
  %arrayidx = getelementptr inbounds [8 x i32 (%struct.stcxt*, %struct.sv*)*], [8 x i32 (%struct.stcxt*, %struct.sv*)*]* @sv_store, i64 0, i64 %113
  %114 = load i32 (%struct.stcxt*, %struct.sv*)*, i32 (%struct.stcxt*, %struct.sv*)** %arrayidx, align 8, !tbaa !28
  %call827 = call i32 %114(%struct.stcxt* nonnull %cxt, %struct.sv* %sv) #7
  br label %cleanup828

cleanup828:                                       ; preds = %if.end826, %if.else818, %if.else748, %cleanup674, %if.else566, %if.else495, %if.else426, %if.else355, %cleanup281, %if.else180, %if.else113, %if.else44, %if.then
  %retval.8 = phi i32 [ %call2, %if.then ], [ %call827, %if.end826 ], [ -1, %if.else44 ], [ -1, %if.else113 ], [ -1, %cleanup281 ], [ -1, %if.else355 ], [ -1, %if.else180 ], [ -1, %if.else426 ], [ -1, %if.else495 ], [ -1, %cleanup674 ], [ -1, %if.else748 ], [ -1, %if.else566 ], [ -1, %if.else818 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %1) #5
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %0) #5
  ret i32 %retval.8
}

; Function Attrs: noinline nounwind optsize uwtable
define hidden i32 @store_scalar(%struct.stcxt* %cxt, %struct.sv* %sv) #3 {
entry:
  %iv = alloca i64, align 8
  %len = alloca i64, align 8
  %niv = alloca i64, align 8
  %nv = alloca double, align 8
  %wlen = alloca i64, align 8
  %y = alloca i32, align 4
  %y1735 = alloca i32, align 4
  %0 = bitcast i64* %iv to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %0) #5
  %1 = bitcast i64* %len to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %1) #5
  %sv_flags = getelementptr inbounds %struct.sv, %struct.sv* %sv, i64 0, i32 2
  %2 = load i64, i64* %sv_flags, align 8, !tbaa !29
  %and = and i64 %2, 118423552
  %tobool.not = icmp eq i64 %and, 0
  br i1 %tobool.not, label %if.then, label %if.end112

if.then:                                          ; preds = %entry
  %cmp = icmp eq %struct.sv* %sv, @PL_sv_undef
  %fio = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %3 = load %struct._PerlIO**, %struct._PerlIO*** %fio, align 8, !tbaa !18
  %tobool2.not = icmp eq %struct._PerlIO** %3, null
  br i1 %cmp, label %if.then1, label %if.else45

if.then1:                                         ; preds = %if.then
  br i1 %tobool2.not, label %if.then3, label %if.else37

if.then3:                                         ; preds = %if.then1
  %aptr = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %4 = load i8*, i8** %aptr, align 8, !tbaa !19
  %aend = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %5 = load i8*, i8** %aend, align 8, !tbaa !20
  %cmp5 = icmp ult i8* %4, %5
  br i1 %cmp5, label %if.then6, label %if.else

if.then6:                                         ; preds = %if.then3
  %incdec.ptr = getelementptr inbounds i8, i8* %4, i64 1
  store i8* %incdec.ptr, i8** %aptr, align 8, !tbaa !19
  store i8 14, i8* %4, align 1, !tbaa !23
  br label %if.end111

if.else:                                          ; preds = %if.then3
  %asiz = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %6 = load i64, i64* %asiz, align 8, !tbaa !21
  %arena = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %7 = load i8*, i8** %arena, align 8, !tbaa !22
  %sub.ptr.lhs.cast = ptrtoint i8* %4 to i64
  %sub.ptr.rhs.cast = ptrtoint i8* %7 to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %8 = shl i64 %6, 32
  %conv = add i64 %8, 35184372088832
  %sext2678 = ashr exact i64 %conv, 32
  %conv18 = and i64 %sext2678, -8192
  %call = tail call i8* @Perl_safesysrealloc(i8* %7, i64 %conv18) #7
  store i8* %call, i8** %arena, align 8, !tbaa !22
  store i64 %conv18, i64* %asiz, align 8, !tbaa !21
  %sext2679 = shl i64 %sub.ptr.sub, 32
  %idx.ext = ashr exact i64 %sext2679, 32
  %add.ptr = getelementptr inbounds i8, i8* %call, i64 %idx.ext
  %add.ptr31 = getelementptr inbounds i8, i8* %call, i64 %conv18
  store i8* %add.ptr31, i8** %aend, align 8, !tbaa !20
  %incdec.ptr36 = getelementptr inbounds i8, i8* %add.ptr, i64 1
  store i8* %incdec.ptr36, i8** %aptr, align 8, !tbaa !19
  store i8 14, i8* %add.ptr, align 1, !tbaa !23
  br label %if.end111

if.else37:                                        ; preds = %if.then1
  %call39 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %3, i32 14) #7
  %cmp40 = icmp eq i32 %call39, -1
  br i1 %cmp40, label %cleanup1988, label %if.end111

if.else45:                                        ; preds = %if.then
  br i1 %tobool2.not, label %if.then48, label %if.else103

if.then48:                                        ; preds = %if.else45
  %aptr50 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %9 = load i8*, i8** %aptr50, align 8, !tbaa !19
  %aend52 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %10 = load i8*, i8** %aend52, align 8, !tbaa !20
  %cmp53 = icmp ult i8* %9, %10
  br i1 %cmp53, label %if.then55, label %if.else59

if.then55:                                        ; preds = %if.then48
  %incdec.ptr58 = getelementptr inbounds i8, i8* %9, i64 1
  store i8* %incdec.ptr58, i8** %aptr50, align 8, !tbaa !19
  store i8 5, i8* %9, align 1, !tbaa !23
  br label %if.end111

if.else59:                                        ; preds = %if.then48
  %asiz62 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %11 = load i64, i64* %asiz62, align 8, !tbaa !21
  %arena71 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %12 = load i8*, i8** %arena71, align 8, !tbaa !22
  %sub.ptr.lhs.cast72 = ptrtoint i8* %9 to i64
  %sub.ptr.rhs.cast73 = ptrtoint i8* %12 to i64
  %sub.ptr.sub74 = sub i64 %sub.ptr.lhs.cast72, %sub.ptr.rhs.cast73
  %13 = shl i64 %11, 32
  %conv66 = add i64 %13, 35184372088832
  %sext = ashr exact i64 %conv66, 32
  %conv78 = and i64 %sext, -8192
  %call80 = tail call i8* @Perl_safesysrealloc(i8* %12, i64 %conv78) #7
  store i8* %call80, i8** %arena71, align 8, !tbaa !22
  store i64 %conv78, i64* %asiz62, align 8, !tbaa !21
  %sext2677 = shl i64 %sub.ptr.sub74, 32
  %idx.ext88 = ashr exact i64 %sext2677, 32
  %add.ptr89 = getelementptr inbounds i8, i8* %call80, i64 %idx.ext88
  %add.ptr96 = getelementptr inbounds i8, i8* %call80, i64 %conv78
  store i8* %add.ptr96, i8** %aend52, align 8, !tbaa !20
  %incdec.ptr101 = getelementptr inbounds i8, i8* %add.ptr89, i64 1
  store i8* %incdec.ptr101, i8** %aptr50, align 8, !tbaa !19
  store i8 5, i8* %add.ptr89, align 1, !tbaa !23
  br label %if.end111

if.else103:                                       ; preds = %if.else45
  %call105 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %3, i32 5) #7
  %cmp106 = icmp eq i32 %call105, -1
  br i1 %cmp106, label %cleanup1988, label %if.end111

if.end111:                                        ; preds = %if.else103, %if.else59, %if.then55, %if.else37, %if.else, %if.then6
  br label %cleanup1988

if.end112:                                        ; preds = %entry
  %and113 = and i64 %2, 8781824
  %cmp114 = icmp eq i64 %and113, 8781824
  br i1 %cmp114, label %if.then116, label %if.else263

if.then116:                                       ; preds = %if.end112
  %cmp117 = icmp eq %struct.sv* %sv, @PL_sv_yes
  br i1 %cmp117, label %if.then119, label %if.else185

if.then119:                                       ; preds = %if.then116
  %fio120 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %14 = load %struct._PerlIO**, %struct._PerlIO*** %fio120, align 8, !tbaa !18
  %tobool121.not = icmp eq %struct._PerlIO** %14, null
  br i1 %tobool121.not, label %if.then122, label %if.else177

if.then122:                                       ; preds = %if.then119
  %aptr124 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %15 = load i8*, i8** %aptr124, align 8, !tbaa !19
  %aend126 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %16 = load i8*, i8** %aend126, align 8, !tbaa !20
  %cmp127 = icmp ult i8* %15, %16
  br i1 %cmp127, label %if.then129, label %if.else133

if.then129:                                       ; preds = %if.then122
  %incdec.ptr132 = getelementptr inbounds i8, i8* %15, i64 1
  store i8* %incdec.ptr132, i8** %aptr124, align 8, !tbaa !19
  store i8 15, i8* %15, align 1, !tbaa !23
  br label %if.end1987

if.else133:                                       ; preds = %if.then122
  %asiz136 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %17 = load i64, i64* %asiz136, align 8, !tbaa !21
  %arena145 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %18 = load i8*, i8** %arena145, align 8, !tbaa !22
  %sub.ptr.lhs.cast146 = ptrtoint i8* %15 to i64
  %sub.ptr.rhs.cast147 = ptrtoint i8* %18 to i64
  %sub.ptr.sub148 = sub i64 %sub.ptr.lhs.cast146, %sub.ptr.rhs.cast147
  %19 = shl i64 %17, 32
  %conv140 = add i64 %19, 35184372088832
  %sext2728 = ashr exact i64 %conv140, 32
  %conv152 = and i64 %sext2728, -8192
  %call154 = tail call i8* @Perl_safesysrealloc(i8* %18, i64 %conv152) #7
  store i8* %call154, i8** %arena145, align 8, !tbaa !22
  store i64 %conv152, i64* %asiz136, align 8, !tbaa !21
  %sext2729 = shl i64 %sub.ptr.sub148, 32
  %idx.ext162 = ashr exact i64 %sext2729, 32
  %add.ptr163 = getelementptr inbounds i8, i8* %call154, i64 %idx.ext162
  %add.ptr170 = getelementptr inbounds i8, i8* %call154, i64 %conv152
  store i8* %add.ptr170, i8** %aend126, align 8, !tbaa !20
  %incdec.ptr175 = getelementptr inbounds i8, i8* %add.ptr163, i64 1
  store i8* %incdec.ptr175, i8** %aptr124, align 8, !tbaa !19
  store i8 15, i8* %add.ptr163, align 1, !tbaa !23
  br label %if.end1987

if.else177:                                       ; preds = %if.then119
  %call179 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %14, i32 15) #7
  %cmp180 = icmp eq i32 %call179, -1
  br i1 %cmp180, label %cleanup1988, label %if.end1987

if.else185:                                       ; preds = %if.then116
  %cmp186 = icmp eq %struct.sv* %sv, @PL_sv_no
  br i1 %cmp186, label %if.then188, label %if.else254

if.then188:                                       ; preds = %if.else185
  %fio189 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %20 = load %struct._PerlIO**, %struct._PerlIO*** %fio189, align 8, !tbaa !18
  %tobool190.not = icmp eq %struct._PerlIO** %20, null
  br i1 %tobool190.not, label %if.then191, label %if.else246

if.then191:                                       ; preds = %if.then188
  %aptr193 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %21 = load i8*, i8** %aptr193, align 8, !tbaa !19
  %aend195 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %22 = load i8*, i8** %aend195, align 8, !tbaa !20
  %cmp196 = icmp ult i8* %21, %22
  br i1 %cmp196, label %if.then198, label %if.else202

if.then198:                                       ; preds = %if.then191
  %incdec.ptr201 = getelementptr inbounds i8, i8* %21, i64 1
  store i8* %incdec.ptr201, i8** %aptr193, align 8, !tbaa !19
  store i8 16, i8* %21, align 1, !tbaa !23
  br label %if.end1987

if.else202:                                       ; preds = %if.then191
  %asiz205 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %23 = load i64, i64* %asiz205, align 8, !tbaa !21
  %arena214 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %24 = load i8*, i8** %arena214, align 8, !tbaa !22
  %sub.ptr.lhs.cast215 = ptrtoint i8* %21 to i64
  %sub.ptr.rhs.cast216 = ptrtoint i8* %24 to i64
  %sub.ptr.sub217 = sub i64 %sub.ptr.lhs.cast215, %sub.ptr.rhs.cast216
  %25 = shl i64 %23, 32
  %conv209 = add i64 %25, 35184372088832
  %sext2726 = ashr exact i64 %conv209, 32
  %conv221 = and i64 %sext2726, -8192
  %call223 = tail call i8* @Perl_safesysrealloc(i8* %24, i64 %conv221) #7
  store i8* %call223, i8** %arena214, align 8, !tbaa !22
  store i64 %conv221, i64* %asiz205, align 8, !tbaa !21
  %sext2727 = shl i64 %sub.ptr.sub217, 32
  %idx.ext231 = ashr exact i64 %sext2727, 32
  %add.ptr232 = getelementptr inbounds i8, i8* %call223, i64 %idx.ext231
  %add.ptr239 = getelementptr inbounds i8, i8* %call223, i64 %conv221
  store i8* %add.ptr239, i8** %aend195, align 8, !tbaa !20
  %incdec.ptr244 = getelementptr inbounds i8, i8* %add.ptr232, i64 1
  store i8* %incdec.ptr244, i8** %aptr193, align 8, !tbaa !19
  store i8 16, i8* %add.ptr232, align 1, !tbaa !23
  br label %if.end1987

if.else246:                                       ; preds = %if.then188
  %call248 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %20, i32 16) #7
  %cmp249 = icmp eq i32 %call248, -1
  br i1 %cmp249, label %cleanup1988, label %if.end1987

if.else254:                                       ; preds = %if.else185
  %and256 = and i64 %2, 262144
  %cmp257.not = icmp eq i64 %and256, 0
  br i1 %cmp257.not, label %cond.false, label %cond.true

cond.true:                                        ; preds = %if.else254
  %26 = bitcast %struct.sv* %sv to %struct.sv**
  %27 = load %struct.sv*, %struct.sv** %26, align 8, !tbaa !31
  %xpv_cur = getelementptr inbounds %struct.sv, %struct.sv* %27, i64 0, i32 1
  %28 = load i64, i64* %xpv_cur, align 8, !tbaa !32
  store i64 %28, i64* %len, align 8, !tbaa !17
  %xpv_pv = getelementptr inbounds %struct.sv, %struct.sv* %27, i64 0, i32 0
  %29 = load i8*, i8** %xpv_pv, align 8, !tbaa !34
  br label %string

cond.false:                                       ; preds = %if.else254
  %call260 = call i8* @Perl_sv_2pv_flags(%struct.sv* %sv, i64* nonnull %len, i64 2) #7
  br label %stringthread-pre-split

if.else263:                                       ; preds = %if.end112
  %and264 = and i64 %2, 262144
  %tobool265.not = icmp eq i64 %and264, 0
  br i1 %tobool265.not, label %if.else267, label %string_readlen

if.else267:                                       ; preds = %if.else263
  %and268 = and i64 %2, 65536
  %tobool269.not = icmp eq i64 %and268, 0
  br i1 %tobool269.not, label %if.else730, label %cond.end278

cond.end278:                                      ; preds = %if.else267
  %30 = bitcast %struct.sv* %sv to %struct.xpviv**
  %31 = load %struct.xpviv*, %struct.xpviv** %30, align 8, !tbaa !31
  %xiv_iv = getelementptr inbounds %struct.xpviv, %struct.xpviv* %31, i64 0, i32 3
  %32 = load i64, i64* %xiv_iv, align 8, !tbaa !35
  store i64 %32, i64* %iv, align 8, !tbaa !17
  br label %integer

integer:                                          ; preds = %cleanup915.thread2736, %cond.end278
  %33 = phi i64 [ %cond770, %cleanup915.thread2736 ], [ %32, %cond.end278 ]
  %34 = trunc i64 %2 to i32
  %tobool281.not = icmp sgt i32 %34, -1
  br i1 %tobool281.not, label %if.end294, label %land.lhs.true

land.lhs.true:                                    ; preds = %integer
  %35 = load i64, i64* %sv_flags, align 8, !tbaa !29
  %and283 = and i64 %35, 65536
  %tobool284.not = icmp eq i64 %and283, 0
  br i1 %tobool284.not, label %cond.false287, label %cond.true285

cond.true285:                                     ; preds = %land.lhs.true
  %36 = bitcast %struct.sv* %sv to %struct.xpviv**
  %37 = load %struct.xpviv*, %struct.xpviv** %36, align 8, !tbaa !31
  %xuv_uv = getelementptr inbounds %struct.xpviv, %struct.xpviv* %37, i64 0, i32 3
  %38 = load i64, i64* %xuv_uv, align 8, !tbaa !37
  br label %cond.end289

cond.false287:                                    ; preds = %land.lhs.true
  %call288 = tail call i64 @Perl_sv_2uv(%struct.sv* nonnull %sv) #7
  br label %cond.end289

cond.end289:                                      ; preds = %cond.false287, %cond.true285
  %cond290 = phi i64 [ %38, %cond.true285 ], [ %call288, %cond.false287 ]
  %cmp291 = icmp slt i64 %cond290, 0
  br i1 %cmp291, label %string_readlen, label %if.end294

if.end294:                                        ; preds = %cond.end289, %integer
  %.off = add i64 %33, 128
  %39 = icmp ult i64 %.off, 256
  br i1 %39, label %if.then300, label %if.else434

if.then300:                                       ; preds = %if.end294
  %40 = trunc i64 %33 to i8
  %conv302 = xor i8 %40, -128
  %fio303 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %41 = load %struct._PerlIO**, %struct._PerlIO*** %fio303, align 8, !tbaa !18
  %tobool304.not = icmp eq %struct._PerlIO** %41, null
  br i1 %tobool304.not, label %if.then305, label %if.else360

if.then305:                                       ; preds = %if.then300
  %aptr307 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %42 = load i8*, i8** %aptr307, align 8, !tbaa !19
  %aend309 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %43 = load i8*, i8** %aend309, align 8, !tbaa !20
  %cmp310 = icmp ult i8* %42, %43
  br i1 %cmp310, label %if.end367.sink.split, label %if.else316

if.else316:                                       ; preds = %if.then305
  %asiz319 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %44 = load i64, i64* %asiz319, align 8, !tbaa !21
  %arena328 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %45 = load i8*, i8** %arena328, align 8, !tbaa !22
  %sub.ptr.lhs.cast329 = ptrtoint i8* %42 to i64
  %sub.ptr.rhs.cast330 = ptrtoint i8* %45 to i64
  %sub.ptr.sub331 = sub i64 %sub.ptr.lhs.cast329, %sub.ptr.rhs.cast330
  %46 = shl i64 %44, 32
  %conv323 = add i64 %46, 35184372088832
  %sext2720 = ashr exact i64 %conv323, 32
  %conv335 = and i64 %sext2720, -8192
  %call337 = tail call i8* @Perl_safesysrealloc(i8* %45, i64 %conv335) #7
  store i8* %call337, i8** %arena328, align 8, !tbaa !22
  store i64 %conv335, i64* %asiz319, align 8, !tbaa !21
  %sext2721 = shl i64 %sub.ptr.sub331, 32
  %idx.ext345 = ashr exact i64 %sext2721, 32
  %add.ptr346 = getelementptr inbounds i8, i8* %call337, i64 %idx.ext345
  %add.ptr353 = getelementptr inbounds i8, i8* %call337, i64 %conv335
  store i8* %add.ptr353, i8** %aend309, align 8, !tbaa !20
  br label %if.end367.sink.split

if.else360:                                       ; preds = %if.then300
  %call362 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %41, i32 8) #7
  %cmp363 = icmp eq i32 %call362, -1
  br i1 %cmp363, label %cleanup1988, label %if.end367

if.end367.sink.split:                             ; preds = %if.else316, %if.then305
  %.sink2749 = phi i8* [ %add.ptr346, %if.else316 ], [ %42, %if.then305 ]
  %incdec.ptr315 = getelementptr inbounds i8, i8* %.sink2749, i64 1
  store i8* %incdec.ptr315, i8** %aptr307, align 8, !tbaa !19
  store i8 8, i8* %.sink2749, align 1, !tbaa !23
  br label %if.end367

if.end367:                                        ; preds = %if.end367.sink.split, %if.else360
  %47 = load %struct._PerlIO**, %struct._PerlIO*** %fio303, align 8, !tbaa !18
  %tobool369.not = icmp eq %struct._PerlIO** %47, null
  br i1 %tobool369.not, label %if.then370, label %if.else425

if.then370:                                       ; preds = %if.end367
  %aptr372 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %48 = load i8*, i8** %aptr372, align 8, !tbaa !19
  %aend374 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %49 = load i8*, i8** %aend374, align 8, !tbaa !20
  %cmp375 = icmp ult i8* %48, %49
  br i1 %cmp375, label %if.then377, label %if.else381

if.then377:                                       ; preds = %if.then370
  %incdec.ptr380 = getelementptr inbounds i8, i8* %48, i64 1
  store i8* %incdec.ptr380, i8** %aptr372, align 8, !tbaa !19
  store i8 %conv302, i8* %48, align 1, !tbaa !23
  br label %if.end1987

if.else381:                                       ; preds = %if.then370
  %asiz384 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %50 = load i64, i64* %asiz384, align 8, !tbaa !21
  %arena393 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %51 = load i8*, i8** %arena393, align 8, !tbaa !22
  %sub.ptr.lhs.cast394 = ptrtoint i8* %48 to i64
  %sub.ptr.rhs.cast395 = ptrtoint i8* %51 to i64
  %sub.ptr.sub396 = sub i64 %sub.ptr.lhs.cast394, %sub.ptr.rhs.cast395
  %52 = shl i64 %50, 32
  %conv388 = add i64 %52, 35184372088832
  %sext2722 = ashr exact i64 %conv388, 32
  %conv400 = and i64 %sext2722, -8192
  %call402 = tail call i8* @Perl_safesysrealloc(i8* %51, i64 %conv400) #7
  store i8* %call402, i8** %arena393, align 8, !tbaa !22
  store i64 %conv400, i64* %asiz384, align 8, !tbaa !21
  %sext2723 = shl i64 %sub.ptr.sub396, 32
  %idx.ext410 = ashr exact i64 %sext2723, 32
  %add.ptr411 = getelementptr inbounds i8, i8* %call402, i64 %idx.ext410
  %add.ptr418 = getelementptr inbounds i8, i8* %call402, i64 %conv400
  store i8* %add.ptr418, i8** %aend374, align 8, !tbaa !20
  %incdec.ptr423 = getelementptr inbounds i8, i8* %add.ptr411, i64 1
  store i8* %incdec.ptr423, i8** %aptr372, align 8, !tbaa !19
  store i8 %conv302, i8* %add.ptr411, align 1, !tbaa !23
  br label %if.end1987

if.else425:                                       ; preds = %if.end367
  %conv427 = zext i8 %conv302 to i32
  %call428 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %47, i32 %conv427) #7
  %cmp429 = icmp eq i32 %call428, -1
  br i1 %cmp429, label %cleanup1988, label %if.end1987

if.else434:                                       ; preds = %if.end294
  %netorder = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 11
  %53 = load i32, i32* %netorder, align 8, !tbaa !24
  %tobool435.not = icmp eq i32 %53, 0
  br i1 %tobool435.not, label %if.else597, label %if.then436

if.then436:                                       ; preds = %if.else434
  %54 = bitcast i64* %niv to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %54) #5
  %conv437 = trunc i64 %33 to i32
  %55 = tail call i32 asm "bswap $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %conv437) #8, !srcloc !39
  %conv450 = zext i32 %55 to i64
  store i64 %conv450, i64* %niv, align 8, !tbaa !17
  %fio451 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %56 = load %struct._PerlIO**, %struct._PerlIO*** %fio451, align 8, !tbaa !18
  %tobool452.not = icmp eq %struct._PerlIO** %56, null
  br i1 %tobool452.not, label %if.then453, label %if.else508

if.then453:                                       ; preds = %if.then436
  %aptr455 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %57 = load i8*, i8** %aptr455, align 8, !tbaa !19
  %aend457 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %58 = load i8*, i8** %aend457, align 8, !tbaa !20
  %cmp458 = icmp ult i8* %57, %58
  br i1 %cmp458, label %if.end515.sink.split, label %if.else464

if.else464:                                       ; preds = %if.then453
  %asiz467 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %59 = load i64, i64* %asiz467, align 8, !tbaa !21
  %arena476 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %60 = load i8*, i8** %arena476, align 8, !tbaa !22
  %sub.ptr.lhs.cast477 = ptrtoint i8* %57 to i64
  %sub.ptr.rhs.cast478 = ptrtoint i8* %60 to i64
  %sub.ptr.sub479 = sub i64 %sub.ptr.lhs.cast477, %sub.ptr.rhs.cast478
  %61 = shl i64 %59, 32
  %conv471 = add i64 %61, 35184372088832
  %sext2715 = ashr exact i64 %conv471, 32
  %conv483 = and i64 %sext2715, -8192
  %call485 = tail call i8* @Perl_safesysrealloc(i8* %60, i64 %conv483) #7
  store i8* %call485, i8** %arena476, align 8, !tbaa !22
  store i64 %conv483, i64* %asiz467, align 8, !tbaa !21
  %sext2716 = shl i64 %sub.ptr.sub479, 32
  %idx.ext493 = ashr exact i64 %sext2716, 32
  %add.ptr494 = getelementptr inbounds i8, i8* %call485, i64 %idx.ext493
  %add.ptr501 = getelementptr inbounds i8, i8* %call485, i64 %conv483
  store i8* %add.ptr501, i8** %aend457, align 8, !tbaa !20
  br label %if.end515.sink.split

if.else508:                                       ; preds = %if.then436
  %call510 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %56, i32 9) #7
  %cmp511 = icmp eq i32 %call510, -1
  br i1 %cmp511, label %cleanup594, label %if.end515

if.end515.sink.split:                             ; preds = %if.else464, %if.then453
  %.sink2751 = phi i8* [ %add.ptr494, %if.else464 ], [ %57, %if.then453 ]
  %incdec.ptr463 = getelementptr inbounds i8, i8* %.sink2751, i64 1
  store i8* %incdec.ptr463, i8** %aptr455, align 8, !tbaa !19
  store i8 9, i8* %.sink2751, align 1, !tbaa !23
  br label %if.end515

if.end515:                                        ; preds = %if.end515.sink.split, %if.else508
  %62 = load %struct._PerlIO**, %struct._PerlIO*** %fio451, align 8, !tbaa !18
  %tobool517.not = icmp eq %struct._PerlIO** %62, null
  br i1 %tobool517.not, label %if.then518, label %if.else586

if.then518:                                       ; preds = %if.end515
  %aptr520 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %63 = load i8*, i8** %aptr520, align 8, !tbaa !19
  %add.ptr521 = getelementptr inbounds i8, i8* %63, i64 4
  %aend523 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %64 = load i8*, i8** %aend523, align 8, !tbaa !20
  %cmp524 = icmp ugt i8* %add.ptr521, %64
  br i1 %cmp524, label %if.then526, label %if.end566

if.then526:                                       ; preds = %if.then518
  %asiz529 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %65 = load i64, i64* %asiz529, align 8, !tbaa !21
  %arena538 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %66 = load i8*, i8** %arena538, align 8, !tbaa !22
  %sub.ptr.lhs.cast539 = ptrtoint i8* %63 to i64
  %sub.ptr.rhs.cast540 = ptrtoint i8* %66 to i64
  %sub.ptr.sub541 = sub i64 %sub.ptr.lhs.cast539, %sub.ptr.rhs.cast540
  %67 = shl i64 %65, 32
  %conv533 = add i64 %67, 35197256990720
  %sext2717 = ashr exact i64 %conv533, 32
  %conv545 = and i64 %sext2717, -8192
  %call547 = tail call i8* @Perl_safesysrealloc(i8* %66, i64 %conv545) #7
  store i8* %call547, i8** %arena538, align 8, !tbaa !22
  store i64 %conv545, i64* %asiz529, align 8, !tbaa !21
  %sext2718 = shl i64 %sub.ptr.sub541, 32
  %idx.ext555 = ashr exact i64 %sext2718, 32
  %add.ptr556 = getelementptr inbounds i8, i8* %call547, i64 %idx.ext555
  store i8* %add.ptr556, i8** %aptr520, align 8, !tbaa !19
  %add.ptr563 = getelementptr inbounds i8, i8* %call547, i64 %conv545
  store i8* %add.ptr563, i8** %aend523, align 8, !tbaa !20
  br label %if.end566

if.end566:                                        ; preds = %if.then526, %if.then518
  %68 = phi i8* [ %add.ptr556, %if.then526 ], [ %63, %if.then518 ]
  %69 = ptrtoint i8* %68 to i64
  %and571 = and i64 %69, -4
  %cmp572 = icmp eq i64 %and571, %69
  br i1 %cmp572, label %if.then574, label %if.else578

if.then574:                                       ; preds = %if.end566
  %70 = load i64, i64* %niv, align 8, !tbaa !17
  %conv575 = trunc i64 %70 to i32
  %71 = bitcast i8* %68 to i32*
  store i32 %conv575, i32* %71, align 4, !tbaa !26
  br label %if.end581

if.else578:                                       ; preds = %if.end566
  %72 = bitcast i64* %niv to i32*
  %73 = bitcast i8* %68 to i32*
  %74 = load i32, i32* %72, align 8
  store i32 %74, i32* %73, align 1
  %.pre2738 = load i8*, i8** %aptr520, align 8, !tbaa !19
  br label %if.end581

if.end581:                                        ; preds = %if.else578, %if.then574
  %75 = phi i8* [ %.pre2738, %if.else578 ], [ %68, %if.then574 ]
  %add.ptr585 = getelementptr inbounds i8, i8* %75, i64 4
  store i8* %add.ptr585, i8** %aptr520, align 8, !tbaa !19
  br label %if.end593

if.else586:                                       ; preds = %if.end515
  %call588 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %62, i8* nonnull %54, i64 8) #7
  %cmp589.not = icmp eq i64 %call588, 8
  br i1 %cmp589.not, label %if.end593, label %cleanup594

if.end593:                                        ; preds = %if.else586, %if.end581
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %54) #5
  br label %if.end1987

cleanup594:                                       ; preds = %if.else586, %if.else508
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %54) #5
  br label %cleanup1988

if.else597:                                       ; preds = %if.else434
  %fio598 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %76 = load %struct._PerlIO**, %struct._PerlIO*** %fio598, align 8, !tbaa !18
  %tobool599.not = icmp eq %struct._PerlIO** %76, null
  br i1 %tobool599.not, label %if.then600, label %if.else655

if.then600:                                       ; preds = %if.else597
  %aptr602 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %77 = load i8*, i8** %aptr602, align 8, !tbaa !19
  %aend604 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %78 = load i8*, i8** %aend604, align 8, !tbaa !20
  %cmp605 = icmp ult i8* %77, %78
  br i1 %cmp605, label %if.end662.sink.split, label %if.else611

if.else611:                                       ; preds = %if.then600
  %asiz614 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %79 = load i64, i64* %asiz614, align 8, !tbaa !21
  %arena623 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %80 = load i8*, i8** %arena623, align 8, !tbaa !22
  %sub.ptr.lhs.cast624 = ptrtoint i8* %77 to i64
  %sub.ptr.rhs.cast625 = ptrtoint i8* %80 to i64
  %sub.ptr.sub626 = sub i64 %sub.ptr.lhs.cast624, %sub.ptr.rhs.cast625
  %81 = shl i64 %79, 32
  %conv618 = add i64 %81, 35184372088832
  %sext2711 = ashr exact i64 %conv618, 32
  %conv630 = and i64 %sext2711, -8192
  %call632 = tail call i8* @Perl_safesysrealloc(i8* %80, i64 %conv630) #7
  store i8* %call632, i8** %arena623, align 8, !tbaa !22
  store i64 %conv630, i64* %asiz614, align 8, !tbaa !21
  %sext2712 = shl i64 %sub.ptr.sub626, 32
  %idx.ext640 = ashr exact i64 %sext2712, 32
  %add.ptr641 = getelementptr inbounds i8, i8* %call632, i64 %idx.ext640
  %add.ptr648 = getelementptr inbounds i8, i8* %call632, i64 %conv630
  store i8* %add.ptr648, i8** %aend604, align 8, !tbaa !20
  br label %if.end662.sink.split

if.else655:                                       ; preds = %if.else597
  %call657 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %76, i32 6) #7
  %cmp658 = icmp eq i32 %call657, -1
  br i1 %cmp658, label %cleanup1988, label %if.end662

if.end662.sink.split:                             ; preds = %if.else611, %if.then600
  %.sink2753 = phi i8* [ %add.ptr641, %if.else611 ], [ %77, %if.then600 ]
  %incdec.ptr610 = getelementptr inbounds i8, i8* %.sink2753, i64 1
  store i8* %incdec.ptr610, i8** %aptr602, align 8, !tbaa !19
  store i8 6, i8* %.sink2753, align 1, !tbaa !23
  br label %if.end662

if.end662:                                        ; preds = %if.end662.sink.split, %if.else655
  %82 = load %struct._PerlIO**, %struct._PerlIO*** %fio598, align 8, !tbaa !18
  %tobool664.not = icmp eq %struct._PerlIO** %82, null
  br i1 %tobool664.not, label %if.then665, label %if.else720

if.then665:                                       ; preds = %if.end662
  %aptr667 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %83 = load i8*, i8** %aptr667, align 8, !tbaa !19
  %add.ptr668 = getelementptr inbounds i8, i8* %83, i64 8
  %aend670 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %84 = load i8*, i8** %aend670, align 8, !tbaa !20
  %cmp671 = icmp ugt i8* %add.ptr668, %84
  br i1 %cmp671, label %if.then673, label %if.end713

if.then673:                                       ; preds = %if.then665
  %asiz676 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %85 = load i64, i64* %asiz676, align 8, !tbaa !21
  %arena685 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %86 = load i8*, i8** %arena685, align 8, !tbaa !22
  %sub.ptr.lhs.cast686 = ptrtoint i8* %83 to i64
  %sub.ptr.rhs.cast687 = ptrtoint i8* %86 to i64
  %sub.ptr.sub688 = sub i64 %sub.ptr.lhs.cast686, %sub.ptr.rhs.cast687
  %87 = shl i64 %85, 32
  %conv680 = add i64 %87, 35214436859904
  %sext2713 = ashr exact i64 %conv680, 32
  %conv692 = and i64 %sext2713, -8192
  %call694 = tail call i8* @Perl_safesysrealloc(i8* %86, i64 %conv692) #7
  store i8* %call694, i8** %arena685, align 8, !tbaa !22
  store i64 %conv692, i64* %asiz676, align 8, !tbaa !21
  %sext2714 = shl i64 %sub.ptr.sub688, 32
  %idx.ext702 = ashr exact i64 %sext2714, 32
  %add.ptr703 = getelementptr inbounds i8, i8* %call694, i64 %idx.ext702
  store i8* %add.ptr703, i8** %aptr667, align 8, !tbaa !19
  %add.ptr710 = getelementptr inbounds i8, i8* %call694, i64 %conv692
  store i8* %add.ptr710, i8** %aend670, align 8, !tbaa !20
  br label %if.end713

if.end713:                                        ; preds = %if.then673, %if.then665
  %.in = phi i8* [ %add.ptr703, %if.then673 ], [ %83, %if.then665 ]
  %88 = bitcast i8* %.in to i64*
  %89 = load i64, i64* %iv, align 8
  store i64 %89, i64* %88, align 1
  %90 = load i8*, i8** %aptr667, align 8, !tbaa !19
  %add.ptr719 = getelementptr inbounds i8, i8* %90, i64 8
  store i8* %add.ptr719, i8** %aptr667, align 8, !tbaa !19
  br label %if.end1987

if.else720:                                       ; preds = %if.end662
  %call722 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %82, i8* nonnull %0, i64 8) #7
  %cmp723.not = icmp eq i64 %call722, 8
  br i1 %cmp723.not, label %if.end1987, label %cleanup1988

if.else730:                                       ; preds = %if.else267
  %and731 = and i64 %2, 131072
  %tobool732.not = icmp eq i64 %and731, 0
  br i1 %tobool732.not, label %if.else918, label %if.then733

if.then733:                                       ; preds = %if.else730
  %91 = bitcast double* %nv to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %91) #5
  %and735 = and i64 %2, 16777216
  %tobool736.not = icmp eq i64 %and735, 0
  br i1 %tobool736.not, label %cond.false751, label %if.end755

cond.false751:                                    ; preds = %if.then733
  %call752 = tail call i64 @Perl_sv_2iv(%struct.sv* nonnull %sv) #7
  %.pre = load i64, i64* %sv_flags, align 8, !tbaa !29
  br label %if.end755

if.end755:                                        ; preds = %cond.false751, %if.then733
  %92 = phi i64 [ %.pre, %cond.false751 ], [ %2, %if.then733 ]
  %and757 = and i64 %92, 2147549184
  %cmp758 = icmp eq i64 %and757, 65536
  br i1 %cmp758, label %if.then760, label %if.end771

if.then760:                                       ; preds = %if.end755
  %and762 = and i64 %92, 65536
  %tobool763.not = icmp eq i64 %and762, 0
  br i1 %tobool763.not, label %cond.false767, label %cond.true764

cond.true764:                                     ; preds = %if.then760
  %93 = bitcast %struct.sv* %sv to %struct.xpviv**
  %94 = load %struct.xpviv*, %struct.xpviv** %93, align 8, !tbaa !31
  %xiv_iv766 = getelementptr inbounds %struct.xpviv, %struct.xpviv* %94, i64 0, i32 3
  %95 = load i64, i64* %xiv_iv766, align 8, !tbaa !35
  br label %cleanup915.thread2736

cond.false767:                                    ; preds = %if.then760
  %call768 = tail call i64 @Perl_sv_2iv(%struct.sv* nonnull %sv) #7
  br label %cleanup915.thread2736

cleanup915.thread2736:                            ; preds = %cond.false767, %cond.true764
  %cond770 = phi i64 [ %95, %cond.true764 ], [ %call768, %cond.false767 ]
  store i64 %cond770, i64* %iv, align 8, !tbaa !17
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %91) #5
  br label %integer

if.end771:                                        ; preds = %if.end755
  %and773 = and i64 %92, 131072
  %tobool774.not = icmp eq i64 %and773, 0
  br i1 %tobool774.not, label %cond.false777, label %cond.true775

cond.true775:                                     ; preds = %if.end771
  %96 = bitcast %struct.sv* %sv to %struct.xpvnv**
  %97 = load %struct.xpvnv*, %struct.xpvnv** %96, align 8, !tbaa !31
  %xnv_nv = getelementptr inbounds %struct.xpvnv, %struct.xpvnv* %97, i64 0, i32 4
  %98 = load double, double* %xnv_nv, align 8, !tbaa !40
  br label %cond.end779

cond.false777:                                    ; preds = %if.end771
  %call778 = tail call double @Perl_sv_2nv(%struct.sv* nonnull %sv) #7
  br label %cond.end779

cond.end779:                                      ; preds = %cond.false777, %cond.true775
  %cond780 = phi double [ %98, %cond.true775 ], [ %call778, %cond.false777 ]
  store double %cond780, double* %nv, align 8, !tbaa !42
  %netorder781 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 11
  %99 = load i32, i32* %netorder781, align 8, !tbaa !24
  %tobool782.not = icmp eq i32 %99, 0
  br i1 %tobool782.not, label %if.end784, label %cleanup915

if.end784:                                        ; preds = %cond.end779
  %fio785 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %100 = load %struct._PerlIO**, %struct._PerlIO*** %fio785, align 8, !tbaa !18
  %tobool786.not = icmp eq %struct._PerlIO** %100, null
  br i1 %tobool786.not, label %if.then787, label %if.else842

if.then787:                                       ; preds = %if.end784
  %aptr789 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %101 = load i8*, i8** %aptr789, align 8, !tbaa !19
  %aend791 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %102 = load i8*, i8** %aend791, align 8, !tbaa !20
  %cmp792 = icmp ult i8* %101, %102
  br i1 %cmp792, label %if.end849.sink.split, label %if.else798

if.else798:                                       ; preds = %if.then787
  %asiz801 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %103 = load i64, i64* %asiz801, align 8, !tbaa !21
  %arena810 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %104 = load i8*, i8** %arena810, align 8, !tbaa !22
  %sub.ptr.lhs.cast811 = ptrtoint i8* %101 to i64
  %sub.ptr.rhs.cast812 = ptrtoint i8* %104 to i64
  %sub.ptr.sub813 = sub i64 %sub.ptr.lhs.cast811, %sub.ptr.rhs.cast812
  %105 = shl i64 %103, 32
  %conv805 = add i64 %105, 35184372088832
  %sext2709 = ashr exact i64 %conv805, 32
  %conv817 = and i64 %sext2709, -8192
  %call819 = tail call i8* @Perl_safesysrealloc(i8* %104, i64 %conv817) #7
  store i8* %call819, i8** %arena810, align 8, !tbaa !22
  store i64 %conv817, i64* %asiz801, align 8, !tbaa !21
  %sext2710 = shl i64 %sub.ptr.sub813, 32
  %idx.ext827 = ashr exact i64 %sext2710, 32
  %add.ptr828 = getelementptr inbounds i8, i8* %call819, i64 %idx.ext827
  %add.ptr835 = getelementptr inbounds i8, i8* %call819, i64 %conv817
  store i8* %add.ptr835, i8** %aend791, align 8, !tbaa !20
  br label %if.end849.sink.split

if.else842:                                       ; preds = %if.end784
  %call844 = tail call i32 @PerlIO_putc(%struct._PerlIO** nonnull %100, i32 7) #7
  %cmp845 = icmp eq i32 %call844, -1
  br i1 %cmp845, label %cleanup915.thread, label %if.end849

if.end849.sink.split:                             ; preds = %if.else798, %if.then787
  %.sink2755 = phi i8* [ %add.ptr828, %if.else798 ], [ %101, %if.then787 ]
  %incdec.ptr797 = getelementptr inbounds i8, i8* %.sink2755, i64 1
  store i8* %incdec.ptr797, i8** %aptr789, align 8, !tbaa !19
  store i8 7, i8* %.sink2755, align 1, !tbaa !23
  br label %if.end849

if.end849:                                        ; preds = %if.end849.sink.split, %if.else842
  %106 = load %struct._PerlIO**, %struct._PerlIO*** %fio785, align 8, !tbaa !18
  %tobool851.not = icmp eq %struct._PerlIO** %106, null
  br i1 %tobool851.not, label %if.then852, label %if.else907

if.then852:                                       ; preds = %if.end849
  %aptr854 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %107 = load i8*, i8** %aptr854, align 8, !tbaa !19
  %add.ptr855 = getelementptr inbounds i8, i8* %107, i64 8
  %aend857 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %108 = load i8*, i8** %aend857, align 8, !tbaa !20
  %cmp858 = icmp ugt i8* %add.ptr855, %108
  br i1 %cmp858, label %if.then860, label %if.end900

if.then860:                                       ; preds = %if.then852
  %asiz863 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %109 = load i64, i64* %asiz863, align 8, !tbaa !21
  %arena872 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %110 = load i8*, i8** %arena872, align 8, !tbaa !22
  %sub.ptr.lhs.cast873 = ptrtoint i8* %107 to i64
  %sub.ptr.rhs.cast874 = ptrtoint i8* %110 to i64
  %sub.ptr.sub875 = sub i64 %sub.ptr.lhs.cast873, %sub.ptr.rhs.cast874
  %111 = shl i64 %109, 32
  %conv867 = add i64 %111, 35214436859904
  %sext2724 = ashr exact i64 %conv867, 32
  %conv879 = and i64 %sext2724, -8192
  %call881 = tail call i8* @Perl_safesysrealloc(i8* %110, i64 %conv879) #7
  store i8* %call881, i8** %arena872, align 8, !tbaa !22
  store i64 %conv879, i64* %asiz863, align 8, !tbaa !21
  %sext2725 = shl i64 %sub.ptr.sub875, 32
  %idx.ext889 = ashr exact i64 %sext2725, 32
  %add.ptr890 = getelementptr inbounds i8, i8* %call881, i64 %idx.ext889
  store i8* %add.ptr890, i8** %aptr854, align 8, !tbaa !19
  %add.ptr897 = getelementptr inbounds i8, i8* %call881, i64 %conv879
  store i8* %add.ptr897, i8** %aend857, align 8, !tbaa !20
  br label %if.end900

if.end900:                                        ; preds = %if.then860, %if.then852
  %.in2748 = phi i8* [ %add.ptr890, %if.then860 ], [ %107, %if.then852 ]
  %112 = bitcast i8* %.in2748 to i64*
  %113 = bitcast double* %nv to i64*
  %114 = load i64, i64* %113, align 8
  store i64 %114, i64* %112, align 1
  %115 = load i8*, i8** %aptr854, align 8, !tbaa !19
  %add.ptr906 = getelementptr inbounds i8, i8* %115, i64 8
  store i8* %add.ptr906, i8** %aptr854, align 8, !tbaa !19
  br label %cleanup915.thread2734

if.else907:                                       ; preds = %if.end849
  %call909 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %106, i8* nonnull %91, i64 8) #7
  %cmp910.not = icmp eq i64 %call909, 8
  br i1 %cmp910.not, label %cleanup915.thread2734, label %cleanup915.thread

cleanup915.thread2734:                            ; preds = %if.else907, %if.end900
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %91) #5
  br label %if.end1987

cleanup915.thread:                                ; preds = %if.else907, %if.else842
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %91) #5
  br label %cleanup1988

cleanup915:                                       ; preds = %cond.end779
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %91) #5
  br label %string_readlen

if.else918:                                       ; preds = %if.else730
  %and919 = and i64 %2, 117440512
  %tobool920.not = icmp eq i64 %and919, 0
  br i1 %tobool920.not, label %if.else1981, label %string_readlen

string_readlen:                                   ; preds = %if.else918, %cleanup915, %cond.end289, %if.else263
  %116 = load i64, i64* %sv_flags, align 8, !tbaa !29
  %and923 = and i64 %116, 262144
  %cmp924.not = icmp eq i64 %and923, 0
  br i1 %cmp924.not, label %cond.false931, label %cond.true926

cond.true926:                                     ; preds = %string_readlen
  %117 = bitcast %struct.sv* %sv to %struct.sv**
  %118 = load %struct.sv*, %struct.sv** %117, align 8, !tbaa !31
  %xpv_cur928 = getelementptr inbounds %struct.sv, %struct.sv* %118, i64 0, i32 1
  %119 = load i64, i64* %xpv_cur928, align 8, !tbaa !32
  store i64 %119, i64* %len, align 8, !tbaa !17
  %xpv_pv930 = getelementptr inbounds %struct.sv, %struct.sv* %118, i64 0, i32 0
  %120 = load i8*, i8** %xpv_pv930, align 8, !tbaa !34
  br label %string

cond.false931:                                    ; preds = %string_readlen
  %call932 = call i8* @Perl_sv_2pv_flags(%struct.sv* nonnull %sv, i64* nonnull %len, i64 2) #7
  br label %stringthread-pre-split

stringthread-pre-split:                           ; preds = %cond.false931, %cond.false
  %pv.0.ph = phi i8* [ %call932, %cond.false931 ], [ %call260, %cond.false ]
  %.pr = load i64, i64* %len, align 8, !tbaa !17
  %.pre2739 = load i64, i64* %sv_flags, align 8, !tbaa !29
  br label %string

string:                                           ; preds = %stringthread-pre-split, %cond.true926, %cond.true
  %121 = phi i64 [ %.pre2739, %stringthread-pre-split ], [ %116, %cond.true926 ], [ %2, %cond.true ]
  %122 = phi i64 [ %.pr, %stringthread-pre-split ], [ %119, %cond.true926 ], [ %28, %cond.true ]
  %pv.0 = phi i8* [ %pv.0.ph, %stringthread-pre-split ], [ %120, %cond.true926 ], [ %29, %cond.true ]
  store i64 %122, i64* %wlen, align 8, !tbaa !17
  %and936 = and i64 %121, 536870912
  %tobool937.not = icmp eq i64 %and936, 0
  %cmp1459 = icmp slt i64 %122, 256
  br i1 %tobool937.not, label %if.else1458, label %if.then938

if.then938:                                       ; preds = %string
  br i1 %cmp1459, label %if.then941, label %if.else1145

if.then941:                                       ; preds = %if.then938
  %conv942 = trunc i64 %122 to i8
  %fio943 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %123 = load %struct._PerlIO**, %struct._PerlIO*** %fio943, align 8, !tbaa !18
  %tobool944.not = icmp eq %struct._PerlIO** %123, null
  br i1 %tobool944.not, label %if.then945, label %if.else1000

if.then945:                                       ; preds = %if.then941
  %aptr947 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %124 = load i8*, i8** %aptr947, align 8, !tbaa !19
  %aend949 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %125 = load i8*, i8** %aend949, align 8, !tbaa !20
  %cmp950 = icmp ult i8* %124, %125
  br i1 %cmp950, label %if.end1007.sink.split, label %if.else956

if.else956:                                       ; preds = %if.then945
  %asiz959 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %126 = load i64, i64* %asiz959, align 8, !tbaa !21
  %arena968 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %127 = load i8*, i8** %arena968, align 8, !tbaa !22
  %sub.ptr.lhs.cast969 = ptrtoint i8* %124 to i64
  %sub.ptr.rhs.cast970 = ptrtoint i8* %127 to i64
  %sub.ptr.sub971 = sub i64 %sub.ptr.lhs.cast969, %sub.ptr.rhs.cast970
  %128 = shl i64 %126, 32
  %conv963 = add i64 %128, 35184372088832
  %sext2703 = ashr exact i64 %conv963, 32
  %conv975 = and i64 %sext2703, -8192
  %call977 = call i8* @Perl_safesysrealloc(i8* %127, i64 %conv975) #7
  store i8* %call977, i8** %arena968, align 8, !tbaa !22
  store i64 %conv975, i64* %asiz959, align 8, !tbaa !21
  %sext2704 = shl i64 %sub.ptr.sub971, 32
  %idx.ext985 = ashr exact i64 %sext2704, 32
  %add.ptr986 = getelementptr inbounds i8, i8* %call977, i64 %idx.ext985
  %add.ptr993 = getelementptr inbounds i8, i8* %call977, i64 %conv975
  store i8* %add.ptr993, i8** %aend949, align 8, !tbaa !20
  br label %if.end1007.sink.split

if.else1000:                                      ; preds = %if.then941
  %call1002 = call i32 @PerlIO_putc(%struct._PerlIO** nonnull %123, i32 23) #7
  %cmp1003 = icmp eq i32 %call1002, -1
  br i1 %cmp1003, label %cleanup1988, label %if.end1007

if.end1007.sink.split:                            ; preds = %if.else956, %if.then945
  %.sink2757 = phi i8* [ %add.ptr986, %if.else956 ], [ %124, %if.then945 ]
  %incdec.ptr955 = getelementptr inbounds i8, i8* %.sink2757, i64 1
  store i8* %incdec.ptr955, i8** %aptr947, align 8, !tbaa !19
  store i8 23, i8* %.sink2757, align 1, !tbaa !23
  br label %if.end1007

if.end1007:                                       ; preds = %if.end1007.sink.split, %if.else1000
  %129 = load %struct._PerlIO**, %struct._PerlIO*** %fio943, align 8, !tbaa !18
  %tobool1009.not = icmp eq %struct._PerlIO** %129, null
  br i1 %tobool1009.not, label %if.then1010, label %if.else1065

if.then1010:                                      ; preds = %if.end1007
  %aptr1012 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %130 = load i8*, i8** %aptr1012, align 8, !tbaa !19
  %aend1014 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %131 = load i8*, i8** %aend1014, align 8, !tbaa !20
  %cmp1015 = icmp ult i8* %130, %131
  br i1 %cmp1015, label %if.end1073.sink.split, label %if.else1021

if.else1021:                                      ; preds = %if.then1010
  %asiz1024 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %132 = load i64, i64* %asiz1024, align 8, !tbaa !21
  %arena1033 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %133 = load i8*, i8** %arena1033, align 8, !tbaa !22
  %sub.ptr.lhs.cast1034 = ptrtoint i8* %130 to i64
  %sub.ptr.rhs.cast1035 = ptrtoint i8* %133 to i64
  %sub.ptr.sub1036 = sub i64 %sub.ptr.lhs.cast1034, %sub.ptr.rhs.cast1035
  %134 = shl i64 %132, 32
  %conv1028 = add i64 %134, 35184372088832
  %sext2705 = ashr exact i64 %conv1028, 32
  %conv1040 = and i64 %sext2705, -8192
  %call1042 = call i8* @Perl_safesysrealloc(i8* %133, i64 %conv1040) #7
  store i8* %call1042, i8** %arena1033, align 8, !tbaa !22
  store i64 %conv1040, i64* %asiz1024, align 8, !tbaa !21
  %sext2706 = shl i64 %sub.ptr.sub1036, 32
  %idx.ext1050 = ashr exact i64 %sext2706, 32
  %add.ptr1051 = getelementptr inbounds i8, i8* %call1042, i64 %idx.ext1050
  %add.ptr1058 = getelementptr inbounds i8, i8* %call1042, i64 %conv1040
  store i8* %add.ptr1058, i8** %aend1014, align 8, !tbaa !20
  br label %if.end1073.sink.split

if.else1065:                                      ; preds = %if.end1007
  %135 = trunc i64 %122 to i32
  %conv1067 = and i32 %135, 255
  %call1068 = call i32 @PerlIO_putc(%struct._PerlIO** nonnull %129, i32 %conv1067) #7
  %cmp1069 = icmp eq i32 %call1068, -1
  br i1 %cmp1069, label %cleanup1988, label %if.end1073

if.end1073.sink.split:                            ; preds = %if.else1021, %if.then1010
  %.sink2759 = phi i8* [ %add.ptr1051, %if.else1021 ], [ %130, %if.then1010 ]
  %incdec.ptr1020 = getelementptr inbounds i8, i8* %.sink2759, i64 1
  store i8* %incdec.ptr1020, i8** %aptr1012, align 8, !tbaa !19
  store i8 %conv942, i8* %.sink2759, align 1, !tbaa !23
  br label %if.end1073

if.end1073:                                       ; preds = %if.end1073.sink.split, %if.else1065
  %136 = load i64, i64* %wlen, align 8, !tbaa !17
  %tobool1074.not = icmp eq i64 %136, 0
  br i1 %tobool1074.not, label %if.end1987, label %if.then1075

if.then1075:                                      ; preds = %if.end1073
  %137 = load %struct._PerlIO**, %struct._PerlIO*** %fio943, align 8, !tbaa !18
  %tobool1077.not = icmp eq %struct._PerlIO** %137, null
  br i1 %tobool1077.not, label %if.then1078, label %if.else1133

if.then1078:                                      ; preds = %if.then1075
  %aptr1080 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %138 = load i8*, i8** %aptr1080, align 8, !tbaa !19
  %add.ptr1081 = getelementptr inbounds i8, i8* %138, i64 %136
  %aend1083 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %139 = load i8*, i8** %aend1083, align 8, !tbaa !20
  %cmp1084 = icmp ugt i8* %add.ptr1081, %139
  br i1 %cmp1084, label %if.then1086, label %if.end1126

if.then1086:                                      ; preds = %if.then1078
  %asiz1089 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %140 = load i64, i64* %asiz1089, align 8, !tbaa !21
  %add1090 = add i64 %140, %136
  %arena1098 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %141 = load i8*, i8** %arena1098, align 8, !tbaa !22
  %sub.ptr.lhs.cast1099 = ptrtoint i8* %138 to i64
  %sub.ptr.rhs.cast1100 = ptrtoint i8* %141 to i64
  %sub.ptr.sub1101 = sub i64 %sub.ptr.lhs.cast1099, %sub.ptr.rhs.cast1100
  %142 = shl i64 %add1090, 32
  %conv1093 = add i64 %142, 35180077121536
  %sext2707 = ashr exact i64 %conv1093, 32
  %conv1105 = and i64 %sext2707, -8192
  %call1107 = call i8* @Perl_safesysrealloc(i8* %141, i64 %conv1105) #7
  store i8* %call1107, i8** %arena1098, align 8, !tbaa !22
  store i64 %conv1105, i64* %asiz1089, align 8, !tbaa !21
  %sext2708 = shl i64 %sub.ptr.sub1101, 32
  %idx.ext1115 = ashr exact i64 %sext2708, 32
  %add.ptr1116 = getelementptr inbounds i8, i8* %call1107, i64 %idx.ext1115
  store i8* %add.ptr1116, i8** %aptr1080, align 8, !tbaa !19
  %add.ptr1123 = getelementptr inbounds i8, i8* %call1107, i64 %conv1105
  store i8* %add.ptr1123, i8** %aend1083, align 8, !tbaa !20
  %.pre2743 = load i64, i64* %wlen, align 8, !tbaa !17
  br label %if.end1126

if.end1126:                                       ; preds = %if.then1086, %if.then1078
  %143 = phi i64 [ %.pre2743, %if.then1086 ], [ %136, %if.then1078 ]
  %144 = phi i8* [ %add.ptr1116, %if.then1086 ], [ %138, %if.then1078 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %144, i8* align 1 %pv.0, i64 %143, i1 false)
  %145 = load i64, i64* %wlen, align 8, !tbaa !17
  %146 = load i8*, i8** %aptr1080, align 8, !tbaa !19
  %add.ptr1132 = getelementptr inbounds i8, i8* %146, i64 %145
  store i8* %add.ptr1132, i8** %aptr1080, align 8, !tbaa !19
  br label %if.end1987

if.else1133:                                      ; preds = %if.then1075
  %call1135 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %137, i8* %pv.0, i64 %136) #7
  %147 = load i64, i64* %wlen, align 8, !tbaa !17
  %cmp1136.not = icmp eq i64 %call1135, %147
  br i1 %cmp1136.not, label %if.end1987, label %cleanup1988

if.else1145:                                      ; preds = %if.then938
  %fio1146 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %148 = load %struct._PerlIO**, %struct._PerlIO*** %fio1146, align 8, !tbaa !18
  %tobool1147.not = icmp eq %struct._PerlIO** %148, null
  br i1 %tobool1147.not, label %if.then1148, label %if.else1203

if.then1148:                                      ; preds = %if.else1145
  %aptr1150 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %149 = load i8*, i8** %aptr1150, align 8, !tbaa !19
  %aend1152 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %150 = load i8*, i8** %aend1152, align 8, !tbaa !20
  %cmp1153 = icmp ult i8* %149, %150
  br i1 %cmp1153, label %if.end1210.sink.split, label %if.else1159

if.else1159:                                      ; preds = %if.then1148
  %asiz1162 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %151 = load i64, i64* %asiz1162, align 8, !tbaa !21
  %arena1171 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %152 = load i8*, i8** %arena1171, align 8, !tbaa !22
  %sub.ptr.lhs.cast1172 = ptrtoint i8* %149 to i64
  %sub.ptr.rhs.cast1173 = ptrtoint i8* %152 to i64
  %sub.ptr.sub1174 = sub i64 %sub.ptr.lhs.cast1172, %sub.ptr.rhs.cast1173
  %153 = shl i64 %151, 32
  %conv1166 = add i64 %153, 35184372088832
  %sext2694 = ashr exact i64 %conv1166, 32
  %conv1178 = and i64 %sext2694, -8192
  %call1180 = call i8* @Perl_safesysrealloc(i8* %152, i64 %conv1178) #7
  store i8* %call1180, i8** %arena1171, align 8, !tbaa !22
  store i64 %conv1178, i64* %asiz1162, align 8, !tbaa !21
  %sext2695 = shl i64 %sub.ptr.sub1174, 32
  %idx.ext1188 = ashr exact i64 %sext2695, 32
  %add.ptr1189 = getelementptr inbounds i8, i8* %call1180, i64 %idx.ext1188
  %add.ptr1196 = getelementptr inbounds i8, i8* %call1180, i64 %conv1178
  store i8* %add.ptr1196, i8** %aend1152, align 8, !tbaa !20
  br label %if.end1210.sink.split

if.else1203:                                      ; preds = %if.else1145
  %call1205 = call i32 @PerlIO_putc(%struct._PerlIO** nonnull %148, i32 24) #7
  %cmp1206 = icmp eq i32 %call1205, -1
  br i1 %cmp1206, label %cleanup1988, label %if.end1210

if.end1210.sink.split:                            ; preds = %if.else1159, %if.then1148
  %.sink2761 = phi i8* [ %add.ptr1189, %if.else1159 ], [ %149, %if.then1148 ]
  %incdec.ptr1158 = getelementptr inbounds i8, i8* %.sink2761, i64 1
  store i8* %incdec.ptr1158, i8** %aptr1150, align 8, !tbaa !19
  store i8 24, i8* %.sink2761, align 1, !tbaa !23
  br label %if.end1210

if.end1210:                                       ; preds = %if.end1210.sink.split, %if.else1203
  %netorder1211 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 11
  %154 = load i32, i32* %netorder1211, align 8, !tbaa !24
  %tobool1212.not = icmp eq i32 %154, 0
  br i1 %tobool1212.not, label %if.else1312, label %if.then1213

if.then1213:                                      ; preds = %if.end1210
  %155 = bitcast i32* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %155) #5
  %156 = load i64, i64* %wlen, align 8, !tbaa !17
  %conv1216 = trunc i64 %156 to i32
  %157 = call i32 asm "bswap $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %conv1216) #8, !srcloc !43
  store i32 %157, i32* %y, align 4, !tbaa !26
  %158 = load %struct._PerlIO**, %struct._PerlIO*** %fio1146, align 8, !tbaa !18
  %tobool1233.not = icmp eq %struct._PerlIO** %158, null
  br i1 %tobool1233.not, label %if.then1234, label %if.else1301

if.then1234:                                      ; preds = %if.then1213
  %aptr1236 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %159 = load i8*, i8** %aptr1236, align 8, !tbaa !19
  %add.ptr1237 = getelementptr inbounds i8, i8* %159, i64 4
  %aend1239 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %160 = load i8*, i8** %aend1239, align 8, !tbaa !20
  %cmp1240 = icmp ugt i8* %add.ptr1237, %160
  br i1 %cmp1240, label %if.then1242, label %if.end1282

if.then1242:                                      ; preds = %if.then1234
  %asiz1245 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %161 = load i64, i64* %asiz1245, align 8, !tbaa !21
  %arena1254 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %162 = load i8*, i8** %arena1254, align 8, !tbaa !22
  %sub.ptr.lhs.cast1255 = ptrtoint i8* %159 to i64
  %sub.ptr.rhs.cast1256 = ptrtoint i8* %162 to i64
  %sub.ptr.sub1257 = sub i64 %sub.ptr.lhs.cast1255, %sub.ptr.rhs.cast1256
  %163 = shl i64 %161, 32
  %conv1249 = add i64 %163, 35197256990720
  %sext2700 = ashr exact i64 %conv1249, 32
  %conv1261 = and i64 %sext2700, -8192
  %call1263 = call i8* @Perl_safesysrealloc(i8* %162, i64 %conv1261) #7
  store i8* %call1263, i8** %arena1254, align 8, !tbaa !22
  store i64 %conv1261, i64* %asiz1245, align 8, !tbaa !21
  %sext2701 = shl i64 %sub.ptr.sub1257, 32
  %idx.ext1271 = ashr exact i64 %sext2701, 32
  %add.ptr1272 = getelementptr inbounds i8, i8* %call1263, i64 %idx.ext1271
  store i8* %add.ptr1272, i8** %aptr1236, align 8, !tbaa !19
  %add.ptr1279 = getelementptr inbounds i8, i8* %call1263, i64 %conv1261
  store i8* %add.ptr1279, i8** %aend1239, align 8, !tbaa !20
  br label %if.end1282

if.end1282:                                       ; preds = %if.then1242, %if.then1234
  %164 = phi i8* [ %add.ptr1272, %if.then1242 ], [ %159, %if.then1234 ]
  %165 = ptrtoint i8* %164 to i64
  %and1287 = and i64 %165, -4
  %cmp1288 = icmp eq i64 %and1287, %165
  %166 = bitcast i8* %164 to i32*
  br i1 %cmp1288, label %if.then1290, label %if.else1293

if.then1290:                                      ; preds = %if.end1282
  store i32 %157, i32* %166, align 4, !tbaa !26
  br label %if.end1296

if.else1293:                                      ; preds = %if.end1282
  store i32 %157, i32* %166, align 1
  %.pre2740 = load i8*, i8** %aptr1236, align 8, !tbaa !19
  br label %if.end1296

if.end1296:                                       ; preds = %if.else1293, %if.then1290
  %167 = phi i8* [ %.pre2740, %if.else1293 ], [ %164, %if.then1290 ]
  %add.ptr1300 = getelementptr inbounds i8, i8* %167, i64 4
  store i8* %add.ptr1300, i8** %aptr1236, align 8, !tbaa !19
  br label %if.end1308

if.else1301:                                      ; preds = %if.then1213
  %call1303 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %158, i8* nonnull %155, i64 4) #7
  %cmp1304.not = icmp eq i64 %call1303, 4
  br i1 %cmp1304.not, label %if.end1308, label %cleanup1309

if.end1308:                                       ; preds = %if.else1301, %if.end1296
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %155) #5
  br label %if.end1391

cleanup1309:                                      ; preds = %if.else1301
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %155) #5
  br label %cleanup1988

if.else1312:                                      ; preds = %if.end1210
  %168 = load %struct._PerlIO**, %struct._PerlIO*** %fio1146, align 8, !tbaa !18
  %tobool1314.not = icmp eq %struct._PerlIO** %168, null
  br i1 %tobool1314.not, label %if.then1315, label %if.else1383

if.then1315:                                      ; preds = %if.else1312
  %aptr1317 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %169 = load i8*, i8** %aptr1317, align 8, !tbaa !19
  %add.ptr1318 = getelementptr inbounds i8, i8* %169, i64 4
  %aend1320 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %170 = load i8*, i8** %aend1320, align 8, !tbaa !20
  %cmp1321 = icmp ugt i8* %add.ptr1318, %170
  br i1 %cmp1321, label %if.then1323, label %if.end1363

if.then1323:                                      ; preds = %if.then1315
  %asiz1326 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %171 = load i64, i64* %asiz1326, align 8, !tbaa !21
  %arena1335 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %172 = load i8*, i8** %arena1335, align 8, !tbaa !22
  %sub.ptr.lhs.cast1336 = ptrtoint i8* %169 to i64
  %sub.ptr.rhs.cast1337 = ptrtoint i8* %172 to i64
  %sub.ptr.sub1338 = sub i64 %sub.ptr.lhs.cast1336, %sub.ptr.rhs.cast1337
  %173 = shl i64 %171, 32
  %conv1330 = add i64 %173, 35197256990720
  %sext2698 = ashr exact i64 %conv1330, 32
  %conv1342 = and i64 %sext2698, -8192
  %call1344 = call i8* @Perl_safesysrealloc(i8* %172, i64 %conv1342) #7
  store i8* %call1344, i8** %arena1335, align 8, !tbaa !22
  store i64 %conv1342, i64* %asiz1326, align 8, !tbaa !21
  %sext2699 = shl i64 %sub.ptr.sub1338, 32
  %idx.ext1352 = ashr exact i64 %sext2699, 32
  %add.ptr1353 = getelementptr inbounds i8, i8* %call1344, i64 %idx.ext1352
  store i8* %add.ptr1353, i8** %aptr1317, align 8, !tbaa !19
  %add.ptr1360 = getelementptr inbounds i8, i8* %call1344, i64 %conv1342
  store i8* %add.ptr1360, i8** %aend1320, align 8, !tbaa !20
  br label %if.end1363

if.end1363:                                       ; preds = %if.then1323, %if.then1315
  %174 = phi i8* [ %add.ptr1353, %if.then1323 ], [ %169, %if.then1315 ]
  %175 = ptrtoint i8* %174 to i64
  %and1368 = and i64 %175, -4
  %cmp1369 = icmp eq i64 %and1368, %175
  br i1 %cmp1369, label %if.then1371, label %if.else1375

if.then1371:                                      ; preds = %if.end1363
  %176 = load i64, i64* %wlen, align 8, !tbaa !17
  %conv1372 = trunc i64 %176 to i32
  %177 = bitcast i8* %174 to i32*
  store i32 %conv1372, i32* %177, align 4, !tbaa !26
  br label %if.end1378

if.else1375:                                      ; preds = %if.end1363
  %178 = bitcast i64* %wlen to i32*
  %179 = bitcast i8* %174 to i32*
  %180 = load i32, i32* %178, align 8
  store i32 %180, i32* %179, align 1
  %.pre2741 = load i8*, i8** %aptr1317, align 8, !tbaa !19
  br label %if.end1378

if.end1378:                                       ; preds = %if.else1375, %if.then1371
  %181 = phi i8* [ %.pre2741, %if.else1375 ], [ %174, %if.then1371 ]
  %add.ptr1382 = getelementptr inbounds i8, i8* %181, i64 4
  store i8* %add.ptr1382, i8** %aptr1317, align 8, !tbaa !19
  br label %if.end1391

if.else1383:                                      ; preds = %if.else1312
  %182 = bitcast i64* %wlen to i8*
  %call1385 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %168, i8* nonnull %182, i64 8) #7
  %cmp1386.not = icmp eq i64 %call1385, 8
  br i1 %cmp1386.not, label %if.end1391, label %cleanup1988

if.end1391:                                       ; preds = %if.else1383, %if.end1378, %if.end1308
  %183 = load %struct._PerlIO**, %struct._PerlIO*** %fio1146, align 8, !tbaa !18
  %tobool1393.not = icmp eq %struct._PerlIO** %183, null
  br i1 %tobool1393.not, label %if.then1394, label %if.else1449

if.then1394:                                      ; preds = %if.end1391
  %aptr1396 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %184 = load i8*, i8** %aptr1396, align 8, !tbaa !19
  %185 = load i64, i64* %wlen, align 8, !tbaa !17
  %add.ptr1397 = getelementptr inbounds i8, i8* %184, i64 %185
  %aend1399 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %186 = load i8*, i8** %aend1399, align 8, !tbaa !20
  %cmp1400 = icmp ugt i8* %add.ptr1397, %186
  br i1 %cmp1400, label %if.then1402, label %if.end1442

if.then1402:                                      ; preds = %if.then1394
  %asiz1405 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %187 = load i64, i64* %asiz1405, align 8, !tbaa !21
  %add1406 = add i64 %187, %185
  %arena1414 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %188 = load i8*, i8** %arena1414, align 8, !tbaa !22
  %sub.ptr.lhs.cast1415 = ptrtoint i8* %184 to i64
  %sub.ptr.rhs.cast1416 = ptrtoint i8* %188 to i64
  %sub.ptr.sub1417 = sub i64 %sub.ptr.lhs.cast1415, %sub.ptr.rhs.cast1416
  %189 = shl i64 %add1406, 32
  %conv1409 = add i64 %189, 35180077121536
  %sext2696 = ashr exact i64 %conv1409, 32
  %conv1421 = and i64 %sext2696, -8192
  %call1423 = call i8* @Perl_safesysrealloc(i8* %188, i64 %conv1421) #7
  store i8* %call1423, i8** %arena1414, align 8, !tbaa !22
  store i64 %conv1421, i64* %asiz1405, align 8, !tbaa !21
  %sext2697 = shl i64 %sub.ptr.sub1417, 32
  %idx.ext1431 = ashr exact i64 %sext2697, 32
  %add.ptr1432 = getelementptr inbounds i8, i8* %call1423, i64 %idx.ext1431
  store i8* %add.ptr1432, i8** %aptr1396, align 8, !tbaa !19
  %add.ptr1439 = getelementptr inbounds i8, i8* %call1423, i64 %conv1421
  store i8* %add.ptr1439, i8** %aend1399, align 8, !tbaa !20
  %.pre2742 = load i64, i64* %wlen, align 8, !tbaa !17
  br label %if.end1442

if.end1442:                                       ; preds = %if.then1402, %if.then1394
  %190 = phi i64 [ %.pre2742, %if.then1402 ], [ %185, %if.then1394 ]
  %191 = phi i8* [ %add.ptr1432, %if.then1402 ], [ %184, %if.then1394 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %191, i8* align 1 %pv.0, i64 %190, i1 false)
  %192 = load i64, i64* %wlen, align 8, !tbaa !17
  %193 = load i8*, i8** %aptr1396, align 8, !tbaa !19
  %add.ptr1448 = getelementptr inbounds i8, i8* %193, i64 %192
  store i8* %add.ptr1448, i8** %aptr1396, align 8, !tbaa !19
  br label %if.end1987

if.else1449:                                      ; preds = %if.end1391
  %194 = load i64, i64* %wlen, align 8, !tbaa !17
  %call1451 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %183, i8* %pv.0, i64 %194) #7
  %195 = load i64, i64* %wlen, align 8, !tbaa !17
  %cmp1452.not = icmp eq i64 %call1451, %195
  br i1 %cmp1452.not, label %if.end1987, label %cleanup1988

if.else1458:                                      ; preds = %string
  br i1 %cmp1459, label %if.then1461, label %if.else1666

if.then1461:                                      ; preds = %if.else1458
  %conv1463 = trunc i64 %122 to i8
  %fio1464 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %196 = load %struct._PerlIO**, %struct._PerlIO*** %fio1464, align 8, !tbaa !18
  %tobool1465.not = icmp eq %struct._PerlIO** %196, null
  br i1 %tobool1465.not, label %if.then1466, label %if.else1521

if.then1466:                                      ; preds = %if.then1461
  %aptr1468 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %197 = load i8*, i8** %aptr1468, align 8, !tbaa !19
  %aend1470 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %198 = load i8*, i8** %aend1470, align 8, !tbaa !20
  %cmp1471 = icmp ult i8* %197, %198
  br i1 %cmp1471, label %if.end1528.sink.split, label %if.else1477

if.else1477:                                      ; preds = %if.then1466
  %asiz1480 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %199 = load i64, i64* %asiz1480, align 8, !tbaa !21
  %arena1489 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %200 = load i8*, i8** %arena1489, align 8, !tbaa !22
  %sub.ptr.lhs.cast1490 = ptrtoint i8* %197 to i64
  %sub.ptr.rhs.cast1491 = ptrtoint i8* %200 to i64
  %sub.ptr.sub1492 = sub i64 %sub.ptr.lhs.cast1490, %sub.ptr.rhs.cast1491
  %201 = shl i64 %199, 32
  %conv1484 = add i64 %201, 35184372088832
  %sext2688 = ashr exact i64 %conv1484, 32
  %conv1496 = and i64 %sext2688, -8192
  %call1498 = call i8* @Perl_safesysrealloc(i8* %200, i64 %conv1496) #7
  store i8* %call1498, i8** %arena1489, align 8, !tbaa !22
  store i64 %conv1496, i64* %asiz1480, align 8, !tbaa !21
  %sext2689 = shl i64 %sub.ptr.sub1492, 32
  %idx.ext1506 = ashr exact i64 %sext2689, 32
  %add.ptr1507 = getelementptr inbounds i8, i8* %call1498, i64 %idx.ext1506
  %add.ptr1514 = getelementptr inbounds i8, i8* %call1498, i64 %conv1496
  store i8* %add.ptr1514, i8** %aend1470, align 8, !tbaa !20
  br label %if.end1528.sink.split

if.else1521:                                      ; preds = %if.then1461
  %call1523 = call i32 @PerlIO_putc(%struct._PerlIO** nonnull %196, i32 10) #7
  %cmp1524 = icmp eq i32 %call1523, -1
  br i1 %cmp1524, label %cleanup1988, label %if.end1528

if.end1528.sink.split:                            ; preds = %if.else1477, %if.then1466
  %.sink2763 = phi i8* [ %add.ptr1507, %if.else1477 ], [ %197, %if.then1466 ]
  %incdec.ptr1476 = getelementptr inbounds i8, i8* %.sink2763, i64 1
  store i8* %incdec.ptr1476, i8** %aptr1468, align 8, !tbaa !19
  store i8 10, i8* %.sink2763, align 1, !tbaa !23
  br label %if.end1528

if.end1528:                                       ; preds = %if.end1528.sink.split, %if.else1521
  %202 = load %struct._PerlIO**, %struct._PerlIO*** %fio1464, align 8, !tbaa !18
  %tobool1530.not = icmp eq %struct._PerlIO** %202, null
  br i1 %tobool1530.not, label %if.then1531, label %if.else1586

if.then1531:                                      ; preds = %if.end1528
  %aptr1533 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %203 = load i8*, i8** %aptr1533, align 8, !tbaa !19
  %aend1535 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %204 = load i8*, i8** %aend1535, align 8, !tbaa !20
  %cmp1536 = icmp ult i8* %203, %204
  br i1 %cmp1536, label %if.end1594.sink.split, label %if.else1542

if.else1542:                                      ; preds = %if.then1531
  %asiz1545 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %205 = load i64, i64* %asiz1545, align 8, !tbaa !21
  %arena1554 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %206 = load i8*, i8** %arena1554, align 8, !tbaa !22
  %sub.ptr.lhs.cast1555 = ptrtoint i8* %203 to i64
  %sub.ptr.rhs.cast1556 = ptrtoint i8* %206 to i64
  %sub.ptr.sub1557 = sub i64 %sub.ptr.lhs.cast1555, %sub.ptr.rhs.cast1556
  %207 = shl i64 %205, 32
  %conv1549 = add i64 %207, 35184372088832
  %sext2690 = ashr exact i64 %conv1549, 32
  %conv1561 = and i64 %sext2690, -8192
  %call1563 = call i8* @Perl_safesysrealloc(i8* %206, i64 %conv1561) #7
  store i8* %call1563, i8** %arena1554, align 8, !tbaa !22
  store i64 %conv1561, i64* %asiz1545, align 8, !tbaa !21
  %sext2691 = shl i64 %sub.ptr.sub1557, 32
  %idx.ext1571 = ashr exact i64 %sext2691, 32
  %add.ptr1572 = getelementptr inbounds i8, i8* %call1563, i64 %idx.ext1571
  %add.ptr1579 = getelementptr inbounds i8, i8* %call1563, i64 %conv1561
  store i8* %add.ptr1579, i8** %aend1535, align 8, !tbaa !20
  br label %if.end1594.sink.split

if.else1586:                                      ; preds = %if.end1528
  %208 = trunc i64 %122 to i32
  %conv1588 = and i32 %208, 255
  %call1589 = call i32 @PerlIO_putc(%struct._PerlIO** nonnull %202, i32 %conv1588) #7
  %cmp1590 = icmp eq i32 %call1589, -1
  br i1 %cmp1590, label %cleanup1988, label %if.end1594

if.end1594.sink.split:                            ; preds = %if.else1542, %if.then1531
  %.sink2765 = phi i8* [ %add.ptr1572, %if.else1542 ], [ %203, %if.then1531 ]
  %incdec.ptr1541 = getelementptr inbounds i8, i8* %.sink2765, i64 1
  store i8* %incdec.ptr1541, i8** %aptr1533, align 8, !tbaa !19
  store i8 %conv1463, i8* %.sink2765, align 1, !tbaa !23
  br label %if.end1594

if.end1594:                                       ; preds = %if.end1594.sink.split, %if.else1586
  %209 = load i64, i64* %wlen, align 8, !tbaa !17
  %tobool1595.not = icmp eq i64 %209, 0
  br i1 %tobool1595.not, label %if.end1987, label %if.then1596

if.then1596:                                      ; preds = %if.end1594
  %210 = load %struct._PerlIO**, %struct._PerlIO*** %fio1464, align 8, !tbaa !18
  %tobool1598.not = icmp eq %struct._PerlIO** %210, null
  br i1 %tobool1598.not, label %if.then1599, label %if.else1654

if.then1599:                                      ; preds = %if.then1596
  %aptr1601 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %211 = load i8*, i8** %aptr1601, align 8, !tbaa !19
  %add.ptr1602 = getelementptr inbounds i8, i8* %211, i64 %209
  %aend1604 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %212 = load i8*, i8** %aend1604, align 8, !tbaa !20
  %cmp1605 = icmp ugt i8* %add.ptr1602, %212
  br i1 %cmp1605, label %if.then1607, label %if.end1647

if.then1607:                                      ; preds = %if.then1599
  %asiz1610 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %213 = load i64, i64* %asiz1610, align 8, !tbaa !21
  %add1611 = add i64 %213, %209
  %arena1619 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %214 = load i8*, i8** %arena1619, align 8, !tbaa !22
  %sub.ptr.lhs.cast1620 = ptrtoint i8* %211 to i64
  %sub.ptr.rhs.cast1621 = ptrtoint i8* %214 to i64
  %sub.ptr.sub1622 = sub i64 %sub.ptr.lhs.cast1620, %sub.ptr.rhs.cast1621
  %215 = shl i64 %add1611, 32
  %conv1614 = add i64 %215, 35180077121536
  %sext2692 = ashr exact i64 %conv1614, 32
  %conv1626 = and i64 %sext2692, -8192
  %call1628 = call i8* @Perl_safesysrealloc(i8* %214, i64 %conv1626) #7
  store i8* %call1628, i8** %arena1619, align 8, !tbaa !22
  store i64 %conv1626, i64* %asiz1610, align 8, !tbaa !21
  %sext2693 = shl i64 %sub.ptr.sub1622, 32
  %idx.ext1636 = ashr exact i64 %sext2693, 32
  %add.ptr1637 = getelementptr inbounds i8, i8* %call1628, i64 %idx.ext1636
  store i8* %add.ptr1637, i8** %aptr1601, align 8, !tbaa !19
  %add.ptr1644 = getelementptr inbounds i8, i8* %call1628, i64 %conv1626
  store i8* %add.ptr1644, i8** %aend1604, align 8, !tbaa !20
  %.pre2747 = load i64, i64* %wlen, align 8, !tbaa !17
  br label %if.end1647

if.end1647:                                       ; preds = %if.then1607, %if.then1599
  %216 = phi i64 [ %.pre2747, %if.then1607 ], [ %209, %if.then1599 ]
  %217 = phi i8* [ %add.ptr1637, %if.then1607 ], [ %211, %if.then1599 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %217, i8* align 1 %pv.0, i64 %216, i1 false)
  %218 = load i64, i64* %wlen, align 8, !tbaa !17
  %219 = load i8*, i8** %aptr1601, align 8, !tbaa !19
  %add.ptr1653 = getelementptr inbounds i8, i8* %219, i64 %218
  store i8* %add.ptr1653, i8** %aptr1601, align 8, !tbaa !19
  br label %if.end1987

if.else1654:                                      ; preds = %if.then1596
  %call1656 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %210, i8* %pv.0, i64 %209) #7
  %220 = load i64, i64* %wlen, align 8, !tbaa !17
  %cmp1657.not = icmp eq i64 %call1656, %220
  br i1 %cmp1657.not, label %if.end1987, label %cleanup1988

if.else1666:                                      ; preds = %if.else1458
  %fio1667 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 23
  %221 = load %struct._PerlIO**, %struct._PerlIO*** %fio1667, align 8, !tbaa !18
  %tobool1668.not = icmp eq %struct._PerlIO** %221, null
  br i1 %tobool1668.not, label %if.then1669, label %if.else1724

if.then1669:                                      ; preds = %if.else1666
  %aptr1671 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %222 = load i8*, i8** %aptr1671, align 8, !tbaa !19
  %aend1673 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %223 = load i8*, i8** %aend1673, align 8, !tbaa !20
  %cmp1674 = icmp ult i8* %222, %223
  br i1 %cmp1674, label %if.end1731.sink.split, label %if.else1680

if.else1680:                                      ; preds = %if.then1669
  %asiz1683 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %224 = load i64, i64* %asiz1683, align 8, !tbaa !21
  %arena1692 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %225 = load i8*, i8** %arena1692, align 8, !tbaa !22
  %sub.ptr.lhs.cast1693 = ptrtoint i8* %222 to i64
  %sub.ptr.rhs.cast1694 = ptrtoint i8* %225 to i64
  %sub.ptr.sub1695 = sub i64 %sub.ptr.lhs.cast1693, %sub.ptr.rhs.cast1694
  %226 = shl i64 %224, 32
  %conv1687 = add i64 %226, 35184372088832
  %sext2680 = ashr exact i64 %conv1687, 32
  %conv1699 = and i64 %sext2680, -8192
  %call1701 = call i8* @Perl_safesysrealloc(i8* %225, i64 %conv1699) #7
  store i8* %call1701, i8** %arena1692, align 8, !tbaa !22
  store i64 %conv1699, i64* %asiz1683, align 8, !tbaa !21
  %sext2681 = shl i64 %sub.ptr.sub1695, 32
  %idx.ext1709 = ashr exact i64 %sext2681, 32
  %add.ptr1710 = getelementptr inbounds i8, i8* %call1701, i64 %idx.ext1709
  %add.ptr1717 = getelementptr inbounds i8, i8* %call1701, i64 %conv1699
  store i8* %add.ptr1717, i8** %aend1673, align 8, !tbaa !20
  br label %if.end1731.sink.split

if.else1724:                                      ; preds = %if.else1666
  %call1726 = call i32 @PerlIO_putc(%struct._PerlIO** nonnull %221, i32 1) #7
  %cmp1727 = icmp eq i32 %call1726, -1
  br i1 %cmp1727, label %cleanup1988, label %if.end1731

if.end1731.sink.split:                            ; preds = %if.else1680, %if.then1669
  %.sink2767 = phi i8* [ %add.ptr1710, %if.else1680 ], [ %222, %if.then1669 ]
  %incdec.ptr1679 = getelementptr inbounds i8, i8* %.sink2767, i64 1
  store i8* %incdec.ptr1679, i8** %aptr1671, align 8, !tbaa !19
  store i8 1, i8* %.sink2767, align 1, !tbaa !23
  br label %if.end1731

if.end1731:                                       ; preds = %if.end1731.sink.split, %if.else1724
  %netorder1732 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 11
  %227 = load i32, i32* %netorder1732, align 8, !tbaa !24
  %tobool1733.not = icmp eq i32 %227, 0
  br i1 %tobool1733.not, label %if.else1834, label %if.then1734

if.then1734:                                      ; preds = %if.end1731
  %228 = bitcast i32* %y1735 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %228) #5
  %229 = load i64, i64* %wlen, align 8, !tbaa !17
  %conv1738 = trunc i64 %229 to i32
  %230 = call i32 asm "bswap $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %conv1738) #8, !srcloc !44
  store i32 %230, i32* %y1735, align 4, !tbaa !26
  %231 = load %struct._PerlIO**, %struct._PerlIO*** %fio1667, align 8, !tbaa !18
  %tobool1755.not = icmp eq %struct._PerlIO** %231, null
  br i1 %tobool1755.not, label %if.then1756, label %if.else1823

if.then1756:                                      ; preds = %if.then1734
  %aptr1758 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %232 = load i8*, i8** %aptr1758, align 8, !tbaa !19
  %add.ptr1759 = getelementptr inbounds i8, i8* %232, i64 4
  %aend1761 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %233 = load i8*, i8** %aend1761, align 8, !tbaa !20
  %cmp1762 = icmp ugt i8* %add.ptr1759, %233
  br i1 %cmp1762, label %if.then1764, label %if.end1804

if.then1764:                                      ; preds = %if.then1756
  %asiz1767 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %234 = load i64, i64* %asiz1767, align 8, !tbaa !21
  %arena1776 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %235 = load i8*, i8** %arena1776, align 8, !tbaa !22
  %sub.ptr.lhs.cast1777 = ptrtoint i8* %232 to i64
  %sub.ptr.rhs.cast1778 = ptrtoint i8* %235 to i64
  %sub.ptr.sub1779 = sub i64 %sub.ptr.lhs.cast1777, %sub.ptr.rhs.cast1778
  %236 = shl i64 %234, 32
  %conv1771 = add i64 %236, 35197256990720
  %sext2686 = ashr exact i64 %conv1771, 32
  %conv1783 = and i64 %sext2686, -8192
  %call1785 = call i8* @Perl_safesysrealloc(i8* %235, i64 %conv1783) #7
  store i8* %call1785, i8** %arena1776, align 8, !tbaa !22
  store i64 %conv1783, i64* %asiz1767, align 8, !tbaa !21
  %sext2687 = shl i64 %sub.ptr.sub1779, 32
  %idx.ext1793 = ashr exact i64 %sext2687, 32
  %add.ptr1794 = getelementptr inbounds i8, i8* %call1785, i64 %idx.ext1793
  store i8* %add.ptr1794, i8** %aptr1758, align 8, !tbaa !19
  %add.ptr1801 = getelementptr inbounds i8, i8* %call1785, i64 %conv1783
  store i8* %add.ptr1801, i8** %aend1761, align 8, !tbaa !20
  br label %if.end1804

if.end1804:                                       ; preds = %if.then1764, %if.then1756
  %237 = phi i8* [ %add.ptr1794, %if.then1764 ], [ %232, %if.then1756 ]
  %238 = ptrtoint i8* %237 to i64
  %and1809 = and i64 %238, -4
  %cmp1810 = icmp eq i64 %and1809, %238
  %239 = bitcast i8* %237 to i32*
  br i1 %cmp1810, label %if.then1812, label %if.else1815

if.then1812:                                      ; preds = %if.end1804
  store i32 %230, i32* %239, align 4, !tbaa !26
  br label %if.end1818

if.else1815:                                      ; preds = %if.end1804
  store i32 %230, i32* %239, align 1
  %.pre2744 = load i8*, i8** %aptr1758, align 8, !tbaa !19
  br label %if.end1818

if.end1818:                                       ; preds = %if.else1815, %if.then1812
  %240 = phi i8* [ %.pre2744, %if.else1815 ], [ %237, %if.then1812 ]
  %add.ptr1822 = getelementptr inbounds i8, i8* %240, i64 4
  store i8* %add.ptr1822, i8** %aptr1758, align 8, !tbaa !19
  br label %if.end1830

if.else1823:                                      ; preds = %if.then1734
  %call1825 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %231, i8* nonnull %228, i64 4) #7
  %cmp1826.not = icmp eq i64 %call1825, 4
  br i1 %cmp1826.not, label %if.end1830, label %cleanup1831

if.end1830:                                       ; preds = %if.else1823, %if.end1818
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %228) #5
  br label %if.end1913

cleanup1831:                                      ; preds = %if.else1823
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %228) #5
  br label %cleanup1988

if.else1834:                                      ; preds = %if.end1731
  %241 = load %struct._PerlIO**, %struct._PerlIO*** %fio1667, align 8, !tbaa !18
  %tobool1836.not = icmp eq %struct._PerlIO** %241, null
  br i1 %tobool1836.not, label %if.then1837, label %if.else1905

if.then1837:                                      ; preds = %if.else1834
  %aptr1839 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %242 = load i8*, i8** %aptr1839, align 8, !tbaa !19
  %add.ptr1840 = getelementptr inbounds i8, i8* %242, i64 4
  %aend1842 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %243 = load i8*, i8** %aend1842, align 8, !tbaa !20
  %cmp1843 = icmp ugt i8* %add.ptr1840, %243
  br i1 %cmp1843, label %if.then1845, label %if.end1885

if.then1845:                                      ; preds = %if.then1837
  %asiz1848 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %244 = load i64, i64* %asiz1848, align 8, !tbaa !21
  %arena1857 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %245 = load i8*, i8** %arena1857, align 8, !tbaa !22
  %sub.ptr.lhs.cast1858 = ptrtoint i8* %242 to i64
  %sub.ptr.rhs.cast1859 = ptrtoint i8* %245 to i64
  %sub.ptr.sub1860 = sub i64 %sub.ptr.lhs.cast1858, %sub.ptr.rhs.cast1859
  %246 = shl i64 %244, 32
  %conv1852 = add i64 %246, 35197256990720
  %sext2684 = ashr exact i64 %conv1852, 32
  %conv1864 = and i64 %sext2684, -8192
  %call1866 = call i8* @Perl_safesysrealloc(i8* %245, i64 %conv1864) #7
  store i8* %call1866, i8** %arena1857, align 8, !tbaa !22
  store i64 %conv1864, i64* %asiz1848, align 8, !tbaa !21
  %sext2685 = shl i64 %sub.ptr.sub1860, 32
  %idx.ext1874 = ashr exact i64 %sext2685, 32
  %add.ptr1875 = getelementptr inbounds i8, i8* %call1866, i64 %idx.ext1874
  store i8* %add.ptr1875, i8** %aptr1839, align 8, !tbaa !19
  %add.ptr1882 = getelementptr inbounds i8, i8* %call1866, i64 %conv1864
  store i8* %add.ptr1882, i8** %aend1842, align 8, !tbaa !20
  br label %if.end1885

if.end1885:                                       ; preds = %if.then1845, %if.then1837
  %247 = phi i8* [ %add.ptr1875, %if.then1845 ], [ %242, %if.then1837 ]
  %248 = ptrtoint i8* %247 to i64
  %and1890 = and i64 %248, -4
  %cmp1891 = icmp eq i64 %and1890, %248
  br i1 %cmp1891, label %if.then1893, label %if.else1897

if.then1893:                                      ; preds = %if.end1885
  %249 = load i64, i64* %wlen, align 8, !tbaa !17
  %conv1894 = trunc i64 %249 to i32
  %250 = bitcast i8* %247 to i32*
  store i32 %conv1894, i32* %250, align 4, !tbaa !26
  br label %if.end1900

if.else1897:                                      ; preds = %if.end1885
  %251 = bitcast i64* %wlen to i32*
  %252 = bitcast i8* %247 to i32*
  %253 = load i32, i32* %251, align 8
  store i32 %253, i32* %252, align 1
  %.pre2745 = load i8*, i8** %aptr1839, align 8, !tbaa !19
  br label %if.end1900

if.end1900:                                       ; preds = %if.else1897, %if.then1893
  %254 = phi i8* [ %.pre2745, %if.else1897 ], [ %247, %if.then1893 ]
  %add.ptr1904 = getelementptr inbounds i8, i8* %254, i64 4
  store i8* %add.ptr1904, i8** %aptr1839, align 8, !tbaa !19
  br label %if.end1913

if.else1905:                                      ; preds = %if.else1834
  %255 = bitcast i64* %wlen to i8*
  %call1907 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %241, i8* nonnull %255, i64 8) #7
  %cmp1908.not = icmp eq i64 %call1907, 8
  br i1 %cmp1908.not, label %if.end1913, label %cleanup1988

if.end1913:                                       ; preds = %if.else1905, %if.end1900, %if.end1830
  %256 = load %struct._PerlIO**, %struct._PerlIO*** %fio1667, align 8, !tbaa !18
  %tobool1915.not = icmp eq %struct._PerlIO** %256, null
  br i1 %tobool1915.not, label %if.then1916, label %if.else1971

if.then1916:                                      ; preds = %if.end1913
  %aptr1918 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  %257 = load i8*, i8** %aptr1918, align 8, !tbaa !19
  %258 = load i64, i64* %wlen, align 8, !tbaa !17
  %add.ptr1919 = getelementptr inbounds i8, i8* %257, i64 %258
  %aend1921 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 3
  %259 = load i8*, i8** %aend1921, align 8, !tbaa !20
  %cmp1922 = icmp ugt i8* %add.ptr1919, %259
  br i1 %cmp1922, label %if.then1924, label %if.end1964

if.then1924:                                      ; preds = %if.then1916
  %asiz1927 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 1
  %260 = load i64, i64* %asiz1927, align 8, !tbaa !21
  %add1928 = add i64 %260, %258
  %arena1936 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 0
  %261 = load i8*, i8** %arena1936, align 8, !tbaa !22
  %sub.ptr.lhs.cast1937 = ptrtoint i8* %257 to i64
  %sub.ptr.rhs.cast1938 = ptrtoint i8* %261 to i64
  %sub.ptr.sub1939 = sub i64 %sub.ptr.lhs.cast1937, %sub.ptr.rhs.cast1938
  %262 = shl i64 %add1928, 32
  %conv1931 = add i64 %262, 35180077121536
  %sext2682 = ashr exact i64 %conv1931, 32
  %conv1943 = and i64 %sext2682, -8192
  %call1945 = call i8* @Perl_safesysrealloc(i8* %261, i64 %conv1943) #7
  store i8* %call1945, i8** %arena1936, align 8, !tbaa !22
  store i64 %conv1943, i64* %asiz1927, align 8, !tbaa !21
  %sext2683 = shl i64 %sub.ptr.sub1939, 32
  %idx.ext1953 = ashr exact i64 %sext2683, 32
  %add.ptr1954 = getelementptr inbounds i8, i8* %call1945, i64 %idx.ext1953
  store i8* %add.ptr1954, i8** %aptr1918, align 8, !tbaa !19
  %add.ptr1961 = getelementptr inbounds i8, i8* %call1945, i64 %conv1943
  store i8* %add.ptr1961, i8** %aend1921, align 8, !tbaa !20
  %.pre2746 = load i64, i64* %wlen, align 8, !tbaa !17
  br label %if.end1964

if.end1964:                                       ; preds = %if.then1924, %if.then1916
  %263 = phi i64 [ %.pre2746, %if.then1924 ], [ %258, %if.then1916 ]
  %264 = phi i8* [ %add.ptr1954, %if.then1924 ], [ %257, %if.then1916 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %264, i8* align 1 %pv.0, i64 %263, i1 false)
  %265 = load i64, i64* %wlen, align 8, !tbaa !17
  %266 = load i8*, i8** %aptr1918, align 8, !tbaa !19
  %add.ptr1970 = getelementptr inbounds i8, i8* %266, i64 %265
  store i8* %add.ptr1970, i8** %aptr1918, align 8, !tbaa !19
  br label %if.end1987

if.else1971:                                      ; preds = %if.end1913
  %267 = load i64, i64* %wlen, align 8, !tbaa !17
  %call1973 = call i64 @Perl_PerlIO_write(%struct._PerlIO** nonnull %256, i8* %pv.0, i64 %267) #7
  %268 = load i64, i64* %wlen, align 8, !tbaa !17
  %cmp1974.not = icmp eq i64 %call1973, %268
  br i1 %cmp1974.not, label %if.end1987, label %cleanup1988

if.else1981:                                      ; preds = %if.else918
  %s_dirty = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 18
  store i32 1, i32* %s_dirty, align 8, !tbaa !45
  %call1982 = tail call i8* @Perl_sv_reftype(%struct.sv* nonnull %sv, i32 0) #7
  %269 = ptrtoint %struct.sv* %sv to i64
  tail call void (i8*, ...) @Perl_croak(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.43.4124, i64 0, i64 0), i8* %call1982, i64 %269) #7
  br label %if.end1987

if.end1987:                                       ; preds = %if.else1981, %if.else1971, %if.end1964, %if.else1654, %if.end1647, %if.end1594, %if.else1449, %if.end1442, %if.else1133, %if.end1126, %if.end1073, %cleanup915.thread2734, %if.else720, %if.end713, %if.end593, %if.else425, %if.else381, %if.then377, %if.else246, %if.else202, %if.then198, %if.else177, %if.else133, %if.then129
  br label %cleanup1988

cleanup1988:                                      ; preds = %if.end1987, %if.else1971, %if.else1905, %cleanup1831, %if.else1724, %if.else1654, %if.else1586, %if.else1521, %if.else1449, %if.else1383, %cleanup1309, %if.else1203, %if.else1133, %if.else1065, %if.else1000, %cleanup915.thread, %if.else720, %if.else655, %cleanup594, %if.else425, %if.else360, %if.else246, %if.else177, %if.end111, %if.else103, %if.else37
  %retval.10 = phi i32 [ 0, %if.end1987 ], [ -1, %cleanup1309 ], [ -1, %cleanup1831 ], [ -1, %cleanup594 ], [ 0, %if.end111 ], [ -1, %if.else37 ], [ -1, %if.else103 ], [ -1, %if.else177 ], [ -1, %if.else246 ], [ -1, %if.else425 ], [ -1, %if.else360 ], [ -1, %if.else655 ], [ -1, %if.else720 ], [ -1, %if.else1133 ], [ -1, %if.else1065 ], [ -1, %if.else1000 ], [ -1, %if.else1203 ], [ -1, %if.else1383 ], [ -1, %if.else1449 ], [ -1, %if.else1654 ], [ -1, %if.else1586 ], [ -1, %if.else1521 ], [ -1, %if.else1724 ], [ -1, %if.else1905 ], [ -1, %if.else1971 ], [ -1, %cleanup915.thread ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %1) #5
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %0) #5
  ret i32 %retval.10
}

; Function Attrs: noinline nounwind optsize uwtable
declare hidden fastcc %struct.sv* @pkg_can(%struct.hv*, %struct.hv*, i8*) unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare hidden fastcc i32 @store_hook(%struct.stcxt*, %struct.sv*, i32, %struct.hv*, %struct.sv*) unnamed_addr #3

; Function Attrs: noinline nounwind optsize uwtable
declare hidden fastcc i32 @known_class(%struct.stcxt* nocapture, i8*, i32, i64* nocapture) unnamed_addr #3

attributes #0 = { argmemonly nofree nounwind willreturn }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly mustprogress nofree nounwind optsize readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { optsize }
attributes #7 = { nounwind optsize }
attributes #8 = { nounwind readnone }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 13.0.0 (git@github.com:ppetoumenos/llvm-project.git 70a9fb72f98c9897c164fba3d27e76821498d6e1)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !9, i64 56}
!5 = !{!"stcxt", !6, i64 0, !6, i64 4, !9, i64 8, !9, i64 16, !9, i64 24, !10, i64 32, !9, i64 40, !9, i64 48, !9, i64 56, !10, i64 64, !10, i64 72, !6, i64 80, !6, i64 84, !6, i64 88, !6, i64 92, !9, i64 96, !6, i64 104, !6, i64 108, !6, i64 112, !6, i64 116, !11, i64 120, !11, i64 152, !11, i64 184, !9, i64 216, !6, i64 224, !6, i64 228, !9, i64 232, !9, i64 240, !9, i64 248}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"any pointer", !7, i64 0}
!10 = !{!"long", !7, i64 0}
!11 = !{!"extendable", !9, i64 0, !10, i64 8, !9, i64 16, !9, i64 24}
!12 = !{!13, !9, i64 0}
!13 = !{!"hv", !9, i64 0, !10, i64 8, !10, i64 16}
!14 = !{!15, !9, i64 80}
!15 = !{!"xpvhv", !9, i64 0, !10, i64 8, !10, i64 16, !10, i64 24, !16, i64 32, !9, i64 40, !9, i64 48, !10, i64 56, !9, i64 64, !9, i64 72, !9, i64 80}
!16 = !{!"double", !7, i64 0}
!17 = !{!10, !10, i64 0}
!18 = !{!5, !9, i64 216}
!19 = !{!5, !9, i64 168}
!20 = !{!5, !9, i64 176}
!21 = !{!5, !10, i64 160}
!22 = !{!5, !9, i64 152}
!23 = !{!7, !7, i64 0}
!24 = !{!5, !6, i64 80}
!25 = !{i32 -2145002907}
!26 = !{!6, !6, i64 0}
!27 = !{i32 -2144995056}
!28 = !{!9, !9, i64 0}
!29 = !{!30, !10, i64 16}
!30 = !{!"sv", !9, i64 0, !10, i64 8, !10, i64 16}
!31 = !{!30, !9, i64 0}
!32 = !{!33, !10, i64 8}
!33 = !{!"xpv", !9, i64 0, !10, i64 8, !10, i64 16}
!34 = !{!33, !9, i64 0}
!35 = !{!36, !10, i64 24}
!36 = !{!"xpviv", !9, i64 0, !10, i64 8, !10, i64 16, !10, i64 24}
!37 = !{!38, !10, i64 24}
!38 = !{!"xpvuv", !9, i64 0, !10, i64 8, !10, i64 16, !10, i64 24}
!39 = !{i32 -2145139054}
!40 = !{!41, !16, i64 32}
!41 = !{!"xpvnv", !9, i64 0, !10, i64 8, !10, i64 16, !10, i64 24, !16, i64 32}
!42 = !{!16, !16, i64 0}
!43 = !{i32 -2145122430}
!44 = !{i32 -2145111379}
!45 = !{!5, !6, i64 112}
