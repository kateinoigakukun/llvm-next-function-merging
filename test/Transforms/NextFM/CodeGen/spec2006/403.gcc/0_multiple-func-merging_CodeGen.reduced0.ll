; RUN: %opt -S --passes="multiple-func-merging" -multiple-func-merging-disable-post-opt -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK-NOT: - Reason:          Invalid merged function
; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/CodeGen/spec2006/403.gcc/0_multiple-func-merging_CodeGen.reduced0.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.rtx_def = type { i32, [1 x %union.anon] }
%union.anon = type { i64 }
%struct.tree_common = type { %union.tree_node*, %union.tree_node*, i32 }
%union.tree_node = type { %struct.tree_decl }
%struct.tree_decl = type { %struct.tree_common, i8*, i32, i32, %union.tree_node*, i48, %union.anon, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, %union.anon.1, %union.tree_node*, %union.tree_node*, %union.tree_node*, i64, %struct.lang_decl* }
%union.anon.1 = type { %struct.function* }
%struct.function = type { %struct.eh_status*, %struct.stmt_status*, %struct.expr_status*, %struct.emit_status*, %struct.varasm_status*, i8*, %union.tree_node*, %struct.function*, i32, i32, i32, i32, %struct.rtx_def*, %struct.ix86_args, %struct.rtx_def*, %struct.rtx_def*, i8*, %struct.initial_value_struct*, i32, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, i64, %union.tree_node*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, i32, %struct.rtx_def**, %struct.temp_slot*, i32, i32, i32, %struct.var_refs_queue*, i32, i32, i8*, %union.tree_node*, %struct.rtx_def*, i32, i32, %struct.machine_function*, i32, i32, %struct.language_function*, %struct.rtx_def*, i24 }
%struct.eh_status = type { %struct.eh_region*, %struct.eh_region**, %struct.eh_region*, %struct.eh_region*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, i32, i32, %struct.varray_head_tag*, %struct.varray_head_tag*, %struct.varray_head_tag*, %struct.const_equiv_data*, i32, i32, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def* }
%struct.eh_region = type { %struct.eh_region*, %struct.eh_region*, %struct.eh_region*, i32, %struct.bitmap_head_def*, i32, %union.anon.195, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def* }
%struct.bitmap_head_def = type { %struct.bitmap_element_def*, %struct.bitmap_element_def*, i32 }
%struct.bitmap_element_def = type { %struct.bitmap_element_def*, %struct.bitmap_element_def*, i32, [2 x i64] }
%union.anon.195 = type { %struct.anon.194 }
%struct.anon.194 = type { %struct.eh_region*, %struct.eh_region*, %struct.eh_region*, %struct.rtx_def* }
%struct.varray_head_tag = type { i32, i32, i32, i8*, %union.varray_data_tag }
%union.varray_data_tag = type { [1 x i64] }
%struct.const_equiv_data = type { %struct.rtx_def*, i32 }
%struct.stmt_status = type { %struct.nesting*, %struct.nesting*, %struct.nesting*, %struct.nesting*, %struct.nesting*, %struct.nesting*, i32, i32, %union.tree_node*, %struct.rtx_def*, i32, i8*, i32, %struct.goto_fixup* }
%struct.nesting = type { %struct.nesting*, %struct.nesting*, i32, %struct.rtx_def*, %union.anon.3.2067 }
%union.anon.3.2067 = type { %struct.anon.6 }
%struct.anon.6 = type { i32, %struct.rtx_def*, %struct.rtx_def*, %struct.nesting*, %union.tree_node*, %union.tree_node*, %struct.label_chain*, i32, i32, i32, i32, %struct.rtx_def*, %union.tree_node** }
%struct.label_chain = type { %struct.label_chain*, %union.tree_node* }
%struct.goto_fixup = type { %struct.goto_fixup*, %struct.rtx_def*, %union.tree_node*, %union.tree_node*, %struct.rtx_def*, i32, %struct.rtx_def*, %union.tree_node* }
%struct.expr_status = type { i32, i32, i32, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def* }
%struct.emit_status = type { i32, i32, %struct.rtx_def*, %struct.rtx_def*, %union.tree_node*, %struct.sequence_stack*, i32, i32, i8*, i32, i8*, %union.tree_node**, %struct.rtx_def** }
%struct.sequence_stack = type { %struct.rtx_def*, %struct.rtx_def*, %union.tree_node*, %struct.sequence_stack* }
%struct.varasm_status = type { %struct.constant_descriptor**, %struct.pool_constant**, %struct.pool_constant*, %struct.pool_constant*, i64, %struct.rtx_def* }
%struct.constant_descriptor = type { %struct.constant_descriptor*, i8*, %struct.rtx_def*, %union.anon.4 }
%union.anon.4 = type { x86_fp80 }
%struct.pool_constant = type { %struct.constant_descriptor*, %struct.pool_constant*, %struct.pool_constant*, %struct.rtx_def*, i32, i32, i32, i64, i32 }
%struct.ix86_args = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.initial_value_struct = type { i32, i32, %struct.initial_value_pair* }
%struct.initial_value_pair = type { %struct.rtx_def*, %struct.rtx_def* }
%struct.temp_slot = type { %struct.temp_slot*, %struct.rtx_def*, %struct.rtx_def*, i32, i64, %union.tree_node*, %union.tree_node*, i8, i8, i32, i32, i64, i64 }
%struct.var_refs_queue = type { %struct.rtx_def*, i32, i32, %struct.var_refs_queue* }
%struct.machine_function = type { [59 x [3 x %struct.rtx_def*]], i32, i32 }
%struct.language_function = type { %struct.stmt_tree_s, %union.tree_node* }
%struct.stmt_tree_s = type { %union.tree_node*, %union.tree_node*, i8*, i32 }
%struct.lang_decl = type { %struct.c_lang_decl, %union.tree_node* }
%struct.c_lang_decl = type { i8, [3 x i8] }
%struct.tree_list = type { %struct.tree_common, %union.tree_node*, %union.tree_node* }

define i32 @reload() local_unnamed_addr {
for.body57:
  %0 = load i8, i8* undef, align 1, !tbaa !0
  br label %if.end102

if.end102:                                        ; preds = %for.body57
  %bf.clear104 = and i32 undef, 65535
  %cmp105 = icmp eq i32 %bf.clear104, 34
  br label %if.end123

if.end123:                                        ; preds = %if.end102
  %cmp124.not = icmp eq %struct.rtx_def* null, null
  br i1 %cmp124.not, label %if.end365, label %land.lhs.true126

land.lhs.true126:                                 ; preds = %if.end123
  switch i16 undef, label %if.end365 [
    i16 61, label %if.then134
  ]

if.then134:                                       ; preds = %land.lhs.true126
  br i1 undef, label %if.end365, label %land.lhs.true137

land.lhs.true137:                                 ; preds = %if.then134
  br i1 undef, label %lor.lhs.false144, label %if.then244

lor.lhs.false144:                                 ; preds = %land.lhs.true137
  %1 = bitcast i32* undef to %struct.rtx_def*
  switch i16 undef, label %if.end365 [
    i16 68, label %lor.lhs.false238
    i16 67, label %lor.lhs.false238
    i16 58, label %land.lhs.true232
    i16 54, label %if.then244
    i16 55, label %if.then244
    i16 56, label %if.then244
    i16 134, label %if.then244
    i16 140, label %if.then244
  ]

land.lhs.true232:                                 ; preds = %lor.lhs.false144
  br i1 undef, label %if.then244, label %land.lhs.true232.lor.lhs.false238_crit_edge

land.lhs.true232.lor.lhs.false238_crit_edge:      ; preds = %land.lhs.true232
  %.pre1657 = load %struct.rtx_def*, %struct.rtx_def** undef, align 4, !tbaa !0
  br label %lor.lhs.false238

lor.lhs.false238:                                 ; preds = %land.lhs.true232.lor.lhs.false238_crit_edge, %lor.lhs.false144, %lor.lhs.false144
  %2 = phi %struct.rtx_def* [ %.pre1657, %land.lhs.true232.lor.lhs.false238_crit_edge ], [ %1, %lor.lhs.false144 ], [ %1, %lor.lhs.false144 ]
  br i1 undef, label %if.end365, label %if.then244

if.then244:                                       ; preds = %lor.lhs.false238, %land.lhs.true232, %lor.lhs.false144, %lor.lhs.false144, %lor.lhs.false144, %lor.lhs.false144, %lor.lhs.false144, %land.lhs.true137
  %arrayidx252 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* undef, i32 0, i32 1, i32 0
  %rtuint = bitcast %union.anon* %arrayidx252 to i32*
  br label %if.end365

if.end365:                                        ; preds = %if.then244, %lor.lhs.false238, %lor.lhs.false144, %if.then134, %land.lhs.true126, %if.end123
  ret i32 undef
}

define i32 @yyparse_1() local_unnamed_addr {
yydefault:
  %0 = load i16, i16* undef, align 2, !tbaa !3
  %conv119 = sext i16 %0 to i32
  %cmp120 = icmp eq i16 %0, 0
  br label %yyreduce

yyreduce:                                         ; preds = %yydefault
  %1 = load i16, i16* undef, align 2, !tbaa !3
  br label %if.end131

if.end131:                                        ; preds = %yyreduce
  br label %if.end150

if.end150:                                        ; preds = %if.end131
  switch i32 %conv119, label %sw.epilog [
    i32 25, label %do.body396
    i32 21, label %do.body348
    i32 9, label %while.cond162.preheader
  ]

while.cond162.preheader:                          ; preds = %if.end150
  %2 = load %struct.tree_common*, %struct.tree_common** undef, align 4, !tbaa !0
  %code5821 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %2, i32 0, i32 2
  %bf.load5822 = load i32, i32* %code5821, align 4
  %switch5825 = icmp ult i32 undef, 3
  br label %while.end218

while.end218:                                     ; preds = %while.cond162.preheader
  %code222 = getelementptr inbounds %union.tree_node, %union.tree_node* undef, i32 0, i32 0, i32 0, i32 2
  %bf.load223 = load i32, i32* %code222, align 4
  %bf.clear224 = and i32 %bf.load223, 255
  %cmp225 = icmp eq i32 %bf.clear224, 121
  br label %land.lhs.true227

land.lhs.true227:                                 ; preds = %while.end218
  %operands231 = getelementptr inbounds %union.tree_node, %union.tree_node* undef, i32 0, i32 0, i32 2
  %3 = load %struct.tree_common*, %struct.tree_common** undef, align 4, !tbaa !0
  %code234 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %3, i32 0, i32 2
  %bf.load235 = load i32, i32* %code234, align 4
  ret i32 undef

do.body348:                                       ; preds = %if.end150
  %4 = load %struct.tree_list*, %struct.tree_list** undef, align 4, !tbaa !5
  %value350 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %4, i32 0, i32 2
  %5 = load %union.tree_node*, %union.tree_node** %value350, align 4, !tbaa !0
  %purpose352 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %4, i32 0, i32 1
  %6 = bitcast %union.tree_node** %purpose352 to %struct.tree_list**
  %7 = load %struct.tree_list*, %struct.tree_list** %6, align 4, !tbaa !0
  %purpose354 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %7, i32 0, i32 1
  %8 = load %union.tree_node*, %union.tree_node** %purpose354, align 4, !tbaa !0
  %value358 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %7, i32 0, i32 2
  %9 = load %union.tree_node*, %union.tree_node** %value358, align 4, !tbaa !0
  %chain360 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %4, i32 0, i32 0, i32 0
  %10 = load %union.tree_node*, %union.tree_node** %chain360, align 4, !tbaa !0
  br label %sw.epilog

do.body396:                                       ; preds = %if.end150
  %11 = load %struct.tree_list*, %struct.tree_list** undef, align 4, !tbaa !5
  %value398 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %11, i32 0, i32 2
  %12 = load %union.tree_node*, %union.tree_node** %value398, align 4, !tbaa !0
  %purpose400 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %11, i32 0, i32 1
  br label %sw.epilog

sw.epilog:                                        ; preds = %do.body396, %do.body348, %if.end150
  ret i32 undef
}

!0 = !{!1, !1, i64 0}
!1 = !{!"omnipotent char", !2, i64 0}
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!4, !4, i64 0}
!4 = !{!"short", !1, i64 0}
!5 = !{!6, !6, i64 0}
!6 = !{!"any pointer", !1, i64 0}
