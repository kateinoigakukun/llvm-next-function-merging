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

%struct.jpeg_compress_struct = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_destination_mgr*, i32, i32, i32, i32, double, i32, i32, i32, %struct.jpeg_component_info*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], [16 x i8], [16 x i8], [16 x i8], i32, %struct.jpeg_scan_info*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8, i16, i16, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, %struct.jpeg_comp_master*, %struct.jpeg_c_main_controller*, %struct.jpeg_c_prep_controller*, %struct.jpeg_c_coef_controller*, %struct.jpeg_marker_writer*, %struct.jpeg_color_converter*, %struct.jpeg_downsampler*, %struct.jpeg_forward_dct*, %struct.jpeg_entropy_encoder* }
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
%struct.jpeg_destination_mgr = type { i8*, i64, void (%struct.jpeg_compress_struct*)*, i32 (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)* }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_scan_info = type { i32, [4 x i32], i32, i32, i32, i32 }
%struct.jpeg_comp_master = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, i32, i32 }
%struct.jpeg_c_main_controller = type { void (%struct.jpeg_compress_struct*, i32)*, void (%struct.jpeg_compress_struct*, i8**, i32*, i32)* }
%struct.jpeg_c_prep_controller = type { void (%struct.jpeg_compress_struct*, i32)*, void (%struct.jpeg_compress_struct*, i8**, i32*, i32, i8***, i32*, i32)* }
%struct.jpeg_c_coef_controller = type { void (%struct.jpeg_compress_struct*, i32)*, i32 (%struct.jpeg_compress_struct*, i8***)* }
%struct.jpeg_marker_writer = type { void (%struct.jpeg_compress_struct*, i32, i8*, i32)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*)* }
%struct.jpeg_color_converter = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*, i8**, i8***, i32, i32)* }
%struct.jpeg_downsampler = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*, i8***, i32, i8***, i32)*, i32 }
%struct.jpeg_forward_dct = type { void (%struct.jpeg_compress_struct*)*, void (%struct.jpeg_compress_struct*, %struct.jpeg_component_info*, i8**, [64 x i16]*, i32, i32, i32)* }
%struct.jpeg_entropy_encoder = type { void (%struct.jpeg_compress_struct*, i32)*, i32 (%struct.jpeg_compress_struct*, [64 x i16]**)*, void (%struct.jpeg_compress_struct*)* }

define hidden void @emit_byte() {
  ret void
}

define hidden void @emit_sof() {
  br i1 true, label %1, label %2

1:                                                ; preds = %0
  br label %2

2:                                                ; preds = %1, %0
  ret void
}

define void @jpeg_set_colorspace(%struct.jpeg_compress_struct* %0, i32 %1) {
  %3 = alloca %struct.jpeg_compress_struct*, align 8
  %4 = alloca i32, align 4
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %3, align 8
  store i32 %1, i32* %4, align 4
  br i1 true, label %5, label %6

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %5, %2
  %7 = load i32, i32* %4, align 4
  %8 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %9 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %8, i32 0, i32 13
  store i32 %7, i32* %9, align 8
  switch i32 3, label %16 [
    i32 3, label %10
    i32 0, label %13
  ]

10:                                               ; preds = %6
  %11 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %12 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %11, i32 0, i32 12
  store i32 3, i32* %12, align 4
  ret void

13:                                               ; preds = %6
  %14 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %3, align 8
  %15 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %14, i32 0, i32 12
  store i32 4, i32* %15, align 4
  br label %16

16:                                               ; preds = %6
  ret void
}
