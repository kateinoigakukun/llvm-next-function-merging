; Generated from multiple-func-merging:UnprofitableMerge
; - get_interlaced_row
; - get_8bit_row

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK-NOT: --- !Missed
; XFAIL: *

; ModuleID = '../bench-play/libjpeg.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

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
%struct.cjpeg_source_struct = type { void (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, void (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, %struct._IO_FILE*, i8**, i32 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct._bmp_source_struct = type { %struct.cjpeg_source_struct, %struct.jpeg_compress_struct*, i8**, %struct.jvirt_sarray_control*, i32, i32, i32 }
%struct.gif_source_struct = type { %struct.cjpeg_source_struct, %struct.jpeg_compress_struct*, i8**, [260 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16*, i8*, i8*, i8*, i32, %struct.jvirt_sarray_control*, i32, i32, i32, i32 }

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden i32 @get_8bit_row(%struct.jpeg_compress_struct* %0, %struct.cjpeg_source_struct* %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct*, align 8
  %4 = alloca %struct.cjpeg_source_struct*, align 8
  %5 = alloca %struct._bmp_source_struct*, align 8
  %6 = alloca i8**, align 8
  %7 = alloca i8**, align 8
  %8 = alloca i32, align 4
  %9 = alloca i8*, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i32, align 4
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %3, align 8
  store %struct.cjpeg_source_struct* %1, %struct.cjpeg_source_struct** %4, align 8
  %12 = load %struct.cjpeg_source_struct*, %struct.cjpeg_source_struct** %4, align 8
  %13 = bitcast %struct.cjpeg_source_struct* %12 to %struct._bmp_source_struct*
  store %struct._bmp_source_struct* %13, %struct._bmp_source_struct** %5, align 8
  %14 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %15 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %14, i32 0, i32 2
  %16 = load i8**, i8*** %15, align 8
  store i8** %16, i8*** %6, align 8
  %17 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %18 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %17, i32 0, i32 4
  %19 = load i32, i32* %18, align 8
  %20 = add i32 %19, -1
  store i32 %20, i32* %18, align 8
  %21 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %22 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %21, i32 0, i32 1
  %23 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %22, align 8
  %24 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %23, i32 0, i32 7
  %25 = load i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)** %24, align 8
  %26 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %27 = bitcast %struct.jpeg_compress_struct* %26 to %struct.jpeg_common_struct*
  %28 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %29 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %28, i32 0, i32 3
  %30 = load %struct.jvirt_sarray_control*, %struct.jvirt_sarray_control** %29, align 8
  %31 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %32 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %31, i32 0, i32 4
  %33 = load i32, i32* %32, align 8
  %34 = call i8** %25(%struct.jpeg_common_struct* %27, %struct.jvirt_sarray_control* %30, i32 %33, i32 1, i32 0)
  store i8** %34, i8*** %7, align 8
  %35 = load i8**, i8*** %7, align 8
  %36 = getelementptr inbounds i8*, i8** %35, i64 0
  %37 = load i8*, i8** %36, align 8
  store i8* %37, i8** %9, align 8
  %38 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %39 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %38, i32 0, i32 0
  %40 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %39, i32 0, i32 4
  %41 = load i8**, i8*** %40, align 8
  %42 = getelementptr inbounds i8*, i8** %41, i64 0
  %43 = load i8*, i8** %42, align 8
  store i8* %43, i8** %10, align 8
  %44 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %45 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %44, i32 0, i32 6
  %46 = load i32, i32* %45, align 8
  store i32 %46, i32* %11, align 4
  br label %47

47:                                               ; preds = %82, %2
  %48 = load i32, i32* %11, align 4
  %49 = icmp ugt i32 %48, 0
  br i1 %49, label %50, label %85

50:                                               ; preds = %47
  %51 = load i8*, i8** %9, align 8
  %52 = getelementptr inbounds i8, i8* %51, i32 1
  store i8* %52, i8** %9, align 8
  %53 = load i8, i8* %51, align 1
  %54 = zext i8 %53 to i32
  store i32 %54, i32* %8, align 4
  %55 = load i8**, i8*** %6, align 8
  %56 = getelementptr inbounds i8*, i8** %55, i64 0
  %57 = load i8*, i8** %56, align 8
  %58 = load i32, i32* %8, align 4
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds i8, i8* %57, i64 %59
  %61 = load i8, i8* %60, align 1
  %62 = load i8*, i8** %10, align 8
  %63 = getelementptr inbounds i8, i8* %62, i32 1
  store i8* %63, i8** %10, align 8
  store i8 %61, i8* %62, align 1
  %64 = load i8**, i8*** %6, align 8
  %65 = getelementptr inbounds i8*, i8** %64, i64 1
  %66 = load i8*, i8** %65, align 8
  %67 = load i32, i32* %8, align 4
  %68 = sext i32 %67 to i64
  %69 = getelementptr inbounds i8, i8* %66, i64 %68
  %70 = load i8, i8* %69, align 1
  %71 = load i8*, i8** %10, align 8
  %72 = getelementptr inbounds i8, i8* %71, i32 1
  store i8* %72, i8** %10, align 8
  store i8 %70, i8* %71, align 1
  %73 = load i8**, i8*** %6, align 8
  %74 = getelementptr inbounds i8*, i8** %73, i64 2
  %75 = load i8*, i8** %74, align 8
  %76 = load i32, i32* %8, align 4
  %77 = sext i32 %76 to i64
  %78 = getelementptr inbounds i8, i8* %75, i64 %77
  %79 = load i8, i8* %78, align 1
  %80 = load i8*, i8** %10, align 8
  %81 = getelementptr inbounds i8, i8* %80, i32 1
  store i8* %81, i8** %10, align 8
  store i8 %79, i8* %80, align 1
  br label %82

82:                                               ; preds = %50
  %83 = load i32, i32* %11, align 4
  %84 = add i32 %83, -1
  store i32 %84, i32* %11, align 4
  br label %47, !llvm.loop !7

85:                                               ; preds = %47
  ret i32 1
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden i32 @get_interlaced_row(%struct.jpeg_compress_struct* %0, %struct.cjpeg_source_struct* %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct*, align 8
  %4 = alloca %struct.cjpeg_source_struct*, align 8
  %5 = alloca %struct.gif_source_struct*, align 8
  %6 = alloca i8**, align 8
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i8*, align 8
  %10 = alloca i32, align 4
  %11 = alloca i8**, align 8
  %12 = alloca i32, align 4
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %3, align 8
  store %struct.cjpeg_source_struct* %1, %struct.cjpeg_source_struct** %4, align 8
  %13 = load %struct.cjpeg_source_struct*, %struct.cjpeg_source_struct** %4, align 8
  %14 = bitcast %struct.cjpeg_source_struct* %13 to %struct.gif_source_struct*
  store %struct.gif_source_struct* %14, %struct.gif_source_struct** %5, align 8
  %15 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %16 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %15, i32 0, i32 2
  %17 = load i8**, i8*** %16, align 8
  store i8** %17, i8*** %11, align 8
  %18 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %19 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %18, i32 0, i32 23
  %20 = load i32, i32* %19, align 8
  %21 = and i32 %20, 7
  switch i32 %21, label %45 [
    i32 0, label %22
    i32 4, label %27
    i32 2, label %36
    i32 6, label %36
  ]

22:                                               ; preds = %2
  %23 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %24 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %23, i32 0, i32 23
  %25 = load i32, i32* %24, align 8
  %26 = lshr i32 %25, 3
  store i32 %26, i32* %12, align 4
  br label %54

27:                                               ; preds = %2
  %28 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %29 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %28, i32 0, i32 23
  %30 = load i32, i32* %29, align 8
  %31 = lshr i32 %30, 3
  %32 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %33 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %32, i32 0, i32 24
  %34 = load i32, i32* %33, align 4
  %35 = add i32 %31, %34
  store i32 %35, i32* %12, align 4
  br label %54

36:                                               ; preds = %2, %2
  %37 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %38 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %37, i32 0, i32 23
  %39 = load i32, i32* %38, align 8
  %40 = lshr i32 %39, 2
  %41 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %42 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %41, i32 0, i32 25
  %43 = load i32, i32* %42, align 8
  %44 = add i32 %40, %43
  store i32 %44, i32* %12, align 4
  br label %54

45:                                               ; preds = %2
  %46 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %47 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %46, i32 0, i32 23
  %48 = load i32, i32* %47, align 8
  %49 = lshr i32 %48, 1
  %50 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %51 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %50, i32 0, i32 26
  %52 = load i32, i32* %51, align 4
  %53 = add i32 %49, %52
  store i32 %53, i32* %12, align 4
  br label %54

54:                                               ; preds = %45, %36, %27, %22
  %55 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %56 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %55, i32 0, i32 1
  %57 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %56, align 8
  %58 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %57, i32 0, i32 7
  %59 = load i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)** %58, align 8
  %60 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %61 = bitcast %struct.jpeg_compress_struct* %60 to %struct.jpeg_common_struct*
  %62 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %63 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %62, i32 0, i32 22
  %64 = load %struct.jvirt_sarray_control*, %struct.jvirt_sarray_control** %63, align 8
  %65 = load i32, i32* %12, align 4
  %66 = call i8** %59(%struct.jpeg_common_struct* %61, %struct.jvirt_sarray_control* %64, i32 %65, i32 1, i32 0)
  store i8** %66, i8*** %6, align 8
  %67 = load i8**, i8*** %6, align 8
  %68 = getelementptr inbounds i8*, i8** %67, i64 0
  %69 = load i8*, i8** %68, align 8
  store i8* %69, i8** %8, align 8
  %70 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %71 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %70, i32 0, i32 0
  %72 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %71, i32 0, i32 4
  %73 = load i8**, i8*** %72, align 8
  %74 = getelementptr inbounds i8*, i8** %73, i64 0
  %75 = load i8*, i8** %74, align 8
  store i8* %75, i8** %9, align 8
  %76 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %77 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %76, i32 0, i32 6
  %78 = load i32, i32* %77, align 8
  store i32 %78, i32* %10, align 4
  br label %79

79:                                               ; preds = %114, %54
  %80 = load i32, i32* %10, align 4
  %81 = icmp ugt i32 %80, 0
  br i1 %81, label %82, label %117

82:                                               ; preds = %79
  %83 = load i8*, i8** %8, align 8
  %84 = getelementptr inbounds i8, i8* %83, i32 1
  store i8* %84, i8** %8, align 8
  %85 = load i8, i8* %83, align 1
  %86 = zext i8 %85 to i32
  store i32 %86, i32* %7, align 4
  %87 = load i8**, i8*** %11, align 8
  %88 = getelementptr inbounds i8*, i8** %87, i64 0
  %89 = load i8*, i8** %88, align 8
  %90 = load i32, i32* %7, align 4
  %91 = sext i32 %90 to i64
  %92 = getelementptr inbounds i8, i8* %89, i64 %91
  %93 = load i8, i8* %92, align 1
  %94 = load i8*, i8** %9, align 8
  %95 = getelementptr inbounds i8, i8* %94, i32 1
  store i8* %95, i8** %9, align 8
  store i8 %93, i8* %94, align 1
  %96 = load i8**, i8*** %11, align 8
  %97 = getelementptr inbounds i8*, i8** %96, i64 1
  %98 = load i8*, i8** %97, align 8
  %99 = load i32, i32* %7, align 4
  %100 = sext i32 %99 to i64
  %101 = getelementptr inbounds i8, i8* %98, i64 %100
  %102 = load i8, i8* %101, align 1
  %103 = load i8*, i8** %9, align 8
  %104 = getelementptr inbounds i8, i8* %103, i32 1
  store i8* %104, i8** %9, align 8
  store i8 %102, i8* %103, align 1
  %105 = load i8**, i8*** %11, align 8
  %106 = getelementptr inbounds i8*, i8** %105, i64 2
  %107 = load i8*, i8** %106, align 8
  %108 = load i32, i32* %7, align 4
  %109 = sext i32 %108 to i64
  %110 = getelementptr inbounds i8, i8* %107, i64 %109
  %111 = load i8, i8* %110, align 1
  %112 = load i8*, i8** %9, align 8
  %113 = getelementptr inbounds i8, i8* %112, i32 1
  store i8* %113, i8** %9, align 8
  store i8 %111, i8* %112, align 1
  br label %114

114:                                              ; preds = %82
  %115 = load i32, i32* %10, align 4
  %116 = add i32 %115, -1
  store i32 %116, i32* %10, align 4
  br label %79, !llvm.loop !9

117:                                              ; preds = %79
  %118 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %119 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %118, i32 0, i32 23
  %120 = load i32, i32* %119, align 8
  %121 = add i32 %120, 1
  store i32 %121, i32* %119, align 8
  ret i32 1
}

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
!9 = distinct !{!9, !8}
