; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-identical-type=true -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -multiple-func-merging-hyfm-nw=true -o %t.mfm.bc %s

; ModuleID = '.x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.xercesc_2_5::DatatypeValidator" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::RefHashTableOf"*, i16*, %"class.xercesc_2_5::RegularExpression"*, i16*, i16*, i16*, i32, i8, i8, i8, i8 }>
%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%"class.xercesc_2_5::RefHashTableOf" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.2"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.2" = type { %"class.xercesc_2_5::DatatypeValidator"*, %"struct.xercesc_2_5::RefHashTableBucketElem.2"*, i8* }
%"class.xercesc_2_5::RegularExpression" = type { i8, i8, i32, i32, i32, i32, %"class.xercesc_2_5::BMPattern"*, i16*, i16*, %"class.xercesc_2_5::Op"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::RangeToken"*, %"class.xercesc_2_5::OpFactory", %"class.xercesc_2_5::XMLMutex", %"class.xercesc_2_5::TokenFactory"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::BMPattern" = type { i8, i32, i32*, i16*, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::Op" = type { i32 (...)**, %"class.xalanc_1_8::XalanNode"*, i16, %"class.xercesc_2_5::Op"* }
%"class.xercesc_2_5::Token" = type { i32 (...)**, i16, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RangeToken" = type { %"class.xercesc_2_5::Token", i8, i8, i32, i32, i32, i32*, i32*, %"class.xercesc_2_5::RangeToken"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::OpFactory" = type { %"class.xercesc_2_5::RefVectorOf"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf" = type { %"class.xercesc_2_5::BaseRefVectorOf.9" }
%"class.xercesc_2_5::BaseRefVectorOf.9" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::Op"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLMutex" = type { i8* }
%"class.xercesc_2_5::TokenFactory" = type { %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::TranscodingException" = type { %"class.xercesc_2_5::XMLException" }
%"class.xercesc_2_5::XMLException" = type { i32 (...)**, i32, i8*, i32, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOfEnumerator.1045" = type { %"class.xalanc_1_8::XalanNode", i8, %"struct.xercesc_2_5::RefHashTableBucketElem.1013"*, i32, %"class.xercesc_2_5::RefHashTableOf.1"*, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.1013" = type { %"class.xercesc_2_5::KVStringPair"*, %"struct.xercesc_2_5::RefHashTableBucketElem.1013"*, i8* }
%"class.xercesc_2_5::KVStringPair" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i16*, i64, i16*, i64 }
%"class.xercesc_2_5::RefHashTableOf.1" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.1013"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::AbstractNumericFacetValidator.4868" = type { %"class.xercesc_2_5::DatatypeValidator.base.3655", i8, i8, i8, i8, i8, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xercesc_2_5::RefVectorOf.23"*, %"class.xercesc_2_5::RefArrayVectorOf"* }
%"class.xercesc_2_5::DatatypeValidator.base.3655" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::RefHashTableOf.1"*, i16*, %"class.xercesc_2_5::RegularExpression.3653"*, i16*, i16*, i16*, i32, i8, i8, i8 }>
%"class.xercesc_2_5::DatatypeValidator.3654" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::RefHashTableOf.1"*, i16*, %"class.xercesc_2_5::RegularExpression.3653"*, i16*, i16*, i16*, i32, i8, i8, i8, i8 }>
%"class.xercesc_2_5::RegularExpression.3653" = type { i8, i8, i32, i32, i32, i32, %"class.xercesc_2_5::BMPattern"*, i16*, i16*, %"class.xercesc_2_5::Op"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::RangeToken"*, %"class.xercesc_2_5::OpFactory", %"class.xercesc_2_5::XMLMutex", %"class.xercesc_2_5::TokenFactory.3652"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::TokenFactory.3652" = type { %"class.xercesc_2_5::RefVectorOf.0"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.0" = type { %"class.xercesc_2_5::BaseRefVectorOf.1" }
%"class.xercesc_2_5::BaseRefVectorOf.1" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::TreeWalkerImpl"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::TreeWalkerImpl" = type <{ %"class.xalanc_1_8::XalanReferenceCountedObject.base", [4 x i8], i64, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DOM_Node", %"class.xercesc_2_5::DOM_Node", i8, [7 x i8] }>
%"class.xalanc_1_8::XalanReferenceCountedObject.base" = type <{ i32 (...)**, i32 }>
%"class.xercesc_2_5::DOM_Node" = type { %"class.xercesc_2_5::NodeImpl"* }
%"class.xercesc_2_5::NodeImpl" = type <{ %"class.xercesc_2_5::NodeListImpl.base", [4 x i8], %"class.xercesc_2_5::NodeImpl"*, i16, [6 x i8] }>
%"class.xercesc_2_5::NodeListImpl.base" = type { %"class.xalanc_1_8::XalanReferenceCountedObject.base" }
%"class.xalanc_1_8::XalanDocumentFragment" = type { %"class.xalanc_1_8::XalanNode" }
%"class.xercesc_2_5::RefVectorOf.23" = type { %"class.xercesc_2_5::BaseRefVectorOf.24" }
%"class.xercesc_2_5::BaseRefVectorOf.24" = type { i32 (...)**, i8, i32, i32, %"class.xalanc_1_8::XalanDocumentFragment"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefArrayVectorOf" = type { %"class.xercesc_2_5::BaseRefVectorOf" }
%"class.xercesc_2_5::BaseRefVectorOf" = type { i32 (...)**, i8, i32, i32, i16**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::AbstractStringValidator.4114" = type { %"class.xercesc_2_5::DatatypeValidator.base.3655", i32, i32, i32, i8, %"class.xercesc_2_5::RefArrayVectorOf"* }

@.str.980 = external hidden unnamed_addr constant [38 x i8], align 1
@_ZN11xercesc_2_513SchemaSymbols18fgELT_MAXINCLUSIVEE = external constant [13 x i16], align 16
@_ZN11xercesc_2_513SchemaSymbols18fgELT_MAXEXCLUSIVEE = external constant [13 x i16], align 16
@_ZN11xercesc_2_513SchemaSymbols18fgELT_MININCLUSIVEE = external constant [13 x i16], align 16
@_ZN11xercesc_2_513SchemaSymbols18fgELT_MINEXCLUSIVEE = external constant [13 x i16], align 16
@_ZN11xercesc_2_513SchemaSymbols12fgELT_LENGTHE = external constant [7 x i16], align 2
@.str.4856 = external hidden unnamed_addr constant [32 x i8], align 1
@_ZN11xercesc_2_513SchemaSymbols15fgELT_MINLENGTHE = external constant [10 x i16], align 16
@_ZN11xercesc_2_513SchemaSymbols15fgELT_MAXLENGTHE = external constant [10 x i16], align 16
@_ZN11xercesc_2_513SchemaSymbols11fgATT_FIXEDE = external constant [6 x i16], align 2
@_ZTIN11xercesc_2_521NumberFormatExceptionE = external constant { i8*, i8*, i8* }, align 8
@_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE = external constant { i8*, i8*, i8* }, align 8
@_ZN11xercesc_2_513SchemaSymbols13fgELT_PATTERNE = external constant [8 x i16], align 16
@_ZTIN11xercesc_2_516RuntimeExceptionE = external constant { i8*, i8*, i8* }, align 8

declare i32 @__gxx_personality_v0(...)

declare i8* @__cxa_allocate_exception(i64) local_unnamed_addr

declare void @__cxa_throw(i8*, i8*, i8*) local_unnamed_addr

declare void @__cxa_free_exception(i8*) local_unnamed_addr

; Function Attrs: noinline noreturn nounwind
declare hidden void @__clang_call_terminate(i8*) local_unnamed_addr #0

declare i8* @__cxa_begin_catch(i8*) local_unnamed_addr

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

declare void @__cxa_end_catch() local_unnamed_addr

; Function Attrs: noinline nounwind optsize uwtable
declare zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16*, i16*) local_unnamed_addr #2 align 2

; Function Attrs: nounwind readnone
declare i32 @llvm.eh.typeid.for(i8*) #3

; Function Attrs: noinline nounwind optsize uwtable
declare i16* @_ZNK11xercesc_2_517DatatypeValidator10getPatternEv(%"class.xercesc_2_5::DatatypeValidator"* nonnull align 8 dereferenceable(103)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48), i8*, i32, i32, i16*, i16*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*) unnamed_addr #4 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48), i8*, i32, i32, %"class.xalanc_1_8::XalanNode"*) unnamed_addr #4 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEEC2EPNS_14RefHashTableOfIS1_EEbPNS_13MemoryManagerE(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48), %"class.xercesc_2_5::RefHashTableOf.1"*, i1 zeroext, %"class.xalanc_1_8::XalanNode"*) unnamed_addr #4 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare zeroext i1 @_ZNK11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE15hasMoreElementsEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48)) unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare nonnull align 8 dereferenceable(48) %"class.xercesc_2_5::KVStringPair"* @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE11nextElementEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48)) unnamed_addr #4 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEED2Ev(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48)) unnamed_addr #4 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi(%"class.xercesc_2_5::DatatypeValidator"* nonnull align 8 dereferenceable(103), i32) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define void @_ZN11xercesc_2_529AbstractNumericFacetValidator11assignFacetEPNS_13MemoryManagerE(%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* nonnull align 8 dereferenceable(160) %this, %"class.xalanc_1_8::XalanNode"* %manager) local_unnamed_addr #4 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %e = alloca %"class.xercesc_2_5::RefHashTableOfEnumerator.1045", align 8
  %pair = alloca %"class.xercesc_2_5::KVStringPair", align 8
  %val = alloca i32, align 4
  %0 = bitcast %"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* %this to %"class.xercesc_2_5::DatatypeValidator.3654"*
  %call = tail call %"class.xercesc_2_5::RefHashTableOf.1"* @_ZNK11xercesc_2_517DatatypeValidator9getFacetsEv(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0) #5
  %tobool.not = icmp eq %"class.xercesc_2_5::RefHashTableOf.1"* %call, null
  br i1 %tobool.not, label %cleanup, label %if.end

if.end:                                           ; preds = %entry
  %1 = bitcast %"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* %e to i8*
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %1) #6
  call void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEEC2EPNS_14RefHashTableOfIS1_EEbPNS_13MemoryManagerE(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e, %"class.xercesc_2_5::RefHashTableOf.1"* nonnull %call, i1 zeroext false, %"class.xalanc_1_8::XalanNode"* %manager) #5
  %2 = bitcast %"class.xercesc_2_5::KVStringPair"* %pair to i8*
  %3 = bitcast %"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* %this to void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)***
  %4 = bitcast i32* %val to i8*
  %5 = getelementptr inbounds %"class.xercesc_2_5::AbstractNumericFacetValidator.4868", %"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* %this, i64 0, i32 0, i32 1
  %6 = bitcast %"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* %this to void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)***
  %call2233 = call zeroext i1 @_ZNK11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE15hasMoreElementsEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
  br i1 %call2233, label %while.body, label %while.end

while.body:                                       ; preds = %if.end, %invoke.cont148
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %2) #6
  %call5 = invoke nonnull align 8 dereferenceable(48) %"class.xercesc_2_5::KVStringPair"* @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE11nextElementEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
          to label %invoke.cont4 unwind label %lpad3

invoke.cont4:                                     ; preds = %while.body
  invoke void @_ZN11xercesc_2_512KVStringPairC1ERKS0_(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair, %"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %call5) #5
          to label %invoke.cont6 unwind label %lpad3

invoke.cont6:                                     ; preds = %invoke.cont4
  %call9 = call i16* @_ZN11xercesc_2_512KVStringPair6getKeyEv(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
  %call11 = call i16* @_ZN11xercesc_2_512KVStringPair8getValueEv(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
  %call13 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([8 x i16], [8 x i16]* @_ZN11xercesc_2_513SchemaSymbols13fgELT_PATTERNE, i64 0, i64 0)) #5
  br i1 %call13, label %if.then14, label %if.else

if.then14:                                        ; preds = %invoke.cont6
  invoke void @_ZN11xercesc_2_517DatatypeValidator10setPatternEPKt(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i16* %call11) #5
          to label %invoke.cont15 unwind label %lpad7

invoke.cont15:                                    ; preds = %if.then14
  %call17 = call i16* bitcast (i16* (%"class.xercesc_2_5::DatatypeValidator"*)* @_ZNK11xercesc_2_517DatatypeValidator10getPatternEv to i16* (%"class.xercesc_2_5::DatatypeValidator.3654"*)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0) #5
  %tobool18.not = icmp eq i16* %call17, null
  br i1 %tobool18.not, label %if.end147, label %if.then19

if.then19:                                        ; preds = %invoke.cont15
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 8) #5
  br label %if.end147

lpad3:                                            ; preds = %if.end147, %invoke.cont4, %while.body
  %7 = landingpad { i8*, i32 }
          cleanup
  %8 = extractvalue { i8*, i32 } %7, 0
  %9 = extractvalue { i8*, i32 } %7, 1
  br label %ehcleanup151

lpad7:                                            ; preds = %if.else138, %if.then14
  %10 = landingpad { i8*, i32 }
          cleanup
  %11 = extractvalue { i8*, i32 } %10, 0
  %12 = extractvalue { i8*, i32 } %10, 1
  br label %ehcleanup149

if.else:                                          ; preds = %invoke.cont6
  %call23 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([13 x i16], [13 x i16]* @_ZN11xercesc_2_513SchemaSymbols18fgELT_MAXINCLUSIVEE, i64 0, i64 0)) #5
  br i1 %call23, label %if.then24, label %if.else33

if.then24:                                        ; preds = %if.else
  %vtable = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)**, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*** %6, align 8, !tbaa !4
  %vfn = getelementptr inbounds void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vtable, i64 18
  %13 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vfn, align 8
  invoke void %13(%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* nonnull align 8 dereferenceable(160) %this, i16* %call11) #5
          to label %try.cont unwind label %lpad25

lpad25:                                           ; preds = %if.then24
  %14 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %15 = extractvalue { i8*, i32 } %14, 0
  %16 = extractvalue { i8*, i32 } %14, 1
  %17 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches = icmp eq i32 %16, %17
  br i1 %matches, label %catch, label %ehcleanup149

catch:                                            ; preds = %lpad25
  %18 = call i8* @__cxa_begin_catch(i8* %15) #6
  %exception = call i8* @__cxa_allocate_exception(i64 48) #6
  %19 = bitcast i8* %exception to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %19, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.980, i64 0, i64 0), i32 286, i32 178, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont28 unwind label %lpad27

invoke.cont28:                                    ; preds = %catch
  invoke void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad29

lpad27:                                           ; preds = %catch
  %20 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception) #6
  br label %ehcleanup

lpad29:                                           ; preds = %invoke.cont28
  %21 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

ehcleanup:                                        ; preds = %lpad29, %lpad27
  %.pn216 = phi { i8*, i32 } [ %21, %lpad29 ], [ %20, %lpad27 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont30 unwind label %terminate.lpad

invoke.cont30:                                    ; preds = %ehcleanup
  %exn.slot.0 = extractvalue { i8*, i32 } %.pn216, 0
  %ehselector.slot.0 = extractvalue { i8*, i32 } %.pn216, 1
  br label %ehcleanup149

try.cont:                                         ; preds = %if.then24
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 32) #5
  br label %if.end147

if.else33:                                        ; preds = %if.else
  %call35 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([13 x i16], [13 x i16]* @_ZN11xercesc_2_513SchemaSymbols18fgELT_MAXEXCLUSIVEE, i64 0, i64 0)) #5
  br i1 %call35, label %if.then36, label %if.else57

if.then36:                                        ; preds = %if.else33
  %vtable37 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)**, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*** %6, align 8, !tbaa !4
  %vfn38 = getelementptr inbounds void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vtable37, i64 19
  %22 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vfn38, align 8
  invoke void %22(%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* nonnull align 8 dereferenceable(160) %this, i16* %call11) #5
          to label %try.cont55 unwind label %lpad39

lpad39:                                           ; preds = %if.then36
  %23 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %24 = extractvalue { i8*, i32 } %23, 0
  %25 = extractvalue { i8*, i32 } %23, 1
  %26 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches43 = icmp eq i32 %25, %26
  br i1 %matches43, label %catch44, label %ehcleanup149

catch44:                                          ; preds = %lpad39
  %27 = call i8* @__cxa_begin_catch(i8* %24) #6
  %exception47 = call i8* @__cxa_allocate_exception(i64 48) #6
  %28 = bitcast i8* %exception47 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %28, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.980, i64 0, i64 0), i32 298, i32 179, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont49 unwind label %lpad48

invoke.cont49:                                    ; preds = %catch44
  invoke void @__cxa_throw(i8* %exception47, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad51

lpad48:                                           ; preds = %catch44
  %29 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception47) #6
  br label %ehcleanup52

lpad51:                                           ; preds = %invoke.cont49
  %30 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup52

ehcleanup52:                                      ; preds = %lpad51, %lpad48
  %.pn214 = phi { i8*, i32 } [ %30, %lpad51 ], [ %29, %lpad48 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont53 unwind label %terminate.lpad

invoke.cont53:                                    ; preds = %ehcleanup52
  %exn.slot.1 = extractvalue { i8*, i32 } %.pn214, 0
  %ehselector.slot.1 = extractvalue { i8*, i32 } %.pn214, 1
  br label %ehcleanup149

try.cont55:                                       ; preds = %if.then36
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 64) #5
  br label %if.end147

if.else57:                                        ; preds = %if.else33
  %call59 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([13 x i16], [13 x i16]* @_ZN11xercesc_2_513SchemaSymbols18fgELT_MININCLUSIVEE, i64 0, i64 0)) #5
  br i1 %call59, label %if.then60, label %if.else81

if.then60:                                        ; preds = %if.else57
  %vtable61 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)**, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*** %6, align 8, !tbaa !4
  %vfn62 = getelementptr inbounds void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vtable61, i64 20
  %31 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vfn62, align 8
  invoke void %31(%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* nonnull align 8 dereferenceable(160) %this, i16* %call11) #5
          to label %try.cont79 unwind label %lpad63

lpad63:                                           ; preds = %if.then60
  %32 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %33 = extractvalue { i8*, i32 } %32, 0
  %34 = extractvalue { i8*, i32 } %32, 1
  %35 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches67 = icmp eq i32 %34, %35
  br i1 %matches67, label %catch68, label %ehcleanup149

catch68:                                          ; preds = %lpad63
  %36 = call i8* @__cxa_begin_catch(i8* %33) #6
  %exception71 = call i8* @__cxa_allocate_exception(i64 48) #6
  %37 = bitcast i8* %exception71 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %37, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.980, i64 0, i64 0), i32 310, i32 180, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont73 unwind label %lpad72

invoke.cont73:                                    ; preds = %catch68
  invoke void @__cxa_throw(i8* %exception71, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad75

lpad72:                                           ; preds = %catch68
  %38 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception71) #6
  br label %ehcleanup76

lpad75:                                           ; preds = %invoke.cont73
  %39 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup76

ehcleanup76:                                      ; preds = %lpad75, %lpad72
  %.pn212 = phi { i8*, i32 } [ %39, %lpad75 ], [ %38, %lpad72 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont77 unwind label %terminate.lpad

invoke.cont77:                                    ; preds = %ehcleanup76
  %exn.slot.2 = extractvalue { i8*, i32 } %.pn212, 0
  %ehselector.slot.2 = extractvalue { i8*, i32 } %.pn212, 1
  br label %ehcleanup149

try.cont79:                                       ; preds = %if.then60
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 128) #5
  br label %if.end147

if.else81:                                        ; preds = %if.else57
  %call83 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([13 x i16], [13 x i16]* @_ZN11xercesc_2_513SchemaSymbols18fgELT_MINEXCLUSIVEE, i64 0, i64 0)) #5
  br i1 %call83, label %if.then84, label %if.else105

if.then84:                                        ; preds = %if.else81
  %vtable85 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)**, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*** %6, align 8, !tbaa !4
  %vfn86 = getelementptr inbounds void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vtable85, i64 21
  %40 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*)** %vfn86, align 8
  invoke void %40(%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* nonnull align 8 dereferenceable(160) %this, i16* %call11) #5
          to label %try.cont103 unwind label %lpad87

lpad87:                                           ; preds = %if.then84
  %41 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %42 = extractvalue { i8*, i32 } %41, 0
  %43 = extractvalue { i8*, i32 } %41, 1
  %44 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches91 = icmp eq i32 %43, %44
  br i1 %matches91, label %catch92, label %ehcleanup149

catch92:                                          ; preds = %lpad87
  %45 = call i8* @__cxa_begin_catch(i8* %42) #6
  %exception95 = call i8* @__cxa_allocate_exception(i64 48) #6
  %46 = bitcast i8* %exception95 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %46, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.980, i64 0, i64 0), i32 322, i32 181, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont97 unwind label %lpad96

invoke.cont97:                                    ; preds = %catch92
  invoke void @__cxa_throw(i8* %exception95, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad99

lpad96:                                           ; preds = %catch92
  %47 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception95) #6
  br label %ehcleanup100

lpad99:                                           ; preds = %invoke.cont97
  %48 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup100

ehcleanup100:                                     ; preds = %lpad99, %lpad96
  %.pn210 = phi { i8*, i32 } [ %48, %lpad99 ], [ %47, %lpad96 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont101 unwind label %terminate.lpad

invoke.cont101:                                   ; preds = %ehcleanup100
  %exn.slot.3 = extractvalue { i8*, i32 } %.pn210, 0
  %ehselector.slot.3 = extractvalue { i8*, i32 } %.pn210, 1
  br label %ehcleanup149

try.cont103:                                      ; preds = %if.then84
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 256) #5
  br label %if.end147

if.else105:                                       ; preds = %if.else81
  %call107 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([6 x i16], [6 x i16]* @_ZN11xercesc_2_513SchemaSymbols11fgATT_FIXEDE, i64 0, i64 0)) #5
  br i1 %call107, label %if.then108, label %if.else138

if.then108:                                       ; preds = %if.else105
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #6
  %49 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %5, align 8, !tbaa !7
  %call111 = invoke zeroext i1 @_ZN11xercesc_2_59XMLString9textToBinEPKtRjPNS_13MemoryManagerE(i16* %call11, i32* nonnull align 4 dereferenceable(4) %val, %"class.xalanc_1_8::XalanNode"* %49) #5
          to label %invoke.cont110 unwind label %lpad109

invoke.cont110:                                   ; preds = %if.then108
  br i1 %call111, label %if.end134, label %if.then128

lpad109:                                          ; preds = %if.then108
  %50 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_516RuntimeExceptionE to i8*)
  %51 = extractvalue { i8*, i32 } %50, 0
  %52 = extractvalue { i8*, i32 } %50, 1
  %53 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_516RuntimeExceptionE to i8*)) #6
  %matches114 = icmp eq i32 %52, %53
  br i1 %matches114, label %catch115, label %ehcleanup136

catch115:                                         ; preds = %lpad109
  %54 = call i8* @__cxa_begin_catch(i8* %51) #6
  %exception118 = call i8* @__cxa_allocate_exception(i64 48) #6
  %55 = bitcast i8* %exception118 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %55, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.980, i64 0, i64 0), i32 336, i32 226, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont120 unwind label %lpad119

invoke.cont120:                                   ; preds = %catch115
  invoke void @__cxa_throw(i8* %exception118, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad122

lpad119:                                          ; preds = %catch115
  %56 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception118) #6
  br label %ehcleanup123

lpad122:                                          ; preds = %invoke.cont120
  %57 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup123

ehcleanup123:                                     ; preds = %lpad122, %lpad119
  %.pn = phi { i8*, i32 } [ %57, %lpad122 ], [ %56, %lpad119 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont124 unwind label %terminate.lpad

invoke.cont124:                                   ; preds = %ehcleanup123
  %exn.slot.4 = extractvalue { i8*, i32 } %.pn, 0
  %ehselector.slot.4 = extractvalue { i8*, i32 } %.pn, 1
  br label %ehcleanup136

if.then128:                                       ; preds = %invoke.cont110
  %exception129 = call i8* @__cxa_allocate_exception(i64 48) #6
  %58 = bitcast i8* %exception129 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %58, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.980, i64 0, i64 0), i32 341, i32 226, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont131 unwind label %lpad130

invoke.cont131:                                   ; preds = %if.then128
  invoke void @__cxa_throw(i8* %exception129, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad133

lpad130:                                          ; preds = %if.then128
  %59 = landingpad { i8*, i32 }
          cleanup
  %60 = extractvalue { i8*, i32 } %59, 0
  %61 = extractvalue { i8*, i32 } %59, 1
  call void @__cxa_free_exception(i8* %exception129) #6
  br label %ehcleanup136

lpad133:                                          ; preds = %invoke.cont131
  %62 = landingpad { i8*, i32 }
          cleanup
  %63 = extractvalue { i8*, i32 } %62, 0
  %64 = extractvalue { i8*, i32 } %62, 1
  br label %ehcleanup136

if.end134:                                        ; preds = %invoke.cont110
  %65 = load i32, i32* %val, align 4, !tbaa !16
  call void @_ZN11xercesc_2_517DatatypeValidator8setFixedEi(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 %65) #5
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #6
  br label %if.end147

ehcleanup136:                                     ; preds = %lpad133, %lpad130, %invoke.cont124, %lpad109
  %ehselector.slot.5 = phi i32 [ %64, %lpad133 ], [ %61, %lpad130 ], [ %ehselector.slot.4, %invoke.cont124 ], [ %52, %lpad109 ]
  %exn.slot.5 = phi i8* [ %63, %lpad133 ], [ %60, %lpad130 ], [ %exn.slot.4, %invoke.cont124 ], [ %51, %lpad109 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #6
  br label %ehcleanup149

if.else138:                                       ; preds = %if.else105
  %vtable139 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)**, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*** %3, align 8, !tbaa !4
  %vfn140 = getelementptr inbounds void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)** %vtable139, i64 12
  %66 = load void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*, void (%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)** %vfn140, align 8
  invoke void %66(%"class.xercesc_2_5::AbstractNumericFacetValidator.4868"* nonnull align 8 dereferenceable(160) %this, i16* %call9, i16* %call11, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %if.end147 unwind label %lpad7

if.end147:                                        ; preds = %try.cont, %try.cont79, %if.end134, %if.else138, %try.cont103, %try.cont55, %invoke.cont15, %if.then19
  invoke void @_ZN11xercesc_2_512KVStringPairD1Ev(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
          to label %invoke.cont148 unwind label %lpad3

invoke.cont148:                                   ; preds = %if.end147
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %2) #6
  %call2 = call zeroext i1 @_ZNK11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE15hasMoreElementsEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
  br i1 %call2, label %while.body, label %while.end, !llvm.loop !17

ehcleanup149:                                     ; preds = %ehcleanup136, %invoke.cont101, %lpad87, %invoke.cont77, %lpad63, %invoke.cont53, %lpad39, %invoke.cont30, %lpad25, %lpad7
  %ehselector.slot.6 = phi i32 [ %12, %lpad7 ], [ %ehselector.slot.0, %invoke.cont30 ], [ %16, %lpad25 ], [ %ehselector.slot.1, %invoke.cont53 ], [ %25, %lpad39 ], [ %ehselector.slot.2, %invoke.cont77 ], [ %34, %lpad63 ], [ %ehselector.slot.3, %invoke.cont101 ], [ %43, %lpad87 ], [ %ehselector.slot.5, %ehcleanup136 ]
  %exn.slot.6 = phi i8* [ %11, %lpad7 ], [ %exn.slot.0, %invoke.cont30 ], [ %15, %lpad25 ], [ %exn.slot.1, %invoke.cont53 ], [ %24, %lpad39 ], [ %exn.slot.2, %invoke.cont77 ], [ %33, %lpad63 ], [ %exn.slot.3, %invoke.cont101 ], [ %42, %lpad87 ], [ %exn.slot.5, %ehcleanup136 ]
  invoke void @_ZN11xercesc_2_512KVStringPairD1Ev(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
          to label %ehcleanup151 unwind label %terminate.lpad

ehcleanup151:                                     ; preds = %ehcleanup149, %lpad3
  %ehselector.slot.7 = phi i32 [ %9, %lpad3 ], [ %ehselector.slot.6, %ehcleanup149 ]
  %exn.slot.7 = phi i8* [ %8, %lpad3 ], [ %exn.slot.6, %ehcleanup149 ]
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %2) #6
  invoke void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEED2Ev(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
          to label %invoke.cont153 unwind label %terminate.lpad

while.end:                                        ; preds = %invoke.cont148, %if.end
  call void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEED2Ev(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %1) #6
  br label %cleanup

cleanup:                                          ; preds = %entry, %while.end
  ret void

invoke.cont153:                                   ; preds = %ehcleanup151
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %1) #6
  %lpad.val = insertvalue { i8*, i32 } undef, i8* %exn.slot.7, 0
  %lpad.val160 = insertvalue { i8*, i32 } %lpad.val, i32 %ehselector.slot.7, 1
  resume { i8*, i32 } %lpad.val160

terminate.lpad:                                   ; preds = %ehcleanup151, %ehcleanup149, %ehcleanup123, %ehcleanup100, %ehcleanup76, %ehcleanup52, %ehcleanup
  %67 = landingpad { i8*, i32 }
          catch i8* null
  %68 = extractvalue { i8*, i32 } %67, 0
  call void @__clang_call_terminate(i8* %68) #8
  br label %UnifiedUnreachableBlock

unreachable:                                      ; preds = %invoke.cont131, %invoke.cont120, %invoke.cont97, %invoke.cont73, %invoke.cont49, %invoke.cont28
  br label %UnifiedUnreachableBlock

UnifiedUnreachableBlock:                          ; preds = %unreachable, %terminate.lpad
  unreachable
}

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_517DatatypeValidator8setFixedEi(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103), i32) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare %"class.xercesc_2_5::RefHashTableOf.1"* @_ZNK11xercesc_2_517DatatypeValidator9getFacetsEv(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103)) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare i16* @_ZN11xercesc_2_512KVStringPair6getKeyEv(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48)) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare i16* @_ZN11xercesc_2_512KVStringPair8getValueEv(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_517DatatypeValidator10setPatternEPKt(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103), i16*) local_unnamed_addr #4 align 2

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZN11xercesc_2_59XMLString9textToBinEPKtRjPNS_13MemoryManagerE(i16*, i32* nocapture nonnull align 4 dereferenceable(4), %"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #4 align 2

; Function Attrs: noinline optsize uwtable
declare i32 @_ZN11xercesc_2_59XMLString8parseIntEPKtPNS_13MemoryManagerE(i16*, %"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #4 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_523AbstractStringValidator9setLengthEj(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128), i32) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_523AbstractStringValidator12setMinLengthEj(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128), i32) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_523AbstractStringValidator12setMaxLengthEj(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128), i32) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
define void @_ZN11xercesc_2_523AbstractStringValidator11assignFacetEPNS_13MemoryManagerE(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128) %this, %"class.xalanc_1_8::XalanNode"* %manager) local_unnamed_addr #4 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %e = alloca %"class.xercesc_2_5::RefHashTableOfEnumerator.1045", align 8
  %pair = alloca %"class.xercesc_2_5::KVStringPair", align 8
  %val115 = alloca i32, align 4
  %0 = bitcast %"class.xercesc_2_5::AbstractStringValidator.4114"* %this to %"class.xercesc_2_5::DatatypeValidator.3654"*
  %call = tail call %"class.xercesc_2_5::RefHashTableOf.1"* @_ZNK11xercesc_2_517DatatypeValidator9getFacetsEv(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0) #5
  %tobool.not = icmp eq %"class.xercesc_2_5::RefHashTableOf.1"* %call, null
  br i1 %tobool.not, label %cleanup, label %if.end

if.end:                                           ; preds = %entry
  %1 = bitcast %"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* %e to i8*
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %1) #6
  call void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEEC2EPNS_14RefHashTableOfIS1_EEbPNS_13MemoryManagerE(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e, %"class.xercesc_2_5::RefHashTableOf.1"* nonnull %call, i1 zeroext false, %"class.xalanc_1_8::XalanNode"* %manager) #5
  %2 = bitcast %"class.xercesc_2_5::KVStringPair"* %pair to i8*
  %3 = bitcast %"class.xercesc_2_5::AbstractStringValidator.4114"* %this to void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)***
  %4 = bitcast i32* %val115 to i8*
  %5 = getelementptr inbounds %"class.xercesc_2_5::AbstractStringValidator.4114", %"class.xercesc_2_5::AbstractStringValidator.4114"* %this, i64 0, i32 0, i32 1
  %call2249 = call zeroext i1 @_ZNK11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE15hasMoreElementsEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
  br i1 %call2249, label %while.body, label %while.end

while.body:                                       ; preds = %if.end, %invoke.cont152
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %2) #6
  %call5 = invoke nonnull align 8 dereferenceable(48) %"class.xercesc_2_5::KVStringPair"* @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE11nextElementEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
          to label %invoke.cont4 unwind label %lpad3

invoke.cont4:                                     ; preds = %while.body
  invoke void @_ZN11xercesc_2_512KVStringPairC1ERKS0_(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair, %"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %call5) #5
          to label %invoke.cont6 unwind label %lpad3

invoke.cont6:                                     ; preds = %invoke.cont4
  %call9 = call i16* @_ZN11xercesc_2_512KVStringPair6getKeyEv(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
  %call11 = call i16* @_ZN11xercesc_2_512KVStringPair8getValueEv(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
  %call13 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([7 x i16], [7 x i16]* @_ZN11xercesc_2_513SchemaSymbols12fgELT_LENGTHE, i64 0, i64 0)) #5
  br i1 %call13, label %if.then14, label %if.else

if.then14:                                        ; preds = %invoke.cont6
  %call17 = invoke i32 @_ZN11xercesc_2_59XMLString8parseIntEPKtPNS_13MemoryManagerE(i16* %call11, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont16 unwind label %lpad15

invoke.cont16:                                    ; preds = %if.then14
  %cmp = icmp slt i32 %call17, 0
  br i1 %cmp, label %if.then23, label %if.end29

lpad3:                                            ; preds = %if.end151, %invoke.cont4, %while.body
  %6 = landingpad { i8*, i32 }
          cleanup
  %7 = extractvalue { i8*, i32 } %6, 0
  %8 = extractvalue { i8*, i32 } %6, 1
  br label %ehcleanup155

lpad7:                                            ; preds = %if.else145, %if.then103
  %9 = landingpad { i8*, i32 }
          cleanup
  %10 = extractvalue { i8*, i32 } %9, 0
  %11 = extractvalue { i8*, i32 } %9, 1
  br label %ehcleanup153

lpad15:                                           ; preds = %if.then14
  %12 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %13 = extractvalue { i8*, i32 } %12, 0
  %14 = extractvalue { i8*, i32 } %12, 1
  %15 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches = icmp eq i32 %14, %15
  br i1 %matches, label %catch, label %ehcleanup153

catch:                                            ; preds = %lpad15
  %16 = call i8* @__cxa_begin_catch(i8* %13) #6
  %exception = call i8* @__cxa_allocate_exception(i64 48) #6
  %17 = bitcast i8* %exception to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %17, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 274, i32 154, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont19 unwind label %lpad18

invoke.cont19:                                    ; preds = %catch
  invoke void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad20

lpad18:                                           ; preds = %catch
  %18 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception) #6
  br label %ehcleanup

lpad20:                                           ; preds = %invoke.cont19
  %19 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup

ehcleanup:                                        ; preds = %lpad20, %lpad18
  %.pn228 = phi { i8*, i32 } [ %19, %lpad20 ], [ %18, %lpad18 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont21 unwind label %terminate.lpad

invoke.cont21:                                    ; preds = %ehcleanup
  %exn.slot.0 = extractvalue { i8*, i32 } %.pn228, 0
  %ehselector.slot.0 = extractvalue { i8*, i32 } %.pn228, 1
  br label %ehcleanup153

if.then23:                                        ; preds = %invoke.cont16
  %exception24 = call i8* @__cxa_allocate_exception(i64 48) #6
  %20 = bitcast i8* %exception24 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %20, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 278, i32 157, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont26 unwind label %lpad25

invoke.cont26:                                    ; preds = %if.then23
  invoke void @__cxa_throw(i8* %exception24, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad28

lpad25:                                           ; preds = %if.then23
  %21 = landingpad { i8*, i32 }
          cleanup
  %22 = extractvalue { i8*, i32 } %21, 0
  %23 = extractvalue { i8*, i32 } %21, 1
  call void @__cxa_free_exception(i8* %exception24) #6
  br label %ehcleanup153

lpad28:                                           ; preds = %invoke.cont26
  %24 = landingpad { i8*, i32 }
          cleanup
  %25 = extractvalue { i8*, i32 } %24, 0
  %26 = extractvalue { i8*, i32 } %24, 1
  br label %ehcleanup153

if.end29:                                         ; preds = %invoke.cont16
  call void @_ZN11xercesc_2_523AbstractStringValidator9setLengthEj(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128) %this, i32 %call17) #5
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 1) #5
  br label %if.end151

if.else:                                          ; preds = %invoke.cont6
  %call34 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([10 x i16], [10 x i16]* @_ZN11xercesc_2_513SchemaSymbols15fgELT_MINLENGTHE, i64 0, i64 0)) #5
  br i1 %call34, label %if.then35, label %if.else66

if.then35:                                        ; preds = %if.else
  %call39 = invoke i32 @_ZN11xercesc_2_59XMLString8parseIntEPKtPNS_13MemoryManagerE(i16* %call11, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont38 unwind label %lpad37

invoke.cont38:                                    ; preds = %if.then35
  %cmp55 = icmp slt i32 %call39, 0
  br i1 %cmp55, label %if.then56, label %if.end62

lpad37:                                           ; preds = %if.then35
  %27 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %28 = extractvalue { i8*, i32 } %27, 0
  %29 = extractvalue { i8*, i32 } %27, 1
  %30 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches42 = icmp eq i32 %29, %30
  br i1 %matches42, label %catch43, label %ehcleanup153

catch43:                                          ; preds = %lpad37
  %31 = call i8* @__cxa_begin_catch(i8* %28) #6
  %exception46 = call i8* @__cxa_allocate_exception(i64 48) #6
  %32 = bitcast i8* %exception46 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %32, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 292, i32 156, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont48 unwind label %lpad47

invoke.cont48:                                    ; preds = %catch43
  invoke void @__cxa_throw(i8* %exception46, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad50

lpad47:                                           ; preds = %catch43
  %33 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception46) #6
  br label %ehcleanup51

lpad50:                                           ; preds = %invoke.cont48
  %34 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup51

ehcleanup51:                                      ; preds = %lpad50, %lpad47
  %.pn226 = phi { i8*, i32 } [ %34, %lpad50 ], [ %33, %lpad47 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont52 unwind label %terminate.lpad

invoke.cont52:                                    ; preds = %ehcleanup51
  %exn.slot.2 = extractvalue { i8*, i32 } %.pn226, 0
  %ehselector.slot.2 = extractvalue { i8*, i32 } %.pn226, 1
  br label %ehcleanup153

if.then56:                                        ; preds = %invoke.cont38
  %exception57 = call i8* @__cxa_allocate_exception(i64 48) #6
  %35 = bitcast i8* %exception57 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %35, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 296, i32 159, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont59 unwind label %lpad58

invoke.cont59:                                    ; preds = %if.then56
  invoke void @__cxa_throw(i8* %exception57, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad61

lpad58:                                           ; preds = %if.then56
  %36 = landingpad { i8*, i32 }
          cleanup
  %37 = extractvalue { i8*, i32 } %36, 0
  %38 = extractvalue { i8*, i32 } %36, 1
  call void @__cxa_free_exception(i8* %exception57) #6
  br label %ehcleanup153

lpad61:                                           ; preds = %invoke.cont59
  %39 = landingpad { i8*, i32 }
          cleanup
  %40 = extractvalue { i8*, i32 } %39, 0
  %41 = extractvalue { i8*, i32 } %39, 1
  br label %ehcleanup153

if.end62:                                         ; preds = %invoke.cont38
  call void @_ZN11xercesc_2_523AbstractStringValidator12setMinLengthEj(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128) %this, i32 %call39) #5
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 2) #5
  br label %if.end151

if.else66:                                        ; preds = %if.else
  %call68 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([10 x i16], [10 x i16]* @_ZN11xercesc_2_513SchemaSymbols15fgELT_MAXLENGTHE, i64 0, i64 0)) #5
  br i1 %call68, label %if.then69, label %if.else100

if.then69:                                        ; preds = %if.else66
  %call73 = invoke i32 @_ZN11xercesc_2_59XMLString8parseIntEPKtPNS_13MemoryManagerE(i16* %call11, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont72 unwind label %lpad71

invoke.cont72:                                    ; preds = %if.then69
  %cmp89 = icmp slt i32 %call73, 0
  br i1 %cmp89, label %if.then90, label %if.end96

lpad71:                                           ; preds = %if.then69
  %42 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)
  %43 = extractvalue { i8*, i32 } %42, 0
  %44 = extractvalue { i8*, i32 } %42, 1
  %45 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_521NumberFormatExceptionE to i8*)) #6
  %matches76 = icmp eq i32 %44, %45
  br i1 %matches76, label %catch77, label %ehcleanup153

catch77:                                          ; preds = %lpad71
  %46 = call i8* @__cxa_begin_catch(i8* %43) #6
  %exception80 = call i8* @__cxa_allocate_exception(i64 48) #6
  %47 = bitcast i8* %exception80 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %47, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 310, i32 155, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont82 unwind label %lpad81

invoke.cont82:                                    ; preds = %catch77
  invoke void @__cxa_throw(i8* %exception80, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad84

lpad81:                                           ; preds = %catch77
  %48 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception80) #6
  br label %ehcleanup85

lpad84:                                           ; preds = %invoke.cont82
  %49 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup85

ehcleanup85:                                      ; preds = %lpad84, %lpad81
  %.pn224 = phi { i8*, i32 } [ %49, %lpad84 ], [ %48, %lpad81 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont86 unwind label %terminate.lpad

invoke.cont86:                                    ; preds = %ehcleanup85
  %exn.slot.4 = extractvalue { i8*, i32 } %.pn224, 0
  %ehselector.slot.4 = extractvalue { i8*, i32 } %.pn224, 1
  br label %ehcleanup153

if.then90:                                        ; preds = %invoke.cont72
  %exception91 = call i8* @__cxa_allocate_exception(i64 48) #6
  %50 = bitcast i8* %exception91 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPKtS6_S6_S6_PNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %50, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 314, i32 158, i16* %call11, i16* null, i16* null, i16* null, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont93 unwind label %lpad92

invoke.cont93:                                    ; preds = %if.then90
  invoke void @__cxa_throw(i8* %exception91, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad95

lpad92:                                           ; preds = %if.then90
  %51 = landingpad { i8*, i32 }
          cleanup
  %52 = extractvalue { i8*, i32 } %51, 0
  %53 = extractvalue { i8*, i32 } %51, 1
  call void @__cxa_free_exception(i8* %exception91) #6
  br label %ehcleanup153

lpad95:                                           ; preds = %invoke.cont93
  %54 = landingpad { i8*, i32 }
          cleanup
  %55 = extractvalue { i8*, i32 } %54, 0
  %56 = extractvalue { i8*, i32 } %54, 1
  br label %ehcleanup153

if.end96:                                         ; preds = %invoke.cont72
  call void @_ZN11xercesc_2_523AbstractStringValidator12setMaxLengthEj(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128) %this, i32 %call73) #5
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 4) #5
  br label %if.end151

if.else100:                                       ; preds = %if.else66
  %call102 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([8 x i16], [8 x i16]* @_ZN11xercesc_2_513SchemaSymbols13fgELT_PATTERNE, i64 0, i64 0)) #5
  br i1 %call102, label %if.then103, label %if.else111

if.then103:                                       ; preds = %if.else100
  invoke void @_ZN11xercesc_2_517DatatypeValidator10setPatternEPKt(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i16* %call11) #5
          to label %invoke.cont104 unwind label %lpad7

invoke.cont104:                                   ; preds = %if.then103
  %call106 = call i16* bitcast (i16* (%"class.xercesc_2_5::DatatypeValidator"*)* @_ZNK11xercesc_2_517DatatypeValidator10getPatternEv to i16* (%"class.xercesc_2_5::DatatypeValidator.3654"*)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0) #5
  %tobool107.not = icmp eq i16* %call106, null
  br i1 %tobool107.not, label %if.end151, label %if.then108

if.then108:                                       ; preds = %invoke.cont104
  call void bitcast (void (%"class.xercesc_2_5::DatatypeValidator"*, i32)* @_ZN11xercesc_2_517DatatypeValidator16setFacetsDefinedEi to void (%"class.xercesc_2_5::DatatypeValidator.3654"*, i32)*)(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 8) #5
  br label %if.end151

if.else111:                                       ; preds = %if.else100
  %call113 = call zeroext i1 @_ZN11xercesc_2_59XMLString6equalsEPKtS2_(i16* %call9, i16* getelementptr inbounds ([6 x i16], [6 x i16]* @_ZN11xercesc_2_513SchemaSymbols11fgATT_FIXEDE, i64 0, i64 0)) #5
  br i1 %call113, label %if.then114, label %if.else145

if.then114:                                       ; preds = %if.else111
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #6
  %57 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %5, align 8, !tbaa !7
  %call118 = invoke zeroext i1 @_ZN11xercesc_2_59XMLString9textToBinEPKtRjPNS_13MemoryManagerE(i16* %call11, i32* nonnull align 4 dereferenceable(4) %val115, %"class.xalanc_1_8::XalanNode"* %57) #5
          to label %invoke.cont117 unwind label %lpad116

invoke.cont117:                                   ; preds = %if.then114
  br i1 %call118, label %if.end141, label %if.then135

lpad116:                                          ; preds = %if.then114
  %58 = landingpad { i8*, i32 }
          cleanup
          catch i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_516RuntimeExceptionE to i8*)
  %59 = extractvalue { i8*, i32 } %58, 0
  %60 = extractvalue { i8*, i32 } %58, 1
  %61 = call i32 @llvm.eh.typeid.for(i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_516RuntimeExceptionE to i8*)) #6
  %matches121 = icmp eq i32 %60, %61
  br i1 %matches121, label %catch122, label %ehcleanup143

catch122:                                         ; preds = %lpad116
  %62 = call i8* @__cxa_begin_catch(i8* %59) #6
  %exception125 = call i8* @__cxa_allocate_exception(i64 48) #6
  %63 = bitcast i8* %exception125 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %63, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 336, i32 226, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont127 unwind label %lpad126

invoke.cont127:                                   ; preds = %catch122
  invoke void @__cxa_throw(i8* %exception125, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad129

lpad126:                                          ; preds = %catch122
  %64 = landingpad { i8*, i32 }
          cleanup
  call void @__cxa_free_exception(i8* %exception125) #6
  br label %ehcleanup130

lpad129:                                          ; preds = %invoke.cont127
  %65 = landingpad { i8*, i32 }
          cleanup
  br label %ehcleanup130

ehcleanup130:                                     ; preds = %lpad129, %lpad126
  %.pn = phi { i8*, i32 } [ %65, %lpad129 ], [ %64, %lpad126 ]
  invoke void @__cxa_end_catch()
          to label %invoke.cont131 unwind label %terminate.lpad

invoke.cont131:                                   ; preds = %ehcleanup130
  %exn.slot.6 = extractvalue { i8*, i32 } %.pn, 0
  %ehselector.slot.6 = extractvalue { i8*, i32 } %.pn, 1
  br label %ehcleanup143

if.then135:                                       ; preds = %invoke.cont117
  %exception136 = call i8* @__cxa_allocate_exception(i64 48) #6
  %66 = bitcast i8* %exception136 to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_529InvalidDatatypeFacetExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %66, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.4856, i64 0, i64 0), i32 341, i32 226, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %invoke.cont138 unwind label %lpad137

invoke.cont138:                                   ; preds = %if.then135
  invoke void @__cxa_throw(i8* %exception136, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_529InvalidDatatypeFacetExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #7
          to label %unreachable unwind label %lpad140

lpad137:                                          ; preds = %if.then135
  %67 = landingpad { i8*, i32 }
          cleanup
  %68 = extractvalue { i8*, i32 } %67, 0
  %69 = extractvalue { i8*, i32 } %67, 1
  call void @__cxa_free_exception(i8* %exception136) #6
  br label %ehcleanup143

lpad140:                                          ; preds = %invoke.cont138
  %70 = landingpad { i8*, i32 }
          cleanup
  %71 = extractvalue { i8*, i32 } %70, 0
  %72 = extractvalue { i8*, i32 } %70, 1
  br label %ehcleanup143

if.end141:                                        ; preds = %invoke.cont117
  %73 = load i32, i32* %val115, align 4, !tbaa !16
  call void @_ZN11xercesc_2_517DatatypeValidator8setFixedEi(%"class.xercesc_2_5::DatatypeValidator.3654"* nonnull align 8 dereferenceable(103) %0, i32 %73) #5
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #6
  br label %if.end151

ehcleanup143:                                     ; preds = %lpad140, %lpad137, %invoke.cont131, %lpad116
  %ehselector.slot.7 = phi i32 [ %72, %lpad140 ], [ %69, %lpad137 ], [ %ehselector.slot.6, %invoke.cont131 ], [ %60, %lpad116 ]
  %exn.slot.7 = phi i8* [ %71, %lpad140 ], [ %68, %lpad137 ], [ %exn.slot.6, %invoke.cont131 ], [ %59, %lpad116 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #6
  br label %ehcleanup153

if.else145:                                       ; preds = %if.else111
  %vtable = load void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)**, void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*** %3, align 8, !tbaa !4
  %vfn = getelementptr inbounds void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*, void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)** %vtable, i64 12
  %74 = load void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*, void (%"class.xercesc_2_5::AbstractStringValidator.4114"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  invoke void %74(%"class.xercesc_2_5::AbstractStringValidator.4114"* nonnull align 8 dereferenceable(128) %this, i16* %call9, i16* %call11, %"class.xalanc_1_8::XalanNode"* %manager) #5
          to label %if.end151 unwind label %lpad7

if.end151:                                        ; preds = %if.end62, %if.then108, %invoke.cont104, %if.else145, %if.end141, %if.end96, %if.end29
  invoke void @_ZN11xercesc_2_512KVStringPairD1Ev(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
          to label %invoke.cont152 unwind label %lpad3

invoke.cont152:                                   ; preds = %if.end151
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %2) #6
  %call2 = call zeroext i1 @_ZNK11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEE15hasMoreElementsEv(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
  br i1 %call2, label %while.body, label %while.end, !llvm.loop !19

ehcleanup153:                                     ; preds = %lpad71, %invoke.cont86, %lpad92, %lpad95, %lpad37, %invoke.cont52, %lpad58, %lpad61, %lpad15, %invoke.cont21, %lpad25, %lpad28, %ehcleanup143, %lpad7
  %ehselector.slot.8 = phi i32 [ %11, %lpad7 ], [ %ehselector.slot.7, %ehcleanup143 ], [ %26, %lpad28 ], [ %23, %lpad25 ], [ %ehselector.slot.0, %invoke.cont21 ], [ %14, %lpad15 ], [ %41, %lpad61 ], [ %38, %lpad58 ], [ %ehselector.slot.2, %invoke.cont52 ], [ %29, %lpad37 ], [ %56, %lpad95 ], [ %53, %lpad92 ], [ %ehselector.slot.4, %invoke.cont86 ], [ %44, %lpad71 ]
  %exn.slot.8 = phi i8* [ %10, %lpad7 ], [ %exn.slot.7, %ehcleanup143 ], [ %25, %lpad28 ], [ %22, %lpad25 ], [ %exn.slot.0, %invoke.cont21 ], [ %13, %lpad15 ], [ %40, %lpad61 ], [ %37, %lpad58 ], [ %exn.slot.2, %invoke.cont52 ], [ %28, %lpad37 ], [ %55, %lpad95 ], [ %52, %lpad92 ], [ %exn.slot.4, %invoke.cont86 ], [ %43, %lpad71 ]
  invoke void @_ZN11xercesc_2_512KVStringPairD1Ev(%"class.xercesc_2_5::KVStringPair"* nonnull align 8 dereferenceable(48) %pair) #5
          to label %ehcleanup155 unwind label %terminate.lpad

ehcleanup155:                                     ; preds = %ehcleanup153, %lpad3
  %ehselector.slot.9 = phi i32 [ %ehselector.slot.8, %ehcleanup153 ], [ %8, %lpad3 ]
  %exn.slot.9 = phi i8* [ %exn.slot.8, %ehcleanup153 ], [ %7, %lpad3 ]
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %2) #6
  invoke void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEED2Ev(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
          to label %invoke.cont157 unwind label %terminate.lpad

while.end:                                        ; preds = %invoke.cont152, %if.end
  call void @_ZN11xercesc_2_524RefHashTableOfEnumeratorINS_12KVStringPairEED2Ev(%"class.xercesc_2_5::RefHashTableOfEnumerator.1045"* nonnull align 8 dereferenceable(48) %e) #5
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %1) #6
  br label %cleanup

cleanup:                                          ; preds = %entry, %while.end
  ret void

invoke.cont157:                                   ; preds = %ehcleanup155
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %1) #6
  %lpad.val = insertvalue { i8*, i32 } undef, i8* %exn.slot.9, 0
  %lpad.val164 = insertvalue { i8*, i32 } %lpad.val, i32 %ehselector.slot.9, 1
  resume { i8*, i32 } %lpad.val164

terminate.lpad:                                   ; preds = %ehcleanup155, %ehcleanup153, %ehcleanup130, %ehcleanup85, %ehcleanup51, %ehcleanup
  %75 = landingpad { i8*, i32 }
          catch i8* null
  %76 = extractvalue { i8*, i32 } %75, 0
  call void @__clang_call_terminate(i8* %76) #8
  br label %UnifiedUnreachableBlock

unreachable:                                      ; preds = %invoke.cont138, %invoke.cont127, %invoke.cont93, %invoke.cont82, %invoke.cont59, %invoke.cont48, %invoke.cont26, %invoke.cont19
  br label %UnifiedUnreachableBlock

UnifiedUnreachableBlock:                          ; preds = %unreachable, %terminate.lpad
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_512XMLExceptionD2Ev(%"class.xercesc_2_5::XMLException"* nocapture nonnull align 8 dereferenceable(48)) unnamed_addr #4 align 2

declare void @_ZN11xercesc_2_512KVStringPairC1ERKS0_(%"class.xercesc_2_5::KVStringPair"*, %"class.xercesc_2_5::KVStringPair"*)

declare void @_ZN11xercesc_2_512KVStringPairD1Ev(%"class.xercesc_2_5::KVStringPair"*)

attributes #0 = { noinline noreturn nounwind }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind readnone }
attributes #4 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { optsize }
attributes #6 = { nounwind }
attributes #7 = { noreturn }
attributes #8 = { noreturn nounwind }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"vtable pointer", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{!8, !9, i64 8}
!8 = !{!"_ZTSN11xercesc_2_517DatatypeValidatorE", !9, i64 8, !11, i64 16, !12, i64 18, !13, i64 20, !13, i64 24, !13, i64 28, !14, i64 32, !9, i64 40, !9, i64 48, !9, i64 56, !9, i64 64, !9, i64 72, !9, i64 80, !9, i64 88, !15, i64 96, !11, i64 100, !11, i64 101, !11, i64 102}
!9 = !{!"any pointer", !10, i64 0}
!10 = !{!"omnipotent char", !6, i64 0}
!11 = !{!"bool", !10, i64 0}
!12 = !{!"short", !10, i64 0}
!13 = !{!"int", !10, i64 0}
!14 = !{!"_ZTSN11xercesc_2_517DatatypeValidator13ValidatorTypeE", !10, i64 0}
!15 = !{!"_ZTSN11xercesc_2_522XSSimpleTypeDefinition8ORDERINGE", !10, i64 0}
!16 = !{!13, !13, i64 0}
!17 = distinct !{!17, !18}
!18 = !{!"llvm.loop.unroll.disable"}
!19 = distinct !{!19, !18}
