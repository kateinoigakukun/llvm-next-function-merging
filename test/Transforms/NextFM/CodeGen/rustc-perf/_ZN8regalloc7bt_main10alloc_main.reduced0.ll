; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      --- !Missed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            CodeGen
; ModuleID = 'test/Transforms/NextFM/CodeGen/rustc-perf/_ZN8regalloc7bt_main10alloc_main.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }
%"alloc::vec::Vec<regalloc::union_find::LLElem>" = type { { i32*, i64 }, i64 }
%"regalloc::union_find::UnionFindEquivClasses<regalloc::data_structures::VirtualRangeIx>" = type { %"core::marker::PhantomData<regalloc::data_structures::VirtualRangeIx>", %"alloc::vec::Vec<u32>", %"alloc::vec::Vec<regalloc::union_find::LLElem>" }
%"core::marker::PhantomData<regalloc::data_structures::VirtualRangeIx>" = type {}
%"alloc::vec::Vec<u32>" = type { { i32*, i64 }, i64 }
%"alloc::vec::Vec<regalloc::data_structures::VirtualReg>" = type { { i32*, i64 }, i64 }

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
  ret void

1:                                                ; No predecessors!
  br label %3

2:                                                ; No predecessors!
  ret void

3:                                                ; preds = %1
  %4 = getelementptr inbounds %"regalloc::union_find::UnionFindEquivClasses<regalloc::data_structures::VirtualRangeIx>", %"regalloc::union_find::UnionFindEquivClasses<regalloc::data_structures::VirtualRangeIx>"* undef, i64 0, i32 2
  ret void
}

define hidden void @_ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  ret void

1:                                                ; No predecessors!
  %2 = getelementptr inbounds %"alloc::vec::Vec<regalloc::data_structures::VirtualReg>", %"alloc::vec::Vec<regalloc::data_structures::VirtualReg>"* undef, i64 0, i32 0
  call void undef({ i32*, i64 }* %2)
  ret void
}

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
