; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=store_blessed --multiple-func-merging-only=store_scalar -o %t.mfm.ll %s
; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=store_blessed --multiple-func-merging-only=store_scalar --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.ll -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/0_multiple-func-merging_UnprofitableMerge.ll'
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

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

declare i64 @strlen() local_unnamed_addr

declare i64 @Perl_PerlIO_write() local_unnamed_addr

declare i32 @PerlIO_putc() local_unnamed_addr

define hidden fastcc i32 @store_blessed(%struct.stcxt* %cxt) unnamed_addr {
if.then54:
  br i1 undef, label %if.then58, label %if.else113

if.then58:                                        ; preds = %if.then54
  %aptr60 = getelementptr inbounds %struct.stcxt, %struct.stcxt* %cxt, i64 0, i32 21, i32 2
  br label %if.then65

if.then65:                                        ; preds = %if.then58
  store i8* undef, i8** %aptr60, align 8, !tbaa !0
  ret i32 undef

if.else113:                                       ; preds = %if.then54
  %0 = trunc i64 undef to i32
  ret i32 undef
}

define hidden i32 @store_scalar(%struct.stcxt* %cxt) {
if.then48:
  br label %if.then55

if.then55:                                        ; preds = %if.then48
  ret i32 undef
}

declare hidden fastcc %struct.sv* @pkg_can() unnamed_addr

declare hidden fastcc i32 @store_hook() unnamed_addr

declare hidden fastcc i32 @known_class() unnamed_addr

attributes #0 = { argmemonly nofree nounwind willreturn }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }

!0 = !{!1, !5, i64 168}
!1 = !{!"stcxt", !2, i64 0, !2, i64 4, !5, i64 8, !5, i64 16, !5, i64 24, !6, i64 32, !5, i64 40, !5, i64 48, !5, i64 56, !6, i64 64, !6, i64 72, !2, i64 80, !2, i64 84, !2, i64 88, !2, i64 92, !5, i64 96, !2, i64 104, !2, i64 108, !2, i64 112, !2, i64 116, !7, i64 120, !7, i64 152, !7, i64 184, !5, i64 216, !2, i64 224, !2, i64 228, !5, i64 232, !5, i64 240, !5, i64 248}
!2 = !{!"int", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!"any pointer", !3, i64 0}
!6 = !{!"long", !3, i64 0}
!7 = !{!"extendable", !5, i64 0, !6, i64 8, !5, i64 16, !5, i64 24}
