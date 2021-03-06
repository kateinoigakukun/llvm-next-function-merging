; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -multiple-func-merging-allow-unprofitable < %s | FileCheck %s

declare double @atan(double)

define double @deg2rad(double %0) {
  %2 = fdiv double %0, 1.800000e+02
  ret double %2
}

define double @rad2deg(double %0) {
  %2 = fdiv double 4.000000e+00, %0
  ret double %2
}

; CHECK-LABEL: define internal double @__msa_merge_rad2deg_deg2rad(i32 %discriminator, double %m.0.0) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %switch6 = icmp ult i32 %discriminator, 1
; CHECK-NEXT:    %spec.select = select i1 %switch6, double 4.000000e+00, double %m.0.0
; CHECK-NEXT:    %switch = icmp ult i32 %discriminator, 1
; CHECK-NEXT:    %m.0.0. = select i1 %switch, double %m.0.0, double 1.800000e+02
; CHECK-NEXT:    %0 = fdiv double %spec.select, %m.0.0.
; CHECK-NEXT:    ret double %0
; CHECK-NEXT:  }
