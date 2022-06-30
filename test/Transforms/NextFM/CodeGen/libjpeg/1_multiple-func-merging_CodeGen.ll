; Generated from multiple-func-merging:CodeGen
; - start_output_gif
; - SkipDataBlocks
; - put_3bytes
; - put_pixel_rows.128

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK-NOT: --- !Missed
; XFAIL: *

; ModuleID = '/tmp/tmp.XL3451GutF/libjpeg.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.gif_source_struct = type { %struct.cjpeg_source_struct, %struct.jpeg_compress_struct*, i8**, [260 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16*, i8*, i8*, i8*, i32, %struct.jvirt_sarray_control*, i32, i32, i32, i32 }
%struct.cjpeg_source_struct = type { void (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, void (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, %struct._IO_FILE*, i8**, i32 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.jpeg_compress_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_destination_mgr*, i32, i32, i32, i32, double, i32, i32, i32, %struct.jpeg_component_info*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], [16 x i8], [16 x i8], [16 x i8], i32, %struct.jpeg_scan_info*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8, i16, i16, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, %struct.jpeg_comp_master*, %struct.jpeg_c_main_controller*, %struct.jpeg_c_prep_controller*, %struct.jpeg_c_coef_controller*, %struct.jpeg_marker_writer*, %struct.jpeg_color_converter*, %struct.jpeg_downsampler*, %struct.jpeg_forward_dct*, %struct.jpeg_entropy_encoder* }
%struct.jpeg_error_mgr = type { void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i32)*, void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*, i8*)*, void (%struct.jpeg_common_struct*)*, i32, %union.anon, i32, i64, i8**, i32, i8**, i32, i32 }
%struct.jpeg_common_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32 }
%union.anon = type { [8 x i32], [48 x i8] }
%struct.jpeg_memory_mgr = type { i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)*, i8** (%struct.jpeg_common_struct*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, i32, i32, i32)*, %struct.jvirt_sarray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, %struct.jvirt_barray_control* (%struct.jpeg_common_struct*, i32, i32, i32, i32, i32)*, {}*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, [64 x i16]** (%struct.jpeg_common_struct*, %struct.jvirt_barray_control*, i32, i32, i32)*, void (%struct.jpeg_common_struct*, i32)*, {}*, i64 }
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
%struct.jvirt_sarray_control = type opaque
%struct.jpeg_decompress_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_source_mgr*, i32, i32, i32, i32, i32, i32, i32, double, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8**, i32, i32, i32, i32, i32, [64 x i32]*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], i32, %struct.jpeg_component_info*, i32, i32, [16 x i8], [16 x i8], [16 x i8], i32, i32, i8, i16, i16, i32, i8, i32, i32, i32, i32, i32, i8*, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, i32, %struct.jpeg_decomp_master*, %struct.jpeg_d_main_controller*, %struct.jpeg_d_coef_controller*, %struct.jpeg_d_post_controller*, %struct.jpeg_input_controller*, %struct.jpeg_marker_reader*, %struct.jpeg_entropy_decoder*, %struct.jpeg_inverse_dct*, %struct.jpeg_upsampler*, %struct.jpeg_color_deconverter*, %struct.jpeg_color_quantizer* }
%struct.jpeg_source_mgr = type { i8*, i64, void (%struct.jpeg_decompress_struct*)*, i32 (%struct.jpeg_decompress_struct*)*, void (%struct.jpeg_decompress_struct*, i64)*, i32 (%struct.jpeg_decompress_struct*, i32)*, void (%struct.jpeg_decompress_struct*)* }
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
%struct.djpeg_dest_struct = type { void (%struct.jpeg_decompress_struct*, %struct.djpeg_dest_struct*)*, void (%struct.jpeg_decompress_struct*, %struct.djpeg_dest_struct*, i32)*, void (%struct.jpeg_decompress_struct*, %struct.djpeg_dest_struct*)*, %struct._IO_FILE*, i8**, i32 }
%struct.gif_dest_struct = type { %struct.djpeg_dest_struct, %struct.jpeg_decompress_struct*, i32, i16, i32, i64, i32, i16, i32, i16, i16, i16, i16*, i64*, i32, [256 x i8] }
%struct.ppm_dest_struct = type { %struct.djpeg_dest_struct, i8*, i8*, i64, i32 }

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @SkipDataBlocks(%struct.gif_source_struct* %0) #0 {
  %2 = alloca %struct.gif_source_struct*, align 8
  %3 = alloca [256 x i8], align 16
  store %struct.gif_source_struct* %0, %struct.gif_source_struct** %2, align 8
  br label %4

4:                                                ; preds = %9, %1
  %5 = load %struct.gif_source_struct*, %struct.gif_source_struct** %2, align 8
  %6 = getelementptr inbounds [256 x i8], [256 x i8]* %3, i64 0, i64 0
  %7 = call i32 @GetDataBlock(%struct.gif_source_struct* %5, i8* %6)
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %4
  br label %4, !llvm.loop !7

10:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @GetDataBlock(%struct.gif_source_struct*, i8*) #0

declare i32 @putc(i32, %struct._IO_FILE*) #1

declare i64 @fwrite(i8*, i64, i64, %struct._IO_FILE*) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @start_output_gif(%struct.jpeg_decompress_struct* %0, %struct.djpeg_dest_struct* %1) #0 {
  %3 = alloca %struct.jpeg_decompress_struct*, align 8
  %4 = alloca %struct.djpeg_dest_struct*, align 8
  %5 = alloca %struct.gif_dest_struct*, align 8
  store %struct.jpeg_decompress_struct* %0, %struct.jpeg_decompress_struct** %3, align 8
  store %struct.djpeg_dest_struct* %1, %struct.djpeg_dest_struct** %4, align 8
  %6 = load %struct.djpeg_dest_struct*, %struct.djpeg_dest_struct** %4, align 8
  %7 = bitcast %struct.djpeg_dest_struct* %6 to %struct.gif_dest_struct*
  store %struct.gif_dest_struct* %7, %struct.gif_dest_struct** %5, align 8
  %8 = load %struct.jpeg_decompress_struct*, %struct.jpeg_decompress_struct** %3, align 8
  %9 = getelementptr inbounds %struct.jpeg_decompress_struct, %struct.jpeg_decompress_struct* %8, i32 0, i32 19
  %10 = load i32, i32* %9, align 4
  %11 = icmp ne i32 %10, 0
  br i1 %11, label %12, label %20

12:                                               ; preds = %2
  %13 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %5, align 8
  %14 = load %struct.jpeg_decompress_struct*, %struct.jpeg_decompress_struct** %3, align 8
  %15 = getelementptr inbounds %struct.jpeg_decompress_struct, %struct.jpeg_decompress_struct* %14, i32 0, i32 31
  %16 = load i32, i32* %15, align 4
  %17 = load %struct.jpeg_decompress_struct*, %struct.jpeg_decompress_struct** %3, align 8
  %18 = getelementptr inbounds %struct.jpeg_decompress_struct, %struct.jpeg_decompress_struct* %17, i32 0, i32 32
  %19 = load i8**, i8*** %18, align 8
  call void @emit_header(%struct.gif_dest_struct* %13, i32 %16, i8** %19)
  br label %22

20:                                               ; preds = %2
  %21 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %5, align 8
  call void @emit_header(%struct.gif_dest_struct* %21, i32 256, i8** null)
  br label %22

22:                                               ; preds = %20, %12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_header(%struct.gif_dest_struct*, i32, i8**) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @put_3bytes(%struct.gif_dest_struct* %0, i32 %1) #0 {
  %3 = alloca %struct.gif_dest_struct*, align 8
  %4 = alloca i32, align 4
  store %struct.gif_dest_struct* %0, %struct.gif_dest_struct** %3, align 8
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %4, align 4
  %6 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %7 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %6, i32 0, i32 0
  %8 = getelementptr inbounds %struct.djpeg_dest_struct, %struct.djpeg_dest_struct* %7, i32 0, i32 3
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8
  %10 = call i32 @putc(i32 %5, %struct._IO_FILE* %9)
  %11 = load i32, i32* %4, align 4
  %12 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %13 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.djpeg_dest_struct, %struct.djpeg_dest_struct* %13, i32 0, i32 3
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** %14, align 8
  %16 = call i32 @putc(i32 %11, %struct._IO_FILE* %15)
  %17 = load i32, i32* %4, align 4
  %18 = load %struct.gif_dest_struct*, %struct.gif_dest_struct** %3, align 8
  %19 = getelementptr inbounds %struct.gif_dest_struct, %struct.gif_dest_struct* %18, i32 0, i32 0
  %20 = getelementptr inbounds %struct.djpeg_dest_struct, %struct.djpeg_dest_struct* %19, i32 0, i32 3
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** %20, align 8
  %22 = call i32 @putc(i32 %17, %struct._IO_FILE* %21)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @put_pixel_rows.128(%struct.jpeg_decompress_struct* %0, %struct.djpeg_dest_struct* %1, i32 %2) #0 {
  %4 = alloca %struct.jpeg_decompress_struct*, align 8
  %5 = alloca %struct.djpeg_dest_struct*, align 8
  %6 = alloca i32, align 4
  %7 = alloca %struct.ppm_dest_struct*, align 8
  store %struct.jpeg_decompress_struct* %0, %struct.jpeg_decompress_struct** %4, align 8
  store %struct.djpeg_dest_struct* %1, %struct.djpeg_dest_struct** %5, align 8
  store i32 %2, i32* %6, align 4
  %8 = load %struct.djpeg_dest_struct*, %struct.djpeg_dest_struct** %5, align 8
  %9 = bitcast %struct.djpeg_dest_struct* %8 to %struct.ppm_dest_struct*
  store %struct.ppm_dest_struct* %9, %struct.ppm_dest_struct** %7, align 8
  %10 = load %struct.ppm_dest_struct*, %struct.ppm_dest_struct** %7, align 8
  %11 = getelementptr inbounds %struct.ppm_dest_struct, %struct.ppm_dest_struct* %10, i32 0, i32 1
  %12 = load i8*, i8** %11, align 8
  %13 = load %struct.ppm_dest_struct*, %struct.ppm_dest_struct** %7, align 8
  %14 = getelementptr inbounds %struct.ppm_dest_struct, %struct.ppm_dest_struct* %13, i32 0, i32 3
  %15 = load i64, i64* %14, align 8
  %16 = load %struct.ppm_dest_struct*, %struct.ppm_dest_struct** %7, align 8
  %17 = getelementptr inbounds %struct.ppm_dest_struct, %struct.ppm_dest_struct* %16, i32 0, i32 0
  %18 = getelementptr inbounds %struct.djpeg_dest_struct, %struct.djpeg_dest_struct* %17, i32 0, i32 3
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** %18, align 8
  %20 = call i64 @fwrite(i8* %12, i64 1, i64 %15, %struct._IO_FILE* %19)
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
