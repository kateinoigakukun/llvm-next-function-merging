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

; CHECK-LABEL: define internal double @__mf_merge_rad2deg_deg2rad(i1 %discriminator, double %m.0.0) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %switch.select = select i1 %discriminator, double %m.0.0, double 4.000000e+00
; CHECK-NEXT:    %switch.select1 = select i1 %discriminator, double 1.800000e+02, double %m.0.0
; CHECK-NEXT:    %0 = fdiv double %switch.select, %switch.select1
; CHECK-NEXT:    ret double %0
; CHECK-NEXT:  }
