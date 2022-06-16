; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 < %s
; XFAIL: *

declare double @atan(double)

define double @deg2rad(double %x) #0 {
  %1 = fmul double 4.000000e+00, %x
  %2 = fmul double %1, %x
  ret double %2
}

define double @rad2deg(double %x) #0 {
  %1 = call double @atan(double 1.000000e+00) #5
  %2 = fmul double 4.000000e+00, %1
  ret double %2
}
