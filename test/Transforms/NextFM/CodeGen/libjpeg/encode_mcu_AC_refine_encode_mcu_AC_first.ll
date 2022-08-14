; RUN: %opt --passes='multiple-func-merging' '--multiple-func-merging-only=encode_mcu_AC_refine' '--multiple-func-merging-only=encode_mcu_AC_first' %s -o %t.opt.two.bc
; RUN: %clang %t.opt.two.bc %S/Inputs/encode_mcu_AC_refine_encode_mcu_AC_first.driver.bc -lm -o %t.opt.two
; RUN: %opt --passes='func-merging' '--func-merging-only=encode_mcu_AC_refine' '--func-merging-only=encode_mcu_AC_first' %s -o %t.opt.fm.bc
; RUN: %clang %t.opt.fm.bc %S/Inputs/encode_mcu_AC_refine_encode_mcu_AC_first.driver.bc -lm -o %t.opt.fm
; RUN: %clang %s %S/Inputs/encode_mcu_AC_refine_encode_mcu_AC_first.driver.bc -lm -o %t.safe
; RUN: timeout 1.5s %t.safe '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; RUN: timeout 1.5s %t.opt.fm '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'
; RUN: not timeout 1.5s %t.opt.two '-dct' 'int' '-progressive' '-opt' '-outfile' '/dev/null' '%S/Inputs/input_small.ppm'

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

@jpeg_natural_order = external constant [80 x i32], align 16

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
  %13 = alloca [64 x i16]*, align 8
  store %struct.jpeg_compress_struct.65* %0, %struct.jpeg_compress_struct.65** %3, align 8
  store [64 x i16]** %1, [64 x i16]*** %4, align 8
  %14 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %15 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %14, i32 0, i32 59
  %16 = load %struct.jpeg_entropy_encoder.64*, %struct.jpeg_entropy_encoder.64** %15, align 8
  %17 = bitcast %struct.jpeg_entropy_encoder.64* %16 to %struct.phuff_entropy_encoder*
  store %struct.phuff_entropy_encoder* %17, %struct.phuff_entropy_encoder** %5, align 8
  %18 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %19 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %18, i32 0, i32 48
  %20 = load i32, i32* %19, align 8
  store i32 %20, i32* %11, align 4
  %21 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %22 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %21, i32 0, i32 50
  %23 = load i32, i32* %22, align 8
  store i32 %23, i32* %12, align 4
  %24 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %25 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %24, i32 0, i32 5
  %26 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %25, align 8
  %27 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %26, i32 0, i32 0
  %28 = load i8*, i8** %27, align 8
  %29 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %30 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %29, i32 0, i32 2
  store i8* %28, i8** %30, align 8
  %31 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %32 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %31, i32 0, i32 5
  %33 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %32, align 8
  %34 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %33, i32 0, i32 1
  %35 = load i64, i64* %34, align 8
  %36 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %37 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %36, i32 0, i32 3
  store i64 %35, i64* %37, align 8
  %38 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %39 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %38, i32 0, i32 29
  %40 = load i32, i32* %39, align 8
  %41 = icmp ne i32 %40, 0
  br i1 %41, label %42, label %53

42:                                               ; preds = %2
  %43 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %44 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %43, i32 0, i32 12
  %45 = load i32, i32* %44, align 8
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %47, label %52

47:                                               ; preds = %42
  %48 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %49 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %50 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %49, i32 0, i32 13
  %51 = load i32, i32* %50, align 4
  call void @emit_restart.20(%struct.phuff_entropy_encoder* %48, i32 %51)
  br label %52

52:                                               ; preds = %47, %42
  br label %53

53:                                               ; preds = %52, %2
  %54 = load [64 x i16]**, [64 x i16]*** %4, align 8
  %55 = getelementptr inbounds [64 x i16]*, [64 x i16]** %54, i64 0
  %56 = load [64 x i16]*, [64 x i16]** %55, align 8
  store [64 x i16]* %56, [64 x i16]** %13, align 8
  store i32 0, i32* %9, align 4
  %57 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %58 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %57, i32 0, i32 47
  %59 = load i32, i32* %58, align 4
  store i32 %59, i32* %10, align 4
  br label %60

60:                                               ; preds = %138, %53
  %61 = load i32, i32* %10, align 4
  %62 = load i32, i32* %11, align 4
  %63 = icmp sle i32 %61, %62
  br i1 %63, label %64, label %141

64:                                               ; preds = %60
  %65 = load [64 x i16]*, [64 x i16]** %13, align 8
  %66 = load i32, i32* %10, align 4
  %67 = sext i32 %66 to i64
  %68 = getelementptr inbounds [0 x i32], [0 x i32]* bitcast ([80 x i32]* @jpeg_natural_order to [0 x i32]*), i64 0, i64 %67
  %69 = load i32, i32* %68, align 4
  %70 = sext i32 %69 to i64
  %71 = getelementptr inbounds [64 x i16], [64 x i16]* %65, i64 0, i64 %70
  %72 = load i16, i16* %71, align 2
  %73 = sext i16 %72 to i32
  store i32 %73, i32* %6, align 4
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %75, label %78

75:                                               ; preds = %64
  %76 = load i32, i32* %9, align 4
  %77 = add nsw i32 %76, 1
  store i32 %77, i32* %9, align 4
  br label %138

78:                                               ; preds = %64
  %79 = load i32, i32* %6, align 4
  %80 = icmp slt i32 %79, 0
  br i1 %80, label %81, label %89

81:                                               ; preds = %78
  %82 = load i32, i32* %6, align 4
  %83 = sub nsw i32 0, %82
  store i32 %83, i32* %6, align 4
  %84 = load i32, i32* %12, align 4
  %85 = load i32, i32* %6, align 4
  %86 = ashr i32 %85, %84
  store i32 %86, i32* %6, align 4
  %87 = load i32, i32* %6, align 4
  %88 = xor i32 %87, -1
  store i32 %88, i32* %7, align 4
  br label %94

89:                                               ; preds = %78
  %90 = load i32, i32* %12, align 4
  %91 = load i32, i32* %6, align 4
  %92 = ashr i32 %91, %90
  store i32 %92, i32* %6, align 4
  %93 = load i32, i32* %6, align 4
  store i32 %93, i32* %7, align 4
  br label %94

94:                                               ; preds = %89, %81
  %95 = load i32, i32* %6, align 4
  %96 = icmp eq i32 %95, 0
  br i1 %96, label %97, label %100

97:                                               ; preds = %94
  %98 = load i32, i32* %9, align 4
  %99 = add nsw i32 %98, 1
  store i32 %99, i32* %9, align 4
  br label %138

100:                                              ; preds = %94
  %101 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %102 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %101, i32 0, i32 9
  %103 = load i32, i32* %102, align 4
  %104 = icmp ugt i32 %103, 0
  br i1 %104, label %105, label %107

105:                                              ; preds = %100
  %106 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  call void @emit_eobrun(%struct.phuff_entropy_encoder* %106)
  br label %107

107:                                              ; preds = %105, %100
  br label %108

108:                                              ; preds = %111, %107
  %109 = load i32, i32* %9, align 4
  %110 = icmp sgt i32 %109, 15
  br i1 %110, label %111, label %118

111:                                              ; preds = %108
  %112 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %113 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %114 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %113, i32 0, i32 8
  %115 = load i32, i32* %114, align 8
  call void @emit_symbol(%struct.phuff_entropy_encoder* %112, i32 %115, i32 240)
  %116 = load i32, i32* %9, align 4
  %117 = sub nsw i32 %116, 16
  store i32 %117, i32* %9, align 4
  br label %108, !llvm.loop !7

118:                                              ; preds = %108
  store i32 1, i32* %8, align 4
  br label %119

119:                                              ; preds = %123, %118
  %120 = load i32, i32* %6, align 4
  %121 = ashr i32 %120, 1
  store i32 %121, i32* %6, align 4
  %122 = icmp ne i32 %121, 0
  br i1 %122, label %123, label %126

123:                                              ; preds = %119
  %124 = load i32, i32* %8, align 4
  %125 = add nsw i32 %124, 1
  store i32 %125, i32* %8, align 4
  br label %119, !llvm.loop !9

126:                                              ; preds = %119
  %127 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %128 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %129 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %128, i32 0, i32 8
  %130 = load i32, i32* %129, align 8
  %131 = load i32, i32* %9, align 4
  %132 = shl i32 %131, 4
  %133 = load i32, i32* %8, align 4
  %134 = add nsw i32 %132, %133
  call void @emit_symbol(%struct.phuff_entropy_encoder* %127, i32 %130, i32 %134)
  %135 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %136 = load i32, i32* %7, align 4
  %137 = load i32, i32* %8, align 4
  call void @emit_bits.18(%struct.phuff_entropy_encoder* %135, i32 %136, i32 %137)
  store i32 0, i32* %9, align 4
  br label %138

138:                                              ; preds = %126, %97, %75
  %139 = load i32, i32* %10, align 4
  %140 = add nsw i32 %139, 1
  store i32 %140, i32* %10, align 4
  br label %60, !llvm.loop !10

141:                                              ; preds = %60
  %142 = load i32, i32* %9, align 4
  %143 = icmp sgt i32 %142, 0
  br i1 %143, label %144, label %156

144:                                              ; preds = %141
  %145 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %146 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %145, i32 0, i32 9
  %147 = load i32, i32* %146, align 4
  %148 = add i32 %147, 1
  store i32 %148, i32* %146, align 4
  %149 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %150 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %149, i32 0, i32 9
  %151 = load i32, i32* %150, align 4
  %152 = icmp eq i32 %151, 32767
  br i1 %152, label %153, label %155

153:                                              ; preds = %144
  %154 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  call void @emit_eobrun(%struct.phuff_entropy_encoder* %154)
  br label %155

155:                                              ; preds = %153, %144
  br label %156

156:                                              ; preds = %155, %141
  %157 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %158 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %157, i32 0, i32 2
  %159 = load i8*, i8** %158, align 8
  %160 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %161 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %160, i32 0, i32 5
  %162 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %161, align 8
  %163 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %162, i32 0, i32 0
  store i8* %159, i8** %163, align 8
  %164 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %165 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %164, i32 0, i32 3
  %166 = load i64, i64* %165, align 8
  %167 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %168 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %167, i32 0, i32 5
  %169 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %168, align 8
  %170 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %169, i32 0, i32 1
  store i64 %166, i64* %170, align 8
  %171 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %172 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %171, i32 0, i32 29
  %173 = load i32, i32* %172, align 8
  %174 = icmp ne i32 %173, 0
  br i1 %174, label %175, label %199

175:                                              ; preds = %156
  %176 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %177 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %176, i32 0, i32 12
  %178 = load i32, i32* %177, align 8
  %179 = icmp eq i32 %178, 0
  br i1 %179, label %180, label %194

180:                                              ; preds = %175
  %181 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %182 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %181, i32 0, i32 29
  %183 = load i32, i32* %182, align 8
  %184 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %185 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %184, i32 0, i32 12
  store i32 %183, i32* %185, align 8
  %186 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %187 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %186, i32 0, i32 13
  %188 = load i32, i32* %187, align 4
  %189 = add nsw i32 %188, 1
  store i32 %189, i32* %187, align 4
  %190 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %191 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %190, i32 0, i32 13
  %192 = load i32, i32* %191, align 4
  %193 = and i32 %192, 7
  store i32 %193, i32* %191, align 4
  br label %194

194:                                              ; preds = %180, %175
  %195 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %196 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %195, i32 0, i32 12
  %197 = load i32, i32* %196, align 8
  %198 = add i32 %197, -1
  store i32 %198, i32* %196, align 8
  br label %199

199:                                              ; preds = %194, %156
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
  %26 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %27 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %26, i32 0, i32 5
  %28 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %27, align 8
  %29 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %28, i32 0, i32 0
  %30 = load i8*, i8** %29, align 8
  %31 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %32 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %31, i32 0, i32 2
  store i8* %30, i8** %32, align 8
  %33 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %34 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %33, i32 0, i32 5
  %35 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %34, align 8
  %36 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %35, i32 0, i32 1
  %37 = load i64, i64* %36, align 8
  %38 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %39 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %38, i32 0, i32 3
  store i64 %37, i64* %39, align 8
  %40 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %41 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %40, i32 0, i32 29
  %42 = load i32, i32* %41, align 8
  %43 = icmp ne i32 %42, 0
  br i1 %43, label %44, label %55

44:                                               ; preds = %2
  %45 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %46 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %45, i32 0, i32 12
  %47 = load i32, i32* %46, align 8
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %49, label %54

49:                                               ; preds = %44
  %50 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %51 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %52 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %51, i32 0, i32 13
  %53 = load i32, i32* %52, align 4
  call void @emit_restart.20(%struct.phuff_entropy_encoder* %50, i32 %53)
  br label %54

54:                                               ; preds = %49, %44
  br label %55

55:                                               ; preds = %54, %2
  %56 = load [64 x i16]**, [64 x i16]*** %4, align 8
  %57 = getelementptr inbounds [64 x i16]*, [64 x i16]** %56, i64 0
  %58 = load [64 x i16]*, [64 x i16]** %57, align 8
  store [64 x i16]* %58, [64 x i16]** %14, align 8
  store i32 0, i32* %9, align 4
  %59 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %60 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %59, i32 0, i32 47
  %61 = load i32, i32* %60, align 4
  store i32 %61, i32* %8, align 4
  br label %62

62:                                               ; preds = %94, %55
  %63 = load i32, i32* %8, align 4
  %64 = load i32, i32* %12, align 4
  %65 = icmp sle i32 %63, %64
  br i1 %65, label %66, label %97

66:                                               ; preds = %62
  %67 = load [64 x i16]*, [64 x i16]** %14, align 8
  %68 = load i32, i32* %8, align 4
  %69 = sext i32 %68 to i64
  %70 = getelementptr inbounds [0 x i32], [0 x i32]* bitcast ([80 x i32]* @jpeg_natural_order to [0 x i32]*), i64 0, i64 %69
  %71 = load i32, i32* %70, align 4
  %72 = sext i32 %71 to i64
  %73 = getelementptr inbounds [64 x i16], [64 x i16]* %67, i64 0, i64 %72
  %74 = load i16, i16* %73, align 2
  %75 = sext i16 %74 to i32
  store i32 %75, i32* %6, align 4
  %76 = load i32, i32* %6, align 4
  %77 = icmp slt i32 %76, 0
  br i1 %77, label %78, label %81

78:                                               ; preds = %66
  %79 = load i32, i32* %6, align 4
  %80 = sub nsw i32 0, %79
  store i32 %80, i32* %6, align 4
  br label %81

81:                                               ; preds = %78, %66
  %82 = load i32, i32* %13, align 4
  %83 = load i32, i32* %6, align 4
  %84 = ashr i32 %83, %82
  store i32 %84, i32* %6, align 4
  %85 = load i32, i32* %6, align 4
  %86 = load i32, i32* %8, align 4
  %87 = sext i32 %86 to i64
  %88 = getelementptr inbounds [64 x i32], [64 x i32]* %15, i64 0, i64 %87
  store i32 %85, i32* %88, align 4
  %89 = load i32, i32* %6, align 4
  %90 = icmp eq i32 %89, 1
  br i1 %90, label %91, label %93

91:                                               ; preds = %81
  %92 = load i32, i32* %8, align 4
  store i32 %92, i32* %9, align 4
  br label %93

93:                                               ; preds = %91, %81
  br label %94

94:                                               ; preds = %93
  %95 = load i32, i32* %8, align 4
  %96 = add nsw i32 %95, 1
  store i32 %96, i32* %8, align 4
  br label %62, !llvm.loop !11

97:                                               ; preds = %62
  store i32 0, i32* %7, align 4
  store i32 0, i32* %11, align 4
  %98 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %99 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %98, i32 0, i32 11
  %100 = load i8*, i8** %99, align 8
  %101 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %102 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %101, i32 0, i32 10
  %103 = load i32, i32* %102, align 8
  %104 = zext i32 %103 to i64
  %105 = getelementptr inbounds i8, i8* %100, i64 %104
  store i8* %105, i8** %10, align 8
  %106 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %107 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %106, i32 0, i32 47
  %108 = load i32, i32* %107, align 4
  store i32 %108, i32* %8, align 4
  br label %109

109:                                              ; preds = %187, %97
  %110 = load i32, i32* %8, align 4
  %111 = load i32, i32* %12, align 4
  %112 = icmp sle i32 %110, %111
  br i1 %112, label %113, label %190

113:                                              ; preds = %109
  %114 = load i32, i32* %8, align 4
  %115 = sext i32 %114 to i64
  %116 = getelementptr inbounds [64 x i32], [64 x i32]* %15, i64 0, i64 %115
  %117 = load i32, i32* %116, align 4
  store i32 %117, i32* %6, align 4
  %118 = icmp eq i32 %117, 0
  br i1 %118, label %119, label %122

119:                                              ; preds = %113
  %120 = load i32, i32* %7, align 4
  %121 = add nsw i32 %120, 1
  store i32 %121, i32* %7, align 4
  br label %187

122:                                              ; preds = %113
  br label %123

123:                                              ; preds = %132, %122
  %124 = load i32, i32* %7, align 4
  %125 = icmp sgt i32 %124, 15
  br i1 %125, label %126, label %130

126:                                              ; preds = %123
  %127 = load i32, i32* %8, align 4
  %128 = load i32, i32* %9, align 4
  %129 = icmp sle i32 %127, %128
  br label %130

130:                                              ; preds = %126, %123
  %131 = phi i1 [ false, %123 ], [ %129, %126 ]
  br i1 %131, label %132, label %146

132:                                              ; preds = %130
  %133 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  call void @emit_eobrun(%struct.phuff_entropy_encoder* %133)
  %134 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %135 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %136 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %135, i32 0, i32 8
  %137 = load i32, i32* %136, align 8
  call void @emit_symbol(%struct.phuff_entropy_encoder* %134, i32 %137, i32 240)
  %138 = load i32, i32* %7, align 4
  %139 = sub nsw i32 %138, 16
  store i32 %139, i32* %7, align 4
  %140 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %141 = load i8*, i8** %10, align 8
  %142 = load i32, i32* %11, align 4
  call void @emit_buffered_bits(%struct.phuff_entropy_encoder* %140, i8* %141, i32 %142)
  %143 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %144 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %143, i32 0, i32 11
  %145 = load i8*, i8** %144, align 8
  store i8* %145, i8** %10, align 8
  store i32 0, i32* %11, align 4
  br label %123, !llvm.loop !12

146:                                              ; preds = %130
  %147 = load i32, i32* %6, align 4
  %148 = icmp sgt i32 %147, 1
  br i1 %148, label %149, label %158

149:                                              ; preds = %146
  %150 = load i32, i32* %6, align 4
  %151 = and i32 %150, 1
  %152 = trunc i32 %151 to i8
  %153 = load i8*, i8** %10, align 8
  %154 = load i32, i32* %11, align 4
  %155 = add i32 %154, 1
  store i32 %155, i32* %11, align 4
  %156 = zext i32 %154 to i64
  %157 = getelementptr inbounds i8, i8* %153, i64 %156
  store i8 %152, i8* %157, align 1
  br label %187

158:                                              ; preds = %146
  %159 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  call void @emit_eobrun(%struct.phuff_entropy_encoder* %159)
  %160 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %161 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %162 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %161, i32 0, i32 8
  %163 = load i32, i32* %162, align 8
  %164 = load i32, i32* %7, align 4
  %165 = shl i32 %164, 4
  %166 = add nsw i32 %165, 1
  call void @emit_symbol(%struct.phuff_entropy_encoder* %160, i32 %163, i32 %166)
  %167 = load [64 x i16]*, [64 x i16]** %14, align 8
  %168 = load i32, i32* %8, align 4
  %169 = sext i32 %168 to i64
  %170 = getelementptr inbounds [0 x i32], [0 x i32]* bitcast ([80 x i32]* @jpeg_natural_order to [0 x i32]*), i64 0, i64 %169
  %171 = load i32, i32* %170, align 4
  %172 = sext i32 %171 to i64
  %173 = getelementptr inbounds [64 x i16], [64 x i16]* %167, i64 0, i64 %172
  %174 = load i16, i16* %173, align 2
  %175 = sext i16 %174 to i32
  %176 = icmp slt i32 %175, 0
  %177 = zext i1 %176 to i64
  %178 = select i1 %176, i32 0, i32 1
  store i32 %178, i32* %6, align 4
  %179 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %180 = load i32, i32* %6, align 4
  call void @emit_bits.18(%struct.phuff_entropy_encoder* %179, i32 %180, i32 1)
  %181 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %182 = load i8*, i8** %10, align 8
  %183 = load i32, i32* %11, align 4
  call void @emit_buffered_bits(%struct.phuff_entropy_encoder* %181, i8* %182, i32 %183)
  %184 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %185 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %184, i32 0, i32 11
  %186 = load i8*, i8** %185, align 8
  store i8* %186, i8** %10, align 8
  store i32 0, i32* %11, align 4
  store i32 0, i32* %7, align 4
  br label %187

187:                                              ; preds = %158, %149, %119
  %188 = load i32, i32* %8, align 4
  %189 = add nsw i32 %188, 1
  store i32 %189, i32* %8, align 4
  br label %109, !llvm.loop !13

190:                                              ; preds = %109
  %191 = load i32, i32* %7, align 4
  %192 = icmp sgt i32 %191, 0
  br i1 %192, label %196, label %193

193:                                              ; preds = %190
  %194 = load i32, i32* %11, align 4
  %195 = icmp ugt i32 %194, 0
  br i1 %195, label %196, label %218

196:                                              ; preds = %193, %190
  %197 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %198 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %197, i32 0, i32 9
  %199 = load i32, i32* %198, align 4
  %200 = add i32 %199, 1
  store i32 %200, i32* %198, align 4
  %201 = load i32, i32* %11, align 4
  %202 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %203 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %202, i32 0, i32 10
  %204 = load i32, i32* %203, align 8
  %205 = add i32 %204, %201
  store i32 %205, i32* %203, align 8
  %206 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %207 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %206, i32 0, i32 9
  %208 = load i32, i32* %207, align 4
  %209 = icmp eq i32 %208, 32767
  br i1 %209, label %215, label %210

210:                                              ; preds = %196
  %211 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %212 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %211, i32 0, i32 10
  %213 = load i32, i32* %212, align 8
  %214 = icmp ugt i32 %213, 937
  br i1 %214, label %215, label %217

215:                                              ; preds = %210, %196
  %216 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  call void @emit_eobrun(%struct.phuff_entropy_encoder* %216)
  br label %217

217:                                              ; preds = %215, %210
  br label %218

218:                                              ; preds = %217, %193
  %219 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %220 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %219, i32 0, i32 2
  %221 = load i8*, i8** %220, align 8
  %222 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %223 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %222, i32 0, i32 5
  %224 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %223, align 8
  %225 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %224, i32 0, i32 0
  store i8* %221, i8** %225, align 8
  %226 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %227 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %226, i32 0, i32 3
  %228 = load i64, i64* %227, align 8
  %229 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %230 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %229, i32 0, i32 5
  %231 = load %struct.jpeg_destination_mgr.51*, %struct.jpeg_destination_mgr.51** %230, align 8
  %232 = getelementptr inbounds %struct.jpeg_destination_mgr.51, %struct.jpeg_destination_mgr.51* %231, i32 0, i32 1
  store i64 %228, i64* %232, align 8
  %233 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %234 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %233, i32 0, i32 29
  %235 = load i32, i32* %234, align 8
  %236 = icmp ne i32 %235, 0
  br i1 %236, label %237, label %261

237:                                              ; preds = %218
  %238 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %239 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %238, i32 0, i32 12
  %240 = load i32, i32* %239, align 8
  %241 = icmp eq i32 %240, 0
  br i1 %241, label %242, label %256

242:                                              ; preds = %237
  %243 = load %struct.jpeg_compress_struct.65*, %struct.jpeg_compress_struct.65** %3, align 8
  %244 = getelementptr inbounds %struct.jpeg_compress_struct.65, %struct.jpeg_compress_struct.65* %243, i32 0, i32 29
  %245 = load i32, i32* %244, align 8
  %246 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %247 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %246, i32 0, i32 12
  store i32 %245, i32* %247, align 8
  %248 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %249 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %248, i32 0, i32 13
  %250 = load i32, i32* %249, align 4
  %251 = add nsw i32 %250, 1
  store i32 %251, i32* %249, align 4
  %252 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %253 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %252, i32 0, i32 13
  %254 = load i32, i32* %253, align 4
  %255 = and i32 %254, 7
  store i32 %255, i32* %253, align 4
  br label %256

256:                                              ; preds = %242, %237
  %257 = load %struct.phuff_entropy_encoder*, %struct.phuff_entropy_encoder** %5, align 8
  %258 = getelementptr inbounds %struct.phuff_entropy_encoder, %struct.phuff_entropy_encoder* %257, i32 0, i32 12
  %259 = load i32, i32* %258, align 8
  %260 = add i32 %259, -1
  store i32 %260, i32* %258, align 8
  br label %261

261:                                              ; preds = %256, %218
  ret i32 1
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_eobrun(%struct.phuff_entropy_encoder*) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_bits.18(%struct.phuff_entropy_encoder*, i32, i32) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_symbol(%struct.phuff_entropy_encoder*, i32, i32) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_buffered_bits(%struct.phuff_entropy_encoder*, i8*, i32) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden void @emit_restart.20(%struct.phuff_entropy_encoder*, i32) #0

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
!13 = distinct !{!13, !8}
