; Check when selecting an operand from split inst results.
; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 < %s | FileCheck %s

declare double @atan(double)

; Select first operand of fmul from `deg2rad`'s %2 or 1.800000e+02

define double @deg2rad() {
  %1 = alloca double, align 8 ; <-- padding to activate merging
  %2 = call double @atan(double 1.000000e+00)
  %3 = fmul double %2, 2.000000e+00
  ret double %3
}

define double @rad2deg() {
  %1 = alloca double, align 8 ; <-- padding to activate merging
  %2 = fmul double 1.800000e+02, 2.000000e+00
  ret double %2
}

; CHECK-LABEL: define internal double @__msa_merge_deg2rad_rad2deg(i32 %discriminator) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = alloca double, align 8
; CHECK-NEXT:    %switch4 = icmp ult i32 %discriminator, 1
; CHECK-NEXT:    br i1 %switch4, label %split.bb, label %bb.switch.values
; CHECK-EMPTY:
; CHECK-NEXT:  split.bb:                                         ; preds = %entry
; CHECK-NEXT:    %1 = call double @atan(double 1.000000e+00)
; CHECK-NEXT:    br label %bb.switch.values
; CHECK-EMPTY:
; CHECK-NEXT:  bb.switch.values:                                 ; preds = %entry, %split.bb
; CHECK-NEXT:    %.0 = phi double [ undef, %entry ], [ %1, %split.bb ]
; CHECK-NEXT:    %switch = icmp ult i32 %discriminator, 1
; CHECK-NEXT:    %.0. = select i1 %switch, double %.0, double 1.800000e+02
; CHECK-NEXT:    %2 = fmul double %.0., 2.000000e+00
; CHECK-NEXT:    ret double %2
; CHECK-NEXT:  }
