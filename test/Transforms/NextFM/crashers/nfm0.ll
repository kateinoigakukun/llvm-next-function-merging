; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 < %s
; XFAIL: *

declare double @atan(double)

define double @deg2rad(double %0) {
  %2 = fmul double %0, %0
  %3 = fdiv double %0, 1.800000e+02
  ret double %2
}

define double @rad2deg(double %0) {
  %2 = fmul double 4.000000e+00, %0
  %3 = fdiv double %2, %0
  ret double %2
}
