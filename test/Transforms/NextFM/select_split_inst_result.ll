; Check when selecting an operand from split inst results.
; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -multiple-func-merging-allow-unprofitable < %s | FileCheck %s

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

; CHECK-LABEL: define internal double @__msa_merge_deg2rad_rad2deg(i1 %discriminator) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = alloca double, align 8
; CHECK-NEXT:    %switch = icmp ult i1 %discriminator, true
; CHECK-NEXT:    br i1 %switch, label %deg2rad..split, label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  deg2rad..split:                                   ; preds = %entry
; CHECK-NEXT:    %1 = call double @atan(double 1.000000e+00)
; CHECK-NEXT:    br label %m.inst.bb1
; CHECK-EMPTY:
; CHECK-NEXT:  m.inst.bb1:                                       ; preds = %entry, %deg2rad..split
; CHECK-NEXT:    %.0 = phi double [ undef, %entry ], [ %1, %deg2rad..split ]
; CHECK-NEXT:    %switch.select = select i1 %discriminator, double 1.800000e+02, double %.0
; CHECK-NEXT:    %2 = fmul double %switch.select, 2.000000e+00
; CHECK-NEXT:    ret double %2
; CHECK-NEXT:  }
