; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive --pass-remarks-output=%t.mfm-hyfm-exact2.yaml -o %t.mfm-hyfm-exact2.ll %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=2 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive --pass-remarks-output=%t.mfm-hyfm-exact3.yaml -o %t.mfm-hyfm-exact3.ll %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=3 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive --pass-remarks-output=%t.mfm-hyfm-exact4.yaml -o %t.mfm-hyfm-exact4.ll %s

; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -multiple-func-merging-hyfm-profitability=true -multiple-func-merging-hyfm-nw=true -pass-remarks-output=%t.mfm-hyfm-approx2.yaml -o %t.mfm-hyfm-approx2.ll %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=2 -multiple-func-merging-hyfm-profitability=true -multiple-func-merging-hyfm-nw=true -pass-remarks-output=%t.mfm-hyfm-approx3.yaml -o %t.mfm-hyfm-approx3.ll %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=3 -multiple-func-merging-hyfm-profitability=true -multiple-func-merging-hyfm-nw=true -pass-remarks-output=%t.mfm-hyfm-approx4.yaml -o %t.mfm-hyfm-approx4.ll %s


; RUN: %llc --filetype=obj %t.mfm-hyfm-exact2.ll -o %t.mfm-hyfm-exact2.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-exact3.ll -o %t.mfm-hyfm-exact3.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-exact4.ll -o %t.mfm-hyfm-exact4.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-approx2.ll -o %t.mfm-hyfm-approx2.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-approx3.ll -o %t.mfm-hyfm-approx3.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-approx4.ll -o %t.mfm-hyfm-approx4.o

; REQUIRES: long_test

; ModuleID = 'benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.xalanc_1_8::XalanDOMString" = type <{ %"class.std::vector", i32, [4 x i8] }>
%"class.std::vector" = type { %"struct.std::_Vector_base" }
%"struct.std::_Vector_base" = type { %"struct.std::_Vector_base<unsigned short, std::allocator<unsigned short> >::_Vector_impl" }
%"struct.std::_Vector_base<unsigned short, std::allocator<unsigned short> >::_Vector_impl" = type { i16*, i16*, i16* }
%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString" = type { %"class.xalanc_1_8::XPathExecutionContext"*, %"class.xalanc_1_8::XalanDOMString"* }
%"class.xalanc_1_8::XPathExecutionContext" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XObjectFactory"* }
%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%"class.xalanc_1_8::XObjectFactory" = type { i32 (...)** }
%"class.xalanc_1_8::ArenaBlockDestroy" = type { i8 }
%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop" = type { %"class.xalanc_1_8::XPathExecutionContext"* }

$_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport13equalFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_ = comdat any

$_ZN10xalanc_1_817doCompareNodeSetsINS_18notEqualsDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE = comdat any

$_ZN10xalanc_1_817doCompareNodeSetsINS_20greaterThanDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE = comdat any

$_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport19greaterThanFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_ = comdat any

$_ZN10xalanc_1_817doCompareNodeSetsINS_17lessThanDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE = comdat any

$_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport16lessThanFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_ = comdat any

$_ZN10xalanc_1_817doCompareNodeSetsINS_27greaterThanOrEqualDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE = comdat any

$_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport26greaterThanOrEqualFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_ = comdat any

$_ZN10xalanc_1_817doCompareNodeSetsINS_24lessThanOrEqualDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE = comdat any

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
declare hidden void @__clang_call_terminate(i8*) local_unnamed_addr #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16), %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16)) unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16)) local_unnamed_addr #3 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16)) unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_813DoubleSupport13equalFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), double* nonnull align 8 dereferenceable(8), double* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport13equalFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, double %theRHS, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction) local_unnamed_addr #2 comdat {
entry:
  %theRHS.addr = alloca double, align 8
  %theLHS = alloca double, align 8
  store double %theRHS, double* %theRHS.addr, align 8, !tbaa !4
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %3 = bitcast double* %theLHS to i8*
  %cmp17.not = icmp eq i32 %call, 0
  br i1 %cmp17.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %phi.cmp = icmp ne i8 %5, 0
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %.lcssa = phi i1 [ false, %entry ], [ %phi.cmp, %for.cond.cleanup.loopexit ]
  ret i1 %.lcssa

for.body:                                         ; preds = %entry, %for.body
  %theResult.019 = phi i8 [ %spec.select, %for.body ], [ 0, %entry ]
  %i.018 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %vtable2 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %2, align 8, !tbaa !8
  %vfn3 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable2, i64 2
  %4 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn3, align 8
  %call4 = call %"class.xalanc_1_8::XalanNode"* %4(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.018) #4
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %3) #5
  %call5 = call double @_ZNK10xalanc_1_825getNumberFromNodeFunctionclERKNS_9XalanNodeE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call4) #4
  store double %call5, double* %theLHS, align 8, !tbaa !4
  %call6 = call zeroext i1 @_ZNK10xalanc_1_813DoubleSupport13equalFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, double* nonnull align 8 dereferenceable(8) %theLHS, double* nonnull align 8 dereferenceable(8) %theRHS.addr) #4
  %spec.select = select i1 %call6, i8 1, i8 %theResult.019
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %3) #5
  %inc = add nuw i32 %i.018, 1
  %cmp = icmp ult i32 %inc, %call
  %5 = and i8 %spec.select, 1
  %cmp1 = icmp eq i8 %5, 0
  %6 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %6, label %for.body, label %for.cond.cleanup.loopexit, !llvm.loop !10
}

; Function Attrs: noinline optsize uwtable
declare void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare double @_ZNK10xalanc_1_825getNumberFromNodeFunctionclERKNS_9XalanNodeE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_817doCompareNodeSetsINS_18notEqualsDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) local_unnamed_addr #2 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %s1 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %s2 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %cmp.not = icmp eq i32 %call, 0
  br i1 %cmp.not, label %if.end55, label %if.then

if.then:                                          ; preds = %entry
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable1 = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %2, align 8, !tbaa !8
  %vfn2 = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable1, i64 3
  %3 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn2, align 8
  %call3 = tail call i32 %3(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet) #4
  %cmp4.not = icmp eq i32 %call3, 0
  br i1 %cmp4.not, label %if.end55, label %if.then5

if.then5:                                         ; preds = %if.then
  %4 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %4) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
  %5 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
          to label %for.body.preheader unwind label %lpad

for.body.preheader:                               ; preds = %if.then5
  %6 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %7 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  br label %for.body

for.cond.cleanup:                                 ; preds = %invoke.cont41
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %invoke.cont46 unwind label %lpad

lpad:                                             ; preds = %for.cond.cleanup, %if.then5
  %8 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup49

for.body:                                         ; preds = %for.body.preheader, %invoke.cont41
  %theResult.095 = phi i8 [ %theResult.1.lcssa, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %i.094 = phi i32 [ %inc43, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %vtable8 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %6, align 8, !tbaa !8
  %vfn9 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable8, i64 2
  %9 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn9, align 8
  %call12 = invoke %"class.xalanc_1_8::XalanNode"* %9(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.094) #4
          to label %invoke.cont11 unwind label %lpad10

invoke.cont11:                                    ; preds = %for.body
  %call13 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call12, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call13) #4
          to label %for.cond15.preheader unwind label %lpad10

for.cond15.preheader:                             ; preds = %invoke.cont11
  %10 = and i8 %theResult.095, 1
  %cmp2090 = icmp eq i8 %10, 0
  br i1 %cmp2090, label %for.body23, label %for.cond.cleanup22

for.cond.cleanup22:                               ; preds = %invoke.cont39, %for.cond15.preheader
  %theResult.1.lcssa = phi i8 [ %theResult.095, %for.cond15.preheader ], [ %spec.select, %invoke.cont39 ]
  %call40 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call40) #4
          to label %invoke.cont41 unwind label %lpad10

lpad10:                                           ; preds = %for.cond.cleanup22, %invoke.cont11, %for.body
  %11 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

for.body23:                                       ; preds = %for.cond15.preheader, %invoke.cont39
  %theResult.192 = phi i8 [ %spec.select, %invoke.cont39 ], [ %theResult.095, %for.cond15.preheader ]
  %k.091 = phi i32 [ %inc, %invoke.cont39 ], [ 0, %for.cond15.preheader ]
  %vtable24 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %7, align 8, !tbaa !8
  %vfn25 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable24, i64 2
  %12 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn25, align 8
  %call28 = invoke %"class.xalanc_1_8::XalanNode"* %12(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, i32 %k.091) #4
          to label %invoke.cont27 unwind label %lpad26

invoke.cont27:                                    ; preds = %for.body23
  %call29 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call28, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call29) #4
          to label %invoke.cont30 unwind label %lpad26

invoke.cont30:                                    ; preds = %invoke.cont27
  %call31 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  %call32 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  %call34 = invoke zeroext i1 @_ZNK10xalanc_1_818notEqualsDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call31, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call32) #4
          to label %invoke.cont33 unwind label %lpad26

invoke.cont33:                                    ; preds = %invoke.cont30
  %call38 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call38) #4
          to label %invoke.cont39 unwind label %lpad26

lpad26:                                           ; preds = %invoke.cont33, %invoke.cont30, %invoke.cont27, %for.body23
  %13 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

invoke.cont39:                                    ; preds = %invoke.cont33
  %spec.select = select i1 %call34, i8 1, i8 %theResult.192
  %inc = add nuw i32 %k.091, 1
  %cmp16 = icmp ult i32 %inc, %call3
  %14 = and i8 %spec.select, 1
  %cmp20 = icmp eq i8 %14, 0
  %15 = select i1 %cmp16, i1 %cmp20, i1 false
  br i1 %15, label %for.body23, label %for.cond.cleanup22, !llvm.loop !12

invoke.cont41:                                    ; preds = %for.cond.cleanup22
  %inc43 = add nuw i32 %i.094, 1
  %cmp6 = icmp ult i32 %inc43, %call
  %16 = and i8 %theResult.1.lcssa, 1
  %cmp7 = icmp eq i8 %16, 0
  %17 = select i1 %cmp6, i1 %cmp7, i1 false
  br i1 %17, label %for.body, label %for.cond.cleanup, !llvm.loop !13

ehcleanup:                                        ; preds = %lpad26, %lpad10
  %.pn = phi { i8*, i32 } [ %13, %lpad26 ], [ %11, %lpad10 ]
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %ehcleanup49 unwind label %terminate.lpad

invoke.cont46:                                    ; preds = %for.cond.cleanup
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  br label %if.end55

ehcleanup49:                                      ; preds = %ehcleanup, %lpad
  %.pn.pn = phi { i8*, i32 } [ %.pn, %ehcleanup ], [ %8, %lpad ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
          to label %invoke.cont51 unwind label %terminate.lpad

invoke.cont51:                                    ; preds = %ehcleanup49
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  resume { i8*, i32 } %.pn.pn

if.end55:                                         ; preds = %if.then, %invoke.cont46, %entry
  %theResult.4 = phi i8 [ 0, %entry ], [ %theResult.1.lcssa, %invoke.cont46 ], [ 0, %if.then ]
  %18 = and i8 %theResult.4, 1
  %tobool56 = icmp ne i8 %18, 0
  ret i1 %tobool56

terminate.lpad:                                   ; preds = %ehcleanup49, %ehcleanup
  %19 = landingpad { i8*, i32 }
          catch i8* null
  %20 = extractvalue { i8*, i32 } %19, 0
  call void @__clang_call_terminate(i8* %20) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_818notEqualsDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_817doCompareNodeSetsINS_20greaterThanDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) local_unnamed_addr #2 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %s1 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %s2 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %cmp.not = icmp eq i32 %call, 0
  br i1 %cmp.not, label %if.end55, label %if.then

if.then:                                          ; preds = %entry
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable1 = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %2, align 8, !tbaa !8
  %vfn2 = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable1, i64 3
  %3 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn2, align 8
  %call3 = tail call i32 %3(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet) #4
  %cmp4.not = icmp eq i32 %call3, 0
  br i1 %cmp4.not, label %if.end55, label %if.then5

if.then5:                                         ; preds = %if.then
  %4 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %4) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
  %5 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
          to label %for.body.preheader unwind label %lpad

for.body.preheader:                               ; preds = %if.then5
  %6 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %7 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  br label %for.body

for.cond.cleanup:                                 ; preds = %invoke.cont41
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %invoke.cont46 unwind label %lpad

lpad:                                             ; preds = %for.cond.cleanup, %if.then5
  %8 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup49

for.body:                                         ; preds = %for.body.preheader, %invoke.cont41
  %theResult.095 = phi i8 [ %theResult.1.lcssa, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %i.094 = phi i32 [ %inc43, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %vtable8 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %6, align 8, !tbaa !8
  %vfn9 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable8, i64 2
  %9 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn9, align 8
  %call12 = invoke %"class.xalanc_1_8::XalanNode"* %9(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.094) #4
          to label %invoke.cont11 unwind label %lpad10

invoke.cont11:                                    ; preds = %for.body
  %call13 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call12, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call13) #4
          to label %for.cond15.preheader unwind label %lpad10

for.cond15.preheader:                             ; preds = %invoke.cont11
  %10 = and i8 %theResult.095, 1
  %cmp2090 = icmp eq i8 %10, 0
  br i1 %cmp2090, label %for.body23, label %for.cond.cleanup22

for.cond.cleanup22:                               ; preds = %invoke.cont39, %for.cond15.preheader
  %theResult.1.lcssa = phi i8 [ %theResult.095, %for.cond15.preheader ], [ %spec.select, %invoke.cont39 ]
  %call40 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call40) #4
          to label %invoke.cont41 unwind label %lpad10

lpad10:                                           ; preds = %for.cond.cleanup22, %invoke.cont11, %for.body
  %11 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

for.body23:                                       ; preds = %for.cond15.preheader, %invoke.cont39
  %theResult.192 = phi i8 [ %spec.select, %invoke.cont39 ], [ %theResult.095, %for.cond15.preheader ]
  %k.091 = phi i32 [ %inc, %invoke.cont39 ], [ 0, %for.cond15.preheader ]
  %vtable24 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %7, align 8, !tbaa !8
  %vfn25 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable24, i64 2
  %12 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn25, align 8
  %call28 = invoke %"class.xalanc_1_8::XalanNode"* %12(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, i32 %k.091) #4
          to label %invoke.cont27 unwind label %lpad26

invoke.cont27:                                    ; preds = %for.body23
  %call29 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call28, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call29) #4
          to label %invoke.cont30 unwind label %lpad26

invoke.cont30:                                    ; preds = %invoke.cont27
  %call31 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  %call32 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  %call34 = invoke zeroext i1 @_ZNK10xalanc_1_820greaterThanDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call31, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call32) #4
          to label %invoke.cont33 unwind label %lpad26

invoke.cont33:                                    ; preds = %invoke.cont30
  %call38 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call38) #4
          to label %invoke.cont39 unwind label %lpad26

lpad26:                                           ; preds = %invoke.cont33, %invoke.cont30, %invoke.cont27, %for.body23
  %13 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

invoke.cont39:                                    ; preds = %invoke.cont33
  %spec.select = select i1 %call34, i8 1, i8 %theResult.192
  %inc = add nuw i32 %k.091, 1
  %cmp16 = icmp ult i32 %inc, %call3
  %14 = and i8 %spec.select, 1
  %cmp20 = icmp eq i8 %14, 0
  %15 = select i1 %cmp16, i1 %cmp20, i1 false
  br i1 %15, label %for.body23, label %for.cond.cleanup22, !llvm.loop !14

invoke.cont41:                                    ; preds = %for.cond.cleanup22
  %inc43 = add nuw i32 %i.094, 1
  %cmp6 = icmp ult i32 %inc43, %call
  %16 = and i8 %theResult.1.lcssa, 1
  %cmp7 = icmp eq i8 %16, 0
  %17 = select i1 %cmp6, i1 %cmp7, i1 false
  br i1 %17, label %for.body, label %for.cond.cleanup, !llvm.loop !15

ehcleanup:                                        ; preds = %lpad26, %lpad10
  %.pn = phi { i8*, i32 } [ %13, %lpad26 ], [ %11, %lpad10 ]
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %ehcleanup49 unwind label %terminate.lpad

invoke.cont46:                                    ; preds = %for.cond.cleanup
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  br label %if.end55

ehcleanup49:                                      ; preds = %ehcleanup, %lpad
  %.pn.pn = phi { i8*, i32 } [ %.pn, %ehcleanup ], [ %8, %lpad ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
          to label %invoke.cont51 unwind label %terminate.lpad

invoke.cont51:                                    ; preds = %ehcleanup49
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  resume { i8*, i32 } %.pn.pn

if.end55:                                         ; preds = %if.then, %invoke.cont46, %entry
  %theResult.4 = phi i8 [ 0, %entry ], [ %theResult.1.lcssa, %invoke.cont46 ], [ 0, %if.then ]
  %18 = and i8 %theResult.4, 1
  %tobool56 = icmp ne i8 %18, 0
  ret i1 %tobool56

terminate.lpad:                                   ; preds = %ehcleanup49, %ehcleanup
  %19 = landingpad { i8*, i32 }
          catch i8* null
  %20 = extractvalue { i8*, i32 } %19, 0
  call void @__clang_call_terminate(i8* %20) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_813DoubleSupport19greaterThanFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), double* nonnull align 8 dereferenceable(8), double* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport19greaterThanFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, double %theRHS, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction) local_unnamed_addr #2 comdat {
entry:
  %theRHS.addr = alloca double, align 8
  %theLHS = alloca double, align 8
  store double %theRHS, double* %theRHS.addr, align 8, !tbaa !4
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %3 = bitcast double* %theLHS to i8*
  %cmp17.not = icmp eq i32 %call, 0
  br i1 %cmp17.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %phi.cmp = icmp ne i8 %5, 0
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %.lcssa = phi i1 [ false, %entry ], [ %phi.cmp, %for.cond.cleanup.loopexit ]
  ret i1 %.lcssa

for.body:                                         ; preds = %entry, %for.body
  %theResult.019 = phi i8 [ %spec.select, %for.body ], [ 0, %entry ]
  %i.018 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %vtable2 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %2, align 8, !tbaa !8
  %vfn3 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable2, i64 2
  %4 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn3, align 8
  %call4 = call %"class.xalanc_1_8::XalanNode"* %4(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.018) #4
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %3) #5
  %call5 = call double @_ZNK10xalanc_1_825getNumberFromNodeFunctionclERKNS_9XalanNodeE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call4) #4
  store double %call5, double* %theLHS, align 8, !tbaa !4
  %call6 = call zeroext i1 @_ZNK10xalanc_1_813DoubleSupport19greaterThanFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, double* nonnull align 8 dereferenceable(8) %theLHS, double* nonnull align 8 dereferenceable(8) %theRHS.addr) #4
  %spec.select = select i1 %call6, i8 1, i8 %theResult.019
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %3) #5
  %inc = add nuw i32 %i.018, 1
  %cmp = icmp ult i32 %inc, %call
  %5 = and i8 %spec.select, 1
  %cmp1 = icmp eq i8 %5, 0
  %6 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %6, label %for.body, label %for.cond.cleanup.loopexit, !llvm.loop !16
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_820greaterThanDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_817doCompareNodeSetsINS_17lessThanDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) local_unnamed_addr #2 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %s1 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %s2 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %cmp.not = icmp eq i32 %call, 0
  br i1 %cmp.not, label %if.end55, label %if.then

if.then:                                          ; preds = %entry
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable1 = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %2, align 8, !tbaa !8
  %vfn2 = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable1, i64 3
  %3 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn2, align 8
  %call3 = tail call i32 %3(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet) #4
  %cmp4.not = icmp eq i32 %call3, 0
  br i1 %cmp4.not, label %if.end55, label %if.then5

if.then5:                                         ; preds = %if.then
  %4 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %4) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
  %5 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
          to label %for.body.preheader unwind label %lpad

for.body.preheader:                               ; preds = %if.then5
  %6 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %7 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  br label %for.body

for.cond.cleanup:                                 ; preds = %invoke.cont41
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %invoke.cont46 unwind label %lpad

lpad:                                             ; preds = %for.cond.cleanup, %if.then5
  %8 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup49

for.body:                                         ; preds = %for.body.preheader, %invoke.cont41
  %theResult.095 = phi i8 [ %theResult.1.lcssa, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %i.094 = phi i32 [ %inc43, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %vtable8 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %6, align 8, !tbaa !8
  %vfn9 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable8, i64 2
  %9 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn9, align 8
  %call12 = invoke %"class.xalanc_1_8::XalanNode"* %9(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.094) #4
          to label %invoke.cont11 unwind label %lpad10

invoke.cont11:                                    ; preds = %for.body
  %call13 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call12, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call13) #4
          to label %for.cond15.preheader unwind label %lpad10

for.cond15.preheader:                             ; preds = %invoke.cont11
  %10 = and i8 %theResult.095, 1
  %cmp2090 = icmp eq i8 %10, 0
  br i1 %cmp2090, label %for.body23, label %for.cond.cleanup22

for.cond.cleanup22:                               ; preds = %invoke.cont39, %for.cond15.preheader
  %theResult.1.lcssa = phi i8 [ %theResult.095, %for.cond15.preheader ], [ %spec.select, %invoke.cont39 ]
  %call40 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call40) #4
          to label %invoke.cont41 unwind label %lpad10

lpad10:                                           ; preds = %for.cond.cleanup22, %invoke.cont11, %for.body
  %11 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

for.body23:                                       ; preds = %for.cond15.preheader, %invoke.cont39
  %theResult.192 = phi i8 [ %spec.select, %invoke.cont39 ], [ %theResult.095, %for.cond15.preheader ]
  %k.091 = phi i32 [ %inc, %invoke.cont39 ], [ 0, %for.cond15.preheader ]
  %vtable24 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %7, align 8, !tbaa !8
  %vfn25 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable24, i64 2
  %12 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn25, align 8
  %call28 = invoke %"class.xalanc_1_8::XalanNode"* %12(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, i32 %k.091) #4
          to label %invoke.cont27 unwind label %lpad26

invoke.cont27:                                    ; preds = %for.body23
  %call29 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call28, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call29) #4
          to label %invoke.cont30 unwind label %lpad26

invoke.cont30:                                    ; preds = %invoke.cont27
  %call31 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  %call32 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  %call34 = invoke zeroext i1 @_ZNK10xalanc_1_817lessThanDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call31, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call32) #4
          to label %invoke.cont33 unwind label %lpad26

invoke.cont33:                                    ; preds = %invoke.cont30
  %call38 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call38) #4
          to label %invoke.cont39 unwind label %lpad26

lpad26:                                           ; preds = %invoke.cont33, %invoke.cont30, %invoke.cont27, %for.body23
  %13 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

invoke.cont39:                                    ; preds = %invoke.cont33
  %spec.select = select i1 %call34, i8 1, i8 %theResult.192
  %inc = add nuw i32 %k.091, 1
  %cmp16 = icmp ult i32 %inc, %call3
  %14 = and i8 %spec.select, 1
  %cmp20 = icmp eq i8 %14, 0
  %15 = select i1 %cmp16, i1 %cmp20, i1 false
  br i1 %15, label %for.body23, label %for.cond.cleanup22, !llvm.loop !17

invoke.cont41:                                    ; preds = %for.cond.cleanup22
  %inc43 = add nuw i32 %i.094, 1
  %cmp6 = icmp ult i32 %inc43, %call
  %16 = and i8 %theResult.1.lcssa, 1
  %cmp7 = icmp eq i8 %16, 0
  %17 = select i1 %cmp6, i1 %cmp7, i1 false
  br i1 %17, label %for.body, label %for.cond.cleanup, !llvm.loop !18

ehcleanup:                                        ; preds = %lpad26, %lpad10
  %.pn = phi { i8*, i32 } [ %13, %lpad26 ], [ %11, %lpad10 ]
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %ehcleanup49 unwind label %terminate.lpad

invoke.cont46:                                    ; preds = %for.cond.cleanup
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  br label %if.end55

ehcleanup49:                                      ; preds = %ehcleanup, %lpad
  %.pn.pn = phi { i8*, i32 } [ %.pn, %ehcleanup ], [ %8, %lpad ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
          to label %invoke.cont51 unwind label %terminate.lpad

invoke.cont51:                                    ; preds = %ehcleanup49
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  resume { i8*, i32 } %.pn.pn

if.end55:                                         ; preds = %if.then, %invoke.cont46, %entry
  %theResult.4 = phi i8 [ 0, %entry ], [ %theResult.1.lcssa, %invoke.cont46 ], [ 0, %if.then ]
  %18 = and i8 %theResult.4, 1
  %tobool56 = icmp ne i8 %18, 0
  ret i1 %tobool56

terminate.lpad:                                   ; preds = %ehcleanup49, %ehcleanup
  %19 = landingpad { i8*, i32 }
          catch i8* null
  %20 = extractvalue { i8*, i32 } %19, 0
  call void @__clang_call_terminate(i8* %20) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_813DoubleSupport16lessThanFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), double* nonnull align 8 dereferenceable(8), double* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport16lessThanFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, double %theRHS, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction) local_unnamed_addr #2 comdat {
entry:
  %theRHS.addr = alloca double, align 8
  %theLHS = alloca double, align 8
  store double %theRHS, double* %theRHS.addr, align 8, !tbaa !4
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %3 = bitcast double* %theLHS to i8*
  %cmp17.not = icmp eq i32 %call, 0
  br i1 %cmp17.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %phi.cmp = icmp ne i8 %5, 0
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %.lcssa = phi i1 [ false, %entry ], [ %phi.cmp, %for.cond.cleanup.loopexit ]
  ret i1 %.lcssa

for.body:                                         ; preds = %entry, %for.body
  %theResult.019 = phi i8 [ %spec.select, %for.body ], [ 0, %entry ]
  %i.018 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %vtable2 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %2, align 8, !tbaa !8
  %vfn3 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable2, i64 2
  %4 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn3, align 8
  %call4 = call %"class.xalanc_1_8::XalanNode"* %4(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.018) #4
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %3) #5
  %call5 = call double @_ZNK10xalanc_1_825getNumberFromNodeFunctionclERKNS_9XalanNodeE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call4) #4
  store double %call5, double* %theLHS, align 8, !tbaa !4
  %call6 = call zeroext i1 @_ZNK10xalanc_1_813DoubleSupport16lessThanFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, double* nonnull align 8 dereferenceable(8) %theLHS, double* nonnull align 8 dereferenceable(8) %theRHS.addr) #4
  %spec.select = select i1 %call6, i8 1, i8 %theResult.019
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %3) #5
  %inc = add nuw i32 %i.018, 1
  %cmp = icmp ult i32 %inc, %call
  %5 = and i8 %spec.select, 1
  %cmp1 = icmp eq i8 %5, 0
  %6 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %6, label %for.body, label %for.cond.cleanup.loopexit, !llvm.loop !19
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_817lessThanDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_817doCompareNodeSetsINS_27greaterThanOrEqualDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) local_unnamed_addr #2 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %s1 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %s2 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %cmp.not = icmp eq i32 %call, 0
  br i1 %cmp.not, label %if.end55, label %if.then

if.then:                                          ; preds = %entry
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable1 = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %2, align 8, !tbaa !8
  %vfn2 = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable1, i64 3
  %3 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn2, align 8
  %call3 = tail call i32 %3(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet) #4
  %cmp4.not = icmp eq i32 %call3, 0
  br i1 %cmp4.not, label %if.end55, label %if.then5

if.then5:                                         ; preds = %if.then
  %4 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %4) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
  %5 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
          to label %for.body.preheader unwind label %lpad

for.body.preheader:                               ; preds = %if.then5
  %6 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %7 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  br label %for.body

for.cond.cleanup:                                 ; preds = %invoke.cont41
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %invoke.cont46 unwind label %lpad

lpad:                                             ; preds = %for.cond.cleanup, %if.then5
  %8 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup49

for.body:                                         ; preds = %for.body.preheader, %invoke.cont41
  %theResult.095 = phi i8 [ %theResult.1.lcssa, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %i.094 = phi i32 [ %inc43, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %vtable8 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %6, align 8, !tbaa !8
  %vfn9 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable8, i64 2
  %9 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn9, align 8
  %call12 = invoke %"class.xalanc_1_8::XalanNode"* %9(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.094) #4
          to label %invoke.cont11 unwind label %lpad10

invoke.cont11:                                    ; preds = %for.body
  %call13 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call12, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call13) #4
          to label %for.cond15.preheader unwind label %lpad10

for.cond15.preheader:                             ; preds = %invoke.cont11
  %10 = and i8 %theResult.095, 1
  %cmp2090 = icmp eq i8 %10, 0
  br i1 %cmp2090, label %for.body23, label %for.cond.cleanup22

for.cond.cleanup22:                               ; preds = %invoke.cont39, %for.cond15.preheader
  %theResult.1.lcssa = phi i8 [ %theResult.095, %for.cond15.preheader ], [ %spec.select, %invoke.cont39 ]
  %call40 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call40) #4
          to label %invoke.cont41 unwind label %lpad10

lpad10:                                           ; preds = %for.cond.cleanup22, %invoke.cont11, %for.body
  %11 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

for.body23:                                       ; preds = %for.cond15.preheader, %invoke.cont39
  %theResult.192 = phi i8 [ %spec.select, %invoke.cont39 ], [ %theResult.095, %for.cond15.preheader ]
  %k.091 = phi i32 [ %inc, %invoke.cont39 ], [ 0, %for.cond15.preheader ]
  %vtable24 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %7, align 8, !tbaa !8
  %vfn25 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable24, i64 2
  %12 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn25, align 8
  %call28 = invoke %"class.xalanc_1_8::XalanNode"* %12(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, i32 %k.091) #4
          to label %invoke.cont27 unwind label %lpad26

invoke.cont27:                                    ; preds = %for.body23
  %call29 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call28, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call29) #4
          to label %invoke.cont30 unwind label %lpad26

invoke.cont30:                                    ; preds = %invoke.cont27
  %call31 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  %call32 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  %call34 = invoke zeroext i1 @_ZNK10xalanc_1_827greaterThanOrEqualDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call31, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call32) #4
          to label %invoke.cont33 unwind label %lpad26

invoke.cont33:                                    ; preds = %invoke.cont30
  %call38 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call38) #4
          to label %invoke.cont39 unwind label %lpad26

lpad26:                                           ; preds = %invoke.cont33, %invoke.cont30, %invoke.cont27, %for.body23
  %13 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

invoke.cont39:                                    ; preds = %invoke.cont33
  %spec.select = select i1 %call34, i8 1, i8 %theResult.192
  %inc = add nuw i32 %k.091, 1
  %cmp16 = icmp ult i32 %inc, %call3
  %14 = and i8 %spec.select, 1
  %cmp20 = icmp eq i8 %14, 0
  %15 = select i1 %cmp16, i1 %cmp20, i1 false
  br i1 %15, label %for.body23, label %for.cond.cleanup22, !llvm.loop !20

invoke.cont41:                                    ; preds = %for.cond.cleanup22
  %inc43 = add nuw i32 %i.094, 1
  %cmp6 = icmp ult i32 %inc43, %call
  %16 = and i8 %theResult.1.lcssa, 1
  %cmp7 = icmp eq i8 %16, 0
  %17 = select i1 %cmp6, i1 %cmp7, i1 false
  br i1 %17, label %for.body, label %for.cond.cleanup, !llvm.loop !21

ehcleanup:                                        ; preds = %lpad26, %lpad10
  %.pn = phi { i8*, i32 } [ %13, %lpad26 ], [ %11, %lpad10 ]
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %ehcleanup49 unwind label %terminate.lpad

invoke.cont46:                                    ; preds = %for.cond.cleanup
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  br label %if.end55

ehcleanup49:                                      ; preds = %ehcleanup, %lpad
  %.pn.pn = phi { i8*, i32 } [ %.pn, %ehcleanup ], [ %8, %lpad ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
          to label %invoke.cont51 unwind label %terminate.lpad

invoke.cont51:                                    ; preds = %ehcleanup49
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  resume { i8*, i32 } %.pn.pn

if.end55:                                         ; preds = %if.then, %invoke.cont46, %entry
  %theResult.4 = phi i8 [ 0, %entry ], [ %theResult.1.lcssa, %invoke.cont46 ], [ 0, %if.then ]
  %18 = and i8 %theResult.4, 1
  %tobool56 = icmp ne i8 %18, 0
  ret i1 %tobool56

terminate.lpad:                                   ; preds = %ehcleanup49, %ehcleanup
  %19 = landingpad { i8*, i32 }
          catch i8* null
  %20 = extractvalue { i8*, i32 } %19, 0
  call void @__clang_call_terminate(i8* %20) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_813DoubleSupport26greaterThanOrEqualFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), double* nonnull align 8 dereferenceable(8), double* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_815doCompareNumberINS_13DoubleSupport26greaterThanOrEqualFunctionENS_25getNumberFromNodeFunctionEEEbRKNS_15NodeRefListBaseERKT0_dRKT_(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, double %theRHS, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction) local_unnamed_addr #2 comdat {
entry:
  %theRHS.addr = alloca double, align 8
  %theLHS = alloca double, align 8
  store double %theRHS, double* %theRHS.addr, align 8, !tbaa !4
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %3 = bitcast double* %theLHS to i8*
  %cmp17.not = icmp eq i32 %call, 0
  br i1 %cmp17.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %phi.cmp = icmp ne i8 %5, 0
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %.lcssa = phi i1 [ false, %entry ], [ %phi.cmp, %for.cond.cleanup.loopexit ]
  ret i1 %.lcssa

for.body:                                         ; preds = %entry, %for.body
  %theResult.019 = phi i8 [ %spec.select, %for.body ], [ 0, %entry ]
  %i.018 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %vtable2 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %2, align 8, !tbaa !8
  %vfn3 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable2, i64 2
  %4 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn3, align 8
  %call4 = call %"class.xalanc_1_8::XalanNode"* %4(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.018) #4
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %3) #5
  %call5 = call double @_ZNK10xalanc_1_825getNumberFromNodeFunctionclERKNS_9XalanNodeE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theNumberFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call4) #4
  store double %call5, double* %theLHS, align 8, !tbaa !4
  %call6 = call zeroext i1 @_ZNK10xalanc_1_813DoubleSupport26greaterThanOrEqualFunctionclERKdS3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, double* nonnull align 8 dereferenceable(8) %theLHS, double* nonnull align 8 dereferenceable(8) %theRHS.addr) #4
  %spec.select = select i1 %call6, i8 1, i8 %theResult.019
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %3) #5
  %inc = add nuw i32 %i.018, 1
  %cmp = icmp ult i32 %inc, %call
  %5 = and i8 %spec.select, 1
  %cmp1 = icmp eq i8 %5, 0
  %6 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %6, label %for.body, label %for.cond.cleanup.loopexit, !llvm.loop !22
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_827greaterThanOrEqualDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr zeroext i1 @_ZN10xalanc_1_817doCompareNodeSetsINS_24lessThanOrEqualDOMStringENS_25getStringFromNodeFunctionEEEbRKNS_15NodeRefListBaseES5_RKT0_RKT_RNS_21XPathExecutionContextE(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, %"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) local_unnamed_addr #2 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %s1 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %s2 = alloca %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString", align 8
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !8
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 3
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet) #4
  %cmp.not = icmp eq i32 %call, 0
  br i1 %cmp.not, label %if.end55, label %if.then

if.then:                                          ; preds = %entry
  %2 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable1 = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %2, align 8, !tbaa !8
  %vfn2 = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable1, i64 3
  %3 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn2, align 8
  %call3 = tail call i32 %3(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet) #4
  %cmp4.not = icmp eq i32 %call3, 0
  br i1 %cmp4.not, label %if.end55, label %if.then5

if.then5:                                         ; preds = %if.then
  %4 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %4) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
  %5 = bitcast %"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* %s2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringC2ERS0_(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2, %"class.xalanc_1_8::XPathExecutionContext"* nonnull align 8 dereferenceable(16) %executionContext) #4
          to label %for.body.preheader unwind label %lpad

for.body.preheader:                               ; preds = %if.then5
  %6 = bitcast %"class.xalanc_1_8::XalanNode"* %theLHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  %7 = bitcast %"class.xalanc_1_8::XalanNode"* %theRHSNodeSet to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)***
  br label %for.body

for.cond.cleanup:                                 ; preds = %invoke.cont41
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %invoke.cont46 unwind label %lpad

lpad:                                             ; preds = %for.cond.cleanup, %if.then5
  %8 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup49

for.body:                                         ; preds = %for.body.preheader, %invoke.cont41
  %theResult.095 = phi i8 [ %theResult.1.lcssa, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %i.094 = phi i32 [ %inc43, %invoke.cont41 ], [ 0, %for.body.preheader ]
  %vtable8 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %6, align 8, !tbaa !8
  %vfn9 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable8, i64 2
  %9 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn9, align 8
  %call12 = invoke %"class.xalanc_1_8::XalanNode"* %9(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theLHSNodeSet, i32 %i.094) #4
          to label %invoke.cont11 unwind label %lpad10

invoke.cont11:                                    ; preds = %for.body
  %call13 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call12, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call13) #4
          to label %for.cond15.preheader unwind label %lpad10

for.cond15.preheader:                             ; preds = %invoke.cont11
  %10 = and i8 %theResult.095, 1
  %cmp2090 = icmp eq i8 %10, 0
  br i1 %cmp2090, label %for.body23, label %for.cond.cleanup22

for.cond.cleanup22:                               ; preds = %invoke.cont39, %for.cond15.preheader
  %theResult.1.lcssa = phi i8 [ %theResult.095, %for.cond15.preheader ], [ %spec.select, %invoke.cont39 ]
  %call40 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call40) #4
          to label %invoke.cont41 unwind label %lpad10

lpad10:                                           ; preds = %for.cond.cleanup22, %invoke.cont11, %for.body
  %11 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

for.body23:                                       ; preds = %for.cond15.preheader, %invoke.cont39
  %theResult.192 = phi i8 [ %spec.select, %invoke.cont39 ], [ %theResult.095, %for.cond15.preheader ]
  %k.091 = phi i32 [ %inc, %invoke.cont39 ], [ 0, %for.cond15.preheader ]
  %vtable24 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*** %7, align 8, !tbaa !8
  %vfn25 = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vtable24, i64 2
  %12 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanNode"*, i32)** %vfn25, align 8
  %call28 = invoke %"class.xalanc_1_8::XalanNode"* %12(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theRHSNodeSet, i32 %k.091) #4
          to label %invoke.cont27 unwind label %lpad26

invoke.cont27:                                    ; preds = %for.body23
  %call29 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZNK10xalanc_1_825getStringFromNodeFunctionclERKNS_9XalanNodeERNS_14XalanDOMStringE(%"class.xalanc_1_8::XPathExecutionContext::CurrentNodePushAndPop"* nonnull align 8 dereferenceable(8) %theTypeFunction, %"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %call28, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call29) #4
          to label %invoke.cont30 unwind label %lpad26

invoke.cont30:                                    ; preds = %invoke.cont27
  %call31 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  %call32 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  %call34 = invoke zeroext i1 @_ZNK10xalanc_1_824lessThanOrEqualDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %theCompareFunction, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call31, %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call32) #4
          to label %invoke.cont33 unwind label %lpad26

invoke.cont33:                                    ; preds = %invoke.cont30
  %call38 = call nonnull align 8 dereferenceable(28) %"class.xalanc_1_8::XalanDOMString"* @_ZNK10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedString3getEv(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
  invoke void @_ZN10xalanc_1_85clearERNS_14XalanDOMStringE(%"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28) %call38) #4
          to label %invoke.cont39 unwind label %lpad26

lpad26:                                           ; preds = %invoke.cont33, %invoke.cont30, %invoke.cont27, %for.body23
  %13 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

invoke.cont39:                                    ; preds = %invoke.cont33
  %spec.select = select i1 %call34, i8 1, i8 %theResult.192
  %inc = add nuw i32 %k.091, 1
  %cmp16 = icmp ult i32 %inc, %call3
  %14 = and i8 %spec.select, 1
  %cmp20 = icmp eq i8 %14, 0
  %15 = select i1 %cmp16, i1 %cmp20, i1 false
  br i1 %15, label %for.body23, label %for.cond.cleanup22, !llvm.loop !23

invoke.cont41:                                    ; preds = %for.cond.cleanup22
  %inc43 = add nuw i32 %i.094, 1
  %cmp6 = icmp ult i32 %inc43, %call
  %16 = and i8 %theResult.1.lcssa, 1
  %cmp7 = icmp eq i8 %16, 0
  %17 = select i1 %cmp6, i1 %cmp7, i1 false
  br i1 %17, label %for.body, label %for.cond.cleanup, !llvm.loop !24

ehcleanup:                                        ; preds = %lpad26, %lpad10
  %.pn = phi { i8*, i32 } [ %13, %lpad26 ], [ %11, %lpad10 ]
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s2) #4
          to label %ehcleanup49 unwind label %terminate.lpad

invoke.cont46:                                    ; preds = %for.cond.cleanup
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  call void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  br label %if.end55

ehcleanup49:                                      ; preds = %ehcleanup, %lpad
  %.pn.pn = phi { i8*, i32 } [ %.pn, %ehcleanup ], [ %8, %lpad ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #5
  invoke void @_ZN10xalanc_1_821XPathExecutionContext25GetAndReleaseCachedStringD2Ev(%"class.xalanc_1_8::XPathExecutionContext::GetAndReleaseCachedString"* nonnull align 8 dereferenceable(16) %s1) #4
          to label %invoke.cont51 unwind label %terminate.lpad

invoke.cont51:                                    ; preds = %ehcleanup49
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %4) #5
  resume { i8*, i32 } %.pn.pn

if.end55:                                         ; preds = %if.then, %invoke.cont46, %entry
  %theResult.4 = phi i8 [ 0, %entry ], [ %theResult.1.lcssa, %invoke.cont46 ], [ 0, %if.then ]
  %18 = and i8 %theResult.4, 1
  %tobool56 = icmp ne i8 %18, 0
  ret i1 %tobool56

terminate.lpad:                                   ; preds = %ehcleanup49, %ehcleanup
  %19 = landingpad { i8*, i32 }
          catch i8* null
  %20 = extractvalue { i8*, i32 } %19, 0
  call void @__clang_call_terminate(i8* %20) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK10xalanc_1_824lessThanOrEqualDOMStringclERKNS_14XalanDOMStringES3_(%"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28), %"class.xalanc_1_8::XalanDOMString"* nonnull align 8 dereferenceable(28)) local_unnamed_addr #2 align 2

attributes #0 = { noinline noreturn nounwind }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { optsize }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"double", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"vtable pointer", !7, i64 0}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !11}
!13 = distinct !{!13, !11}
!14 = distinct !{!14, !11}
!15 = distinct !{!15, !11}
!16 = distinct !{!16, !11}
!17 = distinct !{!17, !11}
!18 = distinct !{!18, !11}
!19 = distinct !{!19, !11}
!20 = distinct !{!20, !11}
!21 = distinct !{!21, !11}
!22 = distinct !{!22, !11}
!23 = distinct !{!23, !11}
!24 = distinct !{!24, !11}
