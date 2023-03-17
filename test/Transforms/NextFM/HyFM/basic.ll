; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -multiple-func-merging-hyfm-nw -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%"class.xercesc_2_5::TranscodingException" = type { %"class.xercesc_2_5::XMLException" }
%"class.xercesc_2_5::XMLException" = type { i32 (...)**, i32, i8*, i32, i16*, %"class.xalanc_1_8::XalanNode"* }

@.str.1705 = external hidden unnamed_addr constant [27 x i8], align 1
@_ZTIN11xercesc_2_525XMLPlatformUtilsExceptionE = external constant { i8*, i8*, i8* }, align 8

declare i32 @__gxx_personality_v0(...)

declare i8* @__cxa_allocate_exception(i64) local_unnamed_addr

declare void @__cxa_throw(i8*, i8*, i8*) local_unnamed_addr

declare void @__cxa_free_exception(i8*) local_unnamed_addr

; Function Attrs: noinline optsize uwtable
define i32 @_ZN11xercesc_2_516XMLPlatformUtils10curFilePosEPvPNS_13MemoryManagerE(i8* nocapture %theFile, %"class.xalanc_1_8::XalanNode"* %manager) local_unnamed_addr #0 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = bitcast i8* %theFile to %struct._IO_FILE*
  %call = tail call i64 @ftell(%struct._IO_FILE* %0) #3
  %conv = trunc i64 %call to i32
  %cmp = icmp eq i32 %conv, -1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %exception = tail call i8* @__cxa_allocate_exception(i64 48) #4
  %1 = bitcast i8* %exception to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_525XMLPlatformUtilsExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %1, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1705, i64 0, i64 0), i32 363, i32 40, %"class.xalanc_1_8::XalanNode"* %manager) #3
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %if.then
  tail call void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_525XMLPlatformUtilsExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #5
  unreachable

lpad:                                             ; preds = %if.then
  %2 = landingpad { i8*, i32 }
          cleanup
  tail call void @__cxa_free_exception(i8* %exception) #4
  resume { i8*, i32 } %2

if.end:                                           ; preds = %entry
  ret i32 %conv
}

; Function Attrs: nofree nounwind optsize
declare noundef i64 @ftell(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_525XMLPlatformUtilsExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48), i8*, i32, i32, %"class.xalanc_1_8::XalanNode"*) unnamed_addr #0 align 2

; Function Attrs: noinline optsize uwtable
define i32 @_ZN11xercesc_2_516XMLPlatformUtils14readFileBufferEPvjPhPNS_13MemoryManagerE(i8* nocapture %theFile, i32 %toRead, i8* nocapture %toFill, %"class.xalanc_1_8::XalanNode"* %manager) local_unnamed_addr #0 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %conv = zext i32 %toRead to i64
  %0 = bitcast i8* %theFile to %struct._IO_FILE*
  %call = tail call i64 @fread(i8* %toFill, i64 1, i64 %conv, %struct._IO_FILE* %0) #3
  %call1 = tail call i32 @ferror(%struct._IO_FILE* %0) #6
  %tobool.not = icmp eq i32 %call1, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %exception = tail call i8* @__cxa_allocate_exception(i64 48) #4
  %1 = bitcast i8* %exception to %"class.xercesc_2_5::TranscodingException"*
  invoke void @_ZN11xercesc_2_525XMLPlatformUtilsExceptionC2EPKcjNS_10XMLExcepts5CodesEPNS_13MemoryManagerE(%"class.xercesc_2_5::TranscodingException"* nonnull align 8 dereferenceable(48) %1, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1705, i64 0, i64 0), i32 456, i32 37, %"class.xalanc_1_8::XalanNode"* %manager) #3
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %if.then
  tail call void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8*, i8* }* @_ZTIN11xercesc_2_525XMLPlatformUtilsExceptionE to i8*), i8* bitcast (void (%"class.xercesc_2_5::XMLException"*)* @_ZN11xercesc_2_512XMLExceptionD2Ev to i8*)) #5
  unreachable

lpad:                                             ; preds = %if.then
  %2 = landingpad { i8*, i32 }
          cleanup
  tail call void @__cxa_free_exception(i8* %exception) #4
  resume { i8*, i32 } %2

if.end:                                           ; preds = %entry
  %conv2 = trunc i64 %call to i32
  ret i32 %conv2
}

; Function Attrs: nofree nounwind optsize
declare noundef i64 @fread(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #1

; Function Attrs: nofree nounwind optsize readonly
declare noundef i32 @ferror(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_512XMLExceptionD2Ev(%"class.xercesc_2_5::XMLException"* nocapture nonnull align 8 dereferenceable(48)) unnamed_addr #0 align 2

attributes #0 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind optsize readonly "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { optsize }
attributes #4 = { nounwind }
attributes #5 = { noreturn }
attributes #6 = { nounwind optsize }
