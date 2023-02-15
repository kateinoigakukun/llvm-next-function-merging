; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-identical-type=true -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -pass-remarks-output=- %s -o /dev/null | FileCheck %s --check-prefix=CHECK-MFM
; RUN: %opt -mergefunc -func-merging -func-merging-operand-reorder=false -func-merging-coalescing=false -func-merging-whole-program=true -func-merging-matcher-report=false -func-merging-debug=false -func-merging-verbose=false  -pass-remarks-filter=func-merging -hyfm-profitability=true -func-merging-f3m=true -adaptive-threshold=false -adaptive-bands=false -hyfm-f3m-rows=2 -hyfm-f3m-bands=100 -shingling-cross-basic-blocks=true -ranking-distance=1.0 -bucket-size-cap=100 -func-merging-report=false -func-merging-hyfm-nw=true -pass-remarks-output=- %s -o /dev/null | FileCheck %s --check-prefix=CHECK-F3M
; CHECK-MFM:      Function:        __msa_merge_muxfa_inv_muxha_inv
; CHECK-MFM-NEXT: Args:
; CHECK-MFM-NEXT:   - Function:        muxfa_inv
; CHECK-MFM-NEXT:   - Function:        muxha_inv
; CHECK-MFM-NEXT:   - MergedSize:      '120'
; CHECK-MFM-NEXT:   - ThunkOverhead:   '0'
; CHECK-MFM-NEXT:   - OriginalTotalSize: '149'
; CHECK-F3M:      Function:        __fm_merge_muxfa_inv_muxha_inv
; CHECK-F3M-NEXT: Args:
; CHECK-F3M-NEXT:   - Function:        muxfa_inv
; CHECK-F3M-NEXT:   - Function:        muxha_inv
; CHECK-F3M-NEXT:   - MergedSize:      '120'
; CHECK-F3M-NEXT:   - ThunkOverhead:   '0'
; CHECK-F3M-NEXT:   - OriginalTotalSize: '149'
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/CodeGen/spec2006/462.libquantum/_main_._all_._files_._linked_.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.quantum_reg_struct = type { i32, i32, i32, %struct.quantum_reg_node_struct*, i32* }
%struct.quantum_reg_node_struct = type { { float, float }, i64 }

declare void @quantum_cnot(i32, i32, %struct.quantum_reg_struct*) local_unnamed_addr

declare void @quantum_toffoli(i32, i32, i32, %struct.quantum_reg_struct*) local_unnamed_addr

declare void @quantum_sigma_x(i32, %struct.quantum_reg_struct*) local_unnamed_addr

define void @muxfa_inv(i32 %a, i32 %b_in, i32 %c_in, i32 %c_out, i32 %xlt_l, i32 %L, i32 %total, %struct.quantum_reg_struct* %reg) local_unnamed_addr {
entry:
  switch i32 %a, label %if.end9 [
    i32 0, label %if.then
    i32 3, label %if.then2
    i32 1, label %if.then5
    i32 2, label %if.then8
  ]

if.then:                                          ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.then2:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_cnot(i32 %L, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.then5:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.then8:                                         ; preds = %entry
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.then5, %if.then2, %if.then, %entry
  ret void
}

define void @muxha_inv(i32 %a, i32 %b_in, i32 %c_in, i32 %xlt_l, i32 %L, %struct.quantum_reg_struct* %reg) local_unnamed_addr {
entry:
  switch i32 %a, label %if.end9 [
    i32 0, label %if.then
    i32 3, label %if.then2
    i32 1, label %if.then5
    i32 2, label %if.then8
  ]

if.then:                                          ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.then2:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_cnot(i32 %L, i32 %c_in, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.then5:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.then8:                                         ; preds = %entry
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg)
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg)
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.then5, %if.then2, %if.then, %entry
  ret void
}
