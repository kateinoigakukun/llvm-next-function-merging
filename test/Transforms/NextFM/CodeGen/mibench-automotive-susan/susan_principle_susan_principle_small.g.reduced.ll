; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null \
; RUN:   -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging \
; RUN:   --multiple-func-merging-only=susan_principle_small \
; RUN:   --multiple-func-merging-only=susan_edges \
; RUN:   %s 2> /dev/null | FileCheck %s
; CHECK-NOT:   - Reason:          Invalid merged function
; XFAIL: *

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

define i32 @susan_principle_small() !dbg !21 {
  ret i32 undef, !dbg !24
}

define i32 @susan_edges() !dbg !25 {
  call void @llvm.dbg.declare(metadata i8** undef, metadata !28, metadata !DIExpression()), !dbg !29
  ret i32 undef
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18, !19, !20}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 13.0.0 (https://github.com/llvm/llvm-project/ 24c8eaec9467b2aaf70b0db33a4e4dd415139a50)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "external/mibench_automotive/susan/susan.c", directory: "/proc/self/cwd")
!2 = !{}
!3 = !{!4, !5, !6, !8, !9, !10, !7, !11}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "uchar", file: !1, line: 308, baseType: !7)
!7 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!10 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!12 = !{!"clang version 13.0.0 (https://github.com/llvm/llvm-project/ 24c8eaec9467b2aaf70b0db33a4e4dd415139a50)"}
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 7, !"PIC Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 1}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{i32 1, !"ThinLTO", i32 0}
!20 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!21 = distinct !DISubprogram(name: "susan_principle_small", scope: !1, file: !1, line: 568, type: !22, scopeLine: 571, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!22 = !DISubroutineType(types: !23)
!23 = !{!8, !5, !11, !5, !8, !8, !8}
!24 = !DILocation(line: 603, column: 1, scope: !21)
!25 = distinct !DISubprogram(name: "susan_edges", scope: !1, file: !1, line: 1064, type: !26, scopeLine: 1067, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!26 = !DISubroutineType(types: !27)
!27 = !{!8, !5, !11, !5, !5, !8, !8, !8}
!28 = !DILocalVariable(name: "in", arg: 1, scope: !25, file: !1, line: 1065, type: !5)
!29 = !DILocation(line: 1065, column: 10, scope: !25)
