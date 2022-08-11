; RUN: %opt --passes='multiple-func-merging' --multiple-func-merging-disable-post-opt -func-merging-explore=2 '--multiple-func-merging-only=jpeg_set_colorspace' '--multiple-func-merging-only=emit_byte' '--multiple-func-merging-only=emit_sof' %s -o %t.opt.three.bc
; RUN: %clang %t.opt.three.bc %S/Inputs/jpeg_set_colorspace_emit_byte_emit_sof.driver.bc -lm -o %t.opt.three
; RUN: %opt --passes='multiple-func-merging' --multiple-func-merging-disable-post-opt -func-merging-explore=2 '--multiple-func-merging-only=jpeg_set_colorspace' '--multiple-func-merging-only=emit_byte' %s -o %t.opt.two.bc
; RUN: %clang %t.opt.two.bc %S/Inputs/jpeg_set_colorspace_emit_byte_emit_sof.driver.bc -lm -o %t.opt.two
; RUN: %clang %s %S/Inputs/jpeg_set_colorspace_emit_byte_emit_sof.driver.bc -lm -o %t.safe
; RUN: %t.safe '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; RUN: %t.opt.two '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; RUN: not %t.opt.three '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.jpeg_compress_struct.175 = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_destination_mgr.161*, i32, i32, i32, i32, double, i32, i32, i32, %struct.jpeg_component_info*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], [16 x i8], [16 x i8], [16 x i8], i32, %struct.jpeg_scan_info*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8, i16, i16, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, %struct.jpeg_comp_master.56*, %struct.jpeg_c_main_controller.167*, %struct.jpeg_c_prep_controller.168*, %struct.jpeg_c_coef_controller.169*, %struct.jpeg_marker_writer.170*, %struct.jpeg_color_converter.171*, %struct.jpeg_downsampler.172*, %struct.jpeg_forward_dct.173*, %struct.jpeg_entropy_encoder.174* }
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
%struct.jpeg_destination_mgr.161 = type { i8*, i64, {}*, i32 (%struct.jpeg_compress_struct.175*)*, {}* }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_scan_info = type { i32, [4 x i32], i32, i32, i32, i32 }
%struct.jpeg_comp_master.56 = type { {}*, {}*, {}*, i32, i32 }
%struct.jpeg_c_main_controller.167 = type { void (%struct.jpeg_compress_struct.175*, i32)*, void (%struct.jpeg_compress_struct.175*, i8**, i32*, i32)* }
%struct.jpeg_c_prep_controller.168 = type { void (%struct.jpeg_compress_struct.175*, i32)*, void (%struct.jpeg_compress_struct.175*, i8**, i32*, i32, i8***, i32*, i32)* }
%struct.jpeg_c_coef_controller.169 = type { void (%struct.jpeg_compress_struct.175*, i32)*, i32 (%struct.jpeg_compress_struct.175*, i8***)* }
%struct.jpeg_marker_writer.170 = type { void (%struct.jpeg_compress_struct.175*, i32, i8*, i32)*, {}*, {}*, {}*, {}*, {}* }
%struct.jpeg_color_converter.171 = type { {}*, void (%struct.jpeg_compress_struct.175*, i8**, i8***, i32, i32)* }
%struct.jpeg_downsampler.172 = type { {}*, void (%struct.jpeg_compress_struct.175*, i8***, i32, i8***, i32)*, i32 }
%struct.jpeg_forward_dct.173 = type { {}*, void (%struct.jpeg_compress_struct.175*, %struct.jpeg_component_info*, i8**, [64 x i16]*, i32, i32, i32)* }
%struct.jpeg_entropy_encoder.174 = type { void (%struct.jpeg_compress_struct.175*, i32)*, i32 (%struct.jpeg_compress_struct.175*, [64 x i16]**)*, {}* }
%struct.jpeg_compress_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_destination_mgr*, i32, i32, i32, i32, double, i32, i32, i32, %struct.jpeg_component_info*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], [16 x i8], [16 x i8], [16 x i8], i32, %struct.jpeg_scan_info*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8, i16, i16, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, %struct.jpeg_comp_master*, %struct.jpeg_c_main_controller*, %struct.jpeg_c_prep_controller*, %struct.jpeg_c_coef_controller*, %struct.jpeg_marker_writer*, %struct.jpeg_color_converter*, %struct.jpeg_downsampler*, %struct.jpeg_forward_dct*, %struct.jpeg_entropy_encoder* }
%struct.jpeg_destination_mgr = type { i8*, i64, void (%struct.jpeg_compress_struct*)*, i32 (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)* }
%struct.jpeg_comp_master = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, i32, i32 }
%struct.jpeg_c_main_controller = type { void (%struct.jpeg_compress_struct*, i32)*, void (%struct.jpeg_compress_struct*, i8**, i32*, i32)* }
%struct.jpeg_c_prep_controller = type { void (%struct.jpeg_compress_struct*, i32)*, void (%struct.jpeg_compress_struct*, i8**, i32*, i32, i8***, i32*, i32)* }
%struct.jpeg_c_coef_controller = type { void (%struct.jpeg_compress_struct*, i32)*, i32 (%struct.jpeg_compress_struct*, i8***)* }
%struct.jpeg_marker_writer = type { void (%struct.jpeg_compress_struct*, i32, i8*, i32)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)* }
%struct.jpeg_color_converter = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*, i8**, i8***, i32, i32)* }
%struct.jpeg_downsampler = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*, i8***, i32, i8***, i32)*, i32 }
%struct.jpeg_forward_dct = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*, %struct.jpeg_component_info*, i8**, [64 x i16]*, i32, i32, i32)* }
%struct.jpeg_entropy_encoder = type { void (%struct.jpeg_compress_struct*, i32)*, i32 (%struct.jpeg_compress_struct*, [64 x i16]**)*, void (%struct.jpeg_compress_struct*)* }

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_2bytes(%struct.jpeg_compress_struct.175*, i32) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @emit_byte(%struct.jpeg_compress_struct.175* %0, i32 %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct.175*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.jpeg_destination_mgr.161*, align 8
  store %struct.jpeg_compress_struct.175* %0, %struct.jpeg_compress_struct.175** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %7 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %6, i32 0, i32 5
  %8 = load %struct.jpeg_destination_mgr.161*, %struct.jpeg_destination_mgr.161** %7, align 8
  store %struct.jpeg_destination_mgr.161* %8, %struct.jpeg_destination_mgr.161** %5, align 8
  %9 = load %struct.jpeg_destination_mgr.161*, %struct.jpeg_destination_mgr.161** %5, align 8
  %10 = getelementptr inbounds %struct.jpeg_destination_mgr.161, %struct.jpeg_destination_mgr.161* %9, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = add i64 %11, -1
  store i64 %12, i64* %10, align 8
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %34

14:                                               ; preds = %2
  %15 = load %struct.jpeg_destination_mgr.161*, %struct.jpeg_destination_mgr.161** %5, align 8
  %16 = getelementptr inbounds %struct.jpeg_destination_mgr.161, %struct.jpeg_destination_mgr.161* %15, i32 0, i32 3
  %17 = load i32 (%struct.jpeg_compress_struct.175*)*, i32 (%struct.jpeg_compress_struct.175*)** %16, align 8
  %18 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %19 = call i32 %17(%struct.jpeg_compress_struct.175* %18)
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %33, label %21

21:                                               ; preds = %14
  %22 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %23 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %22, i32 0, i32 0
  %24 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %23, align 8
  %25 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %24, i32 0, i32 5
  store i32 22, i32* %25, align 8
  %26 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %27 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %26, i32 0, i32 0
  %28 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %27, align 8
  %29 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %28, i32 0, i32 0
  %30 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %29, align 8
  %31 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %32 = bitcast %struct.jpeg_compress_struct.175* %31 to %struct.jpeg_common_struct*
  call void %30(%struct.jpeg_common_struct* %32)
  br label %33

33:                                               ; preds = %21, %14
  br label %34

34:                                               ; preds = %33, %2
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define hidden void @emit_sof(%struct.jpeg_compress_struct.175* %0, i32 %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct.175*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca %struct.jpeg_component_info*, align 8
  store %struct.jpeg_compress_struct.175* %0, %struct.jpeg_compress_struct.175** %3, align 8
  store i32 %1, i32* %4, align 4
  %7 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %8 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %7, i32 0, i32 7
  %9 = load i32, i32* %8, align 4
  %10 = zext i32 %9 to i64
  %11 = icmp sgt i64 %10, 65535
  br i1 %11, label %12, label %30

12:                                               ; preds = %2
  %13 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %14 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %13, i32 0, i32 0
  %15 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %14, align 8
  %16 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %15, i32 0, i32 5
  store i32 40, i32* %16, align 8
  %17 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %18 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %17, i32 0, i32 0
  %19 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %18, align 8
  %20 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %19, i32 0, i32 6
  %21 = bitcast %union.anon* %20 to [8 x i32]*
  %22 = getelementptr inbounds [8 x i32], [8 x i32]* %21, i64 0, i64 0
  store i32 65535, i32* %22, align 4
  %23 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %24 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %23, i32 0, i32 0
  %25 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %24, align 8
  %26 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %25, i32 0, i32 0
  %27 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %26, align 8
  %28 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %29 = bitcast %struct.jpeg_compress_struct.175* %28 to %struct.jpeg_common_struct*
  call void %27(%struct.jpeg_common_struct* %29)
  br label %30

30:                                               ; preds = %12, %2
  %31 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %32 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %33 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %32, i32 0, i32 7
  %34 = load i32, i32* %33, align 4
  call void @emit_2bytes(%struct.jpeg_compress_struct.175* %31, i32 %34)
  %35 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %36 = load %struct.jpeg_compress_struct.175*, %struct.jpeg_compress_struct.175** %3, align 8
  %37 = getelementptr inbounds %struct.jpeg_compress_struct.175, %struct.jpeg_compress_struct.175* %36, i32 0, i32 12
  %38 = load i32, i32* %37, align 4
  call void @emit_byte(%struct.jpeg_compress_struct.175* %35, i32 %38)
  store i32 0, i32* %5, align 4
  br label %39

39:                                               ; preds = %43, %30
  %40 = load i32, i32* %5, align 4
  %41 = icmp slt i32 %40, 1
  br i1 %41, label %42, label %46

42:                                               ; preds = %39
  br label %43

43:                                               ; preds = %42
  %44 = load i32, i32* %5, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %5, align 4
  br label %39, !llvm.loop !7

46:                                               ; preds = %39
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @jpeg_set_colorspace(%struct.jpeg_compress_struct* %0, i32 %1) #0 {
  %3 = alloca %struct.jpeg_compress_struct*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.jpeg_component_info*, align 8
  %6 = alloca i32, align 4
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %3, align 8
  store i32 %1, i32* %4, align 4
  %7 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %8 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %7, i32 0, i32 4
  %9 = load i32, i32* %8, align 4
  %10 = icmp ne i32 %9, 100
  br i1 %10, label %11, label %32

11:                                               ; preds = %2
  %12 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %13 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %12, i32 0, i32 0
  %14 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %13, align 8
  %15 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %14, i32 0, i32 5
  store i32 18, i32* %15, align 8
  %16 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %17 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %16, i32 0, i32 4
  %18 = load i32, i32* %17, align 4
  %19 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %20 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %19, i32 0, i32 0
  %21 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %20, align 8
  %22 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %21, i32 0, i32 6
  %23 = bitcast %union.anon* %22 to [8 x i32]*
  %24 = getelementptr inbounds [8 x i32], [8 x i32]* %23, i64 0, i64 0
  store i32 %18, i32* %24, align 4
  %25 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %26 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %25, i32 0, i32 0
  %27 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %26, align 8
  %28 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %27, i32 0, i32 0
  %29 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %28, align 8
  %30 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %31 = bitcast %struct.jpeg_compress_struct* %30 to %struct.jpeg_common_struct*
  call void %29(%struct.jpeg_common_struct* %31)
  br label %32

32:                                               ; preds = %11, %2
  %33 = load i32, i32* %4, align 4
  %34 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %35 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %34, i32 0, i32 13
  store i32 %33, i32* %35, align 8
  %36 = load i32, i32* %4, align 4
  switch i32 %36, label %109 [
    i32 3, label %37
    i32 0, label %58
  ]

37:                                               ; preds = %32
  %38 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %39 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %38, i32 0, i32 12
  store i32 3, i32* %39, align 4
  %40 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %41 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %40, i32 0, i32 14
  %42 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %41, align 8
  %43 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %42, i64 0
  store %struct.jpeg_component_info* %43, %struct.jpeg_component_info** %5, align 8
  %44 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %5, align 8
  %45 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %44, i32 0, i32 2
  store i32 2, i32* %45, align 8
  %46 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %5, align 8
  %47 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %46, i32 0, i32 3
  store i32 2, i32* %47, align 4
  %48 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %49 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %48, i32 0, i32 14
  %50 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %49, align 8
  %51 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %50, i64 1
  store %struct.jpeg_component_info* %51, %struct.jpeg_component_info** %5, align 8
  %52 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %5, align 8
  %53 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %52, i32 0, i32 3
  store i32 1, i32* %53, align 4
  %54 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %55 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %54, i32 0, i32 14
  %56 = load %struct.jpeg_component_info*, %struct.jpeg_component_info** %55, align 8
  %57 = getelementptr inbounds %struct.jpeg_component_info, %struct.jpeg_component_info* %56, i64 2
  store %struct.jpeg_component_info* %57, %struct.jpeg_component_info** %5, align 8
  br label %121

58:                                               ; preds = %32
  %59 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %60 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %59, i32 0, i32 8
  %61 = load i32, i32* %60, align 8
  %62 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %63 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %62, i32 0, i32 12
  store i32 %61, i32* %63, align 4
  %64 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %65 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %64, i32 0, i32 12
  %66 = load i32, i32* %65, align 4
  %67 = icmp slt i32 %66, 1
  br i1 %67, label %73, label %68

68:                                               ; preds = %58
  %69 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %70 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %69, i32 0, i32 12
  %71 = load i32, i32* %70, align 4
  %72 = icmp sgt i32 %71, 10
  br i1 %72, label %73, label %100

73:                                               ; preds = %68, %58
  %74 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %75 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %74, i32 0, i32 0
  %76 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %75, align 8
  %77 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %76, i32 0, i32 5
  store i32 24, i32* %77, align 8
  %78 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %79 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %78, i32 0, i32 12
  %80 = load i32, i32* %79, align 4
  %81 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %82 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %81, i32 0, i32 0
  %83 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %82, align 8
  %84 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %83, i32 0, i32 6
  %85 = bitcast %union.anon* %84 to [8 x i32]*
  %86 = getelementptr inbounds [8 x i32], [8 x i32]* %85, i64 0, i64 0
  store i32 %80, i32* %86, align 4
  %87 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %88 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %87, i32 0, i32 0
  %89 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %88, align 8
  %90 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %89, i32 0, i32 6
  %91 = bitcast %union.anon* %90 to [8 x i32]*
  %92 = getelementptr inbounds [8 x i32], [8 x i32]* %91, i64 0, i64 1
  store i32 10, i32* %92, align 4
  %93 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %94 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %93, i32 0, i32 0
  %95 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %94, align 8
  %96 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %95, i32 0, i32 0
  %97 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %96, align 8
  %98 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %99 = bitcast %struct.jpeg_compress_struct* %98 to %struct.jpeg_common_struct*
  call void %97(%struct.jpeg_common_struct* %99)
  br label %100

100:                                              ; preds = %73, %68
  store i32 0, i32* %6, align 4
  br label %101

101:                                              ; preds = %105, %100
  %102 = load i32, i32* %6, align 4
  %103 = icmp slt i32 %102, 1
  br i1 %103, label %104, label %108

104:                                              ; preds = %101
  br label %105

105:                                              ; preds = %104
  %106 = load i32, i32* %6, align 4
  %107 = add nsw i32 %106, 1
  store i32 %107, i32* %6, align 4
  br label %101, !llvm.loop !9

108:                                              ; preds = %101
  br label %121

109:                                              ; preds = %32
  %110 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %111 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %110, i32 0, i32 0
  %112 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %111, align 8
  %113 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %112, i32 0, i32 5
  store i32 8, i32* %113, align 8
  %114 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %115 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %114, i32 0, i32 0
  %116 = load %struct.jpeg_error_mgr*, %struct.jpeg_error_mgr** %115, align 8
  %117 = getelementptr inbounds %struct.jpeg_error_mgr, %struct.jpeg_error_mgr* %116, i32 0, i32 0
  %118 = load void (%struct.jpeg_common_struct*)*, void (%struct.jpeg_common_struct*)** %117, align 8
  %119 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %120 = bitcast %struct.jpeg_compress_struct* %119 to %struct.jpeg_common_struct*
  call void %118(%struct.jpeg_common_struct* %120)
  br label %121

121:                                              ; preds = %109, %108, %37
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
