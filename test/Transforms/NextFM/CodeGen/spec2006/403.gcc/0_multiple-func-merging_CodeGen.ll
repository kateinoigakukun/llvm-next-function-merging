; Generated from multiple-func-merging:CodeGen
; - reload
; - yyparse_1

; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -o /dev/null -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging < %s | FileCheck %s
; CHECK-NOT: - Reason:          Invalid merged function

; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/.x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/403.gcc/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.obstack = type { i32, %struct._obstack_chunk*, i8*, i8*, i8*, i32, i32, %struct._obstack_chunk* (i8*, i32)*, void (i8*, %struct._obstack_chunk*)*, i8*, i8 }
%struct._obstack_chunk = type { i8*, %struct._obstack_chunk*, [4 x i8] }
%struct.bitmap_head_def = type { %struct.bitmap_element_def*, %struct.bitmap_element_def*, i32 }
%struct.bitmap_element_def = type { %struct.bitmap_element_def*, %struct.bitmap_element_def*, i32, [2 x i64] }
%struct.insn_chain = type { %struct.insn_chain*, %struct.insn_chain*, %struct.insn_chain*, i32, %struct.rtx_def*, %struct.bitmap_head_def, %struct.bitmap_head_def, %struct.reload*, i32, i64, %struct.needs, i8 }
%struct.rtx_def = type { i32, [1 x %union.anon] }
%union.anon = type { i64 }
%struct.reload = type { %struct.rtx_def*, %struct.rtx_def*, i32, i32, i32, i32, i32, i32, %struct.rtx_def*, %struct.rtx_def*, i32, %struct.rtx_def*, i32, i32, i32, i32, i32, i32, i8 }
%struct.needs = type { [2 x [25 x i16]], [25 x i16] }
%struct.elim_table = type { i32, i32, i32, i32, i32, i32, i32, i32, %struct.rtx_def*, %struct.rtx_def* }
%union.tree_node = type { %struct.tree_decl }
%struct.tree_decl = type { %struct.tree_common, i8*, i32, i32, %union.tree_node*, i48, %union.anon, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, %union.anon.1, %union.tree_node*, %union.tree_node*, %union.tree_node*, i64, %struct.lang_decl* }
%struct.tree_common = type { %union.tree_node*, %union.tree_node*, i32 }
%union.anon.1 = type { %struct.function* }
%struct.function = type { %struct.eh_status*, %struct.stmt_status*, %struct.expr_status*, %struct.emit_status*, %struct.varasm_status*, i8*, %union.tree_node*, %struct.function*, i32, i32, i32, i32, %struct.rtx_def*, %struct.ix86_args, %struct.rtx_def*, %struct.rtx_def*, i8*, %struct.initial_value_struct*, i32, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, i64, %union.tree_node*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, i32, %struct.rtx_def**, %struct.temp_slot*, i32, i32, i32, %struct.var_refs_queue*, i32, i32, i8*, %union.tree_node*, %struct.rtx_def*, i32, i32, %struct.machine_function*, i32, i32, %struct.language_function*, %struct.rtx_def*, i24 }
%struct.eh_status = type { %struct.eh_region*, %struct.eh_region**, %struct.eh_region*, %struct.eh_region*, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, i32, i32, %struct.varray_head_tag*, %struct.varray_head_tag*, %struct.varray_head_tag*, %struct.const_equiv_data*, i32, i32, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def* }
%struct.eh_region = type { %struct.eh_region*, %struct.eh_region*, %struct.eh_region*, i32, %struct.bitmap_head_def*, i32, %union.anon.195, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def*, %struct.rtx_def* }
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
%union.anon.2 = type { i32 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i32, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i32, i32, [40 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.basic_block_def = type { %struct.rtx_def*, %struct.rtx_def*, %union.tree_node*, %union.tree_node*, %struct.edge_def*, %struct.edge_def*, %struct.bitmap_head_def*, %struct.bitmap_head_def*, %struct.bitmap_head_def*, %struct.bitmap_head_def*, i8*, i32, i32, i64, i32, i32 }
%struct.edge_def = type { %struct.edge_def*, %struct.edge_def*, %struct.basic_block_def*, %struct.basic_block_def*, %struct.rtx_def*, i8*, i32, i32, i64 }
%struct.mem_attrs = type { i64, %union.tree_node*, %struct.rtx_def*, %struct.rtx_def*, i32 }
%struct.tree_type = type { %struct.tree_common, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, i32, i32, i32, %union.tree_node*, %union.tree_node*, %union.anon.2, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, i64, %struct.lang_type* }
%struct.lang_type = type { i32, [1 x %union.tree_node*] }
%struct.tree_list = type { %struct.tree_common, %union.tree_node*, %union.tree_node* }
%struct.cpp_hashnode = type { %struct.ht_identifier, i16, i8, i8, i8, i8, %union.anon.3 }
%struct.ht_identifier = type { i32, i8* }
%union.anon.3 = type { %struct.cpp_macro* }
%struct.cpp_macro = type { %struct.cpp_hashnode**, %struct.cpp_token*, i32, i32, i16, i8 }
%struct.cpp_token = type { i32, i16, i8, i8, %union.anon.0 }
%union.anon.0 = type { %struct.ht_identifier }
%struct.tree_exp = type { %struct.tree_common, i32, [1 x %union.tree_node*] }
%struct.tree_identifier = type { %struct.tree_common, %struct.ht_identifier }
%struct.c_common_identifier = type { %struct.tree_common, %struct.cpp_hashnode }

@reload_obstack = external global %struct.obstack, align 4
@reload_startobj = external local_unnamed_addr global i8*, align 4
@spilled_pseudos = external hidden global %struct.bitmap_head_def, align 4
@unused_insn_chains = external hidden unnamed_addr global %struct.insn_chain*, align 4
@.str.1.2375 = external hidden unnamed_addr constant [14 x i8], align 1
@failure = external hidden unnamed_addr global i1, align 4
@reload_firstobj = external local_unnamed_addr global i8*, align 4
@spill_stack_slot = external hidden unnamed_addr global [53 x %struct.rtx_def*], align 4
@spill_stack_slot_width = external hidden unnamed_addr global [53 x i32], align 4
@reg_equiv_init = external hidden unnamed_addr global %struct.rtx_def**, align 4
@reg_max_ref_width = external hidden unnamed_addr global i32*, align 4
@reg_old_renumber = external hidden unnamed_addr global i16*, align 4
@pseudo_forbidden_regs = external hidden unnamed_addr global i64*, align 4
@pseudo_previous_regs = external hidden unnamed_addr global i64*, align 4
@bad_spill_regs_global = external hidden unnamed_addr global i64, align 8
@num_eliminable_invariants = external hidden unnamed_addr global i32, align 4
@num_labels = external hidden unnamed_addr global i32, align 4
@offsets_known_at = external hidden unnamed_addr global i8*, align 4
@offsets_at = external hidden unnamed_addr global [4 x i32]*, align 4
@num_eliminable = external hidden unnamed_addr global i32, align 4
@insns_need_reload = external hidden unnamed_addr global %struct.insn_chain*, align 4
@something_needs_elimination = external hidden unnamed_addr global i1, align 4
@last_spill_reg = external hidden unnamed_addr global i32, align 4
@used_spill_regs = external hidden unnamed_addr global i64, align 8
@reg_eliminate = external hidden unnamed_addr global %struct.elim_table*, align 4
@something_needs_operands_changed = external local_unnamed_addr global i32, align 4
@__FUNCTION__.reload = external hidden unnamed_addr constant [7 x i8], align 1
@reload.verbose_warned = external hidden unnamed_addr global i1, align 4
@.str.2.2378 = external hidden unnamed_addr constant [49 x i8], align 1
@.str.3.2379 = external hidden unnamed_addr constant [43 x i8], align 1
@n_spills = external hidden unnamed_addr global i32, align 4
@spill_regs = external hidden unnamed_addr global [53 x i16], align 2
@declspec_stack = external hidden global %union.tree_node*, align 4
@current_declspecs = external hidden global %union.tree_node*, align 4
@prefix_attributes = external hidden global %union.tree_node*, align 4
@all_prefix_attributes = external hidden global %union.tree_node*, align 4
@yydebug = external local_unnamed_addr global i32, align 4
@.str.2678 = external hidden unnamed_addr constant [16 x i8], align 1
@yynerrs = external local_unnamed_addr global i32, align 4
@yychar = external local_unnamed_addr global i32, align 4
@.str.1.2679 = external hidden unnamed_addr constant [22 x i8], align 1
@.str.2.2680 = external hidden unnamed_addr constant [28 x i8], align 1
@.str.3.2681 = external hidden unnamed_addr constant [19 x i8], align 1
@yypact = external hidden unnamed_addr constant [901 x i16], align 2
@.str.4.2682 = external hidden unnamed_addr constant [18 x i8], align 1
@.str.5.2683 = external hidden unnamed_addr constant [22 x i8], align 1
@yytranslate = external hidden unnamed_addr constant [323 x i8], align 1
@.str.6.2684 = external hidden unnamed_addr constant [21 x i8], align 1
@yytname = external hidden unnamed_addr constant [290 x i8*], align 4
@yylval = external global %union.anon.2, align 4
@.str.7.2685 = external hidden unnamed_addr constant [3 x i8], align 1
@yycheck = external hidden unnamed_addr constant [3206 x i16], align 2
@yytable = external hidden unnamed_addr constant [3206 x i16], align 2
@.str.8.2686 = external hidden unnamed_addr constant [25 x i8], align 1
@yydefact = external hidden unnamed_addr constant [901 x i16], align 2
@yyr2 = external hidden unnamed_addr constant [560 x i16], align 2
@.str.9.2687 = external hidden unnamed_addr constant [33 x i8], align 1
@yyrline = external hidden unnamed_addr constant [560 x i16], align 2
@yyprhs = external hidden unnamed_addr constant [560 x i16], align 2
@yyrhs = external hidden unnamed_addr constant [1730 x i16], align 2
@.str.10.2688 = external hidden unnamed_addr constant [4 x i8], align 1
@.str.11.2689 = external hidden unnamed_addr constant [8 x i8], align 1
@yyr1 = external hidden unnamed_addr constant [560 x i16], align 2
@.str.12.2690 = external hidden unnamed_addr constant [35 x i8], align 1
@.str.13.2691 = external hidden unnamed_addr constant [43 x i8], align 1
@.str.14.2692 = external hidden unnamed_addr constant [60 x i8], align 1
@.str.15.2693 = external hidden unnamed_addr constant [45 x i8], align 1
@.str.16.2694 = external hidden unnamed_addr constant [53 x i8], align 1
@.str.17.2695 = external hidden unnamed_addr constant [13 x i8], align 1
@.str.18.2696 = external hidden unnamed_addr constant [46 x i8], align 1
@.str.19.2697 = external hidden unnamed_addr constant [8 x i8], align 1
@.str.20.2698 = external hidden unnamed_addr constant [32 x i8], align 1
@.str.21.2699 = external hidden unnamed_addr constant [58 x i8], align 1
@.str.22.2700 = external hidden unnamed_addr constant [34 x i8], align 1
@.str.23.2701 = external hidden unnamed_addr constant [47 x i8], align 1
@.str.24.2702 = external hidden unnamed_addr constant [55 x i8], align 1
@.str.25.2703 = external hidden unnamed_addr constant [3 x i8], align 1
@yyparse_1.last_lineno = external hidden unnamed_addr global i32, align 4
@yyparse_1.last_input_filename = external hidden unnamed_addr global i8*, align 4
@.str.26.2704 = external hidden unnamed_addr constant [43 x i8], align 1
@.str.27.2705 = external hidden unnamed_addr constant [41 x i8], align 1
@.str.28.2706 = external hidden unnamed_addr constant [18 x i8], align 1
@.str.29.2707 = external hidden unnamed_addr constant [40 x i8], align 1
@.str.30.2708 = external hidden unnamed_addr constant [39 x i8], align 1
@.str.31.2709 = external hidden unnamed_addr constant [51 x i8], align 1
@.str.32.2710 = external hidden unnamed_addr constant [51 x i8], align 1
@.str.33.2711 = external hidden unnamed_addr constant [48 x i8], align 1
@.str.34.2712 = external hidden unnamed_addr constant [57 x i8], align 1
@.str.35.2713 = external hidden unnamed_addr constant [31 x i8], align 1
@.str.36.2714 = external hidden unnamed_addr constant [49 x i8], align 1
@.str.37.2715 = external hidden unnamed_addr constant [32 x i8], align 1
@.str.38.2716 = external hidden unnamed_addr constant [39 x i8], align 1
@.str.39.2717 = external hidden unnamed_addr constant [45 x i8], align 1
@.str.40.2718 = external hidden unnamed_addr constant [45 x i8], align 1
@.str.41.2719 = external hidden unnamed_addr constant [50 x i8], align 1
@.str.42.2720 = external hidden unnamed_addr constant [44 x i8], align 1
@.str.43.2721 = external hidden unnamed_addr constant [53 x i8], align 1
@.str.44.2722 = external hidden unnamed_addr constant [44 x i8], align 1
@.str.45.2723 = external hidden unnamed_addr constant [33 x i8], align 1
@compstmt_count = external hidden unnamed_addr global i32, align 4
@.str.46.2724 = external hidden unnamed_addr constant [62 x i8], align 1
@stmt_count = external hidden unnamed_addr global i32, align 4
@if_stmt_file = external hidden unnamed_addr global i8*, align 4
@if_stmt_line = external hidden unnamed_addr global i32, align 4
@.str.47.2725 = external hidden unnamed_addr constant [32 x i8], align 1
@.str.48.2726 = external hidden unnamed_addr constant [30 x i8], align 1
@.str.49.2727 = external hidden unnamed_addr constant [28 x i8], align 1
@.str.50.2728 = external hidden unnamed_addr constant [45 x i8], align 1
@.str.51.2729 = external hidden unnamed_addr constant [45 x i8], align 1
@.str.52.2730 = external hidden unnamed_addr constant [35 x i8], align 1
@.str.53.2731 = external hidden unnamed_addr constant [16 x i8], align 1
@.str.54.2732 = external hidden unnamed_addr constant [4 x i8], align 1
@yypgoto = external hidden unnamed_addr constant [198 x i16], align 2
@yydefgoto = external hidden unnamed_addr constant [198 x i16], align 2
@.str.56.2733 = external hidden unnamed_addr constant [12 x i8], align 1
@.str.57.2734 = external hidden unnamed_addr constant [27 x i8], align 1
@.str.58.2735 = external hidden unnamed_addr constant [23 x i8], align 1
@.str.59.2736 = external hidden unnamed_addr constant [23 x i8], align 1
@caller_save_needed = external local_unnamed_addr global i32, align 4
@skip_evaluation = external local_unnamed_addr global i32, align 4
@warn_pointer_arith = external local_unnamed_addr global i32, align 4
@flag_isoc99 = external local_unnamed_addr global i32, align 4
@warn_traditional = external local_unnamed_addr global i32, align 4
@flag_traditional = external local_unnamed_addr global i32, align 4
@c_global_trees = external global [32 x %union.tree_node*], align 4
@pedantic = external local_unnamed_addr global i32, align 4
@in_system_header = external local_unnamed_addr global i32, align 4
@input_filename = external local_unnamed_addr global i8*, align 4
@flag_stack_check = external global i32, align 4
@reg_equiv_constant = external local_unnamed_addr global %struct.rtx_def**, align 4
@reg_equiv_memory_loc = external local_unnamed_addr global %struct.rtx_def**, align 4
@reload_first_uid = external local_unnamed_addr global i32, align 4
@max_regno = external local_unnamed_addr global i32, align 4
@reg_equiv_mem = external local_unnamed_addr global %struct.rtx_def**, align 4
@reg_equiv_address = external local_unnamed_addr global %struct.rtx_def**, align 4
@lineno = external local_unnamed_addr global i32, align 4
@tree_code_type = external local_unnamed_addr global <{ [147 x i8], [109 x i8] }>, align 1
@flag_pic = external global i32, align 4
@global_trees = external global [51 x %union.tree_node*], align 4
@fixed_regs = external local_unnamed_addr global [53 x i8], align 1
@current_function_decl = external global %union.tree_node*, align 4
@global_rtl = external global [11 x %struct.rtx_def*], align 4
@reload_completed = external local_unnamed_addr global i32, align 4
@frame_pointer_needed = external local_unnamed_addr global i32, align 4
@reg_renumber = external local_unnamed_addr global i16*, align 4
@reload_in_progress = external local_unnamed_addr global i32, align 4
@call_used_regs = external local_unnamed_addr global [53 x i8], align 1
@regs_ever_live = external local_unnamed_addr global [53 x i8], align 1
@extra_warnings = external local_unnamed_addr global i32, align 4
@n_basic_blocks = external local_unnamed_addr global i32, align 4
@rtx_class = external local_unnamed_addr constant [153 x i8], align 1
@basic_block_info = external local_unnamed_addr global %struct.varray_head_tag*, align 4
@stderr = external local_unnamed_addr global %struct._IO_FILE*, align 4
@target_flags = external local_unnamed_addr global i32, align 4
@cfun = external global %struct.function*, align 4

; Function Attrs: nofree nounwind
declare noundef i32 @fwrite(i8* nocapture noundef, i32 noundef, i32 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #0

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fprintf(%struct._IO_FILE* nocapture noundef, i8* nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #0

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i32, i1 immarg) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn
declare void @free(i8* nocapture noundef) #4

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1 immarg) #5

; Function Attrs: optsize
declare void @obstack_free(%struct.obstack*, i8*) local_unnamed_addr #6

; Function Attrs: optsize
declare void @_obstack_newchunk(%struct.obstack*, i32) local_unnamed_addr #6

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn writeonly
declare void @init_recog() local_unnamed_addr #7

; Function Attrs: noinline nounwind optsize
declare i32 @memory_operand(%struct.rtx_def*, i32) #8

; Function Attrs: argmemonly mustprogress nofree nounwind optsize readonly willreturn
declare i32 @strcmp(i8* nocapture, i8* nocapture) #9

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i32 @max_label_num() local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i32 @get_first_label_num() local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize
declare void @unshare_all_rtl_again(%struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i32 @get_max_uid() local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @emit_line_note(i8*, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @emit_note(i8*, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @size_int_wide(i64, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @fold(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @gen_rtx_fmt_ue(i32, i32, %struct.rtx_def*, %struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare zeroext i1 @can_throw_internal(%struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @ggc_collect() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
define i32 @reload(%struct.rtx_def* %first, i32 %global) local_unnamed_addr #8 {
entry:
  %to_spill = alloca i64, align 8
  tail call void @init_recog() #20
  store i1 false, i1* @failure, align 4
  %0 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 4), align 4, !tbaa !4
  %1 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4, !tbaa !11
  %sub.ptr.lhs.cast = ptrtoint i8* %0 to i32
  %sub.ptr.rhs.cast = ptrtoint i8* %1 to i32
  %sub.ptr.sub = sub i32 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %cmp = icmp slt i32 %sub.ptr.sub, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  tail call void @_obstack_newchunk(%struct.obstack* nonnull @reload_obstack, i32 0) #20
  %.pre = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %2 = phi i8* [ %.pre, %if.then ], [ %1, %entry ]
  %3 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 2), align 4, !tbaa !12
  %cmp3 = icmp eq i8* %2, %3
  br i1 %cmp3, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %bf.load = load i8, i8* getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 10), align 4
  %bf.set = or i8 %bf.load, 2
  store i8 %bf.set, i8* getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 10), align 4
  br label %if.end5

if.end5:                                          ; preds = %if.then4, %if.end
  %sub.ptr.lhs.cast7 = ptrtoint i8* %2 to i32
  %4 = load i32, i32* getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 6), align 4, !tbaa !13
  %add = add nsw i32 %4, %sub.ptr.lhs.cast7
  %neg = xor i32 %4, -1
  %and = and i32 %add, %neg
  %5 = inttoptr i32 %and to i8*
  %6 = load i8*, i8** bitcast (%struct._obstack_chunk** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 1) to i8**), align 4, !tbaa !14
  %sub.ptr.rhs.cast13 = ptrtoint i8* %6 to i32
  %sub.ptr.sub14 = sub i32 %and, %sub.ptr.rhs.cast13
  %7 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 4), align 4, !tbaa !4
  %sub.ptr.lhs.cast17 = ptrtoint i8* %7 to i32
  %sub.ptr.sub19 = sub i32 %sub.ptr.lhs.cast17, %sub.ptr.rhs.cast13
  %cmp20 = icmp sgt i32 %sub.ptr.sub14, %sub.ptr.sub19
  %spec.store.select = select i1 %cmp20, i8* %7, i8* %5
  store i8* %spec.store.select, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4
  store i8* %spec.store.select, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 2), align 4, !tbaa !12
  store i8* %3, i8** @reload_firstobj, align 4, !tbaa !15
  %call = tail call %struct.rtx_def* @emit_note(i8* null, i32 -99) #20
  %call28 = tail call i32 @get_max_uid() #20
  store i32 %call28, i32* @reload_first_uid, align 4, !tbaa !16
  tail call void @clear_secondary_mem() #20
  tail call void @llvm.memset.p0i8.i32(i8* noundef nonnull align 4 dereferenceable(212) bitcast ([53 x %struct.rtx_def*]* @spill_stack_slot to i8*), i8 0, i32 212, i1 false)
  tail call void @llvm.memset.p0i8.i32(i8* noundef nonnull align 4 dereferenceable(212) bitcast ([53 x i32]* @spill_stack_slot_width to i8*), i8 0, i32 212, i1 false)
  tail call void @init_save_areas() #20
  %8 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp291645 = icmp sgt i32 %8, 53
  br i1 %cmp291645, label %for.body, label %for.end

for.body:                                         ; preds = %for.body, %if.end5
  %i.01646 = phi i32 [ %inc, %for.body ], [ 53, %if.end5 ]
  tail call void @mark_home_live(i32 %i.01646) #21
  %inc = add nuw nsw i32 %i.01646, 1
  %9 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp29 = icmp slt i32 %inc, %9
  br i1 %cmp29, label %for.body, label %for.end, !llvm.loop !17

for.end:                                          ; preds = %for.body, %if.end5
  %.lcssa = phi i32 [ %8, %if.end5 ], [ %9, %for.body ]
  %10 = load %struct.function*, %struct.function** @cfun, align 4, !tbaa !15
  %has_nonlocal_label = getelementptr inbounds %struct.function, %struct.function* %10, i32 0, i32 56
  %11 = bitcast i24* %has_nonlocal_label to i32*
  %bf.load30 = load i32, i32* %11, align 4
  %12 = and i32 %bf.load30, 256
  %tobool.not = icmp eq i32 %12, 0
  br i1 %tobool.not, label %if.end45, label %for.body35

for.body35:                                       ; preds = %for.inc42, %for.end
  %i.11644 = phi i32 [ %inc43, %for.inc42 ], [ 0, %for.end ]
  %arrayidx = getelementptr inbounds [53 x i8], [53 x i8]* @call_used_regs, i32 0, i32 %i.11644
  %13 = load i8, i8* %arrayidx, align 1, !tbaa !19
  %tobool36.not = icmp eq i8 %13, 0
  br i1 %tobool36.not, label %land.lhs.true, label %for.inc42

land.lhs.true:                                    ; preds = %for.body35
  %arrayidx37 = getelementptr inbounds [53 x i8], [53 x i8]* @fixed_regs, i32 0, i32 %i.11644
  %14 = load i8, i8* %arrayidx37, align 1, !tbaa !19
  %tobool38.not = icmp eq i8 %14, 0
  br i1 %tobool38.not, label %if.then39, label %for.inc42

if.then39:                                        ; preds = %land.lhs.true
  %arrayidx40 = getelementptr inbounds [53 x i8], [53 x i8]* @regs_ever_live, i32 0, i32 %i.11644
  store i8 1, i8* %arrayidx40, align 1, !tbaa !19
  br label %for.inc42

for.inc42:                                        ; preds = %if.then39, %land.lhs.true, %for.body35
  %inc43 = add nuw nsw i32 %i.11644, 1
  %exitcond1654.not = icmp eq i32 %inc43, 53
  br i1 %exitcond1654.not, label %if.end45, label %for.body35, !llvm.loop !20

if.end45:                                         ; preds = %for.inc42, %for.end
  %call46 = tail call noalias i8* @xcalloc(i32 %.lcssa, i32 4) #20
  store i8* %call46, i8** bitcast (%struct.rtx_def*** @reg_equiv_constant to i8**), align 4, !tbaa !15
  %15 = load i32, i32* @max_regno, align 4, !tbaa !16
  %call47 = tail call noalias i8* @xcalloc(i32 %15, i32 4) #20
  store i8* %call47, i8** bitcast (%struct.rtx_def*** @reg_equiv_mem to i8**), align 4, !tbaa !15
  %16 = load i32, i32* @max_regno, align 4, !tbaa !16
  %call48 = tail call noalias i8* @xcalloc(i32 %16, i32 4) #20
  store i8* %call48, i8** bitcast (%struct.rtx_def*** @reg_equiv_init to i8**), align 4, !tbaa !15
  %17 = load i32, i32* @max_regno, align 4, !tbaa !16
  %call49 = tail call noalias i8* @xcalloc(i32 %17, i32 4) #20
  store i8* %call49, i8** bitcast (%struct.rtx_def*** @reg_equiv_address to i8**), align 4, !tbaa !15
  %18 = load i32, i32* @max_regno, align 4, !tbaa !16
  %call50 = tail call noalias i8* @xcalloc(i32 %18, i32 4) #20
  store i8* %call50, i8** bitcast (i32** @reg_max_ref_width to i8**), align 4, !tbaa !15
  %19 = load i32, i32* @max_regno, align 4, !tbaa !16
  %call51 = tail call noalias i8* @xcalloc(i32 %19, i32 2) #20
  store i8* %call51, i8** bitcast (i16** @reg_old_renumber to i8**), align 4, !tbaa !15
  %20 = load i8*, i8** bitcast (i16** @reg_renumber to i8**), align 4, !tbaa !15
  %21 = load i32, i32* @max_regno, align 4, !tbaa !16
  %mul = shl i32 %21, 1
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %call51, i8* align 2 %20, i32 %mul, i1 false)
  %mul52 = shl i32 %21, 3
  %call53 = tail call noalias i8* @xmalloc(i32 %mul52) #20
  store i8* %call53, i8** bitcast (i64** @pseudo_forbidden_regs to i8**), align 4, !tbaa !15
  %22 = load i32, i32* @max_regno, align 4, !tbaa !16
  %call54 = tail call noalias i8* @xcalloc(i32 %22, i32 8) #20
  store i8* %call54, i8** bitcast (i64** @pseudo_previous_regs to i8**), align 4, !tbaa !15
  store i64 0, i64* @bad_spill_regs_global, align 8, !tbaa !21
  store i32 0, i32* @num_eliminable_invariants, align 4, !tbaa !16
  %tobool56.not1639 = icmp eq %struct.rtx_def* %first, null
  br i1 %tobool56.not1639, label %for.end384, label %for.body57

for.body57:                                       ; preds = %cleanup377, %if.end45
  %insn.01640 = phi %struct.rtx_def* [ %70, %cleanup377 ], [ %first, %if.end45 ]
  %23 = getelementptr %struct.rtx_def, %struct.rtx_def* %insn.01640, i32 0, i32 0
  %bf.load58 = load i32, i32* %23, align 4
  %bf.clear59 = and i32 %bf.load58, 65535
  %arrayidx60 = getelementptr inbounds [153 x i8], [153 x i8]* @rtx_class, i32 0, i32 %bf.clear59
  %24 = load i8, i8* %arrayidx60, align 1, !tbaa !19
  %cmp61 = icmp eq i8 %24, 105
  br i1 %cmp61, label %cond.true, label %if.end102

cond.true:                                        ; preds = %for.body57
  %arrayidx63 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.01640, i32 0, i32 1, i32 3
  %rtx = bitcast %union.anon* %arrayidx63 to %struct.rtx_def**
  %25 = load %struct.rtx_def*, %struct.rtx_def** %rtx, align 4, !tbaa !19
  %26 = getelementptr %struct.rtx_def, %struct.rtx_def* %25, i32 0, i32 0
  %bf.load64 = load i32, i32* %26, align 4
  %bf.clear65 = and i32 %bf.load64, 65535
  %cmp66 = icmp eq i32 %bf.clear65, 47
  br i1 %cmp66, label %land.lhs.true85, label %cond.end77

cond.end77:                                       ; preds = %cond.true
  %call75 = tail call %struct.rtx_def* @single_set_2(%struct.rtx_def* nonnull %insn.01640, %struct.rtx_def* nonnull %25) #20
  %bf.load79.pre = load i32, i32* %23, align 4
  %.pre1665 = and i32 %bf.load79.pre, 65535
  %arrayidx81.phi.trans.insert = getelementptr inbounds [153 x i8], [153 x i8]* @rtx_class, i32 0, i32 %.pre1665
  %.pre1666 = load i8, i8* %arrayidx81.phi.trans.insert, align 1, !tbaa !19
  %cmp83 = icmp eq i8 %.pre1666, 105
  br i1 %cmp83, label %land.lhs.true85, label %if.end102

land.lhs.true85:                                  ; preds = %cond.end77, %cond.true
  %cond781672 = phi %struct.rtx_def* [ %call75, %cond.end77 ], [ %25, %cond.true ]
  %bf.load791670 = phi i32 [ %bf.load79.pre, %cond.end77 ], [ %bf.load58, %cond.true ]
  %arrayidx87 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.01640, i32 0, i32 1, i32 3
  %27 = bitcast %union.anon* %arrayidx87 to i32**
  %28 = load i32*, i32** %27, align 4, !tbaa !19
  %bf.load89 = load i32, i32* %28, align 4
  %bf.clear90 = and i32 %bf.load89, 65535
  %cmp91 = icmp ne i32 %bf.clear90, 48
  %29 = and i32 %bf.load791670, 16711680
  %cmp97.not = icmp eq i32 %29, 0
  %or.cond1573 = select i1 %cmp91, i1 true, i1 %cmp97.not
  br i1 %or.cond1573, label %if.end102, label %if.then99

if.then99:                                        ; preds = %land.lhs.true85
  %bf.clear101 = and i32 %bf.load791670, -16711681
  store i32 %bf.clear101, i32* %23, align 4
  br label %if.end102

if.end102:                                        ; preds = %if.then99, %land.lhs.true85, %cond.end77, %for.body57
  %cond781671 = phi %struct.rtx_def* [ %cond781672, %if.then99 ], [ %cond781672, %land.lhs.true85 ], [ %call75, %cond.end77 ], [ null, %for.body57 ]
  %bf.load103 = phi i32 [ %bf.clear101, %if.then99 ], [ %bf.load791670, %land.lhs.true85 ], [ %bf.load79.pre, %cond.end77 ], [ %bf.load58, %for.body57 ]
  %bf.clear104 = and i32 %bf.load103, 65535
  %cmp105 = icmp eq i32 %bf.clear104, 34
  br i1 %cmp105, label %land.lhs.true107, label %if.end123

land.lhs.true107:                                 ; preds = %if.end102
  %call108 = tail call %struct.rtx_def* @find_reg_note(%struct.rtx_def* nonnull %insn.01640, i32 28, %struct.rtx_def* null) #20
  %tobool109.not = icmp eq %struct.rtx_def* %call108, null
  br i1 %tobool109.not, label %if.end123, label %for.body114

for.body114:                                      ; preds = %for.inc120, %land.lhs.true107
  %i.21638 = phi i32 [ %inc121, %for.inc120 ], [ 0, %land.lhs.true107 ]
  %arrayidx115 = getelementptr inbounds [53 x i8], [53 x i8]* @call_used_regs, i32 0, i32 %i.21638
  %30 = load i8, i8* %arrayidx115, align 1, !tbaa !19
  %tobool116.not = icmp eq i8 %30, 0
  br i1 %tobool116.not, label %if.then117, label %for.inc120

if.then117:                                       ; preds = %for.body114
  %arrayidx118 = getelementptr inbounds [53 x i8], [53 x i8]* @regs_ever_live, i32 0, i32 %i.21638
  store i8 1, i8* %arrayidx118, align 1, !tbaa !19
  br label %for.inc120

for.inc120:                                       ; preds = %if.then117, %for.body114
  %inc121 = add nuw nsw i32 %i.21638, 1
  %exitcond1653.not = icmp eq i32 %inc121, 53
  br i1 %exitcond1653.not, label %if.end123, label %for.body114, !llvm.loop !23

if.end123:                                        ; preds = %for.inc120, %land.lhs.true107, %if.end102
  %cmp124.not = icmp eq %struct.rtx_def* %cond781671, null
  br i1 %cmp124.not, label %if.end365, label %land.lhs.true126

land.lhs.true126:                                 ; preds = %if.end123
  %fld127 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %cond781671, i32 0, i32 1
  %rtx129 = bitcast [1 x %union.anon]* %fld127 to %struct.rtx_def**
  %31 = bitcast [1 x %union.anon]* %fld127 to i32**
  %32 = load i32*, i32** %31, align 4, !tbaa !19
  %bf.load130 = load i32, i32* %32, align 4
  %33 = bitcast i32* %32 to %struct.rtx_def*
  %trunc1679 = trunc i32 %bf.load130 to i16
  switch i16 %trunc1679, label %if.end365 [
    i16 61, label %if.then134
    i16 66, label %land.lhs.true318
  ]

if.then134:                                       ; preds = %land.lhs.true126
  %call135 = tail call %struct.rtx_def* @find_reg_note(%struct.rtx_def* nonnull %insn.01640, i32 3, %struct.rtx_def* null) #20
  %tobool136.not = icmp eq %struct.rtx_def* %call135, null
  br i1 %tobool136.not, label %if.end365, label %land.lhs.true137

land.lhs.true137:                                 ; preds = %if.then134
  %arrayidx139 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %call135, i32 0, i32 1, i32 0
  %rtx140 = bitcast %union.anon* %arrayidx139 to %struct.rtx_def**
  %34 = load %struct.rtx_def*, %struct.rtx_def** %rtx140, align 4, !tbaa !19
  %call141 = tail call i32 @function_invariant_p(%struct.rtx_def* %34) #20
  %tobool142 = icmp ne i32 %call141, 0
  %35 = load i32, i32* @flag_pic, align 4
  %tobool143 = icmp ne i32 %35, 0
  %or.cond = select i1 %tobool142, i1 %tobool143, i1 false
  br i1 %or.cond, label %lor.lhs.false144, label %if.then244

lor.lhs.false144:                                 ; preds = %land.lhs.true137
  %36 = bitcast %union.anon* %arrayidx139 to i32**
  %37 = load i32*, i32** %36, align 4, !tbaa !19
  %bf.load148 = load i32, i32* %37, align 4
  %trunc = trunc i32 %bf.load148 to i16
  %38 = bitcast i32* %37 to %struct.rtx_def*
  switch i16 %trunc, label %if.end365 [
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
  %call236 = tail call i32 @symbolic_reference_mentioned_p(%struct.rtx_def* nonnull %38) #20
  %tobool237.not = icmp eq i32 %call236, 0
  br i1 %tobool237.not, label %if.then244, label %land.lhs.true232.lor.lhs.false238_crit_edge

land.lhs.true232.lor.lhs.false238_crit_edge:      ; preds = %land.lhs.true232
  %.pre1657 = load %struct.rtx_def*, %struct.rtx_def** %rtx140, align 4, !tbaa !19
  br label %lor.lhs.false238

lor.lhs.false238:                                 ; preds = %land.lhs.true232.lor.lhs.false238_crit_edge, %lor.lhs.false144, %lor.lhs.false144
  %39 = phi %struct.rtx_def* [ %.pre1657, %land.lhs.true232.lor.lhs.false238_crit_edge ], [ %38, %lor.lhs.false144 ], [ %38, %lor.lhs.false144 ]
  %call242 = tail call i32 @legitimate_pic_address_disp_p(%struct.rtx_def* %39) #20
  %tobool243.not = icmp eq i32 %call242, 0
  br i1 %tobool243.not, label %if.end365, label %if.then244

if.then244:                                       ; preds = %lor.lhs.false238, %land.lhs.true232, %lor.lhs.false144, %lor.lhs.false144, %lor.lhs.false144, %lor.lhs.false144, %lor.lhs.false144, %land.lhs.true137
  %40 = load %struct.rtx_def*, %struct.rtx_def** %rtx140, align 4, !tbaa !19
  %41 = load %struct.rtx_def*, %struct.rtx_def** %rtx129, align 4, !tbaa !19
  %arrayidx252 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %41, i32 0, i32 1, i32 0
  %rtuint = bitcast %union.anon* %arrayidx252 to i32*
  %42 = load i32, i32* %rtuint, align 4, !tbaa !19
  %cmp253 = icmp sgt i32 %42, 57
  br i1 %cmp253, label %if.then255, label %if.end365

if.then255:                                       ; preds = %if.then244
  %call256 = tail call i32 @memory_operand(%struct.rtx_def* %40, i32 0) #20
  %tobool257.not = icmp eq i32 %call256, 0
  br i1 %tobool257.not, label %if.else, label %if.then258

if.then258:                                       ; preds = %if.then255
  %call259 = tail call %struct.rtx_def* @copy_rtx(%struct.rtx_def* %40) #20
  %43 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx260 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %43, i32 %42
  store %struct.rtx_def* %call259, %struct.rtx_def** %arrayidx260, align 4, !tbaa !15
  br label %if.end287

if.else:                                          ; preds = %if.then255
  %call261 = tail call i32 @function_invariant_p(%struct.rtx_def* %40) #20
  %tobool262.not = icmp eq i32 %call261, 0
  br i1 %tobool262.not, label %cleanup377, label %if.then263

if.then263:                                       ; preds = %if.else
  %44 = getelementptr %struct.rtx_def, %struct.rtx_def* %40, i32 0, i32 0
  %bf.load264 = load i32, i32* %44, align 4
  %bf.clear265 = and i32 %bf.load264, 65535
  %cmp266 = icmp eq i32 %bf.clear265, 75
  br i1 %cmp266, label %if.then268, label %if.else272

if.then268:                                       ; preds = %if.then263
  %call269 = tail call %struct.rtx_def* @copy_rtx(%struct.rtx_def* nonnull %40) #20
  %45 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_constant, align 4, !tbaa !15
  %arrayidx270 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %45, i32 %42
  store %struct.rtx_def* %call269, %struct.rtx_def** %arrayidx270, align 4, !tbaa !15
  %46 = load i32, i32* @num_eliminable_invariants, align 4, !tbaa !16
  %inc271 = add nsw i32 %46, 1
  store i32 %inc271, i32* @num_eliminable_invariants, align 4, !tbaa !16
  br label %if.end287

if.else272:                                       ; preds = %if.then263
  %47 = load %struct.rtx_def*, %struct.rtx_def** getelementptr inbounds ([11 x %struct.rtx_def*], [11 x %struct.rtx_def*]* @global_rtl, i32 0, i32 3), align 4, !tbaa !15
  %cmp273 = icmp eq %struct.rtx_def* %40, %47
  %48 = load %struct.rtx_def*, %struct.rtx_def** getelementptr inbounds ([11 x %struct.rtx_def*], [11 x %struct.rtx_def*]* @global_rtl, i32 0, i32 5), align 4
  %cmp276 = icmp eq %struct.rtx_def* %40, %48
  %or.cond1574 = select i1 %cmp273, i1 true, i1 %cmp276
  %49 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_constant, align 4, !tbaa !15
  %arrayidx279 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %49, i32 %42
  store %struct.rtx_def* %40, %struct.rtx_def** %arrayidx279, align 4, !tbaa !15
  br i1 %or.cond1574, label %if.then278, label %if.end287

if.then278:                                       ; preds = %if.else272
  %50 = load i32, i32* @num_eliminable_invariants, align 4, !tbaa !16
  %inc280 = add nsw i32 %50, 1
  store i32 %inc280, i32* @num_eliminable_invariants, align 4, !tbaa !16
  br label %if.end287

if.end287:                                        ; preds = %if.then278, %if.else272, %if.then268, %if.then258
  %51 = getelementptr %struct.rtx_def, %struct.rtx_def* %40, i32 0, i32 0
  %bf.load288 = load i32, i32* %51, align 4
  %bf.clear289 = and i32 %bf.load288, 65535
  %cmp290.not = icmp eq i32 %bf.clear289, 66
  br i1 %cmp290.not, label %lor.lhs.false292, label %if.then298

lor.lhs.false292:                                 ; preds = %if.end287
  %arrayidx294 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %cond781671, i32 0, i32 1, i32 1
  %rtx295 = bitcast %union.anon* %arrayidx294 to %struct.rtx_def**
  %52 = load %struct.rtx_def*, %struct.rtx_def** %rtx295, align 4, !tbaa !19
  %call296 = tail call i32 @rtx_equal_p(%struct.rtx_def* %52, %struct.rtx_def* nonnull %40) #20
  %tobool297.not = icmp eq i32 %call296, 0
  br i1 %tobool297.not, label %if.end365, label %if.then298

if.then298:                                       ; preds = %lor.lhs.false292, %if.end287
  %53 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_init, align 4, !tbaa !15
  %arrayidx299 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %53, i32 %42
  %54 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx299, align 4, !tbaa !15
  %call300 = tail call %struct.rtx_def* @gen_rtx_fmt_ue(i32 4, i32 0, %struct.rtx_def* nonnull %insn.01640, %struct.rtx_def* %54) #20
  %55 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_init, align 4, !tbaa !15
  %arrayidx301 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %55, i32 %42
  store %struct.rtx_def* %call300, %struct.rtx_def** %arrayidx301, align 4, !tbaa !15
  br label %if.end365

land.lhs.true318:                                 ; preds = %land.lhs.true126
  %arrayidx320 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %cond781671, i32 0, i32 1, i32 1
  %rtx321 = bitcast %union.anon* %arrayidx320 to %struct.rtx_def**
  %56 = load %struct.rtx_def*, %struct.rtx_def** %rtx321, align 4, !tbaa !19
  %57 = getelementptr %struct.rtx_def, %struct.rtx_def* %56, i32 0, i32 0
  %bf.load322 = load i32, i32* %57, align 4
  %bf.clear323 = and i32 %bf.load322, 65535
  %cmp324 = icmp eq i32 %bf.clear323, 61
  br i1 %cmp324, label %land.lhs.true326, label %if.end365

land.lhs.true326:                                 ; preds = %land.lhs.true318
  %58 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx331 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %56, i32 0, i32 1, i32 0
  %rtuint332 = bitcast %union.anon* %arrayidx331 to i32*
  %59 = load i32, i32* %rtuint332, align 4, !tbaa !19
  %arrayidx333 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %58, i32 %59
  %60 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx333, align 4, !tbaa !15
  %tobool334.not = icmp eq %struct.rtx_def* %60, null
  br i1 %tobool334.not, label %if.end365, label %land.lhs.true335

land.lhs.true335:                                 ; preds = %land.lhs.true326
  %call346 = tail call i32 @rtx_equal_p(%struct.rtx_def* nonnull %33, %struct.rtx_def* nonnull %60) #20
  %tobool347.not = icmp eq i32 %call346, 0
  br i1 %tobool347.not, label %if.end365, label %if.then348

if.then348:                                       ; preds = %land.lhs.true335
  %61 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_init, align 4, !tbaa !15
  %62 = load %struct.rtx_def*, %struct.rtx_def** %rtx321, align 4, !tbaa !19
  %arrayidx353 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %62, i32 0, i32 1, i32 0
  %rtuint354 = bitcast %union.anon* %arrayidx353 to i32*
  %63 = load i32, i32* %rtuint354, align 4, !tbaa !19
  %arrayidx355 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %61, i32 %63
  %64 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx355, align 4, !tbaa !15
  %call356 = tail call %struct.rtx_def* @gen_rtx_fmt_ue(i32 4, i32 0, %struct.rtx_def* nonnull %insn.01640, %struct.rtx_def* %64) #20
  %65 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_init, align 4, !tbaa !15
  %66 = load %struct.rtx_def*, %struct.rtx_def** %rtx321, align 4, !tbaa !19
  %arrayidx361 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %66, i32 0, i32 1, i32 0
  %rtuint362 = bitcast %union.anon* %arrayidx361 to i32*
  %67 = load i32, i32* %rtuint362, align 4, !tbaa !19
  %arrayidx363 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %65, i32 %67
  store %struct.rtx_def* %call356, %struct.rtx_def** %arrayidx363, align 4, !tbaa !15
  br label %if.end365

if.end365:                                        ; preds = %if.then348, %land.lhs.true335, %land.lhs.true326, %land.lhs.true318, %if.then298, %lor.lhs.false292, %if.then244, %lor.lhs.false238, %lor.lhs.false144, %if.then134, %land.lhs.true126, %if.end123
  %bf.load366 = load i32, i32* %23, align 4
  %bf.clear367 = and i32 %bf.load366, 65535
  %arrayidx368 = getelementptr inbounds [153 x i8], [153 x i8]* @rtx_class, i32 0, i32 %bf.clear367
  %68 = load i8, i8* %arrayidx368, align 1, !tbaa !19
  %cmp370 = icmp eq i8 %68, 105
  br i1 %cmp370, label %if.then372, label %cleanup377

if.then372:                                       ; preds = %if.end365
  %arrayidx374 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.01640, i32 0, i32 1, i32 3
  %rtx375 = bitcast %union.anon* %arrayidx374 to %struct.rtx_def**
  %69 = load %struct.rtx_def*, %struct.rtx_def** %rtx375, align 4, !tbaa !19
  tail call fastcc void @scan_paradoxical_subregs(%struct.rtx_def* %69) #21
  br label %cleanup377

cleanup377:                                       ; preds = %if.then372, %if.end365, %if.else
  %arrayidx382 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.01640, i32 0, i32 1, i32 2
  %rtx383 = bitcast %union.anon* %arrayidx382 to %struct.rtx_def**
  %70 = load %struct.rtx_def*, %struct.rtx_def** %rtx383, align 4, !tbaa !19
  %tobool56.not = icmp eq %struct.rtx_def* %70, null
  br i1 %tobool56.not, label %for.end384, label %for.body57, !llvm.loop !24

for.end384:                                       ; preds = %cleanup377, %if.end45
  tail call fastcc void @init_elim_table() #21
  %call385 = tail call i32 @max_label_num() #20
  %call386 = tail call i32 @get_first_label_num() #20
  %sub = sub nsw i32 %call385, %call386
  store i32 %sub, i32* @num_labels, align 4, !tbaa !16
  %call387 = tail call noalias i8* @xmalloc(i32 %sub) #20
  %71 = load i32, i32* @num_labels, align 4, !tbaa !16
  %mul389 = shl i32 %71, 4
  %call390 = tail call noalias i8* @xmalloc(i32 %mul389) #20
  %72 = bitcast i8* %call390 to [4 x i32]*
  %call391 = tail call i32 @get_first_label_num() #20
  %idx.neg = sub i32 0, %call391
  %add.ptr392 = getelementptr inbounds i8, i8* %call387, i32 %idx.neg
  store i8* %add.ptr392, i8** @offsets_known_at, align 4, !tbaa !15
  %call393 = tail call i32 @get_first_label_num() #20
  %idx.neg394 = sub i32 0, %call393
  %add.ptr395 = getelementptr inbounds [4 x i32], [4 x i32]* %72, i32 %idx.neg394
  store [4 x i32]* %add.ptr395, [4 x i32]** @offsets_at, align 4, !tbaa !15
  %73 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp3971636 = icmp sgt i32 %73, 58
  br i1 %cmp3971636, label %for.body399, label %for.cond403.preheader

for.cond403.preheader:                            ; preds = %for.body399, %for.end384
  %tobool4041632 = icmp ne %struct.rtx_def* %first, null
  %74 = load i32, i32* @num_eliminable, align 4
  %tobool4051633 = icmp ne i32 %74, 0
  %75 = select i1 %tobool4041632, i1 %tobool4051633, i1 false
  br i1 %75, label %for.body406, label %for.body435.preheader

for.body399:                                      ; preds = %for.body399, %for.end384
  %i.31637 = phi i32 [ %inc401, %for.body399 ], [ 58, %for.end384 ]
  tail call fastcc void @alter_reg(i32 %i.31637, i32 -1) #21
  %inc401 = add nuw nsw i32 %i.31637, 1
  %76 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp397 = icmp slt i32 %inc401, %76
  br i1 %cmp397, label %for.body399, label %for.cond403.preheader, !llvm.loop !25

for.body406:                                      ; preds = %for.inc426, %for.cond403.preheader
  %77 = phi i32 [ %80, %for.inc426 ], [ %74, %for.cond403.preheader ]
  %insn.11634 = phi %struct.rtx_def* [ %81, %for.inc426 ], [ %first, %for.cond403.preheader ]
  %78 = getelementptr %struct.rtx_def, %struct.rtx_def* %insn.11634, i32 0, i32 0
  %bf.load407 = load i32, i32* %78, align 4
  %bf.clear408 = and i32 %bf.load407, 65535
  %bf.clear408.off = add nsw i32 %bf.clear408, -32
  %switch = icmp ult i32 %bf.clear408.off, 3
  br i1 %switch, label %if.then421, label %for.inc426

if.then421:                                       ; preds = %for.body406
  %arrayidx423 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.11634, i32 0, i32 1, i32 3
  %rtx424 = bitcast %union.anon* %arrayidx423 to %struct.rtx_def**
  %79 = load %struct.rtx_def*, %struct.rtx_def** %rtx424, align 4, !tbaa !19
  tail call void @note_stores(%struct.rtx_def* %79, void (%struct.rtx_def*, %struct.rtx_def*, i8*)* nonnull @mark_not_eliminable, i8* null) #20
  %.pre1658 = load i32, i32* @num_eliminable, align 4
  br label %for.inc426

for.inc426:                                       ; preds = %if.then421, %for.body406
  %80 = phi i32 [ %77, %for.body406 ], [ %.pre1658, %if.then421 ]
  %arrayidx428 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.11634, i32 0, i32 1, i32 2
  %rtx429 = bitcast %union.anon* %arrayidx428 to %struct.rtx_def**
  %81 = load %struct.rtx_def*, %struct.rtx_def** %rtx429, align 4, !tbaa !19
  %tobool404 = icmp ne %struct.rtx_def* %81, null
  %tobool405 = icmp ne i32 %80, 0
  %82 = select i1 %tobool404, i1 %tobool405, i1 false
  br i1 %82, label %for.body406, label %for.body435.preheader, !llvm.loop !26

for.body435.preheader:                            ; preds = %for.inc426, %for.cond403.preheader
  tail call fastcc void @maybe_fix_stack_asms() #21
  store %struct.insn_chain* null, %struct.insn_chain** @insns_need_reload, align 4, !tbaa !15
  store i1 false, i1* @something_needs_elimination, align 4
  store i32 -1, i32* @last_spill_reg, align 4, !tbaa !16
  store i64 0, i64* @used_spill_regs, align 8, !tbaa !21
  %83 = load %struct.elim_table*, %struct.elim_table** @reg_eliminate, align 4, !tbaa !15
  br label %for.body435

for.body435:                                      ; preds = %for.inc439, %for.body435.preheader
  %84 = phi %struct.elim_table* [ %87, %for.inc439 ], [ %83, %for.body435.preheader ]
  %ep.01631 = phi %struct.elim_table* [ %incdec.ptr, %for.inc439 ], [ %83, %for.body435.preheader ]
  %can_eliminate = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.01631, i32 0, i32 3
  %85 = load i32, i32* %can_eliminate, align 4, !tbaa !27
  %tobool436.not = icmp eq i32 %85, 0
  br i1 %tobool436.not, label %if.then437, label %for.inc439

if.then437:                                       ; preds = %for.body435
  %from = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.01631, i32 0, i32 0
  %86 = load i32, i32* %from, align 4, !tbaa !29
  tail call fastcc void @spill_hard_reg(i32 %86) #21
  %.pre1659 = load %struct.elim_table*, %struct.elim_table** @reg_eliminate, align 4, !tbaa !15
  br label %for.inc439

for.inc439:                                       ; preds = %if.then437, %for.body435
  %87 = phi %struct.elim_table* [ %84, %for.body435 ], [ %.pre1659, %if.then437 ]
  %incdec.ptr = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.01631, i32 1
  %arrayidx432 = getelementptr inbounds %struct.elim_table, %struct.elim_table* %87, i32 4
  %cmp433 = icmp ult %struct.elim_table* %incdec.ptr, %arrayidx432
  br i1 %cmp433, label %for.body435, label %for.end440, !llvm.loop !30

for.end440:                                       ; preds = %for.inc439
  %88 = load i32, i32* @frame_pointer_needed, align 4, !tbaa !16
  %tobool441.not = icmp eq i32 %88, 0
  br i1 %tobool441.not, label %if.end443, label %if.then442

if.then442:                                       ; preds = %for.end440
  tail call fastcc void @spill_hard_reg(i32 6) #21
  br label %if.end443

if.end443:                                        ; preds = %if.then442, %for.end440
  %call444 = tail call fastcc i32 @finish_spills(i32 %global) #21
  store i32 1, i32* @reload_in_progress, align 4, !tbaa !16
  %89 = bitcast i64* %to_spill to i8*
  br label %for.cond445

for.cond445:                                      ; preds = %for.cond445.backedge, %if.end443
  %90 = load %struct.function*, %struct.function** @cfun, align 4, !tbaa !15
  %stack_alignment_needed = getelementptr inbounds %struct.function, %struct.function* %90, i32 0, i32 52
  %91 = load i32, i32* %stack_alignment_needed, align 4, !tbaa !31
  %tobool446.not = icmp eq i32 %91, 0
  br i1 %tobool446.not, label %if.end450, label %if.then447

if.then447:                                       ; preds = %for.cond445
  %call449 = tail call %struct.rtx_def* @assign_stack_local(i32 51, i64 0, i32 %91) #20
  br label %if.end450

if.end450:                                        ; preds = %if.then447, %for.cond445
  %call451 = tail call i64 @get_frame_size() #20
  tail call fastcc void @set_initial_elim_offsets() #21
  tail call fastcc void @set_initial_label_offsets() #21
  %92 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp4531621 = icmp sgt i32 %92, 53
  br i1 %cmp4531621, label %for.body455, label %for.end693

for.body455:                                      ; preds = %for.inc691, %if.end450
  %i.41622 = phi i32 [ %inc692, %for.inc691 ], [ 53, %if.end450 ]
  %93 = load i16*, i16** @reg_renumber, align 4, !tbaa !15
  %arrayidx456 = getelementptr inbounds i16, i16* %93, i32 %i.41622
  %94 = load i16, i16* %arrayidx456, align 2, !tbaa !34
  %cmp458 = icmp slt i16 %94, 0
  br i1 %cmp458, label %land.lhs.true460, label %for.inc691

land.lhs.true460:                                 ; preds = %for.body455
  %95 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx461 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %95, i32 %i.41622
  %96 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx461, align 4, !tbaa !15
  %tobool462.not = icmp eq %struct.rtx_def* %96, null
  br i1 %tobool462.not, label %for.inc691, label %if.then463

if.then463:                                       ; preds = %land.lhs.true460
  %call466 = tail call %struct.rtx_def* @eliminate_regs(%struct.rtx_def* nonnull %96, i32 0, %struct.rtx_def* null) #21
  %97 = load %struct.function*, %struct.function** @cfun, align 4, !tbaa !15
  %emit = getelementptr inbounds %struct.function, %struct.function* %97, i32 0, i32 3
  %98 = load %struct.emit_status*, %struct.emit_status** %emit, align 4, !tbaa !36
  %x_regno_reg_rtx = getelementptr inbounds %struct.emit_status, %struct.emit_status* %98, i32 0, i32 12
  %99 = load %struct.rtx_def**, %struct.rtx_def*** %x_regno_reg_rtx, align 4, !tbaa !37
  %arrayidx467 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %99, i32 %i.41622
  %100 = bitcast %struct.rtx_def** %arrayidx467 to i32**
  %101 = load i32*, i32** %100, align 4, !tbaa !15
  %bf.load468 = load i32, i32* %101, align 4
  %bf.lshr469 = lshr i32 %bf.load468, 16
  %bf.clear470 = and i32 %bf.lshr469, 255
  %arrayidx472 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %call466, i32 0, i32 1, i32 0
  %rtx473 = bitcast %union.anon* %arrayidx472 to %struct.rtx_def**
  %102 = load %struct.rtx_def*, %struct.rtx_def** %rtx473, align 4, !tbaa !19
  %call474 = tail call i32 @strict_memory_address_p(i32 %bf.clear470, %struct.rtx_def* %102) #20
  %tobool475.not = icmp eq i32 %call474, 0
  br i1 %tobool475.not, label %if.else479, label %if.then476

if.then476:                                       ; preds = %if.then463
  %103 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_mem, align 4, !tbaa !15
  %arrayidx477 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %103, i32 %i.41622
  store %struct.rtx_def* %call466, %struct.rtx_def** %arrayidx477, align 4, !tbaa !15
  %104 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_address, align 4, !tbaa !15
  %arrayidx478 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %104, i32 %i.41622
  store %struct.rtx_def* null, %struct.rtx_def** %arrayidx478, align 4, !tbaa !15
  br label %for.inc691

if.else479:                                       ; preds = %if.then463
  %105 = load %struct.rtx_def*, %struct.rtx_def** %rtx473, align 4, !tbaa !19
  %106 = getelementptr %struct.rtx_def, %struct.rtx_def* %105, i32 0, i32 0
  %bf.load483 = load i32, i32* %106, align 4
  %trunc1590 = trunc i32 %bf.load483 to i16
  switch i16 %trunc1590, label %if.else685 [
    i16 67, label %if.then679
    i16 68, label %if.then679
    i16 54, label %if.then679
    i16 55, label %if.then679
    i16 58, label %if.then679
    i16 134, label %if.then679
    i16 56, label %if.then679
    i16 140, label %if.then679
    i16 61, label %land.lhs.true551
    i16 75, label %land.lhs.true568
  ]

land.lhs.true551:                                 ; preds = %if.else479
  %arrayidx556 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %105, i32 0, i32 1, i32 0
  %rtuint557 = bitcast %union.anon* %arrayidx556 to i32*
  %107 = load i32, i32* %rtuint557, align 4, !tbaa !19
  %cmp558 = icmp ult i32 %107, 53
  br i1 %cmp558, label %if.then679, label %if.else685

land.lhs.true568:                                 ; preds = %if.else479
  %fld572 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %105, i32 0, i32 1
  %rtx574 = bitcast [1 x %union.anon]* %fld572 to %struct.rtx_def**
  %108 = load %struct.rtx_def*, %struct.rtx_def** %rtx574, align 4, !tbaa !19
  %109 = getelementptr %struct.rtx_def, %struct.rtx_def* %108, i32 0, i32 0
  %bf.load575 = load i32, i32* %109, align 4
  %bf.clear576 = and i32 %bf.load575, 65535
  %cmp577 = icmp eq i32 %bf.clear576, 61
  br i1 %cmp577, label %land.lhs.true579, label %if.else685

land.lhs.true579:                                 ; preds = %land.lhs.true568
  %arrayidx587 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %108, i32 0, i32 1, i32 0
  %rtuint588 = bitcast %union.anon* %arrayidx587 to i32*
  %110 = load i32, i32* %rtuint588, align 4, !tbaa !19
  %cmp589 = icmp ult i32 %110, 53
  br i1 %cmp589, label %land.lhs.true591, label %if.else685

land.lhs.true591:                                 ; preds = %land.lhs.true579
  %arrayidx596 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %105, i32 0, i32 1, i32 1
  %111 = bitcast %union.anon* %arrayidx596 to i32**
  %112 = load i32*, i32** %111, align 4, !tbaa !19
  %bf.load598 = load i32, i32* %112, align 4
  %trunc1591 = trunc i32 %bf.load598 to i16
  switch i16 %trunc1591, label %if.else685 [
    i16 67, label %if.then679
    i16 68, label %if.then679
    i16 54, label %if.then679
    i16 55, label %if.then679
    i16 58, label %if.then679
    i16 134, label %if.then679
    i16 56, label %if.then679
    i16 140, label %if.then679
  ]

if.then679:                                       ; preds = %land.lhs.true591, %land.lhs.true591, %land.lhs.true591, %land.lhs.true591, %land.lhs.true591, %land.lhs.true591, %land.lhs.true591, %land.lhs.true591, %land.lhs.true551, %if.else479, %if.else479, %if.else479, %if.else479, %if.else479, %if.else479, %if.else479, %if.else479
  %113 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_address, align 4, !tbaa !15
  %arrayidx683 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %113, i32 %i.41622
  store %struct.rtx_def* %105, %struct.rtx_def** %arrayidx683, align 4, !tbaa !15
  %114 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_mem, align 4, !tbaa !15
  %arrayidx684 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %114, i32 %i.41622
  store %struct.rtx_def* null, %struct.rtx_def** %arrayidx684, align 4, !tbaa !15
  br label %for.inc691

if.else685:                                       ; preds = %land.lhs.true591, %land.lhs.true579, %land.lhs.true568, %land.lhs.true551, %if.else479
  %115 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx686 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %115, i32 %i.41622
  store %struct.rtx_def* null, %struct.rtx_def** %arrayidx686, align 4, !tbaa !15
  %116 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_init, align 4, !tbaa !15
  %arrayidx687 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %116, i32 %i.41622
  store %struct.rtx_def* null, %struct.rtx_def** %arrayidx687, align 4, !tbaa !15
  tail call fastcc void @alter_reg(i32 %i.41622, i32 -1) #21
  br label %for.inc691

for.inc691:                                       ; preds = %if.else685, %if.then679, %if.then476, %land.lhs.true460, %for.body455
  %inc692 = add nuw nsw i32 %i.41622, 1
  %117 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp453 = icmp slt i32 %inc692, %117
  br i1 %cmp453, label %for.body455, label %for.end693, !llvm.loop !39

for.end693:                                       ; preds = %for.inc691, %if.end450
  %118 = load i32, i32* @caller_save_needed, align 4, !tbaa !16
  %tobool694.not = icmp eq i32 %118, 0
  br i1 %tobool694.not, label %if.end696, label %if.then695

if.then695:                                       ; preds = %for.end693
  tail call void @setup_save_areas() #20
  br label %if.end696

if.end696:                                        ; preds = %if.then695, %for.end693
  %call697 = tail call i64 @get_frame_size() #20
  %cmp698.not = icmp eq i64 %call451, %call697
  br i1 %cmp698.not, label %if.end701, label %for.cond445.backedge

if.end701:                                        ; preds = %if.end696
  %119 = load i32, i32* @caller_save_needed, align 4, !tbaa !16
  %tobool702.not = icmp eq i32 %119, 0
  br i1 %tobool702.not, label %if.end759, label %if.then703

if.then703:                                       ; preds = %if.end701
  tail call void @save_call_clobbered_regs() #20
  %120 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 4), align 4, !tbaa !4
  %121 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4, !tbaa !11
  %sub.ptr.lhs.cast709 = ptrtoint i8* %120 to i32
  %sub.ptr.rhs.cast710 = ptrtoint i8* %121 to i32
  %sub.ptr.sub711 = sub i32 %sub.ptr.lhs.cast709, %sub.ptr.rhs.cast710
  %cmp712 = icmp slt i32 %sub.ptr.sub711, 0
  br i1 %cmp712, label %if.then714, label %if.end715

if.then714:                                       ; preds = %if.then703
  tail call void @_obstack_newchunk(%struct.obstack* nonnull @reload_obstack, i32 0) #20
  %.pre1660 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4, !tbaa !11
  br label %if.end715

if.end715:                                        ; preds = %if.then714, %if.then703
  %122 = phi i8* [ %.pre1660, %if.then714 ], [ %121, %if.then703 ]
  %123 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 2), align 4, !tbaa !12
  %cmp723 = icmp eq i8* %122, %123
  br i1 %cmp723, label %if.then725, label %if.end730

if.then725:                                       ; preds = %if.end715
  %bf.load727 = load i8, i8* getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 10), align 4
  %bf.set729 = or i8 %bf.load727, 2
  store i8 %bf.set729, i8* getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 10), align 4
  br label %if.end730

if.end730:                                        ; preds = %if.then725, %if.end715
  %sub.ptr.lhs.cast732 = ptrtoint i8* %122 to i32
  %124 = load i32, i32* getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 6), align 4, !tbaa !13
  %add735 = add nsw i32 %124, %sub.ptr.lhs.cast732
  %neg737 = xor i32 %124, -1
  %and738 = and i32 %add735, %neg737
  %125 = inttoptr i32 %and738 to i8*
  %126 = load i8*, i8** bitcast (%struct._obstack_chunk** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 1) to i8**), align 4, !tbaa !14
  %sub.ptr.rhs.cast743 = ptrtoint i8* %126 to i32
  %sub.ptr.sub744 = sub i32 %and738, %sub.ptr.rhs.cast743
  %127 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 4), align 4, !tbaa !4
  %sub.ptr.lhs.cast747 = ptrtoint i8* %127 to i32
  %sub.ptr.sub749 = sub i32 %sub.ptr.lhs.cast747, %sub.ptr.rhs.cast743
  %cmp750 = icmp sgt i32 %sub.ptr.sub744, %sub.ptr.sub749
  %spec.store.select1575 = select i1 %cmp750, i8* %127, i8* %125
  store i8* %spec.store.select1575, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4
  store i8* %spec.store.select1575, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 2), align 4, !tbaa !12
  store i8* %123, i8** @reload_firstobj, align 4, !tbaa !15
  br label %if.end759

if.end759:                                        ; preds = %if.end730, %if.end701
  tail call fastcc void @calculate_needs_all_insns(i32 %global) #21
  tail call void @bitmap_clear(%struct.bitmap_head_def* nonnull @spilled_pseudos) #20
  %call760 = tail call i64 @get_frame_size() #20
  %cmp761.not = icmp ne i64 %call451, %call760
  %spec.select = zext i1 %cmp761.not to i32
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %89) #22
  store i64 0, i64* %to_spill, align 8, !tbaa !21
  call fastcc void @update_eliminables(i64* nonnull %to_spill) #21
  %128 = load i64, i64* %to_spill, align 8, !tbaa !21
  br label %for.body768

for.body768:                                      ; preds = %for.inc773, %if.end759
  %i.51627 = phi i32 [ 0, %if.end759 ], [ %inc774, %for.inc773 ]
  %something_changed.11626 = phi i32 [ %spec.select, %if.end759 ], [ %something_changed.2, %for.inc773 ]
  %did_spill.01625 = phi i32 [ 0, %if.end759 ], [ %did_spill.1, %for.inc773 ]
  %sh_prom = zext i32 %i.51627 to i64
  %shl = shl nuw nsw i64 1, %sh_prom
  %and769 = and i64 %128, %shl
  %tobool770.not = icmp eq i64 %and769, 0
  br i1 %tobool770.not, label %for.inc773, label %if.then771

if.then771:                                       ; preds = %for.body768
  tail call fastcc void @spill_hard_reg(i32 %i.51627) #21
  br label %for.inc773

for.inc773:                                       ; preds = %if.then771, %for.body768
  %did_spill.1 = phi i32 [ 1, %if.then771 ], [ %did_spill.01625, %for.body768 ]
  %something_changed.2 = phi i32 [ 1, %if.then771 ], [ %something_changed.11626, %for.body768 ]
  %inc774 = add nuw nsw i32 %i.51627, 1
  %exitcond1652.not = icmp eq i32 %inc774, 53
  br i1 %exitcond1652.not, label %for.end775, label %for.body768, !llvm.loop !40

for.end775:                                       ; preds = %for.inc773
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %89) #22
  tail call fastcc void @select_reload_regs() #21
  %.b1570 = load i1, i1* @failure, align 4
  br i1 %.b1570, label %failed, label %if.end778

if.end778:                                        ; preds = %for.end775
  %129 = load %struct.insn_chain*, %struct.insn_chain** @insns_need_reload, align 4, !tbaa !15
  %cmp779 = icmp ne %struct.insn_chain* %129, null
  %tobool782 = icmp ne i32 %did_spill.1, 0
  %or.cond1238 = select i1 %cmp779, i1 true, i1 %tobool782
  br i1 %or.cond1238, label %if.then783, label %if.end785

if.then783:                                       ; preds = %if.end778
  %call784 = tail call fastcc i32 @finish_spills(i32 %global) #21
  %or = or i32 %call784, %something_changed.2
  br label %if.end785

if.end785:                                        ; preds = %if.then783, %if.end778
  %something_changed.3 = phi i32 [ %or, %if.then783 ], [ %something_changed.2, %if.end778 ]
  %tobool786.not = icmp eq i32 %something_changed.3, 0
  br i1 %tobool786.not, label %for.end810, label %if.end788

if.end788:                                        ; preds = %if.end785
  %130 = load i32, i32* @caller_save_needed, align 4, !tbaa !16
  %tobool789.not = icmp eq i32 %130, 0
  br i1 %tobool789.not, label %if.end791, label %if.then790

if.then790:                                       ; preds = %if.end788
  tail call fastcc void @delete_caller_save_insns() #21
  br label %if.end791

if.end791:                                        ; preds = %if.then790, %if.end788
  %131 = load i8*, i8** @reload_firstobj, align 4, !tbaa !15
  %132 = load i8*, i8** bitcast (%struct._obstack_chunk** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 1) to i8**), align 4, !tbaa !14
  %cmp794 = icmp ugt i8* %131, %132
  %133 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 4), align 4
  %cmp798 = icmp ult i8* %131, %133
  %or.cond1576 = select i1 %cmp794, i1 %cmp798, i1 false
  br i1 %or.cond1576, label %if.then800, label %if.else803

if.then800:                                       ; preds = %if.end791
  store i8* %131, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 2), align 4, !tbaa !12
  store i8* %131, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4, !tbaa !11
  br label %for.cond445.backedge

for.cond445.backedge:                             ; preds = %if.else803, %if.then800, %if.end696
  br label %for.cond445, !llvm.loop !41

if.else803:                                       ; preds = %if.end791
  tail call void @obstack_free(%struct.obstack* nonnull @reload_obstack, i8* %131) #20
  br label %for.cond445.backedge

for.end810:                                       ; preds = %if.end785
  %tobool811.not = icmp eq i32 %global, 0
  br i1 %tobool811.not, label %if.end826, label %for.body817.preheader

for.body817.preheader:                            ; preds = %for.end810
  %134 = load %struct.elim_table*, %struct.elim_table** @reg_eliminate, align 4, !tbaa !15
  br label %for.body817

for.body817:                                      ; preds = %for.inc823, %for.body817.preheader
  %135 = phi %struct.elim_table* [ %139, %for.inc823 ], [ %134, %for.body817.preheader ]
  %ep.11619 = phi %struct.elim_table* [ %incdec.ptr824, %for.inc823 ], [ %134, %for.body817.preheader ]
  %can_eliminate818 = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.11619, i32 0, i32 3
  %136 = load i32, i32* %can_eliminate818, align 4, !tbaa !27
  %tobool819.not = icmp eq i32 %136, 0
  br i1 %tobool819.not, label %for.inc823, label %if.then820

if.then820:                                       ; preds = %for.body817
  %from821 = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.11619, i32 0, i32 0
  %137 = load i32, i32* %from821, align 4, !tbaa !29
  %to = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.11619, i32 0, i32 1
  %138 = load i32, i32* %to, align 4, !tbaa !42
  tail call void @mark_elimination(i32 %137, i32 %138) #20
  %.pre1661 = load %struct.elim_table*, %struct.elim_table** @reg_eliminate, align 4, !tbaa !15
  br label %for.inc823

for.inc823:                                       ; preds = %if.then820, %for.body817
  %139 = phi %struct.elim_table* [ %135, %for.body817 ], [ %.pre1661, %if.then820 ]
  %incdec.ptr824 = getelementptr inbounds %struct.elim_table, %struct.elim_table* %ep.11619, i32 1
  %arrayidx814 = getelementptr inbounds %struct.elim_table, %struct.elim_table* %139, i32 4
  %cmp815 = icmp ult %struct.elim_table* %incdec.ptr824, %arrayidx814
  br i1 %cmp815, label %for.body817, label %if.end826, !llvm.loop !43

if.end826:                                        ; preds = %for.inc823, %for.end810
  %140 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp8281613 = icmp sgt i32 %140, 53
  br i1 %cmp8281613, label %for.body830, label %for.end883

for.body830:                                      ; preds = %for.inc881, %if.end826
  %141 = phi i32 [ %154, %for.inc881 ], [ %140, %if.end826 ]
  %i.61614 = phi i32 [ %inc882, %for.inc881 ], [ 53, %if.end826 ]
  %142 = load i16*, i16** @reg_renumber, align 4, !tbaa !15
  %arrayidx831 = getelementptr inbounds i16, i16* %142, i32 %i.61614
  %143 = load i16, i16* %arrayidx831, align 2, !tbaa !34
  %cmp833 = icmp slt i16 %143, 0
  br i1 %cmp833, label %land.lhs.true835, label %for.inc881

land.lhs.true835:                                 ; preds = %for.body830
  %144 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_init, align 4, !tbaa !15
  %arrayidx836 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %144, i32 %i.61614
  %145 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx836, align 4, !tbaa !15
  %cmp837.not = icmp eq %struct.rtx_def* %145, null
  br i1 %cmp837.not, label %for.inc881, label %for.body843

for.body843:                                      ; preds = %if.end874, %land.lhs.true835
  %list.01612 = phi %struct.rtx_def* [ %153, %if.end874 ], [ %145, %land.lhs.true835 ]
  %fld844 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %list.01612, i32 0, i32 1
  %rtx846 = bitcast [1 x %union.anon]* %fld844 to %struct.rtx_def**
  %146 = load %struct.rtx_def*, %struct.rtx_def** %rtx846, align 4, !tbaa !19
  %147 = getelementptr %struct.rtx_def, %struct.rtx_def* %146, i32 0, i32 0
  %bf.load847 = load i32, i32* %147, align 4
  %bf.clear848 = and i32 %bf.load847, 65535
  %cmp849 = icmp eq i32 %bf.clear848, 37
  br i1 %cmp849, label %if.end874, label %lor.lhs.false851

lor.lhs.false851:                                 ; preds = %for.body843
  %call852 = tail call zeroext i1 @can_throw_internal(%struct.rtx_def* nonnull %146) #20
  br i1 %call852, label %if.end874, label %if.else855

if.else855:                                       ; preds = %lor.lhs.false851
  %148 = load %struct.function*, %struct.function** @cfun, align 4, !tbaa !15
  %emit856 = getelementptr inbounds %struct.function, %struct.function* %148, i32 0, i32 3
  %149 = load %struct.emit_status*, %struct.emit_status** %emit856, align 4, !tbaa !36
  %x_regno_reg_rtx857 = getelementptr inbounds %struct.emit_status, %struct.emit_status* %149, i32 0, i32 12
  %150 = load %struct.rtx_def**, %struct.rtx_def*** %x_regno_reg_rtx857, align 4, !tbaa !37
  %arrayidx858 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %150, i32 %i.61614
  %151 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx858, align 4, !tbaa !15
  %arrayidx860 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %146, i32 0, i32 1, i32 3
  %rtx861 = bitcast %union.anon* %arrayidx860 to %struct.rtx_def**
  %152 = load %struct.rtx_def*, %struct.rtx_def** %rtx861, align 4, !tbaa !19
  %call862 = tail call i32 @reg_set_p(%struct.rtx_def* %151, %struct.rtx_def* %152) #20
  %tobool863.not = icmp eq i32 %call862, 0
  br i1 %tobool863.not, label %if.else865, label %if.then864

if.then864:                                       ; preds = %if.else855
  tail call fastcc void @delete_dead_insn(%struct.rtx_def* nonnull %146) #21
  br label %if.end874

if.else865:                                       ; preds = %if.else855
  %bf.load866 = load i32, i32* %147, align 4
  %bf.clear867 = and i32 %bf.load866, -65536
  %bf.set868 = or i32 %bf.clear867, 37
  store i32 %bf.set868, i32* %147, align 4
  %rtstr = bitcast %union.anon* %arrayidx860 to i8**
  store i8* null, i8** %rtstr, align 4, !tbaa !19
  %arrayidx872 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %146, i32 0, i32 1, i32 4
  %rtint = bitcast %union.anon* %arrayidx872 to i32*
  store i32 -99, i32* %rtint, align 4, !tbaa !19
  br label %if.end874

if.end874:                                        ; preds = %if.else865, %if.then864, %lor.lhs.false851, %for.body843
  %arrayidx877 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %list.01612, i32 0, i32 1, i32 1
  %rtx878 = bitcast %union.anon* %arrayidx877 to %struct.rtx_def**
  %153 = load %struct.rtx_def*, %struct.rtx_def** %rtx878, align 4, !tbaa !19
  %tobool842.not = icmp eq %struct.rtx_def* %153, null
  br i1 %tobool842.not, label %for.inc881.loopexit, label %for.body843, !llvm.loop !44

for.inc881.loopexit:                              ; preds = %if.end874
  %.pre1662 = load i32, i32* @max_regno, align 4, !tbaa !16
  br label %for.inc881

for.inc881:                                       ; preds = %for.inc881.loopexit, %land.lhs.true835, %for.body830
  %154 = phi i32 [ %.pre1662, %for.inc881.loopexit ], [ %141, %for.body830 ], [ %141, %land.lhs.true835 ]
  %inc882 = add nuw nsw i32 %i.61614, 1
  %cmp828 = icmp slt i32 %inc882, %154
  br i1 %cmp828, label %for.body830, label %for.end883, !llvm.loop !45

for.end883:                                       ; preds = %for.inc881, %if.end826
  %155 = load %struct.insn_chain*, %struct.insn_chain** @insns_need_reload, align 4, !tbaa !15
  %cmp884 = icmp ne %struct.insn_chain* %155, null
  %.b1571 = load i1, i1* @something_needs_elimination, align 4
  %or.cond1239 = select i1 %cmp884, i1 true, i1 %.b1571
  %156 = load i32, i32* @something_needs_operands_changed, align 4
  %tobool889 = icmp ne i32 %156, 0
  %or.cond1240 = select i1 %or.cond1239, i1 true, i1 %tobool889
  br i1 %or.cond1240, label %if.then890, label %if.end900

if.then890:                                       ; preds = %for.end883
  %call891 = tail call i64 @get_frame_size() #20
  tail call fastcc void @reload_as_needed(i32 %global) #21
  %call892 = tail call i64 @get_frame_size() #20
  %cmp893.not = icmp eq i64 %call891, %call892
  br i1 %cmp893.not, label %if.end896, label %if.then895

if.then895:                                       ; preds = %if.then890
  tail call void @fancy_abort(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1.2375, i32 0, i32 0), i32 1113, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @__FUNCTION__.reload, i32 0, i32 0)) #23
  unreachable

if.end896:                                        ; preds = %if.then890
  %157 = load i32, i32* @num_eliminable, align 4, !tbaa !16
  %tobool897.not = icmp eq i32 %157, 0
  br i1 %tobool897.not, label %if.end900, label %if.then898

if.then898:                                       ; preds = %if.end896
  tail call fastcc void @verify_initial_elim_offsets() #21
  br label %if.end900

if.end900:                                        ; preds = %if.then898, %if.end896, %for.end883
  %158 = load i32, i32* @frame_pointer_needed, align 4, !tbaa !16
  %tobool901.not = icmp eq i32 %158, 0
  %159 = load i32, i32* @n_basic_blocks, align 4
  %cmp9041609 = icmp sgt i32 %159, 0
  %or.cond1648 = select i1 %tobool901.not, i1 %cmp9041609, i1 false
  br i1 %or.cond1648, label %for.body906, label %failed

for.body906:                                      ; preds = %for.body906, %if.end900
  %i.71610 = phi i32 [ %inc909, %for.body906 ], [ 0, %if.end900 ]
  %160 = load %struct.varray_head_tag*, %struct.varray_head_tag** @basic_block_info, align 4, !tbaa !15
  %data = getelementptr inbounds %struct.varray_head_tag, %struct.varray_head_tag* %160, i32 0, i32 4
  %bb = bitcast %union.varray_data_tag* %data to [1 x %struct.basic_block_def*]*
  %arrayidx907 = getelementptr inbounds [1 x %struct.basic_block_def*], [1 x %struct.basic_block_def*]* %bb, i32 0, i32 %i.71610
  %161 = load %struct.basic_block_def*, %struct.basic_block_def** %arrayidx907, align 4, !tbaa !19
  %global_live_at_start = getelementptr inbounds %struct.basic_block_def, %struct.basic_block_def* %161, i32 0, i32 8
  %162 = load %struct.bitmap_head_def*, %struct.bitmap_head_def** %global_live_at_start, align 4, !tbaa !46
  tail call void @bitmap_clear_bit(%struct.bitmap_head_def* %162, i32 6) #20
  %inc909 = add nuw nsw i32 %i.71610, 1
  %163 = load i32, i32* @n_basic_blocks, align 4, !tbaa !16
  %cmp904 = icmp slt i32 %inc909, %163
  br i1 %cmp904, label %for.body906, label %failed, !llvm.loop !48

failed:                                           ; preds = %for.body906, %if.end900, %for.end775
  tail call void @bitmap_clear(%struct.bitmap_head_def* nonnull @spilled_pseudos) #20
  store i32 0, i32* @reload_in_progress, align 4, !tbaa !16
  %164 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp9131606 = icmp sgt i32 %164, 53
  br i1 %cmp9131606, label %for.body915, label %for.end1022

for.body915:                                      ; preds = %if.end1019, %failed
  %i.81607 = phi i32 [ %inc1021, %if.end1019 ], [ 53, %failed ]
  %165 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_mem, align 4, !tbaa !15
  %arrayidx916 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %165, i32 %i.81607
  %166 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx916, align 4, !tbaa !15
  %tobool917.not = icmp eq %struct.rtx_def* %166, null
  br i1 %tobool917.not, label %if.end923, label %if.then918

if.then918:                                       ; preds = %for.body915
  %arrayidx921 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %166, i32 0, i32 1, i32 0
  %rtx922 = bitcast %union.anon* %arrayidx921 to %struct.rtx_def**
  %167 = load %struct.rtx_def*, %struct.rtx_def** %rtx922, align 4, !tbaa !19
  br label %if.end923

if.end923:                                        ; preds = %if.then918, %for.body915
  %addr.0 = phi %struct.rtx_def* [ %167, %if.then918 ], [ null, %for.body915 ]
  %168 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_address, align 4, !tbaa !15
  %arrayidx924 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %168, i32 %i.81607
  %169 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx924, align 4, !tbaa !15
  %tobool925.not = icmp eq %struct.rtx_def* %169, null
  %spec.select1577 = select i1 %tobool925.not, %struct.rtx_def* %addr.0, %struct.rtx_def* %169
  %tobool929.not = icmp eq %struct.rtx_def* %spec.select1577, null
  br i1 %tobool929.not, label %if.end1019, label %if.then930

if.then930:                                       ; preds = %if.end923
  %170 = load i16*, i16** @reg_renumber, align 4, !tbaa !15
  %arrayidx931 = getelementptr inbounds i16, i16* %170, i32 %i.81607
  %171 = load i16, i16* %arrayidx931, align 2, !tbaa !34
  %cmp933 = icmp slt i16 %171, 0
  br i1 %cmp933, label %if.then935, label %if.else1009

if.then935:                                       ; preds = %if.then930
  %172 = load %struct.function*, %struct.function** @cfun, align 4, !tbaa !15
  %emit936 = getelementptr inbounds %struct.function, %struct.function* %172, i32 0, i32 3
  %173 = load %struct.emit_status*, %struct.emit_status** %emit936, align 4, !tbaa !36
  %x_regno_reg_rtx937 = getelementptr inbounds %struct.emit_status, %struct.emit_status* %173, i32 0, i32 12
  %174 = load %struct.rtx_def**, %struct.rtx_def*** %x_regno_reg_rtx937, align 4, !tbaa !37
  %arrayidx938 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %174, i32 %i.81607
  %175 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx938, align 4, !tbaa !15
  %176 = getelementptr %struct.rtx_def, %struct.rtx_def* %175, i32 0, i32 0
  %bf.load939 = load i32, i32* %176, align 4
  %bf.clear940 = and i32 %bf.load939, -65536
  %bf.set941 = or i32 %bf.clear940, 66
  %fld942 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %175, i32 0, i32 1
  %rtx944 = bitcast [1 x %union.anon]* %fld942 to %struct.rtx_def**
  store %struct.rtx_def* %spec.select1577, %struct.rtx_def** %rtx944, align 4, !tbaa !19
  %bf.clear946 = and i32 %bf.set941, -134283198
  store i32 %bf.clear946, i32* %176, align 4
  %177 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx947 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %177, i32 %i.81607
  %178 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx947, align 4, !tbaa !15
  %tobool948.not = icmp eq %struct.rtx_def* %178, null
  br i1 %tobool948.not, label %if.else998, label %if.then949

if.then949:                                       ; preds = %if.then935
  %179 = getelementptr %struct.rtx_def, %struct.rtx_def* %178, i32 0, i32 0
  %bf.load951 = load i32, i32* %179, align 4
  %bf.clear953 = and i32 %bf.load951, 134217728
  %bf.set956 = or i32 %bf.clear953, %bf.clear946
  store i32 %bf.set956, i32* %176, align 4
  %180 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx957 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %180, i32 %i.81607
  %181 = bitcast %struct.rtx_def** %arrayidx957 to i32**
  %182 = load i32*, i32** %181, align 4, !tbaa !15
  %bf.load958 = load i32, i32* %182, align 4
  %bf.clear960 = and i32 %bf.load958, 268435456
  %bf.clear964 = and i32 %bf.set956, -268500926
  %bf.set965 = or i32 %bf.clear960, %bf.clear964
  store i32 %bf.set965, i32* %176, align 4
  %183 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx966 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %183, i32 %i.81607
  %184 = bitcast %struct.rtx_def** %arrayidx966 to i32**
  %185 = load i32*, i32** %184, align 4, !tbaa !15
  %bf.load967 = load i32, i32* %185, align 4
  %bf.lshr968 = and i32 %bf.load967, -2147483648
  %bf.clear972 = and i32 %bf.set965, 2147418178
  %bf.set973 = or i32 %bf.lshr968, %bf.clear972
  store i32 %bf.set973, i32* %176, align 4
  %186 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx974 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %186, i32 %i.81607
  %187 = bitcast %struct.rtx_def** %arrayidx974 to i32**
  %188 = load i32*, i32** %187, align 4, !tbaa !15
  %bf.load975 = load i32, i32* %188, align 4
  %bf.clear977 = and i32 %bf.load975, 67108864
  %bf.clear981 = and i32 %bf.set973, -67174334
  %bf.set982 = or i32 %bf.clear977, %bf.clear981
  store i32 %bf.set982, i32* %176, align 4
  %189 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx983 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %189, i32 %i.81607
  %190 = bitcast %struct.rtx_def** %arrayidx983 to i32**
  %191 = load i32*, i32** %190, align 4, !tbaa !15
  %bf.load984 = load i32, i32* %191, align 4
  %bf.clear986 = and i32 %bf.load984, 16777216
  %bf.clear990 = and i32 %bf.set982, -16842686
  %bf.set991 = or i32 %bf.clear986, %bf.clear990
  store i32 %bf.set991, i32* %176, align 4
  %192 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %arrayidx992 = getelementptr inbounds %struct.rtx_def*, %struct.rtx_def** %192, i32 %i.81607
  %193 = load %struct.rtx_def*, %struct.rtx_def** %arrayidx992, align 4, !tbaa !15
  %arrayidx994 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %193, i32 0, i32 1, i32 1
  %rtmem = bitcast %union.anon* %arrayidx994 to %struct.mem_attrs**
  %194 = load %struct.mem_attrs*, %struct.mem_attrs** %rtmem, align 4, !tbaa !19
  %arrayidx996 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %175, i32 0, i32 1, i32 1
  %rtmem997 = bitcast %union.anon* %arrayidx996 to %struct.mem_attrs**
  store %struct.mem_attrs* %194, %struct.mem_attrs** %rtmem997, align 4, !tbaa !19
  br label %if.end1019

if.else998:                                       ; preds = %if.then935
  %bf.clear1004 = and i32 %bf.set941, 1677656130
  store i32 %bf.clear1004, i32* %176, align 4
  %arrayidx1006 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %175, i32 0, i32 1, i32 1
  %rtmem1007 = bitcast %union.anon* %arrayidx1006 to %struct.mem_attrs**
  store %struct.mem_attrs* null, %struct.mem_attrs** %rtmem1007, align 4, !tbaa !19
  br label %if.end1019

if.else1009:                                      ; preds = %if.then930
  br i1 %tobool917.not, label %if.end1019, label %if.then1012

if.then1012:                                      ; preds = %if.else1009
  %arrayidx1015 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %166, i32 0, i32 1, i32 0
  %rtx1016 = bitcast %union.anon* %arrayidx1015 to %struct.rtx_def**
  store %struct.rtx_def* %spec.select1577, %struct.rtx_def** %rtx1016, align 4, !tbaa !19
  br label %if.end1019

if.end1019:                                       ; preds = %if.then1012, %if.else1009, %if.else998, %if.then949, %if.end923
  %inc1021 = add nuw nsw i32 %i.81607, 1
  %195 = load i32, i32* @max_regno, align 4, !tbaa !16
  %cmp913 = icmp slt i32 %inc1021, %195
  br i1 %cmp913, label %for.body915, label %for.end1022, !llvm.loop !49

for.end1022:                                      ; preds = %if.end1019, %failed
  store i32 1, i32* @reload_completed, align 4, !tbaa !16
  br i1 %tobool56.not1639, label %for.end1145, label %for.body1025

for.body1025:                                     ; preds = %for.inc1141, %for.end1022
  %insn.21602 = phi %struct.rtx_def* [ %213, %for.inc1141 ], [ %first, %for.end1022 ]
  %196 = getelementptr %struct.rtx_def, %struct.rtx_def* %insn.21602, i32 0, i32 0
  %bf.load1026 = load i32, i32* %196, align 4
  %bf.clear1027 = and i32 %bf.load1026, 65535
  %arrayidx1028 = getelementptr inbounds [153 x i8], [153 x i8]* @rtx_class, i32 0, i32 %bf.clear1027
  %197 = load i8, i8* %arrayidx1028, align 1, !tbaa !19
  %cmp1030 = icmp eq i8 %197, 105
  br i1 %cmp1030, label %if.then1032, label %for.inc1141

if.then1032:                                      ; preds = %for.body1025
  %cmp1035 = icmp eq i32 %bf.clear1027, 34
  br i1 %cmp1035, label %if.then1037, label %if.end1044

if.then1037:                                      ; preds = %if.then1032
  %arrayidx1039 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.21602, i32 0, i32 1, i32 7
  %rtx1040 = bitcast %union.anon* %arrayidx1039 to %struct.rtx_def**
  %198 = load %struct.rtx_def*, %struct.rtx_def** %rtx1040, align 4, !tbaa !19
  tail call fastcc void @replace_pseudos_in_call_usage(%struct.rtx_def** nonnull %rtx1040, i32 0, %struct.rtx_def* %198) #21
  br label %if.end1044

if.end1044:                                       ; preds = %if.then1037, %if.then1032
  %arrayidx1046 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.21602, i32 0, i32 1, i32 3
  %rtx1047 = bitcast %union.anon* %arrayidx1046 to %struct.rtx_def**
  %199 = bitcast %union.anon* %arrayidx1046 to i32**
  %200 = load i32*, i32** %199, align 4, !tbaa !19
  %bf.load1048 = load i32, i32* %200, align 4
  %bf.clear1049 = and i32 %bf.load1048, 65535
  %cmp1050 = icmp eq i32 %bf.clear1049, 48
  %201 = bitcast i32* %200 to %struct.rtx_def*
  br i1 %cmp1050, label %land.lhs.true1052, label %lor.lhs.false1061

land.lhs.true1052:                                ; preds = %if.end1044
  %bf.load1053 = load i32, i32* %196, align 4
  %202 = and i32 %bf.load1053, 16711680
  %cmp1056 = icmp eq i32 %202, 131072
  br i1 %cmp1056, label %if.then1091, label %lor.lhs.false1058

lor.lhs.false1058:                                ; preds = %land.lhs.true1052
  %call1059 = tail call %struct.rtx_def* @find_reg_note(%struct.rtx_def* nonnull %insn.21602, i32 4, %struct.rtx_def* null) #20
  %tobool1060.not = icmp eq %struct.rtx_def* %call1059, null
  br i1 %tobool1060.not, label %lor.lhs.false1058.lor.lhs.false1061_crit_edge, label %if.then1091

lor.lhs.false1058.lor.lhs.false1061_crit_edge:    ; preds = %lor.lhs.false1058
  %.pre1663 = load %struct.rtx_def*, %struct.rtx_def** %rtx1047, align 4, !tbaa !19
  br label %lor.lhs.false1061

lor.lhs.false1061:                                ; preds = %lor.lhs.false1058.lor.lhs.false1061_crit_edge, %if.end1044
  %203 = phi %struct.rtx_def* [ %.pre1663, %lor.lhs.false1058.lor.lhs.false1061_crit_edge ], [ %201, %if.end1044 ]
  %204 = getelementptr %struct.rtx_def, %struct.rtx_def* %203, i32 0, i32 0
  %bf.load1065 = load i32, i32* %204, align 4
  %bf.clear1066 = and i32 %bf.load1065, 65535
  %cmp1067 = icmp eq i32 %bf.clear1066, 49
  br i1 %cmp1067, label %land.lhs.true1069, label %if.end1093

land.lhs.true1069:                                ; preds = %lor.lhs.false1061
  %arrayidx1074 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %203, i32 0, i32 1, i32 0
  %205 = bitcast %union.anon* %arrayidx1074 to i32**
  %206 = load i32*, i32** %205, align 4, !tbaa !19
  %bf.load1076 = load i32, i32* %206, align 4
  %207 = and i32 %bf.load1076, 1073807359
  %.not = icmp eq i32 %207, 1073741885
  br i1 %.not, label %if.end1093, label %if.then1091

if.then1091:                                      ; preds = %land.lhs.true1069, %lor.lhs.false1058, %land.lhs.true1052
  %call1092 = tail call %struct.rtx_def* @delete_insn(%struct.rtx_def* nonnull %insn.21602) #20
  br label %for.inc1141

if.end1093:                                       ; preds = %land.lhs.true1069, %lor.lhs.false1061
  %arrayidx1095 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.21602, i32 0, i32 1, i32 6
  %rtx1096 = bitcast %union.anon* %arrayidx1095 to %struct.rtx_def**
  %208 = load %struct.rtx_def*, %struct.rtx_def** %rtx1096, align 4, !tbaa !15
  %cmp1097.not1599 = icmp eq %struct.rtx_def* %208, null
  br i1 %cmp1097.not1599, label %while.end, label %while.body

while.body:                                       ; preds = %if.end1136, %if.end1093
  %209 = phi %struct.rtx_def* [ %212, %if.end1136 ], [ %208, %if.end1093 ]
  %pnote.01600 = phi %struct.rtx_def** [ %pnote.1, %if.end1136 ], [ %rtx1096, %if.end1093 ]
  %210 = getelementptr %struct.rtx_def, %struct.rtx_def* %209, i32 0, i32 0
  %bf.load1099 = load i32, i32* %210, align 4
  %bf.lshr1100 = lshr i32 %bf.load1099, 16
  %trunc1589 = trunc i32 %bf.lshr1100 to i8
  switch i8 %trunc1589, label %if.else1132 [
    i8 1, label %if.then1128
    i8 10, label %if.then1128
    i8 2, label %if.then1128
    i8 6, label %if.then1128
    i8 7, label %if.then1128
  ]

if.then1128:                                      ; preds = %while.body, %while.body, %while.body, %while.body, %while.body
  %arrayidx1130 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %209, i32 0, i32 1, i32 1
  %rtx1131 = bitcast %union.anon* %arrayidx1130 to %struct.rtx_def**
  %211 = load %struct.rtx_def*, %struct.rtx_def** %rtx1131, align 4, !tbaa !19
  store %struct.rtx_def* %211, %struct.rtx_def** %pnote.01600, align 4, !tbaa !15
  br label %if.end1136

if.else1132:                                      ; preds = %while.body
  %arrayidx1134 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %209, i32 0, i32 1, i32 1
  %rtx1135 = bitcast %union.anon* %arrayidx1134 to %struct.rtx_def**
  %.pre1664 = load %struct.rtx_def*, %struct.rtx_def** %rtx1135, align 4, !tbaa !15
  br label %if.end1136

if.end1136:                                       ; preds = %if.else1132, %if.then1128
  %212 = phi %struct.rtx_def* [ %211, %if.then1128 ], [ %.pre1664, %if.else1132 ]
  %pnote.1 = phi %struct.rtx_def** [ %pnote.01600, %if.then1128 ], [ %rtx1135, %if.else1132 ]
  %cmp1097.not = icmp eq %struct.rtx_def* %212, null
  br i1 %cmp1097.not, label %while.end, label %while.body, !llvm.loop !50

while.end:                                        ; preds = %if.end1136, %if.end1093
  tail call void @cleanup_subreg_operands(%struct.rtx_def* nonnull %insn.21602) #20
  br label %for.inc1141

for.inc1141:                                      ; preds = %while.end, %if.then1091, %for.body1025
  %arrayidx1143 = getelementptr inbounds %struct.rtx_def, %struct.rtx_def* %insn.21602, i32 0, i32 1, i32 2
  %rtx1144 = bitcast %union.anon* %arrayidx1143 to %struct.rtx_def**
  %213 = load %struct.rtx_def*, %struct.rtx_def** %rtx1144, align 4, !tbaa !19
  %tobool1024.not = icmp eq %struct.rtx_def* %213, null
  br i1 %tobool1024.not, label %for.end1145, label %for.body1025, !llvm.loop !51

for.end1145:                                      ; preds = %for.inc1141, %for.end1022
  %214 = load i32, i32* @flag_stack_check, align 4, !tbaa !16
  %tobool1146.not = icmp eq i32 %214, 0
  br i1 %tobool1146.not, label %if.end1191, label %if.then1147

if.then1147:                                      ; preds = %for.end1145
  %call1148 = tail call i64 @get_frame_size() #20
  %215 = load i32, i32* @target_flags, align 4, !tbaa !16
  %and1149 = and i32 %215, 33554432
  %tobool1150.not = icmp eq i32 %and1149, 0
  %mul1152 = select i1 %tobool1150.not, i32 16, i32 32
  %216 = zext i32 %mul1152 to i64
  %add1154 = add nsw i64 %call1148, %216
  %cond1172 = select i1 %tobool1150.not, i32 4, i32 8
  %217 = zext i32 %cond1172 to i64
  br label %for.body1158

for.body1158:                                     ; preds = %for.inc1176, %if.then1147
  %i.91597 = phi i32 [ 0, %if.then1147 ], [ %inc1177, %for.inc1176 ]
  %size.01596 = phi i64 [ %add1154, %if.then1147 ], [ %size.1, %for.inc1176 ]
  %arrayidx1159 = getelementptr inbounds [53 x i8], [53 x i8]* @regs_ever_live, i32 0, i32 %i.91597
  %218 = load i8, i8* %arrayidx1159, align 1, !tbaa !19
  %tobool1161.not = icmp eq i8 %218, 0
  br i1 %tobool1161.not, label %for.inc1176, label %land.lhs.true1162

land.lhs.true1162:                                ; preds = %for.body1158
  %arrayidx1163 = getelementptr inbounds [53 x i8], [53 x i8]* @fixed_regs, i32 0, i32 %i.91597
  %219 = load i8, i8* %arrayidx1163, align 1, !tbaa !19
  %tobool1164.not = icmp eq i8 %219, 0
  br i1 %tobool1164.not, label %land.lhs.true1165, label %for.inc1176

land.lhs.true1165:                                ; preds = %land.lhs.true1162
  %arrayidx1166 = getelementptr inbounds [53 x i8], [53 x i8]* @call_used_regs, i32 0, i32 %i.91597
  %220 = load i8, i8* %arrayidx1166, align 1, !tbaa !19
  %tobool1168.not = icmp eq i8 %220, 0
  %add1174 = select i1 %tobool1168.not, i64 0, i64 %217
  %spec.select1647 = add nsw i64 %size.01596, %add1174
  br label %for.inc1176

for.inc1176:                                      ; preds = %land.lhs.true1165, %land.lhs.true1162, %for.body1158
  %size.1 = phi i64 [ %size.01596, %land.lhs.true1162 ], [ %size.01596, %for.body1158 ], [ %spec.select1647, %land.lhs.true1165 ]
  %inc1177 = add nuw nsw i32 %i.91597, 1
  %exitcond1651.not = icmp eq i32 %inc1177, 53
  br i1 %exitcond1651.not, label %for.end1178, label %for.body1158, !llvm.loop !52

for.end1178:                                      ; preds = %for.inc1176
  %sub1182 = select i1 %tobool1150.not, i32 4092, i32 4088
  %221 = zext i32 %sub1182 to i64
  %cmp1184 = icmp sgt i64 %size.1, %221
  br i1 %cmp1184, label %if.then1186, label %if.end1191

if.then1186:                                      ; preds = %for.end1178
  tail call void (i8*, ...) @warning(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.2.2378, i32 0, i32 0)) #20
  %.b1572 = load i1, i1* @reload.verbose_warned, align 4
  br i1 %.b1572, label %if.end1191, label %if.then1188

if.then1188:                                      ; preds = %if.then1186
  tail call void (i8*, ...) @warning(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.3.2379, i32 0, i32 0)) #20
  store i1 true, i1* @reload.verbose_warned, align 4
  br label %if.end1191

if.end1191:                                       ; preds = %if.then1188, %if.then1186, %for.end1178, %for.end1145
  %222 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_constant, align 4, !tbaa !15
  %tobool1192.not = icmp eq %struct.rtx_def** %222, null
  br i1 %tobool1192.not, label %if.end1194, label %if.then1193

if.then1193:                                      ; preds = %if.end1191
  %223 = bitcast %struct.rtx_def** %222 to i8*
  tail call void @free(i8* %223) #20
  br label %if.end1194

if.end1194:                                       ; preds = %if.then1193, %if.end1191
  store %struct.rtx_def** null, %struct.rtx_def*** @reg_equiv_constant, align 4, !tbaa !15
  %224 = load %struct.rtx_def**, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %tobool1195.not = icmp eq %struct.rtx_def** %224, null
  br i1 %tobool1195.not, label %if.end1197, label %if.then1196

if.then1196:                                      ; preds = %if.end1194
  %225 = bitcast %struct.rtx_def** %224 to i8*
  tail call void @free(i8* %225) #20
  br label %if.end1197

if.end1197:                                       ; preds = %if.then1196, %if.end1194
  store %struct.rtx_def** null, %struct.rtx_def*** @reg_equiv_memory_loc, align 4, !tbaa !15
  %tobool1198.not = icmp eq i8* %call387, null
  br i1 %tobool1198.not, label %if.end1200, label %if.then1199

if.then1199:                                      ; preds = %if.end1197
  tail call void @free(i8* nonnull %call387) #20
  br label %if.end1200

if.end1200:                                       ; preds = %if.then1199, %if.end1197
  %tobool1201.not = icmp eq i8* %call390, null
  br i1 %tobool1201.not, label %if.end1203, label %if.then1202

if.then1202:                                      ; preds = %if.end1200
  tail call void @free(i8* nonnull %call390) #20
  br label %if.end1203

if.end1203:                                       ; preds = %if.then1202, %if.end1200
  %226 = load i8*, i8** bitcast (%struct.rtx_def*** @reg_equiv_mem to i8**), align 4, !tbaa !15
  tail call void @free(i8* %226) #20
  %227 = load i8*, i8** bitcast (%struct.rtx_def*** @reg_equiv_init to i8**), align 4, !tbaa !15
  tail call void @free(i8* %227) #20
  %228 = load i8*, i8** bitcast (%struct.rtx_def*** @reg_equiv_address to i8**), align 4, !tbaa !15
  tail call void @free(i8* %228) #20
  %229 = load i8*, i8** bitcast (i32** @reg_max_ref_width to i8**), align 4, !tbaa !15
  tail call void @free(i8* %229) #20
  %230 = load i8*, i8** bitcast (i16** @reg_old_renumber to i8**), align 4, !tbaa !15
  tail call void @free(i8* %230) #20
  %231 = load i8*, i8** bitcast (i64** @pseudo_previous_regs to i8**), align 4, !tbaa !15
  tail call void @free(i8* %231) #20
  %232 = load i8*, i8** bitcast (i64** @pseudo_forbidden_regs to i8**), align 4, !tbaa !15
  tail call void @free(i8* %232) #20
  store i64 0, i64* @used_spill_regs, align 8, !tbaa !21
  %233 = load i32, i32* @n_spills, align 4, !tbaa !16
  %cmp12051593 = icmp sgt i32 %233, 0
  br i1 %cmp12051593, label %for.body1207, label %for.end1215

for.body1207:                                     ; preds = %for.body1207, %if.end1203
  %or12121595 = phi i64 [ %or1212, %for.body1207 ], [ 0, %if.end1203 ]
  %i.101594 = phi i32 [ %inc1214, %for.body1207 ], [ 0, %if.end1203 ]
  %arrayidx1208 = getelementptr inbounds [53 x i16], [53 x i16]* @spill_regs, i32 0, i32 %i.101594
  %234 = load i16, i16* %arrayidx1208, align 2, !tbaa !34
  %conv1209 = sext i16 %234 to i32
  %sh_prom1210 = zext i32 %conv1209 to i64
  %shl1211 = shl nuw i64 1, %sh_prom1210
  %or1212 = or i64 %shl1211, %or12121595
  %inc1214 = add nuw nsw i32 %i.101594, 1
  %exitcond.not = icmp eq i32 %inc1214, %233
  br i1 %exitcond.not, label %for.cond1204.for.end1215_crit_edge, label %for.body1207, !llvm.loop !53

for.cond1204.for.end1215_crit_edge:               ; preds = %for.body1207
  store i64 %or1212, i64* @used_spill_regs, align 8, !tbaa !21
  br label %for.end1215

for.end1215:                                      ; preds = %for.cond1204.for.end1215_crit_edge, %if.end1203
  %235 = load i8*, i8** @reload_startobj, align 4, !tbaa !15
  %236 = load i8*, i8** bitcast (%struct._obstack_chunk** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 1) to i8**), align 4, !tbaa !14
  %cmp1219 = icmp ugt i8* %235, %236
  %237 = load i8*, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 4), align 4
  %cmp1223 = icmp ult i8* %235, %237
  %or.cond1579 = select i1 %cmp1219, i1 %cmp1223, i1 false
  br i1 %or.cond1579, label %if.then1225, label %if.else1228

if.then1225:                                      ; preds = %for.end1215
  store i8* %235, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 2), align 4, !tbaa !12
  store i8* %235, i8** getelementptr inbounds (%struct.obstack, %struct.obstack* @reload_obstack, i32 0, i32 3), align 4, !tbaa !11
  br label %cleanup1230

if.else1228:                                      ; preds = %for.end1215
  tail call void @obstack_free(%struct.obstack* nonnull @reload_obstack, i8* %235) #20
  br label %cleanup1230

cleanup1230:                                      ; preds = %if.else1228, %if.then1225
  store %struct.insn_chain* null, %struct.insn_chain** @unused_insn_chains, align 4, !tbaa !15
  tail call void @fixup_abnormal_edges() #21
  tail call void @unshare_all_rtl_again(%struct.rtx_def* %first) #20
  %.b = load i1, i1* @failure, align 4
  %238 = zext i1 %.b to i32
  ret i32 %238
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare void @mark_home_live(i32) local_unnamed_addr #11

; Function Attrs: nofree noinline nosync nounwind optsize
declare hidden fastcc void @scan_paradoxical_subregs(%struct.rtx_def* nocapture readonly) unnamed_addr #12

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @init_elim_table() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @alter_reg(i32, i32) unnamed_addr #8

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare hidden void @mark_not_eliminable(%struct.rtx_def* readonly, %struct.rtx_def* nocapture readonly, i8* nocapture readnone) #11

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @maybe_fix_stack_asms() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @spill_hard_reg(i32) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc i32 @finish_spills(i32) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @set_initial_elim_offsets() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @set_initial_label_offsets() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @eliminate_regs(%struct.rtx_def*, i32, %struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @calculate_needs_all_insns(i32) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @update_eliminables(i64* nocapture) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @select_reload_regs() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @delete_caller_save_insns() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @delete_dead_insn(%struct.rtx_def*) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @reload_as_needed(i32) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @verify_initial_elim_offsets() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @replace_pseudos_in_call_usage(%struct.rtx_def** nocapture, i32, %struct.rtx_def*) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @fixup_abnormal_edges() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare i32 @comptypes(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_sizeof(%union.tree_node* nocapture readonly) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @default_conversion(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_unary_op(i32, %union.tree_node*, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_modify_expr(%union.tree_node*, i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_conditional_expr(%union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_component_ref(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_indirect_ref(%union.tree_node*, i8*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_array_ref(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_external_ref(%union.tree_node*, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_function_call(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @parser_build_binary_op(i32, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_compound_expr(%union.tree_node* nocapture) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_cast_expr(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @start_init(%union.tree_node*, %union.tree_node* readonly, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @finish_init() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @really_start_incremental_init(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @push_init_level(i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @pop_init_level(i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @process_init_element(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @set_init_index(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @set_init_label(%union.tree_node* readonly) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @simple_asm_stmt(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_asm_stmt(%union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_expand_return(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_start_case(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @do_case(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @c_finish_case() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
define i32 @yyparse_1() local_unnamed_addr #8 {
entry:
  %yyssa = alloca [200 x i16], align 2
  %yyvsa = alloca [200 x %union.anon.2], align 4
  %yyval = alloca %union.anon.2, align 4
  %label4296 = alloca %union.tree_node*, align 4
  %0 = bitcast [200 x i16]* %yyssa to i8*
  call void @llvm.lifetime.start.p0i8(i64 400, i8* nonnull %0) #22
  %1 = bitcast [200 x %union.anon.2]* %yyvsa to i8*
  call void @llvm.lifetime.start.p0i8(i64 800, i8* nonnull %1) #22
  %arraydecay = getelementptr inbounds [200 x i16], [200 x i16]* %yyssa, i32 0, i32 0
  %arraydecay1 = getelementptr inbounds [200 x %union.anon.2], [200 x %union.anon.2]* %yyvsa, i32 0, i32 0
  %2 = bitcast %union.anon.2* %yyval to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %2) #22
  %3 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool.not = icmp eq i32 %3, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %5 = tail call i32 @fwrite(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2678, i32 0, i32 0), i32 15, i32 1, %struct._IO_FILE* %4) #24
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  store i32 0, i32* @yynerrs, align 4, !tbaa !16
  store i32 -2, i32* @yychar, align 4, !tbaa !16
  %add.ptr = getelementptr inbounds [200 x i16], [200 x i16]* %yyssa, i32 0, i32 -1
  %6 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyval, i32 0, i32 0
  %ttype4642 = bitcast %union.anon.2* %yyval to %union.tree_node**
  %7 = bitcast %union.tree_node** %label4296 to i8*
  %filename3930 = bitcast %union.anon.2* %yyval to i8**
  br label %yynewstate

yynewstate:                                       ; preds = %yynewstate.backedge, %if.end
  %yystacksize.0 = phi i32 [ 200, %if.end ], [ %yystacksize.2, %yynewstate.backedge ]
  %yyvs.0 = phi %union.anon.2* [ %arraydecay1, %if.end ], [ %yyvs.2, %yynewstate.backedge ]
  %yyss.0 = phi i16* [ %arraydecay, %if.end ], [ %yyss.2, %yynewstate.backedge ]
  %yychar1.0 = phi i32 [ 0, %if.end ], [ %yychar1.0.be, %yynewstate.backedge ]
  %yyerrstatus.0 = phi i32 [ 0, %if.end ], [ %yyerrstatus.0.be, %yynewstate.backedge ]
  %yyvsp.0 = phi %union.anon.2* [ %arraydecay1, %if.end ], [ %yyvsp.0.be, %yynewstate.backedge ]
  %yyssp.0 = phi i16* [ %add.ptr, %if.end ], [ %yyssp.0.be, %yynewstate.backedge ]
  %yystate.0 = phi i32 [ 0, %if.end ], [ %yystate.0.be, %yynewstate.backedge ]
  %conv = trunc i32 %yystate.0 to i16
  %incdec.ptr = getelementptr inbounds i16, i16* %yyssp.0, i32 1
  store i16 %conv, i16* %incdec.ptr, align 2, !tbaa !34
  %add.ptr3.idx = add nsw i32 %yystacksize.0, -1
  %add.ptr3 = getelementptr inbounds i16, i16* %yyss.0, i32 %add.ptr3.idx
  %cmp.not = icmp ult i16* %incdec.ptr, %add.ptr3
  br i1 %cmp.not, label %if.end37, label %if.then5

if.then5:                                         ; preds = %yynewstate
  %sub.ptr.lhs.cast = ptrtoint i16* %incdec.ptr to i32
  %sub.ptr.rhs.cast = ptrtoint i16* %yyss.0 to i32
  %sub.ptr.sub = sub i32 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %sub.ptr.div = ashr exact i32 %sub.ptr.sub, 1
  %add = add nsw i32 %sub.ptr.div, 1
  %cmp6 = icmp sgt i32 %yystacksize.0, 9999
  br i1 %cmp6, label %cleanup.thread, label %if.end12

cleanup.thread:                                   ; preds = %if.then5
  call fastcc void @yyerror(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1.2679, i32 0, i32 0)) #21
  br label %cleanup4861

if.end12:                                         ; preds = %if.then5
  %mul = shl nsw i32 %yystacksize.0, 1
  %8 = icmp slt i32 %mul, 10000
  %spec.store.select = select i1 %8, i32 %mul, i32 10000
  %mul17 = shl i32 %spec.store.select, 1
  %9 = alloca i8, i32 %mul17, align 16
  %10 = bitcast i8* %9 to i16*
  %11 = bitcast i16* %yyss.0 to i8*
  %mul18 = shl i32 %add, 1
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 16 %9, i8* align 1 %11, i32 %mul18, i1 false)
  %mul19 = shl i32 %spec.store.select, 2
  %12 = alloca i8, i32 %mul19, align 16
  %13 = bitcast i8* %12 to %union.anon.2*
  %14 = bitcast %union.anon.2* %yyvs.0 to i8*
  %mul20 = shl i32 %add, 2
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 16 %12, i8* align 1 %14, i32 %mul20, i1 false)
  %add.ptr22 = getelementptr inbounds i16, i16* %10, i32 %sub.ptr.div
  %add.ptr24 = getelementptr inbounds %union.anon.2, %union.anon.2* %13, i32 %sub.ptr.div
  %15 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool25.not = icmp eq i32 %15, 0
  br i1 %tobool25.not, label %if.end28, label %if.then26

if.then26:                                        ; preds = %if.end12
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %call27 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.2.2680, i32 0, i32 0), i32 %spec.store.select) #25
  br label %if.end28

if.end28:                                         ; preds = %if.then26, %if.end12
  %add.ptr30.idx = add nsw i32 %spec.store.select, -1
  %cmp31.not = icmp slt i32 %sub.ptr.div, %add.ptr30.idx
  br i1 %cmp31.not, label %if.end37, label %cleanup4861

if.end37:                                         ; preds = %if.end28, %yynewstate
  %yystacksize.2 = phi i32 [ %yystacksize.0, %yynewstate ], [ %spec.store.select, %if.end28 ]
  %yyvs.2 = phi %union.anon.2* [ %yyvs.0, %yynewstate ], [ %13, %if.end28 ]
  %yyss.2 = phi i16* [ %yyss.0, %yynewstate ], [ %10, %if.end28 ]
  %yyvsp.2 = phi %union.anon.2* [ %yyvsp.0, %yynewstate ], [ %add.ptr24, %if.end28 ]
  %yyssp.2 = phi i16* [ %incdec.ptr, %yynewstate ], [ %add.ptr22, %if.end28 ]
  %17 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool38.not = icmp eq i32 %17, 0
  br i1 %tobool38.not, label %yybackup, label %if.then39

if.then39:                                        ; preds = %if.end37
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %call40 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3.2681, i32 0, i32 0), i32 %yystate.0) #25
  br label %yybackup

yybackup:                                         ; preds = %if.then39, %if.end37
  %arrayidx = getelementptr inbounds [901 x i16], [901 x i16]* @yypact, i32 0, i32 %yystate.0
  %19 = load i16, i16* %arrayidx, align 2, !tbaa !34
  %conv42 = sext i16 %19 to i32
  %cmp43 = icmp eq i16 %19, -32768
  br i1 %cmp43, label %yydefault, label %if.end46

if.end46:                                         ; preds = %yybackup
  %20 = load i32, i32* @yychar, align 4, !tbaa !16
  %cmp47 = icmp eq i32 %20, -2
  br i1 %cmp47, label %if.then49, label %if.end55

if.then49:                                        ; preds = %if.end46
  %21 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool50.not = icmp eq i32 %21, 0
  br i1 %tobool50.not, label %if.end53, label %if.then51

if.then51:                                        ; preds = %if.then49
  %22 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %23 = call i32 @fwrite(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.4.2682, i32 0, i32 0), i32 17, i32 1, %struct._IO_FILE* %22) #24
  br label %if.end53

if.end53:                                         ; preds = %if.then51, %if.then49
  %call54 = call fastcc i32 @yylex() #21
  store i32 %call54, i32* @yychar, align 4, !tbaa !16
  br label %if.end55

if.end55:                                         ; preds = %if.end53, %if.end46
  %24 = phi i32 [ %call54, %if.end53 ], [ %20, %if.end46 ]
  %cmp56 = icmp slt i32 %24, 1
  br i1 %cmp56, label %if.then58, label %if.else

if.then58:                                        ; preds = %if.end55
  store i32 0, i32* @yychar, align 4, !tbaa !16
  %25 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool59.not = icmp eq i32 %25, 0
  br i1 %tobool59.not, label %if.end73, label %if.then60

if.then60:                                        ; preds = %if.then58
  %26 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %27 = call i32 @fwrite(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.5.2683, i32 0, i32 0), i32 21, i32 1, %struct._IO_FILE* %26) #24
  br label %if.end73

if.else:                                          ; preds = %if.end55
  %cmp63 = icmp ult i32 %24, 323
  br i1 %cmp63, label %cond.true, label %cond.end

cond.true:                                        ; preds = %if.else
  %arrayidx65 = getelementptr inbounds [323 x i8], [323 x i8]* @yytranslate, i32 0, i32 %24
  %28 = load i8, i8* %arrayidx65, align 1, !tbaa !19
  %conv66 = sext i8 %28 to i32
  br label %cond.end

cond.end:                                         ; preds = %cond.true, %if.else
  %cond = phi i32 [ %conv66, %cond.true ], [ 289, %if.else ]
  %29 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool67.not = icmp eq i32 %29, 0
  br i1 %tobool67.not, label %if.end73, label %if.then68

if.then68:                                        ; preds = %cond.end
  %30 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %arrayidx69 = getelementptr inbounds [290 x i8*], [290 x i8*]* @yytname, i32 0, i32 %cond
  %31 = load i8*, i8** %arrayidx69, align 4, !tbaa !15
  %call70 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.6.2684, i32 0, i32 0), i32 %24, i8* %31) #25
  %32 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %33 = load i32, i32* @yychar, align 4, !tbaa !16
  call fastcc void @yyprint(%struct._IO_FILE* %32, i32 %33, %union.anon.2* nonnull byval(%union.anon.2) align 4 @yylval) #21
  %34 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %35 = call i32 @fwrite(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.7.2685, i32 0, i32 0), i32 2, i32 1, %struct._IO_FILE* %34) #24
  br label %if.end73

if.end73:                                         ; preds = %if.then68, %cond.end, %if.then60, %if.then58
  %yychar1.1 = phi i32 [ 0, %if.then60 ], [ 0, %if.then58 ], [ %cond, %if.then68 ], [ %cond, %cond.end ]
  %add74 = add nsw i32 %yychar1.1, %conv42
  %36 = icmp ugt i32 %add74, 3205
  br i1 %36, label %yydefault, label %lor.lhs.false79

lor.lhs.false79:                                  ; preds = %if.end73
  %arrayidx80 = getelementptr inbounds [3206 x i16], [3206 x i16]* @yycheck, i32 0, i32 %add74
  %37 = load i16, i16* %arrayidx80, align 2, !tbaa !34
  %conv81 = sext i16 %37 to i32
  %cmp82.not = icmp eq i32 %yychar1.1, %conv81
  br i1 %cmp82.not, label %if.end85, label %yydefault

if.end85:                                         ; preds = %lor.lhs.false79
  %arrayidx86 = getelementptr inbounds [3206 x i16], [3206 x i16]* @yytable, i32 0, i32 %add74
  %38 = load i16, i16* %arrayidx86, align 2, !tbaa !34
  %conv87 = sext i16 %38 to i32
  %cmp88 = icmp slt i16 %38, 0
  br i1 %cmp88, label %if.then90, label %if.else95

if.then90:                                        ; preds = %if.end85
  %cmp91 = icmp eq i16 %38, -32768
  br i1 %cmp91, label %yyerrlab, label %if.end94

if.end94:                                         ; preds = %if.then90
  %sub = sub nsw i32 0, %conv87
  br label %yyreduce

if.else95:                                        ; preds = %if.end85
  switch i16 %38, label %if.end104 [
    i16 0, label %yyerrlab
    i16 900, label %cleanup4861
  ]

if.end104:                                        ; preds = %if.else95
  %39 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool105.not = icmp eq i32 %39, 0
  br i1 %tobool105.not, label %if.end109, label %if.then106

if.then106:                                       ; preds = %if.end104
  %40 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %41 = load i32, i32* @yychar, align 4, !tbaa !16
  %arrayidx107 = getelementptr inbounds [290 x i8*], [290 x i8*]* @yytname, i32 0, i32 %yychar1.1
  %42 = load i8*, i8** %arrayidx107, align 4, !tbaa !15
  %call108 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %40, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.8.2686, i32 0, i32 0), i32 %41, i8* %42) #25
  br label %if.end109

if.end109:                                        ; preds = %if.then106, %if.end104
  %43 = load i32, i32* @yychar, align 4, !tbaa !16
  %cmp110.not = icmp eq i32 %43, 0
  br i1 %cmp110.not, label %if.end113, label %if.then112

if.then112:                                       ; preds = %if.end109
  store i32 -2, i32* @yychar, align 4, !tbaa !16
  br label %if.end113

if.end113:                                        ; preds = %if.then112, %if.end109
  %incdec.ptr114 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.2, i32 1
  %44 = getelementptr %union.anon.2, %union.anon.2* %incdec.ptr114, i32 0, i32 0
  %45 = load i32, i32* getelementptr inbounds (%union.anon.2, %union.anon.2* @yylval, i32 0, i32 0), align 4
  store i32 %45, i32* %44, align 4
  %tobool115.not = icmp eq i32 %yyerrstatus.0, 0
  %dec = add nsw i32 %yyerrstatus.0, -1
  %spec.select = select i1 %tobool115.not, i32 0, i32 %dec
  br label %yynewstate.backedge

yynewstate.backedge:                              ; preds = %if.end4853, %if.end4771, %if.end113
  %yychar1.0.be = phi i32 [ %yychar1.1, %if.end113 ], [ %yychar1.3, %if.end4771 ], [ %yychar1.5, %if.end4853 ]
  %yyerrstatus.0.be = phi i32 [ %spec.select, %if.end113 ], [ %yyerrstatus.2, %if.end4771 ], [ 3, %if.end4853 ]
  %yyvsp.0.be = phi %union.anon.2* [ %incdec.ptr114, %if.end113 ], [ %incdec.ptr4745, %if.end4771 ], [ %incdec.ptr4854, %if.end4853 ]
  %yyssp.0.be = phi i16* [ %yyssp.2, %if.end113 ], [ %add.ptr4730, %if.end4771 ], [ %yyssp.5, %if.end4853 ]
  %yystate.0.be = phi i32 [ %conv87, %if.end113 ], [ %yystate.2, %if.end4771 ], [ %conv4831.le58085851, %if.end4853 ]
  br label %yynewstate

yydefault:                                        ; preds = %lor.lhs.false79, %if.end73, %yybackup
  %yychar1.2 = phi i32 [ %yychar1.0, %yybackup ], [ %yychar1.1, %if.end73 ], [ %yychar1.1, %lor.lhs.false79 ]
  %arrayidx118 = getelementptr inbounds [901 x i16], [901 x i16]* @yydefact, i32 0, i32 %yystate.0
  %46 = load i16, i16* %arrayidx118, align 2, !tbaa !34
  %conv119 = sext i16 %46 to i32
  %cmp120 = icmp eq i16 %46, 0
  br i1 %cmp120, label %yyerrlab, label %yyreduce

yyreduce:                                         ; preds = %if.end4838, %yydefault, %if.end94
  %yychar1.3 = phi i32 [ %yychar1.5, %if.end4838 ], [ %yychar1.2, %yydefault ], [ %yychar1.1, %if.end94 ]
  %yyerrstatus.2 = phi i32 [ 3, %if.end4838 ], [ %yyerrstatus.0, %yydefault ], [ %yyerrstatus.0, %if.end94 ]
  %yyvsp.3 = phi %union.anon.2* [ %yyvsp.5, %if.end4838 ], [ %yyvsp.2, %yydefault ], [ %yyvsp.2, %if.end94 ]
  %yyssp.3 = phi i16* [ %yyssp.5, %if.end4838 ], [ %yyssp.2, %yydefault ], [ %yyssp.2, %if.end94 ]
  %yyn.0 = phi i32 [ %sub4839, %if.end4838 ], [ %conv119, %yydefault ], [ %sub, %if.end94 ]
  %yystate.1 = phi i32 [ %yystate.4, %if.end4838 ], [ %yystate.0, %yydefault ], [ %yystate.0, %if.end94 ]
  %arrayidx124 = getelementptr inbounds [560 x i16], [560 x i16]* @yyr2, i32 0, i32 %yyn.0
  %47 = load i16, i16* %arrayidx124, align 2, !tbaa !34
  %conv125 = sext i16 %47 to i32
  %cmp126 = icmp sgt i16 %47, 0
  br i1 %cmp126, label %if.then128, label %if.end131

if.then128:                                       ; preds = %yyreduce
  %sub129 = sub nsw i32 1, %conv125
  %48 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 %sub129, i32 0
  %49 = load i32, i32* %48, align 4
  store i32 %49, i32* %6, align 4
  br label %if.end131

if.end131:                                        ; preds = %if.then128, %yyreduce
  %50 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool132.not = icmp eq i32 %50, 0
  br i1 %tobool132.not, label %if.end150, label %if.then133

if.then133:                                       ; preds = %if.end131
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %arrayidx134 = getelementptr inbounds [560 x i16], [560 x i16]* @yyrline, i32 0, i32 %yyn.0
  %52 = load i16, i16* %arrayidx134, align 2, !tbaa !34
  %conv135 = sext i16 %52 to i32
  %call136 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.9.2687, i32 0, i32 0), i32 %yyn.0, i32 %conv135) #25
  %arrayidx137 = getelementptr inbounds [560 x i16], [560 x i16]* @yyprhs, i32 0, i32 %yyn.0
  %53 = load i16, i16* %arrayidx137, align 2, !tbaa !34
  %conv138 = sext i16 %53 to i32
  %arrayidx1395810 = getelementptr inbounds [1730 x i16], [1730 x i16]* @yyrhs, i32 0, i32 %conv138
  %54 = load i16, i16* %arrayidx1395810, align 2, !tbaa !34
  %cmp1415811 = icmp sgt i16 %54, 0
  br i1 %cmp1415811, label %for.body, label %for.end

for.body:                                         ; preds = %for.body, %if.then133
  %55 = phi i16 [ %58, %for.body ], [ %54, %if.then133 ]
  %i.05812 = phi i32 [ %inc, %for.body ], [ %conv138, %if.then133 ]
  %conv1405792 = zext i16 %55 to i32
  %56 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %arrayidx144 = getelementptr inbounds [290 x i8*], [290 x i8*]* @yytname, i32 0, i32 %conv1405792
  %57 = load i8*, i8** %arrayidx144, align 4, !tbaa !15
  %call145 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %56, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10.2688, i32 0, i32 0), i8* %57) #25
  %inc = add nsw i32 %i.05812, 1
  %arrayidx139 = getelementptr inbounds [1730 x i16], [1730 x i16]* @yyrhs, i32 0, i32 %inc
  %58 = load i16, i16* %arrayidx139, align 2, !tbaa !34
  %cmp141 = icmp sgt i16 %58, 0
  br i1 %cmp141, label %for.body, label %for.end, !llvm.loop !54

for.end:                                          ; preds = %for.body, %if.then133
  %59 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %arrayidx146 = getelementptr inbounds [560 x i16], [560 x i16]* @yyr1, i32 0, i32 %yyn.0
  %60 = load i16, i16* %arrayidx146, align 2, !tbaa !34
  %idxprom147 = sext i16 %60 to i32
  %arrayidx148 = getelementptr inbounds [290 x i8*], [290 x i8*]* @yytname, i32 0, i32 %idxprom147
  %61 = load i8*, i8** %arrayidx148, align 4, !tbaa !15
  %call149 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %59, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.11.2689, i32 0, i32 0), i8* %61) #25
  br label %if.end150

if.end150:                                        ; preds = %for.end, %if.end131
  switch i32 %yyn.0, label %sw.epilog [
    i32 1, label %sw.bb
    i32 2, label %while.cond.preheader
    i32 3, label %sw.bb158
    i32 5, label %sw.bb159
    i32 9, label %while.cond162.preheader
    i32 10, label %do.body
    i32 11, label %sw.bb261
    i32 12, label %do.body281
    i32 13, label %do.body297
    i32 14, label %sw.bb312
    i32 17, label %sw.bb315
    i32 18, label %sw.bb319
    i32 19, label %sw.bb326
    i32 20, label %sw.bb327
    i32 21, label %do.body348
    i32 22, label %sw.bb363
    i32 23, label %sw.bb370
    i32 24, label %sw.bb371
    i32 25, label %do.body396
    i32 26, label %sw.bb411
    i32 27, label %sw.bb418
    i32 28, label %sw.bb419
    i32 29, label %do.body444
    i32 32, label %sw.bb459
    i32 33, label %sw.bb461
    i32 34, label %sw.bb463
    i32 35, label %sw.bb470
    i32 36, label %sw.bb472
    i32 37, label %sw.bb474
    i32 38, label %sw.bb476
    i32 39, label %sw.bb478
    i32 40, label %sw.bb483
    i32 42, label %sw.bb485
    i32 43, label %sw.bb490
    i32 45, label %sw.bb497
    i32 46, label %sw.bb502
    i32 47, label %sw.bb519
    i32 48, label %sw.bb527
    i32 49, label %sw.bb532
    i32 50, label %sw.bb562
    i32 51, label %sw.bb569
    i32 52, label %sw.bb575
    i32 53, label %sw.bb582
    i32 54, label %sw.bb587
    i32 55, label %sw.bb592
    i32 56, label %sw.bb594
    i32 58, label %sw.bb596
    i32 60, label %sw.bb603
    i32 61, label %sw.bb612
    i32 62, label %sw.bb621
    i32 63, label %sw.bb630
    i32 64, label %sw.bb639
    i32 65, label %sw.bb648
    i32 66, label %sw.bb657
    i32 67, label %sw.bb666
    i32 68, label %sw.bb675
    i32 69, label %sw.bb684
    i32 70, label %sw.bb693
    i32 71, label %sw.bb702
    i32 72, label %sw.bb711
    i32 73, label %sw.bb723
    i32 74, label %sw.bb735
    i32 75, label %sw.bb747
    i32 76, label %sw.bb759
    i32 77, label %sw.bb771
    i32 78, label %sw.bb782
    i32 79, label %sw.bb796
    i32 80, label %sw.bb816
    i32 81, label %sw.bb830
    i32 82, label %sw.bb863
    i32 83, label %sw.bb900
    i32 85, label %sw.bb912
    i32 86, label %sw.bb917
    i32 87, label %sw.bb923
    i32 88, label %sw.bb931
    i32 89, label %sw.bb945
    i32 90, label %sw.bb979
    i32 91, label %sw.bb981
    i32 92, label %sw.bb1032
    i32 93, label %sw.bb1045
    i32 94, label %sw.bb1052
    i32 95, label %sw.bb1060
    i32 96, label %sw.bb1137
    i32 97, label %sw.bb1158
    i32 98, label %sw.bb1165
    i32 99, label %sw.bb1172
    i32 100, label %sw.bb1181
    i32 101, label %sw.bb1186
    i32 103, label %sw.bb1191
    i32 106, label %sw.bb1211
    i32 559, label %sw.bb4722
    i32 112, label %do.body1217
    i32 113, label %do.body1233
    i32 114, label %sw.bb1248
    i32 115, label %sw.bb1251
    i32 558, label %sw.bb4714
    i32 117, label %sw.bb1253
    i32 118, label %sw.bb1261
    i32 119, label %do.body1266
    i32 120, label %do.body1282
    i32 121, label %do.body1298
    i32 122, label %do.body1314
    i32 123, label %sw.bb1329
    i32 124, label %do.body1333
    i32 125, label %sw.bb1346
    i32 126, label %sw.bb1356
    i32 127, label %sw.bb1369
    i32 128, label %sw.bb1382
    i32 129, label %sw.bb1402
    i32 130, label %sw.bb1415
    i32 131, label %sw.bb1428
    i32 132, label %sw.bb1438
    i32 133, label %sw.bb1460
    i32 134, label %sw.bb1471
    i32 135, label %sw.bb1484
    i32 136, label %sw.bb1497
    i32 137, label %sw.bb1510
    i32 138, label %sw.bb1523
    i32 139, label %sw.bb1536
    i32 140, label %sw.bb1549
    i32 141, label %sw.bb1560
    i32 142, label %sw.bb1582
    i32 143, label %sw.bb1595
    i32 144, label %sw.bb1608
    i32 145, label %sw.bb1621
    i32 146, label %sw.bb1634
    i32 147, label %sw.bb1647
    i32 148, label %sw.bb1660
    i32 149, label %sw.bb1673
    i32 150, label %sw.bb1686
    i32 151, label %sw.bb1699
    i32 152, label %sw.bb1712
    i32 153, label %sw.bb1734
    i32 154, label %sw.bb1747
    i32 155, label %sw.bb1760
    i32 156, label %sw.bb1773
    i32 157, label %sw.bb1786
    i32 158, label %sw.bb1796
    i32 159, label %sw.bb1809
    i32 160, label %sw.bb1822
    i32 161, label %sw.bb1858
    i32 162, label %sw.bb1897
    i32 163, label %sw.bb1936
    i32 164, label %sw.bb1975
    i32 165, label %sw.bb1997
    i32 166, label %sw.bb2010
    i32 167, label %sw.bb2023
    i32 168, label %sw.bb2062
    i32 169, label %sw.bb2101
    i32 170, label %sw.bb2140
    i32 171, label %sw.bb2179
    i32 172, label %sw.bb2201
    i32 173, label %sw.bb2214
    i32 174, label %sw.bb2227
    i32 175, label %sw.bb2240
    i32 176, label %sw.bb2253
    i32 177, label %sw.bb2266
    i32 178, label %sw.bb2279
    i32 179, label %sw.bb2318
    i32 180, label %sw.bb2357
    i32 181, label %sw.bb2396
    i32 182, label %sw.bb2435
    i32 183, label %sw.bb2457
    i32 184, label %sw.bb2470
    i32 185, label %sw.bb2483
    i32 186, label %sw.bb2496
    i32 187, label %sw.bb2509
    i32 188, label %sw.bb2522
    i32 189, label %sw.bb2535
    i32 190, label %sw.bb2548
    i32 191, label %sw.bb2561
    i32 192, label %sw.bb2574
    i32 193, label %sw.bb2587
    i32 194, label %sw.bb2626
    i32 195, label %sw.bb2665
    i32 196, label %sw.bb2704
    i32 197, label %sw.bb2743
    i32 198, label %sw.bb2765
    i32 199, label %sw.bb2778
    i32 200, label %sw.bb2791
    i32 201, label %sw.bb2804
    i32 258, label %sw.bb2817
    i32 259, label %sw.bb2819
    i32 557, label %sw.bb4709
    i32 266, label %sw.bb2824
    i32 267, label %sw.bb2829
    i32 268, label %sw.bb2835
    i32 273, label %sw.bb2840
    i32 274, label %sw.bb2842
    i32 275, label %sw.bb2858
    i32 276, label %sw.bb2870
    i32 277, label %sw.bb2877
    i32 278, label %sw.bb2887
    i32 279, label %sw.bb2899
    i32 280, label %sw.bb2906
    i32 281, label %sw.bb2917
    i32 282, label %sw.bb2919
    i32 283, label %sw.bb2923
    i32 284, label %sw.bb2927
    i32 285, label %sw.bb2934
    i32 286, label %sw.bb2938
    i32 287, label %sw.bb2942
    i32 288, label %sw.bb2949
    i32 289, label %sw.bb2951
    i32 290, label %sw.bb2956
    i32 291, label %sw.bb2964
    i32 292, label %sw.bb2974
    i32 298, label %sw.bb2981
    i32 299, label %sw.bb2982
    i32 300, label %sw.bb2985
    i32 301, label %sw.bb2987
    i32 305, label %sw.bb2991
    i32 306, label %sw.bb2997
    i32 307, label %sw.bb3001
    i32 310, label %sw.bb3007
    i32 311, label %sw.bb3008
    i32 312, label %sw.bb3010
    i32 316, label %sw.bb3013
    i32 317, label %sw.bb3016
    i32 318, label %sw.bb3024
    i32 319, label %sw.bb3027
    i32 320, label %sw.bb3037
    i32 321, label %sw.bb3038
    i32 322, label %sw.bb3049
    i32 323, label %sw.bb3059
    i32 324, label %sw.bb3060
    i32 327, label %sw.bb3071
    i32 328, label %sw.bb3087
    i32 329, label %sw.bb3094
    i32 330, label %sw.bb3101
    i32 334, label %sw.bb3108
    i32 335, label %sw.bb3115
    i32 337, label %sw.bb3122
    i32 338, label %sw.bb3129
    i32 339, label %sw.bb3136
    i32 340, label %sw.bb3143
    i32 341, label %sw.bb3150
    i32 342, label %sw.bb3166
    i32 343, label %sw.bb3173
    i32 344, label %sw.bb3189
    i32 345, label %sw.bb3196
    i32 347, label %sw.bb3203
    i32 348, label %sw.bb3205
    i32 349, label %sw.bb3209
    i32 350, label %sw.bb3211
    i32 351, label %sw.bb3215
    i32 352, label %sw.bb3217
    i32 353, label %sw.bb3221
    i32 354, label %sw.bb3226
    i32 355, label %sw.bb3238
    i32 356, label %sw.bb3249
    i32 357, label %sw.bb3254
    i32 358, label %sw.bb3266
    i32 359, label %sw.bb3277
    i32 360, label %sw.bb3282
    i32 361, label %sw.bb3295
    i32 362, label %sw.bb3298
    i32 363, label %sw.bb3311
    i32 364, label %sw.bb3316
    i32 365, label %sw.bb3321
    i32 369, label %sw.bb3335
    i32 370, label %sw.bb3341
    i32 371, label %sw.bb3345
    i32 372, label %sw.bb3352
    i32 373, label %sw.bb3354
    i32 374, label %sw.bb3361
    i32 375, label %sw.bb3365
    i32 376, label %sw.bb3384
    i32 377, label %sw.bb3409
    i32 378, label %sw.bb3428
    i32 379, label %sw.bb3435
    i32 380, label %sw.bb3437
    i32 382, label %sw.bb3454
    i32 384, label %sw.bb3461
    i32 385, label %sw.bb3468
    i32 386, label %sw.bb3482
    i32 387, label %sw.bb3498
    i32 388, label %sw.bb3512
    i32 389, label %sw.bb3526
    i32 390, label %sw.bb3542
    i32 392, label %sw.bb3556
    i32 393, label %sw.bb3573
    i32 394, label %sw.bb3575
    i32 395, label %sw.bb3580
    i32 396, label %sw.bb3587
    i32 397, label %sw.bb3591
    i32 398, label %sw.bb3598
    i32 400, label %sw.bb3600
    i32 401, label %sw.bb3604
    i32 402, label %sw.bb3610
    i32 406, label %sw.bb3619
    i32 407, label %sw.bb3626
    i32 408, label %sw.bb3631
    i32 409, label %sw.bb3638
    i32 410, label %sw.bb3654
    i32 411, label %sw.bb3661
    i32 412, label %sw.bb3668
    i32 413, label %sw.bb3673
    i32 414, label %sw.bb3678
    i32 415, label %sw.bb3683
    i32 416, label %sw.bb3690
    i32 417, label %sw.bb3693
    i32 418, label %sw.bb3698
    i32 419, label %sw.bb3701
    i32 420, label %sw.bb3706
    i32 421, label %sw.bb3720
    i32 422, label %sw.bb3736
    i32 425, label %sw.bb3752
    i32 433, label %sw.bb3753
    i32 448, label %sw.bb3759
    i32 449, label %sw.bb3761
    i32 450, label %sw.bb3764
    i32 451, label %sw.bb3773
    i32 453, label %sw.bb3794
    i32 456, label %sw.bb3798
    i32 556, label %sw.bb4701
    i32 459, label %sw.bb3817
    i32 460, label %sw.bb3821
    i32 461, label %sw.bb3824
    i32 464, label %sw.bb3843
    i32 465, label %do.body3855
    i32 466, label %sw.bb3880
    i32 468, label %sw.bb3881
    i32 469, label %sw.bb3884
    i32 470, label %sw.bb3894
    i32 471, label %sw.bb3904
    i32 472, label %sw.bb3924
    i32 473, label %sw.bb3931
    i32 476, label %sw.bb3938
    i32 477, label %sw.bb3962
    i32 478, label %sw.bb3974
    i32 479, label %sw.bb3986
    i32 480, label %sw.bb3989
    i32 481, label %sw.bb3998
    i32 482, label %sw.bb4008
    i32 483, label %sw.bb4009
    i32 484, label %sw.bb4013
    i32 485, label %do.body4029
    i32 486, label %sw.bb4049
    i32 555, label %sw.bb4696
    i32 488, label %sw.bb4059
    i32 489, label %sw.bb4064
    i32 490, label %sw.bb4086
    i32 491, label %sw.bb4100
    i32 492, label %do.body4109
    i32 493, label %sw.bb4129
    i32 494, label %sw.bb4135
    i32 495, label %sw.bb4136
    i32 496, label %sw.bb4141
    i32 497, label %sw.bb4142
    i32 498, label %sw.bb4147
    i32 499, label %sw.bb4153
    i32 500, label %sw.bb4178
    i32 501, label %sw.bb4183
    i32 502, label %sw.bb4188
    i32 503, label %sw.bb4192
    i32 504, label %sw.bb4198
    i32 505, label %sw.bb4204
    i32 506, label %sw.bb4214
    i32 507, label %sw.bb4226
    i32 508, label %sw.bb4240
    i32 509, label %sw.bb4260
    i32 510, label %sw.bb4275
    i32 511, label %sw.bb4277
    i32 512, label %sw.bb4283
    i32 513, label %sw.bb4291
    i32 514, label %sw.bb4295
    i32 515, label %sw.bb4317
    i32 516, label %sw.bb4320
    i32 517, label %sw.bb4322
    i32 519, label %sw.bb4324
    i32 522, label %sw.bb4326
    i32 523, label %sw.bb4333
    i32 524, label %sw.bb4341
    i32 525, label %sw.bb4351
    i32 526, label %sw.bb4357
    i32 527, label %sw.bb4365
    i32 528, label %sw.bb4366
    i32 530, label %sw.bb4371
    i32 554, label %sw.bb4644
    i32 532, label %sw.bb4389
    i32 533, label %sw.bb4393
    i32 534, label %sw.bb4396
    i32 535, label %sw.bb4399
    i32 536, label %sw.bb4402
    i32 537, label %sw.bb4405
    i32 538, label %sw.bb4408
    i32 539, label %sw.bb4411
    i32 540, label %sw.bb4414
    i32 541, label %sw.bb4438
    i32 542, label %sw.bb4462
    i32 543, label %sw.bb4481
    i32 544, label %sw.bb4505
    i32 545, label %sw.bb4524
    i32 546, label %sw.bb4548
    i32 547, label %sw.bb4572
    i32 548, label %sw.bb4591
    i32 549, label %sw.bb4615
    i32 550, label %sw.bb4634
    i32 551, label %sw.bb4638
    i32 552, label %sw.bb4639
  ]

while.cond162.preheader:                          ; preds = %if.end150
  %arrayidx163 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype164 = bitcast %union.anon.2* %arrayidx163 to %union.tree_node**
  %62 = bitcast %union.anon.2* %arrayidx163 to %struct.tree_common**
  %63 = load %struct.tree_common*, %struct.tree_common** %62, align 4, !tbaa !19
  %code5821 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %63, i32 0, i32 2
  %bf.load5822 = load i32, i32* %code5821, align 4
  %bf.clear5823 = and i32 %bf.load5822, 255
  %bf.clear.off5824 = add nsw i32 %bf.clear5823, -114
  %switch5825 = icmp ult i32 %bf.clear.off5824, 3
  %64 = bitcast %struct.tree_common* %63 to %union.tree_node*
  br i1 %switch5825, label %land.lhs.true.preheader, label %while.end218

land.lhs.true.preheader:                          ; preds = %while.cond162.preheader
  %operands5878 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %63, i32 1, i32 1
  %65 = load %union.tree_node*, %union.tree_node** %operands5878, align 4, !tbaa !19
  %66 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  %cmp188.not5880 = icmp eq %union.tree_node* %65, %66
  br i1 %cmp188.not5880, label %while.end218, label %land.rhs

while.cond.preheader:                             ; preds = %if.end150
  %call1555832 = call i32 @global_bindings_p() #20
  %tobool156.not5833 = icmp eq i32 %call1555832, 0
  br i1 %tobool156.not5833, label %while.body, label %while.end

sw.bb:                                            ; preds = %if.end150
  %67 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool151.not = icmp eq i32 %67, 0
  br i1 %tobool151.not, label %if.end153, label %if.then152

if.then152:                                       ; preds = %sw.bb
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.12.2690, i32 0, i32 0)) #20
  br label %if.end153

if.end153:                                        ; preds = %if.then152, %sw.bb
  call void @finish_file() #20
  br label %sw.epilog

while.body:                                       ; preds = %while.body, %while.cond.preheader
  %call157 = call %union.tree_node* @poplevel(i32 0, i32 0, i32 0) #20
  %call155 = call i32 @global_bindings_p() #20
  %tobool156.not = icmp eq i32 %call155, 0
  br i1 %tobool156.not, label %while.body, label %while.end, !llvm.loop !55

while.end:                                        ; preds = %while.body, %while.cond.preheader
  call void @finish_fname_decls() #20
  call void @finish_file() #20
  br label %sw.epilog

sw.bb158:                                         ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb159:                                         ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void @ggc_collect() #20
  br label %sw.epilog

land.lhs.true:                                    ; preds = %while.body210
  %operands = getelementptr inbounds %union.tree_node, %union.tree_node* %70, i32 0, i32 0, i32 2
  %arrayidx187 = bitcast i32* %operands to %union.tree_node**
  %68 = load %union.tree_node*, %union.tree_node** %arrayidx187, align 4, !tbaa !19
  %69 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  %cmp188.not = icmp eq %union.tree_node* %68, %69
  br i1 %cmp188.not, label %while.end218, label %land.rhs, !llvm.loop !56

land.rhs:                                         ; preds = %land.lhs.true, %land.lhs.true.preheader
  %70 = phi %union.tree_node* [ %68, %land.lhs.true ], [ %65, %land.lhs.true.preheader ]
  %bf.clear58265881 = phi i32 [ %bf.clear, %land.lhs.true ], [ %bf.clear5823, %land.lhs.true.preheader ]
  %71 = phi %union.tree_node* [ %70, %land.lhs.true ], [ %64, %land.lhs.true.preheader ]
  %type = getelementptr inbounds %union.tree_node, %union.tree_node* %71, i32 0, i32 0, i32 0, i32 1
  %72 = bitcast %union.tree_node** %type to %struct.tree_type**
  %73 = load %struct.tree_type*, %struct.tree_type** %72, align 4, !tbaa !19
  %mode = getelementptr inbounds %struct.tree_type, %struct.tree_type* %73, i32 0, i32 6
  %bf.load194 = load i32, i32* %mode, align 4
  %type202 = getelementptr inbounds %union.tree_node, %union.tree_node* %70, i32 0, i32 0, i32 0, i32 1
  %74 = bitcast %union.tree_node** %type202 to %struct.tree_type**
  %75 = load %struct.tree_type*, %struct.tree_type** %74, align 4, !tbaa !19
  %mode204 = getelementptr inbounds %struct.tree_type, %struct.tree_type* %75, i32 0, i32 6
  %bf.load205 = load i32, i32* %mode204, align 4
  %bf.lshr5775 = xor i32 %bf.load205, %bf.load194
  %76 = and i32 %bf.lshr5775, 65024
  %cmp208 = icmp eq i32 %76, 0
  br i1 %cmp208, label %while.body210, label %while.end218

while.body210:                                    ; preds = %land.rhs
  store %union.tree_node* %70, %union.tree_node** %ttype164, align 4, !tbaa !19
  %code = getelementptr inbounds %union.tree_node, %union.tree_node* %70, i32 0, i32 0, i32 0, i32 2
  %bf.load = load i32, i32* %code, align 4
  %bf.clear = and i32 %bf.load, 255
  %bf.clear.off = add nsw i32 %bf.clear, -114
  %switch = icmp ult i32 %bf.clear.off, 3
  br i1 %switch, label %land.lhs.true, label %while.end218, !llvm.loop !56

while.end218:                                     ; preds = %while.body210, %land.rhs, %land.lhs.true, %land.lhs.true.preheader, %while.cond162.preheader
  %77 = phi %union.tree_node* [ %64, %while.cond162.preheader ], [ %64, %land.lhs.true.preheader ], [ %71, %land.rhs ], [ %70, %land.lhs.true ], [ %70, %while.body210 ]
  %bf.clear.lcssa = phi i32 [ %bf.clear5823, %while.cond162.preheader ], [ %bf.clear5823, %land.lhs.true.preheader ], [ %bf.clear58265881, %land.rhs ], [ %bf.clear, %land.lhs.true ], [ %bf.clear, %while.body210 ]
  %code222 = getelementptr inbounds %union.tree_node, %union.tree_node* %77, i32 0, i32 0, i32 0, i32 2
  %bf.load223 = load i32, i32* %code222, align 4
  %bf.clear224 = and i32 %bf.load223, 255
  %cmp225 = icmp eq i32 %bf.clear224, 121
  br i1 %cmp225, label %land.lhs.true227, label %lor.lhs.false239

land.lhs.true227:                                 ; preds = %while.end218
  %operands231 = getelementptr inbounds %union.tree_node, %union.tree_node* %77, i32 0, i32 0, i32 2
  %78 = bitcast i32* %operands231 to %struct.tree_common**
  %79 = load %struct.tree_common*, %struct.tree_common** %78, align 4, !tbaa !19
  %code234 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %79, i32 0, i32 2
  %bf.load235 = load i32, i32* %code234, align 4
  %bf.clear236 = and i32 %bf.load235, 255
  %cmp237 = icmp eq i32 %bf.clear236, 29
  %cmp246 = icmp eq i32 %bf.clear.lcssa, 29
  %or.cond = select i1 %cmp237, i1 true, i1 %cmp246
  br i1 %or.cond, label %if.then248, label %if.else251

lor.lhs.false239:                                 ; preds = %while.end218
  %cmp246.old = icmp eq i32 %bf.clear.lcssa, 29
  br i1 %cmp246.old, label %if.then248, label %if.else251

if.then248:                                       ; preds = %lor.lhs.false239, %land.lhs.true227
  call void @assemble_asm(%union.tree_node* nonnull %77) #20
  br label %sw.epilog

if.else251:                                       ; preds = %lor.lhs.false239, %land.lhs.true227
  call void (i8*, ...) @error(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.13.2691, i32 0, i32 0)) #20
  br label %sw.epilog

do.body:                                          ; preds = %if.end150
  %arrayidx254 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype255 = bitcast %union.anon.2* %arrayidx254 to %union.tree_node**
  %80 = load %union.tree_node*, %union.tree_node** %ttype255, align 4, !tbaa !19
  %call256 = call i64 @tree_low_cst(%union.tree_node* %80, i32 0) #20
  %conv257 = trunc i64 %call256 to i32
  %and = and i32 %conv257, 1
  store i32 %and, i32* @pedantic, align 4, !tbaa !16
  %shr5773 = lshr i32 %conv257, 1
  %and258 = and i32 %shr5773, 1
  store i32 %and258, i32* @warn_pointer_arith, align 4, !tbaa !16
  %shr2595774 = lshr i32 %conv257, 2
  %and260 = and i32 %shr2595774, 1
  store i32 %and260, i32* @warn_traditional, align 4, !tbaa !16
  br label %sw.epilog

sw.bb261:                                         ; preds = %if.end150
  %81 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool262.not = icmp eq i32 %81, 0
  br i1 %tobool262.not, label %if.else264, label %if.then263

if.then263:                                       ; preds = %sw.bb261
  call void (i8*, ...) @error(i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.14.2692, i32 0, i32 0)) #20
  br label %do.body269

if.else264:                                       ; preds = %sw.bb261
  %82 = load i32, i32* @flag_traditional, align 4, !tbaa !16
  %tobool265.not = icmp eq i32 %82, 0
  br i1 %tobool265.not, label %if.then266, label %do.body269

if.then266:                                       ; preds = %if.else264
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.15.2693, i32 0, i32 0)) #20
  br label %do.body269

do.body269:                                       ; preds = %if.then266, %if.else264, %if.then263
  %83 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value = getelementptr inbounds %struct.tree_list, %struct.tree_list* %83, i32 0, i32 2
  %84 = load %union.tree_node*, %union.tree_node** %value, align 4, !tbaa !19
  store %union.tree_node* %84, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose = getelementptr inbounds %struct.tree_list, %struct.tree_list* %83, i32 0, i32 1
  %85 = bitcast %union.tree_node** %purpose to %struct.tree_list**
  %86 = load %struct.tree_list*, %struct.tree_list** %85, align 4, !tbaa !19
  %purpose272 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %86, i32 0, i32 1
  %87 = load %union.tree_node*, %union.tree_node** %purpose272, align 4, !tbaa !19
  store %union.tree_node* %87, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value276 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %86, i32 0, i32 2
  %88 = load %union.tree_node*, %union.tree_node** %value276, align 4, !tbaa !19
  store %union.tree_node* %88, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain = getelementptr inbounds %struct.tree_list, %struct.tree_list* %83, i32 0, i32 0, i32 0
  %89 = load %union.tree_node*, %union.tree_node** %chain, align 4, !tbaa !19
  store %union.tree_node* %89, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body281:                                       ; preds = %if.end150
  %90 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value283 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %90, i32 0, i32 2
  %91 = load %union.tree_node*, %union.tree_node** %value283, align 4, !tbaa !19
  store %union.tree_node* %91, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose285 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %90, i32 0, i32 1
  %92 = bitcast %union.tree_node** %purpose285 to %struct.tree_list**
  %93 = load %struct.tree_list*, %struct.tree_list** %92, align 4, !tbaa !19
  %purpose287 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %93, i32 0, i32 1
  %94 = load %union.tree_node*, %union.tree_node** %purpose287, align 4, !tbaa !19
  store %union.tree_node* %94, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value291 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %93, i32 0, i32 2
  %95 = load %union.tree_node*, %union.tree_node** %value291, align 4, !tbaa !19
  store %union.tree_node* %95, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain293 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %90, i32 0, i32 0, i32 0
  %96 = load %union.tree_node*, %union.tree_node** %chain293, align 4, !tbaa !19
  store %union.tree_node* %96, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body297:                                       ; preds = %if.end150
  %97 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value299 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %97, i32 0, i32 2
  %98 = load %union.tree_node*, %union.tree_node** %value299, align 4, !tbaa !19
  store %union.tree_node* %98, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose301 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %97, i32 0, i32 1
  %99 = bitcast %union.tree_node** %purpose301 to %struct.tree_list**
  %100 = load %struct.tree_list*, %struct.tree_list** %99, align 4, !tbaa !19
  %purpose303 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %100, i32 0, i32 1
  %101 = load %union.tree_node*, %union.tree_node** %purpose303, align 4, !tbaa !19
  store %union.tree_node* %101, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value307 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %100, i32 0, i32 2
  %102 = load %union.tree_node*, %union.tree_node** %value307, align 4, !tbaa !19
  store %union.tree_node* %102, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain309 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %97, i32 0, i32 0, i32 0
  %103 = load %union.tree_node*, %union.tree_node** %chain309, align 4, !tbaa !19
  store %union.tree_node* %103, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb312:                                         ; preds = %if.end150
  %arrayidx313 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype314 = bitcast %union.anon.2* %arrayidx313 to %union.tree_node**
  %104 = load %union.tree_node*, %union.tree_node** %ttype314, align 4, !tbaa !19
  call void @shadow_tag(%union.tree_node* %104) #20
  br label %sw.epilog

sw.bb315:                                         ; preds = %if.end150
  %105 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool316.not = icmp eq i32 %105, 0
  br i1 %tobool316.not, label %sw.epilog, label %if.then317

if.then317:                                       ; preds = %sw.bb315
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.16.2694, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb319:                                         ; preds = %if.end150
  %106 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype321 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %107 = load %union.tree_node*, %union.tree_node** %ttype321, align 4, !tbaa !19
  %108 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call322 = call i32 @start_function(%union.tree_node* %106, %union.tree_node* %107, %union.tree_node* %108) #20
  %tobool323.not = icmp eq i32 %call322, 0
  br i1 %tobool323.not, label %if.then324, label %sw.epilog

if.then324:                                       ; preds = %sw.bb319
  call fastcc void @yyerror(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.17.2695, i32 0, i32 0)) #21
  br label %yyerrlab1

sw.bb326:                                         ; preds = %if.end150
  call void @store_parm_decls() #20
  br label %sw.epilog

sw.bb327:                                         ; preds = %if.end150
  %arrayidx328 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %filename = bitcast %union.anon.2* %arrayidx328 to i8**
  %109 = load i8*, i8** %filename, align 4, !tbaa !19
  %110 = load %struct.tree_decl*, %struct.tree_decl** bitcast (%union.tree_node** @current_function_decl to %struct.tree_decl**), align 4, !tbaa !15
  %filename329 = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %110, i32 0, i32 1
  store i8* %109, i8** %filename329, align 4, !tbaa !19
  %lineno = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %111 = load i32, i32* %lineno, align 4, !tbaa !19
  %linenum = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %110, i32 0, i32 2
  store i32 %111, i32* %linenum, align 4, !tbaa !19
  call void @finish_function(i32 0, i32 1) #20
  %112 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value334 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %112, i32 0, i32 2
  %113 = load %union.tree_node*, %union.tree_node** %value334, align 4, !tbaa !19
  store %union.tree_node* %113, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose336 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %112, i32 0, i32 1
  %114 = bitcast %union.tree_node** %purpose336 to %struct.tree_list**
  %115 = load %struct.tree_list*, %struct.tree_list** %114, align 4, !tbaa !19
  %purpose338 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %115, i32 0, i32 1
  %116 = load %union.tree_node*, %union.tree_node** %purpose338, align 4, !tbaa !19
  store %union.tree_node* %116, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value342 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %115, i32 0, i32 2
  %117 = load %union.tree_node*, %union.tree_node** %value342, align 4, !tbaa !19
  store %union.tree_node* %117, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain344 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %112, i32 0, i32 0, i32 0
  %118 = load %union.tree_node*, %union.tree_node** %chain344, align 4, !tbaa !19
  store %union.tree_node* %118, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body348:                                       ; preds = %if.end150
  %119 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value350 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %119, i32 0, i32 2
  %120 = load %union.tree_node*, %union.tree_node** %value350, align 4, !tbaa !19
  store %union.tree_node* %120, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose352 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %119, i32 0, i32 1
  %121 = bitcast %union.tree_node** %purpose352 to %struct.tree_list**
  %122 = load %struct.tree_list*, %struct.tree_list** %121, align 4, !tbaa !19
  %purpose354 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %122, i32 0, i32 1
  %123 = load %union.tree_node*, %union.tree_node** %purpose354, align 4, !tbaa !19
  store %union.tree_node* %123, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value358 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %122, i32 0, i32 2
  %124 = load %union.tree_node*, %union.tree_node** %value358, align 4, !tbaa !19
  store %union.tree_node* %124, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain360 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %119, i32 0, i32 0, i32 0
  %125 = load %union.tree_node*, %union.tree_node** %chain360, align 4, !tbaa !19
  store %union.tree_node* %125, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb363:                                         ; preds = %if.end150
  %126 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype365 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %127 = load %union.tree_node*, %union.tree_node** %ttype365, align 4, !tbaa !19
  %128 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call366 = call i32 @start_function(%union.tree_node* %126, %union.tree_node* %127, %union.tree_node* %128) #20
  %tobool367.not = icmp eq i32 %call366, 0
  br i1 %tobool367.not, label %if.then368, label %sw.epilog

if.then368:                                       ; preds = %sw.bb363
  call fastcc void @yyerror(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.17.2695, i32 0, i32 0)) #21
  br label %yyerrlab1

sw.bb370:                                         ; preds = %if.end150
  call void @store_parm_decls() #20
  br label %sw.epilog

sw.bb371:                                         ; preds = %if.end150
  %arrayidx372 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %filename373 = bitcast %union.anon.2* %arrayidx372 to i8**
  %129 = load i8*, i8** %filename373, align 4, !tbaa !19
  %130 = load %struct.tree_decl*, %struct.tree_decl** bitcast (%union.tree_node** @current_function_decl to %struct.tree_decl**), align 4, !tbaa !15
  %filename375 = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %130, i32 0, i32 1
  store i8* %129, i8** %filename375, align 4, !tbaa !19
  %lineno377 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %131 = load i32, i32* %lineno377, align 4, !tbaa !19
  %linenum379 = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %130, i32 0, i32 2
  store i32 %131, i32* %linenum379, align 4, !tbaa !19
  call void @finish_function(i32 0, i32 1) #20
  %132 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value382 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %132, i32 0, i32 2
  %133 = load %union.tree_node*, %union.tree_node** %value382, align 4, !tbaa !19
  store %union.tree_node* %133, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose384 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %132, i32 0, i32 1
  %134 = bitcast %union.tree_node** %purpose384 to %struct.tree_list**
  %135 = load %struct.tree_list*, %struct.tree_list** %134, align 4, !tbaa !19
  %purpose386 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %135, i32 0, i32 1
  %136 = load %union.tree_node*, %union.tree_node** %purpose386, align 4, !tbaa !19
  store %union.tree_node* %136, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value390 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %135, i32 0, i32 2
  %137 = load %union.tree_node*, %union.tree_node** %value390, align 4, !tbaa !19
  store %union.tree_node* %137, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain392 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %132, i32 0, i32 0, i32 0
  %138 = load %union.tree_node*, %union.tree_node** %chain392, align 4, !tbaa !19
  store %union.tree_node* %138, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body396:                                       ; preds = %if.end150
  %139 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value398 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %139, i32 0, i32 2
  %140 = load %union.tree_node*, %union.tree_node** %value398, align 4, !tbaa !19
  store %union.tree_node* %140, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose400 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %139, i32 0, i32 1
  %141 = bitcast %union.tree_node** %purpose400 to %struct.tree_list**
  %142 = load %struct.tree_list*, %struct.tree_list** %141, align 4, !tbaa !19
  %purpose402 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %142, i32 0, i32 1
  %143 = load %union.tree_node*, %union.tree_node** %purpose402, align 4, !tbaa !19
  store %union.tree_node* %143, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value406 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %142, i32 0, i32 2
  %144 = load %union.tree_node*, %union.tree_node** %value406, align 4, !tbaa !19
  store %union.tree_node* %144, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain408 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %139, i32 0, i32 0, i32 0
  %145 = load %union.tree_node*, %union.tree_node** %chain408, align 4, !tbaa !19
  store %union.tree_node* %145, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb411:                                         ; preds = %if.end150
  %ttype413 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %146 = load %union.tree_node*, %union.tree_node** %ttype413, align 4, !tbaa !19
  %147 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call414 = call i32 @start_function(%union.tree_node* null, %union.tree_node* %146, %union.tree_node* %147) #20
  %tobool415.not = icmp eq i32 %call414, 0
  br i1 %tobool415.not, label %if.then416, label %sw.epilog

if.then416:                                       ; preds = %sw.bb411
  call fastcc void @yyerror(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.17.2695, i32 0, i32 0)) #21
  br label %yyerrlab1

sw.bb418:                                         ; preds = %if.end150
  call void @store_parm_decls() #20
  br label %sw.epilog

sw.bb419:                                         ; preds = %if.end150
  %arrayidx420 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %filename421 = bitcast %union.anon.2* %arrayidx420 to i8**
  %148 = load i8*, i8** %filename421, align 4, !tbaa !19
  %149 = load %struct.tree_decl*, %struct.tree_decl** bitcast (%union.tree_node** @current_function_decl to %struct.tree_decl**), align 4, !tbaa !15
  %filename423 = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %149, i32 0, i32 1
  store i8* %148, i8** %filename423, align 4, !tbaa !19
  %lineno425 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %150 = load i32, i32* %lineno425, align 4, !tbaa !19
  %linenum427 = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %149, i32 0, i32 2
  store i32 %150, i32* %linenum427, align 4, !tbaa !19
  call void @finish_function(i32 0, i32 1) #20
  %151 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value430 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %151, i32 0, i32 2
  %152 = load %union.tree_node*, %union.tree_node** %value430, align 4, !tbaa !19
  store %union.tree_node* %152, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose432 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %151, i32 0, i32 1
  %153 = bitcast %union.tree_node** %purpose432 to %struct.tree_list**
  %154 = load %struct.tree_list*, %struct.tree_list** %153, align 4, !tbaa !19
  %purpose434 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %154, i32 0, i32 1
  %155 = load %union.tree_node*, %union.tree_node** %purpose434, align 4, !tbaa !19
  store %union.tree_node* %155, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value438 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %154, i32 0, i32 2
  %156 = load %union.tree_node*, %union.tree_node** %value438, align 4, !tbaa !19
  store %union.tree_node* %156, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain440 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %151, i32 0, i32 0, i32 0
  %157 = load %union.tree_node*, %union.tree_node** %chain440, align 4, !tbaa !19
  store %union.tree_node* %157, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body444:                                       ; preds = %if.end150
  %158 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value446 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %158, i32 0, i32 2
  %159 = load %union.tree_node*, %union.tree_node** %value446, align 4, !tbaa !19
  store %union.tree_node* %159, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose448 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %158, i32 0, i32 1
  %160 = bitcast %union.tree_node** %purpose448 to %struct.tree_list**
  %161 = load %struct.tree_list*, %struct.tree_list** %160, align 4, !tbaa !19
  %purpose450 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %161, i32 0, i32 1
  %162 = load %union.tree_node*, %union.tree_node** %purpose450, align 4, !tbaa !19
  store %union.tree_node* %162, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value454 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %161, i32 0, i32 2
  %163 = load %union.tree_node*, %union.tree_node** %value454, align 4, !tbaa !19
  store %union.tree_node* %163, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain456 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %158, i32 0, i32 0, i32 0
  %164 = load %union.tree_node*, %union.tree_node** %chain456, align 4, !tbaa !19
  store %union.tree_node* %164, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb459:                                         ; preds = %if.end150
  store i32 121, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb461:                                         ; preds = %if.end150
  store i32 77, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb463:                                         ; preds = %if.end150
  store i32 114, i32* %6, align 4, !tbaa !19
  %165 = load i32, i32* @warn_traditional, align 4, !tbaa !16
  %tobool465 = icmp eq i32 %165, 0
  %166 = load i32, i32* @in_system_header, align 4
  %tobool467 = icmp ne i32 %166, 0
  %or.cond4876 = select i1 %tobool465, i1 true, i1 %tobool467
  br i1 %or.cond4876, label %sw.epilog, label %if.then468

if.then468:                                       ; preds = %sw.bb463
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.18.2696, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb470:                                         ; preds = %if.end150
  store i32 130, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb472:                                         ; preds = %if.end150
  store i32 129, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb474:                                         ; preds = %if.end150
  store i32 90, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb476:                                         ; preds = %if.end150
  store i32 96, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb478:                                         ; preds = %if.end150
  %ttype480 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %167 = load %union.tree_node*, %union.tree_node** %ttype480, align 4, !tbaa !19
  %call481 = call %union.tree_node* @build_compound_expr(%union.tree_node* %167) #20
  store %union.tree_node* %call481, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb483:                                         ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb485:                                         ; preds = %if.end150
  %ttype487 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %168 = load %union.tree_node*, %union.tree_node** %ttype487, align 4, !tbaa !19
  %call488 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %168) #20
  store %union.tree_node* %call488, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb490:                                         ; preds = %if.end150
  %arrayidx491 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype492 = bitcast %union.anon.2* %arrayidx491 to %union.tree_node**
  %169 = load %union.tree_node*, %union.tree_node** %ttype492, align 4, !tbaa !19
  %ttype494 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %170 = load %union.tree_node*, %union.tree_node** %ttype494, align 4, !tbaa !19
  %call495 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %170) #20
  %call496 = call %union.tree_node* @chainon(%union.tree_node* %169, %union.tree_node* %call495) #20
  br label %sw.epilog

sw.bb497:                                         ; preds = %if.end150
  %ttype499 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %171 = load %union.tree_node*, %union.tree_node** %ttype499, align 4, !tbaa !19
  %call500 = call %union.tree_node* @build_indirect_ref(%union.tree_node* %171, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.19.2697, i32 0, i32 0)) #20
  store %union.tree_node* %call500, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb502:                                         ; preds = %if.end150
  %ttype504 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %172 = load %union.tree_node*, %union.tree_node** %ttype504, align 4, !tbaa !19
  store %union.tree_node* %172, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %arrayidx508 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype509 = bitcast %union.anon.2* %arrayidx508 to %union.tree_node**
  %173 = load %union.tree_node*, %union.tree_node** %ttype509, align 4, !tbaa !19
  %call510 = call i64 @tree_low_cst(%union.tree_node* %173, i32 0) #20
  %conv511 = trunc i64 %call510 to i32
  %and512 = and i32 %conv511, 1
  store i32 %and512, i32* @pedantic, align 4, !tbaa !16
  %shr5135771 = lshr i32 %conv511, 1
  %and514 = and i32 %shr5135771, 1
  store i32 %and514, i32* @warn_pointer_arith, align 4, !tbaa !16
  %shr5155772 = lshr i32 %conv511, 2
  %and516 = and i32 %shr5155772, 1
  store i32 %and516, i32* @warn_traditional, align 4, !tbaa !16
  br label %sw.epilog

sw.bb519:                                         ; preds = %if.end150
  %code521 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %174 = load i32, i32* %code521, align 4, !tbaa !19
  %ttype523 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %175 = load %union.tree_node*, %union.tree_node** %ttype523, align 4, !tbaa !19
  %call524 = call %union.tree_node* @build_unary_op(i32 %174, %union.tree_node* %175, i32 0) #20
  store %union.tree_node* %call524, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void @overflow_warning(%union.tree_node* %call524) #20
  br label %sw.epilog

sw.bb527:                                         ; preds = %if.end150
  %ttype529 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %176 = load %union.tree_node*, %union.tree_node** %ttype529, align 4, !tbaa !19
  %call530 = call %union.tree_node* @finish_label_address_expr(%union.tree_node* %176) #20
  store %union.tree_node* %call530, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb532:                                         ; preds = %if.end150
  %177 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %dec533 = add nsw i32 %177, -1
  store i32 %dec533, i32* @skip_evaluation, align 4, !tbaa !16
  %ttype535 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %178 = load %union.tree_node*, %union.tree_node** %ttype535, align 4, !tbaa !19
  %code537 = getelementptr inbounds %union.tree_node, %union.tree_node* %178, i32 0, i32 0, i32 0, i32 2
  %bf.load538 = load i32, i32* %code537, align 4
  %bf.clear539 = and i32 %bf.load538, 255
  %cmp540 = icmp eq i32 %bf.clear539, 39
  %179 = getelementptr %union.tree_node, %union.tree_node* %178, i32 0, i32 0, i32 0
  br i1 %cmp540, label %land.lhs.true542, label %if.end555

land.lhs.true542:                                 ; preds = %sw.bb532
  %operands546 = getelementptr inbounds %union.tree_node, %union.tree_node* %178, i32 0, i32 0, i32 2
  %arrayidx547 = getelementptr inbounds i32, i32* %operands546, i32 1
  %180 = bitcast i32* %arrayidx547 to %struct.tree_decl**
  %181 = load %struct.tree_decl*, %struct.tree_decl** %180, align 4, !tbaa !19
  %lang_flag_4 = getelementptr inbounds %struct.tree_decl, %struct.tree_decl* %181, i32 0, i32 5
  %182 = bitcast i48* %lang_flag_4 to i64*
  %bf.load549 = load i64, i64* %182, align 4
  %183 = and i64 %bf.load549, 2199023255552
  %cmp552.not = icmp eq i64 %183, 0
  br i1 %cmp552.not, label %if.end555, label %if.then554

if.then554:                                       ; preds = %land.lhs.true542
  call void (i8*, ...) @error(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20.2698, i32 0, i32 0)) #20
  %.phi.trans.insert = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_common**
  %.pre5850 = load %struct.tree_common*, %struct.tree_common** %.phi.trans.insert, align 4, !tbaa !19
  br label %if.end555

if.end555:                                        ; preds = %if.then554, %land.lhs.true542, %sw.bb532
  %184 = phi %struct.tree_common* [ %.pre5850, %if.then554 ], [ %179, %land.lhs.true542 ], [ %179, %sw.bb532 ]
  %type559 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %184, i32 0, i32 1
  %185 = load %union.tree_node*, %union.tree_node** %type559, align 4, !tbaa !19
  %call560 = call %union.tree_node* @c_sizeof(%union.tree_node* %185) #20
  store %union.tree_node* %call560, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb562:                                         ; preds = %if.end150
  %186 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %dec563 = add nsw i32 %186, -1
  store i32 %dec563, i32* @skip_evaluation, align 4, !tbaa !16
  %arrayidx564 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype565 = bitcast %union.anon.2* %arrayidx564 to %union.tree_node**
  %187 = load %union.tree_node*, %union.tree_node** %ttype565, align 4, !tbaa !19
  %call566 = call %union.tree_node* @groktypename(%union.tree_node* %187) #20
  %call567 = call %union.tree_node* @c_sizeof(%union.tree_node* %call566) #20
  store %union.tree_node* %call567, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb569:                                         ; preds = %if.end150
  %188 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %dec570 = add nsw i32 %188, -1
  store i32 %dec570, i32* @skip_evaluation, align 4, !tbaa !16
  %ttype572 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %189 = load %union.tree_node*, %union.tree_node** %ttype572, align 4, !tbaa !19
  %call573 = call %union.tree_node* @c_alignof_expr(%union.tree_node* %189) #20
  store %union.tree_node* %call573, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb575:                                         ; preds = %if.end150
  %190 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %dec576 = add nsw i32 %190, -1
  store i32 %dec576, i32* @skip_evaluation, align 4, !tbaa !16
  %arrayidx577 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype578 = bitcast %union.anon.2* %arrayidx577 to %union.tree_node**
  %191 = load %union.tree_node*, %union.tree_node** %ttype578, align 4, !tbaa !19
  %call579 = call %union.tree_node* @groktypename(%union.tree_node* %191) #20
  %call580 = call %union.tree_node* @c_alignof(%union.tree_node* %call579) #20
  store %union.tree_node* %call580, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb582:                                         ; preds = %if.end150
  %ttype584 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %192 = load %union.tree_node*, %union.tree_node** %ttype584, align 4, !tbaa !19
  %call585 = call %union.tree_node* @build_unary_op(i32 127, %union.tree_node* %192, i32 0) #20
  store %union.tree_node* %call585, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb587:                                         ; preds = %if.end150
  %ttype589 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %193 = load %union.tree_node*, %union.tree_node** %ttype589, align 4, !tbaa !19
  %call590 = call %union.tree_node* @build_unary_op(i32 128, %union.tree_node* %193, i32 0) #20
  store %union.tree_node* %call590, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb592:                                         ; preds = %if.end150
  %194 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %inc593 = add nsw i32 %194, 1
  store i32 %inc593, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb594:                                         ; preds = %if.end150
  %195 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %inc595 = add nsw i32 %195, 1
  store i32 %inc595, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb596:                                         ; preds = %if.end150
  %arrayidx597 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype598 = bitcast %union.anon.2* %arrayidx597 to %union.tree_node**
  %196 = load %union.tree_node*, %union.tree_node** %ttype598, align 4, !tbaa !19
  %ttype600 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %197 = load %union.tree_node*, %union.tree_node** %ttype600, align 4, !tbaa !19
  %call601 = call %union.tree_node* @c_cast_expr(%union.tree_node* %196, %union.tree_node* %197) #20
  store %union.tree_node* %call601, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb603:                                         ; preds = %if.end150
  %code605 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %198 = load i32, i32* %code605, align 4, !tbaa !19
  %arrayidx606 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype607 = bitcast %union.anon.2* %arrayidx606 to %union.tree_node**
  %199 = load %union.tree_node*, %union.tree_node** %ttype607, align 4, !tbaa !19
  %ttype609 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %200 = load %union.tree_node*, %union.tree_node** %ttype609, align 4, !tbaa !19
  %call610 = call %union.tree_node* @parser_build_binary_op(i32 %198, %union.tree_node* %199, %union.tree_node* %200) #20
  store %union.tree_node* %call610, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb612:                                         ; preds = %if.end150
  %code614 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %201 = load i32, i32* %code614, align 4, !tbaa !19
  %arrayidx615 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype616 = bitcast %union.anon.2* %arrayidx615 to %union.tree_node**
  %202 = load %union.tree_node*, %union.tree_node** %ttype616, align 4, !tbaa !19
  %ttype618 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %203 = load %union.tree_node*, %union.tree_node** %ttype618, align 4, !tbaa !19
  %call619 = call %union.tree_node* @parser_build_binary_op(i32 %201, %union.tree_node* %202, %union.tree_node* %203) #20
  store %union.tree_node* %call619, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb621:                                         ; preds = %if.end150
  %code623 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %204 = load i32, i32* %code623, align 4, !tbaa !19
  %arrayidx624 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype625 = bitcast %union.anon.2* %arrayidx624 to %union.tree_node**
  %205 = load %union.tree_node*, %union.tree_node** %ttype625, align 4, !tbaa !19
  %ttype627 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %206 = load %union.tree_node*, %union.tree_node** %ttype627, align 4, !tbaa !19
  %call628 = call %union.tree_node* @parser_build_binary_op(i32 %204, %union.tree_node* %205, %union.tree_node* %206) #20
  store %union.tree_node* %call628, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb630:                                         ; preds = %if.end150
  %code632 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %207 = load i32, i32* %code632, align 4, !tbaa !19
  %arrayidx633 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype634 = bitcast %union.anon.2* %arrayidx633 to %union.tree_node**
  %208 = load %union.tree_node*, %union.tree_node** %ttype634, align 4, !tbaa !19
  %ttype636 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %209 = load %union.tree_node*, %union.tree_node** %ttype636, align 4, !tbaa !19
  %call637 = call %union.tree_node* @parser_build_binary_op(i32 %207, %union.tree_node* %208, %union.tree_node* %209) #20
  store %union.tree_node* %call637, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb639:                                         ; preds = %if.end150
  %code641 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %210 = load i32, i32* %code641, align 4, !tbaa !19
  %arrayidx642 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype643 = bitcast %union.anon.2* %arrayidx642 to %union.tree_node**
  %211 = load %union.tree_node*, %union.tree_node** %ttype643, align 4, !tbaa !19
  %ttype645 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %212 = load %union.tree_node*, %union.tree_node** %ttype645, align 4, !tbaa !19
  %call646 = call %union.tree_node* @parser_build_binary_op(i32 %210, %union.tree_node* %211, %union.tree_node* %212) #20
  store %union.tree_node* %call646, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb648:                                         ; preds = %if.end150
  %code650 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %213 = load i32, i32* %code650, align 4, !tbaa !19
  %arrayidx651 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype652 = bitcast %union.anon.2* %arrayidx651 to %union.tree_node**
  %214 = load %union.tree_node*, %union.tree_node** %ttype652, align 4, !tbaa !19
  %ttype654 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %215 = load %union.tree_node*, %union.tree_node** %ttype654, align 4, !tbaa !19
  %call655 = call %union.tree_node* @parser_build_binary_op(i32 %213, %union.tree_node* %214, %union.tree_node* %215) #20
  store %union.tree_node* %call655, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb657:                                         ; preds = %if.end150
  %code659 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %216 = load i32, i32* %code659, align 4, !tbaa !19
  %arrayidx660 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype661 = bitcast %union.anon.2* %arrayidx660 to %union.tree_node**
  %217 = load %union.tree_node*, %union.tree_node** %ttype661, align 4, !tbaa !19
  %ttype663 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %218 = load %union.tree_node*, %union.tree_node** %ttype663, align 4, !tbaa !19
  %call664 = call %union.tree_node* @parser_build_binary_op(i32 %216, %union.tree_node* %217, %union.tree_node* %218) #20
  store %union.tree_node* %call664, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb666:                                         ; preds = %if.end150
  %code668 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %219 = load i32, i32* %code668, align 4, !tbaa !19
  %arrayidx669 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype670 = bitcast %union.anon.2* %arrayidx669 to %union.tree_node**
  %220 = load %union.tree_node*, %union.tree_node** %ttype670, align 4, !tbaa !19
  %ttype672 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %221 = load %union.tree_node*, %union.tree_node** %ttype672, align 4, !tbaa !19
  %call673 = call %union.tree_node* @parser_build_binary_op(i32 %219, %union.tree_node* %220, %union.tree_node* %221) #20
  store %union.tree_node* %call673, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb675:                                         ; preds = %if.end150
  %code677 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %222 = load i32, i32* %code677, align 4, !tbaa !19
  %arrayidx678 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype679 = bitcast %union.anon.2* %arrayidx678 to %union.tree_node**
  %223 = load %union.tree_node*, %union.tree_node** %ttype679, align 4, !tbaa !19
  %ttype681 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %224 = load %union.tree_node*, %union.tree_node** %ttype681, align 4, !tbaa !19
  %call682 = call %union.tree_node* @parser_build_binary_op(i32 %222, %union.tree_node* %223, %union.tree_node* %224) #20
  store %union.tree_node* %call682, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb684:                                         ; preds = %if.end150
  %code686 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %225 = load i32, i32* %code686, align 4, !tbaa !19
  %arrayidx687 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype688 = bitcast %union.anon.2* %arrayidx687 to %union.tree_node**
  %226 = load %union.tree_node*, %union.tree_node** %ttype688, align 4, !tbaa !19
  %ttype690 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %227 = load %union.tree_node*, %union.tree_node** %ttype690, align 4, !tbaa !19
  %call691 = call %union.tree_node* @parser_build_binary_op(i32 %225, %union.tree_node* %226, %union.tree_node* %227) #20
  store %union.tree_node* %call691, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb693:                                         ; preds = %if.end150
  %code695 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %228 = load i32, i32* %code695, align 4, !tbaa !19
  %arrayidx696 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype697 = bitcast %union.anon.2* %arrayidx696 to %union.tree_node**
  %229 = load %union.tree_node*, %union.tree_node** %ttype697, align 4, !tbaa !19
  %ttype699 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %230 = load %union.tree_node*, %union.tree_node** %ttype699, align 4, !tbaa !19
  %call700 = call %union.tree_node* @parser_build_binary_op(i32 %228, %union.tree_node* %229, %union.tree_node* %230) #20
  store %union.tree_node* %call700, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb702:                                         ; preds = %if.end150
  %code704 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %231 = load i32, i32* %code704, align 4, !tbaa !19
  %arrayidx705 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype706 = bitcast %union.anon.2* %arrayidx705 to %union.tree_node**
  %232 = load %union.tree_node*, %union.tree_node** %ttype706, align 4, !tbaa !19
  %ttype708 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %233 = load %union.tree_node*, %union.tree_node** %ttype708, align 4, !tbaa !19
  %call709 = call %union.tree_node* @parser_build_binary_op(i32 %231, %union.tree_node* %232, %union.tree_node* %233) #20
  store %union.tree_node* %call709, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb711:                                         ; preds = %if.end150
  %arrayidx712 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype713 = bitcast %union.anon.2* %arrayidx712 to %union.tree_node**
  %234 = load %union.tree_node*, %union.tree_node** %ttype713, align 4, !tbaa !19
  %call714 = call %union.tree_node* @default_conversion(%union.tree_node* %234) #20
  %call715 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %call714) #20
  store %union.tree_node* %call715, %union.tree_node** %ttype713, align 4, !tbaa !19
  %235 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 18), align 4, !tbaa !15
  %cmp720 = icmp eq %union.tree_node* %call715, %235
  %conv721 = zext i1 %cmp720 to i32
  %236 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %add722 = add nsw i32 %236, %conv721
  store i32 %add722, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb723:                                         ; preds = %if.end150
  %arrayidx724 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype725 = bitcast %union.anon.2* %arrayidx724 to %union.tree_node**
  %237 = load %union.tree_node*, %union.tree_node** %ttype725, align 4, !tbaa !19
  %238 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 18), align 4, !tbaa !15
  %cmp726 = icmp eq %union.tree_node* %237, %238
  %conv727.neg = sext i1 %cmp726 to i32
  %239 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %sub728 = add i32 %239, %conv727.neg
  store i32 %sub728, i32* @skip_evaluation, align 4, !tbaa !16
  %240 = load %union.tree_node*, %union.tree_node** %ttype725, align 4, !tbaa !19
  %ttype732 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %241 = load %union.tree_node*, %union.tree_node** %ttype732, align 4, !tbaa !19
  %call733 = call %union.tree_node* @parser_build_binary_op(i32 91, %union.tree_node* %240, %union.tree_node* %241) #20
  store %union.tree_node* %call733, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb735:                                         ; preds = %if.end150
  %arrayidx736 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype737 = bitcast %union.anon.2* %arrayidx736 to %union.tree_node**
  %242 = load %union.tree_node*, %union.tree_node** %ttype737, align 4, !tbaa !19
  %call738 = call %union.tree_node* @default_conversion(%union.tree_node* %242) #20
  %call739 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %call738) #20
  store %union.tree_node* %call739, %union.tree_node** %ttype737, align 4, !tbaa !19
  %243 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 17), align 4, !tbaa !15
  %cmp744 = icmp eq %union.tree_node* %call739, %243
  %conv745 = zext i1 %cmp744 to i32
  %244 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %add746 = add nsw i32 %244, %conv745
  store i32 %add746, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb747:                                         ; preds = %if.end150
  %arrayidx748 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype749 = bitcast %union.anon.2* %arrayidx748 to %union.tree_node**
  %245 = load %union.tree_node*, %union.tree_node** %ttype749, align 4, !tbaa !19
  %246 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 17), align 4, !tbaa !15
  %cmp750 = icmp eq %union.tree_node* %245, %246
  %conv751.neg = sext i1 %cmp750 to i32
  %247 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %sub752 = add i32 %247, %conv751.neg
  store i32 %sub752, i32* @skip_evaluation, align 4, !tbaa !16
  %248 = load %union.tree_node*, %union.tree_node** %ttype749, align 4, !tbaa !19
  %ttype756 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %249 = load %union.tree_node*, %union.tree_node** %ttype756, align 4, !tbaa !19
  %call757 = call %union.tree_node* @parser_build_binary_op(i32 92, %union.tree_node* %248, %union.tree_node* %249) #20
  store %union.tree_node* %call757, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb759:                                         ; preds = %if.end150
  %arrayidx760 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype761 = bitcast %union.anon.2* %arrayidx760 to %union.tree_node**
  %250 = load %union.tree_node*, %union.tree_node** %ttype761, align 4, !tbaa !19
  %call762 = call %union.tree_node* @default_conversion(%union.tree_node* %250) #20
  %call763 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %call762) #20
  store %union.tree_node* %call763, %union.tree_node** %ttype761, align 4, !tbaa !19
  %251 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 18), align 4, !tbaa !15
  %cmp768 = icmp eq %union.tree_node* %call763, %251
  %conv769 = zext i1 %cmp768 to i32
  %252 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %add770 = add nsw i32 %252, %conv769
  store i32 %add770, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb771:                                         ; preds = %if.end150
  %arrayidx772 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype773 = bitcast %union.anon.2* %arrayidx772 to %union.tree_node**
  %253 = load %union.tree_node*, %union.tree_node** %ttype773, align 4, !tbaa !19
  %254 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 17), align 4, !tbaa !15
  %cmp774 = icmp eq %union.tree_node* %253, %254
  %conv775 = zext i1 %cmp774 to i32
  %255 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 18), align 4, !tbaa !15
  %cmp778 = icmp eq %union.tree_node* %253, %255
  %conv779.neg = sext i1 %cmp778 to i32
  %256 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %sub780 = add i32 %256, %conv775
  %add781 = add i32 %sub780, %conv779.neg
  store i32 %add781, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb782:                                         ; preds = %if.end150
  %arrayidx783 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype784 = bitcast %union.anon.2* %arrayidx783 to %union.tree_node**
  %257 = load %union.tree_node*, %union.tree_node** %ttype784, align 4, !tbaa !19
  %258 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 17), align 4, !tbaa !15
  %cmp785 = icmp eq %union.tree_node* %257, %258
  %conv786.neg = sext i1 %cmp785 to i32
  %259 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %sub787 = add i32 %259, %conv786.neg
  store i32 %sub787, i32* @skip_evaluation, align 4, !tbaa !16
  %260 = load %union.tree_node*, %union.tree_node** %ttype784, align 4, !tbaa !19
  %arrayidx790 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype791 = bitcast %union.anon.2* %arrayidx790 to %union.tree_node**
  %261 = load %union.tree_node*, %union.tree_node** %ttype791, align 4, !tbaa !19
  %ttype793 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %262 = load %union.tree_node*, %union.tree_node** %ttype793, align 4, !tbaa !19
  %call794 = call %union.tree_node* @build_conditional_expr(%union.tree_node* %260, %union.tree_node* %261, %union.tree_node* %262) #20
  store %union.tree_node* %call794, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb796:                                         ; preds = %if.end150
  %263 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool797.not = icmp eq i32 %263, 0
  br i1 %tobool797.not, label %if.end799, label %if.then798

if.then798:                                       ; preds = %sw.bb796
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.21.2699, i32 0, i32 0)) #20
  br label %if.end799

if.end799:                                        ; preds = %if.then798, %sw.bb796
  %arrayidx800 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype801 = bitcast %union.anon.2* %arrayidx800 to %union.tree_node**
  %264 = load %union.tree_node*, %union.tree_node** %ttype801, align 4, !tbaa !19
  %call802 = call %union.tree_node* @save_expr(%union.tree_node* %264) #20
  %ttype804 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  store %union.tree_node* %call802, %union.tree_node** %ttype804, align 4, !tbaa !19
  %call807 = call %union.tree_node* @default_conversion(%union.tree_node* %call802) #20
  %call808 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %call807) #20
  store %union.tree_node* %call808, %union.tree_node** %ttype801, align 4, !tbaa !19
  %265 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 17), align 4, !tbaa !15
  %cmp813 = icmp eq %union.tree_node* %call808, %265
  %conv814 = zext i1 %cmp813 to i32
  %266 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %add815 = add nsw i32 %266, %conv814
  store i32 %add815, i32* @skip_evaluation, align 4, !tbaa !16
  br label %sw.epilog

sw.bb816:                                         ; preds = %if.end150
  %arrayidx817 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype818 = bitcast %union.anon.2* %arrayidx817 to %union.tree_node**
  %267 = load %union.tree_node*, %union.tree_node** %ttype818, align 4, !tbaa !19
  %268 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([32 x %union.tree_node*], [32 x %union.tree_node*]* @c_global_trees, i32 0, i32 17), align 4, !tbaa !15
  %cmp819 = icmp eq %union.tree_node* %267, %268
  %conv820.neg = sext i1 %cmp819 to i32
  %269 = load i32, i32* @skip_evaluation, align 4, !tbaa !16
  %sub821 = add i32 %269, %conv820.neg
  store i32 %sub821, i32* @skip_evaluation, align 4, !tbaa !16
  %270 = load %union.tree_node*, %union.tree_node** %ttype818, align 4, !tbaa !19
  %arrayidx824 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype825 = bitcast %union.anon.2* %arrayidx824 to %union.tree_node**
  %271 = load %union.tree_node*, %union.tree_node** %ttype825, align 4, !tbaa !19
  %ttype827 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %272 = load %union.tree_node*, %union.tree_node** %ttype827, align 4, !tbaa !19
  %call828 = call %union.tree_node* @build_conditional_expr(%union.tree_node* %270, %union.tree_node* %271, %union.tree_node* %272) #20
  store %union.tree_node* %call828, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb830:                                         ; preds = %if.end150
  %arrayidx831 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype832 = bitcast %union.anon.2* %arrayidx831 to %union.tree_node**
  %273 = load %union.tree_node*, %union.tree_node** %ttype832, align 4, !tbaa !19
  %ttype834 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %274 = load %union.tree_node*, %union.tree_node** %ttype834, align 4, !tbaa !19
  %call835 = call %union.tree_node* @build_modify_expr(%union.tree_node* %273, i32 115, %union.tree_node* %274) #20
  store %union.tree_node* %call835, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %code839 = getelementptr inbounds %union.tree_node, %union.tree_node* %call835, i32 0, i32 0, i32 0, i32 2
  %bf.load840 = load i32, i32* %code839, align 4
  %bf.clear841 = and i32 %bf.load840, 255
  %arrayidx842 = getelementptr inbounds [256 x i8], [256 x i8]* bitcast (<{ [147 x i8], [109 x i8] }>* @tree_code_type to [256 x i8]*), i32 0, i32 %bf.clear841
  %275 = load i8, i8* %arrayidx842, align 1, !tbaa !19
  switch i8 %275, label %sw.epilog [
    i8 60, label %if.then858
    i8 49, label %if.then858
    i8 50, label %if.then858
    i8 101, label %if.then858
  ]

if.then858:                                       ; preds = %sw.bb830, %sw.bb830, %sw.bb830, %sw.bb830
  %complexity = getelementptr inbounds %union.tree_node, %union.tree_node* %call835, i32 0, i32 0, i32 1
  %276 = bitcast i8** %complexity to i32*
  store i32 48, i32* %276, align 4, !tbaa !19
  br label %sw.epilog

sw.bb863:                                         ; preds = %if.end150
  %arrayidx865 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype866 = bitcast %union.anon.2* %arrayidx865 to %union.tree_node**
  %277 = load %union.tree_node*, %union.tree_node** %ttype866, align 4, !tbaa !19
  %code868 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %278 = load i32, i32* %code868, align 4, !tbaa !19
  %ttype870 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %279 = load %union.tree_node*, %union.tree_node** %ttype870, align 4, !tbaa !19
  %call871 = call %union.tree_node* @build_modify_expr(%union.tree_node* %277, i32 %278, %union.tree_node* %279) #20
  store %union.tree_node* %call871, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %code875 = getelementptr inbounds %union.tree_node, %union.tree_node* %call871, i32 0, i32 0, i32 0, i32 2
  %bf.load876 = load i32, i32* %code875, align 4
  %bf.clear877 = and i32 %bf.load876, 255
  %arrayidx878 = getelementptr inbounds [256 x i8], [256 x i8]* bitcast (<{ [147 x i8], [109 x i8] }>* @tree_code_type to [256 x i8]*), i32 0, i32 %bf.clear877
  %280 = load i8, i8* %arrayidx878, align 1, !tbaa !19
  switch i8 %280, label %sw.epilog [
    i8 60, label %if.then894
    i8 49, label %if.then894
    i8 50, label %if.then894
    i8 101, label %if.then894
  ]

if.then894:                                       ; preds = %sw.bb863, %sw.bb863, %sw.bb863, %sw.bb863
  %complexity897 = getelementptr inbounds %union.tree_node, %union.tree_node* %call871, i32 0, i32 0, i32 1
  %281 = bitcast i8** %complexity897 to i32*
  store i32 0, i32* %281, align 4, !tbaa !19
  br label %sw.epilog

sw.bb900:                                         ; preds = %if.end150
  %282 = load i32, i32* @yychar, align 4, !tbaa !16
  %cmp901 = icmp eq i32 %282, -2
  br i1 %cmp901, label %if.then903, label %if.end905

if.then903:                                       ; preds = %sw.bb900
  %call904 = call fastcc i32 @yylex() #21
  store i32 %call904, i32* @yychar, align 4, !tbaa !16
  br label %if.end905

if.end905:                                        ; preds = %if.then903, %sw.bb900
  %283 = phi i32 [ %call904, %if.then903 ], [ %282, %sw.bb900 ]
  %ttype907 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %284 = load %union.tree_node*, %union.tree_node** %ttype907, align 4, !tbaa !19
  %cmp908 = icmp eq i32 %283, 40
  %conv909 = zext i1 %cmp908 to i32
  %call910 = call %union.tree_node* @build_external_ref(%union.tree_node* %284, i32 %conv909) #20
  store %union.tree_node* %call910, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb912:                                         ; preds = %if.end150
  %ttype914 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %285 = load %union.tree_node*, %union.tree_node** %ttype914, align 4, !tbaa !19
  %call915 = call %union.tree_node* @combine_strings(%union.tree_node* %285) #20
  store %union.tree_node* %call915, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb917:                                         ; preds = %if.end150
  %286 = load %union.tree_node*, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %node = getelementptr inbounds %union.tree_node, %union.tree_node* %286, i32 0, i32 0, i32 1
  %287 = bitcast i8** %node to %struct.cpp_hashnode*
  %rid_code = getelementptr inbounds %struct.cpp_hashnode, %struct.cpp_hashnode* %287, i32 0, i32 3
  %288 = load i8, i8* %rid_code, align 1, !tbaa !57
  %conv919 = zext i8 %288 to i32
  %call921 = call %union.tree_node* @fname_decl(i32 %conv919, %union.tree_node* %286) #20
  store %union.tree_node* %call921, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb923:                                         ; preds = %if.end150
  call void @start_init(%union.tree_node* null, %union.tree_node* null, i32 0) #20
  %arrayidx924 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype925 = bitcast %union.anon.2* %arrayidx924 to %union.tree_node**
  %289 = load %union.tree_node*, %union.tree_node** %ttype925, align 4, !tbaa !19
  %call926 = call %union.tree_node* @groktypename(%union.tree_node* %289) #20
  store %union.tree_node* %call926, %union.tree_node** %ttype925, align 4, !tbaa !19
  call void @really_start_incremental_init(%union.tree_node* %call926) #20
  br label %sw.epilog

sw.bb931:                                         ; preds = %if.end150
  %call932 = call %union.tree_node* @pop_init_level(i32 0) #20
  %arrayidx934 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %ttype935 = bitcast %union.anon.2* %arrayidx934 to %union.tree_node**
  %290 = load %union.tree_node*, %union.tree_node** %ttype935, align 4, !tbaa !19
  call void @finish_init() #20
  %291 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool936 = icmp eq i32 %291, 0
  %292 = load i32, i32* @flag_isoc99, align 4
  %tobool938 = icmp ne i32 %292, 0
  %or.cond4877 = select i1 %tobool936, i1 true, i1 %tobool938
  br i1 %or.cond4877, label %if.end940, label %if.then939

if.then939:                                       ; preds = %sw.bb931
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.22.2700, i32 0, i32 0)) #20
  br label %if.end940

if.end940:                                        ; preds = %if.then939, %sw.bb931
  %call941 = call %union.tree_node* @build_compound_literal(%union.tree_node* %290, %union.tree_node* %call932) #20
  store %union.tree_node* %call941, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb945:                                         ; preds = %if.end150
  %arrayidx947 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %293 = bitcast %union.anon.2* %arrayidx947 to %struct.tree_common**
  %294 = load %struct.tree_common*, %struct.tree_common** %293, align 4, !tbaa !19
  %code950 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %294, i32 0, i32 2
  %bf.load951 = load i32, i32* %code950, align 4
  %bf.clear952 = and i32 %bf.load951, 255
  %arrayidx953 = getelementptr inbounds [256 x i8], [256 x i8]* bitcast (<{ [147 x i8], [109 x i8] }>* @tree_code_type to [256 x i8]*), i32 0, i32 %bf.clear952
  %295 = load i8, i8* %arrayidx953, align 1, !tbaa !19
  %296 = bitcast %struct.tree_common* %294 to %union.tree_node*
  switch i8 %295, label %if.end974 [
    i8 60, label %if.then969
    i8 49, label %if.then969
    i8 50, label %if.then969
    i8 101, label %if.then969
  ]

if.then969:                                       ; preds = %sw.bb945, %sw.bb945, %sw.bb945, %sw.bb945
  %ttype948 = bitcast %union.anon.2* %arrayidx947 to %union.tree_node**
  %complexity973 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %294, i32 1
  %297 = bitcast %struct.tree_common* %complexity973 to i32*
  store i32 0, i32* %297, align 4, !tbaa !19
  %.pre5849 = load %union.tree_node*, %union.tree_node** %ttype948, align 4, !tbaa !19
  br label %if.end974

if.end974:                                        ; preds = %if.then969, %sw.bb945
  %298 = phi %union.tree_node* [ %296, %sw.bb945 ], [ %.pre5849, %if.then969 ]
  store %union.tree_node* %298, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb979:                                         ; preds = %if.end150
  %299 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  store %union.tree_node* %299, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb981:                                         ; preds = %if.end150
  %300 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool982.not = icmp eq i32 %300, 0
  br i1 %tobool982.not, label %if.end984, label %if.then983

if.then983:                                       ; preds = %sw.bb981
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([47 x i8], [47 x i8]* @.str.23.2701, i32 0, i32 0)) #20
  br label %if.end984

if.end984:                                        ; preds = %if.then983, %sw.bb981
  call void @pop_label_level() #20
  %arrayidx985 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype986 = bitcast %union.anon.2* %arrayidx985 to %union.tree_node**
  %301 = load %union.tree_node*, %union.tree_node** %ttype986, align 4, !tbaa !19
  %operands988 = getelementptr inbounds %union.tree_node, %union.tree_node* %301, i32 0, i32 0, i32 2
  %arrayidx989 = bitcast i32* %operands988 to %union.tree_node**
  %302 = load %union.tree_node*, %union.tree_node** %arrayidx989, align 4, !tbaa !19
  %chain994 = getelementptr inbounds %union.tree_node, %union.tree_node* %301, i32 0, i32 0, i32 0, i32 0
  %303 = load %union.tree_node*, %union.tree_node** %chain994, align 4, !tbaa !19
  store %union.tree_node* %303, %union.tree_node** %arrayidx989, align 4, !tbaa !19
  %304 = bitcast %union.anon.2* %arrayidx985 to %struct.tree_common**
  %305 = load %struct.tree_common*, %struct.tree_common** %304, align 4, !tbaa !19
  %chain1003 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %305, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain1003, align 4, !tbaa !19
  %306 = load %union.tree_node*, %union.tree_node** %ttype986, align 4, !tbaa !19
  %call1006 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call1006, i32 0, i32 0
  store %union.tree_node* %306, %union.tree_node** %x_last_stmt, align 4, !tbaa !62
  %call1009 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt1010 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call1009, i32 0, i32 0
  store %union.tree_node* %302, %union.tree_node** %x_last_stmt1010, align 4, !tbaa !62
  %call1011 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %307 = bitcast %struct.stmt_tree_s* %call1011 to %struct.tree_common**
  %308 = load %struct.tree_common*, %struct.tree_common** %307, align 4, !tbaa !62
  %chain1014 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %308, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain1014, align 4, !tbaa !19
  %call1015 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_expr_type = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call1015, i32 0, i32 1
  %309 = load %union.tree_node*, %union.tree_node** %x_last_expr_type, align 4, !tbaa !64
  %tobool1016.not = icmp eq %union.tree_node* %309, null
  br i1 %tobool1016.not, label %if.then1017, label %if.end1020

if.then1017:                                      ; preds = %if.end984
  %310 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 27), align 4, !tbaa !15
  %call1018 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_expr_type1019 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call1018, i32 0, i32 1
  store %union.tree_node* %310, %union.tree_node** %x_last_expr_type1019, align 4, !tbaa !64
  br label %if.end1020

if.end1020:                                       ; preds = %if.then1017, %if.end984
  %call1021 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_expr_type1022 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call1021, i32 0, i32 1
  %311 = load %union.tree_node*, %union.tree_node** %x_last_expr_type1022, align 4, !tbaa !64
  %312 = load %union.tree_node*, %union.tree_node** %ttype986, align 4, !tbaa !19
  %call1025 = call %union.tree_node* @build1(i32 169, %union.tree_node* %311, %union.tree_node* %312) #20
  store %union.tree_node* %call1025, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %side_effects_flag = getelementptr inbounds %union.tree_node, %union.tree_node* %call1025, i32 0, i32 0, i32 0, i32 2
  %bf.load1029 = load i32, i32* %side_effects_flag, align 4
  %bf.set = or i32 %bf.load1029, 256
  store i32 %bf.set, i32* %side_effects_flag, align 4
  br label %sw.epilog

sw.bb1032:                                        ; preds = %if.end150
  call void @pop_label_level() #20
  %arrayidx1033 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %313 = bitcast %union.anon.2* %arrayidx1033 to %struct.tree_exp**
  %314 = load %struct.tree_exp*, %struct.tree_exp** %313, align 4, !tbaa !19
  %arrayidx1037 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %314, i32 0, i32 2, i32 0
  %315 = load %union.tree_node*, %union.tree_node** %arrayidx1037, align 4, !tbaa !19
  %call1038 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt1039 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call1038, i32 0, i32 0
  store %union.tree_node* %315, %union.tree_node** %x_last_stmt1039, align 4, !tbaa !62
  %call1040 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %316 = bitcast %struct.stmt_tree_s* %call1040 to %struct.tree_common**
  %317 = load %struct.tree_common*, %struct.tree_common** %316, align 4, !tbaa !62
  %chain1043 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %317, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain1043, align 4, !tbaa !19
  %318 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  store %union.tree_node* %318, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1045:                                        ; preds = %if.end150
  %arrayidx1046 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype1047 = bitcast %union.anon.2* %arrayidx1046 to %union.tree_node**
  %319 = load %union.tree_node*, %union.tree_node** %ttype1047, align 4, !tbaa !19
  %arrayidx1048 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1049 = bitcast %union.anon.2* %arrayidx1048 to %union.tree_node**
  %320 = load %union.tree_node*, %union.tree_node** %ttype1049, align 4, !tbaa !19
  %call1050 = call %union.tree_node* @build_function_call(%union.tree_node* %319, %union.tree_node* %320) #20
  store %union.tree_node* %call1050, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1052:                                        ; preds = %if.end150
  %arrayidx1053 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype1054 = bitcast %union.anon.2* %arrayidx1053 to %union.tree_node**
  %321 = load %union.tree_node*, %union.tree_node** %ttype1054, align 4, !tbaa !19
  %arrayidx1055 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1056 = bitcast %union.anon.2* %arrayidx1055 to %union.tree_node**
  %322 = load %union.tree_node*, %union.tree_node** %ttype1056, align 4, !tbaa !19
  %call1057 = call %union.tree_node* @groktypename(%union.tree_node* %322) #20
  %call1058 = call %union.tree_node* @build_va_arg(%union.tree_node* %321, %union.tree_node* %call1057) #20
  store %union.tree_node* %call1058, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1060:                                        ; preds = %if.end150
  %arrayidx1061 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %ttype1062 = bitcast %union.anon.2* %arrayidx1061 to %union.tree_node**
  %323 = load %union.tree_node*, %union.tree_node** %ttype1062, align 4, !tbaa !19
  %call1063 = call %union.tree_node* @fold(%union.tree_node* %323) #20
  %324 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4
  br label %while.cond1064

while.cond1064:                                   ; preds = %land.rhs1091, %sw.bb1060
  %c.0 = phi %union.tree_node* [ %call1063, %sw.bb1060 ], [ %325, %land.rhs1091 ]
  %code1066 = getelementptr inbounds %union.tree_node, %union.tree_node* %c.0, i32 0, i32 0, i32 0, i32 2
  %bf.load1067 = load i32, i32* %code1066, align 4
  %bf.clear1068 = and i32 %bf.load1067, 255
  %bf.clear1068.off = add nsw i32 %bf.clear1068, -114
  %switch5776 = icmp ult i32 %bf.clear1068.off, 3
  br i1 %switch5776, label %land.lhs.true1085, label %while.end1116

land.lhs.true1085:                                ; preds = %while.cond1064
  %operands1087 = getelementptr inbounds %union.tree_node, %union.tree_node* %c.0, i32 0, i32 0, i32 2
  %arrayidx1088 = bitcast i32* %operands1087 to %union.tree_node**
  %325 = load %union.tree_node*, %union.tree_node** %arrayidx1088, align 4, !tbaa !19
  %cmp1089.not = icmp eq %union.tree_node* %325, %324
  br i1 %cmp1089.not, label %if.then1123, label %land.rhs1091

land.rhs1091:                                     ; preds = %land.lhs.true1085
  %type1093 = getelementptr inbounds %union.tree_node, %union.tree_node* %c.0, i32 0, i32 0, i32 0, i32 1
  %326 = bitcast %union.tree_node** %type1093 to %struct.tree_type**
  %327 = load %struct.tree_type*, %struct.tree_type** %326, align 4, !tbaa !19
  %mode1095 = getelementptr inbounds %struct.tree_type, %struct.tree_type* %327, i32 0, i32 6
  %bf.load1096 = load i32, i32* %mode1095, align 4
  %type1103 = getelementptr inbounds %union.tree_node, %union.tree_node* %325, i32 0, i32 0, i32 0, i32 1
  %328 = bitcast %union.tree_node** %type1103 to %struct.tree_type**
  %329 = load %struct.tree_type*, %struct.tree_type** %328, align 4, !tbaa !19
  %mode1105 = getelementptr inbounds %struct.tree_type, %struct.tree_type* %329, i32 0, i32 6
  %bf.load1106 = load i32, i32* %mode1105, align 4
  %bf.lshr10975769 = xor i32 %bf.load1106, %bf.load1096
  %330 = and i32 %bf.lshr10975769, 65024
  %cmp1109 = icmp eq i32 %330, 0
  br i1 %cmp1109, label %while.cond1064, label %if.then1123, !llvm.loop !65

while.end1116:                                    ; preds = %while.cond1064
  %cmp1121.not = icmp eq i32 %bf.clear1068, 25
  br i1 %cmp1121.not, label %if.end1124, label %if.then1123

if.then1123:                                      ; preds = %while.end1116, %land.rhs1091, %land.lhs.true1085
  call void (i8*, ...) @error(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @.str.24.2702, i32 0, i32 0)) #20
  br label %if.end1124

if.end1124:                                       ; preds = %if.then1123, %while.end1116
  %call1125 = call i32 @integer_zerop(%union.tree_node* nonnull %c.0) #20
  %tobool1126.not = icmp eq i32 %call1125, 0
  %cond1134.in.in.v = select i1 %tobool1126.not, i32 -3, i32 -1
  %cond1134.in.in = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 %cond1134.in.in.v
  %cond1134.in = bitcast %union.anon.2* %cond1134.in.in to %union.tree_node**
  %cond1134 = load %union.tree_node*, %union.tree_node** %cond1134.in, align 4, !tbaa !19
  store %union.tree_node* %cond1134, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1137:                                        ; preds = %if.end150
  %arrayidx1138 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype1139 = bitcast %union.anon.2* %arrayidx1138 to %union.tree_node**
  %331 = load %union.tree_node*, %union.tree_node** %ttype1139, align 4, !tbaa !19
  %call1140 = call %union.tree_node* @groktypename(%union.tree_node* %331) #20
  %332 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1140, i32 0, i32 0, i32 13
  %333 = load %union.tree_node*, %union.tree_node** %332, align 4, !tbaa !19
  %arrayidx1142 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1143 = bitcast %union.anon.2* %arrayidx1142 to %union.tree_node**
  %334 = load %union.tree_node*, %union.tree_node** %ttype1143, align 4, !tbaa !19
  %call1144 = call %union.tree_node* @groktypename(%union.tree_node* %334) #20
  %335 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1144, i32 0, i32 0, i32 13
  %336 = load %union.tree_node*, %union.tree_node** %335, align 4, !tbaa !19
  %call1147 = call i32 @comptypes(%union.tree_node* %333, %union.tree_node* %336) #20
  %tobool1148.not = icmp ne i32 %call1147, 0
  %. = zext i1 %tobool1148.not to i64
  %call1152 = call %union.tree_node* @build_int_2_wide(i64 %., i64 0) #20
  store %union.tree_node* %call1152, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1158:                                        ; preds = %if.end150
  %arrayidx1159 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype1160 = bitcast %union.anon.2* %arrayidx1159 to %union.tree_node**
  %337 = load %union.tree_node*, %union.tree_node** %ttype1160, align 4, !tbaa !19
  %arrayidx1161 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1162 = bitcast %union.anon.2* %arrayidx1161 to %union.tree_node**
  %338 = load %union.tree_node*, %union.tree_node** %ttype1162, align 4, !tbaa !19
  %call1163 = call %union.tree_node* @build_array_ref(%union.tree_node* %337, %union.tree_node* %338) #20
  store %union.tree_node* %call1163, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1165:                                        ; preds = %if.end150
  %arrayidx1166 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype1167 = bitcast %union.anon.2* %arrayidx1166 to %union.tree_node**
  %339 = load %union.tree_node*, %union.tree_node** %ttype1167, align 4, !tbaa !19
  %ttype1169 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %340 = load %union.tree_node*, %union.tree_node** %ttype1169, align 4, !tbaa !19
  %call1170 = call %union.tree_node* @build_component_ref(%union.tree_node* %339, %union.tree_node* %340) #20
  store %union.tree_node* %call1170, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1172:                                        ; preds = %if.end150
  %arrayidx1173 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype1174 = bitcast %union.anon.2* %arrayidx1173 to %union.tree_node**
  %341 = load %union.tree_node*, %union.tree_node** %ttype1174, align 4, !tbaa !19
  %call1175 = call %union.tree_node* @build_indirect_ref(%union.tree_node* %341, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.25.2703, i32 0, i32 0)) #20
  %ttype1177 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %342 = load %union.tree_node*, %union.tree_node** %ttype1177, align 4, !tbaa !19
  %call1178 = call %union.tree_node* @build_component_ref(%union.tree_node* %call1175, %union.tree_node* %342) #20
  store %union.tree_node* %call1178, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1181:                                        ; preds = %if.end150
  %arrayidx1182 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1183 = bitcast %union.anon.2* %arrayidx1182 to %union.tree_node**
  %343 = load %union.tree_node*, %union.tree_node** %ttype1183, align 4, !tbaa !19
  %call1184 = call %union.tree_node* @build_unary_op(i32 132, %union.tree_node* %343, i32 0) #20
  store %union.tree_node* %call1184, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1186:                                        ; preds = %if.end150
  %arrayidx1187 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1188 = bitcast %union.anon.2* %arrayidx1187 to %union.tree_node**
  %344 = load %union.tree_node*, %union.tree_node** %ttype1188, align 4, !tbaa !19
  %call1189 = call %union.tree_node* @build_unary_op(i32 131, %union.tree_node* %344, i32 0) #20
  store %union.tree_node* %call1189, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb1191:                                        ; preds = %if.end150
  %arrayidx1192 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1193 = bitcast %union.anon.2* %arrayidx1192 to %union.tree_node**
  %345 = load %union.tree_node*, %union.tree_node** %ttype1193, align 4, !tbaa !19
  %ttype1195 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %346 = load %union.tree_node*, %union.tree_node** %ttype1195, align 4, !tbaa !19
  %call1196 = call %union.tree_node* @chainon(%union.tree_node* %345, %union.tree_node* %346) #20
  store %union.tree_node* %call1196, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %347 = load i32, i32* @warn_traditional, align 4, !tbaa !16
  %tobool1198 = icmp eq i32 %347, 0
  %348 = load i32, i32* @in_system_header, align 4
  %tobool1200 = icmp ne i32 %348, 0
  %or.cond4879 = select i1 %tobool1198, i1 true, i1 %tobool1200
  br i1 %or.cond4879, label %sw.epilog, label %land.lhs.true1201

land.lhs.true1201:                                ; preds = %sw.bb1191
  %349 = load i32, i32* @lineno, align 4, !tbaa !16
  %350 = load i32, i32* @yyparse_1.last_lineno, align 4, !tbaa !16
  %cmp1202 = icmp eq i32 %349, %350
  %351 = load i8*, i8** @yyparse_1.last_input_filename, align 4
  %tobool1205 = icmp ne i8* %351, null
  %or.cond4880 = select i1 %cmp1202, i1 %tobool1205, i1 false
  br i1 %or.cond4880, label %lor.lhs.false1206, label %if.then1209

lor.lhs.false1206:                                ; preds = %land.lhs.true1201
  %352 = load i8*, i8** @input_filename, align 4, !tbaa !15
  %call1207 = call i32 @strcmp(i8* noundef nonnull %351, i8* noundef nonnull dereferenceable(1) %352) #26
  %tobool1208.not = icmp eq i32 %call1207, 0
  br i1 %tobool1208.not, label %sw.epilog, label %if.then1209

if.then1209:                                      ; preds = %lor.lhs.false1206, %land.lhs.true1201
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.26.2704, i32 0, i32 0)) #20
  %353 = load i32, i32* @lineno, align 4, !tbaa !16
  store i32 %353, i32* @yyparse_1.last_lineno, align 4, !tbaa !16
  %354 = load i8*, i8** @input_filename, align 4, !tbaa !15
  store i8* %354, i8** @yyparse_1.last_input_filename, align 4, !tbaa !15
  br label %sw.epilog

sw.bb1211:                                        ; preds = %if.end150
  call void @c_mark_varargs() #20
  %355 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool1212.not = icmp eq i32 %355, 0
  br i1 %tobool1212.not, label %sw.epilog, label %if.then1213

if.then1213:                                      ; preds = %sw.bb1211
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.27.2705, i32 0, i32 0)) #20
  br label %sw.epilog

do.body1217:                                      ; preds = %if.end150
  %356 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value1219 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %356, i32 0, i32 2
  %357 = load %union.tree_node*, %union.tree_node** %value1219, align 4, !tbaa !19
  store %union.tree_node* %357, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose1221 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %356, i32 0, i32 1
  %358 = bitcast %union.tree_node** %purpose1221 to %struct.tree_list**
  %359 = load %struct.tree_list*, %struct.tree_list** %358, align 4, !tbaa !19
  %purpose1223 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %359, i32 0, i32 1
  %360 = load %union.tree_node*, %union.tree_node** %purpose1223, align 4, !tbaa !19
  store %union.tree_node* %360, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value1227 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %359, i32 0, i32 2
  %361 = load %union.tree_node*, %union.tree_node** %value1227, align 4, !tbaa !19
  store %union.tree_node* %361, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain1229 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %356, i32 0, i32 0, i32 0
  %362 = load %union.tree_node*, %union.tree_node** %chain1229, align 4, !tbaa !19
  store %union.tree_node* %362, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body1233:                                      ; preds = %if.end150
  %363 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value1235 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %363, i32 0, i32 2
  %364 = load %union.tree_node*, %union.tree_node** %value1235, align 4, !tbaa !19
  store %union.tree_node* %364, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose1237 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %363, i32 0, i32 1
  %365 = bitcast %union.tree_node** %purpose1237 to %struct.tree_list**
  %366 = load %struct.tree_list*, %struct.tree_list** %365, align 4, !tbaa !19
  %purpose1239 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %366, i32 0, i32 1
  %367 = load %union.tree_node*, %union.tree_node** %purpose1239, align 4, !tbaa !19
  store %union.tree_node* %367, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value1243 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %366, i32 0, i32 2
  %368 = load %union.tree_node*, %union.tree_node** %value1243, align 4, !tbaa !19
  store %union.tree_node* %368, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain1245 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %363, i32 0, i32 0, i32 0
  %369 = load %union.tree_node*, %union.tree_node** %chain1245, align 4, !tbaa !19
  store %union.tree_node* %369, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb1248:                                        ; preds = %if.end150
  %arrayidx1249 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1250 = bitcast %union.anon.2* %arrayidx1249 to %union.tree_node**
  %370 = load %union.tree_node*, %union.tree_node** %ttype1250, align 4, !tbaa !19
  call void @shadow_tag_warned(%union.tree_node* %370, i32 1) #20
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.28.2706, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb1251:                                        ; preds = %if.end150
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.28.2706, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb1253:                                        ; preds = %if.end150
  call void @pending_xref_error() #20
  %371 = load %union.tree_node*, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %372 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call1255 = call %union.tree_node* @build_tree_list(%union.tree_node* %371, %union.tree_node* %372) #20
  %373 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %374 = load %union.tree_node*, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  %call1256 = call %union.tree_node* @tree_cons(%union.tree_node* %call1255, %union.tree_node* %373, %union.tree_node* %374) #20
  store %union.tree_node* %call1256, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  %ttype1260 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %375 = load %union.tree_node*, %union.tree_node** %ttype1260, align 4, !tbaa !19
  call void @split_specs_attrs(%union.tree_node* %375, %union.tree_node** nonnull @current_declspecs, %union.tree_node** nonnull @prefix_attributes) #20
  %376 = load %union.tree_node*, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  store %union.tree_node* %376, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  br label %sw.epilog

sw.bb1261:                                        ; preds = %if.end150
  %ttype1263 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %377 = load %union.tree_node*, %union.tree_node** %ttype1263, align 4, !tbaa !19
  %378 = load %union.tree_node*, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %call1264 = call %union.tree_node* @chainon(%union.tree_node* %377, %union.tree_node* %378) #20
  store %union.tree_node* %call1264, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  br label %sw.epilog

do.body1266:                                      ; preds = %if.end150
  %379 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value1268 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %379, i32 0, i32 2
  %380 = load %union.tree_node*, %union.tree_node** %value1268, align 4, !tbaa !19
  store %union.tree_node* %380, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose1270 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %379, i32 0, i32 1
  %381 = bitcast %union.tree_node** %purpose1270 to %struct.tree_list**
  %382 = load %struct.tree_list*, %struct.tree_list** %381, align 4, !tbaa !19
  %purpose1272 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %382, i32 0, i32 1
  %383 = load %union.tree_node*, %union.tree_node** %purpose1272, align 4, !tbaa !19
  store %union.tree_node* %383, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value1276 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %382, i32 0, i32 2
  %384 = load %union.tree_node*, %union.tree_node** %value1276, align 4, !tbaa !19
  store %union.tree_node* %384, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain1278 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %379, i32 0, i32 0, i32 0
  %385 = load %union.tree_node*, %union.tree_node** %chain1278, align 4, !tbaa !19
  store %union.tree_node* %385, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body1282:                                      ; preds = %if.end150
  %386 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value1284 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %386, i32 0, i32 2
  %387 = load %union.tree_node*, %union.tree_node** %value1284, align 4, !tbaa !19
  store %union.tree_node* %387, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose1286 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %386, i32 0, i32 1
  %388 = bitcast %union.tree_node** %purpose1286 to %struct.tree_list**
  %389 = load %struct.tree_list*, %struct.tree_list** %388, align 4, !tbaa !19
  %purpose1288 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %389, i32 0, i32 1
  %390 = load %union.tree_node*, %union.tree_node** %purpose1288, align 4, !tbaa !19
  store %union.tree_node* %390, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value1292 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %389, i32 0, i32 2
  %391 = load %union.tree_node*, %union.tree_node** %value1292, align 4, !tbaa !19
  store %union.tree_node* %391, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain1294 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %386, i32 0, i32 0, i32 0
  %392 = load %union.tree_node*, %union.tree_node** %chain1294, align 4, !tbaa !19
  store %union.tree_node* %392, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body1298:                                      ; preds = %if.end150
  %393 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value1300 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %393, i32 0, i32 2
  %394 = load %union.tree_node*, %union.tree_node** %value1300, align 4, !tbaa !19
  store %union.tree_node* %394, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose1302 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %393, i32 0, i32 1
  %395 = bitcast %union.tree_node** %purpose1302 to %struct.tree_list**
  %396 = load %struct.tree_list*, %struct.tree_list** %395, align 4, !tbaa !19
  %purpose1304 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %396, i32 0, i32 1
  %397 = load %union.tree_node*, %union.tree_node** %purpose1304, align 4, !tbaa !19
  store %union.tree_node* %397, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value1308 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %396, i32 0, i32 2
  %398 = load %union.tree_node*, %union.tree_node** %value1308, align 4, !tbaa !19
  store %union.tree_node* %398, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain1310 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %393, i32 0, i32 0, i32 0
  %399 = load %union.tree_node*, %union.tree_node** %chain1310, align 4, !tbaa !19
  store %union.tree_node* %399, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

do.body1314:                                      ; preds = %if.end150
  %400 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value1316 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %400, i32 0, i32 2
  %401 = load %union.tree_node*, %union.tree_node** %value1316, align 4, !tbaa !19
  store %union.tree_node* %401, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose1318 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %400, i32 0, i32 1
  %402 = bitcast %union.tree_node** %purpose1318 to %struct.tree_list**
  %403 = load %struct.tree_list*, %struct.tree_list** %402, align 4, !tbaa !19
  %purpose1320 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %403, i32 0, i32 1
  %404 = load %union.tree_node*, %union.tree_node** %purpose1320, align 4, !tbaa !19
  store %union.tree_node* %404, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value1324 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %403, i32 0, i32 2
  %405 = load %union.tree_node*, %union.tree_node** %value1324, align 4, !tbaa !19
  store %union.tree_node* %405, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain1326 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %400, i32 0, i32 0, i32 0
  %406 = load %union.tree_node*, %union.tree_node** %chain1326, align 4, !tbaa !19
  store %union.tree_node* %406, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb1329:                                        ; preds = %if.end150
  %arrayidx1330 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1331 = bitcast %union.anon.2* %arrayidx1330 to %union.tree_node**
  %407 = load %union.tree_node*, %union.tree_node** %ttype1331, align 4, !tbaa !19
  call void @shadow_tag(%union.tree_node* %407) #20
  br label %sw.epilog

do.body1333:                                      ; preds = %if.end150
  %arrayidx1335 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1336 = bitcast %union.anon.2* %arrayidx1335 to %union.tree_node**
  %408 = load %union.tree_node*, %union.tree_node** %ttype1336, align 4, !tbaa !19
  %call1337 = call i64 @tree_low_cst(%union.tree_node* %408, i32 0) #20
  %conv1338 = trunc i64 %call1337 to i32
  %and1339 = and i32 %conv1338, 1
  store i32 %and1339, i32* @pedantic, align 4, !tbaa !16
  %shr13405767 = lshr i32 %conv1338, 1
  %and1341 = and i32 %shr13405767, 1
  store i32 %and1341, i32* @warn_pointer_arith, align 4, !tbaa !16
  %shr13425768 = lshr i32 %conv1338, 2
  %and1343 = and i32 %shr13425768, 1
  store i32 %and1343, i32* @warn_traditional, align 4, !tbaa !16
  br label %sw.epilog

sw.bb1346:                                        ; preds = %if.end150
  %ttype1348 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %409 = load %union.tree_node*, %union.tree_node** %ttype1348, align 4, !tbaa !19
  %call1349 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %409, %union.tree_node* null) #20
  store %union.tree_node* %call1349, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag = getelementptr inbounds %union.tree_node, %union.tree_node* %call1349, i32 0, i32 0, i32 0, i32 2
  %bf.load1353 = load i32, i32* %static_flag, align 4
  %bf.set1355 = or i32 %bf.load1353, 262144
  store i32 %bf.set1355, i32* %static_flag, align 4
  br label %sw.epilog

sw.bb1356:                                        ; preds = %if.end150
  %ttype1358 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %410 = load %union.tree_node*, %union.tree_node** %ttype1358, align 4, !tbaa !19
  %arrayidx1359 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1360 = bitcast %union.anon.2* %arrayidx1359 to %union.tree_node**
  %411 = load %union.tree_node*, %union.tree_node** %ttype1360, align 4, !tbaa !19
  %call1361 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %410, %union.tree_node* %411) #20
  store %union.tree_node* %call1361, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1365 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1361, i32 0, i32 0, i32 0, i32 2
  %bf.load1366 = load i32, i32* %static_flag1365, align 4
  %bf.set1368 = or i32 %bf.load1366, 262144
  store i32 %bf.set1368, i32* %static_flag1365, align 4
  br label %sw.epilog

sw.bb1369:                                        ; preds = %if.end150
  %ttype1371 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %412 = load %union.tree_node*, %union.tree_node** %ttype1371, align 4, !tbaa !19
  %arrayidx1372 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1373 = bitcast %union.anon.2* %arrayidx1372 to %union.tree_node**
  %413 = load %union.tree_node*, %union.tree_node** %ttype1373, align 4, !tbaa !19
  %call1374 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %412, %union.tree_node* %413) #20
  store %union.tree_node* %call1374, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1378 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1374, i32 0, i32 0, i32 0, i32 2
  %bf.load1379 = load i32, i32* %static_flag1378, align 4
  %bf.set1381 = or i32 %bf.load1379, 262144
  store i32 %bf.set1381, i32* %static_flag1378, align 4
  br label %sw.epilog

sw.bb1382:                                        ; preds = %if.end150
  %ttype1384 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %414 = load %union.tree_node*, %union.tree_node** %ttype1384, align 4, !tbaa !19
  %arrayidx1385 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1386 = bitcast %union.anon.2* %arrayidx1385 to %union.tree_node**
  %415 = load %union.tree_node*, %union.tree_node** %ttype1386, align 4, !tbaa !19
  %call1387 = call %union.tree_node* @tree_cons(%union.tree_node* %414, %union.tree_node* null, %union.tree_node* %415) #20
  store %union.tree_node* %call1387, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %416 = bitcast %union.anon.2* %arrayidx1385 to %struct.tree_common**
  %417 = load %struct.tree_common*, %struct.tree_common** %416, align 4, !tbaa !19
  %static_flag1392 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %417, i32 0, i32 2
  %bf.load1393 = load i32, i32* %static_flag1392, align 4
  %bf.clear1395 = and i32 %bf.load1393, 262144
  %static_flag1398 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1387, i32 0, i32 0, i32 0, i32 2
  %bf.load1399 = load i32, i32* %static_flag1398, align 4
  %bf.clear1400 = and i32 %bf.load1399, -262145
  %bf.set1401 = or i32 %bf.clear1400, %bf.clear1395
  store i32 %bf.set1401, i32* %static_flag1398, align 4
  br label %sw.epilog

sw.bb1402:                                        ; preds = %if.end150
  %ttype1404 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %418 = load %union.tree_node*, %union.tree_node** %ttype1404, align 4, !tbaa !19
  %arrayidx1405 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1406 = bitcast %union.anon.2* %arrayidx1405 to %union.tree_node**
  %419 = load %union.tree_node*, %union.tree_node** %ttype1406, align 4, !tbaa !19
  %call1407 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %418, %union.tree_node* %419) #20
  store %union.tree_node* %call1407, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1411 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1407, i32 0, i32 0, i32 0, i32 2
  %bf.load1412 = load i32, i32* %static_flag1411, align 4
  %bf.set1414 = or i32 %bf.load1412, 262144
  store i32 %bf.set1414, i32* %static_flag1411, align 4
  br label %sw.epilog

sw.bb1415:                                        ; preds = %if.end150
  %ttype1417 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %420 = load %union.tree_node*, %union.tree_node** %ttype1417, align 4, !tbaa !19
  %arrayidx1418 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1419 = bitcast %union.anon.2* %arrayidx1418 to %union.tree_node**
  %421 = load %union.tree_node*, %union.tree_node** %ttype1419, align 4, !tbaa !19
  %call1420 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %420, %union.tree_node* %421) #20
  store %union.tree_node* %call1420, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1424 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1420, i32 0, i32 0, i32 0, i32 2
  %bf.load1425 = load i32, i32* %static_flag1424, align 4
  %bf.set1427 = or i32 %bf.load1425, 262144
  store i32 %bf.set1427, i32* %static_flag1424, align 4
  br label %sw.epilog

sw.bb1428:                                        ; preds = %if.end150
  %ttype1430 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %422 = load %union.tree_node*, %union.tree_node** %ttype1430, align 4, !tbaa !19
  %call1431 = call %union.tree_node* @tree_cons(%union.tree_node* %422, %union.tree_node* null, %union.tree_node* null) #20
  store %union.tree_node* %call1431, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1435 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1431, i32 0, i32 0, i32 0, i32 2
  %bf.load1436 = load i32, i32* %static_flag1435, align 4
  %bf.clear1437 = and i32 %bf.load1436, -262145
  store i32 %bf.clear1437, i32* %static_flag1435, align 4
  br label %sw.epilog

sw.bb1438:                                        ; preds = %if.end150
  %ttype1440 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %423 = load %union.tree_node*, %union.tree_node** %ttype1440, align 4, !tbaa !19
  %arrayidx1441 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1442 = bitcast %union.anon.2* %arrayidx1441 to %union.tree_node**
  %424 = load %union.tree_node*, %union.tree_node** %ttype1442, align 4, !tbaa !19
  %call1443 = call %union.tree_node* @tree_cons(%union.tree_node* %423, %union.tree_node* null, %union.tree_node* %424) #20
  store %union.tree_node* %call1443, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %425 = bitcast %union.anon.2* %arrayidx1441 to %struct.tree_common**
  %426 = load %struct.tree_common*, %struct.tree_common** %425, align 4, !tbaa !19
  %static_flag1448 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %426, i32 0, i32 2
  %bf.load1449 = load i32, i32* %static_flag1448, align 4
  %bf.clear1451 = and i32 %bf.load1449, 262144
  %static_flag1454 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1443, i32 0, i32 0, i32 0, i32 2
  %bf.load1455 = load i32, i32* %static_flag1454, align 4
  %bf.clear1458 = and i32 %bf.load1455, -262145
  %bf.set1459 = or i32 %bf.clear1458, %bf.clear1451
  store i32 %bf.set1459, i32* %static_flag1454, align 4
  br label %sw.epilog

sw.bb1460:                                        ; preds = %if.end150
  %ttype1462 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %427 = load %union.tree_node*, %union.tree_node** %ttype1462, align 4, !tbaa !19
  %call1463 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %427, %union.tree_node* null) #20
  store %union.tree_node* %call1463, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1467 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1463, i32 0, i32 0, i32 0, i32 2
  %bf.load1468 = load i32, i32* %static_flag1467, align 4
  %bf.set1470 = or i32 %bf.load1468, 262144
  store i32 %bf.set1470, i32* %static_flag1467, align 4
  br label %sw.epilog

sw.bb1471:                                        ; preds = %if.end150
  %ttype1473 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %428 = load %union.tree_node*, %union.tree_node** %ttype1473, align 4, !tbaa !19
  %arrayidx1474 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1475 = bitcast %union.anon.2* %arrayidx1474 to %union.tree_node**
  %429 = load %union.tree_node*, %union.tree_node** %ttype1475, align 4, !tbaa !19
  %call1476 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %428, %union.tree_node* %429) #20
  store %union.tree_node* %call1476, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1480 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1476, i32 0, i32 0, i32 0, i32 2
  %bf.load1481 = load i32, i32* %static_flag1480, align 4
  %bf.set1483 = or i32 %bf.load1481, 262144
  store i32 %bf.set1483, i32* %static_flag1480, align 4
  br label %sw.epilog

sw.bb1484:                                        ; preds = %if.end150
  %ttype1486 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %430 = load %union.tree_node*, %union.tree_node** %ttype1486, align 4, !tbaa !19
  %arrayidx1487 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1488 = bitcast %union.anon.2* %arrayidx1487 to %union.tree_node**
  %431 = load %union.tree_node*, %union.tree_node** %ttype1488, align 4, !tbaa !19
  %call1489 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %430, %union.tree_node* %431) #20
  store %union.tree_node* %call1489, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1493 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1489, i32 0, i32 0, i32 0, i32 2
  %bf.load1494 = load i32, i32* %static_flag1493, align 4
  %bf.set1496 = or i32 %bf.load1494, 262144
  store i32 %bf.set1496, i32* %static_flag1493, align 4
  br label %sw.epilog

sw.bb1497:                                        ; preds = %if.end150
  %ttype1499 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %432 = load %union.tree_node*, %union.tree_node** %ttype1499, align 4, !tbaa !19
  %arrayidx1500 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1501 = bitcast %union.anon.2* %arrayidx1500 to %union.tree_node**
  %433 = load %union.tree_node*, %union.tree_node** %ttype1501, align 4, !tbaa !19
  %call1502 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %432, %union.tree_node* %433) #20
  store %union.tree_node* %call1502, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1506 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1502, i32 0, i32 0, i32 0, i32 2
  %bf.load1507 = load i32, i32* %static_flag1506, align 4
  %bf.set1509 = or i32 %bf.load1507, 262144
  store i32 %bf.set1509, i32* %static_flag1506, align 4
  br label %sw.epilog

sw.bb1510:                                        ; preds = %if.end150
  %ttype1512 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %434 = load %union.tree_node*, %union.tree_node** %ttype1512, align 4, !tbaa !19
  %arrayidx1513 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1514 = bitcast %union.anon.2* %arrayidx1513 to %union.tree_node**
  %435 = load %union.tree_node*, %union.tree_node** %ttype1514, align 4, !tbaa !19
  %call1515 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %434, %union.tree_node* %435) #20
  store %union.tree_node* %call1515, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1519 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1515, i32 0, i32 0, i32 0, i32 2
  %bf.load1520 = load i32, i32* %static_flag1519, align 4
  %bf.set1522 = or i32 %bf.load1520, 262144
  store i32 %bf.set1522, i32* %static_flag1519, align 4
  br label %sw.epilog

sw.bb1523:                                        ; preds = %if.end150
  %ttype1525 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %436 = load %union.tree_node*, %union.tree_node** %ttype1525, align 4, !tbaa !19
  %arrayidx1526 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1527 = bitcast %union.anon.2* %arrayidx1526 to %union.tree_node**
  %437 = load %union.tree_node*, %union.tree_node** %ttype1527, align 4, !tbaa !19
  %call1528 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %436, %union.tree_node* %437) #20
  store %union.tree_node* %call1528, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1532 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1528, i32 0, i32 0, i32 0, i32 2
  %bf.load1533 = load i32, i32* %static_flag1532, align 4
  %bf.set1535 = or i32 %bf.load1533, 262144
  store i32 %bf.set1535, i32* %static_flag1532, align 4
  br label %sw.epilog

sw.bb1536:                                        ; preds = %if.end150
  %ttype1538 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %438 = load %union.tree_node*, %union.tree_node** %ttype1538, align 4, !tbaa !19
  %arrayidx1539 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1540 = bitcast %union.anon.2* %arrayidx1539 to %union.tree_node**
  %439 = load %union.tree_node*, %union.tree_node** %ttype1540, align 4, !tbaa !19
  %call1541 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %438, %union.tree_node* %439) #20
  store %union.tree_node* %call1541, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1545 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1541, i32 0, i32 0, i32 0, i32 2
  %bf.load1546 = load i32, i32* %static_flag1545, align 4
  %bf.set1548 = or i32 %bf.load1546, 262144
  store i32 %bf.set1548, i32* %static_flag1545, align 4
  br label %sw.epilog

sw.bb1549:                                        ; preds = %if.end150
  %ttype1551 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %440 = load %union.tree_node*, %union.tree_node** %ttype1551, align 4, !tbaa !19
  %call1552 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %440, %union.tree_node* null) #20
  store %union.tree_node* %call1552, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1556 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1552, i32 0, i32 0, i32 0, i32 2
  %bf.load1557 = load i32, i32* %static_flag1556, align 4
  %bf.set1559 = or i32 %bf.load1557, 262144
  store i32 %bf.set1559, i32* %static_flag1556, align 4
  br label %sw.epilog

sw.bb1560:                                        ; preds = %if.end150
  %ttype1562 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %441 = load %union.tree_node*, %union.tree_node** %ttype1562, align 4, !tbaa !19
  %arrayidx1563 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1564 = bitcast %union.anon.2* %arrayidx1563 to %union.tree_node**
  %442 = load %union.tree_node*, %union.tree_node** %ttype1564, align 4, !tbaa !19
  %call1565 = call %union.tree_node* @tree_cons(%union.tree_node* %441, %union.tree_node* null, %union.tree_node* %442) #20
  store %union.tree_node* %call1565, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %443 = bitcast %union.anon.2* %arrayidx1563 to %struct.tree_common**
  %444 = load %struct.tree_common*, %struct.tree_common** %443, align 4, !tbaa !19
  %static_flag1570 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %444, i32 0, i32 2
  %bf.load1571 = load i32, i32* %static_flag1570, align 4
  %bf.clear1573 = and i32 %bf.load1571, 262144
  %static_flag1576 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1565, i32 0, i32 0, i32 0, i32 2
  %bf.load1577 = load i32, i32* %static_flag1576, align 4
  %bf.clear1580 = and i32 %bf.load1577, -262145
  %bf.set1581 = or i32 %bf.clear1580, %bf.clear1573
  store i32 %bf.set1581, i32* %static_flag1576, align 4
  br label %sw.epilog

sw.bb1582:                                        ; preds = %if.end150
  %ttype1584 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %445 = load %union.tree_node*, %union.tree_node** %ttype1584, align 4, !tbaa !19
  %arrayidx1585 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1586 = bitcast %union.anon.2* %arrayidx1585 to %union.tree_node**
  %446 = load %union.tree_node*, %union.tree_node** %ttype1586, align 4, !tbaa !19
  %call1587 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %445, %union.tree_node* %446) #20
  store %union.tree_node* %call1587, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1591 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1587, i32 0, i32 0, i32 0, i32 2
  %bf.load1592 = load i32, i32* %static_flag1591, align 4
  %bf.set1594 = or i32 %bf.load1592, 262144
  store i32 %bf.set1594, i32* %static_flag1591, align 4
  br label %sw.epilog

sw.bb1595:                                        ; preds = %if.end150
  %ttype1597 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %447 = load %union.tree_node*, %union.tree_node** %ttype1597, align 4, !tbaa !19
  %arrayidx1598 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1599 = bitcast %union.anon.2* %arrayidx1598 to %union.tree_node**
  %448 = load %union.tree_node*, %union.tree_node** %ttype1599, align 4, !tbaa !19
  %call1600 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %447, %union.tree_node* %448) #20
  store %union.tree_node* %call1600, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1604 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1600, i32 0, i32 0, i32 0, i32 2
  %bf.load1605 = load i32, i32* %static_flag1604, align 4
  %bf.set1607 = or i32 %bf.load1605, 262144
  store i32 %bf.set1607, i32* %static_flag1604, align 4
  br label %sw.epilog

sw.bb1608:                                        ; preds = %if.end150
  %ttype1610 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %449 = load %union.tree_node*, %union.tree_node** %ttype1610, align 4, !tbaa !19
  %arrayidx1611 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1612 = bitcast %union.anon.2* %arrayidx1611 to %union.tree_node**
  %450 = load %union.tree_node*, %union.tree_node** %ttype1612, align 4, !tbaa !19
  %call1613 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %449, %union.tree_node* %450) #20
  store %union.tree_node* %call1613, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1617 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1613, i32 0, i32 0, i32 0, i32 2
  %bf.load1618 = load i32, i32* %static_flag1617, align 4
  %bf.set1620 = or i32 %bf.load1618, 262144
  store i32 %bf.set1620, i32* %static_flag1617, align 4
  br label %sw.epilog

sw.bb1621:                                        ; preds = %if.end150
  %ttype1623 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %451 = load %union.tree_node*, %union.tree_node** %ttype1623, align 4, !tbaa !19
  %arrayidx1624 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1625 = bitcast %union.anon.2* %arrayidx1624 to %union.tree_node**
  %452 = load %union.tree_node*, %union.tree_node** %ttype1625, align 4, !tbaa !19
  %call1626 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %451, %union.tree_node* %452) #20
  store %union.tree_node* %call1626, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1630 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1626, i32 0, i32 0, i32 0, i32 2
  %bf.load1631 = load i32, i32* %static_flag1630, align 4
  %bf.set1633 = or i32 %bf.load1631, 262144
  store i32 %bf.set1633, i32* %static_flag1630, align 4
  br label %sw.epilog

sw.bb1634:                                        ; preds = %if.end150
  %ttype1636 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %453 = load %union.tree_node*, %union.tree_node** %ttype1636, align 4, !tbaa !19
  %arrayidx1637 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1638 = bitcast %union.anon.2* %arrayidx1637 to %union.tree_node**
  %454 = load %union.tree_node*, %union.tree_node** %ttype1638, align 4, !tbaa !19
  %call1639 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %453, %union.tree_node* %454) #20
  store %union.tree_node* %call1639, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1643 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1639, i32 0, i32 0, i32 0, i32 2
  %bf.load1644 = load i32, i32* %static_flag1643, align 4
  %bf.set1646 = or i32 %bf.load1644, 262144
  store i32 %bf.set1646, i32* %static_flag1643, align 4
  br label %sw.epilog

sw.bb1647:                                        ; preds = %if.end150
  %ttype1649 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %455 = load %union.tree_node*, %union.tree_node** %ttype1649, align 4, !tbaa !19
  %arrayidx1650 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1651 = bitcast %union.anon.2* %arrayidx1650 to %union.tree_node**
  %456 = load %union.tree_node*, %union.tree_node** %ttype1651, align 4, !tbaa !19
  %call1652 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %455, %union.tree_node* %456) #20
  store %union.tree_node* %call1652, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1656 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1652, i32 0, i32 0, i32 0, i32 2
  %bf.load1657 = load i32, i32* %static_flag1656, align 4
  %bf.set1659 = or i32 %bf.load1657, 262144
  store i32 %bf.set1659, i32* %static_flag1656, align 4
  br label %sw.epilog

sw.bb1660:                                        ; preds = %if.end150
  %ttype1662 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %457 = load %union.tree_node*, %union.tree_node** %ttype1662, align 4, !tbaa !19
  %arrayidx1663 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1664 = bitcast %union.anon.2* %arrayidx1663 to %union.tree_node**
  %458 = load %union.tree_node*, %union.tree_node** %ttype1664, align 4, !tbaa !19
  %call1665 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %457, %union.tree_node* %458) #20
  store %union.tree_node* %call1665, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1669 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1665, i32 0, i32 0, i32 0, i32 2
  %bf.load1670 = load i32, i32* %static_flag1669, align 4
  %bf.set1672 = or i32 %bf.load1670, 262144
  store i32 %bf.set1672, i32* %static_flag1669, align 4
  br label %sw.epilog

sw.bb1673:                                        ; preds = %if.end150
  %ttype1675 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %459 = load %union.tree_node*, %union.tree_node** %ttype1675, align 4, !tbaa !19
  %arrayidx1676 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1677 = bitcast %union.anon.2* %arrayidx1676 to %union.tree_node**
  %460 = load %union.tree_node*, %union.tree_node** %ttype1677, align 4, !tbaa !19
  %call1678 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %459, %union.tree_node* %460) #20
  store %union.tree_node* %call1678, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1682 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1678, i32 0, i32 0, i32 0, i32 2
  %bf.load1683 = load i32, i32* %static_flag1682, align 4
  %bf.set1685 = or i32 %bf.load1683, 262144
  store i32 %bf.set1685, i32* %static_flag1682, align 4
  br label %sw.epilog

sw.bb1686:                                        ; preds = %if.end150
  %ttype1688 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %461 = load %union.tree_node*, %union.tree_node** %ttype1688, align 4, !tbaa !19
  %arrayidx1689 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1690 = bitcast %union.anon.2* %arrayidx1689 to %union.tree_node**
  %462 = load %union.tree_node*, %union.tree_node** %ttype1690, align 4, !tbaa !19
  %call1691 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %461, %union.tree_node* %462) #20
  store %union.tree_node* %call1691, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1695 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1691, i32 0, i32 0, i32 0, i32 2
  %bf.load1696 = load i32, i32* %static_flag1695, align 4
  %bf.set1698 = or i32 %bf.load1696, 262144
  store i32 %bf.set1698, i32* %static_flag1695, align 4
  br label %sw.epilog

sw.bb1699:                                        ; preds = %if.end150
  %ttype1701 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %463 = load %union.tree_node*, %union.tree_node** %ttype1701, align 4, !tbaa !19
  %arrayidx1702 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1703 = bitcast %union.anon.2* %arrayidx1702 to %union.tree_node**
  %464 = load %union.tree_node*, %union.tree_node** %ttype1703, align 4, !tbaa !19
  %call1704 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %463, %union.tree_node* %464) #20
  store %union.tree_node* %call1704, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1708 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1704, i32 0, i32 0, i32 0, i32 2
  %bf.load1709 = load i32, i32* %static_flag1708, align 4
  %bf.set1711 = or i32 %bf.load1709, 262144
  store i32 %bf.set1711, i32* %static_flag1708, align 4
  br label %sw.epilog

sw.bb1712:                                        ; preds = %if.end150
  %ttype1714 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %465 = load %union.tree_node*, %union.tree_node** %ttype1714, align 4, !tbaa !19
  %arrayidx1715 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1716 = bitcast %union.anon.2* %arrayidx1715 to %union.tree_node**
  %466 = load %union.tree_node*, %union.tree_node** %ttype1716, align 4, !tbaa !19
  %call1717 = call %union.tree_node* @tree_cons(%union.tree_node* %465, %union.tree_node* null, %union.tree_node* %466) #20
  store %union.tree_node* %call1717, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %467 = bitcast %union.anon.2* %arrayidx1715 to %struct.tree_common**
  %468 = load %struct.tree_common*, %struct.tree_common** %467, align 4, !tbaa !19
  %static_flag1722 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %468, i32 0, i32 2
  %bf.load1723 = load i32, i32* %static_flag1722, align 4
  %bf.clear1725 = and i32 %bf.load1723, 262144
  %static_flag1728 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1717, i32 0, i32 0, i32 0, i32 2
  %bf.load1729 = load i32, i32* %static_flag1728, align 4
  %bf.clear1732 = and i32 %bf.load1729, -262145
  %bf.set1733 = or i32 %bf.clear1732, %bf.clear1725
  store i32 %bf.set1733, i32* %static_flag1728, align 4
  br label %sw.epilog

sw.bb1734:                                        ; preds = %if.end150
  %ttype1736 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %469 = load %union.tree_node*, %union.tree_node** %ttype1736, align 4, !tbaa !19
  %arrayidx1737 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1738 = bitcast %union.anon.2* %arrayidx1737 to %union.tree_node**
  %470 = load %union.tree_node*, %union.tree_node** %ttype1738, align 4, !tbaa !19
  %call1739 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %469, %union.tree_node* %470) #20
  store %union.tree_node* %call1739, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1743 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1739, i32 0, i32 0, i32 0, i32 2
  %bf.load1744 = load i32, i32* %static_flag1743, align 4
  %bf.set1746 = or i32 %bf.load1744, 262144
  store i32 %bf.set1746, i32* %static_flag1743, align 4
  br label %sw.epilog

sw.bb1747:                                        ; preds = %if.end150
  %ttype1749 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %471 = load %union.tree_node*, %union.tree_node** %ttype1749, align 4, !tbaa !19
  %arrayidx1750 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1751 = bitcast %union.anon.2* %arrayidx1750 to %union.tree_node**
  %472 = load %union.tree_node*, %union.tree_node** %ttype1751, align 4, !tbaa !19
  %call1752 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %471, %union.tree_node* %472) #20
  store %union.tree_node* %call1752, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1756 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1752, i32 0, i32 0, i32 0, i32 2
  %bf.load1757 = load i32, i32* %static_flag1756, align 4
  %bf.set1759 = or i32 %bf.load1757, 262144
  store i32 %bf.set1759, i32* %static_flag1756, align 4
  br label %sw.epilog

sw.bb1760:                                        ; preds = %if.end150
  %ttype1762 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %473 = load %union.tree_node*, %union.tree_node** %ttype1762, align 4, !tbaa !19
  %arrayidx1763 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1764 = bitcast %union.anon.2* %arrayidx1763 to %union.tree_node**
  %474 = load %union.tree_node*, %union.tree_node** %ttype1764, align 4, !tbaa !19
  %call1765 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %473, %union.tree_node* %474) #20
  store %union.tree_node* %call1765, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1769 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1765, i32 0, i32 0, i32 0, i32 2
  %bf.load1770 = load i32, i32* %static_flag1769, align 4
  %bf.set1772 = or i32 %bf.load1770, 262144
  store i32 %bf.set1772, i32* %static_flag1769, align 4
  br label %sw.epilog

sw.bb1773:                                        ; preds = %if.end150
  %ttype1775 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %475 = load %union.tree_node*, %union.tree_node** %ttype1775, align 4, !tbaa !19
  %arrayidx1776 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1777 = bitcast %union.anon.2* %arrayidx1776 to %union.tree_node**
  %476 = load %union.tree_node*, %union.tree_node** %ttype1777, align 4, !tbaa !19
  %call1778 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %475, %union.tree_node* %476) #20
  store %union.tree_node* %call1778, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1782 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1778, i32 0, i32 0, i32 0, i32 2
  %bf.load1783 = load i32, i32* %static_flag1782, align 4
  %bf.set1785 = or i32 %bf.load1783, 262144
  store i32 %bf.set1785, i32* %static_flag1782, align 4
  br label %sw.epilog

sw.bb1786:                                        ; preds = %if.end150
  %ttype1788 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %477 = load %union.tree_node*, %union.tree_node** %ttype1788, align 4, !tbaa !19
  %call1789 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %477, %union.tree_node* null) #20
  store %union.tree_node* %call1789, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1793 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1789, i32 0, i32 0, i32 0, i32 2
  %bf.load1794 = load i32, i32* %static_flag1793, align 4
  %bf.clear1795 = and i32 %bf.load1794, -262145
  store i32 %bf.clear1795, i32* %static_flag1793, align 4
  br label %sw.epilog

sw.bb1796:                                        ; preds = %if.end150
  %ttype1798 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %478 = load %union.tree_node*, %union.tree_node** %ttype1798, align 4, !tbaa !19
  %arrayidx1799 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1800 = bitcast %union.anon.2* %arrayidx1799 to %union.tree_node**
  %479 = load %union.tree_node*, %union.tree_node** %ttype1800, align 4, !tbaa !19
  %call1801 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %478, %union.tree_node* %479) #20
  store %union.tree_node* %call1801, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1805 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1801, i32 0, i32 0, i32 0, i32 2
  %bf.load1806 = load i32, i32* %static_flag1805, align 4
  %bf.set1808 = or i32 %bf.load1806, 262144
  store i32 %bf.set1808, i32* %static_flag1805, align 4
  br label %sw.epilog

sw.bb1809:                                        ; preds = %if.end150
  %ttype1811 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %480 = load %union.tree_node*, %union.tree_node** %ttype1811, align 4, !tbaa !19
  %arrayidx1812 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1813 = bitcast %union.anon.2* %arrayidx1812 to %union.tree_node**
  %481 = load %union.tree_node*, %union.tree_node** %ttype1813, align 4, !tbaa !19
  %call1814 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %480, %union.tree_node* %481) #20
  store %union.tree_node* %call1814, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag1818 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1814, i32 0, i32 0, i32 0, i32 2
  %bf.load1819 = load i32, i32* %static_flag1818, align 4
  %bf.set1821 = or i32 %bf.load1819, 262144
  store i32 %bf.set1821, i32* %static_flag1818, align 4
  br label %sw.epilog

sw.bb1822:                                        ; preds = %if.end150
  %482 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool1823.not = icmp eq i32 %482, 0
  br i1 %tobool1823.not, label %if.end1836, label %land.lhs.true1824

land.lhs.true1824:                                ; preds = %sw.bb1822
  %arrayidx1825 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %483 = bitcast %union.anon.2* %arrayidx1825 to %struct.tree_common**
  %484 = load %struct.tree_common*, %struct.tree_common** %483, align 4, !tbaa !19
  %static_flag1828 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %484, i32 0, i32 2
  %bf.load1829 = load i32, i32* %static_flag1828, align 4
  %485 = and i32 %bf.load1829, 262144
  %tobool1832.not = icmp eq i32 %485, 0
  br i1 %tobool1832.not, label %if.end1836, label %if.then1833

if.then1833:                                      ; preds = %land.lhs.true1824
  %486 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %487 = load %struct.tree_identifier*, %struct.tree_identifier** %486, align 4, !tbaa !19
  %str = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %487, i32 0, i32 1, i32 1
  %488 = load i8*, i8** %str, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %488) #20
  br label %if.end1836

if.end1836:                                       ; preds = %if.then1833, %land.lhs.true1824, %sw.bb1822
  %ttype1838 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %489 = load %union.tree_node*, %union.tree_node** %ttype1838, align 4, !tbaa !19
  %arrayidx1839 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1840 = bitcast %union.anon.2* %arrayidx1839 to %union.tree_node**
  %490 = load %union.tree_node*, %union.tree_node** %ttype1840, align 4, !tbaa !19
  %call1841 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %489, %union.tree_node* %490) #20
  store %union.tree_node* %call1841, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %491 = bitcast %union.anon.2* %arrayidx1839 to %struct.tree_common**
  %492 = load %struct.tree_common*, %struct.tree_common** %491, align 4, !tbaa !19
  %static_flag1846 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %492, i32 0, i32 2
  %bf.load1847 = load i32, i32* %static_flag1846, align 4
  %bf.clear1849 = and i32 %bf.load1847, 262144
  %static_flag1852 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1841, i32 0, i32 0, i32 0, i32 2
  %bf.load1853 = load i32, i32* %static_flag1852, align 4
  %bf.clear1856 = and i32 %bf.load1853, -262145
  %bf.set1857 = or i32 %bf.clear1856, %bf.clear1849
  store i32 %bf.set1857, i32* %static_flag1852, align 4
  br label %sw.epilog

sw.bb1858:                                        ; preds = %if.end150
  %493 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool1859.not = icmp eq i32 %493, 0
  br i1 %tobool1859.not, label %if.end1875, label %land.lhs.true1860

land.lhs.true1860:                                ; preds = %sw.bb1858
  %arrayidx1861 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %494 = bitcast %union.anon.2* %arrayidx1861 to %struct.tree_common**
  %495 = load %struct.tree_common*, %struct.tree_common** %494, align 4, !tbaa !19
  %static_flag1864 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %495, i32 0, i32 2
  %bf.load1865 = load i32, i32* %static_flag1864, align 4
  %496 = and i32 %bf.load1865, 262144
  %tobool1868.not = icmp eq i32 %496, 0
  br i1 %tobool1868.not, label %if.end1875, label %if.then1869

if.then1869:                                      ; preds = %land.lhs.true1860
  %497 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %498 = load %struct.tree_identifier*, %struct.tree_identifier** %497, align 4, !tbaa !19
  %str1874 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %498, i32 0, i32 1, i32 1
  %499 = load i8*, i8** %str1874, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %499) #20
  br label %if.end1875

if.end1875:                                       ; preds = %if.then1869, %land.lhs.true1860, %sw.bb1858
  %ttype1877 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %500 = load %union.tree_node*, %union.tree_node** %ttype1877, align 4, !tbaa !19
  %arrayidx1878 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1879 = bitcast %union.anon.2* %arrayidx1878 to %union.tree_node**
  %501 = load %union.tree_node*, %union.tree_node** %ttype1879, align 4, !tbaa !19
  %call1880 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %500, %union.tree_node* %501) #20
  store %union.tree_node* %call1880, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %502 = bitcast %union.anon.2* %arrayidx1878 to %struct.tree_common**
  %503 = load %struct.tree_common*, %struct.tree_common** %502, align 4, !tbaa !19
  %static_flag1885 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %503, i32 0, i32 2
  %bf.load1886 = load i32, i32* %static_flag1885, align 4
  %bf.clear1888 = and i32 %bf.load1886, 262144
  %static_flag1891 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1880, i32 0, i32 0, i32 0, i32 2
  %bf.load1892 = load i32, i32* %static_flag1891, align 4
  %bf.clear1895 = and i32 %bf.load1892, -262145
  %bf.set1896 = or i32 %bf.clear1895, %bf.clear1888
  store i32 %bf.set1896, i32* %static_flag1891, align 4
  br label %sw.epilog

sw.bb1897:                                        ; preds = %if.end150
  %504 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool1898.not = icmp eq i32 %504, 0
  br i1 %tobool1898.not, label %if.end1914, label %land.lhs.true1899

land.lhs.true1899:                                ; preds = %sw.bb1897
  %arrayidx1900 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %505 = bitcast %union.anon.2* %arrayidx1900 to %struct.tree_common**
  %506 = load %struct.tree_common*, %struct.tree_common** %505, align 4, !tbaa !19
  %static_flag1903 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %506, i32 0, i32 2
  %bf.load1904 = load i32, i32* %static_flag1903, align 4
  %507 = and i32 %bf.load1904, 262144
  %tobool1907.not = icmp eq i32 %507, 0
  br i1 %tobool1907.not, label %if.end1914, label %if.then1908

if.then1908:                                      ; preds = %land.lhs.true1899
  %508 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %509 = load %struct.tree_identifier*, %struct.tree_identifier** %508, align 4, !tbaa !19
  %str1913 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %509, i32 0, i32 1, i32 1
  %510 = load i8*, i8** %str1913, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %510) #20
  br label %if.end1914

if.end1914:                                       ; preds = %if.then1908, %land.lhs.true1899, %sw.bb1897
  %ttype1916 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %511 = load %union.tree_node*, %union.tree_node** %ttype1916, align 4, !tbaa !19
  %arrayidx1917 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1918 = bitcast %union.anon.2* %arrayidx1917 to %union.tree_node**
  %512 = load %union.tree_node*, %union.tree_node** %ttype1918, align 4, !tbaa !19
  %call1919 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %511, %union.tree_node* %512) #20
  store %union.tree_node* %call1919, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %513 = bitcast %union.anon.2* %arrayidx1917 to %struct.tree_common**
  %514 = load %struct.tree_common*, %struct.tree_common** %513, align 4, !tbaa !19
  %static_flag1924 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %514, i32 0, i32 2
  %bf.load1925 = load i32, i32* %static_flag1924, align 4
  %bf.clear1927 = and i32 %bf.load1925, 262144
  %static_flag1930 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1919, i32 0, i32 0, i32 0, i32 2
  %bf.load1931 = load i32, i32* %static_flag1930, align 4
  %bf.clear1934 = and i32 %bf.load1931, -262145
  %bf.set1935 = or i32 %bf.clear1934, %bf.clear1927
  store i32 %bf.set1935, i32* %static_flag1930, align 4
  br label %sw.epilog

sw.bb1936:                                        ; preds = %if.end150
  %515 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool1937.not = icmp eq i32 %515, 0
  br i1 %tobool1937.not, label %if.end1953, label %land.lhs.true1938

land.lhs.true1938:                                ; preds = %sw.bb1936
  %arrayidx1939 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %516 = bitcast %union.anon.2* %arrayidx1939 to %struct.tree_common**
  %517 = load %struct.tree_common*, %struct.tree_common** %516, align 4, !tbaa !19
  %static_flag1942 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %517, i32 0, i32 2
  %bf.load1943 = load i32, i32* %static_flag1942, align 4
  %518 = and i32 %bf.load1943, 262144
  %tobool1946.not = icmp eq i32 %518, 0
  br i1 %tobool1946.not, label %if.end1953, label %if.then1947

if.then1947:                                      ; preds = %land.lhs.true1938
  %519 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %520 = load %struct.tree_identifier*, %struct.tree_identifier** %519, align 4, !tbaa !19
  %str1952 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %520, i32 0, i32 1, i32 1
  %521 = load i8*, i8** %str1952, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %521) #20
  br label %if.end1953

if.end1953:                                       ; preds = %if.then1947, %land.lhs.true1938, %sw.bb1936
  %ttype1955 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %522 = load %union.tree_node*, %union.tree_node** %ttype1955, align 4, !tbaa !19
  %arrayidx1956 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1957 = bitcast %union.anon.2* %arrayidx1956 to %union.tree_node**
  %523 = load %union.tree_node*, %union.tree_node** %ttype1957, align 4, !tbaa !19
  %call1958 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %522, %union.tree_node* %523) #20
  store %union.tree_node* %call1958, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %524 = bitcast %union.anon.2* %arrayidx1956 to %struct.tree_common**
  %525 = load %struct.tree_common*, %struct.tree_common** %524, align 4, !tbaa !19
  %static_flag1963 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %525, i32 0, i32 2
  %bf.load1964 = load i32, i32* %static_flag1963, align 4
  %bf.clear1966 = and i32 %bf.load1964, 262144
  %static_flag1969 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1958, i32 0, i32 0, i32 0, i32 2
  %bf.load1970 = load i32, i32* %static_flag1969, align 4
  %bf.clear1973 = and i32 %bf.load1970, -262145
  %bf.set1974 = or i32 %bf.clear1973, %bf.clear1966
  store i32 %bf.set1974, i32* %static_flag1969, align 4
  br label %sw.epilog

sw.bb1975:                                        ; preds = %if.end150
  %ttype1977 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %526 = load %union.tree_node*, %union.tree_node** %ttype1977, align 4, !tbaa !19
  %arrayidx1978 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype1979 = bitcast %union.anon.2* %arrayidx1978 to %union.tree_node**
  %527 = load %union.tree_node*, %union.tree_node** %ttype1979, align 4, !tbaa !19
  %call1980 = call %union.tree_node* @tree_cons(%union.tree_node* %526, %union.tree_node* null, %union.tree_node* %527) #20
  store %union.tree_node* %call1980, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %528 = bitcast %union.anon.2* %arrayidx1978 to %struct.tree_common**
  %529 = load %struct.tree_common*, %struct.tree_common** %528, align 4, !tbaa !19
  %static_flag1985 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %529, i32 0, i32 2
  %bf.load1986 = load i32, i32* %static_flag1985, align 4
  %bf.clear1988 = and i32 %bf.load1986, 262144
  %static_flag1991 = getelementptr inbounds %union.tree_node, %union.tree_node* %call1980, i32 0, i32 0, i32 0, i32 2
  %bf.load1992 = load i32, i32* %static_flag1991, align 4
  %bf.clear1995 = and i32 %bf.load1992, -262145
  %bf.set1996 = or i32 %bf.clear1995, %bf.clear1988
  store i32 %bf.set1996, i32* %static_flag1991, align 4
  br label %sw.epilog

sw.bb1997:                                        ; preds = %if.end150
  %ttype1999 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %530 = load %union.tree_node*, %union.tree_node** %ttype1999, align 4, !tbaa !19
  %arrayidx2000 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2001 = bitcast %union.anon.2* %arrayidx2000 to %union.tree_node**
  %531 = load %union.tree_node*, %union.tree_node** %ttype2001, align 4, !tbaa !19
  %call2002 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %530, %union.tree_node* %531) #20
  store %union.tree_node* %call2002, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2006 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2002, i32 0, i32 0, i32 0, i32 2
  %bf.load2007 = load i32, i32* %static_flag2006, align 4
  %bf.set2009 = or i32 %bf.load2007, 262144
  store i32 %bf.set2009, i32* %static_flag2006, align 4
  br label %sw.epilog

sw.bb2010:                                        ; preds = %if.end150
  %ttype2012 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %532 = load %union.tree_node*, %union.tree_node** %ttype2012, align 4, !tbaa !19
  %arrayidx2013 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2014 = bitcast %union.anon.2* %arrayidx2013 to %union.tree_node**
  %533 = load %union.tree_node*, %union.tree_node** %ttype2014, align 4, !tbaa !19
  %call2015 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %532, %union.tree_node* %533) #20
  store %union.tree_node* %call2015, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2019 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2015, i32 0, i32 0, i32 0, i32 2
  %bf.load2020 = load i32, i32* %static_flag2019, align 4
  %bf.set2022 = or i32 %bf.load2020, 262144
  store i32 %bf.set2022, i32* %static_flag2019, align 4
  br label %sw.epilog

sw.bb2023:                                        ; preds = %if.end150
  %534 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2024.not = icmp eq i32 %534, 0
  br i1 %tobool2024.not, label %if.end2040, label %land.lhs.true2025

land.lhs.true2025:                                ; preds = %sw.bb2023
  %arrayidx2026 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %535 = bitcast %union.anon.2* %arrayidx2026 to %struct.tree_common**
  %536 = load %struct.tree_common*, %struct.tree_common** %535, align 4, !tbaa !19
  %static_flag2029 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %536, i32 0, i32 2
  %bf.load2030 = load i32, i32* %static_flag2029, align 4
  %537 = and i32 %bf.load2030, 262144
  %tobool2033.not = icmp eq i32 %537, 0
  br i1 %tobool2033.not, label %if.end2040, label %if.then2034

if.then2034:                                      ; preds = %land.lhs.true2025
  %538 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %539 = load %struct.tree_identifier*, %struct.tree_identifier** %538, align 4, !tbaa !19
  %str2039 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %539, i32 0, i32 1, i32 1
  %540 = load i8*, i8** %str2039, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %540) #20
  br label %if.end2040

if.end2040:                                       ; preds = %if.then2034, %land.lhs.true2025, %sw.bb2023
  %ttype2042 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %541 = load %union.tree_node*, %union.tree_node** %ttype2042, align 4, !tbaa !19
  %arrayidx2043 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2044 = bitcast %union.anon.2* %arrayidx2043 to %union.tree_node**
  %542 = load %union.tree_node*, %union.tree_node** %ttype2044, align 4, !tbaa !19
  %call2045 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %541, %union.tree_node* %542) #20
  store %union.tree_node* %call2045, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %543 = bitcast %union.anon.2* %arrayidx2043 to %struct.tree_common**
  %544 = load %struct.tree_common*, %struct.tree_common** %543, align 4, !tbaa !19
  %static_flag2050 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %544, i32 0, i32 2
  %bf.load2051 = load i32, i32* %static_flag2050, align 4
  %bf.clear2053 = and i32 %bf.load2051, 262144
  %static_flag2056 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2045, i32 0, i32 0, i32 0, i32 2
  %bf.load2057 = load i32, i32* %static_flag2056, align 4
  %bf.clear2060 = and i32 %bf.load2057, -262145
  %bf.set2061 = or i32 %bf.clear2060, %bf.clear2053
  store i32 %bf.set2061, i32* %static_flag2056, align 4
  br label %sw.epilog

sw.bb2062:                                        ; preds = %if.end150
  %545 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2063.not = icmp eq i32 %545, 0
  br i1 %tobool2063.not, label %if.end2079, label %land.lhs.true2064

land.lhs.true2064:                                ; preds = %sw.bb2062
  %arrayidx2065 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %546 = bitcast %union.anon.2* %arrayidx2065 to %struct.tree_common**
  %547 = load %struct.tree_common*, %struct.tree_common** %546, align 4, !tbaa !19
  %static_flag2068 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %547, i32 0, i32 2
  %bf.load2069 = load i32, i32* %static_flag2068, align 4
  %548 = and i32 %bf.load2069, 262144
  %tobool2072.not = icmp eq i32 %548, 0
  br i1 %tobool2072.not, label %if.end2079, label %if.then2073

if.then2073:                                      ; preds = %land.lhs.true2064
  %549 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %550 = load %struct.tree_identifier*, %struct.tree_identifier** %549, align 4, !tbaa !19
  %str2078 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %550, i32 0, i32 1, i32 1
  %551 = load i8*, i8** %str2078, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %551) #20
  br label %if.end2079

if.end2079:                                       ; preds = %if.then2073, %land.lhs.true2064, %sw.bb2062
  %ttype2081 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %552 = load %union.tree_node*, %union.tree_node** %ttype2081, align 4, !tbaa !19
  %arrayidx2082 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2083 = bitcast %union.anon.2* %arrayidx2082 to %union.tree_node**
  %553 = load %union.tree_node*, %union.tree_node** %ttype2083, align 4, !tbaa !19
  %call2084 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %552, %union.tree_node* %553) #20
  store %union.tree_node* %call2084, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %554 = bitcast %union.anon.2* %arrayidx2082 to %struct.tree_common**
  %555 = load %struct.tree_common*, %struct.tree_common** %554, align 4, !tbaa !19
  %static_flag2089 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %555, i32 0, i32 2
  %bf.load2090 = load i32, i32* %static_flag2089, align 4
  %bf.clear2092 = and i32 %bf.load2090, 262144
  %static_flag2095 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2084, i32 0, i32 0, i32 0, i32 2
  %bf.load2096 = load i32, i32* %static_flag2095, align 4
  %bf.clear2099 = and i32 %bf.load2096, -262145
  %bf.set2100 = or i32 %bf.clear2099, %bf.clear2092
  store i32 %bf.set2100, i32* %static_flag2095, align 4
  br label %sw.epilog

sw.bb2101:                                        ; preds = %if.end150
  %556 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2102.not = icmp eq i32 %556, 0
  br i1 %tobool2102.not, label %if.end2118, label %land.lhs.true2103

land.lhs.true2103:                                ; preds = %sw.bb2101
  %arrayidx2104 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %557 = bitcast %union.anon.2* %arrayidx2104 to %struct.tree_common**
  %558 = load %struct.tree_common*, %struct.tree_common** %557, align 4, !tbaa !19
  %static_flag2107 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %558, i32 0, i32 2
  %bf.load2108 = load i32, i32* %static_flag2107, align 4
  %559 = and i32 %bf.load2108, 262144
  %tobool2111.not = icmp eq i32 %559, 0
  br i1 %tobool2111.not, label %if.end2118, label %if.then2112

if.then2112:                                      ; preds = %land.lhs.true2103
  %560 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %561 = load %struct.tree_identifier*, %struct.tree_identifier** %560, align 4, !tbaa !19
  %str2117 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %561, i32 0, i32 1, i32 1
  %562 = load i8*, i8** %str2117, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %562) #20
  br label %if.end2118

if.end2118:                                       ; preds = %if.then2112, %land.lhs.true2103, %sw.bb2101
  %ttype2120 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %563 = load %union.tree_node*, %union.tree_node** %ttype2120, align 4, !tbaa !19
  %arrayidx2121 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2122 = bitcast %union.anon.2* %arrayidx2121 to %union.tree_node**
  %564 = load %union.tree_node*, %union.tree_node** %ttype2122, align 4, !tbaa !19
  %call2123 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %563, %union.tree_node* %564) #20
  store %union.tree_node* %call2123, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %565 = bitcast %union.anon.2* %arrayidx2121 to %struct.tree_common**
  %566 = load %struct.tree_common*, %struct.tree_common** %565, align 4, !tbaa !19
  %static_flag2128 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %566, i32 0, i32 2
  %bf.load2129 = load i32, i32* %static_flag2128, align 4
  %bf.clear2131 = and i32 %bf.load2129, 262144
  %static_flag2134 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2123, i32 0, i32 0, i32 0, i32 2
  %bf.load2135 = load i32, i32* %static_flag2134, align 4
  %bf.clear2138 = and i32 %bf.load2135, -262145
  %bf.set2139 = or i32 %bf.clear2138, %bf.clear2131
  store i32 %bf.set2139, i32* %static_flag2134, align 4
  br label %sw.epilog

sw.bb2140:                                        ; preds = %if.end150
  %567 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2141.not = icmp eq i32 %567, 0
  br i1 %tobool2141.not, label %if.end2157, label %land.lhs.true2142

land.lhs.true2142:                                ; preds = %sw.bb2140
  %arrayidx2143 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %568 = bitcast %union.anon.2* %arrayidx2143 to %struct.tree_common**
  %569 = load %struct.tree_common*, %struct.tree_common** %568, align 4, !tbaa !19
  %static_flag2146 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %569, i32 0, i32 2
  %bf.load2147 = load i32, i32* %static_flag2146, align 4
  %570 = and i32 %bf.load2147, 262144
  %tobool2150.not = icmp eq i32 %570, 0
  br i1 %tobool2150.not, label %if.end2157, label %if.then2151

if.then2151:                                      ; preds = %land.lhs.true2142
  %571 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %572 = load %struct.tree_identifier*, %struct.tree_identifier** %571, align 4, !tbaa !19
  %str2156 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %572, i32 0, i32 1, i32 1
  %573 = load i8*, i8** %str2156, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %573) #20
  br label %if.end2157

if.end2157:                                       ; preds = %if.then2151, %land.lhs.true2142, %sw.bb2140
  %ttype2159 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %574 = load %union.tree_node*, %union.tree_node** %ttype2159, align 4, !tbaa !19
  %arrayidx2160 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2161 = bitcast %union.anon.2* %arrayidx2160 to %union.tree_node**
  %575 = load %union.tree_node*, %union.tree_node** %ttype2161, align 4, !tbaa !19
  %call2162 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %574, %union.tree_node* %575) #20
  store %union.tree_node* %call2162, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %576 = bitcast %union.anon.2* %arrayidx2160 to %struct.tree_common**
  %577 = load %struct.tree_common*, %struct.tree_common** %576, align 4, !tbaa !19
  %static_flag2167 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %577, i32 0, i32 2
  %bf.load2168 = load i32, i32* %static_flag2167, align 4
  %bf.clear2170 = and i32 %bf.load2168, 262144
  %static_flag2173 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2162, i32 0, i32 0, i32 0, i32 2
  %bf.load2174 = load i32, i32* %static_flag2173, align 4
  %bf.clear2177 = and i32 %bf.load2174, -262145
  %bf.set2178 = or i32 %bf.clear2177, %bf.clear2170
  store i32 %bf.set2178, i32* %static_flag2173, align 4
  br label %sw.epilog

sw.bb2179:                                        ; preds = %if.end150
  %ttype2181 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %578 = load %union.tree_node*, %union.tree_node** %ttype2181, align 4, !tbaa !19
  %arrayidx2182 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2183 = bitcast %union.anon.2* %arrayidx2182 to %union.tree_node**
  %579 = load %union.tree_node*, %union.tree_node** %ttype2183, align 4, !tbaa !19
  %call2184 = call %union.tree_node* @tree_cons(%union.tree_node* %578, %union.tree_node* null, %union.tree_node* %579) #20
  store %union.tree_node* %call2184, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %580 = bitcast %union.anon.2* %arrayidx2182 to %struct.tree_common**
  %581 = load %struct.tree_common*, %struct.tree_common** %580, align 4, !tbaa !19
  %static_flag2189 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %581, i32 0, i32 2
  %bf.load2190 = load i32, i32* %static_flag2189, align 4
  %bf.clear2192 = and i32 %bf.load2190, 262144
  %static_flag2195 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2184, i32 0, i32 0, i32 0, i32 2
  %bf.load2196 = load i32, i32* %static_flag2195, align 4
  %bf.clear2199 = and i32 %bf.load2196, -262145
  %bf.set2200 = or i32 %bf.clear2199, %bf.clear2192
  store i32 %bf.set2200, i32* %static_flag2195, align 4
  br label %sw.epilog

sw.bb2201:                                        ; preds = %if.end150
  %ttype2203 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %582 = load %union.tree_node*, %union.tree_node** %ttype2203, align 4, !tbaa !19
  %arrayidx2204 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2205 = bitcast %union.anon.2* %arrayidx2204 to %union.tree_node**
  %583 = load %union.tree_node*, %union.tree_node** %ttype2205, align 4, !tbaa !19
  %call2206 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %582, %union.tree_node* %583) #20
  store %union.tree_node* %call2206, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2210 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2206, i32 0, i32 0, i32 0, i32 2
  %bf.load2211 = load i32, i32* %static_flag2210, align 4
  %bf.set2213 = or i32 %bf.load2211, 262144
  store i32 %bf.set2213, i32* %static_flag2210, align 4
  br label %sw.epilog

sw.bb2214:                                        ; preds = %if.end150
  %ttype2216 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %584 = load %union.tree_node*, %union.tree_node** %ttype2216, align 4, !tbaa !19
  %arrayidx2217 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2218 = bitcast %union.anon.2* %arrayidx2217 to %union.tree_node**
  %585 = load %union.tree_node*, %union.tree_node** %ttype2218, align 4, !tbaa !19
  %call2219 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %584, %union.tree_node* %585) #20
  store %union.tree_node* %call2219, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2223 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2219, i32 0, i32 0, i32 0, i32 2
  %bf.load2224 = load i32, i32* %static_flag2223, align 4
  %bf.set2226 = or i32 %bf.load2224, 262144
  store i32 %bf.set2226, i32* %static_flag2223, align 4
  br label %sw.epilog

sw.bb2227:                                        ; preds = %if.end150
  %ttype2229 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %586 = load %union.tree_node*, %union.tree_node** %ttype2229, align 4, !tbaa !19
  %arrayidx2230 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2231 = bitcast %union.anon.2* %arrayidx2230 to %union.tree_node**
  %587 = load %union.tree_node*, %union.tree_node** %ttype2231, align 4, !tbaa !19
  %call2232 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %586, %union.tree_node* %587) #20
  store %union.tree_node* %call2232, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2236 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2232, i32 0, i32 0, i32 0, i32 2
  %bf.load2237 = load i32, i32* %static_flag2236, align 4
  %bf.set2239 = or i32 %bf.load2237, 262144
  store i32 %bf.set2239, i32* %static_flag2236, align 4
  br label %sw.epilog

sw.bb2240:                                        ; preds = %if.end150
  %ttype2242 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %588 = load %union.tree_node*, %union.tree_node** %ttype2242, align 4, !tbaa !19
  %arrayidx2243 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2244 = bitcast %union.anon.2* %arrayidx2243 to %union.tree_node**
  %589 = load %union.tree_node*, %union.tree_node** %ttype2244, align 4, !tbaa !19
  %call2245 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %588, %union.tree_node* %589) #20
  store %union.tree_node* %call2245, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2249 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2245, i32 0, i32 0, i32 0, i32 2
  %bf.load2250 = load i32, i32* %static_flag2249, align 4
  %bf.set2252 = or i32 %bf.load2250, 262144
  store i32 %bf.set2252, i32* %static_flag2249, align 4
  br label %sw.epilog

sw.bb2253:                                        ; preds = %if.end150
  %ttype2255 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %590 = load %union.tree_node*, %union.tree_node** %ttype2255, align 4, !tbaa !19
  %arrayidx2256 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2257 = bitcast %union.anon.2* %arrayidx2256 to %union.tree_node**
  %591 = load %union.tree_node*, %union.tree_node** %ttype2257, align 4, !tbaa !19
  %call2258 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %590, %union.tree_node* %591) #20
  store %union.tree_node* %call2258, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2262 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2258, i32 0, i32 0, i32 0, i32 2
  %bf.load2263 = load i32, i32* %static_flag2262, align 4
  %bf.set2265 = or i32 %bf.load2263, 262144
  store i32 %bf.set2265, i32* %static_flag2262, align 4
  br label %sw.epilog

sw.bb2266:                                        ; preds = %if.end150
  %ttype2268 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %592 = load %union.tree_node*, %union.tree_node** %ttype2268, align 4, !tbaa !19
  %arrayidx2269 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2270 = bitcast %union.anon.2* %arrayidx2269 to %union.tree_node**
  %593 = load %union.tree_node*, %union.tree_node** %ttype2270, align 4, !tbaa !19
  %call2271 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %592, %union.tree_node* %593) #20
  store %union.tree_node* %call2271, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2275 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2271, i32 0, i32 0, i32 0, i32 2
  %bf.load2276 = load i32, i32* %static_flag2275, align 4
  %bf.set2278 = or i32 %bf.load2276, 262144
  store i32 %bf.set2278, i32* %static_flag2275, align 4
  br label %sw.epilog

sw.bb2279:                                        ; preds = %if.end150
  %594 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2280.not = icmp eq i32 %594, 0
  br i1 %tobool2280.not, label %if.end2296, label %land.lhs.true2281

land.lhs.true2281:                                ; preds = %sw.bb2279
  %arrayidx2282 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %595 = bitcast %union.anon.2* %arrayidx2282 to %struct.tree_common**
  %596 = load %struct.tree_common*, %struct.tree_common** %595, align 4, !tbaa !19
  %static_flag2285 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %596, i32 0, i32 2
  %bf.load2286 = load i32, i32* %static_flag2285, align 4
  %597 = and i32 %bf.load2286, 262144
  %tobool2289.not = icmp eq i32 %597, 0
  br i1 %tobool2289.not, label %if.end2296, label %if.then2290

if.then2290:                                      ; preds = %land.lhs.true2281
  %598 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %599 = load %struct.tree_identifier*, %struct.tree_identifier** %598, align 4, !tbaa !19
  %str2295 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %599, i32 0, i32 1, i32 1
  %600 = load i8*, i8** %str2295, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %600) #20
  br label %if.end2296

if.end2296:                                       ; preds = %if.then2290, %land.lhs.true2281, %sw.bb2279
  %ttype2298 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %601 = load %union.tree_node*, %union.tree_node** %ttype2298, align 4, !tbaa !19
  %arrayidx2299 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2300 = bitcast %union.anon.2* %arrayidx2299 to %union.tree_node**
  %602 = load %union.tree_node*, %union.tree_node** %ttype2300, align 4, !tbaa !19
  %call2301 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %601, %union.tree_node* %602) #20
  store %union.tree_node* %call2301, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %603 = bitcast %union.anon.2* %arrayidx2299 to %struct.tree_common**
  %604 = load %struct.tree_common*, %struct.tree_common** %603, align 4, !tbaa !19
  %static_flag2306 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %604, i32 0, i32 2
  %bf.load2307 = load i32, i32* %static_flag2306, align 4
  %bf.clear2309 = and i32 %bf.load2307, 262144
  %static_flag2312 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2301, i32 0, i32 0, i32 0, i32 2
  %bf.load2313 = load i32, i32* %static_flag2312, align 4
  %bf.clear2316 = and i32 %bf.load2313, -262145
  %bf.set2317 = or i32 %bf.clear2316, %bf.clear2309
  store i32 %bf.set2317, i32* %static_flag2312, align 4
  br label %sw.epilog

sw.bb2318:                                        ; preds = %if.end150
  %605 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2319.not = icmp eq i32 %605, 0
  br i1 %tobool2319.not, label %if.end2335, label %land.lhs.true2320

land.lhs.true2320:                                ; preds = %sw.bb2318
  %arrayidx2321 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %606 = bitcast %union.anon.2* %arrayidx2321 to %struct.tree_common**
  %607 = load %struct.tree_common*, %struct.tree_common** %606, align 4, !tbaa !19
  %static_flag2324 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %607, i32 0, i32 2
  %bf.load2325 = load i32, i32* %static_flag2324, align 4
  %608 = and i32 %bf.load2325, 262144
  %tobool2328.not = icmp eq i32 %608, 0
  br i1 %tobool2328.not, label %if.end2335, label %if.then2329

if.then2329:                                      ; preds = %land.lhs.true2320
  %609 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %610 = load %struct.tree_identifier*, %struct.tree_identifier** %609, align 4, !tbaa !19
  %str2334 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %610, i32 0, i32 1, i32 1
  %611 = load i8*, i8** %str2334, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %611) #20
  br label %if.end2335

if.end2335:                                       ; preds = %if.then2329, %land.lhs.true2320, %sw.bb2318
  %ttype2337 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %612 = load %union.tree_node*, %union.tree_node** %ttype2337, align 4, !tbaa !19
  %arrayidx2338 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2339 = bitcast %union.anon.2* %arrayidx2338 to %union.tree_node**
  %613 = load %union.tree_node*, %union.tree_node** %ttype2339, align 4, !tbaa !19
  %call2340 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %612, %union.tree_node* %613) #20
  store %union.tree_node* %call2340, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %614 = bitcast %union.anon.2* %arrayidx2338 to %struct.tree_common**
  %615 = load %struct.tree_common*, %struct.tree_common** %614, align 4, !tbaa !19
  %static_flag2345 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %615, i32 0, i32 2
  %bf.load2346 = load i32, i32* %static_flag2345, align 4
  %bf.clear2348 = and i32 %bf.load2346, 262144
  %static_flag2351 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2340, i32 0, i32 0, i32 0, i32 2
  %bf.load2352 = load i32, i32* %static_flag2351, align 4
  %bf.clear2355 = and i32 %bf.load2352, -262145
  %bf.set2356 = or i32 %bf.clear2355, %bf.clear2348
  store i32 %bf.set2356, i32* %static_flag2351, align 4
  br label %sw.epilog

sw.bb2357:                                        ; preds = %if.end150
  %616 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2358.not = icmp eq i32 %616, 0
  br i1 %tobool2358.not, label %if.end2374, label %land.lhs.true2359

land.lhs.true2359:                                ; preds = %sw.bb2357
  %arrayidx2360 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %617 = bitcast %union.anon.2* %arrayidx2360 to %struct.tree_common**
  %618 = load %struct.tree_common*, %struct.tree_common** %617, align 4, !tbaa !19
  %static_flag2363 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %618, i32 0, i32 2
  %bf.load2364 = load i32, i32* %static_flag2363, align 4
  %619 = and i32 %bf.load2364, 262144
  %tobool2367.not = icmp eq i32 %619, 0
  br i1 %tobool2367.not, label %if.end2374, label %if.then2368

if.then2368:                                      ; preds = %land.lhs.true2359
  %620 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %621 = load %struct.tree_identifier*, %struct.tree_identifier** %620, align 4, !tbaa !19
  %str2373 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %621, i32 0, i32 1, i32 1
  %622 = load i8*, i8** %str2373, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %622) #20
  br label %if.end2374

if.end2374:                                       ; preds = %if.then2368, %land.lhs.true2359, %sw.bb2357
  %ttype2376 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %623 = load %union.tree_node*, %union.tree_node** %ttype2376, align 4, !tbaa !19
  %arrayidx2377 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2378 = bitcast %union.anon.2* %arrayidx2377 to %union.tree_node**
  %624 = load %union.tree_node*, %union.tree_node** %ttype2378, align 4, !tbaa !19
  %call2379 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %623, %union.tree_node* %624) #20
  store %union.tree_node* %call2379, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %625 = bitcast %union.anon.2* %arrayidx2377 to %struct.tree_common**
  %626 = load %struct.tree_common*, %struct.tree_common** %625, align 4, !tbaa !19
  %static_flag2384 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %626, i32 0, i32 2
  %bf.load2385 = load i32, i32* %static_flag2384, align 4
  %bf.clear2387 = and i32 %bf.load2385, 262144
  %static_flag2390 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2379, i32 0, i32 0, i32 0, i32 2
  %bf.load2391 = load i32, i32* %static_flag2390, align 4
  %bf.clear2394 = and i32 %bf.load2391, -262145
  %bf.set2395 = or i32 %bf.clear2394, %bf.clear2387
  store i32 %bf.set2395, i32* %static_flag2390, align 4
  br label %sw.epilog

sw.bb2396:                                        ; preds = %if.end150
  %627 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2397.not = icmp eq i32 %627, 0
  br i1 %tobool2397.not, label %if.end2413, label %land.lhs.true2398

land.lhs.true2398:                                ; preds = %sw.bb2396
  %arrayidx2399 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %628 = bitcast %union.anon.2* %arrayidx2399 to %struct.tree_common**
  %629 = load %struct.tree_common*, %struct.tree_common** %628, align 4, !tbaa !19
  %static_flag2402 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %629, i32 0, i32 2
  %bf.load2403 = load i32, i32* %static_flag2402, align 4
  %630 = and i32 %bf.load2403, 262144
  %tobool2406.not = icmp eq i32 %630, 0
  br i1 %tobool2406.not, label %if.end2413, label %if.then2407

if.then2407:                                      ; preds = %land.lhs.true2398
  %631 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %632 = load %struct.tree_identifier*, %struct.tree_identifier** %631, align 4, !tbaa !19
  %str2412 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %632, i32 0, i32 1, i32 1
  %633 = load i8*, i8** %str2412, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %633) #20
  br label %if.end2413

if.end2413:                                       ; preds = %if.then2407, %land.lhs.true2398, %sw.bb2396
  %ttype2415 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %634 = load %union.tree_node*, %union.tree_node** %ttype2415, align 4, !tbaa !19
  %arrayidx2416 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2417 = bitcast %union.anon.2* %arrayidx2416 to %union.tree_node**
  %635 = load %union.tree_node*, %union.tree_node** %ttype2417, align 4, !tbaa !19
  %call2418 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %634, %union.tree_node* %635) #20
  store %union.tree_node* %call2418, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %636 = bitcast %union.anon.2* %arrayidx2416 to %struct.tree_common**
  %637 = load %struct.tree_common*, %struct.tree_common** %636, align 4, !tbaa !19
  %static_flag2423 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %637, i32 0, i32 2
  %bf.load2424 = load i32, i32* %static_flag2423, align 4
  %bf.clear2426 = and i32 %bf.load2424, 262144
  %static_flag2429 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2418, i32 0, i32 0, i32 0, i32 2
  %bf.load2430 = load i32, i32* %static_flag2429, align 4
  %bf.clear2433 = and i32 %bf.load2430, -262145
  %bf.set2434 = or i32 %bf.clear2433, %bf.clear2426
  store i32 %bf.set2434, i32* %static_flag2429, align 4
  br label %sw.epilog

sw.bb2435:                                        ; preds = %if.end150
  %ttype2437 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %638 = load %union.tree_node*, %union.tree_node** %ttype2437, align 4, !tbaa !19
  %arrayidx2438 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2439 = bitcast %union.anon.2* %arrayidx2438 to %union.tree_node**
  %639 = load %union.tree_node*, %union.tree_node** %ttype2439, align 4, !tbaa !19
  %call2440 = call %union.tree_node* @tree_cons(%union.tree_node* %638, %union.tree_node* null, %union.tree_node* %639) #20
  store %union.tree_node* %call2440, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %640 = bitcast %union.anon.2* %arrayidx2438 to %struct.tree_common**
  %641 = load %struct.tree_common*, %struct.tree_common** %640, align 4, !tbaa !19
  %static_flag2445 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %641, i32 0, i32 2
  %bf.load2446 = load i32, i32* %static_flag2445, align 4
  %bf.clear2448 = and i32 %bf.load2446, 262144
  %static_flag2451 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2440, i32 0, i32 0, i32 0, i32 2
  %bf.load2452 = load i32, i32* %static_flag2451, align 4
  %bf.clear2455 = and i32 %bf.load2452, -262145
  %bf.set2456 = or i32 %bf.clear2455, %bf.clear2448
  store i32 %bf.set2456, i32* %static_flag2451, align 4
  br label %sw.epilog

sw.bb2457:                                        ; preds = %if.end150
  %ttype2459 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %642 = load %union.tree_node*, %union.tree_node** %ttype2459, align 4, !tbaa !19
  %arrayidx2460 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2461 = bitcast %union.anon.2* %arrayidx2460 to %union.tree_node**
  %643 = load %union.tree_node*, %union.tree_node** %ttype2461, align 4, !tbaa !19
  %call2462 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %642, %union.tree_node* %643) #20
  store %union.tree_node* %call2462, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2466 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2462, i32 0, i32 0, i32 0, i32 2
  %bf.load2467 = load i32, i32* %static_flag2466, align 4
  %bf.set2469 = or i32 %bf.load2467, 262144
  store i32 %bf.set2469, i32* %static_flag2466, align 4
  br label %sw.epilog

sw.bb2470:                                        ; preds = %if.end150
  %ttype2472 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %644 = load %union.tree_node*, %union.tree_node** %ttype2472, align 4, !tbaa !19
  %arrayidx2473 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2474 = bitcast %union.anon.2* %arrayidx2473 to %union.tree_node**
  %645 = load %union.tree_node*, %union.tree_node** %ttype2474, align 4, !tbaa !19
  %call2475 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %644, %union.tree_node* %645) #20
  store %union.tree_node* %call2475, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2479 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2475, i32 0, i32 0, i32 0, i32 2
  %bf.load2480 = load i32, i32* %static_flag2479, align 4
  %bf.set2482 = or i32 %bf.load2480, 262144
  store i32 %bf.set2482, i32* %static_flag2479, align 4
  br label %sw.epilog

sw.bb2483:                                        ; preds = %if.end150
  %ttype2485 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %646 = load %union.tree_node*, %union.tree_node** %ttype2485, align 4, !tbaa !19
  %arrayidx2486 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2487 = bitcast %union.anon.2* %arrayidx2486 to %union.tree_node**
  %647 = load %union.tree_node*, %union.tree_node** %ttype2487, align 4, !tbaa !19
  %call2488 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %646, %union.tree_node* %647) #20
  store %union.tree_node* %call2488, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2492 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2488, i32 0, i32 0, i32 0, i32 2
  %bf.load2493 = load i32, i32* %static_flag2492, align 4
  %bf.set2495 = or i32 %bf.load2493, 262144
  store i32 %bf.set2495, i32* %static_flag2492, align 4
  br label %sw.epilog

sw.bb2496:                                        ; preds = %if.end150
  %ttype2498 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %648 = load %union.tree_node*, %union.tree_node** %ttype2498, align 4, !tbaa !19
  %arrayidx2499 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2500 = bitcast %union.anon.2* %arrayidx2499 to %union.tree_node**
  %649 = load %union.tree_node*, %union.tree_node** %ttype2500, align 4, !tbaa !19
  %call2501 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %648, %union.tree_node* %649) #20
  store %union.tree_node* %call2501, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2505 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2501, i32 0, i32 0, i32 0, i32 2
  %bf.load2506 = load i32, i32* %static_flag2505, align 4
  %bf.set2508 = or i32 %bf.load2506, 262144
  store i32 %bf.set2508, i32* %static_flag2505, align 4
  br label %sw.epilog

sw.bb2509:                                        ; preds = %if.end150
  %ttype2511 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %650 = load %union.tree_node*, %union.tree_node** %ttype2511, align 4, !tbaa !19
  %arrayidx2512 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2513 = bitcast %union.anon.2* %arrayidx2512 to %union.tree_node**
  %651 = load %union.tree_node*, %union.tree_node** %ttype2513, align 4, !tbaa !19
  %call2514 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %650, %union.tree_node* %651) #20
  store %union.tree_node* %call2514, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2518 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2514, i32 0, i32 0, i32 0, i32 2
  %bf.load2519 = load i32, i32* %static_flag2518, align 4
  %bf.set2521 = or i32 %bf.load2519, 262144
  store i32 %bf.set2521, i32* %static_flag2518, align 4
  br label %sw.epilog

sw.bb2522:                                        ; preds = %if.end150
  %ttype2524 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %652 = load %union.tree_node*, %union.tree_node** %ttype2524, align 4, !tbaa !19
  %arrayidx2525 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2526 = bitcast %union.anon.2* %arrayidx2525 to %union.tree_node**
  %653 = load %union.tree_node*, %union.tree_node** %ttype2526, align 4, !tbaa !19
  %call2527 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %652, %union.tree_node* %653) #20
  store %union.tree_node* %call2527, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2531 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2527, i32 0, i32 0, i32 0, i32 2
  %bf.load2532 = load i32, i32* %static_flag2531, align 4
  %bf.set2534 = or i32 %bf.load2532, 262144
  store i32 %bf.set2534, i32* %static_flag2531, align 4
  br label %sw.epilog

sw.bb2535:                                        ; preds = %if.end150
  %ttype2537 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %654 = load %union.tree_node*, %union.tree_node** %ttype2537, align 4, !tbaa !19
  %arrayidx2538 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2539 = bitcast %union.anon.2* %arrayidx2538 to %union.tree_node**
  %655 = load %union.tree_node*, %union.tree_node** %ttype2539, align 4, !tbaa !19
  %call2540 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %654, %union.tree_node* %655) #20
  store %union.tree_node* %call2540, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2544 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2540, i32 0, i32 0, i32 0, i32 2
  %bf.load2545 = load i32, i32* %static_flag2544, align 4
  %bf.set2547 = or i32 %bf.load2545, 262144
  store i32 %bf.set2547, i32* %static_flag2544, align 4
  br label %sw.epilog

sw.bb2548:                                        ; preds = %if.end150
  %ttype2550 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %656 = load %union.tree_node*, %union.tree_node** %ttype2550, align 4, !tbaa !19
  %arrayidx2551 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2552 = bitcast %union.anon.2* %arrayidx2551 to %union.tree_node**
  %657 = load %union.tree_node*, %union.tree_node** %ttype2552, align 4, !tbaa !19
  %call2553 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %656, %union.tree_node* %657) #20
  store %union.tree_node* %call2553, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2557 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2553, i32 0, i32 0, i32 0, i32 2
  %bf.load2558 = load i32, i32* %static_flag2557, align 4
  %bf.set2560 = or i32 %bf.load2558, 262144
  store i32 %bf.set2560, i32* %static_flag2557, align 4
  br label %sw.epilog

sw.bb2561:                                        ; preds = %if.end150
  %ttype2563 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %658 = load %union.tree_node*, %union.tree_node** %ttype2563, align 4, !tbaa !19
  %arrayidx2564 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2565 = bitcast %union.anon.2* %arrayidx2564 to %union.tree_node**
  %659 = load %union.tree_node*, %union.tree_node** %ttype2565, align 4, !tbaa !19
  %call2566 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %658, %union.tree_node* %659) #20
  store %union.tree_node* %call2566, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2570 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2566, i32 0, i32 0, i32 0, i32 2
  %bf.load2571 = load i32, i32* %static_flag2570, align 4
  %bf.set2573 = or i32 %bf.load2571, 262144
  store i32 %bf.set2573, i32* %static_flag2570, align 4
  br label %sw.epilog

sw.bb2574:                                        ; preds = %if.end150
  %ttype2576 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %660 = load %union.tree_node*, %union.tree_node** %ttype2576, align 4, !tbaa !19
  %arrayidx2577 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2578 = bitcast %union.anon.2* %arrayidx2577 to %union.tree_node**
  %661 = load %union.tree_node*, %union.tree_node** %ttype2578, align 4, !tbaa !19
  %call2579 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %660, %union.tree_node* %661) #20
  store %union.tree_node* %call2579, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2583 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2579, i32 0, i32 0, i32 0, i32 2
  %bf.load2584 = load i32, i32* %static_flag2583, align 4
  %bf.set2586 = or i32 %bf.load2584, 262144
  store i32 %bf.set2586, i32* %static_flag2583, align 4
  br label %sw.epilog

sw.bb2587:                                        ; preds = %if.end150
  %662 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2588.not = icmp eq i32 %662, 0
  br i1 %tobool2588.not, label %if.end2604, label %land.lhs.true2589

land.lhs.true2589:                                ; preds = %sw.bb2587
  %arrayidx2590 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %663 = bitcast %union.anon.2* %arrayidx2590 to %struct.tree_common**
  %664 = load %struct.tree_common*, %struct.tree_common** %663, align 4, !tbaa !19
  %static_flag2593 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %664, i32 0, i32 2
  %bf.load2594 = load i32, i32* %static_flag2593, align 4
  %665 = and i32 %bf.load2594, 262144
  %tobool2597.not = icmp eq i32 %665, 0
  br i1 %tobool2597.not, label %if.end2604, label %if.then2598

if.then2598:                                      ; preds = %land.lhs.true2589
  %666 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %667 = load %struct.tree_identifier*, %struct.tree_identifier** %666, align 4, !tbaa !19
  %str2603 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %667, i32 0, i32 1, i32 1
  %668 = load i8*, i8** %str2603, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %668) #20
  br label %if.end2604

if.end2604:                                       ; preds = %if.then2598, %land.lhs.true2589, %sw.bb2587
  %ttype2606 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %669 = load %union.tree_node*, %union.tree_node** %ttype2606, align 4, !tbaa !19
  %arrayidx2607 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2608 = bitcast %union.anon.2* %arrayidx2607 to %union.tree_node**
  %670 = load %union.tree_node*, %union.tree_node** %ttype2608, align 4, !tbaa !19
  %call2609 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %669, %union.tree_node* %670) #20
  store %union.tree_node* %call2609, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %671 = bitcast %union.anon.2* %arrayidx2607 to %struct.tree_common**
  %672 = load %struct.tree_common*, %struct.tree_common** %671, align 4, !tbaa !19
  %static_flag2614 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %672, i32 0, i32 2
  %bf.load2615 = load i32, i32* %static_flag2614, align 4
  %bf.clear2617 = and i32 %bf.load2615, 262144
  %static_flag2620 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2609, i32 0, i32 0, i32 0, i32 2
  %bf.load2621 = load i32, i32* %static_flag2620, align 4
  %bf.clear2624 = and i32 %bf.load2621, -262145
  %bf.set2625 = or i32 %bf.clear2624, %bf.clear2617
  store i32 %bf.set2625, i32* %static_flag2620, align 4
  br label %sw.epilog

sw.bb2626:                                        ; preds = %if.end150
  %673 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2627.not = icmp eq i32 %673, 0
  br i1 %tobool2627.not, label %if.end2643, label %land.lhs.true2628

land.lhs.true2628:                                ; preds = %sw.bb2626
  %arrayidx2629 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %674 = bitcast %union.anon.2* %arrayidx2629 to %struct.tree_common**
  %675 = load %struct.tree_common*, %struct.tree_common** %674, align 4, !tbaa !19
  %static_flag2632 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %675, i32 0, i32 2
  %bf.load2633 = load i32, i32* %static_flag2632, align 4
  %676 = and i32 %bf.load2633, 262144
  %tobool2636.not = icmp eq i32 %676, 0
  br i1 %tobool2636.not, label %if.end2643, label %if.then2637

if.then2637:                                      ; preds = %land.lhs.true2628
  %677 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %678 = load %struct.tree_identifier*, %struct.tree_identifier** %677, align 4, !tbaa !19
  %str2642 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %678, i32 0, i32 1, i32 1
  %679 = load i8*, i8** %str2642, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %679) #20
  br label %if.end2643

if.end2643:                                       ; preds = %if.then2637, %land.lhs.true2628, %sw.bb2626
  %ttype2645 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %680 = load %union.tree_node*, %union.tree_node** %ttype2645, align 4, !tbaa !19
  %arrayidx2646 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2647 = bitcast %union.anon.2* %arrayidx2646 to %union.tree_node**
  %681 = load %union.tree_node*, %union.tree_node** %ttype2647, align 4, !tbaa !19
  %call2648 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %680, %union.tree_node* %681) #20
  store %union.tree_node* %call2648, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %682 = bitcast %union.anon.2* %arrayidx2646 to %struct.tree_common**
  %683 = load %struct.tree_common*, %struct.tree_common** %682, align 4, !tbaa !19
  %static_flag2653 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %683, i32 0, i32 2
  %bf.load2654 = load i32, i32* %static_flag2653, align 4
  %bf.clear2656 = and i32 %bf.load2654, 262144
  %static_flag2659 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2648, i32 0, i32 0, i32 0, i32 2
  %bf.load2660 = load i32, i32* %static_flag2659, align 4
  %bf.clear2663 = and i32 %bf.load2660, -262145
  %bf.set2664 = or i32 %bf.clear2663, %bf.clear2656
  store i32 %bf.set2664, i32* %static_flag2659, align 4
  br label %sw.epilog

sw.bb2665:                                        ; preds = %if.end150
  %684 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2666.not = icmp eq i32 %684, 0
  br i1 %tobool2666.not, label %if.end2682, label %land.lhs.true2667

land.lhs.true2667:                                ; preds = %sw.bb2665
  %arrayidx2668 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %685 = bitcast %union.anon.2* %arrayidx2668 to %struct.tree_common**
  %686 = load %struct.tree_common*, %struct.tree_common** %685, align 4, !tbaa !19
  %static_flag2671 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %686, i32 0, i32 2
  %bf.load2672 = load i32, i32* %static_flag2671, align 4
  %687 = and i32 %bf.load2672, 262144
  %tobool2675.not = icmp eq i32 %687, 0
  br i1 %tobool2675.not, label %if.end2682, label %if.then2676

if.then2676:                                      ; preds = %land.lhs.true2667
  %688 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %689 = load %struct.tree_identifier*, %struct.tree_identifier** %688, align 4, !tbaa !19
  %str2681 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %689, i32 0, i32 1, i32 1
  %690 = load i8*, i8** %str2681, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %690) #20
  br label %if.end2682

if.end2682:                                       ; preds = %if.then2676, %land.lhs.true2667, %sw.bb2665
  %ttype2684 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %691 = load %union.tree_node*, %union.tree_node** %ttype2684, align 4, !tbaa !19
  %arrayidx2685 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2686 = bitcast %union.anon.2* %arrayidx2685 to %union.tree_node**
  %692 = load %union.tree_node*, %union.tree_node** %ttype2686, align 4, !tbaa !19
  %call2687 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %691, %union.tree_node* %692) #20
  store %union.tree_node* %call2687, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %693 = bitcast %union.anon.2* %arrayidx2685 to %struct.tree_common**
  %694 = load %struct.tree_common*, %struct.tree_common** %693, align 4, !tbaa !19
  %static_flag2692 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %694, i32 0, i32 2
  %bf.load2693 = load i32, i32* %static_flag2692, align 4
  %bf.clear2695 = and i32 %bf.load2693, 262144
  %static_flag2698 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2687, i32 0, i32 0, i32 0, i32 2
  %bf.load2699 = load i32, i32* %static_flag2698, align 4
  %bf.clear2702 = and i32 %bf.load2699, -262145
  %bf.set2703 = or i32 %bf.clear2702, %bf.clear2695
  store i32 %bf.set2703, i32* %static_flag2698, align 4
  br label %sw.epilog

sw.bb2704:                                        ; preds = %if.end150
  %695 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool2705.not = icmp eq i32 %695, 0
  br i1 %tobool2705.not, label %if.end2721, label %land.lhs.true2706

land.lhs.true2706:                                ; preds = %sw.bb2704
  %arrayidx2707 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %696 = bitcast %union.anon.2* %arrayidx2707 to %struct.tree_common**
  %697 = load %struct.tree_common*, %struct.tree_common** %696, align 4, !tbaa !19
  %static_flag2710 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %697, i32 0, i32 2
  %bf.load2711 = load i32, i32* %static_flag2710, align 4
  %698 = and i32 %bf.load2711, 262144
  %tobool2714.not = icmp eq i32 %698, 0
  br i1 %tobool2714.not, label %if.end2721, label %if.then2715

if.then2715:                                      ; preds = %land.lhs.true2706
  %699 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_identifier**
  %700 = load %struct.tree_identifier*, %struct.tree_identifier** %699, align 4, !tbaa !19
  %str2720 = getelementptr inbounds %struct.tree_identifier, %struct.tree_identifier* %700, i32 0, i32 1, i32 1
  %701 = load i8*, i8** %str2720, align 4, !tbaa !19
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.29.2707, i32 0, i32 0), i8* %701) #20
  br label %if.end2721

if.end2721:                                       ; preds = %if.then2715, %land.lhs.true2706, %sw.bb2704
  %ttype2723 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %702 = load %union.tree_node*, %union.tree_node** %ttype2723, align 4, !tbaa !19
  %arrayidx2724 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2725 = bitcast %union.anon.2* %arrayidx2724 to %union.tree_node**
  %703 = load %union.tree_node*, %union.tree_node** %ttype2725, align 4, !tbaa !19
  %call2726 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %702, %union.tree_node* %703) #20
  store %union.tree_node* %call2726, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %704 = bitcast %union.anon.2* %arrayidx2724 to %struct.tree_common**
  %705 = load %struct.tree_common*, %struct.tree_common** %704, align 4, !tbaa !19
  %static_flag2731 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %705, i32 0, i32 2
  %bf.load2732 = load i32, i32* %static_flag2731, align 4
  %bf.clear2734 = and i32 %bf.load2732, 262144
  %static_flag2737 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2726, i32 0, i32 0, i32 0, i32 2
  %bf.load2738 = load i32, i32* %static_flag2737, align 4
  %bf.clear2741 = and i32 %bf.load2738, -262145
  %bf.set2742 = or i32 %bf.clear2741, %bf.clear2734
  store i32 %bf.set2742, i32* %static_flag2737, align 4
  br label %sw.epilog

sw.bb2743:                                        ; preds = %if.end150
  %ttype2745 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %706 = load %union.tree_node*, %union.tree_node** %ttype2745, align 4, !tbaa !19
  %arrayidx2746 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2747 = bitcast %union.anon.2* %arrayidx2746 to %union.tree_node**
  %707 = load %union.tree_node*, %union.tree_node** %ttype2747, align 4, !tbaa !19
  %call2748 = call %union.tree_node* @tree_cons(%union.tree_node* %706, %union.tree_node* null, %union.tree_node* %707) #20
  store %union.tree_node* %call2748, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %708 = bitcast %union.anon.2* %arrayidx2746 to %struct.tree_common**
  %709 = load %struct.tree_common*, %struct.tree_common** %708, align 4, !tbaa !19
  %static_flag2753 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %709, i32 0, i32 2
  %bf.load2754 = load i32, i32* %static_flag2753, align 4
  %bf.clear2756 = and i32 %bf.load2754, 262144
  %static_flag2759 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2748, i32 0, i32 0, i32 0, i32 2
  %bf.load2760 = load i32, i32* %static_flag2759, align 4
  %bf.clear2763 = and i32 %bf.load2760, -262145
  %bf.set2764 = or i32 %bf.clear2763, %bf.clear2756
  store i32 %bf.set2764, i32* %static_flag2759, align 4
  br label %sw.epilog

sw.bb2765:                                        ; preds = %if.end150
  %ttype2767 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %710 = load %union.tree_node*, %union.tree_node** %ttype2767, align 4, !tbaa !19
  %arrayidx2768 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2769 = bitcast %union.anon.2* %arrayidx2768 to %union.tree_node**
  %711 = load %union.tree_node*, %union.tree_node** %ttype2769, align 4, !tbaa !19
  %call2770 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %710, %union.tree_node* %711) #20
  store %union.tree_node* %call2770, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2774 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2770, i32 0, i32 0, i32 0, i32 2
  %bf.load2775 = load i32, i32* %static_flag2774, align 4
  %bf.set2777 = or i32 %bf.load2775, 262144
  store i32 %bf.set2777, i32* %static_flag2774, align 4
  br label %sw.epilog

sw.bb2778:                                        ; preds = %if.end150
  %ttype2780 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %712 = load %union.tree_node*, %union.tree_node** %ttype2780, align 4, !tbaa !19
  %arrayidx2781 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2782 = bitcast %union.anon.2* %arrayidx2781 to %union.tree_node**
  %713 = load %union.tree_node*, %union.tree_node** %ttype2782, align 4, !tbaa !19
  %call2783 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %712, %union.tree_node* %713) #20
  store %union.tree_node* %call2783, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2787 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2783, i32 0, i32 0, i32 0, i32 2
  %bf.load2788 = load i32, i32* %static_flag2787, align 4
  %bf.set2790 = or i32 %bf.load2788, 262144
  store i32 %bf.set2790, i32* %static_flag2787, align 4
  br label %sw.epilog

sw.bb2791:                                        ; preds = %if.end150
  %ttype2793 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %714 = load %union.tree_node*, %union.tree_node** %ttype2793, align 4, !tbaa !19
  %arrayidx2794 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2795 = bitcast %union.anon.2* %arrayidx2794 to %union.tree_node**
  %715 = load %union.tree_node*, %union.tree_node** %ttype2795, align 4, !tbaa !19
  %call2796 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %714, %union.tree_node* %715) #20
  store %union.tree_node* %call2796, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2800 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2796, i32 0, i32 0, i32 0, i32 2
  %bf.load2801 = load i32, i32* %static_flag2800, align 4
  %bf.set2803 = or i32 %bf.load2801, 262144
  store i32 %bf.set2803, i32* %static_flag2800, align 4
  br label %sw.epilog

sw.bb2804:                                        ; preds = %if.end150
  %ttype2806 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %716 = load %union.tree_node*, %union.tree_node** %ttype2806, align 4, !tbaa !19
  %arrayidx2807 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2808 = bitcast %union.anon.2* %arrayidx2807 to %union.tree_node**
  %717 = load %union.tree_node*, %union.tree_node** %ttype2808, align 4, !tbaa !19
  %call2809 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %716, %union.tree_node* %717) #20
  store %union.tree_node* %call2809, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %static_flag2813 = getelementptr inbounds %union.tree_node, %union.tree_node* %call2809, i32 0, i32 0, i32 0, i32 2
  %bf.load2814 = load i32, i32* %static_flag2813, align 4
  %bf.set2816 = or i32 %bf.load2814, 262144
  store i32 %bf.set2816, i32* %static_flag2813, align 4
  br label %sw.epilog

sw.bb2817:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2819:                                        ; preds = %if.end150
  %ttype2821 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %718 = load %union.tree_node*, %union.tree_node** %ttype2821, align 4, !tbaa !19
  store %union.tree_node* %718, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2824:                                        ; preds = %if.end150
  %ttype2826 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %719 = load %union.tree_node*, %union.tree_node** %ttype2826, align 4, !tbaa !19
  %call2827 = call %union.tree_node* @lookup_name(%union.tree_node* %719) #20
  store %union.tree_node* %call2827, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2829:                                        ; preds = %if.end150
  %arrayidx2830 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %720 = bitcast %union.anon.2* %arrayidx2830 to %struct.tree_common**
  %721 = load %struct.tree_common*, %struct.tree_common** %720, align 4, !tbaa !19
  %type2833 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %721, i32 0, i32 1
  %722 = load %union.tree_node*, %union.tree_node** %type2833, align 4, !tbaa !19
  store %union.tree_node* %722, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2835:                                        ; preds = %if.end150
  %arrayidx2836 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2837 = bitcast %union.anon.2* %arrayidx2836 to %union.tree_node**
  %723 = load %union.tree_node*, %union.tree_node** %ttype2837, align 4, !tbaa !19
  %call2838 = call %union.tree_node* @groktypename(%union.tree_node* %723) #20
  store %union.tree_node* %call2838, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2840:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2842:                                        ; preds = %if.end150
  %arrayidx2843 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2844 = bitcast %union.anon.2* %arrayidx2843 to %union.tree_node**
  %724 = load %union.tree_node*, %union.tree_node** %ttype2844, align 4, !tbaa !19
  %chain2846 = getelementptr inbounds %union.tree_node, %union.tree_node* %724, i32 0, i32 0, i32 0, i32 0
  %725 = load %union.tree_node*, %union.tree_node** %chain2846, align 4, !tbaa !19
  %tobool2847.not = icmp eq %union.tree_node* %725, null
  br i1 %tobool2847.not, label %if.end2854, label %if.then2848

if.then2848:                                      ; preds = %sw.bb2842
  %call2851 = call %union.tree_node* @combine_strings(%union.tree_node* nonnull %724) #20
  store %union.tree_node* %call2851, %union.tree_node** %ttype2844, align 4, !tbaa !19
  br label %if.end2854

if.end2854:                                       ; preds = %if.then2848, %sw.bb2842
  %726 = phi %union.tree_node* [ %call2851, %if.then2848 ], [ %724, %sw.bb2842 ]
  store %union.tree_node* %726, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2858:                                        ; preds = %if.end150
  %arrayidx2859 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype2860 = bitcast %union.anon.2* %arrayidx2859 to %union.tree_node**
  %727 = load %union.tree_node*, %union.tree_node** %ttype2860, align 4, !tbaa !19
  %728 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx2861 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2862 = bitcast %union.anon.2* %arrayidx2861 to %union.tree_node**
  %729 = load %union.tree_node*, %union.tree_node** %ttype2862, align 4, !tbaa !19
  %730 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call2863 = call %union.tree_node* @chainon(%union.tree_node* %729, %union.tree_node* %730) #20
  %call2864 = call %union.tree_node* @start_decl(%union.tree_node* %727, %union.tree_node* %728, i32 1, %union.tree_node* %call2863) #20
  store %union.tree_node* %call2864, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %arrayidx2867 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype2868 = bitcast %union.anon.2* %arrayidx2867 to %union.tree_node**
  %731 = load %union.tree_node*, %union.tree_node** %ttype2868, align 4, !tbaa !19
  %call2869 = call i32 @global_bindings_p() #20
  call void @start_init(%union.tree_node* %call2864, %union.tree_node* %731, i32 %call2869) #20
  br label %sw.epilog

sw.bb2870:                                        ; preds = %if.end150
  call void @finish_init() #20
  %arrayidx2871 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2872 = bitcast %union.anon.2* %arrayidx2871 to %union.tree_node**
  %732 = load %union.tree_node*, %union.tree_node** %ttype2872, align 4, !tbaa !19
  %ttype2874 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %733 = load %union.tree_node*, %union.tree_node** %ttype2874, align 4, !tbaa !19
  %arrayidx2875 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype2876 = bitcast %union.anon.2* %arrayidx2875 to %union.tree_node**
  %734 = load %union.tree_node*, %union.tree_node** %ttype2876, align 4, !tbaa !19
  call void @finish_decl(%union.tree_node* %732, %union.tree_node* %733, %union.tree_node* %734) #20
  br label %sw.epilog

sw.bb2877:                                        ; preds = %if.end150
  %arrayidx2878 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype2879 = bitcast %union.anon.2* %arrayidx2878 to %union.tree_node**
  %735 = load %union.tree_node*, %union.tree_node** %ttype2879, align 4, !tbaa !19
  %736 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype2881 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %737 = load %union.tree_node*, %union.tree_node** %ttype2881, align 4, !tbaa !19
  %738 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call2882 = call %union.tree_node* @chainon(%union.tree_node* %737, %union.tree_node* %738) #20
  %call2883 = call %union.tree_node* @start_decl(%union.tree_node* %735, %union.tree_node* %736, i32 0, %union.tree_node* %call2882) #20
  %arrayidx2884 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2885 = bitcast %union.anon.2* %arrayidx2884 to %union.tree_node**
  %739 = load %union.tree_node*, %union.tree_node** %ttype2885, align 4, !tbaa !19
  call void @finish_decl(%union.tree_node* %call2883, %union.tree_node* null, %union.tree_node* %739) #20
  br label %sw.epilog

sw.bb2887:                                        ; preds = %if.end150
  %arrayidx2888 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype2889 = bitcast %union.anon.2* %arrayidx2888 to %union.tree_node**
  %740 = load %union.tree_node*, %union.tree_node** %ttype2889, align 4, !tbaa !19
  %741 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx2890 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2891 = bitcast %union.anon.2* %arrayidx2890 to %union.tree_node**
  %742 = load %union.tree_node*, %union.tree_node** %ttype2891, align 4, !tbaa !19
  %743 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call2892 = call %union.tree_node* @chainon(%union.tree_node* %742, %union.tree_node* %743) #20
  %call2893 = call %union.tree_node* @start_decl(%union.tree_node* %740, %union.tree_node* %741, i32 1, %union.tree_node* %call2892) #20
  store %union.tree_node* %call2893, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %arrayidx2896 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype2897 = bitcast %union.anon.2* %arrayidx2896 to %union.tree_node**
  %744 = load %union.tree_node*, %union.tree_node** %ttype2897, align 4, !tbaa !19
  %call2898 = call i32 @global_bindings_p() #20
  call void @start_init(%union.tree_node* %call2893, %union.tree_node* %744, i32 %call2898) #20
  br label %sw.epilog

sw.bb2899:                                        ; preds = %if.end150
  call void @finish_init() #20
  %arrayidx2900 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2901 = bitcast %union.anon.2* %arrayidx2900 to %union.tree_node**
  %745 = load %union.tree_node*, %union.tree_node** %ttype2901, align 4, !tbaa !19
  %ttype2903 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %746 = load %union.tree_node*, %union.tree_node** %ttype2903, align 4, !tbaa !19
  %arrayidx2904 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype2905 = bitcast %union.anon.2* %arrayidx2904 to %union.tree_node**
  %747 = load %union.tree_node*, %union.tree_node** %ttype2905, align 4, !tbaa !19
  call void @finish_decl(%union.tree_node* %745, %union.tree_node* %746, %union.tree_node* %747) #20
  br label %sw.epilog

sw.bb2906:                                        ; preds = %if.end150
  %arrayidx2908 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype2909 = bitcast %union.anon.2* %arrayidx2908 to %union.tree_node**
  %748 = load %union.tree_node*, %union.tree_node** %ttype2909, align 4, !tbaa !19
  %749 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype2911 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %750 = load %union.tree_node*, %union.tree_node** %ttype2911, align 4, !tbaa !19
  %751 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call2912 = call %union.tree_node* @chainon(%union.tree_node* %750, %union.tree_node* %751) #20
  %call2913 = call %union.tree_node* @start_decl(%union.tree_node* %748, %union.tree_node* %749, i32 0, %union.tree_node* %call2912) #20
  %arrayidx2914 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2915 = bitcast %union.anon.2* %arrayidx2914 to %union.tree_node**
  %752 = load %union.tree_node*, %union.tree_node** %ttype2915, align 4, !tbaa !19
  call void @finish_decl(%union.tree_node* %call2913, %union.tree_node* null, %union.tree_node* %752) #20
  br label %sw.epilog

sw.bb2917:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2919:                                        ; preds = %if.end150
  %ttype2921 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %753 = load %union.tree_node*, %union.tree_node** %ttype2921, align 4, !tbaa !19
  store %union.tree_node* %753, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2923:                                        ; preds = %if.end150
  %ttype2925 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %754 = load %union.tree_node*, %union.tree_node** %ttype2925, align 4, !tbaa !19
  store %union.tree_node* %754, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2927:                                        ; preds = %if.end150
  %arrayidx2928 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2929 = bitcast %union.anon.2* %arrayidx2928 to %union.tree_node**
  %755 = load %union.tree_node*, %union.tree_node** %ttype2929, align 4, !tbaa !19
  %ttype2931 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %756 = load %union.tree_node*, %union.tree_node** %ttype2931, align 4, !tbaa !19
  %call2932 = call %union.tree_node* @chainon(%union.tree_node* %755, %union.tree_node* %756) #20
  store %union.tree_node* %call2932, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2934:                                        ; preds = %if.end150
  %arrayidx2935 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype2936 = bitcast %union.anon.2* %arrayidx2935 to %union.tree_node**
  %757 = load %union.tree_node*, %union.tree_node** %ttype2936, align 4, !tbaa !19
  store %union.tree_node* %757, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2938:                                        ; preds = %if.end150
  %ttype2940 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %758 = load %union.tree_node*, %union.tree_node** %ttype2940, align 4, !tbaa !19
  store %union.tree_node* %758, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2942:                                        ; preds = %if.end150
  %arrayidx2943 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype2944 = bitcast %union.anon.2* %arrayidx2943 to %union.tree_node**
  %759 = load %union.tree_node*, %union.tree_node** %ttype2944, align 4, !tbaa !19
  %ttype2946 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %760 = load %union.tree_node*, %union.tree_node** %ttype2946, align 4, !tbaa !19
  %call2947 = call %union.tree_node* @chainon(%union.tree_node* %759, %union.tree_node* %760) #20
  store %union.tree_node* %call2947, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2949:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2951:                                        ; preds = %if.end150
  %ttype2953 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %761 = load %union.tree_node*, %union.tree_node** %ttype2953, align 4, !tbaa !19
  %call2954 = call %union.tree_node* @build_tree_list(%union.tree_node* %761, %union.tree_node* null) #20
  store %union.tree_node* %call2954, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2956:                                        ; preds = %if.end150
  %arrayidx2957 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype2958 = bitcast %union.anon.2* %arrayidx2957 to %union.tree_node**
  %762 = load %union.tree_node*, %union.tree_node** %ttype2958, align 4, !tbaa !19
  %arrayidx2959 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2960 = bitcast %union.anon.2* %arrayidx2959 to %union.tree_node**
  %763 = load %union.tree_node*, %union.tree_node** %ttype2960, align 4, !tbaa !19
  %call2961 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %763) #20
  %call2962 = call %union.tree_node* @build_tree_list(%union.tree_node* %762, %union.tree_node* %call2961) #20
  store %union.tree_node* %call2962, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2964:                                        ; preds = %if.end150
  %arrayidx2965 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %ttype2966 = bitcast %union.anon.2* %arrayidx2965 to %union.tree_node**
  %764 = load %union.tree_node*, %union.tree_node** %ttype2966, align 4, !tbaa !19
  %arrayidx2967 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype2968 = bitcast %union.anon.2* %arrayidx2967 to %union.tree_node**
  %765 = load %union.tree_node*, %union.tree_node** %ttype2968, align 4, !tbaa !19
  %arrayidx2969 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2970 = bitcast %union.anon.2* %arrayidx2969 to %union.tree_node**
  %766 = load %union.tree_node*, %union.tree_node** %ttype2970, align 4, !tbaa !19
  %call2971 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %765, %union.tree_node* %766) #20
  %call2972 = call %union.tree_node* @build_tree_list(%union.tree_node* %764, %union.tree_node* %call2971) #20
  store %union.tree_node* %call2972, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2974:                                        ; preds = %if.end150
  %arrayidx2975 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype2976 = bitcast %union.anon.2* %arrayidx2975 to %union.tree_node**
  %767 = load %union.tree_node*, %union.tree_node** %ttype2976, align 4, !tbaa !19
  %arrayidx2977 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype2978 = bitcast %union.anon.2* %arrayidx2977 to %union.tree_node**
  %768 = load %union.tree_node*, %union.tree_node** %ttype2978, align 4, !tbaa !19
  %call2979 = call %union.tree_node* @build_tree_list(%union.tree_node* %767, %union.tree_node* %768) #20
  store %union.tree_node* %call2979, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2981:                                        ; preds = %if.end150
  call void @really_start_incremental_init(%union.tree_node* null) #20
  br label %sw.epilog

sw.bb2982:                                        ; preds = %if.end150
  %call2983 = call %union.tree_node* @pop_init_level(i32 0) #20
  store %union.tree_node* %call2983, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2985:                                        ; preds = %if.end150
  %769 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  store %union.tree_node* %769, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb2987:                                        ; preds = %if.end150
  %770 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool2988.not = icmp eq i32 %770, 0
  br i1 %tobool2988.not, label %sw.epilog, label %if.then2989

if.then2989:                                      ; preds = %sw.bb2987
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.30.2708, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb2991:                                        ; preds = %if.end150
  %771 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool2992 = icmp eq i32 %771, 0
  %772 = load i32, i32* @flag_isoc99, align 4
  %tobool2994 = icmp ne i32 %772, 0
  %or.cond4881 = select i1 %tobool2992, i1 true, i1 %tobool2994
  br i1 %or.cond4881, label %sw.epilog, label %if.then2995

if.then2995:                                      ; preds = %sw.bb2991
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.31.2709, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb2997:                                        ; preds = %if.end150
  %773 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool2998.not = icmp eq i32 %773, 0
  br i1 %tobool2998.not, label %sw.epilog, label %if.then2999

if.then2999:                                      ; preds = %sw.bb2997
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.32.2710, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3001:                                        ; preds = %if.end150
  %arrayidx3002 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3003 = bitcast %union.anon.2* %arrayidx3002 to %union.tree_node**
  %774 = load %union.tree_node*, %union.tree_node** %ttype3003, align 4, !tbaa !19
  call void @set_init_label(%union.tree_node* %774) #20
  %775 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3004.not = icmp eq i32 %775, 0
  br i1 %tobool3004.not, label %sw.epilog, label %if.then3005

if.then3005:                                      ; preds = %sw.bb3001
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.33.2711, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3007:                                        ; preds = %if.end150
  call void @push_init_level(i32 0) #20
  br label %sw.epilog

sw.bb3008:                                        ; preds = %if.end150
  %call3009 = call %union.tree_node* @pop_init_level(i32 0) #20
  call void @process_init_element(%union.tree_node* %call3009) #20
  br label %sw.epilog

sw.bb3010:                                        ; preds = %if.end150
  %ttype3012 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %776 = load %union.tree_node*, %union.tree_node** %ttype3012, align 4, !tbaa !19
  call void @process_init_element(%union.tree_node* %776) #20
  br label %sw.epilog

sw.bb3013:                                        ; preds = %if.end150
  %ttype3015 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %777 = load %union.tree_node*, %union.tree_node** %ttype3015, align 4, !tbaa !19
  call void @set_init_label(%union.tree_node* %777) #20
  br label %sw.epilog

sw.bb3016:                                        ; preds = %if.end150
  %arrayidx3017 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3018 = bitcast %union.anon.2* %arrayidx3017 to %union.tree_node**
  %778 = load %union.tree_node*, %union.tree_node** %ttype3018, align 4, !tbaa !19
  %arrayidx3019 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3020 = bitcast %union.anon.2* %arrayidx3019 to %union.tree_node**
  %779 = load %union.tree_node*, %union.tree_node** %ttype3020, align 4, !tbaa !19
  call void @set_init_index(%union.tree_node* %778, %union.tree_node* %779) #20
  %780 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3021.not = icmp eq i32 %780, 0
  br i1 %tobool3021.not, label %sw.epilog, label %if.then3022

if.then3022:                                      ; preds = %sw.bb3016
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.34.2712, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3024:                                        ; preds = %if.end150
  %arrayidx3025 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3026 = bitcast %union.anon.2* %arrayidx3025 to %union.tree_node**
  %781 = load %union.tree_node*, %union.tree_node** %ttype3026, align 4, !tbaa !19
  call void @set_init_index(%union.tree_node* %781, %union.tree_node* null) #20
  br label %sw.epilog

sw.bb3027:                                        ; preds = %if.end150
  %782 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3028.not = icmp eq i32 %782, 0
  br i1 %tobool3028.not, label %if.end3030, label %if.then3029

if.then3029:                                      ; preds = %sw.bb3027
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.35.2713, i32 0, i32 0)) #20
  br label %if.end3030

if.end3030:                                       ; preds = %if.then3029, %sw.bb3027
  call void @push_function_context() #20
  %783 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype3032 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %784 = load %union.tree_node*, %union.tree_node** %ttype3032, align 4, !tbaa !19
  %785 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3033 = call i32 @start_function(%union.tree_node* %783, %union.tree_node* %784, %union.tree_node* %785) #20
  %tobool3034.not = icmp eq i32 %call3033, 0
  br i1 %tobool3034.not, label %if.then3035, label %sw.epilog

if.then3035:                                      ; preds = %if.end3030
  call void @pop_function_context() #20
  call fastcc void @yyerror(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.17.2695, i32 0, i32 0)) #21
  br label %yyerrlab1

sw.bb3037:                                        ; preds = %if.end150
  call void @store_parm_decls() #20
  br label %sw.epilog

sw.bb3038:                                        ; preds = %if.end150
  %786 = load %union.tree_node*, %union.tree_node** @current_function_decl, align 4, !tbaa !15
  %arrayidx3040 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %filename3041 = bitcast %union.anon.2* %arrayidx3040 to i8**
  %787 = load i8*, i8** %filename3041, align 4, !tbaa !19
  %filename3043 = getelementptr inbounds %union.tree_node, %union.tree_node* %786, i32 0, i32 0, i32 1
  store i8* %787, i8** %filename3043, align 4, !tbaa !19
  %lineno3045 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %788 = load i32, i32* %lineno3045, align 4, !tbaa !19
  %linenum3047 = getelementptr inbounds %union.tree_node, %union.tree_node* %786, i32 0, i32 0, i32 2
  store i32 %788, i32* %linenum3047, align 4, !tbaa !19
  call void @finish_function(i32 1, i32 1) #20
  call void @pop_function_context() #20
  call void @add_decl_stmt(%union.tree_node* %786) #20
  br label %sw.epilog

sw.bb3049:                                        ; preds = %if.end150
  %789 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3050.not = icmp eq i32 %789, 0
  br i1 %tobool3050.not, label %if.end3052, label %if.then3051

if.then3051:                                      ; preds = %sw.bb3049
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.35.2713, i32 0, i32 0)) #20
  br label %if.end3052

if.end3052:                                       ; preds = %if.then3051, %sw.bb3049
  call void @push_function_context() #20
  %790 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype3054 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %791 = load %union.tree_node*, %union.tree_node** %ttype3054, align 4, !tbaa !19
  %792 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3055 = call i32 @start_function(%union.tree_node* %790, %union.tree_node* %791, %union.tree_node* %792) #20
  %tobool3056.not = icmp eq i32 %call3055, 0
  br i1 %tobool3056.not, label %if.then3057, label %sw.epilog

if.then3057:                                      ; preds = %if.end3052
  call void @pop_function_context() #20
  call fastcc void @yyerror(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.17.2695, i32 0, i32 0)) #21
  br label %yyerrlab1

sw.bb3059:                                        ; preds = %if.end150
  call void @store_parm_decls() #20
  br label %sw.epilog

sw.bb3060:                                        ; preds = %if.end150
  %793 = load %union.tree_node*, %union.tree_node** @current_function_decl, align 4, !tbaa !15
  %arrayidx3062 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %filename3063 = bitcast %union.anon.2* %arrayidx3062 to i8**
  %794 = load i8*, i8** %filename3063, align 4, !tbaa !19
  %filename3065 = getelementptr inbounds %union.tree_node, %union.tree_node* %793, i32 0, i32 0, i32 1
  store i8* %794, i8** %filename3065, align 4, !tbaa !19
  %lineno3067 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %795 = load i32, i32* %lineno3067, align 4, !tbaa !19
  %linenum3069 = getelementptr inbounds %union.tree_node, %union.tree_node* %793, i32 0, i32 0, i32 2
  store i32 %795, i32* %linenum3069, align 4, !tbaa !19
  call void @finish_function(i32 1, i32 1) #20
  call void @pop_function_context() #20
  call void @add_decl_stmt(%union.tree_node* %793) #20
  br label %sw.epilog

sw.bb3071:                                        ; preds = %if.end150
  %arrayidx3072 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3073 = bitcast %union.anon.2* %arrayidx3072 to %union.tree_node**
  %796 = load %union.tree_node*, %union.tree_node** %ttype3073, align 4, !tbaa !19
  %tobool3074.not = icmp eq %union.tree_node* %796, null
  %arrayidx3082 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3083 = bitcast %union.anon.2* %arrayidx3082 to %union.tree_node**
  %797 = load %union.tree_node*, %union.tree_node** %ttype3083, align 4, !tbaa !19
  br i1 %tobool3074.not, label %cond.end3084, label %cond.true3075

cond.true3075:                                    ; preds = %sw.bb3071
  %call3080 = call %union.tree_node* @tree_cons(%union.tree_node* nonnull %796, %union.tree_node* %797, %union.tree_node* null) #20
  br label %cond.end3084

cond.end3084:                                     ; preds = %cond.true3075, %sw.bb3071
  %cond3085 = phi %union.tree_node* [ %call3080, %cond.true3075 ], [ %797, %sw.bb3071 ]
  store %union.tree_node* %cond3085, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3087:                                        ; preds = %if.end150
  %arrayidx3088 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3089 = bitcast %union.anon.2* %arrayidx3088 to %union.tree_node**
  %798 = load %union.tree_node*, %union.tree_node** %ttype3089, align 4, !tbaa !19
  %ttype3091 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %799 = load %union.tree_node*, %union.tree_node** %ttype3091, align 4, !tbaa !19
  %call3092 = call %union.tree_node* (i32, ...) @build_nt(i32 53, %union.tree_node* %798, %union.tree_node* %799, %union.tree_node* null) #20
  store %union.tree_node* %call3092, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3094:                                        ; preds = %if.end150
  %ttype3096 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %800 = load %union.tree_node*, %union.tree_node** %ttype3096, align 4, !tbaa !19
  %arrayidx3097 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3098 = bitcast %union.anon.2* %arrayidx3097 to %union.tree_node**
  %801 = load %union.tree_node*, %union.tree_node** %ttype3098, align 4, !tbaa !19
  %call3099 = call %union.tree_node* @set_array_declarator_type(%union.tree_node* %800, %union.tree_node* %801, i32 0) #20
  store %union.tree_node* %call3099, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3101:                                        ; preds = %if.end150
  %arrayidx3102 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3103 = bitcast %union.anon.2* %arrayidx3102 to %union.tree_node**
  %802 = load %union.tree_node*, %union.tree_node** %ttype3103, align 4, !tbaa !19
  %ttype3105 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %803 = load %union.tree_node*, %union.tree_node** %ttype3105, align 4, !tbaa !19
  %call3106 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %802, %union.tree_node* %803) #21
  store %union.tree_node* %call3106, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3108:                                        ; preds = %if.end150
  %arrayidx3109 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3110 = bitcast %union.anon.2* %arrayidx3109 to %union.tree_node**
  %804 = load %union.tree_node*, %union.tree_node** %ttype3110, align 4, !tbaa !19
  %ttype3112 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %805 = load %union.tree_node*, %union.tree_node** %ttype3112, align 4, !tbaa !19
  %call3113 = call %union.tree_node* (i32, ...) @build_nt(i32 53, %union.tree_node* %804, %union.tree_node* %805, %union.tree_node* null) #20
  store %union.tree_node* %call3113, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3115:                                        ; preds = %if.end150
  %ttype3117 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %806 = load %union.tree_node*, %union.tree_node** %ttype3117, align 4, !tbaa !19
  %arrayidx3118 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3119 = bitcast %union.anon.2* %arrayidx3118 to %union.tree_node**
  %807 = load %union.tree_node*, %union.tree_node** %ttype3119, align 4, !tbaa !19
  %call3120 = call %union.tree_node* @set_array_declarator_type(%union.tree_node* %806, %union.tree_node* %807, i32 0) #20
  store %union.tree_node* %call3120, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3122:                                        ; preds = %if.end150
  %arrayidx3123 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3124 = bitcast %union.anon.2* %arrayidx3123 to %union.tree_node**
  %808 = load %union.tree_node*, %union.tree_node** %ttype3124, align 4, !tbaa !19
  %ttype3126 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %809 = load %union.tree_node*, %union.tree_node** %ttype3126, align 4, !tbaa !19
  %call3127 = call %union.tree_node* (i32, ...) @build_nt(i32 53, %union.tree_node* %808, %union.tree_node* %809, %union.tree_node* null) #20
  store %union.tree_node* %call3127, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3129:                                        ; preds = %if.end150
  %ttype3131 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %810 = load %union.tree_node*, %union.tree_node** %ttype3131, align 4, !tbaa !19
  %arrayidx3132 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3133 = bitcast %union.anon.2* %arrayidx3132 to %union.tree_node**
  %811 = load %union.tree_node*, %union.tree_node** %ttype3133, align 4, !tbaa !19
  %call3134 = call %union.tree_node* @set_array_declarator_type(%union.tree_node* %810, %union.tree_node* %811, i32 0) #20
  store %union.tree_node* %call3134, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3136:                                        ; preds = %if.end150
  %arrayidx3137 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3138 = bitcast %union.anon.2* %arrayidx3137 to %union.tree_node**
  %812 = load %union.tree_node*, %union.tree_node** %ttype3138, align 4, !tbaa !19
  %ttype3140 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %813 = load %union.tree_node*, %union.tree_node** %ttype3140, align 4, !tbaa !19
  %call3141 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %812, %union.tree_node* %813) #21
  store %union.tree_node* %call3141, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3143:                                        ; preds = %if.end150
  %arrayidx3144 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3145 = bitcast %union.anon.2* %arrayidx3144 to %union.tree_node**
  %814 = load %union.tree_node*, %union.tree_node** %ttype3145, align 4, !tbaa !19
  %ttype3147 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %815 = load %union.tree_node*, %union.tree_node** %ttype3147, align 4, !tbaa !19
  %call3148 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %814, %union.tree_node* %815) #21
  store %union.tree_node* %call3148, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3150:                                        ; preds = %if.end150
  %arrayidx3151 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3152 = bitcast %union.anon.2* %arrayidx3151 to %union.tree_node**
  %816 = load %union.tree_node*, %union.tree_node** %ttype3152, align 4, !tbaa !19
  %tobool3153.not = icmp eq %union.tree_node* %816, null
  %arrayidx3161 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3162 = bitcast %union.anon.2* %arrayidx3161 to %union.tree_node**
  %817 = load %union.tree_node*, %union.tree_node** %ttype3162, align 4, !tbaa !19
  br i1 %tobool3153.not, label %cond.end3163, label %cond.true3154

cond.true3154:                                    ; preds = %sw.bb3150
  %call3159 = call %union.tree_node* @tree_cons(%union.tree_node* nonnull %816, %union.tree_node* %817, %union.tree_node* null) #20
  br label %cond.end3163

cond.end3163:                                     ; preds = %cond.true3154, %sw.bb3150
  %cond3164 = phi %union.tree_node* [ %call3159, %cond.true3154 ], [ %817, %sw.bb3150 ]
  store %union.tree_node* %cond3164, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3166:                                        ; preds = %if.end150
  %arrayidx3167 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3168 = bitcast %union.anon.2* %arrayidx3167 to %union.tree_node**
  %818 = load %union.tree_node*, %union.tree_node** %ttype3168, align 4, !tbaa !19
  %ttype3170 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %819 = load %union.tree_node*, %union.tree_node** %ttype3170, align 4, !tbaa !19
  %call3171 = call %union.tree_node* (i32, ...) @build_nt(i32 53, %union.tree_node* %818, %union.tree_node* %819, %union.tree_node* null) #20
  store %union.tree_node* %call3171, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3173:                                        ; preds = %if.end150
  %arrayidx3174 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3175 = bitcast %union.anon.2* %arrayidx3174 to %union.tree_node**
  %820 = load %union.tree_node*, %union.tree_node** %ttype3175, align 4, !tbaa !19
  %tobool3176.not = icmp eq %union.tree_node* %820, null
  %arrayidx3184 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3185 = bitcast %union.anon.2* %arrayidx3184 to %union.tree_node**
  %821 = load %union.tree_node*, %union.tree_node** %ttype3185, align 4, !tbaa !19
  br i1 %tobool3176.not, label %cond.end3186, label %cond.true3177

cond.true3177:                                    ; preds = %sw.bb3173
  %call3182 = call %union.tree_node* @tree_cons(%union.tree_node* nonnull %820, %union.tree_node* %821, %union.tree_node* null) #20
  br label %cond.end3186

cond.end3186:                                     ; preds = %cond.true3177, %sw.bb3173
  %cond3187 = phi %union.tree_node* [ %call3182, %cond.true3177 ], [ %821, %sw.bb3173 ]
  store %union.tree_node* %cond3187, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3189:                                        ; preds = %if.end150
  %arrayidx3190 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3191 = bitcast %union.anon.2* %arrayidx3190 to %union.tree_node**
  %822 = load %union.tree_node*, %union.tree_node** %ttype3191, align 4, !tbaa !19
  %ttype3193 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %823 = load %union.tree_node*, %union.tree_node** %ttype3193, align 4, !tbaa !19
  %call3194 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %822, %union.tree_node* %823) #21
  store %union.tree_node* %call3194, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3196:                                        ; preds = %if.end150
  %ttype3198 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %824 = load %union.tree_node*, %union.tree_node** %ttype3198, align 4, !tbaa !19
  %arrayidx3199 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3200 = bitcast %union.anon.2* %arrayidx3199 to %union.tree_node**
  %825 = load %union.tree_node*, %union.tree_node** %ttype3200, align 4, !tbaa !19
  %call3201 = call %union.tree_node* @set_array_declarator_type(%union.tree_node* %824, %union.tree_node* %825, i32 0) #20
  store %union.tree_node* %call3201, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3203:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3205:                                        ; preds = %if.end150
  %ttype3207 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %826 = load %union.tree_node*, %union.tree_node** %ttype3207, align 4, !tbaa !19
  store %union.tree_node* %826, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3209:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3211:                                        ; preds = %if.end150
  %ttype3213 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %827 = load %union.tree_node*, %union.tree_node** %ttype3213, align 4, !tbaa !19
  store %union.tree_node* %827, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3215:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3217:                                        ; preds = %if.end150
  %ttype3219 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %828 = load %union.tree_node*, %union.tree_node** %ttype3219, align 4, !tbaa !19
  store %union.tree_node* %828, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3221:                                        ; preds = %if.end150
  %arrayidx3222 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3223 = bitcast %union.anon.2* %arrayidx3222 to %union.tree_node**
  %829 = load %union.tree_node*, %union.tree_node** %ttype3223, align 4, !tbaa !19
  %call3224 = call %union.tree_node* @start_struct(i32 20, %union.tree_node* %829) #20
  store %union.tree_node* %call3224, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3226:                                        ; preds = %if.end150
  %arrayidx3227 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3228 = bitcast %union.anon.2* %arrayidx3227 to %union.tree_node**
  %830 = load %union.tree_node*, %union.tree_node** %ttype3228, align 4, !tbaa !19
  %arrayidx3229 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3230 = bitcast %union.anon.2* %arrayidx3229 to %union.tree_node**
  %831 = load %union.tree_node*, %union.tree_node** %ttype3230, align 4, !tbaa !19
  %arrayidx3231 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype3232 = bitcast %union.anon.2* %arrayidx3231 to %union.tree_node**
  %832 = load %union.tree_node*, %union.tree_node** %ttype3232, align 4, !tbaa !19
  %ttype3234 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %833 = load %union.tree_node*, %union.tree_node** %ttype3234, align 4, !tbaa !19
  %call3235 = call %union.tree_node* @chainon(%union.tree_node* %832, %union.tree_node* %833) #20
  %call3236 = call %union.tree_node* @finish_struct(%union.tree_node* %830, %union.tree_node* %831, %union.tree_node* %call3235) #20
  store %union.tree_node* %call3236, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3238:                                        ; preds = %if.end150
  %call3239 = call %union.tree_node* @start_struct(i32 20, %union.tree_node* null) #20
  %arrayidx3240 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3241 = bitcast %union.anon.2* %arrayidx3240 to %union.tree_node**
  %834 = load %union.tree_node*, %union.tree_node** %ttype3241, align 4, !tbaa !19
  %arrayidx3242 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype3243 = bitcast %union.anon.2* %arrayidx3242 to %union.tree_node**
  %835 = load %union.tree_node*, %union.tree_node** %ttype3243, align 4, !tbaa !19
  %ttype3245 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %836 = load %union.tree_node*, %union.tree_node** %ttype3245, align 4, !tbaa !19
  %call3246 = call %union.tree_node* @chainon(%union.tree_node* %835, %union.tree_node* %836) #20
  %call3247 = call %union.tree_node* @finish_struct(%union.tree_node* %call3239, %union.tree_node* %834, %union.tree_node* %call3246) #20
  store %union.tree_node* %call3247, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3249:                                        ; preds = %if.end150
  %arrayidx3250 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3251 = bitcast %union.anon.2* %arrayidx3250 to %union.tree_node**
  %837 = load %union.tree_node*, %union.tree_node** %ttype3251, align 4, !tbaa !19
  %call3252 = call %union.tree_node* @start_struct(i32 21, %union.tree_node* %837) #20
  store %union.tree_node* %call3252, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3254:                                        ; preds = %if.end150
  %arrayidx3255 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3256 = bitcast %union.anon.2* %arrayidx3255 to %union.tree_node**
  %838 = load %union.tree_node*, %union.tree_node** %ttype3256, align 4, !tbaa !19
  %arrayidx3257 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3258 = bitcast %union.anon.2* %arrayidx3257 to %union.tree_node**
  %839 = load %union.tree_node*, %union.tree_node** %ttype3258, align 4, !tbaa !19
  %arrayidx3259 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype3260 = bitcast %union.anon.2* %arrayidx3259 to %union.tree_node**
  %840 = load %union.tree_node*, %union.tree_node** %ttype3260, align 4, !tbaa !19
  %ttype3262 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %841 = load %union.tree_node*, %union.tree_node** %ttype3262, align 4, !tbaa !19
  %call3263 = call %union.tree_node* @chainon(%union.tree_node* %840, %union.tree_node* %841) #20
  %call3264 = call %union.tree_node* @finish_struct(%union.tree_node* %838, %union.tree_node* %839, %union.tree_node* %call3263) #20
  store %union.tree_node* %call3264, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3266:                                        ; preds = %if.end150
  %call3267 = call %union.tree_node* @start_struct(i32 21, %union.tree_node* null) #20
  %arrayidx3268 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3269 = bitcast %union.anon.2* %arrayidx3268 to %union.tree_node**
  %842 = load %union.tree_node*, %union.tree_node** %ttype3269, align 4, !tbaa !19
  %arrayidx3270 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype3271 = bitcast %union.anon.2* %arrayidx3270 to %union.tree_node**
  %843 = load %union.tree_node*, %union.tree_node** %ttype3271, align 4, !tbaa !19
  %ttype3273 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %844 = load %union.tree_node*, %union.tree_node** %ttype3273, align 4, !tbaa !19
  %call3274 = call %union.tree_node* @chainon(%union.tree_node* %843, %union.tree_node* %844) #20
  %call3275 = call %union.tree_node* @finish_struct(%union.tree_node* %call3267, %union.tree_node* %842, %union.tree_node* %call3274) #20
  store %union.tree_node* %call3275, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3277:                                        ; preds = %if.end150
  %arrayidx3278 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3279 = bitcast %union.anon.2* %arrayidx3278 to %union.tree_node**
  %845 = load %union.tree_node*, %union.tree_node** %ttype3279, align 4, !tbaa !19
  %call3280 = call %union.tree_node* @start_enum(%union.tree_node* %845) #20
  store %union.tree_node* %call3280, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3282:                                        ; preds = %if.end150
  %arrayidx3283 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype3284 = bitcast %union.anon.2* %arrayidx3283 to %union.tree_node**
  %846 = load %union.tree_node*, %union.tree_node** %ttype3284, align 4, !tbaa !19
  %arrayidx3285 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3286 = bitcast %union.anon.2* %arrayidx3285 to %union.tree_node**
  %847 = load %union.tree_node*, %union.tree_node** %ttype3286, align 4, !tbaa !19
  %call3287 = call %union.tree_node* @nreverse(%union.tree_node* %847) #20
  %arrayidx3288 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -7
  %ttype3289 = bitcast %union.anon.2* %arrayidx3288 to %union.tree_node**
  %848 = load %union.tree_node*, %union.tree_node** %ttype3289, align 4, !tbaa !19
  %ttype3291 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %849 = load %union.tree_node*, %union.tree_node** %ttype3291, align 4, !tbaa !19
  %call3292 = call %union.tree_node* @chainon(%union.tree_node* %848, %union.tree_node* %849) #20
  %call3293 = call %union.tree_node* @finish_enum(%union.tree_node* %846, %union.tree_node* %call3287, %union.tree_node* %call3292) #20
  store %union.tree_node* %call3293, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3295:                                        ; preds = %if.end150
  %call3296 = call %union.tree_node* @start_enum(%union.tree_node* null) #20
  store %union.tree_node* %call3296, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3298:                                        ; preds = %if.end150
  %arrayidx3299 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype3300 = bitcast %union.anon.2* %arrayidx3299 to %union.tree_node**
  %850 = load %union.tree_node*, %union.tree_node** %ttype3300, align 4, !tbaa !19
  %arrayidx3301 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3302 = bitcast %union.anon.2* %arrayidx3301 to %union.tree_node**
  %851 = load %union.tree_node*, %union.tree_node** %ttype3302, align 4, !tbaa !19
  %call3303 = call %union.tree_node* @nreverse(%union.tree_node* %851) #20
  %arrayidx3304 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype3305 = bitcast %union.anon.2* %arrayidx3304 to %union.tree_node**
  %852 = load %union.tree_node*, %union.tree_node** %ttype3305, align 4, !tbaa !19
  %ttype3307 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %853 = load %union.tree_node*, %union.tree_node** %ttype3307, align 4, !tbaa !19
  %call3308 = call %union.tree_node* @chainon(%union.tree_node* %852, %union.tree_node* %853) #20
  %call3309 = call %union.tree_node* @finish_enum(%union.tree_node* %850, %union.tree_node* %call3303, %union.tree_node* %call3308) #20
  store %union.tree_node* %call3309, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3311:                                        ; preds = %if.end150
  %ttype3313 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %854 = load %union.tree_node*, %union.tree_node** %ttype3313, align 4, !tbaa !19
  %call3314 = call %union.tree_node* @xref_tag(i32 20, %union.tree_node* %854) #20
  store %union.tree_node* %call3314, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3316:                                        ; preds = %if.end150
  %ttype3318 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %855 = load %union.tree_node*, %union.tree_node** %ttype3318, align 4, !tbaa !19
  %call3319 = call %union.tree_node* @xref_tag(i32 21, %union.tree_node* %855) #20
  store %union.tree_node* %call3319, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3321:                                        ; preds = %if.end150
  %ttype3323 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %856 = load %union.tree_node*, %union.tree_node** %ttype3323, align 4, !tbaa !19
  %call3324 = call %union.tree_node* @xref_tag(i32 10, %union.tree_node* %856) #20
  store %union.tree_node* %call3324, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %857 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3326.not = icmp eq i32 %857, 0
  br i1 %tobool3326.not, label %sw.epilog, label %land.lhs.true3327

land.lhs.true3327:                                ; preds = %sw.bb3321
  %size3330 = getelementptr inbounds %union.tree_node, %union.tree_node* %call3324, i32 0, i32 0, i32 2
  %858 = bitcast i32* %size3330 to %union.tree_node**
  %859 = load %union.tree_node*, %union.tree_node** %858, align 4, !tbaa !19
  %cmp3331.not = icmp eq %union.tree_node* %859, null
  br i1 %cmp3331.not, label %if.then3333, label %sw.epilog

if.then3333:                                      ; preds = %land.lhs.true3327
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.36.2714, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3335:                                        ; preds = %if.end150
  %860 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3336 = icmp eq i32 %860, 0
  %861 = load i32, i32* @flag_isoc99, align 4
  %tobool3338 = icmp ne i32 %861, 0
  %or.cond4882 = select i1 %tobool3336, i1 true, i1 %tobool3338
  br i1 %or.cond4882, label %sw.epilog, label %if.then3339

if.then3339:                                      ; preds = %sw.bb3335
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.37.2715, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3341:                                        ; preds = %if.end150
  %ttype3343 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %862 = load %union.tree_node*, %union.tree_node** %ttype3343, align 4, !tbaa !19
  store %union.tree_node* %862, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3345:                                        ; preds = %if.end150
  %arrayidx3346 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3347 = bitcast %union.anon.2* %arrayidx3346 to %union.tree_node**
  %863 = load %union.tree_node*, %union.tree_node** %ttype3347, align 4, !tbaa !19
  %ttype3349 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %864 = load %union.tree_node*, %union.tree_node** %ttype3349, align 4, !tbaa !19
  %call3350 = call %union.tree_node* @chainon(%union.tree_node* %863, %union.tree_node* %864) #20
  store %union.tree_node* %call3350, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.38.2716, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3352:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3354:                                        ; preds = %if.end150
  %arrayidx3355 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3356 = bitcast %union.anon.2* %arrayidx3355 to %union.tree_node**
  %865 = load %union.tree_node*, %union.tree_node** %ttype3356, align 4, !tbaa !19
  %arrayidx3357 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3358 = bitcast %union.anon.2* %arrayidx3357 to %union.tree_node**
  %866 = load %union.tree_node*, %union.tree_node** %ttype3358, align 4, !tbaa !19
  %call3359 = call %union.tree_node* @chainon(%union.tree_node* %865, %union.tree_node* %866) #20
  store %union.tree_node* %call3359, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3361:                                        ; preds = %if.end150
  %867 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3362.not = icmp eq i32 %867, 0
  br i1 %tobool3362.not, label %sw.epilog, label %if.then3363

if.then3363:                                      ; preds = %sw.bb3361
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.39.2717, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3365:                                        ; preds = %if.end150
  %ttype3367 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %868 = load %union.tree_node*, %union.tree_node** %ttype3367, align 4, !tbaa !19
  store %union.tree_node* %868, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %869 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value3371 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %869, i32 0, i32 2
  %870 = load %union.tree_node*, %union.tree_node** %value3371, align 4, !tbaa !19
  store %union.tree_node* %870, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose3373 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %869, i32 0, i32 1
  %871 = bitcast %union.tree_node** %purpose3373 to %struct.tree_list**
  %872 = load %struct.tree_list*, %struct.tree_list** %871, align 4, !tbaa !19
  %purpose3375 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %872, i32 0, i32 1
  %873 = load %union.tree_node*, %union.tree_node** %purpose3375, align 4, !tbaa !19
  store %union.tree_node* %873, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value3379 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %872, i32 0, i32 2
  %874 = load %union.tree_node*, %union.tree_node** %value3379, align 4, !tbaa !19
  store %union.tree_node* %874, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain3381 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %869, i32 0, i32 0, i32 0
  %875 = load %union.tree_node*, %union.tree_node** %chain3381, align 4, !tbaa !19
  store %union.tree_node* %875, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb3384:                                        ; preds = %if.end150
  %876 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3385.not = icmp eq i32 %876, 0
  br i1 %tobool3385.not, label %if.end3387, label %if.then3386

if.then3386:                                      ; preds = %sw.bb3384
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.40.2718, i32 0, i32 0)) #20
  br label %if.end3387

if.end3387:                                       ; preds = %if.then3386, %sw.bb3384
  %arrayidx3388 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %filename3389 = bitcast %union.anon.2* %arrayidx3388 to i8**
  %877 = load i8*, i8** %filename3389, align 4, !tbaa !19
  %lineno3391 = getelementptr %union.anon.2, %union.anon.2* %yyvsp.3, i32 0, i32 0
  %878 = load i32, i32* %lineno3391, align 4, !tbaa !19
  %879 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %call3392 = call %union.tree_node* @grokfield(i8* %877, i32 %878, %union.tree_node* null, %union.tree_node* %879, %union.tree_node* null) #20
  store %union.tree_node* %call3392, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %880 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value3396 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %880, i32 0, i32 2
  %881 = load %union.tree_node*, %union.tree_node** %value3396, align 4, !tbaa !19
  store %union.tree_node* %881, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose3398 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %880, i32 0, i32 1
  %882 = bitcast %union.tree_node** %purpose3398 to %struct.tree_list**
  %883 = load %struct.tree_list*, %struct.tree_list** %882, align 4, !tbaa !19
  %purpose3400 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %883, i32 0, i32 1
  %884 = load %union.tree_node*, %union.tree_node** %purpose3400, align 4, !tbaa !19
  store %union.tree_node* %884, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value3404 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %883, i32 0, i32 2
  %885 = load %union.tree_node*, %union.tree_node** %value3404, align 4, !tbaa !19
  store %union.tree_node* %885, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain3406 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %880, i32 0, i32 0, i32 0
  %886 = load %union.tree_node*, %union.tree_node** %chain3406, align 4, !tbaa !19
  store %union.tree_node* %886, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb3409:                                        ; preds = %if.end150
  %ttype3411 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %887 = load %union.tree_node*, %union.tree_node** %ttype3411, align 4, !tbaa !19
  store %union.tree_node* %887, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %888 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value3415 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %888, i32 0, i32 2
  %889 = load %union.tree_node*, %union.tree_node** %value3415, align 4, !tbaa !19
  store %union.tree_node* %889, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose3417 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %888, i32 0, i32 1
  %890 = bitcast %union.tree_node** %purpose3417 to %struct.tree_list**
  %891 = load %struct.tree_list*, %struct.tree_list** %890, align 4, !tbaa !19
  %purpose3419 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %891, i32 0, i32 1
  %892 = load %union.tree_node*, %union.tree_node** %purpose3419, align 4, !tbaa !19
  store %union.tree_node* %892, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value3423 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %891, i32 0, i32 2
  %893 = load %union.tree_node*, %union.tree_node** %value3423, align 4, !tbaa !19
  store %union.tree_node* %893, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain3425 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %888, i32 0, i32 0, i32 0
  %894 = load %union.tree_node*, %union.tree_node** %chain3425, align 4, !tbaa !19
  store %union.tree_node* %894, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb3428:                                        ; preds = %if.end150
  %895 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3429.not = icmp eq i32 %895, 0
  br i1 %tobool3429.not, label %if.end3431, label %if.then3430

if.then3430:                                      ; preds = %sw.bb3428
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @.str.41.2719, i32 0, i32 0)) #20
  br label %if.end3431

if.end3431:                                       ; preds = %if.then3430, %sw.bb3428
  %ttype3433 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %896 = load %union.tree_node*, %union.tree_node** %ttype3433, align 4, !tbaa !19
  call void @shadow_tag(%union.tree_node* %896) #20
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3435:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3437:                                        ; preds = %if.end150
  %ttype3439 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %897 = load %union.tree_node*, %union.tree_node** %ttype3439, align 4, !tbaa !19
  store %union.tree_node* %897, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %arrayidx3443 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3444 = bitcast %union.anon.2* %arrayidx3443 to %union.tree_node**
  %898 = load %union.tree_node*, %union.tree_node** %ttype3444, align 4, !tbaa !19
  %call3445 = call i64 @tree_low_cst(%union.tree_node* %898, i32 0) #20
  %conv3446 = trunc i64 %call3445 to i32
  %and3447 = and i32 %conv3446, 1
  store i32 %and3447, i32* @pedantic, align 4, !tbaa !16
  %shr34485765 = lshr i32 %conv3446, 1
  %and3449 = and i32 %shr34485765, 1
  store i32 %and3449, i32* @warn_pointer_arith, align 4, !tbaa !16
  %shr34505766 = lshr i32 %conv3446, 2
  %and3451 = and i32 %shr34505766, 1
  store i32 %and3451, i32* @warn_traditional, align 4, !tbaa !16
  br label %sw.epilog

sw.bb3454:                                        ; preds = %if.end150
  %arrayidx3455 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3456 = bitcast %union.anon.2* %arrayidx3455 to %union.tree_node**
  %899 = load %union.tree_node*, %union.tree_node** %ttype3456, align 4, !tbaa !19
  %ttype3458 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %900 = load %union.tree_node*, %union.tree_node** %ttype3458, align 4, !tbaa !19
  %call3459 = call %union.tree_node* @chainon(%union.tree_node* %899, %union.tree_node* %900) #20
  store %union.tree_node* %call3459, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3461:                                        ; preds = %if.end150
  %arrayidx3462 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3463 = bitcast %union.anon.2* %arrayidx3462 to %union.tree_node**
  %901 = load %union.tree_node*, %union.tree_node** %ttype3463, align 4, !tbaa !19
  %ttype3465 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %902 = load %union.tree_node*, %union.tree_node** %ttype3465, align 4, !tbaa !19
  %call3466 = call %union.tree_node* @chainon(%union.tree_node* %901, %union.tree_node* %902) #20
  store %union.tree_node* %call3466, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3468:                                        ; preds = %if.end150
  %arrayidx3469 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %filename3470 = bitcast %union.anon.2* %arrayidx3469 to i8**
  %903 = load i8*, i8** %filename3470, align 4, !tbaa !19
  %lineno3472 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2, i32 0
  %904 = load i32, i32* %lineno3472, align 4, !tbaa !19
  %arrayidx3473 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3474 = bitcast %union.anon.2* %arrayidx3473 to %union.tree_node**
  %905 = load %union.tree_node*, %union.tree_node** %ttype3474, align 4, !tbaa !19
  %906 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %call3475 = call %union.tree_node* @grokfield(i8* %903, i32 %904, %union.tree_node* %905, %union.tree_node* %906, %union.tree_node* null) #20
  store %union.tree_node* %call3475, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %ttype3479 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %907 = load %union.tree_node*, %union.tree_node** %ttype3479, align 4, !tbaa !19
  %908 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3480 = call %union.tree_node* @chainon(%union.tree_node* %907, %union.tree_node* %908) #20
  %call3481 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %ttype4642, %union.tree_node* %call3480, i32 0) #20
  br label %sw.epilog

sw.bb3482:                                        ; preds = %if.end150
  %arrayidx3483 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %filename3484 = bitcast %union.anon.2* %arrayidx3483 to i8**
  %909 = load i8*, i8** %filename3484, align 4, !tbaa !19
  %lineno3486 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4, i32 0
  %910 = load i32, i32* %lineno3486, align 4, !tbaa !19
  %arrayidx3487 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3488 = bitcast %union.anon.2* %arrayidx3487 to %union.tree_node**
  %911 = load %union.tree_node*, %union.tree_node** %ttype3488, align 4, !tbaa !19
  %912 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx3489 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3490 = bitcast %union.anon.2* %arrayidx3489 to %union.tree_node**
  %913 = load %union.tree_node*, %union.tree_node** %ttype3490, align 4, !tbaa !19
  %call3491 = call %union.tree_node* @grokfield(i8* %909, i32 %910, %union.tree_node* %911, %union.tree_node* %912, %union.tree_node* %913) #20
  store %union.tree_node* %call3491, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %ttype3495 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %914 = load %union.tree_node*, %union.tree_node** %ttype3495, align 4, !tbaa !19
  %915 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3496 = call %union.tree_node* @chainon(%union.tree_node* %914, %union.tree_node* %915) #20
  %call3497 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %ttype4642, %union.tree_node* %call3496, i32 0) #20
  br label %sw.epilog

sw.bb3498:                                        ; preds = %if.end150
  %arrayidx3499 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %filename3500 = bitcast %union.anon.2* %arrayidx3499 to i8**
  %916 = load i8*, i8** %filename3500, align 4, !tbaa !19
  %lineno3502 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3, i32 0
  %917 = load i32, i32* %lineno3502, align 4, !tbaa !19
  %918 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx3503 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3504 = bitcast %union.anon.2* %arrayidx3503 to %union.tree_node**
  %919 = load %union.tree_node*, %union.tree_node** %ttype3504, align 4, !tbaa !19
  %call3505 = call %union.tree_node* @grokfield(i8* %916, i32 %917, %union.tree_node* null, %union.tree_node* %918, %union.tree_node* %919) #20
  store %union.tree_node* %call3505, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %ttype3509 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %920 = load %union.tree_node*, %union.tree_node** %ttype3509, align 4, !tbaa !19
  %921 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3510 = call %union.tree_node* @chainon(%union.tree_node* %920, %union.tree_node* %921) #20
  %call3511 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %ttype4642, %union.tree_node* %call3510, i32 0) #20
  br label %sw.epilog

sw.bb3512:                                        ; preds = %if.end150
  %arrayidx3513 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %filename3514 = bitcast %union.anon.2* %arrayidx3513 to i8**
  %922 = load i8*, i8** %filename3514, align 4, !tbaa !19
  %lineno3516 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2, i32 0
  %923 = load i32, i32* %lineno3516, align 4, !tbaa !19
  %arrayidx3517 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3518 = bitcast %union.anon.2* %arrayidx3517 to %union.tree_node**
  %924 = load %union.tree_node*, %union.tree_node** %ttype3518, align 4, !tbaa !19
  %925 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %call3519 = call %union.tree_node* @grokfield(i8* %922, i32 %923, %union.tree_node* %924, %union.tree_node* %925, %union.tree_node* null) #20
  store %union.tree_node* %call3519, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %ttype3523 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %926 = load %union.tree_node*, %union.tree_node** %ttype3523, align 4, !tbaa !19
  %927 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3524 = call %union.tree_node* @chainon(%union.tree_node* %926, %union.tree_node* %927) #20
  %call3525 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %ttype4642, %union.tree_node* %call3524, i32 0) #20
  br label %sw.epilog

sw.bb3526:                                        ; preds = %if.end150
  %arrayidx3527 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %filename3528 = bitcast %union.anon.2* %arrayidx3527 to i8**
  %928 = load i8*, i8** %filename3528, align 4, !tbaa !19
  %lineno3530 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4, i32 0
  %929 = load i32, i32* %lineno3530, align 4, !tbaa !19
  %arrayidx3531 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3532 = bitcast %union.anon.2* %arrayidx3531 to %union.tree_node**
  %930 = load %union.tree_node*, %union.tree_node** %ttype3532, align 4, !tbaa !19
  %931 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx3533 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3534 = bitcast %union.anon.2* %arrayidx3533 to %union.tree_node**
  %932 = load %union.tree_node*, %union.tree_node** %ttype3534, align 4, !tbaa !19
  %call3535 = call %union.tree_node* @grokfield(i8* %928, i32 %929, %union.tree_node* %930, %union.tree_node* %931, %union.tree_node* %932) #20
  store %union.tree_node* %call3535, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %ttype3539 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %933 = load %union.tree_node*, %union.tree_node** %ttype3539, align 4, !tbaa !19
  %934 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3540 = call %union.tree_node* @chainon(%union.tree_node* %933, %union.tree_node* %934) #20
  %call3541 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %ttype4642, %union.tree_node* %call3540, i32 0) #20
  br label %sw.epilog

sw.bb3542:                                        ; preds = %if.end150
  %arrayidx3543 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %filename3544 = bitcast %union.anon.2* %arrayidx3543 to i8**
  %935 = load i8*, i8** %filename3544, align 4, !tbaa !19
  %lineno3546 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3, i32 0
  %936 = load i32, i32* %lineno3546, align 4, !tbaa !19
  %937 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx3547 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3548 = bitcast %union.anon.2* %arrayidx3547 to %union.tree_node**
  %938 = load %union.tree_node*, %union.tree_node** %ttype3548, align 4, !tbaa !19
  %call3549 = call %union.tree_node* @grokfield(i8* %935, i32 %936, %union.tree_node* null, %union.tree_node* %937, %union.tree_node* %938) #20
  store %union.tree_node* %call3549, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %ttype3553 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %939 = load %union.tree_node*, %union.tree_node** %ttype3553, align 4, !tbaa !19
  %940 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3554 = call %union.tree_node* @chainon(%union.tree_node* %939, %union.tree_node* %940) #20
  %call3555 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %ttype4642, %union.tree_node* %call3554, i32 0) #20
  br label %sw.epilog

sw.bb3556:                                        ; preds = %if.end150
  %arrayidx3557 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3558 = bitcast %union.anon.2* %arrayidx3557 to %union.tree_node**
  %941 = load %union.tree_node*, %union.tree_node** %ttype3558, align 4, !tbaa !19
  %942 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  %cmp3559 = icmp eq %union.tree_node* %941, %942
  br i1 %cmp3559, label %if.then3561, label %if.else3565

if.then3561:                                      ; preds = %sw.bb3556
  store %union.tree_node* %941, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

if.else3565:                                      ; preds = %sw.bb3556
  %ttype3567 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %943 = load %union.tree_node*, %union.tree_node** %ttype3567, align 4, !tbaa !19
  %call3570 = call %union.tree_node* @chainon(%union.tree_node* %943, %union.tree_node* %941) #20
  store %union.tree_node* %call3570, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3573:                                        ; preds = %if.end150
  %944 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  store %union.tree_node* %944, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3575:                                        ; preds = %if.end150
  %ttype3577 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %945 = load %union.tree_node*, %union.tree_node** %ttype3577, align 4, !tbaa !19
  %call3578 = call %union.tree_node* @build_enumerator(%union.tree_node* %945, %union.tree_node* null) #20
  store %union.tree_node* %call3578, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3580:                                        ; preds = %if.end150
  %arrayidx3581 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3582 = bitcast %union.anon.2* %arrayidx3581 to %union.tree_node**
  %946 = load %union.tree_node*, %union.tree_node** %ttype3582, align 4, !tbaa !19
  %ttype3584 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %947 = load %union.tree_node*, %union.tree_node** %ttype3584, align 4, !tbaa !19
  %call3585 = call %union.tree_node* @build_enumerator(%union.tree_node* %946, %union.tree_node* %947) #20
  store %union.tree_node* %call3585, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3587:                                        ; preds = %if.end150
  call void @pending_xref_error() #20
  %ttype3589 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %948 = load %union.tree_node*, %union.tree_node** %ttype3589, align 4, !tbaa !19
  store %union.tree_node* %948, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3591:                                        ; preds = %if.end150
  %arrayidx3592 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3593 = bitcast %union.anon.2* %arrayidx3592 to %union.tree_node**
  %949 = load %union.tree_node*, %union.tree_node** %ttype3593, align 4, !tbaa !19
  %ttype3595 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %950 = load %union.tree_node*, %union.tree_node** %ttype3595, align 4, !tbaa !19
  %call3596 = call %union.tree_node* @build_tree_list(%union.tree_node* %949, %union.tree_node* %950) #20
  store %union.tree_node* %call3596, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3598:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3600:                                        ; preds = %if.end150
  %951 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %call3601 = call %union.tree_node* @build_tree_list(%union.tree_node* %951, %union.tree_node* null) #20
  %952 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3602 = call %union.tree_node* @build_tree_list(%union.tree_node* %call3601, %union.tree_node* %952) #20
  store %union.tree_node* %call3602, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3604:                                        ; preds = %if.end150
  %953 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %ttype3606 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %954 = load %union.tree_node*, %union.tree_node** %ttype3606, align 4, !tbaa !19
  %call3607 = call %union.tree_node* @build_tree_list(%union.tree_node* %953, %union.tree_node* %954) #20
  %955 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3608 = call %union.tree_node* @build_tree_list(%union.tree_node* %call3607, %union.tree_node* %955) #20
  store %union.tree_node* %call3608, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3610:                                        ; preds = %if.end150
  %956 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx3611 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3612 = bitcast %union.anon.2* %arrayidx3611 to %union.tree_node**
  %957 = load %union.tree_node*, %union.tree_node** %ttype3612, align 4, !tbaa !19
  %call3613 = call %union.tree_node* @build_tree_list(%union.tree_node* %956, %union.tree_node* %957) #20
  %ttype3615 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %958 = load %union.tree_node*, %union.tree_node** %ttype3615, align 4, !tbaa !19
  %959 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call3616 = call %union.tree_node* @chainon(%union.tree_node* %958, %union.tree_node* %959) #20
  %call3617 = call %union.tree_node* @build_tree_list(%union.tree_node* %call3613, %union.tree_node* %call3616) #20
  store %union.tree_node* %call3617, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3619:                                        ; preds = %if.end150
  %arrayidx3620 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3621 = bitcast %union.anon.2* %arrayidx3620 to %union.tree_node**
  %960 = load %union.tree_node*, %union.tree_node** %ttype3621, align 4, !tbaa !19
  %ttype3623 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %961 = load %union.tree_node*, %union.tree_node** %ttype3623, align 4, !tbaa !19
  %call3624 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %960, %union.tree_node* %961) #21
  store %union.tree_node* %call3624, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3626:                                        ; preds = %if.end150
  %ttype3628 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %962 = load %union.tree_node*, %union.tree_node** %ttype3628, align 4, !tbaa !19
  %call3629 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %962, %union.tree_node* null) #21
  store %union.tree_node* %call3629, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3631:                                        ; preds = %if.end150
  %arrayidx3632 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3633 = bitcast %union.anon.2* %arrayidx3632 to %union.tree_node**
  %963 = load %union.tree_node*, %union.tree_node** %ttype3633, align 4, !tbaa !19
  %ttype3635 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %964 = load %union.tree_node*, %union.tree_node** %ttype3635, align 4, !tbaa !19
  %call3636 = call %union.tree_node* @make_pointer_declarator(%union.tree_node* %963, %union.tree_node* %964) #21
  store %union.tree_node* %call3636, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3638:                                        ; preds = %if.end150
  %arrayidx3639 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3640 = bitcast %union.anon.2* %arrayidx3639 to %union.tree_node**
  %965 = load %union.tree_node*, %union.tree_node** %ttype3640, align 4, !tbaa !19
  %tobool3641.not = icmp eq %union.tree_node* %965, null
  %arrayidx3649 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3650 = bitcast %union.anon.2* %arrayidx3649 to %union.tree_node**
  %966 = load %union.tree_node*, %union.tree_node** %ttype3650, align 4, !tbaa !19
  br i1 %tobool3641.not, label %cond.end3651, label %cond.true3642

cond.true3642:                                    ; preds = %sw.bb3638
  %call3647 = call %union.tree_node* @tree_cons(%union.tree_node* nonnull %965, %union.tree_node* %966, %union.tree_node* null) #20
  br label %cond.end3651

cond.end3651:                                     ; preds = %cond.true3642, %sw.bb3638
  %cond3652 = phi %union.tree_node* [ %call3647, %cond.true3642 ], [ %966, %sw.bb3638 ]
  store %union.tree_node* %cond3652, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3654:                                        ; preds = %if.end150
  %arrayidx3655 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3656 = bitcast %union.anon.2* %arrayidx3655 to %union.tree_node**
  %967 = load %union.tree_node*, %union.tree_node** %ttype3656, align 4, !tbaa !19
  %ttype3658 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %968 = load %union.tree_node*, %union.tree_node** %ttype3658, align 4, !tbaa !19
  %call3659 = call %union.tree_node* (i32, ...) @build_nt(i32 53, %union.tree_node* %967, %union.tree_node* %968, %union.tree_node* null) #20
  store %union.tree_node* %call3659, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3661:                                        ; preds = %if.end150
  %ttype3663 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %969 = load %union.tree_node*, %union.tree_node** %ttype3663, align 4, !tbaa !19
  %arrayidx3664 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3665 = bitcast %union.anon.2* %arrayidx3664 to %union.tree_node**
  %970 = load %union.tree_node*, %union.tree_node** %ttype3665, align 4, !tbaa !19
  %call3666 = call %union.tree_node* @set_array_declarator_type(%union.tree_node* %969, %union.tree_node* %970, i32 1) #20
  store %union.tree_node* %call3666, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3668:                                        ; preds = %if.end150
  %ttype3670 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %971 = load %union.tree_node*, %union.tree_node** %ttype3670, align 4, !tbaa !19
  %call3671 = call %union.tree_node* (i32, ...) @build_nt(i32 53, %union.tree_node* null, %union.tree_node* %971, %union.tree_node* null) #20
  store %union.tree_node* %call3671, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3673:                                        ; preds = %if.end150
  %ttype3675 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %972 = load %union.tree_node*, %union.tree_node** %ttype3675, align 4, !tbaa !19
  %call3676 = call %union.tree_node* @set_array_declarator_type(%union.tree_node* %972, %union.tree_node* null, i32 1) #20
  store %union.tree_node* %call3676, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3678:                                        ; preds = %if.end150
  %arrayidx3679 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3680 = bitcast %union.anon.2* %arrayidx3679 to %union.tree_node**
  %973 = load %union.tree_node*, %union.tree_node** %ttype3680, align 4, !tbaa !19
  %call3681 = call %union.tree_node* @build_array_declarator(%union.tree_node* %973, %union.tree_node* null, i32 0, i32 0) #20
  store %union.tree_node* %call3681, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3683:                                        ; preds = %if.end150
  %arrayidx3684 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3685 = bitcast %union.anon.2* %arrayidx3684 to %union.tree_node**
  %974 = load %union.tree_node*, %union.tree_node** %ttype3685, align 4, !tbaa !19
  %arrayidx3686 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3687 = bitcast %union.anon.2* %arrayidx3686 to %union.tree_node**
  %975 = load %union.tree_node*, %union.tree_node** %ttype3687, align 4, !tbaa !19
  %call3688 = call %union.tree_node* @build_array_declarator(%union.tree_node* %974, %union.tree_node* %975, i32 0, i32 0) #20
  store %union.tree_node* %call3688, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3690:                                        ; preds = %if.end150
  %call3691 = call %union.tree_node* @build_array_declarator(%union.tree_node* null, %union.tree_node* null, i32 0, i32 0) #20
  store %union.tree_node* %call3691, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3693:                                        ; preds = %if.end150
  %arrayidx3694 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3695 = bitcast %union.anon.2* %arrayidx3694 to %union.tree_node**
  %976 = load %union.tree_node*, %union.tree_node** %ttype3695, align 4, !tbaa !19
  %call3696 = call %union.tree_node* @build_array_declarator(%union.tree_node* null, %union.tree_node* %976, i32 0, i32 0) #20
  store %union.tree_node* %call3696, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3698:                                        ; preds = %if.end150
  %call3699 = call %union.tree_node* @build_array_declarator(%union.tree_node* null, %union.tree_node* null, i32 0, i32 1) #20
  store %union.tree_node* %call3699, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3701:                                        ; preds = %if.end150
  %arrayidx3702 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3703 = bitcast %union.anon.2* %arrayidx3702 to %union.tree_node**
  %977 = load %union.tree_node*, %union.tree_node** %ttype3703, align 4, !tbaa !19
  %call3704 = call %union.tree_node* @build_array_declarator(%union.tree_node* null, %union.tree_node* %977, i32 0, i32 1) #20
  store %union.tree_node* %call3704, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3706:                                        ; preds = %if.end150
  %arrayidx3707 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %978 = bitcast %union.anon.2* %arrayidx3707 to %struct.c_common_identifier**
  %979 = load %struct.c_common_identifier*, %struct.c_common_identifier** %978, align 4, !tbaa !19
  %rid_code3710 = getelementptr inbounds %struct.c_common_identifier, %struct.c_common_identifier* %979, i32 0, i32 1, i32 3
  %980 = load i8, i8* %rid_code3710, align 1, !tbaa !57
  %cmp3712.not = icmp eq i8 %980, 0
  br i1 %cmp3712.not, label %if.end3715, label %if.then3714

if.then3714:                                      ; preds = %sw.bb3706
  call void (i8*, ...) @error(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.42.2720, i32 0, i32 0)) #20
  br label %if.end3715

if.end3715:                                       ; preds = %if.then3714, %sw.bb3706
  %arrayidx3716 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3717 = bitcast %union.anon.2* %arrayidx3716 to %union.tree_node**
  %981 = load %union.tree_node*, %union.tree_node** %ttype3717, align 4, !tbaa !19
  %call3718 = call %union.tree_node* @build_array_declarator(%union.tree_node* %981, %union.tree_node* null, i32 1, i32 0) #20
  store %union.tree_node* %call3718, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3720:                                        ; preds = %if.end150
  %arrayidx3721 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %982 = bitcast %union.anon.2* %arrayidx3721 to %struct.c_common_identifier**
  %983 = load %struct.c_common_identifier*, %struct.c_common_identifier** %982, align 4, !tbaa !19
  %rid_code3724 = getelementptr inbounds %struct.c_common_identifier, %struct.c_common_identifier* %983, i32 0, i32 1, i32 3
  %984 = load i8, i8* %rid_code3724, align 1, !tbaa !57
  %cmp3726.not = icmp eq i8 %984, 0
  br i1 %cmp3726.not, label %if.end3729, label %if.then3728

if.then3728:                                      ; preds = %sw.bb3720
  call void (i8*, ...) @error(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.42.2720, i32 0, i32 0)) #20
  br label %if.end3729

if.end3729:                                       ; preds = %if.then3728, %sw.bb3720
  %arrayidx3730 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3731 = bitcast %union.anon.2* %arrayidx3730 to %union.tree_node**
  %985 = load %union.tree_node*, %union.tree_node** %ttype3731, align 4, !tbaa !19
  %arrayidx3732 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3733 = bitcast %union.anon.2* %arrayidx3732 to %union.tree_node**
  %986 = load %union.tree_node*, %union.tree_node** %ttype3733, align 4, !tbaa !19
  %call3734 = call %union.tree_node* @build_array_declarator(%union.tree_node* %985, %union.tree_node* %986, i32 1, i32 0) #20
  store %union.tree_node* %call3734, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3736:                                        ; preds = %if.end150
  %arrayidx3737 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %987 = bitcast %union.anon.2* %arrayidx3737 to %struct.c_common_identifier**
  %988 = load %struct.c_common_identifier*, %struct.c_common_identifier** %987, align 4, !tbaa !19
  %rid_code3740 = getelementptr inbounds %struct.c_common_identifier, %struct.c_common_identifier* %988, i32 0, i32 1, i32 3
  %989 = load i8, i8* %rid_code3740, align 1, !tbaa !57
  %cmp3742.not = icmp eq i8 %989, 0
  br i1 %cmp3742.not, label %if.end3745, label %if.then3744

if.then3744:                                      ; preds = %sw.bb3736
  call void (i8*, ...) @error(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.42.2720, i32 0, i32 0)) #20
  br label %if.end3745

if.end3745:                                       ; preds = %if.then3744, %sw.bb3736
  %arrayidx3746 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3747 = bitcast %union.anon.2* %arrayidx3746 to %union.tree_node**
  %990 = load %union.tree_node*, %union.tree_node** %ttype3747, align 4, !tbaa !19
  %arrayidx3748 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3749 = bitcast %union.anon.2* %arrayidx3748 to %union.tree_node**
  %991 = load %union.tree_node*, %union.tree_node** %ttype3749, align 4, !tbaa !19
  %call3750 = call %union.tree_node* @build_array_declarator(%union.tree_node* %990, %union.tree_node* %991, i32 1, i32 0) #20
  store %union.tree_node* %call3750, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3752:                                        ; preds = %if.end150
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.43.2721, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3753:                                        ; preds = %if.end150
  %992 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3754 = icmp eq i32 %992, 0
  %993 = load i32, i32* @flag_isoc99, align 4
  %tobool3756 = icmp ne i32 %993, 0
  %or.cond4883 = select i1 %tobool3754, i1 true, i1 %tobool3756
  br i1 %or.cond4883, label %sw.epilog, label %if.then3757

if.then3757:                                      ; preds = %sw.bb3753
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.44.2722, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3759:                                        ; preds = %if.end150
  call void @pushlevel(i32 0) #20
  call void @clear_last_expr() #20
  %call3760 = call %union.tree_node* @add_scope_stmt(i32 1, i32 0) #20
  br label %sw.epilog

sw.bb3761:                                        ; preds = %if.end150
  %call3762 = call %union.tree_node* @add_scope_stmt(i32 0, i32 0) #20
  store %union.tree_node* %call3762, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3764:                                        ; preds = %if.end150
  %994 = load i32, i32* @flag_isoc99, align 4, !tbaa !16
  %tobool3765.not = icmp eq i32 %994, 0
  br i1 %tobool3765.not, label %if.else3770, label %if.then3766

if.then3766:                                      ; preds = %sw.bb3764
  %call3767 = call %union.tree_node* @c_begin_compound_stmt() #20
  store %union.tree_node* %call3767, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void @pushlevel(i32 0) #20
  call void @clear_last_expr() #20
  %call3769 = call %union.tree_node* @add_scope_stmt(i32 1, i32 0) #20
  br label %sw.epilog

if.else3770:                                      ; preds = %sw.bb3764
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3773:                                        ; preds = %if.end150
  %995 = load i32, i32* @flag_isoc99, align 4, !tbaa !16
  %tobool3774.not = icmp eq i32 %995, 0
  br i1 %tobool3774.not, label %if.else3791, label %if.then3775

if.then3775:                                      ; preds = %sw.bb3773
  %call3776 = call %union.tree_node* @add_scope_stmt(i32 0, i32 0) #20
  %call3777 = call i32 @kept_level_p() #20
  %call3778 = call %union.tree_node* @poplevel(i32 %call3777, i32 0, i32 0) #20
  store %union.tree_node* %call3778, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %value3782 = getelementptr inbounds %union.tree_node, %union.tree_node* %call3776, i32 0, i32 0, i32 2
  %996 = bitcast i32* %value3782 to %struct.tree_exp**
  %997 = load %struct.tree_exp*, %struct.tree_exp** %996, align 4, !tbaa !19
  %arrayidx3785 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %997, i32 0, i32 2, i32 0
  store %union.tree_node* %call3778, %union.tree_node** %arrayidx3785, align 4, !tbaa !19
  %purpose3787 = getelementptr inbounds %union.tree_node, %union.tree_node* %call3776, i32 0, i32 0, i32 1
  %998 = bitcast i8** %purpose3787 to %struct.tree_exp**
  %999 = load %struct.tree_exp*, %struct.tree_exp** %998, align 4, !tbaa !19
  %arrayidx3790 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %999, i32 0, i32 2, i32 0
  store %union.tree_node* %call3778, %union.tree_node** %arrayidx3790, align 4, !tbaa !19
  br label %sw.epilog

if.else3791:                                      ; preds = %sw.bb3773
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3794:                                        ; preds = %if.end150
  %1000 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool3795.not = icmp eq i32 %1000, 0
  br i1 %tobool3795.not, label %sw.epilog, label %if.then3796

if.then3796:                                      ; preds = %sw.bb3794
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.45.2723, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3798:                                        ; preds = %if.end150
  %arrayidx3799 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3800 = bitcast %union.anon.2* %arrayidx3799 to %union.tree_node**
  %link.05818 = load %union.tree_node*, %union.tree_node** %ttype3800, align 4, !tbaa !19
  %tobool3802.not5819 = icmp eq %union.tree_node* %link.05818, null
  br i1 %tobool3802.not5819, label %sw.epilog, label %for.body3803

for.body3803:                                     ; preds = %for.body3803, %sw.bb3798
  %link.05820 = phi %union.tree_node* [ %link.0, %for.body3803 ], [ %link.05818, %sw.bb3798 ]
  %value3805 = getelementptr inbounds %union.tree_node, %union.tree_node* %link.05820, i32 0, i32 0, i32 2
  %1001 = bitcast i32* %value3805 to %union.tree_node**
  %1002 = load %union.tree_node*, %union.tree_node** %1001, align 4, !tbaa !19
  %call3806 = call %union.tree_node* @shadow_label(%union.tree_node* %1002) #20
  %lang_flag_1 = getelementptr inbounds %union.tree_node, %union.tree_node* %call3806, i32 0, i32 0, i32 0, i32 2
  %bf.load3808 = load i32, i32* %lang_flag_1, align 4
  %bf.set3810 = or i32 %bf.load3808, 33554432
  store i32 %bf.set3810, i32* %lang_flag_1, align 4
  call void @add_decl_stmt(%union.tree_node* %call3806) #20
  %chain3813 = getelementptr inbounds %union.tree_node, %union.tree_node* %link.05820, i32 0, i32 0, i32 0, i32 0
  %link.0 = load %union.tree_node*, %union.tree_node** %chain3813, align 4, !tbaa !19
  %tobool3802.not = icmp eq %union.tree_node* %link.0, null
  br i1 %tobool3802.not, label %sw.epilog, label %for.body3803, !llvm.loop !66

sw.bb3817:                                        ; preds = %if.end150
  %1003 = load i32, i32* @compstmt_count, align 4, !tbaa !16
  %inc3818 = add nsw i32 %1003, 1
  store i32 %inc3818, i32* @compstmt_count, align 4, !tbaa !16
  %call3819 = call %union.tree_node* @c_begin_compound_stmt() #20
  store %union.tree_node* %call3819, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3821:                                        ; preds = %if.end150
  %1004 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 27), align 4, !tbaa !15
  %1005 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 11), align 4, !tbaa !15
  %call3822 = call %union.tree_node* @convert(%union.tree_node* %1004, %union.tree_node* %1005) #20
  store %union.tree_node* %call3822, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3824:                                        ; preds = %if.end150
  %call3825 = call i32 @kept_level_p() #20
  %call3826 = call %union.tree_node* @poplevel(i32 %call3825, i32 1, i32 0) #20
  store %union.tree_node* %call3826, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1006 = bitcast %union.anon.2* %yyvsp.3 to %struct.tree_list**
  %1007 = load %struct.tree_list*, %struct.tree_list** %1006, align 4, !tbaa !19
  %value3832 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1007, i32 0, i32 2
  %1008 = bitcast %union.tree_node** %value3832 to %struct.tree_exp**
  %1009 = load %struct.tree_exp*, %struct.tree_exp** %1008, align 4, !tbaa !19
  %arrayidx3835 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %1009, i32 0, i32 2, i32 0
  store %union.tree_node* %call3826, %union.tree_node** %arrayidx3835, align 4, !tbaa !19
  %1010 = load %struct.tree_list*, %struct.tree_list** %1006, align 4, !tbaa !19
  %purpose3839 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1010, i32 0, i32 1
  %1011 = bitcast %union.tree_node** %purpose3839 to %struct.tree_exp**
  %1012 = load %struct.tree_exp*, %struct.tree_exp** %1011, align 4, !tbaa !19
  %arrayidx3842 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %1012, i32 0, i32 2, i32 0
  store %union.tree_node* %call3826, %union.tree_node** %arrayidx3842, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3843:                                        ; preds = %if.end150
  %1013 = load %union.tree_node*, %union.tree_node** @current_function_decl, align 4, !tbaa !15
  %cmp3844 = icmp eq %union.tree_node* %1013, null
  br i1 %cmp3844, label %if.then3846, label %if.end3847

if.then3846:                                      ; preds = %sw.bb3843
  call void (i8*, ...) @error(i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.46.2724, i32 0, i32 0)) #20
  br label %yyerrlab1

if.end3847:                                       ; preds = %sw.bb3843
  call void @keep_next_level() #20
  call void @push_label_level() #20
  %1014 = load i32, i32* @compstmt_count, align 4, !tbaa !16
  %inc3848 = add nsw i32 %1014, 1
  store i32 %inc3848, i32* @compstmt_count, align 4, !tbaa !16
  %call3849 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt3850 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call3849, i32 0, i32 0
  %1015 = load %union.tree_node*, %union.tree_node** %x_last_stmt3850, align 4, !tbaa !62
  %call3851 = call %union.tree_node* (i32, ...) @build_stmt(i32 153, %union.tree_node* %1015) #20
  %call3852 = call %union.tree_node* @add_stmt(%union.tree_node* %call3851) #20
  store %union.tree_node* %call3852, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

do.body3855:                                      ; preds = %if.end150
  %arrayidx3856 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3857 = bitcast %union.anon.2* %arrayidx3856 to %union.tree_node**
  %1016 = load %union.tree_node*, %union.tree_node** %ttype3857, align 4, !tbaa !19
  %chain3859 = getelementptr inbounds %union.tree_node, %union.tree_node* %1016, i32 0, i32 0, i32 0, i32 0
  %1017 = load %union.tree_node*, %union.tree_node** %chain3859, align 4, !tbaa !19
  %operands3863 = getelementptr inbounds %union.tree_node, %union.tree_node* %1016, i32 0, i32 0, i32 2
  %arrayidx3864 = bitcast i32* %operands3863 to %union.tree_node**
  store %union.tree_node* %1017, %union.tree_node** %arrayidx3864, align 4, !tbaa !19
  %1018 = bitcast %union.anon.2* %arrayidx3856 to %struct.tree_common**
  %1019 = load %struct.tree_common*, %struct.tree_common** %1018, align 4, !tbaa !19
  %chain3868 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %1019, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain3868, align 4, !tbaa !19
  %1020 = load %union.tree_node*, %union.tree_node** %ttype3857, align 4, !tbaa !19
  %call3871 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt3872 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call3871, i32 0, i32 0
  store %union.tree_node* %1020, %union.tree_node** %x_last_stmt3872, align 4, !tbaa !62
  %call3875 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_expr_type3876 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call3875, i32 0, i32 1
  store %union.tree_node* null, %union.tree_node** %x_last_expr_type3876, align 4, !tbaa !64
  %1021 = load %union.tree_node*, %union.tree_node** %ttype3857, align 4, !tbaa !19
  store %union.tree_node* %1021, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3880:                                        ; preds = %if.end150
  call void @c_finish_then() #20
  br label %sw.epilog

sw.bb3881:                                        ; preds = %if.end150
  %call3882 = call %union.tree_node* @c_begin_if_stmt() #20
  store %union.tree_node* %call3882, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3884:                                        ; preds = %if.end150
  %arrayidx3885 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype3886 = bitcast %union.anon.2* %arrayidx3885 to %union.tree_node**
  %1022 = load %union.tree_node*, %union.tree_node** %ttype3886, align 4, !tbaa !19
  %call3887 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %1022) #20
  %1023 = load i32, i32* @compstmt_count, align 4, !tbaa !16
  %arrayidx3888 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype3889 = bitcast %union.anon.2* %arrayidx3888 to %union.tree_node**
  %1024 = load %union.tree_node*, %union.tree_node** %ttype3889, align 4, !tbaa !19
  call void @c_expand_start_cond(%union.tree_node* %call3887, i32 %1023, %union.tree_node* %1024) #20
  %1025 = load i32, i32* @stmt_count, align 4, !tbaa !16
  store i32 %1025, i32* %6, align 4, !tbaa !19
  %arrayidx3890 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -7
  %filename3891 = bitcast %union.anon.2* %arrayidx3890 to i8**
  %1026 = load i8*, i8** %filename3891, align 4, !tbaa !19
  store i8* %1026, i8** @if_stmt_file, align 4, !tbaa !15
  %lineno3893 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6, i32 0
  %1027 = load i32, i32* %lineno3893, align 4, !tbaa !19
  store i32 %1027, i32* @if_stmt_line, align 4, !tbaa !16
  br label %sw.epilog

sw.bb3894:                                        ; preds = %if.end150
  %1028 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc3895 = add nsw i32 %1028, 1
  store i32 %inc3895, i32* @stmt_count, align 4, !tbaa !16
  %1029 = load i32, i32* @compstmt_count, align 4, !tbaa !16
  %inc3896 = add nsw i32 %1029, 1
  store i32 %inc3896, i32* @compstmt_count, align 4, !tbaa !16
  %call3897 = call %union.tree_node* (i32, ...) @build_stmt(i32 158, %union.tree_node* null, %union.tree_node* null) #20
  %call3898 = call %union.tree_node* @add_stmt(%union.tree_node* %call3897) #20
  store %union.tree_node* %call3898, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1030 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 0), align 4, !tbaa !15
  %operands3902 = getelementptr inbounds %union.tree_node, %union.tree_node* %call3898, i32 0, i32 0, i32 2
  %arrayidx3903 = bitcast i32* %operands3902 to %union.tree_node**
  store %union.tree_node* %1030, %union.tree_node** %arrayidx3903, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3904:                                        ; preds = %if.end150
  %arrayidx3905 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3906 = bitcast %union.anon.2* %arrayidx3905 to %union.tree_node**
  %1031 = load %union.tree_node*, %union.tree_node** %ttype3906, align 4, !tbaa !19
  store %union.tree_node* %1031, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %chain3911 = getelementptr inbounds %union.tree_node, %union.tree_node* %1031, i32 0, i32 0, i32 0, i32 0
  %1032 = load %union.tree_node*, %union.tree_node** %chain3911, align 4, !tbaa !19
  %operands3914 = getelementptr inbounds %union.tree_node, %union.tree_node* %1031, i32 0, i32 0, i32 2
  %arrayidx3915 = getelementptr inbounds i32, i32* %operands3914, i32 1
  %1033 = bitcast i32* %arrayidx3915 to %union.tree_node**
  store %union.tree_node* %1032, %union.tree_node** %1033, align 4, !tbaa !19
  %chain3918 = getelementptr inbounds %union.tree_node, %union.tree_node* %1031, i32 0, i32 0, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain3918, align 4, !tbaa !19
  %1034 = load %union.tree_node*, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %call3920 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt3921 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call3920, i32 0, i32 0
  store %union.tree_node* %1034, %union.tree_node** %x_last_stmt3921, align 4, !tbaa !62
  br label %sw.epilog

sw.bb3924:                                        ; preds = %if.end150
  %1035 = load i32, i32* @yychar, align 4, !tbaa !16
  %cmp3925 = icmp eq i32 %1035, -2
  br i1 %cmp3925, label %if.then3927, label %if.end3929

if.then3927:                                      ; preds = %sw.bb3924
  %call3928 = call fastcc i32 @yylex() #21
  store i32 %call3928, i32* @yychar, align 4, !tbaa !16
  br label %if.end3929

if.end3929:                                       ; preds = %if.then3927, %sw.bb3924
  %1036 = load i8*, i8** @input_filename, align 4, !tbaa !15
  store i8* %1036, i8** %filename3930, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3931:                                        ; preds = %if.end150
  %1037 = load i32, i32* @yychar, align 4, !tbaa !16
  %cmp3932 = icmp eq i32 %1037, -2
  br i1 %cmp3932, label %if.then3934, label %if.end3936

if.then3934:                                      ; preds = %sw.bb3931
  %call3935 = call fastcc i32 @yylex() #21
  store i32 %call3935, i32* @yychar, align 4, !tbaa !16
  br label %if.end3936

if.end3936:                                       ; preds = %if.then3934, %sw.bb3931
  %1038 = load i32, i32* @lineno, align 4, !tbaa !16
  store i32 %1038, i32* %6, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3938:                                        ; preds = %if.end150
  %1039 = load i32, i32* @flag_isoc99, align 4, !tbaa !16
  %tobool3939.not = icmp eq i32 %1039, 0
  br i1 %tobool3939.not, label %sw.epilog, label %do.body3941

do.body3941:                                      ; preds = %sw.bb3938
  %arrayidx3942 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype3943 = bitcast %union.anon.2* %arrayidx3942 to %union.tree_node**
  %1040 = load %union.tree_node*, %union.tree_node** %ttype3943, align 4, !tbaa !19
  %chain3945 = getelementptr inbounds %union.tree_node, %union.tree_node* %1040, i32 0, i32 0, i32 0, i32 0
  %1041 = load %union.tree_node*, %union.tree_node** %chain3945, align 4, !tbaa !19
  %operands3949 = getelementptr inbounds %union.tree_node, %union.tree_node* %1040, i32 0, i32 0, i32 2
  %arrayidx3950 = bitcast i32* %operands3949 to %union.tree_node**
  store %union.tree_node* %1041, %union.tree_node** %arrayidx3950, align 4, !tbaa !19
  %1042 = bitcast %union.anon.2* %arrayidx3942 to %struct.tree_common**
  %1043 = load %struct.tree_common*, %struct.tree_common** %1042, align 4, !tbaa !19
  %chain3954 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %1043, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain3954, align 4, !tbaa !19
  %1044 = load %union.tree_node*, %union.tree_node** %ttype3943, align 4, !tbaa !19
  %call3957 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt3958 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call3957, i32 0, i32 0
  store %union.tree_node* %1044, %union.tree_node** %x_last_stmt3958, align 4, !tbaa !62
  br label %sw.epilog

sw.bb3962:                                        ; preds = %if.end150
  %ttype3964 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1045 = load %union.tree_node*, %union.tree_node** %ttype3964, align 4, !tbaa !19
  %tobool3965.not = icmp eq %union.tree_node* %1045, null
  br i1 %tobool3965.not, label %sw.epilog, label %if.then3966

if.then3966:                                      ; preds = %sw.bb3962
  %lineno3968 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %1046 = load i32, i32* %lineno3968, align 4, !tbaa !19
  %complexity3972 = getelementptr inbounds %union.tree_node, %union.tree_node* %1045, i32 0, i32 0, i32 1
  %1047 = bitcast i8** %complexity3972 to i32*
  store i32 %1046, i32* %1047, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3974:                                        ; preds = %if.end150
  %ttype3976 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1048 = load %union.tree_node*, %union.tree_node** %ttype3976, align 4, !tbaa !19
  %tobool3977.not = icmp eq %union.tree_node* %1048, null
  br i1 %tobool3977.not, label %sw.epilog, label %if.then3978

if.then3978:                                      ; preds = %sw.bb3974
  %lineno3980 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  %1049 = load i32, i32* %lineno3980, align 4, !tbaa !19
  %complexity3984 = getelementptr inbounds %union.tree_node, %union.tree_node* %1048, i32 0, i32 0, i32 1
  %1050 = bitcast i8** %complexity3984 to i32*
  store i32 %1049, i32* %1050, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3986:                                        ; preds = %if.end150
  call void @c_expand_start_else() #20
  %1051 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %itype3988 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1, i32 0
  store i32 %1051, i32* %itype3988, align 4, !tbaa !19
  br label %sw.epilog

sw.bb3989:                                        ; preds = %if.end150
  call void @c_finish_else() #20
  call void @c_expand_end_cond() #20
  %1052 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool3990.not = icmp eq i32 %1052, 0
  br i1 %tobool3990.not, label %sw.epilog, label %land.lhs.true3991

land.lhs.true3991:                                ; preds = %sw.bb3989
  %1053 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %itype3993 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3, i32 0
  %1054 = load i32, i32* %itype3993, align 4, !tbaa !19
  %cmp3994 = icmp eq i32 %1053, %1054
  br i1 %cmp3994, label %if.then3996, label %sw.epilog

if.then3996:                                      ; preds = %land.lhs.true3991
  call void (i8*, ...) @warning(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.47.2725, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb3998:                                        ; preds = %if.end150
  call void @c_expand_end_cond() #20
  %1055 = load i32, i32* @extra_warnings, align 4, !tbaa !16
  %tobool3999.not = icmp eq i32 %1055, 0
  br i1 %tobool3999.not, label %sw.epilog, label %land.lhs.true4000

land.lhs.true4000:                                ; preds = %sw.bb3998
  %1056 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4001 = add nsw i32 %1056, 1
  store i32 %inc4001, i32* @stmt_count, align 4, !tbaa !16
  %itype4003 = getelementptr %union.anon.2, %union.anon.2* %yyvsp.3, i32 0, i32 0
  %1057 = load i32, i32* %itype4003, align 4, !tbaa !19
  %cmp4004 = icmp eq i32 %1056, %1057
  br i1 %cmp4004, label %if.then4006, label %sw.epilog

if.then4006:                                      ; preds = %land.lhs.true4000
  %1058 = load i8*, i8** @if_stmt_file, align 4, !tbaa !15
  %1059 = load i32, i32* @if_stmt_line, align 4, !tbaa !16
  call void (i8*, i32, i8*, ...) @warning_with_file_and_line(i8* %1058, i32 %1059, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.48.2726, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb4008:                                        ; preds = %if.end150
  call void @c_expand_end_cond() #20
  br label %sw.epilog

sw.bb4009:                                        ; preds = %if.end150
  %1060 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4010 = add nsw i32 %1060, 1
  store i32 %inc4010, i32* @stmt_count, align 4, !tbaa !16
  %call4011 = call %union.tree_node* @c_begin_while_stmt() #20
  store %union.tree_node* %call4011, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4013:                                        ; preds = %if.end150
  %arrayidx4014 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4015 = bitcast %union.anon.2* %arrayidx4014 to %union.tree_node**
  %1061 = load %union.tree_node*, %union.tree_node** %ttype4015, align 4, !tbaa !19
  %call4016 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %1061) #20
  store %union.tree_node* %call4016, %union.tree_node** %ttype4015, align 4, !tbaa !19
  %call4021 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %call4016) #20
  %arrayidx4022 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype4023 = bitcast %union.anon.2* %arrayidx4022 to %union.tree_node**
  %1062 = load %union.tree_node*, %union.tree_node** %ttype4023, align 4, !tbaa !19
  call void @c_finish_while_stmt_cond(%union.tree_node* %call4021, %union.tree_node* %1062) #20
  %1063 = load %union.tree_node*, %union.tree_node** %ttype4023, align 4, !tbaa !19
  %call4026 = call %union.tree_node* @add_stmt(%union.tree_node* %1063) #20
  store %union.tree_node* %call4026, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

do.body4029:                                      ; preds = %if.end150
  %arrayidx4030 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4031 = bitcast %union.anon.2* %arrayidx4030 to %union.tree_node**
  %1064 = load %union.tree_node*, %union.tree_node** %ttype4031, align 4, !tbaa !19
  %chain4033 = getelementptr inbounds %union.tree_node, %union.tree_node* %1064, i32 0, i32 0, i32 0, i32 0
  %1065 = load %union.tree_node*, %union.tree_node** %chain4033, align 4, !tbaa !19
  %operands4037 = getelementptr inbounds %union.tree_node, %union.tree_node* %1064, i32 0, i32 0, i32 2
  %arrayidx4038 = getelementptr inbounds i32, i32* %operands4037, i32 1
  %1066 = bitcast i32* %arrayidx4038 to %union.tree_node**
  store %union.tree_node* %1065, %union.tree_node** %1066, align 4, !tbaa !19
  %1067 = bitcast %union.anon.2* %arrayidx4030 to %struct.tree_common**
  %1068 = load %struct.tree_common*, %struct.tree_common** %1067, align 4, !tbaa !19
  %chain4042 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %1068, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain4042, align 4, !tbaa !19
  %1069 = load %union.tree_node*, %union.tree_node** %ttype4031, align 4, !tbaa !19
  %call4045 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt4046 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call4045, i32 0, i32 0
  store %union.tree_node* %1069, %union.tree_node** %x_last_stmt4046, align 4, !tbaa !62
  br label %sw.epilog

sw.bb4049:                                        ; preds = %if.end150
  %arrayidx4050 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4051 = bitcast %union.anon.2* %arrayidx4050 to %union.tree_node**
  %1070 = load %union.tree_node*, %union.tree_node** %ttype4051, align 4, !tbaa !19
  %call4052 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* %1070) #20
  %arrayidx4053 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %1071 = bitcast %union.anon.2* %arrayidx4053 to %struct.tree_exp**
  %1072 = load %struct.tree_exp*, %struct.tree_exp** %1071, align 4, !tbaa !19
  %arrayidx4057 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %1072, i32 0, i32 2, i32 0
  store %union.tree_node* %call4052, %union.tree_node** %arrayidx4057, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4059:                                        ; preds = %if.end150
  %call4060 = call %union.tree_node* (i32, ...) @build_stmt(i32 156, %union.tree_node* null, %union.tree_node* null, %union.tree_node* null, %union.tree_node* null) #20
  store %union.tree_node* %call4060, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %call4063 = call %union.tree_node* @add_stmt(%union.tree_node* %call4060) #20
  br label %sw.epilog

sw.bb4064:                                        ; preds = %if.end150
  %1073 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4065 = add nsw i32 %1073, 1
  store i32 %inc4065, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4067 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4068 = bitcast %union.anon.2* %arrayidx4067 to %union.tree_node**
  %1074 = load %union.tree_node*, %union.tree_node** %ttype4068, align 4, !tbaa !19
  %chain4070 = getelementptr inbounds %union.tree_node, %union.tree_node* %1074, i32 0, i32 0, i32 0, i32 0
  %1075 = load %union.tree_node*, %union.tree_node** %chain4070, align 4, !tbaa !19
  %operands4074 = getelementptr inbounds %union.tree_node, %union.tree_node* %1074, i32 0, i32 0, i32 2
  %arrayidx4075 = bitcast i32* %operands4074 to %union.tree_node**
  store %union.tree_node* %1075, %union.tree_node** %arrayidx4075, align 4, !tbaa !19
  %1076 = bitcast %union.anon.2* %arrayidx4067 to %struct.tree_common**
  %1077 = load %struct.tree_common*, %struct.tree_common** %1076, align 4, !tbaa !19
  %chain4079 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %1077, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain4079, align 4, !tbaa !19
  %1078 = load %union.tree_node*, %union.tree_node** %ttype4068, align 4, !tbaa !19
  %call4082 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt4083 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call4082, i32 0, i32 0
  store %union.tree_node* %1078, %union.tree_node** %x_last_stmt4083, align 4, !tbaa !62
  br label %sw.epilog

sw.bb4086:                                        ; preds = %if.end150
  %arrayidx4087 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4088 = bitcast %union.anon.2* %arrayidx4087 to %union.tree_node**
  %1079 = load %union.tree_node*, %union.tree_node** %ttype4088, align 4, !tbaa !19
  %tobool4089.not = icmp eq %union.tree_node* %1079, null
  br i1 %tobool4089.not, label %sw.epilog, label %if.then4090

if.then4090:                                      ; preds = %sw.bb4086
  %call4093 = call %union.tree_node* @truthvalue_conversion(%union.tree_node* nonnull %1079) #20
  %arrayidx4094 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %1080 = bitcast %union.anon.2* %arrayidx4094 to %struct.tree_exp**
  %1081 = load %struct.tree_exp*, %struct.tree_exp** %1080, align 4, !tbaa !19
  %arrayidx4098 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %1081, i32 0, i32 2, i32 1
  store %union.tree_node* %call4093, %union.tree_node** %arrayidx4098, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4100:                                        ; preds = %if.end150
  %arrayidx4101 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4102 = bitcast %union.anon.2* %arrayidx4101 to %union.tree_node**
  %1082 = load %union.tree_node*, %union.tree_node** %ttype4102, align 4, !tbaa !19
  %arrayidx4103 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -8
  %1083 = bitcast %union.anon.2* %arrayidx4103 to %struct.tree_exp**
  %1084 = load %struct.tree_exp*, %struct.tree_exp** %1083, align 4, !tbaa !19
  %arrayidx4107 = getelementptr inbounds %struct.tree_exp, %struct.tree_exp* %1084, i32 0, i32 2, i32 2
  store %union.tree_node* %1082, %union.tree_node** %arrayidx4107, align 4, !tbaa !19
  br label %sw.epilog

do.body4109:                                      ; preds = %if.end150
  %arrayidx4110 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -10
  %ttype4111 = bitcast %union.anon.2* %arrayidx4110 to %union.tree_node**
  %1085 = load %union.tree_node*, %union.tree_node** %ttype4111, align 4, !tbaa !19
  %chain4113 = getelementptr inbounds %union.tree_node, %union.tree_node* %1085, i32 0, i32 0, i32 0, i32 0
  %1086 = load %union.tree_node*, %union.tree_node** %chain4113, align 4, !tbaa !19
  %operands4117 = getelementptr inbounds %union.tree_node, %union.tree_node* %1085, i32 0, i32 0, i32 2
  %arrayidx4118 = getelementptr inbounds i32, i32* %operands4117, i32 3
  %1087 = bitcast i32* %arrayidx4118 to %union.tree_node**
  store %union.tree_node* %1086, %union.tree_node** %1087, align 4, !tbaa !19
  %1088 = bitcast %union.anon.2* %arrayidx4110 to %struct.tree_common**
  %1089 = load %struct.tree_common*, %struct.tree_common** %1088, align 4, !tbaa !19
  %chain4122 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %1089, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain4122, align 4, !tbaa !19
  %1090 = load %union.tree_node*, %union.tree_node** %ttype4111, align 4, !tbaa !19
  %call4125 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt4126 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call4125, i32 0, i32 0
  store %union.tree_node* %1090, %union.tree_node** %x_last_stmt4126, align 4, !tbaa !62
  br label %sw.epilog

sw.bb4129:                                        ; preds = %if.end150
  %1091 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4130 = add nsw i32 %1091, 1
  store i32 %inc4130, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4131 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4132 = bitcast %union.anon.2* %arrayidx4131 to %union.tree_node**
  %1092 = load %union.tree_node*, %union.tree_node** %ttype4132, align 4, !tbaa !19
  %call4133 = call %union.tree_node* @c_start_case(%union.tree_node* %1092) #20
  store %union.tree_node* %call4133, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4135:                                        ; preds = %if.end150
  call void @c_finish_case() #20
  br label %sw.epilog

sw.bb4136:                                        ; preds = %if.end150
  %arrayidx4137 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4138 = bitcast %union.anon.2* %arrayidx4137 to %union.tree_node**
  %1093 = load %union.tree_node*, %union.tree_node** %ttype4138, align 4, !tbaa !19
  %call4139 = call %union.tree_node* (i32, ...) @build_stmt(i32 152, %union.tree_node* %1093) #20
  %call4140 = call %union.tree_node* @add_stmt(%union.tree_node* %call4139) #20
  br label %sw.epilog

sw.bb4141:                                        ; preds = %if.end150
  call void @check_for_loop_decls() #20
  br label %sw.epilog

sw.bb4142:                                        ; preds = %if.end150
  %1094 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4143 = add nsw i32 %1094, 1
  store i32 %inc4143, i32* @stmt_count, align 4, !tbaa !16
  %ttype4145 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1095 = load %union.tree_node*, %union.tree_node** %ttype4145, align 4, !tbaa !19
  store %union.tree_node* %1095, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4147:                                        ; preds = %if.end150
  %1096 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4148 = add nsw i32 %1096, 1
  store i32 %inc4148, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4149 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4150 = bitcast %union.anon.2* %arrayidx4149 to %union.tree_node**
  %1097 = load %union.tree_node*, %union.tree_node** %ttype4150, align 4, !tbaa !19
  %call4151 = call %union.tree_node* @c_expand_expr_stmt(%union.tree_node* %1097) #20
  store %union.tree_node* %call4151, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4153:                                        ; preds = %if.end150
  %1098 = load i32, i32* @flag_isoc99, align 4, !tbaa !16
  %tobool4154.not = icmp eq i32 %1098, 0
  br i1 %tobool4154.not, label %if.end4176, label %do.body4156

do.body4156:                                      ; preds = %sw.bb4153
  %arrayidx4157 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4158 = bitcast %union.anon.2* %arrayidx4157 to %union.tree_node**
  %1099 = load %union.tree_node*, %union.tree_node** %ttype4158, align 4, !tbaa !19
  %chain4160 = getelementptr inbounds %union.tree_node, %union.tree_node* %1099, i32 0, i32 0, i32 0, i32 0
  %1100 = load %union.tree_node*, %union.tree_node** %chain4160, align 4, !tbaa !19
  %operands4164 = getelementptr inbounds %union.tree_node, %union.tree_node* %1099, i32 0, i32 0, i32 2
  %arrayidx4165 = bitcast i32* %operands4164 to %union.tree_node**
  store %union.tree_node* %1100, %union.tree_node** %arrayidx4165, align 4, !tbaa !19
  %1101 = bitcast %union.anon.2* %arrayidx4157 to %struct.tree_common**
  %1102 = load %struct.tree_common*, %struct.tree_common** %1101, align 4, !tbaa !19
  %chain4169 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %1102, i32 0, i32 0
  store %union.tree_node* null, %union.tree_node** %chain4169, align 4, !tbaa !19
  %1103 = load %union.tree_node*, %union.tree_node** %ttype4158, align 4, !tbaa !19
  %call4172 = call %struct.stmt_tree_s* @current_stmt_tree() #20
  %x_last_stmt4173 = getelementptr inbounds %struct.stmt_tree_s, %struct.stmt_tree_s* %call4172, i32 0, i32 0
  store %union.tree_node* %1103, %union.tree_node** %x_last_stmt4173, align 4, !tbaa !62
  br label %if.end4176

if.end4176:                                       ; preds = %do.body4156, %sw.bb4153
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4178:                                        ; preds = %if.end150
  %1104 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4179 = add nsw i32 %1104, 1
  store i32 %inc4179, i32* @stmt_count, align 4, !tbaa !16
  %call4180 = call %union.tree_node* @build_break_stmt() #20
  %call4181 = call %union.tree_node* @add_stmt(%union.tree_node* %call4180) #20
  store %union.tree_node* %call4181, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4183:                                        ; preds = %if.end150
  %1105 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4184 = add nsw i32 %1105, 1
  store i32 %inc4184, i32* @stmt_count, align 4, !tbaa !16
  %call4185 = call %union.tree_node* @build_continue_stmt() #20
  %call4186 = call %union.tree_node* @add_stmt(%union.tree_node* %call4185) #20
  store %union.tree_node* %call4186, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4188:                                        ; preds = %if.end150
  %1106 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4189 = add nsw i32 %1106, 1
  store i32 %inc4189, i32* @stmt_count, align 4, !tbaa !16
  %call4190 = call %union.tree_node* @c_expand_return(%union.tree_node* null) #20
  store %union.tree_node* %call4190, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4192:                                        ; preds = %if.end150
  %1107 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4193 = add nsw i32 %1107, 1
  store i32 %inc4193, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4194 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4195 = bitcast %union.anon.2* %arrayidx4194 to %union.tree_node**
  %1108 = load %union.tree_node*, %union.tree_node** %ttype4195, align 4, !tbaa !19
  %call4196 = call %union.tree_node* @c_expand_return(%union.tree_node* %1108) #20
  store %union.tree_node* %call4196, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4198:                                        ; preds = %if.end150
  %1109 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4199 = add nsw i32 %1109, 1
  store i32 %inc4199, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4200 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4201 = bitcast %union.anon.2* %arrayidx4200 to %union.tree_node**
  %1110 = load %union.tree_node*, %union.tree_node** %ttype4201, align 4, !tbaa !19
  %call4202 = call %union.tree_node* @simple_asm_stmt(%union.tree_node* %1110) #20
  store %union.tree_node* %call4202, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4204:                                        ; preds = %if.end150
  %1111 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4205 = add nsw i32 %1111, 1
  store i32 %inc4205, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4206 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype4207 = bitcast %union.anon.2* %arrayidx4206 to %union.tree_node**
  %1112 = load %union.tree_node*, %union.tree_node** %ttype4207, align 4, !tbaa !19
  %arrayidx4208 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype4209 = bitcast %union.anon.2* %arrayidx4208 to %union.tree_node**
  %1113 = load %union.tree_node*, %union.tree_node** %ttype4209, align 4, !tbaa !19
  %arrayidx4210 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4211 = bitcast %union.anon.2* %arrayidx4210 to %union.tree_node**
  %1114 = load %union.tree_node*, %union.tree_node** %ttype4211, align 4, !tbaa !19
  %call4212 = call %union.tree_node* @build_asm_stmt(%union.tree_node* %1112, %union.tree_node* %1113, %union.tree_node* %1114, %union.tree_node* null, %union.tree_node* null) #20
  store %union.tree_node* %call4212, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4214:                                        ; preds = %if.end150
  %1115 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4215 = add nsw i32 %1115, 1
  store i32 %inc4215, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4216 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -8
  %ttype4217 = bitcast %union.anon.2* %arrayidx4216 to %union.tree_node**
  %1116 = load %union.tree_node*, %union.tree_node** %ttype4217, align 4, !tbaa !19
  %arrayidx4218 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype4219 = bitcast %union.anon.2* %arrayidx4218 to %union.tree_node**
  %1117 = load %union.tree_node*, %union.tree_node** %ttype4219, align 4, !tbaa !19
  %arrayidx4220 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype4221 = bitcast %union.anon.2* %arrayidx4220 to %union.tree_node**
  %1118 = load %union.tree_node*, %union.tree_node** %ttype4221, align 4, !tbaa !19
  %arrayidx4222 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4223 = bitcast %union.anon.2* %arrayidx4222 to %union.tree_node**
  %1119 = load %union.tree_node*, %union.tree_node** %ttype4223, align 4, !tbaa !19
  %call4224 = call %union.tree_node* @build_asm_stmt(%union.tree_node* %1116, %union.tree_node* %1117, %union.tree_node* %1118, %union.tree_node* %1119, %union.tree_node* null) #20
  store %union.tree_node* %call4224, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4226:                                        ; preds = %if.end150
  %1120 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4227 = add nsw i32 %1120, 1
  store i32 %inc4227, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4228 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -10
  %ttype4229 = bitcast %union.anon.2* %arrayidx4228 to %union.tree_node**
  %1121 = load %union.tree_node*, %union.tree_node** %ttype4229, align 4, !tbaa !19
  %arrayidx4230 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -8
  %ttype4231 = bitcast %union.anon.2* %arrayidx4230 to %union.tree_node**
  %1122 = load %union.tree_node*, %union.tree_node** %ttype4231, align 4, !tbaa !19
  %arrayidx4232 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -6
  %ttype4233 = bitcast %union.anon.2* %arrayidx4232 to %union.tree_node**
  %1123 = load %union.tree_node*, %union.tree_node** %ttype4233, align 4, !tbaa !19
  %arrayidx4234 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype4235 = bitcast %union.anon.2* %arrayidx4234 to %union.tree_node**
  %1124 = load %union.tree_node*, %union.tree_node** %ttype4235, align 4, !tbaa !19
  %arrayidx4236 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4237 = bitcast %union.anon.2* %arrayidx4236 to %union.tree_node**
  %1125 = load %union.tree_node*, %union.tree_node** %ttype4237, align 4, !tbaa !19
  %call4238 = call %union.tree_node* @build_asm_stmt(%union.tree_node* %1121, %union.tree_node* %1122, %union.tree_node* %1123, %union.tree_node* %1124, %union.tree_node* %1125) #20
  store %union.tree_node* %call4238, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4240:                                        ; preds = %if.end150
  %1126 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4242 = add nsw i32 %1126, 1
  store i32 %inc4242, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4243 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4244 = bitcast %union.anon.2* %arrayidx4243 to %union.tree_node**
  %1127 = load %union.tree_node*, %union.tree_node** %ttype4244, align 4, !tbaa !19
  %call4245 = call %union.tree_node* @lookup_label(%union.tree_node* %1127) #20
  %cmp4246.not = icmp eq %union.tree_node* %call4245, null
  br i1 %cmp4246.not, label %if.else4256, label %if.then4248

if.then4248:                                      ; preds = %sw.bb4240
  %used_flag = getelementptr inbounds %union.tree_node, %union.tree_node* %call4245, i32 0, i32 0, i32 0, i32 2
  %bf.load4250 = load i32, i32* %used_flag, align 4
  %bf.set4252 = or i32 %bf.load4250, 65536
  store i32 %bf.set4252, i32* %used_flag, align 4
  %call4253 = call %union.tree_node* (i32, ...) @build_stmt(i32 163, %union.tree_node* nonnull %call4245) #20
  %call4254 = call %union.tree_node* @add_stmt(%union.tree_node* %call4253) #20
  store %union.tree_node* %call4254, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

if.else4256:                                      ; preds = %sw.bb4240
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4260:                                        ; preds = %if.end150
  %1128 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool4261.not = icmp eq i32 %1128, 0
  br i1 %tobool4261.not, label %if.end4263, label %if.then4262

if.then4262:                                      ; preds = %sw.bb4260
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.49.2727, i32 0, i32 0)) #20
  br label %if.end4263

if.end4263:                                       ; preds = %if.then4262, %sw.bb4260
  %1129 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4264 = add nsw i32 %1129, 1
  store i32 %inc4264, i32* @stmt_count, align 4, !tbaa !16
  %1130 = load %union.tree_node*, %union.tree_node** getelementptr inbounds ([51 x %union.tree_node*], [51 x %union.tree_node*]* @global_trees, i32 0, i32 28), align 4, !tbaa !15
  %arrayidx4265 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4266 = bitcast %union.anon.2* %arrayidx4265 to %union.tree_node**
  %1131 = load %union.tree_node*, %union.tree_node** %ttype4266, align 4, !tbaa !19
  %call4267 = call %union.tree_node* @convert(%union.tree_node* %1130, %union.tree_node* %1131) #20
  store %union.tree_node* %call4267, %union.tree_node** %ttype4266, align 4, !tbaa !19
  %call4272 = call %union.tree_node* (i32, ...) @build_stmt(i32 163, %union.tree_node* %call4267) #20
  %call4273 = call %union.tree_node* @add_stmt(%union.tree_node* %call4272) #20
  store %union.tree_node* %call4273, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4275:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4277:                                        ; preds = %if.end150
  %1132 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4278 = add nsw i32 %1132, 1
  store i32 %inc4278, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4279 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4280 = bitcast %union.anon.2* %arrayidx4279 to %union.tree_node**
  %1133 = load %union.tree_node*, %union.tree_node** %ttype4280, align 4, !tbaa !19
  %call4281 = call %union.tree_node* @do_case(%union.tree_node* %1133, %union.tree_node* null) #20
  store %union.tree_node* %call4281, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4283:                                        ; preds = %if.end150
  %1134 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4284 = add nsw i32 %1134, 1
  store i32 %inc4284, i32* @stmt_count, align 4, !tbaa !16
  %arrayidx4285 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype4286 = bitcast %union.anon.2* %arrayidx4285 to %union.tree_node**
  %1135 = load %union.tree_node*, %union.tree_node** %ttype4286, align 4, !tbaa !19
  %arrayidx4287 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4288 = bitcast %union.anon.2* %arrayidx4287 to %union.tree_node**
  %1136 = load %union.tree_node*, %union.tree_node** %ttype4288, align 4, !tbaa !19
  %call4289 = call %union.tree_node* @do_case(%union.tree_node* %1135, %union.tree_node* %1136) #20
  store %union.tree_node* %call4289, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4291:                                        ; preds = %if.end150
  %1137 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4292 = add nsw i32 %1137, 1
  store i32 %inc4292, i32* @stmt_count, align 4, !tbaa !16
  %call4293 = call %union.tree_node* @do_case(%union.tree_node* null, %union.tree_node* null) #20
  store %union.tree_node* %call4293, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4295:                                        ; preds = %if.end150
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %7) #22
  %arrayidx4297 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %filename4298 = bitcast %union.anon.2* %arrayidx4297 to i8**
  %1138 = load i8*, i8** %filename4298, align 4, !tbaa !19
  %lineno4300 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2, i32 0
  %1139 = load i32, i32* %lineno4300, align 4, !tbaa !19
  %arrayidx4301 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -4
  %ttype4302 = bitcast %union.anon.2* %arrayidx4301 to %union.tree_node**
  %1140 = load %union.tree_node*, %union.tree_node** %ttype4302, align 4, !tbaa !19
  %call4303 = call %union.tree_node* @define_label(i8* %1138, i32 %1139, %union.tree_node* %1140) #20
  store %union.tree_node* %call4303, %union.tree_node** %label4296, align 4, !tbaa !15
  %1141 = load i32, i32* @stmt_count, align 4, !tbaa !16
  %inc4304 = add nsw i32 %1141, 1
  store i32 %inc4304, i32* @stmt_count, align 4, !tbaa !16
  %tobool4305.not = icmp eq %union.tree_node* %call4303, null
  br i1 %tobool4305.not, label %if.end4315, label %if.then4306

if.then4306:                                      ; preds = %sw.bb4295
  %ttype4308 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1142 = load %union.tree_node*, %union.tree_node** %ttype4308, align 4, !tbaa !19
  %call4309 = call %union.tree_node* @decl_attributes(%union.tree_node** nonnull %label4296, %union.tree_node* %1142, i32 0) #20
  %1143 = load %union.tree_node*, %union.tree_node** %label4296, align 4, !tbaa !15
  %call4310 = call %union.tree_node* (i32, ...) @build_stmt(i32 164, %union.tree_node* %1143) #20
  %call4311 = call %union.tree_node* @add_stmt(%union.tree_node* %call4310) #20
  br label %if.end4315

if.end4315:                                       ; preds = %if.then4306, %sw.bb4295
  %storemerge = phi %union.tree_node* [ %call4311, %if.then4306 ], [ null, %sw.bb4295 ]
  store %union.tree_node* %storemerge, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %7) #22
  br label %sw.epilog

sw.bb4317:                                        ; preds = %if.end150
  %1144 = load i8*, i8** @input_filename, align 4, !tbaa !15
  %1145 = load i32, i32* @lineno, align 4, !tbaa !16
  %call4318 = call %struct.rtx_def* @emit_line_note(i8* %1144, i32 %1145) #20
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4320:                                        ; preds = %if.end150
  %1146 = load i8*, i8** @input_filename, align 4, !tbaa !15
  %1147 = load i32, i32* @lineno, align 4, !tbaa !16
  %call4321 = call %struct.rtx_def* @emit_line_note(i8* %1146, i32 %1147) #20
  br label %sw.epilog

sw.bb4322:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4324:                                        ; preds = %if.end150
  store %union.tree_node* null, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4326:                                        ; preds = %if.end150
  %arrayidx4327 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4328 = bitcast %union.anon.2* %arrayidx4327 to %union.tree_node**
  %1148 = load %union.tree_node*, %union.tree_node** %ttype4328, align 4, !tbaa !19
  %ttype4330 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1149 = load %union.tree_node*, %union.tree_node** %ttype4330, align 4, !tbaa !19
  %call4331 = call %union.tree_node* @chainon(%union.tree_node* %1148, %union.tree_node* %1149) #20
  store %union.tree_node* %call4331, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4333:                                        ; preds = %if.end150
  %arrayidx4334 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype4335 = bitcast %union.anon.2* %arrayidx4334 to %union.tree_node**
  %1150 = load %union.tree_node*, %union.tree_node** %ttype4335, align 4, !tbaa !19
  %call4336 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %1150) #20
  %arrayidx4337 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4338 = bitcast %union.anon.2* %arrayidx4337 to %union.tree_node**
  %1151 = load %union.tree_node*, %union.tree_node** %ttype4338, align 4, !tbaa !19
  %call4339 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4336, %union.tree_node* %1151) #20
  store %union.tree_node* %call4339, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4341:                                        ; preds = %if.end150
  %arrayidx4342 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -5
  %ttype4343 = bitcast %union.anon.2* %arrayidx4342 to %union.tree_node**
  %1152 = load %union.tree_node*, %union.tree_node** %ttype4343, align 4, !tbaa !19
  %arrayidx4344 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype4345 = bitcast %union.anon.2* %arrayidx4344 to %union.tree_node**
  %1153 = load %union.tree_node*, %union.tree_node** %ttype4345, align 4, !tbaa !19
  %call4346 = call %union.tree_node* @build_tree_list(%union.tree_node* %1152, %union.tree_node* %1153) #20
  %arrayidx4347 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4348 = bitcast %union.anon.2* %arrayidx4347 to %union.tree_node**
  %1154 = load %union.tree_node*, %union.tree_node** %ttype4348, align 4, !tbaa !19
  %call4349 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4346, %union.tree_node* %1154) #20
  store %union.tree_node* %call4349, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4351:                                        ; preds = %if.end150
  %ttype4353 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1155 = load %union.tree_node*, %union.tree_node** %ttype4353, align 4, !tbaa !19
  %call4354 = call %union.tree_node* @combine_strings(%union.tree_node* %1155) #20
  %call4355 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %call4354, %union.tree_node* null) #20
  store %union.tree_node* %call4355, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4357:                                        ; preds = %if.end150
  %ttype4359 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1156 = load %union.tree_node*, %union.tree_node** %ttype4359, align 4, !tbaa !19
  %call4360 = call %union.tree_node* @combine_strings(%union.tree_node* %1156) #20
  %arrayidx4361 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4362 = bitcast %union.anon.2* %arrayidx4361 to %union.tree_node**
  %1157 = load %union.tree_node*, %union.tree_node** %ttype4362, align 4, !tbaa !19
  %call4363 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* %call4360, %union.tree_node* %1157) #20
  store %union.tree_node* %call4363, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4365:                                        ; preds = %if.end150
  call void @pushlevel(i32 0) #20
  call void @clear_parm_order() #20
  call void @declare_parm_level(i32 0) #20
  br label %sw.epilog

sw.bb4366:                                        ; preds = %if.end150
  %ttype4368 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1158 = load %union.tree_node*, %union.tree_node** %ttype4368, align 4, !tbaa !19
  store %union.tree_node* %1158, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void @parmlist_tags_warning() #20
  %call4370 = call %union.tree_node* @poplevel(i32 0, i32 0, i32 0) #20
  br label %sw.epilog

sw.bb4371:                                        ; preds = %if.end150
  %1159 = load i32, i32* @pedantic, align 4, !tbaa !16
  %tobool4372.not = icmp eq i32 %1159, 0
  br i1 %tobool4372.not, label %if.end4374, label %if.then4373

if.then4373:                                      ; preds = %sw.bb4371
  call void (i8*, ...) @pedwarn(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.50.2728, i32 0, i32 0)) #20
  br label %if.end4374

if.end4374:                                       ; preds = %if.then4373, %sw.bb4371
  %call4375 = call %union.tree_node* @getdecls() #20
  %tobool4377.not5816 = icmp eq %union.tree_node* %call4375, null
  br i1 %tobool4377.not5816, label %for.end4386, label %for.body4378

for.body4378:                                     ; preds = %for.body4378, %if.end4374
  %parm.05817 = phi %union.tree_node* [ %1160, %for.body4378 ], [ %call4375, %if.end4374 ]
  %asm_written_flag = getelementptr inbounds %union.tree_node, %union.tree_node* %parm.05817, i32 0, i32 0, i32 0, i32 2
  %bf.load4380 = load i32, i32* %asm_written_flag, align 4
  %bf.set4382 = or i32 %bf.load4380, 16384
  store i32 %bf.set4382, i32* %asm_written_flag, align 4
  %chain4385 = getelementptr inbounds %union.tree_node, %union.tree_node* %parm.05817, i32 0, i32 0, i32 0, i32 0
  %1160 = load %union.tree_node*, %union.tree_node** %chain4385, align 4, !tbaa !19
  %tobool4377.not = icmp eq %union.tree_node* %1160, null
  br i1 %tobool4377.not, label %for.end4386, label %for.body4378, !llvm.loop !67

for.end4386:                                      ; preds = %for.body4378, %if.end4374
  call void @clear_parm_order() #20
  br label %sw.epilog

sw.bb4389:                                        ; preds = %if.end150
  %ttype4391 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1161 = load %union.tree_node*, %union.tree_node** %ttype4391, align 4, !tbaa !19
  store %union.tree_node* %1161, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4393:                                        ; preds = %if.end150
  %call4394 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* null, %union.tree_node* null) #20
  store %union.tree_node* %call4394, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4396:                                        ; preds = %if.end150
  %call4397 = call %union.tree_node* @get_parm_info(i32 0) #20
  store %union.tree_node* %call4397, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4399:                                        ; preds = %if.end150
  %call4400 = call %union.tree_node* @get_parm_info(i32 0) #20
  store %union.tree_node* %call4400, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void (i8*, ...) @error(i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.51.2729, i32 0, i32 0)) #20
  br label %sw.epilog

sw.bb4402:                                        ; preds = %if.end150
  %call4403 = call %union.tree_node* @get_parm_info(i32 1) #20
  store %union.tree_node* %call4403, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4405:                                        ; preds = %if.end150
  %call4406 = call %union.tree_node* @get_parm_info(i32 0) #20
  store %union.tree_node* %call4406, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4408:                                        ; preds = %if.end150
  %ttype4410 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1162 = load %union.tree_node*, %union.tree_node** %ttype4410, align 4, !tbaa !19
  call void @push_parm_decl(%union.tree_node* %1162) #20
  br label %sw.epilog

sw.bb4411:                                        ; preds = %if.end150
  %ttype4413 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1163 = load %union.tree_node*, %union.tree_node** %ttype4413, align 4, !tbaa !19
  call void @push_parm_decl(%union.tree_node* %1163) #20
  br label %sw.epilog

sw.bb4414:                                        ; preds = %if.end150
  %1164 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx4415 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4416 = bitcast %union.anon.2* %arrayidx4415 to %union.tree_node**
  %1165 = load %union.tree_node*, %union.tree_node** %ttype4416, align 4, !tbaa !19
  %call4417 = call %union.tree_node* @build_tree_list(%union.tree_node* %1164, %union.tree_node* %1165) #20
  %ttype4419 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1166 = load %union.tree_node*, %union.tree_node** %ttype4419, align 4, !tbaa !19
  %1167 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call4420 = call %union.tree_node* @chainon(%union.tree_node* %1166, %union.tree_node* %1167) #20
  %call4421 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4417, %union.tree_node* %call4420) #20
  store %union.tree_node* %call4421, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1168 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4425 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1168, i32 0, i32 2
  %1169 = load %union.tree_node*, %union.tree_node** %value4425, align 4, !tbaa !19
  store %union.tree_node* %1169, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4427 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1168, i32 0, i32 1
  %1170 = bitcast %union.tree_node** %purpose4427 to %struct.tree_list**
  %1171 = load %struct.tree_list*, %struct.tree_list** %1170, align 4, !tbaa !19
  %purpose4429 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1171, i32 0, i32 1
  %1172 = load %union.tree_node*, %union.tree_node** %purpose4429, align 4, !tbaa !19
  store %union.tree_node* %1172, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4433 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1171, i32 0, i32 2
  %1173 = load %union.tree_node*, %union.tree_node** %value4433, align 4, !tbaa !19
  store %union.tree_node* %1173, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4435 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1168, i32 0, i32 0, i32 0
  %1174 = load %union.tree_node*, %union.tree_node** %chain4435, align 4, !tbaa !19
  store %union.tree_node* %1174, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4438:                                        ; preds = %if.end150
  %1175 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx4439 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4440 = bitcast %union.anon.2* %arrayidx4439 to %union.tree_node**
  %1176 = load %union.tree_node*, %union.tree_node** %ttype4440, align 4, !tbaa !19
  %call4441 = call %union.tree_node* @build_tree_list(%union.tree_node* %1175, %union.tree_node* %1176) #20
  %ttype4443 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1177 = load %union.tree_node*, %union.tree_node** %ttype4443, align 4, !tbaa !19
  %1178 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call4444 = call %union.tree_node* @chainon(%union.tree_node* %1177, %union.tree_node* %1178) #20
  %call4445 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4441, %union.tree_node* %call4444) #20
  store %union.tree_node* %call4445, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1179 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4449 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1179, i32 0, i32 2
  %1180 = load %union.tree_node*, %union.tree_node** %value4449, align 4, !tbaa !19
  store %union.tree_node* %1180, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4451 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1179, i32 0, i32 1
  %1181 = bitcast %union.tree_node** %purpose4451 to %struct.tree_list**
  %1182 = load %struct.tree_list*, %struct.tree_list** %1181, align 4, !tbaa !19
  %purpose4453 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1182, i32 0, i32 1
  %1183 = load %union.tree_node*, %union.tree_node** %purpose4453, align 4, !tbaa !19
  store %union.tree_node* %1183, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4457 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1182, i32 0, i32 2
  %1184 = load %union.tree_node*, %union.tree_node** %value4457, align 4, !tbaa !19
  store %union.tree_node* %1184, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4459 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1179, i32 0, i32 0, i32 0
  %1185 = load %union.tree_node*, %union.tree_node** %chain4459, align 4, !tbaa !19
  store %union.tree_node* %1185, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4462:                                        ; preds = %if.end150
  %ttype4464 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1186 = load %union.tree_node*, %union.tree_node** %ttype4464, align 4, !tbaa !19
  store %union.tree_node* %1186, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1187 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4468 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1187, i32 0, i32 2
  %1188 = load %union.tree_node*, %union.tree_node** %value4468, align 4, !tbaa !19
  store %union.tree_node* %1188, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4470 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1187, i32 0, i32 1
  %1189 = bitcast %union.tree_node** %purpose4470 to %struct.tree_list**
  %1190 = load %struct.tree_list*, %struct.tree_list** %1189, align 4, !tbaa !19
  %purpose4472 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1190, i32 0, i32 1
  %1191 = load %union.tree_node*, %union.tree_node** %purpose4472, align 4, !tbaa !19
  store %union.tree_node* %1191, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4476 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1190, i32 0, i32 2
  %1192 = load %union.tree_node*, %union.tree_node** %value4476, align 4, !tbaa !19
  store %union.tree_node* %1192, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4478 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1187, i32 0, i32 0, i32 0
  %1193 = load %union.tree_node*, %union.tree_node** %chain4478, align 4, !tbaa !19
  store %union.tree_node* %1193, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4481:                                        ; preds = %if.end150
  %1194 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx4482 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4483 = bitcast %union.anon.2* %arrayidx4482 to %union.tree_node**
  %1195 = load %union.tree_node*, %union.tree_node** %ttype4483, align 4, !tbaa !19
  %call4484 = call %union.tree_node* @build_tree_list(%union.tree_node* %1194, %union.tree_node* %1195) #20
  %ttype4486 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1196 = load %union.tree_node*, %union.tree_node** %ttype4486, align 4, !tbaa !19
  %1197 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call4487 = call %union.tree_node* @chainon(%union.tree_node* %1196, %union.tree_node* %1197) #20
  %call4488 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4484, %union.tree_node* %call4487) #20
  store %union.tree_node* %call4488, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1198 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4492 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1198, i32 0, i32 2
  %1199 = load %union.tree_node*, %union.tree_node** %value4492, align 4, !tbaa !19
  store %union.tree_node* %1199, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4494 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1198, i32 0, i32 1
  %1200 = bitcast %union.tree_node** %purpose4494 to %struct.tree_list**
  %1201 = load %struct.tree_list*, %struct.tree_list** %1200, align 4, !tbaa !19
  %purpose4496 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1201, i32 0, i32 1
  %1202 = load %union.tree_node*, %union.tree_node** %purpose4496, align 4, !tbaa !19
  store %union.tree_node* %1202, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4500 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1201, i32 0, i32 2
  %1203 = load %union.tree_node*, %union.tree_node** %value4500, align 4, !tbaa !19
  store %union.tree_node* %1203, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4502 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1198, i32 0, i32 0, i32 0
  %1204 = load %union.tree_node*, %union.tree_node** %chain4502, align 4, !tbaa !19
  store %union.tree_node* %1204, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4505:                                        ; preds = %if.end150
  %ttype4507 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1205 = load %union.tree_node*, %union.tree_node** %ttype4507, align 4, !tbaa !19
  store %union.tree_node* %1205, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1206 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4511 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1206, i32 0, i32 2
  %1207 = load %union.tree_node*, %union.tree_node** %value4511, align 4, !tbaa !19
  store %union.tree_node* %1207, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4513 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1206, i32 0, i32 1
  %1208 = bitcast %union.tree_node** %purpose4513 to %struct.tree_list**
  %1209 = load %struct.tree_list*, %struct.tree_list** %1208, align 4, !tbaa !19
  %purpose4515 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1209, i32 0, i32 1
  %1210 = load %union.tree_node*, %union.tree_node** %purpose4515, align 4, !tbaa !19
  store %union.tree_node* %1210, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4519 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1209, i32 0, i32 2
  %1211 = load %union.tree_node*, %union.tree_node** %value4519, align 4, !tbaa !19
  store %union.tree_node* %1211, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4521 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1206, i32 0, i32 0, i32 0
  %1212 = load %union.tree_node*, %union.tree_node** %chain4521, align 4, !tbaa !19
  store %union.tree_node* %1212, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4524:                                        ; preds = %if.end150
  %1213 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx4525 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4526 = bitcast %union.anon.2* %arrayidx4525 to %union.tree_node**
  %1214 = load %union.tree_node*, %union.tree_node** %ttype4526, align 4, !tbaa !19
  %call4527 = call %union.tree_node* @build_tree_list(%union.tree_node* %1213, %union.tree_node* %1214) #20
  %ttype4529 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1215 = load %union.tree_node*, %union.tree_node** %ttype4529, align 4, !tbaa !19
  %1216 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call4530 = call %union.tree_node* @chainon(%union.tree_node* %1215, %union.tree_node* %1216) #20
  %call4531 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4527, %union.tree_node* %call4530) #20
  store %union.tree_node* %call4531, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1217 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4535 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1217, i32 0, i32 2
  %1218 = load %union.tree_node*, %union.tree_node** %value4535, align 4, !tbaa !19
  store %union.tree_node* %1218, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4537 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1217, i32 0, i32 1
  %1219 = bitcast %union.tree_node** %purpose4537 to %struct.tree_list**
  %1220 = load %struct.tree_list*, %struct.tree_list** %1219, align 4, !tbaa !19
  %purpose4539 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1220, i32 0, i32 1
  %1221 = load %union.tree_node*, %union.tree_node** %purpose4539, align 4, !tbaa !19
  store %union.tree_node* %1221, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4543 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1220, i32 0, i32 2
  %1222 = load %union.tree_node*, %union.tree_node** %value4543, align 4, !tbaa !19
  store %union.tree_node* %1222, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4545 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1217, i32 0, i32 0, i32 0
  %1223 = load %union.tree_node*, %union.tree_node** %chain4545, align 4, !tbaa !19
  store %union.tree_node* %1223, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4548:                                        ; preds = %if.end150
  %1224 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx4549 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4550 = bitcast %union.anon.2* %arrayidx4549 to %union.tree_node**
  %1225 = load %union.tree_node*, %union.tree_node** %ttype4550, align 4, !tbaa !19
  %call4551 = call %union.tree_node* @build_tree_list(%union.tree_node* %1224, %union.tree_node* %1225) #20
  %ttype4553 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1226 = load %union.tree_node*, %union.tree_node** %ttype4553, align 4, !tbaa !19
  %1227 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call4554 = call %union.tree_node* @chainon(%union.tree_node* %1226, %union.tree_node* %1227) #20
  %call4555 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4551, %union.tree_node* %call4554) #20
  store %union.tree_node* %call4555, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1228 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4559 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1228, i32 0, i32 2
  %1229 = load %union.tree_node*, %union.tree_node** %value4559, align 4, !tbaa !19
  store %union.tree_node* %1229, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4561 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1228, i32 0, i32 1
  %1230 = bitcast %union.tree_node** %purpose4561 to %struct.tree_list**
  %1231 = load %struct.tree_list*, %struct.tree_list** %1230, align 4, !tbaa !19
  %purpose4563 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1231, i32 0, i32 1
  %1232 = load %union.tree_node*, %union.tree_node** %purpose4563, align 4, !tbaa !19
  store %union.tree_node* %1232, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4567 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1231, i32 0, i32 2
  %1233 = load %union.tree_node*, %union.tree_node** %value4567, align 4, !tbaa !19
  store %union.tree_node* %1233, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4569 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1228, i32 0, i32 0, i32 0
  %1234 = load %union.tree_node*, %union.tree_node** %chain4569, align 4, !tbaa !19
  store %union.tree_node* %1234, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4572:                                        ; preds = %if.end150
  %ttype4574 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1235 = load %union.tree_node*, %union.tree_node** %ttype4574, align 4, !tbaa !19
  store %union.tree_node* %1235, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1236 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4578 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1236, i32 0, i32 2
  %1237 = load %union.tree_node*, %union.tree_node** %value4578, align 4, !tbaa !19
  store %union.tree_node* %1237, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4580 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1236, i32 0, i32 1
  %1238 = bitcast %union.tree_node** %purpose4580 to %struct.tree_list**
  %1239 = load %struct.tree_list*, %struct.tree_list** %1238, align 4, !tbaa !19
  %purpose4582 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1239, i32 0, i32 1
  %1240 = load %union.tree_node*, %union.tree_node** %purpose4582, align 4, !tbaa !19
  store %union.tree_node* %1240, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4586 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1239, i32 0, i32 2
  %1241 = load %union.tree_node*, %union.tree_node** %value4586, align 4, !tbaa !19
  store %union.tree_node* %1241, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4588 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1236, i32 0, i32 0, i32 0
  %1242 = load %union.tree_node*, %union.tree_node** %chain4588, align 4, !tbaa !19
  store %union.tree_node* %1242, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4591:                                        ; preds = %if.end150
  %1243 = load %union.tree_node*, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %arrayidx4592 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4593 = bitcast %union.anon.2* %arrayidx4592 to %union.tree_node**
  %1244 = load %union.tree_node*, %union.tree_node** %ttype4593, align 4, !tbaa !19
  %call4594 = call %union.tree_node* @build_tree_list(%union.tree_node* %1243, %union.tree_node* %1244) #20
  %ttype4596 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1245 = load %union.tree_node*, %union.tree_node** %ttype4596, align 4, !tbaa !19
  %1246 = load %union.tree_node*, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %call4597 = call %union.tree_node* @chainon(%union.tree_node* %1245, %union.tree_node* %1246) #20
  %call4598 = call %union.tree_node* @build_tree_list(%union.tree_node* %call4594, %union.tree_node* %call4597) #20
  store %union.tree_node* %call4598, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1247 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4602 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1247, i32 0, i32 2
  %1248 = load %union.tree_node*, %union.tree_node** %value4602, align 4, !tbaa !19
  store %union.tree_node* %1248, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4604 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1247, i32 0, i32 1
  %1249 = bitcast %union.tree_node** %purpose4604 to %struct.tree_list**
  %1250 = load %struct.tree_list*, %struct.tree_list** %1249, align 4, !tbaa !19
  %purpose4606 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1250, i32 0, i32 1
  %1251 = load %union.tree_node*, %union.tree_node** %purpose4606, align 4, !tbaa !19
  store %union.tree_node* %1251, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4610 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1250, i32 0, i32 2
  %1252 = load %union.tree_node*, %union.tree_node** %value4610, align 4, !tbaa !19
  store %union.tree_node* %1252, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4612 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1247, i32 0, i32 0, i32 0
  %1253 = load %union.tree_node*, %union.tree_node** %chain4612, align 4, !tbaa !19
  store %union.tree_node* %1253, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4615:                                        ; preds = %if.end150
  %ttype4617 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1254 = load %union.tree_node*, %union.tree_node** %ttype4617, align 4, !tbaa !19
  store %union.tree_node* %1254, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %1255 = load %struct.tree_list*, %struct.tree_list** bitcast (%union.tree_node** @declspec_stack to %struct.tree_list**), align 4, !tbaa !15
  %value4621 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1255, i32 0, i32 2
  %1256 = load %union.tree_node*, %union.tree_node** %value4621, align 4, !tbaa !19
  store %union.tree_node* %1256, %union.tree_node** @current_declspecs, align 4, !tbaa !15
  %purpose4623 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1255, i32 0, i32 1
  %1257 = bitcast %union.tree_node** %purpose4623 to %struct.tree_list**
  %1258 = load %struct.tree_list*, %struct.tree_list** %1257, align 4, !tbaa !19
  %purpose4625 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1258, i32 0, i32 1
  %1259 = load %union.tree_node*, %union.tree_node** %purpose4625, align 4, !tbaa !19
  store %union.tree_node* %1259, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %value4629 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1258, i32 0, i32 2
  %1260 = load %union.tree_node*, %union.tree_node** %value4629, align 4, !tbaa !19
  store %union.tree_node* %1260, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  %chain4631 = getelementptr inbounds %struct.tree_list, %struct.tree_list* %1255, i32 0, i32 0, i32 0
  %1261 = load %union.tree_node*, %union.tree_node** %chain4631, align 4, !tbaa !19
  store %union.tree_node* %1261, %union.tree_node** @declspec_stack, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4634:                                        ; preds = %if.end150
  %1262 = load %union.tree_node*, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  %arrayidx4635 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype4636 = bitcast %union.anon.2* %arrayidx4635 to %union.tree_node**
  %1263 = load %union.tree_node*, %union.tree_node** %ttype4636, align 4, !tbaa !19
  %call4637 = call %union.tree_node* @chainon(%union.tree_node* %1262, %union.tree_node* %1263) #20
  store %union.tree_node* %call4637, %union.tree_node** @prefix_attributes, align 4, !tbaa !15
  store %union.tree_node* %call4637, %union.tree_node** @all_prefix_attributes, align 4, !tbaa !15
  br label %sw.epilog

sw.bb4638:                                        ; preds = %if.end150
  call void @pushlevel(i32 0) #20
  call void @clear_parm_order() #20
  call void @declare_parm_level(i32 1) #20
  br label %sw.epilog

sw.bb4639:                                        ; preds = %if.end150
  %ttype4641 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1264 = load %union.tree_node*, %union.tree_node** %ttype4641, align 4, !tbaa !19
  store %union.tree_node* %1264, %union.tree_node** %ttype4642, align 4, !tbaa !19
  call void @parmlist_tags_warning() #20
  %call4643 = call %union.tree_node* @poplevel(i32 0, i32 0, i32 0) #20
  br label %sw.epilog

sw.bb4644:                                        ; preds = %if.end150
  %arrayidx4645 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -1
  %ttype4646 = bitcast %union.anon.2* %arrayidx4645 to %union.tree_node**
  %t.05813 = load %union.tree_node*, %union.tree_node** %ttype4646, align 4, !tbaa !19
  %tobool4648.not5814 = icmp eq %union.tree_node* %t.05813, null
  br i1 %tobool4648.not5814, label %for.end4659, label %for.body4649

for.body4649:                                     ; preds = %for.inc4656, %sw.bb4644
  %t.05815 = phi %union.tree_node* [ %t.0, %for.inc4656 ], [ %t.05813, %sw.bb4644 ]
  %value4651 = getelementptr inbounds %union.tree_node, %union.tree_node* %t.05815, i32 0, i32 0, i32 2
  %1265 = bitcast i32* %value4651 to %union.tree_node**
  %1266 = load %union.tree_node*, %union.tree_node** %1265, align 4, !tbaa !19
  %cmp4652 = icmp eq %union.tree_node* %1266, null
  br i1 %cmp4652, label %if.then4654, label %for.inc4656

if.then4654:                                      ; preds = %for.body4649
  call void (i8*, ...) @error(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.52.2730, i32 0, i32 0)) #20
  br label %for.inc4656

for.inc4656:                                      ; preds = %if.then4654, %for.body4649
  %chain4658 = getelementptr inbounds %union.tree_node, %union.tree_node* %t.05815, i32 0, i32 0, i32 0, i32 0
  %t.0 = load %union.tree_node*, %union.tree_node** %chain4658, align 4, !tbaa !19
  %tobool4648.not = icmp eq %union.tree_node* %t.0, null
  br i1 %tobool4648.not, label %for.end4659.loopexit, label %for.body4649, !llvm.loop !68

for.end4659.loopexit:                             ; preds = %for.inc4656
  %.pre = load %union.tree_node*, %union.tree_node** %ttype4646, align 4, !tbaa !19
  br label %for.end4659

for.end4659:                                      ; preds = %for.end4659.loopexit, %sw.bb4644
  %1267 = phi %union.tree_node* [ %.pre, %for.end4659.loopexit ], [ null, %sw.bb4644 ]
  %call4662 = call %union.tree_node* @tree_cons(%union.tree_node* null, %union.tree_node* null, %union.tree_node* %1267) #20
  store %union.tree_node* %call4662, %union.tree_node** %ttype4642, align 4, !tbaa !19
  %arrayidx4664 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -3
  %ttype4665 = bitcast %union.anon.2* %arrayidx4664 to %union.tree_node**
  %1268 = load %union.tree_node*, %union.tree_node** %ttype4665, align 4, !tbaa !19
  %cmp4666.not = icmp eq %union.tree_node* %1268, null
  br i1 %cmp4666.not, label %sw.epilog, label %land.lhs.true4668

land.lhs.true4668:                                ; preds = %for.end4659
  %code4671 = getelementptr inbounds %union.tree_node, %union.tree_node* %call4662, i32 0, i32 0, i32 0, i32 2
  %bf.load4672 = load i32, i32* %code4671, align 4
  %bf.clear4673 = and i32 %bf.load4672, 255
  %cmp4674.not = icmp eq i32 %bf.clear4673, 2
  br i1 %cmp4674.not, label %lor.lhs.false4676, label %cleanup4694

lor.lhs.false4676:                                ; preds = %land.lhs.true4668
  %purpose4679 = getelementptr inbounds %union.tree_node, %union.tree_node* %call4662, i32 0, i32 0, i32 1
  %1269 = bitcast i8** %purpose4679 to %union.tree_node**
  %1270 = load %union.tree_node*, %union.tree_node** %1269, align 4, !tbaa !19
  %cmp4680 = icmp eq %union.tree_node* %1270, null
  br i1 %cmp4680, label %cleanup4694, label %lor.lhs.false4682

lor.lhs.false4682:                                ; preds = %lor.lhs.false4676
  %code4687 = getelementptr inbounds %union.tree_node, %union.tree_node* %1270, i32 0, i32 0, i32 0, i32 2
  %bf.load4688 = load i32, i32* %code4687, align 4
  %bf.clear4689 = and i32 %bf.load4688, 255
  %cmp4690.not = icmp eq i32 %bf.clear4689, 35
  br i1 %cmp4690.not, label %sw.epilog, label %cleanup4694

cleanup4694:                                      ; preds = %lor.lhs.false4682, %lor.lhs.false4676, %land.lhs.true4668
  call fastcc void @yyerror(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.17.2695, i32 0, i32 0)) #21
  br label %yyerrlab1

sw.bb4696:                                        ; preds = %if.end150
  %ttype4698 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1271 = load %union.tree_node*, %union.tree_node** %ttype4698, align 4, !tbaa !19
  %call4699 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %1271) #20
  store %union.tree_node* %call4699, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4701:                                        ; preds = %if.end150
  %arrayidx4702 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4703 = bitcast %union.anon.2* %arrayidx4702 to %union.tree_node**
  %1272 = load %union.tree_node*, %union.tree_node** %ttype4703, align 4, !tbaa !19
  %ttype4705 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1273 = load %union.tree_node*, %union.tree_node** %ttype4705, align 4, !tbaa !19
  %call4706 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %1273) #20
  %call4707 = call %union.tree_node* @chainon(%union.tree_node* %1272, %union.tree_node* %call4706) #20
  store %union.tree_node* %call4707, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4709:                                        ; preds = %if.end150
  %ttype4711 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1274 = load %union.tree_node*, %union.tree_node** %ttype4711, align 4, !tbaa !19
  %call4712 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %1274) #20
  store %union.tree_node* %call4712, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4714:                                        ; preds = %if.end150
  %arrayidx4715 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 -2
  %ttype4716 = bitcast %union.anon.2* %arrayidx4715 to %union.tree_node**
  %1275 = load %union.tree_node*, %union.tree_node** %ttype4716, align 4, !tbaa !19
  %ttype4718 = bitcast %union.anon.2* %yyvsp.3 to %union.tree_node**
  %1276 = load %union.tree_node*, %union.tree_node** %ttype4718, align 4, !tbaa !19
  %call4719 = call %union.tree_node* @build_tree_list(%union.tree_node* null, %union.tree_node* %1276) #20
  %call4720 = call %union.tree_node* @chainon(%union.tree_node* %1275, %union.tree_node* %call4719) #20
  store %union.tree_node* %call4720, %union.tree_node** %ttype4642, align 4, !tbaa !19
  br label %sw.epilog

sw.bb4722:                                        ; preds = %if.end150
  %1277 = load i32, i32* @pedantic, align 4, !tbaa !16
  %1278 = load i32, i32* @warn_pointer_arith, align 4, !tbaa !16
  %shl = shl i32 %1278, 1
  %or = or i32 %shl, %1277
  %1279 = load i32, i32* @warn_traditional, align 4, !tbaa !16
  %shl4723 = shl i32 %1279, 2
  %or4724 = or i32 %or, %shl4723
  %conv4725 = sext i32 %or4724 to i64
  %call4726 = call %union.tree_node* @size_int_wide(i64 %conv4725, i32 0) #20
  store %union.tree_node* %call4726, %union.tree_node** %ttype4642, align 4, !tbaa !19
  store i32 0, i32* @pedantic, align 4, !tbaa !16
  store i32 0, i32* @warn_pointer_arith, align 4, !tbaa !16
  store i32 0, i32* @warn_traditional, align 4, !tbaa !16
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.bb4722, %sw.bb4714, %sw.bb4709, %sw.bb4701, %sw.bb4696, %lor.lhs.false4682, %for.end4659, %sw.bb4639, %sw.bb4638, %sw.bb4634, %sw.bb4615, %sw.bb4591, %sw.bb4572, %sw.bb4548, %sw.bb4524, %sw.bb4505, %sw.bb4481, %sw.bb4462, %sw.bb4438, %sw.bb4414, %sw.bb4411, %sw.bb4408, %sw.bb4405, %sw.bb4402, %sw.bb4399, %sw.bb4396, %sw.bb4393, %sw.bb4389, %for.end4386, %sw.bb4366, %sw.bb4365, %sw.bb4357, %sw.bb4351, %sw.bb4341, %sw.bb4333, %sw.bb4326, %sw.bb4324, %sw.bb4322, %sw.bb4320, %sw.bb4317, %if.end4315, %sw.bb4291, %sw.bb4283, %sw.bb4277, %sw.bb4275, %if.end4263, %if.else4256, %if.then4248, %sw.bb4226, %sw.bb4214, %sw.bb4204, %sw.bb4198, %sw.bb4192, %sw.bb4188, %sw.bb4183, %sw.bb4178, %if.end4176, %sw.bb4147, %sw.bb4142, %sw.bb4141, %sw.bb4136, %sw.bb4135, %sw.bb4129, %do.body4109, %sw.bb4100, %if.then4090, %sw.bb4086, %sw.bb4064, %sw.bb4059, %sw.bb4049, %do.body4029, %sw.bb4013, %sw.bb4009, %sw.bb4008, %if.then4006, %land.lhs.true4000, %sw.bb3998, %if.then3996, %land.lhs.true3991, %sw.bb3989, %sw.bb3986, %if.then3978, %sw.bb3974, %if.then3966, %sw.bb3962, %do.body3941, %sw.bb3938, %if.end3936, %if.end3929, %sw.bb3904, %sw.bb3894, %sw.bb3884, %sw.bb3881, %sw.bb3880, %do.body3855, %if.end3847, %sw.bb3824, %sw.bb3821, %sw.bb3817, %for.body3803, %sw.bb3798, %if.then3796, %sw.bb3794, %if.else3791, %if.then3775, %if.else3770, %if.then3766, %sw.bb3761, %sw.bb3759, %if.then3757, %sw.bb3753, %sw.bb3752, %if.end3745, %if.end3729, %if.end3715, %sw.bb3701, %sw.bb3698, %sw.bb3693, %sw.bb3690, %sw.bb3683, %sw.bb3678, %sw.bb3673, %sw.bb3668, %sw.bb3661, %sw.bb3654, %cond.end3651, %sw.bb3631, %sw.bb3626, %sw.bb3619, %sw.bb3610, %sw.bb3604, %sw.bb3600, %sw.bb3598, %sw.bb3591, %sw.bb3587, %sw.bb3580, %sw.bb3575, %sw.bb3573, %if.else3565, %if.then3561, %sw.bb3542, %sw.bb3526, %sw.bb3512, %sw.bb3498, %sw.bb3482, %sw.bb3468, %sw.bb3461, %sw.bb3454, %sw.bb3437, %sw.bb3435, %if.end3431, %sw.bb3409, %if.end3387, %sw.bb3365, %if.then3363, %sw.bb3361, %sw.bb3354, %sw.bb3352, %sw.bb3345, %sw.bb3341, %if.then3339, %sw.bb3335, %if.then3333, %land.lhs.true3327, %sw.bb3321, %sw.bb3316, %sw.bb3311, %sw.bb3298, %sw.bb3295, %sw.bb3282, %sw.bb3277, %sw.bb3266, %sw.bb3254, %sw.bb3249, %sw.bb3238, %sw.bb3226, %sw.bb3221, %sw.bb3217, %sw.bb3215, %sw.bb3211, %sw.bb3209, %sw.bb3205, %sw.bb3203, %sw.bb3196, %sw.bb3189, %cond.end3186, %sw.bb3166, %cond.end3163, %sw.bb3143, %sw.bb3136, %sw.bb3129, %sw.bb3122, %sw.bb3115, %sw.bb3108, %sw.bb3101, %sw.bb3094, %sw.bb3087, %cond.end3084, %sw.bb3060, %sw.bb3059, %if.end3052, %sw.bb3038, %sw.bb3037, %if.end3030, %sw.bb3024, %if.then3022, %sw.bb3016, %sw.bb3013, %sw.bb3010, %sw.bb3008, %sw.bb3007, %if.then3005, %sw.bb3001, %if.then2999, %sw.bb2997, %if.then2995, %sw.bb2991, %if.then2989, %sw.bb2987, %sw.bb2985, %sw.bb2982, %sw.bb2981, %sw.bb2974, %sw.bb2964, %sw.bb2956, %sw.bb2951, %sw.bb2949, %sw.bb2942, %sw.bb2938, %sw.bb2934, %sw.bb2927, %sw.bb2923, %sw.bb2919, %sw.bb2917, %sw.bb2906, %sw.bb2899, %sw.bb2887, %sw.bb2877, %sw.bb2870, %sw.bb2858, %if.end2854, %sw.bb2840, %sw.bb2835, %sw.bb2829, %sw.bb2824, %sw.bb2819, %sw.bb2817, %sw.bb2804, %sw.bb2791, %sw.bb2778, %sw.bb2765, %sw.bb2743, %if.end2721, %if.end2682, %if.end2643, %if.end2604, %sw.bb2574, %sw.bb2561, %sw.bb2548, %sw.bb2535, %sw.bb2522, %sw.bb2509, %sw.bb2496, %sw.bb2483, %sw.bb2470, %sw.bb2457, %sw.bb2435, %if.end2413, %if.end2374, %if.end2335, %if.end2296, %sw.bb2266, %sw.bb2253, %sw.bb2240, %sw.bb2227, %sw.bb2214, %sw.bb2201, %sw.bb2179, %if.end2157, %if.end2118, %if.end2079, %if.end2040, %sw.bb2010, %sw.bb1997, %sw.bb1975, %if.end1953, %if.end1914, %if.end1875, %if.end1836, %sw.bb1809, %sw.bb1796, %sw.bb1786, %sw.bb1773, %sw.bb1760, %sw.bb1747, %sw.bb1734, %sw.bb1712, %sw.bb1699, %sw.bb1686, %sw.bb1673, %sw.bb1660, %sw.bb1647, %sw.bb1634, %sw.bb1621, %sw.bb1608, %sw.bb1595, %sw.bb1582, %sw.bb1560, %sw.bb1549, %sw.bb1536, %sw.bb1523, %sw.bb1510, %sw.bb1497, %sw.bb1484, %sw.bb1471, %sw.bb1460, %sw.bb1438, %sw.bb1428, %sw.bb1415, %sw.bb1402, %sw.bb1382, %sw.bb1369, %sw.bb1356, %sw.bb1346, %do.body1333, %sw.bb1329, %do.body1314, %do.body1298, %do.body1282, %do.body1266, %sw.bb1261, %sw.bb1253, %sw.bb1251, %sw.bb1248, %do.body1233, %do.body1217, %if.then1213, %sw.bb1211, %if.then1209, %lor.lhs.false1206, %sw.bb1191, %sw.bb1186, %sw.bb1181, %sw.bb1172, %sw.bb1165, %sw.bb1158, %sw.bb1137, %if.end1124, %sw.bb1052, %sw.bb1045, %sw.bb1032, %if.end1020, %sw.bb979, %if.end974, %if.end940, %sw.bb923, %sw.bb917, %sw.bb912, %if.end905, %if.then894, %sw.bb863, %if.then858, %sw.bb830, %sw.bb816, %if.end799, %sw.bb782, %sw.bb771, %sw.bb759, %sw.bb747, %sw.bb735, %sw.bb723, %sw.bb711, %sw.bb702, %sw.bb693, %sw.bb684, %sw.bb675, %sw.bb666, %sw.bb657, %sw.bb648, %sw.bb639, %sw.bb630, %sw.bb621, %sw.bb612, %sw.bb603, %sw.bb596, %sw.bb594, %sw.bb592, %sw.bb587, %sw.bb582, %sw.bb575, %sw.bb569, %sw.bb562, %if.end555, %sw.bb527, %sw.bb519, %sw.bb502, %sw.bb497, %sw.bb490, %sw.bb485, %sw.bb483, %sw.bb478, %sw.bb476, %sw.bb474, %sw.bb472, %sw.bb470, %if.then468, %sw.bb463, %sw.bb461, %sw.bb459, %do.body444, %sw.bb419, %sw.bb418, %sw.bb411, %do.body396, %sw.bb371, %sw.bb370, %sw.bb363, %do.body348, %sw.bb327, %sw.bb326, %sw.bb319, %if.then317, %sw.bb315, %sw.bb312, %do.body297, %do.body281, %do.body269, %do.body, %if.else251, %if.then248, %sw.bb159, %sw.bb158, %while.end, %if.end153, %if.end150
  %idx.neg = sub nsw i32 0, %conv125
  %add.ptr4730 = getelementptr inbounds i16, i16* %yyssp.3, i32 %idx.neg
  %1280 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool4731.not = icmp eq i32 %1280, 0
  br i1 %tobool4731.not, label %if.end4744, label %if.then4732

if.then4732:                                      ; preds = %sw.epilog
  %add.ptr4733 = getelementptr inbounds i16, i16* %yyss.2, i32 -1
  %1281 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %1282 = call i32 @fwrite(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.53.2731, i32 0, i32 0), i32 15, i32 1, %struct._IO_FILE* %1281) #24
  %cmp4736.not5834 = icmp eq i16* %add.ptr4733, %add.ptr4730
  br i1 %cmp4736.not5834, label %while.end4742, label %while.body4738

while.body4738:                                   ; preds = %while.body4738, %if.then4732
  %ssp1.05835 = phi i16* [ %incdec.ptr4739, %while.body4738 ], [ %add.ptr4733, %if.then4732 ]
  %1283 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %incdec.ptr4739 = getelementptr inbounds i16, i16* %ssp1.05835, i32 1
  %1284 = load i16, i16* %incdec.ptr4739, align 2, !tbaa !34
  %conv4740 = sext i16 %1284 to i32
  %call4741 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1283, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.54.2732, i32 0, i32 0), i32 %conv4740) #25
  %cmp4736.not = icmp eq i16* %incdec.ptr4739, %add.ptr4730
  br i1 %cmp4736.not, label %while.end4742, label %while.body4738, !llvm.loop !69

while.end4742:                                    ; preds = %while.body4738, %if.then4732
  %1285 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %fputc5764 = call i32 @fputc(i32 10, %struct._IO_FILE* %1285)
  br label %if.end4744

if.end4744:                                       ; preds = %while.end4742, %sw.epilog
  %incdec.ptr4745.idx = sub nsw i32 1, %conv125
  %incdec.ptr4745 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.3, i32 %incdec.ptr4745.idx
  %1286 = getelementptr %union.anon.2, %union.anon.2* %incdec.ptr4745, i32 0, i32 0
  %1287 = load i32, i32* %6, align 4
  store i32 %1287, i32* %1286, align 4
  %arrayidx4746 = getelementptr inbounds [560 x i16], [560 x i16]* @yyr1, i32 0, i32 %yyn.0
  %1288 = load i16, i16* %arrayidx4746, align 2, !tbaa !34
  %conv4747 = sext i16 %1288 to i32
  %sub4748 = add nsw i32 %conv4747, -91
  %arrayidx4749 = getelementptr inbounds [198 x i16], [198 x i16]* @yypgoto, i32 0, i32 %sub4748
  %1289 = load i16, i16* %arrayidx4749, align 2, !tbaa !34
  %conv4750 = sext i16 %1289 to i32
  %1290 = load i16, i16* %add.ptr4730, align 2, !tbaa !34
  %conv4751 = sext i16 %1290 to i32
  %add4752 = add nsw i32 %conv4751, %conv4750
  %1291 = icmp ult i32 %add4752, 3206
  br i1 %1291, label %land.lhs.true4758, label %if.else4767

land.lhs.true4758:                                ; preds = %if.end4744
  %arrayidx4759 = getelementptr inbounds [3206 x i16], [3206 x i16]* @yycheck, i32 0, i32 %add4752
  %1292 = load i16, i16* %arrayidx4759, align 2, !tbaa !34
  %cmp4762 = icmp eq i16 %1292, %1290
  br i1 %cmp4762, label %if.then4764, label %if.else4767

if.then4764:                                      ; preds = %land.lhs.true4758
  %arrayidx4765 = getelementptr inbounds [3206 x i16], [3206 x i16]* @yytable, i32 0, i32 %add4752
  br label %if.end4771

if.else4767:                                      ; preds = %land.lhs.true4758, %if.end4744
  %arrayidx4769 = getelementptr inbounds [198 x i16], [198 x i16]* @yydefgoto, i32 0, i32 %sub4748
  br label %if.end4771

if.end4771:                                       ; preds = %if.else4767, %if.then4764
  %yystate.2.in.in = phi i16* [ %arrayidx4765, %if.then4764 ], [ %arrayidx4769, %if.else4767 ]
  %yystate.2.in = load i16, i16* %yystate.2.in.in, align 2, !tbaa !34
  %yystate.2 = sext i16 %yystate.2.in to i32
  br label %yynewstate.backedge

yyerrlab:                                         ; preds = %yydefault, %if.else95, %if.then90
  %yychar1.4 = phi i32 [ %yychar1.2, %yydefault ], [ %yychar1.1, %if.then90 ], [ %yychar1.1, %if.else95 ]
  %tobool4772.not = icmp eq i32 %yyerrstatus.0, 0
  br i1 %tobool4772.not, label %if.then4773, label %yyerrlab1

if.then4773:                                      ; preds = %yyerrlab
  %1293 = load i32, i32* @yynerrs, align 4, !tbaa !16
  %inc4774 = add nsw i32 %1293, 1
  store i32 %inc4774, i32* @yynerrs, align 4, !tbaa !16
  call fastcc void @yyerror(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.56.2733, i32 0, i32 0)) #21
  br label %yyerrlab1

yyerrlab1:                                        ; preds = %if.then4773, %yyerrlab, %cleanup4694, %if.then3846, %if.then3057, %if.then3035, %if.then416, %if.then368, %if.then324
  %yychar1.5 = phi i32 [ %yychar1.3, %cleanup4694 ], [ %yychar1.3, %if.then3846 ], [ %yychar1.3, %if.then3057 ], [ %yychar1.3, %if.then3035 ], [ %yychar1.3, %if.then416 ], [ %yychar1.3, %if.then368 ], [ %yychar1.3, %if.then324 ], [ %yychar1.4, %if.then4773 ], [ %yychar1.4, %yyerrlab ]
  %yyerrstatus.3 = phi i32 [ %yyerrstatus.2, %cleanup4694 ], [ %yyerrstatus.2, %if.then3846 ], [ %yyerrstatus.2, %if.then3057 ], [ %yyerrstatus.2, %if.then3035 ], [ %yyerrstatus.2, %if.then416 ], [ %yyerrstatus.2, %if.then368 ], [ %yyerrstatus.2, %if.then324 ], [ %yyerrstatus.0, %if.then4773 ], [ %yyerrstatus.0, %yyerrlab ]
  %yyvsp.4 = phi %union.anon.2* [ %yyvsp.3, %cleanup4694 ], [ %yyvsp.3, %if.then3846 ], [ %yyvsp.3, %if.then3057 ], [ %yyvsp.3, %if.then3035 ], [ %yyvsp.3, %if.then416 ], [ %yyvsp.3, %if.then368 ], [ %yyvsp.3, %if.then324 ], [ %yyvsp.2, %if.then4773 ], [ %yyvsp.2, %yyerrlab ]
  %yyssp.4 = phi i16* [ %yyssp.3, %cleanup4694 ], [ %yyssp.3, %if.then3846 ], [ %yyssp.3, %if.then3057 ], [ %yyssp.3, %if.then3035 ], [ %yyssp.3, %if.then416 ], [ %yyssp.3, %if.then368 ], [ %yyssp.3, %if.then324 ], [ %yyssp.2, %if.then4773 ], [ %yyssp.2, %yyerrlab ]
  %yystate.3 = phi i32 [ %yystate.1, %cleanup4694 ], [ %yystate.1, %if.then3846 ], [ %yystate.1, %if.then3057 ], [ %yystate.1, %if.then3035 ], [ %yystate.1, %if.then416 ], [ %yystate.1, %if.then368 ], [ %yystate.1, %if.then324 ], [ %yystate.0, %if.then4773 ], [ %yystate.0, %yyerrlab ]
  %cmp4776 = icmp eq i32 %yyerrstatus.3, 3
  br i1 %cmp4776, label %if.then4778, label %if.end4788

if.then4778:                                      ; preds = %yyerrlab1
  %1294 = load i32, i32* @yychar, align 4, !tbaa !16
  %cmp4779 = icmp eq i32 %1294, 0
  br i1 %cmp4779, label %cleanup4861, label %if.end4782

if.end4782:                                       ; preds = %if.then4778
  %1295 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool4783.not = icmp eq i32 %1295, 0
  br i1 %tobool4783.not, label %if.end4787, label %if.then4784

if.then4784:                                      ; preds = %if.end4782
  %1296 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %arrayidx4785 = getelementptr inbounds [290 x i8*], [290 x i8*]* @yytname, i32 0, i32 %yychar1.5
  %1297 = load i8*, i8** %arrayidx4785, align 4, !tbaa !15
  %call4786 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1296, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.57.2734, i32 0, i32 0), i32 %1294, i8* %1297) #25
  br label %if.end4787

if.end4787:                                       ; preds = %if.then4784, %if.end4782
  store i32 -2, i32* @yychar, align 4, !tbaa !16
  br label %if.end4788

if.end4788:                                       ; preds = %if.end4787, %yyerrlab1
  %add.ptr4799 = getelementptr inbounds i16, i16* %yyss.2, i32 -1
  br label %yyerrhandle

yyerrpop:                                         ; preds = %if.else4840, %if.then4834, %lor.lhs.false4823, %if.end4816, %yyerrhandle
  %cmp4789 = icmp eq i16* %yyssp.5, %yyss.2
  br i1 %cmp4789, label %cleanup4861, label %if.end4792

if.end4792:                                       ; preds = %yyerrpop
  %incdec.ptr4793 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.5, i32 -1
  %incdec.ptr4794 = getelementptr inbounds i16, i16* %yyssp.5, i32 -1
  %1298 = load i16, i16* %incdec.ptr4794, align 2, !tbaa !34
  %conv4795 = sext i16 %1298 to i32
  %1299 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool4796.not = icmp eq i32 %1299, 0
  br i1 %tobool4796.not, label %yyerrhandle.backedge, label %while.body4804.preheader

while.body4804.preheader:                         ; preds = %if.end4792
  %1300 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %1301 = call i32 @fwrite(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.58.2735, i32 0, i32 0), i32 22, i32 1, %struct._IO_FILE* %1300) #24
  br label %while.body4804

while.body4804:                                   ; preds = %while.body4804, %while.body4804.preheader
  %ssp14798.05807 = phi i16* [ %incdec.ptr4805, %while.body4804 ], [ %add.ptr4799, %while.body4804.preheader ]
  %1302 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %incdec.ptr4805 = getelementptr inbounds i16, i16* %ssp14798.05807, i32 1
  %1303 = load i16, i16* %incdec.ptr4805, align 2, !tbaa !34
  %conv4806 = sext i16 %1303 to i32
  %call4807 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1302, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.54.2732, i32 0, i32 0), i32 %conv4806) #25
  %cmp4802.not = icmp eq i16* %incdec.ptr4805, %incdec.ptr4794
  br i1 %cmp4802.not, label %while.end4808, label %while.body4804, !llvm.loop !70

while.end4808:                                    ; preds = %while.body4804
  %1304 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %fputc = call i32 @fputc(i32 10, %struct._IO_FILE* %1304)
  br label %yyerrhandle.backedge

yyerrhandle.backedge:                             ; preds = %while.end4808, %if.end4792
  br label %yyerrhandle

yyerrhandle:                                      ; preds = %yyerrhandle.backedge, %if.end4788
  %yyvsp.5 = phi %union.anon.2* [ %yyvsp.4, %if.end4788 ], [ %incdec.ptr4793, %yyerrhandle.backedge ]
  %yyssp.5 = phi i16* [ %yyssp.4, %if.end4788 ], [ %incdec.ptr4794, %yyerrhandle.backedge ]
  %yystate.4 = phi i32 [ %yystate.3, %if.end4788 ], [ %conv4795, %yyerrhandle.backedge ]
  %arrayidx4811 = getelementptr inbounds [901 x i16], [901 x i16]* @yypact, i32 0, i32 %yystate.4
  %1305 = load i16, i16* %arrayidx4811, align 2, !tbaa !34
  %cmp4813 = icmp eq i16 %1305, -32768
  br i1 %cmp4813, label %yyerrpop, label %if.end4816

if.end4816:                                       ; preds = %yyerrhandle
  %conv4812 = sext i16 %1305 to i32
  %add4817 = add nsw i32 %conv4812, 1
  %cmp4818 = icmp slt i16 %1305, -1
  br i1 %cmp4818, label %yyerrpop, label %lor.lhs.false4823

lor.lhs.false4823:                                ; preds = %if.end4816
  %arrayidx4824 = getelementptr inbounds [3206 x i16], [3206 x i16]* @yycheck, i32 0, i32 %add4817
  %1306 = load i16, i16* %arrayidx4824, align 2, !tbaa !34
  %cmp4826.not = icmp eq i16 %1306, 1
  br i1 %cmp4826.not, label %if.end4829, label %yyerrpop

if.end4829:                                       ; preds = %lor.lhs.false4823
  %arrayidx4830 = getelementptr inbounds [3206 x i16], [3206 x i16]* @yytable, i32 0, i32 %add4817
  %1307 = load i16, i16* %arrayidx4830, align 2, !tbaa !34
  %cmp4832 = icmp slt i16 %1307, 0
  br i1 %cmp4832, label %if.then4834, label %if.else4840

if.then4834:                                      ; preds = %if.end4829
  %cmp4835 = icmp eq i16 %1307, -32768
  br i1 %cmp4835, label %yyerrpop, label %if.end4838

if.end4838:                                       ; preds = %if.then4834
  %conv4831.le = sext i16 %1307 to i32
  %sub4839 = sub nsw i32 0, %conv4831.le
  br label %yyreduce

if.else4840:                                      ; preds = %if.end4829
  switch i16 %1307, label %if.end4849 [
    i16 0, label %yyerrpop
    i16 900, label %cleanup4861
  ]

if.end4849:                                       ; preds = %if.else4840
  %conv4831.le58085851 = zext i16 %1307 to i32
  %1308 = load i32, i32* @yydebug, align 4, !tbaa !16
  %tobool4850.not = icmp eq i32 %1308, 0
  br i1 %tobool4850.not, label %if.end4853, label %if.then4851

if.then4851:                                      ; preds = %if.end4849
  %1309 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 4, !tbaa !15
  %1310 = call i32 @fwrite(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.59.2736, i32 0, i32 0), i32 22, i32 1, %struct._IO_FILE* %1309) #24
  br label %if.end4853

if.end4853:                                       ; preds = %if.then4851, %if.end4849
  %incdec.ptr4854 = getelementptr inbounds %union.anon.2, %union.anon.2* %yyvsp.5, i32 1
  %1311 = getelementptr %union.anon.2, %union.anon.2* %incdec.ptr4854, i32 0, i32 0
  %1312 = load i32, i32* getelementptr inbounds (%union.anon.2, %union.anon.2* @yylval, i32 0, i32 0), align 4
  store i32 %1312, i32* %1311, align 4
  br label %yynewstate.backedge

cleanup4861:                                      ; preds = %if.else4840, %yyerrpop, %if.then4778, %if.else95, %if.end28, %cleanup.thread
  %retval.3 = phi i32 [ 2, %cleanup.thread ], [ 1, %yyerrpop ], [ 0, %if.else4840 ], [ 1, %if.then4778 ], [ 1, %if.end28 ], [ 0, %if.else95 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %2) #22
  call void @llvm.lifetime.end.p0i8(i64 800, i8* nonnull %1) #22
  call void @llvm.lifetime.end.p0i8(i64 400, i8* nonnull %0) #22
  ret i32 %retval.3
}

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @yyerror(i8*) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc i32 @yylex() unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare hidden fastcc void @yyprint(%struct._IO_FILE* nocapture, i32, %union.anon.2* nocapture readonly byval(%union.anon.2) align 4) unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @make_pointer_declarator(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @mark_elimination(i32, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @delete_insn(%struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @push_function_context() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @pop_function_context() local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i64 @get_frame_size() local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @assign_stack_local(i32, i64, i32) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i32 @global_bindings_p() local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn writeonly
declare void @keep_next_level() local_unnamed_addr #7

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i32 @kept_level_p() local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn
declare void @declare_parm_level(i32) local_unnamed_addr #13

; Function Attrs: noinline nounwind optsize
declare void @pushlevel(i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @poplevel(i32, i32, i32) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare %union.tree_node* @getdecls() local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @define_label(i8*, i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @lookup_label(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare %union.tree_node* @lookup_name(%union.tree_node* nocapture readonly) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @shadow_label(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @push_label_level() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @pop_label_level() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @pending_xref_error() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @finish_decl(%union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @shadow_tag(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @shadow_tag_warned(%union.tree_node*, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_array_declarator(%union.tree_node*, %union.tree_node*, i32, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @set_array_declarator_type(%union.tree_node* returned, %union.tree_node*, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @groktypename(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @start_decl(%union.tree_node*, %union.tree_node*, i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @push_parm_decl(%union.tree_node* nocapture readonly) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn
declare void @clear_parm_order() local_unnamed_addr #13

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_compound_literal(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @get_parm_info(i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @parmlist_tags_warning() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @xref_tag(i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @start_struct(i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @grokfield(i8* nocapture readnone, i32, %union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @finish_struct(%union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @start_enum(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @finish_enum(%union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_enumerator(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare i32 @start_function(%union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn writeonly
declare void @c_mark_varargs() local_unnamed_addr #7

; Function Attrs: noinline nounwind optsize
declare void @store_parm_decls() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @finish_function(i32, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @check_for_loop_decls() local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone willreturn
declare nonnull %struct.stmt_tree_s* @current_stmt_tree() local_unnamed_addr #14

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_begin_compound_stmt() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @convert(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare noalias i8* @xmalloc(i32) #8

; Function Attrs: noinline nounwind optsize
declare noalias i8* @xcalloc(i32, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_int_2_wide(i64, i64) local_unnamed_addr #8

; Function Attrs: nofree noinline nosync nounwind optsize readonly
declare i32 @integer_zerop(%union.tree_node* nocapture readonly) local_unnamed_addr #15

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare %union.tree_node* @chainon(%union.tree_node*, %union.tree_node*) local_unnamed_addr #11

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare %union.tree_node* @nreverse(%union.tree_node*) local_unnamed_addr #11

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @tree_cons(%union.tree_node*, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_tree_list(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare i64 @tree_low_cst(%union.tree_node* nocapture readonly, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @save_expr(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build1(i32, %union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_nt(i32, ...) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @assemble_asm(%union.tree_node* nocapture readonly) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn
declare i32 @function_invariant_p(%struct.rtx_def* readonly) local_unnamed_addr #10

; Function Attrs: nofree noinline nosync nounwind optsize readonly
declare %struct.rtx_def* @single_set_2(%struct.rtx_def* nocapture readonly, %struct.rtx_def* nocapture readonly) local_unnamed_addr #15

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readonly
declare %struct.rtx_def* @find_reg_note(%struct.rtx_def* nocapture readonly, i32, %struct.rtx_def* readnone) local_unnamed_addr #16

; Function Attrs: noinline nounwind optsize
declare i32 @reg_set_p(%struct.rtx_def*, %struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @note_stores(%struct.rtx_def*, void (%struct.rtx_def*, %struct.rtx_def*, i8*)* nocapture, i8*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @add_stmt(%union.tree_node* returned) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @add_decl_stmt(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_stmt(i32, ...) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @add_scope_stmt(i32, i32) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_break_stmt() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_continue_stmt() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @finish_file() local_unnamed_addr #8

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare void @bitmap_clear(%struct.bitmap_head_def* nocapture) local_unnamed_addr #11

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare void @bitmap_clear_bit(%struct.bitmap_head_def* nocapture, i32) local_unnamed_addr #11

; Function Attrs: noinline nounwind optsize
declare void @cleanup_subreg_operands(%struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @c_expand_start_cond(%union.tree_node*, i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @c_finish_then() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @c_expand_end_cond() local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn
declare void @c_expand_start_else() local_unnamed_addr #13

; Function Attrs: noinline nounwind optsize
declare void @c_finish_else() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_begin_if_stmt() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_begin_while_stmt() local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn writeonly
declare void @c_finish_while_stmt_cond(%union.tree_node*, %union.tree_node* nocapture) local_unnamed_addr #7

; Function Attrs: noinline nounwind optsize
declare void @finish_fname_decls() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @fname_decl(i32, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @combine_strings(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @overflow_warning(%union.tree_node* nocapture) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_expand_expr_stmt(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @truthvalue_conversion(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_alignof(%union.tree_node* nocapture readonly) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @c_alignof_expr(%union.tree_node* nocapture readonly) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @build_va_arg(%union.tree_node*, %union.tree_node*) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @finish_label_address_expr(%union.tree_node*) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize willreturn
declare void @clear_last_expr() local_unnamed_addr #13

; Function Attrs: noinline noreturn nounwind optsize
declare void @fancy_abort(i8*, i32, i8*) local_unnamed_addr #17

; Function Attrs: noinline nounwind optsize
declare void @pedwarn(i8*, ...) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @error(i8*, ...) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone willreturn
declare void @warning_with_file_and_line(i8* nocapture, i32, i8* nocapture, ...) local_unnamed_addr #14

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone willreturn
declare void @warning(i8* nocapture, ...) local_unnamed_addr #14

; Function Attrs: noinline nounwind optsize
declare i32 @strict_memory_address_p(i32, %struct.rtx_def*) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize willreturn writeonly
declare void @clear_secondary_mem() local_unnamed_addr #18

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare void @init_save_areas() local_unnamed_addr #11

; Function Attrs: noinline nounwind optsize
declare void @setup_save_areas() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare void @save_call_clobbered_regs() local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %struct.rtx_def* @copy_rtx(%struct.rtx_def* readonly) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare i32 @rtx_equal_p(%struct.rtx_def* readonly, %struct.rtx_def* readonly) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize
declare %union.tree_node* @decl_attributes(%union.tree_node**, %union.tree_node*, i32) local_unnamed_addr #8

; Function Attrs: nofree noinline norecurse nosync nounwind optsize
declare void @split_specs_attrs(%union.tree_node*, %union.tree_node** nocapture, %union.tree_node** nocapture) local_unnamed_addr #11

; Function Attrs: nofree noinline nosync nounwind optsize readonly
declare i32 @symbolic_reference_mentioned_p(%struct.rtx_def* nocapture readonly) local_unnamed_addr #15

; Function Attrs: mustprogress nofree noinline nounwind optsize readonly willreturn
declare i32 @legitimate_pic_address_disp_p(%struct.rtx_def* nocapture readonly) local_unnamed_addr #19

attributes #0 = { nofree nounwind }
attributes #1 = { nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { argmemonly nofree nosync nounwind willreturn }
attributes #4 = { inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { argmemonly nofree nounwind willreturn writeonly }
attributes #6 = { optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nofree noinline norecurse nosync nounwind optsize willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { noinline nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { argmemonly mustprogress nofree nounwind optsize readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { mustprogress nofree noinline norecurse nosync nounwind optsize readonly willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { nofree noinline norecurse nosync nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { nofree noinline nosync nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { mustprogress nofree noinline norecurse nosync nounwind optsize willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #14 = { mustprogress nofree noinline norecurse nosync nounwind optsize readnone willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #15 = { nofree noinline nosync nounwind optsize readonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #16 = { nofree noinline norecurse nosync nounwind optsize readonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #17 = { noinline noreturn nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #18 = { mustprogress nofree noinline nosync nounwind optsize willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #19 = { mustprogress nofree noinline nounwind optsize readonly willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #20 = { nounwind optsize }
attributes #21 = { optsize }
attributes #22 = { nounwind }
attributes #23 = { noreturn nounwind optsize }
attributes #24 = { cold }
attributes #25 = { cold optsize }
attributes #26 = { nounwind optsize readonly willreturn }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"NumRegisterParameters", i32 0}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"PIC Level", i32 2}
!4 = !{!5, !9, i64 16}
!5 = !{!"obstack", !6, i64 0, !9, i64 4, !9, i64 8, !9, i64 12, !9, i64 16, !10, i64 20, !10, i64 24, !9, i64 28, !9, i64 32, !9, i64 36, !10, i64 40, !10, i64 40, !10, i64 40}
!6 = !{!"long", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"any pointer", !7, i64 0}
!10 = !{!"int", !7, i64 0}
!11 = !{!5, !9, i64 12}
!12 = !{!5, !9, i64 8}
!13 = !{!5, !10, i64 24}
!14 = !{!5, !9, i64 4}
!15 = !{!9, !9, i64 0}
!16 = !{!10, !10, i64 0}
!17 = distinct !{!17, !18}
!18 = !{!"llvm.loop.unroll.disable"}
!19 = !{!7, !7, i64 0}
!20 = distinct !{!20, !18}
!21 = !{!22, !22, i64 0}
!22 = !{!"long long", !7, i64 0}
!23 = distinct !{!23, !18}
!24 = distinct !{!24, !18}
!25 = distinct !{!25, !18}
!26 = distinct !{!26, !18}
!27 = !{!28, !10, i64 12}
!28 = !{!"elim_table", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !9, i64 32, !9, i64 36}
!29 = !{!28, !10, i64 0}
!30 = distinct !{!30, !18}
!31 = !{!32, !10, i64 236}
!32 = !{!"function", !9, i64 0, !9, i64 4, !9, i64 8, !9, i64 12, !9, i64 16, !9, i64 20, !9, i64 24, !9, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !9, i64 48, !33, i64 52, !9, i64 80, !9, i64 84, !9, i64 88, !9, i64 92, !10, i64 96, !9, i64 100, !9, i64 104, !9, i64 108, !9, i64 112, !9, i64 116, !9, i64 120, !9, i64 124, !9, i64 128, !9, i64 132, !9, i64 136, !9, i64 140, !9, i64 144, !9, i64 148, !22, i64 152, !9, i64 160, !9, i64 164, !9, i64 168, !9, i64 172, !10, i64 176, !9, i64 180, !9, i64 184, !10, i64 188, !10, i64 192, !10, i64 196, !9, i64 200, !10, i64 204, !10, i64 208, !9, i64 212, !9, i64 216, !9, i64 220, !10, i64 224, !10, i64 228, !9, i64 232, !10, i64 236, !10, i64 240, !9, i64 244, !9, i64 248, !10, i64 252, !10, i64 252, !10, i64 252, !10, i64 252, !10, i64 252, !10, i64 252, !10, i64 252, !10, i64 252, !10, i64 253, !10, i64 253, !10, i64 253, !10, i64 253, !10, i64 253, !10, i64 253, !10, i64 253, !10, i64 253, !10, i64 254, !10, i64 254, !10, i64 254, !10, i64 254, !10, i64 254, !10, i64 254, !10, i64 254, !10, i64 254}
!33 = !{!"ix86_args", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24}
!34 = !{!35, !35, i64 0}
!35 = !{!"short", !7, i64 0}
!36 = !{!32, !9, i64 12}
!37 = !{!38, !9, i64 48}
!38 = !{!"emit_status", !10, i64 0, !10, i64 4, !9, i64 8, !9, i64 12, !9, i64 16, !9, i64 20, !10, i64 24, !10, i64 28, !9, i64 32, !10, i64 36, !9, i64 40, !9, i64 44, !9, i64 48}
!39 = distinct !{!39, !18}
!40 = distinct !{!40, !18}
!41 = distinct !{!41, !18}
!42 = !{!28, !10, i64 4}
!43 = distinct !{!43, !18}
!44 = distinct !{!44, !18}
!45 = distinct !{!45, !18}
!46 = !{!47, !9, i64 32}
!47 = !{!"basic_block_def", !9, i64 0, !9, i64 4, !9, i64 8, !9, i64 12, !9, i64 16, !9, i64 20, !9, i64 24, !9, i64 28, !9, i64 32, !9, i64 36, !9, i64 40, !10, i64 44, !10, i64 48, !22, i64 52, !10, i64 60, !10, i64 64}
!48 = distinct !{!48, !18}
!49 = distinct !{!49, !18}
!50 = distinct !{!50, !18}
!51 = distinct !{!51, !18}
!52 = distinct !{!52, !18}
!53 = distinct !{!53, !18}
!54 = distinct !{!54, !18}
!55 = distinct !{!55, !18}
!56 = distinct !{!56, !18}
!57 = !{!58, !7, i64 23}
!58 = !{!"c_common_identifier", !59, i64 0, !60, i64 12}
!59 = !{!"tree_common", !9, i64 0, !9, i64 4, !7, i64 8, !10, i64 9, !10, i64 9, !10, i64 9, !10, i64 9, !10, i64 9, !10, i64 9, !10, i64 9, !10, i64 9, !10, i64 10, !10, i64 10, !10, i64 10, !10, i64 10, !10, i64 10, !10, i64 10, !10, i64 10, !10, i64 10, !10, i64 11, !10, i64 11, !10, i64 11, !10, i64 11, !10, i64 11, !10, i64 11, !10, i64 11, !10, i64 11}
!60 = !{!"cpp_hashnode", !61, i64 0, !35, i64 8, !7, i64 10, !7, i64 11, !7, i64 12, !7, i64 13, !7, i64 16}
!61 = !{!"ht_identifier", !10, i64 0, !9, i64 4}
!62 = !{!63, !9, i64 0}
!63 = !{!"stmt_tree_s", !9, i64 0, !9, i64 4, !9, i64 8, !10, i64 12}
!64 = !{!63, !9, i64 4}
!65 = distinct !{!65, !18}
!66 = distinct !{!66, !18}
!67 = distinct !{!67, !18}
!68 = distinct !{!68, !18}
!69 = distinct !{!69, !18}
!70 = distinct !{!70, !18}
