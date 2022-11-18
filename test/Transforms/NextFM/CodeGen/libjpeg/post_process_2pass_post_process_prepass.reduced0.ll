; RUN: %opt -S --passes="multiple-func-merging" --multiple-func-merging-only=post_process_2pass --multiple-func-merging-only=post_process_prepass -o %t.mfm.ll %s
; RUN: %opt -S --passes="func-merging" --func-merging-only=post_process_2pass --func-merging-only=post_process_prepass -o %t.fm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.fm.ll -o %t.fm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.fm.o
; RUN: [[ $(stat -c%%s %t.mfm.o) -le $(stat -c%%s %t.fm.o) ]]
; ModuleID = 'test/Transforms/NextFM/CodeGen/libjpeg/post_process_2pass_post_process_prepass.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.jpeg_decompress_struct.637 = type { %struct.jpeg_error_mgr*, %struct.jpeg_memory_mgr*, %struct.jpeg_progress_mgr*, i32, i32, %struct.jpeg_source_mgr.622*, i32, i32, i32, i32, i32, i32, i32, double, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8**, i32, i32, i32, i32, i32, [64 x i32]*, [4 x %struct.JQUANT_TBL*], [4 x %struct.JHUFF_TBL*], [4 x %struct.JHUFF_TBL*], i32, %struct.jpeg_component_info*, i32, i32, [16 x i8], [16 x i8], [16 x i8], i32, i32, i8, i16, i16, i32, i8, i32, i32, i32, i32, i32, i8*, i32, [4 x %struct.jpeg_component_info*], i32, i32, i32, [10 x i32], i32, i32, i32, i32, i32, %struct.jpeg_decomp_master.626*, %struct.jpeg_d_main_controller.627*, %struct.jpeg_d_coef_controller.628*, %struct.jpeg_d_post_controller.629*, %struct.jpeg_input_controller.630*, %struct.jpeg_marker_reader.631*, %struct.jpeg_entropy_decoder.632*, %struct.jpeg_inverse_dct.633*, %struct.jpeg_upsampler.634*, %struct.jpeg_color_deconverter.635*, %struct.jpeg_color_quantizer.636* }
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
%struct.jpeg_source_mgr.622 = type { i8*, i64, void (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*, i64)*, i32 (%struct.jpeg_decompress_struct.637*, i32)*, void (%struct.jpeg_decompress_struct.637*)* }
%struct.JQUANT_TBL = type { [64 x i16], i32 }
%struct.JHUFF_TBL = type { [17 x i8], [256 x i8], i32 }
%struct.jpeg_component_info = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.JQUANT_TBL*, i8* }
%struct.jpeg_decomp_master.626 = type { void (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*)*, i32 }
%struct.jpeg_d_main_controller.627 = type { void (%struct.jpeg_decompress_struct.637*, i32)*, void (%struct.jpeg_decompress_struct.637*, i8**, i32*, i32)* }
%struct.jpeg_d_coef_controller.628 = type { void (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*, i8***)*, %struct.jvirt_barray_control** }
%struct.jpeg_d_post_controller.629 = type { void (%struct.jpeg_decompress_struct.637*, i32)*, void (%struct.jpeg_decompress_struct.637*, i8***, i32*, i32, i8**, i32*, i32)* }
%struct.jpeg_input_controller.630 = type { i32 (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*)*, i32, i32 }
%struct.jpeg_marker_reader.631 = type { void (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*)*, [16 x i32 (%struct.jpeg_decompress_struct.637*)*], i32, i32, i32, i32 }
%struct.jpeg_entropy_decoder.632 = type { void (%struct.jpeg_decompress_struct.637*)*, i32 (%struct.jpeg_decompress_struct.637*, [64 x i16]**)* }
%struct.jpeg_inverse_dct.633 = type { void (%struct.jpeg_decompress_struct.637*)*, [10 x void (%struct.jpeg_decompress_struct.637*, %struct.jpeg_component_info*, i16*, i8**, i32)*] }
%struct.jpeg_upsampler.634 = type { void (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*, i8***, i32*, i32, i8**, i32*, i32)*, i32 }
%struct.jpeg_color_deconverter.635 = type { void (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*, i8***, i32, i8**, i32)* }
%struct.jpeg_color_quantizer.636 = type { {}*, void (%struct.jpeg_decompress_struct.637*, i8**, i8**, i32)*, void (%struct.jpeg_decompress_struct.637*)*, void (%struct.jpeg_decompress_struct.637*)* }
%struct.my_post_controller = type { %struct.jpeg_d_post_controller.629, %struct.jvirt_sarray_control*, i8**, i32, i32, i32 }

define hidden void @post_process_prepass() {
  %1 = load %struct.jpeg_decompress_struct.637*, %struct.jpeg_decompress_struct.637** undef, align 8
  %2 = load i8***, i8**** undef, align 8
  %3 = load i32*, i32** undef, align 8
  ret void
}

; Function Attrs: noinline optnone
define hidden void @post_process_2pass() #0 {
  %1 = load %struct.jvirt_sarray_control*, %struct.jvirt_sarray_control** undef, align 8
  %2 = load %struct.my_post_controller*, %struct.my_post_controller** undef, align 8
  %3 = getelementptr inbounds %struct.my_post_controller, %struct.my_post_controller* %2, i32 0, i32 4
  %4 = load i32, i32* %3, align 4
  %5 = load %struct.my_post_controller*, %struct.my_post_controller** undef, align 8
  %6 = getelementptr inbounds %struct.my_post_controller, %struct.my_post_controller* %5, i32 0, i32 3
  %7 = call i8** undef(%struct.jpeg_common_struct* undef, %struct.jvirt_sarray_control* %1, i32 %4, i32 undef, i32 0)
  %8 = load %struct.my_post_controller*, %struct.my_post_controller** undef, align 8
  ret void
}

attributes #0 = { noinline optnone }
