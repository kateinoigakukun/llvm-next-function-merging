; Generated from multiple-func-merging:UnprofitableMerge
; - load_interlaced_image
; - preload_image

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      --- !Missed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            UnprofitableMerge
; CHECK-NEXT: Function:        preload_image

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
%struct.cjpeg_source_struct = type { void (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, void (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, %struct._IO_FILE*, i8**, i32 }
%struct._bmp_source_struct = type { %struct.cjpeg_source_struct, %struct.jpeg_compress_struct*, i8**, %struct.jvirt_sarray_control*, i32, i32, i32 }
%struct.cdjpeg_progress_mgr = type { %struct.jpeg_progress_mgr, i32, i32, i32 }
%struct.gif_source_struct = type { %struct.cjpeg_source_struct, %struct.jpeg_compress_struct*, i8**, [260 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16*, i8*, i8*, i8*, i32, %struct.jvirt_sarray_control*, i32, i32, i32, i32 }

declare i32 @getc(%struct._IO_FILE*) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden i32 @preload_image(%struct.jpeg_compress_struct* %0, %struct.cjpeg_source_struct* %1) #1 {
  %3 = alloca %struct.jpeg_compress_struct*, align 8
  %4 = alloca %struct.cjpeg_source_struct*, align 8
  %5 = alloca %struct._bmp_source_struct*, align 8
  %6 = alloca %struct._IO_FILE*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i8**, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca %struct.cdjpeg_progress_mgr*, align 8
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %3, align 8
  store %struct.cjpeg_source_struct* %1, %struct.cjpeg_source_struct** %4, align 8
  %13 = load %struct.cjpeg_source_struct*, %struct.cjpeg_source_struct** %4, align 8
  %14 = bitcast %struct.cjpeg_source_struct* %13 to %struct._bmp_source_struct*
  store %struct._bmp_source_struct* %14, %struct._bmp_source_struct** %5, align 8
  %15 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %16 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %15, i32 0, i32 0
  %17 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %16, i32 0, i32 3
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** %17, align 8
  store %struct._IO_FILE* %18, %struct._IO_FILE** %6, align 8
  %19 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %20 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %19, i32 0, i32 2
  %21 = load %struct.jpeg_progress_mgr*, %struct.jpeg_progress_mgr** %20, align 8
  %22 = bitcast %struct.jpeg_progress_mgr* %21 to %struct.cdjpeg_progress_mgr*
  store %struct.cdjpeg_progress_mgr* %22, %struct.cdjpeg_progress_mgr** %12, align 8
  store i32 0, i32* %10, align 4
  br label %23

23:                                               ; preds = %99, %2
  %24 = load i32, i32* %10, align 4
  %25 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %26 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %25, i32 0, i32 7
  %27 = load i32, i32* %26, align 4
  %28 = icmp ult i32 %24, %27
  br i1 %28, label %29, label %102

29:                                               ; preds = %23
  %30 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %12, align 8
  %31 = icmp ne %struct.cdjpeg_progress_mgr* %30, null
  br i1 %31, label %32, label %52

32:                                               ; preds = %29
  %33 = load i32, i32* %10, align 4
  %34 = zext i32 %33 to i64
  %35 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %12, align 8
  %36 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %35, i32 0, i32 0
  %37 = getelementptr inbounds %struct.jpeg_progress_mgr, %struct.jpeg_progress_mgr* %36, i32 0, i32 1
  store i64 %34, i64* %37, align 8
  %38 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %39 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %38, i32 0, i32 7
  %40 = load i32, i32* %39, align 4
  %41 = zext i32 %40 to i64
  %42 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %12, align 8
  %43 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %42, i32 0, i32 0
  %44 = getelementptr inbounds %struct.jpeg_progress_mgr, %struct.jpeg_progress_mgr* %43, i32 0, i32 2
  store i64 %41, i64* %44, align 8
  %45 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %12, align 8
  %46 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %45, i32 0, i32 0
  %47 = getelementptr inbounds %struct.jpeg_progress_mgr, %struct.jpeg_progress_mgr* %46, i32 0, i32 0
  %48 = bitcast {}** %47 to void (%struct.jpeg_common_struct*)**
  %49 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %48, align 8
  %50 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %51 = bitcast %struct.jpeg_compress_struct* %50 to %struct.jpeg_common_struct*
  call void %49(%struct.jpeg_common_struct* %51)
  br label %52

52:                                               ; preds = %32, %29
  %53 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %54 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %53, i32 0, i32 1
  %55 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %54, align 8
  %56 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %55, i32 0, i32 7
  %57 = load i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)** %56, align 8
  %58 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %59 = bitcast %struct.jpeg_compress_struct* %58 to %struct.jpeg_common_struct*
  %60 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %61 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %60, i32 0, i32 3
  %62 = load %struct.jvirt_sarray_control*, %struct.jvirt_sarray_control** %61, align 8
  %63 = load i32, i32* %10, align 4
  %64 = call i8** %57(%struct.jpeg_common_struct* %59, %struct.jvirt_sarray_control* %62, i32 %63, i32 1, i32 1)
  store i8** %64, i8*** %9, align 8
  %65 = load i8**, i8*** %9, align 8
  %66 = getelementptr inbounds i8*, i8** %65, i64 0
  %67 = load i8*, i8** %66, align 8
  store i8* %67, i8** %8, align 8
  %68 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %69 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %68, i32 0, i32 5
  %70 = load i32, i32* %69, align 4
  store i32 %70, i32* %11, align 4
  br label %71

71:                                               ; preds = %95, %52
  %72 = load i32, i32* %11, align 4
  %73 = icmp ugt i32 %72, 0
  br i1 %73, label %74, label %98

74:                                               ; preds = %71
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %76 = call i32 @getc(%struct._IO_FILE* %75)
  store i32 %76, i32* %7, align 4
  %77 = icmp eq i32 %76, -1
  br i1 %77, label %78, label %90

78:                                               ; preds = %74
  %79 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %80 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %79, i32 0, i32 0
  %81 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %80, align 8
  %82 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %81, i32 0, i32 5
  store i32 42, i32* %82, align 8
  %83 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %84 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %83, i32 0, i32 0
  %85 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %84, align 8
  %86 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %85, i32 0, i32 0
  %87 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %86, align 8
  %88 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %89 = bitcast %struct.jpeg_compress_struct* %88 to %struct.jpeg_common_struct*
  call void %87(%struct.jpeg_common_struct* %89)
  br label %90

90:                                               ; preds = %78, %74
  %91 = load i32, i32* %7, align 4
  %92 = trunc i32 %91 to i8
  %93 = load i8*, i8** %8, align 8
  %94 = getelementptr inbounds i8, i8* %93, i32 1
  store i8* %94, i8** %8, align 8
  store i8 %92, i8* %93, align 1
  br label %95

95:                                               ; preds = %90
  %96 = load i32, i32* %11, align 4
  %97 = add i32 %96, -1
  store i32 %97, i32* %11, align 4
  br label %71, !llvm.loop !7

98:                                               ; preds = %71
  br label %99

99:                                               ; preds = %98
  %100 = load i32, i32* %10, align 4
  %101 = add i32 %100, 1
  store i32 %101, i32* %10, align 4
  br label %23, !llvm.loop !9

102:                                              ; preds = %23
  %103 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %12, align 8
  %104 = icmp ne %struct.cdjpeg_progress_mgr* %103, null
  br i1 %104, label %105, label %110

105:                                              ; preds = %102
  %106 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %12, align 8
  %107 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %106, i32 0, i32 1
  %108 = load i32, i32* %107, align 8
  %109 = add nsw i32 %108, 1
  store i32 %109, i32* %107, align 8
  br label %110

110:                                              ; preds = %105, %102
  %111 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %112 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %111, i32 0, i32 6
  %113 = load i32, i32* %112, align 8
  switch i32 %113, label %122 [
    i32 8, label %114
    i32 24, label %118
  ]

114:                                              ; preds = %110
  %115 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %116 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %115, i32 0, i32 0
  %117 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %116, i32 0, i32 1
  store i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)* @get_8bit_row, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)** %117, align 8
  br label %134

118:                                              ; preds = %110
  %119 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %120 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %119, i32 0, i32 0
  %121 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %120, i32 0, i32 1
  store i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)* @get_24bit_row, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)** %121, align 8
  br label %134

122:                                              ; preds = %110
  %123 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %124 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %123, i32 0, i32 0
  %125 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %124, align 8
  %126 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %125, i32 0, i32 5
  store i32 1002, i32* %126, align 8
  %127 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %128 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %127, i32 0, i32 0
  %129 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %128, align 8
  %130 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %129, i32 0, i32 0
  %131 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %130, align 8
  %132 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %133 = bitcast %struct.jpeg_compress_struct* %132 to %struct.jpeg_common_struct*
  call void %131(%struct.jpeg_common_struct* %133)
  br label %134

134:                                              ; preds = %122, %118, %114
  %135 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %136 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %135, i32 0, i32 7
  %137 = load i32, i32* %136, align 4
  %138 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %139 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %138, i32 0, i32 4
  store i32 %137, i32* %139, align 8
  %140 = load %struct._bmp_source_struct*, %struct._bmp_source_struct** %5, align 8
  %141 = getelementptr inbounds %struct._bmp_source_struct, %struct._bmp_source_struct* %140, i32 0, i32 0
  %142 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %141, i32 0, i32 1
  %143 = load i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)*, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)** %142, align 8
  %144 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %145 = load %struct.cjpeg_source_struct*, %struct.cjpeg_source_struct** %4, align 8
  %146 = call i32 %143(%struct.jpeg_compress_struct* %144, %struct.cjpeg_source_struct* %145)
  ret i32 %146
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @get_8bit_row(%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @get_24bit_row(%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden i32 @load_interlaced_image(%struct.jpeg_compress_struct* %0, %struct.cjpeg_source_struct* %1) #1 {
  %3 = alloca %struct.jpeg_compress_struct*, align 8
  %4 = alloca %struct.cjpeg_source_struct*, align 8
  %5 = alloca %struct.gif_source_struct*, align 8
  %6 = alloca i8**, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.cdjpeg_progress_mgr*, align 8
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %3, align 8
  store %struct.cjpeg_source_struct* %1, %struct.cjpeg_source_struct** %4, align 8
  %11 = load %struct.cjpeg_source_struct*, %struct.cjpeg_source_struct** %4, align 8
  %12 = bitcast %struct.cjpeg_source_struct* %11 to %struct.gif_source_struct*
  store %struct.gif_source_struct* %12, %struct.gif_source_struct** %5, align 8
  %13 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %14 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %13, i32 0, i32 2
  %15 = load %struct.jpeg_progress_mgr*, %struct.jpeg_progress_mgr** %14, align 8
  %16 = bitcast %struct.jpeg_progress_mgr* %15 to %struct.cdjpeg_progress_mgr*
  store %struct.cdjpeg_progress_mgr* %16, %struct.cdjpeg_progress_mgr** %10, align 8
  store i32 0, i32* %9, align 4
  br label %17

17:                                               ; preds = %78, %2
  %18 = load i32, i32* %9, align 4
  %19 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %20 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %19, i32 0, i32 7
  %21 = load i32, i32* %20, align 4
  %22 = icmp ult i32 %18, %21
  br i1 %22, label %23, label %81

23:                                               ; preds = %17
  %24 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %10, align 8
  %25 = icmp ne %struct.cdjpeg_progress_mgr* %24, null
  br i1 %25, label %26, label %46

26:                                               ; preds = %23
  %27 = load i32, i32* %9, align 4
  %28 = zext i32 %27 to i64
  %29 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %10, align 8
  %30 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %29, i32 0, i32 0
  %31 = getelementptr inbounds %struct.jpeg_progress_mgr, %struct.jpeg_progress_mgr* %30, i32 0, i32 1
  store i64 %28, i64* %31, align 8
  %32 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %33 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %32, i32 0, i32 7
  %34 = load i32, i32* %33, align 4
  %35 = zext i32 %34 to i64
  %36 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %10, align 8
  %37 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %36, i32 0, i32 0
  %38 = getelementptr inbounds %struct.jpeg_progress_mgr, %struct.jpeg_progress_mgr* %37, i32 0, i32 2
  store i64 %35, i64* %38, align 8
  %39 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %10, align 8
  %40 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %39, i32 0, i32 0
  %41 = getelementptr inbounds %struct.jpeg_progress_mgr, %struct.jpeg_progress_mgr* %40, i32 0, i32 0
  %42 = bitcast {}** %41 to void (%struct.jpeg_common_struct*)**
  %43 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %42, align 8
  %44 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %45 = bitcast %struct.jpeg_compress_struct* %44 to %struct.jpeg_common_struct*
  call void %43(%struct.jpeg_common_struct* %45)
  br label %46

46:                                               ; preds = %26, %23
  %47 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %48 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %47, i32 0, i32 1
  %49 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %48, align 8
  %50 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %49, i32 0, i32 7
  %51 = load i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)*, i8** (%struct.jpeg_common_struct*, %struct.jvirt_sarray_control*, i32, i32, i32)** %50, align 8
  %52 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %53 = bitcast %struct.jpeg_compress_struct* %52 to %struct.jpeg_common_struct*
  %54 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %55 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %54, i32 0, i32 22
  %56 = load %struct.jvirt_sarray_control*, %struct.jvirt_sarray_control** %55, align 8
  %57 = load i32, i32* %9, align 4
  %58 = call i8** %51(%struct.jpeg_common_struct* %53, %struct.jvirt_sarray_control* %56, i32 %57, i32 1, i32 1)
  store i8** %58, i8*** %6, align 8
  %59 = load i8**, i8*** %6, align 8
  %60 = getelementptr inbounds i8*, i8** %59, i64 0
  %61 = load i8*, i8** %60, align 8
  store i8* %61, i8** %7, align 8
  %62 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %63 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %62, i32 0, i32 6
  %64 = load i32, i32* %63, align 8
  store i32 %64, i32* %8, align 4
  br label %65

65:                                               ; preds = %74, %46
  %66 = load i32, i32* %8, align 4
  %67 = icmp ugt i32 %66, 0
  br i1 %67, label %68, label %77

68:                                               ; preds = %65
  %69 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %70 = call i32 @LZWReadByte(%struct.gif_source_struct* %69)
  %71 = trunc i32 %70 to i8
  %72 = load i8*, i8** %7, align 8
  %73 = getelementptr inbounds i8, i8* %72, i32 1
  store i8* %73, i8** %7, align 8
  store i8 %71, i8* %72, align 1
  br label %74

74:                                               ; preds = %68
  %75 = load i32, i32* %8, align 4
  %76 = add i32 %75, -1
  store i32 %76, i32* %8, align 4
  br label %65, !llvm.loop !10

77:                                               ; preds = %65
  br label %78

78:                                               ; preds = %77
  %79 = load i32, i32* %9, align 4
  %80 = add i32 %79, 1
  store i32 %80, i32* %9, align 4
  br label %17, !llvm.loop !11

81:                                               ; preds = %17
  %82 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %10, align 8
  %83 = icmp ne %struct.cdjpeg_progress_mgr* %82, null
  br i1 %83, label %84, label %89

84:                                               ; preds = %81
  %85 = load %struct.cdjpeg_progress_mgr*, %struct.cdjpeg_progress_mgr** %10, align 8
  %86 = getelementptr inbounds %struct.cdjpeg_progress_mgr, %struct.cdjpeg_progress_mgr* %85, i32 0, i32 1
  %87 = load i32, i32* %86, align 8
  %88 = add nsw i32 %87, 1
  store i32 %88, i32* %86, align 8
  br label %89

89:                                               ; preds = %84, %81
  %90 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %91 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %90, i32 0, i32 0
  %92 = getelementptr inbounds %struct.cjpeg_source_struct, %struct.cjpeg_source_struct* %91, i32 0, i32 1
  store i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)* @get_interlaced_row, i32 (%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*)** %92, align 8
  %93 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %94 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %93, i32 0, i32 23
  store i32 0, i32* %94, align 8
  %95 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %96 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %95, i32 0, i32 7
  %97 = load i32, i32* %96, align 4
  %98 = add i32 %97, 7
  %99 = udiv i32 %98, 8
  %100 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %101 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %100, i32 0, i32 24
  store i32 %99, i32* %101, align 4
  %102 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %103 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %102, i32 0, i32 24
  %104 = load i32, i32* %103, align 4
  %105 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %106 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %105, i32 0, i32 7
  %107 = load i32, i32* %106, align 4
  %108 = add i32 %107, 3
  %109 = udiv i32 %108, 8
  %110 = add i32 %104, %109
  %111 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %112 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %111, i32 0, i32 25
  store i32 %110, i32* %112, align 8
  %113 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %114 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %113, i32 0, i32 25
  %115 = load i32, i32* %114, align 8
  %116 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %117 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %116, i32 0, i32 7
  %118 = load i32, i32* %117, align 4
  %119 = add i32 %118, 1
  %120 = udiv i32 %119, 4
  %121 = add i32 %115, %120
  %122 = load %struct.gif_source_struct*, %struct.gif_source_struct** %5, align 8
  %123 = getelementptr inbounds %struct.gif_source_struct, %struct.gif_source_struct* %122, i32 0, i32 26
  store i32 %121, i32* %123, align 4
  %124 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %125 = load %struct.cjpeg_source_struct*, %struct.cjpeg_source_struct** %4, align 8
  %126 = call i32 @get_interlaced_row(%struct.jpeg_compress_struct* %124, %struct.cjpeg_source_struct* %125)
  ret i32 %126
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @LZWReadByte(%struct.gif_source_struct*) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @get_interlaced_row(%struct.jpeg_compress_struct*, %struct.cjpeg_source_struct*) #1

attributes #0 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
