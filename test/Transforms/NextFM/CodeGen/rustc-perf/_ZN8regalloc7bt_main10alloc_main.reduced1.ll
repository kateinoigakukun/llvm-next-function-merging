; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 --multiple-func-merging-shape-limit=41943040 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge
; ModuleID = 'test/Transforms/NextFM/CodeGen/rustc-perf/_ZN8regalloc7bt_main10alloc_main.reduced1.ll'
source_filename = "cranelift_codegen.1fa9f6fc-cgu.10"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }
%"regalloc::bt_main::EditListItem" = type { i32, i32, i32, i8, [3 x i8] }

define hidden void @_ZN8regalloc7bt_main10alloc_main17hff001664e8376445E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = alloca i32, align 4
  %2 = alloca i32*, align 8
  ret void
}

define hidden void @_ZN8regalloc7bt_main10alloc_main17had6f854518aa1322E() unnamed_addr personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* undef {
  %1 = alloca i32, align 4
  %2 = alloca %"regalloc::bt_main::EditListItem"*, align 8
  br label %3

3:                                                ; preds = %0
  br label %4

4:                                                ; preds = %3
  br label %5

5:                                                ; preds = %4
  br label %6

6:                                                ; preds = %5
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  br label %10

10:                                               ; preds = %9
  br label %11

11:                                               ; preds = %10
  br label %12

12:                                               ; preds = %11
  br label %13

13:                                               ; preds = %12
  br label %14

14:                                               ; preds = %13
  br label %15

15:                                               ; preds = %14
  br label %16

16:                                               ; preds = %15
  br label %17

17:                                               ; preds = %16
  br label %18

18:                                               ; preds = %17
  br label %19

19:                                               ; preds = %18
  br label %20

20:                                               ; preds = %19
  br label %21

21:                                               ; preds = %20
  br label %22

22:                                               ; preds = %21
  br label %23

23:                                               ; preds = %22
  br label %24

24:                                               ; preds = %23
  br label %25

25:                                               ; preds = %24
  br label %26

26:                                               ; preds = %25
  br label %27

27:                                               ; preds = %26
  br label %28

28:                                               ; preds = %27
  br label %29

29:                                               ; preds = %28
  br label %30

30:                                               ; preds = %29
  br label %31

31:                                               ; preds = %30
  br label %32

32:                                               ; preds = %31
  br label %33

33:                                               ; preds = %32
  br label %34

34:                                               ; preds = %33
  br label %35

35:                                               ; preds = %34
  br label %36

36:                                               ; preds = %35
  br label %37

37:                                               ; preds = %36
  br label %38

38:                                               ; preds = %37
  br label %39

39:                                               ; preds = %38
  br label %40

40:                                               ; preds = %39
  br label %41

41:                                               ; preds = %40
  br label %42

42:                                               ; preds = %41
  br label %43

43:                                               ; preds = %42
  br label %44

44:                                               ; preds = %43
  br label %45

45:                                               ; preds = %44
  br label %46

46:                                               ; preds = %45
  br label %47

47:                                               ; preds = %46
  br label %48

48:                                               ; preds = %47
  br label %49

49:                                               ; preds = %48
  br label %50

50:                                               ; preds = %49
  br label %51

51:                                               ; preds = %50
  br label %52

52:                                               ; preds = %51
  br label %53

53:                                               ; preds = %52
  br label %54

54:                                               ; preds = %53
  br label %55

55:                                               ; preds = %54
  br label %56

56:                                               ; preds = %55
  br label %57

57:                                               ; preds = %56
  br label %58

58:                                               ; preds = %57
  br label %59

59:                                               ; preds = %58
  br label %60

60:                                               ; preds = %59
  br label %61

61:                                               ; preds = %60
  br label %62

62:                                               ; preds = %61
  br label %63

63:                                               ; preds = %62
  br label %64

64:                                               ; preds = %63
  br label %65

65:                                               ; preds = %64
  br label %66

66:                                               ; preds = %65
  br label %67

67:                                               ; preds = %66
  br label %68

68:                                               ; preds = %67
  br label %69

69:                                               ; preds = %68
  br label %70

70:                                               ; preds = %69
  br label %71

71:                                               ; preds = %70
  br label %72

72:                                               ; preds = %71
  switch i32 undef, label %73 [
    i32 0, label %74
  ]

73:                                               ; preds = %72
  unreachable

74:                                               ; preds = %72
  switch i32 undef, label %75 [
    i32 0, label %78
    i32 1, label %76
    i32 2, label %78
    i32 3, label %77
  ]

75:                                               ; preds = %74
  unreachable

76:                                               ; preds = %74
  br label %78

77:                                               ; preds = %74
  br label %78

78:                                               ; preds = %77, %76, %74, %74
  %79 = phi i1 [ true, %77 ], [ false, %76 ], [ false, %74 ], [ false, %74 ]
  %80 = phi i1 [ false, %77 ], [ true, %76 ], [ false, %74 ], [ false, %74 ]
  ret void
}
