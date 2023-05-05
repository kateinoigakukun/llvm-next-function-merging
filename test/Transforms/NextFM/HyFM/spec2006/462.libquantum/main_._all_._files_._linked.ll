; RUN: %opt --passes="mergefunc,func-merging" --func-merging-f3m -func-merging-explore=1 --func-merging-debug=false --func-merging-whole-program=true --func-merging-coalescing=false --func-merging-hyfm-nw -hyfm-profitability=true  -o %t.f3m-hyfm.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" -func-merging-explore=1 --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm-hyfm.bc %s
; RUN: %llc --filetype=obj %t.f3m-hyfm.bc -o %t.f3m-hyfm.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.bc -o %t.mfm-hyfm.o
; RUN: %strip %t.f3m-hyfm.o
; RUN: %strip %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -eq $(stat -c%%s %t.f3m-hyfm.o)

; ModuleID = '../llvm-nextfm-benchmark/benchmarks/spec2006/462.libquantum/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.quantum_reg_struct = type { i32, i32, i32, %struct.quantum_reg_node_struct*, i32* }
%struct.quantum_reg_node_struct = type { { float, float }, i64 }
%struct.__va_list_tag = type { i32, i32, i8*, i8* }
%struct.quantum_matrix_struct = type { i32, i32, { float, float }* }

@opstatus = local_unnamed_addr global i32 0, align 4
@objcode = local_unnamed_addr global i8* null, align 8
@position = local_unnamed_addr global i64 0, align 8
@allocated = local_unnamed_addr global i64 0, align 8
@.str.1 = private unnamed_addr constant [24 x i8] c"Unknown opcode 0x(%X)!\0A\00", align 1
@stderr = external local_unnamed_addr global %struct._IO_FILE*, align 8
@.str.3 = private unnamed_addr constant [74 x i8] c"Object code generation not active! Forgot to call quantum_objcode_start?\0A\00", align 1
@globalfile = local_unnamed_addr global i8* null, align 8
@.str.4 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.6 = private unnamed_addr constant [41 x i8] c"quantum_objcode_run: Could not open %s: \00", align 1
@.str.7 = private unnamed_addr constant [28 x i8] c"%i: Unknown opcode 0x(%X)!\0A\00", align 1
@str = private unnamed_addr constant [42 x i8] c"Error allocating memory for objcode data!\00", align 1
@str.8 = private unnamed_addr constant [44 x i8] c"Error reallocating memory for objcode data!\00", align 1
@.str = private unnamed_addr constant [40 x i8] c"Error allocating %i-element int array!\0A\00", align 1
@.str.2 = private unnamed_addr constant [39 x i8] c"Not enough memory for %i-sized qubit!\0A\00", align 1
@.str.3.16 = private unnamed_addr constant [39 x i8] c"Not enough memory for %i bytes array!\0A\00", align 1
@quantum_gate_counter.counter = internal unnamed_addr global i32 0, align 4
@str.15 = private unnamed_addr constant [28 x i8] c"Matrix is not a 2x2 matrix!\00", align 1
@str.5 = private unnamed_addr constant [28 x i8] c"Matrix is not a 4x4 matrix!\00", align 1
@seedi = internal unnamed_addr global i32 0, align 4
@.str.49 = private unnamed_addr constant [39 x i8] c"Not enough memory for %i-sized qubit!\0A\00", align 1
@.str.50 = private unnamed_addr constant [6 x i8] c"0.2.4\00", align 1
@status = local_unnamed_addr global i32 0, align 4
@lambda = local_unnamed_addr global float 0.000000e+00, align 4
@.str.53 = private unnamed_addr constant [48 x i8] c"Not enough memory for %i-sized array of float!\0A\00", align 1
@type = local_unnamed_addr global i32 0, align 4
@width = local_unnamed_addr global i32 0, align 4
@quantum_qec_counter.counter = internal unnamed_addr global i32 0, align 4
@quantum_qec_counter.freq = internal unnamed_addr global i32 1073741824, align 4
@.str.2.64 = private unnamed_addr constant [28 x i8] c"N = %i, %i qubits required\0A\00", align 1
@.str.3.65 = private unnamed_addr constant [17 x i8] c"Random seed: %i\0A\00", align 1
@.str.6.67 = private unnamed_addr constant [19 x i8] c"Measured %i (%f), \00", align 1
@.str.7.68 = private unnamed_addr constant [36 x i8] c"fractional approximation is %i/%i.\0A\00", align 1
@.str.10 = private unnamed_addr constant [24 x i8] c"Possible period is %i.\0A\00", align 1
@.str.11 = private unnamed_addr constant [14 x i8] c"%i = %i * %i\0A\00", align 1
@str.69 = private unnamed_addr constant [40 x i8] c"Unable to determine factors, try again.\00", align 1
@str.13 = private unnamed_addr constant [23 x i8] c"Odd period, try again.\00", align 1
@str.14 = private unnamed_addr constant [40 x i8] c"Odd denominator, trying to expand by 2.\00", align 1
@str.15.66 = private unnamed_addr constant [26 x i8] c"Measured zero, try again.\00", align 1
@str.16 = private unnamed_addr constant [24 x i8] c"Impossible Measurement!\00", align 1
@str.17 = private unnamed_addr constant [16 x i8] c"Invalid number\0A\00", align 1
@str.18 = private unnamed_addr constant [22 x i8] c"Usage: shor [number]\0A\00", align 1
@quantum_memman.mem = internal unnamed_addr global i64 0, align 8
@quantum_memman.max = internal unnamed_addr global i64 0, align 8
@.str.74 = private unnamed_addr constant [35 x i8] c"Not enogh memory for %ix%i-Matrix!\00", align 1
@.str.1.79 = private unnamed_addr constant [10 x i8] c"% f %+fi\09\00", align 1
@.str.80 = private unnamed_addr constant [51 x i8] c"Error! Cannot convert a multi-column-matrix (%i)!\0A\00", align 1
@.str.1.81 = private unnamed_addr constant [39 x i8] c"Not enough memory for %i-sized qubit!\0A\00", align 1
@.str.2.82 = private unnamed_addr constant [38 x i8] c"Not enough memory for %i-sized hash!\0A\00", align 1
@.str.3.85 = private unnamed_addr constant [9 x i8] c"QUOBFILE\00", align 1
@.str.4.93 = private unnamed_addr constant [23 x i8] c"% f %+fi|%lli> (%e) (|\00", align 1
@.str.6.94 = private unnamed_addr constant [3 x i8] c"%i\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"%i: %lli\0A\00", align 1
@.str.10.98 = private unnamed_addr constant [13 x i8] c"%i: %i %llu\0A\00", align 1
@.str.11.101 = private unnamed_addr constant [50 x i8] c"Not enough memory for %i-sized quantum register!\0A\00", align 1
@str.95 = private unnamed_addr constant [3 x i8] c">)\00", align 1

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_qft(i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %sub = add nsw i32 %width, -1
  %cmp20 = icmp sgt i32 %width, 0
  br i1 %cmp20, label %for.cond2.preheader, label %for.end7

for.cond2.preheader:                              ; preds = %entry, %for.end
  %i.021 = phi i32 [ %dec6, %for.end ], [ %sub, %entry ]
  %cmp318 = icmp sgt i32 %sub, %i.021
  br i1 %cmp318, label %for.body4, label %for.end

for.body4:                                        ; preds = %for.cond2.preheader, %for.body4
  %j.019 = phi i32 [ %dec, %for.body4 ], [ %sub, %for.cond2.preheader ]
  tail call void @quantum_cond_phase(i32 %j.019, i32 %i.021, %struct.quantum_reg_struct* %reg) #31
  %dec = add nsw i32 %j.019, -1
  %cmp3 = icmp sgt i32 %dec, %i.021
  br i1 %cmp3, label %for.body4, label %for.end, !llvm.loop !4

for.end:                                          ; preds = %for.body4, %for.cond2.preheader
  tail call void @quantum_hadamard(i32 %i.021, %struct.quantum_reg_struct* %reg) #31
  %dec6 = add nsw i32 %i.021, -1
  %cmp = icmp sgt i32 %i.021, 0
  br i1 %cmp, label %for.cond2.preheader, label %for.end7, !llvm.loop !6

for.end7:                                         ; preds = %for.end, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_qft_inv(i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %cmp19 = icmp sgt i32 %width, 0
  br i1 %cmp19, label %for.body, label %for.end6

for.cond.loopexit:                                ; preds = %for.body3, %for.body
  %exitcond21.not = icmp eq i32 %add, %width
  br i1 %exitcond21.not, label %for.end6, label %for.body, !llvm.loop !7

for.body:                                         ; preds = %entry, %for.cond.loopexit
  %i.020 = phi i32 [ %add, %for.cond.loopexit ], [ 0, %entry ]
  tail call void @quantum_hadamard(i32 %i.020, %struct.quantum_reg_struct* %reg) #31
  %add = add nuw nsw i32 %i.020, 1
  %cmp217 = icmp slt i32 %add, %width
  br i1 %cmp217, label %for.body3, label %for.cond.loopexit

for.body3:                                        ; preds = %for.body, %for.body3
  %j.018 = phi i32 [ %inc, %for.body3 ], [ %add, %for.body ]
  tail call void @quantum_cond_phase_inv(i32 %j.018, i32 %i.020, %struct.quantum_reg_struct* %reg) #31
  %inc = add nuw i32 %j.018, 1
  %exitcond.not = icmp eq i32 %inc, %width
  br i1 %exitcond.not, label %for.cond.loopexit, label %for.body3, !llvm.loop !8

for.end6:                                         ; preds = %for.cond.loopexit, %entry
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable writeonly
define void @quantum_mu2char(i64 %mu, i8* nocapture %buf) local_unnamed_addr #1 {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %mu.addr.017 = phi i64 [ %mu, %entry ], [ %rem, %for.body ]
  %0 = mul nsw i64 %indvars.iv, -8
  %1 = add nsw i64 %0, 56
  %div = lshr i64 %mu.addr.017, %1
  %conv = trunc i64 %div to i8
  %arrayidx = getelementptr inbounds i8, i8* %buf, i64 %indvars.iv
  store i8 %conv, i8* %arrayidx, align 1, !tbaa !9
  %notmask = shl nsw i64 -1, %1
  %2 = xor i64 %notmask, -1
  %rem = and i64 %mu.addr.017, %2
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 8
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !12

for.end:                                          ; preds = %for.body
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable writeonly
define void @quantum_int2char(i32 %j, i8* nocapture %buf) local_unnamed_addr #1 {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %j.addr.016 = phi i32 [ %j, %entry ], [ %rem, %for.body ]
  %0 = trunc i64 %indvars.iv to i32
  %1 = mul i32 %0, -8
  %2 = add i32 %1, 24
  %shl = shl nuw nsw i32 1, %2
  %div = sdiv i32 %j.addr.016, %shl
  %conv = trunc i32 %div to i8
  %arrayidx = getelementptr inbounds i8, i8* %buf, i64 %indvars.iv
  store i8 %conv, i8* %arrayidx, align 1, !tbaa !9
  %rem = srem i32 %j.addr.016, %shl
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 4
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !13

for.end:                                          ; preds = %for.body
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable writeonly
define void @quantum_double2char(double %d, i8* nocapture %buf) local_unnamed_addr #1 {
entry:
  %d.addr.0.buf.sroa_cast = bitcast i8* %buf to double*
  store double %d, double* %d.addr.0.buf.sroa_cast, align 1
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readonly uwtable
define i64 @quantum_char2mu(i8* nocapture readonly %buf) local_unnamed_addr #2 {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 7, %entry ], [ %indvars.iv.next, %for.body ]
  %mu.014 = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i8, i8* %buf, i64 %indvars.iv
  %0 = load i8, i8* %arrayidx, align 1, !tbaa !9
  %conv = zext i8 %0 to i64
  %1 = mul nsw i64 %indvars.iv, -8
  %2 = add nsw i64 %1, 56
  %mul3 = shl i64 %conv, %2
  %add = add i64 %mul3, %mu.014
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %cmp.not = icmp eq i64 %indvars.iv, 0
  br i1 %cmp.not, label %for.end, label %for.body, !llvm.loop !14

for.end:                                          ; preds = %for.body
  ret i64 %add
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readonly uwtable
define i32 @quantum_char2int(i8* nocapture readonly %buf) local_unnamed_addr #2 {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 3, %entry ], [ %indvars.iv.next, %for.body ]
  %j.014 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i8, i8* %buf, i64 %indvars.iv
  %0 = load i8, i8* %arrayidx, align 1, !tbaa !9
  %conv = zext i8 %0 to i32
  %1 = trunc i64 %indvars.iv to i32
  %2 = mul i32 %1, -8
  %3 = add i32 %2, 24
  %mul3 = shl i32 %conv, %3
  %add = add nsw i32 %mul3, %j.014
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %cmp.not = icmp eq i64 %indvars.iv, 0
  br i1 %cmp.not, label %for.end, label %for.body, !llvm.loop !15

for.end:                                          ; preds = %for.body
  ret i32 %add
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
define double @quantum_char2double(i8* nocapture readonly %buf) local_unnamed_addr #3 {
entry:
  %0 = bitcast i8* %buf to double*
  %1 = load double, double* %0, align 8, !tbaa !16
  ret double %1
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_objcode_start() local_unnamed_addr #0 {
entry:
  store i32 1, i32* @opstatus, align 4, !tbaa !18
  store i64 1, i64* @allocated, align 8, !tbaa !20
  %call = tail call noalias align 16 dereferenceable_or_null(65536) i8* @malloc(i64 65536) #31
  store i8* %call, i8** @objcode, align 8, !tbaa !22
  %tobool.not = icmp eq i8* %call, null
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([42 x i8], [42 x i8]* @str, i64 0, i64 0))
  tail call void @exit(i32 1) #32
  unreachable

if.end:                                           ; preds = %entry
  %call2 = tail call i64 @quantum_memman(i64 65536) #31
  ret void
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind optsize willreturn
declare noalias noundef align 16 i8* @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #5

; Function Attrs: noreturn nounwind optsize
declare void @exit(i32) local_unnamed_addr #6

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_objcode_stop() local_unnamed_addr #0 {
entry:
  store i32 0, i32* @opstatus, align 4, !tbaa !18
  %0 = load i8*, i8** @objcode, align 8, !tbaa !22
  tail call void @free(i8* %0) #31
  store i8* null, i8** @objcode, align 8, !tbaa !22
  %1 = load i64, i64* @allocated, align 8, !tbaa !20
  %sub.neg = mul i64 %1, -65536
  %call = tail call i64 @quantum_memman(i64 %sub.neg) #31
  store i64 0, i64* @allocated, align 8, !tbaa !20
  ret void
}

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #7

; Function Attrs: noinline nounwind optsize uwtable
define i32 @quantum_objcode_put(i8 zeroext %operation, ...) local_unnamed_addr #0 {
entry:
  %args = alloca [1 x %struct.__va_list_tag], align 16
  %buf = alloca [80 x i8], align 16
  %0 = bitcast [1 x %struct.__va_list_tag]* %args to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %0) #33
  %1 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %1) #33
  %2 = load i32, i32* @opstatus, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %2, 0
  br i1 %tobool.not, label %cleanup, label %if.end

if.end:                                           ; preds = %entry
  call void @llvm.va_start(i8* nonnull %0)
  store i8 %operation, i8* %1, align 16, !tbaa !9
  switch i8 %operation, label %sw.default [
    i8 0, label %sw.bb
    i8 1, label %sw.bb4
    i8 12, label %sw.bb4
    i8 2, label %sw.bb31
    i8 3, label %sw.bb71
    i8 4, label %sw.bb71
    i8 5, label %sw.bb71
    i8 6, label %sw.bb71
    i8 -127, label %sw.bb71
    i8 -126, label %sw.bb71
    i8 14, label %sw.bb71
    i8 7, label %sw.bb85
    i8 8, label %sw.bb85
    i8 9, label %sw.bb85
    i8 10, label %sw.bb85
    i8 11, label %sw.bb85
    i8 13, label %sw.bb109
    i8 -128, label %sw.epilog
    i8 -1, label %sw.epilog
  ]

sw.bb:                                            ; preds = %if.end
  %gp_offset_p = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 0
  %gp_offset = load i32, i32* %gp_offset_p, align 16
  %fits_in_gp = icmp ult i32 %gp_offset, 41
  br i1 %fits_in_gp, label %vaarg.in_reg, label %vaarg.in_mem

vaarg.in_reg:                                     ; preds = %sw.bb
  %3 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area = load i8*, i8** %3, align 16
  %4 = zext i32 %gp_offset to i64
  %5 = getelementptr i8, i8* %reg_save_area, i64 %4
  %6 = add nuw nsw i32 %gp_offset, 8
  store i32 %6, i32* %gp_offset_p, align 16
  br label %vaarg.end

vaarg.in_mem:                                     ; preds = %sw.bb
  %overflow_arg_area_p = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area = load i8*, i8** %overflow_arg_area_p, align 8
  %overflow_arg_area.next = getelementptr i8, i8* %overflow_arg_area, i64 8
  store i8* %overflow_arg_area.next, i8** %overflow_arg_area_p, align 8
  br label %vaarg.end

vaarg.end:                                        ; preds = %vaarg.in_mem, %vaarg.in_reg
  %vaarg.addr.in = phi i8* [ %5, %vaarg.in_reg ], [ %overflow_arg_area, %vaarg.in_mem ]
  %vaarg.addr = bitcast i8* %vaarg.addr.in to i64*
  %7 = load i64, i64* %vaarg.addr, align 8
  %arrayidx3 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 1
  call void @quantum_mu2char(i64 %7, i8* nonnull %arrayidx3) #34
  br label %sw.epilog

sw.bb4:                                           ; preds = %if.end, %if.end
  %gp_offset_p6 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 0
  %gp_offset7 = load i32, i32* %gp_offset_p6, align 16
  %fits_in_gp8 = icmp ult i32 %gp_offset7, 41
  br i1 %fits_in_gp8, label %vaarg.in_reg9, label %vaarg.in_mem11

vaarg.in_reg9:                                    ; preds = %sw.bb4
  %8 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area10 = load i8*, i8** %8, align 16
  %9 = zext i32 %gp_offset7 to i64
  %10 = getelementptr i8, i8* %reg_save_area10, i64 %9
  %11 = add nuw nsw i32 %gp_offset7, 8
  store i32 %11, i32* %gp_offset_p6, align 16
  br label %vaarg.end15

vaarg.in_mem11:                                   ; preds = %sw.bb4
  %overflow_arg_area_p12 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area13 = load i8*, i8** %overflow_arg_area_p12, align 8
  %overflow_arg_area.next14 = getelementptr i8, i8* %overflow_arg_area13, i64 8
  store i8* %overflow_arg_area.next14, i8** %overflow_arg_area_p12, align 8
  br label %vaarg.end15

vaarg.end15:                                      ; preds = %vaarg.in_mem11, %vaarg.in_reg9
  %vaarg.addr16.in = phi i8* [ %10, %vaarg.in_reg9 ], [ %overflow_arg_area13, %vaarg.in_mem11 ]
  %vaarg.addr16 = bitcast i8* %vaarg.addr16.in to i32*
  %12 = load i32, i32* %vaarg.addr16, align 4
  %arrayidx17 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 1
  call void @quantum_int2char(i32 %12, i8* nonnull %arrayidx17) #34
  %gp_offset20 = load i32, i32* %gp_offset_p6, align 16
  %fits_in_gp21 = icmp ult i32 %gp_offset20, 41
  br i1 %fits_in_gp21, label %vaarg.in_reg22, label %vaarg.in_mem24

vaarg.in_reg22:                                   ; preds = %vaarg.end15
  %13 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area23 = load i8*, i8** %13, align 16
  %14 = zext i32 %gp_offset20 to i64
  %15 = getelementptr i8, i8* %reg_save_area23, i64 %14
  %16 = add nuw nsw i32 %gp_offset20, 8
  store i32 %16, i32* %gp_offset_p6, align 16
  br label %vaarg.end28

vaarg.in_mem24:                                   ; preds = %vaarg.end15
  %overflow_arg_area_p25 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area26 = load i8*, i8** %overflow_arg_area_p25, align 8
  %overflow_arg_area.next27 = getelementptr i8, i8* %overflow_arg_area26, i64 8
  store i8* %overflow_arg_area.next27, i8** %overflow_arg_area_p25, align 8
  br label %vaarg.end28

vaarg.end28:                                      ; preds = %vaarg.in_mem24, %vaarg.in_reg22
  %vaarg.addr29.in = phi i8* [ %15, %vaarg.in_reg22 ], [ %overflow_arg_area26, %vaarg.in_mem24 ]
  %vaarg.addr29 = bitcast i8* %vaarg.addr29.in to i32*
  %17 = load i32, i32* %vaarg.addr29, align 4
  %arrayidx30 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 5
  call void @quantum_int2char(i32 %17, i8* nonnull %arrayidx30) #34
  br label %sw.epilog

sw.bb31:                                          ; preds = %if.end
  %gp_offset_p33 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 0
  %gp_offset34 = load i32, i32* %gp_offset_p33, align 16
  %fits_in_gp35 = icmp ult i32 %gp_offset34, 41
  br i1 %fits_in_gp35, label %vaarg.in_reg36, label %vaarg.in_mem38

vaarg.in_reg36:                                   ; preds = %sw.bb31
  %18 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area37 = load i8*, i8** %18, align 16
  %19 = zext i32 %gp_offset34 to i64
  %20 = getelementptr i8, i8* %reg_save_area37, i64 %19
  %21 = add nuw nsw i32 %gp_offset34, 8
  store i32 %21, i32* %gp_offset_p33, align 16
  br label %vaarg.end42

vaarg.in_mem38:                                   ; preds = %sw.bb31
  %overflow_arg_area_p39 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area40 = load i8*, i8** %overflow_arg_area_p39, align 8
  %overflow_arg_area.next41 = getelementptr i8, i8* %overflow_arg_area40, i64 8
  store i8* %overflow_arg_area.next41, i8** %overflow_arg_area_p39, align 8
  br label %vaarg.end42

vaarg.end42:                                      ; preds = %vaarg.in_mem38, %vaarg.in_reg36
  %vaarg.addr43.in = phi i8* [ %20, %vaarg.in_reg36 ], [ %overflow_arg_area40, %vaarg.in_mem38 ]
  %vaarg.addr43 = bitcast i8* %vaarg.addr43.in to i32*
  %22 = load i32, i32* %vaarg.addr43, align 4
  %arrayidx44 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 1
  call void @quantum_int2char(i32 %22, i8* nonnull %arrayidx44) #34
  %gp_offset47 = load i32, i32* %gp_offset_p33, align 16
  %fits_in_gp48 = icmp ult i32 %gp_offset47, 41
  br i1 %fits_in_gp48, label %vaarg.in_reg49, label %vaarg.in_mem51

vaarg.in_reg49:                                   ; preds = %vaarg.end42
  %23 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area50 = load i8*, i8** %23, align 16
  %24 = zext i32 %gp_offset47 to i64
  %25 = getelementptr i8, i8* %reg_save_area50, i64 %24
  %26 = add nuw nsw i32 %gp_offset47, 8
  store i32 %26, i32* %gp_offset_p33, align 16
  br label %vaarg.end55

vaarg.in_mem51:                                   ; preds = %vaarg.end42
  %overflow_arg_area_p52 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area53 = load i8*, i8** %overflow_arg_area_p52, align 8
  %overflow_arg_area.next54 = getelementptr i8, i8* %overflow_arg_area53, i64 8
  store i8* %overflow_arg_area.next54, i8** %overflow_arg_area_p52, align 8
  br label %vaarg.end55

vaarg.end55:                                      ; preds = %vaarg.in_mem51, %vaarg.in_reg49
  %vaarg.addr56.in = phi i8* [ %25, %vaarg.in_reg49 ], [ %overflow_arg_area53, %vaarg.in_mem51 ]
  %vaarg.addr56 = bitcast i8* %vaarg.addr56.in to i32*
  %27 = load i32, i32* %vaarg.addr56, align 4
  %arrayidx57 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 5
  call void @quantum_int2char(i32 %27, i8* nonnull %arrayidx57) #34
  %gp_offset60 = load i32, i32* %gp_offset_p33, align 16
  %fits_in_gp61 = icmp ult i32 %gp_offset60, 41
  br i1 %fits_in_gp61, label %vaarg.in_reg62, label %vaarg.in_mem64

vaarg.in_reg62:                                   ; preds = %vaarg.end55
  %28 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area63 = load i8*, i8** %28, align 16
  %29 = zext i32 %gp_offset60 to i64
  %30 = getelementptr i8, i8* %reg_save_area63, i64 %29
  %31 = add nuw nsw i32 %gp_offset60, 8
  store i32 %31, i32* %gp_offset_p33, align 16
  br label %vaarg.end68

vaarg.in_mem64:                                   ; preds = %vaarg.end55
  %overflow_arg_area_p65 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area66 = load i8*, i8** %overflow_arg_area_p65, align 8
  %overflow_arg_area.next67 = getelementptr i8, i8* %overflow_arg_area66, i64 8
  store i8* %overflow_arg_area.next67, i8** %overflow_arg_area_p65, align 8
  br label %vaarg.end68

vaarg.end68:                                      ; preds = %vaarg.in_mem64, %vaarg.in_reg62
  %vaarg.addr69.in = phi i8* [ %30, %vaarg.in_reg62 ], [ %overflow_arg_area66, %vaarg.in_mem64 ]
  %vaarg.addr69 = bitcast i8* %vaarg.addr69.in to i32*
  %32 = load i32, i32* %vaarg.addr69, align 4
  %arrayidx70 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 9
  call void @quantum_int2char(i32 %32, i8* nonnull %arrayidx70) #34
  br label %sw.epilog

sw.bb71:                                          ; preds = %if.end, %if.end, %if.end, %if.end, %if.end, %if.end, %if.end
  %gp_offset_p73 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 0
  %gp_offset74 = load i32, i32* %gp_offset_p73, align 16
  %fits_in_gp75 = icmp ult i32 %gp_offset74, 41
  br i1 %fits_in_gp75, label %vaarg.in_reg76, label %vaarg.in_mem78

vaarg.in_reg76:                                   ; preds = %sw.bb71
  %33 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area77 = load i8*, i8** %33, align 16
  %34 = zext i32 %gp_offset74 to i64
  %35 = getelementptr i8, i8* %reg_save_area77, i64 %34
  %36 = add nuw nsw i32 %gp_offset74, 8
  store i32 %36, i32* %gp_offset_p73, align 16
  br label %vaarg.end82

vaarg.in_mem78:                                   ; preds = %sw.bb71
  %overflow_arg_area_p79 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area80 = load i8*, i8** %overflow_arg_area_p79, align 8
  %overflow_arg_area.next81 = getelementptr i8, i8* %overflow_arg_area80, i64 8
  store i8* %overflow_arg_area.next81, i8** %overflow_arg_area_p79, align 8
  br label %vaarg.end82

vaarg.end82:                                      ; preds = %vaarg.in_mem78, %vaarg.in_reg76
  %vaarg.addr83.in = phi i8* [ %35, %vaarg.in_reg76 ], [ %overflow_arg_area80, %vaarg.in_mem78 ]
  %vaarg.addr83 = bitcast i8* %vaarg.addr83.in to i32*
  %37 = load i32, i32* %vaarg.addr83, align 4
  %arrayidx84 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 1
  call void @quantum_int2char(i32 %37, i8* nonnull %arrayidx84) #34
  br label %sw.epilog

sw.bb85:                                          ; preds = %if.end, %if.end, %if.end, %if.end, %if.end
  %gp_offset_p87 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 0
  %gp_offset88 = load i32, i32* %gp_offset_p87, align 16
  %fits_in_gp89 = icmp ult i32 %gp_offset88, 41
  br i1 %fits_in_gp89, label %vaarg.in_reg90, label %vaarg.in_mem92

vaarg.in_reg90:                                   ; preds = %sw.bb85
  %38 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area91 = load i8*, i8** %38, align 16
  %39 = zext i32 %gp_offset88 to i64
  %40 = getelementptr i8, i8* %reg_save_area91, i64 %39
  %41 = add nuw nsw i32 %gp_offset88, 8
  store i32 %41, i32* %gp_offset_p87, align 16
  br label %vaarg.end96

vaarg.in_mem92:                                   ; preds = %sw.bb85
  %overflow_arg_area_p93 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area94 = load i8*, i8** %overflow_arg_area_p93, align 8
  %overflow_arg_area.next95 = getelementptr i8, i8* %overflow_arg_area94, i64 8
  store i8* %overflow_arg_area.next95, i8** %overflow_arg_area_p93, align 8
  br label %vaarg.end96

vaarg.end96:                                      ; preds = %vaarg.in_mem92, %vaarg.in_reg90
  %vaarg.addr97.in = phi i8* [ %40, %vaarg.in_reg90 ], [ %overflow_arg_area94, %vaarg.in_mem92 ]
  %vaarg.addr97 = bitcast i8* %vaarg.addr97.in to i32*
  %42 = load i32, i32* %vaarg.addr97, align 4
  %fp_offset_p = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 1
  %fp_offset = load i32, i32* %fp_offset_p, align 4
  %fits_in_fp = icmp ult i32 %fp_offset, 161
  br i1 %fits_in_fp, label %vaarg.in_reg99, label %vaarg.in_mem101

vaarg.in_reg99:                                   ; preds = %vaarg.end96
  %43 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area100 = load i8*, i8** %43, align 16
  %44 = zext i32 %fp_offset to i64
  %45 = getelementptr i8, i8* %reg_save_area100, i64 %44
  %46 = add nuw nsw i32 %fp_offset, 16
  store i32 %46, i32* %fp_offset_p, align 4
  br label %vaarg.end105

vaarg.in_mem101:                                  ; preds = %vaarg.end96
  %overflow_arg_area_p102 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area103 = load i8*, i8** %overflow_arg_area_p102, align 8
  %overflow_arg_area.next104 = getelementptr i8, i8* %overflow_arg_area103, i64 8
  store i8* %overflow_arg_area.next104, i8** %overflow_arg_area_p102, align 8
  br label %vaarg.end105

vaarg.end105:                                     ; preds = %vaarg.in_mem101, %vaarg.in_reg99
  %vaarg.addr106.in = phi i8* [ %45, %vaarg.in_reg99 ], [ %overflow_arg_area103, %vaarg.in_mem101 ]
  %vaarg.addr106 = bitcast i8* %vaarg.addr106.in to double*
  %47 = load double, double* %vaarg.addr106, align 8
  %arrayidx107 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 1
  call void @quantum_int2char(i32 %42, i8* nonnull %arrayidx107) #34
  %arrayidx108 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 5
  call void @quantum_double2char(double %47, i8* nonnull %arrayidx108) #34
  br label %sw.epilog

sw.bb109:                                         ; preds = %if.end
  %gp_offset_p111 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 0
  %gp_offset112 = load i32, i32* %gp_offset_p111, align 16
  %fits_in_gp113 = icmp ult i32 %gp_offset112, 41
  br i1 %fits_in_gp113, label %vaarg.in_reg114, label %vaarg.in_mem116

vaarg.in_reg114:                                  ; preds = %sw.bb109
  %48 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area115 = load i8*, i8** %48, align 16
  %49 = zext i32 %gp_offset112 to i64
  %50 = getelementptr i8, i8* %reg_save_area115, i64 %49
  %51 = add nuw nsw i32 %gp_offset112, 8
  store i32 %51, i32* %gp_offset_p111, align 16
  br label %vaarg.end120

vaarg.in_mem116:                                  ; preds = %sw.bb109
  %overflow_arg_area_p117 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area118 = load i8*, i8** %overflow_arg_area_p117, align 8
  %overflow_arg_area.next119 = getelementptr i8, i8* %overflow_arg_area118, i64 8
  store i8* %overflow_arg_area.next119, i8** %overflow_arg_area_p117, align 8
  br label %vaarg.end120

vaarg.end120:                                     ; preds = %vaarg.in_mem116, %vaarg.in_reg114
  %vaarg.addr121.in = phi i8* [ %50, %vaarg.in_reg114 ], [ %overflow_arg_area118, %vaarg.in_mem116 ]
  %vaarg.addr121 = bitcast i8* %vaarg.addr121.in to i32*
  %52 = load i32, i32* %vaarg.addr121, align 4
  %arrayidx122 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 1
  call void @quantum_int2char(i32 %52, i8* nonnull %arrayidx122) #34
  %gp_offset125 = load i32, i32* %gp_offset_p111, align 16
  %fits_in_gp126 = icmp ult i32 %gp_offset125, 41
  br i1 %fits_in_gp126, label %vaarg.in_reg127, label %vaarg.in_mem129

vaarg.in_reg127:                                  ; preds = %vaarg.end120
  %53 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area128 = load i8*, i8** %53, align 16
  %54 = zext i32 %gp_offset125 to i64
  %55 = getelementptr i8, i8* %reg_save_area128, i64 %54
  %56 = add nuw nsw i32 %gp_offset125, 8
  store i32 %56, i32* %gp_offset_p111, align 16
  br label %vaarg.end133

vaarg.in_mem129:                                  ; preds = %vaarg.end120
  %overflow_arg_area_p130 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area131 = load i8*, i8** %overflow_arg_area_p130, align 8
  %overflow_arg_area.next132 = getelementptr i8, i8* %overflow_arg_area131, i64 8
  store i8* %overflow_arg_area.next132, i8** %overflow_arg_area_p130, align 8
  br label %vaarg.end133

vaarg.end133:                                     ; preds = %vaarg.in_mem129, %vaarg.in_reg127
  %vaarg.addr134.in = phi i8* [ %55, %vaarg.in_reg127 ], [ %overflow_arg_area131, %vaarg.in_mem129 ]
  %vaarg.addr134 = bitcast i8* %vaarg.addr134.in to i32*
  %57 = load i32, i32* %vaarg.addr134, align 4
  %arrayidx135 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 5
  call void @quantum_int2char(i32 %57, i8* nonnull %arrayidx135) #34
  %fp_offset_p137 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 1
  %fp_offset138 = load i32, i32* %fp_offset_p137, align 4
  %fits_in_fp139 = icmp ult i32 %fp_offset138, 161
  br i1 %fits_in_fp139, label %vaarg.in_reg140, label %vaarg.in_mem142

vaarg.in_reg140:                                  ; preds = %vaarg.end133
  %58 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 3
  %reg_save_area141 = load i8*, i8** %58, align 16
  %59 = zext i32 %fp_offset138 to i64
  %60 = getelementptr i8, i8* %reg_save_area141, i64 %59
  %61 = add nuw nsw i32 %fp_offset138, 16
  store i32 %61, i32* %fp_offset_p137, align 4
  br label %vaarg.end146

vaarg.in_mem142:                                  ; preds = %vaarg.end133
  %overflow_arg_area_p143 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %args, i64 0, i64 0, i32 2
  %overflow_arg_area144 = load i8*, i8** %overflow_arg_area_p143, align 8
  %overflow_arg_area.next145 = getelementptr i8, i8* %overflow_arg_area144, i64 8
  store i8* %overflow_arg_area.next145, i8** %overflow_arg_area_p143, align 8
  br label %vaarg.end146

vaarg.end146:                                     ; preds = %vaarg.in_mem142, %vaarg.in_reg140
  %vaarg.addr147.in = phi i8* [ %60, %vaarg.in_reg140 ], [ %overflow_arg_area144, %vaarg.in_mem142 ]
  %vaarg.addr147 = bitcast i8* %vaarg.addr147.in to double*
  %62 = load double, double* %vaarg.addr147, align 8
  %arrayidx148 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 9
  call void @quantum_double2char(double %62, i8* nonnull %arrayidx148) #34
  br label %sw.epilog

sw.default:                                       ; preds = %if.end
  %conv = zext i8 %operation to i32
  %call = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0), i32 %conv) #34
  call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

sw.epilog:                                        ; preds = %if.end, %if.end, %vaarg.end146, %vaarg.end105, %vaarg.end82, %vaarg.end68, %vaarg.end28, %vaarg.end
  %size.0 = phi i64 [ 17, %vaarg.end146 ], [ 13, %vaarg.end105 ], [ 5, %vaarg.end82 ], [ 13, %vaarg.end68 ], [ 9, %vaarg.end28 ], [ 9, %vaarg.end ], [ 1, %if.end ], [ 1, %if.end ]
  %63 = load i64, i64* @position, align 8, !tbaa !20
  %add = add i64 %63, %size.0
  %div = lshr i64 %add, 16
  %div152 = lshr i64 %63, 16
  %cmp = icmp ugt i64 %div, %div152
  br i1 %cmp, label %if.then154, label %for.body.preheader

if.then154:                                       ; preds = %sw.epilog
  %64 = load i64, i64* @allocated, align 8, !tbaa !20
  %inc = add i64 %64, 1
  store i64 %inc, i64* @allocated, align 8, !tbaa !20
  %65 = load i8*, i8** @objcode, align 8, !tbaa !22
  %mul = shl i64 %inc, 16
  %call155 = call align 16 i8* @realloc(i8* %65, i64 %mul) #31
  store i8* %call155, i8** @objcode, align 8, !tbaa !22
  %tobool156.not = icmp eq i8* %call155, null
  br i1 %tobool156.not, label %if.then157, label %if.end159

if.then157:                                       ; preds = %if.then154
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([44 x i8], [44 x i8]* @str.8, i64 0, i64 0))
  call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end159:                                        ; preds = %if.then154
  %call160 = call i64 @quantum_memman(i64 65536) #31
  %.pre.pre = load i64, i64* @position, align 8, !tbaa !20
  br label %for.body.preheader

for.body.preheader:                               ; preds = %if.end159, %sw.epilog
  %.ph = phi i64 [ %63, %sw.epilog ], [ %.pre.pre, %if.end159 ]
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %66 = phi i64 [ %inc166, %for.body ], [ %.ph, %for.body.preheader ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %arrayidx164 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 %indvars.iv
  %67 = load i8, i8* %arrayidx164, align 1, !tbaa !9
  %68 = load i8*, i8** @objcode, align 8, !tbaa !22
  %arrayidx165 = getelementptr inbounds i8, i8* %68, i64 %66
  store i8 %67, i8* %arrayidx165, align 1, !tbaa !9
  %69 = load i64, i64* @position, align 8, !tbaa !20
  %inc166 = add i64 %69, 1
  store i64 %inc166, i64* @position, align 8, !tbaa !20
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %size.0
  br i1 %exitcond.not, label %cleanup, label %for.body, !llvm.loop !24

cleanup:                                          ; preds = %for.body, %entry
  %retval.0 = phi i32 [ 0, %entry ], [ 1, %for.body ]
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %1) #33
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %0) #33
  ret i32 %retval.0

UnifiedUnreachableBlock:                          ; preds = %if.then157, %sw.default
  unreachable
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #8

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.va_start(i8*) #9

; Function Attrs: nofree nounwind optsize
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #10

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn
declare noalias noundef align 16 i8* @realloc(i8* nocapture, i64 noundef) local_unnamed_addr #7

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #8

; Function Attrs: nofree noinline nounwind optsize uwtable
define i32 @quantum_objcode_write(i8* readonly %file) local_unnamed_addr #11 {
entry:
  %0 = load i32, i32* @opstatus, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !22
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.3, i64 0, i64 0), i64 73, i64 1, %struct._IO_FILE* %1) #35
  br label %cleanup

if.end:                                           ; preds = %entry
  %tobool1.not = icmp eq i8* %file, null
  %3 = load i8*, i8** @globalfile, align 8
  %spec.select = select i1 %tobool1.not, i8* %3, i8* %file
  %call4 = tail call %struct._IO_FILE* @fopen(i8* %spec.select, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0)) #34
  %cmp = icmp eq %struct._IO_FILE* %call4, null
  br i1 %cmp, label %cleanup, label %if.end6

if.end6:                                          ; preds = %if.end
  %4 = load i8*, i8** @objcode, align 8, !tbaa !22
  %5 = load i64, i64* @position, align 8, !tbaa !20
  %call7 = tail call i64 @fwrite(i8* %4, i64 %5, i64 1, %struct._IO_FILE* nonnull %call4) #34
  %call8 = tail call i32 @fclose(%struct._IO_FILE* nonnull %call4) #34
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.end6, %if.then
  %retval.0 = phi i32 [ 0, %if.end6 ], [ 1, %if.then ], [ -1, %if.end ]
  ret i32 %retval.0
}

; Function Attrs: nofree nounwind optsize
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #10

; Function Attrs: nofree nounwind optsize
declare noalias noundef %struct._IO_FILE* @fopen(i8* nocapture noundef readonly, i8* nocapture noundef readonly) local_unnamed_addr #10

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fclose(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
define void @quantum_objcode_file(i8* %file) local_unnamed_addr #12 {
entry:
  store i8* %file, i8** @globalfile, align 8, !tbaa !22
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_objcode_exit(i8* nocapture readnone %file) #0 {
entry:
  %call = tail call i32 @quantum_objcode_write(i8* null) #34
  tail call void @quantum_objcode_stop() #34
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_objcode_run(i8* %file, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %buf = alloca [80 x i8], align 16
  %buf185 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 0
  %tmp = alloca %struct.quantum_reg_struct, align 8
  %0 = getelementptr inbounds [80 x i8], [80 x i8]* %buf, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 80, i8* nonnull %0) #33
  %call = tail call %struct._IO_FILE* @fopen(i8* %file, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i64 0, i64 0)) #34
  %tobool.not = icmp eq %struct._IO_FILE* %call, null
  br i1 %tobool.not, label %if.then, label %for.cond.preheader

for.cond.preheader:                               ; preds = %entry
  %1 = bitcast %struct.quantum_reg_struct* %tmp to i8*
  %2 = bitcast %struct.quantum_reg_struct* %reg to i8*
  %call2180 = call i32 @feof(%struct._IO_FILE* nonnull %call) #31
  %tobool3.not181 = icmp eq i32 %call2180, 0
  br i1 %tobool3.not181, label %for.cond4.preheader, label %for.end94

if.then:                                          ; preds = %entry
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !22
  %call1 = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.6, i64 0, i64 0), i8* %file) #36
  tail call void @perror(i8* null) #36
  br label %cleanup

for.cond4.preheader:                              ; preds = %for.cond.preheader, %for.inc92
  %i.0182 = phi i32 [ %inc93, %for.inc92 ], [ 0, %for.cond.preheader ]
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(80) %buf185, i8 0, i64 80, i1 false)
  %call6 = call i32 @fgetc(%struct._IO_FILE* nonnull %call) #34
  %trunc = trunc i32 %call6 to i8
  switch i8 %trunc, label %sw.default [
    i8 0, label %sw.bb
    i8 1, label %sw.bb11
    i8 12, label %sw.bb11
    i8 2, label %sw.bb23
    i8 3, label %sw.bb36
    i8 4, label %sw.bb36
    i8 5, label %sw.bb36
    i8 6, label %sw.bb36
    i8 -127, label %sw.bb36
    i8 -126, label %sw.bb36
    i8 14, label %sw.bb36
    i8 7, label %sw.bb52
    i8 8, label %sw.bb52
    i8 9, label %sw.bb52
    i8 10, label %sw.bb52
    i8 11, label %sw.bb52
    i8 13, label %sw.bb73
    i8 -128, label %sw.bb87
    i8 -1, label %for.inc92
  ]

sw.bb:                                            ; preds = %for.cond4.preheader
  %call8 = call i64 @fread(i8* nonnull %0, i64 8, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call10 = call i64 @quantum_char2mu(i8* nonnull %0) #34
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %1) #33
  call void @quantum_new_qureg(%struct.quantum_reg_struct* nonnull sret(%struct.quantum_reg_struct) align 8 %tmp, i64 %call10, i32 12) #31
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %2, i8* noundef nonnull align 8 dereferenceable(32) %1, i64 32, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %1) #33
  br label %for.inc92

sw.bb11:                                          ; preds = %for.cond4.preheader, %for.cond4.preheader
  %call13 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call15 = call i32 @quantum_char2int(i8* nonnull %0) #34
  %call17 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call19 = call i32 @quantum_char2int(i8* nonnull %0) #34
  switch i8 %trunc, label %for.inc92 [
    i8 1, label %sw.bb21
    i8 12, label %sw.bb22
  ]

sw.bb21:                                          ; preds = %sw.bb11
  call void @quantum_cnot(i32 %call15, i32 %call19, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb22:                                          ; preds = %sw.bb11
  call void @quantum_cond_phase(i32 %call15, i32 %call19, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb23:                                          ; preds = %for.cond4.preheader
  %call25 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call27 = call i32 @quantum_char2int(i8* nonnull %0) #34
  %call29 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call31 = call i32 @quantum_char2int(i8* nonnull %0) #34
  %call33 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call35 = call i32 @quantum_char2int(i8* nonnull %0) #34
  call void @quantum_toffoli(i32 %call27, i32 %call31, i32 %call35, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb36:                                          ; preds = %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader
  %call38 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call40 = call i32 @quantum_char2int(i8* nonnull %0) #34
  switch i8 %trunc, label %for.inc92 [
    i8 3, label %sw.bb42
    i8 4, label %sw.bb43
    i8 5, label %sw.bb44
    i8 6, label %sw.bb45
    i8 -127, label %sw.bb46
    i8 -126, label %sw.bb48
    i8 14, label %sw.bb50
  ]

sw.bb42:                                          ; preds = %sw.bb36
  call void @quantum_sigma_x(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb43:                                          ; preds = %sw.bb36
  call void @quantum_sigma_y(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb44:                                          ; preds = %sw.bb36
  call void @quantum_sigma_z(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb45:                                          ; preds = %sw.bb36
  call void @quantum_hadamard(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb46:                                          ; preds = %sw.bb36
  %call47 = call i32 @quantum_bmeasure(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb48:                                          ; preds = %sw.bb36
  %call49 = call i32 @quantum_bmeasure_bitpreserve(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb50:                                          ; preds = %sw.bb36
  call void @quantum_swaptheleads(i32 %call40, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb52:                                          ; preds = %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader, %for.cond4.preheader
  %call54 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call56 = call i32 @quantum_char2int(i8* nonnull %0) #34
  %call58 = call i64 @fread(i8* nonnull %0, i64 8, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call60 = call double @quantum_char2double(i8* nonnull %0) #34
  switch i8 %trunc, label %for.inc92 [
    i8 7, label %sw.bb62
    i8 8, label %sw.bb64
    i8 9, label %sw.bb66
    i8 10, label %sw.bb68
    i8 11, label %sw.bb70
  ]

sw.bb62:                                          ; preds = %sw.bb52
  %conv63 = fptrunc double %call60 to float
  call void @quantum_r_x(i32 %call56, float %conv63, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb64:                                          ; preds = %sw.bb52
  %conv65 = fptrunc double %call60 to float
  call void @quantum_r_y(i32 %call56, float %conv65, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb66:                                          ; preds = %sw.bb52
  %conv67 = fptrunc double %call60 to float
  call void @quantum_r_z(i32 %call56, float %conv67, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb68:                                          ; preds = %sw.bb52
  %conv69 = fptrunc double %call60 to float
  call void @quantum_phase_kick(i32 %call56, float %conv69, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb70:                                          ; preds = %sw.bb52
  %conv71 = fptrunc double %call60 to float
  call void @quantum_phase_scale(i32 %call56, float %conv71, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb73:                                          ; preds = %for.cond4.preheader
  %call75 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call77 = call i32 @quantum_char2int(i8* nonnull %0) #34
  %call79 = call i64 @fread(i8* nonnull %0, i64 4, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call81 = call i32 @quantum_char2int(i8* nonnull %0) #34
  %call83 = call i64 @fread(i8* nonnull %0, i64 8, i64 1, %struct._IO_FILE* nonnull %call) #34
  %call85 = call double @quantum_char2double(i8* nonnull %0) #34
  %conv86 = fptrunc double %call85 to float
  call void @quantum_cond_phase_kick(i32 %call77, i32 %call81, float %conv86, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc92

sw.bb87:                                          ; preds = %for.cond4.preheader
  %call88 = call i64 @quantum_measure(%struct.quantum_reg_struct* byval(%struct.quantum_reg_struct) align 8 %reg) #31
  br label %for.inc92

sw.default:                                       ; preds = %for.cond4.preheader
  %conv7 = and i32 %call6, 255
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !22
  %call90 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.7, i64 0, i64 0), i32 %i.0182, i32 %conv7) #36
  br label %cleanup

for.inc92:                                        ; preds = %sw.bb, %sw.bb23, %sw.bb73, %sw.bb87, %for.cond4.preheader, %sw.bb11, %sw.bb22, %sw.bb21, %sw.bb36, %sw.bb50, %sw.bb48, %sw.bb46, %sw.bb45, %sw.bb44, %sw.bb43, %sw.bb42, %sw.bb52, %sw.bb70, %sw.bb68, %sw.bb66, %sw.bb64, %sw.bb62
  %inc93 = add nuw nsw i32 %i.0182, 1
  %call2 = call i32 @feof(%struct._IO_FILE* nonnull %call) #31
  %tobool3.not = icmp eq i32 %call2, 0
  br i1 %tobool3.not, label %for.cond4.preheader, label %for.end94, !llvm.loop !26

for.end94:                                        ; preds = %for.inc92, %for.cond.preheader
  %call95 = call i32 @fclose(%struct._IO_FILE* nonnull %call) #34
  br label %cleanup

cleanup:                                          ; preds = %for.end94, %sw.default, %if.then
  call void @llvm.lifetime.end.p0i8(i64 80, i8* nonnull %0) #33
  ret void
}

; Function Attrs: nofree nounwind optsize
declare noundef i32 @feof(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #10

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fprintf(%struct._IO_FILE* nocapture noundef, i8* nocapture noundef readonly, ...) local_unnamed_addr #10

; Function Attrs: nofree nounwind optsize
declare void @perror(i8* nocapture noundef readonly) local_unnamed_addr #10

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #13

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fgetc(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #10

; Function Attrs: nofree nounwind optsize
declare noundef i64 @fread(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #10

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #14

; Function Attrs: noinline nounwind optsize uwtable
define void @emul(i32 %a, i32 %L, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %mul = shl nsw i32 %width, 1
  %add = add nsw i32 %mul, 2
  %cmp10 = icmp sgt i32 %width, 0
  br i1 %cmp10, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %i.011.in = phi i32 [ %i.011, %for.inc ], [ %width, %entry ]
  %i.011 = add nsw i32 %i.011.in, -1
  %0 = shl nuw i32 1, %i.011
  %1 = and i32 %0, %a
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %for.inc, label %if.then

if.then:                                          ; preds = %for.body
  %add1 = add nsw i32 %i.011, %width
  tail call void @quantum_toffoli(i32 %add, i32 %L, i32 %add1, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %cmp = icmp sgt i32 %i.011.in, 1
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !27

for.end:                                          ; preds = %for.inc, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @muln(i32 %N, i32 %a, i32 %ctl, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %mul = shl nsw i32 %width, 1
  %add = or i32 %mul, 1
  %add2 = add nsw i32 %mul, 2
  tail call void @quantum_toffoli(i32 %ctl, i32 %add2, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %rem = srem i32 %a, %N
  tail call void @emul(i32 %rem, i32 %add, i32 %width, %struct.quantum_reg_struct* %reg) #34
  tail call void @quantum_toffoli(i32 %ctl, i32 %add2, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %cmp41 = icmp sgt i32 %width, 1
  br i1 %cmp41, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.042 = phi i32 [ %inc, %for.body ], [ 1, %entry ]
  %add7 = add nsw i32 %i.042, %add2
  tail call void @quantum_toffoli(i32 %ctl, i32 %add7, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %mul8 = shl i32 %a, %i.042
  %rem9 = srem i32 %mul8, %N
  tail call void @add_mod_n(i32 %N, i32 %rem9, i32 %width, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %ctl, i32 %add7, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %inc = add nuw nsw i32 %i.042, 1
  %exitcond.not = icmp eq i32 %inc, %width
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !28

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @muln_inv(i32 %N, i32 %a, i32 %ctl, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %mul = shl nsw i32 %width, 1
  %add = or i32 %mul, 1
  %call = tail call i32 @quantum_inverse_mod(i32 %N, i32 %a) #31
  %add2 = add nsw i32 %mul, 2
  %cmp46 = icmp sgt i32 %width, 1
  br i1 %cmp46, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.047.in = phi i32 [ %i.047, %for.body ], [ %width, %entry ]
  %i.047 = add nsw i32 %i.047.in, -1
  %add3 = add nsw i32 %add2, %i.047
  tail call void @quantum_toffoli(i32 %ctl, i32 %add3, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %mul4 = shl i32 %call, %i.047
  %rem = srem i32 %mul4, %N
  %sub5 = sub nsw i32 %N, %rem
  tail call void @add_mod_n(i32 %N, i32 %sub5, i32 %width, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %ctl, i32 %add3, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %cmp = icmp sgt i32 %i.047.in, 2
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !29

for.end:                                          ; preds = %for.body, %entry
  tail call void @quantum_toffoli(i32 %ctl, i32 %add2, i32 %add, %struct.quantum_reg_struct* %reg) #31
  %rem11 = srem i32 %call, %N
  tail call void @emul(i32 %rem11, i32 %add, i32 %width, %struct.quantum_reg_struct* %reg) #34
  tail call void @quantum_toffoli(i32 %ctl, i32 %add2, i32 %add, %struct.quantum_reg_struct* %reg) #31
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @mul_mod_n(i32 %N, i32 %a, i32 %ctl, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  tail call void @muln(i32 %N, i32 %a, i32 %ctl, i32 %width, %struct.quantum_reg_struct* %reg) #34
  tail call void @quantum_swaptheleads_omuln_controlled(i32 %ctl, i32 %width, %struct.quantum_reg_struct* %reg) #31
  tail call void @muln_inv(i32 %N, i32 %a, i32 %ctl, i32 %width, %struct.quantum_reg_struct* %reg) #34
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_cnot(i32 %control, i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %qec = alloca i32, align 4
  %0 = bitcast i32* %qec to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0) #33
  call void @quantum_qec_get_status(i32* nonnull %qec, i32* null) #31
  %1 = load i32, i32* %qec, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  call void @quantum_cnot_ft(i32 %control, i32 %target, %struct.quantum_reg_struct* %reg) #31
  br label %cleanup

if.else:                                          ; preds = %entry
  %call = call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 1, i32 %control, i32 %target) #31
  %tobool1.not = icmp eq i32 %call, 0
  br i1 %tobool1.not, label %for.cond.preheader, label %cleanup

for.cond.preheader:                               ; preds = %if.else
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %sh_prom = zext i32 %control to i64
  %shl = shl nuw i64 1, %sh_prom
  %sh_prom5 = zext i32 %target to i64
  %shl6 = shl nuw i64 1, %sh_prom5
  %cmp26 = icmp sgt i32 %2, 0
  br i1 %cmp26, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %3 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %2 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %3, i64 %indvars.iv, i32 1
  %4 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %4, %shl
  %tobool3.not = icmp eq i64 %and, 0
  br i1 %tobool3.not, label %for.inc, label %if.then4

if.then4:                                         ; preds = %for.body
  %xor = xor i64 %4, %shl6
  store i64 %xor, i64* %state, align 8, !tbaa !33
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !36

for.end:                                          ; preds = %for.inc, %for.cond.preheader
  call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %if.then, %for.end, %if.else
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0) #33
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_toffoli(i32 %control1, i32 %control2, i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %qec = alloca i32, align 4
  %0 = bitcast i32* %qec to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0) #33
  call void @quantum_qec_get_status(i32* nonnull %qec, i32* null) #31
  %1 = load i32, i32* %qec, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  call void @quantum_toffoli_ft(i32 %control1, i32 %control2, i32 %target, %struct.quantum_reg_struct* %reg) #31
  br label %cleanup

if.else:                                          ; preds = %entry
  %call = call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 2, i32 %control1, i32 %control2, i32 %target) #31
  %tobool1.not = icmp eq i32 %call, 0
  br i1 %tobool1.not, label %for.cond.preheader, label %cleanup

for.cond.preheader:                               ; preds = %if.else
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %sh_prom14 = zext i32 %target to i64
  %shl15 = shl nuw i64 1, %sh_prom14
  %cmp40 = icmp sgt i32 %2, 0
  br i1 %cmp40, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %sh_prom9 = zext i32 %control2 to i64
  %shl10 = shl nuw i64 1, %sh_prom9
  %sh_prom = zext i32 %control1 to i64
  %shl = shl nuw i64 1, %sh_prom
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %3 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %2 to i64
  %4 = freeze i64 %shl10
  %5 = or i64 %shl, %4
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %3, i64 %indvars.iv, i32 1
  %6 = load i64, i64* %state, align 8, !tbaa !33
  %7 = and i64 %6, %5
  %.not = icmp eq i64 %7, %5
  br i1 %.not, label %if.then13, label %for.inc

if.then13:                                        ; preds = %for.body
  %xor = xor i64 %6, %shl15
  store i64 %xor, i64* %state, align 8, !tbaa !33
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then13
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !37

for.end:                                          ; preds = %for.inc, %for.cond.preheader
  call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %if.then, %for.end, %if.else
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0) #33
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_unbounded_toffoli(i32 %controlling, %struct.quantum_reg_struct* %reg, ...) local_unnamed_addr #0 {
entry:
  %bits = alloca [1 x %struct.__va_list_tag], align 16
  %0 = bitcast [1 x %struct.__va_list_tag]* %bits to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %0) #33
  %conv = sext i32 %controlling to i64
  %mul = shl nsw i64 %conv, 2
  %call = tail call noalias align 16 i8* @malloc(i64 %mul) #31
  %1 = bitcast i8* %call to i32*
  %tobool.not = icmp eq i8* %call, null
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call1 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([40 x i8], [40 x i8]* @.str, i64 0, i64 0), i32 %controlling) #34
  tail call void @exit(i32 1) #32
  unreachable

if.end:                                           ; preds = %entry
  %call4 = tail call i64 @quantum_memman(i64 %mul) #31
  call void @llvm.va_start(i8* nonnull %0)
  %gp_offset_p = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %bits, i64 0, i64 0, i32 0
  %overflow_arg_area_p = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %bits, i64 0, i64 0, i32 2
  %2 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %bits, i64 0, i64 0, i32 3
  %reg_save_area = load i8*, i8** %2, align 16
  %cmp85 = icmp sgt i32 %controlling, 0
  br i1 %cmp85, label %for.body.preheader, label %if.end.for.end_crit_edge

if.end.for.end_crit_edge:                         ; preds = %if.end
  %gp_offset10.pre = load i32, i32* %gp_offset_p, align 16
  br label %for.end

for.body.preheader:                               ; preds = %if.end
  %wide.trip.count93 = zext i32 %controlling to i64
  %gp_offset.pre = load i32, i32* %gp_offset_p, align 16
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %vaarg.end
  %gp_offset = phi i32 [ %gp_offset.pre, %for.body.preheader ], [ %gp_offset95, %vaarg.end ]
  %indvars.iv91 = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next92, %vaarg.end ]
  %fits_in_gp = icmp ult i32 %gp_offset, 41
  br i1 %fits_in_gp, label %vaarg.in_reg, label %vaarg.in_mem

vaarg.in_reg:                                     ; preds = %for.body
  %3 = zext i32 %gp_offset to i64
  %4 = getelementptr i8, i8* %reg_save_area, i64 %3
  %5 = add nuw nsw i32 %gp_offset, 8
  store i32 %5, i32* %gp_offset_p, align 16
  br label %vaarg.end

vaarg.in_mem:                                     ; preds = %for.body
  %overflow_arg_area = load i8*, i8** %overflow_arg_area_p, align 8
  %overflow_arg_area.next = getelementptr i8, i8* %overflow_arg_area, i64 8
  store i8* %overflow_arg_area.next, i8** %overflow_arg_area_p, align 8
  br label %vaarg.end

vaarg.end:                                        ; preds = %vaarg.in_mem, %vaarg.in_reg
  %gp_offset95 = phi i32 [ %5, %vaarg.in_reg ], [ %gp_offset, %vaarg.in_mem ]
  %vaarg.addr.in = phi i8* [ %4, %vaarg.in_reg ], [ %overflow_arg_area, %vaarg.in_mem ]
  %vaarg.addr = bitcast i8* %vaarg.addr.in to i32*
  %6 = load i32, i32* %vaarg.addr, align 4
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %indvars.iv91
  store i32 %6, i32* %arrayidx, align 4, !tbaa !18
  %indvars.iv.next92 = add nuw nsw i64 %indvars.iv91, 1
  %exitcond94.not = icmp eq i64 %indvars.iv.next92, %wide.trip.count93
  br i1 %exitcond94.not, label %for.end, label %for.body, !llvm.loop !38

for.end:                                          ; preds = %vaarg.end, %if.end.for.end_crit_edge
  %gp_offset10 = phi i32 [ %gp_offset10.pre, %if.end.for.end_crit_edge ], [ %gp_offset95, %vaarg.end ]
  %fits_in_gp11 = icmp ult i32 %gp_offset10, 41
  br i1 %fits_in_gp11, label %vaarg.in_reg12, label %vaarg.in_mem14

vaarg.in_reg12:                                   ; preds = %for.end
  %7 = zext i32 %gp_offset10 to i64
  %8 = getelementptr i8, i8* %reg_save_area, i64 %7
  %9 = add nuw nsw i32 %gp_offset10, 8
  store i32 %9, i32* %gp_offset_p, align 16
  br label %vaarg.end18

vaarg.in_mem14:                                   ; preds = %for.end
  %overflow_arg_area16 = load i8*, i8** %overflow_arg_area_p, align 8
  %overflow_arg_area.next17 = getelementptr i8, i8* %overflow_arg_area16, i64 8
  store i8* %overflow_arg_area.next17, i8** %overflow_arg_area_p, align 8
  br label %vaarg.end18

vaarg.end18:                                      ; preds = %vaarg.in_mem14, %vaarg.in_reg12
  %vaarg.addr19.in = phi i8* [ %8, %vaarg.in_reg12 ], [ %overflow_arg_area16, %vaarg.in_mem14 ]
  %vaarg.addr19 = bitcast i8* %vaarg.addr19.in to i32*
  %10 = load i32, i32* %vaarg.addr19, align 4
  call void @llvm.va_end(i8* nonnull %0)
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %11 = load i32, i32* %size, align 4, !tbaa !30
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %sh_prom41 = zext i32 %10 to i64
  %shl42 = shl nuw i64 1, %sh_prom41
  %cmp2382 = icmp sgt i32 %11, 0
  br i1 %cmp2382, label %for.cond26.preheader.preheader, label %for.end50

for.cond26.preheader.preheader:                   ; preds = %vaarg.end18
  %wide.trip.count89 = zext i32 %11 to i64
  %wide.trip.count = zext i32 %controlling to i64
  br label %for.cond26.preheader

for.cond26.preheader:                             ; preds = %for.cond26.preheader.preheader, %for.inc48
  %indvars.iv87 = phi i64 [ 0, %for.cond26.preheader.preheader ], [ %indvars.iv.next88, %for.inc48 ]
  br i1 %cmp85, label %land.rhs.lr.ph, label %for.end37

land.rhs.lr.ph:                                   ; preds = %for.cond26.preheader
  %12 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %12, i64 %indvars.iv87, i32 1
  %13 = load i64, i64* %state, align 8, !tbaa !33
  br label %land.rhs

land.rhs:                                         ; preds = %land.rhs.lr.ph, %for.inc35
  %indvars.iv = phi i64 [ 0, %land.rhs.lr.ph ], [ %indvars.iv.next, %for.inc35 ]
  %arrayidx32 = getelementptr inbounds i32, i32* %1, i64 %indvars.iv
  %14 = load i32, i32* %arrayidx32, align 4, !tbaa !18
  %sh_prom = zext i32 %14 to i64
  %shl = shl nuw i64 1, %sh_prom
  %and = and i64 %shl, %13
  %tobool33.not = icmp eq i64 %and, 0
  br i1 %tobool33.not, label %for.end37.loopexit, label %for.inc35

for.inc35:                                        ; preds = %land.rhs
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %if.then40, label %land.rhs, !llvm.loop !39

for.end37.loopexit:                               ; preds = %land.rhs
  %15 = trunc i64 %indvars.iv to i32
  br label %for.end37

for.end37:                                        ; preds = %for.end37.loopexit, %for.cond26.preheader
  %j.0.lcssa = phi i32 [ 0, %for.cond26.preheader ], [ %15, %for.end37.loopexit ]
  %cmp38 = icmp eq i32 %j.0.lcssa, %controlling
  br i1 %cmp38, label %if.then40, label %for.inc48

if.then40:                                        ; preds = %for.inc35, %for.end37
  %16 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state46 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %16, i64 %indvars.iv87, i32 1
  %17 = load i64, i64* %state46, align 8, !tbaa !33
  %xor = xor i64 %17, %shl42
  store i64 %xor, i64* %state46, align 8, !tbaa !33
  br label %for.inc48

for.inc48:                                        ; preds = %for.end37, %if.then40
  %indvars.iv.next88 = add nuw nsw i64 %indvars.iv87, 1
  %exitcond90.not = icmp eq i64 %indvars.iv.next88, %wide.trip.count89
  br i1 %exitcond90.not, label %for.end50, label %for.cond26.preheader, !llvm.loop !40

for.end50:                                        ; preds = %for.inc48, %vaarg.end18
  call void @free(i8* %call) #31
  %sub = sub nsw i32 0, %controlling
  %conv51 = sext i32 %sub to i64
  %mul52 = shl nsw i64 %conv51, 2
  %call53 = call i64 @quantum_memman(i64 %mul52) #31
  call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %0) #33
  ret void
}

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.va_end(i8*) #9

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_sigma_x(i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %qec = alloca i32, align 4
  %0 = bitcast i32* %qec to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0) #33
  call void @quantum_qec_get_status(i32* nonnull %qec, i32* null) #31
  %1 = load i32, i32* %qec, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  call void @quantum_sigma_x_ft(i32 %target, %struct.quantum_reg_struct* %reg) #31
  br label %cleanup

if.else:                                          ; preds = %entry
  %call = call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 3, i32 %target) #31
  %tobool1.not = icmp eq i32 %call, 0
  br i1 %tobool1.not, label %for.cond.preheader, label %cleanup

for.cond.preheader:                               ; preds = %if.else
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %sh_prom = zext i32 %target to i64
  %shl = shl nuw i64 1, %sh_prom
  %cmp13 = icmp sgt i32 %2, 0
  br i1 %cmp13, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %3 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %2 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.body ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %3, i64 %indvars.iv, i32 1
  %4 = load i64, i64* %state, align 8, !tbaa !33
  %xor = xor i64 %4, %shl
  store i64 %xor, i64* %state, align 8, !tbaa !33
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !41

for.end:                                          ; preds = %for.body, %for.cond.preheader
  call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %if.then, %for.end, %if.else
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0) #33
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_sigma_y(i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 4, i32 %target) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %for.cond.preheader, label %cleanup

for.cond.preheader:                               ; preds = %entry
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %sh_prom = zext i32 %target to i64
  %shl = shl nuw i64 1, %sh_prom
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp51 = icmp sgt i32 %0, 0
  br i1 %cmp51, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond.preheader, %for.inc
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc ], [ 0, %for.cond.preheader ]
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 1
  %2 = load i64, i64* %state, align 8, !tbaa !33
  %xor = xor i64 %2, %shl
  store i64 %xor, i64* %state, align 8, !tbaa !33
  %and = and i64 %xor, %shl
  %tobool7.not = icmp eq i64 %and, 0
  %amplitude19.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 0
  %amplitude19.real = load float, float* %amplitude19.realp, align 8
  %amplitude19.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 1
  %amplitude19.imag = load float, float* %amplitude19.imagp, align 4
  %mul_ac20 = fmul float %amplitude19.real, 0.000000e+00
  br i1 %tobool7.not, label %if.else, label %if.then8

if.then8:                                         ; preds = %for.body
  %mul_bc = fmul float %amplitude19.imag, 0.000000e+00
  %mul_r = fsub float %mul_ac20, %amplitude19.imag
  %mul_i = fadd float %amplitude19.real, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %for.inc, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then8
  %isnan_cmp12 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp12, label %complex_mul_libcall, label %for.inc, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call13 = tail call <2 x float> @__mulsc3(float %amplitude19.real, float %amplitude19.imag, float 0.000000e+00, float 1.000000e+00) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call13, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call13, i32 1
  br label %for.inc

if.else:                                          ; preds = %for.body
  %mul_bc23 = fmul float %amplitude19.imag, -0.000000e+00
  %3 = fsub float %amplitude19.imag, %mul_ac20
  %mul_i25 = fsub float %mul_bc23, %amplitude19.real
  %isnan_cmp26 = fcmp uno float %3, 0.000000e+00
  br i1 %isnan_cmp26, label %complex_mul_imag_nan27, label %for.inc, !prof !42

complex_mul_imag_nan27:                           ; preds = %if.else
  %isnan_cmp28 = fcmp uno float %mul_i25, 0.000000e+00
  br i1 %isnan_cmp28, label %complex_mul_libcall29, label %for.inc, !prof !42

complex_mul_libcall29:                            ; preds = %complex_mul_imag_nan27
  %call30 = tail call <2 x float> @__mulsc3(float %amplitude19.real, float %amplitude19.imag, float -0.000000e+00, float -1.000000e+00) #31
  %coerce31.sroa.0.0.vec.extract = extractelement <2 x float> %call30, i32 0
  %coerce31.sroa.0.4.vec.extract = extractelement <2 x float> %call30, i32 1
  br label %for.inc

for.inc:                                          ; preds = %if.else, %complex_mul_imag_nan27, %complex_mul_libcall29, %if.then8, %complex_mul_imag_nan, %complex_mul_libcall
  %real_mul_phi.sink = phi float [ %mul_r, %if.then8 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce.sroa.0.0.vec.extract, %complex_mul_libcall ], [ %3, %if.else ], [ %3, %complex_mul_imag_nan27 ], [ %coerce31.sroa.0.0.vec.extract, %complex_mul_libcall29 ]
  %imag_mul_phi.sink = phi float [ %mul_i, %if.then8 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce.sroa.0.4.vec.extract, %complex_mul_libcall ], [ %mul_i25, %if.else ], [ %mul_i25, %complex_mul_imag_nan27 ], [ %coerce31.sroa.0.4.vec.extract, %complex_mul_libcall29 ]
  store float %real_mul_phi.sink, float* %amplitude19.realp, align 8
  store float %imag_mul_phi.sink, float* %amplitude19.imagp, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %4 = load i32, i32* %size, align 4, !tbaa !30
  %5 = sext i32 %4 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %5
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !43

for.end:                                          ; preds = %for.inc, %for.cond.preheader
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

declare <2 x float> @__mulsc3(float, float, float, float) local_unnamed_addr

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_sigma_z(i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 5, i32 %target) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %for.cond.preheader, label %cleanup

for.cond.preheader:                               ; preds = %entry
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %sh_prom = zext i32 %target to i64
  %shl = shl nuw i64 1, %sh_prom
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp19 = icmp sgt i32 %0, 0
  br i1 %cmp19, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond.preheader, %for.inc
  %1 = phi i32 [ %4, %for.inc ], [ %0, %for.cond.preheader ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc ], [ 0, %for.cond.preheader ]
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 1
  %3 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %3, %shl
  %tobool1.not = icmp eq i64 %and, 0
  br i1 %tobool1.not, label %for.inc, label %if.then2

if.then2:                                         ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fneg float %amplitude.real
  %mul_bd = fmul float %amplitude.imag, 0.000000e+00
  %mul_ad = fmul float %amplitude.real, 0.000000e+00
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fsub float %mul_ad, %amplitude.imag
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then2
  %isnan_cmp6 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp6, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call7 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float -1.000000e+00, float 0.000000e+00) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call7, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call7, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then2
  %real_mul_phi = phi float [ %mul_r, %if.then2 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then2 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %.pre = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc

for.inc:                                          ; preds = %for.body, %complex_mul_cont
  %4 = phi i32 [ %1, %for.body ], [ %.pre, %complex_mul_cont ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %5 = sext i32 %4 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %5
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !44

for.end:                                          ; preds = %for.inc, %for.cond.preheader
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_swaptheleads(i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %qec = alloca i32, align 4
  %0 = bitcast i32* %qec to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0) #33
  call void @quantum_qec_get_status(i32* nonnull %qec, i32* null) #31
  %1 = load i32, i32* %qec, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %for.cond3.preheader, label %for.cond.preheader

for.cond.preheader:                               ; preds = %entry
  %cmp97 = icmp sgt i32 %width, 0
  br i1 %cmp97, label %for.body, label %cleanup

for.cond3.preheader:                              ; preds = %entry
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %sh_prom = zext i32 %width to i64
  %notmask = shl nsw i64 -1, %sh_prom
  %2 = xor i64 %notmask, -1
  %cmp992 = icmp sgt i32 %width, 0
  %3 = load i32, i32* %size, align 4, !tbaa !30
  %cmp495 = icmp sgt i32 %3, 0
  br i1 %cmp495, label %for.body5, label %cleanup

for.body:                                         ; preds = %for.cond.preheader, %for.body
  %i.098 = phi i32 [ %inc, %for.body ], [ 0, %for.cond.preheader ]
  %add = add nsw i32 %i.098, %width
  call void @quantum_cnot(i32 %i.098, i32 %add, %struct.quantum_reg_struct* %reg) #34
  call void @quantum_cnot(i32 %add, i32 %i.098, %struct.quantum_reg_struct* %reg) #34
  call void @quantum_cnot(i32 %i.098, i32 %add, %struct.quantum_reg_struct* %reg) #34
  %inc = add nuw nsw i32 %i.098, 1
  %exitcond102.not = icmp eq i32 %inc, %width
  br i1 %exitcond102.not, label %cleanup, label %for.body, !llvm.loop !45

for.body5:                                        ; preds = %for.cond3.preheader, %for.end24
  %indvars.iv100 = phi i64 [ %indvars.iv.next101, %for.end24 ], [ 0, %for.cond3.preheader ]
  %call = call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 14, i32 %width) #31
  %tobool6.not = icmp eq i32 %call, 0
  br i1 %tobool6.not, label %if.end, label %cleanup

if.end:                                           ; preds = %for.body5
  %4 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv100, i32 1
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %rem = and i64 %5, %2
  %conv = trunc i64 %rem to i32
  br i1 %cmp992, label %for.body11, label %for.end24

for.body11:                                       ; preds = %if.end, %for.body11
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body11 ], [ 0, %if.end ]
  %pat2.094 = phi i32 [ %conv21, %for.body11 ], [ 0, %if.end ]
  %6 = trunc i64 %indvars.iv to i32
  %add16 = add nsw i32 %6, %width
  %sh_prom17 = zext i32 %add16 to i64
  %shl18 = shl nuw i64 1, %sh_prom17
  %and = and i64 %shl18, %5
  %7 = trunc i64 %and to i32
  %conv21 = add i32 %pat2.094, %7
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %sh_prom
  br i1 %exitcond.not, label %for.end24, label %for.body11, !llvm.loop !46

for.end24:                                        ; preds = %for.body11, %if.end
  %pat2.0.lcssa = phi i32 [ 0, %if.end ], [ %conv21, %for.body11 ]
  %add29 = add nsw i32 %pat2.0.lcssa, %conv
  %conv30 = sext i32 %add29 to i64
  %shl31 = shl i32 %conv, %width
  %conv32 = sext i32 %shl31 to i64
  %shr = ashr i32 %pat2.0.lcssa, %width
  %conv34 = sext i32 %shr to i64
  %sub = add i64 %5, %conv32
  %add33 = sub i64 %sub, %conv30
  %add35 = add i64 %add33, %conv34
  store i64 %add35, i64* %state, align 8, !tbaa !33
  %indvars.iv.next101 = add nuw nsw i64 %indvars.iv100, 1
  %8 = load i32, i32* %size, align 4, !tbaa !30
  %9 = sext i32 %8 to i64
  %cmp4 = icmp slt i64 %indvars.iv.next101, %9
  br i1 %cmp4, label %for.body5, label %cleanup, !llvm.loop !47

cleanup:                                          ; preds = %for.body, %for.body5, %for.end24, %for.cond.preheader, %for.cond3.preheader
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0) #33
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_swaptheleads_omuln_controlled(i32 %control, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %mul = shl nsw i32 %width, 1
  %add1 = add i32 %mul, 2
  %cmp29 = icmp sgt i32 %width, 0
  br i1 %cmp29, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.030 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %add = add nsw i32 %i.030, %width
  %add2 = add i32 %add1, %i.030
  tail call void @quantum_toffoli(i32 %control, i32 %add, i32 %add2, %struct.quantum_reg_struct* %reg) #34
  tail call void @quantum_toffoli(i32 %control, i32 %add2, i32 %add, %struct.quantum_reg_struct* %reg) #34
  tail call void @quantum_toffoli(i32 %control, i32 %add, i32 %add2, %struct.quantum_reg_struct* %reg) #34
  %inc = add nuw nsw i32 %i.030, 1
  %exitcond.not = icmp eq i32 %inc, %width
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !48

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_gate1(i32 %target, i64 %m.coerce0, { float, float }* readonly %m.coerce1, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %0 = icmp eq i64 %m.coerce0, 8589934594
  br i1 %0, label %for.cond.preheader, label %if.then

for.cond.preheader:                               ; preds = %entry
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %1 = load i32, i32* %hashw, align 8, !tbaa !49
  %cmp2700.not = icmp eq i32 %1, 31
  br i1 %cmp2700.not, label %for.cond3.preheader, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %2 = load i32*, i32** %hash, align 8, !tbaa !50
  br label %for.body

if.then:                                          ; preds = %entry
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([28 x i8], [28 x i8]* @str.15, i64 0, i64 0))
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

for.cond3.preheader:                              ; preds = %for.body, %for.cond.preheader
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %3 = load i32, i32* %size, align 4, !tbaa !30
  %cmp4696 = icmp sgt i32 %3, 0
  br i1 %cmp4696, label %for.body5, label %for.cond11.preheader

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv711 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next712, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %indvars.iv711
  store i32 0, i32* %arrayidx, align 4, !tbaa !18
  %indvars.iv.next712 = add nuw nsw i64 %indvars.iv711, 1
  %4 = load i32, i32* %hashw, align 8, !tbaa !49
  %shl = shl nuw i32 1, %4
  %5 = sext i32 %shl to i64
  %cmp2 = icmp slt i64 %indvars.iv.next712, %5
  br i1 %cmp2, label %for.body, label %for.cond3.preheader, !llvm.loop !51

for.cond11.preheader:                             ; preds = %for.body5, %for.cond3.preheader
  %.lcssa678 = phi i32 [ %3, %for.cond3.preheader ], [ %11, %for.body5 ]
  %sh_prom = zext i32 %target to i64
  %shl19 = shl nuw i64 1, %sh_prom
  %arrayidx24.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 1, i32 0
  %arrayidx24.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 1, i32 1
  %arrayidx38.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 2, i32 0
  %arrayidx38.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 2, i32 1
  %cmp13692 = icmp sgt i32 %.lcssa678, 0
  br i1 %cmp13692, label %for.body14.lr.ph, label %for.cond11.preheader.for.end59_crit_edge

for.cond11.preheader.for.end59_crit_edge:         ; preds = %for.cond11.preheader
  %.phi.trans.insert = bitcast %struct.quantum_reg_node_struct** %node to i8**
  %.pre = load i8*, i8** %.phi.trans.insert, align 8, !tbaa !32
  br label %for.end59

for.body14.lr.ph:                                 ; preds = %for.cond11.preheader
  %6 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %.lcssa678 to i64
  %7 = bitcast %struct.quantum_reg_node_struct* %6 to i8*
  br label %for.body14

for.body5:                                        ; preds = %for.cond3.preheader, %for.body5
  %indvars.iv709 = phi i64 [ %indvars.iv.next710, %for.body5 ], [ 0, %for.cond3.preheader ]
  %8 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %8, i64 %indvars.iv709, i32 1
  %9 = load i64, i64* %state, align 8, !tbaa !33
  %10 = trunc i64 %indvars.iv709 to i32
  tail call fastcc void @quantum_add_hash(i64 %9, i32 %10, %struct.quantum_reg_struct* nonnull %reg) #34
  %indvars.iv.next710 = add nuw nsw i64 %indvars.iv709, 1
  %11 = load i32, i32* %size, align 4, !tbaa !30
  %12 = sext i32 %11 to i64
  %cmp4 = icmp slt i64 %indvars.iv.next710, %12
  br i1 %cmp4, label %for.body5, label %for.cond11.preheader, !llvm.loop !52

for.body14:                                       ; preds = %for.body14.lr.ph, %for.inc57
  %indvars.iv706 = phi i64 [ 0, %for.body14.lr.ph ], [ %indvars.iv.next707, %for.inc57 ]
  %addsize.0693 = phi i32 [ 0, %for.body14.lr.ph ], [ %addsize.2, %for.inc57 ]
  %state18 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %6, i64 %indvars.iv706, i32 1
  %13 = load i64, i64* %state18, align 8, !tbaa !33
  %xor = xor i64 %13, %shl19
  %call20 = tail call fastcc i32 @quantum_get_state(i64 %xor, %struct.quantum_reg_struct* nonnull byval(%struct.quantum_reg_struct) align 8 %reg) #34
  %cmp21 = icmp eq i32 %call20, -1
  br i1 %cmp21, label %if.then22, label %for.inc57

if.then22:                                        ; preds = %for.body14
  %arrayidx24.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx24.imag = load float, float* %arrayidx24.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %arrayidx24.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %arrayidx24.imag, i32 1
  %call25 = tail call fastcc float @quantum_prob_inline(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call25 to double
  %cmp26 = fcmp ogt double %conv, 1.000000e-09
  %and = and i64 %13, %shl19
  %tobool.not = icmp ne i64 %and, 0
  %narrow = select i1 %cmp26, i1 %tobool.not, i1 false
  %spec.select = zext i1 %narrow to i32
  %addsize.1 = add nsw i32 %addsize.0693, %spec.select
  %arrayidx38.real = load float, float* %arrayidx38.realp, align 4
  %arrayidx38.imag = load float, float* %arrayidx38.imagp, align 4
  %coerce39.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %arrayidx38.real, i32 0
  %coerce39.sroa.0.4.vec.insert = insertelement <2 x float> %coerce39.sroa.0.0.vec.insert, float %arrayidx38.imag, i32 1
  %call40 = tail call fastcc float @quantum_prob_inline(<2 x float> %coerce39.sroa.0.4.vec.insert) #34
  %conv41 = fpext float %call40 to double
  %cmp42 = fcmp ogt double %conv41, 1.000000e-09
  br i1 %cmp42, label %land.lhs.true44, label %for.inc57

land.lhs.true44:                                  ; preds = %if.then22
  %tobool52.not = icmp eq i64 %and, 0
  %inc54 = zext i1 %tobool52.not to i32
  %spec.select667 = add nsw i32 %addsize.1, %inc54
  br label %for.inc57

for.inc57:                                        ; preds = %land.lhs.true44, %for.body14, %if.then22
  %addsize.2 = phi i32 [ %addsize.1, %if.then22 ], [ %addsize.0693, %for.body14 ], [ %spec.select667, %land.lhs.true44 ]
  %indvars.iv.next707 = add nuw nsw i64 %indvars.iv706, 1
  %exitcond708.not = icmp eq i64 %indvars.iv.next707, %wide.trip.count
  br i1 %exitcond708.not, label %for.end59, label %for.body14, !llvm.loop !53

for.end59:                                        ; preds = %for.inc57, %for.cond11.preheader.for.end59_crit_edge
  %14 = phi i8* [ %.pre, %for.cond11.preheader.for.end59_crit_edge ], [ %7, %for.inc57 ]
  %addsize.0.lcssa = phi i32 [ 0, %for.cond11.preheader.for.end59_crit_edge ], [ %addsize.2, %for.inc57 ]
  %.pre-phi = bitcast %struct.quantum_reg_node_struct** %node to i8**
  %add = add nsw i32 %addsize.0.lcssa, %.lcssa678
  %conv62 = sext i32 %add to i64
  %mul = shl nsw i64 %conv62, 4
  %call63 = tail call align 16 i8* @realloc(i8* %14, i64 %mul) #31
  store i8* %call63, i8** %.pre-phi, align 8, !tbaa !32
  %tobool66.not = icmp eq i8* %call63, null
  br i1 %tobool66.not, label %if.then67, label %if.end71

if.then67:                                        ; preds = %for.end59
  %15 = load i32, i32* %size, align 4, !tbaa !30
  %add69 = add nsw i32 %15, %addsize.0.lcssa
  %call70 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.2, i64 0, i64 0), i32 %add69) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end71:                                         ; preds = %for.end59
  %conv72 = sext i32 %addsize.0.lcssa to i64
  %mul73 = shl nsw i64 %conv72, 4
  %call74 = tail call i64 @quantum_memman(i64 %mul73) #31
  %cmp76690 = icmp sgt i32 %addsize.0.lcssa, 0
  br i1 %cmp76690, label %for.body78, label %for.end92

for.body78:                                       ; preds = %if.end71, %for.body78
  %i.3691 = phi i32 [ %inc91, %for.body78 ], [ 0, %if.end71 ]
  %16 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %17 = load i32, i32* %size, align 4, !tbaa !30
  %add81 = add nsw i32 %17, %i.3691
  %idxprom82 = sext i32 %add81 to i64
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %16, i64 %idxprom82, i32 0, i32 0
  %inc91 = add nuw nsw i32 %i.3691, 1
  %exitcond.not = icmp eq i32 %inc91, %addsize.0.lcssa
  %18 = bitcast float* %amplitude.realp to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false)
  br i1 %exitcond.not, label %for.end92, label %for.body78, !llvm.loop !54

for.end92:                                        ; preds = %for.body78, %if.end71
  %19 = load i32, i32* %size, align 4, !tbaa !30
  %add94 = add nsw i32 %19, %addsize.0.lcssa
  %conv95 = sext i32 %add94 to i64
  %call96 = tail call noalias align 16 i8* @calloc(i64 %conv95, i64 1) #31
  %tobool97.not = icmp eq i8* %call96, null
  br i1 %tobool97.not, label %if.then98, label %if.end104

if.then98:                                        ; preds = %for.end92
  %call103 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.3.16, i64 0, i64 0), i64 %conv95) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end104:                                        ; preds = %for.end92
  %conv106 = sext i32 %19 to i64
  %add109 = add nsw i64 %conv106, %conv72
  %call110 = tail call i64 @quantum_memman(i64 %add109) #31
  %20 = load i32, i32* %size, align 4, !tbaa !30
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %21 = load i32, i32* %width, align 8, !tbaa !55
  %sh_prom112 = zext i32 %21 to i64
  %shl113 = shl nuw i64 1, %sh_prom112
  %conv114 = uitofp i64 %shl113 to double
  %div = fdiv double 1.000000e+00, %conv114
  %div115 = fdiv double %div, 1.000000e+06
  %conv116 = fptrunc double %div115 to float
  %arrayidx191.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 0, i32 0
  %arrayidx191.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 0, i32 1
  %arrayidx168.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 3, i32 0
  %arrayidx168.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 3, i32 1
  %cmp119684 = icmp sgt i32 %20, 0
  br i1 %cmp119684, label %for.body121, label %for.end441

for.body121:                                      ; preds = %if.end104, %for.inc439.for.body121_crit_edge
  %22 = phi i8 [ %.pre713, %for.inc439.for.body121_crit_edge ], [ 0, %if.end104 ]
  %indvars.iv704 = phi i64 [ %indvars.iv.next705, %for.inc439.for.body121_crit_edge ], [ 0, %if.end104 ]
  %k.0685 = phi i32 [ %k.2, %for.inc439.for.body121_crit_edge ], [ %20, %if.end104 ]
  %tobool124.not = icmp eq i8 %22, 0
  br i1 %tobool124.not, label %if.then125, label %for.inc439

if.then125:                                       ; preds = %for.body121
  %23 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state129 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %indvars.iv704, i32 1
  %24 = load i64, i64* %state129, align 8, !tbaa !33
  %and132 = and i64 %24, %shl19
  %conv133 = trunc i64 %and132 to i32
  %xor142 = xor i64 %24, %shl19
  %call143 = tail call fastcc i32 @quantum_get_state(i64 %xor142, %struct.quantum_reg_struct* nonnull byval(%struct.quantum_reg_struct) align 8 %reg) #34
  %amplitude147.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %indvars.iv704, i32 0, i32 0
  %amplitude147.real = load float, float* %amplitude147.realp, align 8
  %amplitude147.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %indvars.iv704, i32 0, i32 1
  %amplitude147.imag = load float, float* %amplitude147.imagp, align 4
  %cmp148 = icmp sgt i32 %call143, -1
  br i1 %cmp148, label %if.then150, label %if.end157

if.then150:                                       ; preds = %if.then125
  %idxprom152674 = zext i32 %call143 to i64
  %amplitude154.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %idxprom152674, i32 0, i32 0
  %amplitude154.real = load float, float* %amplitude154.realp, align 8
  %amplitude154.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %idxprom152674, i32 0, i32 1
  %amplitude154.imag = load float, float* %amplitude154.imagp, align 4
  br label %if.end157

if.end157:                                        ; preds = %if.then150, %if.then125
  %tnot.sroa.0.0 = phi float [ %amplitude154.real, %if.then150 ], [ 0.000000e+00, %if.then125 ]
  %tnot.sroa.9.0 = phi float [ %amplitude154.imag, %if.then150 ], [ 0.000000e+00, %if.then125 ]
  %tobool158 = icmp ne i32 %conv133, 0
  br i1 %tobool158, label %if.then159, label %if.else

if.then159:                                       ; preds = %if.end157
  %arrayidx161.real = load float, float* %arrayidx38.realp, align 4
  %arrayidx161.imag = load float, float* %arrayidx38.imagp, align 4
  %mul_ac = fmul float %tnot.sroa.0.0, %arrayidx161.real
  %mul_bd = fmul float %tnot.sroa.9.0, %arrayidx161.imag
  %mul_ad = fmul float %tnot.sroa.9.0, %arrayidx161.real
  %mul_bc = fmul float %tnot.sroa.0.0, %arrayidx161.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then159
  %isnan_cmp164 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp164, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call165 = tail call <2 x float> @__mulsc3(float %arrayidx161.real, float %arrayidx161.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce166.sroa.0.0.vec.extract = extractelement <2 x float> %call165, i32 0
  %coerce166.sroa.0.4.vec.extract = extractelement <2 x float> %call165, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then159
  %real_mul_phi = phi float [ %mul_r, %if.then159 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce166.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then159 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce166.sroa.0.4.vec.extract, %complex_mul_libcall ]
  %arrayidx168.real = load float, float* %arrayidx168.realp, align 4
  %arrayidx168.imag = load float, float* %arrayidx168.imagp, align 4
  %mul_ac171 = fmul float %amplitude147.real, %arrayidx168.real
  %mul_bd172 = fmul float %amplitude147.imag, %arrayidx168.imag
  %mul_ad173 = fmul float %amplitude147.imag, %arrayidx168.real
  %mul_bc174 = fmul float %amplitude147.real, %arrayidx168.imag
  %mul_r175 = fsub float %mul_ac171, %mul_bd172
  %mul_i176 = fadd float %mul_ad173, %mul_bc174
  %isnan_cmp177 = fcmp uno float %mul_r175, 0.000000e+00
  br i1 %isnan_cmp177, label %complex_mul_imag_nan178, label %if.end238, !prof !42

complex_mul_imag_nan178:                          ; preds = %complex_mul_cont
  %isnan_cmp179 = fcmp uno float %mul_i176, 0.000000e+00
  br i1 %isnan_cmp179, label %complex_mul_libcall180, label %if.end238, !prof !42

complex_mul_libcall180:                           ; preds = %complex_mul_imag_nan178
  %call181 = tail call <2 x float> @__mulsc3(float %arrayidx168.real, float %arrayidx168.imag, float %amplitude147.real, float %amplitude147.imag) #31
  %coerce182.sroa.0.0.vec.extract = extractelement <2 x float> %call181, i32 0
  %coerce182.sroa.0.4.vec.extract = extractelement <2 x float> %call181, i32 1
  br label %if.end238

if.else:                                          ; preds = %if.end157
  %arrayidx191.real = load float, float* %arrayidx191.realp, align 4
  %arrayidx191.imag = load float, float* %arrayidx191.imagp, align 4
  %mul_ac196 = fmul float %amplitude147.real, %arrayidx191.real
  %mul_bd197 = fmul float %amplitude147.imag, %arrayidx191.imag
  %mul_ad198 = fmul float %amplitude147.imag, %arrayidx191.real
  %mul_bc199 = fmul float %amplitude147.real, %arrayidx191.imag
  %mul_r200 = fsub float %mul_ac196, %mul_bd197
  %mul_i201 = fadd float %mul_ad198, %mul_bc199
  %isnan_cmp202 = fcmp uno float %mul_r200, 0.000000e+00
  br i1 %isnan_cmp202, label %complex_mul_imag_nan203, label %complex_mul_cont208, !prof !42

complex_mul_imag_nan203:                          ; preds = %if.else
  %isnan_cmp204 = fcmp uno float %mul_i201, 0.000000e+00
  br i1 %isnan_cmp204, label %complex_mul_libcall205, label %complex_mul_cont208, !prof !42

complex_mul_libcall205:                           ; preds = %complex_mul_imag_nan203
  %call206 = tail call <2 x float> @__mulsc3(float %arrayidx191.real, float %arrayidx191.imag, float %amplitude147.real, float %amplitude147.imag) #31
  %coerce207.sroa.0.0.vec.extract = extractelement <2 x float> %call206, i32 0
  %coerce207.sroa.0.4.vec.extract = extractelement <2 x float> %call206, i32 1
  br label %complex_mul_cont208

complex_mul_cont208:                              ; preds = %complex_mul_libcall205, %complex_mul_imag_nan203, %if.else
  %real_mul_phi209 = phi float [ %mul_r200, %if.else ], [ %mul_r200, %complex_mul_imag_nan203 ], [ %coerce207.sroa.0.0.vec.extract, %complex_mul_libcall205 ]
  %imag_mul_phi210 = phi float [ %mul_i201, %if.else ], [ %mul_i201, %complex_mul_imag_nan203 ], [ %coerce207.sroa.0.4.vec.extract, %complex_mul_libcall205 ]
  %arrayidx212.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx212.imag = load float, float* %arrayidx24.imagp, align 4
  %mul_ac217 = fmul float %tnot.sroa.0.0, %arrayidx212.real
  %mul_bd218 = fmul float %tnot.sroa.9.0, %arrayidx212.imag
  %mul_ad219 = fmul float %tnot.sroa.9.0, %arrayidx212.real
  %mul_bc220 = fmul float %tnot.sroa.0.0, %arrayidx212.imag
  %mul_r221 = fsub float %mul_ac217, %mul_bd218
  %mul_i222 = fadd float %mul_ad219, %mul_bc220
  %isnan_cmp223 = fcmp uno float %mul_r221, 0.000000e+00
  br i1 %isnan_cmp223, label %complex_mul_imag_nan224, label %if.end238.thread, !prof !42

complex_mul_imag_nan224:                          ; preds = %complex_mul_cont208
  %isnan_cmp225 = fcmp uno float %mul_i222, 0.000000e+00
  br i1 %isnan_cmp225, label %complex_mul_libcall226, label %if.end238.thread, !prof !42

complex_mul_libcall226:                           ; preds = %complex_mul_imag_nan224
  %call227 = tail call <2 x float> @__mulsc3(float %arrayidx212.real, float %arrayidx212.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce228.sroa.0.0.vec.extract = extractelement <2 x float> %call227, i32 0
  %coerce228.sroa.0.4.vec.extract = extractelement <2 x float> %call227, i32 1
  br label %if.end238.thread

if.end238:                                        ; preds = %complex_mul_cont, %complex_mul_imag_nan178, %complex_mul_libcall180
  %real_mul_phi184 = phi float [ %mul_r175, %complex_mul_cont ], [ %mul_r175, %complex_mul_imag_nan178 ], [ %coerce182.sroa.0.0.vec.extract, %complex_mul_libcall180 ]
  %imag_mul_phi185 = phi float [ %mul_i176, %complex_mul_cont ], [ %mul_i176, %complex_mul_imag_nan178 ], [ %coerce182.sroa.0.4.vec.extract, %complex_mul_libcall180 ]
  %add.r = fadd float %real_mul_phi, %real_mul_phi184
  %add.i = fadd float %imag_mul_phi, %imag_mul_phi185
  %25 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude189.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %25, i64 %indvars.iv704, i32 0, i32 0
  %amplitude189.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %25, i64 %indvars.iv704, i32 0, i32 1
  store float %add.r, float* %amplitude189.realp, align 8
  store float %add.i, float* %amplitude189.imagp, align 4
  br i1 %cmp148, label %if.then243, label %if.else342

if.end238.thread:                                 ; preds = %complex_mul_cont208, %complex_mul_imag_nan224, %complex_mul_libcall226
  %real_mul_phi230 = phi float [ %mul_r221, %complex_mul_cont208 ], [ %mul_r221, %complex_mul_imag_nan224 ], [ %coerce228.sroa.0.0.vec.extract, %complex_mul_libcall226 ]
  %imag_mul_phi231 = phi float [ %mul_i222, %complex_mul_cont208 ], [ %mul_i222, %complex_mul_imag_nan224 ], [ %coerce228.sroa.0.4.vec.extract, %complex_mul_libcall226 ]
  %add.r232 = fadd float %real_mul_phi209, %real_mul_phi230
  %add.i233 = fadd float %imag_mul_phi210, %imag_mul_phi231
  %26 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude237.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %26, i64 %indvars.iv704, i32 0, i32 0
  %amplitude237.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %26, i64 %indvars.iv704, i32 0, i32 1
  store float %add.r232, float* %amplitude237.realp, align 8
  store float %add.i233, float* %amplitude237.imagp, align 4
  br i1 %cmp148, label %if.else292, label %if.else342

if.then243:                                       ; preds = %if.end238
  %arrayidx245.real = load float, float* %arrayidx191.realp, align 4
  %arrayidx245.imag = load float, float* %arrayidx191.imagp, align 4
  %mul_ac250 = fmul float %tnot.sroa.0.0, %arrayidx245.real
  %mul_bd251 = fmul float %tnot.sroa.9.0, %arrayidx245.imag
  %mul_ad252 = fmul float %tnot.sroa.9.0, %arrayidx245.real
  %mul_bc253 = fmul float %tnot.sroa.0.0, %arrayidx245.imag
  %mul_r254 = fsub float %mul_ac250, %mul_bd251
  %mul_i255 = fadd float %mul_ad252, %mul_bc253
  %isnan_cmp256 = fcmp uno float %mul_r254, 0.000000e+00
  br i1 %isnan_cmp256, label %complex_mul_imag_nan257, label %complex_mul_cont262, !prof !42

complex_mul_imag_nan257:                          ; preds = %if.then243
  %isnan_cmp258 = fcmp uno float %mul_i255, 0.000000e+00
  br i1 %isnan_cmp258, label %complex_mul_libcall259, label %complex_mul_cont262, !prof !42

complex_mul_libcall259:                           ; preds = %complex_mul_imag_nan257
  %call260 = tail call <2 x float> @__mulsc3(float %arrayidx245.real, float %arrayidx245.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce261.sroa.0.0.vec.extract = extractelement <2 x float> %call260, i32 0
  %coerce261.sroa.0.4.vec.extract = extractelement <2 x float> %call260, i32 1
  br label %complex_mul_cont262

complex_mul_cont262:                              ; preds = %complex_mul_libcall259, %complex_mul_imag_nan257, %if.then243
  %real_mul_phi263 = phi float [ %mul_r254, %if.then243 ], [ %mul_r254, %complex_mul_imag_nan257 ], [ %coerce261.sroa.0.0.vec.extract, %complex_mul_libcall259 ]
  %imag_mul_phi264 = phi float [ %mul_i255, %if.then243 ], [ %mul_i255, %complex_mul_imag_nan257 ], [ %coerce261.sroa.0.4.vec.extract, %complex_mul_libcall259 ]
  %arrayidx266.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx266.imag = load float, float* %arrayidx24.imagp, align 4
  %mul_ac271 = fmul float %amplitude147.real, %arrayidx266.real
  %mul_bd272 = fmul float %amplitude147.imag, %arrayidx266.imag
  %mul_ad273 = fmul float %amplitude147.imag, %arrayidx266.real
  %mul_bc274 = fmul float %amplitude147.real, %arrayidx266.imag
  %mul_r275 = fsub float %mul_ac271, %mul_bd272
  %mul_i276 = fadd float %mul_ad273, %mul_bc274
  %isnan_cmp277 = fcmp uno float %mul_r275, 0.000000e+00
  br i1 %isnan_cmp277, label %complex_mul_imag_nan278, label %complex_mul_cont283, !prof !42

complex_mul_imag_nan278:                          ; preds = %complex_mul_cont262
  %isnan_cmp279 = fcmp uno float %mul_i276, 0.000000e+00
  br i1 %isnan_cmp279, label %complex_mul_libcall280, label %complex_mul_cont283, !prof !42

complex_mul_libcall280:                           ; preds = %complex_mul_imag_nan278
  %call281 = tail call <2 x float> @__mulsc3(float %arrayidx266.real, float %arrayidx266.imag, float %amplitude147.real, float %amplitude147.imag) #31
  %coerce282.sroa.0.0.vec.extract = extractelement <2 x float> %call281, i32 0
  %coerce282.sroa.0.4.vec.extract = extractelement <2 x float> %call281, i32 1
  br label %complex_mul_cont283

complex_mul_cont283:                              ; preds = %complex_mul_libcall280, %complex_mul_imag_nan278, %complex_mul_cont262
  %real_mul_phi284 = phi float [ %mul_r275, %complex_mul_cont262 ], [ %mul_r275, %complex_mul_imag_nan278 ], [ %coerce282.sroa.0.0.vec.extract, %complex_mul_libcall280 ]
  %imag_mul_phi285 = phi float [ %mul_i276, %complex_mul_cont262 ], [ %mul_i276, %complex_mul_imag_nan278 ], [ %coerce282.sroa.0.4.vec.extract, %complex_mul_libcall280 ]
  %add.r286 = fadd float %real_mul_phi263, %real_mul_phi284
  %add.i287 = fadd float %imag_mul_phi264, %imag_mul_phi285
  %27 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %idxprom289675 = zext i32 %call143 to i64
  %amplitude291.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %27, i64 %idxprom289675, i32 0, i32 0
  %amplitude291.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %27, i64 %idxprom289675, i32 0, i32 1
  store float %add.r286, float* %amplitude291.realp, align 8
  store float %add.i287, float* %amplitude291.imagp, align 4
  br label %if.then434

if.else292:                                       ; preds = %if.end238.thread
  %arrayidx294.real = load float, float* %arrayidx38.realp, align 4
  %arrayidx294.imag = load float, float* %arrayidx38.imagp, align 4
  %mul_ac299 = fmul float %amplitude147.real, %arrayidx294.real
  %mul_bd300 = fmul float %amplitude147.imag, %arrayidx294.imag
  %mul_ad301 = fmul float %amplitude147.imag, %arrayidx294.real
  %mul_bc302 = fmul float %amplitude147.real, %arrayidx294.imag
  %mul_r303 = fsub float %mul_ac299, %mul_bd300
  %mul_i304 = fadd float %mul_ad301, %mul_bc302
  %isnan_cmp305 = fcmp uno float %mul_r303, 0.000000e+00
  br i1 %isnan_cmp305, label %complex_mul_imag_nan306, label %complex_mul_cont311, !prof !42

complex_mul_imag_nan306:                          ; preds = %if.else292
  %isnan_cmp307 = fcmp uno float %mul_i304, 0.000000e+00
  br i1 %isnan_cmp307, label %complex_mul_libcall308, label %complex_mul_cont311, !prof !42

complex_mul_libcall308:                           ; preds = %complex_mul_imag_nan306
  %call309 = tail call <2 x float> @__mulsc3(float %arrayidx294.real, float %arrayidx294.imag, float %amplitude147.real, float %amplitude147.imag) #31
  %coerce310.sroa.0.0.vec.extract = extractelement <2 x float> %call309, i32 0
  %coerce310.sroa.0.4.vec.extract = extractelement <2 x float> %call309, i32 1
  br label %complex_mul_cont311

complex_mul_cont311:                              ; preds = %complex_mul_libcall308, %complex_mul_imag_nan306, %if.else292
  %real_mul_phi312 = phi float [ %mul_r303, %if.else292 ], [ %mul_r303, %complex_mul_imag_nan306 ], [ %coerce310.sroa.0.0.vec.extract, %complex_mul_libcall308 ]
  %imag_mul_phi313 = phi float [ %mul_i304, %if.else292 ], [ %mul_i304, %complex_mul_imag_nan306 ], [ %coerce310.sroa.0.4.vec.extract, %complex_mul_libcall308 ]
  %arrayidx315.real = load float, float* %arrayidx168.realp, align 4
  %arrayidx315.imag = load float, float* %arrayidx168.imagp, align 4
  %mul_ac320 = fmul float %tnot.sroa.0.0, %arrayidx315.real
  %mul_bd321 = fmul float %tnot.sroa.9.0, %arrayidx315.imag
  %mul_ad322 = fmul float %tnot.sroa.9.0, %arrayidx315.real
  %mul_bc323 = fmul float %tnot.sroa.0.0, %arrayidx315.imag
  %mul_r324 = fsub float %mul_ac320, %mul_bd321
  %mul_i325 = fadd float %mul_ad322, %mul_bc323
  %isnan_cmp326 = fcmp uno float %mul_r324, 0.000000e+00
  br i1 %isnan_cmp326, label %complex_mul_imag_nan327, label %complex_mul_cont332, !prof !42

complex_mul_imag_nan327:                          ; preds = %complex_mul_cont311
  %isnan_cmp328 = fcmp uno float %mul_i325, 0.000000e+00
  br i1 %isnan_cmp328, label %complex_mul_libcall329, label %complex_mul_cont332, !prof !42

complex_mul_libcall329:                           ; preds = %complex_mul_imag_nan327
  %call330 = tail call <2 x float> @__mulsc3(float %arrayidx315.real, float %arrayidx315.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce331.sroa.0.0.vec.extract = extractelement <2 x float> %call330, i32 0
  %coerce331.sroa.0.4.vec.extract = extractelement <2 x float> %call330, i32 1
  br label %complex_mul_cont332

complex_mul_cont332:                              ; preds = %complex_mul_libcall329, %complex_mul_imag_nan327, %complex_mul_cont311
  %real_mul_phi333 = phi float [ %mul_r324, %complex_mul_cont311 ], [ %mul_r324, %complex_mul_imag_nan327 ], [ %coerce331.sroa.0.0.vec.extract, %complex_mul_libcall329 ]
  %imag_mul_phi334 = phi float [ %mul_i325, %complex_mul_cont311 ], [ %mul_i325, %complex_mul_imag_nan327 ], [ %coerce331.sroa.0.4.vec.extract, %complex_mul_libcall329 ]
  %add.r335 = fadd float %real_mul_phi312, %real_mul_phi333
  %add.i336 = fadd float %imag_mul_phi313, %imag_mul_phi334
  %28 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %idxprom338677 = zext i32 %call143 to i64
  %amplitude340.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %28, i64 %idxprom338677, i32 0, i32 0
  %amplitude340.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %28, i64 %idxprom338677, i32 0, i32 1
  store float %add.r335, float* %amplitude340.realp, align 8
  store float %add.i336, float* %amplitude340.imagp, align 4
  br label %if.then434

if.else342:                                       ; preds = %if.end238.thread, %if.end238
  %arrayidx344.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx344.imag = load float, float* %arrayidx24.imagp, align 4
  %coerce345.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %arrayidx344.real, i32 0
  %coerce345.sroa.0.4.vec.insert = insertelement <2 x float> %coerce345.sroa.0.0.vec.insert, float %arrayidx344.imag, i32 1
  %call346 = tail call fastcc float @quantum_prob_inline(<2 x float> %coerce345.sroa.0.4.vec.insert) #34
  %conv347 = fpext float %call346 to double
  %cmp348 = fcmp olt double %conv347, 1.000000e-09
  %or.cond = select i1 %cmp348, i1 %tobool158, i1 false
  br i1 %or.cond, label %for.end441.loopexit, label %if.end353

if.end353:                                        ; preds = %if.else342
  %arrayidx355.real = load float, float* %arrayidx38.realp, align 4
  %arrayidx355.imag = load float, float* %arrayidx38.imagp, align 4
  %coerce356.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %arrayidx355.real, i32 0
  %coerce356.sroa.0.4.vec.insert = insertelement <2 x float> %coerce356.sroa.0.0.vec.insert, float %arrayidx355.imag, i32 1
  %call357 = tail call fastcc float @quantum_prob_inline(<2 x float> %coerce356.sroa.0.4.vec.insert) #34
  %conv358 = fpext float %call357 to double
  %cmp359 = fcmp uge double %conv358, 1.000000e-09
  %or.cond512 = select i1 %cmp359, i1 true, i1 %tobool158
  br i1 %or.cond512, label %if.end364, label %for.end441.loopexit

if.end364:                                        ; preds = %if.end353
  %29 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state368 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %29, i64 %indvars.iv704, i32 1
  %30 = load i64, i64* %state368, align 8, !tbaa !33
  %xor371 = xor i64 %30, %shl19
  %idxprom373 = sext i32 %k.0685 to i64
  %state375 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %29, i64 %idxprom373, i32 1
  store i64 %xor371, i64* %state375, align 8, !tbaa !33
  br i1 %tobool158, label %if.then377, label %if.else403

if.then377:                                       ; preds = %if.end364
  %arrayidx379.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx379.imag = load float, float* %arrayidx24.imagp, align 4
  %mul_ac384 = fmul float %amplitude147.real, %arrayidx379.real
  %mul_bd385 = fmul float %amplitude147.imag, %arrayidx379.imag
  %mul_ad386 = fmul float %amplitude147.imag, %arrayidx379.real
  %mul_bc387 = fmul float %amplitude147.real, %arrayidx379.imag
  %mul_r388 = fsub float %mul_ac384, %mul_bd385
  %mul_i389 = fadd float %mul_ad386, %mul_bc387
  %isnan_cmp390 = fcmp uno float %mul_r388, 0.000000e+00
  br i1 %isnan_cmp390, label %complex_mul_imag_nan391, label %if.end431, !prof !42

complex_mul_imag_nan391:                          ; preds = %if.then377
  %isnan_cmp392 = fcmp uno float %mul_i389, 0.000000e+00
  br i1 %isnan_cmp392, label %complex_mul_libcall393, label %if.end431, !prof !42

complex_mul_libcall393:                           ; preds = %complex_mul_imag_nan391
  %call394 = tail call <2 x float> @__mulsc3(float %arrayidx379.real, float %arrayidx379.imag, float %amplitude147.real, float %amplitude147.imag) #31
  br label %if.end431.sink.split

if.else403:                                       ; preds = %if.end364
  %arrayidx405.real = load float, float* %arrayidx38.realp, align 4
  %arrayidx405.imag = load float, float* %arrayidx38.imagp, align 4
  %mul_ac410 = fmul float %amplitude147.real, %arrayidx405.real
  %mul_bd411 = fmul float %amplitude147.imag, %arrayidx405.imag
  %mul_ad412 = fmul float %amplitude147.imag, %arrayidx405.real
  %mul_bc413 = fmul float %amplitude147.real, %arrayidx405.imag
  %mul_r414 = fsub float %mul_ac410, %mul_bd411
  %mul_i415 = fadd float %mul_ad412, %mul_bc413
  %isnan_cmp416 = fcmp uno float %mul_r414, 0.000000e+00
  br i1 %isnan_cmp416, label %complex_mul_imag_nan417, label %if.end431, !prof !42

complex_mul_imag_nan417:                          ; preds = %if.else403
  %isnan_cmp418 = fcmp uno float %mul_i415, 0.000000e+00
  br i1 %isnan_cmp418, label %complex_mul_libcall419, label %if.end431, !prof !42

complex_mul_libcall419:                           ; preds = %complex_mul_imag_nan417
  %call420 = tail call <2 x float> @__mulsc3(float %arrayidx405.real, float %arrayidx405.imag, float %amplitude147.real, float %amplitude147.imag) #31
  br label %if.end431.sink.split

if.end431.sink.split:                             ; preds = %complex_mul_libcall393, %complex_mul_libcall419
  %call420.sink724 = phi <2 x float> [ %call420, %complex_mul_libcall419 ], [ %call394, %complex_mul_libcall393 ]
  %coerce421.sroa.0.0.vec.extract = extractelement <2 x float> %call420.sink724, i32 0
  %coerce421.sroa.0.4.vec.extract = extractelement <2 x float> %call420.sink724, i32 1
  %.pre714 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  br label %if.end431

if.end431:                                        ; preds = %if.end431.sink.split, %if.else403, %complex_mul_imag_nan417, %if.then377, %complex_mul_imag_nan391
  %.sink723 = phi %struct.quantum_reg_node_struct* [ %29, %if.then377 ], [ %29, %complex_mul_imag_nan391 ], [ %29, %if.else403 ], [ %29, %complex_mul_imag_nan417 ], [ %.pre714, %if.end431.sink.split ]
  %real_mul_phi397.sink = phi float [ %mul_r388, %if.then377 ], [ %mul_r388, %complex_mul_imag_nan391 ], [ %mul_r414, %if.else403 ], [ %mul_r414, %complex_mul_imag_nan417 ], [ %coerce421.sroa.0.0.vec.extract, %if.end431.sink.split ]
  %imag_mul_phi398.sink = phi float [ %mul_i389, %if.then377 ], [ %mul_i389, %complex_mul_imag_nan391 ], [ %mul_i415, %if.else403 ], [ %mul_i415, %complex_mul_imag_nan417 ], [ %coerce421.sroa.0.4.vec.extract, %if.end431.sink.split ]
  %amplitude402.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %.sink723, i64 %idxprom373, i32 0, i32 0
  %amplitude402.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %.sink723, i64 %idxprom373, i32 0, i32 1
  store float %real_mul_phi397.sink, float* %amplitude402.realp, align 8
  store float %imag_mul_phi398.sink, float* %amplitude402.imagp, align 4
  %inc430 = add nsw i32 %k.0685, 1
  br label %for.inc439

if.then434:                                       ; preds = %complex_mul_cont283, %complex_mul_cont332
  %idxprom435676.pre-phi = phi i64 [ %idxprom289675, %complex_mul_cont283 ], [ %idxprom338677, %complex_mul_cont332 ]
  %arrayidx436 = getelementptr inbounds i8, i8* %call96, i64 %idxprom435676.pre-phi
  store i8 1, i8* %arrayidx436, align 1, !tbaa !9
  br label %for.inc439

for.inc439:                                       ; preds = %if.end431, %for.body121, %if.then434
  %k.2 = phi i32 [ %k.0685, %for.body121 ], [ %k.0685, %if.then434 ], [ %inc430, %if.end431 ]
  %indvars.iv.next705 = add nuw nsw i64 %indvars.iv704, 1
  %31 = load i32, i32* %size, align 4, !tbaa !30
  %32 = sext i32 %31 to i64
  %cmp119 = icmp slt i64 %indvars.iv.next705, %32
  br i1 %cmp119, label %for.inc439.for.body121_crit_edge, label %for.end441.loopexit, !llvm.loop !56

for.inc439.for.body121_crit_edge:                 ; preds = %for.inc439
  %arrayidx123.phi.trans.insert = getelementptr inbounds i8, i8* %call96, i64 %indvars.iv.next705
  %.pre713 = load i8, i8* %arrayidx123.phi.trans.insert, align 1, !tbaa !9
  br label %for.body121

for.end441.loopexit:                              ; preds = %if.end353, %if.else342, %for.inc439
  %.pre716 = load i32, i32* %size, align 4, !tbaa !30
  br label %for.end441

for.end441:                                       ; preds = %for.end441.loopexit, %if.end104
  %33 = phi i32 [ %.pre716, %for.end441.loopexit ], [ %20, %if.end104 ]
  %add443 = add nsw i32 %33, %addsize.0.lcssa
  store i32 %add443, i32* %size, align 4, !tbaa !30
  tail call void @free(i8* %call96) #31
  %sub = sub nsw i32 0, %add443
  %conv445 = sext i32 %sub to i64
  %call447 = tail call i64 @quantum_memman(i64 %conv445) #31
  %34 = load i32, i32* %size, align 4, !tbaa !30
  %cmp450679 = icmp sgt i32 %34, 0
  br i1 %cmp450679, label %for.body452, label %if.end511

for.body452:                                      ; preds = %for.end441, %for.inc487
  %35 = phi i32 [ %39, %for.inc487 ], [ %34, %for.end441 ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc487 ], [ 0, %for.end441 ]
  %j.0681 = phi i32 [ %j.1, %for.inc487 ], [ 0, %for.end441 ]
  %decsize.0680 = phi i32 [ %decsize.1, %for.inc487 ], [ 0, %for.end441 ]
  %36 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude456.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %indvars.iv, i32 0, i32 0
  %amplitude456.real = load float, float* %amplitude456.realp, align 8
  %amplitude456.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %indvars.iv, i32 0, i32 1
  %amplitude456.imag = load float, float* %amplitude456.imagp, align 4
  %coerce457.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude456.real, i32 0
  %coerce457.sroa.0.4.vec.insert = insertelement <2 x float> %coerce457.sroa.0.0.vec.insert, float %amplitude456.imag, i32 1
  %call458 = tail call fastcc float @quantum_prob_inline(<2 x float> %coerce457.sroa.0.4.vec.insert) #34
  %cmp459 = fcmp olt float %call458, %conv116
  br i1 %cmp459, label %if.then461, label %if.else464

if.then461:                                       ; preds = %for.body452
  %inc462 = add nsw i32 %j.0681, 1
  %inc463 = add nsw i32 %decsize.0680, 1
  br label %for.inc487

if.else464:                                       ; preds = %for.body452
  %tobool465.not = icmp eq i32 %j.0681, 0
  br i1 %tobool465.not, label %for.inc487, label %if.then466

if.then466:                                       ; preds = %if.else464
  %state470 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %indvars.iv, i32 1
  %37 = load i64, i64* %state470, align 8, !tbaa !33
  %38 = trunc i64 %indvars.iv to i32
  %sub472 = sub nsw i32 %38, %j.0681
  %idxprom473 = sext i32 %sub472 to i64
  %state475 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %idxprom473, i32 1
  store i64 %37, i64* %state475, align 8, !tbaa !33
  %amplitude484.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %idxprom473, i32 0, i32 0
  %amplitude484.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %idxprom473, i32 0, i32 1
  store float %amplitude456.real, float* %amplitude484.realp, align 8
  store float %amplitude456.imag, float* %amplitude484.imagp, align 4
  %.pre717 = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc487

for.inc487:                                       ; preds = %if.then461, %if.then466, %if.else464
  %39 = phi i32 [ %35, %if.then461 ], [ %.pre717, %if.then466 ], [ %35, %if.else464 ]
  %decsize.1 = phi i32 [ %inc463, %if.then461 ], [ %decsize.0680, %if.then466 ], [ %decsize.0680, %if.else464 ]
  %j.1 = phi i32 [ %inc462, %if.then461 ], [ %j.0681, %if.then466 ], [ 0, %if.else464 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %40 = sext i32 %39 to i64
  %cmp450 = icmp slt i64 %indvars.iv.next, %40
  br i1 %cmp450, label %for.body452, label %for.end489, !llvm.loop !57

for.end489:                                       ; preds = %for.inc487
  %tobool490.not = icmp eq i32 %decsize.1, 0
  br i1 %tobool490.not, label %if.end511, label %if.then491

if.then491:                                       ; preds = %for.end489
  %sub493 = sub nsw i32 %39, %decsize.1
  store i32 %sub493, i32* %size, align 4, !tbaa !30
  %41 = load i8*, i8** %.pre-phi, align 8, !tbaa !32
  %conv496 = sext i32 %sub493 to i64
  %mul497 = shl nsw i64 %conv496, 4
  %call498 = tail call align 16 i8* @realloc(i8* %41, i64 %mul497) #31
  store i8* %call498, i8** %.pre-phi, align 8, !tbaa !32
  %tobool501.not = icmp eq i8* %call498, null
  br i1 %tobool501.not, label %if.then502, label %if.end506

if.then502:                                       ; preds = %if.then491
  %42 = load i32, i32* %size, align 4, !tbaa !30
  %add504 = add nsw i32 %42, %addsize.0.lcssa
  %call505 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.2, i64 0, i64 0), i32 %add504) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end506:                                        ; preds = %if.then491
  %sub507 = sub nsw i32 0, %decsize.1
  %conv508 = sext i32 %sub507 to i64
  %mul509 = shl nsw i64 %conv508, 4
  %call510 = tail call i64 @quantum_memman(i64 %mul509) #31
  br label %if.end511

if.end511:                                        ; preds = %for.end441, %if.end506, %for.end489
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then502, %if.then98, %if.then67, %if.then
  unreachable
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
define internal fastcc void @quantum_add_hash(i64 %a, i32 %pos, %struct.quantum_reg_struct* nocapture readonly %reg) unnamed_addr #16 {
entry:
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %0 = load i32, i32* %hashw, align 8, !tbaa !49
  %call = tail call fastcc i32 @quantum_hash64(i64 %a, i32 %0) #34
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %1 = load i32*, i32** %hash, align 8, !tbaa !50
  %shl = shl nuw i32 1, %0
  %idxprom12 = sext i32 %call to i64
  %arrayidx13 = getelementptr inbounds i32, i32* %1, i64 %idxprom12
  %2 = load i32, i32* %arrayidx13, align 4, !tbaa !18
  %tobool.not14 = icmp eq i32 %2, 0
  br i1 %tobool.not14, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %i.015 = phi i32 [ %spec.store.select, %while.body ], [ %call, %entry ]
  %inc = add nsw i32 %i.015, 1
  %cmp = icmp eq i32 %inc, %shl
  %spec.store.select = select i1 %cmp, i32 0, i32 %inc
  %idxprom = sext i32 %spec.store.select to i64
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %idxprom
  %3 = load i32, i32* %arrayidx, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %3, 0
  br i1 %tobool.not, label %while.end, label %while.body, !llvm.loop !58

while.end:                                        ; preds = %while.body, %entry
  %idxprom.lcssa = phi i64 [ %idxprom12, %entry ], [ %idxprom, %while.body ]
  %arrayidx.le = getelementptr inbounds i32, i32* %1, i64 %idxprom.lcssa
  %add = add nsw i32 %pos, 1
  store i32 %add, i32* %arrayidx.le, align 4, !tbaa !18
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readonly uwtable
define internal fastcc i32 @quantum_get_state(i64 %a, %struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) unnamed_addr #2 {
entry:
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %0 = load i32, i32* %hashw, align 8, !tbaa !49
  %call = tail call fastcc i32 @quantum_hash64(i64 %a, i32 %0) #34
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %1 = load i32*, i32** %hash, align 8, !tbaa !50
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %shl = shl nuw i32 1, %0
  %idxprom20 = sext i32 %call to i64
  %arrayidx21 = getelementptr inbounds i32, i32* %1, i64 %idxprom20
  %3 = load i32, i32* %arrayidx21, align 4, !tbaa !18
  %tobool.not22 = icmp eq i32 %3, 0
  br i1 %tobool.not22, label %cleanup, label %while.body

while.body:                                       ; preds = %entry, %if.end
  %4 = phi i32 [ %6, %if.end ], [ %3, %entry ]
  %i.023 = phi i32 [ %spec.store.select, %if.end ], [ %call, %entry ]
  %sub = add nsw i32 %4, -1
  %idxprom4 = sext i32 %sub to i64
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %idxprom4, i32 1
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %cmp = icmp eq i64 %5, %a
  br i1 %cmp, label %cleanup, label %if.end

if.end:                                           ; preds = %while.body
  %inc = add nsw i32 %i.023, 1
  %cmp11 = icmp eq i32 %inc, %shl
  %spec.store.select = select i1 %cmp11, i32 0, i32 %inc
  %idxprom = sext i32 %spec.store.select to i64
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %idxprom
  %6 = load i32, i32* %arrayidx, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %6, 0
  br i1 %tobool.not, label %cleanup, label %while.body, !llvm.loop !59

cleanup:                                          ; preds = %while.body, %if.end, %entry
  %retval.0 = phi i32 [ -1, %entry ], [ -1, %if.end ], [ %sub, %while.body ]
  ret i32 %retval.0
}

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_prob_inline(<2 x float> %a.coerce) unnamed_addr #17 {
entry:
  %call = tail call fastcc float @quantum_real(<2 x float> %a.coerce) #34
  %call6 = tail call fastcc float @quantum_imag(<2 x float> %a.coerce) #34
  %mul7 = fmul float %call6, %call6
  %0 = tail call float @llvm.fmuladd.f32(float %call, float %call, float %mul7)
  ret float %0
}

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare noalias noundef align 16 i8* @calloc(i64 noundef, i64 noundef) local_unnamed_addr #18

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_real(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.0.vec.extract = extractelement <2 x float> %a.coerce, i32 0
  ret float %a.sroa.0.0.vec.extract
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_imag(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.4.vec.extract = extractelement <2 x float> %a.coerce, i32 1
  ret float %a.sroa.0.4.vec.extract
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fmuladd.f32(float, float, float) #20

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc i32 @quantum_hash64(i64 %key, i32 %width) unnamed_addr #21 {
entry:
  %shr = lshr i64 %key, 32
  %conv1 = xor i64 %shr, %key
  %0 = trunc i64 %conv1 to i32
  %conv2 = mul i32 %0, -1640562687
  %sub = sub nsw i32 32, %width
  %shr3 = lshr i32 %conv2, %sub
  ret i32 %shr3
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_gate2(i32 %control, i32 %target, i64 %m.coerce0, { float, float }* readonly %m.coerce1, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %0 = icmp eq i64 %m.coerce0, 17179869188
  br i1 %0, label %for.cond.preheader, label %if.then

for.cond.preheader:                               ; preds = %entry
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %1 = load i32, i32* %hashw, align 8, !tbaa !49
  %cmp2680.not = icmp eq i32 %1, 31
  br i1 %cmp2680.not, label %for.cond3.preheader, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %2 = load i32*, i32** %hash, align 8, !tbaa !50
  br label %for.body

if.then:                                          ; preds = %entry
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([28 x i8], [28 x i8]* @str.5, i64 0, i64 0))
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

for.cond3.preheader:                              ; preds = %for.body, %for.cond.preheader
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %3 = load i32, i32* %size, align 4, !tbaa !30
  %cmp4676 = icmp sgt i32 %3, 0
  br i1 %cmp4676, label %for.body5, label %for.cond11.preheader

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv691 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next692, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %indvars.iv691
  store i32 0, i32* %arrayidx, align 4, !tbaa !18
  %indvars.iv.next692 = add nuw nsw i64 %indvars.iv691, 1
  %4 = load i32, i32* %hashw, align 8, !tbaa !49
  %shl = shl nuw i32 1, %4
  %5 = sext i32 %shl to i64
  %cmp2 = icmp slt i64 %indvars.iv.next692, %5
  br i1 %cmp2, label %for.body, label %for.cond3.preheader, !llvm.loop !60

for.cond11.preheader:                             ; preds = %for.body5, %for.cond3.preheader
  %.lcssa660 = phi i32 [ %3, %for.cond3.preheader ], [ %11, %for.body5 ]
  %sh_prom = zext i32 %target to i64
  %shl19 = shl nuw i64 1, %sh_prom
  %arrayidx24.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 1, i32 0
  %arrayidx24.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 1, i32 1
  %arrayidx35.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 2, i32 0
  %arrayidx35.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 2, i32 1
  %cmp13672 = icmp sgt i32 %.lcssa660, 0
  br i1 %cmp13672, label %for.body14.lr.ph, label %for.cond11.preheader.for.end54_crit_edge

for.cond11.preheader.for.end54_crit_edge:         ; preds = %for.cond11.preheader
  %.phi.trans.insert = bitcast %struct.quantum_reg_node_struct** %node to i8**
  %.pre = load i8*, i8** %.phi.trans.insert, align 8, !tbaa !32
  br label %for.end54

for.body14.lr.ph:                                 ; preds = %for.cond11.preheader
  %6 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %.lcssa660 to i64
  %7 = bitcast %struct.quantum_reg_node_struct* %6 to i8*
  br label %for.body14

for.body5:                                        ; preds = %for.cond3.preheader, %for.body5
  %indvars.iv689 = phi i64 [ %indvars.iv.next690, %for.body5 ], [ 0, %for.cond3.preheader ]
  %8 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %8, i64 %indvars.iv689, i32 1
  %9 = load i64, i64* %state, align 8, !tbaa !33
  %10 = trunc i64 %indvars.iv689 to i32
  tail call fastcc void @quantum_add_hash(i64 %9, i32 %10, %struct.quantum_reg_struct* nonnull %reg) #34
  %indvars.iv.next690 = add nuw nsw i64 %indvars.iv689, 1
  %11 = load i32, i32* %size, align 4, !tbaa !30
  %12 = sext i32 %11 to i64
  %cmp4 = icmp slt i64 %indvars.iv.next690, %12
  br i1 %cmp4, label %for.body5, label %for.cond11.preheader, !llvm.loop !61

for.body14:                                       ; preds = %for.body14.lr.ph, %for.inc52
  %indvars.iv686 = phi i64 [ 0, %for.body14.lr.ph ], [ %indvars.iv.next687, %for.inc52 ]
  %addsize.0673 = phi i32 [ 0, %for.body14.lr.ph ], [ %addsize.2, %for.inc52 ]
  %state18 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %6, i64 %indvars.iv686, i32 1
  %13 = load i64, i64* %state18, align 8, !tbaa !33
  %xor = xor i64 %13, %shl19
  %call20 = tail call fastcc i32 @quantum_get_state(i64 %xor, %struct.quantum_reg_struct* nonnull byval(%struct.quantum_reg_struct) align 8 %reg) #34
  %cmp21 = icmp eq i32 %call20, -1
  br i1 %cmp21, label %if.then22, label %for.inc52

if.then22:                                        ; preds = %for.body14
  %arrayidx24.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx24.imag = load float, float* %arrayidx24.imagp, align 4
  %cmp.r = fcmp une float %arrayidx24.real, 0.000000e+00
  %cmp.i = fcmp une float %arrayidx24.imag, 0.000000e+00
  %or.ri = or i1 %cmp.r, %cmp.i
  %and = and i64 %13, %shl19
  %tobool.not = icmp ne i64 %and, 0
  %narrow = select i1 %or.ri, i1 %tobool.not, i1 false
  %spec.select = zext i1 %narrow to i32
  %addsize.1 = add nsw i32 %addsize.0673, %spec.select
  %arrayidx35.real = load float, float* %arrayidx35.realp, align 4
  %arrayidx35.imag = load float, float* %arrayidx35.imagp, align 4
  %cmp.r36 = fcmp une float %arrayidx35.real, 0.000000e+00
  %cmp.i37 = fcmp une float %arrayidx35.imag, 0.000000e+00
  %or.ri38 = or i1 %cmp.r36, %cmp.i37
  br i1 %or.ri38, label %land.lhs.true39, label %for.inc52

land.lhs.true39:                                  ; preds = %if.then22
  %tobool47.not = icmp eq i64 %and, 0
  %inc49 = zext i1 %tobool47.not to i32
  %spec.select653 = add nsw i32 %addsize.1, %inc49
  br label %for.inc52

for.inc52:                                        ; preds = %land.lhs.true39, %for.body14, %if.then22
  %addsize.2 = phi i32 [ %addsize.1, %if.then22 ], [ %addsize.0673, %for.body14 ], [ %spec.select653, %land.lhs.true39 ]
  %indvars.iv.next687 = add nuw nsw i64 %indvars.iv686, 1
  %exitcond688.not = icmp eq i64 %indvars.iv.next687, %wide.trip.count
  br i1 %exitcond688.not, label %for.end54, label %for.body14, !llvm.loop !62

for.end54:                                        ; preds = %for.inc52, %for.cond11.preheader.for.end54_crit_edge
  %14 = phi i8* [ %.pre, %for.cond11.preheader.for.end54_crit_edge ], [ %7, %for.inc52 ]
  %addsize.0.lcssa = phi i32 [ 0, %for.cond11.preheader.for.end54_crit_edge ], [ %addsize.2, %for.inc52 ]
  %.pre-phi = bitcast %struct.quantum_reg_node_struct** %node to i8**
  %add = add nsw i32 %addsize.0.lcssa, %.lcssa660
  %conv = sext i32 %add to i64
  %mul = shl nsw i64 %conv, 4
  %call57 = tail call align 16 i8* @realloc(i8* %14, i64 %mul) #31
  store i8* %call57, i8** %.pre-phi, align 8, !tbaa !32
  %tobool60.not = icmp eq i8* %call57, null
  br i1 %tobool60.not, label %if.then61, label %if.end65

if.then61:                                        ; preds = %for.end54
  %15 = load i32, i32* %size, align 4, !tbaa !30
  %add63 = add nsw i32 %15, %addsize.0.lcssa
  %call64 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.2, i64 0, i64 0), i32 %add63) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end65:                                         ; preds = %for.end54
  %conv66 = sext i32 %addsize.0.lcssa to i64
  %mul67 = shl nsw i64 %conv66, 4
  %call68 = tail call i64 @quantum_memman(i64 %mul67) #31
  %cmp70670 = icmp sgt i32 %addsize.0.lcssa, 0
  br i1 %cmp70670, label %for.body72, label %for.end86

for.body72:                                       ; preds = %if.end65, %for.body72
  %i.3671 = phi i32 [ %inc85, %for.body72 ], [ 0, %if.end65 ]
  %16 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %17 = load i32, i32* %size, align 4, !tbaa !30
  %add75 = add nsw i32 %17, %i.3671
  %idxprom76 = sext i32 %add75 to i64
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %16, i64 %idxprom76, i32 0, i32 0
  %inc85 = add nuw nsw i32 %i.3671, 1
  %exitcond.not = icmp eq i32 %inc85, %addsize.0.lcssa
  %18 = bitcast float* %amplitude.realp to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false)
  br i1 %exitcond.not, label %for.end86, label %for.body72, !llvm.loop !63

for.end86:                                        ; preds = %for.body72, %if.end65
  %19 = load i32, i32* %size, align 4, !tbaa !30
  %add88 = add nsw i32 %19, %addsize.0.lcssa
  %conv89 = sext i32 %add88 to i64
  %call90 = tail call noalias align 16 i8* @calloc(i64 %conv89, i64 1) #31
  %tobool91.not = icmp eq i8* %call90, null
  br i1 %tobool91.not, label %if.then92, label %if.end98

if.then92:                                        ; preds = %for.end86
  %call97 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.3.16, i64 0, i64 0), i64 %conv89) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end98:                                         ; preds = %for.end86
  %conv100 = sext i32 %19 to i64
  %add103 = add nsw i64 %conv100, %conv66
  %call104 = tail call i64 @quantum_memman(i64 %add103) #31
  %20 = load i32, i32* %size, align 4, !tbaa !30
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %21 = load i32, i32* %width, align 8, !tbaa !55
  %sh_prom106 = zext i32 %21 to i64
  %shl107 = shl nuw i64 1, %sh_prom106
  %conv108 = uitofp i64 %shl107 to double
  %div = fdiv double 1.000000e+00, %conv108
  %div109 = fdiv double %div, 1.000000e+06
  %conv110 = fptrunc double %div109 to float
  %arrayidx184.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 0, i32 0
  %arrayidx184.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 0, i32 1
  %arrayidx161.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 3, i32 0
  %arrayidx161.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 3, i32 1
  %cmp113666 = icmp sgt i32 %20, 0
  br i1 %cmp113666, label %for.body115, label %for.end431

for.body115:                                      ; preds = %if.end98, %for.inc429.for.body115_crit_edge
  %22 = phi i8 [ %.pre693, %for.inc429.for.body115_crit_edge ], [ 0, %if.end98 ]
  %indvars.iv684 = phi i64 [ %indvars.iv.next685, %for.inc429.for.body115_crit_edge ], [ 0, %if.end98 ]
  %k.0667 = phi i32 [ %k.2, %for.inc429.for.body115_crit_edge ], [ %20, %if.end98 ]
  %tobool118.not = icmp eq i8 %22, 0
  br i1 %tobool118.not, label %if.then119, label %for.inc429

if.then119:                                       ; preds = %for.body115
  %23 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state123 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %indvars.iv684, i32 1
  %24 = load i64, i64* %state123, align 8, !tbaa !33
  %and126 = and i64 %24, %shl19
  %conv127 = trunc i64 %and126 to i32
  %xor136 = xor i64 %24, %shl19
  %call137 = tail call fastcc i32 @quantum_get_state(i64 %xor136, %struct.quantum_reg_struct* nonnull byval(%struct.quantum_reg_struct) align 8 %reg) #34
  %amplitude141.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %indvars.iv684, i32 0, i32 0
  %amplitude141.real = load float, float* %amplitude141.realp, align 8
  %amplitude141.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %indvars.iv684, i32 0, i32 1
  %amplitude141.imag = load float, float* %amplitude141.imagp, align 4
  %cmp142 = icmp sgt i32 %call137, -1
  br i1 %cmp142, label %if.then144, label %if.end151

if.then144:                                       ; preds = %if.then119
  %idxprom146656 = zext i32 %call137 to i64
  %amplitude148.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %idxprom146656, i32 0, i32 0
  %amplitude148.real = load float, float* %amplitude148.realp, align 8
  %amplitude148.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %23, i64 %idxprom146656, i32 0, i32 1
  %amplitude148.imag = load float, float* %amplitude148.imagp, align 4
  br label %if.end151

if.end151:                                        ; preds = %if.then144, %if.then119
  %tnot.sroa.0.0 = phi float [ %amplitude148.real, %if.then144 ], [ 0.000000e+00, %if.then119 ]
  %tnot.sroa.9.0 = phi float [ %amplitude148.imag, %if.then144 ], [ 0.000000e+00, %if.then119 ]
  %tobool152 = icmp ne i32 %conv127, 0
  br i1 %tobool152, label %if.then153, label %if.else

if.then153:                                       ; preds = %if.end151
  %arrayidx155.real = load float, float* %arrayidx35.realp, align 4
  %arrayidx155.imag = load float, float* %arrayidx35.imagp, align 4
  %mul_ac = fmul float %tnot.sroa.0.0, %arrayidx155.real
  %mul_bd = fmul float %tnot.sroa.9.0, %arrayidx155.imag
  %mul_ad = fmul float %tnot.sroa.9.0, %arrayidx155.real
  %mul_bc = fmul float %tnot.sroa.0.0, %arrayidx155.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then153
  %isnan_cmp158 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp158, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call159 = tail call <2 x float> @__mulsc3(float %arrayidx155.real, float %arrayidx155.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call159, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call159, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then153
  %real_mul_phi = phi float [ %mul_r, %if.then153 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then153 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce.sroa.0.4.vec.extract, %complex_mul_libcall ]
  %arrayidx161.real = load float, float* %arrayidx161.realp, align 4
  %arrayidx161.imag = load float, float* %arrayidx161.imagp, align 4
  %mul_ac164 = fmul float %amplitude141.real, %arrayidx161.real
  %mul_bd165 = fmul float %amplitude141.imag, %arrayidx161.imag
  %mul_ad166 = fmul float %amplitude141.imag, %arrayidx161.real
  %mul_bc167 = fmul float %amplitude141.real, %arrayidx161.imag
  %mul_r168 = fsub float %mul_ac164, %mul_bd165
  %mul_i169 = fadd float %mul_ad166, %mul_bc167
  %isnan_cmp170 = fcmp uno float %mul_r168, 0.000000e+00
  br i1 %isnan_cmp170, label %complex_mul_imag_nan171, label %if.end231, !prof !42

complex_mul_imag_nan171:                          ; preds = %complex_mul_cont
  %isnan_cmp172 = fcmp uno float %mul_i169, 0.000000e+00
  br i1 %isnan_cmp172, label %complex_mul_libcall173, label %if.end231, !prof !42

complex_mul_libcall173:                           ; preds = %complex_mul_imag_nan171
  %call174 = tail call <2 x float> @__mulsc3(float %arrayidx161.real, float %arrayidx161.imag, float %amplitude141.real, float %amplitude141.imag) #31
  %coerce175.sroa.0.0.vec.extract = extractelement <2 x float> %call174, i32 0
  %coerce175.sroa.0.4.vec.extract = extractelement <2 x float> %call174, i32 1
  br label %if.end231

if.else:                                          ; preds = %if.end151
  %arrayidx184.real = load float, float* %arrayidx184.realp, align 4
  %arrayidx184.imag = load float, float* %arrayidx184.imagp, align 4
  %mul_ac189 = fmul float %amplitude141.real, %arrayidx184.real
  %mul_bd190 = fmul float %amplitude141.imag, %arrayidx184.imag
  %mul_ad191 = fmul float %amplitude141.imag, %arrayidx184.real
  %mul_bc192 = fmul float %amplitude141.real, %arrayidx184.imag
  %mul_r193 = fsub float %mul_ac189, %mul_bd190
  %mul_i194 = fadd float %mul_ad191, %mul_bc192
  %isnan_cmp195 = fcmp uno float %mul_r193, 0.000000e+00
  br i1 %isnan_cmp195, label %complex_mul_imag_nan196, label %complex_mul_cont201, !prof !42

complex_mul_imag_nan196:                          ; preds = %if.else
  %isnan_cmp197 = fcmp uno float %mul_i194, 0.000000e+00
  br i1 %isnan_cmp197, label %complex_mul_libcall198, label %complex_mul_cont201, !prof !42

complex_mul_libcall198:                           ; preds = %complex_mul_imag_nan196
  %call199 = tail call <2 x float> @__mulsc3(float %arrayidx184.real, float %arrayidx184.imag, float %amplitude141.real, float %amplitude141.imag) #31
  %coerce200.sroa.0.0.vec.extract = extractelement <2 x float> %call199, i32 0
  %coerce200.sroa.0.4.vec.extract = extractelement <2 x float> %call199, i32 1
  br label %complex_mul_cont201

complex_mul_cont201:                              ; preds = %complex_mul_libcall198, %complex_mul_imag_nan196, %if.else
  %real_mul_phi202 = phi float [ %mul_r193, %if.else ], [ %mul_r193, %complex_mul_imag_nan196 ], [ %coerce200.sroa.0.0.vec.extract, %complex_mul_libcall198 ]
  %imag_mul_phi203 = phi float [ %mul_i194, %if.else ], [ %mul_i194, %complex_mul_imag_nan196 ], [ %coerce200.sroa.0.4.vec.extract, %complex_mul_libcall198 ]
  %arrayidx205.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx205.imag = load float, float* %arrayidx24.imagp, align 4
  %mul_ac210 = fmul float %tnot.sroa.0.0, %arrayidx205.real
  %mul_bd211 = fmul float %tnot.sroa.9.0, %arrayidx205.imag
  %mul_ad212 = fmul float %tnot.sroa.9.0, %arrayidx205.real
  %mul_bc213 = fmul float %tnot.sroa.0.0, %arrayidx205.imag
  %mul_r214 = fsub float %mul_ac210, %mul_bd211
  %mul_i215 = fadd float %mul_ad212, %mul_bc213
  %isnan_cmp216 = fcmp uno float %mul_r214, 0.000000e+00
  br i1 %isnan_cmp216, label %complex_mul_imag_nan217, label %if.end231.thread, !prof !42

complex_mul_imag_nan217:                          ; preds = %complex_mul_cont201
  %isnan_cmp218 = fcmp uno float %mul_i215, 0.000000e+00
  br i1 %isnan_cmp218, label %complex_mul_libcall219, label %if.end231.thread, !prof !42

complex_mul_libcall219:                           ; preds = %complex_mul_imag_nan217
  %call220 = tail call <2 x float> @__mulsc3(float %arrayidx205.real, float %arrayidx205.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce221.sroa.0.0.vec.extract = extractelement <2 x float> %call220, i32 0
  %coerce221.sroa.0.4.vec.extract = extractelement <2 x float> %call220, i32 1
  br label %if.end231.thread

if.end231:                                        ; preds = %complex_mul_cont, %complex_mul_imag_nan171, %complex_mul_libcall173
  %real_mul_phi177 = phi float [ %mul_r168, %complex_mul_cont ], [ %mul_r168, %complex_mul_imag_nan171 ], [ %coerce175.sroa.0.0.vec.extract, %complex_mul_libcall173 ]
  %imag_mul_phi178 = phi float [ %mul_i169, %complex_mul_cont ], [ %mul_i169, %complex_mul_imag_nan171 ], [ %coerce175.sroa.0.4.vec.extract, %complex_mul_libcall173 ]
  %add.r = fadd float %real_mul_phi, %real_mul_phi177
  %add.i = fadd float %imag_mul_phi, %imag_mul_phi178
  %25 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude182.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %25, i64 %indvars.iv684, i32 0, i32 0
  %amplitude182.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %25, i64 %indvars.iv684, i32 0, i32 1
  store float %add.r, float* %amplitude182.realp, align 8
  store float %add.i, float* %amplitude182.imagp, align 4
  br i1 %cmp142, label %if.then236, label %if.else335

if.end231.thread:                                 ; preds = %complex_mul_cont201, %complex_mul_imag_nan217, %complex_mul_libcall219
  %real_mul_phi223 = phi float [ %mul_r214, %complex_mul_cont201 ], [ %mul_r214, %complex_mul_imag_nan217 ], [ %coerce221.sroa.0.0.vec.extract, %complex_mul_libcall219 ]
  %imag_mul_phi224 = phi float [ %mul_i215, %complex_mul_cont201 ], [ %mul_i215, %complex_mul_imag_nan217 ], [ %coerce221.sroa.0.4.vec.extract, %complex_mul_libcall219 ]
  %add.r225 = fadd float %real_mul_phi202, %real_mul_phi223
  %add.i226 = fadd float %imag_mul_phi203, %imag_mul_phi224
  %26 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude230.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %26, i64 %indvars.iv684, i32 0, i32 0
  %amplitude230.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %26, i64 %indvars.iv684, i32 0, i32 1
  store float %add.r225, float* %amplitude230.realp, align 8
  store float %add.i226, float* %amplitude230.imagp, align 4
  %arrayidx287.real = load float, float* %arrayidx35.realp, align 4
  %arrayidx287.imag = load float, float* %arrayidx35.imagp, align 4
  br i1 %cmp142, label %if.else285, label %if.end344

if.then236:                                       ; preds = %if.end231
  %arrayidx238.real = load float, float* %arrayidx184.realp, align 4
  %arrayidx238.imag = load float, float* %arrayidx184.imagp, align 4
  %mul_ac243 = fmul float %tnot.sroa.0.0, %arrayidx238.real
  %mul_bd244 = fmul float %tnot.sroa.9.0, %arrayidx238.imag
  %mul_ad245 = fmul float %tnot.sroa.9.0, %arrayidx238.real
  %mul_bc246 = fmul float %tnot.sroa.0.0, %arrayidx238.imag
  %mul_r247 = fsub float %mul_ac243, %mul_bd244
  %mul_i248 = fadd float %mul_ad245, %mul_bc246
  %isnan_cmp249 = fcmp uno float %mul_r247, 0.000000e+00
  br i1 %isnan_cmp249, label %complex_mul_imag_nan250, label %complex_mul_cont255, !prof !42

complex_mul_imag_nan250:                          ; preds = %if.then236
  %isnan_cmp251 = fcmp uno float %mul_i248, 0.000000e+00
  br i1 %isnan_cmp251, label %complex_mul_libcall252, label %complex_mul_cont255, !prof !42

complex_mul_libcall252:                           ; preds = %complex_mul_imag_nan250
  %call253 = tail call <2 x float> @__mulsc3(float %arrayidx238.real, float %arrayidx238.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce254.sroa.0.0.vec.extract = extractelement <2 x float> %call253, i32 0
  %coerce254.sroa.0.4.vec.extract = extractelement <2 x float> %call253, i32 1
  br label %complex_mul_cont255

complex_mul_cont255:                              ; preds = %complex_mul_libcall252, %complex_mul_imag_nan250, %if.then236
  %real_mul_phi256 = phi float [ %mul_r247, %if.then236 ], [ %mul_r247, %complex_mul_imag_nan250 ], [ %coerce254.sroa.0.0.vec.extract, %complex_mul_libcall252 ]
  %imag_mul_phi257 = phi float [ %mul_i248, %if.then236 ], [ %mul_i248, %complex_mul_imag_nan250 ], [ %coerce254.sroa.0.4.vec.extract, %complex_mul_libcall252 ]
  %arrayidx259.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx259.imag = load float, float* %arrayidx24.imagp, align 4
  %mul_ac264 = fmul float %amplitude141.real, %arrayidx259.real
  %mul_bd265 = fmul float %amplitude141.imag, %arrayidx259.imag
  %mul_ad266 = fmul float %amplitude141.imag, %arrayidx259.real
  %mul_bc267 = fmul float %amplitude141.real, %arrayidx259.imag
  %mul_r268 = fsub float %mul_ac264, %mul_bd265
  %mul_i269 = fadd float %mul_ad266, %mul_bc267
  %isnan_cmp270 = fcmp uno float %mul_r268, 0.000000e+00
  br i1 %isnan_cmp270, label %complex_mul_imag_nan271, label %complex_mul_cont276, !prof !42

complex_mul_imag_nan271:                          ; preds = %complex_mul_cont255
  %isnan_cmp272 = fcmp uno float %mul_i269, 0.000000e+00
  br i1 %isnan_cmp272, label %complex_mul_libcall273, label %complex_mul_cont276, !prof !42

complex_mul_libcall273:                           ; preds = %complex_mul_imag_nan271
  %call274 = tail call <2 x float> @__mulsc3(float %arrayidx259.real, float %arrayidx259.imag, float %amplitude141.real, float %amplitude141.imag) #31
  %coerce275.sroa.0.0.vec.extract = extractelement <2 x float> %call274, i32 0
  %coerce275.sroa.0.4.vec.extract = extractelement <2 x float> %call274, i32 1
  br label %complex_mul_cont276

complex_mul_cont276:                              ; preds = %complex_mul_libcall273, %complex_mul_imag_nan271, %complex_mul_cont255
  %real_mul_phi277 = phi float [ %mul_r268, %complex_mul_cont255 ], [ %mul_r268, %complex_mul_imag_nan271 ], [ %coerce275.sroa.0.0.vec.extract, %complex_mul_libcall273 ]
  %imag_mul_phi278 = phi float [ %mul_i269, %complex_mul_cont255 ], [ %mul_i269, %complex_mul_imag_nan271 ], [ %coerce275.sroa.0.4.vec.extract, %complex_mul_libcall273 ]
  %add.r279 = fadd float %real_mul_phi256, %real_mul_phi277
  %add.i280 = fadd float %imag_mul_phi257, %imag_mul_phi278
  %27 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %idxprom282657 = zext i32 %call137 to i64
  %amplitude284.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %27, i64 %idxprom282657, i32 0, i32 0
  %amplitude284.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %27, i64 %idxprom282657, i32 0, i32 1
  store float %add.r279, float* %amplitude284.realp, align 8
  store float %add.i280, float* %amplitude284.imagp, align 4
  br label %if.then424

if.else285:                                       ; preds = %if.end231.thread
  %mul_ac292 = fmul float %amplitude141.real, %arrayidx287.real
  %mul_bd293 = fmul float %amplitude141.imag, %arrayidx287.imag
  %mul_ad294 = fmul float %amplitude141.imag, %arrayidx287.real
  %mul_bc295 = fmul float %amplitude141.real, %arrayidx287.imag
  %mul_r296 = fsub float %mul_ac292, %mul_bd293
  %mul_i297 = fadd float %mul_ad294, %mul_bc295
  %isnan_cmp298 = fcmp uno float %mul_r296, 0.000000e+00
  br i1 %isnan_cmp298, label %complex_mul_imag_nan299, label %complex_mul_cont304, !prof !42

complex_mul_imag_nan299:                          ; preds = %if.else285
  %isnan_cmp300 = fcmp uno float %mul_i297, 0.000000e+00
  br i1 %isnan_cmp300, label %complex_mul_libcall301, label %complex_mul_cont304, !prof !42

complex_mul_libcall301:                           ; preds = %complex_mul_imag_nan299
  %call302 = tail call <2 x float> @__mulsc3(float %arrayidx287.real, float %arrayidx287.imag, float %amplitude141.real, float %amplitude141.imag) #31
  %coerce303.sroa.0.0.vec.extract = extractelement <2 x float> %call302, i32 0
  %coerce303.sroa.0.4.vec.extract = extractelement <2 x float> %call302, i32 1
  br label %complex_mul_cont304

complex_mul_cont304:                              ; preds = %complex_mul_libcall301, %complex_mul_imag_nan299, %if.else285
  %real_mul_phi305 = phi float [ %mul_r296, %if.else285 ], [ %mul_r296, %complex_mul_imag_nan299 ], [ %coerce303.sroa.0.0.vec.extract, %complex_mul_libcall301 ]
  %imag_mul_phi306 = phi float [ %mul_i297, %if.else285 ], [ %mul_i297, %complex_mul_imag_nan299 ], [ %coerce303.sroa.0.4.vec.extract, %complex_mul_libcall301 ]
  %arrayidx308.real = load float, float* %arrayidx161.realp, align 4
  %arrayidx308.imag = load float, float* %arrayidx161.imagp, align 4
  %mul_ac313 = fmul float %tnot.sroa.0.0, %arrayidx308.real
  %mul_bd314 = fmul float %tnot.sroa.9.0, %arrayidx308.imag
  %mul_ad315 = fmul float %tnot.sroa.9.0, %arrayidx308.real
  %mul_bc316 = fmul float %tnot.sroa.0.0, %arrayidx308.imag
  %mul_r317 = fsub float %mul_ac313, %mul_bd314
  %mul_i318 = fadd float %mul_ad315, %mul_bc316
  %isnan_cmp319 = fcmp uno float %mul_r317, 0.000000e+00
  br i1 %isnan_cmp319, label %complex_mul_imag_nan320, label %complex_mul_cont325, !prof !42

complex_mul_imag_nan320:                          ; preds = %complex_mul_cont304
  %isnan_cmp321 = fcmp uno float %mul_i318, 0.000000e+00
  br i1 %isnan_cmp321, label %complex_mul_libcall322, label %complex_mul_cont325, !prof !42

complex_mul_libcall322:                           ; preds = %complex_mul_imag_nan320
  %call323 = tail call <2 x float> @__mulsc3(float %arrayidx308.real, float %arrayidx308.imag, float %tnot.sroa.0.0, float %tnot.sroa.9.0) #31
  %coerce324.sroa.0.0.vec.extract = extractelement <2 x float> %call323, i32 0
  %coerce324.sroa.0.4.vec.extract = extractelement <2 x float> %call323, i32 1
  br label %complex_mul_cont325

complex_mul_cont325:                              ; preds = %complex_mul_libcall322, %complex_mul_imag_nan320, %complex_mul_cont304
  %real_mul_phi326 = phi float [ %mul_r317, %complex_mul_cont304 ], [ %mul_r317, %complex_mul_imag_nan320 ], [ %coerce324.sroa.0.0.vec.extract, %complex_mul_libcall322 ]
  %imag_mul_phi327 = phi float [ %mul_i318, %complex_mul_cont304 ], [ %mul_i318, %complex_mul_imag_nan320 ], [ %coerce324.sroa.0.4.vec.extract, %complex_mul_libcall322 ]
  %add.r328 = fadd float %real_mul_phi305, %real_mul_phi326
  %add.i329 = fadd float %imag_mul_phi306, %imag_mul_phi327
  %28 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %idxprom331659 = zext i32 %call137 to i64
  %amplitude333.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %28, i64 %idxprom331659, i32 0, i32 0
  %amplitude333.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %28, i64 %idxprom331659, i32 0, i32 1
  store float %add.r328, float* %amplitude333.realp, align 8
  store float %add.i329, float* %amplitude333.imagp, align 4
  br label %if.then424

if.else335:                                       ; preds = %if.end231
  %arrayidx337.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx337.imag = load float, float* %arrayidx24.imagp, align 4
  %cmp.r338 = fcmp oeq float %arrayidx337.real, 0.000000e+00
  %cmp.i339 = fcmp oeq float %arrayidx337.imag, 0.000000e+00
  %and.ri = and i1 %cmp.r338, %cmp.i339
  %or.cond = select i1 %and.ri, i1 %tobool152, i1 false
  br i1 %or.cond, label %for.end431.loopexit, label %if.end354

if.end344:                                        ; preds = %if.end231.thread
  %cmp.r347 = fcmp une float %arrayidx287.real, 0.000000e+00
  %cmp.i348 = fcmp une float %arrayidx287.imag, 0.000000e+00
  %and.ri349.not = or i1 %cmp.r347, %cmp.i348
  %or.cond502 = select i1 %and.ri349.not, i1 true, i1 %tobool152
  br i1 %or.cond502, label %if.end354, label %for.end431.loopexit

if.end354:                                        ; preds = %if.else335, %if.end344
  %29 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state358 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %29, i64 %indvars.iv684, i32 1
  %30 = load i64, i64* %state358, align 8, !tbaa !33
  %xor361 = xor i64 %30, %shl19
  %idxprom363 = sext i32 %k.0667 to i64
  %state365 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %29, i64 %idxprom363, i32 1
  store i64 %xor361, i64* %state365, align 8, !tbaa !33
  br i1 %tobool152, label %if.then367, label %if.else393

if.then367:                                       ; preds = %if.end354
  %arrayidx369.real = load float, float* %arrayidx24.realp, align 4
  %arrayidx369.imag = load float, float* %arrayidx24.imagp, align 4
  %mul_ac374 = fmul float %amplitude141.real, %arrayidx369.real
  %mul_bd375 = fmul float %amplitude141.imag, %arrayidx369.imag
  %mul_ad376 = fmul float %amplitude141.imag, %arrayidx369.real
  %mul_bc377 = fmul float %amplitude141.real, %arrayidx369.imag
  %mul_r378 = fsub float %mul_ac374, %mul_bd375
  %mul_i379 = fadd float %mul_ad376, %mul_bc377
  %isnan_cmp380 = fcmp uno float %mul_r378, 0.000000e+00
  br i1 %isnan_cmp380, label %complex_mul_imag_nan381, label %if.end421, !prof !42

complex_mul_imag_nan381:                          ; preds = %if.then367
  %isnan_cmp382 = fcmp uno float %mul_i379, 0.000000e+00
  br i1 %isnan_cmp382, label %complex_mul_libcall383, label %if.end421, !prof !42

complex_mul_libcall383:                           ; preds = %complex_mul_imag_nan381
  %call384 = tail call <2 x float> @__mulsc3(float %arrayidx369.real, float %arrayidx369.imag, float %amplitude141.real, float %amplitude141.imag) #31
  br label %if.end421.sink.split

if.else393:                                       ; preds = %if.end354
  %arrayidx395.real = load float, float* %arrayidx35.realp, align 4
  %arrayidx395.imag = load float, float* %arrayidx35.imagp, align 4
  %mul_ac400 = fmul float %amplitude141.real, %arrayidx395.real
  %mul_bd401 = fmul float %amplitude141.imag, %arrayidx395.imag
  %mul_ad402 = fmul float %amplitude141.imag, %arrayidx395.real
  %mul_bc403 = fmul float %amplitude141.real, %arrayidx395.imag
  %mul_r404 = fsub float %mul_ac400, %mul_bd401
  %mul_i405 = fadd float %mul_ad402, %mul_bc403
  %isnan_cmp406 = fcmp uno float %mul_r404, 0.000000e+00
  br i1 %isnan_cmp406, label %complex_mul_imag_nan407, label %if.end421, !prof !42

complex_mul_imag_nan407:                          ; preds = %if.else393
  %isnan_cmp408 = fcmp uno float %mul_i405, 0.000000e+00
  br i1 %isnan_cmp408, label %complex_mul_libcall409, label %if.end421, !prof !42

complex_mul_libcall409:                           ; preds = %complex_mul_imag_nan407
  %call410 = tail call <2 x float> @__mulsc3(float %arrayidx395.real, float %arrayidx395.imag, float %amplitude141.real, float %amplitude141.imag) #31
  br label %if.end421.sink.split

if.end421.sink.split:                             ; preds = %complex_mul_libcall383, %complex_mul_libcall409
  %call410.sink716 = phi <2 x float> [ %call410, %complex_mul_libcall409 ], [ %call384, %complex_mul_libcall383 ]
  %coerce411.sroa.0.0.vec.extract = extractelement <2 x float> %call410.sink716, i32 0
  %coerce411.sroa.0.4.vec.extract = extractelement <2 x float> %call410.sink716, i32 1
  %.pre694 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  br label %if.end421

if.end421:                                        ; preds = %if.end421.sink.split, %if.else393, %complex_mul_imag_nan407, %if.then367, %complex_mul_imag_nan381
  %.sink715 = phi %struct.quantum_reg_node_struct* [ %29, %if.then367 ], [ %29, %complex_mul_imag_nan381 ], [ %29, %if.else393 ], [ %29, %complex_mul_imag_nan407 ], [ %.pre694, %if.end421.sink.split ]
  %real_mul_phi387.sink = phi float [ %mul_r378, %if.then367 ], [ %mul_r378, %complex_mul_imag_nan381 ], [ %mul_r404, %if.else393 ], [ %mul_r404, %complex_mul_imag_nan407 ], [ %coerce411.sroa.0.0.vec.extract, %if.end421.sink.split ]
  %imag_mul_phi388.sink = phi float [ %mul_i379, %if.then367 ], [ %mul_i379, %complex_mul_imag_nan381 ], [ %mul_i405, %if.else393 ], [ %mul_i405, %complex_mul_imag_nan407 ], [ %coerce411.sroa.0.4.vec.extract, %if.end421.sink.split ]
  %amplitude392.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %.sink715, i64 %idxprom363, i32 0, i32 0
  %amplitude392.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %.sink715, i64 %idxprom363, i32 0, i32 1
  store float %real_mul_phi387.sink, float* %amplitude392.realp, align 8
  store float %imag_mul_phi388.sink, float* %amplitude392.imagp, align 4
  %inc420 = add nsw i32 %k.0667, 1
  br label %for.inc429

if.then424:                                       ; preds = %complex_mul_cont276, %complex_mul_cont325
  %idxprom425658.pre-phi = phi i64 [ %idxprom282657, %complex_mul_cont276 ], [ %idxprom331659, %complex_mul_cont325 ]
  %arrayidx426 = getelementptr inbounds i8, i8* %call90, i64 %idxprom425658.pre-phi
  store i8 1, i8* %arrayidx426, align 1, !tbaa !9
  br label %for.inc429

for.inc429:                                       ; preds = %if.end421, %for.body115, %if.then424
  %k.2 = phi i32 [ %k.0667, %for.body115 ], [ %k.0667, %if.then424 ], [ %inc420, %if.end421 ]
  %indvars.iv.next685 = add nuw nsw i64 %indvars.iv684, 1
  %31 = load i32, i32* %size, align 4, !tbaa !30
  %32 = sext i32 %31 to i64
  %cmp113 = icmp slt i64 %indvars.iv.next685, %32
  br i1 %cmp113, label %for.inc429.for.body115_crit_edge, label %for.end431.loopexit, !llvm.loop !64

for.inc429.for.body115_crit_edge:                 ; preds = %for.inc429
  %arrayidx117.phi.trans.insert = getelementptr inbounds i8, i8* %call90, i64 %indvars.iv.next685
  %.pre693 = load i8, i8* %arrayidx117.phi.trans.insert, align 1, !tbaa !9
  br label %for.body115

for.end431.loopexit:                              ; preds = %if.end344, %if.else335, %for.inc429
  %.pre696 = load i32, i32* %size, align 4, !tbaa !30
  br label %for.end431

for.end431:                                       ; preds = %for.end431.loopexit, %if.end98
  %33 = phi i32 [ %.pre696, %for.end431.loopexit ], [ %20, %if.end98 ]
  %add433 = add nsw i32 %33, %addsize.0.lcssa
  store i32 %add433, i32* %size, align 4, !tbaa !30
  tail call void @free(i8* %call90) #31
  %sub = sub nsw i32 0, %add433
  %conv435 = sext i32 %sub to i64
  %call437 = tail call i64 @quantum_memman(i64 %conv435) #31
  %34 = load i32, i32* %size, align 4, !tbaa !30
  %cmp440661 = icmp sgt i32 %34, 0
  br i1 %cmp440661, label %for.body442, label %if.end501

for.body442:                                      ; preds = %for.end431, %for.inc477
  %35 = phi i32 [ %39, %for.inc477 ], [ %34, %for.end431 ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc477 ], [ 0, %for.end431 ]
  %j.0663 = phi i32 [ %j.1, %for.inc477 ], [ 0, %for.end431 ]
  %decsize.0662 = phi i32 [ %decsize.1, %for.inc477 ], [ 0, %for.end431 ]
  %36 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude446.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %indvars.iv, i32 0, i32 0
  %amplitude446.real = load float, float* %amplitude446.realp, align 8
  %amplitude446.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %indvars.iv, i32 0, i32 1
  %amplitude446.imag = load float, float* %amplitude446.imagp, align 4
  %coerce447.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude446.real, i32 0
  %coerce447.sroa.0.4.vec.insert = insertelement <2 x float> %coerce447.sroa.0.0.vec.insert, float %amplitude446.imag, i32 1
  %call448 = tail call fastcc float @quantum_prob_inline(<2 x float> %coerce447.sroa.0.4.vec.insert) #34
  %cmp449 = fcmp olt float %call448, %conv110
  br i1 %cmp449, label %if.then451, label %if.else454

if.then451:                                       ; preds = %for.body442
  %inc452 = add nsw i32 %j.0663, 1
  %inc453 = add nsw i32 %decsize.0662, 1
  br label %for.inc477

if.else454:                                       ; preds = %for.body442
  %tobool455.not = icmp eq i32 %j.0663, 0
  br i1 %tobool455.not, label %for.inc477, label %if.then456

if.then456:                                       ; preds = %if.else454
  %state460 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %indvars.iv, i32 1
  %37 = load i64, i64* %state460, align 8, !tbaa !33
  %38 = trunc i64 %indvars.iv to i32
  %sub462 = sub nsw i32 %38, %j.0663
  %idxprom463 = sext i32 %sub462 to i64
  %state465 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %idxprom463, i32 1
  store i64 %37, i64* %state465, align 8, !tbaa !33
  %amplitude474.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %idxprom463, i32 0, i32 0
  %amplitude474.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %36, i64 %idxprom463, i32 0, i32 1
  store float %amplitude446.real, float* %amplitude474.realp, align 8
  store float %amplitude446.imag, float* %amplitude474.imagp, align 4
  %.pre697 = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc477

for.inc477:                                       ; preds = %if.then451, %if.then456, %if.else454
  %39 = phi i32 [ %35, %if.then451 ], [ %.pre697, %if.then456 ], [ %35, %if.else454 ]
  %decsize.1 = phi i32 [ %inc453, %if.then451 ], [ %decsize.0662, %if.then456 ], [ %decsize.0662, %if.else454 ]
  %j.1 = phi i32 [ %inc452, %if.then451 ], [ %j.0663, %if.then456 ], [ 0, %if.else454 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %40 = sext i32 %39 to i64
  %cmp440 = icmp slt i64 %indvars.iv.next, %40
  br i1 %cmp440, label %for.body442, label %for.end479, !llvm.loop !65

for.end479:                                       ; preds = %for.inc477
  %tobool480.not = icmp eq i32 %decsize.1, 0
  br i1 %tobool480.not, label %if.end501, label %if.then481

if.then481:                                       ; preds = %for.end479
  %sub483 = sub nsw i32 %39, %decsize.1
  store i32 %sub483, i32* %size, align 4, !tbaa !30
  %41 = load i8*, i8** %.pre-phi, align 8, !tbaa !32
  %conv486 = sext i32 %sub483 to i64
  %mul487 = shl nsw i64 %conv486, 4
  %call488 = tail call align 16 i8* @realloc(i8* %41, i64 %mul487) #31
  store i8* %call488, i8** %.pre-phi, align 8, !tbaa !32
  %tobool491.not = icmp eq i8* %call488, null
  br i1 %tobool491.not, label %if.then492, label %if.end496

if.then492:                                       ; preds = %if.then481
  %42 = load i32, i32* %size, align 4, !tbaa !30
  %add494 = add nsw i32 %42, %addsize.0.lcssa
  %call495 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.2, i64 0, i64 0), i32 %add494) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end496:                                        ; preds = %if.then481
  %sub497 = sub nsw i32 0, %decsize.1
  %conv498 = sext i32 %sub497 to i64
  %mul499 = shl nsw i64 %conv498, 4
  %call500 = tail call i64 @quantum_memman(i64 %mul499) #31
  br label %if.end501

if.end501:                                        ; preds = %for.end431, %if.end496, %for.end479
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then492, %if.then92, %if.then61, %if.then
  unreachable
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_hadamard(i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %m = alloca %struct.quantum_matrix_struct, align 8
  %0 = bitcast %struct.quantum_matrix_struct* %m to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %0) #33
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 6, i32 %target) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call { i64, { float, float }* } @quantum_new_matrix(i32 2, i32 2) #31
  %1 = extractvalue { i64, { float, float }* } %call1, 0
  %2 = extractvalue { i64, { float, float }* } %call1, 1
  %tmp.sroa.0.0..sroa_cast15 = bitcast %struct.quantum_matrix_struct* %m to i64*
  store i64 %1, i64* %tmp.sroa.0.0..sroa_cast15, align 8, !tbaa.struct !66
  %tmp.sroa.4.0..sroa_idx17 = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 2
  store { float, float }* %2, { float, float }** %tmp.sroa.4.0..sroa_idx17, align 8, !tbaa.struct !67
  %arrayidx.realp = getelementptr inbounds { float, float }, { float, float }* %2, i64 0, i32 0
  %arrayidx.imagp = getelementptr inbounds { float, float }, { float, float }* %2, i64 0, i32 1
  store float 0x3FE6A09E60000000, float* %arrayidx.realp, align 4
  store float 0.000000e+00, float* %arrayidx.imagp, align 4
  %3 = load { float, float }*, { float, float }** %tmp.sroa.4.0..sroa_idx17, align 8, !tbaa !68
  %arrayidx6.realp = getelementptr inbounds { float, float }, { float, float }* %3, i64 1, i32 0
  %arrayidx6.imagp = getelementptr inbounds { float, float }, { float, float }* %3, i64 1, i32 1
  store float 0x3FE6A09E60000000, float* %arrayidx6.realp, align 4
  store float 0.000000e+00, float* %arrayidx6.imagp, align 4
  %4 = load { float, float }*, { float, float }** %tmp.sroa.4.0..sroa_idx17, align 8, !tbaa !68
  %arrayidx10.realp = getelementptr inbounds { float, float }, { float, float }* %4, i64 2, i32 0
  %arrayidx10.imagp = getelementptr inbounds { float, float }, { float, float }* %4, i64 2, i32 1
  store float 0x3FE6A09E60000000, float* %arrayidx10.realp, align 4
  store float 0.000000e+00, float* %arrayidx10.imagp, align 4
  %arrayidx14.realp = getelementptr inbounds { float, float }, { float, float }* %4, i64 3, i32 0
  %arrayidx14.imagp = getelementptr inbounds { float, float }, { float, float }* %4, i64 3, i32 1
  store float 0xBFE6A09E60000000, float* %arrayidx14.realp, align 4
  store float 0.000000e+00, float* %arrayidx14.imagp, align 4
  %5 = load i64, i64* %tmp.sroa.0.0..sroa_cast15, align 8
  tail call void @quantum_gate1(i32 %target, i64 %5, { float, float }* %4, %struct.quantum_reg_struct* %reg) #34
  call void @quantum_delete_matrix(%struct.quantum_matrix_struct* nonnull %m) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.end
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %0) #33
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_walsh(i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %width, 0
  br i1 %cmp4, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  tail call void @quantum_hadamard(i32 %i.05, %struct.quantum_reg_struct* %reg) #34
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %width
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !70

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_r_x(i32 %target, float %gamma, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %m = alloca %struct.quantum_matrix_struct, align 8
  %0 = bitcast %struct.quantum_matrix_struct* %m to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %0) #33
  %conv = fpext float %gamma to double
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 7, i32 %target, double %conv) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call { i64, { float, float }* } @quantum_new_matrix(i32 2, i32 2) #31
  %1 = extractvalue { i64, { float, float }* } %call1, 0
  %2 = extractvalue { i64, { float, float }* } %call1, 1
  %tmp.sroa.0.0..sroa_cast27 = bitcast %struct.quantum_matrix_struct* %m to i64*
  store i64 %1, i64* %tmp.sroa.0.0..sroa_cast27, align 8, !tbaa.struct !66
  %tmp.sroa.4.0..sroa_idx29 = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 2
  store { float, float }* %2, { float, float }** %tmp.sroa.4.0..sroa_idx29, align 8, !tbaa.struct !67
  %div = fmul float %gamma, 5.000000e-01
  %conv2 = fpext float %div to double
  %call3 = tail call double @cos(double %conv2) #31
  %conv4 = fptrunc double %call3 to float
  %arrayidx.realp = getelementptr inbounds { float, float }, { float, float }* %2, i64 0, i32 0
  %arrayidx.imagp = getelementptr inbounds { float, float }, { float, float }* %2, i64 0, i32 1
  store float %conv4, float* %arrayidx.realp, align 4
  store float 0.000000e+00, float* %arrayidx.imagp, align 4
  %call7 = tail call double @sin(double %conv2) #31
  %mul.rl = fmul double %call7, -0.000000e+00
  %conv8 = fptrunc double %mul.rl to float
  %3 = fptrunc double %call7 to float
  %conv9 = fneg float %3
  %4 = load { float, float }*, { float, float }** %tmp.sroa.4.0..sroa_idx29, align 8, !tbaa !68
  %arrayidx11.realp = getelementptr inbounds { float, float }, { float, float }* %4, i64 1, i32 0
  %arrayidx11.imagp = getelementptr inbounds { float, float }, { float, float }* %4, i64 1, i32 1
  store float %conv8, float* %arrayidx11.realp, align 4
  store float %conv9, float* %arrayidx11.imagp, align 4
  %call14 = tail call double @sin(double %conv2) #31
  %mul.rl15 = fmul double %call14, -0.000000e+00
  %conv17 = fptrunc double %mul.rl15 to float
  %5 = fptrunc double %call14 to float
  %conv18 = fneg float %5
  %6 = load { float, float }*, { float, float }** %tmp.sroa.4.0..sroa_idx29, align 8, !tbaa !68
  %arrayidx20.realp = getelementptr inbounds { float, float }, { float, float }* %6, i64 2, i32 0
  %arrayidx20.imagp = getelementptr inbounds { float, float }, { float, float }* %6, i64 2, i32 1
  store float %conv17, float* %arrayidx20.realp, align 4
  store float %conv18, float* %arrayidx20.imagp, align 4
  %call23 = tail call double @cos(double %conv2) #31
  %conv24 = fptrunc double %call23 to float
  %arrayidx26.realp = getelementptr inbounds { float, float }, { float, float }* %6, i64 3, i32 0
  %arrayidx26.imagp = getelementptr inbounds { float, float }, { float, float }* %6, i64 3, i32 1
  store float %conv24, float* %arrayidx26.realp, align 4
  store float 0.000000e+00, float* %arrayidx26.imagp, align 4
  %7 = load i64, i64* %tmp.sroa.0.0..sroa_cast27, align 8
  tail call void @quantum_gate1(i32 %target, i64 %7, { float, float }* %6, %struct.quantum_reg_struct* %reg) #34
  call void @quantum_delete_matrix(%struct.quantum_matrix_struct* nonnull %m) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.end
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %0) #33
  ret void
}

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @cos(double) local_unnamed_addr #18

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @sin(double) local_unnamed_addr #18

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_r_y(i32 %target, float %gamma, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %m = alloca %struct.quantum_matrix_struct, align 8
  %0 = bitcast %struct.quantum_matrix_struct* %m to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %0) #33
  %conv = fpext float %gamma to double
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 8, i32 %target, double %conv) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call { i64, { float, float }* } @quantum_new_matrix(i32 2, i32 2) #31
  %1 = extractvalue { i64, { float, float }* } %call1, 0
  %2 = extractvalue { i64, { float, float }* } %call1, 1
  %tmp.sroa.0.0..sroa_cast23 = bitcast %struct.quantum_matrix_struct* %m to i64*
  store i64 %1, i64* %tmp.sroa.0.0..sroa_cast23, align 8, !tbaa.struct !66
  %tmp.sroa.4.0..sroa_idx25 = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 2
  store { float, float }* %2, { float, float }** %tmp.sroa.4.0..sroa_idx25, align 8, !tbaa.struct !67
  %div = fmul float %gamma, 5.000000e-01
  %conv2 = fpext float %div to double
  %call3 = tail call double @cos(double %conv2) #31
  %conv4 = fptrunc double %call3 to float
  %arrayidx.realp = getelementptr inbounds { float, float }, { float, float }* %2, i64 0, i32 0
  %arrayidx.imagp = getelementptr inbounds { float, float }, { float, float }* %2, i64 0, i32 1
  store float %conv4, float* %arrayidx.realp, align 4
  store float 0.000000e+00, float* %arrayidx.imagp, align 4
  %call7 = tail call double @sin(double %conv2) #31
  %3 = fptrunc double %call7 to float
  %conv8 = fneg float %3
  %4 = load { float, float }*, { float, float }** %tmp.sroa.4.0..sroa_idx25, align 8, !tbaa !68
  %arrayidx10.realp = getelementptr inbounds { float, float }, { float, float }* %4, i64 1, i32 0
  %arrayidx10.imagp = getelementptr inbounds { float, float }, { float, float }* %4, i64 1, i32 1
  store float %conv8, float* %arrayidx10.realp, align 4
  store float 0.000000e+00, float* %arrayidx10.imagp, align 4
  %call13 = tail call double @sin(double %conv2) #31
  %conv14 = fptrunc double %call13 to float
  %5 = load { float, float }*, { float, float }** %tmp.sroa.4.0..sroa_idx25, align 8, !tbaa !68
  %arrayidx16.realp = getelementptr inbounds { float, float }, { float, float }* %5, i64 2, i32 0
  %arrayidx16.imagp = getelementptr inbounds { float, float }, { float, float }* %5, i64 2, i32 1
  store float %conv14, float* %arrayidx16.realp, align 4
  store float 0.000000e+00, float* %arrayidx16.imagp, align 4
  %call19 = tail call double @cos(double %conv2) #31
  %conv20 = fptrunc double %call19 to float
  %arrayidx22.realp = getelementptr inbounds { float, float }, { float, float }* %5, i64 3, i32 0
  %arrayidx22.imagp = getelementptr inbounds { float, float }, { float, float }* %5, i64 3, i32 1
  store float %conv20, float* %arrayidx22.realp, align 4
  store float 0.000000e+00, float* %arrayidx22.imagp, align 4
  %6 = load i64, i64* %tmp.sroa.0.0..sroa_cast23, align 8
  tail call void @quantum_gate1(i32 %target, i64 %6, { float, float }* %5, %struct.quantum_reg_struct* %reg) #34
  call void @quantum_delete_matrix(%struct.quantum_matrix_struct* nonnull %m) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.end
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %0) #33
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_r_z(i32 %target, float %gamma, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %conv = fpext float %gamma to double
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 9, i32 %target, double %conv) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %div = fmul float %gamma, 5.000000e-01
  %call1 = tail call <2 x float> @quantum_cexp(float %div) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call1, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call1, i32 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %sh_prom = zext i32 %target to i64
  %shl = shl nuw i64 1, %sh_prom
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp42 = icmp sgt i32 %0, 0
  br i1 %cmp42, label %for.body, label %for.end

for.body:                                         ; preds = %if.end, %for.inc
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc ], [ 0, %if.end ]
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 1
  %2 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %2, %shl
  %tobool3.not = icmp eq i64 %and, 0
  %amplitude22.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 0
  %amplitude22.real = load float, float* %amplitude22.realp, align 8
  %amplitude22.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 1
  %amplitude22.imag = load float, float* %amplitude22.imagp, align 4
  br i1 %tobool3.not, label %if.else, label %if.then4

if.then4:                                         ; preds = %for.body
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude22.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude22.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude22.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude22.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %for.inc, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then4
  %isnan_cmp10 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp10, label %complex_mul_libcall, label %for.inc, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call11 = tail call <2 x float> @__mulsc3(float %amplitude22.real, float %amplitude22.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce12.sroa.0.0.vec.extract = extractelement <2 x float> %call11, i32 0
  %coerce12.sroa.0.4.vec.extract = extractelement <2 x float> %call11, i32 1
  br label %for.inc

if.else:                                          ; preds = %for.body
  %call23 = tail call <2 x float> @__divsc3(float %amplitude22.real, float %amplitude22.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce24.sroa.0.0.vec.extract = extractelement <2 x float> %call23, i32 0
  %coerce24.sroa.0.4.vec.extract = extractelement <2 x float> %call23, i32 1
  br label %for.inc

for.inc:                                          ; preds = %if.then4, %complex_mul_imag_nan, %complex_mul_libcall, %if.else
  %real_mul_phi.sink = phi float [ %coerce24.sroa.0.0.vec.extract, %if.else ], [ %mul_r, %if.then4 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce12.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi.sink = phi float [ %coerce24.sroa.0.4.vec.extract, %if.else ], [ %mul_i, %if.then4 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce12.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi.sink, float* %amplitude22.realp, align 8
  store float %imag_mul_phi.sink, float* %amplitude22.imagp, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %3 = load i32, i32* %size, align 4, !tbaa !30
  %4 = sext i32 %3 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %4
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !71

for.end:                                          ; preds = %for.inc, %if.end
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

declare <2 x float> @__divsc3(float, float, float, float) local_unnamed_addr

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_phase_scale(i32 %target, float %gamma, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %conv = fpext float %gamma to double
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 11, i32 %target, double %conv) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call <2 x float> @quantum_cexp(float %gamma) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call1, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call1, i32 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp19 = icmp sgt i32 %0, 0
  br i1 %cmp19, label %for.body, label %for.end

for.body:                                         ; preds = %if.end, %complex_mul_cont
  %indvars.iv = phi i64 [ %indvars.iv.next, %complex_mul_cont ], [ 0, %if.end ]
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %for.body
  %isnan_cmp5 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp5, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call6 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce7.sroa.0.0.vec.extract = extractelement <2 x float> %call6, i32 0
  %coerce7.sroa.0.4.vec.extract = extractelement <2 x float> %call6, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %for.body
  %real_mul_phi = phi float [ %mul_r, %for.body ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce7.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %for.body ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce7.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %3 = sext i32 %2 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %3
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !72

for.end:                                          ; preds = %complex_mul_cont, %if.end
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_phase_kick(i32 %target, float %gamma, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %conv = fpext float %gamma to double
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 10, i32 %target, double %conv) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call <2 x float> @quantum_cexp(float %gamma) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call1, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call1, i32 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %sh_prom = zext i32 %target to i64
  %shl = shl nuw i64 1, %sh_prom
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp28 = icmp sgt i32 %0, 0
  br i1 %cmp28, label %for.body, label %for.end

for.body:                                         ; preds = %if.end, %for.inc
  %1 = phi i32 [ %4, %for.inc ], [ %0, %if.end ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc ], [ 0, %if.end ]
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 1
  %3 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %3, %shl
  %tobool3.not = icmp eq i64 %and, 0
  br i1 %tobool3.not, label %for.inc, label %if.then4

if.then4:                                         ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then4
  %isnan_cmp10 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp10, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call11 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce12.sroa.0.0.vec.extract = extractelement <2 x float> %call11, i32 0
  %coerce12.sroa.0.4.vec.extract = extractelement <2 x float> %call11, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then4
  %real_mul_phi = phi float [ %mul_r, %if.then4 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce12.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then4 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce12.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %.pre = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc

for.inc:                                          ; preds = %for.body, %complex_mul_cont
  %4 = phi i32 [ %1, %for.body ], [ %.pre, %complex_mul_cont ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %5 = sext i32 %4 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %5
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !73

for.end:                                          ; preds = %for.inc, %if.end
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_cond_phase(i32 %control, i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 12, i32 %control, i32 %target) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %sub = sub nsw i32 %control, %target
  %sh_prom = zext i32 %sub to i64
  %shl = shl nuw i64 1, %sh_prom
  %conv = uitofp i64 %shl to double
  %div = fdiv double 0x400921FB54524550, %conv
  %conv1 = fptrunc double %div to float
  %call2 = tail call <2 x float> @quantum_cexp(float %conv1) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call2, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call2, i32 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp45 = icmp sgt i32 %0, 0
  br i1 %cmp45, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %if.end
  %sh_prom12 = zext i32 %target to i64
  %shl13 = shl nuw i64 1, %sh_prom12
  %sh_prom4 = zext i32 %control to i64
  %shl5 = shl nuw i64 1, %sh_prom4
  %1 = freeze i64 %shl13
  %2 = or i64 %shl5, %1
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %3 = phi i32 [ %0, %for.body.preheader ], [ %7, %for.inc ]
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %4 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 1
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %6 = and i64 %5, %2
  %.not = icmp eq i64 %6, %2
  br i1 %.not, label %if.then16, label %for.inc

if.then16:                                        ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then16
  %isnan_cmp22 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp22, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call23 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce24.sroa.0.0.vec.extract = extractelement <2 x float> %call23, i32 0
  %coerce24.sroa.0.4.vec.extract = extractelement <2 x float> %call23, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then16
  %real_mul_phi = phi float [ %mul_r, %if.then16 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce24.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then16 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce24.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %.pre = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc

for.inc:                                          ; preds = %for.body, %complex_mul_cont
  %7 = phi i32 [ %3, %for.body ], [ %.pre, %complex_mul_cont ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %8 = sext i32 %7 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %8
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !74

for.end:                                          ; preds = %for.inc, %if.end
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_cond_phase_inv(i32 %control, i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %sub = sub nsw i32 %control, %target
  %sh_prom = zext i32 %sub to i64
  %shl = shl nuw i64 1, %sh_prom
  %conv = uitofp i64 %shl to double
  %div = fdiv double 0xC00921FB54524550, %conv
  %conv1 = fptrunc double %div to float
  %call = tail call <2 x float> @quantum_cexp(float %conv1) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call, i32 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp38 = icmp sgt i32 %0, 0
  br i1 %cmp38, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %sh_prom9 = zext i32 %target to i64
  %shl10 = shl nuw i64 1, %sh_prom9
  %sh_prom3 = zext i32 %control to i64
  %shl4 = shl nuw i64 1, %sh_prom3
  %1 = freeze i64 %shl10
  %2 = or i64 %shl4, %1
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %3 = phi i32 [ %0, %for.body.preheader ], [ %7, %for.inc ]
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %4 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 1
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %6 = and i64 %5, %2
  %.not = icmp eq i64 %6, %2
  br i1 %.not, label %if.then13, label %for.inc

if.then13:                                        ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then13
  %isnan_cmp19 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp19, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call20 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce21.sroa.0.0.vec.extract = extractelement <2 x float> %call20, i32 0
  %coerce21.sroa.0.4.vec.extract = extractelement <2 x float> %call20, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then13
  %real_mul_phi = phi float [ %mul_r, %if.then13 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce21.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then13 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce21.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %.pre = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc

for.inc:                                          ; preds = %for.body, %complex_mul_cont
  %7 = phi i32 [ %3, %for.body ], [ %.pre, %complex_mul_cont ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %8 = sext i32 %7 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %8
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !75

for.end:                                          ; preds = %for.inc, %entry
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_cond_phase_kick(i32 %control, i32 %target, float %gamma, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %conv = fpext float %gamma to double
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 12, i32 %control, i32 %target, double %conv) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call <2 x float> @quantum_cexp(float %gamma) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call1, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call1, i32 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp41 = icmp sgt i32 %0, 0
  br i1 %cmp41, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %if.end
  %sh_prom9 = zext i32 %target to i64
  %shl10 = shl nuw i64 1, %sh_prom9
  %sh_prom = zext i32 %control to i64
  %shl = shl nuw i64 1, %sh_prom
  %1 = freeze i64 %shl10
  %2 = or i64 %shl, %1
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %3 = phi i32 [ %0, %for.body.preheader ], [ %7, %for.inc ]
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %4 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 1
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %6 = and i64 %5, %2
  %.not = icmp eq i64 %6, %2
  br i1 %.not, label %if.then13, label %for.inc

if.then13:                                        ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then13
  %isnan_cmp19 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp19, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call20 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce21.sroa.0.0.vec.extract = extractelement <2 x float> %call20, i32 0
  %coerce21.sroa.0.4.vec.extract = extractelement <2 x float> %call20, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then13
  %real_mul_phi = phi float [ %mul_r, %if.then13 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce21.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then13 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce21.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %.pre = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc

for.inc:                                          ; preds = %for.body, %complex_mul_cont
  %7 = phi i32 [ %3, %for.body ], [ %.pre, %complex_mul_cont ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %8 = sext i32 %7 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %8
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !76

for.end:                                          ; preds = %for.inc, %if.end
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
define i32 @quantum_gate_counter(i32 %inc) local_unnamed_addr #22 {
entry:
  %cmp = icmp sgt i32 %inc, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %0 = load i32, i32* @quantum_gate_counter.counter, align 4, !tbaa !18
  %add = add nsw i32 %0, %inc
  store i32 %add, i32* @quantum_gate_counter.counter, align 4, !tbaa !18
  br label %if.end3

if.else:                                          ; preds = %entry
  %cmp1 = icmp slt i32 %inc, 0
  br i1 %cmp1, label %if.then2, label %if.else.if.end3_crit_edge

if.else.if.end3_crit_edge:                        ; preds = %if.else
  %.pre = load i32, i32* @quantum_gate_counter.counter, align 4, !tbaa !18
  br label %if.end3

if.then2:                                         ; preds = %if.else
  store i32 0, i32* @quantum_gate_counter.counter, align 4, !tbaa !18
  br label %if.end3

if.end3:                                          ; preds = %if.else.if.end3_crit_edge, %if.then2, %if.then
  %1 = phi i32 [ %.pre, %if.else.if.end3_crit_edge ], [ 0, %if.then2 ], [ %add, %if.then ]
  ret i32 %1
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_exp_mod_n(i32 %N, i32 %x, i32 %width_input, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %mul = shl nsw i32 %width, 1
  %add = add nsw i32 %mul, 2
  tail call void @quantum_sigma_x(i32 %add, %struct.quantum_reg_struct* %reg) #31
  %mul6 = mul nsw i32 %width, 3
  %cmp.not31 = icmp slt i32 %width_input, 1
  br i1 %cmp.not31, label %for.end11, label %for.cond1.preheader.lr.ph

for.cond1.preheader.lr.ph:                        ; preds = %entry
  %f.027 = srem i32 %x, %N
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.cond1.preheader.lr.ph, %for.end
  %i.032 = phi i32 [ 1, %for.cond1.preheader.lr.ph ], [ %add7, %for.end ]
  %cmp228 = icmp ugt i32 %i.032, 1
  br i1 %cmp228, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1.preheader, %for.body3
  %f.030 = phi i32 [ %f.0, %for.body3 ], [ %f.027, %for.cond1.preheader ]
  %j.029 = phi i32 [ %inc, %for.body3 ], [ 1, %for.cond1.preheader ]
  %mul4 = mul nsw i32 %f.030, %f.030
  %inc = add nuw nsw i32 %j.029, 1
  %f.0 = srem i32 %mul4, %N
  %exitcond.not = icmp eq i32 %inc, %i.032
  br i1 %exitcond.not, label %for.end, label %for.body3, !llvm.loop !77

for.end:                                          ; preds = %for.body3, %for.cond1.preheader
  %f.0.lcssa = phi i32 [ %f.027, %for.cond1.preheader ], [ %f.0, %for.body3 ]
  %add7 = add nuw i32 %i.032, 1
  %add8 = add i32 %add7, %mul6
  tail call void @mul_mod_n(i32 %N, i32 %f.0.lcssa, i32 %add8, i32 %width, %struct.quantum_reg_struct* %reg) #31
  %exitcond34.not = icmp eq i32 %i.032, %width_input
  br i1 %exitcond34.not, label %for.end11, label %for.cond1.preheader, !llvm.loop !78

for.end11:                                        ; preds = %for.end, %entry
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define <2 x float> @quantum_conj(<2 x float> %a.coerce) local_unnamed_addr #19 {
entry:
  %call = tail call fastcc float @quantum_real.35(<2 x float> %a.coerce) #34
  %call6 = tail call fastcc float @quantum_imag.36(<2 x float> %a.coerce) #34
  %mul.rl = fmul float %call6, 0.000000e+00
  %sub.r = fsub float %call, %mul.rl
  %sub.i = fneg float %call6
  %retval.sroa.0.0.vec.insert = insertelement <2 x float> undef, float %sub.r, i32 0
  %retval.sroa.0.4.vec.insert = insertelement <2 x float> %retval.sroa.0.0.vec.insert, float %sub.i, i32 1
  ret <2 x float> %retval.sroa.0.4.vec.insert
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_real.35(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.0.vec.extract = extractelement <2 x float> %a.coerce, i32 0
  ret float %a.sroa.0.0.vec.extract
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_imag.36(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.4.vec.extract = extractelement <2 x float> %a.coerce, i32 1
  ret float %a.sroa.0.4.vec.extract
}

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize readnone uwtable willreturn
define float @quantum_prob(<2 x float> %a.coerce) local_unnamed_addr #17 {
entry:
  %call = tail call fastcc float @quantum_prob_inline.37(<2 x float> %a.coerce) #34
  ret float %call
}

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_prob_inline.37(<2 x float> %a.coerce) unnamed_addr #17 {
entry:
  %call = tail call fastcc float @quantum_real.35(<2 x float> %a.coerce) #34
  %call6 = tail call fastcc float @quantum_imag.36(<2 x float> %a.coerce) #34
  %mul7 = fmul float %call6, %call6
  %0 = tail call float @llvm.fmuladd.f32(float %call, float %call, float %mul7)
  ret float %0
}

; Function Attrs: mustprogress nofree noinline nounwind optsize uwtable willreturn
define <2 x float> @quantum_cexp(float %phi) local_unnamed_addr #23 {
entry:
  %conv = fpext float %phi to double
  %call = tail call double @cos(double %conv) #31
  %call2 = tail call double @sin(double %conv) #31
  %mul.rl = fmul double %call2, 0.000000e+00
  %add.r = fadd double %call, %mul.rl
  %conv3 = fptrunc double %add.r to float
  %conv4 = fptrunc double %call2 to float
  %retval.sroa.0.0.vec.insert = insertelement <2 x float> undef, float %conv3, i32 0
  %retval.sroa.0.4.vec.insert = insertelement <2 x float> %retval.sroa.0.0.vec.insert, float %conv4, i32 1
  ret <2 x float> %retval.sroa.0.4.vec.insert
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
define void @spec_srand(i32 %seed) local_unnamed_addr #12 {
entry:
  store i32 %seed, i32* @seedi, align 4, !tbaa !18
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
define double @spec_rand() local_unnamed_addr #22 {
entry:
  %0 = load i32, i32* @seedi, align 4, !tbaa !18
  %div18 = sdiv i32 %0, 127773
  %rem19 = srem i32 %0, 127773
  %mul = mul nsw i32 %rem19, 16807
  %narrow = mul nsw i32 %div18, -2836
  %sub = add i32 %mul, %narrow
  %cmp = icmp sgt i32 %sub, 0
  %conv10 = add i32 %sub, 2147483647
  %storemerge = select i1 %cmp, i32 %sub, i32 %conv10
  store i32 %storemerge, i32* @seedi, align 4, !tbaa !18
  %conv11 = sitofp i32 %storemerge to double
  %div12 = fdiv double %conv11, 0x41DFFFFFFFC00000
  ret double %div12
}

; Function Attrs: noinline nounwind optsize uwtable
define double @quantum_frand() local_unnamed_addr #0 {
entry:
  %call = tail call double @spec_rand() #31
  ret double %call
}

; Function Attrs: noinline nounwind optsize uwtable
define i64 @quantum_measure(%struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) local_unnamed_addr #15 {
entry:
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext -128) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %call1 = tail call double @quantum_frand() #34
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %cmp18 = icmp sgt i32 %0, 0
  br i1 %cmp18, label %for.body.preheader, label %cleanup

for.body.preheader:                               ; preds = %if.end
  %wide.trip.count = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %r.019 = phi double [ %call1, %for.body.preheader ], [ %sub, %for.inc ]
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %amplitude.imag, i32 1
  %call2 = tail call fastcc float @quantum_prob_inline.42(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call2 to double
  %sub = fsub double %r.019, %conv
  %cmp3 = fcmp ugt double %sub, 0.000000e+00
  br i1 %cmp3, label %for.inc, label %if.then5

if.then5:                                         ; preds = %for.body
  %idxprom.le = and i64 %indvars.iv, 4294967295
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %idxprom.le, i32 1
  %2 = load i64, i64* %state, align 8, !tbaa !33
  br label %cleanup

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %cleanup, label %for.body, !llvm.loop !79

cleanup:                                          ; preds = %for.inc, %if.end, %entry, %if.then5
  %retval.0 = phi i64 [ %2, %if.then5 ], [ 0, %entry ], [ -1, %if.end ], [ -1, %for.inc ]
  ret i64 %retval.0
}

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_prob_inline.42(<2 x float> %a.coerce) unnamed_addr #17 {
entry:
  %call = tail call fastcc float @quantum_real.43(<2 x float> %a.coerce) #34
  %call6 = tail call fastcc float @quantum_imag.44(<2 x float> %a.coerce) #34
  %mul7 = fmul float %call6, %call6
  %0 = tail call float @llvm.fmuladd.f32(float %call, float %call, float %mul7)
  ret float %0
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_real.43(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.0.vec.extract = extractelement <2 x float> %a.coerce, i32 0
  ret float %a.sroa.0.0.vec.extract
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_imag.44(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.4.vec.extract = extractelement <2 x float> %a.coerce, i32 1
  ret float %a.sroa.0.4.vec.extract
}

; Function Attrs: noinline nounwind optsize uwtable
define i32 @quantum_bmeasure(i32 %pos, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %out = alloca %struct.quantum_reg_struct, align 8
  %tmp = alloca %struct.quantum_reg_struct, align 8
  %out.0..sroa_cast = bitcast %struct.quantum_reg_struct* %out to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %out.0..sroa_cast)
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext -127, i32 %pos) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %sh_prom = zext i32 %pos to i64
  %shl = shl nuw i64 1, %sh_prom
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %cmp38 = icmp sgt i32 %0, 0
  br i1 %cmp38, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %if.end
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
  %pa.039 = phi double [ 0.000000e+00, %for.body.lr.ph ], [ %pa.1, %for.inc ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 1
  %2 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %2, %shl
  %tobool1.not = icmp eq i64 %and, 0
  br i1 %tobool1.not, label %if.then2, label %for.inc

if.then2:                                         ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %amplitude.imag, i32 1
  %call6 = tail call fastcc float @quantum_prob_inline.42(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call6 to double
  %add = fadd double %pa.039, %conv
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then2
  %pa.1 = phi double [ %pa.039, %for.body ], [ %add, %if.then2 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !80

for.end:                                          ; preds = %for.inc, %if.end
  %pa.0.lcssa = phi double [ 0.000000e+00, %if.end ], [ %pa.1, %for.inc ]
  %call8 = tail call double @quantum_frand() #34
  %cmp9 = fcmp ogt double %call8, %pa.0.lcssa
  %result.0 = zext i1 %cmp9 to i32
  %3 = bitcast %struct.quantum_reg_struct* %tmp to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %3) #33
  call void @quantum_state_collapse(%struct.quantum_reg_struct* nonnull sret(%struct.quantum_reg_struct) align 8 %tmp, i32 %pos, i32 %result.0, %struct.quantum_reg_struct* nonnull byval(%struct.quantum_reg_struct) align 8 %reg) #31
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %out.0..sroa_cast, i8* noundef nonnull align 8 dereferenceable(32) %3, i64 32, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %3) #33
  call void @quantum_delete_qureg_hashpreserve(%struct.quantum_reg_struct* nonnull %reg) #31
  %4 = bitcast %struct.quantum_reg_struct* %reg to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %4, i8* noundef nonnull align 8 dereferenceable(32) %out.0..sroa_cast, i64 32, i1 false), !tbaa.struct !25
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end
  %retval.0 = phi i32 [ %result.0, %for.end ], [ 0, %entry ]
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %out.0..sroa_cast)
  ret i32 %retval.0
}

; Function Attrs: noinline nounwind optsize uwtable
define i32 @quantum_bmeasure_bitpreserve(i32 %pos, %struct.quantum_reg_struct* %reg) local_unnamed_addr #15 {
entry:
  %call = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext -126, i32 %pos) #31
  %tobool.not = icmp eq i32 %call, 0
  br i1 %tobool.not, label %if.end, label %cleanup

if.end:                                           ; preds = %entry
  %sh_prom = zext i32 %pos to i64
  %shl = shl nuw i64 1, %sh_prom
  %size1 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %0 = load i32, i32* %size1, align 4, !tbaa !30
  %cmp206 = icmp sgt i32 %0, 0
  br i1 %cmp206, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %if.end
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv212 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next213, %for.inc ]
  %pa.0207 = phi double [ 0.000000e+00, %for.body.lr.ph ], [ %pa.1, %for.inc ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv212, i32 1
  %2 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %2, %shl
  %tobool2.not = icmp eq i64 %and, 0
  br i1 %tobool2.not, label %if.then3, label %for.inc

if.then3:                                         ; preds = %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv212, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv212, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %amplitude.imag, i32 1
  %call7 = tail call fastcc float @quantum_prob_inline.42(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call7 to double
  %add = fadd double %pa.0207, %conv
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then3
  %pa.1 = phi double [ %pa.0207, %for.body ], [ %add, %if.then3 ]
  %indvars.iv.next213 = add nuw nsw i64 %indvars.iv212, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next213, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !81

for.end:                                          ; preds = %for.inc, %if.end
  %pa.0.lcssa = phi double [ 0.000000e+00, %if.end ], [ %pa.1, %for.inc ]
  %call9 = tail call double @quantum_frand() #34
  %cmp10 = fcmp ogt double %call9, %pa.0.lcssa
  %result.0 = zext i1 %cmp10 to i32
  %node19 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %3 = load i32, i32* %size1, align 4, !tbaa !30
  %cmp16199 = icmp sgt i32 %3, 0
  br i1 %cmp16199, label %for.body18, label %for.end63

for.body18:                                       ; preds = %for.end, %for.inc61
  %indvars.iv210 = phi i64 [ %indvars.iv.next211, %for.inc61 ], [ 0, %for.end ]
  %size.0201 = phi i32 [ %size.1, %for.inc61 ], [ 0, %for.end ]
  %d.0200 = phi double [ %d.1, %for.inc61 ], [ 0.000000e+00, %for.end ]
  %4 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node19, align 8, !tbaa !32
  %state22 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv210, i32 1
  %5 = load i64, i64* %state22, align 8, !tbaa !33
  %and23 = and i64 %5, %shl
  %tobool24.not = icmp eq i64 %and23, 0
  %amplitude48.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv210, i32 0, i32 0
  br i1 %tobool24.not, label %if.else42, label %if.then25

if.then25:                                        ; preds = %for.body18
  br i1 %cmp10, label %if.else, label %if.then27

if.then27:                                        ; preds = %if.then25
  %amplitude31.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv210, i32 0, i32 1
  store float 0.000000e+00, float* %amplitude48.realp, align 8
  store float 0.000000e+00, float* %amplitude31.imagp, align 4
  br label %for.inc61

if.else:                                          ; preds = %if.then25
  %amplitude35.real = load float, float* %amplitude48.realp, align 8
  %amplitude35.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv210, i32 0, i32 1
  %amplitude35.imag = load float, float* %amplitude35.imagp, align 4
  %coerce36.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude35.real, i32 0
  %coerce36.sroa.0.4.vec.insert = insertelement <2 x float> %coerce36.sroa.0.0.vec.insert, float %amplitude35.imag, i32 1
  %call37 = tail call fastcc float @quantum_prob_inline.42(<2 x float> %coerce36.sroa.0.4.vec.insert) #34
  %conv38 = fpext float %call37 to double
  %add39 = fadd double %d.0200, %conv38
  %inc40 = add nsw i32 %size.0201, 1
  br label %for.inc61

if.else42:                                        ; preds = %for.body18
  br i1 %cmp10, label %if.then44, label %if.else49

if.then44:                                        ; preds = %if.else42
  %amplitude48.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv210, i32 0, i32 1
  store float 0.000000e+00, float* %amplitude48.realp, align 8
  store float 0.000000e+00, float* %amplitude48.imagp, align 4
  br label %for.inc61

if.else49:                                        ; preds = %if.else42
  %amplitude53.real = load float, float* %amplitude48.realp, align 8
  %amplitude53.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %indvars.iv210, i32 0, i32 1
  %amplitude53.imag = load float, float* %amplitude53.imagp, align 4
  %coerce54.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude53.real, i32 0
  %coerce54.sroa.0.4.vec.insert = insertelement <2 x float> %coerce54.sroa.0.0.vec.insert, float %amplitude53.imag, i32 1
  %call55 = tail call fastcc float @quantum_prob_inline.42(<2 x float> %coerce54.sroa.0.4.vec.insert) #34
  %conv56 = fpext float %call55 to double
  %add57 = fadd double %d.0200, %conv56
  %inc58 = add nsw i32 %size.0201, 1
  br label %for.inc61

for.inc61:                                        ; preds = %if.else, %if.then27, %if.else49, %if.then44
  %d.1 = phi double [ %add39, %if.else ], [ %d.0200, %if.then27 ], [ %d.0200, %if.then44 ], [ %add57, %if.else49 ]
  %size.1 = phi i32 [ %inc40, %if.else ], [ %size.0201, %if.then27 ], [ %size.0201, %if.then44 ], [ %inc58, %if.else49 ]
  %indvars.iv.next211 = add nuw nsw i64 %indvars.iv210, 1
  %6 = load i32, i32* %size1, align 4, !tbaa !30
  %7 = sext i32 %6 to i64
  %cmp16 = icmp slt i64 %indvars.iv.next211, %7
  br i1 %cmp16, label %for.body18, label %for.end63, !llvm.loop !82

for.end63:                                        ; preds = %for.inc61, %for.end
  %d.0.lcssa = phi double [ 0.000000e+00, %for.end ], [ %d.1, %for.inc61 ]
  %size.0.lcssa = phi i32 [ 0, %for.end ], [ %size.1, %for.inc61 ]
  %conv65 = sext i32 %size.0.lcssa to i64
  %call66 = tail call noalias align 16 i8* @calloc(i64 %conv65, i64 16) #31
  %8 = bitcast i8* %call66 to %struct.quantum_reg_node_struct*
  %tobool69.not = icmp eq i8* %call66, null
  br i1 %tobool69.not, label %if.then70, label %if.end72

if.then70:                                        ; preds = %for.end63
  %call71 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.49, i64 0, i64 0), i32 %size.0.lcssa) #34
  tail call void @exit(i32 1) #32
  unreachable

if.end72:                                         ; preds = %for.end63
  %mul = shl nsw i64 %conv65, 4
  %call74 = tail call i64 @quantum_memman(i64 %mul) #31
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %9 = load i32, i32* %hashw, align 8, !tbaa !49
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %10 = load i32*, i32** %hash, align 8, !tbaa !50
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %11 = load i32, i32* %width, align 8, !tbaa !55
  %12 = load i32, i32* %size1, align 4, !tbaa !30
  %cmp80196 = icmp sgt i32 %12, 0
  br i1 %cmp80196, label %for.body82, label %for.end116

for.body82:                                       ; preds = %if.end72, %for.inc114
  %13 = phi i32 [ %18, %for.inc114 ], [ %12, %if.end72 ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc114 ], [ 0, %if.end72 ]
  %j.0197 = phi i32 [ %j.1, %for.inc114 ], [ 0, %if.end72 ]
  %14 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node19, align 8, !tbaa !32
  %amplitude86.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %indvars.iv, i32 0, i32 0
  %amplitude86.real = load float, float* %amplitude86.realp, align 8
  %amplitude86.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %indvars.iv, i32 0, i32 1
  %amplitude86.imag = load float, float* %amplitude86.imagp, align 4
  %tobool87 = fcmp une float %amplitude86.real, 0.000000e+00
  %tobool88 = fcmp une float %amplitude86.imag, 0.000000e+00
  %tobool89 = or i1 %tobool87, %tobool88
  br i1 %tobool89, label %if.then90, label %for.inc114

if.then90:                                        ; preds = %for.body82
  %state94 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %indvars.iv, i32 1
  %15 = load i64, i64* %state94, align 8, !tbaa !33
  %idxprom96 = sext i32 %j.0197 to i64
  %state98 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %8, i64 %idxprom96, i32 1
  store i64 %15, i64* %state98, align 8, !tbaa !33
  %amplitude102.real = load float, float* %amplitude86.realp, align 8
  %amplitude102.imag = load float, float* %amplitude86.imagp, align 4
  %mul_bd = fmul float %amplitude102.imag, 0.000000e+00
  %mul_ad = fmul float %amplitude102.real, 0.000000e+00
  %mul_r = fsub float %amplitude102.real, %mul_bd
  %mul_i = fadd float %mul_ad, %amplitude102.imag
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then90
  %isnan_cmp103 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp103, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call104 = tail call <2 x float> @__mulsc3(float %amplitude102.real, float %amplitude102.imag, float 1.000000e+00, float 0.000000e+00) #31
  %coerce105.sroa.0.0.vec.extract = extractelement <2 x float> %call104, i32 0
  %coerce105.sroa.0.4.vec.extract = extractelement <2 x float> %call104, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then90
  %real_mul_phi = phi float [ %mul_r, %if.then90 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce105.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then90 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce105.sroa.0.4.vec.extract, %complex_mul_libcall ]
  %call106 = tail call double @sqrt(double %d.0.lcssa) #31
  %conv107 = fptrunc double %call106 to float
  %16 = fdiv float %real_mul_phi, %conv107
  %17 = fdiv float %imag_mul_phi, %conv107
  %amplitude111.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %8, i64 %idxprom96, i32 0, i32 0
  %amplitude111.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %8, i64 %idxprom96, i32 0, i32 1
  store float %16, float* %amplitude111.realp, align 16
  store float %17, float* %amplitude111.imagp, align 4
  %inc112 = add nsw i32 %j.0197, 1
  %.pre = load i32, i32* %size1, align 4, !tbaa !30
  br label %for.inc114

for.inc114:                                       ; preds = %for.body82, %complex_mul_cont
  %18 = phi i32 [ %.pre, %complex_mul_cont ], [ %13, %for.body82 ]
  %j.1 = phi i32 [ %inc112, %complex_mul_cont ], [ %j.0197, %for.body82 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %19 = sext i32 %18 to i64
  %cmp80 = icmp slt i64 %indvars.iv.next, %19
  br i1 %cmp80, label %for.body82, label %for.end116, !llvm.loop !83

for.end116:                                       ; preds = %for.inc114, %if.end72
  tail call void @quantum_delete_qureg_hashpreserve(%struct.quantum_reg_struct* nonnull %reg) #31
  store i32 %11, i32* %width, align 8, !tbaa.struct !25
  store i32 %size.0.lcssa, i32* %size1, align 4, !tbaa.struct !84
  store i32 %9, i32* %hashw, align 8, !tbaa.struct !85
  %20 = bitcast %struct.quantum_reg_node_struct** %node19 to i8**
  store i8* %call66, i8** %20, align 8, !tbaa.struct !86
  store i32* %10, i32** %hash, align 8, !tbaa.struct !67
  br label %cleanup

cleanup:                                          ; preds = %entry, %for.end116
  %retval.0 = phi i32 [ %result.0, %for.end116 ], [ 0, %entry ]
  ret i32 %retval.0
}

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @sqrt(double) local_unnamed_addr #18

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define i8* @quantum_get_version() local_unnamed_addr #21 {
entry:
  ret i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.50, i64 0, i64 0)
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
define float @quantum_get_decoherence() local_unnamed_addr #3 {
entry:
  %0 = load float, float* @lambda, align 4, !tbaa !87
  ret float %0
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
define void @quantum_set_decoherence(float %l) local_unnamed_addr #12 {
entry:
  %tobool = fcmp une float %l, 0.000000e+00
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  store i32 1, i32* @status, align 4, !tbaa !18
  store float %l, float* @lambda, align 4, !tbaa !87
  br label %if.end

if.else:                                          ; preds = %entry
  store i32 0, i32* @status, align 4, !tbaa !18
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_decohere(%struct.quantum_reg_struct* nocapture readonly %reg) local_unnamed_addr #15 {
entry:
  %call = tail call i32 @quantum_gate_counter(i32 1) #31
  %0 = load i32, i32* @status, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %if.end74, label %if.then

if.then:                                          ; preds = %entry
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %1 = load i32, i32* %width, align 8, !tbaa !55
  %conv = sext i32 %1 to i64
  %call1 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 4) #31
  %2 = bitcast i8* %call1 to float*
  %tobool2.not = icmp eq i8* %call1, null
  br i1 %tobool2.not, label %if.then3, label %if.end

if.then3:                                         ; preds = %if.then
  %call5 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([48 x i8], [48 x i8]* @.str.53, i64 0, i64 0), i32 %1) #34
  tail call void @exit(i32 1) #32
  unreachable

if.end:                                           ; preds = %if.then
  %mul = shl nsw i64 %conv, 2
  %call8 = tail call i64 @quantum_memman(i64 %mul) #31
  %3 = load i32, i32* %width, align 8, !tbaa !55
  %cmp119 = icmp sgt i32 %3, 0
  br i1 %cmp119, label %do.body.preheader, label %for.cond36.preheader

do.body.preheader:                                ; preds = %if.end, %do.end
  %indvars.iv123 = phi i64 [ %indvars.iv.next124, %do.end ], [ 0, %if.end ]
  br label %do.body

for.cond36.preheader:                             ; preds = %do.end, %if.end
  %4 = phi i32 [ %3, %if.end ], [ %10, %do.end ]
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %5 = load i32, i32* %size, align 4, !tbaa !30
  %cmp37117 = icmp sgt i32 %5, 0
  br i1 %cmp37117, label %for.cond40.preheader, label %for.end68

do.body:                                          ; preds = %do.body.preheader, %do.body
  %call11 = tail call double (...) bitcast (double ()* @quantum_frand to double (...)*)() #31
  %6 = tail call double @llvm.fmuladd.f64(double %call11, double 2.000000e+00, double -1.000000e+00)
  %conv13 = fptrunc double %6 to float
  %call14 = tail call double (...) bitcast (double ()* @quantum_frand to double (...)*)() #31
  %7 = tail call double @llvm.fmuladd.f64(double %call14, double 2.000000e+00, double -1.000000e+00)
  %conv16 = fptrunc double %7 to float
  %mul18 = fmul float %conv16, %conv16
  %8 = tail call float @llvm.fmuladd.f32(float %conv13, float %conv13, float %mul18)
  %cmp19 = fcmp ult float %8, 1.000000e+00
  br i1 %cmp19, label %do.end, label %do.body, !llvm.loop !89

do.end:                                           ; preds = %do.body
  %conv21 = fpext float %conv13 to double
  %conv22 = fpext float %8 to double
  %call23 = tail call double @log(double %conv22) #31
  %mul24 = fmul double %call23, -2.000000e+00
  %div = fdiv double %mul24, %conv22
  %call26 = tail call double @sqrt(double %div) #31
  %mul27 = fmul double %call26, %conv21
  %conv28 = fptrunc double %mul27 to float
  %9 = load float, float* @lambda, align 4, !tbaa !87
  %mul29 = fmul float %9, 2.000000e+00
  %conv30 = fpext float %mul29 to double
  %call31 = tail call double @sqrt(double %conv30) #31
  %conv32 = fpext float %conv28 to double
  %mul33 = fmul double %call31, %conv32
  %conv34 = fptrunc double %mul33 to float
  %div35 = fmul float %conv34, 5.000000e-01
  %arrayidx = getelementptr inbounds float, float* %2, i64 %indvars.iv123
  store float %div35, float* %arrayidx, align 4, !tbaa !87
  %indvars.iv.next124 = add nuw nsw i64 %indvars.iv123, 1
  %10 = load i32, i32* %width, align 8, !tbaa !55
  %11 = sext i32 %10 to i64
  %cmp = icmp slt i64 %indvars.iv.next124, %11
  br i1 %cmp, label %do.body.preheader, label %for.cond36.preheader, !llvm.loop !90

for.cond40.preheader:                             ; preds = %for.cond36.preheader, %complex_mul_cont
  %12 = phi i32 [ %.pre, %complex_mul_cont ], [ %4, %for.cond36.preheader ]
  %indvars.iv121 = phi i64 [ %indvars.iv.next122, %complex_mul_cont ], [ 0, %for.cond36.preheader ]
  %cmp42114 = icmp sgt i32 %12, 0
  br i1 %cmp42114, label %for.body44.lr.ph, label %for.end56

for.body44.lr.ph:                                 ; preds = %for.cond40.preheader
  %13 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %13, i64 %indvars.iv121, i32 1
  %14 = load i64, i64* %state, align 8, !tbaa !33
  %wide.trip.count = zext i32 %12 to i64
  br label %for.body44

for.body44:                                       ; preds = %for.body44.lr.ph, %for.body44
  %indvars.iv = phi i64 [ 0, %for.body44.lr.ph ], [ %indvars.iv.next, %for.body44 ]
  %angle.0116 = phi float [ 0.000000e+00, %for.body44.lr.ph ], [ %angle.1, %for.body44 ]
  %shl = shl nuw i64 1, %indvars.iv
  %and = and i64 %14, %shl
  %tobool47.not = icmp eq i64 %and, 0
  %arrayidx52 = getelementptr inbounds float, float* %2, i64 %indvars.iv
  %15 = load float, float* %arrayidx52, align 4, !tbaa !87
  %16 = fneg float %15
  %angle.1.p = select i1 %tobool47.not, float %16, float %15
  %angle.1 = fadd float %angle.0116, %angle.1.p
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end56, label %for.body44, !llvm.loop !91

for.end56:                                        ; preds = %for.body44, %for.cond40.preheader
  %angle.0.lcssa = phi float [ 0.000000e+00, %for.cond40.preheader ], [ %angle.1, %for.body44 ]
  %call57 = tail call <2 x float> @quantum_cexp(float %angle.0.lcssa) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call57, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call57, i32 1
  %17 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %17, i64 %indvars.iv121, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %17, i64 %indvars.iv121, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %mul_ac = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.real
  %mul_bd = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.imag
  %mul_ad = fmul float %coerce.sroa.0.4.vec.extract, %amplitude.real
  %mul_bc = fmul float %coerce.sroa.0.0.vec.extract, %amplitude.imag
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_ad, %mul_bc
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %for.end56
  %isnan_cmp61 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp61, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call62 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %coerce.sroa.0.0.vec.extract, float %coerce.sroa.0.4.vec.extract) #31
  %coerce63.sroa.0.0.vec.extract = extractelement <2 x float> %call62, i32 0
  %coerce63.sroa.0.4.vec.extract = extractelement <2 x float> %call62, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %for.end56
  %real_mul_phi = phi float [ %mul_r, %for.end56 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce63.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %for.end56 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce63.sroa.0.4.vec.extract, %complex_mul_libcall ]
  store float %real_mul_phi, float* %amplitude.realp, align 8
  store float %imag_mul_phi, float* %amplitude.imagp, align 4
  %indvars.iv.next122 = add nuw nsw i64 %indvars.iv121, 1
  %18 = load i32, i32* %size, align 4, !tbaa !30
  %19 = sext i32 %18 to i64
  %cmp37 = icmp slt i64 %indvars.iv.next122, %19
  %.pre = load i32, i32* %width, align 8, !tbaa !55
  br i1 %cmp37, label %for.cond40.preheader, label %for.end68, !llvm.loop !92

for.end68:                                        ; preds = %complex_mul_cont, %for.cond36.preheader
  %20 = phi i32 [ %4, %for.cond36.preheader ], [ %.pre, %complex_mul_cont ]
  tail call void @free(i8* %call1) #31
  %sub70 = sub nsw i32 0, %20
  %conv71 = sext i32 %sub70 to i64
  %mul72 = shl nsw i64 %conv71, 2
  %call73 = tail call i64 @quantum_memman(i64 %mul72) #31
  br label %if.end74

if.end74:                                         ; preds = %for.end68, %entry
  ret void
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #20

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @log(double) local_unnamed_addr #18

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
define void @quantum_qec_set_status(i32 %stype, i32 %swidth) local_unnamed_addr #12 {
entry:
  store i32 %stype, i32* @type, align 4, !tbaa !18
  store i32 %swidth, i32* @width, align 4, !tbaa !18
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
define void @quantum_qec_get_status(i32* %ptype, i32* %pwidth) local_unnamed_addr #22 {
entry:
  %tobool.not = icmp eq i32* %ptype, null
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %0 = load i32, i32* @type, align 4, !tbaa !18
  store i32 %0, i32* %ptype, align 4, !tbaa !18
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %tobool1.not = icmp eq i32* %pwidth, null
  br i1 %tobool1.not, label %if.end3, label %if.then2

if.then2:                                         ; preds = %if.end
  %1 = load i32, i32* @width, align 4, !tbaa !18
  store i32 %1, i32* %pwidth, align 4, !tbaa !18
  br label %if.end3

if.end3:                                          ; preds = %if.then2, %if.end
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_qec_encode(i32 %type, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %call = tail call float (...) bitcast (float ()* @quantum_get_decoherence to float (...)*)() #31
  tail call void @quantum_set_decoherence(float 0.000000e+00) #31
  %width1 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %0 = load i32, i32* %width1, align 8, !tbaa !55
  %cmp53 = icmp sgt i32 %0, 0
  br i1 %cmp53, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %1 = phi i32 [ %7, %for.inc ], [ %0, %entry ]
  %i.054 = phi i32 [ %inc, %for.inc ], [ 0, %entry ]
  %sub = add nsw i32 %1, -1
  %cmp3 = icmp eq i32 %i.054, %sub
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  tail call void @quantum_set_decoherence(float %call) #31
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %cmp4 = icmp slt i32 %i.054, %width
  %2 = load i32, i32* %width1, align 8, !tbaa !55
  %add = add nsw i32 %2, %i.054
  br i1 %cmp4, label %if.then5, label %if.else

if.then5:                                         ; preds = %if.end
  tail call void @quantum_hadamard(i32 %add, %struct.quantum_reg_struct* nonnull %reg) #31
  %3 = load i32, i32* %width1, align 8, !tbaa !55
  %mul = shl nsw i32 %3, 1
  %add8 = add nsw i32 %mul, %i.054
  tail call void @quantum_hadamard(i32 %add8, %struct.quantum_reg_struct* nonnull %reg) #31
  %4 = load i32, i32* %width1, align 8, !tbaa !55
  %add10 = add nsw i32 %4, %i.054
  tail call void @quantum_cnot(i32 %add10, i32 %i.054, %struct.quantum_reg_struct* nonnull %reg) #31
  %5 = load i32, i32* %width1, align 8, !tbaa !55
  %mul12 = shl nsw i32 %5, 1
  %add13 = add nsw i32 %mul12, %i.054
  br label %for.inc

if.else:                                          ; preds = %if.end
  tail call void @quantum_cnot(i32 %i.054, i32 %add, %struct.quantum_reg_struct* nonnull %reg) #31
  %6 = load i32, i32* %width1, align 8, !tbaa !55
  %mul17 = shl nsw i32 %6, 1
  %add18 = add nsw i32 %mul17, %i.054
  br label %for.inc

for.inc:                                          ; preds = %if.then5, %if.else
  %i.054.sink = phi i32 [ %i.054, %if.then5 ], [ %add18, %if.else ]
  %add13.sink = phi i32 [ %add13, %if.then5 ], [ %i.054, %if.else ]
  tail call void @quantum_cnot(i32 %add13.sink, i32 %i.054.sink, %struct.quantum_reg_struct* nonnull %reg) #31
  %inc = add nuw nsw i32 %i.054, 1
  %7 = load i32, i32* %width1, align 8, !tbaa !55
  %cmp = icmp slt i32 %inc, %7
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !93

for.end:                                          ; preds = %for.inc, %entry
  %.lcssa = phi i32 [ %0, %entry ], [ %7, %for.inc ]
  tail call void @quantum_qec_set_status(i32 1, i32 %.lcssa) #34
  %8 = load i32, i32* %width1, align 8, !tbaa !55
  %mul22 = mul nsw i32 %8, 3
  store i32 %mul22, i32* %width1, align 8, !tbaa !55
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_qec_decode(i32 %type, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %call = tail call float (...) bitcast (float ()* @quantum_get_decoherence to float (...)*)() #31
  tail call void @quantum_set_decoherence(float 0.000000e+00) #31
  %width1 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %0 = load i32, i32* %width1, align 8, !tbaa !55
  %div = sdiv i32 %0, 3
  tail call void @quantum_qec_set_status(i32 0, i32 0) #34
  %1 = load i32, i32* %width1, align 8, !tbaa !55
  %mul = shl nsw i32 %div, 1
  %cmp79 = icmp sgt i32 %1, 2
  br i1 %cmp79, label %for.body.preheader, label %for.cond15.preheader

for.body.preheader:                               ; preds = %entry
  %div382 = udiv i32 %1, 3
  br label %for.body

for.cond15.preheader:                             ; preds = %for.inc, %entry
  %cmp16.not75 = icmp slt i32 %0, 3
  br i1 %cmp16.not75, label %for.end31, label %for.body17

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %i.0.in80 = phi i32 [ %i.081, %for.inc ], [ %div382, %for.body.preheader ]
  %i.081 = add nsw i32 %i.0.in80, -1
  %cmp4 = icmp eq i32 %i.081, 0
  br i1 %cmp4, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  tail call void @quantum_set_decoherence(float %call) #31
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %cmp5.not = icmp sgt i32 %i.0.in80, %width
  %add12 = add nsw i32 %i.081, %mul
  br i1 %cmp5.not, label %if.else, label %if.then6

if.then6:                                         ; preds = %if.end
  tail call void @quantum_cnot(i32 %add12, i32 %i.081, %struct.quantum_reg_struct* %reg) #31
  %add7 = add nsw i32 %i.081, %div
  tail call void @quantum_cnot(i32 %add7, i32 %i.081, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_hadamard(i32 %add12, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_hadamard(i32 %add7, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc

if.else:                                          ; preds = %if.end
  tail call void @quantum_cnot(i32 %i.081, i32 %add12, %struct.quantum_reg_struct* %reg) #31
  %add13 = add nsw i32 %i.081, %div
  tail call void @quantum_cnot(i32 %i.081, i32 %add13, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc

for.inc:                                          ; preds = %if.then6, %if.else
  %cmp = icmp sgt i32 %i.0.in80, 1
  br i1 %cmp, label %for.body, label %for.cond15.preheader, !llvm.loop !94

for.body17:                                       ; preds = %for.cond15.preheader, %for.inc30
  %i.176 = phi i32 [ %inc, %for.inc30 ], [ 1, %for.cond15.preheader ]
  %call18 = tail call i32 @quantum_bmeasure(i32 %div, %struct.quantum_reg_struct* %reg) #31
  %sub20 = sub nsw i32 %mul, %i.176
  %call21 = tail call i32 @quantum_bmeasure(i32 %sub20, %struct.quantum_reg_struct* %reg) #31
  %cmp22 = icmp ne i32 %call18, 1
  %cmp23 = icmp ne i32 %call21, 1
  %or.cond = select i1 %cmp22, i1 true, i1 %cmp23
  %cmp26.not = icmp sgt i32 %i.176, %width
  %or.cond74 = select i1 %or.cond, i1 true, i1 %cmp26.not
  br i1 %or.cond74, label %for.inc30, label %if.then27

if.then27:                                        ; preds = %for.body17
  %sub25 = add nsw i32 %i.176, -1
  tail call void @quantum_sigma_z(i32 %sub25, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc30

for.inc30:                                        ; preds = %for.body17, %if.then27
  %inc = add nuw nsw i32 %i.176, 1
  %exitcond.not = icmp eq i32 %i.176, %div
  br i1 %exitcond.not, label %for.end31, label %for.body17, !llvm.loop !95

for.end31:                                        ; preds = %for.inc30, %for.cond15.preheader
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define i32 @quantum_qec_counter(i32 %inc, i32 %frequency, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %cmp = icmp sgt i32 %inc, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %0 = load i32, i32* @quantum_qec_counter.counter, align 4, !tbaa !18
  %add = add nsw i32 %0, %inc
  br label %if.end3.sink.split

if.else:                                          ; preds = %entry
  %cmp1 = icmp slt i32 %inc, 0
  br i1 %cmp1, label %if.end3.sink.split, label %if.end3

if.end3.sink.split:                               ; preds = %if.else, %if.then
  %.sink = phi i32 [ %add, %if.then ], [ 0, %if.else ]
  store i32 %.sink, i32* @quantum_qec_counter.counter, align 4, !tbaa !18
  br label %if.end3

if.end3:                                          ; preds = %if.end3.sink.split, %if.else
  %cmp4 = icmp sgt i32 %frequency, 0
  br i1 %cmp4, label %if.then5, label %if.end3.if.end6_crit_edge

if.end3.if.end6_crit_edge:                        ; preds = %if.end3
  %.pre = load i32, i32* @quantum_qec_counter.freq, align 4, !tbaa !18
  br label %if.end6

if.then5:                                         ; preds = %if.end3
  store i32 %frequency, i32* @quantum_qec_counter.freq, align 4, !tbaa !18
  br label %if.end6

if.end6:                                          ; preds = %if.end3.if.end6_crit_edge, %if.then5
  %1 = phi i32 [ %.pre, %if.end3.if.end6_crit_edge ], [ %frequency, %if.then5 ]
  %2 = load i32, i32* @quantum_qec_counter.counter, align 4, !tbaa !18
  %cmp7.not = icmp slt i32 %2, %1
  br i1 %cmp7.not, label %if.end9, label %if.then8

if.then8:                                         ; preds = %if.end6
  store i32 0, i32* @quantum_qec_counter.counter, align 4, !tbaa !18
  %3 = load i32, i32* @width, align 4, !tbaa !18
  tail call void @quantum_qec_decode(i32 undef, i32 %3, %struct.quantum_reg_struct* %reg) #34
  %4 = load i32, i32* @width, align 4, !tbaa !18
  tail call void @quantum_qec_encode(i32 undef, i32 %4, %struct.quantum_reg_struct* %reg) #34
  %.pre14 = load i32, i32* @quantum_qec_counter.counter, align 4, !tbaa !18
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.end6
  %5 = phi i32 [ %.pre14, %if.then8 ], [ %2, %if.end6 ]
  ret i32 %5
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_sigma_x_ft(i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %0 = load i32, i32* @type, align 4, !tbaa !18
  store i32 0, i32* @type, align 4, !tbaa !18
  %call = tail call float (...) bitcast (float ()* @quantum_get_decoherence to float (...)*)() #31
  tail call void @quantum_set_decoherence(float 0.000000e+00) #31
  tail call void @quantum_sigma_x(i32 %target, %struct.quantum_reg_struct* %reg) #31
  %1 = load i32, i32* @width, align 4, !tbaa !18
  %add = add nsw i32 %1, %target
  tail call void @quantum_sigma_x(i32 %add, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_set_decoherence(float %call) #31
  %2 = load i32, i32* @width, align 4, !tbaa !18
  %mul = shl nsw i32 %2, 1
  %add1 = add nsw i32 %mul, %target
  tail call void @quantum_sigma_x(i32 %add1, %struct.quantum_reg_struct* %reg) #31
  %call2 = tail call i32 @quantum_qec_counter(i32 1, i32 0, %struct.quantum_reg_struct* %reg) #34
  store i32 %0, i32* @type, align 4, !tbaa !18
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_cnot_ft(i32 %control, i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %0 = load i32, i32* @type, align 4, !tbaa !18
  store i32 0, i32* @type, align 4, !tbaa !18
  %call = tail call float (...) bitcast (float ()* @quantum_get_decoherence to float (...)*)() #31
  tail call void @quantum_set_decoherence(float 0.000000e+00) #31
  tail call void @quantum_cnot(i32 %control, i32 %target, %struct.quantum_reg_struct* %reg) #31
  %1 = load i32, i32* @width, align 4, !tbaa !18
  %add = add nsw i32 %1, %control
  %add1 = add nsw i32 %1, %target
  tail call void @quantum_cnot(i32 %add, i32 %add1, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_set_decoherence(float %call) #31
  %2 = load i32, i32* @width, align 4, !tbaa !18
  %mul = shl nsw i32 %2, 1
  %add2 = add nsw i32 %mul, %control
  %add4 = add nsw i32 %mul, %target
  tail call void @quantum_cnot(i32 %add2, i32 %add4, %struct.quantum_reg_struct* %reg) #31
  %call5 = tail call i32 @quantum_qec_counter(i32 1, i32 0, %struct.quantum_reg_struct* %reg) #34
  store i32 %0, i32* @type, align 4, !tbaa !18
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_toffoli_ft(i32 %control1, i32 %control2, i32 %target, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %sh_prom = zext i32 %target to i64
  %shl = shl nuw i64 1, %sh_prom
  %0 = load i32, i32* @width, align 4, !tbaa !18
  %add = add nsw i32 %0, %target
  %sh_prom1 = zext i32 %add to i64
  %shl2 = shl nuw i64 1, %sh_prom1
  %add3 = add i64 %shl2, %shl
  %mul = shl nsw i32 %0, 1
  %add4 = add nsw i32 %mul, %target
  %sh_prom5 = zext i32 %add4 to i64
  %shl6 = shl nuw i64 1, %sh_prom5
  %add7 = add i64 %add3, %shl6
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %1 = load i32, i32* %size, align 4, !tbaa !30
  %sh_prom8 = zext i32 %control1 to i64
  %shl9 = shl nuw i64 1, %sh_prom8
  %add14 = add nsw i32 %0, %control1
  %sh_prom15 = zext i32 %add14 to i64
  %shl16 = shl nuw i64 1, %sh_prom15
  %add26 = add nsw i32 %mul, %control1
  %sh_prom27 = zext i32 %add26 to i64
  %shl28 = shl nuw i64 1, %sh_prom27
  %sh_prom38 = zext i32 %control2 to i64
  %shl39 = shl nuw i64 1, %sh_prom38
  %add48 = add nsw i32 %0, %control2
  %sh_prom49 = zext i32 %add48 to i64
  %shl50 = shl nuw i64 1, %sh_prom49
  %add61 = add nsw i32 %mul, %control2
  %sh_prom62 = zext i32 %add61 to i64
  %shl63 = shl nuw i64 1, %sh_prom62
  %cmp121 = icmp sgt i32 %1, 0
  br i1 %cmp121, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %entry
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %1 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 1
  %3 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %3, %shl9
  %tobool.not = icmp ne i64 %and, 0
  %and17 = and i64 %3, %shl16
  %tobool18.not = icmp ne i64 %and17, 0
  %c1.1117 = xor i1 %tobool.not, %tobool18.not
  %and29 = and i64 %3, %shl28
  %tobool30.not = icmp ne i64 %and29, 0
  %spec.select115118 = xor i1 %tobool30.not, %c1.1117
  %and40 = and i64 %3, %shl39
  %tobool41.not = icmp ne i64 %and40, 0
  %and51 = and i64 %3, %shl50
  %tobool52.not = icmp ne i64 %and51, 0
  %spec.select116119 = xor i1 %tobool41.not, %tobool52.not
  %and64 = and i64 %3, %shl63
  %tobool65.not = icmp ne i64 %and64, 0
  %c2.2120 = xor i1 %tobool65.not, %spec.select116119
  %or.cond = and i1 %spec.select115118, %c2.2120
  br i1 %or.cond, label %if.then71, label %for.inc

if.then71:                                        ; preds = %for.body
  %xor76 = xor i64 %3, %add7
  store i64 %xor76, i64* %state, align 8, !tbaa !33
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then71
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !96

for.end:                                          ; preds = %for.inc, %entry
  tail call void @quantum_decohere(%struct.quantum_reg_struct* nonnull %reg) #31
  %call = tail call i32 @quantum_qec_counter(i32 1, i32 0, %struct.quantum_reg_struct* nonnull %reg) #34
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readnone uwtable
define i32 @quantum_ipow(i32 %a, i32 %b) local_unnamed_addr #24 {
entry:
  %cmp5 = icmp sgt i32 %b, 0
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %r.07 = phi i32 [ %mul, %for.body ], [ 1, %entry ]
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nsw i32 %r.07, %a
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %b
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !97

for.end:                                          ; preds = %for.body, %entry
  %r.0.lcssa = phi i32 [ 1, %entry ], [ %mul, %for.body ]
  ret i32 %r.0.lcssa
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readnone uwtable
define i32 @quantum_gcd(i32 %u, i32 %v) local_unnamed_addr #24 {
entry:
  %tobool.not5 = icmp eq i32 %v, 0
  br i1 %tobool.not5, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %u.addr.07 = phi i32 [ %v.addr.06, %while.body ], [ %u, %entry ]
  %v.addr.06 = phi i32 [ %rem, %while.body ], [ %v, %entry ]
  %rem = srem i32 %u.addr.07, %v.addr.06
  %tobool.not = icmp eq i32 %rem, 0
  br i1 %tobool.not, label %while.end, label %while.body, !llvm.loop !98

while.end:                                        ; preds = %while.body, %entry
  %u.addr.0.lcssa = phi i32 [ %u, %entry ], [ %v.addr.06, %while.body ]
  ret i32 %u.addr.0.lcssa
}

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
define void @quantum_frac_approx(i32* nocapture %a, i32* nocapture %b, i32 %width) local_unnamed_addr #25 {
entry:
  %0 = load i32, i32* %a, align 4, !tbaa !18
  %conv = sitofp i32 %0 to float
  %1 = load i32, i32* %b, align 4, !tbaa !18
  %conv1 = sitofp i32 %1 to float
  %div = fdiv float %conv, %conv1
  %shl = shl nuw i32 1, %width
  %mul23 = shl nsw i32 %shl, 1
  %conv24 = sitofp i32 %mul23 to double
  %div25 = fdiv double 1.000000e+00, %conv24
  %conv254 = fpext float %div to double
  %cmp57 = icmp slt i32 %shl, 1
  br i1 %cmp57, label %do.end, label %if.end.preheader

if.end.preheader:                                 ; preds = %entry
  %add55 = fadd double %conv254, 5.000000e-06
  %conv356 = fptosi double %add55 to i32
  br label %if.end

do.body:                                          ; preds = %if.end
  %conv4 = sitofp i32 %conv362 to double
  %sub = fadd double %conv4, -5.000000e-06
  %sub6 = fsub double %conv261, %sub
  %conv7 = fptrunc double %sub6 to float
  %conv10 = fdiv float 1.000000e+00, %conv7
  %conv2 = fpext float %conv10 to double
  %add = fadd double %conv2, 5.000000e-06
  %conv3 = fptosi double %add to i32
  %mul = mul nsw i32 %add1163, %conv3
  %add11 = add nsw i32 %mul, %den.060
  %cmp = icmp sgt i32 %add11, %shl
  br i1 %cmp, label %do.end, label %if.end, !llvm.loop !99

if.end:                                           ; preds = %if.end.preheader, %do.body
  %add1163 = phi i32 [ %add11, %do.body ], [ 1, %if.end.preheader ]
  %conv362 = phi i32 [ %conv3, %do.body ], [ %conv356, %if.end.preheader ]
  %conv261 = phi double [ %conv2, %do.body ], [ %conv254, %if.end.preheader ]
  %den.060 = phi i32 [ %add1163, %do.body ], [ 0, %if.end.preheader ]
  %num1.059 = phi i32 [ %add14, %do.body ], [ 1, %if.end.preheader ]
  %num2.058 = phi i32 [ %num1.059, %do.body ], [ 0, %if.end.preheader ]
  %mul13 = mul nsw i32 %num1.059, %conv362
  %add14 = add nsw i32 %mul13, %num2.058
  %conv17 = sitofp i32 %add14 to float
  %conv18 = sitofp i32 %add1163 to float
  %div19 = fdiv float %conv17, %conv18
  %sub20 = fsub float %div19, %div
  %2 = tail call float @llvm.fabs.f32(float %sub20)
  %conv21 = fpext float %2 to double
  %cmp26 = fcmp olt double %div25, %conv21
  br i1 %cmp26, label %do.body, label %do.end, !llvm.loop !99

do.end:                                           ; preds = %if.end, %do.body, %entry
  %num.1 = phi i32 [ 0, %entry ], [ %add14, %do.body ], [ %add14, %if.end ]
  %den.1 = phi i32 [ 0, %entry ], [ %add1163, %do.body ], [ %add1163, %if.end ]
  store i32 %num.1, i32* %a, align 4, !tbaa !18
  store i32 %den.1, i32* %b, align 4, !tbaa !18
  ret void
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fabs.f32(float) #20

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readnone uwtable
define i32 @quantum_getwidth(i32 %n) local_unnamed_addr #24 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.cond, %entry
  %i.0 = phi i32 [ 1, %entry ], [ %inc, %for.cond ]
  %shl = shl nuw i32 1, %i.0
  %cmp = icmp slt i32 %shl, %n
  %inc = add nuw nsw i32 %i.0, 1
  br i1 %cmp, label %for.cond, label %for.end, !llvm.loop !100

for.end:                                          ; preds = %for.cond
  ret i32 %i.0
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readnone uwtable
define i32 @quantum_inverse_mod(i32 %n, i32 %c) local_unnamed_addr #24 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.cond, %entry
  %i.0 = phi i32 [ 1, %entry ], [ %inc, %for.cond ]
  %mul = mul nsw i32 %i.0, %c
  %rem = srem i32 %mul, %n
  %cmp.not = icmp eq i32 %rem, 1
  %inc = add nuw nsw i32 %i.0, 1
  br i1 %cmp.not, label %for.end, label %for.cond, !llvm.loop !101

for.end:                                          ; preds = %for.cond
  ret i32 %i.0
}

; Function Attrs: noinline nounwind optsize uwtable
define i32 @main(i32 %argc, i8** nocapture readonly %argv) local_unnamed_addr #0 {
entry:
  %qr = alloca %struct.quantum_reg_struct, align 8
  %c = alloca i32, align 4
  %q = alloca i32, align 4
  %tmp = alloca %struct.quantum_reg_struct, align 8
  %0 = bitcast %struct.quantum_reg_struct* %qr to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %0) #33
  %1 = bitcast i32* %c to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1) #33
  %2 = bitcast i32* %q to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %2) #33
  tail call void @spec_srand(i32 26) #31
  %cmp = icmp eq i32 %argc, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %puts188 = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([22 x i8], [22 x i8]* @str.18, i64 0, i64 0))
  br label %cleanup

if.end:                                           ; preds = %entry
  %arrayidx = getelementptr inbounds i8*, i8** %argv, i64 1
  %3 = load i8*, i8** %arrayidx, align 8, !tbaa !22
  %call1 = tail call i32 @atoi(i8* %3) #37
  %cmp2 = icmp slt i32 %call1, 15
  br i1 %cmp2, label %if.then3, label %if.end5

if.then3:                                         ; preds = %if.end
  %puts187 = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @str.17, i64 0, i64 0))
  br label %cleanup

if.end5:                                          ; preds = %if.end
  %mul = mul nsw i32 %call1, %call1
  %call6 = tail call i32 @quantum_getwidth(i32 %mul) #31
  %call7 = tail call i32 @quantum_getwidth(i32 %call1) #31
  %mul8 = mul i32 %call7, 3
  %add = add i32 %mul8, 2
  %add9 = add i32 %add, %call6
  %call10 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([28 x i8], [28 x i8]* @.str.2.64, i64 0, i64 0), i32 %call1, i32 %add9) #34
  %cmp11 = icmp sgt i32 %argc, 2
  br i1 %cmp11, label %if.then12, label %if.end15

if.then12:                                        ; preds = %if.end5
  %arrayidx13 = getelementptr inbounds i8*, i8** %argv, i64 2
  %4 = load i8*, i8** %arrayidx13, align 8, !tbaa !22
  %call14 = tail call i32 @atoi(i8* %4) #37
  br label %if.end15

if.end15:                                         ; preds = %if.then12, %if.end5
  %x.0 = phi i32 [ %call14, %if.then12 ], [ 0, %if.end5 ]
  %conv21201 = zext i32 %call1 to i64
  %call16196 = tail call i32 @quantum_gcd(i32 %call1, i32 %x.0) #31
  %cmp17197 = icmp sgt i32 %call16196, 1
  %cmp18198 = icmp slt i32 %x.0, 2
  %5 = select i1 %cmp17197, i1 true, i1 %cmp18198
  br i1 %5, label %while.body, label %while.end

while.body:                                       ; preds = %if.end15, %while.body
  %call19 = tail call double @spec_rand() #31
  %mul20 = fmul double %call19, 0x41DFFFFFFFC00000
  %conv = fptosi double %mul20 to i64
  %rem = srem i64 %conv, %conv21201
  %conv22 = trunc i64 %rem to i32
  %call16 = tail call i32 @quantum_gcd(i32 %call1, i32 %conv22) #31
  %cmp17 = icmp sgt i32 %call16, 1
  %cmp18 = icmp slt i32 %conv22, 2
  %6 = select i1 %cmp17, i1 true, i1 %cmp18
  br i1 %6, label %while.body, label %while.end.loopexit, !llvm.loop !102

while.end.loopexit:                               ; preds = %while.body
  %conv22.le = trunc i64 %rem to i32
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %if.end15
  %x.1.lcssa = phi i32 [ %x.0, %if.end15 ], [ %conv22.le, %while.end.loopexit ]
  %call23 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3.65, i64 0, i64 0), i32 %x.1.lcssa) #34
  %7 = bitcast %struct.quantum_reg_struct* %tmp to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %7) #33
  call void @quantum_new_qureg(%struct.quantum_reg_struct* nonnull sret(%struct.quantum_reg_struct) align 8 %tmp, i64 0, i32 %call6) #31
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %0, i8* noundef nonnull align 8 dereferenceable(32) %7, i64 32, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %7) #33
  %cmp24194 = icmp sgt i32 %call6, 0
  br i1 %cmp24194, label %for.body, label %for.end

for.body:                                         ; preds = %while.end, %for.body
  %i.0195 = phi i32 [ %inc, %for.body ], [ 0, %while.end ]
  call void @quantum_hadamard(i32 %i.0195, %struct.quantum_reg_struct* nonnull %qr) #31
  %inc = add nuw nsw i32 %i.0195, 1
  %exitcond200.not = icmp eq i32 %inc, %call6
  br i1 %exitcond200.not, label %for.end, label %for.body, !llvm.loop !103

for.end:                                          ; preds = %for.body, %while.end
  call void @quantum_addscratch(i32 %add, %struct.quantum_reg_struct* nonnull %qr) #31
  call void @quantum_exp_mod_n(i32 %call1, i32 %x.1.lcssa, i32 %call6, i32 %call7, %struct.quantum_reg_struct* nonnull %qr) #31
  %cmp31192 = icmp sgt i32 %mul8, -2
  br i1 %cmp31192, label %for.body33.preheader, label %for.end37

for.body33.preheader:                             ; preds = %for.end
  %smax = call i32 @llvm.smax.i32(i32 %add, i32 1)
  br label %for.body33

for.body33:                                       ; preds = %for.body33.preheader, %for.body33
  %i.1193 = phi i32 [ %inc36, %for.body33 ], [ 0, %for.body33.preheader ]
  %call34 = call i32 @quantum_bmeasure(i32 0, %struct.quantum_reg_struct* nonnull %qr) #31
  %inc36 = add nuw nsw i32 %i.1193, 1
  %exitcond199.not = icmp eq i32 %inc36, %smax
  br i1 %exitcond199.not, label %for.end37, label %for.body33, !llvm.loop !104

for.end37:                                        ; preds = %for.body33, %for.end
  call void @quantum_qft(i32 %call6, %struct.quantum_reg_struct* nonnull %qr) #31
  %div = sdiv i32 %call6, 2
  %cmp39190 = icmp sgt i32 %call6, 1
  br i1 %cmp39190, label %for.body41, label %for.end49

for.body41:                                       ; preds = %for.end37, %for.body41
  %i.2191 = phi i32 [ %inc48, %for.body41 ], [ 0, %for.end37 ]
  %8 = xor i32 %i.2191, -1
  %sub42 = add i32 %call6, %8
  call void @quantum_cnot(i32 %i.2191, i32 %sub42, %struct.quantum_reg_struct* nonnull %qr) #31
  call void @quantum_cnot(i32 %sub42, i32 %i.2191, %struct.quantum_reg_struct* nonnull %qr) #31
  call void @quantum_cnot(i32 %i.2191, i32 %sub42, %struct.quantum_reg_struct* nonnull %qr) #31
  %inc48 = add nuw nsw i32 %i.2191, 1
  %exitcond.not = icmp eq i32 %inc48, %div
  br i1 %exitcond.not, label %for.end49, label %for.body41, !llvm.loop !105

for.end49:                                        ; preds = %for.body41, %for.end37
  %call50 = call i64 @quantum_measure(%struct.quantum_reg_struct* nonnull byval(%struct.quantum_reg_struct) align 8 %qr) #31
  %conv51 = trunc i64 %call50 to i32
  store i32 %conv51, i32* %c, align 4, !tbaa !18
  switch i32 %conv51, label %if.end61 [
    i32 -1, label %if.then54
    i32 0, label %if.then59
  ]

if.then54:                                        ; preds = %for.end49
  %puts186 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @str.16, i64 0, i64 0))
  call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.then59:                                        ; preds = %for.end49
  %puts185 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([26 x i8], [26 x i8]* @str.15.66, i64 0, i64 0))
  call void @exit(i32 2) #32
  br label %UnifiedUnreachableBlock

if.end61:                                         ; preds = %for.end49
  %shl = shl nuw i32 1, %call6
  store i32 %shl, i32* %q, align 4, !tbaa !18
  %conv62 = sitofp i32 %conv51 to float
  %conv63 = sitofp i32 %shl to float
  %div64 = fdiv float %conv62, %conv63
  %conv65 = fpext float %div64 to double
  %call66 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([19 x i8], [19 x i8]* @.str.6.67, i64 0, i64 0), i32 %conv51, double %conv65) #34
  call void @quantum_frac_approx(i32* nonnull %c, i32* nonnull %q, i32 %call6) #31
  %9 = load i32, i32* %c, align 4, !tbaa !18
  %10 = load i32, i32* %q, align 4, !tbaa !18
  %call67 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([36 x i8], [36 x i8]* @.str.7.68, i64 0, i64 0), i32 %9, i32 %10) #34
  %11 = load i32, i32* %q, align 4, !tbaa !18
  %rem68 = srem i32 %11, 2
  %cmp69 = icmp eq i32 %rem68, 1
  %mul71 = shl nsw i32 %11, 1
  %cmp73 = icmp slt i32 %mul71, %shl
  %or.cond189 = select i1 %cmp69, i1 %cmp73, i1 false
  br i1 %or.cond189, label %if.then75, label %if.end78

if.then75:                                        ; preds = %if.end61
  %puts184 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([40 x i8], [40 x i8]* @str.14, i64 0, i64 0))
  %12 = load i32, i32* %q, align 4, !tbaa !18
  %mul77 = shl nsw i32 %12, 1
  store i32 %mul77, i32* %q, align 4, !tbaa !18
  br label %if.end78

if.end78:                                         ; preds = %if.then75, %if.end61
  %13 = phi i32 [ %mul77, %if.then75 ], [ %11, %if.end61 ]
  %rem79 = srem i32 %13, 2
  %cmp80 = icmp eq i32 %rem79, 1
  br i1 %cmp80, label %if.then82, label %if.end84

if.then82:                                        ; preds = %if.end78
  %puts183 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @str.13, i64 0, i64 0))
  call void @exit(i32 2) #32
  br label %UnifiedUnreachableBlock

if.end84:                                         ; preds = %if.end78
  %call85 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.10, i64 0, i64 0), i32 %13) #34
  %14 = load i32, i32* %q, align 4, !tbaa !18
  %div86 = sdiv i32 %14, 2
  %call87 = call i32 @quantum_ipow(i32 %x.1.lcssa, i32 %div86) #31
  %add89 = add nsw i32 %call87, 1
  %15 = load i32, i32* %q, align 4, !tbaa !18
  %div90 = sdiv i32 %15, 2
  %call91 = call i32 @quantum_ipow(i32 %x.1.lcssa, i32 %div90) #31
  %sub93 = add nsw i32 %call91, -1
  %call94 = call i32 @quantum_gcd(i32 %call1, i32 %add89) #31
  %call95 = call i32 @quantum_gcd(i32 %call1, i32 %sub93) #31
  %cmp96 = icmp sgt i32 %call94, %call95
  %call94.call95 = select i1 %cmp96, i32 %call94, i32 %call95
  %cmp100 = icmp slt i32 %call94.call95, %call1
  %cmp103 = icmp sgt i32 %call94.call95, 1
  %or.cond = and i1 %cmp100, %cmp103
  br i1 %or.cond, label %if.then105, label %if.else108

if.then105:                                       ; preds = %if.end84
  %div106 = sdiv i32 %call1, %call94.call95
  %call107 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([14 x i8], [14 x i8]* @.str.11, i64 0, i64 0), i32 %call1, i32 %call94.call95, i32 %div106) #34
  call void @quantum_delete_qureg(%struct.quantum_reg_struct* nonnull %qr) #31
  br label %cleanup

if.else108:                                       ; preds = %if.end84
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([40 x i8], [40 x i8]* @str.69, i64 0, i64 0))
  call void @exit(i32 0) #32
  br label %UnifiedUnreachableBlock

cleanup:                                          ; preds = %if.then105, %if.then3, %if.then
  %retval.0 = phi i32 [ 3, %if.then ], [ 3, %if.then3 ], [ 0, %if.then105 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %2) #33
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1) #33
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %0) #33
  ret i32 %retval.0

UnifiedUnreachableBlock:                          ; preds = %if.else108, %if.then82, %if.then59, %if.then54
  unreachable
}

; Function Attrs: mustprogress nofree nounwind optsize readonly willreturn
declare i32 @atoi(i8* nocapture) local_unnamed_addr #26

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smax.i32(i32, i32) #20

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
define i64 @quantum_memman(i64 %change) local_unnamed_addr #22 {
entry:
  %0 = load i64, i64* @quantum_memman.mem, align 8, !tbaa !20
  %add = add nsw i64 %0, %change
  store i64 %add, i64* @quantum_memman.mem, align 8, !tbaa !20
  %1 = load i64, i64* @quantum_memman.max, align 8, !tbaa !20
  %cmp = icmp sgt i64 %add, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i64 %add, i64* @quantum_memman.max, align 8, !tbaa !20
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret i64 %add
}

; Function Attrs: noinline nounwind optsize uwtable
define { i64, { float, float }* } @quantum_new_matrix(i32 %cols, i32 %rows) local_unnamed_addr #0 {
entry:
  %mul = mul nsw i32 %rows, %cols
  %conv = sext i32 %mul to i64
  %call = tail call noalias align 16 i8* @calloc(i64 %conv, i64 8) #31
  %tobool.not = icmp eq i8* %call, null
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call4 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([35 x i8], [35 x i8]* @.str.74, i64 0, i64 0), i32 %rows, i32 %cols) #34
  tail call void @exit(i32 1) #32
  unreachable

if.end:                                           ; preds = %entry
  %0 = bitcast i8* %call to { float, float }*
  %conv5 = sext i32 %cols to i64
  %mul6 = shl nsw i64 %conv5, 3
  %conv7 = sext i32 %rows to i64
  %mul8 = mul i64 %mul6, %conv7
  %call9 = tail call i64 @quantum_memman(i64 %mul8) #34
  %retval.sroa.2.0.insert.ext = zext i32 %cols to i64
  %retval.sroa.2.0.insert.shift = shl nuw i64 %retval.sroa.2.0.insert.ext, 32
  %retval.sroa.0.0.insert.ext = zext i32 %rows to i64
  %retval.sroa.0.0.insert.insert = or i64 %retval.sroa.2.0.insert.shift, %retval.sroa.0.0.insert.ext
  %.fca.0.insert = insertvalue { i64, { float, float }* } undef, i64 %retval.sroa.0.0.insert.insert, 0
  %.fca.1.insert = insertvalue { i64, { float, float }* } %.fca.0.insert, { float, float }* %0, 1
  ret { i64, { float, float }* } %.fca.1.insert
}

; Function Attrs: mustprogress noinline nounwind optsize uwtable willreturn
define void @quantum_delete_matrix(%struct.quantum_matrix_struct* nocapture %m) local_unnamed_addr #27 {
entry:
  %t = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 2
  %0 = bitcast { float, float }** %t to i8**
  %1 = load i8*, i8** %0, align 8, !tbaa !68
  tail call void @free(i8* %1) #31
  %cols = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 1
  %2 = load i32, i32* %cols, align 4, !tbaa !106
  %conv = sext i32 %2 to i64
  %mul = mul nsw i64 %conv, -8
  %rows = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 0
  %3 = load i32, i32* %rows, align 8, !tbaa !107
  %conv1 = sext i32 %3 to i64
  %mul2 = mul i64 %mul, %conv1
  %call = tail call i64 @quantum_memman(i64 %mul2) #34
  store { float, float }* null, { float, float }** %t, align 8, !tbaa !68
  ret void
}

; Function Attrs: nofree noinline nounwind optsize uwtable
define void @quantum_print_matrix(i64 %m.coerce0, { float, float }* nocapture readonly %m.coerce1) local_unnamed_addr #28 {
entry:
  %m.sroa.0.0.extract.trunc = trunc i64 %m.coerce0 to i32
  %m.sroa.3.0.extract.shift = lshr i64 %m.coerce0, 32
  br label %while.cond

while.cond:                                       ; preds = %while.cond, %entry
  %z.0 = phi i32 [ 0, %entry ], [ %inc, %while.cond ]
  %inc = add nuw nsw i32 %z.0, 1
  %shl = shl nuw i32 1, %z.0
  %cmp = icmp slt i32 %shl, %m.sroa.0.0.extract.trunc
  br i1 %cmp, label %while.cond, label %for.cond.preheader, !llvm.loop !108

for.cond.preheader:                               ; preds = %while.cond
  %m.sroa.3.0.extract.trunc = trunc i64 %m.sroa.3.0.extract.shift to i32
  %cmp440 = icmp sgt i32 %m.sroa.3.0.extract.trunc, 0
  %cmp242 = icmp sgt i32 %m.sroa.0.0.extract.trunc, 0
  br i1 %cmp242, label %for.cond3.preheader.preheader, label %for.end21

for.cond3.preheader.preheader:                    ; preds = %for.cond.preheader
  %0 = ashr i64 %m.coerce0, 32
  %wide.trip.count48 = and i64 %m.coerce0, 4294967295
  br label %for.cond3.preheader

for.cond3.preheader:                              ; preds = %for.cond3.preheader.preheader, %for.end
  %indvars.iv45 = phi i64 [ 0, %for.cond3.preheader.preheader ], [ %indvars.iv.next46, %for.end ]
  %1 = mul nsw i64 %indvars.iv45, %0
  br i1 %cmp440, label %for.body5, label %for.end

for.body5:                                        ; preds = %for.cond3.preheader, %for.body5
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body5 ], [ 0, %for.cond3.preheader ]
  %2 = add nsw i64 %indvars.iv, %1
  %arrayidx.realp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 %2, i32 0
  %arrayidx.real = load float, float* %arrayidx.realp, align 4
  %arrayidx.imagp = getelementptr inbounds { float, float }, { float, float }* %m.coerce1, i64 %2, i32 1
  %arrayidx.imag = load float, float* %arrayidx.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %arrayidx.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %arrayidx.imag, i32 1
  %call = tail call fastcc float @quantum_real.77(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call to double
  %call14 = tail call fastcc float @quantum_imag.78(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv15 = fpext float %call14 to double
  %call16 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1.79, i64 0, i64 0), double %conv, double %conv15) #34
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %m.sroa.3.0.extract.shift
  br i1 %exitcond.not, label %for.end, label %for.body5, !llvm.loop !109

for.end:                                          ; preds = %for.body5, %for.cond3.preheader
  %putchar39 = tail call i32 @putchar(i32 10)
  %indvars.iv.next46 = add nuw nsw i64 %indvars.iv45, 1
  %exitcond49.not = icmp eq i64 %indvars.iv.next46, %wide.trip.count48
  br i1 %exitcond49.not, label %for.end21, label %for.cond3.preheader, !llvm.loop !110

for.end21:                                        ; preds = %for.end, %for.cond.preheader
  %putchar = tail call i32 @putchar(i32 10)
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_real.77(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.0.vec.extract = extractelement <2 x float> %a.coerce, i32 0
  ret float %a.sroa.0.0.vec.extract
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_imag.78(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.4.vec.extract = extractelement <2 x float> %a.coerce, i32 1
  ret float %a.sroa.0.4.vec.extract
}

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_matrix2qureg(%struct.quantum_reg_struct* noalias nocapture sret(%struct.quantum_reg_struct) align 8 %agg.result, %struct.quantum_matrix_struct* nocapture readonly %m, i32 %width) local_unnamed_addr #0 {
entry:
  %cols = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 1
  %0 = load i32, i32* %cols, align 4, !tbaa !106
  %cmp.not = icmp eq i32 %0, 1
  br i1 %cmp.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([51 x i8], [51 x i8]* @.str.80, i64 0, i64 0), i32 %0) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  %width2 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 0
  store i32 %width, i32* %width2, align 8, !tbaa !55
  %rows = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 0
  %1 = load i32, i32* %rows, align 8, !tbaa !107
  %cmp386 = icmp sgt i32 %1, 0
  br i1 %cmp386, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %if.end
  %t = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 2
  %2 = load { float, float }*, { float, float }** %t, align 8, !tbaa !68
  %wide.trip.count = zext i32 %1 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv89 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next90, %for.body ]
  %size.088 = phi i32 [ 0, %for.body.lr.ph ], [ %spec.select, %for.body ]
  %arrayidx.realp = getelementptr inbounds { float, float }, { float, float }* %2, i64 %indvars.iv89, i32 0
  %arrayidx.real = load float, float* %arrayidx.realp, align 4
  %arrayidx.imagp = getelementptr inbounds { float, float }, { float, float }* %2, i64 %indvars.iv89, i32 1
  %arrayidx.imag = load float, float* %arrayidx.imagp, align 4
  %tobool = fcmp une float %arrayidx.real, 0.000000e+00
  %tobool4 = fcmp une float %arrayidx.imag, 0.000000e+00
  %tobool5 = or i1 %tobool, %tobool4
  %inc = zext i1 %tobool5 to i32
  %spec.select = add nuw nsw i32 %size.088, %inc
  %indvars.iv.next90 = add nuw nsw i64 %indvars.iv89, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next90, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !111

for.end:                                          ; preds = %for.body, %if.end
  %size.0.lcssa = phi i32 [ 0, %if.end ], [ %spec.select, %for.body ]
  %size9 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 1
  store i32 %size.0.lcssa, i32* %size9, align 4, !tbaa !30
  %add = add nsw i32 %width, 2
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 2
  store i32 %add, i32* %hashw, align 8, !tbaa !49
  %conv = zext i32 %size.0.lcssa to i64
  %call10 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 16) #31
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 3
  %3 = bitcast %struct.quantum_reg_node_struct** %node to i8**
  store i8* %call10, i8** %3, align 8, !tbaa !32
  %tobool12.not = icmp eq i8* %call10, null
  %4 = bitcast i8* %call10 to %struct.quantum_reg_node_struct*
  br i1 %tobool12.not, label %if.then13, label %if.end15

if.then13:                                        ; preds = %for.end
  %call14 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1.81, i64 0, i64 0), i32 %size.0.lcssa) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end15:                                         ; preds = %for.end
  %mul = shl nuw nsw i64 %conv, 4
  %call17 = tail call i64 @quantum_memman(i64 %mul) #31
  %shl = shl nuw i32 1, %add
  %conv19 = sext i32 %shl to i64
  %call20 = tail call noalias align 16 i8* @calloc(i64 %conv19, i64 4) #31
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 4
  %5 = bitcast i32** %hash to i8**
  store i8* %call20, i8** %5, align 8, !tbaa !50
  %tobool22.not = icmp eq i8* %call20, null
  br i1 %tobool22.not, label %if.then23, label %if.end27

if.then23:                                        ; preds = %if.end15
  %call26 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([38 x i8], [38 x i8]* @.str.2.82, i64 0, i64 0), i32 %shl) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end27:                                         ; preds = %if.end15
  %mul31 = shl nsw i64 %conv19, 2
  %call32 = tail call i64 @quantum_memman(i64 %mul31) #31
  %6 = load i32, i32* %rows, align 8, !tbaa !107
  %cmp3583 = icmp sgt i32 %6, 0
  br i1 %cmp3583, label %for.body37.preheader, label %for.end59

for.body37.preheader:                             ; preds = %if.end27
  %t38 = getelementptr inbounds %struct.quantum_matrix_struct, %struct.quantum_matrix_struct* %m, i64 0, i32 2
  %.pre = load { float, float }*, { float, float }** %t38, align 8, !tbaa !68
  %7 = sext i32 %6 to i64
  br label %for.body37

for.body37:                                       ; preds = %for.body37.preheader, %for.inc57
  %indvars.iv = phi i64 [ 0, %for.body37.preheader ], [ %indvars.iv.next, %for.inc57 ]
  %j.085 = phi i32 [ 0, %for.body37.preheader ], [ %j.1, %for.inc57 ]
  %arrayidx40.realp = getelementptr inbounds { float, float }, { float, float }* %.pre, i64 %indvars.iv, i32 0
  %arrayidx40.real = load float, float* %arrayidx40.realp, align 4
  %arrayidx40.imagp = getelementptr inbounds { float, float }, { float, float }* %.pre, i64 %indvars.iv, i32 1
  %arrayidx40.imag = load float, float* %arrayidx40.imagp, align 4
  %tobool41 = fcmp une float %arrayidx40.real, 0.000000e+00
  %tobool42 = fcmp une float %arrayidx40.imag, 0.000000e+00
  %tobool43 = or i1 %tobool41, %tobool42
  br i1 %tobool43, label %if.then44, label %for.inc57

if.then44:                                        ; preds = %for.body37
  %idxprom47 = sext i32 %j.085 to i64
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %idxprom47, i32 1
  store i64 %indvars.iv, i64* %state, align 8, !tbaa !33
  %arrayidx51.real = load float, float* %arrayidx40.realp, align 4
  %arrayidx51.imag = load float, float* %arrayidx40.imagp, align 4
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %idxprom47, i32 0, i32 0
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %4, i64 %idxprom47, i32 0, i32 1
  store float %arrayidx51.real, float* %amplitude.realp, align 16
  store float %arrayidx51.imag, float* %amplitude.imagp, align 4
  %inc55 = add nsw i32 %j.085, 1
  br label %for.inc57

for.inc57:                                        ; preds = %for.body37, %if.then44
  %j.1 = phi i32 [ %inc55, %if.then44 ], [ %j.085, %for.body37 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp35 = icmp slt i64 %indvars.iv.next, %7
  br i1 %cmp35, label %for.body37, label %for.end59, !llvm.loop !112

for.end59:                                        ; preds = %for.inc57, %if.end27
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then23, %if.then13, %if.then
  unreachable
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_new_qureg(%struct.quantum_reg_struct* noalias nocapture sret(%struct.quantum_reg_struct) align 8 %agg.result, i64 %initval, i32 %width) local_unnamed_addr #0 {
entry:
  %width1 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 0
  store i32 %width, i32* %width1, align 8, !tbaa !55
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 1
  store i32 1, i32* %size, align 4, !tbaa !30
  %add = add nsw i32 %width, 2
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 2
  store i32 %add, i32* %hashw, align 8, !tbaa !49
  %call = tail call noalias align 16 dereferenceable_or_null(16) i8* @calloc(i64 1, i64 16) #31
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 3
  %0 = bitcast %struct.quantum_reg_node_struct** %node to i8**
  store i8* %call, i8** %0, align 8, !tbaa !32
  %tobool.not = icmp eq i8* %call, null
  %1 = bitcast i8* %call to %struct.quantum_reg_node_struct*
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call3 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1.81, i64 0, i64 0), i32 1) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  %call4 = tail call i64 @quantum_memman(i64 16) #31
  %shl = shl nuw i32 1, %add
  %conv = sext i32 %shl to i64
  %call6 = tail call noalias align 16 i8* @calloc(i64 %conv, i64 4) #31
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 4
  %2 = bitcast i32** %hash to i8**
  store i8* %call6, i8** %2, align 8, !tbaa !50
  %tobool8.not = icmp eq i8* %call6, null
  br i1 %tobool8.not, label %if.then9, label %if.end13

if.then9:                                         ; preds = %if.end
  %call12 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([38 x i8], [38 x i8]* @.str.2.82, i64 0, i64 0), i32 %shl) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end13:                                         ; preds = %if.end
  %mul = shl nsw i64 %conv, 2
  %call17 = tail call i64 @quantum_memman(i64 %mul) #31
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 0, i32 1
  store i64 %initval, i64* %state, align 8, !tbaa !33
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 0, i32 0, i32 0
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 0, i32 0, i32 1
  store float 1.000000e+00, float* %amplitude.realp, align 16
  store float 0.000000e+00, float* %amplitude.imagp, align 4
  %call21 = tail call i8* @getenv(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.3.85, i64 0, i64 0)) #31
  %tobool22.not = icmp eq i8* %call21, null
  br i1 %tobool22.not, label %if.end25, label %if.then23

if.then23:                                        ; preds = %if.end13
  tail call void (...) bitcast (void ()* @quantum_objcode_start to void (...)*)() #31
  tail call void @quantum_objcode_file(i8* nonnull %call21) #31
  %call24 = tail call i32 @atexit(void ()* bitcast (void (i8*)* @quantum_objcode_exit to void ()*)) #31
  br label %if.end25

if.end25:                                         ; preds = %if.then23, %if.end13
  %call26 = tail call i32 (i8, ...) @quantum_objcode_put(i8 zeroext 0, i64 %initval) #31
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then9, %if.then
  unreachable
}

; Function Attrs: nofree nounwind optsize readonly
declare noundef i8* @getenv(i8* nocapture noundef) local_unnamed_addr #29

; Function Attrs: nounwind optsize
declare i32 @atexit(void ()*) local_unnamed_addr #30

; Function Attrs: noinline nounwind optsize uwtable
define { i64, { float, float }* } @quantum_qureg2matrix(%struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) local_unnamed_addr #0 {
entry:
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %0 = load i32, i32* %width, align 8, !tbaa !55
  %shl = shl nuw i32 1, %0
  %call = tail call { i64, { float, float }* } @quantum_new_matrix(i32 1, i32 %shl) #31
  %1 = extractvalue { i64, { float, float }* } %call, 1
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %cmp13 = icmp sgt i32 %2, 0
  br i1 %cmp13, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %3 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %3, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %3, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %3, i64 %indvars.iv, i32 1
  %4 = load i64, i64* %state, align 8, !tbaa !33
  %arrayidx4.realp = getelementptr inbounds { float, float }, { float, float }* %1, i64 %4, i32 0
  %arrayidx4.imagp = getelementptr inbounds { float, float }, { float, float }* %1, i64 %4, i32 1
  store float %amplitude.real, float* %arrayidx4.realp, align 4
  store float %amplitude.imag, float* %arrayidx4.imagp, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %5 = load i32, i32* %size, align 4, !tbaa !30
  %6 = sext i32 %5 to i64
  %cmp = icmp slt i64 %indvars.iv.next, %6
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !113

for.end:                                          ; preds = %for.body, %entry
  ret { i64, { float, float }* } %call
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_destroy_hash(%struct.quantum_reg_struct* nocapture %reg) local_unnamed_addr #0 {
entry:
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %0 = bitcast i32** %hash to i8**
  %1 = load i8*, i8** %0, align 8, !tbaa !50
  tail call void @free(i8* %1) #31
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %2 = load i32, i32* %hashw, align 8, !tbaa !49
  %shl.neg = shl nsw i32 -1, %2
  %conv = sext i32 %shl.neg to i64
  %mul = shl nsw i64 %conv, 2
  %call = tail call i64 @quantum_memman(i64 %mul) #31
  store i32* null, i32** %hash, align 8, !tbaa !50
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_delete_qureg(%struct.quantum_reg_struct* nocapture %reg) local_unnamed_addr #0 {
entry:
  tail call void @quantum_destroy_hash(%struct.quantum_reg_struct* %reg) #34
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = bitcast %struct.quantum_reg_node_struct** %node to i8**
  %1 = load i8*, i8** %0, align 8, !tbaa !32
  tail call void @free(i8* %1) #31
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %sub = sub nsw i32 0, %2
  %conv = sext i32 %sub to i64
  %mul = shl nsw i64 %conv, 4
  %call = tail call i64 @quantum_memman(i64 %mul) #31
  store %struct.quantum_reg_node_struct* null, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_delete_qureg_hashpreserve(%struct.quantum_reg_struct* nocapture %reg) local_unnamed_addr #0 {
entry:
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %0 = bitcast %struct.quantum_reg_node_struct** %node to i8**
  %1 = load i8*, i8** %0, align 8, !tbaa !32
  tail call void @free(i8* %1) #31
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %sub = sub nsw i32 0, %2
  %conv = sext i32 %sub to i64
  %mul = shl nsw i64 %conv, 4
  %call = tail call i64 @quantum_memman(i64 %mul) #31
  store %struct.quantum_reg_node_struct* null, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  ret void
}

; Function Attrs: nofree noinline nounwind optsize uwtable
define void @quantum_print_qureg(%struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) local_unnamed_addr #28 {
entry:
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %2 = load i32, i32* %width, align 8
  %cmp2054 = icmp sgt i32 %2, 0
  %cmp56 = icmp sgt i32 %0, 0
  br i1 %cmp56, label %for.body.preheader, label %for.end35

for.body.preheader:                               ; preds = %entry
  %3 = zext i32 %2 to i64
  %wide.trip.count = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.end
  %indvars.iv58 = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next59, %for.end ]
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv58, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv58, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %amplitude.imag, i32 1
  %call = tail call fastcc float @quantum_real.90(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call to double
  %call6 = tail call fastcc float @quantum_imag.91(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv7 = fpext float %call6 to double
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv58, i32 1
  %4 = load i64, i64* %state, align 8, !tbaa !33
  %call16 = tail call fastcc float @quantum_prob_inline.92(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv17 = fpext float %call16 to double
  %call18 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4.93, i64 0, i64 0), double %conv, double %conv7, i64 %4, double %conv17) #34
  br i1 %cmp2054, label %for.body22, label %for.end

for.body22:                                       ; preds = %for.body, %if.end
  %indvars.iv = phi i64 [ %indvars.iv.next, %if.end ], [ %3, %for.body ]
  %j.055.in = phi i32 [ %j.055, %if.end ], [ %2, %for.body ]
  %j.055 = add nsw i32 %j.055.in, -1
  %rem52 = and i32 %j.055, 3
  %cmp23 = icmp eq i32 %rem52, 3
  br i1 %cmp23, label %if.then, label %if.end

if.then:                                          ; preds = %for.body22
  %putchar51 = tail call i32 @putchar(i32 32)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body22
  %sh_prom = zext i32 %j.055 to i64
  %shl = shl nuw i64 1, %sh_prom
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %5, %shl
  %cmp30 = icmp ne i64 %and, 0
  %conv31 = zext i1 %cmp30 to i32
  %call32 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([3 x i8], [3 x i8]* @.str.6.94, i64 0, i64 0), i32 %conv31) #34
  %cmp20 = icmp sgt i64 %indvars.iv, 1
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  br i1 %cmp20, label %for.body22, label %for.end, !llvm.loop !114

for.end:                                          ; preds = %if.end, %for.body
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([3 x i8], [3 x i8]* @str.95, i64 0, i64 0))
  %indvars.iv.next59 = add nuw nsw i64 %indvars.iv58, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next59, %wide.trip.count
  br i1 %exitcond.not, label %for.end35, label %for.body, !llvm.loop !115

for.end35:                                        ; preds = %for.end, %entry
  %putchar = tail call i32 @putchar(i32 10)
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_real.90(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.0.vec.extract = extractelement <2 x float> %a.coerce, i32 0
  ret float %a.sroa.0.0.vec.extract
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_imag.91(<2 x float> %a.coerce) unnamed_addr #19 {
entry:
  %a.sroa.0.4.vec.extract = extractelement <2 x float> %a.coerce, i32 1
  ret float %a.sroa.0.4.vec.extract
}

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize readnone uwtable willreturn
define internal fastcc float @quantum_prob_inline.92(<2 x float> %a.coerce) unnamed_addr #17 {
entry:
  %call = tail call fastcc float @quantum_real.90(<2 x float> %a.coerce) #34
  %call6 = tail call fastcc float @quantum_imag.91(<2 x float> %a.coerce) #34
  %mul7 = fmul float %call6, %call6
  %0 = tail call float @llvm.fmuladd.f32(float %call, float %call, float %mul7)
  ret float %0
}

; Function Attrs: nofree noinline nounwind optsize uwtable
define void @quantum_print_expn(%struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) local_unnamed_addr #11 {
entry:
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %0 = load i32, i32* %size, align 4, !tbaa !30
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %2 = load i32, i32* %width, align 8
  %div = sdiv i32 %2, 2
  %cmp6 = icmp sgt i32 %0, 0
  br i1 %cmp6, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv, i32 1
  %3 = load i64, i64* %state, align 8, !tbaa !33
  %4 = trunc i64 %indvars.iv to i32
  %mul = shl i32 %4, %div
  %conv = sext i32 %mul to i64
  %sub = sub i64 %3, %conv
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i64 0, i64 0), i32 %4, i64 %sub) #34
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !116

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
define void @quantum_addscratch(i32 %bits, %struct.quantum_reg_struct* nocapture %reg) local_unnamed_addr #16 {
entry:
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %0 = load i32, i32* %width, align 8, !tbaa !55
  %add = add nsw i32 %0, %bits
  store i32 %add, i32* %width, align 8, !tbaa !55
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %1 = load i32, i32* %size, align 4, !tbaa !30
  %sh_prom = zext i32 %bits to i64
  %cmp17 = icmp sgt i32 %1, 0
  br i1 %cmp17, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %entry
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %wide.trip.count = zext i32 %1 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.body ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %indvars.iv, i32 1
  %3 = load i64, i64* %state, align 8, !tbaa !33
  %shl = shl i64 %3, %sh_prom
  store i64 %shl, i64* %state, align 8, !tbaa !33
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !117

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Function Attrs: nofree noinline nounwind optsize uwtable
define void @quantum_print_hash(%struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) local_unnamed_addr #11 {
entry:
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %0 = load i32, i32* %hashw, align 8, !tbaa !49
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %1 = load i32*, i32** %hash, align 8
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %cmp13.not = icmp eq i32 %0, 31
  br i1 %cmp13.not, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  %shl = shl nuw nsw i32 1, %0
  %smax = call i32 @llvm.smax.i32(i32 %shl, i32 1)
  %wide.trip.count = zext i32 %smax to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %tobool.not = icmp eq i64 %indvars.iv, 0
  br i1 %tobool.not, label %for.inc, label %if.then

if.then:                                          ; preds = %for.body
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %indvars.iv
  %3 = load i32, i32* %arrayidx, align 4, !tbaa !18
  %sub = add nsw i32 %3, -1
  %idxprom5 = sext i32 %sub to i64
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %idxprom5, i32 1
  %4 = load i64, i64* %state, align 8, !tbaa !33
  %5 = trunc i64 %indvars.iv to i32
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str.10.98, i64 0, i64 0), i32 %5, i32 %sub, i64 %4) #34
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !118

for.end:                                          ; preds = %for.inc, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_kronecker(%struct.quantum_reg_struct* noalias nocapture sret(%struct.quantum_reg_struct) align 8 %agg.result, %struct.quantum_reg_struct* nocapture readonly %reg1, %struct.quantum_reg_struct* nocapture readonly %reg2) local_unnamed_addr #15 {
entry:
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg1, i64 0, i32 0
  %0 = load i32, i32* %width, align 8, !tbaa !55
  %width1 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 0
  %1 = load i32, i32* %width1, align 8, !tbaa !55
  %add = add nsw i32 %1, %0
  %width2 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 0
  store i32 %add, i32* %width2, align 8, !tbaa !55
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg1, i64 0, i32 1
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %size3 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 1
  %3 = load i32, i32* %size3, align 4, !tbaa !30
  %mul = mul nsw i32 %3, %2
  %size4 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 1
  store i32 %mul, i32* %size4, align 4, !tbaa !30
  %add8 = add nsw i32 %mul, 2
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 2
  store i32 %add8, i32* %hashw, align 8, !tbaa !49
  %conv = sext i32 %mul to i64
  %call = tail call noalias align 16 i8* @calloc(i64 %conv, i64 16) #31
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 3
  %4 = bitcast %struct.quantum_reg_node_struct** %node to i8**
  store i8* %call, i8** %4, align 8, !tbaa !32
  %tobool.not = icmp eq i8* %call, null
  %5 = bitcast i8* %call to %struct.quantum_reg_node_struct*
  br i1 %tobool.not, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call12 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1.81, i64 0, i64 0), i32 %mul) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  %mul15 = shl nsw i64 %conv, 4
  %call16 = tail call i64 @quantum_memman(i64 %mul15) #31
  %shl = shl nuw i32 1, %add8
  %conv18 = sext i32 %shl to i64
  %call19 = tail call noalias align 16 i8* @calloc(i64 %conv18, i64 4) #31
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 4
  %6 = bitcast i32** %hash to i8**
  store i8* %call19, i8** %6, align 8, !tbaa !50
  %tobool21.not = icmp eq i8* %call19, null
  br i1 %tobool21.not, label %if.then22, label %if.end26

if.then22:                                        ; preds = %if.end
  %call25 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([38 x i8], [38 x i8]* @.str.2.82, i64 0, i64 0), i32 %shl) #34
  tail call void @exit(i32 1) #32
  br label %UnifiedUnreachableBlock

if.end26:                                         ; preds = %if.end
  %mul30 = shl nsw i64 %conv18, 2
  %call31 = tail call i64 @quantum_memman(i64 %mul30) #31
  %node39 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg1, i64 0, i32 3
  %node42 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 3
  %7 = load i32, i32* %size, align 4, !tbaa !30
  %cmp99 = icmp sgt i32 %7, 0
  br i1 %cmp99, label %for.cond34.preheader.preheader, label %for.end71

for.cond34.preheader.preheader:                   ; preds = %if.end26
  %.pre = load i32, i32* %size3, align 4, !tbaa !30
  br label %for.cond34.preheader

for.cond34.preheader:                             ; preds = %for.cond34.preheader.preheader, %for.inc69
  %8 = phi i32 [ %7, %for.cond34.preheader.preheader ], [ %22, %for.inc69 ]
  %9 = phi i32 [ %.pre, %for.cond34.preheader.preheader ], [ %23, %for.inc69 ]
  %10 = phi i32 [ %.pre, %for.cond34.preheader.preheader ], [ %24, %for.inc69 ]
  %indvars.iv102 = phi i64 [ 0, %for.cond34.preheader.preheader ], [ %indvars.iv.next103, %for.inc69 ]
  %cmp3697 = icmp sgt i32 %10, 0
  br i1 %cmp3697, label %for.body38.preheader, label %for.inc69

for.body38.preheader:                             ; preds = %for.cond34.preheader
  %11 = trunc i64 %indvars.iv102 to i32
  br label %for.body38

for.body38:                                       ; preds = %for.body38.preheader, %complex_mul_cont
  %12 = phi i32 [ %9, %for.body38.preheader ], [ %20, %complex_mul_cont ]
  %indvars.iv = phi i64 [ 0, %for.body38.preheader ], [ %indvars.iv.next, %complex_mul_cont ]
  %13 = phi i32 [ %10, %for.body38.preheader ], [ %20, %complex_mul_cont ]
  %14 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node39, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %indvars.iv102, i32 1
  %15 = load i64, i64* %state, align 8, !tbaa !33
  %16 = load i32, i32* %width1, align 8, !tbaa !55
  %sh_prom = zext i32 %16 to i64
  %shl41 = shl i64 %15, %sh_prom
  %17 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node42, align 8, !tbaa !32
  %state45 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %17, i64 %indvars.iv, i32 1
  %18 = load i64, i64* %state45, align 8, !tbaa !33
  %or = or i64 %shl41, %18
  %mul48 = mul nsw i32 %13, %11
  %19 = trunc i64 %indvars.iv to i32
  %add49 = add nsw i32 %mul48, %19
  %idxprom50 = sext i32 %add49 to i64
  %state52 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %5, i64 %idxprom50, i32 1
  store i64 %or, i64* %state52, align 8, !tbaa !33
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %indvars.iv102, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %indvars.iv102, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %amplitude59.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %17, i64 %indvars.iv, i32 0, i32 0
  %amplitude59.real = load float, float* %amplitude59.realp, align 8
  %amplitude59.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %17, i64 %indvars.iv, i32 0, i32 1
  %amplitude59.imag = load float, float* %amplitude59.imagp, align 4
  %mul_ac = fmul float %amplitude.real, %amplitude59.real
  %mul_bd = fmul float %amplitude.imag, %amplitude59.imag
  %mul_ad = fmul float %amplitude.real, %amplitude59.imag
  %mul_bc = fmul float %amplitude.imag, %amplitude59.real
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_bc, %mul_ad
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %for.body38
  %isnan_cmp60 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp60, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call61 = tail call <2 x float> @__mulsc3(float %amplitude.real, float %amplitude.imag, float %amplitude59.real, float %amplitude59.imag) #31
  %coerce.sroa.0.0.vec.extract = extractelement <2 x float> %call61, i32 0
  %coerce.sroa.0.4.vec.extract = extractelement <2 x float> %call61, i32 1
  %.pre104 = load i32, i32* %size3, align 4, !tbaa !30
  %.pre106 = mul nsw i32 %.pre104, %11
  %.pre107 = add nsw i32 %.pre106, %19
  %.pre108 = sext i32 %.pre107 to i64
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %for.body38
  %idxprom66.pre-phi = phi i64 [ %.pre108, %complex_mul_libcall ], [ %idxprom50, %complex_mul_imag_nan ], [ %idxprom50, %for.body38 ]
  %20 = phi i32 [ %.pre104, %complex_mul_libcall ], [ %12, %complex_mul_imag_nan ], [ %12, %for.body38 ]
  %real_mul_phi = phi float [ %coerce.sroa.0.0.vec.extract, %complex_mul_libcall ], [ %mul_r, %complex_mul_imag_nan ], [ %mul_r, %for.body38 ]
  %imag_mul_phi = phi float [ %coerce.sroa.0.4.vec.extract, %complex_mul_libcall ], [ %mul_i, %complex_mul_imag_nan ], [ %mul_i, %for.body38 ]
  %amplitude68.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %5, i64 %idxprom66.pre-phi, i32 0, i32 0
  %amplitude68.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %5, i64 %idxprom66.pre-phi, i32 0, i32 1
  store float %real_mul_phi, float* %amplitude68.realp, align 16
  store float %imag_mul_phi, float* %amplitude68.imagp, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %21 = sext i32 %20 to i64
  %cmp36 = icmp slt i64 %indvars.iv.next, %21
  br i1 %cmp36, label %for.body38, label %for.inc69.loopexit, !llvm.loop !119

for.inc69.loopexit:                               ; preds = %complex_mul_cont
  %.pre105 = load i32, i32* %size, align 4, !tbaa !30
  br label %for.inc69

for.inc69:                                        ; preds = %for.inc69.loopexit, %for.cond34.preheader
  %22 = phi i32 [ %.pre105, %for.inc69.loopexit ], [ %8, %for.cond34.preheader ]
  %23 = phi i32 [ %20, %for.inc69.loopexit ], [ %9, %for.cond34.preheader ]
  %24 = phi i32 [ %20, %for.inc69.loopexit ], [ %10, %for.cond34.preheader ]
  %indvars.iv.next103 = add nuw nsw i64 %indvars.iv102, 1
  %25 = sext i32 %22 to i64
  %cmp = icmp slt i64 %indvars.iv.next103, %25
  br i1 %cmp, label %for.cond34.preheader, label %for.end71, !llvm.loop !120

for.end71:                                        ; preds = %for.inc69, %if.end26
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then22, %if.then
  unreachable
}

; Function Attrs: noinline nounwind optsize uwtable
define void @quantum_state_collapse(%struct.quantum_reg_struct* noalias nocapture sret(%struct.quantum_reg_struct) align 8 %agg.result, i32 %pos, i32 %value, %struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) local_unnamed_addr #15 {
entry:
  %sh_prom = zext i32 %pos to i64
  %shl = shl nuw i64 1, %sh_prom
  %size1 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 1
  %0 = load i32, i32* %size1, align 4, !tbaa !30
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %1 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %tobool2 = icmp ne i32 %value, 0
  %cmp161 = icmp sgt i32 %0, 0
  br i1 %cmp161, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %wide.trip.count176 = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %indvars.iv174 = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next175, %for.inc ]
  %d.0164 = phi double [ 0.000000e+00, %for.body.preheader ], [ %d.1, %for.inc ]
  %size.0162 = phi i32 [ 0, %for.body.preheader ], [ %size.1, %for.inc ]
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv174, i32 1
  %2 = load i64, i64* %state, align 8, !tbaa !33
  %and = and i64 %2, %shl
  %tobool = icmp ne i64 %and, 0
  %or.cond = select i1 %tobool, i1 %tobool2, i1 false
  br i1 %or.cond, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %for.body
  %or.cond103 = select i1 %tobool, i1 true, i1 %tobool2
  br i1 %or.cond103, label %for.inc, label %if.then

if.then:                                          ; preds = %lor.lhs.false, %for.body
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv174, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv174, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %amplitude.imag, i32 1
  %call = tail call fastcc float @quantum_prob_inline.92(<2 x float> %coerce.sroa.0.4.vec.insert) #34
  %conv = fpext float %call to double
  %add = fadd double %d.0164, %conv
  %inc = add nsw i32 %size.0162, 1
  br label %for.inc

for.inc:                                          ; preds = %lor.lhs.false, %if.then
  %size.1 = phi i32 [ %inc, %if.then ], [ %size.0162, %lor.lhs.false ]
  %d.1 = phi double [ %add, %if.then ], [ %d.0164, %lor.lhs.false ]
  %indvars.iv.next175 = add nuw nsw i64 %indvars.iv174, 1
  %exitcond177.not = icmp eq i64 %indvars.iv.next175, %wide.trip.count176
  br i1 %exitcond177.not, label %for.end, label %for.body, !llvm.loop !121

for.end:                                          ; preds = %for.inc, %entry
  %size.0.lcssa = phi i32 [ 0, %entry ], [ %size.1, %for.inc ]
  %d.0.lcssa = phi double [ 0.000000e+00, %entry ], [ %d.1, %for.inc ]
  %width = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 0
  %3 = load i32, i32* %width, align 8, !tbaa !55
  %sub = add nsw i32 %3, -1
  %width15 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 0
  store i32 %sub, i32* %width15, align 8, !tbaa !55
  %size16 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 1
  store i32 %size.0.lcssa, i32* %size16, align 4, !tbaa !30
  %conv17 = sext i32 %size.0.lcssa to i64
  %call18 = tail call noalias align 16 i8* @calloc(i64 %conv17, i64 16) #31
  %node19 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 3
  %4 = bitcast %struct.quantum_reg_node_struct** %node19 to i8**
  store i8* %call18, i8** %4, align 8, !tbaa !32
  %tobool21.not = icmp eq i8* %call18, null
  %5 = bitcast i8* %call18 to %struct.quantum_reg_node_struct*
  br i1 %tobool21.not, label %if.then22, label %if.end24

if.then22:                                        ; preds = %for.end
  %call23 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([50 x i8], [50 x i8]* @.str.11.101, i64 0, i64 0), i32 %size.0.lcssa) #34
  tail call void @exit(i32 1) #32
  unreachable

if.end24:                                         ; preds = %for.end
  %mul = shl nsw i64 %conv17, 4
  %call26 = tail call i64 @quantum_memman(i64 %mul) #31
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %6 = load i32, i32* %hashw, align 8, !tbaa !49
  %hashw27 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 2
  store i32 %6, i32* %hashw27, align 8, !tbaa !49
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %7 = load i32*, i32** %hash, align 8, !tbaa !50
  %hash28 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %agg.result, i64 0, i32 4
  store i32* %7, i32** %hash28, align 8, !tbaa !50
  %cmp53150 = icmp sgt i32 %pos, 0
  %cmp68153 = icmp slt i32 %pos, 63
  br i1 %cmp161, label %for.body33.preheader, label %for.end102

for.body33.preheader:                             ; preds = %if.end24
  %wide.trip.count172 = zext i32 %0 to i64
  br label %for.body33

for.body33:                                       ; preds = %for.body33.preheader, %for.inc100
  %indvars.iv170 = phi i64 [ 0, %for.body33.preheader ], [ %indvars.iv.next171, %for.inc100 ]
  %j.0158 = phi i32 [ 0, %for.body33.preheader ], [ %j.1, %for.inc100 ]
  %state37 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv170, i32 1
  %8 = load i64, i64* %state37, align 8, !tbaa !33
  %and38 = and i64 %8, %shl
  %tobool39 = icmp ne i64 %and38, 0
  %or.cond104 = select i1 %tobool39, i1 %tobool2, i1 false
  br i1 %or.cond104, label %if.then51, label %lor.lhs.false42

lor.lhs.false42:                                  ; preds = %for.body33
  %or.cond105 = select i1 %tobool39, i1 true, i1 %tobool2
  br i1 %or.cond105, label %for.inc100, label %if.then51

if.then51:                                        ; preds = %lor.lhs.false42, %for.body33
  br i1 %cmp53150, label %for.body55, label %for.end61

for.body55:                                       ; preds = %if.then51, %for.body55
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body55 ], [ 0, %if.then51 ]
  %rpat.0152 = phi i64 [ %add58, %for.body55 ], [ 0, %if.then51 ]
  %shl57 = shl nuw i64 1, %indvars.iv
  %add58 = add i64 %shl57, %rpat.0152
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %sh_prom
  br i1 %exitcond.not, label %for.end61, label %for.body55, !llvm.loop !122

for.end61:                                        ; preds = %for.body55, %if.then51
  %rpat.0.lcssa = phi i64 [ 0, %if.then51 ], [ %add58, %for.body55 ]
  %and66 = and i64 %rpat.0.lcssa, %8
  br i1 %cmp68153, label %for.body70, label %for.end75

for.body70:                                       ; preds = %for.end61, %for.body70
  %lpat.0155 = phi i64 [ %add73, %for.body70 ], [ 0, %for.end61 ]
  %k.1154 = phi i32 [ %dec, %for.body70 ], [ 63, %for.end61 ]
  %sh_prom71 = zext i32 %k.1154 to i64
  %shl72 = shl nuw i64 1, %sh_prom71
  %add73 = add i64 %shl72, %lpat.0155
  %dec = add nsw i32 %k.1154, -1
  %cmp68 = icmp sgt i32 %dec, %pos
  br i1 %cmp68, label %for.body70, label %for.end75, !llvm.loop !123

for.end75:                                        ; preds = %for.body70, %for.end61
  %lpat.0.lcssa = phi i64 [ 0, %for.end61 ], [ %add73, %for.body70 ]
  %and80 = and i64 %lpat.0.lcssa, %8
  %shr = lshr i64 %and80, 1
  %or = or i64 %shr, %and66
  %idxprom82 = sext i32 %j.0158 to i64
  %state84 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %5, i64 %idxprom82, i32 1
  store i64 %or, i64* %state84, align 8, !tbaa !33
  %amplitude88.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv170, i32 0, i32 0
  %amplitude88.real = load float, float* %amplitude88.realp, align 8
  %amplitude88.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %1, i64 %indvars.iv170, i32 0, i32 1
  %amplitude88.imag = load float, float* %amplitude88.imagp, align 4
  %mul_bd = fmul float %amplitude88.imag, 0.000000e+00
  %mul_ad = fmul float %amplitude88.real, 0.000000e+00
  %mul_r = fsub float %amplitude88.real, %mul_bd
  %mul_i = fadd float %mul_ad, %amplitude88.imag
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %for.end75
  %isnan_cmp89 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp89, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call90 = tail call <2 x float> @__mulsc3(float %amplitude88.real, float %amplitude88.imag, float 1.000000e+00, float 0.000000e+00) #31
  %coerce91.sroa.0.0.vec.extract = extractelement <2 x float> %call90, i32 0
  %coerce91.sroa.0.4.vec.extract = extractelement <2 x float> %call90, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %for.end75
  %real_mul_phi = phi float [ %mul_r, %for.end75 ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce91.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %for.end75 ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce91.sroa.0.4.vec.extract, %complex_mul_libcall ]
  %call92 = tail call double @sqrt(double %d.0.lcssa) #31
  %conv93 = fptrunc double %call92 to float
  %9 = fdiv float %real_mul_phi, %conv93
  %10 = fdiv float %imag_mul_phi, %conv93
  %amplitude97.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %5, i64 %idxprom82, i32 0, i32 0
  %amplitude97.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %5, i64 %idxprom82, i32 0, i32 1
  store float %9, float* %amplitude97.realp, align 16
  store float %10, float* %amplitude97.imagp, align 4
  %inc98 = add nsw i32 %j.0158, 1
  br label %for.inc100

for.inc100:                                       ; preds = %lor.lhs.false42, %complex_mul_cont
  %j.1 = phi i32 [ %inc98, %complex_mul_cont ], [ %j.0158, %lor.lhs.false42 ]
  %indvars.iv.next171 = add nuw nsw i64 %indvars.iv170, 1
  %exitcond173.not = icmp eq i64 %indvars.iv.next171, %wide.trip.count172
  br i1 %exitcond173.not, label %for.end102, label %for.body33, !llvm.loop !124

for.end102:                                       ; preds = %for.inc100, %if.end24
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define <2 x float> @quantum_dot_product(%struct.quantum_reg_struct* nocapture readonly %reg1, %struct.quantum_reg_struct* nocapture readonly %reg2) local_unnamed_addr #15 {
entry:
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 2
  %0 = load i32, i32* %hashw, align 8, !tbaa !49
  %cmp75.not = icmp eq i32 %0, 31
  br i1 %cmp75.not, label %for.cond1.preheader, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 4
  %1 = load i32*, i32** %hash, align 8, !tbaa !50
  br label %for.body

for.cond1.preheader:                              ; preds = %for.body, %entry
  %size = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 1
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg2, i64 0, i32 3
  %2 = load i32, i32* %size, align 4, !tbaa !30
  %cmp272 = icmp sgt i32 %2, 0
  br i1 %cmp272, label %for.body3, label %for.cond9.preheader

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv79 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next80, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %indvars.iv79
  store i32 0, i32* %arrayidx, align 4, !tbaa !18
  %indvars.iv.next80 = add nuw nsw i64 %indvars.iv79, 1
  %3 = load i32, i32* %hashw, align 8, !tbaa !49
  %shl = shl nuw i32 1, %3
  %4 = sext i32 %shl to i64
  %cmp = icmp slt i64 %indvars.iv.next80, %4
  br i1 %cmp, label %for.body, label %for.cond1.preheader, !llvm.loop !125

for.cond9.preheader:                              ; preds = %for.body3, %for.cond1.preheader
  %size10 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg1, i64 0, i32 1
  %node13 = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg1, i64 0, i32 3
  %5 = load i32, i32* %size10, align 4, !tbaa !30
  %cmp1167 = icmp sgt i32 %5, 0
  br i1 %cmp1167, label %for.body12, label %for.end36

for.body3:                                        ; preds = %for.cond1.preheader, %for.body3
  %indvars.iv77 = phi i64 [ %indvars.iv.next78, %for.body3 ], [ 0, %for.cond1.preheader ]
  %6 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %6, i64 %indvars.iv77, i32 1
  %7 = load i64, i64* %state, align 8, !tbaa !33
  %8 = trunc i64 %indvars.iv77 to i32
  tail call fastcc void @quantum_add_hash.102(i64 %7, i32 %8, %struct.quantum_reg_struct* nonnull %reg2) #34
  %indvars.iv.next78 = add nuw nsw i64 %indvars.iv77, 1
  %9 = load i32, i32* %size, align 4, !tbaa !30
  %10 = sext i32 %9 to i64
  %cmp2 = icmp slt i64 %indvars.iv.next78, %10
  br i1 %cmp2, label %for.body3, label %for.cond9.preheader, !llvm.loop !126

for.body12:                                       ; preds = %for.cond9.preheader, %for.inc34
  %11 = phi i32 [ %15, %for.inc34 ], [ %5, %for.cond9.preheader ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc34 ], [ 0, %for.cond9.preheader ]
  %f.sroa.0.069 = phi float [ %f.sroa.0.1, %for.inc34 ], [ 0.000000e+00, %for.cond9.preheader ]
  %f.sroa.6.068 = phi float [ %f.sroa.6.1, %for.inc34 ], [ 0.000000e+00, %for.cond9.preheader ]
  %12 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node13, align 8, !tbaa !32
  %state16 = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %12, i64 %indvars.iv, i32 1
  %13 = load i64, i64* %state16, align 8, !tbaa !33
  %call = tail call fastcc i32 @quantum_get_state.103(i64 %13, %struct.quantum_reg_struct* byval(%struct.quantum_reg_struct) align 8 %reg2) #34
  %cmp17 = icmp sgt i32 %call, -1
  br i1 %cmp17, label %if.then, label %for.inc34

if.then:                                          ; preds = %for.body12
  %amplitude.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %12, i64 %indvars.iv, i32 0, i32 0
  %amplitude.real = load float, float* %amplitude.realp, align 8
  %amplitude.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %12, i64 %indvars.iv, i32 0, i32 1
  %amplitude.imag = load float, float* %amplitude.imagp, align 4
  %coerce.sroa.0.0.vec.insert = insertelement <2 x float> poison, float %amplitude.real, i32 0
  %coerce.sroa.0.4.vec.insert = insertelement <2 x float> %coerce.sroa.0.0.vec.insert, float %amplitude.imag, i32 1
  %call21 = tail call <2 x float> @quantum_conj(<2 x float> %coerce.sroa.0.4.vec.insert) #31
  %coerce22.sroa.0.0.vec.extract = extractelement <2 x float> %call21, i32 0
  %coerce22.sroa.0.4.vec.extract = extractelement <2 x float> %call21, i32 1
  %14 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8, !tbaa !32
  %idxprom2466 = zext i32 %call to i64
  %amplitude26.realp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %idxprom2466, i32 0, i32 0
  %amplitude26.real = load float, float* %amplitude26.realp, align 8
  %amplitude26.imagp = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %14, i64 %idxprom2466, i32 0, i32 1
  %amplitude26.imag = load float, float* %amplitude26.imagp, align 4
  %mul_ac = fmul float %coerce22.sroa.0.0.vec.extract, %amplitude26.real
  %mul_bd = fmul float %coerce22.sroa.0.4.vec.extract, %amplitude26.imag
  %mul_ad = fmul float %coerce22.sroa.0.0.vec.extract, %amplitude26.imag
  %mul_bc = fmul float %coerce22.sroa.0.4.vec.extract, %amplitude26.real
  %mul_r = fsub float %mul_ac, %mul_bd
  %mul_i = fadd float %mul_bc, %mul_ad
  %isnan_cmp = fcmp uno float %mul_r, 0.000000e+00
  br i1 %isnan_cmp, label %complex_mul_imag_nan, label %complex_mul_cont, !prof !42

complex_mul_imag_nan:                             ; preds = %if.then
  %isnan_cmp27 = fcmp uno float %mul_i, 0.000000e+00
  br i1 %isnan_cmp27, label %complex_mul_libcall, label %complex_mul_cont, !prof !42

complex_mul_libcall:                              ; preds = %complex_mul_imag_nan
  %call28 = tail call <2 x float> @__mulsc3(float %coerce22.sroa.0.0.vec.extract, float %coerce22.sroa.0.4.vec.extract, float %amplitude26.real, float %amplitude26.imag) #31
  %coerce29.sroa.0.0.vec.extract = extractelement <2 x float> %call28, i32 0
  %coerce29.sroa.0.4.vec.extract = extractelement <2 x float> %call28, i32 1
  br label %complex_mul_cont

complex_mul_cont:                                 ; preds = %complex_mul_libcall, %complex_mul_imag_nan, %if.then
  %real_mul_phi = phi float [ %mul_r, %if.then ], [ %mul_r, %complex_mul_imag_nan ], [ %coerce29.sroa.0.0.vec.extract, %complex_mul_libcall ]
  %imag_mul_phi = phi float [ %mul_i, %if.then ], [ %mul_i, %complex_mul_imag_nan ], [ %coerce29.sroa.0.4.vec.extract, %complex_mul_libcall ]
  %add.r = fadd float %f.sroa.0.069, %real_mul_phi
  %add.i = fadd float %f.sroa.6.068, %imag_mul_phi
  %.pre = load i32, i32* %size10, align 4, !tbaa !30
  br label %for.inc34

for.inc34:                                        ; preds = %for.body12, %complex_mul_cont
  %15 = phi i32 [ %.pre, %complex_mul_cont ], [ %11, %for.body12 ]
  %f.sroa.6.1 = phi float [ %add.i, %complex_mul_cont ], [ %f.sroa.6.068, %for.body12 ]
  %f.sroa.0.1 = phi float [ %add.r, %complex_mul_cont ], [ %f.sroa.0.069, %for.body12 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %16 = sext i32 %15 to i64
  %cmp11 = icmp slt i64 %indvars.iv.next, %16
  br i1 %cmp11, label %for.body12, label %for.end36, !llvm.loop !127

for.end36:                                        ; preds = %for.inc34, %for.cond9.preheader
  %f.sroa.6.0.lcssa = phi float [ 0.000000e+00, %for.cond9.preheader ], [ %f.sroa.6.1, %for.inc34 ]
  %f.sroa.0.0.lcssa = phi float [ 0.000000e+00, %for.cond9.preheader ], [ %f.sroa.0.1, %for.inc34 ]
  %retval.sroa.0.0.vec.insert = insertelement <2 x float> undef, float %f.sroa.0.0.lcssa, i32 0
  %retval.sroa.0.4.vec.insert = insertelement <2 x float> %retval.sroa.0.0.vec.insert, float %f.sroa.6.0.lcssa, i32 1
  ret <2 x float> %retval.sroa.0.4.vec.insert
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
define internal fastcc void @quantum_add_hash.102(i64 %a, i32 %pos, %struct.quantum_reg_struct* nocapture readonly %reg) unnamed_addr #16 {
entry:
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %0 = load i32, i32* %hashw, align 8, !tbaa !49
  %call = tail call fastcc i32 @quantum_hash64.104(i64 %a, i32 %0) #34
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %1 = load i32*, i32** %hash, align 8, !tbaa !50
  %shl = shl nuw i32 1, %0
  %idxprom12 = sext i32 %call to i64
  %arrayidx13 = getelementptr inbounds i32, i32* %1, i64 %idxprom12
  %2 = load i32, i32* %arrayidx13, align 4, !tbaa !18
  %tobool.not14 = icmp eq i32 %2, 0
  br i1 %tobool.not14, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %i.015 = phi i32 [ %spec.store.select, %while.body ], [ %call, %entry ]
  %inc = add nsw i32 %i.015, 1
  %cmp = icmp eq i32 %inc, %shl
  %spec.store.select = select i1 %cmp, i32 0, i32 %inc
  %idxprom = sext i32 %spec.store.select to i64
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %idxprom
  %3 = load i32, i32* %arrayidx, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %3, 0
  br i1 %tobool.not, label %while.end, label %while.body, !llvm.loop !128

while.end:                                        ; preds = %while.body, %entry
  %idxprom.lcssa = phi i64 [ %idxprom12, %entry ], [ %idxprom, %while.body ]
  %arrayidx.le = getelementptr inbounds i32, i32* %1, i64 %idxprom.lcssa
  %add = add nsw i32 %pos, 1
  store i32 %add, i32* %arrayidx.le, align 4, !tbaa !18
  ret void
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readonly uwtable
define internal fastcc i32 @quantum_get_state.103(i64 %a, %struct.quantum_reg_struct* nocapture readonly byval(%struct.quantum_reg_struct) align 8 %reg) unnamed_addr #2 {
entry:
  %hashw = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 2
  %0 = load i32, i32* %hashw, align 8, !tbaa !49
  %call = tail call fastcc i32 @quantum_hash64.104(i64 %a, i32 %0) #34
  %node = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 3
  %hash = getelementptr inbounds %struct.quantum_reg_struct, %struct.quantum_reg_struct* %reg, i64 0, i32 4
  %1 = load i32*, i32** %hash, align 8, !tbaa !50
  %2 = load %struct.quantum_reg_node_struct*, %struct.quantum_reg_node_struct** %node, align 8
  %shl = shl nuw i32 1, %0
  %idxprom20 = sext i32 %call to i64
  %arrayidx21 = getelementptr inbounds i32, i32* %1, i64 %idxprom20
  %3 = load i32, i32* %arrayidx21, align 4, !tbaa !18
  %tobool.not22 = icmp eq i32 %3, 0
  br i1 %tobool.not22, label %cleanup, label %while.body

while.body:                                       ; preds = %entry, %if.end
  %4 = phi i32 [ %6, %if.end ], [ %3, %entry ]
  %i.023 = phi i32 [ %spec.store.select, %if.end ], [ %call, %entry ]
  %sub = add nsw i32 %4, -1
  %idxprom4 = sext i32 %sub to i64
  %state = getelementptr inbounds %struct.quantum_reg_node_struct, %struct.quantum_reg_node_struct* %2, i64 %idxprom4, i32 1
  %5 = load i64, i64* %state, align 8, !tbaa !33
  %cmp = icmp eq i64 %5, %a
  br i1 %cmp, label %cleanup, label %if.end

if.end:                                           ; preds = %while.body
  %inc = add nsw i32 %i.023, 1
  %cmp11 = icmp eq i32 %inc, %shl
  %spec.store.select = select i1 %cmp11, i32 0, i32 %inc
  %idxprom = sext i32 %spec.store.select to i64
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %idxprom
  %6 = load i32, i32* %arrayidx, align 4, !tbaa !18
  %tobool.not = icmp eq i32 %6, 0
  br i1 %tobool.not, label %cleanup, label %while.body, !llvm.loop !129

cleanup:                                          ; preds = %while.body, %if.end, %entry
  %retval.0 = phi i32 [ -1, %entry ], [ -1, %if.end ], [ %sub, %while.body ]
  ret i32 %retval.0
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
define internal fastcc i32 @quantum_hash64.104(i64 %key, i32 %width) unnamed_addr #21 {
entry:
  %shr = lshr i64 %key, 32
  %conv1 = xor i64 %shr, %key
  %0 = trunc i64 %conv1 to i32
  %conv2 = mul i32 %0, -1640562687
  %sub = sub nsw i32 32, %width
  %shr3 = lshr i32 %conv2, %sub
  ret i32 %shr3
}

; Function Attrs: noinline nounwind optsize uwtable
define void @test_sum(i32 %compare, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %conv = sext i32 %compare to i64
  %sub = add i32 %width, -1
  %sh_prom = zext i32 %sub to i64
  %shl = shl nuw i64 1, %sh_prom
  %and = and i64 %shl, %conv
  %tobool.not = icmp eq i64 %and, 0
  %mul7 = shl nsw i32 %width, 1
  %sub8 = add nsw i32 %mul7, -1
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  tail call void @quantum_cnot(i32 %sub8, i32 %sub, %struct.quantum_reg_struct* %reg) #31
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %sub.sink = phi i32 [ 0, %if.then ], [ %sub, %entry ]
  tail call void @quantum_sigma_x(i32 %sub8, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %sub8, i32 %sub.sink, %struct.quantum_reg_struct* %reg) #31
  %cmp172 = icmp sgt i32 %width, 2
  br i1 %cmp172, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %if.end
  %sub12 = add nsw i32 %width, -2
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %i.0173 = phi i32 [ %dec, %for.inc ], [ %sub12, %for.body.preheader ]
  %shl14 = shl nuw i32 1, %i.0173
  %and15 = and i32 %shl14, %compare
  %tobool16.not = icmp eq i32 %and15, 0
  br i1 %tobool16.not, label %if.else22, label %if.then17

if.then17:                                        ; preds = %for.body
  %add = add nuw nsw i32 %i.0173, 1
  %add18 = add nsw i32 %i.0173, %width
  tail call void @quantum_toffoli(i32 %add, i32 %add18, i32 %i.0173, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %add18, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %add, i32 %add18, i32 0, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc

if.else22:                                        ; preds = %for.body
  %add23 = add nsw i32 %i.0173, %width
  tail call void @quantum_sigma_x(i32 %add23, %struct.quantum_reg_struct* %reg) #31
  %add24 = add nuw nsw i32 %i.0173, 1
  tail call void @quantum_toffoli(i32 %add24, i32 %add23, i32 %i.0173, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc

for.inc:                                          ; preds = %if.then17, %if.else22
  %dec = add nsw i32 %i.0173, -1
  %cmp = icmp sgt i32 %i.0173, 1
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !130

for.end:                                          ; preds = %for.inc, %if.end
  %and27 = and i32 %compare, 1
  %tobool28.not = icmp eq i32 %and27, 0
  br i1 %tobool28.not, label %if.end30.thread, label %if.then36

if.end30.thread:                                  ; preds = %for.end
  %mul31166 = shl nsw i32 %width, 1
  %add32167 = or i32 %mul31166, 1
  tail call void @quantum_toffoli(i32 %add32167, i32 0, i32 %mul31166, %struct.quantum_reg_struct* %reg) #31
  br label %if.end37

if.then36:                                        ; preds = %for.end
  tail call void @quantum_sigma_x(i32 %width, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %width, i32 1, i32 0, %struct.quantum_reg_struct* %reg) #31
  %mul31 = shl nsw i32 %width, 1
  %add32 = or i32 %mul31, 1
  tail call void @quantum_toffoli(i32 %add32, i32 0, i32 %mul31, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %width, i32 1, i32 0, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %width, %struct.quantum_reg_struct* %reg) #31
  br label %if.end37

if.end37:                                         ; preds = %if.end30.thread, %if.then36
  %mul31168 = phi i32 [ %mul31166, %if.end30.thread ], [ %mul31, %if.then36 ]
  %cmp40.not169 = icmp slt i32 %width, 3
  br i1 %cmp40.not169, label %for.end58, label %for.body42

for.body42:                                       ; preds = %if.end37, %for.inc57
  %i.1170 = phi i32 [ %add53, %for.inc57 ], [ 1, %if.end37 ]
  %shl43 = shl nuw i32 1, %i.1170
  %and44 = and i32 %shl43, %compare
  %tobool45.not = icmp eq i32 %and44, 0
  %add53 = add nuw i32 %i.1170, 1
  %add54 = add nsw i32 %i.1170, %width
  br i1 %tobool45.not, label %if.else52, label %if.then46

if.then46:                                        ; preds = %for.body42
  tail call void @quantum_toffoli(i32 %add53, i32 %add54, i32 0, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %add54, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %add53, i32 %add54, i32 %i.1170, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc57

if.else52:                                        ; preds = %for.body42
  tail call void @quantum_toffoli(i32 %add53, i32 %add54, i32 %i.1170, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %add54, %struct.quantum_reg_struct* %reg) #31
  br label %for.inc57

for.inc57:                                        ; preds = %if.then46, %if.else52
  %exitcond.not = icmp eq i32 %add53, %sub
  br i1 %exitcond.not, label %for.end58, label %for.body42, !llvm.loop !131

for.end58:                                        ; preds = %for.inc57, %if.end37
  %shl60 = shl nuw i32 1, %sub
  %and61 = and i32 %shl60, %compare
  %tobool62.not = icmp eq i32 %and61, 0
  %sub73 = add nsw i32 %mul31168, -1
  br i1 %tobool62.not, label %if.else71, label %if.then63

if.then63:                                        ; preds = %for.end58
  tail call void @quantum_cnot(i32 %sub73, i32 0, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %sub73, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %sub73, i32 %sub, %struct.quantum_reg_struct* %reg) #31
  br label %if.end77

if.else71:                                        ; preds = %for.end58
  tail call void @quantum_cnot(i32 %sub73, i32 %sub, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %sub73, %struct.quantum_reg_struct* %reg) #31
  br label %if.end77

if.end77:                                         ; preds = %if.else71, %if.then63
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @muxfa(i32 %a, i32 %b_in, i32 %c_in, i32 %c_out, i32 %xlt_l, i32 %L, i32 %total, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  switch i32 %a, label %if.end9 [
    i32 0, label %if.then
    i32 3, label %if.then2
    i32 1, label %if.then5
    i32 2, label %if.then8
  ]

if.then:                                          ; preds = %entry
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then2:                                         ; preds = %entry
  tail call void @quantum_toffoli(i32 %L, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %L, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then5:                                         ; preds = %entry
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then8:                                         ; preds = %entry
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.end9:                                          ; preds = %if.then5, %if.then2, %if.then, %entry, %if.then8
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @muxfa_inv(i32 %a, i32 %b_in, i32 %c_in, i32 %c_out, i32 %xlt_l, i32 %L, i32 %total, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  switch i32 %a, label %if.end9 [
    i32 0, label %if.then
    i32 3, label %if.then2
    i32 1, label %if.then5
    i32 2, label %if.then8
  ]

if.then:                                          ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then2:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %L, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then5:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then8:                                         ; preds = %entry
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %b_in, i32 %c_in, i32 %c_out, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %b_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.end9:                                          ; preds = %if.then5, %if.then2, %if.then, %entry, %if.then8
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @muxha(i32 %a, i32 %b_in, i32 %c_in, i32 %xlt_l, i32 %L, i32 %total, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  switch i32 %a, label %if.end9 [
    i32 0, label %if.then
    i32 3, label %if.then2
    i32 1, label %if.then5
    i32 2, label %if.then8
  ]

if.then:                                          ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then2:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %L, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then5:                                         ; preds = %entry
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then8:                                         ; preds = %entry
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.end9:                                          ; preds = %if.then5, %if.then2, %if.then, %entry, %if.then8
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @muxha_inv(i32 %a, i32 %b_in, i32 %c_in, i32 %xlt_l, i32 %L, i32 %total, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  switch i32 %a, label %if.end9 [
    i32 0, label %if.then
    i32 3, label %if.then2
    i32 1, label %if.then5
    i32 2, label %if.then8
  ]

if.then:                                          ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then2:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %L, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then5:                                         ; preds = %entry
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.then8:                                         ; preds = %entry
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_cnot(i32 %b_in, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_toffoli(i32 %L, i32 %xlt_l, i32 %c_in, %struct.quantum_reg_struct* %reg) #31
  tail call void @quantum_sigma_x(i32 %xlt_l, %struct.quantum_reg_struct* %reg) #31
  br label %if.end9

if.end9:                                          ; preds = %if.then5, %if.then2, %if.then, %entry, %if.then8
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @madd(i32 %a, i32 %a_inv, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %sub = add i32 %width, -1
  %mul9 = shl nsw i32 %width, 1
  %add11 = or i32 %mul9, 1
  %cmp57 = icmp sgt i32 %width, 1
  br i1 %cmp57, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.058 = phi i32 [ %add8, %for.body ], [ 0, %entry ]
  %shl = shl nuw i32 1, %i.058
  %and = and i32 %shl, %a
  %tobool.not = icmp eq i32 %and, 0
  %. = select i1 %tobool.not, i32 0, i32 2
  %0 = lshr i32 %a_inv, %i.058
  %1 = and i32 %0, 1
  %j.1 = or i32 %., %1
  %add7 = add nsw i32 %i.058, %width
  %add8 = add nuw nsw i32 %i.058, 1
  tail call void @muxfa(i32 %j.1, i32 %add7, i32 %i.058, i32 %add8, i32 %mul9, i32 %add11, i32 undef, %struct.quantum_reg_struct* %reg) #34
  %exitcond.not = icmp eq i32 %add8, %sub
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !132

for.end:                                          ; preds = %for.body, %entry
  %shl13 = shl nuw i32 1, %sub
  %and14 = and i32 %shl13, %a
  %tobool15.not = icmp eq i32 %and14, 0
  %spec.store.select = select i1 %tobool15.not, i32 0, i32 2
  %2 = lshr i32 %a_inv, %sub
  %3 = and i32 %2, 1
  %spec.select = or i32 %spec.store.select, %3
  %sub26 = add nsw i32 %mul9, -1
  tail call void @muxha(i32 %spec.select, i32 %sub26, i32 %sub, i32 %mul9, i32 %add11, i32 undef, %struct.quantum_reg_struct* %reg) #34
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @madd_inv(i32 %a, i32 %a_inv, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %sub = add nsw i32 %width, -1
  %shl = shl nuw i32 1, %sub
  %and = and i32 %shl, %a
  %tobool.not = icmp eq i32 %and, 0
  %spec.store.select = select i1 %tobool.not, i32 0, i32 2
  %0 = lshr i32 %a_inv, %sub
  %1 = and i32 %0, 1
  %spec.select = or i32 %spec.store.select, %1
  %mul9 = shl nsw i32 %width, 1
  %sub10 = add nsw i32 %mul9, -1
  %add13 = or i32 %mul9, 1
  tail call void @muxha_inv(i32 %spec.select, i32 %sub, i32 %sub10, i32 %mul9, i32 %add13, i32 undef, %struct.quantum_reg_struct* %reg) #34
  %cmp59 = icmp sgt i32 %width, 1
  br i1 %cmp59, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %sub14 = add nsw i32 %width, -2
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.060 = phi i32 [ %dec, %for.body ], [ %sub14, %for.body.preheader ]
  %shl15 = shl nuw i32 1, %i.060
  %and16 = and i32 %shl15, %a
  %tobool17.not = icmp eq i32 %and16, 0
  %. = select i1 %tobool17.not, i32 0, i32 2
  %2 = lshr i32 %a_inv, %i.060
  %3 = and i32 %2, 1
  %j.2 = or i32 %., %3
  %add26 = add i32 %i.060, %width
  %add28 = add i32 %add26, 1
  tail call void @muxfa_inv(i32 %j.2, i32 %i.060, i32 %add26, i32 %add28, i32 %mul9, i32 %add13, i32 undef, %struct.quantum_reg_struct* %reg) #34
  %dec = add nsw i32 %i.060, -1
  %cmp = icmp sgt i32 %i.060, 0
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !133

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @addn(i32 %N, i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %sub = sub nsw i32 %N, %a
  tail call void @test_sum(i32 %sub, i32 %width, %struct.quantum_reg_struct* %reg) #34
  %shl = shl nuw i32 1, %width
  %add = sub i32 %a, %N
  %sub1 = add i32 %add, %shl
  tail call void @madd(i32 %sub1, i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) #34
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @addn_inv(i32 %N, i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  %mul = shl nsw i32 %width, 1
  %add = or i32 %mul, 1
  tail call void @quantum_cnot(i32 %add, i32 %mul, %struct.quantum_reg_struct* %reg) #31
  %shl = shl nuw i32 1, %width
  %sub = sub nsw i32 %shl, %a
  %sub2 = sub nsw i32 %N, %a
  tail call void @madd_inv(i32 %sub, i32 %sub2, i32 %width, %struct.quantum_reg_struct* %reg) #34
  tail call void @quantum_swaptheleads(i32 %width, %struct.quantum_reg_struct* %reg) #31
  tail call void @test_sum(i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) #34
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @add_mod_n(i32 %N, i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) local_unnamed_addr #0 {
entry:
  tail call void @addn(i32 %N, i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) #34
  tail call void @addn_inv(i32 %N, i32 %a, i32 %width, %struct.quantum_reg_struct* %reg) #34
  ret void
}

attributes #0 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree noinline norecurse nosync nounwind optsize uwtable writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree noinline norecurse nosync nounwind optsize readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { inaccessiblememonly mustprogress nofree nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nounwind }
attributes #6 = { noreturn nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { argmemonly nofree nosync nounwind willreturn }
attributes #9 = { nofree nosync nounwind willreturn }
attributes #10 = { nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { nofree noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { argmemonly nofree nounwind willreturn writeonly }
attributes #14 = { argmemonly nofree nounwind willreturn }
attributes #15 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="64" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #16 = { nofree noinline norecurse nosync nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #17 = { mustprogress nofree noinline nosync nounwind optsize readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="64" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #18 = { mustprogress nofree nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #19 = { mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="64" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #20 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #21 = { mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #22 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #23 = { mustprogress nofree noinline nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="64" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #24 = { nofree noinline norecurse nosync nounwind optsize readnone uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #25 = { nofree noinline nosync nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #26 = { mustprogress nofree nounwind optsize readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #27 = { mustprogress noinline nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #28 = { nofree noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="64" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #29 = { nofree nounwind optsize readonly "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #30 = { nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #31 = { nounwind optsize }
attributes #32 = { noreturn nounwind optsize }
attributes #33 = { nounwind }
attributes #34 = { optsize }
attributes #35 = { cold }
attributes #36 = { cold optsize }
attributes #37 = { nounwind optsize readonly willreturn }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = distinct !{!6, !5}
!7 = distinct !{!7, !5}
!8 = distinct !{!8, !5}
!9 = !{!10, !10, i64 0}
!10 = !{!"omnipotent char", !11, i64 0}
!11 = !{!"Simple C/C++ TBAA"}
!12 = distinct !{!12, !5}
!13 = distinct !{!13, !5}
!14 = distinct !{!14, !5}
!15 = distinct !{!15, !5}
!16 = !{!17, !17, i64 0}
!17 = !{!"double", !10, i64 0}
!18 = !{!19, !19, i64 0}
!19 = !{!"int", !10, i64 0}
!20 = !{!21, !21, i64 0}
!21 = !{!"long", !10, i64 0}
!22 = !{!23, !23, i64 0}
!23 = !{!"any pointer", !10, i64 0}
!24 = distinct !{!24, !5}
!25 = !{i64 0, i64 4, !18, i64 4, i64 4, !18, i64 8, i64 4, !18, i64 16, i64 8, !22, i64 24, i64 8, !22}
!26 = distinct !{!26, !5}
!27 = distinct !{!27, !5}
!28 = distinct !{!28, !5}
!29 = distinct !{!29, !5}
!30 = !{!31, !19, i64 4}
!31 = !{!"quantum_reg_struct", !19, i64 0, !19, i64 4, !19, i64 8, !23, i64 16, !23, i64 24}
!32 = !{!31, !23, i64 16}
!33 = !{!34, !35, i64 8}
!34 = !{!"quantum_reg_node_struct", !10, i64 0, !35, i64 8}
!35 = !{!"long long", !10, i64 0}
!36 = distinct !{!36, !5}
!37 = distinct !{!37, !5}
!38 = distinct !{!38, !5}
!39 = distinct !{!39, !5}
!40 = distinct !{!40, !5}
!41 = distinct !{!41, !5}
!42 = !{!"branch_weights", i32 1, i32 1048575}
!43 = distinct !{!43, !5}
!44 = distinct !{!44, !5}
!45 = distinct !{!45, !5}
!46 = distinct !{!46, !5}
!47 = distinct !{!47, !5}
!48 = distinct !{!48, !5}
!49 = !{!31, !19, i64 8}
!50 = !{!31, !23, i64 24}
!51 = distinct !{!51, !5}
!52 = distinct !{!52, !5}
!53 = distinct !{!53, !5}
!54 = distinct !{!54, !5}
!55 = !{!31, !19, i64 0}
!56 = distinct !{!56, !5}
!57 = distinct !{!57, !5}
!58 = distinct !{!58, !5}
!59 = distinct !{!59, !5}
!60 = distinct !{!60, !5}
!61 = distinct !{!61, !5}
!62 = distinct !{!62, !5}
!63 = distinct !{!63, !5}
!64 = distinct !{!64, !5}
!65 = distinct !{!65, !5}
!66 = !{i64 0, i64 4, !18, i64 4, i64 4, !18, i64 8, i64 8, !22}
!67 = !{i64 0, i64 8, !22}
!68 = !{!69, !23, i64 8}
!69 = !{!"quantum_matrix_struct", !19, i64 0, !19, i64 4, !23, i64 8}
!70 = distinct !{!70, !5}
!71 = distinct !{!71, !5}
!72 = distinct !{!72, !5}
!73 = distinct !{!73, !5}
!74 = distinct !{!74, !5}
!75 = distinct !{!75, !5}
!76 = distinct !{!76, !5}
!77 = distinct !{!77, !5}
!78 = distinct !{!78, !5}
!79 = distinct !{!79, !5}
!80 = distinct !{!80, !5}
!81 = distinct !{!81, !5}
!82 = distinct !{!82, !5}
!83 = distinct !{!83, !5}
!84 = !{i64 0, i64 4, !18, i64 4, i64 4, !18, i64 12, i64 8, !22, i64 20, i64 8, !22}
!85 = !{i64 0, i64 4, !18, i64 8, i64 8, !22, i64 16, i64 8, !22}
!86 = !{i64 0, i64 8, !22, i64 8, i64 8, !22}
!87 = !{!88, !88, i64 0}
!88 = !{!"float", !10, i64 0}
!89 = distinct !{!89, !5}
!90 = distinct !{!90, !5}
!91 = distinct !{!91, !5}
!92 = distinct !{!92, !5}
!93 = distinct !{!93, !5}
!94 = distinct !{!94, !5}
!95 = distinct !{!95, !5}
!96 = distinct !{!96, !5}
!97 = distinct !{!97, !5}
!98 = distinct !{!98, !5}
!99 = distinct !{!99, !5}
!100 = distinct !{!100, !5}
!101 = distinct !{!101, !5}
!102 = distinct !{!102, !5}
!103 = distinct !{!103, !5}
!104 = distinct !{!104, !5}
!105 = distinct !{!105, !5}
!106 = !{!69, !19, i64 4}
!107 = !{!69, !19, i64 0}
!108 = distinct !{!108, !5}
!109 = distinct !{!109, !5}
!110 = distinct !{!110, !5}
!111 = distinct !{!111, !5}
!112 = distinct !{!112, !5}
!113 = distinct !{!113, !5}
!114 = distinct !{!114, !5}
!115 = distinct !{!115, !5}
!116 = distinct !{!116, !5}
!117 = distinct !{!117, !5}
!118 = distinct !{!118, !5}
!119 = distinct !{!119, !5}
!120 = distinct !{!120, !5}
!121 = distinct !{!121, !5}
!122 = distinct !{!122, !5}
!123 = distinct !{!123, !5}
!124 = distinct !{!124, !5}
!125 = distinct !{!125, !5}
!126 = distinct !{!126, !5}
!127 = distinct !{!127, !5}
!128 = distinct !{!128, !5}
!129 = distinct !{!129, !5}
!130 = distinct !{!130, !5}
!131 = distinct !{!131, !5}
!132 = distinct !{!132, !5}
!133 = distinct !{!133, !5}
