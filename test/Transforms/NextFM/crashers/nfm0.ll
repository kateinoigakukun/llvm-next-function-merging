; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 < %s
; XFAIL: *

declare double @atan(double)

define double @deg2rad() {
  %1 = call double @atan(double 1.000000e+00)
  %2 = fmul double %1, 2.000000e+00
  ret double %2
}

define double @rad2deg() {
  %1 = alloca double, align 8
  %2 = fmul double 1.800000e+02, 2.000000e+00
  ret double %2
}

; OUTPUT DIAGNOSTICS:
; > Instruction does not dominate all uses!
; >   %1 = call double @atan(double 1.000000e+00)
; >   %3 = phi double [ 1.800000e+02, %bb.select.values ], [ %1, %bb.select.values2 ]

; GENERATED CODE
; > define internal double @__msa_merge_rad2deg_deg2rad_(i32 %discriminator) {
; > entry:
; >   br label %0
; 
; > switch.blackhole:                                 ; preds = %bb.switch.values, %0
; >   unreachable
; 
; > 0:                                                ; preds = %entry
; >   switch i32 %discriminator, label %switch.blackhole [
; >     i32 0, label %split.bb
; >     i32 1, label %split.bb1
; >   ]
; 
; > split.bb1:                                        ; preds = %0
; >   %1 = call double @atan(double 1.000000e+00)
; >   br label %bb.switch.values
; 
; > split.bb:                                         ; preds = %0
; >   %2 = alloca double, align 8
; >   br label %bb.switch.values
; 
; > bb.switch.values:                                 ; preds = %split.bb, %split.bb1
; >   switch i32 %discriminator, label %switch.blackhole [
; >     i32 0, label %bb.select.values
; >     i32 1, label %bb.select.values2
; >   ]
; 
; > bb.select.values:                                 ; preds = %bb.switch.values
; >   br label %bb.aggregate.values
; 
; > bb.select.values2:                                ; preds = %bb.switch.values
; >   br label %bb.aggregate.values
; 
; > bb.aggregate.values:                              ; preds = %bb.select.values2, %bb.select.values
; >   %3 = phi double [ 1.800000e+02, %bb.select.values ], [ %1, %bb.select.values2 ]
; >   br label %m.inst.bb
; 
; > m.inst.bb:                                        ; preds = %bb.aggregate.values
; >   %4 = fmul double %3, 2.000000e+00
; >   br label %m.term.bb
; 
; > m.term.bb:                                        ; preds = %m.inst.bb
; >   ret double %4
; > }
;
