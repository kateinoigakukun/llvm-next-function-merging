; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 < %s
; XFAIL: *

declare double @atan(double)

define double @deg2rad(double %0) #0 {
  %2 = alloca double, align 8
  store double %0, double* %2, align 8
  %3 = call double @atan(double 1.000000e+00) #5
  %4 = fmul double 4.000000e+00, %3
  %5 = load double, double* %2, align 8
  %6 = fmul double %4, %5
  %7 = fdiv double %6, 1.800000e+02
  ret double %7
}

define double @rad2deg(double %0) #0 {
  %2 = alloca double, align 8
  store double %0, double* %2, align 8
  %3 = load double, double* %2, align 8
  %4 = fmul double 1.800000e+02, %3
  %5 = call double @atan(double 1.000000e+00) #5
  %6 = fmul double 4.000000e+00, %5
  %7 = fdiv double %4, %6
  ret double %7
}
