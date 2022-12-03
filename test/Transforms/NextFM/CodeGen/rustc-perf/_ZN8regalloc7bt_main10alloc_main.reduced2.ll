; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 --multiple-func-merging-only=_ZN8regalloc7bt_main10alloc_main17hff001664e8376445E --multiple-func-merging-only=_ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E -o - -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      define internal void @__msa_merge__ZN8regalloc7bt_main10alloc_main17hff001664e8376445E__ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E(
; CHECK-NEXT: entry:
; CHECK-NEXT:   ret void
; CHECK-NEXT: }


; ModuleID = 'test/Transforms/NextFM/CodeGen/rustc-perf/_ZN8regalloc7bt_main10alloc_main.reduced.tmp.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }
%"alloc::vec::Vec<regalloc::data_structures::VirtualReg>" = type { { i32*, i64 }, i64 }
%"alloc::vec::Vec<i32>" = type { { i32*, i64 }, i64 }

declare hidden void @_ZN8regalloc13analysis_main12run_analysis17h45759d65a021de6aE() unnamed_addr

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.experimental.noalias.scope.decl(metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #2

define hidden void @_ZN8regalloc7bt_main10alloc_main17hff001664e8376445E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = getelementptr inbounds %"alloc::vec::Vec<regalloc::data_structures::VirtualReg>", %"alloc::vec::Vec<regalloc::data_structures::VirtualReg>"* undef, i64 0, i32 0, i32 1
  %2 = bitcast i64* %1 to i8*
  ret void
}

declare hidden void @_ZN8regalloc13analysis_main12run_analysis17h728621e09b968141E() unnamed_addr

define hidden void @_ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = getelementptr inbounds %"alloc::vec::Vec<i32>", %"alloc::vec::Vec<i32>"* undef, i64 0, i32 0, i32 1
  %2 = bitcast i64* %1 to i8*
  ret void
}

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
