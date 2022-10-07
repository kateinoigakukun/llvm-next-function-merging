; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s

; CHECK: --- !Passed

source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"core::panic::location::Location" = type { { [0 x i8]*, i64 }, i32, i32 }
%"regalloc::linear_scan::analysis::RangeFrag" = type { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>", i32, i32, i8, [7 x i8] }
%"smallvec::SmallVec<[ir::entities::Value; 4]>" = type { i64, %"smallvec::SmallVecData<[ir::entities::Value; 4]>" }
%"smallvec::SmallVecData<[ir::entities::Value; 4]>" = type { i32, [5 x i32] }
%"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" = type { i64, %"smallvec::SmallVecData<[(regalloc::data_structures::InstIx, usize); 8]>" }
%"smallvec::SmallVecData<[(regalloc::data_structures::InstIx, usize); 8]>" = type { i64, [16 x i64] }
%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }

@anon.b95475fadfab75acbbc31e70c5209b76.7 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.b95475fadfab75acbbc31e70c5209b76.8 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.b95475fadfab75acbbc31e70c5209b76.9 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.b95475fadfab75acbbc31e70c5209b76.11 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.b95475fadfab75acbbc31e70c5209b76.12 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.b95475fadfab75acbbc31e70c5209b76.13 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.b95475fadfab75acbbc31e70c5209b76.14 = external hidden unnamed_addr constant <{ [35 x i8] }>, align 1
@anon.d6c3d094ad60d520064373e3df1e5641.12 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.d6c3d094ad60d520064373e3df1e5641.13 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.d6c3d094ad60d520064373e3df1e5641.14 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.d6c3d094ad60d520064373e3df1e5641.16 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.d6c3d094ad60d520064373e3df1e5641.17 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.d6c3d094ad60d520064373e3df1e5641.18 = external hidden unnamed_addr constant <{ i8*, [16 x i8] }>, align 8
@anon.d6c3d094ad60d520064373e3df1e5641.19 = external hidden unnamed_addr constant <{ [35 x i8] }>, align 1

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

; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64, i64, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24)) unnamed_addr #4

; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core5slice5index26slice_start_index_len_fail17haac0d373d67dca37E(i64, i64, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24)) unnamed_addr #4

; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core5slice5index24slice_end_index_len_fail17h80e02ac829cd41f5E(i64, i64, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24)) unnamed_addr #4

; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking5panic17h97167cd315d19cd4E([0 x i8]* noalias nonnull readonly align 1, i64, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24)) unnamed_addr #4

; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core5slice5index22slice_index_order_fail17h79f274959805de1fE(i64, i64, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24)) unnamed_addr #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.umin.i64(i64, i64) #5

; Function Attrs: mustprogress nofree nosync nounwind nonlazybind uwtable willreturn
declare hidden void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17hb2cb5cf585b48469E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nocapture nonnull align 8, i64, i64, i64) unnamed_addr #6

; Function Attrs: nonlazybind uwtable
define hidden fastcc void @_ZN4core5slice4sort7recurse17h84fd8028bd55c38bE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %0, i64 %1, i8** noalias align 8 dereferenceable(8) %2, i64* noalias readonly align 8 dereferenceable_or_null(192) %3, i32 %4) unnamed_addr #7 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
  %6 = alloca [24 x i64], align 8
  %7 = alloca { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }, align 8
  %8 = alloca { i32, i8, [7 x i8] }, align 8
  %9 = alloca [24 x i64], align 8
  %10 = alloca [24 x i64], align 8
  %11 = alloca %"regalloc::linear_scan::analysis::RangeFrag", align 8
  %12 = alloca [128 x i8], align 1
  %13 = alloca [128 x i8], align 1
  %14 = alloca { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }, align 8
  %15 = alloca { i32, i8, [7 x i8] }, align 8
  %16 = alloca { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }, align 8
  %17 = alloca { i32, i8, [7 x i8] }, align 8
  %18 = bitcast { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }* %7 to i8*
  %19 = bitcast { i32, i8, [7 x i8] }* %8 to i8*
  %20 = bitcast [24 x i64]* %6 to i8*
  %21 = bitcast { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }* %14 to i8*
  %22 = bitcast { i32, i8, [7 x i8] }* %15 to i8*
  %23 = getelementptr inbounds [128 x i8], [128 x i8]* %13, i64 0, i64 0
  %24 = getelementptr inbounds [128 x i8], [128 x i8]* %12, i64 0, i64 0
  %25 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %11 to i8*
  %26 = bitcast [24 x i64]* %9 to i8*
  %27 = bitcast [24 x i64]* %10 to i8*
  %28 = icmp ult i64 %1, 21
  br i1 %28, label %46, label %29

29:                                               ; preds = %754, %5
  %30 = phi i1 [ %759, %754 ], [ true, %5 ]
  %31 = phi i1 [ %686, %754 ], [ false, %5 ]
  %32 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %757, %754 ], [ %0, %5 ]
  %33 = phi i64 [ %756, %754 ], [ %1, %5 ]
  %34 = phi i64* [ %755, %754 ], [ %3, %5 ]
  %35 = phi i32 [ %114, %754 ], [ %4, %5 ]
  %36 = icmp eq i64* %34, null
  %37 = getelementptr i64, i64* %34, i64 22
  %38 = bitcast i64* %37 to i32*
  br label %39

39:                                               ; preds = %740, %29
  %40 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %32, %29 ], [ %743, %740 ]
  %41 = phi i64 [ %33, %29 ], [ %742, %740 ]
  %42 = phi i32 [ %35, %29 ], [ %114, %740 ]
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %108, label %109

44:                                               ; preds = %740
  %45 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %741 to [0 x %"regalloc::linear_scan::analysis::RangeFrag"]*
  br label %46

46:                                               ; preds = %754, %44, %5
  %47 = phi i64 [ %1, %5 ], [ %742, %44 ], [ %756, %754 ]
  %48 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %0, %5 ], [ %45, %44 ], [ %757, %754 ]
  call void @llvm.experimental.noalias.scope.decl(metadata !4)
  %49 = bitcast { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }* %16 to i8*
  %50 = bitcast { i32, i8, [7 x i8] }* %17 to i8*
  %51 = icmp ugt i64 %47, 1
  br i1 %51, label %52, label %107

52:                                               ; preds = %105, %46
  %53 = phi i64 [ %54, %105 ], [ 1, %46 ]
  %54 = add nuw i64 %53, 1
  call void @llvm.experimental.noalias.scope.decl(metadata !7)
  %55 = add i64 %53, -1
  %56 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %53, i32 2
  %57 = load i32, i32* %56, align 8, !alias.scope !10
  %58 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %55, i32 2
  %59 = load i32, i32* %58, align 8, !alias.scope !10
  %60 = icmp ult i32 %57, %59
  br i1 %60, label %68, label %105

61:                                               ; preds = %316, %63
  %62 = phi { i8*, i32 } [ %64, %63 ], [ %317, %316 ]
  resume { i8*, i32 } %62

63:                                               ; preds = %68
  %64 = landingpad { i8*, i32 }
          cleanup
  %65 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %73 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %65, i8* noundef nonnull align 8 dereferenceable(176) %49, i64 176, i1 false), !noalias !11
  store i32 %57, i32* %58, align 8, !alias.scope !10, !noalias !11
  %66 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %55, i32 3
  %67 = bitcast i32* %66 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %67, i8* noundef nonnull align 8 dereferenceable(12) %50, i64 12, i1 false), !noalias !11
  br label %61

68:                                               ; preds = %52
  %69 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %53
  call void @llvm.lifetime.start.p0i8(i64 176, i8* nonnull %49)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %50)
  %70 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %69 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %49, i8* noundef nonnull align 8 dereferenceable(176) %70, i64 176, i1 false)
  %71 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %53, i32 3
  %72 = bitcast i32* %71 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(12) %50, i8* noundef nonnull align 4 dereferenceable(12) %72, i64 12, i1 false)
  %73 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %55
  %74 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %73 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %70, i8* noundef nonnull align 8 dereferenceable(192) %74, i64 192, i1 false) #11, !alias.scope !10
  %75 = invoke { i64, i64 } @"_ZN4core4iter8adapters3rev12Rev$LT$T$GT$3new17h8f773365797c4ef1E"(i64 0, i64 %55)
          to label %76 unwind label %63, !noalias !10

76:                                               ; preds = %68
  %77 = extractvalue { i64, i64 } %75, 0
  %78 = extractvalue { i64, i64 } %75, 1
  %79 = icmp ult i64 %77, %78
  br i1 %79, label %80, label %85

80:                                               ; preds = %76
  %81 = add i64 %78, -1
  %82 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %81, i32 2
  %83 = load i32, i32* %82, align 8, !alias.scope !10
  %84 = icmp ult i32 %57, %83
  br i1 %84, label %97, label %85

85:                                               ; preds = %97, %92, %80, %76
  %86 = phi i64 [ %55, %76 ], [ %55, %80 ], [ %77, %97 ], [ %98, %92 ]
  %87 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %86, i32 0, i32 0
  %88 = bitcast i64* %87 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %88, i8* noundef nonnull align 8 dereferenceable(176) %49, i64 176, i1 false), !noalias !14
  %89 = getelementptr inbounds i64, i64* %87, i64 22
  %90 = bitcast i64* %89 to i32*
  store i32 %57, i32* %90, align 8, !alias.scope !10, !noalias !14
  %91 = getelementptr inbounds i8, i8* %88, i64 180
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %91, i8* noundef nonnull align 8 dereferenceable(12) %50, i64 12, i1 false), !noalias !14
  call void @llvm.lifetime.end.p0i8(i64 176, i8* nonnull %49)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %50)
  br label %105

92:                                               ; preds = %97
  %93 = add i64 %98, -1
  %94 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %93, i32 2
  %95 = load i32, i32* %94, align 8, !alias.scope !10
  %96 = icmp ult i32 %57, %95
  br i1 %96, label %97, label %85

97:                                               ; preds = %92, %80
  %98 = phi i64 [ %93, %92 ], [ %81, %80 ]
  %99 = phi i64 [ %98, %92 ], [ %78, %80 ]
  %100 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %98
  %101 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %99
  %102 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %101 to i8*
  %103 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %100 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %102, i8* noundef nonnull align 8 dereferenceable(192) %103, i64 192, i1 false) #11, !alias.scope !10
  %104 = icmp ult i64 %77, %98
  br i1 %104, label %92, label %85

105:                                              ; preds = %85, %52
  %106 = icmp eq i64 %54, %47
  br i1 %106, label %107, label %52

107:                                              ; preds = %293, %108, %105, %46
  ret void

108:                                              ; preds = %39
  call fastcc void @_ZN4core5slice4sort8heapsort17h78a15fd72da57097E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41, i8** noalias nonnull align 8 dereferenceable(8) %2)
  br label %107

109:                                              ; preds = %39
  br i1 %31, label %290, label %113

110:                                              ; preds = %131
  %111 = add nuw nsw i64 %141, 1
  %112 = icmp ult i64 %141, 11
  br i1 %112, label %280, label %223

113:                                              ; preds = %290, %109
  %114 = phi i32 [ %291, %290 ], [ %42, %109 ]
  %115 = lshr i64 %41, 2
  %116 = shl nuw nsw i64 %115, 1
  %117 = mul nuw i64 %115, 3
  %118 = icmp ugt i64 %41, 49
  br i1 %118, label %145, label %119

119:                                              ; preds = %206, %113
  %120 = phi i64 [ 0, %113 ], [ %221, %206 ]
  %121 = phi i64 [ %117, %113 ], [ %222, %206 ]
  %122 = phi i64 [ %116, %113 ], [ %196, %206 ]
  %123 = phi i64 [ %115, %113 ], [ %170, %206 ]
  %124 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %122, i32 2
  %125 = load i32, i32* %124, align 8, !alias.scope !17, !noalias !20
  %126 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %123, i32 2
  %127 = load i32, i32* %126, align 8, !alias.scope !17, !noalias !20
  %128 = icmp ult i32 %125, %127
  br i1 %128, label %129, label %131

129:                                              ; preds = %119
  %130 = add nuw nsw i64 %120, 1
  br label %131

131:                                              ; preds = %129, %119
  %132 = phi i32 [ %125, %129 ], [ %127, %119 ]
  %133 = phi i64 [ %130, %129 ], [ %120, %119 ]
  %134 = phi i64 [ %123, %129 ], [ %122, %119 ]
  %135 = phi i64 [ %122, %129 ], [ %123, %119 ]
  %136 = phi i32 [ %127, %129 ], [ %125, %119 ]
  %137 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %121, i32 2
  %138 = load i32, i32* %137, align 8, !alias.scope !17, !noalias !30
  %139 = icmp ult i32 %138, %136
  %140 = zext i1 %139 to i64
  %141 = add nuw nsw i64 %133, %140
  %142 = select i1 %139, i64 %121, i64 %134
  %143 = select i1 %139, i32 %138, i32 %136
  %144 = icmp ult i32 %143, %132
  br i1 %144, label %110, label %280

145:                                              ; preds = %113
  %146 = add nsw i64 %115, -1
  %147 = add nuw nsw i64 %115, 1
  %148 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %115, i32 2
  %149 = load i32, i32* %148, align 8, !alias.scope !17, !noalias !35
  %150 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %146, i32 2
  %151 = load i32, i32* %150, align 8, !alias.scope !17, !noalias !35
  %152 = icmp ult i32 %149, %151
  br i1 %152, label %153, label %154

153:                                              ; preds = %145
  br label %154

154:                                              ; preds = %153, %145
  %155 = phi i32 [ %149, %153 ], [ %151, %145 ]
  %156 = phi i64 [ 1, %153 ], [ 0, %145 ]
  %157 = phi i64 [ %146, %153 ], [ %115, %145 ]
  %158 = phi i64 [ %115, %153 ], [ %146, %145 ]
  %159 = phi i32 [ %151, %153 ], [ %149, %145 ]
  %160 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %147, i32 2
  %161 = load i32, i32* %160, align 8, !alias.scope !17, !noalias !48
  %162 = icmp ult i32 %161, %159
  %163 = zext i1 %162 to i64
  %164 = add nuw nsw i64 %156, %163
  %165 = select i1 %162, i64 %147, i64 %157
  %166 = select i1 %162, i32 %161, i32 %159
  %167 = icmp ult i32 %166, %155
  %168 = zext i1 %167 to i64
  %169 = add nuw nsw i64 %164, %168
  %170 = select i1 %167, i64 %158, i64 %165
  %171 = add nsw i64 %116, -1
  %172 = or i64 %116, 1
  %173 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %116, i32 2
  %174 = load i32, i32* %173, align 8, !alias.scope !17, !noalias !53
  %175 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %171, i32 2
  %176 = load i32, i32* %175, align 8, !alias.scope !17, !noalias !53
  %177 = icmp ult i32 %174, %176
  br i1 %177, label %178, label %180

178:                                              ; preds = %154
  %179 = add nuw nsw i64 %169, 1
  br label %180

180:                                              ; preds = %178, %154
  %181 = phi i32 [ %174, %178 ], [ %176, %154 ]
  %182 = phi i64 [ %179, %178 ], [ %169, %154 ]
  %183 = phi i64 [ %171, %178 ], [ %116, %154 ]
  %184 = phi i64 [ %116, %178 ], [ %171, %154 ]
  %185 = phi i32 [ %176, %178 ], [ %174, %154 ]
  %186 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %172, i32 2
  %187 = load i32, i32* %186, align 8, !alias.scope !17, !noalias !66
  %188 = icmp ult i32 %187, %185
  %189 = zext i1 %188 to i64
  %190 = add nuw nsw i64 %182, %189
  %191 = select i1 %188, i64 %172, i64 %183
  %192 = select i1 %188, i32 %187, i32 %185
  %193 = icmp ult i32 %192, %181
  %194 = zext i1 %193 to i64
  %195 = add nuw nsw i64 %190, %194
  %196 = select i1 %193, i64 %184, i64 %191
  %197 = add i64 %117, -1
  %198 = add nuw i64 %117, 1
  %199 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %117, i32 2
  %200 = load i32, i32* %199, align 8, !alias.scope !17, !noalias !71
  %201 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %197, i32 2
  %202 = load i32, i32* %201, align 8, !alias.scope !17, !noalias !71
  %203 = icmp ult i32 %200, %202
  br i1 %203, label %204, label %206

204:                                              ; preds = %180
  %205 = add nuw nsw i64 %195, 1
  br label %206

206:                                              ; preds = %204, %180
  %207 = phi i32 [ %200, %204 ], [ %202, %180 ]
  %208 = phi i64 [ %205, %204 ], [ %195, %180 ]
  %209 = phi i64 [ %197, %204 ], [ %117, %180 ]
  %210 = phi i64 [ %117, %204 ], [ %197, %180 ]
  %211 = phi i32 [ %202, %204 ], [ %200, %180 ]
  %212 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %198, i32 2
  %213 = load i32, i32* %212, align 8, !alias.scope !17, !noalias !84
  %214 = icmp ult i32 %213, %211
  %215 = zext i1 %214 to i64
  %216 = add nuw nsw i64 %208, %215
  %217 = select i1 %214, i64 %198, i64 %209
  %218 = select i1 %214, i32 %213, i32 %211
  %219 = icmp ult i32 %218, %207
  %220 = zext i1 %219 to i64
  %221 = add nuw nsw i64 %216, %220
  %222 = select i1 %219, i64 %210, i64 %217
  br label %119

223:                                              ; preds = %110
  %224 = lshr i64 %41, 1
  %225 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %41, i32 0, i32 0
  %226 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 0
  %227 = bitcast i64* %225 to %"regalloc::linear_scan::analysis::RangeFrag"*
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %226, i64 %224)
  %228 = sub nsw i64 0, %224
  %229 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %228
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %229, i64 %224)
  call void @llvm.experimental.noalias.scope.decl(metadata !89)
  call void @llvm.experimental.noalias.scope.decl(metadata !92)
  br label %230

230:                                              ; preds = %230, %223
  %231 = phi i64 [ %233, %230 ], [ 0, %223 ]
  %232 = xor i64 %231, -1
  %233 = add nuw nsw i64 %231, 1
  %234 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231
  %235 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232
  call void @llvm.experimental.noalias.scope.decl(metadata !94)
  call void @llvm.experimental.noalias.scope.decl(metadata !97)
  %236 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %234 to i8*
  %237 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %235 to i8*
  %238 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %234 to <4 x i64>*
  %239 = load <4 x i64>, <4 x i64>* %238, align 8, !alias.scope !99, !noalias !102
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %236, i8* noundef nonnull align 8 dereferenceable(32) %237, i64 32, i1 false) #11, !alias.scope !103
  %240 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %235 to <4 x i64>*
  store <4 x i64> %239, <4 x i64>* %240, align 8, !alias.scope !104, !noalias !105
  %241 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1
  %242 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %241 to i8*
  %243 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1
  %244 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %243 to i8*
  %245 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %241 to <4 x i64>*
  %246 = load <4 x i64>, <4 x i64>* %245, align 8, !alias.scope !99, !noalias !102
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %242, i8* noundef nonnull align 8 dereferenceable(32) %244, i64 32, i1 false) #11, !alias.scope !103
  %247 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %243 to <4 x i64>*
  store <4 x i64> %246, <4 x i64>* %247, align 8, !alias.scope !104, !noalias !105
  %248 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 2
  %249 = bitcast i64* %248 to i8*
  %250 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 2
  %251 = bitcast i64* %250 to i8*
  %252 = bitcast i64* %248 to <4 x i64>*
  %253 = load <4 x i64>, <4 x i64>* %252, align 8, !alias.scope !99, !noalias !102
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %249, i8* noundef nonnull align 8 dereferenceable(32) %251, i64 32, i1 false) #11, !alias.scope !103
  %254 = bitcast i64* %250 to <4 x i64>*
  store <4 x i64> %253, <4 x i64>* %254, align 8, !alias.scope !104, !noalias !105
  %255 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 6
  %256 = bitcast i64* %255 to i8*
  %257 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 6
  %258 = bitcast i64* %257 to i8*
  %259 = bitcast i64* %255 to <4 x i64>*
  %260 = load <4 x i64>, <4 x i64>* %259, align 8, !alias.scope !99, !noalias !102
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %256, i8* noundef nonnull align 8 dereferenceable(32) %258, i64 32, i1 false) #11, !alias.scope !103
  %261 = bitcast i64* %257 to <4 x i64>*
  store <4 x i64> %260, <4 x i64>* %261, align 8, !alias.scope !104, !noalias !105
  %262 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 10
  %263 = bitcast i64* %262 to i8*
  %264 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 10
  %265 = bitcast i64* %264 to i8*
  %266 = bitcast i64* %262 to <4 x i64>*
  %267 = load <4 x i64>, <4 x i64>* %266, align 8, !alias.scope !99, !noalias !102
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %263, i8* noundef nonnull align 8 dereferenceable(32) %265, i64 32, i1 false) #11, !alias.scope !103
  %268 = bitcast i64* %264 to <4 x i64>*
  store <4 x i64> %267, <4 x i64>* %268, align 8, !alias.scope !104, !noalias !105
  %269 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 14
  %270 = bitcast i64* %269 to i8*
  %271 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 14
  %272 = bitcast i64* %271 to i8*
  %273 = bitcast i64* %269 to <4 x i64>*
  %274 = load <4 x i64>, <4 x i64>* %273, align 8, !alias.scope !99, !noalias !102
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %270, i8* noundef nonnull align 8 dereferenceable(32) %272, i64 32, i1 false) #11, !alias.scope !103
  %275 = bitcast i64* %271 to <4 x i64>*
  store <4 x i64> %274, <4 x i64>* %275, align 8, !alias.scope !104, !noalias !105
  %276 = icmp eq i64 %233, %224
  br i1 %276, label %277, label %230

277:                                              ; preds = %230
  %278 = xor i64 %135, -1
  %279 = add i64 %41, %278
  br label %285

280:                                              ; preds = %131, %110
  %281 = phi i64 [ %135, %110 ], [ %142, %131 ]
  %282 = phi i64 [ %111, %110 ], [ %141, %131 ]
  %283 = icmp eq i64 %282, 0
  %284 = zext i1 %283 to i8
  br label %285

285:                                              ; preds = %280, %277
  %286 = phi i8 [ %284, %280 ], [ 1, %277 ]
  %287 = phi i64 [ %281, %280 ], [ %279, %277 ]
  %288 = icmp ne i8 %286, 0
  %289 = select i1 %30, i1 %288, i1 false
  br i1 %289, label %293, label %292

290:                                              ; preds = %109
  call fastcc void @_ZN4core5slice4sort14break_patterns17h00ba22c2bff5cb1eE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41)
  %291 = add i32 %42, -1
  br label %113

292:                                              ; preds = %293, %285
  br i1 %36, label %297, label %295

293:                                              ; preds = %285
  %294 = call fastcc zeroext i1 @_ZN4core5slice4sort22partial_insertion_sort17h6701cef9f9e13336E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41)
  br i1 %294, label %107, label %292

295:                                              ; preds = %292
  %296 = icmp ult i64 %287, %41
  br i1 %296, label %690, label %695, !prof !106

297:                                              ; preds = %292
  call void @llvm.experimental.noalias.scope.decl(metadata !107)
  %298 = icmp eq i64 %33, 0
  br i1 %298, label %303, label %299, !prof !110

299:                                              ; preds = %690, %297
  %300 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %32, %297 ], [ %40, %690 ]
  %301 = phi i64 [ %33, %297 ], [ %41, %690 ]
  %302 = icmp ult i64 %287, %301
  br i1 %302, label %305, label %304, !prof !106

303:                                              ; preds = %297
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 0, i64 0, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.7 to %"core::panic::location::Location"*)) #12, !noalias !111
  unreachable

304:                                              ; preds = %299
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 %287, i64 %301, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.7 to %"core::panic::location::Location"*)) #12, !noalias !111
  unreachable

305:                                              ; preds = %299
  call void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17hb2cb5cf585b48469E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %300, i64 %301, i64 0, i64 %287), !noalias !114
  %306 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 0
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %306, i64 1), !noalias !116
  %307 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 1
  %308 = add i64 %301, -1
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %307, i64 %308), !noalias !116
  call void @llvm.lifetime.start.p0i8(i64 176, i8* nonnull %21)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %22)
  %309 = bitcast [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %21, i8* noundef nonnull align 8 dereferenceable(176) %309, i64 176, i1 false)
  %310 = getelementptr inbounds i8, i8* %309, i64 176
  %311 = bitcast i8* %310 to i32*
  %312 = load i32, i32* %311, align 8, !alias.scope !107
  %313 = getelementptr inbounds i8, i8* %309, i64 180
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(12) %22, i8* noundef nonnull align 4 dereferenceable(12) %313, i64 12, i1 false)
  %314 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 0, i32 0, i32 0
  %315 = icmp eq i64 %308, 0
  br i1 %315, label %326, label %321

316:                                              ; preds = %347, %345
  %317 = landingpad { i8*, i32 }
          cleanup
  %318 = bitcast [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %318, i8* noundef nonnull align 8 dereferenceable(176) %21, i64 176, i1 false), !noalias !122
  %319 = getelementptr inbounds i64, i64* %314, i64 22
  %320 = bitcast i64* %319 to i32*
  store i32 %312, i32* %320, align 8, !alias.scope !107, !noalias !122
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %313, i8* noundef nonnull align 8 dereferenceable(12) %22, i64 12, i1 false), !noalias !122
  br label %61

321:                                              ; preds = %329, %305
  %322 = phi i64 [ %330, %329 ], [ 0, %305 ]
  %323 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %307, i64 %322, i32 2
  %324 = load i32, i32* %323, align 8, !alias.scope !107
  %325 = icmp ult i32 %324, %312
  br i1 %325, label %329, label %326

326:                                              ; preds = %329, %321, %305
  %327 = phi i64 [ 0, %305 ], [ %322, %321 ], [ %308, %329 ]
  %328 = call i64 @llvm.umin.i64(i64 %327, i64 %308)
  br label %332

329:                                              ; preds = %321
  %330 = add nuw i64 %322, 1
  %331 = icmp eq i64 %330, %308
  br i1 %331, label %326, label %321

332:                                              ; preds = %335, %326
  %333 = phi i64 [ %308, %326 ], [ %336, %335 ]
  %334 = icmp ugt i64 %333, %327
  br i1 %334, label %335, label %340

335:                                              ; preds = %332
  %336 = add i64 %333, -1
  %337 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 %333, i32 2
  %338 = load i32, i32* %337, align 8, !alias.scope !107
  %339 = icmp ult i32 %338, %312
  br i1 %339, label %340, label %332

340:                                              ; preds = %335, %332
  %341 = phi i64 [ %328, %332 ], [ %333, %335 ]
  %342 = icmp ult i64 %341, %327
  br i1 %342, label %345, label %343

343:                                              ; preds = %340
  %344 = icmp ugt i64 %341, %308
  br i1 %344, label %347, label %349

345:                                              ; preds = %340
  invoke void @_ZN4core5slice5index22slice_index_order_fail17h79f274959805de1fE(i64 %327, i64 %341, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.8 to %"core::panic::location::Location"*)) #12
          to label %346 unwind label %316

346:                                              ; preds = %345
  unreachable

347:                                              ; preds = %343
  invoke void @_ZN4core5slice5index24slice_end_index_len_fail17h80e02ac829cd41f5E(i64 %341, i64 %308, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.8 to %"core::panic::location::Location"*)) #12
          to label %348 unwind label %316

348:                                              ; preds = %347
  unreachable

349:                                              ; preds = %343
  %350 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %307, i64 %327
  call void @llvm.experimental.noalias.scope.decl(metadata !125)
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %23), !noalias !128
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(128) %23, i8 undef, i64 128, i1 false), !noalias !128
  %351 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %307, i64 %341
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %24), !noalias !128
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(128) %24, i8 undef, i64 128, i1 false), !noalias !128
  br label %352

352:                                              ; preds = %529, %349
  %353 = phi i8* [ null, %349 ], [ %474, %529 ]
  %354 = phi i8* [ null, %349 ], [ %530, %529 ]
  %355 = phi i64 [ 128, %349 ], [ %367, %529 ]
  %356 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %351, %349 ], [ %538, %529 ]
  %357 = phi i8* [ null, %349 ], [ %404, %529 ]
  %358 = phi i8* [ null, %349 ], [ %531, %529 ]
  %359 = phi i64 [ 128, %349 ], [ %368, %529 ]
  %360 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %350, %349 ], [ %534, %529 ]
  %361 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %356 to i64
  %362 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %360 to i64
  %363 = sub i64 %361, %362
  %364 = udiv i64 %363, 192
  %365 = icmp ult i64 %363, 49344
  br i1 %365, label %370, label %366

366:                                              ; preds = %378, %370, %352
  %367 = phi i64 [ %355, %352 ], [ %380, %378 ], [ %376, %370 ]
  %368 = phi i64 [ %359, %352 ], [ %379, %378 ], [ %377, %370 ]
  %369 = icmp eq i8* %358, %357
  br i1 %369, label %407, label %403

370:                                              ; preds = %352
  %371 = icmp ult i8* %358, %357
  %372 = icmp ult i8* %354, %353
  %373 = select i1 %371, i1 true, i1 %372
  %374 = add nsw i64 %364, -128
  %375 = select i1 %373, i64 %374, i64 %364
  %376 = select i1 %371, i64 %375, i64 %355
  %377 = select i1 %371, i64 %359, i64 %375
  br i1 %373, label %366, label %378

378:                                              ; preds = %370
  %379 = lshr i64 %375, 1
  %380 = sub i64 %375, %379
  br label %366

381:                                              ; preds = %415, %409
  %382 = phi i8* [ undef, %409 ], [ %448, %415 ]
  %383 = phi i8* [ %23, %409 ], [ %448, %415 ]
  %384 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %360, %409 ], [ %449, %415 ]
  %385 = phi i64 [ 0, %409 ], [ %441, %415 ]
  %386 = icmp eq i64 %411, 0
  br i1 %386, label %403, label %387

387:                                              ; preds = %387, %381
  %388 = phi i8* [ %399, %387 ], [ %383, %381 ]
  %389 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %400, %387 ], [ %384, %381 ]
  %390 = phi i64 [ %392, %387 ], [ %385, %381 ]
  %391 = phi i64 [ %401, %387 ], [ %411, %381 ]
  %392 = add nuw i64 %390, 1
  %393 = trunc i64 %390 to i8
  store i8 %393, i8* %388, align 1, !noalias !128
  %394 = icmp ne %"regalloc::linear_scan::analysis::RangeFrag"* %389, null
  call void @llvm.assume(i1 %394)
  %395 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %389, i64 0, i32 2
  %396 = load i32, i32* %395, align 8, !alias.scope !130, !noalias !131
  %397 = icmp uge i32 %396, %312
  %398 = zext i1 %397 to i64
  %399 = getelementptr inbounds i8, i8* %388, i64 %398
  %400 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %389, i64 1
  %401 = add i64 %391, -1
  %402 = icmp eq i64 %401, 0
  br i1 %402, label %403, label %387, !llvm.loop !132

403:                                              ; preds = %407, %387, %381, %366
  %404 = phi i8* [ %357, %366 ], [ %23, %407 ], [ %382, %381 ], [ %399, %387 ]
  %405 = phi i8* [ %358, %366 ], [ %23, %407 ], [ %23, %387 ], [ %23, %381 ]
  %406 = icmp eq i8* %354, %353
  br i1 %406, label %485, label %473

407:                                              ; preds = %366
  %408 = icmp eq i64 %368, 0
  br i1 %408, label %403, label %409

409:                                              ; preds = %407
  %410 = add i64 %368, -1
  %411 = and i64 %368, 3
  %412 = icmp ult i64 %410, 3
  br i1 %412, label %381, label %413

413:                                              ; preds = %409
  %414 = and i64 %368, -4
  br label %415

415:                                              ; preds = %415, %413
  %416 = phi i8* [ %23, %413 ], [ %448, %415 ]
  %417 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %360, %413 ], [ %449, %415 ]
  %418 = phi i64 [ 0, %413 ], [ %441, %415 ]
  %419 = phi i64 [ %414, %413 ], [ %450, %415 ]
  %420 = trunc i64 %418 to i8
  store i8 %420, i8* %416, align 1, !noalias !128
  %421 = icmp ne %"regalloc::linear_scan::analysis::RangeFrag"* %417, null
  call void @llvm.assume(i1 %421)
  %422 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 0, i32 2
  %423 = load i32, i32* %422, align 8, !alias.scope !130, !noalias !131
  %424 = icmp uge i32 %423, %312
  %425 = zext i1 %424 to i64
  %426 = getelementptr inbounds i8, i8* %416, i64 %425
  %427 = trunc i64 %418 to i8
  %428 = or i8 %427, 1
  store i8 %428, i8* %426, align 1, !noalias !128
  %429 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 1, i32 2
  %430 = load i32, i32* %429, align 8, !alias.scope !130, !noalias !131
  %431 = icmp uge i32 %430, %312
  %432 = zext i1 %431 to i64
  %433 = getelementptr inbounds i8, i8* %426, i64 %432
  %434 = trunc i64 %418 to i8
  %435 = or i8 %434, 2
  store i8 %435, i8* %433, align 1, !noalias !128
  %436 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 2, i32 2
  %437 = load i32, i32* %436, align 8, !alias.scope !130, !noalias !131
  %438 = icmp uge i32 %437, %312
  %439 = zext i1 %438 to i64
  %440 = getelementptr inbounds i8, i8* %433, i64 %439
  %441 = add nuw i64 %418, 4
  %442 = trunc i64 %418 to i8
  %443 = or i8 %442, 3
  store i8 %443, i8* %440, align 1, !noalias !128
  %444 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 3, i32 2
  %445 = load i32, i32* %444, align 8, !alias.scope !130, !noalias !131
  %446 = icmp uge i32 %445, %312
  %447 = zext i1 %446 to i64
  %448 = getelementptr inbounds i8, i8* %440, i64 %447
  %449 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 4
  %450 = add i64 %419, -4
  %451 = icmp eq i64 %450, 0
  br i1 %451, label %381, label %415

452:                                              ; preds = %493, %487
  %453 = phi i8* [ undef, %487 ], [ %526, %493 ]
  %454 = phi i8* [ %24, %487 ], [ %526, %493 ]
  %455 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %356, %487 ], [ %519, %493 ]
  %456 = phi i64 [ 0, %487 ], [ %518, %493 ]
  %457 = icmp eq i64 %489, 0
  br i1 %457, label %473, label %458

458:                                              ; preds = %458, %452
  %459 = phi i8* [ %470, %458 ], [ %454, %452 ]
  %460 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %464, %458 ], [ %455, %452 ]
  %461 = phi i64 [ %463, %458 ], [ %456, %452 ]
  %462 = phi i64 [ %471, %458 ], [ %489, %452 ]
  %463 = add nuw i64 %461, 1
  %464 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %460, i64 -1
  %465 = trunc i64 %461 to i8
  store i8 %465, i8* %459, align 1, !noalias !128
  %466 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %460, i64 -1, i32 2
  %467 = load i32, i32* %466, align 8, !alias.scope !130, !noalias !131
  %468 = icmp ult i32 %467, %312
  %469 = zext i1 %468 to i64
  %470 = getelementptr inbounds i8, i8* %459, i64 %469
  %471 = add i64 %462, -1
  %472 = icmp eq i64 %471, 0
  br i1 %472, label %473, label %458, !llvm.loop !134

473:                                              ; preds = %485, %458, %452, %403
  %474 = phi i8* [ %353, %403 ], [ %24, %485 ], [ %453, %452 ], [ %470, %458 ]
  %475 = phi i8* [ %354, %403 ], [ %24, %485 ], [ %24, %458 ], [ %24, %452 ]
  %476 = ptrtoint i8* %404 to i64
  %477 = ptrtoint i8* %405 to i64
  %478 = sub i64 %476, %477
  %479 = ptrtoint i8* %474 to i64
  %480 = ptrtoint i8* %475 to i64
  %481 = sub i64 %479, %480
  %482 = icmp ugt i64 %478, %481
  %483 = select i1 %482, i64 %481, i64 %478
  %484 = icmp eq i64 %483, 0
  br i1 %484, label %529, label %539

485:                                              ; preds = %403
  %486 = icmp eq i64 %367, 0
  br i1 %486, label %473, label %487

487:                                              ; preds = %485
  %488 = add i64 %367, -1
  %489 = and i64 %367, 3
  %490 = icmp ult i64 %488, 3
  br i1 %490, label %452, label %491

491:                                              ; preds = %487
  %492 = and i64 %367, -4
  br label %493

493:                                              ; preds = %493, %491
  %494 = phi i8* [ %24, %491 ], [ %526, %493 ]
  %495 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %356, %491 ], [ %519, %493 ]
  %496 = phi i64 [ 0, %491 ], [ %518, %493 ]
  %497 = phi i64 [ %492, %491 ], [ %527, %493 ]
  %498 = trunc i64 %496 to i8
  store i8 %498, i8* %494, align 1, !noalias !128
  %499 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %495, i64 -1, i32 2
  %500 = load i32, i32* %499, align 8, !alias.scope !130, !noalias !131
  %501 = icmp ult i32 %500, %312
  %502 = zext i1 %501 to i64
  %503 = getelementptr inbounds i8, i8* %494, i64 %502
  %504 = trunc i64 %496 to i8
  %505 = or i8 %504, 1
  store i8 %505, i8* %503, align 1, !noalias !128
  %506 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %495, i64 -2, i32 2
  %507 = load i32, i32* %506, align 8, !alias.scope !130, !noalias !131
  %508 = icmp ult i32 %507, %312
  %509 = zext i1 %508 to i64
  %510 = getelementptr inbounds i8, i8* %503, i64 %509
  %511 = trunc i64 %496 to i8
  %512 = or i8 %511, 2
  store i8 %512, i8* %510, align 1, !noalias !128
  %513 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %495, i64 -3, i32 2
  %514 = load i32, i32* %513, align 8, !alias.scope !130, !noalias !131
  %515 = icmp ult i32 %514, %312
  %516 = zext i1 %515 to i64
  %517 = getelementptr inbounds i8, i8* %510, i64 %516
  %518 = add nuw i64 %496, 4
  %519 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %495, i64 -4
  %520 = trunc i64 %496 to i8
  %521 = or i8 %520, 3
  store i8 %521, i8* %517, align 1, !noalias !128
  %522 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %495, i64 -4, i32 2
  %523 = load i32, i32* %522, align 8, !alias.scope !130, !noalias !131
  %524 = icmp ult i32 %523, %312
  %525 = zext i1 %524 to i64
  %526 = getelementptr inbounds i8, i8* %517, i64 %525
  %527 = add i64 %497, -4
  %528 = icmp eq i64 %527, 0
  br i1 %528, label %452, label %493

529:                                              ; preds = %578, %473
  %530 = phi i8* [ %583, %578 ], [ %475, %473 ]
  %531 = phi i8* [ %582, %578 ], [ %405, %473 ]
  %532 = icmp eq i8* %531, %404
  %533 = select i1 %532, i64 %368, i64 0
  %534 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %533
  %535 = icmp eq i8* %530, %474
  %536 = sub i64 0, %367
  %537 = select i1 %535, i64 %536, i64 0
  %538 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %537
  br i1 %365, label %584, label %352

539:                                              ; preds = %473
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %25)
  %540 = load i8, i8* %405, align 1, !noalias !128
  %541 = zext i8 %540 to i64
  %542 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %541
  %543 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %542 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %25, i8* noundef nonnull align 8 dereferenceable(192) %543, i64 192, i1 false) #11, !noalias !131
  %544 = load i8, i8* %475, align 1, !noalias !128
  %545 = zext i8 %544 to i64
  %546 = xor i64 %545, -1
  %547 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %546
  %548 = load i8, i8* %405, align 1, !noalias !128
  %549 = zext i8 %548 to i64
  %550 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %549
  %551 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %550 to i8*
  %552 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %547 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %551, i8* noundef nonnull align 8 dereferenceable(192) %552, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  %553 = icmp eq i64 %483, 1
  br i1 %553, label %578, label %554

554:                                              ; preds = %554, %539
  %555 = phi i8 [ %570, %554 ], [ %544, %539 ]
  %556 = phi i8* [ %560, %554 ], [ %405, %539 ]
  %557 = phi i8* [ %569, %554 ], [ %475, %539 ]
  %558 = phi i64 [ %559, %554 ], [ 1, %539 ]
  %559 = add nuw i64 %558, 1
  %560 = getelementptr inbounds i8, i8* %556, i64 1
  %561 = load i8, i8* %560, align 1, !noalias !128
  %562 = zext i8 %561 to i64
  %563 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %562
  %564 = zext i8 %555 to i64
  %565 = xor i64 %564, -1
  %566 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %565
  %567 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %566 to i8*
  %568 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %563 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %567, i8* noundef nonnull align 8 dereferenceable(192) %568, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  %569 = getelementptr inbounds i8, i8* %557, i64 1
  %570 = load i8, i8* %569, align 1, !noalias !128
  %571 = zext i8 %570 to i64
  %572 = xor i64 %571, -1
  %573 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %572
  %574 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %573 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %568, i8* noundef nonnull align 8 dereferenceable(192) %574, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  %575 = icmp eq i64 %559, %483
  br i1 %575, label %576, label %554

576:                                              ; preds = %554
  %577 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %573 to i8*
  br label %578

578:                                              ; preds = %576, %539
  %579 = phi i8* [ %552, %539 ], [ %577, %576 ]
  %580 = phi i8* [ %475, %539 ], [ %569, %576 ]
  %581 = phi i8* [ %405, %539 ], [ %560, %576 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %579, i8* noundef nonnull align 8 dereferenceable(192) %25, i64 192, i1 false) #11, !noalias !131
  %582 = getelementptr inbounds i8, i8* %581, i64 1
  %583 = getelementptr inbounds i8, i8* %580, i64 1
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %25)
  br label %529

584:                                              ; preds = %529
  %585 = ptrtoint i8* %404 to i64
  %586 = ptrtoint i8* %531 to i64
  %587 = ptrtoint i8* %474 to i64
  %588 = ptrtoint i8* %530 to i64
  %589 = icmp ult i8* %531, %404
  br i1 %589, label %590, label %609

590:                                              ; preds = %584
  %591 = sub i64 %585, %586
  %592 = xor i64 %586, -1
  %593 = and i64 %591, 1
  %594 = icmp eq i64 %593, 0
  br i1 %594, label %603, label %595

595:                                              ; preds = %590
  %596 = getelementptr inbounds i8, i8* %404, i64 -1
  %597 = load i8, i8* %596, align 1, !noalias !128
  %598 = zext i8 %597 to i64
  %599 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %534, i64 %598
  %600 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %538, i64 -1
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %27)
  %601 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %599 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %27, i8* noundef nonnull align 8 dereferenceable(192) %601, i64 192, i1 false) #11, !noalias !131
  %602 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %600 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %601, i8* noundef nonnull align 8 dereferenceable(192) %602, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %602, i8* noundef nonnull align 8 dereferenceable(192) %27, i64 192, i1 false) #11, !noalias !131
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %27)
  br label %603

603:                                              ; preds = %595, %590
  %604 = phi i8* [ %596, %595 ], [ %404, %590 ]
  %605 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %600, %595 ], [ %538, %590 ]
  %606 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %600, %595 ], [ undef, %590 ]
  %607 = sub i64 0, %585
  %608 = icmp eq i64 %592, %607
  br i1 %608, label %669, label %631

609:                                              ; preds = %584
  %610 = icmp ult i8* %530, %474
  br i1 %610, label %611, label %669

611:                                              ; preds = %609
  %612 = sub i64 %587, %588
  %613 = xor i64 %588, -1
  %614 = and i64 %612, 1
  %615 = icmp eq i64 %614, 0
  br i1 %615, label %625, label %616

616:                                              ; preds = %611
  %617 = getelementptr inbounds i8, i8* %474, i64 -1
  %618 = load i8, i8* %617, align 1, !noalias !128
  %619 = zext i8 %618 to i64
  %620 = xor i64 %619, -1
  %621 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %538, i64 %620
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %26)
  %622 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %534 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %26, i8* noundef nonnull align 8 dereferenceable(192) %622, i64 192, i1 false) #11, !noalias !131
  %623 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %621 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %622, i8* noundef nonnull align 8 dereferenceable(192) %623, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %623, i8* noundef nonnull align 8 dereferenceable(192) %26, i64 192, i1 false) #11, !noalias !131
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %26)
  %624 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %534, i64 1
  br label %625

625:                                              ; preds = %616, %611
  %626 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %624, %616 ], [ %534, %611 ]
  %627 = phi i8* [ %617, %616 ], [ %474, %611 ]
  %628 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %624, %616 ], [ undef, %611 ]
  %629 = sub i64 0, %587
  %630 = icmp eq i64 %613, %629
  br i1 %630, label %669, label %649

631:                                              ; preds = %631, %603
  %632 = phi i8* [ %641, %631 ], [ %604, %603 ]
  %633 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %645, %631 ], [ %605, %603 ]
  %634 = getelementptr inbounds i8, i8* %632, i64 -1
  %635 = load i8, i8* %634, align 1, !noalias !128
  %636 = zext i8 %635 to i64
  %637 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %534, i64 %636
  %638 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %633, i64 -1
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %27)
  %639 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %637 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %27, i8* noundef nonnull align 8 dereferenceable(192) %639, i64 192, i1 false) #11, !noalias !131
  %640 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %638 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %639, i8* noundef nonnull align 8 dereferenceable(192) %640, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %640, i8* noundef nonnull align 8 dereferenceable(192) %27, i64 192, i1 false) #11, !noalias !131
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %27)
  %641 = getelementptr inbounds i8, i8* %632, i64 -2
  %642 = load i8, i8* %641, align 1, !noalias !128
  %643 = zext i8 %642 to i64
  %644 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %534, i64 %643
  %645 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %633, i64 -2
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %27)
  %646 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %644 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %27, i8* noundef nonnull align 8 dereferenceable(192) %646, i64 192, i1 false) #11, !noalias !131
  %647 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %645 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %646, i8* noundef nonnull align 8 dereferenceable(192) %647, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %647, i8* noundef nonnull align 8 dereferenceable(192) %27, i64 192, i1 false) #11, !noalias !131
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %27)
  %648 = icmp ult i8* %531, %641
  br i1 %648, label %631, label %669

649:                                              ; preds = %649, %625
  %650 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %667, %649 ], [ %626, %625 ]
  %651 = phi i8* [ %660, %649 ], [ %627, %625 ]
  %652 = getelementptr inbounds i8, i8* %651, i64 -1
  %653 = load i8, i8* %652, align 1, !noalias !128
  %654 = zext i8 %653 to i64
  %655 = xor i64 %654, -1
  %656 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %538, i64 %655
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %26)
  %657 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %650 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %26, i8* noundef nonnull align 8 dereferenceable(192) %657, i64 192, i1 false) #11, !noalias !131
  %658 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %656 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %657, i8* noundef nonnull align 8 dereferenceable(192) %658, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %658, i8* noundef nonnull align 8 dereferenceable(192) %26, i64 192, i1 false) #11, !noalias !131
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %26)
  %659 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %650, i64 1
  %660 = getelementptr inbounds i8, i8* %651, i64 -2
  %661 = load i8, i8* %660, align 1, !noalias !128
  %662 = zext i8 %661 to i64
  %663 = xor i64 %662, -1
  %664 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %538, i64 %663
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %26)
  %665 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %659 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %26, i8* noundef nonnull align 8 dereferenceable(192) %665, i64 192, i1 false) #11, !noalias !131
  %666 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %664 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %665, i8* noundef nonnull align 8 dereferenceable(192) %666, i64 192, i1 false) #11, !alias.scope !130, !noalias !131
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %666, i8* noundef nonnull align 8 dereferenceable(192) %26, i64 192, i1 false) #11, !noalias !131
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %26)
  %667 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %650, i64 2
  %668 = icmp ult i8* %530, %660
  br i1 %668, label %649, label %669

669:                                              ; preds = %649, %631, %625, %609, %603
  %670 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %534, %609 ], [ %606, %603 ], [ %645, %631 ], [ %628, %625 ], [ %667, %649 ]
  %671 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %670 to i64
  %672 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %350 to i64
  %673 = sub i64 %671, %672
  %674 = udiv i64 %673, 192
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %24), !noalias !128
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %23), !noalias !128
  %675 = add i64 %674, %327
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %309, i8* noundef nonnull align 8 dereferenceable(176) %21, i64 176, i1 false), !noalias !135
  %676 = getelementptr inbounds i64, i64* %314, i64 22
  %677 = bitcast i64* %676 to i32*
  store i32 %312, i32* %677, align 8, !alias.scope !107, !noalias !135
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %313, i8* noundef nonnull align 8 dereferenceable(12) %22, i64 12, i1 false), !noalias !135
  call void @llvm.lifetime.end.p0i8(i64 176, i8* nonnull %21)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %22)
  %678 = icmp ugt i64 %301, %675
  br i1 %678, label %680, label %679, !prof !106

679:                                              ; preds = %669
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 %675, i64 %301, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.9 to %"core::panic::location::Location"*)) #12, !noalias !138
  unreachable

680:                                              ; preds = %669
  %681 = icmp uge i64 %327, %341
  call void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17hb2cb5cf585b48469E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %300, i64 %301, i64 0, i64 %675), !noalias !141
  %682 = sub i64 %301, %675
  %683 = icmp ugt i64 %675, %682
  %684 = select i1 %683, i64 %682, i64 %675
  %685 = lshr i64 %301, 3
  %686 = icmp ult i64 %684, %685
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %306, i64 %675), !noalias !143
  %687 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 %675
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %687, i64 %682), !noalias !143
  %688 = icmp eq i64 %682, 0
  br i1 %688, label %689, label %745

689:                                              ; preds = %680
  call void @_ZN4core9panicking5panic17h97167cd315d19cd4E([0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [35 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.14 to [0 x i8]*), i64 35, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.13 to %"core::panic::location::Location"*)) #12, !noalias !149
  unreachable

690:                                              ; preds = %295
  %691 = load i32, i32* %38, align 8
  %692 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %287, i32 2
  %693 = load i32, i32* %692, align 8
  %694 = icmp ult i32 %691, %693
  br i1 %694, label %299, label %696

695:                                              ; preds = %295
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 %287, i64 %41, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.11 to %"core::panic::location::Location"*)) #12
  unreachable

696:                                              ; preds = %690
  call void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17hb2cb5cf585b48469E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41, i64 0, i64 %287), !noalias !153
  %697 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 0
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %697, i64 1), !noalias !156
  %698 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 1
  %699 = add i64 %41, -1
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %698, i64 %699), !noalias !156
  call void @llvm.lifetime.start.p0i8(i64 176, i8* nonnull %18)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %19)
  %700 = bitcast [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %18, i8* noundef nonnull align 8 dereferenceable(176) %700, i64 176, i1 false)
  %701 = getelementptr inbounds i8, i8* %700, i64 176
  %702 = bitcast i8* %701 to i32*
  %703 = load i32, i32* %702, align 8, !alias.scope !162
  %704 = getelementptr inbounds i8, i8* %700, i64 180
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(12) %19, i8* noundef nonnull align 4 dereferenceable(12) %704, i64 12, i1 false)
  br label %705

705:                                              ; preds = %727, %696
  %706 = phi i64 [ %723, %727 ], [ %699, %696 ]
  %707 = phi i64 [ %732, %727 ], [ 0, %696 ]
  %708 = icmp ult i64 %707, %706
  br i1 %708, label %709, label %714

709:                                              ; preds = %716, %705
  %710 = phi i64 [ %717, %716 ], [ %707, %705 ]
  %711 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %698, i64 %710, i32 2
  %712 = load i32, i32* %711, align 8, !alias.scope !162
  %713 = icmp ult i32 %703, %712
  br i1 %713, label %714, label %716

714:                                              ; preds = %716, %709, %705
  %715 = phi i64 [ %707, %705 ], [ %710, %709 ], [ %706, %716 ]
  br label %719

716:                                              ; preds = %709
  %717 = add i64 %710, 1
  %718 = icmp eq i64 %717, %706
  br i1 %718, label %714, label %709

719:                                              ; preds = %722, %714
  %720 = phi i64 [ %706, %714 ], [ %723, %722 ]
  %721 = icmp ult i64 %715, %720
  br i1 %721, label %722, label %733

722:                                              ; preds = %719
  %723 = add i64 %720, -1
  %724 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %720, i32 2
  %725 = load i32, i32* %724, align 8, !alias.scope !162
  %726 = icmp ult i32 %703, %725
  br i1 %726, label %719, label %727

727:                                              ; preds = %722
  %728 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %698, i64 %715
  %729 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %720
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %20)
  %730 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %728 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %20, i8* noundef nonnull align 8 dereferenceable(192) %730, i64 192, i1 false) #11
  %731 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %729 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %730, i8* noundef nonnull align 8 dereferenceable(192) %731, i64 192, i1 false) #11, !alias.scope !162
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %731, i8* noundef nonnull align 8 dereferenceable(192) %20, i64 192, i1 false) #11
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %20)
  %732 = add nuw i64 %715, 1
  br label %705

733:                                              ; preds = %719
  %734 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 0, i32 0, i32 0
  %735 = add i64 %715, 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %700, i8* noundef nonnull align 8 dereferenceable(176) %18, i64 176, i1 false), !noalias !165
  %736 = getelementptr inbounds i64, i64* %734, i64 22
  %737 = bitcast i64* %736 to i32*
  store i32 %703, i32* %737, align 8, !alias.scope !162, !noalias !165
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %704, i8* noundef nonnull align 8 dereferenceable(12) %19, i64 12, i1 false), !noalias !165
  call void @llvm.lifetime.end.p0i8(i64 176, i8* nonnull %18)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %19)
  %738 = icmp ult i64 %41, %735
  br i1 %738, label %739, label %740

739:                                              ; preds = %733
  call void @_ZN4core5slice5index26slice_start_index_len_fail17haac0d373d67dca37E(i64 %735, i64 %41, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.b95475fadfab75acbbc31e70c5209b76.12 to %"core::panic::location::Location"*)) #12, !noalias !168
  unreachable

740:                                              ; preds = %733
  %741 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %735
  %742 = sub i64 %41, %735
  %743 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %741 to [0 x %"regalloc::linear_scan::analysis::RangeFrag"]*
  %744 = icmp ult i64 %742, 21
  br i1 %744, label %44, label %39

745:                                              ; preds = %680
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %687, i64 1), !noalias !173
  %746 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %687, i64 1
  %747 = add i64 %682, -1
  call void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %746, i64 %747), !noalias !173
  %748 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %746 to [0 x %"regalloc::linear_scan::analysis::RangeFrag"]*
  %749 = icmp ult i64 %675, %747
  br i1 %749, label %752, label %750

750:                                              ; preds = %745
  %751 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %687, i64 0, i32 0, i32 0
  call fastcc void @_ZN4core5slice4sort7recurse17h84fd8028bd55c38bE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %748, i64 %747, i8** noalias nonnull align 8 dereferenceable(8) %2, i64* noalias nonnull readonly align 8 dereferenceable_or_null(192) %751, i32 %114)
  br label %754

752:                                              ; preds = %745
  call fastcc void @_ZN4core5slice4sort7recurse17h84fd8028bd55c38bE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %300, i64 %675, i8** noalias nonnull align 8 dereferenceable(8) %2, i64* noalias readonly align 8 dereferenceable_or_null(192) %34, i32 %114)
  %753 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %687, i64 0, i32 0, i32 0
  br label %754

754:                                              ; preds = %752, %750
  %755 = phi i64* [ %753, %752 ], [ %34, %750 ]
  %756 = phi i64 [ %747, %752 ], [ %675, %750 ]
  %757 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %748, %752 ], [ %300, %750 ]
  %758 = xor i1 %686, true
  %759 = select i1 %758, i1 %681, i1 false
  %760 = icmp ult i64 %756, 21
  br i1 %760, label %46, label %29
}

; Function Attrs: cold nonlazybind uwtable
declare hidden fastcc void @_ZN4core5slice4sort8heapsort17h78a15fd72da57097E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8, i64, i8** noalias align 8 dereferenceable(8)) unnamed_addr #8

; Function Attrs: cold nonlazybind uwtable
declare hidden fastcc void @_ZN4core5slice4sort14break_patterns17h00ba22c2bff5cb1eE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8, i64) unnamed_addr #8

; Function Attrs: cold nonlazybind uwtable
declare hidden fastcc zeroext i1 @_ZN4core5slice4sort22partial_insertion_sort17h6701cef9f9e13336E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8, i64) unnamed_addr #8

; Function Attrs: nounwind nonlazybind uwtable
declare i32 @rust_eh_personality(i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*) unnamed_addr #9

; Function Attrs: nonlazybind uwtable
define hidden fastcc void @_ZN4core5slice4sort7recurse17h37cd075f67b5ff92E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %0, i64 %1, i8** noalias align 8 dereferenceable(8) %2, i64* noalias readonly align 8 dereferenceable_or_null(192) %3, i32 %4) unnamed_addr #7 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
  %6 = alloca [24 x i64], align 8
  %7 = alloca { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }, align 8
  %8 = alloca { i32, i8, [7 x i8] }, align 8
  %9 = alloca [24 x i64], align 8
  %10 = alloca [24 x i64], align 8
  %11 = alloca %"regalloc::linear_scan::analysis::RangeFrag", align 8
  %12 = alloca [128 x i8], align 1
  %13 = alloca [128 x i8], align 1
  %14 = alloca { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }, align 8
  %15 = alloca { i32, i8, [7 x i8] }, align 8
  %16 = alloca { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }, align 8
  %17 = alloca { i32, i8, [7 x i8] }, align 8
  %18 = bitcast { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }* %7 to i8*
  %19 = bitcast { i32, i8, [7 x i8] }* %8 to i8*
  %20 = bitcast [24 x i64]* %6 to i8*
  %21 = bitcast { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }* %14 to i8*
  %22 = bitcast { i32, i8, [7 x i8] }* %15 to i8*
  %23 = getelementptr inbounds [128 x i8], [128 x i8]* %13, i64 0, i64 0
  %24 = getelementptr inbounds [128 x i8], [128 x i8]* %12, i64 0, i64 0
  %25 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %11 to i8*
  %26 = bitcast [24 x i64]* %9 to i8*
  %27 = bitcast [24 x i64]* %10 to i8*
  %28 = icmp ult i64 %1, 21
  br i1 %28, label %46, label %29

29:                                               ; preds = %595, %5
  %30 = phi i1 [ %600, %595 ], [ true, %5 ]
  %31 = phi i1 [ %527, %595 ], [ false, %5 ]
  %32 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %598, %595 ], [ %0, %5 ]
  %33 = phi i64 [ %597, %595 ], [ %1, %5 ]
  %34 = phi i64* [ %596, %595 ], [ %3, %5 ]
  %35 = phi i32 [ %114, %595 ], [ %4, %5 ]
  %36 = icmp eq i64* %34, null
  %37 = getelementptr i64, i64* %34, i64 22
  %38 = bitcast i64* %37 to i32*
  br label %39

39:                                               ; preds = %581, %29
  %40 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %32, %29 ], [ %584, %581 ]
  %41 = phi i64 [ %33, %29 ], [ %583, %581 ]
  %42 = phi i32 [ %35, %29 ], [ %114, %581 ]
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %108, label %109

44:                                               ; preds = %581
  %45 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %582 to [0 x %"regalloc::linear_scan::analysis::RangeFrag"]*
  br label %46

46:                                               ; preds = %595, %44, %5
  %47 = phi i64 [ %1, %5 ], [ %583, %44 ], [ %597, %595 ]
  %48 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %0, %5 ], [ %45, %44 ], [ %598, %595 ]
  call void @llvm.experimental.noalias.scope.decl(metadata !177)
  %49 = bitcast { %"smallvec::SmallVec<[ir::entities::Value; 4]>", %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>" }* %16 to i8*
  %50 = bitcast { i32, i8, [7 x i8] }* %17 to i8*
  %51 = icmp ugt i64 %47, 1
  br i1 %51, label %52, label %107

52:                                               ; preds = %105, %46
  %53 = phi i64 [ %54, %105 ], [ 1, %46 ]
  %54 = add nuw i64 %53, 1
  call void @llvm.experimental.noalias.scope.decl(metadata !180)
  %55 = add i64 %53, -1
  %56 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %53, i32 2
  %57 = load i32, i32* %56, align 8, !alias.scope !183
  %58 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %55, i32 2
  %59 = load i32, i32* %58, align 8, !alias.scope !183
  %60 = icmp ult i32 %57, %59
  br i1 %60, label %68, label %105

61:                                               ; preds = %316, %63
  %62 = phi { i8*, i32 } [ %64, %63 ], [ %317, %316 ]
  resume { i8*, i32 } %62

63:                                               ; preds = %68
  %64 = landingpad { i8*, i32 }
          cleanup
  %65 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %73 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %65, i8* noundef nonnull align 8 dereferenceable(176) %49, i64 176, i1 false), !noalias !184
  store i32 %57, i32* %58, align 8, !alias.scope !183, !noalias !184
  %66 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %55, i32 3
  %67 = bitcast i32* %66 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %67, i8* noundef nonnull align 8 dereferenceable(12) %50, i64 12, i1 false), !noalias !184
  br label %61

68:                                               ; preds = %52
  %69 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %53
  call void @llvm.lifetime.start.p0i8(i64 176, i8* nonnull %49)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %50)
  %70 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %69 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %49, i8* noundef nonnull align 8 dereferenceable(176) %70, i64 176, i1 false)
  %71 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %53, i32 3
  %72 = bitcast i32* %71 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(12) %50, i8* noundef nonnull align 4 dereferenceable(12) %72, i64 12, i1 false)
  %73 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %55
  %74 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %73 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %70, i8* noundef nonnull align 8 dereferenceable(192) %74, i64 192, i1 false) #11, !alias.scope !183
  %75 = invoke { i64, i64 } @"_ZN4core4iter8adapters3rev12Rev$LT$T$GT$3new17h8f874c5e95c6a2d0E"(i64 0, i64 %55)
          to label %76 unwind label %63, !noalias !183

76:                                               ; preds = %68
  %77 = extractvalue { i64, i64 } %75, 0
  %78 = extractvalue { i64, i64 } %75, 1
  %79 = icmp ult i64 %77, %78
  br i1 %79, label %80, label %85

80:                                               ; preds = %76
  %81 = add i64 %78, -1
  %82 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %81, i32 2
  %83 = load i32, i32* %82, align 8, !alias.scope !183
  %84 = icmp ult i32 %57, %83
  br i1 %84, label %97, label %85

85:                                               ; preds = %97, %92, %80, %76
  %86 = phi i64 [ %55, %76 ], [ %55, %80 ], [ %77, %97 ], [ %98, %92 ]
  %87 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %86, i32 0, i32 0
  %88 = bitcast i64* %87 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %88, i8* noundef nonnull align 8 dereferenceable(176) %49, i64 176, i1 false), !noalias !187
  %89 = getelementptr inbounds i64, i64* %87, i64 22
  %90 = bitcast i64* %89 to i32*
  store i32 %57, i32* %90, align 8, !alias.scope !183, !noalias !187
  %91 = getelementptr inbounds i8, i8* %88, i64 180
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %91, i8* noundef nonnull align 8 dereferenceable(12) %50, i64 12, i1 false), !noalias !187
  call void @llvm.lifetime.end.p0i8(i64 176, i8* nonnull %49)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %50)
  br label %105

92:                                               ; preds = %97
  %93 = add i64 %98, -1
  %94 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %93, i32 2
  %95 = load i32, i32* %94, align 8, !alias.scope !183
  %96 = icmp ult i32 %57, %95
  br i1 %96, label %97, label %85

97:                                               ; preds = %92, %80
  %98 = phi i64 [ %93, %92 ], [ %81, %80 ]
  %99 = phi i64 [ %98, %92 ], [ %78, %80 ]
  %100 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %98
  %101 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %48, i64 0, i64 %99
  %102 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %101 to i8*
  %103 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %100 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %102, i8* noundef nonnull align 8 dereferenceable(192) %103, i64 192, i1 false) #11, !alias.scope !183
  %104 = icmp ult i64 %77, %98
  br i1 %104, label %92, label %85

105:                                              ; preds = %85, %52
  %106 = icmp eq i64 %54, %47
  br i1 %106, label %107, label %52

107:                                              ; preds = %293, %108, %105, %46
  ret void

108:                                              ; preds = %39
  call fastcc void @_ZN4core5slice4sort8heapsort17h9365bd4682aa485cE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41, i8** noalias nonnull align 8 dereferenceable(8) %2)
  br label %107

109:                                              ; preds = %39
  br i1 %31, label %290, label %113

110:                                              ; preds = %131
  %111 = add nuw nsw i64 %141, 1
  %112 = icmp ult i64 %141, 11
  br i1 %112, label %280, label %223

113:                                              ; preds = %290, %109
  %114 = phi i32 [ %291, %290 ], [ %42, %109 ]
  %115 = lshr i64 %41, 2
  %116 = shl nuw nsw i64 %115, 1
  %117 = mul nuw i64 %115, 3
  %118 = icmp ugt i64 %41, 49
  br i1 %118, label %145, label %119

119:                                              ; preds = %206, %113
  %120 = phi i64 [ 0, %113 ], [ %221, %206 ]
  %121 = phi i64 [ %117, %113 ], [ %222, %206 ]
  %122 = phi i64 [ %116, %113 ], [ %196, %206 ]
  %123 = phi i64 [ %115, %113 ], [ %170, %206 ]
  %124 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %122, i32 2
  %125 = load i32, i32* %124, align 8, !alias.scope !190, !noalias !193
  %126 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %123, i32 2
  %127 = load i32, i32* %126, align 8, !alias.scope !190, !noalias !193
  %128 = icmp ult i32 %125, %127
  br i1 %128, label %129, label %131

129:                                              ; preds = %119
  %130 = add nuw nsw i64 %120, 1
  br label %131

131:                                              ; preds = %129, %119
  %132 = phi i32 [ %125, %129 ], [ %127, %119 ]
  %133 = phi i64 [ %130, %129 ], [ %120, %119 ]
  %134 = phi i64 [ %123, %129 ], [ %122, %119 ]
  %135 = phi i64 [ %122, %129 ], [ %123, %119 ]
  %136 = phi i32 [ %127, %129 ], [ %125, %119 ]
  %137 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %121, i32 2
  %138 = load i32, i32* %137, align 8, !alias.scope !190, !noalias !203
  %139 = icmp ult i32 %138, %136
  %140 = zext i1 %139 to i64
  %141 = add nuw nsw i64 %133, %140
  %142 = select i1 %139, i64 %121, i64 %134
  %143 = select i1 %139, i32 %138, i32 %136
  %144 = icmp ult i32 %143, %132
  br i1 %144, label %110, label %280

145:                                              ; preds = %113
  %146 = add nsw i64 %115, -1
  %147 = add nuw nsw i64 %115, 1
  %148 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %115, i32 2
  %149 = load i32, i32* %148, align 8, !alias.scope !190, !noalias !208
  %150 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %146, i32 2
  %151 = load i32, i32* %150, align 8, !alias.scope !190, !noalias !208
  %152 = icmp ult i32 %149, %151
  br i1 %152, label %153, label %154

153:                                              ; preds = %145
  br label %154

154:                                              ; preds = %153, %145
  %155 = phi i32 [ %149, %153 ], [ %151, %145 ]
  %156 = phi i64 [ 1, %153 ], [ 0, %145 ]
  %157 = phi i64 [ %146, %153 ], [ %115, %145 ]
  %158 = phi i64 [ %115, %153 ], [ %146, %145 ]
  %159 = phi i32 [ %151, %153 ], [ %149, %145 ]
  %160 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %147, i32 2
  %161 = load i32, i32* %160, align 8, !alias.scope !190, !noalias !221
  %162 = icmp ult i32 %161, %159
  %163 = zext i1 %162 to i64
  %164 = add nuw nsw i64 %156, %163
  %165 = select i1 %162, i64 %147, i64 %157
  %166 = select i1 %162, i32 %161, i32 %159
  %167 = icmp ult i32 %166, %155
  %168 = zext i1 %167 to i64
  %169 = add nuw nsw i64 %164, %168
  %170 = select i1 %167, i64 %158, i64 %165
  %171 = add nsw i64 %116, -1
  %172 = or i64 %116, 1
  %173 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %116, i32 2
  %174 = load i32, i32* %173, align 8, !alias.scope !190, !noalias !226
  %175 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %171, i32 2
  %176 = load i32, i32* %175, align 8, !alias.scope !190, !noalias !226
  %177 = icmp ult i32 %174, %176
  br i1 %177, label %178, label %180

178:                                              ; preds = %154
  %179 = add nuw nsw i64 %169, 1
  br label %180

180:                                              ; preds = %178, %154
  %181 = phi i32 [ %174, %178 ], [ %176, %154 ]
  %182 = phi i64 [ %179, %178 ], [ %169, %154 ]
  %183 = phi i64 [ %171, %178 ], [ %116, %154 ]
  %184 = phi i64 [ %116, %178 ], [ %171, %154 ]
  %185 = phi i32 [ %176, %178 ], [ %174, %154 ]
  %186 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %172, i32 2
  %187 = load i32, i32* %186, align 8, !alias.scope !190, !noalias !239
  %188 = icmp ult i32 %187, %185
  %189 = zext i1 %188 to i64
  %190 = add nuw nsw i64 %182, %189
  %191 = select i1 %188, i64 %172, i64 %183
  %192 = select i1 %188, i32 %187, i32 %185
  %193 = icmp ult i32 %192, %181
  %194 = zext i1 %193 to i64
  %195 = add nuw nsw i64 %190, %194
  %196 = select i1 %193, i64 %184, i64 %191
  %197 = add i64 %117, -1
  %198 = add nuw i64 %117, 1
  %199 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %117, i32 2
  %200 = load i32, i32* %199, align 8, !alias.scope !190, !noalias !244
  %201 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %197, i32 2
  %202 = load i32, i32* %201, align 8, !alias.scope !190, !noalias !244
  %203 = icmp ult i32 %200, %202
  br i1 %203, label %204, label %206

204:                                              ; preds = %180
  %205 = add nuw nsw i64 %195, 1
  br label %206

206:                                              ; preds = %204, %180
  %207 = phi i32 [ %200, %204 ], [ %202, %180 ]
  %208 = phi i64 [ %205, %204 ], [ %195, %180 ]
  %209 = phi i64 [ %197, %204 ], [ %117, %180 ]
  %210 = phi i64 [ %117, %204 ], [ %197, %180 ]
  %211 = phi i32 [ %202, %204 ], [ %200, %180 ]
  %212 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %198, i32 2
  %213 = load i32, i32* %212, align 8, !alias.scope !190, !noalias !257
  %214 = icmp ult i32 %213, %211
  %215 = zext i1 %214 to i64
  %216 = add nuw nsw i64 %208, %215
  %217 = select i1 %214, i64 %198, i64 %209
  %218 = select i1 %214, i32 %213, i32 %211
  %219 = icmp ult i32 %218, %207
  %220 = zext i1 %219 to i64
  %221 = add nuw nsw i64 %216, %220
  %222 = select i1 %219, i64 %210, i64 %217
  br label %119

223:                                              ; preds = %110
  %224 = lshr i64 %41, 1
  %225 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %41, i32 0, i32 0
  %226 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 0
  %227 = bitcast i64* %225 to %"regalloc::linear_scan::analysis::RangeFrag"*
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %226, i64 %224)
  %228 = sub nsw i64 0, %224
  %229 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %228
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %229, i64 %224)
  call void @llvm.experimental.noalias.scope.decl(metadata !262)
  call void @llvm.experimental.noalias.scope.decl(metadata !265)
  br label %230

230:                                              ; preds = %230, %223
  %231 = phi i64 [ %233, %230 ], [ 0, %223 ]
  %232 = xor i64 %231, -1
  %233 = add nuw nsw i64 %231, 1
  %234 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231
  %235 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232
  call void @llvm.experimental.noalias.scope.decl(metadata !267)
  call void @llvm.experimental.noalias.scope.decl(metadata !270)
  %236 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %234 to i8*
  %237 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %235 to i8*
  %238 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %234 to <4 x i64>*
  %239 = load <4 x i64>, <4 x i64>* %238, align 8, !alias.scope !272, !noalias !275
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %236, i8* noundef nonnull align 8 dereferenceable(32) %237, i64 32, i1 false) #11, !alias.scope !276
  %240 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %235 to <4 x i64>*
  store <4 x i64> %239, <4 x i64>* %240, align 8, !alias.scope !277, !noalias !278
  %241 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1
  %242 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %241 to i8*
  %243 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1
  %244 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %243 to i8*
  %245 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %241 to <4 x i64>*
  %246 = load <4 x i64>, <4 x i64>* %245, align 8, !alias.scope !272, !noalias !275
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %242, i8* noundef nonnull align 8 dereferenceable(32) %244, i64 32, i1 false) #11, !alias.scope !276
  %247 = bitcast %"smallvec::SmallVec<[(regalloc::data_structures::InstIx, usize); 8]>"* %243 to <4 x i64>*
  store <4 x i64> %246, <4 x i64>* %247, align 8, !alias.scope !277, !noalias !278
  %248 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 2
  %249 = bitcast i64* %248 to i8*
  %250 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 2
  %251 = bitcast i64* %250 to i8*
  %252 = bitcast i64* %248 to <4 x i64>*
  %253 = load <4 x i64>, <4 x i64>* %252, align 8, !alias.scope !272, !noalias !275
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %249, i8* noundef nonnull align 8 dereferenceable(32) %251, i64 32, i1 false) #11, !alias.scope !276
  %254 = bitcast i64* %250 to <4 x i64>*
  store <4 x i64> %253, <4 x i64>* %254, align 8, !alias.scope !277, !noalias !278
  %255 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 6
  %256 = bitcast i64* %255 to i8*
  %257 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 6
  %258 = bitcast i64* %257 to i8*
  %259 = bitcast i64* %255 to <4 x i64>*
  %260 = load <4 x i64>, <4 x i64>* %259, align 8, !alias.scope !272, !noalias !275
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %256, i8* noundef nonnull align 8 dereferenceable(32) %258, i64 32, i1 false) #11, !alias.scope !276
  %261 = bitcast i64* %257 to <4 x i64>*
  store <4 x i64> %260, <4 x i64>* %261, align 8, !alias.scope !277, !noalias !278
  %262 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 10
  %263 = bitcast i64* %262 to i8*
  %264 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 10
  %265 = bitcast i64* %264 to i8*
  %266 = bitcast i64* %262 to <4 x i64>*
  %267 = load <4 x i64>, <4 x i64>* %266, align 8, !alias.scope !272, !noalias !275
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %263, i8* noundef nonnull align 8 dereferenceable(32) %265, i64 32, i1 false) #11, !alias.scope !276
  %268 = bitcast i64* %264 to <4 x i64>*
  store <4 x i64> %267, <4 x i64>* %268, align 8, !alias.scope !277, !noalias !278
  %269 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %231, i32 1, i32 1, i32 1, i64 14
  %270 = bitcast i64* %269 to i8*
  %271 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %227, i64 %232, i32 1, i32 1, i32 1, i64 14
  %272 = bitcast i64* %271 to i8*
  %273 = bitcast i64* %269 to <4 x i64>*
  %274 = load <4 x i64>, <4 x i64>* %273, align 8, !alias.scope !272, !noalias !275
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %270, i8* noundef nonnull align 8 dereferenceable(32) %272, i64 32, i1 false) #11, !alias.scope !276
  %275 = bitcast i64* %271 to <4 x i64>*
  store <4 x i64> %274, <4 x i64>* %275, align 8, !alias.scope !277, !noalias !278
  %276 = icmp eq i64 %233, %224
  br i1 %276, label %277, label %230

277:                                              ; preds = %230
  %278 = xor i64 %135, -1
  %279 = add i64 %41, %278
  br label %285

280:                                              ; preds = %131, %110
  %281 = phi i64 [ %135, %110 ], [ %142, %131 ]
  %282 = phi i64 [ %111, %110 ], [ %141, %131 ]
  %283 = icmp eq i64 %282, 0
  %284 = zext i1 %283 to i8
  br label %285

285:                                              ; preds = %280, %277
  %286 = phi i8 [ %284, %280 ], [ 1, %277 ]
  %287 = phi i64 [ %281, %280 ], [ %279, %277 ]
  %288 = icmp ne i8 %286, 0
  %289 = select i1 %30, i1 %288, i1 false
  br i1 %289, label %293, label %292

290:                                              ; preds = %109
  call fastcc void @_ZN4core5slice4sort14break_patterns17h28b110d7f3445eb0E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41)
  %291 = add i32 %42, -1
  br label %113

292:                                              ; preds = %293, %285
  br i1 %36, label %297, label %295

293:                                              ; preds = %285
  %294 = call fastcc zeroext i1 @_ZN4core5slice4sort22partial_insertion_sort17h1ae1a9d836d2ea51E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41)
  br i1 %294, label %107, label %292

295:                                              ; preds = %292
  %296 = icmp ult i64 %287, %41
  br i1 %296, label %531, label %536, !prof !106

297:                                              ; preds = %292
  call void @llvm.experimental.noalias.scope.decl(metadata !279)
  %298 = icmp eq i64 %33, 0
  br i1 %298, label %303, label %299, !prof !110

299:                                              ; preds = %531, %297
  %300 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %32, %297 ], [ %40, %531 ]
  %301 = phi i64 [ %33, %297 ], [ %41, %531 ]
  %302 = icmp ult i64 %287, %301
  br i1 %302, label %305, label %304, !prof !106

303:                                              ; preds = %297
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 0, i64 0, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.12 to %"core::panic::location::Location"*)) #12, !noalias !282
  unreachable

304:                                              ; preds = %299
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 %287, i64 %301, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.12 to %"core::panic::location::Location"*)) #12, !noalias !282
  unreachable

305:                                              ; preds = %299
  call void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17h9830139ec7d1d207E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %300, i64 %301, i64 0, i64 %287), !noalias !285
  %306 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 0
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %306, i64 1), !noalias !287
  %307 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 1
  %308 = add i64 %301, -1
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %307, i64 %308), !noalias !287
  call void @llvm.lifetime.start.p0i8(i64 176, i8* nonnull %21)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %22)
  %309 = bitcast [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %21, i8* noundef nonnull align 8 dereferenceable(176) %309, i64 176, i1 false)
  %310 = getelementptr inbounds i8, i8* %309, i64 176
  %311 = bitcast i8* %310 to i32*
  %312 = load i32, i32* %311, align 8, !alias.scope !279
  %313 = getelementptr inbounds i8, i8* %309, i64 180
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(12) %22, i8* noundef nonnull align 4 dereferenceable(12) %313, i64 12, i1 false)
  %314 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 0, i32 0, i32 0
  %315 = icmp eq i64 %308, 0
  br i1 %315, label %326, label %321

316:                                              ; preds = %347, %345
  %317 = landingpad { i8*, i32 }
          cleanup
  %318 = bitcast [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %318, i8* noundef nonnull align 8 dereferenceable(176) %21, i64 176, i1 false), !noalias !293
  %319 = getelementptr inbounds i64, i64* %314, i64 22
  %320 = bitcast i64* %319 to i32*
  store i32 %312, i32* %320, align 8, !alias.scope !279, !noalias !293
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %313, i8* noundef nonnull align 8 dereferenceable(12) %22, i64 12, i1 false), !noalias !293
  br label %61

321:                                              ; preds = %329, %305
  %322 = phi i64 [ %330, %329 ], [ 0, %305 ]
  %323 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %307, i64 %322, i32 2
  %324 = load i32, i32* %323, align 8, !alias.scope !279
  %325 = icmp ult i32 %324, %312
  br i1 %325, label %329, label %326

326:                                              ; preds = %329, %321, %305
  %327 = phi i64 [ 0, %305 ], [ %322, %321 ], [ %308, %329 ]
  %328 = call i64 @llvm.umin.i64(i64 %327, i64 %308)
  br label %332

329:                                              ; preds = %321
  %330 = add nuw i64 %322, 1
  %331 = icmp eq i64 %330, %308
  br i1 %331, label %326, label %321

332:                                              ; preds = %335, %326
  %333 = phi i64 [ %308, %326 ], [ %336, %335 ]
  %334 = icmp ugt i64 %333, %327
  br i1 %334, label %335, label %340

335:                                              ; preds = %332
  %336 = add i64 %333, -1
  %337 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 %333, i32 2
  %338 = load i32, i32* %337, align 8, !alias.scope !279
  %339 = icmp ult i32 %338, %312
  br i1 %339, label %340, label %332

340:                                              ; preds = %335, %332
  %341 = phi i64 [ %328, %332 ], [ %333, %335 ]
  %342 = icmp ult i64 %341, %327
  br i1 %342, label %345, label %343

343:                                              ; preds = %340
  %344 = icmp ugt i64 %341, %308
  br i1 %344, label %347, label %349

345:                                              ; preds = %340
  invoke void @_ZN4core5slice5index22slice_index_order_fail17h79f274959805de1fE(i64 %327, i64 %341, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.13 to %"core::panic::location::Location"*)) #12
          to label %346 unwind label %316

346:                                              ; preds = %345
  unreachable

347:                                              ; preds = %343
  invoke void @_ZN4core5slice5index24slice_end_index_len_fail17h80e02ac829cd41f5E(i64 %341, i64 %308, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.13 to %"core::panic::location::Location"*)) #12
          to label %348 unwind label %316

348:                                              ; preds = %347
  unreachable

349:                                              ; preds = %343
  %350 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %307, i64 %327
  call void @llvm.experimental.noalias.scope.decl(metadata !296)
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %23), !noalias !299
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(128) %23, i8 undef, i64 128, i1 false), !noalias !299
  %351 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %307, i64 %341
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %24), !noalias !299
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(128) %24, i8 undef, i64 128, i1 false), !noalias !299
  br label %352

352:                                              ; preds = %428, %349
  %353 = phi i8* [ null, %349 ], [ %402, %428 ]
  %354 = phi i8* [ null, %349 ], [ %429, %428 ]
  %355 = phi i64 [ 128, %349 ], [ %367, %428 ]
  %356 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %351, %349 ], [ %437, %428 ]
  %357 = phi i8* [ null, %349 ], [ %382, %428 ]
  %358 = phi i8* [ null, %349 ], [ %430, %428 ]
  %359 = phi i64 [ 128, %349 ], [ %368, %428 ]
  %360 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %350, %349 ], [ %433, %428 ]
  %361 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %356 to i64
  %362 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %360 to i64
  %363 = sub i64 %361, %362
  %364 = udiv i64 %363, 192
  %365 = icmp ult i64 %363, 49344
  br i1 %365, label %370, label %366

366:                                              ; preds = %378, %370, %352
  %367 = phi i64 [ %355, %352 ], [ %380, %378 ], [ %376, %370 ]
  %368 = phi i64 [ %359, %352 ], [ %379, %378 ], [ %377, %370 ]
  %369 = icmp eq i8* %358, %357
  br i1 %369, label %385, label %381

370:                                              ; preds = %352
  %371 = icmp ult i8* %358, %357
  %372 = icmp ult i8* %354, %353
  %373 = select i1 %371, i1 true, i1 %372
  %374 = add nsw i64 %364, -128
  %375 = select i1 %373, i64 %374, i64 %364
  %376 = select i1 %371, i64 %375, i64 %355
  %377 = select i1 %371, i64 %359, i64 %375
  br i1 %373, label %366, label %378

378:                                              ; preds = %370
  %379 = lshr i64 %375, 1
  %380 = sub i64 %375, %379
  br label %366

381:                                              ; preds = %387, %385, %366
  %382 = phi i8* [ %357, %366 ], [ %23, %385 ], [ %398, %387 ]
  %383 = phi i8* [ %358, %366 ], [ %23, %385 ], [ %23, %387 ]
  %384 = icmp eq i8* %354, %353
  br i1 %384, label %413, label %401

385:                                              ; preds = %366
  %386 = icmp eq i64 %368, 0
  br i1 %386, label %381, label %387

387:                                              ; preds = %387, %385
  %388 = phi i8* [ %398, %387 ], [ %23, %385 ]
  %389 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %399, %387 ], [ %360, %385 ]
  %390 = phi i64 [ %391, %387 ], [ 0, %385 ]
  %391 = add nuw i64 %390, 1
  %392 = trunc i64 %390 to i8
  store i8 %392, i8* %388, align 1, !noalias !299
  %393 = icmp ne %"regalloc::linear_scan::analysis::RangeFrag"* %389, null
  call void @llvm.assume(i1 %393)
  %394 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %389, i64 0, i32 2
  %395 = load i32, i32* %394, align 8, !alias.scope !301, !noalias !302
  %396 = icmp uge i32 %395, %312
  %397 = zext i1 %396 to i64
  %398 = getelementptr inbounds i8, i8* %388, i64 %397
  %399 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %389, i64 1
  %400 = icmp eq i64 %391, %368
  br i1 %400, label %381, label %387

401:                                              ; preds = %415, %413, %381
  %402 = phi i8* [ %353, %381 ], [ %24, %413 ], [ %426, %415 ]
  %403 = phi i8* [ %354, %381 ], [ %24, %413 ], [ %24, %415 ]
  %404 = ptrtoint i8* %382 to i64
  %405 = ptrtoint i8* %383 to i64
  %406 = sub i64 %404, %405
  %407 = ptrtoint i8* %402 to i64
  %408 = ptrtoint i8* %403 to i64
  %409 = sub i64 %407, %408
  %410 = icmp ugt i64 %406, %409
  %411 = select i1 %410, i64 %409, i64 %406
  %412 = icmp eq i64 %411, 0
  br i1 %412, label %428, label %438

413:                                              ; preds = %381
  %414 = icmp eq i64 %367, 0
  br i1 %414, label %401, label %415

415:                                              ; preds = %415, %413
  %416 = phi i8* [ %426, %415 ], [ %24, %413 ]
  %417 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %420, %415 ], [ %356, %413 ]
  %418 = phi i64 [ %419, %415 ], [ 0, %413 ]
  %419 = add nuw i64 %418, 1
  %420 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 -1
  %421 = trunc i64 %418 to i8
  store i8 %421, i8* %416, align 1, !noalias !299
  %422 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %417, i64 -1, i32 2
  %423 = load i32, i32* %422, align 8, !alias.scope !301, !noalias !302
  %424 = icmp ult i32 %423, %312
  %425 = zext i1 %424 to i64
  %426 = getelementptr inbounds i8, i8* %416, i64 %425
  %427 = icmp eq i64 %419, %367
  br i1 %427, label %401, label %415

428:                                              ; preds = %477, %401
  %429 = phi i8* [ %482, %477 ], [ %403, %401 ]
  %430 = phi i8* [ %481, %477 ], [ %383, %401 ]
  %431 = icmp eq i8* %430, %382
  %432 = select i1 %431, i64 %368, i64 0
  %433 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %432
  %434 = icmp eq i8* %429, %402
  %435 = sub i64 0, %367
  %436 = select i1 %434, i64 %435, i64 0
  %437 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %436
  br i1 %365, label %483, label %352

438:                                              ; preds = %401
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %25)
  %439 = load i8, i8* %383, align 1, !noalias !299
  %440 = zext i8 %439 to i64
  %441 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %440
  %442 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %441 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %25, i8* noundef nonnull align 8 dereferenceable(192) %442, i64 192, i1 false) #11, !noalias !302
  %443 = load i8, i8* %403, align 1, !noalias !299
  %444 = zext i8 %443 to i64
  %445 = xor i64 %444, -1
  %446 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %445
  %447 = load i8, i8* %383, align 1, !noalias !299
  %448 = zext i8 %447 to i64
  %449 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %448
  %450 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %449 to i8*
  %451 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %446 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %450, i8* noundef nonnull align 8 dereferenceable(192) %451, i64 192, i1 false) #11, !alias.scope !301, !noalias !302
  %452 = icmp eq i64 %411, 1
  br i1 %452, label %477, label %453

453:                                              ; preds = %453, %438
  %454 = phi i8 [ %469, %453 ], [ %443, %438 ]
  %455 = phi i8* [ %459, %453 ], [ %383, %438 ]
  %456 = phi i8* [ %468, %453 ], [ %403, %438 ]
  %457 = phi i64 [ %458, %453 ], [ 1, %438 ]
  %458 = add nuw i64 %457, 1
  %459 = getelementptr inbounds i8, i8* %455, i64 1
  %460 = load i8, i8* %459, align 1, !noalias !299
  %461 = zext i8 %460 to i64
  %462 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %360, i64 %461
  %463 = zext i8 %454 to i64
  %464 = xor i64 %463, -1
  %465 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %464
  %466 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %465 to i8*
  %467 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %462 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %466, i8* noundef nonnull align 8 dereferenceable(192) %467, i64 192, i1 false) #11, !alias.scope !301, !noalias !302
  %468 = getelementptr inbounds i8, i8* %456, i64 1
  %469 = load i8, i8* %468, align 1, !noalias !299
  %470 = zext i8 %469 to i64
  %471 = xor i64 %470, -1
  %472 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %356, i64 %471
  %473 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %472 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %467, i8* noundef nonnull align 8 dereferenceable(192) %473, i64 192, i1 false) #11, !alias.scope !301, !noalias !302
  %474 = icmp eq i64 %458, %411
  br i1 %474, label %475, label %453

475:                                              ; preds = %453
  %476 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %472 to i8*
  br label %477

477:                                              ; preds = %475, %438
  %478 = phi i8* [ %451, %438 ], [ %476, %475 ]
  %479 = phi i8* [ %403, %438 ], [ %468, %475 ]
  %480 = phi i8* [ %383, %438 ], [ %459, %475 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %478, i8* noundef nonnull align 8 dereferenceable(192) %25, i64 192, i1 false) #11, !noalias !302
  %481 = getelementptr inbounds i8, i8* %480, i64 1
  %482 = getelementptr inbounds i8, i8* %479, i64 1
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %25)
  br label %428

483:                                              ; preds = %428
  %484 = icmp ult i8* %430, %382
  br i1 %484, label %487, label %485

485:                                              ; preds = %483
  %486 = icmp ult i8* %429, %402
  br i1 %486, label %498, label %510

487:                                              ; preds = %487, %483
  %488 = phi i8* [ %490, %487 ], [ %382, %483 ]
  %489 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %494, %487 ], [ %437, %483 ]
  %490 = getelementptr inbounds i8, i8* %488, i64 -1
  %491 = load i8, i8* %490, align 1, !noalias !299
  %492 = zext i8 %491 to i64
  %493 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %433, i64 %492
  %494 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %489, i64 -1
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %27)
  %495 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %493 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %27, i8* noundef nonnull align 8 dereferenceable(192) %495, i64 192, i1 false) #11, !noalias !302
  %496 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %494 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %495, i8* noundef nonnull align 8 dereferenceable(192) %496, i64 192, i1 false) #11, !alias.scope !301, !noalias !302
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %496, i8* noundef nonnull align 8 dereferenceable(192) %27, i64 192, i1 false) #11, !noalias !302
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %27)
  %497 = icmp ult i8* %430, %490
  br i1 %497, label %487, label %510

498:                                              ; preds = %498, %485
  %499 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %508, %498 ], [ %433, %485 ]
  %500 = phi i8* [ %501, %498 ], [ %402, %485 ]
  %501 = getelementptr inbounds i8, i8* %500, i64 -1
  %502 = load i8, i8* %501, align 1, !noalias !299
  %503 = zext i8 %502 to i64
  %504 = xor i64 %503, -1
  %505 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %437, i64 %504
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %26)
  %506 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %499 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %26, i8* noundef nonnull align 8 dereferenceable(192) %506, i64 192, i1 false) #11, !noalias !302
  %507 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %505 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %506, i8* noundef nonnull align 8 dereferenceable(192) %507, i64 192, i1 false) #11, !alias.scope !301, !noalias !302
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %507, i8* noundef nonnull align 8 dereferenceable(192) %26, i64 192, i1 false) #11, !noalias !302
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %26)
  %508 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %499, i64 1
  %509 = icmp ult i8* %429, %501
  br i1 %509, label %498, label %510

510:                                              ; preds = %498, %487, %485
  %511 = phi %"regalloc::linear_scan::analysis::RangeFrag"* [ %433, %485 ], [ %494, %487 ], [ %508, %498 ]
  %512 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %511 to i64
  %513 = ptrtoint %"regalloc::linear_scan::analysis::RangeFrag"* %350 to i64
  %514 = sub i64 %512, %513
  %515 = udiv i64 %514, 192
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %24), !noalias !299
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %23), !noalias !299
  %516 = add i64 %515, %327
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %309, i8* noundef nonnull align 8 dereferenceable(176) %21, i64 176, i1 false), !noalias !303
  %517 = getelementptr inbounds i64, i64* %314, i64 22
  %518 = bitcast i64* %517 to i32*
  store i32 %312, i32* %518, align 8, !alias.scope !279, !noalias !303
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %313, i8* noundef nonnull align 8 dereferenceable(12) %22, i64 12, i1 false), !noalias !303
  call void @llvm.lifetime.end.p0i8(i64 176, i8* nonnull %21)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %22)
  %519 = icmp ugt i64 %301, %516
  br i1 %519, label %521, label %520, !prof !106

520:                                              ; preds = %510
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 %516, i64 %301, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.14 to %"core::panic::location::Location"*)) #12, !noalias !306
  unreachable

521:                                              ; preds = %510
  %522 = icmp uge i64 %327, %341
  call void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17h9830139ec7d1d207E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %300, i64 %301, i64 0, i64 %516), !noalias !309
  %523 = sub i64 %301, %516
  %524 = icmp ugt i64 %516, %523
  %525 = select i1 %524, i64 %523, i64 %516
  %526 = lshr i64 %301, 3
  %527 = icmp ult i64 %525, %526
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %306, i64 %516), !noalias !311
  %528 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %300, i64 0, i64 %516
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %528, i64 %523), !noalias !311
  %529 = icmp eq i64 %523, 0
  br i1 %529, label %530, label %586

530:                                              ; preds = %521
  call void @_ZN4core9panicking5panic17h97167cd315d19cd4E([0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [35 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.19 to [0 x i8]*), i64 35, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.18 to %"core::panic::location::Location"*)) #12, !noalias !317
  unreachable

531:                                              ; preds = %295
  %532 = load i32, i32* %38, align 8
  %533 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %287, i32 2
  %534 = load i32, i32* %533, align 8
  %535 = icmp ult i32 %532, %534
  br i1 %535, label %299, label %537

536:                                              ; preds = %295
  call void @_ZN4core9panicking18panic_bounds_check17h449d4ff4d992b84fE(i64 %287, i64 %41, %"core::panic::location::Location"* noalias readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.16 to %"core::panic::location::Location"*)) #12
  unreachable

537:                                              ; preds = %531
  call void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17h9830139ec7d1d207E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %40, i64 %41, i64 0, i64 %287), !noalias !321
  %538 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 0
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %538, i64 1), !noalias !324
  %539 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 1
  %540 = add i64 %41, -1
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %539, i64 %540), !noalias !324
  call void @llvm.lifetime.start.p0i8(i64 176, i8* nonnull %18)
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %19)
  %541 = bitcast [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %18, i8* noundef nonnull align 8 dereferenceable(176) %541, i64 176, i1 false)
  %542 = getelementptr inbounds i8, i8* %541, i64 176
  %543 = bitcast i8* %542 to i32*
  %544 = load i32, i32* %543, align 8, !alias.scope !330
  %545 = getelementptr inbounds i8, i8* %541, i64 180
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(12) %19, i8* noundef nonnull align 4 dereferenceable(12) %545, i64 12, i1 false)
  br label %546

546:                                              ; preds = %568, %537
  %547 = phi i64 [ %564, %568 ], [ %540, %537 ]
  %548 = phi i64 [ %573, %568 ], [ 0, %537 ]
  %549 = icmp ult i64 %548, %547
  br i1 %549, label %550, label %555

550:                                              ; preds = %557, %546
  %551 = phi i64 [ %558, %557 ], [ %548, %546 ]
  %552 = getelementptr %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %539, i64 %551, i32 2
  %553 = load i32, i32* %552, align 8, !alias.scope !330
  %554 = icmp ult i32 %544, %553
  br i1 %554, label %555, label %557

555:                                              ; preds = %557, %550, %546
  %556 = phi i64 [ %548, %546 ], [ %551, %550 ], [ %547, %557 ]
  br label %560

557:                                              ; preds = %550
  %558 = add i64 %551, 1
  %559 = icmp eq i64 %558, %547
  br i1 %559, label %555, label %550

560:                                              ; preds = %563, %555
  %561 = phi i64 [ %547, %555 ], [ %564, %563 ]
  %562 = icmp ult i64 %556, %561
  br i1 %562, label %563, label %574

563:                                              ; preds = %560
  %564 = add i64 %561, -1
  %565 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %561, i32 2
  %566 = load i32, i32* %565, align 8, !alias.scope !330
  %567 = icmp ult i32 %544, %566
  br i1 %567, label %560, label %568

568:                                              ; preds = %563
  %569 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %539, i64 %556
  %570 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %561
  call void @llvm.lifetime.start.p0i8(i64 192, i8* nonnull %20)
  %571 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %569 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %20, i8* noundef nonnull align 8 dereferenceable(192) %571, i64 192, i1 false) #11
  %572 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %570 to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %571, i8* noundef nonnull align 8 dereferenceable(192) %572, i64 192, i1 false) #11, !alias.scope !330
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(192) %572, i8* noundef nonnull align 8 dereferenceable(192) %20, i64 192, i1 false) #11
  call void @llvm.lifetime.end.p0i8(i64 192, i8* nonnull %20)
  %573 = add nuw i64 %556, 1
  br label %546

574:                                              ; preds = %560
  %575 = getelementptr [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 0, i32 0, i32 0
  %576 = add i64 %556, 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(176) %541, i8* noundef nonnull align 8 dereferenceable(176) %18, i64 176, i1 false), !noalias !333
  %577 = getelementptr inbounds i64, i64* %575, i64 22
  %578 = bitcast i64* %577 to i32*
  store i32 %544, i32* %578, align 8, !alias.scope !330, !noalias !333
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %545, i8* noundef nonnull align 8 dereferenceable(12) %19, i64 12, i1 false), !noalias !333
  call void @llvm.lifetime.end.p0i8(i64 176, i8* nonnull %18)
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %19)
  %579 = icmp ult i64 %41, %576
  br i1 %579, label %580, label %581

580:                                              ; preds = %574
  call void @_ZN4core5slice5index26slice_start_index_len_fail17haac0d373d67dca37E(i64 %576, i64 %41, %"core::panic::location::Location"* noalias nonnull readonly align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @anon.d6c3d094ad60d520064373e3df1e5641.17 to %"core::panic::location::Location"*)) #12, !noalias !336
  unreachable

581:                                              ; preds = %574
  %582 = getelementptr inbounds [0 x %"regalloc::linear_scan::analysis::RangeFrag"], [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* %40, i64 0, i64 %576
  %583 = sub i64 %41, %576
  %584 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %582 to [0 x %"regalloc::linear_scan::analysis::RangeFrag"]*
  %585 = icmp ult i64 %583, 21
  br i1 %585, label %44, label %39

586:                                              ; preds = %521
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %528, i64 1), !noalias !341
  %587 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %528, i64 1
  %588 = add i64 %523, -1
  call void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nonnull %587, i64 %588), !noalias !341
  %589 = bitcast %"regalloc::linear_scan::analysis::RangeFrag"* %587 to [0 x %"regalloc::linear_scan::analysis::RangeFrag"]*
  %590 = icmp ult i64 %516, %588
  br i1 %590, label %593, label %591

591:                                              ; preds = %586
  %592 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %528, i64 0, i32 0, i32 0
  call fastcc void @_ZN4core5slice4sort7recurse17h37cd075f67b5ff92E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %589, i64 %588, i8** noalias nonnull align 8 dereferenceable(8) %2, i64* noalias nonnull readonly align 8 dereferenceable_or_null(192) %592, i32 %114)
  br label %595

593:                                              ; preds = %586
  call fastcc void @_ZN4core5slice4sort7recurse17h37cd075f67b5ff92E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8 %300, i64 %516, i8** noalias nonnull align 8 dereferenceable(8) %2, i64* noalias readonly align 8 dereferenceable_or_null(192) %34, i32 %114)
  %594 = getelementptr inbounds %"regalloc::linear_scan::analysis::RangeFrag", %"regalloc::linear_scan::analysis::RangeFrag"* %528, i64 0, i32 0, i32 0
  br label %595

595:                                              ; preds = %593, %591
  %596 = phi i64* [ %594, %593 ], [ %34, %591 ]
  %597 = phi i64 [ %588, %593 ], [ %516, %591 ]
  %598 = phi [0 x %"regalloc::linear_scan::analysis::RangeFrag"]* [ %589, %593 ], [ %300, %591 ]
  %599 = xor i1 %527, true
  %600 = select i1 %599, i1 %522, i1 false
  %601 = icmp ult i64 %597, 21
  br i1 %601, label %46, label %29
}

; Function Attrs: cold nonlazybind uwtable
declare hidden fastcc void @_ZN4core5slice4sort8heapsort17h9365bd4682aa485cE([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8, i64, i8** noalias align 8 dereferenceable(8)) unnamed_addr #8

; Function Attrs: cold nonlazybind uwtable
declare hidden fastcc void @_ZN4core5slice4sort14break_patterns17h28b110d7f3445eb0E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8, i64) unnamed_addr #8

; Function Attrs: cold nonlazybind uwtable
declare hidden fastcc zeroext i1 @_ZN4core5slice4sort22partial_insertion_sort17h1ae1a9d836d2ea51E([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nonnull align 8, i64) unnamed_addr #8

; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind readnone uwtable willreturn
declare hidden void @_ZN4core5slice3raw20debug_check_data_len17hd22b0b06f11db5cdE(%"regalloc::linear_scan::analysis::RangeFrag"* nocapture readnone, i64) unnamed_addr #10

; Function Attrs: mustprogress nofree nosync nounwind nonlazybind uwtable willreturn
declare hidden void @"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$14swap_unchecked17h9830139ec7d1d207E"([0 x %"regalloc::linear_scan::analysis::RangeFrag"]* noalias nocapture nonnull align 8, i64, i64, i64) unnamed_addr #6

; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind readnone uwtable willreturn
declare hidden { i64, i64 } @"_ZN4core4iter8adapters3rev12Rev$LT$T$GT$3new17h8f874c5e95c6a2d0E"(i64, i64) unnamed_addr #10

declare { i64, i64 } @"_ZN4core4iter8adapters3rev12Rev$LT$T$GT$3new17h8f773365797c4ef1E"(i64, i64)

declare void @_ZN4core5slice3raw20debug_check_data_len17h12aaa731f5340bb2E(%"regalloc::linear_scan::analysis::RangeFrag"*, i64)

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
attributes #4 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { mustprogress nofree nosync nounwind nonlazybind uwtable willreturn "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #7 = { nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #8 = { cold nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #9 = { nounwind nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #10 = { mustprogress nofree norecurse nosync nounwind nonlazybind readnone uwtable willreturn "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #11 = { nounwind }
attributes #12 = { noreturn }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.dbg.cu = !{}

!0 = !{i32 7, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 2, !"RtLibUseGOT", i32 1}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{!5}
!5 = distinct !{!5, !6, !"_ZN4core5slice4sort14insertion_sort17h289b47cdeacc294dE: argument 0"}
!6 = distinct !{!6, !"_ZN4core5slice4sort14insertion_sort17h289b47cdeacc294dE"}
!7 = !{!8}
!8 = distinct !{!8, !9, !"_ZN4core5slice4sort10shift_tail17h0f6d64a1f71d080cE: argument 0"}
!9 = distinct !{!9, !"_ZN4core5slice4sort10shift_tail17h0f6d64a1f71d080cE"}
!10 = !{!8, !5}
!11 = !{!12}
!12 = distinct !{!12, !13, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE: argument 0"}
!13 = distinct !{!13, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE"}
!14 = !{!15}
!15 = distinct !{!15, !16, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE: argument 0"}
!16 = distinct !{!16, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE"}
!17 = !{!18}
!18 = distinct !{!18, !19, !"_ZN4core5slice4sort12choose_pivot17h7f2fcb297a703dedE: argument 0"}
!19 = distinct !{!19, !"_ZN4core5slice4sort12choose_pivot17h7f2fcb297a703dedE"}
!20 = !{!21, !23, !24, !25, !27, !28, !29}
!21 = distinct !{!21, !22, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!22 = distinct !{!22, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!23 = distinct !{!23, !22, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!24 = distinct !{!24, !22, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!25 = distinct !{!25, !26, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 0"}
!26 = distinct !{!26, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E"}
!27 = distinct !{!27, !26, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 1"}
!28 = distinct !{!28, !26, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 2"}
!29 = distinct !{!29, !26, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 3"}
!30 = !{!31, !33, !34, !25, !27, !28, !29}
!31 = distinct !{!31, !32, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!32 = distinct !{!32, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!33 = distinct !{!33, !32, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!34 = distinct !{!34, !32, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!35 = !{!36, !38, !39, !40, !42, !43, !44, !45, !47}
!36 = distinct !{!36, !37, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!37 = distinct !{!37, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!38 = distinct !{!38, !37, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!39 = distinct !{!39, !37, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!40 = distinct !{!40, !41, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 0"}
!41 = distinct !{!41, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E"}
!42 = distinct !{!42, !41, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 1"}
!43 = distinct !{!43, !41, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 2"}
!44 = distinct !{!44, !41, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 3"}
!45 = distinct !{!45, !46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 0"}
!46 = distinct !{!46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE"}
!47 = distinct !{!47, !46, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 1"}
!48 = !{!49, !51, !52, !40, !42, !43, !44, !45, !47}
!49 = distinct !{!49, !50, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!50 = distinct !{!50, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!51 = distinct !{!51, !50, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!52 = distinct !{!52, !50, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!53 = !{!54, !56, !57, !58, !60, !61, !62, !63, !65}
!54 = distinct !{!54, !55, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!55 = distinct !{!55, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!56 = distinct !{!56, !55, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!57 = distinct !{!57, !55, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!58 = distinct !{!58, !59, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 0"}
!59 = distinct !{!59, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E"}
!60 = distinct !{!60, !59, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 1"}
!61 = distinct !{!61, !59, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 2"}
!62 = distinct !{!62, !59, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 3"}
!63 = distinct !{!63, !64, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 0"}
!64 = distinct !{!64, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE"}
!65 = distinct !{!65, !64, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 1"}
!66 = !{!67, !69, !70, !58, !60, !61, !62, !63, !65}
!67 = distinct !{!67, !68, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!68 = distinct !{!68, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!69 = distinct !{!69, !68, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!70 = distinct !{!70, !68, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!71 = !{!72, !74, !75, !76, !78, !79, !80, !81, !83}
!72 = distinct !{!72, !73, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!73 = distinct !{!73, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!74 = distinct !{!74, !73, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!75 = distinct !{!75, !73, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!76 = distinct !{!76, !77, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 0"}
!77 = distinct !{!77, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E"}
!78 = distinct !{!78, !77, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 1"}
!79 = distinct !{!79, !77, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 2"}
!80 = distinct !{!80, !77, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17h080a348e52611525E: argument 3"}
!81 = distinct !{!81, !82, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 0"}
!82 = distinct !{!82, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE"}
!83 = distinct !{!83, !82, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hd6f54e18160f6ddaE: argument 1"}
!84 = !{!85, !87, !88, !76, !78, !79, !80, !81, !83}
!85 = distinct !{!85, !86, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 0"}
!86 = distinct !{!86, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E"}
!87 = distinct !{!87, !86, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 1"}
!88 = distinct !{!88, !86, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hb03a2e0fb7c80e56E: argument 2"}
!89 = !{!90}
!90 = distinct !{!90, !91, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse7revswap17h61188dc3094b9dacE: argument 0"}
!91 = distinct !{!91, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse7revswap17h61188dc3094b9dacE"}
!92 = !{!93}
!93 = distinct !{!93, !91, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse7revswap17h61188dc3094b9dacE: argument 1"}
!94 = !{!95}
!95 = distinct !{!95, !96, !"_ZN4core3mem4swap17h7dcb2a8b53a291cfE: argument 0"}
!96 = distinct !{!96, !"_ZN4core3mem4swap17h7dcb2a8b53a291cfE"}
!97 = !{!98}
!98 = distinct !{!98, !96, !"_ZN4core3mem4swap17h7dcb2a8b53a291cfE: argument 1"}
!99 = !{!95, !90, !100, !18}
!100 = distinct !{!100, !101, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse17he22f61056b826c87E: argument 0"}
!101 = distinct !{!101, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse17he22f61056b826c87E"}
!102 = !{!98, !93}
!103 = !{!95, !98, !90, !93, !100, !18}
!104 = !{!98, !93, !100, !18}
!105 = !{!95, !90}
!106 = !{!"branch_weights", i32 2000, i32 1}
!107 = !{!108}
!108 = distinct !{!108, !109, !"_ZN4core5slice4sort9partition17hf887a6d8f80d4169E: argument 0"}
!109 = distinct !{!109, !"_ZN4core5slice4sort9partition17hf887a6d8f80d4169E"}
!110 = !{!"branch_weights", i32 1, i32 2000}
!111 = !{!112}
!112 = distinct !{!112, !113, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E: argument 0"}
!113 = distinct !{!113, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E"}
!114 = !{!115}
!115 = distinct !{!115, !113, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E: argument 1"}
!116 = !{!117, !119, !121}
!117 = distinct !{!117, !118, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E: argument 0"}
!118 = distinct !{!118, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E"}
!119 = distinct !{!119, !120, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 0"}
!120 = distinct !{!120, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE"}
!121 = distinct !{!121, !120, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 2"}
!122 = !{!123}
!123 = distinct !{!123, !124, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE: argument 0"}
!124 = distinct !{!124, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE"}
!125 = !{!126}
!126 = distinct !{!126, !127, !"_ZN4core5slice4sort19partition_in_blocks17h4cbf5d7ff413fc94E: argument 0"}
!127 = distinct !{!127, !"_ZN4core5slice4sort19partition_in_blocks17h4cbf5d7ff413fc94E"}
!128 = !{!126, !129, !108}
!129 = distinct !{!129, !127, !"_ZN4core5slice4sort19partition_in_blocks17h4cbf5d7ff413fc94E: argument 1"}
!130 = !{!126, !108}
!131 = !{!129}
!132 = distinct !{!132, !133}
!133 = !{!"llvm.loop.unroll.disable"}
!134 = distinct !{!134, !133}
!135 = !{!136}
!136 = distinct !{!136, !137, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE: argument 0"}
!137 = distinct !{!137, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE"}
!138 = !{!139}
!139 = distinct !{!139, !140, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E: argument 0"}
!140 = distinct !{!140, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E"}
!141 = !{!142}
!142 = distinct !{!142, !140, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E: argument 1"}
!143 = !{!144, !146, !148}
!144 = distinct !{!144, !145, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E: argument 0"}
!145 = distinct !{!145, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E"}
!146 = distinct !{!146, !147, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 0"}
!147 = distinct !{!147, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE"}
!148 = distinct !{!148, !147, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 2"}
!149 = !{!150, !152}
!150 = distinct !{!150, !151, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 0"}
!151 = distinct !{!151, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE"}
!152 = distinct !{!152, !151, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 1"}
!153 = !{!154}
!154 = distinct !{!154, !155, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E: argument 1"}
!155 = distinct !{!155, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hd9ac2816d6eead16E"}
!156 = !{!157, !159, !161}
!157 = distinct !{!157, !158, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E: argument 0"}
!158 = distinct !{!158, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E"}
!159 = distinct !{!159, !160, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 0"}
!160 = distinct !{!160, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE"}
!161 = distinct !{!161, !160, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 2"}
!162 = !{!163}
!163 = distinct !{!163, !164, !"_ZN4core5slice4sort15partition_equal17h934a6a3ecee78c93E: argument 0"}
!164 = distinct !{!164, !"_ZN4core5slice4sort15partition_equal17h934a6a3ecee78c93E"}
!165 = !{!166}
!166 = distinct !{!166, !167, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE: argument 0"}
!167 = distinct !{!167, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he83b55495f441a1eE"}
!168 = !{!169, !171}
!169 = distinct !{!169, !170, !"_ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h86c36b5596a8dd22E: argument 0"}
!170 = distinct !{!170, !"_ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h86c36b5596a8dd22E"}
!171 = distinct !{!171, !172, !"_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17h0176f7f04d894f9aE: argument 0"}
!172 = distinct !{!172, !"_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17h0176f7f04d894f9aE"}
!173 = !{!174, !150, !176}
!174 = distinct !{!174, !175, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E: argument 0"}
!175 = distinct !{!175, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17hbc02297db61ae1f9E"}
!176 = distinct !{!176, !151, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17hda5cb1a5d80ec20cE: argument 2"}
!177 = !{!178}
!178 = distinct !{!178, !179, !"_ZN4core5slice4sort14insertion_sort17ha9f86e4201a75615E: argument 0"}
!179 = distinct !{!179, !"_ZN4core5slice4sort14insertion_sort17ha9f86e4201a75615E"}
!180 = !{!181}
!181 = distinct !{!181, !182, !"_ZN4core5slice4sort10shift_tail17h980a8d3140fd2559E: argument 0"}
!182 = distinct !{!182, !"_ZN4core5slice4sort10shift_tail17h980a8d3140fd2559E"}
!183 = !{!181, !178}
!184 = !{!185}
!185 = distinct !{!185, !186, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE: argument 0"}
!186 = distinct !{!186, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE"}
!187 = !{!188}
!188 = distinct !{!188, !189, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE: argument 0"}
!189 = distinct !{!189, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE"}
!190 = !{!191}
!191 = distinct !{!191, !192, !"_ZN4core5slice4sort12choose_pivot17he7ac1307dfa88db3E: argument 0"}
!192 = distinct !{!192, !"_ZN4core5slice4sort12choose_pivot17he7ac1307dfa88db3E"}
!193 = !{!194, !196, !197, !198, !200, !201, !202}
!194 = distinct !{!194, !195, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!195 = distinct !{!195, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!196 = distinct !{!196, !195, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!197 = distinct !{!197, !195, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!198 = distinct !{!198, !199, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 0"}
!199 = distinct !{!199, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E"}
!200 = distinct !{!200, !199, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 1"}
!201 = distinct !{!201, !199, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 2"}
!202 = distinct !{!202, !199, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 3"}
!203 = !{!204, !206, !207, !198, !200, !201, !202}
!204 = distinct !{!204, !205, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!205 = distinct !{!205, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!206 = distinct !{!206, !205, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!207 = distinct !{!207, !205, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!208 = !{!209, !211, !212, !213, !215, !216, !217, !218, !220}
!209 = distinct !{!209, !210, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!210 = distinct !{!210, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!211 = distinct !{!211, !210, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!212 = distinct !{!212, !210, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!213 = distinct !{!213, !214, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 0"}
!214 = distinct !{!214, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E"}
!215 = distinct !{!215, !214, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 1"}
!216 = distinct !{!216, !214, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 2"}
!217 = distinct !{!217, !214, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 3"}
!218 = distinct !{!218, !219, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E: argument 0"}
!219 = distinct !{!219, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E"}
!220 = distinct !{!220, !219, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E: argument 1"}
!221 = !{!222, !224, !225, !213, !215, !216, !217, !218, !220}
!222 = distinct !{!222, !223, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!223 = distinct !{!223, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!224 = distinct !{!224, !223, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!225 = distinct !{!225, !223, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!226 = !{!227, !229, !230, !231, !233, !234, !235, !236, !238}
!227 = distinct !{!227, !228, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!228 = distinct !{!228, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!229 = distinct !{!229, !228, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!230 = distinct !{!230, !228, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!231 = distinct !{!231, !232, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 0"}
!232 = distinct !{!232, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E"}
!233 = distinct !{!233, !232, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 1"}
!234 = distinct !{!234, !232, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 2"}
!235 = distinct !{!235, !232, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 3"}
!236 = distinct !{!236, !237, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E: argument 0"}
!237 = distinct !{!237, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E"}
!238 = distinct !{!238, !237, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E: argument 1"}
!239 = !{!240, !242, !243, !231, !233, !234, !235, !236, !238}
!240 = distinct !{!240, !241, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!241 = distinct !{!241, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!242 = distinct !{!242, !241, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!243 = distinct !{!243, !241, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!244 = !{!245, !247, !248, !249, !251, !252, !253, !254, !256}
!245 = distinct !{!245, !246, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!246 = distinct !{!246, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!247 = distinct !{!247, !246, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!248 = distinct !{!248, !246, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!249 = distinct !{!249, !250, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 0"}
!250 = distinct !{!250, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E"}
!251 = distinct !{!251, !250, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 1"}
!252 = distinct !{!252, !250, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 2"}
!253 = distinct !{!253, !250, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hf08ae264d81ebf28E: argument 3"}
!254 = distinct !{!254, !255, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E: argument 0"}
!255 = distinct !{!255, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E"}
!256 = distinct !{!256, !255, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hc06cbba5523f3723E: argument 1"}
!257 = !{!258, !260, !261, !249, !251, !252, !253, !254, !256}
!258 = distinct !{!258, !259, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 0"}
!259 = distinct !{!259, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE"}
!260 = distinct !{!260, !259, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 1"}
!261 = distinct !{!261, !259, !"_ZN4core5slice4sort12choose_pivot28_$u7b$$u7b$closure$u7d$$u7d$17hccf75224704a4efaE: argument 2"}
!262 = !{!263}
!263 = distinct !{!263, !264, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse7revswap17h40d4a6c815f5108bE: argument 0"}
!264 = distinct !{!264, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse7revswap17h40d4a6c815f5108bE"}
!265 = !{!266}
!266 = distinct !{!266, !264, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse7revswap17h40d4a6c815f5108bE: argument 1"}
!267 = !{!268}
!268 = distinct !{!268, !269, !"_ZN4core3mem4swap17h9f9c85991c057b21E: argument 0"}
!269 = distinct !{!269, !"_ZN4core3mem4swap17h9f9c85991c057b21E"}
!270 = !{!271}
!271 = distinct !{!271, !269, !"_ZN4core3mem4swap17h9f9c85991c057b21E: argument 1"}
!272 = !{!268, !263, !273, !191}
!273 = distinct !{!273, !274, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse17h116835ad5bc774f3E: argument 0"}
!274 = distinct !{!274, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$7reverse17h116835ad5bc774f3E"}
!275 = !{!271, !266}
!276 = !{!268, !271, !263, !266, !273, !191}
!277 = !{!271, !266, !273, !191}
!278 = !{!268, !263}
!279 = !{!280}
!280 = distinct !{!280, !281, !"_ZN4core5slice4sort9partition17h78d95f188b423b1dE: argument 0"}
!281 = distinct !{!281, !"_ZN4core5slice4sort9partition17h78d95f188b423b1dE"}
!282 = !{!283}
!283 = distinct !{!283, !284, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E: argument 0"}
!284 = distinct !{!284, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E"}
!285 = !{!286}
!286 = distinct !{!286, !284, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E: argument 1"}
!287 = !{!288, !290, !292}
!288 = distinct !{!288, !289, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E: argument 0"}
!289 = distinct !{!289, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E"}
!290 = distinct !{!290, !291, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 0"}
!291 = distinct !{!291, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E"}
!292 = distinct !{!292, !291, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 2"}
!293 = !{!294}
!294 = distinct !{!294, !295, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE: argument 0"}
!295 = distinct !{!295, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE"}
!296 = !{!297}
!297 = distinct !{!297, !298, !"_ZN4core5slice4sort19partition_in_blocks17h3475b3b9c11091e1E: argument 0"}
!298 = distinct !{!298, !"_ZN4core5slice4sort19partition_in_blocks17h3475b3b9c11091e1E"}
!299 = !{!297, !300, !280}
!300 = distinct !{!300, !298, !"_ZN4core5slice4sort19partition_in_blocks17h3475b3b9c11091e1E: argument 1"}
!301 = !{!297, !280}
!302 = !{!300}
!303 = !{!304}
!304 = distinct !{!304, !305, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE: argument 0"}
!305 = distinct !{!305, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE"}
!306 = !{!307}
!307 = distinct !{!307, !308, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E: argument 0"}
!308 = distinct !{!308, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E"}
!309 = !{!310}
!310 = distinct !{!310, !308, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E: argument 1"}
!311 = !{!312, !314, !316}
!312 = distinct !{!312, !313, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E: argument 0"}
!313 = distinct !{!313, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E"}
!314 = distinct !{!314, !315, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 0"}
!315 = distinct !{!315, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E"}
!316 = distinct !{!316, !315, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 2"}
!317 = !{!318, !320}
!318 = distinct !{!318, !319, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 0"}
!319 = distinct !{!319, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E"}
!320 = distinct !{!320, !319, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 1"}
!321 = !{!322}
!322 = distinct !{!322, !323, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E: argument 1"}
!323 = distinct !{!323, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17hc23db5bf0856a7a6E"}
!324 = !{!325, !327, !329}
!325 = distinct !{!325, !326, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E: argument 0"}
!326 = distinct !{!326, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E"}
!327 = distinct !{!327, !328, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 0"}
!328 = distinct !{!328, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E"}
!329 = distinct !{!329, !328, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 2"}
!330 = !{!331}
!331 = distinct !{!331, !332, !"_ZN4core5slice4sort15partition_equal17ha3c71209b9645b71E: argument 0"}
!332 = distinct !{!332, !"_ZN4core5slice4sort15partition_equal17ha3c71209b9645b71E"}
!333 = !{!334}
!334 = distinct !{!334, !335, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE: argument 0"}
!335 = distinct !{!335, !"_ZN80_$LT$core..slice..sort..CopyOnDrop$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17h0c9ff5f02190a91bE"}
!336 = !{!337, !339}
!337 = distinct !{!337, !338, !"_ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h156471c7892c6dcbE: argument 0"}
!338 = distinct !{!338, !"_ZN110_$LT$core..ops..range..RangeFrom$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h156471c7892c6dcbE"}
!339 = distinct !{!339, !340, !"_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17hae1346a6bdb4fa05E: argument 0"}
!340 = distinct !{!340, !"_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17hae1346a6bdb4fa05E"}
!341 = !{!342, !318, !344}
!342 = distinct !{!342, !343, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E: argument 0"}
!343 = distinct !{!343, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$22split_at_mut_unchecked17h4025df15d153e694E"}
!344 = distinct !{!344, !319, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$12split_at_mut17h4517b526c8fd5ff9E: argument 2"}
