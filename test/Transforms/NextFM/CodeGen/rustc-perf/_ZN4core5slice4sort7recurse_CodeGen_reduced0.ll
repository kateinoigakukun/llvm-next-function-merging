; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      --- !Missed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            CodeGen
; CHECK-NEXT: Function:        _ZN4core5slice4sort7recurse17h84fd8028bd55c38bE
; CHECK-NEXT: Args:
; CHECK-NEXT:   - Reason:          Something went wrong
; ModuleID = 'test/Transforms/NextFM/CodeGen/rustc-perf/_ZN4core5slice4sort7recurse_CodeGen.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }

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

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.umin.i64(i64, i64) #4

define hidden fastcc void @_ZN4core5slice4sort7recurse17h84fd8028bd55c38bE() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = alloca [24 x i64], align 8
  br label %end_bb

orphan:                                           ; No predecessors!
  br label %end_bb

end_bb:                                           ; preds = %orphan, %0
  ret void
}

define hidden fastcc void @_ZN4core5slice4sort7recurse17h37cd075f67b5ff92E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = alloca [24 x i64], align 8
  ret void
}

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
