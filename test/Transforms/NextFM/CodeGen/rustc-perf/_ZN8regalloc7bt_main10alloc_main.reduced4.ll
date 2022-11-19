; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 --multiple-func-merging-shape-limit=41943040 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging %s 2>&1 | FileCheck %s
; CHECK-NOT: PHI node operands are not the same type as the result!
; ModuleID = 'test/Transforms/NextFM/CodeGen/rustc-perf/_ZN8regalloc7bt_main10alloc_main.reduced4.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }
%"core::marker::PhantomData<fx::FxHasher>" = type {}
%"core::result::Result<(), smallvec::CollectionAllocErr>" = type { i64, [2 x i64] }
%"alloc::vec::Vec<regalloc::data_structures::VirtualReg>" = type { { i32*, i64 }, i64 }
%"regalloc::data_structures::RealRegUniverse" = type { %"alloc::vec::Vec<(regalloc::data_structures::RealReg, alloc::string::String)>", i64, [5 x %"core::option::Option<regalloc::data_structures::RegClassInfo>"] }
%"alloc::vec::Vec<(regalloc::data_structures::RealReg, alloc::string::String)>" = type { { i64*, i64 }, i64 }
%"core::option::Option<regalloc::data_structures::RegClassInfo>" = type { [2 x i64], i64, [1 x i64] }

define hidden void @_ZN8regalloc7bt_main10alloc_main17hff001664e8376445E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = alloca %"core::marker::PhantomData<fx::FxHasher>", align 1
  %2 = alloca %"core::result::Result<(), smallvec::CollectionAllocErr>", align 8
  %3 = alloca %"core::result::Result<(), smallvec::CollectionAllocErr>", align 8
  %4 = alloca %"core::result::Result<(), smallvec::CollectionAllocErr>", align 8
  %5 = alloca %"core::result::Result<(), smallvec::CollectionAllocErr>", align 8
  ret void
}

define hidden void @_ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = alloca %"alloc::vec::Vec<regalloc::data_structures::VirtualReg>", align 8
  %2 = alloca %"regalloc::data_structures::RealRegUniverse"*, align 8
  br i1 undef, label %5, label %3

3:                                                ; preds = %0
  %4 = load i8, i8* undef, align 8, !range !0
  br label %5

5:                                                ; preds = %3, %0
  %6 = phi i8 [ %4, %3 ], [ 5, %0 ]
  %7 = phi %"alloc::vec::Vec<regalloc::data_structures::VirtualReg>"* [ undef, %3 ], [ %1, %0 ]
  ret void
}

!0 = !{i8 0, i8 6}
