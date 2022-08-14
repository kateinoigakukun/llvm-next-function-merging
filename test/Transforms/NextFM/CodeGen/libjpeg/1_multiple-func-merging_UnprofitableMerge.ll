; Generated from multiple-func-merging:UnprofitableMerge
; - read_quant_tables
; - read_scan_script

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK-NOT: --- !Missed

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

@.str.101 = external hidden unnamed_addr constant [2 x i8], align 1
@stderr = external global %struct._IO_FILE*, align 8
@.str.1.102 = external hidden unnamed_addr constant [26 x i8], align 1
@.str.2.103 = external hidden unnamed_addr constant [28 x i8], align 1
@.str.3.104 = external hidden unnamed_addr constant [31 x i8], align 1
@.str.4.105 = external hidden unnamed_addr constant [29 x i8], align 1
@.str.5.108 = external hidden unnamed_addr constant [36 x i8], align 1
@.str.6.109 = external hidden unnamed_addr constant [35 x i8], align 1
@.str.7.110 = external hidden unnamed_addr constant [44 x i8], align 1
@.str.8.111 = external hidden unnamed_addr constant [38 x i8], align 1

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #0

declare %struct._IO_FILE* @fopen(i8*, i8*) #0

declare i32 @fclose(%struct._IO_FILE*) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @read_quant_tables(%struct.jpeg_compress_struct* %0, i8* %1, i32 %2, i32 %3) #1 {
  %5 = alloca i32, align 4
  %6 = alloca %struct.jpeg_compress_struct*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct._IO_FILE*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i64, align 8
  %15 = alloca [64 x i32], align 16
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %6, align 8
  store i8* %1, i8** %7, align 8
  store i32 %2, i32* %8, align 4
  store i32 %3, i32* %9, align 4
  %16 = load i8*, i8** %7, align 8
  %17 = call %struct._IO_FILE* @fopen(i8* %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.101, i64 0, i64 0))
  store %struct._IO_FILE* %17, %struct._IO_FILE** %10, align 8
  %18 = icmp eq %struct._IO_FILE* %17, null
  br i1 %18, label %19, label %23

19:                                               ; preds = %4
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %21 = load i8*, i8** %7, align 8
  %22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.1.102, i64 0, i64 0), i8* %21)
  store i32 0, i32* %5, align 4
  br label %83

23:                                               ; preds = %4
  store i32 0, i32* %11, align 4
  br label %24

24:                                               ; preds = %63, %23
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8
  %26 = call i32 @read_text_integer(%struct._IO_FILE* %25, i64* %14, i32* %13)
  %27 = icmp ne i32 %26, 0
  br i1 %27, label %28, label %71

28:                                               ; preds = %24
  %29 = load i32, i32* %11, align 4
  %30 = icmp sge i32 %29, 4
  br i1 %30, label %31, label %37

31:                                               ; preds = %28
  %32 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %33 = load i8*, i8** %7, align 8
  %34 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %32, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.2.103, i64 0, i64 0), i8* %33)
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8
  %36 = call i32 @fclose(%struct._IO_FILE* %35)
  store i32 0, i32* %5, align 4
  br label %83

37:                                               ; preds = %28
  %38 = load i64, i64* %14, align 8
  %39 = trunc i64 %38 to i32
  %40 = getelementptr inbounds [64 x i32], [64 x i32]* %15, i64 0, i64 0
  store i32 %39, i32* %40, align 16
  store i32 1, i32* %12, align 4
  br label %41

41:                                               ; preds = %60, %37
  %42 = load i32, i32* %12, align 4
  %43 = icmp slt i32 %42, 64
  br i1 %43, label %44, label %63

44:                                               ; preds = %41
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8
  %46 = call i32 @read_text_integer(%struct._IO_FILE* %45, i64* %14, i32* %13)
  %47 = icmp ne i32 %46, 0
  br i1 %47, label %54, label %48

48:                                               ; preds = %44
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %50 = load i8*, i8** %7, align 8
  %51 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.3.104, i64 0, i64 0), i8* %50)
  %52 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8
  %53 = call i32 @fclose(%struct._IO_FILE* %52)
  store i32 0, i32* %5, align 4
  br label %83

54:                                               ; preds = %44
  %55 = load i64, i64* %14, align 8
  %56 = trunc i64 %55 to i32
  %57 = load i32, i32* %12, align 4
  %58 = sext i32 %57 to i64
  %59 = getelementptr inbounds [64 x i32], [64 x i32]* %15, i64 0, i64 %58
  store i32 %56, i32* %59, align 4
  br label %60

60:                                               ; preds = %54
  %61 = load i32, i32* %12, align 4
  %62 = add nsw i32 %61, 1
  store i32 %62, i32* %12, align 4
  br label %41, !llvm.loop !7

63:                                               ; preds = %41
  %64 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %6, align 8
  %65 = load i32, i32* %11, align 4
  %66 = getelementptr inbounds [64 x i32], [64 x i32]* %15, i64 0, i64 0
  %67 = load i32, i32* %8, align 4
  %68 = load i32, i32* %9, align 4
  call void @jpeg_add_quant_table(%struct.jpeg_compress_struct* %64, i32 %65, i32* %66, i32 %67, i32 %68)
  %69 = load i32, i32* %11, align 4
  %70 = add nsw i32 %69, 1
  store i32 %70, i32* %11, align 4
  br label %24, !llvm.loop !9

71:                                               ; preds = %24
  %72 = load i32, i32* %13, align 4
  %73 = icmp ne i32 %72, -1
  br i1 %73, label %74, label %80

74:                                               ; preds = %71
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %76 = load i8*, i8** %7, align 8
  %77 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %75, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.4.105, i64 0, i64 0), i8* %76)
  %78 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8
  %79 = call i32 @fclose(%struct._IO_FILE* %78)
  store i32 0, i32* %5, align 4
  br label %83

80:                                               ; preds = %71
  %81 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8
  %82 = call i32 @fclose(%struct._IO_FILE* %81)
  store i32 1, i32* %5, align 4
  br label %83

83:                                               ; preds = %80, %74, %48, %31, %19
  %84 = load i32, i32* %5, align 4
  ret i32 %84
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @read_text_integer(%struct._IO_FILE*, i64*, i32*) #1

declare void @jpeg_add_quant_table(%struct.jpeg_compress_struct*, i32, i32*, i32, i32) #0

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @read_scan_script(%struct.jpeg_compress_struct* %0, i8* %1) #1 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.jpeg_compress_struct*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca %struct._IO_FILE*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  %11 = alloca %struct.jpeg_scan_info*, align 8
  %12 = alloca [100 x %struct.jpeg_scan_info], align 16
  store %struct.jpeg_compress_struct* %0, %struct.jpeg_compress_struct** %4, align 8
  store i8* %1, i8** %5, align 8
  %13 = load i8*, i8** %5, align 8
  %14 = call %struct._IO_FILE* @fopen(i8* %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.101, i64 0, i64 0))
  store %struct._IO_FILE* %14, %struct._IO_FILE** %6, align 8
  %15 = icmp eq %struct._IO_FILE* %14, null
  br i1 %15, label %16, label %20

16:                                               ; preds = %2
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %18 = load i8*, i8** %5, align 8
  %19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.5.108, i64 0, i64 0), i8* %18)
  store i32 0, i32* %3, align 4
  br label %188

20:                                               ; preds = %2
  %21 = getelementptr inbounds [100 x %struct.jpeg_scan_info], [100 x %struct.jpeg_scan_info]* %12, i64 0, i64 0
  store %struct.jpeg_scan_info* %21, %struct.jpeg_scan_info** %11, align 8
  store i32 0, i32* %7, align 4
  br label %22

22:                                               ; preds = %142, %20
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %24 = call i32 @read_scan_integer(%struct._IO_FILE* %23, i64* %10, i32* %9)
  %25 = icmp ne i32 %24, 0
  br i1 %25, label %26, label %147

26:                                               ; preds = %22
  %27 = load i32, i32* %7, align 4
  %28 = icmp sge i32 %27, 100
  br i1 %28, label %29, label %35

29:                                               ; preds = %26
  %30 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %31 = load i8*, i8** %5, align 8
  %32 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.6.109, i64 0, i64 0), i8* %31)
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %34 = call i32 @fclose(%struct._IO_FILE* %33)
  store i32 0, i32* %3, align 4
  br label %188

35:                                               ; preds = %26
  %36 = load i64, i64* %10, align 8
  %37 = trunc i64 %36 to i32
  %38 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %39 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %38, i32 0, i32 1
  %40 = getelementptr inbounds [4 x i32], [4 x i32]* %39, i64 0, i64 0
  store i32 %37, i32* %40, align 4
  store i32 1, i32* %8, align 4
  br label %41

41:                                               ; preds = %58, %35
  %42 = load i32, i32* %9, align 4
  %43 = icmp eq i32 %42, 32
  br i1 %43, label %44, label %68

44:                                               ; preds = %41
  %45 = load i32, i32* %8, align 4
  %46 = icmp sge i32 %45, 4
  br i1 %46, label %47, label %53

47:                                               ; preds = %44
  %48 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %49 = load i8*, i8** %5, align 8
  %50 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %48, i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.7.110, i64 0, i64 0), i8* %49)
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %52 = call i32 @fclose(%struct._IO_FILE* %51)
  store i32 0, i32* %3, align 4
  br label %188

53:                                               ; preds = %44
  %54 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %55 = call i32 @read_scan_integer(%struct._IO_FILE* %54, i64* %10, i32* %9)
  %56 = icmp ne i32 %55, 0
  br i1 %56, label %58, label %57

57:                                               ; preds = %53
  br label %136

58:                                               ; preds = %53
  %59 = load i64, i64* %10, align 8
  %60 = trunc i64 %59 to i32
  %61 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %62 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %61, i32 0, i32 1
  %63 = load i32, i32* %8, align 4
  %64 = sext i32 %63 to i64
  %65 = getelementptr inbounds [4 x i32], [4 x i32]* %62, i64 0, i64 %64
  store i32 %60, i32* %65, align 4
  %66 = load i32, i32* %8, align 4
  %67 = add nsw i32 %66, 1
  store i32 %67, i32* %8, align 4
  br label %41, !llvm.loop !10

68:                                               ; preds = %41
  %69 = load i32, i32* %8, align 4
  %70 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %71 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %70, i32 0, i32 0
  store i32 %69, i32* %71, align 4
  %72 = load i32, i32* %9, align 4
  %73 = icmp eq i32 %72, 58
  br i1 %73, label %74, label %120

74:                                               ; preds = %68
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %76 = call i32 @read_scan_integer(%struct._IO_FILE* %75, i64* %10, i32* %9)
  %77 = icmp ne i32 %76, 0
  br i1 %77, label %78, label %81

78:                                               ; preds = %74
  %79 = load i32, i32* %9, align 4
  %80 = icmp ne i32 %79, 32
  br i1 %80, label %81, label %82

81:                                               ; preds = %78, %74
  br label %136

82:                                               ; preds = %78
  %83 = load i64, i64* %10, align 8
  %84 = trunc i64 %83 to i32
  %85 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %86 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %85, i32 0, i32 2
  store i32 %84, i32* %86, align 4
  %87 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %88 = call i32 @read_scan_integer(%struct._IO_FILE* %87, i64* %10, i32* %9)
  %89 = icmp ne i32 %88, 0
  br i1 %89, label %90, label %93

90:                                               ; preds = %82
  %91 = load i32, i32* %9, align 4
  %92 = icmp ne i32 %91, 32
  br i1 %92, label %93, label %94

93:                                               ; preds = %90, %82
  br label %136

94:                                               ; preds = %90
  %95 = load i64, i64* %10, align 8
  %96 = trunc i64 %95 to i32
  %97 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %98 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %97, i32 0, i32 3
  store i32 %96, i32* %98, align 4
  %99 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %100 = call i32 @read_scan_integer(%struct._IO_FILE* %99, i64* %10, i32* %9)
  %101 = icmp ne i32 %100, 0
  br i1 %101, label %102, label %105

102:                                              ; preds = %94
  %103 = load i32, i32* %9, align 4
  %104 = icmp ne i32 %103, 32
  br i1 %104, label %105, label %106

105:                                              ; preds = %102, %94
  br label %136

106:                                              ; preds = %102
  %107 = load i64, i64* %10, align 8
  %108 = trunc i64 %107 to i32
  %109 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %110 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %109, i32 0, i32 4
  store i32 %108, i32* %110, align 4
  %111 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %112 = call i32 @read_scan_integer(%struct._IO_FILE* %111, i64* %10, i32* %9)
  %113 = icmp ne i32 %112, 0
  br i1 %113, label %115, label %114

114:                                              ; preds = %106
  br label %136

115:                                              ; preds = %106
  %116 = load i64, i64* %10, align 8
  %117 = trunc i64 %116 to i32
  %118 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %119 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %118, i32 0, i32 5
  store i32 %117, i32* %119, align 4
  br label %129

120:                                              ; preds = %68
  %121 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %122 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %121, i32 0, i32 2
  store i32 0, i32* %122, align 4
  %123 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %124 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %123, i32 0, i32 3
  store i32 63, i32* %124, align 4
  %125 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %126 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %125, i32 0, i32 4
  store i32 0, i32* %126, align 4
  %127 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %128 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %127, i32 0, i32 5
  store i32 0, i32* %128, align 4
  br label %129

129:                                              ; preds = %120, %115
  %130 = load i32, i32* %9, align 4
  %131 = icmp ne i32 %130, 59
  br i1 %131, label %132, label %142

132:                                              ; preds = %129
  %133 = load i32, i32* %9, align 4
  %134 = icmp ne i32 %133, -1
  br i1 %134, label %135, label %142

135:                                              ; preds = %132
  br label %136

136:                                              ; preds = %135, %114, %105, %93, %81, %57
  %137 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %138 = load i8*, i8** %5, align 8
  %139 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %137, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.8.111, i64 0, i64 0), i8* %138)
  %140 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %141 = call i32 @fclose(%struct._IO_FILE* %140)
  store i32 0, i32* %3, align 4
  br label %188

142:                                              ; preds = %132, %129
  %143 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %144 = getelementptr inbounds %struct.jpeg_scan_info, %struct.jpeg_scan_info* %143, i32 1
  store %struct.jpeg_scan_info* %144, %struct.jpeg_scan_info** %11, align 8
  %145 = load i32, i32* %7, align 4
  %146 = add nsw i32 %145, 1
  store i32 %146, i32* %7, align 4
  br label %22, !llvm.loop !11

147:                                              ; preds = %22
  %148 = load i32, i32* %9, align 4
  %149 = icmp ne i32 %148, -1
  br i1 %149, label %150, label %156

150:                                              ; preds = %147
  %151 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %152 = load i8*, i8** %5, align 8
  %153 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %151, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.4.105, i64 0, i64 0), i8* %152)
  %154 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %155 = call i32 @fclose(%struct._IO_FILE* %154)
  store i32 0, i32* %3, align 4
  br label %188

156:                                              ; preds = %147
  %157 = load i32, i32* %7, align 4
  %158 = icmp sgt i32 %157, 0
  br i1 %158, label %159, label %185

159:                                              ; preds = %156
  %160 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %161 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %160, i32 0, i32 1
  %162 = load %struct.jpeg_memory_mgr*, %struct.jpeg_memory_mgr** %161, align 8
  %163 = getelementptr inbounds %struct.jpeg_memory_mgr, %struct.jpeg_memory_mgr* %162, i32 0, i32 0
  %164 = load i8* (%struct.jpeg_common_struct*, i32, i64)*, i8* (%struct.jpeg_common_struct*, i32, i64)** %163, align 8
  %165 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %166 = bitcast %struct.jpeg_compress_struct* %165 to %struct.jpeg_common_struct*
  %167 = load i32, i32* %7, align 4
  %168 = sext i32 %167 to i64
  %169 = mul i64 %168, 36
  %170 = call i8* %164(%struct.jpeg_common_struct* %166, i32 1, i64 %169)
  %171 = bitcast i8* %170 to %struct.jpeg_scan_info*
  store %struct.jpeg_scan_info* %171, %struct.jpeg_scan_info** %11, align 8
  %172 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %173 = bitcast %struct.jpeg_scan_info* %172 to i8*
  %174 = getelementptr inbounds [100 x %struct.jpeg_scan_info], [100 x %struct.jpeg_scan_info]* %12, i64 0, i64 0
  %175 = bitcast %struct.jpeg_scan_info* %174 to i8*
  %176 = load i32, i32* %7, align 4
  %177 = sext i32 %176 to i64
  %178 = mul i64 %177, 36
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %173, i8* align 16 %175, i64 %178, i1 false)
  %179 = load %struct.jpeg_scan_info*, %struct.jpeg_scan_info** %11, align 8
  %180 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %181 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %180, i32 0, i32 22
  store %struct.jpeg_scan_info* %179, %struct.jpeg_scan_info** %181, align 8
  %182 = load i32, i32* %7, align 4
  %183 = load %struct.jpeg_compress_struct*, %struct.jpeg_compress_struct** %4, align 8
  %184 = getelementptr inbounds %struct.jpeg_compress_struct, %struct.jpeg_compress_struct* %183, i32 0, i32 21
  store i32 %182, i32* %184, align 8
  br label %185

185:                                              ; preds = %159, %156
  %186 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8
  %187 = call i32 @fclose(%struct._IO_FILE* %186)
  store i32 1, i32* %3, align 4
  br label %188

188:                                              ; preds = %185, %150, %136, %47, %29, %16
  %189 = load i32, i32* %3, align 4
  ret i32 %189
}

; Function Attrs: noinline nounwind optnone ssp uwtable
declare hidden i32 @read_scan_integer(%struct._IO_FILE*, i64*, i32*) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

attributes #0 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nounwind willreturn }

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
