; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-disable-post-opt --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false -o %t.mfm.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-disable-post-opt --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -o %t.mfm-hyfm.bc %s
; RUN: %llc --filetype=obj %t.mfm.bc -o %t.mfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -gt $(stat -c%%s %t.mfm.o)

; ModuleID = '.x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/400.perlbench/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull i8* @Perl_uvuni_to_utf8_flags(i8*, i64, i64) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
define nonnull i8* @Perl_uvuni_to_utf8(i8* %d, i64 %uv) local_unnamed_addr #0 {
entry:
  %call = tail call i8* @Perl_uvuni_to_utf8_flags(i8* %d, i64 %uv, i64 0) #1
  ret i8* %call
}

; Function Attrs: noinline nounwind optsize uwtable
define nonnull i8* @Perl_uvchr_to_utf8_flags(i8* %d, i64 %uv, i64 %flags) local_unnamed_addr #0 {
entry:
  %call = tail call i8* @Perl_uvuni_to_utf8_flags(i8* %d, i64 %uv, i64 %flags) #1
  ret i8* %call
}

attributes #0 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 13.0.0 (git@github.com:ppetoumenos/llvm-project.git 70a9fb72f98c9897c164fba3d27e76821498d6e1)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
