; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 < %s | FileCheck %s

declare double @atan(double)

define double @deg2rad(double %0) {
  %2 = fdiv double %0, 1.800000e+02
  ret double %2
}

define double @rad2deg(double %0) {
  %2 = fdiv double 4.000000e+00, %0
  ret double %2
}

; CHECK-LABEL: define internal double @__msa_merge_rad2deg_deg2rad(i32 %discriminator, double %m..) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %switch7 = icmp ult i32 %discriminator, 1
; CHECK-NEXT:    %spec.select = select i1 %switch7, double 4.000000e+00, double %m..
; CHECK-NEXT:    %switch = icmp ult i32 %discriminator, 1
; CHECK-NEXT:    %m... = select i1 %switch, double %m.., double 1.800000e+02
; CHECK-NEXT:    %0 = fdiv double %spec.select, %m...
; CHECK-NEXT:    ret double %0
; CHECK-NEXT:  }
