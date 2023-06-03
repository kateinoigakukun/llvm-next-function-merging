; RUN: %opt -o %t.baseline.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw --multiple-func-merging-size-estimation=exact -o %t.mfm-hyfm.bc %s
; RUN: %llc --filetype=obj %t.baseline.bc -o %t.baseline.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.baseline.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -le $(stat -c%%s %t.baseline.o)
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006/400.perlbench/main_._all_._files_._linked.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.sv = type { i8*, i64, i64 }
%struct.gv = type { %struct.xpvgv*, i64, i64 }
%struct.xpvgv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.gp*, i8*, i64, %struct.hv*, i8 }
%struct.magic = type { %struct.magic*, %struct.mgvtbl*, i16, i8, i8, %struct.sv*, i8*, i64 }
%struct.mgvtbl = type { i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i64 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*)*, i32 (%struct.sv*, %struct.magic*, %struct.sv*, i8*, i32)*, i32 (%struct.magic*, %struct.clone_params*)* }
%struct.clone_params = type { %struct.av*, i64, %struct.interpreter* }
%struct.av = type { %struct.xpvav*, i64, i64 }
%struct.xpvav = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.sv**, %struct.sv*, i8 }
%struct.interpreter = type { i8 }
%struct.gp = type { %struct.sv*, i64, %struct.io*, %struct.cv*, %struct.av*, %struct.hv*, %struct.gv*, %struct.cv*, i64, i64, i64, i8* }
%struct.io = type { %struct.xpvio*, i64, i64 }
%struct.xpvio = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct._PerlIO**, %struct._PerlIO**, %union.anon.0, i64, i64, i64, i64, i8*, %struct.gv*, i8*, %struct.gv*, i8*, %struct.gv*, i16, i8, i8 }
%struct._PerlIO = type { %struct._PerlIO*, %struct._PerlIO_funcs*, i64 }
%struct._PerlIO_funcs = type { i64, i8*, i64, i64, i64 (%struct._PerlIO**, i8*, %struct.sv*, %struct._PerlIO_funcs*)*, i64 (%struct._PerlIO**)*, %struct._PerlIO** (%struct._PerlIO_funcs*, %struct.PerlIO_list_s*, i64, i8*, i32, i32, i32, %struct._PerlIO**, i32, %struct.sv**)*, i64 (%struct._PerlIO**)*, %struct.sv* (%struct._PerlIO**, %struct.clone_params*, i32)*, i64 (%struct._PerlIO**)*, %struct._PerlIO** (%struct._PerlIO**, %struct._PerlIO**, %struct.clone_params*, i32)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i8*, i64)*, i64 (%struct._PerlIO**, i64, i32)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, void (%struct._PerlIO**)*, void (%struct._PerlIO**)*, i8* (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, i8* (%struct._PerlIO**)*, i64 (%struct._PerlIO**)*, void (%struct._PerlIO**, i8*, i64)* }
%struct.PerlIO_list_s = type { i64, i64, i64, %struct.PerlIO_pair_t* }
%struct.PerlIO_pair_t = type { %struct._PerlIO_funcs*, %struct.sv* }
%union.anon.0 = type { %struct.__dirstream* }
%struct.__dirstream = type opaque
%struct.cv = type { %struct.xpvcv*, i64, i64 }
%struct.xpvcv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, %struct.hv*, %struct.op*, %struct.op*, void (%struct.cv*)*, %union.any, %struct.gv*, i8*, i64, %struct.av*, %struct.cv*, i16, i64 }
%struct.op = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8 }
%union.any = type { i8* }
%struct.hv = type { %struct.xpvhv*, i64, i64 }
%struct.xpvhv = type { i8*, i64, i64, i64, double, %struct.magic*, %struct.hv*, i64, %struct.he*, %struct.pmop*, i8* }
%struct.he = type { %struct.he*, %struct.hek*, %struct.sv* }
%struct.hek = type { i64, i64, [1 x i8] }
%struct.pmop = type { %struct.op*, %struct.op*, %struct.op* ()*, i64, i16, i16, i8, i8, %struct.op*, %struct.op*, %struct.op*, %struct.op*, %struct.pmop*, %struct.regexp*, i64, i64, i8, %struct.hv* }
%struct.regexp = type { i64*, i64*, %struct.regnode*, %struct.reg_substr_data*, i8*, %struct.reg_data*, i8*, i64*, i64, i64, i64, i64, i64, i64, i64, i64, [1 x %struct.regnode] }
%struct.regnode = type { i8, i8, i16 }
%struct.reg_substr_data = type { [3 x %struct.reg_substr_datum] }
%struct.reg_substr_datum = type { i64, i64, %struct.sv*, %struct.sv* }
%struct.reg_data = type { i64, i8*, [1 x i8*] }

declare void @Perl_gv_fullname4(%struct.sv*, %struct.gv*) local_unnamed_addr

define void @Perl_gv_efullname4(%struct.sv* %sv, %struct.gv* %gv) local_unnamed_addr {
entry:
  %0 = load %struct.gv*, %struct.gv** undef, align 8, !tbaa !0
  %tobool.not = icmp eq %struct.gv* %0, null
  %spec.select = select i1 %tobool.not, %struct.gv* %gv, %struct.gv* %0
  call void @Perl_gv_fullname4(%struct.sv* %sv, %struct.gv* %spec.select)
  ret void
}

; Function Attrs: nounwind
define void @Perl_gv_fullname(%struct.sv* %sv, %struct.gv* %gv) local_unnamed_addr #0 {
entry:
  %0 = bitcast %struct.gv* %gv to %struct.sv*
  %cmp = icmp eq %struct.sv* %0, %sv
  %cond = select i1 %cmp, i8* poison, i8* poison
  call void @Perl_gv_fullname4(%struct.sv* %sv, %struct.gv* %gv)
  ret void
}

attributes #0 = { nounwind }

!0 = !{!1, !2, i64 48}
!1 = !{!"gp", !2, i64 0, !5, i64 8, !2, i64 16, !2, i64 24, !2, i64 32, !2, i64 40, !2, i64 48, !2, i64 56, !5, i64 64, !5, i64 72, !5, i64 80, !2, i64 88}
!2 = !{!"any pointer", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!"long", !3, i64 0}
