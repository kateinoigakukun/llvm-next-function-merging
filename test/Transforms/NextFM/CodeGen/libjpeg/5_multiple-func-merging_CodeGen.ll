; Generated from multiple-func-merging:CodeGen
; - set_quant_slots
; - set_sample_factors

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge
; CHECK-NEXT: Function:        __msa_merge_set_sample_factors_set_quant_slots

; ModuleID = '../bench-play/libjpeg.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.jpeg_compress_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_destination_mgr*, i32, i32, i32, i32, double, i32, i32, i32, %struct.jpeg_component_info*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], [16 x i8], [16 x i8], [16 x i8], i32, %struct.jpeg_scan_info*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8, i16, i16, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, %struct.jpeg_comp_master*, %struct.jpeg_c_main_controller*, %struct.jpeg_c_prep_controller*, %struct.jpeg_c_coef_controller*, %struct.jpeg_marker_writer*, %struct.jpeg_color_converter*, %struct.jpeg_downsampler*, %struct.jpeg_forward_dct*, %struct.jpeg_entropy_encoder* }
%struct.jpeg_error_mgr = type { void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i32)*, void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i8*)*, void (%struct.jpeg_common_struct*)*, i32, %union.anon, i32, i64, i8**, i32, i8**, i32, i32 }
%struct.jpeg_common_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32 }
%union.anon = type { [8 x i32], [48 x i8] }
%struct.jpeg_memory_mgr = type { i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)*, i8** (%struct.jpeg_common_struct*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, i32, i32, i32)*, %struct.jvirt_sarray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, %struct.jvirt_barray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, {}*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, %struct.jvirt_barray_control*, i32, i32, i32)*, void (%struct.jpeg_common_struct*, i32)*, {}*, i64 }
%struct.jvirt_sarray_control = type opaque
%struct.jvirt_barray_control = type opaque
%struct.jpeg_progress_mgr = type { {}*, i64, i64, i32, i32 }
%struct.jpeg_destination_mgr = type { i8*, i64, void (%struct.jpeg_compress_struct*)*, i32 (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)* }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_scan_info = type { i32, [4 x i32], i32, i32, i32, i32 }
%struct.jpeg_comp_master = type opaque
%struct.jpeg_c_main_controller = type opaque
%struct.jpeg_c_prep_controller = type opaque
%struct.jpeg_c_coef_controller = type opaque
%struct.jpeg_marker_writer = type opaque
%struct.jpeg_color_converter = type opaque
%struct.jpeg_downsampler = type opaque
%struct.jpeg_forward_dct = type opaque
%struct.jpeg_entropy_encoder = type opaque

@stderr = external global %struct._IO_FILE*, align 8
@.str.9.114 = external hidden unnamed_addr constant [5 x i8], align 1
@.str.10.115 = external hidden unnamed_addr constant [45 x i8], align 1
@.str.11.118 = external hidden unnamed_addr constant [9 x i8], align 1
@.str.12.119 = external hidden unnamed_addr constant [36 x i8], align 1

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #0

; Function Attrs: nounwind
declare i32 @__isoc99_sscanf(i8*, i8*, ...) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @set_quant_slots(%struct.jpeg_compress_struct* %0, i8* %1) #2 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.jpeg_compress_struct*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 0, i32* %6, align 4
  store i32 0, i32* %7, align 4
  br label %9

9:                                                ; preds = %69, %2
  %10 = load i32, i32* %7, align 4
  %11 = icmp slt i32 %10, 10
  br i1 %11, label %12, label %72

12:                                               ; preds = %9
  %13 = load i8*, i8** %5, align 8
  %14 = load i8, i8* %13, align 1
  %15 = icmp ne i8 %14, 0
  br i1 %15, label %16, label %59

16:                                               ; preds = %12
  store i8 44, i8* %8, align 1
  %17 = load i8*, i8** %5, align 8
  %18 = call i32 (i8*, i8*, ...) @__isoc99_sscanf(i8* %17, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.9.114, i64 0, i64 0), i32* %6, i8* %8) #3
  %19 = icmp slt i32 %18, 1
  br i1 %19, label %20, label %21

20:                                               ; preds = %16
  store i32 0, i32* %3, align 4
  br label %73

21:                                               ; preds = %16
  %22 = load i8, i8* %8, align 1
  %23 = sext i8 %22 to i32
  %24 = icmp ne i32 %23, 44
  br i1 %24, label %25, label %26

25:                                               ; preds = %21
  store i32 0, i32* %3, align 4
  br label %73

26:                                               ; preds = %21
  %27 = load i32, i32* %6, align 4
  %28 = icmp slt i32 %27, 0
  br i1 %28, label %32, label %29

29:                                               ; preds = %26
  %30 = load i32, i32* %6, align 4
  %31 = icmp sge i32 %30, 4
  br i1 %31, label %32, label %35

32:                                               ; preds = %29, %26
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %34 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.10.115, i64 0, i64 0), i32 3)
  store i32 0, i32* %3, align 4
  br label %73

35:                                               ; preds = %29
  %36 = load i32, i32* %6, align 4
  %37 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %38 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %37, i32 0, i32 14
  %39 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %38, align 8
  %40 = load i32, i32* %7, align 4
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %39, i64 %41
  %43 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %42, i32 0, i32 4
  store i32 %36, i32* %43, align 8
  br label %44

44:                                               ; preds = %57, %35
  %45 = load i8*, i8** %5, align 8
  %46 = load i8, i8* %45, align 1
  %47 = sext i8 %46 to i32
  %48 = icmp ne i32 %47, 0
  br i1 %48, label %49, label %55

49:                                               ; preds = %44
  %50 = load i8*, i8** %5, align 8
  %51 = getelementptr inbounds i8, i8* %50, i32 1
  store i8* %51, i8** %5, align 8
  %52 = load i8, i8* %50, align 1
  %53 = sext i8 %52 to i32
  %54 = icmp ne i32 %53, 44
  br label %55

55:                                               ; preds = %49, %44
  %56 = phi i1 [ false, %44 ], [ %54, %49 ]
  br i1 %56, label %57, label %58

57:                                               ; preds = %55
  br label %44, !llvm.loop !7

58:                                               ; preds = %55
  br label %68

59:                                               ; preds = %12
  %60 = load i32, i32* %6, align 4
  %61 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %62 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %61, i32 0, i32 14
  %63 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %62, align 8
  %64 = load i32, i32* %7, align 4
  %65 = sext i32 %64 to i64
  %66 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %63, i64 %65
  %67 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %66, i32 0, i32 4
  store i32 %60, i32* %67, align 8
  br label %68

68:                                               ; preds = %59, %58
  br label %69

69:                                               ; preds = %68
  %70 = load i32, i32* %7, align 4
  %71 = add nsw i32 %70, 1
  store i32 %71, i32* %7, align 4
  br label %9, !llvm.loop !9

72:                                               ; preds = %9
  store i32 1, i32* %3, align 4
  br label %73

73:                                               ; preds = %72, %32, %25, %20
  %74 = load i32, i32* %3, align 4
  ret i32 %74
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @set_sample_factors(%struct.jpeg_compress_struct* %0, i8* %1) #2 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.jpeg_compress_struct*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  %10 = alloca i8, align 1
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %4, align 8
  store i8* %1, i8** %5, align 8
  store i32 0, i32* %6, align 4
  br label %11

11:                                               ; preds = %99, %2
  %12 = load i32, i32* %6, align 4
  %13 = icmp slt i32 %12, 10
  br i1 %13, label %14, label %102

14:                                               ; preds = %11
  %15 = load i8*, i8** %5, align 8
  %16 = load i8, i8* %15, align 1
  %17 = icmp ne i8 %16, 0
  br i1 %17, label %18, label %83

18:                                               ; preds = %14
  store i8 44, i8* %10, align 1
  %19 = load i8*, i8** %5, align 8
  %20 = call i32 (i8*, i8*, ...) @__isoc99_sscanf(i8* %19, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.11.118, i64 0, i64 0), i32* %7, i8* %9, i32* %8, i8* %10) #3
  %21 = icmp slt i32 %20, 3
  br i1 %21, label %22, label %23

22:                                               ; preds = %18
  store i32 0, i32* %3, align 4
  br label %103

23:                                               ; preds = %18
  %24 = load i8, i8* %9, align 1
  %25 = sext i8 %24 to i32
  %26 = icmp ne i32 %25, 120
  br i1 %26, label %27, label %31

27:                                               ; preds = %23
  %28 = load i8, i8* %9, align 1
  %29 = sext i8 %28 to i32
  %30 = icmp ne i32 %29, 88
  br i1 %30, label %35, label %31

31:                                               ; preds = %27, %23
  %32 = load i8, i8* %10, align 1
  %33 = sext i8 %32 to i32
  %34 = icmp ne i32 %33, 44
  br i1 %34, label %35, label %36

35:                                               ; preds = %31, %27
  store i32 0, i32* %3, align 4
  br label %103

36:                                               ; preds = %31
  %37 = load i32, i32* %7, align 4
  %38 = icmp sle i32 %37, 0
  br i1 %38, label %48, label %39

39:                                               ; preds = %36
  %40 = load i32, i32* %7, align 4
  %41 = icmp sgt i32 %40, 4
  br i1 %41, label %48, label %42

42:                                               ; preds = %39
  %43 = load i32, i32* %8, align 4
  %44 = icmp sle i32 %43, 0
  br i1 %44, label %48, label %45

45:                                               ; preds = %42
  %46 = load i32, i32* %8, align 4
  %47 = icmp sgt i32 %46, 4
  br i1 %47, label %48, label %51

48:                                               ; preds = %45, %42, %39, %36
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %50 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.12.119, i64 0, i64 0))
  store i32 0, i32* %3, align 4
  br label %103

51:                                               ; preds = %45
  %52 = load i32, i32* %7, align 4
  %53 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %54 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %53, i32 0, i32 14
  %55 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %54, align 8
  %56 = load i32, i32* %6, align 4
  %57 = sext i32 %56 to i64
  %58 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %55, i64 %57
  %59 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %58, i32 0, i32 2
  store i32 %52, i32* %59, align 8
  %60 = load i32, i32* %8, align 4
  %61 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %62 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %61, i32 0, i32 14
  %63 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %62, align 8
  %64 = load i32, i32* %6, align 4
  %65 = sext i32 %64 to i64
  %66 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %63, i64 %65
  %67 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %66, i32 0, i32 3
  store i32 %60, i32* %67, align 4
  br label %68

68:                                               ; preds = %81, %51
  %69 = load i8*, i8** %5, align 8
  %70 = load i8, i8* %69, align 1
  %71 = sext i8 %70 to i32
  %72 = icmp ne i32 %71, 0
  br i1 %72, label %73, label %79

73:                                               ; preds = %68
  %74 = load i8*, i8** %5, align 8
  %75 = getelementptr inbounds i8, i8* %74, i32 1
  store i8* %75, i8** %5, align 8
  %76 = load i8, i8* %74, align 1
  %77 = sext i8 %76 to i32
  %78 = icmp ne i32 %77, 44
  br label %79

79:                                               ; preds = %73, %68
  %80 = phi i1 [ false, %68 ], [ %78, %73 ]
  br i1 %80, label %81, label %82

81:                                               ; preds = %79
  br label %68, !llvm.loop !10

82:                                               ; preds = %79
  br label %98

83:                                               ; preds = %14
  %84 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %85 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %84, i32 0, i32 14
  %86 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %85, align 8
  %87 = load i32, i32* %6, align 4
  %88 = sext i32 %87 to i64
  %89 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %86, i64 %88
  %90 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %89, i32 0, i32 2
  store i32 1, i32* %90, align 8
  %91 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %92 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %91, i32 0, i32 14
  %93 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %92, align 8
  %94 = load i32, i32* %6, align 4
  %95 = sext i32 %94 to i64
  %96 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %93, i64 %95
  %97 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %96, i32 0, i32 3
  store i32 1, i32* %97, align 4
  br label %98

98:                                               ; preds = %83, %82
  br label %99

99:                                               ; preds = %98
  %100 = load i32, i32* %6, align 4
  %101 = add nsw i32 %100, 1
  store i32 %101, i32* %6, align 4
  br label %11, !llvm.loop !11

102:                                              ; preds = %11
  store i32 1, i32* %3, align 4
  br label %103

103:                                              ; preds = %102, %48, %35, %22
  %104 = load i32, i32* %3, align 4
  ret i32 %104
}

attributes #0 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5, !6}

!0 = !{!"clang version 13.0.0 (https://github.com/llvm/llvm-project/ 24c8eaec9467b2aaf70b0db33a4e4dd415139a50)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{i32 1, !"ThinLTO", i32 0}
!6 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = distinct !{!11, !8}
