; Generated from multiple-func-merging:UnprofitableMerge
; - compress_term
; - output

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK-NOT: --- !Missed
; XFAIL: *

; ModuleID = '../bench-play/libjpeg.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.gif_dest_struct = type { %struct.djpeg_dest_struct, %struct.jpeg_decompress_struct*, i32, i16, i32, i64, i32, i16, i32, i16, i16, i16, i16*, i64*, i32, [256 x i8] }
%struct.djpeg_dest_struct = type { void (%struct.jpeg_decompress_struct*, %struct.djpeg_dest_struct*)*, void (%struct.jpeg_decompress_struct*, %struct.djpeg_dest_struct*, i32)*, void (%struct.jpeg_decompress_struct*, %struct.djpeg_dest_struct*)*, %struct._IO_FILE*, i8**, i32 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.jpeg_decompress_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_source_mgr*, i32, i32, i32, i32, i32, i32, i32, double, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8**, i32, i32, i32, i32, i32, [64 x i32]*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], i32, %struct.jpeg_component_info*, i32, i32, [16 x i8], [16 x i8], [16 x i8], i32, i32, i8, i16, i16, i32, i8, i32, i32, i32, i32, i32, i8*, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, i32, %struct.jpeg_decomp_master*, %struct.jpeg_d_main_controller*, %struct.jpeg_d_coef_controller*, %struct.jpeg_d_post_controller*, %struct.jpeg_input_controller*, %struct.jpeg_marker_reader*, %struct.jpeg_entropy_decoder*, %struct.jpeg_inverse_dct*, %struct.jpeg_upsampler*, %struct.jpeg_color_deconverter*, %struct.jpeg_color_quantizer* }
%struct.jpeg_error_mgr = type { void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i32)*, void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i8*)*, void (%struct.jpeg_common_struct*)*, i32, %union.anon, i32, i64, i8**, i32, i8**, i32, i32 }
%struct.jpeg_common_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32 }
%union.anon = type { [8 x i32], [48 x i8] }
%struct.jpeg_memory_mgr = type { i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)*, i8** (%struct.jpeg_common_struct*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, i32, i32, i32)*, %struct.jvirt_sarray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, %struct.jvirt_barray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, {}*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, %struct.jvirt_barray_control*, i32, i32, i32)*, void (%struct.jpeg_common_struct*, i32)*, {}*, i64 }
%struct.jvirt_sarray_control = type opaque
%struct.jvirt_barray_control = type opaque
%struct.jpeg_progress_mgr = type { {}*, i64, i64, i32, i32 }
%struct.jpeg_source_mgr = type { i8*, i64, void (%struct.jpeg_decompress_struct*)*, i32 (%struct.jpeg_decompress_struct*)*, void (%struct.jpeg_decompress_struct*, i64)*, i32 (%struct.jpeg_decompress_struct*, i32)*, void (%struct.jpeg_decompress_struct*)* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.jpeg_decomp_master = type opaque
%struct.jpeg_d_main_controller = type opaque
%struct.jpeg_d_coef_controller = type opaque
%struct.jpeg_d_post_controller = type opaque
%struct.jpeg_input_controller = type opaque
%struct.jpeg_marker_reader = type opaque
%struct.jpeg_entropy_decoder = type opaque
%struct.jpeg_inverse_dct = type opaque
%struct.jpeg_upsampler = type opaque
%struct.jpeg_color_deconverter = type opaque
%struct.jpeg_color_quantizer = type opaque

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @compress_term(%struct.gif_dest_struct* %0) #0 {
  %2 = alloca %struct.gif_dest_struct*, align 8
  store %struct.gif_dest_struct* %0, %struct.gif_dest_struct** %2, align 8
  %3 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %4 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %3, i32 0, i32 8
  %5 = load i32, i32* %4, align 8
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %12, label %7

7:                                                ; preds = %1
  %8 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %9 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %10 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %9, i32 0, i32 7
  %11 = load i16, i16* %10, align 4
  call void @output(%struct.gif_dest_struct* %8, i16 signext %11)
  br label %12

12:                                               ; preds = %7, %1
  %13 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %14 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %15 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %14, i32 0, i32 10
  %16 = load i16, i16* %15, align 2
  call void @output(%struct.gif_dest_struct* %13, i16 signext %16)
  %17 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %18 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %17, i32 0, i32 6
  %19 = load i32, i32* %18, align 8
  %20 = icmp sgt i32 %19, 0
  br i1 %20, label %21, label %42

21:                                               ; preds = %12
  %22 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %23 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %22, i32 0, i32 5
  %24 = load i64, i64* %23, align 8
  %25 = and i64 %24, 255
  %26 = trunc i64 %25 to i8
  %27 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %28 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %27, i32 0, i32 15
  %29 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %30 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %29, i32 0, i32 14
  %31 = load i32, i32* %30, align 8
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %30, align 8
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [256 x i8], [256 x i8]* %28, i64 0, i64 %33
  store i8 %26, i8* %34, align 1
  %35 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  %36 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %35, i32 0, i32 14
  %37 = load i32, i32* %36, align 8
  %38 = icmp sge i32 %37, 255
  br i1 %38, label %39, label %41

39:                                               ; preds = %21
  %40 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  call void @flush_packet(%struct.gif_dest_struct* %40)
  br label %41

41:                                               ; preds = %39, %21
  br label %42

42:                                               ; preds = %41, %12
  %43 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %2, align 8
  call void @flush_packet(%struct.gif_dest_struct* %43)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @output(%struct.gif_dest_struct* %0, i16 signext %1) #0 {
  %3 = alloca %struct.gif_dest_struct*, align 8
  %4 = alloca i16, align 2
  store %struct.gif_dest_struct* %0, %struct.gif_dest_struct** %3, align 8
  store i16 %1, i16* %4, align 2
  %5 = load i16, i16* %4, align 2
  %6 = sext i16 %5 to i64
  %7 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %8 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %7, i32 0, i32 6
  %9 = load i32, i32* %8, align 8
  %10 = zext i32 %9 to i64
  %11 = shl i64 %6, %10
  %12 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %13 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %12, i32 0, i32 5
  %14 = load i64, i64* %13, align 8
  %15 = or i64 %14, %11
  store i64 %15, i64* %13, align 8
  %16 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %17 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %16, i32 0, i32 2
  %18 = load i32, i32* %17, align 8
  %19 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %20 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %19, i32 0, i32 6
  %21 = load i32, i32* %20, align 8
  %22 = add nsw i32 %21, %18
  store i32 %22, i32* %20, align 8
  br label %23

23:                                               ; preds = %48, %2
  %24 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %25 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %24, i32 0, i32 6
  %26 = load i32, i32* %25, align 8
  %27 = icmp sge i32 %26, 8
  br i1 %27, label %28, label %57

28:                                               ; preds = %23
  %29 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %30 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %29, i32 0, i32 5
  %31 = load i64, i64* %30, align 8
  %32 = and i64 %31, 255
  %33 = trunc i64 %32 to i8
  %34 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %35 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %34, i32 0, i32 15
  %36 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %37 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %36, i32 0, i32 14
  %38 = load i32, i32* %37, align 8
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %37, align 8
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [256 x i8], [256 x i8]* %35, i64 0, i64 %40
  store i8 %33, i8* %41, align 1
  %42 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %43 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %42, i32 0, i32 14
  %44 = load i32, i32* %43, align 8
  %45 = icmp sge i32 %44, 255
  br i1 %45, label %46, label %48

46:                                               ; preds = %28
  %47 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  call void @flush_packet(%struct.gif_dest_struct* %47)
  br label %48

48:                                               ; preds = %46, %28
  %49 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %50 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %49, i32 0, i32 5
  %51 = load i64, i64* %50, align 8
  %52 = ashr i64 %51, 8
  store i64 %52, i64* %50, align 8
  %53 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %54 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %53, i32 0, i32 6
  %55 = load i32, i32* %54, align 8
  %56 = sub nsw i32 %55, 8
  store i32 %56, i32* %54, align 8
  br label %23, !llvm.loop !7

57:                                               ; preds = %23
  %58 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %59 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %58, i32 0, i32 11
  %60 = load i16, i16* %59, align 8
  %61 = sext i16 %60 to i32
  %62 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %63 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %62, i32 0, i32 3
  %64 = load i16, i16* %63, align 4
  %65 = sext i16 %64 to i32
  %66 = icmp sgt i32 %61, %65
  br i1 %66, label %67, label %89

67:                                               ; preds = %57
  %68 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %69 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %68, i32 0, i32 2
  %70 = load i32, i32* %69, align 8
  %71 = add nsw i32 %70, 1
  store i32 %71, i32* %69, align 8
  %72 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %73 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %72, i32 0, i32 2
  %74 = load i32, i32* %73, align 8
  %75 = icmp eq i32 %74, 12
  br i1 %75, label %76, label %79

76:                                               ; preds = %67
  %77 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %78 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %77, i32 0, i32 3
  store i16 4096, i16* %78, align 4
  br label %88

79:                                               ; preds = %67
  %80 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %81 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %80, i32 0, i32 2
  %82 = load i32, i32* %81, align 8
  %83 = shl i32 1, %82
  %84 = sub nsw i32 %83, 1
  %85 = trunc i32 %84 to i16
  %86 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %87 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %86, i32 0, i32 3
  store i16 %85, i16* %87, align 4
  br label %88

88:                                               ; preds = %79, %76
  br label %89

89:                                               ; preds = %88, %57
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @flush_packet(%struct.gif_dest_struct*) #0

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
