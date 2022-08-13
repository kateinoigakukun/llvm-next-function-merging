; AUTOMATICALLY GENERATED BY tools/llvm-nextfm-remark/compare-mergesize.rb
;
; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=build_ycc_rgb_table.43 --multiple-func-merging-only=build_ycc_rgb_table -o %t.mfm.ll %s
; RUN: %opt -S --passes="func-merging" --func-merging-only=build_ycc_rgb_table.43 --func-merging-only=build_ycc_rgb_table -o %t.fm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.fm.ll -o %t.fm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.fm.o
; RUN: [[ $(stat -c%%s %t.mfm.o) -le $(stat -c%%s %t.fm.o) ]]

; ModuleID = '../benchmarks/mibench/consumer/jpeg/cjpeg.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.jpeg_decompress_struct.424 = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_source_mgr.409*, i32, i32, i32, i32, i32, i32, i32, double, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8**, i32, i32, i32, i32, i32, [64 x i32]*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], i32, %struct.jpeg_component_info*, i32, i32, [16 x i8], [16 x i8], [16 x i8], i32, i32, i8, i16, i16, i32, i8, i32, i32, i32, i32, i32, i8*, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, i32, %struct.jpeg_decomp_master.413*, %struct.jpeg_d_main_controller.414*, %struct.jpeg_d_coef_controller.415*, %struct.jpeg_d_post_controller.416*, %struct.jpeg_input_controller.417*, %struct.jpeg_marker_reader.418*, %struct.jpeg_entropy_decoder.419*, %struct.jpeg_inverse_dct.420*, %struct.jpeg_upsampler.421*, %struct.jpeg_color_deconverter.422*, %struct.jpeg_color_quantizer.423* }
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
%struct.jpeg_source_mgr.409 = type { i8*, i64, {}*, i32 (%struct.jpeg_decompress_struct.424*)*, void (%struct.jpeg_decompress_struct.424*, i64)*, i32 (%struct.jpeg_decompress_struct.424*, i32)*, {}* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.jpeg_decomp_master.413 = type { {}*, {}*, i32 }
%struct.jpeg_d_main_controller.414 = type { void (%struct.jpeg_decompress_struct.424*, i32)*, void (%struct.jpeg_decompress_struct.424*, i8**, i32*, i32)* }
%struct.jpeg_d_coef_controller.415 = type { {}*, i32 (%struct.jpeg_decompress_struct.424*)*, {}*, i32 (%struct.jpeg_decompress_struct.424*, i8***)*, %struct.jvirt_barray_control** }
%struct.jpeg_d_post_controller.416 = type { void (%struct.jpeg_decompress_struct.424*, i32)*, void (%struct.jpeg_decompress_struct.424*, i8***, i32*, i32, i8**, i32*, i32)* }
%struct.jpeg_input_controller.417 = type { i32 (%struct.jpeg_decompress_struct.424*)*, {}*, {}*, {}*, i32, i32 }
%struct.jpeg_marker_reader.418 = type { {}*, i32 (%struct.jpeg_decompress_struct.424*)*, i32 (%struct.jpeg_decompress_struct.424*)*, i32 (%struct.jpeg_decompress_struct.424*)*, [16 x i32 (%struct.jpeg_decompress_struct.424*)*], i32, i32, i32, i32 }
%struct.jpeg_entropy_decoder.419 = type { {}*, i32 (%struct.jpeg_decompress_struct.424*, [64 x i16]**)* }
%struct.jpeg_inverse_dct.420 = type { {}*, [10 x void (%struct.jpeg_decompress_struct.424*, %struct.jpeg_component_info*, i16*, i8**, i32)*] }
%struct.jpeg_upsampler.421 = type { {}*, void (%struct.jpeg_decompress_struct.424*, i8***, i32*, i32, i8**, i32*, i32)*, i32 }
%struct.jpeg_color_deconverter.422 = type { {}*, void (%struct.jpeg_decompress_struct.424*, i8***, i32, i8**, i32)* }
%struct.jpeg_color_quantizer.423 = type { void (%struct.jpeg_decompress_struct.424*, i32)*, void (%struct.jpeg_decompress_struct.424*, i8**, i8**, i32)*, {}*, {}* }
%struct.my_color_deconverter = type { %struct.jpeg_color_deconverter.422, i32*, i32*, i64*, i64* }
%struct.my_upsampler = type { %struct.jpeg_upsampler.421, void (%struct.jpeg_decompress_struct.424*, i8***, i32, i8**)*, i32*, i32*, i64*, i64*, i8*, i32, i32, i32 }

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @build_ycc_rgb_table(%struct.jpeg_decompress_struct.424* %0) #0 {
  %2 = alloca %struct.jpeg_decompress_struct.424*, align 8
  %3 = alloca %struct.my_color_deconverter*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  store %struct.jpeg_decompress_struct.424* %0, %struct.jpeg_decompress_struct.424** %2, align 8
  %6 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %7 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %6, i32 0, i32 82
  %8 = load %struct.jpeg_color_deconverter.422*, %struct.jpeg_color_deconverter.422** %7, align 8
  %9 = bitcast %struct.jpeg_color_deconverter.422* %8 to %struct.my_color_deconverter*
  store %struct.my_color_deconverter* %9, %struct.my_color_deconverter** %3, align 8
  %10 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %11 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %10, i32 0, i32 1
  %12 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %11, align 8
  %13 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %12, i32 0, i32 0
  %14 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %13, align 8
  %15 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %16 = bitcast %struct.jpeg_decompress_struct.424* %15 to %struct.jpeg_common_struct*
  %17 = call i8* %14(%struct.jpeg_common_struct* %16, i32 1, i64 1024)
  %18 = bitcast i8* %17 to i32*
  %19 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %20 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %19, i32 0, i32 1
  store i32* %18, i32** %20, align 8
  %21 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %22 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %21, i32 0, i32 1
  %23 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %22, align 8
  %24 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %23, i32 0, i32 0
  %25 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %24, align 8
  %26 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %27 = bitcast %struct.jpeg_decompress_struct.424* %26 to %struct.jpeg_common_struct*
  %28 = call i8* %25(%struct.jpeg_common_struct* %27, i32 1, i64 1024)
  %29 = bitcast i8* %28 to i32*
  %30 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %31 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %30, i32 0, i32 2
  store i32* %29, i32** %31, align 8
  %32 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %33 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %32, i32 0, i32 1
  %34 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %33, align 8
  %35 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %34, i32 0, i32 0
  %36 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %35, align 8
  %37 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %38 = bitcast %struct.jpeg_decompress_struct.424* %37 to %struct.jpeg_common_struct*
  %39 = call i8* %36(%struct.jpeg_common_struct* %38, i32 1, i64 2048)
  %40 = bitcast i8* %39 to i64*
  %41 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %42 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %41, i32 0, i32 3
  store i64* %40, i64** %42, align 8
  %43 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %44 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %43, i32 0, i32 1
  %45 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %44, align 8
  %46 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %45, i32 0, i32 0
  %47 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %46, align 8
  %48 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %49 = bitcast %struct.jpeg_decompress_struct.424* %48 to %struct.jpeg_common_struct*
  %50 = call i8* %47(%struct.jpeg_common_struct* %49, i32 1, i64 2048)
  %51 = bitcast i8* %50 to i64*
  %52 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %53 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %52, i32 0, i32 4
  store i64* %51, i64** %53, align 8
  store i32 0, i32* %4, align 4
  store i64 -128, i64* %5, align 8
  br label %54

54:                                               ; preds = %97, %1
  %55 = load i32, i32* %4, align 4
  %56 = icmp sle i32 %55, 255
  br i1 %56, label %57, label %102

57:                                               ; preds = %54
  %58 = load i64, i64* %5, align 8
  %59 = mul nsw i64 91881, %58
  %60 = add nsw i64 %59, 32768
  %61 = ashr i64 %60, 16
  %62 = trunc i64 %61 to i32
  %63 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %64 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %63, i32 0, i32 1
  %65 = load i32*, i32** %64, align 8
  %66 = load i32, i32* %4, align 4
  %67 = sext i32 %66 to i64
  %68 = getelementptr inbounds i32, i32* %65, i64 %67
  store i32 %62, i32* %68, align 4
  %69 = load i64, i64* %5, align 8
  %70 = mul nsw i64 116130, %69
  %71 = add nsw i64 %70, 32768
  %72 = ashr i64 %71, 16
  %73 = trunc i64 %72 to i32
  %74 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %75 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %74, i32 0, i32 2
  %76 = load i32*, i32** %75, align 8
  %77 = load i32, i32* %4, align 4
  %78 = sext i32 %77 to i64
  %79 = getelementptr inbounds i32, i32* %76, i64 %78
  store i32 %73, i32* %79, align 4
  %80 = load i64, i64* %5, align 8
  %81 = mul nsw i64 -46802, %80
  %82 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %83 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %82, i32 0, i32 3
  %84 = load i64*, i64** %83, align 8
  %85 = load i32, i32* %4, align 4
  %86 = sext i32 %85 to i64
  %87 = getelementptr inbounds i64, i64* %84, i64 %86
  store i64 %81, i64* %87, align 8
  %88 = load i64, i64* %5, align 8
  %89 = mul nsw i64 -22554, %88
  %90 = add nsw i64 %89, 32768
  %91 = load %struct.my_color_deconverter*, %struct.my_color_deconverter** %3, align 8
  %92 = getelementptr inbounds %struct.my_color_deconverter, %struct.my_color_deconverter* %91, i32 0, i32 4
  %93 = load i64*, i64** %92, align 8
  %94 = load i32, i32* %4, align 4
  %95 = sext i32 %94 to i64
  %96 = getelementptr inbounds i64, i64* %93, i64 %95
  store i64 %90, i64* %96, align 8
  br label %97

97:                                               ; preds = %57
  %98 = load i32, i32* %4, align 4
  %99 = add nsw i32 %98, 1
  store i32 %99, i32* %4, align 4
  %100 = load i64, i64* %5, align 8
  %101 = add nsw i64 %100, 1
  store i64 %101, i64* %5, align 8
  br label %54, !llvm.loop !7

102:                                              ; preds = %54
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @build_ycc_rgb_table.43(%struct.jpeg_decompress_struct.424* %0) #0 {
  %2 = alloca %struct.jpeg_decompress_struct.424*, align 8
  %3 = alloca %struct.my_upsampler*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  store %struct.jpeg_decompress_struct.424* %0, %struct.jpeg_decompress_struct.424** %2, align 8
  %6 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %7 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %6, i32 0, i32 81
  %8 = load %struct.jpeg_upsampler.421*, %struct.jpeg_upsampler.421** %7, align 8
  %9 = bitcast %struct.jpeg_upsampler.421* %8 to %struct.my_upsampler*
  store %struct.my_upsampler* %9, %struct.my_upsampler** %3, align 8
  %10 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %11 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %10, i32 0, i32 1
  %12 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %11, align 8
  %13 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %12, i32 0, i32 0
  %14 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %13, align 8
  %15 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %16 = bitcast %struct.jpeg_decompress_struct.424* %15 to %struct.jpeg_common_struct*
  %17 = call i8* %14(%struct.jpeg_common_struct* %16, i32 1, i64 1024)
  %18 = bitcast i8* %17 to i32*
  %19 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %20 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %19, i32 0, i32 2
  store i32* %18, i32** %20, align 8
  %21 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %22 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %21, i32 0, i32 1
  %23 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %22, align 8
  %24 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %23, i32 0, i32 0
  %25 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %24, align 8
  %26 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %27 = bitcast %struct.jpeg_decompress_struct.424* %26 to %struct.jpeg_common_struct*
  %28 = call i8* %25(%struct.jpeg_common_struct* %27, i32 1, i64 1024)
  %29 = bitcast i8* %28 to i32*
  %30 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %31 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %30, i32 0, i32 3
  store i32* %29, i32** %31, align 8
  %32 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %33 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %32, i32 0, i32 1
  %34 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %33, align 8
  %35 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %34, i32 0, i32 0
  %36 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %35, align 8
  %37 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %38 = bitcast %struct.jpeg_decompress_struct.424* %37 to %struct.jpeg_common_struct*
  %39 = call i8* %36(%struct.jpeg_common_struct* %38, i32 1, i64 2048)
  %40 = bitcast i8* %39 to i64*
  %41 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %42 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %41, i32 0, i32 4
  store i64* %40, i64** %42, align 8
  %43 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %44 = getelementptr inbounds %struct.jpeg_decompress_struct.424, %struct.jpeg_decompress_struct.424* %43, i32 0, i32 1
  %45 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %44, align 8
  %46 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %45, i32 0, i32 0
  %47 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %46, align 8
  %48 = load %struct.jpeg_decompress_struct.424*, %struct.jpeg_decompress_struct.424** %2, align 8
  %49 = bitcast %struct.jpeg_decompress_struct.424* %48 to %struct.jpeg_common_struct*
  %50 = call i8* %47(%struct.jpeg_common_struct* %49, i32 1, i64 2048)
  %51 = bitcast i8* %50 to i64*
  %52 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %53 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %52, i32 0, i32 5
  store i64* %51, i64** %53, align 8
  store i32 0, i32* %4, align 4
  store i64 -128, i64* %5, align 8
  br label %54

54:                                               ; preds = %97, %1
  %55 = load i32, i32* %4, align 4
  %56 = icmp sle i32 %55, 255
  br i1 %56, label %57, label %102

57:                                               ; preds = %54
  %58 = load i64, i64* %5, align 8
  %59 = mul nsw i64 91881, %58
  %60 = add nsw i64 %59, 32768
  %61 = ashr i64 %60, 16
  %62 = trunc i64 %61 to i32
  %63 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %64 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %63, i32 0, i32 2
  %65 = load i32*, i32** %64, align 8
  %66 = load i32, i32* %4, align 4
  %67 = sext i32 %66 to i64
  %68 = getelementptr inbounds i32, i32* %65, i64 %67
  store i32 %62, i32* %68, align 4
  %69 = load i64, i64* %5, align 8
  %70 = mul nsw i64 116130, %69
  %71 = add nsw i64 %70, 32768
  %72 = ashr i64 %71, 16
  %73 = trunc i64 %72 to i32
  %74 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %75 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %74, i32 0, i32 3
  %76 = load i32*, i32** %75, align 8
  %77 = load i32, i32* %4, align 4
  %78 = sext i32 %77 to i64
  %79 = getelementptr inbounds i32, i32* %76, i64 %78
  store i32 %73, i32* %79, align 4
  %80 = load i64, i64* %5, align 8
  %81 = mul nsw i64 -46802, %80
  %82 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %83 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %82, i32 0, i32 4
  %84 = load i64*, i64** %83, align 8
  %85 = load i32, i32* %4, align 4
  %86 = sext i32 %85 to i64
  %87 = getelementptr inbounds i64, i64* %84, i64 %86
  store i64 %81, i64* %87, align 8
  %88 = load i64, i64* %5, align 8
  %89 = mul nsw i64 -22554, %88
  %90 = add nsw i64 %89, 32768
  %91 = load %struct.my_upsampler*, %struct.my_upsampler** %3, align 8
  %92 = getelementptr inbounds %struct.my_upsampler, %struct.my_upsampler* %91, i32 0, i32 5
  %93 = load i64*, i64** %92, align 8
  %94 = load i32, i32* %4, align 4
  %95 = sext i32 %94 to i64
  %96 = getelementptr inbounds i64, i64* %93, i64 %95
  store i64 %90, i64* %96, align 8
  br label %97

97:                                               ; preds = %57
  %98 = load i32, i32* %4, align 4
  %99 = add nsw i32 %98, 1
  store i32 %99, i32* %4, align 4
  %100 = load i64, i64* %5, align 8
  %101 = add nsw i64 %100, 1
  store i64 %101, i64* %5, align 8
  br label %54, !llvm.loop !9

102:                                              ; preds = %54
  ret void
}

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