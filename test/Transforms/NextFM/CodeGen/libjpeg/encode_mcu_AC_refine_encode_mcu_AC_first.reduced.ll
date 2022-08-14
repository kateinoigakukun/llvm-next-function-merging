; RUN: %opt --passes='multiple-func-merging' '--multiple-func-merging-only=encode_mcu_AC_refine' '--multiple-func-merging-only=encode_mcu_AC_first' %s -o %t.opt.two.bc
; RUN: %clang %t.opt.two.bc %S/Inputs/encode_mcu_AC_refine_encode_mcu_AC_first.driver.bc -lm -o %t.opt.two
; RUN: %opt --passes='func-merging' '--func-merging-only=encode_mcu_AC_refine' '--func-merging-only=encode_mcu_AC_first' %s -o %t.opt.fm.bc
; RUN: %clang %t.opt.fm.bc %S/Inputs/encode_mcu_AC_refine_encode_mcu_AC_first.driver.bc -lm -o %t.opt.fm
; RUN: %clang %s %S/Inputs/encode_mcu_AC_refine_encode_mcu_AC_first.driver.bc -lm -o %t.safe
; RUN: %t.safe '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; RUN: %t.opt.fm '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; RUN: %t.opt.two '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-size-benchmark-suite/bazel-bin/benchmarks/mibench/consumer/jpeg/cjpeg.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.jpeg_compress_struct.65 = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_destination_mgr.51*, i32, i32, i32, i32, double, i32, i32, i32, %struct.jpeg_component_info*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], [16 x i8], [16 x i8], [16 x i8], i32, %struct.jpeg_scan_info*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8, i16, i16, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, %struct.jpeg_comp_master.56*, %struct.jpeg_c_main_controller.57*, %struct.jpeg_c_prep_controller.58*, %struct.jpeg_c_coef_controller.59*, %struct.jpeg_marker_writer.60*, %struct.jpeg_color_converter.61*, %struct.jpeg_downsampler.62*, %struct.jpeg_forward_dct.63*, %struct.jpeg_entropy_encoder.64* }
%struct.jpeg_error_mgr = type { void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i32)*, void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i8*)*, void (%struct.jpeg_common_struct*)*, i32, %union.anon, i32, i64, i8**, i32, i8**, i32, i32 }
%struct.jpeg_common_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32 }
%union.anon = type { [8 x i32], [48 x i8] }
%struct.jpeg_memory_mgr = type { i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)*, i8** (%struct.jpeg_common_struct*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, i32, i32, i32)*, %struct.jvirt_sarray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, %struct.jvirt_barray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, {}*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, %struct.jvirt_barray_control*, i32, i32, i32)*, void (%struct.jpeg_common_struct*, i32)*, {}*, i64 }
%struct.jvirt_sarray_control = type { i8**, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.jvirt_sarray_control*, %struct.backing_store_struct }
%struct.backing_store_struct = type { void (%struct.jpeg_common_struct.775*, %struct.backing_store_struct*, i8*, i64, i64)*, void (%struct.jpeg_common_struct.775*, %struct.backing_store_struct*, i8*, i64, i64)*, void (%struct.jpeg_common_struct.775*, %struct.backing_store_struct*)*, %struct._IO_FILE*, [64 x i8] }
%struct.jpeg_common_struct.775 = type { %struct.jpeg_error_mgr.766*, %struct.jpeg_memory_mgr.773*, %struct.jpeg_progress_mgr*, i32, i32 }
%struct.jpeg_error_mgr.766 = type { {}*, void (%struct.jpeg_common_struct.775*, i32)*, {}*, void (%struct.jpeg_common_struct.775*, i8*)*, {}*, i32, %union.anon, i32, i64, i8**, i32, i8**, i32, i32 }
%struct.jpeg_memory_mgr.773 = type { i8* (%struct.jpeg_common_struct.775*, i32, i64)*, i8* (%struct.jpeg_common_struct.775*, i32, i64)*, i8** (%struct.jpeg_common_struct.775*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct.775*, i32, i32, i32)*, %struct.jvirt_sarray_control* (%struct.jpeg_common_struct.775*, i32, i32, i32, i32, i32)*, %struct.jvirt_barray_control* (%struct.jpeg_common_struct.775*, i32, i32, i32, i32, i32)*, {}*, i8** (%struct.jpeg_common_struct.775*, %struct.jvirt_sarray_control*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct.775*, %struct.jvirt_barray_control*, i32, i32, i32)*, void (%struct.jpeg_common_struct.775*, i32)*, {}*, i64 }
%struct.jvirt_barray_control = type { [64 x i16]**, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.jvirt_barray_control*, %struct.backing_store_struct }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.jpeg_progress_mgr = type { {}*, i64, i64, i32, i32 }
%struct.jpeg_destination_mgr.51 = type { i8*, i64, {}*, i32 (%struct.jpeg_compress_struct.65*)*, {}* }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_scan_info = type { i32, [4 x i32], i32, i32, i32, i32 }
%struct.jpeg_comp_master.56 = type { {}*, {}*, {}*, i32, i32 }
%struct.jpeg_c_main_controller.57 = type { void (%struct.jpeg_compress_struct.65*, i32)*, void (%struct.jpeg_compress_struct.65*, i8**, i32*, i32)* }
%struct.jpeg_c_prep_controller.58 = type { void (%struct.jpeg_compress_struct.65*, i32)*, void (%struct.jpeg_compress_struct.65*, i8**, i32*, i32, i8***, i32*, i32)* }
%struct.jpeg_c_coef_controller.59 = type { void (%struct.jpeg_compress_struct.65*, i32)*, i32 (%struct.jpeg_compress_struct.65*, i8***)* }
%struct.jpeg_marker_writer.60 = type { void (%struct.jpeg_compress_struct.65*, i32, i8*, i32)*, {}*, {}*, {}*, {}*, {}* }
%struct.jpeg_color_converter.61 = type { {}*, void (%struct.jpeg_compress_struct.65*, i8**, i8***, i32, i32)* }
%struct.jpeg_downsampler.62 = type { {}*, void (%struct.jpeg_compress_struct.65*, i8***, i32, i8***, i32)*, i32 }
%struct.jpeg_forward_dct.63 = type { {}*, void (%struct.jpeg_compress_struct.65*, %struct.jpeg_component_info*, i8**, [64 x i16]*, i32, i32, i32)* }
%struct.jpeg_entropy_encoder.64 = type { void (%struct.jpeg_compress_struct.65*, i32)*, i32 (%struct.jpeg_compress_struct.65*, [64 x i16]**)*, {}* }
%struct.phuff_entropy_encoder = type { %struct.jpeg_entropy_encoder.64, i32, i8*, i64, i64, i32, %struct.jpeg_compress_struct.65*, [4 x i32], i32, i32, i32, i8*, i32, i32, [4 x %struct.c_derived_tbl*], [4 x i64*] }
%struct.c_derived_tbl = type { [256 x i32], [256 x i8] }

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden i32 @encode_mcu_AC_first(%struct.jpeg_compress_struct.65* %0, [64 x i16]** %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct.65*, align 8
  %4 = alloca [64 x i16]**, align 8
  %5 = alloca %struct.phuff_entropy_encoder*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store %struct.jpeg_compress_struct.65* %0, %struct.jpeg_compress_struct.65** %3, align 8
  store [64 x i16]** %1, [64 x i16]*** %4, align 8
  %13 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %14 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %13, i32 0, i32 59
  %15 = load %struct.jpeg_entropy_encoder.64*, %struct.jpeg_entropy_encoder.64** %14, align 8
  %16 = bitcast %struct.jpeg_entropy_encoder.64* %15 to %struct.phuff_entropy_encoder*
  store %struct.phuff_entropy_encoder* %16, %struct.phuff_entropy_encoder** %5, align 8
  %17 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %18 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %17, i32 0, i32 48
  %19 = load i32, i32* %18, align 8
  store i32 %19, i32* %11, align 4
  %20 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %21 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %20, i32 0, i32 50
  %22 = load i32, i32* %21, align 8
  store i32 %22, i32* %12, align 4
  store i32 0, i32* %9, align 4
  %23 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %24 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %23, i32 0, i32 47
  %25 = load i32, i32* %24, align 4
  store i32 %25, i32* %10, align 4
  br label %26

26:                                               ; preds = %55, %2
  %27 = load i32, i32* %10, align 4
  %28 = load i32, i32* %11, align 4
  %29 = icmp sle i32 %27, %28
  br i1 %29, label %30, label %58

30:                                               ; preds = %26
  %31 = load i32, i32* %6, align 4
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %33, label %39

33:                                               ; preds = %30
  %34 = load i32, i32* %6, align 4
  %35 = sub nsw i32 0, %34
  store i32 %35, i32* %6, align 4
  %36 = load i32, i32* %12, align 4
  %37 = load i32, i32* %6, align 4
  %38 = ashr i32 %37, %36
  store i32 %38, i32* %6, align 4
  br label %40

39:                                               ; preds = %30
  br label %40

40:                                               ; preds = %39, %33
  %41 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %42 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %41, i32 0, i32 9
  %43 = load i32, i32* %42, align 4
  %44 = icmp ne i32 %43, 0
  br i1 %44, label %45, label %47

45:                                               ; preds = %40
  %46 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  call void @emit_eobrun(%struct.phuff_entropy_encoder* %46)
  br label %47

47:                                               ; preds = %45, %40
  br label %48

48:                                               ; preds = %51, %47
  %49 = load i32, i32* %9, align 4
  %50 = icmp sgt i32 %49, 15
  br i1 %50, label %51, label %54

51:                                               ; preds = %48
  %52 = load i32, i32* %9, align 4
  %53 = sub nsw i32 %52, 16
  store i32 %53, i32* %9, align 4
  br label %48, !llvm.loop !7

54:                                               ; preds = %48
  br label %55

55:                                               ; preds = %54
  %56 = load i32, i32* %10, align 4
  %57 = add nsw i32 %56, 1
  store i32 %57, i32* %10, align 4
  br label %26, !llvm.loop !9

58:                                               ; preds = %26
  ret i32 1
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden i32 @encode_mcu_AC_refine(%struct.jpeg_compress_struct.65* %0, [64 x i16]** %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct.65*, align 8
  %4 = alloca [64 x i16]**, align 8
  %5 = alloca %struct.phuff_entropy_encoder*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i8*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca [64 x i16]*, align 8
  %15 = alloca [64 x i32], align 16
  store %struct.jpeg_compress_struct.65* %0, %struct.jpeg_compress_struct.65** %3, align 8
  store [64 x i16]** %1, [64 x i16]*** %4, align 8
  %16 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %17 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %16, i32 0, i32 59
  %18 = load %struct.jpeg_entropy_encoder.64*, %struct.jpeg_entropy_encoder.64** %17, align 8
  %19 = bitcast %struct.jpeg_entropy_encoder.64* %18 to %struct.phuff_entropy_encoder*
  store %struct.phuff_entropy_encoder* %19, %struct.phuff_entropy_encoder** %5, align 8
  %20 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %21 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %20, i32 0, i32 48
  %22 = load i32, i32* %21, align 8
  store i32 %22, i32* %12, align 4
  %23 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %24 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %23, i32 0, i32 50
  %25 = load i32, i32* %24, align 8
  store i32 %25, i32* %13, align 4
  %26 = load [64 x i16]**, [64 x i16]*** %4, align 8
  %27 = getelementptr inbounds [64 x i16]*, [64 x i16]** %26, i64 0
  %28 = load [64 x i16]*, [64 x i16]** %27, align 8
  store [64 x i16]* %28, [64 x i16]** %14, align 8
  store i32 0, i32* %9, align 4
  %29 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %30 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %29, i32 0, i32 47
  %31 = load i32, i32* %30, align 4
  store i32 %31, i32* %8, align 4
  br label %32

32:                                               ; preds = %52, %2
  %33 = load i32, i32* %8, align 4
  %34 = load i32, i32* %12, align 4
  %35 = icmp sle i32 %33, %34
  br i1 %35, label %36, label %55

36:                                               ; preds = %32
  %37 = load i32, i32* %6, align 4
  %38 = icmp ne i32 %37, 0
  br i1 %38, label %39, label %42

39:                                               ; preds = %36
  %40 = load i32, i32* %6, align 4
  %41 = sub nsw i32 0, %40
  store i32 %41, i32* %6, align 4
  br label %42

42:                                               ; preds = %39, %36
  %43 = load i32, i32* %6, align 4
  %44 = load i32, i32* %8, align 4
  %45 = sext i32 %44 to i64
  %46 = getelementptr inbounds [64 x i32], [64 x i32]* %15, i64 0, i64 %45
  store i32 %43, i32* %46, align 4
  %47 = load i32, i32* %6, align 4
  %48 = icmp ne i32 %47, 0
  br i1 %48, label %49, label %51

49:                                               ; preds = %42
  %50 = load i32, i32* %8, align 4
  store i32 %50, i32* %9, align 4
  br label %51

51:                                               ; preds = %49, %42
  br label %52

52:                                               ; preds = %51
  %53 = load i32, i32* %8, align 4
  %54 = add nsw i32 %53, 1
  store i32 %54, i32* %8, align 4
  br label %32, !llvm.loop !10

55:                                               ; preds = %32
  store i32 0, i32* %7, align 4
  %56 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %57 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %56, i32 0, i32 47
  %58 = load i32, i32* %57, align 4
  store i32 %58, i32* %8, align 4
  br label %59

59:                                               ; preds = %88, %55
  %60 = load i32, i32* %8, align 4
  %61 = load i32, i32* %12, align 4
  %62 = icmp sle i32 %60, %61
  br i1 %62, label %63, label %91

63:                                               ; preds = %59
  br label %64

64:                                               ; preds = %73, %63
  %65 = load i32, i32* %7, align 4
  %66 = icmp sgt i32 %65, 15
  br i1 %66, label %67, label %71

67:                                               ; preds = %64
  %68 = load i32, i32* %8, align 4
  %69 = load i32, i32* %9, align 4
  %70 = icmp sle i32 %68, %69
  br label %71

71:                                               ; preds = %67, %64
  %72 = phi i1 [ false, %64 ], [ %70, %67 ]
  br i1 %72, label %73, label %76

73:                                               ; preds = %71
  %74 = load i32, i32* %7, align 4
  %75 = sub nsw i32 %74, 16
  store i32 %75, i32* %7, align 4
  br label %64, !llvm.loop !11

76:                                               ; preds = %71
  %77 = load i32, i32* %6, align 4
  %78 = icmp sgt i32 %77, 1
  br i1 %78, label %79, label %80

79:                                               ; preds = %76
  br label %88

80:                                               ; preds = %76
  %81 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %82 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %83 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %82, i32 0, i32 8
  %84 = load i32, i32* %83, align 8
  %85 = load i32, i32* %7, align 4
  %86 = shl i32 %85, 4
  %87 = add nsw i32 %86, 1
  call void @emit_symbol(%struct.phuff_entropy_encoder* %81, i32 %84, i32 %87)
  store i32 0, i32* %7, align 4
  br label %88

88:                                               ; preds = %80, %79
  %89 = load i32, i32* %8, align 4
  %90 = add nsw i32 %89, 1
  store i32 %90, i32* %8, align 4
  br label %59, !llvm.loop !12

91:                                               ; preds = %59
  ret i32 1
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_eobrun(%struct.phuff_entropy_encoder*) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_symbol(%struct.phuff_entropy_encoder*, i32, i32) #0

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
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
!12 = distinct !{!12, !8}
