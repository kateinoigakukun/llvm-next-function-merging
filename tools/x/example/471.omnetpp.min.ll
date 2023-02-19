; ModuleID = 'benchmarks/spec2006/471.omnetpp/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%class.cPar = type { %class.cObject, i8, i8, i8, %class.opp_string, %union.anon.132 }
%class.cObject = type { i32 (...)**, i8*, i8, i8, %class.cObject*, %class.cObject*, %class.cObject*, %class.cObject* }
%class.opp_string = type { i8* }
%union.anon.132 = type { %struct.anon.3 }
%struct.anon.3 = type { double (...)*, i32, double, double, double, double }

; Function Attrs: noinline optsize uwtable
define align 8 %class.cPar* @_ZN4cPar12setLongValueEl(%class.cPar* align 8 %this, i64 %l) local_unnamed_addr #0 align 2 {
entry:
  %0 = bitcast %class.cPar* %this to void (%class.cPar*)***
  %vtable = load void (%class.cPar*)**, void (%class.cPar*)*** %0, align 8
  %vfn = getelementptr inbounds void (%class.cPar*)*, void (%class.cPar*)** %vtable, i64 14
  %1 = load void (%class.cPar*)*, void (%class.cPar*)** %vfn, align 8
  tail call void %1(%class.cPar* align 8 %this)
  %2 = getelementptr inbounds %class.cPar, %class.cPar* %this, i64 0, i32 5
  %val = bitcast %union.anon.132* %2 to i64*
  store i64 %l, i64* %val, align 8
  %typechar = getelementptr inbounds %class.cPar, %class.cPar* %this, i64 0, i32 1
  store i8 76, i8* %typechar, align 8
  ret %class.cPar* %this
}

; Function Attrs: noinline optsize uwtable
define align 8 %class.cPar* @_ZN4cPar14setDoubleValueEd(%class.cPar* align 8 %this, double %d) local_unnamed_addr #0 align 2 {
entry:
  %0 = bitcast %class.cPar* %this to void (%class.cPar*)***
  %vtable = load void (%class.cPar*)**, void (%class.cPar*)*** %0, align 8
  %vfn = getelementptr inbounds void (%class.cPar*)*, void (%class.cPar*)** %vtable, i64 14
  %1 = load void (%class.cPar*)*, void (%class.cPar*)** %vfn, align 8
  tail call void %1(%class.cPar* align 8 %this)
  %2 = getelementptr inbounds %class.cPar, %class.cPar* %this, i64 0, i32 5
  %val = bitcast %union.anon.132* %2 to double*
  store double %d, double* %val, align 8
  %typechar = getelementptr inbounds %class.cPar, %class.cPar* %this, i64 0, i32 1
  store i8 68, i8* %typechar, align 8
  ret %class.cPar* %this
}

; Function Attrs: noinline optsize uwtable
define align 8 %class.cPar* @_ZN4cPar12setBoolValueEb(%class.cPar* align 8 %this, i1 zeroext %b) local_unnamed_addr #0 align 2 {
entry:
  %0 = bitcast %class.cPar* %this to void (%class.cPar*)***
  %vtable = load void (%class.cPar*)**, void (%class.cPar*)*** %0, align 8
  %vfn = getelementptr inbounds void (%class.cPar*)*, void (%class.cPar*)** %vtable, i64 14
  %1 = load void (%class.cPar*)*, void (%class.cPar*)** %vfn, align 8
  tail call void %1(%class.cPar* align 8 %this)
  %conv = zext i1 %b to i64
  %2 = getelementptr inbounds %class.cPar, %class.cPar* %this, i64 0, i32 5
  %val = bitcast %union.anon.132* %2 to i64*
  store i64 %conv, i64* %val, align 8
  %typechar = getelementptr inbounds %class.cPar, %class.cPar* %this, i64 0, i32 1
  store i8 66, i8* %typechar, align 8
  ret %class.cPar* %this
}

; Function Attrs: noinline nounwind optsize uwtable
declare zeroext i1 @_ZNK4cPar12isRedirectedEv(%class.cPar* align 8 dereferenceable(120)) local_unnamed_addr #1 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN4cPar9deleteoldEv(%class.cPar* align 8 dereferenceable(120)) local_unnamed_addr #0 align 2

attributes #0 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"vtable pointer", !6, i64 0}
!9 = !{!10, !5, i64 56}
!10 = !{!"_ZTS4cPar", !5, i64 56, !11, i64 57, !11, i64 58, !12, i64 64, !5, i64 72}
!11 = !{!"bool", !5, i64 0}
!12 = !{!"_ZTS10opp_string", !13, i64 0}
!13 = !{!"any pointer", !5, i64 0}
!14 = !{!10, !11, i64 57}
