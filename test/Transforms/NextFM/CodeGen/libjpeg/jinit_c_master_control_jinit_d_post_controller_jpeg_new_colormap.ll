; RUN: %opt --passes='multiple-func-merging' --multiple-func-merging-disable-post-opt -func-merging-explore=2 '--multiple-func-merging-only=jinit_c_master_control' '--multiple-func-merging-only=jinit_d_post_controller' '--multiple-func-merging-only=jpeg_new_colormap' %s -o %t.opt.three.bc
; RUN: %clang %t.opt.three.bc %S/Inputs/jinit_c_master_control_jinit_d_post_controller_jpeg_new_colormap.driver.c -lm -o %t.opt.three
; RUN: %opt --passes='multiple-func-merging' --multiple-func-merging-disable-post-opt -func-merging-explore=2 '--multiple-func-merging-only=jinit_c_master_control' '--multiple-func-merging-only=jinit_d_post_controller' %s -o %t.opt.two.bc
; RUN: %clang %t.opt.two.bc %S/Inputs/jinit_c_master_control_jinit_d_post_controller_jpeg_new_colormap.driver.c -lm -o %t.opt.two
; RUN: %clang %s %S/Inputs/jinit_c_master_control_jinit_d_post_controller_jpeg_new_colormap.driver.c -lm -o %t.safe
; RUN: %t.safe
; RUN: %t.opt.two
; RUN: %t.opt.three

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.jpeg_compress_struct.3 = type { %struct.jpeg_memory_mgr*, %struct.jpeg_entropy_encoder.2* }
%struct.jpeg_memory_mgr = type { i8* (%struct.jpeg_common_struct*, i32, i64)* }
%struct.jpeg_common_struct = type { %struct.jpeg_memory_mgr* }
%struct.jpeg_entropy_encoder.2 = type { void (%struct.jpeg_compress_struct.3*, i32)*, i32 (%struct.jpeg_compress_struct.3*, [64 x i16]**)*, {}* }
%struct.jpeg_decompress_struct = type opaque
%struct.jpeg_compress_struct.7 = type { %struct.jpeg_memory_mgr*, %struct.jpeg_entropy_encoder.6* }
%struct.jpeg_entropy_encoder.6 = type { void (%struct.jpeg_compress_struct.7*, i32)*, i32 (%struct.jpeg_compress_struct.7*, [64 x i16]**)*, {}* }

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @jinit_c_master_control(%struct.jpeg_compress_struct.3* %0) #0 {
  %2 = alloca %struct.jpeg_compress_struct.3*, align 8
  store %struct.jpeg_compress_struct.3* %0, %struct.jpeg_compress_struct.3** %2, align 8
  %3 = load %struct.jpeg_compress_struct.3*, %struct.jpeg_compress_struct.3** %2, align 8
  %4 = getelementptr inbounds %struct.jpeg_compress_struct.3, %struct.jpeg_compress_struct.3* %3, i32 0, i32 0
  %5 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %4, align 8
  %6 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %5, i32 0, i32 0
  %7 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %6, align 8
  %8 = call i8* %7(%struct.jpeg_common_struct* null, i32 0, i64 4)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @jpeg_new_colormap(%struct.jpeg_decompress_struct* %0) #0 {
  %2 = alloca %struct.jpeg_decompress_struct*, align 8
  store %struct.jpeg_decompress_struct* %0, %struct.jpeg_decompress_struct** %2, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @jinit_d_post_controller(%struct.jpeg_compress_struct.7* %0) #0 {
  %2 = alloca %struct.jpeg_compress_struct.7*, align 8
  store %struct.jpeg_compress_struct.7* %0, %struct.jpeg_compress_struct.7** %2, align 8
  %3 = load %struct.jpeg_compress_struct.7*, %struct.jpeg_compress_struct.7** %2, align 8
  %4 = getelementptr inbounds %struct.jpeg_compress_struct.7, %struct.jpeg_compress_struct.7* %3, i32 0, i32 0
  %5 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %4, align 8
  %6 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %5, i32 0, i32 0
  %7 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %6, align 8
  %8 = call i8* %7(%struct.jpeg_common_struct* null, i32 0, i64 4)
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5, !6}

!0 = !{!"clang version 13.0.0 (https://github.com/llvm/llvm-project/ 24c8eaec9467b2aaf70b0db33a4e4dd415139a50)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{i32 1, !"ThinLTO", i32 0}
!6 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
