; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      --- !Missed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            CodeGen
; CHECK-NEXT: Function:        _ZN4core5slice4sort7recurse17h84fd8028bd55c38bE
; CHECK-NEXT: Args:
; CHECK-NEXT:   - Reason:          Something went wrong
; ModuleID = '/tmp/llvm-reduce-4e84e3.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"regalloc::linear_scan::analysis::RangeFrag" = type { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>", i32, i32, i8, [7 x i8] }
%"smallvec::SmallVec<[ir::entities::Value; 4]>" = type { i64, %"smallvec::SmallVecData<[ir::entities::Value; 4]>" }
%"smallvec::SmallVecData<[ir::entities::Value; 4]>" = type { i32, [5 x i32] }
%"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" = type { i64, %"smallvec::SmallVecData<[(regalloc::data_structures::InstIx, usize); 8]>" }
%"smallvec::SmallVecData<[(regalloc::data_structures::InstIx, usize); 8]>" = type { i64, [16 x i64] }
%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }

; Function Attrs: inaccessiblememonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #0

; Function Attrs: nofree norecurse nosync nounwind readonly
define hidden fastcc void @_ZN4core5slice4sort7recurse17h84fd8028bd55c38bE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* nocapture readonly %0, i64 %1) unnamed_addr #1 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %3 = lshr i64 %1, 1
  %4 = and i64 %3, 9223372036854775806
  %5 = icmp ugt i64 %1, 49
  br i1 %5, label %12, label %6

6:                                                ; preds = %12, %2
  %7 = phi i64 [ %4, %2 ], [ %19, %12 ]
  %8 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %0, i64 0, i64 %7, i32 2
  %9 = load i32, i32* %8, align 8, !alias.scope !0, !noalias !3
  %10 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %0, i64 0, i64 undef, i32 2
  %11 = load i32, i32* %10, align 8, !alias.scope !0, !noalias !13
  %.not = icmp ult i32 %11, %9
  br i1 %.not, label %.preheader, label %20

12:                                               ; preds = %2
  %13 = add nsw i64 %4, -1
  %14 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %0, i64 0, i64 %4, i32 2
  %15 = load i32, i32* %14, align 8, !alias.scope !0, !noalias !18
  %16 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %0, i64 0, i64 %13, i32 2
  %17 = load i32, i32* %16, align 8, !alias.scope !0, !noalias !18
  %18 = icmp ult i32 %15, %17
  %19 = select i1 %18, i64 %4, i64 %13
  br label %6

.preheader:                                       ; preds = %6, %.preheader
  br label %.preheader

20:                                               ; preds = %6
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind willreturn
define hidden fastcc void @_ZN4core5slice4sort7recurse17h37cd075f67b5ff92E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* nocapture readonly %0, i64 %1) unnamed_addr #2 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %3 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %0, i64 0, i64 0, i32 2
  %4 = load i32, i32* %3, align 8, !alias.scope !31, !noalias !34
  %5 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %0, i64 0, i64 undef, i32 2
  %6 = load i32, i32* %5, align 8, !alias.scope !31, !noalias !44
  %7 = icmp uge i32 %6, %4
  tail call void @llvm.assume(i1 %7)
  ret void
}

attributes #0 = { inaccessiblememonly mustprogress nofree nosync nounwind willreturn }
attributes #1 = { nofree norecurse nosync nounwind readonly }
attributes #2 = { mustprogress nofree nosync nounwind willreturn }

!0 = !{!1}
!1 = distinct !{!1, !2, !"_ZN4core5slice4sort12choose_pivot17h7f2fcb297a703dedE: argument 0"}
!2 = distinct !{!2, !"_ZN4core5slice4sort12choose_pivot17h7f2fcb297a703dedE"}
!3 = !{!4, !6, !7, !8, !10, !11, !12}
!4 = distinct !{!4, !5, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!5 = distinct !{!5, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!6 = distinct !{!6, !5, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!7 = distinct !{!7, !5, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!8 = distinct !{!8, !9, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 0"}
!9 = distinct !{!9, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E"}
!10 = distinct !{!10, !9, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 1"}
!11 = distinct !{!11, !9, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 2"}
!12 = distinct !{!12, !9, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 3"}
!13 = !{!14, !16, !17, !8, !10, !11, !12}
!14 = distinct !{!14, !15, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!15 = distinct !{!15, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!16 = distinct !{!16, !15, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!17 = distinct !{!17, !15, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!18 = !{!19, !21, !22, !23, !25, !26, !27, !28, !30}
!19 = distinct !{!19, !20, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!20 = distinct !{!20, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!21 = distinct !{!21, !20, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!22 = distinct !{!22, !20, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!23 = distinct !{!23, !24, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 0"}
!24 = distinct !{!24, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E"}
!25 = distinct !{!25, !24, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 1"}
!26 = distinct !{!26, !24, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 2"}
!27 = distinct !{!27, !24, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 3"}
!28 = distinct !{!28, !29, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 0"}
!29 = distinct !{!29, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE"}
!30 = distinct !{!30, !29, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 1"}
!31 = !{!32}
!32 = distinct !{!32, !33, !"_ZN4core5slice4sort12choose_pivot17he7ac1307dfa88db3E: argument 0"}
!33 = distinct !{!33, !"_ZN4core5slice4sort12choose_pivot17he7ac1307dfa88db3E"}
!34 = !{!35, !37, !38, !39, !41, !42, !43}
!35 = distinct !{!35, !36, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!36 = distinct !{!36, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!37 = distinct !{!37, !36, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!38 = distinct !{!38, !36, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!39 = distinct !{!39, !40, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 0"}
!40 = distinct !{!40, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E"}
!41 = distinct !{!41, !40, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 1"}
!42 = distinct !{!42, !40, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 2"}
!43 = distinct !{!43, !40, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 3"}
!44 = !{!45, !47, !48, !39, !41, !42, !43}
!45 = distinct !{!45, !46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!46 = distinct !{!46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!47 = distinct !{!47, !46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!48 = distinct !{!48, !46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
