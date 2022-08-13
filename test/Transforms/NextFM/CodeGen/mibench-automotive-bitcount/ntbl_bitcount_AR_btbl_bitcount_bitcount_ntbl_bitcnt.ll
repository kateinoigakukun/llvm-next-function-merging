; RUN: %opt %s -S --passes=multiple-func-merging --func-merging-explore=4 \
; RUN:   --multiple-func-merging-only=ntbl_bitcount \
; RUN:   --multiple-func-merging-only=AR_btbl_bitcount \
; RUN:   --multiple-func-merging-only=bitcount \
; RUN:   --multiple-func-merging-only=ntbl_bitcnt | not FileCheck %s

; CHECK-LABEL: define internal i32 @__msa_merge_ntbl_bitcount_AR_btbl_bitcount_bitcount_ntbl_bitcnt(i2 %discriminator, i64 %m.0.0.0.0) 
; CHECK-NEXT:  entry:
; CHECK-NEXT:    unreachable
; CHECK-NEXT:  }


target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@bits = external hidden global [256 x i8], align 16
@bits.1 = external hidden global [256 x i8], align 16

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @bitcount(i64 %0) #0 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  %3 = load i64, i64* %2, align 8
  %4 = and i64 %3, 2863311530
  %5 = ashr i64 %4, 1
  %6 = load i64, i64* %2, align 8
  %7 = and i64 %6, 1431655765
  %8 = add nsw i64 %5, %7
  store i64 %8, i64* %2, align 8
  %9 = load i64, i64* %2, align 8
  %10 = and i64 %9, 3435973836
  %11 = ashr i64 %10, 2
  %12 = load i64, i64* %2, align 8
  %13 = and i64 %12, 858993459
  %14 = add nsw i64 %11, %13
  store i64 %14, i64* %2, align 8
  %15 = load i64, i64* %2, align 8
  %16 = and i64 %15, 4042322160
  %17 = ashr i64 %16, 4
  %18 = load i64, i64* %2, align 8
  %19 = and i64 %18, 252645135
  %20 = add nsw i64 %17, %19
  store i64 %20, i64* %2, align 8
  %21 = load i64, i64* %2, align 8
  %22 = and i64 %21, 4278255360
  %23 = ashr i64 %22, 8
  %24 = load i64, i64* %2, align 8
  %25 = and i64 %24, 16711935
  %26 = add nsw i64 %23, %25
  store i64 %26, i64* %2, align 8
  %27 = load i64, i64* %2, align 8
  %28 = and i64 %27, 4294901760
  %29 = ashr i64 %28, 16
  %30 = load i64, i64* %2, align 8
  %31 = and i64 %30, 65535
  %32 = add nsw i64 %29, %31
  store i64 %32, i64* %2, align 8
  %33 = load i64, i64* %2, align 8
  %34 = trunc i64 %33 to i32
  ret i32 %34
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ntbl_bitcount(i64 %0) #0 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  %3 = load i64, i64* %2, align 8
  %4 = and i64 %3, 15
  %5 = trunc i64 %4 to i32
  %6 = sext i32 %5 to i64
  %7 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %6
  %8 = load i8, i8* %7, align 1
  %9 = sext i8 %8 to i32
  %10 = load i64, i64* %2, align 8
  %11 = and i64 %10, 240
  %12 = lshr i64 %11, 4
  %13 = trunc i64 %12 to i32
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %14
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = add nsw i32 %9, %17
  %19 = load i64, i64* %2, align 8
  %20 = and i64 %19, 3840
  %21 = lshr i64 %20, 8
  %22 = trunc i64 %21 to i32
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %23
  %25 = load i8, i8* %24, align 1
  %26 = sext i8 %25 to i32
  %27 = add nsw i32 %18, %26
  %28 = load i64, i64* %2, align 8
  %29 = and i64 %28, 61440
  %30 = lshr i64 %29, 12
  %31 = trunc i64 %30 to i32
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %32
  %34 = load i8, i8* %33, align 1
  %35 = sext i8 %34 to i32
  %36 = add nsw i32 %27, %35
  %37 = load i64, i64* %2, align 8
  %38 = and i64 %37, 983040
  %39 = lshr i64 %38, 16
  %40 = trunc i64 %39 to i32
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %41
  %43 = load i8, i8* %42, align 1
  %44 = sext i8 %43 to i32
  %45 = add nsw i32 %36, %44
  %46 = load i64, i64* %2, align 8
  %47 = and i64 %46, 15728640
  %48 = lshr i64 %47, 20
  %49 = trunc i64 %48 to i32
  %50 = sext i32 %49 to i64
  %51 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %50
  %52 = load i8, i8* %51, align 1
  %53 = sext i8 %52 to i32
  %54 = add nsw i32 %45, %53
  %55 = load i64, i64* %2, align 8
  %56 = and i64 %55, 251658240
  %57 = lshr i64 %56, 24
  %58 = trunc i64 %57 to i32
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %59
  %61 = load i8, i8* %60, align 1
  %62 = sext i8 %61 to i32
  %63 = add nsw i32 %54, %62
  %64 = load i64, i64* %2, align 8
  %65 = and i64 %64, 4026531840
  %66 = lshr i64 %65, 28
  %67 = trunc i64 %66 to i32
  %68 = sext i32 %67 to i64
  %69 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %68
  %70 = load i8, i8* %69, align 1
  %71 = sext i8 %70 to i32
  %72 = add nsw i32 %63, %71
  ret i32 %72
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @AR_btbl_bitcount(i64 %0) #0 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  store i64 %0, i64* %2, align 8
  %5 = bitcast i64* %2 to i8*
  store i8* %5, i8** %3, align 8
  %6 = load i8*, i8** %3, align 8
  %7 = getelementptr inbounds i8, i8* %6, i32 1
  store i8* %7, i8** %3, align 8
  %8 = load i8, i8* %6, align 1
  %9 = zext i8 %8 to i64
  %10 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %9
  %11 = load i8, i8* %10, align 1
  %12 = sext i8 %11 to i32
  store i32 %12, i32* %4, align 4
  %13 = load i8*, i8** %3, align 8
  %14 = getelementptr inbounds i8, i8* %13, i32 1
  store i8* %14, i8** %3, align 8
  %15 = load i8, i8* %13, align 1
  %16 = zext i8 %15 to i64
  %17 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %16
  %18 = load i8, i8* %17, align 1
  %19 = sext i8 %18 to i32
  %20 = load i32, i32* %4, align 4
  %21 = add nsw i32 %20, %19
  store i32 %21, i32* %4, align 4
  %22 = load i8*, i8** %3, align 8
  %23 = getelementptr inbounds i8, i8* %22, i32 1
  store i8* %23, i8** %3, align 8
  %24 = load i8, i8* %22, align 1
  %25 = zext i8 %24 to i64
  %26 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %25
  %27 = load i8, i8* %26, align 1
  %28 = sext i8 %27 to i32
  %29 = load i32, i32* %4, align 4
  %30 = add nsw i32 %29, %28
  store i32 %30, i32* %4, align 4
  %31 = load i8*, i8** %3, align 8
  %32 = load i8, i8* %31, align 1
  %33 = zext i8 %32 to i64
  %34 = getelementptr inbounds [256 x i8], [256 x i8]* @bits, i64 0, i64 %33
  %35 = load i8, i8* %34, align 1
  %36 = sext i8 %35 to i32
  %37 = load i32, i32* %4, align 4
  %38 = add nsw i32 %37, %36
  store i32 %38, i32* %4, align 4
  %39 = load i32, i32* %4, align 4
  ret i32 %39
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ntbl_bitcnt(i64 %0) #0 {
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  store i64 %0, i64* %2, align 8
  %4 = load i64, i64* %2, align 8
  %5 = and i64 %4, 15
  %6 = trunc i64 %5 to i32
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds [256 x i8], [256 x i8]* @bits.1, i64 0, i64 %7
  %9 = load i8, i8* %8, align 1
  %10 = sext i8 %9 to i32
  store i32 %10, i32* %3, align 4
  %11 = load i64, i64* %2, align 8
  %12 = ashr i64 %11, 4
  store i64 %12, i64* %2, align 8
  %13 = icmp ne i64 0, %12
  br i1 %13, label %14, label %19

14:                                               ; preds = %1
  %15 = load i64, i64* %2, align 8
  %16 = call i32 @ntbl_bitcnt(i64 %15)
  %17 = load i32, i32* %3, align 4
  %18 = add nsw i32 %17, %16
  store i32 %18, i32* %3, align 4
  br label %19

19:                                               ; preds = %14, %1
  %20 = load i32, i32* %3, align 4
  ret i32 %20
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5, !6}

!0 = !{!"clang version 13.0.0 (https://github.com/llvm/llvm-project/ 24c8eaec9467b2aaf70b0db33a4e4dd415139a50)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{i32 1, !"ThinLTO", i32 0}
!6 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
