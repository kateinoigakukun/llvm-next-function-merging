; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-size-estimation=exact -func-merging-explore=1 -pass-remarks-output=%t.mfm2-hyfm.yaml -pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm2-hyfm.bc %s
; RUN: %opt --passes="mergefunc,multiple-func-merging" --multiple-func-merging-size-estimation=exact -func-merging-explore=2 -pass-remarks-output=%t.mfm3-hyfm.yaml -pass-remarks-filter=multiple-func-merging --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm3-hyfm.bc %s
; RUN: %llc --filetype=obj %t.mfm2-hyfm.bc -o %t.mfm2-hyfm.o
; RUN: %llc --filetype=obj %t.mfm3-hyfm.bc -o %t.mfm3-hyfm.o
; RUN: test $(stat -c%%s %t.mfm3-hyfm.o) -gt $(stat -c%%s %t.mfm2-hyfm.o)

; ModuleID = '/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/test/Transforms/NextFM/HyFM/spec2006/433.milc/main_._all_._files_._linked.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.params = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, double, double, double, i32, double, double, double, i32, i32, i32, i32, i32, [256 x i8], [256 x i8] }
%struct.gauge_file = type { %struct._IO_FILE*, %struct.gauge_header*, i8*, i32, i32*, i32, %struct.gauge_check }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.gauge_header = type { i32, [64 x i8], [4 x i32], i32, i32 }
%struct.gauge_check = type { i32, i32 }
%struct.su3_vector = type { [3 x %struct.complex] }
%struct.complex = type { double, double }
%struct.su3_matrix = type { [3 x [3 x %struct.complex]] }
%struct.anon = type { [7 x i32], i32, double, double }
%struct.double_prn = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, double }
%struct.site = type { i16, i16, i16, i16, i8, i32, %struct.double_prn, i32, [4 x %struct.su3_matrix], [4 x %struct.su3_matrix], [4 x %struct.su3_matrix], [4 x %struct.anti_hermitmat], [4 x double], %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, %struct.su3_vector, [4 x %struct.su3_vector], [4 x %struct.su3_vector], %struct.su3_vector, %struct.su3_matrix, %struct.su3_matrix }
%struct.anti_hermitmat = type { %struct.complex, %struct.complex, %struct.complex, double, double, double, double }
%struct.su2_matrix = type { [2 x [2 x %struct.complex]] }
%struct.msg_tag = type { i32, i32, i8*, i32 }
%struct.wilson_vector = type { [4 x %struct.su3_vector] }
%struct.half_wilson_vector = type { [2 x %struct.su3_vector] }
%struct.QCDheader = type { i32, i8**, i8** }

@.str.1 = private unnamed_addr constant [41 x i8] c"%d %d  ( %.4e , %.4e )  ( %.4e , %.4e )\0A\00", align 1
@.str.2 = private unnamed_addr constant [37 x i8] c"Inversion checked, frac. error = %e\0A\00", align 1
@str = private unnamed_addr constant [6 x i8] c"BOTCH\00", align 1
@.str = private unnamed_addr constant [19 x i8] c"action.description\00", align 1
@.str.1.1 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.2.2 = private unnamed_addr constant [32 x i8] c"\22Gauge plus fermion (improved)\22\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"gauge.description\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"gauge.nloops\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"gauge.nreps\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"gauge.beta11\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@.str.9 = private unnamed_addr constant [17 x i8] c"gauge.tadpole.u0\00", align 1
@.str.10 = private unnamed_addr constant [18 x i8] c"quark.description\00", align 1
@quark_action_description = internal global [72 x i8] c"\22O(a^2): couplings(pi)=0, Naik term, No O(a^2) errors, tadpole weights\22\00", align 16
@.str.11 = private unnamed_addr constant [14 x i8] c"quark.flavors\00", align 1
@.str.12 = private unnamed_addr constant [11 x i8] c"quark.mass\00", align 1
@gauge_action_nloops = global i32 3, align 4
@gauge_action_nreps = global i32 1, align 4
@make_loop_table.loop_ind = internal unnamed_addr constant [3 x [6 x i32]] [[6 x i32] [i32 0, i32 1, i32 7, i32 6, i32 -1, i32 -1], [6 x i32] [i32 0, i32 0, i32 1, i32 7, i32 7, i32 6], [6 x i32] [i32 0, i32 1, i32 2, i32 7, i32 6, i32 5]], align 16
@make_loop_table.loop_length_in = internal unnamed_addr constant [3 x i32] [i32 4, i32 6, i32 6], align 4
@loop_num = local_unnamed_addr global [3 x i32] zeroinitializer, align 4
@loop_length = local_unnamed_addr global [3 x i32] zeroinitializer, align 4
@loop_coeff = local_unnamed_addr global [3 x [1 x double]] zeroinitializer, align 16
@gauge_action_description = global [128 x i8] zeroinitializer, align 16
@.str.13 = private unnamed_addr constant [36 x i8] c"\22Symanzik 1x1 + 1x2 + 1x1x1 action\22\00", align 1
@loop_char = local_unnamed_addr global [16 x i32] zeroinitializer, align 16
@loop_table = global [3 x [16 x [6 x i32]]] zeroinitializer, align 16
@.str.4.17 = private unnamed_addr constant [42 x i8] c"                    %d %d      %e     %d\0A\00", align 1
@.str.5.18 = private unnamed_addr constant [13 x i8] c"PLAQ:\09%f\09%f\0A\00", align 1
@.str.6.19 = private unnamed_addr constant [15 x i8] c"P_LOOP:\09%e\09%e\0A\00", align 1
@.str.7.20 = private unnamed_addr constant [23 x i8] c"G_LOOP:  %d  %d  %d   \00", align 1
@.str.8.21 = private unnamed_addr constant [4 x i8] c"\09%e\00", align 1
@.str.9.22 = private unnamed_addr constant [4 x i8] c"\09( \00", align 1
@.str.10.23 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.12.25 = private unnamed_addr constant [13 x i8] c"GACTION: %e\0A\00", align 1
@.str.13.26 = private unnamed_addr constant [13 x i8] c",  L = %d )\0A\00", align 1
@loop_ind = local_unnamed_addr global [3 x [6 x i32]] zeroinitializer, align 16
@loop_expect = local_unnamed_addr global [3 x [1 x [16 x double]]] zeroinitializer, align 16
@str.16 = private unnamed_addr constant [54 x i8] c"loop coefficients: nloop rep loop_coeff  multiplicity\00", align 1
@str.14 = private unnamed_addr constant [24 x i8] c"OOPS: MAX_NUM too small\00", align 1
@str.15 = private unnamed_addr constant [34 x i8] c"Symanzik 1x1 + 1x2 + 1x1x1 action\00", align 1
@str.16.24 = private unnamed_addr constant [3 x i8] c" )\00", align 1
@.str.7.28 = private unnamed_addr constant [29 x i8] c"Machine = %s, with %d nodes\0A\00", align 1
@.str.9.29 = private unnamed_addr constant [9 x i8] c"nflavors\00", align 1
@par_buf = global %struct.params zeroinitializer, align 8
@.str.10.30 = private unnamed_addr constant [3 x i8] c"nx\00", align 1
@.str.11.31 = private unnamed_addr constant [3 x i8] c"ny\00", align 1
@.str.12.32 = private unnamed_addr constant [3 x i8] c"nz\00", align 1
@.str.13.33 = private unnamed_addr constant [3 x i8] c"nt\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"iseed\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"warms\00", align 1
@.str.17 = private unnamed_addr constant [8 x i8] c"trajecs\00", align 1
@.str.18 = private unnamed_addr constant [18 x i8] c"traj_between_meas\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"beta\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"mass\00", align 1
@.str.21 = private unnamed_addr constant [3 x i8] c"u0\00", align 1
@.str.22 = private unnamed_addr constant [25 x i8] c"microcanonical_time_step\00", align 1
@.str.23 = private unnamed_addr constant [21 x i8] c"steps_per_trajectory\00", align 1
@.str.24 = private unnamed_addr constant [18 x i8] c"max_cg_iterations\00", align 1
@.str.25 = private unnamed_addr constant [15 x i8] c"error_per_site\00", align 1
@.str.26 = private unnamed_addr constant [21 x i8] c"error_for_propagator\00", align 1
@gf = local_unnamed_addr global %struct.gauge_file* null, align 8
@str.27 = private unnamed_addr constant [15 x i8] c"Finished setup\00", align 1
@str.28 = private unnamed_addr constant [17 x i8] c"Made 3nn gathers\00", align 1
@str.29 = private unnamed_addr constant [16 x i8] c"Made nn gathers\00", align 1
@str.30 = private unnamed_addr constant [13 x i8] c"Made lattice\00", align 1
@str.31 = private unnamed_addr constant [28 x i8] c"SU3 with improved KS action\00", align 1
@str.32 = private unnamed_addr constant [42 x i8] c"Microcanonical simulation with refreshing\00", align 1
@str.33 = private unnamed_addr constant [15 x i8] c"MIMD version 6\00", align 1
@str.34 = private unnamed_addr constant [12 x i8] c"R algorithm\00", align 1
@str.35 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@str.36 = private unnamed_addr constant [28 x i8] c"third_neighb: bad direction\00", align 1
@neighbor = local_unnamed_addr global i32** null, align 8
@n_gathers = local_unnamed_addr global i32 0, align 4
@.str.2.43 = private unnamed_addr constant [38 x i8] c"NODE %d: no room for neighbor vector\0A\00", align 1
@.str.4.47 = private unnamed_addr constant [38 x i8] c"It mapped %d %d %d %d to %d %d %d %d\0A\00", align 1
@.str.7.49 = private unnamed_addr constant [47 x i8] c"It's square mapped %d %d %d %d to %d %d %d %d\0A\00", align 1
@g_gather_flag = local_unnamed_addr global i32 0, align 4
@.str.8.65 = private unnamed_addr constant [48 x i8] c"ERROR: node %d, two general_gathers() at once!\0A\00", align 1
@name = internal global [17 x i8] c"Scalar processor\00", align 16
@.str.10.52 = private unnamed_addr constant [8 x i8] c"%s: %s\0A\00", align 1
@.str.11.50 = private unnamed_addr constant [12 x i8] c"termination\00", align 1
@.str.12.51 = private unnamed_addr constant [26 x i8] c"Termination: status = %d\0A\00", align 1
@str.48 = private unnamed_addr constant [50 x i8] c"DUMMY! Your gather mapping is not its own inverse\00", align 1
@str.13 = private unnamed_addr constant [56 x i8] c"DUMMY! Your gather mapping does not obey claimed parity\00", align 1
@str.14.46 = private unnamed_addr constant [52 x i8] c"DUMMY! Your gather mapping does not stay in lattice\00", align 1
@str.15.42 = private unnamed_addr constant [37 x i8] c"Too many gathers! change MAX_GATHERS\00", align 1
@str.17 = private unnamed_addr constant [21 x i8] c"BOTCH: bad direction\00", align 1
@str.21 = private unnamed_addr constant [26 x i8] c"BOTCH: this never happens\00", align 1
@temp_not_allocated = internal unnamed_addr global i1 false, align 4
@temp = internal unnamed_addr global [9 x %struct.su3_vector*] zeroinitializer, align 16
@diffmat_offset = local_unnamed_addr global i32 0, align 4
@diffmatp = local_unnamed_addr global %struct.su3_matrix* null, align 8
@sumvec_offset = local_unnamed_addr global i32 0, align 4
@sumvecp = local_unnamed_addr global %struct.su3_vector* null, align 8
@.str.2.93 = private unnamed_addr constant [55 x i8] c"GFIX: Ended at step %d. Av gf action %.8e, delta %.3e\0A\00", align 1
@str.92 = private unnamed_addr constant [30 x i8] c"gaugefix: Can't malloc sumvec\00", align 1
@str.3 = private unnamed_addr constant [31 x i8] c"gaugefix: Can't malloc diffmat\00", align 1
@.str.1.95 = private unnamed_addr constant [19 x i8] c"Time to save = %e\0A\00", align 1
@.str.2.96 = private unnamed_addr constant [19 x i8] c"CHECK PLAQ: %e %e\0A\00", align 1
@.str.3.99 = private unnamed_addr constant [34 x i8] c"reload_lattice: Bad startflag %d\0A\00", align 1
@.str.4.100 = private unnamed_addr constant [41 x i8] c"Time to reload gauge configuration = %e\0A\00", align 1
@.str.5.101 = private unnamed_addr constant [40 x i8] c"Unitarity checked.  Max deviation %.2e\0A\00", align 1
@.str.7.104 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.9.105 = private unnamed_addr constant [4 x i8] c"%s \00", align 1
@.str.10.106 = private unnamed_addr constant [6 x i8] c"fresh\00", align 1
@.str.12.107 = private unnamed_addr constant [9 x i8] c"continue\00", align 1
@.str.13.108 = private unnamed_addr constant [13 x i8] c"reload_ascii\00", align 1
@.str.14.109 = private unnamed_addr constant [14 x i8] c"reload_serial\00", align 1
@.str.15 = private unnamed_addr constant [16 x i8] c"reload_parallel\00", align 1
@.str.16.110 = private unnamed_addr constant [69 x i8] c"ask_starting_lattice: ERROR IN INPUT: lattice_command %s is invalid\0A\00", align 1
@.str.22.113 = private unnamed_addr constant [11 x i8] c"save_ascii\00", align 1
@.str.23.114 = private unnamed_addr constant [12 x i8] c"save_serial\00", align 1
@.str.24.115 = private unnamed_addr constant [14 x i8] c"save_parallel\00", align 1
@.str.25.116 = private unnamed_addr constant [16 x i8] c"save_checkpoint\00", align 1
@.str.26.117 = private unnamed_addr constant [20 x i8] c"save_serial_archive\00", align 1
@.str.27 = private unnamed_addr constant [22 x i8] c"save_parallel_archive\00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"forget\00", align 1
@.str.29 = private unnamed_addr constant [70 x i8] c"ask_ending_lattice: ERROR IN INPUT: %s is not a save lattice command\0A\00", align 1
@.str.33 = private unnamed_addr constant [10 x i8] c"enter %s \00", align 1
@.str.34 = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.35 = private unnamed_addr constant [7 x i8] c"%s %g\0A\00", align 1
@.str.37 = private unnamed_addr constant [41 x i8] c"get_f: EOF on STDIN while expecting %s.\0A\00", align 1
@.str.38 = private unnamed_addr constant [36 x i8] c"get_f: Format error looking for %s\0A\00", align 1
@.str.39 = private unnamed_addr constant [49 x i8] c"get_f: ERROR IN INPUT: expected %s but found %s\0A\00", align 1
@.str.40 = private unnamed_addr constant [47 x i8] c"\0Aget_f: Expecting value for %s but found EOF.\0A\00", align 1
@.str.41 = private unnamed_addr constant [43 x i8] c"\0Aget_f: Format error reading value for %s\0A\00", align 1
@.str.42 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@.str.43 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.44 = private unnamed_addr constant [7 x i8] c"%s %d\0A\00", align 1
@.str.45 = private unnamed_addr constant [41 x i8] c"get_i: EOF on STDIN while expecting %s.\0A\00", align 1
@.str.46 = private unnamed_addr constant [36 x i8] c"get_i: Format error looking for %s\0A\00", align 1
@.str.47 = private unnamed_addr constant [49 x i8] c"get_i: ERROR IN INPUT: expected %s but found %s\0A\00", align 1
@.str.48 = private unnamed_addr constant [47 x i8] c"\0Aget_i: Expecting value for %s but found EOF.\0A\00", align 1
@.str.49 = private unnamed_addr constant [43 x i8] c"\0Aget_i: Format error reading value for %s\0A\00", align 1
@.str.50 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.51 = private unnamed_addr constant [7 x i8] c"%s %s\0A\00", align 1
@.str.52 = private unnamed_addr constant [41 x i8] c"get_s: EOF on STDIN while expecting %s.\0A\00", align 1
@.str.53 = private unnamed_addr constant [36 x i8] c"get_s: Format error looking for %s\0A\00", align 1
@.str.54 = private unnamed_addr constant [49 x i8] c"get_s: ERROR IN INPUT: expected %s but found %s\0A\00", align 1
@.str.55 = private unnamed_addr constant [47 x i8] c"\0Aget_s: Expecting value for %s but found EOF.\0A\00", align 1
@.str.56 = private unnamed_addr constant [43 x i8] c"\0Aget_s: Format error reading value for %s\0A\00", align 1
@.str.58 = private unnamed_addr constant [7 x i8] c"prompt\00", align 1
@str.94 = private unnamed_addr constant [53 x i8] c"save_lattice: ERROR: unknown type for saving lattice\00", align 1
@str.62 = private unnamed_addr constant [53 x i8] c"ask_starting_lattice: ERROR IN INPUT: file name read\00", align 1
@str.63 = private unnamed_addr constant [38 x i8] c"enter name of file containing lattice\00", align 1
@str.64 = private unnamed_addr constant [63 x i8] c"ask_starting_lattice: ERROR IN INPUT: starting lattice command\00", align 1
@str.65 = private unnamed_addr constant [81 x i8] c"enter 'continue', 'fresh', 'reload_ascii', 'reload_serial', or 'reload_parallel'\00", align 1
@str.66 = private unnamed_addr constant [50 x i8] c"ask_ending_lattice: ERROR IN INPUT: save filename\00", align 1
@str.67 = private unnamed_addr constant [15 x i8] c"enter filename\00", align 1
@str.68 = private unnamed_addr constant [59 x i8] c"ask_ending_lattice: ERROR IN INPUT: ending lattice command\00", align 1
@str.69 = private unnamed_addr constant [141 x i8] c"'forget' lattice at end,  'save_ascii', 'save_serial', 'save_parallel', 'save_checkpoint', 'save_serial_archive', or 'save_parallel_archive'\00", align 1
@str.70 = private unnamed_addr constant [32 x i8] c"unit gauge configuration loaded\00", align 1
@str.73 = private unnamed_addr constant [19 x i8] c"Data format error.\00", align 1
@str.74 = private unnamed_addr constant [40 x i8] c"type 0 for no prompts  or 1 for prompts\00", align 1
@str.75 = private unnamed_addr constant [43 x i8] c"get_prompt: ERROR IN INPUT: initial prompt\00", align 1
@gaussian_rand_no.iset = internal unnamed_addr global i1 false, align 4
@gaussian_rand_no.gset = internal unnamed_addr global double 0.000000e+00, align 8
@.str.126 = private unnamed_addr constant [18 x i8] c"Site %d %d %d %d\0A\00", align 1
@.str.1.127 = private unnamed_addr constant [16 x i8] c"%d %d\09%e\09%e\09%e\0A\00", align 1
@.str.140 = private unnamed_addr constant [32 x i8] c"LAYOUT = Hypercubes, options = \00", align 1
@.str.1.141 = private unnamed_addr constant [11 x i8] c"EVENFIRST,\00", align 1
@squaresize = local_unnamed_addr global [4 x i32] zeroinitializer, align 16
@nsquares = local_unnamed_addr global [4 x i32] zeroinitializer, align 16
@str.142 = private unnamed_addr constant [34 x i8] c"SORRY, CAN'T LAY OUT THIS LATTICE\00", align 1
@str.5 = private unnamed_addr constant [60 x i8] c"LAYOUT: Can't lay out this lattice, not enough factors of 2\00", align 1
@str.149 = private unnamed_addr constant [31 x i8] c"plaquette: can't malloc su3mat\00", align 1
@str.156 = private unnamed_addr constant [32 x i8] c"DUMMY: you fouled up the phases\00", align 1
@.str.159 = private unnamed_addr constant [38 x i8] c"PBP: mass %e     %e  %e ( %d of %d )\0A\00", align 1
@.str.1.160 = private unnamed_addr constant [38 x i8] c"FACTION: mass = %e,  %e ( %d of %d )\0A\00", align 1
@.str.165 = private unnamed_addr constant [59 x i8] c"CG not converged after %d iterations, res. = %e wanted %e\0A\00", align 1
@max_deviation = local_unnamed_addr global double 0.000000e+00, align 8
@av_deviation = local_unnamed_addr global double 0.000000e+00, align 8
@.str.180 = private unnamed_addr constant [60 x i8] c"Unitarity problem on node %d, site %d, dir %d tolerance=%e\0A\00", align 1
@.str.2.182 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str.5.183 = private unnamed_addr constant [6 x i8] c"%08x \00", align 1
@.str.8.186 = private unnamed_addr constant [62 x i8] c"reunitarize: Node %d unitarity problem, maximum deviation=%e\0A\00", align 1
@str.181 = private unnamed_addr constant [12 x i8] c"SU3 matrix:\00", align 1
@str.9 = private unnamed_addr constant [15 x i8] c"repeat in hex:\00", align 1
@str.10 = private unnamed_addr constant [5 x i8] c"  \0A \00", align 1
@str.12 = private unnamed_addr constant [32 x i8] c"Unitarity error count exceeded.\00", align 1
@quark_action_description.191 = internal global [72 x i8] c"\22O(a^2): couplings(pi)=0, Naik term, No O(a^2) errors, tadpole weights\22\00", align 16
@num_q_paths = local_unnamed_addr global i32 0, align 4
@num_basic_paths = local_unnamed_addr global i32 0, align 4
@path_coeff = internal unnamed_addr constant [6 x double] [double 6.250000e-01, double 0xBFA5555555555555, double -6.250000e-02, double 1.562500e-02, double 0xBF65555555555555, double -6.250000e-02], align 16
@path_length_in = internal unnamed_addr constant [6 x i32] [i32 1, i32 3, i32 3, i32 5, i32 7, i32 5], align 16
@act_path_coeff = internal unnamed_addr global [6 x double] zeroinitializer, align 16
@path_ind = internal global [6 x [7 x i32]] [[7 x i32] [i32 0, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 0], [7 x i32] [i32 0, i32 0, i32 0, i32 -1, i32 -1, i32 -1, i32 0], [7 x i32] [i32 1, i32 0, i32 6, i32 -1, i32 -1, i32 -1, i32 0], [7 x i32] [i32 1, i32 2, i32 0, i32 5, i32 6, i32 -1, i32 0], [7 x i32] [i32 1, i32 2, i32 3, i32 0, i32 4, i32 5, i32 6], [7 x i32] [i32 1, i32 1, i32 0, i32 6, i32 6, i32 -1, i32 0]], align 16
@.str.2.193 = private unnamed_addr constant [39 x i8] c"                    %d      %e     %d\0A\00", align 1
@q_paths = global [688 x %struct.anon] zeroinitializer, align 16
@path_num = local_unnamed_addr global [6 x i32] zeroinitializer, align 16
@str.192 = private unnamed_addr constant [51 x i8] c"path coefficients: npath  path_coeff  multiplicity\00", align 1
@str.6 = private unnamed_addr constant [24 x i8] c"OOPS: MAX_NUM too small\00", align 1
@str.7 = private unnamed_addr constant [38 x i8] c"BOTCH: load_longlinks needs phases in\00", align 1
@str.8 = private unnamed_addr constant [37 x i8] c"BOTCH: load_fatlinks needs phases in\00", align 1
@switch.table.path_transport_hwv.10 = private unnamed_addr constant [3 x i32] [i32 2, i32 1, i32 3], align 4
@.str.202 = private unnamed_addr constant [61 x i8] c"Unitarity problem on node %d, site %d, dir %d, deviation=%f\0A\00", align 1
@.str.2.204 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str.5.206 = private unnamed_addr constant [6 x i8] c"%08x \00", align 1
@.str.7.208 = private unnamed_addr constant [52 x i8] c"Unitarity problem on node %d, maximum deviation=%f\0A\00", align 1
@str.203 = private unnamed_addr constant [12 x i8] c"SU3 matrix:\00", align 1
@str.8.205 = private unnamed_addr constant [15 x i8] c"repeat in hex:\00", align 1
@str.9.207 = private unnamed_addr constant [5 x i8] c"  \0A \00", align 1
@.str.225 = private unnamed_addr constant [48 x i8] c"g_open: Node %d. Append not supported in PIOFS\0A\00", align 1
@.str.1.226 = private unnamed_addr constant [41 x i8] c"g_open: Node %d. mode %s not recognized\0A\00", align 1
@.str.2.227 = private unnamed_addr constant [37 x i8] c"g_open: Node %d error %d opening %s\0A\00", align 1
@.str.3.228 = private unnamed_addr constant [33 x i8] c"g_open: Node %d can't malloc fp\0A\00", align 1
@.str.231 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1.232 = private unnamed_addr constant [3 x i8] c"%x\00", align 1
@.str.2.233 = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.5.235 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.6.236 = private unnamed_addr constant [12 x i8] c"END_HEADER\0A\00", align 1
@.str.7.237 = private unnamed_addr constant [31 x i8] c"%s: Node %d %s write error %d\0A\00", align 1
@.str.8.238 = private unnamed_addr constant [39 x i8] c"%s: Node %d %s descrip,write error %d\0A\00", align 1
@.str.9.239 = private unnamed_addr constant [30 x i8] c"%s: Node %d %s read error %d\0A\00", align 1
@__const.pwrite_gauge_hdr.myname = private unnamed_addr constant [17 x i8] c"pwrite_gauge_hdr\00", align 16
@.str.10.240 = private unnamed_addr constant [13 x i8] c"magic_number\00", align 1
@.str.11.241 = private unnamed_addr constant [11 x i8] c"dimensions\00", align 1
@.str.12.242 = private unnamed_addr constant [11 x i8] c"time_stamp\00", align 1
@.str.13.243 = private unnamed_addr constant [6 x i8] c"order\00", align 1
@__const.swrite_gauge_hdr.myname = private unnamed_addr constant [17 x i8] c"swrite_gauge_hdr\00", align 16
@.str.14.246 = private unnamed_addr constant [57 x i8] c"write_gauge_info_item: WARNING: keyword %s not in table\0A\00", align 1
@.str.15.247 = private unnamed_addr constant [5 x i8] c"%s =\00", align 1
@.str.16.248 = private unnamed_addr constant [5 x i8] c"[%d]\00", align 1
@.str.23.249 = private unnamed_addr constant [50 x i8] c"write_gauge_info_item: Unrecognized data type %s\0A\00", align 1
@.str.25.250 = private unnamed_addr constant [6 x i8] c".info\00", align 1
@.str.26.251 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.27.257 = private unnamed_addr constant [54 x i8] c"write_gauge_info_file: Can't open ascii info file %s\0A\00", align 1
@.str.28.252 = private unnamed_addr constant [5 x i8] c"\22%s\22\00", align 1
@.str.29.253 = private unnamed_addr constant [6 x i8] c"%x %x\00", align 1
@.str.30 = private unnamed_addr constant [10 x i8] c"checksums\00", align 1
@.str.31 = private unnamed_addr constant [3 x i8] c"nx\00", align 1
@.str.32 = private unnamed_addr constant [3 x i8] c"ny\00", align 1
@.str.33.254 = private unnamed_addr constant [3 x i8] c"nz\00", align 1
@.str.34.255 = private unnamed_addr constant [3 x i8] c"nt\00", align 1
@.str.35.256 = private unnamed_addr constant [20 x i8] c"Wrote info file %s\0A\00", align 1
@__const.setup_input_gauge_file.myname = private unnamed_addr constant [23 x i8] c"setup_input_gauge_file\00", align 16
@.str.36 = private unnamed_addr constant [21 x i8] c"%s: Can't malloc gf\0A\00", align 1
@.str.37.258 = private unnamed_addr constant [21 x i8] c"%s: Can't malloc gh\0A\00", align 1
@__const.setup_output_gauge_file.myname = private unnamed_addr constant [24 x i8] c"setup_output_gauge_file\00", align 16
@__const.w_serial_i.myname = private unnamed_addr constant [11 x i8] c"w_serial_i\00", align 1
@.str.38.259 = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@.str.39.260 = private unnamed_addr constant [42 x i8] c"%s: Node %d can't open file %s, error %d\0A\00", align 1
@__const.read_checksum.myname = private unnamed_addr constant [14 x i8] c"read_checksum\00", align 1
@.str.40.261 = private unnamed_addr constant [9 x i8] c"checksum\00", align 1
@.str.41.262 = private unnamed_addr constant [54 x i8] c"%s: Checksum violation. Computed %x %x.  Read %x %x.\0A\00", align 1
@.str.42.263 = private unnamed_addr constant [20 x i8] c"Checksums %x %x OK\0A\00", align 1
@__const.write_checksum.myname = private unnamed_addr constant [15 x i8] c"write_checksum\00", align 1
@.str.43.264 = private unnamed_addr constant [17 x i8] c"Checksums %x %x\0A\00", align 1
@.str.46.265 = private unnamed_addr constant [50 x i8] c"w_serial: Node %d fseeko failed error %d file %s\0A\00", align 1
@.str.47.266 = private unnamed_addr constant [62 x i8] c"w_serial: Node %d gauge configuration write error %d file %s\0A\00", align 1
@.str.48.267 = private unnamed_addr constant [54 x i8] c"Saved gauge configuration serially to binary file %s\0A\00", align 1
@.str.49.268 = private unnamed_addr constant [15 x i8] c"Time stamp %s\0A\00", align 1
@.str.52.269 = private unnamed_addr constant [49 x i8] c"read_site_list: Node %d site list read error %d\0A\00", align 1
@__const.read_v3_gauge_hdr.myname = private unnamed_addr constant [18 x i8] c"read_v3_gauge_hdr\00", align 16
@.str.54.270 = private unnamed_addr constant [13 x i8] c"magic number\00", align 1
@.str.58.272 = private unnamed_addr constant [53 x i8] c"requires size of int32type(%d) = size of double(%d)\0A\00", align 1
@.str.59 = private unnamed_addr constant [49 x i8] c"read_v3_gauge_hdr: Incorrect lattice dimensions \00", align 1
@.str.60 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.61 = private unnamed_addr constant [3 x i8] c"c1\00", align 1
@.str.62 = private unnamed_addr constant [3 x i8] c"c2\00", align 1
@.str.63 = private unnamed_addr constant [40 x i8] c"Old format header parameters are %f %f\0A\00", align 1
@__const.read_1996_gauge_hdr.myname = private unnamed_addr constant [20 x i8] c"read_1996_gauge_hdr\00", align 16
@.str.67 = private unnamed_addr constant [51 x i8] c"read_1996_gauge_hdr: Incorrect lattice dimensions \00", align 1
@.str.68 = private unnamed_addr constant [12 x i8] c"header size\00", align 1
@.str.69 = private unnamed_addr constant [11 x i8] c"n_descript\00", align 1
@.str.70 = private unnamed_addr constant [55 x i8] c"read_1996_gauge_hdr: gauge field descriptor length %d\0A\00", align 1
@.str.71 = private unnamed_addr constant [29 x i8] c" exceeds allocated space %d\0A\00", align 1
@.str.72 = private unnamed_addr constant [8 x i8] c"descrip\00", align 1
@.str.73 = private unnamed_addr constant [26 x i8] c"gauge_field.descript: %s\0A\00", align 1
@.str.74 = private unnamed_addr constant [8 x i8] c"n_param\00", align 1
@.str.75 = private unnamed_addr constant [61 x i8] c"read_1996_gauge_hdr: gauge field parameter vector length %d\0A\00", align 1
@.str.76 = private unnamed_addr constant [12 x i8] c"gauge param\00", align 1
@.str.77 = private unnamed_addr constant [28 x i8] c"gauge_field.param[%d] = %f\0A\00", align 1
@__const.read_gauge_hdr.myname = private unnamed_addr constant [15 x i8] c"read_gauge_hdr\00", align 1
@.str.80 = private unnamed_addr constant [24 x i8] c"%s: Can't byte reverse\0A\00", align 1
@.str.82 = private unnamed_addr constant [67 x i8] c"%s: Unrecognized magic number in gauge configuration file header.\0A\00", align 1
@.str.83 = private unnamed_addr constant [25 x i8] c"Expected %x but read %x\0A\00", align 1
@.str.84 = private unnamed_addr constant [25 x i8] c"Expected %s but read %s\0A\00", align 1
@stderr = external local_unnamed_addr global %struct._IO_FILE*, align 8
@.str.85 = private unnamed_addr constant [56 x i8] c"%s: Must use reload_serial with archive files for now.\0A\00", align 1
@.str.86 = private unnamed_addr constant [12 x i8] c"DIMENSION_1\00", align 1
@.str.87 = private unnamed_addr constant [24 x i8] c"DIMENSION_1 not present\00", align 1
@.str.88 = private unnamed_addr constant [12 x i8] c"DIMENSION_2\00", align 1
@.str.89 = private unnamed_addr constant [24 x i8] c"DIMENSION_2 not present\00", align 1
@.str.90 = private unnamed_addr constant [12 x i8] c"DIMENSION_3\00", align 1
@.str.91 = private unnamed_addr constant [24 x i8] c"DIMENSION_3 not present\00", align 1
@.str.92 = private unnamed_addr constant [12 x i8] c"DIMENSION_4\00", align 1
@.str.93 = private unnamed_addr constant [24 x i8] c"DIMENSION_4 not present\00", align 1
@.str.94 = private unnamed_addr constant [9 x i8] c"CHECKSUM\00", align 1
@.str.95 = private unnamed_addr constant [21 x i8] c"CHECKSUM not present\00", align 1
@.str.96 = private unnamed_addr constant [34 x i8] c"%s: Incorrect lattice dimensions \00", align 1
@.str.97 = private unnamed_addr constant [11 x i8] c"time stamp\00", align 1
@.str.98 = private unnamed_addr constant [16 x i8] c"order parameter\00", align 1
@.str.99 = private unnamed_addr constant [3 x i8] c"rb\00", align 1
@.str.100 = private unnamed_addr constant [50 x i8] c"r_serial_i: Node %d can't open file %s, error %d\0A\00", align 1
@__const.r_serial.myname = private unnamed_addr constant [9 x i8] c"r_serial\00", align 1
@.str.101 = private unnamed_addr constant [48 x i8] c"%s: Attempting serial read from parallel file \0A\00", align 1
@.str.102 = private unnamed_addr constant [31 x i8] c"%s: Node %d can't malloc lbuf\0A\00", align 1
@.str.103 = private unnamed_addr constant [43 x i8] c"%s: Node 0 fseeko failed error %d file %s\0A\00", align 1
@.str.104 = private unnamed_addr constant [55 x i8] c"%s: node %d gauge configuration read error %d file %s\0A\00", align 1
@.str.105 = private unnamed_addr constant [59 x i8] c"Restored binary gauge configuration serially from file %s\0A\00", align 1
@__const.r_serial_arch.myname = private unnamed_addr constant [14 x i8] c"r_serial_arch\00", align 1
@.str.106 = private unnamed_addr constant [55 x i8] c"%s: Node %d can't malloc uin buffer to read timeslice\0A\00", align 1
@.str.108 = private unnamed_addr constant [60 x i8] c"Restored archive gauge configuration serially from file %s\0A\00", align 1
@.str.109 = private unnamed_addr constant [56 x i8] c"Archive style checksum violation: computed %x, read %x\0A\00", align 1
@.str.110 = private unnamed_addr constant [32 x i8] c"Archive style checksum = %x OK\0A\00", align 1
@.str.112 = private unnamed_addr constant [44 x i8] c"write_site_list: node %d can't malloc cbuf\0A\00", align 1
@.str.113 = private unnamed_addr constant [53 x i8] c"write_site_list: node %d g_seek %ld failed errno %d\0A\00", align 1
@.str.114 = private unnamed_addr constant [48 x i8] c"write_site_list: Node %d coords write error %d\0A\00", align 1
@.str.115 = private unnamed_addr constant [53 x i8] c"parallel_open: Node %d can't open file %s, error %d\0A\00", align 1
@__const.w_parallel_setup.myname = private unnamed_addr constant [17 x i8] c"w_parallel_setup\00", align 16
@.str.116 = private unnamed_addr constant [47 x i8] c"%s: Attempting parallel write to serial file.\0A\00", align 1
@.str.117 = private unnamed_addr constant [48 x i8] c"%s: Node %d g_seek %ld failed error %d file %s\0A\00", align 1
@__const.w_parallel.myname = private unnamed_addr constant [11 x i8] c"w_parallel\00", align 1
@.str.119 = private unnamed_addr constant [56 x i8] c"%s: Node %d gauge configuration write error %d file %s\0A\00", align 1
@.str.120 = private unnamed_addr constant [61 x i8] c"%s: Node %d g_seek %ld for checksum failed error %d file %s\0A\00", align 1
@.str.121 = private unnamed_addr constant [57 x i8] c"Saved gauge configuration in parallel to binary file %s\0A\00", align 1
@__const.w_checkpoint.myname = private unnamed_addr constant [13 x i8] c"w_checkpoint\00", align 1
@.str.122 = private unnamed_addr constant [46 x i8] c"Saved gauge configuration checkpoint file %s\0A\00", align 1
@.str.124 = private unnamed_addr constant [52 x i8] c"r_parallel_i: Node %d can't open file %s, error %d\0A\00", align 1
@__const.r_parallel.myname = private unnamed_addr constant [11 x i8] c"r_parallel\00", align 1
@.str.125 = private unnamed_addr constant [48 x i8] c"%s: Attempting parallel read from serial file.\0A\00", align 1
@.str.126.274 = private unnamed_addr constant [37 x i8] c"BOTCH. Node %d received %d %d %d %d\0A\00", align 1
@.str.127 = private unnamed_addr constant [62 x i8] c"Restored binary gauge configuration in parallel from file %s\0A\00", align 1
@.str.128 = private unnamed_addr constant [60 x i8] c"%s: Node 0 g_seek %ld for checksum failed error %d file %s\0A\00", align 1
@.str.130 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.131 = private unnamed_addr constant [30 x i8] c"Can't open file %s, error %d\0A\00", align 1
@.str.134 = private unnamed_addr constant [27 x i8] c"  read %d but expected %d\0A\00", align 1
@.str.135 = private unnamed_addr constant [26 x i8] c"%*[ \0C\0A\0D\09\0B]%*[\22]%[^\22]%*[\22]\00", align 1
@.str.137 = private unnamed_addr constant [24 x i8] c"count %d time_stamp %s\0A\00", align 1
@.str.138 = private unnamed_addr constant [9 x i8] c"%d%d%d%d\00", align 1
@.str.140.277 = private unnamed_addr constant [51 x i8] c"restore_ascii: Incorrect lattice size %d,%d,%d,%d\0A\00", align 1
@.str.141 = private unnamed_addr constant [8 x i8] c"%lf%lf\0A\00", align 1
@.str.143 = private unnamed_addr constant [50 x i8] c"Restored gauge configuration from ascii file  %s\0A\00", align 1
@.str.144 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.146 = private unnamed_addr constant [6 x i8] c"\22%s\22\0A\00", align 1
@.str.148 = private unnamed_addr constant [13 x i8] c"%d\09%d\09%d\09%d\0A\00", align 1
@.str.150 = private unnamed_addr constant [11 x i8] c"%.7e\09%.7e\0A\00", align 1
@.str.152 = private unnamed_addr constant [44 x i8] c"Saved gauge configuration to ascii file %s\0A\00", align 1
@.str.153 = private unnamed_addr constant [12 x i8] c"trace = %f\0A\00", align 1
@.str.154 = private unnamed_addr constant [15 x i8] c"chksum_x = %x\0A\00", align 1
@.str.155 = private unnamed_addr constant [17 x i8] c"chksum_u = %12u\0A\00", align 1
@.str.156 = private unnamed_addr constant [16 x i8] c"plaquette = %f\0A\00", align 1
@.str.157 = private unnamed_addr constant [38 x i8] c"Writing archive format lattice to %s\0A\00", align 1
@.str.158 = private unnamed_addr constant [31 x i8] c"error opening output file: %s\0A\00", align 1
@.str.159.292 = private unnamed_addr constant [14 x i8] c"BEGIN_HEADER\0A\00", align 1
@.str.160 = private unnamed_addr constant [25 x i8] c"DATATYPE = 4D_SU3_GAUGE\0A\00", align 1
@.str.161 = private unnamed_addr constant [18 x i8] c"DIMENSION_1 = %d\0A\00", align 1
@.str.162 = private unnamed_addr constant [18 x i8] c"DIMENSION_2 = %d\0A\00", align 1
@.str.163 = private unnamed_addr constant [18 x i8] c"DIMENSION_3 = %d\0A\00", align 1
@.str.164 = private unnamed_addr constant [18 x i8] c"DIMENSION_4 = %d\0A\00", align 1
@.str.165.293 = private unnamed_addr constant [15 x i8] c"CHECKSUM = %x\0A\00", align 1
@.str.166 = private unnamed_addr constant [20 x i8] c"LINK_TRACE = %.10f\0A\00", align 1
@.str.167 = private unnamed_addr constant [19 x i8] c"PLAQUETTE = %.10f\0A\00", align 1
@.str.168 = private unnamed_addr constant [18 x i8] c"ENSEMBLE_ID = %s\0A\00", align 1
@.str.169 = private unnamed_addr constant [22 x i8] c"SEQUENCE_NUMBER = %d\0A\00", align 1
@.str.170 = private unnamed_addr constant [33 x i8] c"MILC_INFO = -------BEGIN-------\0A\00", align 1
@.str.171 = private unnamed_addr constant [33 x i8] c"MILC_INFO = --------END--------\0A\00", align 1
@.str.174 = private unnamed_addr constant [29 x i8] c"Wrote archive gauge file %s\0A\00", align 1
@str.234 = private unnamed_addr constant [24 x i8] c"reading Archive header:\00", align 1
@str.176 = private unnamed_addr constant [35 x i8] c"w_serial: Node 0 can't malloc lbuf\00", align 1
@str.177 = private unnamed_addr constant [52 x i8] c"w_serial: Attempting serial write to parallel file \00", align 1
@str.178 = private unnamed_addr constant [54 x i8] c"w_serial_f: Attempting serial close on parallel file \00", align 1
@str.179 = private unnamed_addr constant [44 x i8] c"read_site_list: Can't malloc rank2rcv table\00", align 1
@str.180 = private unnamed_addr constant [66 x i8] c"Reading as old-style gauge field configuration with byte reversal\00", align 1
@str.181.271 = private unnamed_addr constant [38 x i8] c"read_v3_gauge_hdr: Can't byte reverse\00", align 1
@str.182 = private unnamed_addr constant [48 x i8] c"Reading as old-style gauge field configuration.\00", align 1
@str.183 = private unnamed_addr constant [73 x i8] c"First 4 bytes were zero. Trying to interpret with 64 bit integer format.\00", align 1
@str.184 = private unnamed_addr constant [67 x i8] c"Reading as 1996-style gauge field configuration with byte reversal\00", align 1
@str.185 = private unnamed_addr constant [40 x i8] c"read_1996_gauge_hdr: Can't byte reverse\00", align 1
@str.186 = private unnamed_addr constant [49 x i8] c"Reading as 1996-style gauge field configuration.\00", align 1
@str.187 = private unnamed_addr constant [27 x i8] c"Reading with byte reversal\00", align 1
@str.188 = private unnamed_addr constant [45 x i8] c"reading as archive format with byte reversal\00", align 1
@str.189 = private unnamed_addr constant [26 x i8] c"reading as archive format\00", align 1
@str.190 = private unnamed_addr constant [40 x i8] c"recompile with smaller read buffer: uin\00", align 1
@str.191 = private unnamed_addr constant [54 x i8] c"r_serial_f: Attempting serial close on parallel file \00", align 1
@str.192.273 = private unnamed_addr constant [56 x i8] c"w_parallel_f: Attempting parallel close on serial file.\00", align 1
@str.193 = private unnamed_addr constant [56 x i8] c"r_parallel_f: Attempting parallel close on serial file.\00", align 1
@str.194 = private unnamed_addr constant [37 x i8] c"restore_ascii: gauge link read error\00", align 1
@str.195 = private unnamed_addr constant [43 x i8] c"restore_ascii: Error in reading dimensions\00", align 1
@str.196 = private unnamed_addr constant [40 x i8] c"restore_ascii: Error reading time stamp\00", align 1
@str.197 = private unnamed_addr constant [58 x i8] c"restore_ascii: Incorrect version number in lattice header\00", align 1
@str.198 = private unnamed_addr constant [44 x i8] c"restore_ascii: Error reading version number\00", align 1
@str.199 = private unnamed_addr constant [26 x i8] c"Write error in save_ascii\00", align 1
@str.200 = private unnamed_addr constant [28 x i8] c"Error in writing dimensions\00", align 1
@str.201 = private unnamed_addr constant [28 x i8] c"Error in writing time stamp\00", align 1
@str.202 = private unnamed_addr constant [32 x i8] c"Error in writing version number\00", align 1
@str.203.294 = private unnamed_addr constant [17 x i8] c"fwrite bombed...\00", align 1
@str.204 = private unnamed_addr constant [28 x i8] c"can't malloc uout timeslice\00", align 1
@str.205 = private unnamed_addr constant [48 x i8] c"Parallel archive saves are not implemented, yet\00", align 1
@.str.301 = private unnamed_addr constant [13 x i8] c"magic_number\00", align 1
@.str.1.302 = private unnamed_addr constant [11 x i8] c"time_stamp\00", align 1
@.str.2.303 = private unnamed_addr constant [10 x i8] c"checksums\00", align 1
@.str.3.304 = private unnamed_addr constant [3 x i8] c"nx\00", align 1
@.str.4.305 = private unnamed_addr constant [3 x i8] c"ny\00", align 1
@.str.5.306 = private unnamed_addr constant [3 x i8] c"nz\00", align 1
@.str.6.307 = private unnamed_addr constant [3 x i8] c"nt\00", align 1
@.str.7.308 = private unnamed_addr constant [19 x i8] c"action.description\00", align 1
@.str.8.309 = private unnamed_addr constant [18 x i8] c"gauge.description\00", align 1
@.str.9.310 = private unnamed_addr constant [13 x i8] c"gauge.beta11\00", align 1
@.str.10.311 = private unnamed_addr constant [13 x i8] c"gauge.beta12\00", align 1
@.str.11.312 = private unnamed_addr constant [17 x i8] c"gauge.tadpole.u0\00", align 1
@.str.12.313 = private unnamed_addr constant [13 x i8] c"gauge.nloops\00", align 1
@.str.13.314 = private unnamed_addr constant [12 x i8] c"gauge.nreps\00", align 1
@.str.14.315 = private unnamed_addr constant [24 x i8] c"gauge.previous.filename\00", align 1
@.str.15.316 = private unnamed_addr constant [26 x i8] c"gauge.previous.time_stamp\00", align 1
@.str.16.317 = private unnamed_addr constant [25 x i8] c"gauge.previous.checksums\00", align 1
@.str.17.318 = private unnamed_addr constant [22 x i8] c"gauge.fix.description\00", align 1
@.str.18.319 = private unnamed_addr constant [20 x i8] c"gauge.fix.tolerance\00", align 1
@.str.19.320 = private unnamed_addr constant [24 x i8] c"gauge.smear.description\00", align 1
@.str.20.321 = private unnamed_addr constant [18 x i8] c"gauge.smear.steps\00", align 1
@.str.21.322 = private unnamed_addr constant [19 x i8] c"gauge.smear.factor\00", align 1
@.str.22.323 = private unnamed_addr constant [18 x i8] c"quark.description\00", align 1
@.str.23.324 = private unnamed_addr constant [14 x i8] c"quark.flavors\00", align 1
@.str.24.325 = private unnamed_addr constant [15 x i8] c"quark.flavors1\00", align 1
@.str.25.326 = private unnamed_addr constant [15 x i8] c"quark.flavors2\00", align 1
@.str.26.327 = private unnamed_addr constant [11 x i8] c"quark.mass\00", align 1
@.str.27.328 = private unnamed_addr constant [12 x i8] c"quark.mass1\00", align 1
@.str.28.329 = private unnamed_addr constant [12 x i8] c"quark.mass2\00", align 1
@.str.29.330 = private unnamed_addr constant [12 x i8] c"quark.kappa\00", align 1
@.str.30.331 = private unnamed_addr constant [14 x i8] c"quark.link.c1\00", align 1
@.str.31.332 = private unnamed_addr constant [14 x i8] c"quark.link.c3\00", align 1
@.str.32.333 = private unnamed_addr constant [16 x i8] c"quark.staple.w3\00", align 1
@.str.33.334 = private unnamed_addr constant [16 x i8] c"quark.clover.c0\00", align 1
@.str.34.335 = private unnamed_addr constant [16 x i8] c"quark.clover.u0\00", align 1
@.str.35.336 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@gauge_info_keyword = local_unnamed_addr global [36 x i8*] [i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.301, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1.302, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2.303, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3.304, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4.305, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.5.306, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.6.307, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.7.308, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.8.309, i32 0, i32 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.9.310, i32 0, i32 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.10.311, i32 0, i32 0), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.11.312, i32 0, i32 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.12.313, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.13.314, i32 0, i32 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.14.315, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.15.316, i32 0, i32 0), i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.16.317, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.17.318, i32 0, i32 0), i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.18.319, i32 0, i32 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.19.320, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.20.321, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21.322, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.22.323, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.23.324, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.24.325, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.25.326, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26.327, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.27.328, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.28.329, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.29.330, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.30.331, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.332, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.32.333, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.33.334, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.34.335, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.35.336, i32 0, i32 0)], align 16
@warms = local_unnamed_addr global i32 0, align 4
@stdout = external local_unnamed_addr global %struct._IO_FILE*, align 8
@trajecs = local_unnamed_addr global i32 0, align 4
@propinterval = local_unnamed_addr global i32 0, align 4
@mass = global double 0.000000e+00, align 8
@.str.38.412 = private unnamed_addr constant [31 x i8] c"average cg iters for step= %e\0A\00", align 1
@.str.39.413 = private unnamed_addr constant [18 x i8] c"total_iters = %d\0A\00", align 1
@total_iters = local_unnamed_addr global i32 0, align 4
@saveflag = local_unnamed_addr global i32 0, align 4
@savefile = global [256 x i8] zeroinitializer, align 16
@ensemble_id = global [256 x i8] zeroinitializer, align 16
@sequence_number = local_unnamed_addr global i32 0, align 4
@volume = local_unnamed_addr global i32 0, align 4
@steps = local_unnamed_addr global i32 0, align 4
@niter = local_unnamed_addr global i32 0, align 4
@nflavors = global i32 0, align 4
@epsilon = local_unnamed_addr global double 0.000000e+00, align 8
@beta = global double 0.000000e+00, align 8
@u0 = global double 0.000000e+00, align 8
@rsqmin = local_unnamed_addr global double 0.000000e+00, align 8
@rsqprop = local_unnamed_addr global double 0.000000e+00, align 8
@startflag = local_unnamed_addr global i32 0, align 4
@startfile = global [256 x i8] zeroinitializer, align 16
@phases_in = local_unnamed_addr global i32 0, align 4
@source_start = local_unnamed_addr global i32 0, align 4
@source_inc = local_unnamed_addr global i32 0, align 4
@n_sources = local_unnamed_addr global i32 0, align 4
@even_sites_on_node = local_unnamed_addr global i32 0, align 4
@odd_sites_on_node = local_unnamed_addr global i32 0, align 4
@number_of_nodes = local_unnamed_addr global i32 0, align 4
@valid_longlinks = local_unnamed_addr global i32 0, align 4
@valid_fatlinks = local_unnamed_addr global i32 0, align 4
@startlat_p = local_unnamed_addr global %struct.gauge_file* null, align 8
@node_prn = global %struct.double_prn zeroinitializer, align 8
@start_lat_hdr = local_unnamed_addr global %struct.gauge_header zeroinitializer, align 4
@str.411 = private unnamed_addr constant [18 x i8] c"RUNNING COMPLETED\00", align 1
@str.40 = private unnamed_addr constant [18 x i8] c"WARMUPS COMPLETED\00", align 1
@sites_on_node = local_unnamed_addr global i32 0, align 4
@lattice = local_unnamed_addr global %struct.site* null, align 8
@.str.416 = private unnamed_addr constant [30 x i8] c"NODE %d: no room for lattice\0A\00", align 1
@this_node = local_unnamed_addr global i32 0, align 4
@gen_pt = local_unnamed_addr global [16 x i8**] zeroinitializer, align 16
@.str.1.417 = private unnamed_addr constant [37 x i8] c"NODE %d: no room for pointer vector\0A\00", align 1
@nt = global i32 0, align 4
@nz = global i32 0, align 4
@ny = global i32 0, align 4
@nx = global i32 0, align 4
@iseed = local_unnamed_addr global i32 0, align 4

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare double @magsq_su3vec(%struct.su3_vector* nocapture readonly) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare { double, double } @ploop() local_unnamed_addr #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @scalar_mult_sub_su3_matrix(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture readonly, double, %struct.su3_matrix* nocapture) local_unnamed_addr #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #5

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @mult_adj_su3_mat_4vec(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector*, %struct.su3_vector*, %struct.su3_vector*, %struct.su3_vector*) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @mat_invert_cg(i32, i32, i32, double) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @mat_invert_uml(i32, i32, i32, double) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #6

; Function Attrs: noreturn nounwind optsize
declare void @exit(i32) local_unnamed_addr #7

; Function Attrs: noinline nounwind optsize uwtable
declare void @check_invert(i32, i32, double, double) local_unnamed_addr #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fabs.f64(double) #5

; Function Attrs: nofree nounwind optsize
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #8

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @sqrt(double) local_unnamed_addr #9

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fflush(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #8

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @mult_su3_mat_vec(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @write_appl_gauge_info(%struct._IO_FILE*) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @scalar_mult_su3_vector(%struct.su3_vector* nocapture readonly, double, %struct.su3_vector* nocapture) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare void @mult_su2_mat_vec_elem_n(%struct.su2_matrix* nocapture readonly, %struct.complex* nocapture, %struct.complex* nocapture) local_unnamed_addr #11

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @mult_su3_na(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @make_loop_table() local_unnamed_addr #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #12

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare double @log(double) local_unnamed_addr #9

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @char_num(i32* nocapture readonly, i32* nocapture, i32) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare double @imp_gauge_action() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
define void @imp_gauge_force(double %eps, i32 %mom_off) local_unnamed_addr #1 {
entry:
  %tmat1 = alloca %struct.su3_matrix, align 8
  %tmat2 = alloca %struct.su3_matrix, align 8
  %dirs = alloca [6 x i32], align 16
  %path_dir = alloca [6 x i32], align 16
  %0 = bitcast %struct.su3_matrix* %tmat1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 144, i8* nonnull %0) #31
  %1 = bitcast %struct.su3_matrix* %tmat2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 144, i8* nonnull %1) #31
  %2 = bitcast [6 x i32]* %dirs to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %2) #31
  %3 = bitcast [6 x i32]* %path_dir to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %3) #31
  %4 = load double, double* @beta, align 8, !tbaa !4
  %mul = fmul double %4, %eps
  %div = fdiv double %mul, 3.000000e+00
  %arraydecay = getelementptr inbounds [6 x i32], [6 x i32]* %path_dir, i64 0, i64 0
  %idx.ext = sext i32 %mom_off to i64
  %.pre = load i32, i32* @sites_on_node, align 4, !tbaa !8
  br label %for.body

for.body:                                         ; preds = %for.inc150, %entry
  %5 = phi i32 [ %.pre, %entry ], [ %47, %for.inc150 ]
  %indvars.iv300 = phi i64 [ 0, %entry ], [ %indvars.iv.next301, %for.inc150 ]
  %cmp2245 = icmp sgt i32 %5, 0
  br i1 %cmp2245, label %for.cond4.preheader.preheader, label %for.cond18.preheader

for.cond4.preheader.preheader:                    ; preds = %for.body
  %6 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !10
  br label %for.cond4.preheader

for.cond18.preheader:                             ; preds = %for.inc15, %for.body
  %7 = phi i32 [ %5, %for.body ], [ %14, %for.inc15 ]
  %8 = sub nuw nsw i64 7, %indvars.iv300
  %9 = trunc i64 %indvars.iv300 to i32
  %10 = add i32 %9, 7
  %11 = trunc i64 %indvars.iv300 to i32
  br label %for.body20

for.cond4.preheader:                              ; preds = %for.inc15, %for.cond4.preheader.preheader
  %i.0247 = phi i32 [ %inc16, %for.inc15 ], [ 0, %for.cond4.preheader.preheader ]
  %st.0246 = phi %struct.site* [ %incdec.ptr, %for.inc15 ], [ %6, %for.cond4.preheader.preheader ]
  br label %for.cond7.preheader

for.cond7.preheader:                              ; preds = %for.inc12, %for.cond4.preheader
  %indvars.iv273 = phi i64 [ 0, %for.cond4.preheader ], [ %indvars.iv.next274, %for.inc12 ]
  br label %for.body9

for.body9:                                        ; preds = %for.body9, %for.cond7.preheader
  %indvars.iv = phi i64 [ 0, %for.cond7.preheader ], [ %indvars.iv.next, %for.body9 ]
  %call = call { double, double } @cmplx(double 0.000000e+00, double 0.000000e+00) #32
  %12 = extractvalue { double, double } %call, 0
  %13 = extractvalue { double, double } %call, 1
  %tmp.sroa.0.0..sroa_idx = getelementptr inbounds %struct.site, %struct.site* %st.0246, i64 0, i32 23, i32 0, i64 %indvars.iv273, i64 %indvars.iv, i32 0
  store double %12, double* %tmp.sroa.0.0..sroa_idx, align 8, !tbaa.struct !12
  %tmp.sroa.4.0..sroa_idx154 = getelementptr inbounds %struct.site, %struct.site* %st.0246, i64 0, i32 23, i32 0, i64 %indvars.iv273, i64 %indvars.iv, i32 1
  store double %13, double* %tmp.sroa.4.0..sroa_idx154, align 8, !tbaa.struct !13
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 3
  br i1 %exitcond.not, label %for.inc12, label %for.body9, !llvm.loop !14

for.inc12:                                        ; preds = %for.body9
  %indvars.iv.next274 = add nuw nsw i64 %indvars.iv273, 1
  %exitcond275.not = icmp eq i64 %indvars.iv.next274, 3
  br i1 %exitcond275.not, label %for.inc15, label %for.cond7.preheader, !llvm.loop !16

for.inc15:                                        ; preds = %for.inc12
  %inc16 = add nuw nsw i32 %i.0247, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %st.0246, i64 1
  %14 = load i32, i32* @sites_on_node, align 4, !tbaa !8
  %cmp2 = icmp slt i32 %inc16, %14
  br i1 %cmp2, label %for.cond4.preheader, label %for.cond18.preheader, !llvm.loop !17

for.body20:                                       ; preds = %for.inc131, %for.cond18.preheader
  %15 = phi i32 [ %7, %for.cond18.preheader ], [ %42, %for.inc131 ]
  %indvars.iv297 = phi i64 [ 0, %for.cond18.preheader ], [ %indvars.iv.next298, %for.inc131 ]
  %arrayidx22 = getelementptr inbounds [3 x i32], [3 x i32]* @loop_length, i64 0, i64 %indvars.iv297
  %16 = load i32, i32* %arrayidx22, align 4, !tbaa !8
  %arrayidx25 = getelementptr inbounds [3 x i32], [3 x i32]* @loop_num, i64 0, i64 %indvars.iv297
  %cmp29248 = icmp sgt i32 %16, 0
  %sub60 = add i32 %16, -1
  %cmp77250 = icmp sgt i32 %16, 1
  %sub103 = add nsw i32 %16, -2
  %arrayidx116 = getelementptr inbounds [3 x [1 x double]], [3 x [1 x double]]* @loop_coeff, i64 0, i64 %indvars.iv297, i64 0
  %17 = load i32, i32* %arrayidx25, align 4, !tbaa !8
  %cmp26263 = icmp sgt i32 %17, 0
  br i1 %cmp26263, label %for.cond28.preheader.preheader, label %for.inc131

for.cond28.preheader.preheader:                   ; preds = %for.body20
  %wide.trip.count = zext i32 %16 to i64
  %wide.trip.count293 = zext i32 %16 to i64
  %wide.trip.count282 = zext i32 %sub60 to i64
  %wide.trip.count287 = zext i32 %sub60 to i64
  br label %for.cond28.preheader

for.cond28.preheader:                             ; preds = %for.inc128, %for.cond28.preheader.preheader
  %18 = phi i32 [ %15, %for.cond28.preheader.preheader ], [ %39, %for.inc128 ]
  %19 = phi i32 [ %17, %for.cond28.preheader.preheader ], [ %40, %for.inc128 ]
  %indvars.iv295 = phi i64 [ 0, %for.cond28.preheader.preheader ], [ %indvars.iv.next296, %for.inc128 ]
  br i1 %cmp29248, label %for.body30, label %for.inc128

for.body30:                                       ; preds = %for.inc57, %for.cond28.preheader
  %indvars.iv276 = phi i64 [ %indvars.iv.next277, %for.inc57 ], [ 0, %for.cond28.preheader ]
  %arrayidx36 = getelementptr inbounds [3 x [16 x [6 x i32]]], [3 x [16 x [6 x i32]]]* @loop_table, i64 0, i64 %indvars.iv297, i64 %indvars.iv295, i64 %indvars.iv276
  %20 = load i32, i32* %arrayidx36, align 4, !tbaa !8
  %cmp37 = icmp slt i32 %20, 4
  br i1 %cmp37, label %if.then, label %if.else

if.then:                                          ; preds = %for.body30
  %add = add nsw i32 %20, %11
  %rem = srem i32 %add, 4
  br label %for.inc57

if.else:                                          ; preds = %for.body30
  %add52 = sub i32 %10, %20
  %rem53 = srem i32 %add52, 4
  %sub54 = sub nsw i32 7, %rem53
  br label %for.inc57

for.inc57:                                        ; preds = %if.else, %if.then
  %sub54.sink = phi i32 [ %rem, %if.then ], [ %sub54, %if.else ]
  %21 = getelementptr inbounds [6 x i32], [6 x i32]* %dirs, i64 0, i64 %indvars.iv276
  store i32 %sub54.sink, i32* %21, align 4
  %indvars.iv.next277 = add nuw nsw i64 %indvars.iv276, 1
  %exitcond278.not = icmp eq i64 %indvars.iv.next277, %wide.trip.count
  br i1 %exitcond278.not, label %for.end59, label %for.body30, !llvm.loop !18

for.end59:                                        ; preds = %for.inc57
  br i1 %cmp29248, label %for.body63, label %for.inc128

for.body63:                                       ; preds = %for.inc125, %for.end59
  %22 = phi i32 [ %38, %for.inc125 ], [ %18, %for.end59 ]
  %indvars.iv289 = phi i64 [ %indvars.iv.next290, %for.inc125 ], [ 0, %for.end59 ]
  %arrayidx65 = getelementptr inbounds [6 x i32], [6 x i32]* %dirs, i64 0, i64 %indvars.iv289
  %23 = load i32, i32* %arrayidx65, align 4, !tbaa !8
  %24 = zext i32 %23 to i64
  %cmp66 = icmp eq i64 %indvars.iv300, %24
  %cmp70 = icmp eq i64 %8, %24
  %or.cond = select i1 %cmp66, i1 true, i1 %cmp70
  br i1 %or.cond, label %if.then71, label %for.inc125

if.then71:                                        ; preds = %for.body63
  %cmp74 = icmp slt i32 %23, 4
  br i1 %cmp74, label %for.cond76.preheader, label %for.cond94.preheader

for.cond76.preheader:                             ; preds = %if.then71
  %25 = add nuw nsw i64 %indvars.iv289, 1
  br i1 %cmp77250, label %for.body78, label %if.end110

for.body78:                                       ; preds = %for.body78, %for.cond76.preheader
  %indvars.iv279 = phi i64 [ %indvars.iv.next280, %for.body78 ], [ 0, %for.cond76.preheader ]
  %26 = add nuw nsw i64 %25, %indvars.iv279
  %27 = trunc i64 %26 to i32
  %rem81 = srem i32 %27, %16
  %idxprom82 = zext i32 %rem81 to i64
  %arrayidx83 = getelementptr inbounds [6 x i32], [6 x i32]* %dirs, i64 0, i64 %idxprom82
  %28 = load i32, i32* %arrayidx83, align 4, !tbaa !8
  %arrayidx85 = getelementptr inbounds [6 x i32], [6 x i32]* %path_dir, i64 0, i64 %indvars.iv279
  store i32 %28, i32* %arrayidx85, align 4, !tbaa !8
  %indvars.iv.next280 = add nuw nsw i64 %indvars.iv279, 1
  %exitcond283.not = icmp eq i64 %indvars.iv.next280, %wide.trip.count282
  br i1 %exitcond283.not, label %if.end89, label %for.body78, !llvm.loop !19

if.end89:                                         ; preds = %for.body78
  %cmp92 = icmp sgt i32 %23, 3
  br i1 %cmp92, label %for.cond94.preheader, label %if.end110

for.cond94.preheader:                             ; preds = %if.end89, %if.then71
  %29 = add nuw nsw i64 %indvars.iv289, 1
  br i1 %cmp77250, label %for.body96, label %if.end110

for.body96:                                       ; preds = %for.body96, %for.cond94.preheader
  %indvars.iv284 = phi i64 [ %indvars.iv.next285, %for.body96 ], [ 0, %for.cond94.preheader ]
  %30 = add nuw nsw i64 %29, %indvars.iv284
  %31 = trunc i64 %30 to i32
  %rem99 = srem i32 %31, %16
  %idxprom100 = zext i32 %rem99 to i64
  %arrayidx101 = getelementptr inbounds [6 x i32], [6 x i32]* %dirs, i64 0, i64 %idxprom100
  %32 = load i32, i32* %arrayidx101, align 4, !tbaa !8
  %sub102 = sub nsw i32 7, %32
  %33 = trunc i64 %indvars.iv284 to i32
  %sub104 = sub i32 %sub103, %33
  %idxprom105 = sext i32 %sub104 to i64
  %arrayidx106 = getelementptr inbounds [6 x i32], [6 x i32]* %path_dir, i64 0, i64 %idxprom105
  store i32 %sub102, i32* %arrayidx106, align 4, !tbaa !8
  %indvars.iv.next285 = add nuw nsw i64 %indvars.iv284, 1
  %exitcond288.not = icmp eq i64 %indvars.iv.next285, %wide.trip.count287
  br i1 %exitcond288.not, label %if.end110, label %for.body96, !llvm.loop !20

if.end110:                                        ; preds = %for.body96, %for.cond94.preheader, %if.end89, %for.cond76.preheader
  call void @path_product(i32* nonnull %arraydecay, i32 %sub60) #32
  %34 = load i32, i32* @sites_on_node, align 4, !tbaa !8
  %cmp112254 = icmp sgt i32 %34, 0
  br i1 %cmp112254, label %for.body113.preheader, label %for.inc125

for.body113.preheader:                            ; preds = %if.end110
  %35 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !10
  br label %for.body113

for.body113:                                      ; preds = %for.body113, %for.body113.preheader
  %i.1256 = phi i32 [ %inc120, %for.body113 ], [ 0, %for.body113.preheader ]
  %st.1255 = phi %struct.site* [ %incdec.ptr121, %for.body113 ], [ %35, %for.body113.preheader ]
  %tempmat1 = getelementptr inbounds %struct.site, %struct.site* %st.1255, i64 0, i32 22
  call void @su3_adjoint(%struct.su3_matrix* nonnull %tempmat1, %struct.su3_matrix* nonnull %tmat1) #32
  %36 = load double, double* %arrayidx116, align 8, !tbaa !4
  %staple117 = getelementptr inbounds %struct.site, %struct.site* %st.1255, i64 0, i32 23
  call void @scalar_mult_add_su3_matrix(%struct.su3_matrix* nonnull %staple117, %struct.su3_matrix* nonnull %tmat1, double %36, %struct.su3_matrix* nonnull %staple117) #32
  %inc120 = add nuw nsw i32 %i.1256, 1
  %incdec.ptr121 = getelementptr inbounds %struct.site, %struct.site* %st.1255, i64 1
  %37 = load i32, i32* @sites_on_node, align 4, !tbaa !8
  %cmp112 = icmp slt i32 %inc120, %37
  br i1 %cmp112, label %for.body113, label %for.inc125, !llvm.loop !21

for.inc125:                                       ; preds = %for.body113, %if.end110, %for.body63
  %38 = phi i32 [ %22, %for.body63 ], [ %34, %if.end110 ], [ %37, %for.body113 ]
  %indvars.iv.next290 = add nuw nsw i64 %indvars.iv289, 1
  %exitcond294.not = icmp eq i64 %indvars.iv.next290, %wide.trip.count293
  br i1 %exitcond294.not, label %for.inc128.loopexit, label %for.body63, !llvm.loop !22

for.inc128.loopexit:                              ; preds = %for.inc125
  %.pre305 = load i32, i32* %arrayidx25, align 4, !tbaa !8
  br label %for.inc128

for.inc128:                                       ; preds = %for.inc128.loopexit, %for.end59, %for.cond28.preheader
  %39 = phi i32 [ %18, %for.end59 ], [ %38, %for.inc128.loopexit ], [ %18, %for.cond28.preheader ]
  %40 = phi i32 [ %19, %for.end59 ], [ %.pre305, %for.inc128.loopexit ], [ %19, %for.cond28.preheader ]
  %indvars.iv.next296 = add nuw nsw i64 %indvars.iv295, 1
  %41 = sext i32 %40 to i64
  %cmp26 = icmp slt i64 %indvars.iv.next296, %41
  br i1 %cmp26, label %for.cond28.preheader, label %for.inc131, !llvm.loop !23

for.inc131:                                       ; preds = %for.inc128, %for.body20
  %42 = phi i32 [ %15, %for.body20 ], [ %39, %for.inc128 ]
  %indvars.iv.next298 = add nuw nsw i64 %indvars.iv297, 1
  %exitcond299.not = icmp eq i64 %indvars.iv.next298, 3
  br i1 %exitcond299.not, label %for.end133, label %for.body20, !llvm.loop !24

for.end133:                                       ; preds = %for.inc131
  %cmp135269 = icmp sgt i32 %42, 0
  br i1 %cmp135269, label %for.body136.preheader, label %for.inc150

for.body136.preheader:                            ; preds = %for.end133
  %43 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !10
  br label %for.body136

for.body136:                                      ; preds = %for.body136, %for.body136.preheader
  %i.2271 = phi i32 [ %inc147, %for.body136 ], [ 0, %for.body136.preheader ]
  %st.2270 = phi %struct.site* [ %incdec.ptr148, %for.body136 ], [ %43, %for.body136.preheader ]
  %arrayidx138 = getelementptr inbounds %struct.site, %struct.site* %st.2270, i64 0, i32 8, i64 %indvars.iv300
  %staple139 = getelementptr inbounds %struct.site, %struct.site* %st.2270, i64 0, i32 23
  call void @mult_su3_na(%struct.su3_matrix* nonnull %arrayidx138, %struct.su3_matrix* nonnull %staple139, %struct.su3_matrix* nonnull %tmat1) #32
  %44 = bitcast %struct.site* %st.2270 to i8*
  %add.ptr = getelementptr inbounds i8, i8* %44, i64 %idx.ext
  %45 = bitcast i8* %add.ptr to %struct.anti_hermitmat*
  %arrayidx141 = getelementptr inbounds %struct.anti_hermitmat, %struct.anti_hermitmat* %45, i64 %indvars.iv300
  call void @uncompress_anti_hermitian(%struct.anti_hermitmat* %arrayidx141, %struct.su3_matrix* nonnull %tmat2) #32
  call void @scalar_mult_sub_su3_matrix(%struct.su3_matrix* nonnull %tmat2, %struct.su3_matrix* nonnull %tmat1, double %div, %struct.su3_matrix* nonnull %staple139) #32
  call void @make_anti_hermitian(%struct.su3_matrix* nonnull %staple139, %struct.anti_hermitmat* %arrayidx141) #32
  %inc147 = add nuw nsw i32 %i.2271, 1
  %incdec.ptr148 = getelementptr inbounds %struct.site, %struct.site* %st.2270, i64 1
  %46 = load i32, i32* @sites_on_node, align 4, !tbaa !8
  %cmp135 = icmp slt i32 %inc147, %46
  br i1 %cmp135, label %for.body136, label %for.inc150, !llvm.loop !25

for.inc150:                                       ; preds = %for.body136, %for.end133
  %47 = phi i32 [ %42, %for.end133 ], [ %46, %for.body136 ]
  %indvars.iv.next301 = add nuw nsw i64 %indvars.iv300, 1
  %exitcond304.not = icmp eq i64 %indvars.iv.next301, 4
  br i1 %exitcond304.not, label %for.end152, label %for.body, !llvm.loop !26

for.end152:                                       ; preds = %for.inc150
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %3) #31
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %2) #31
  call void @llvm.lifetime.end.p0i8(i64 144, i8* nonnull %1) #31
  call void @llvm.lifetime.end.p0i8(i64 144, i8* nonnull %0) #31
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
define void @g_measure() local_unnamed_addr #1 {
entry:
  %ss_plaquette = alloca double, align 8
  %st_plaquette = alloca double, align 8
  %average = alloca [1 x double], align 8
  %total_action = alloca double, align 8
  %0 = bitcast double* %ss_plaquette to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %0) #31
  %1 = bitcast double* %st_plaquette to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %1) #31
  %2 = bitcast [1 x double]* %average to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %2) #31
  %3 = bitcast double* %total_action to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %3) #31
  call void @d_plaquette(double* nonnull %ss_plaquette, double* nonnull %st_plaquette) #32
  %4 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp = icmp eq i32 %4, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %5 = load double, double* %ss_plaquette, align 8, !tbaa !4
  %6 = load double, double* %st_plaquette, align 8, !tbaa !4
  %call = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str.5.18, i64 0, i64 0), double %5, double %6) #33
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %call1 = call { double, double } @ploop() #32
  %7 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp2 = icmp eq i32 %7, 0
  br i1 %cmp2, label %if.then3, label %if.end5

if.then3:                                         ; preds = %if.end
  %8 = extractvalue { double, double } %call1, 1
  %9 = extractvalue { double, double } %call1, 0
  %call4 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.6.19, i64 0, i64 0), double %9, double %8) #33
  br label %if.end5

if.end5:                                          ; preds = %if.then3, %if.end
  store double 0.000000e+00, double* %total_action, align 8, !tbaa !4
  %arrayidx20 = getelementptr inbounds [1 x double], [1 x double]* %average, i64 0, i64 0
  br label %for.body

for.body:                                         ; preds = %for.inc97, %if.end5
  %10 = phi double [ 0.000000e+00, %if.end5 ], [ %34, %for.inc97 ]
  %indvars.iv181 = phi i64 [ 0, %if.end5 ], [ %indvars.iv.next182, %for.inc97 ]
  %arrayidx = getelementptr inbounds [3 x i32], [3 x i32]* @loop_length, i64 0, i64 %indvars.iv181
  %11 = load i32, i32* %arrayidx, align 4, !tbaa !8
  %arrayidx9 = getelementptr inbounds [3 x i32], [3 x i32]* @loop_num, i64 0, i64 %indvars.iv181
  %arrayidx31 = getelementptr inbounds [3 x [1 x double]], [3 x [1 x double]]* @loop_coeff, i64 0, i64 %indvars.iv181, i64 0
  %cmp72171 = icmp sgt i32 %11, 0
  %12 = load i32, i32* %arrayidx9, align 4, !tbaa !8
  %cmp10174 = icmp sgt i32 %12, 0
  br i1 %cmp10174, label %for.body11.preheader, label %for.inc97

for.body11.preheader:                             ; preds = %for.body
  %13 = trunc i64 %indvars.iv181 to i32
  %wide.trip.count = zext i32 %11 to i64
  br label %for.body11

for.body11:                                       ; preds = %for.inc94, %for.body11.preheader
  %14 = phi double [ %10, %for.body11.preheader ], [ %23, %for.inc94 ]
  %indvars.iv179 = phi i64 [ 0, %for.body11.preheader ], [ %indvars.iv.next180, %for.inc94 ]
  %arraydecay = getelementptr inbounds [3 x [16 x [6 x i32]]], [3 x [16 x [6 x i32]]]* @loop_table, i64 0, i64 %indvars.iv181, i64 %indvars.iv179, i64 0
  call void @path_product(i32* nonnull %arraydecay, i32 %11) #32
  store double 0.000000e+00, double* %arrayidx20, align 8, !tbaa !4
  %15 = load i32, i32* @sites_on_node, align 4, !tbaa !8
  %cmp22168 = icmp sgt i32 %15, 0
  br i1 %cmp22168, label %for.body23.preheader, label %for.end48

for.body23.preheader:                             ; preds = %for.body11
  %16 = load %struct.site*, %struct.site** @lattice, align 8, !tbaa !10
  br label %for.body23

for.body23:                                       ; preds = %for.body23, %for.body23.preheader
  %17 = phi double [ %21, %for.body23 ], [ %14, %for.body23.preheader ]
  %i.0170 = phi i32 [ %inc47, %for.body23 ], [ 0, %for.body23.preheader ]
  %s.0169 = phi %struct.site* [ %incdec.ptr, %for.body23 ], [ %16, %for.body23.preheader ]
  %tempmat1 = getelementptr inbounds %struct.site, %struct.site* %s.0169, i64 0, i32 22
  %call25 = call { double, double } @trace_su3(%struct.su3_matrix* nonnull %tempmat1) #32
  %18 = extractvalue { double, double } %call25, 0
  %19 = load double, double* %arrayidx20, align 8, !tbaa !4
  %add = fadd double %19, %18
  store double %add, double* %arrayidx20, align 8, !tbaa !4
  %sub = fsub double 3.000000e+00, %18
  %20 = load double, double* %arrayidx31, align 8, !tbaa !4
  %21 = call double @llvm.fmuladd.f64(double %20, double %sub, double %17)
  store double %21, double* %total_action, align 8, !tbaa !4
  %inc47 = add nuw nsw i32 %i.0170, 1
  %incdec.ptr = getelementptr inbounds %struct.site, %struct.site* %s.0169, i64 1
  %22 = load i32, i32* @sites_on_node, align 4, !tbaa !8
  %cmp22 = icmp slt i32 %inc47, %22
  br i1 %cmp22, label %for.body23, label %for.end48, !llvm.loop !27

for.end48:                                        ; preds = %for.body23, %for.body11
  %23 = phi double [ %14, %for.body11 ], [ %21, %for.body23 ]
  call void @g_vecdoublesum(double* nonnull %arrayidx20, i32 1) #32
  %24 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp50 = icmp eq i32 %24, 0
  br i1 %cmp50, label %if.end53, label %if.end70

if.end53:                                         ; preds = %for.end48
  %25 = trunc i64 %indvars.iv179 to i32
  %call52 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.7.20, i64 0, i64 0), i32 %13, i32 %25, i32 %11) #33
  %.pr = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp57 = icmp eq i32 %.pr, 0
  br i1 %cmp57, label %for.end65, label %if.end70

for.end65:                                        ; preds = %if.end53
  %26 = load double, double* %arrayidx20, align 8, !tbaa !4
  %27 = load i32, i32* @volume, align 4, !tbaa !8
  %conv = sitofp i32 %27 to double
  %div = fdiv double %26, %conv
  %call61 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8.21, i64 0, i64 0), double %div) #33
  %.pr164 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp66 = icmp eq i32 %.pr164, 0
  br i1 %cmp66, label %if.then68, label %if.end70

if.then68:                                        ; preds = %for.end65
  %call69 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9.22, i64 0, i64 0)) #33
  br label %if.end70

if.end70:                                         ; preds = %if.then68, %for.end65, %if.end53, %for.end48
  %.pre184 = load i32, i32* @this_node, align 4, !tbaa !8
  br i1 %cmp72171, label %for.body74, label %for.end88

for.body74:                                       ; preds = %for.inc86, %if.end70
  %28 = phi i32 [ %30, %for.inc86 ], [ %.pre184, %if.end70 ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc86 ], [ 0, %if.end70 ]
  %cmp75 = icmp eq i32 %28, 0
  br i1 %cmp75, label %if.then77, label %for.inc86

if.then77:                                        ; preds = %for.body74
  %arrayidx83 = getelementptr inbounds [3 x [16 x [6 x i32]]], [3 x [16 x [6 x i32]]]* @loop_table, i64 0, i64 %indvars.iv181, i64 %indvars.iv179, i64 %indvars.iv
  %29 = load i32, i32* %arrayidx83, align 4, !tbaa !8
  %call84 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10.23, i64 0, i64 0), i32 %29) #33
  %.pre = load i32, i32* @this_node, align 4, !tbaa !8
  br label %for.inc86

for.inc86:                                        ; preds = %if.then77, %for.body74
  %30 = phi i32 [ %28, %for.body74 ], [ %.pre, %if.then77 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end88, label %for.body74, !llvm.loop !28

for.end88:                                        ; preds = %for.inc86, %if.end70
  %31 = phi i32 [ %.pre184, %if.end70 ], [ %30, %for.inc86 ]
  %cmp89 = icmp eq i32 %31, 0
  br i1 %cmp89, label %if.then91, label %for.inc94

if.then91:                                        ; preds = %for.end88
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([3 x i8], [3 x i8]* @str.16.24, i64 0, i64 0))
  br label %for.inc94

for.inc94:                                        ; preds = %if.then91, %for.end88
  %indvars.iv.next180 = add nuw nsw i64 %indvars.iv179, 1
  %32 = load i32, i32* %arrayidx9, align 4, !tbaa !8
  %33 = sext i32 %32 to i64
  %cmp10 = icmp slt i64 %indvars.iv.next180, %33
  br i1 %cmp10, label %for.body11, label %for.inc97, !llvm.loop !29

for.inc97:                                        ; preds = %for.inc94, %for.body
  %34 = phi double [ %10, %for.body ], [ %23, %for.inc94 ]
  %indvars.iv.next182 = add nuw nsw i64 %indvars.iv181, 1
  %exitcond183.not = icmp eq i64 %indvars.iv.next182, 3
  br i1 %exitcond183.not, label %for.end99, label %for.body, !llvm.loop !30

for.end99:                                        ; preds = %for.inc97
  call void @g_doublesum(double* nonnull %total_action) #32
  %35 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp100 = icmp eq i32 %35, 0
  br i1 %cmp100, label %if.end106, label %if.end111

if.end106:                                        ; preds = %for.end99
  %36 = load double, double* %total_action, align 8, !tbaa !4
  %37 = load i32, i32* @volume, align 4, !tbaa !8
  %conv103 = sitofp i32 %37 to double
  %div104 = fdiv double %36, %conv103
  %call105 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str.12.25, i64 0, i64 0), double %div104) #33
  %.pr166 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp107 = icmp eq i32 %.pr166, 0
  br i1 %cmp107, label %if.then109, label %if.end111

if.then109:                                       ; preds = %if.end106
  %38 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !tbaa !10
  %call110 = call i32 @fflush(%struct._IO_FILE* %38) #33
  br label %if.end111

if.end111:                                        ; preds = %if.then109, %if.end106, %for.end99
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %3) #31
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %2) #31
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %1) #31
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %0) #31
  ret void
}

; Function Attrs: nofree noinline nounwind optsize uwtable
define void @printpath(i32* nocapture readonly %path, i32 %length) local_unnamed_addr #13 {
entry:
  %0 = load i32, i32* @this_node, align 4, !tbaa !8
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9.22, i64 0, i64 0)) #33
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %cmp114 = icmp sgt i32 %length, 0
  br i1 %cmp114, label %for.body.preheader, label %if.end.for.end_crit_edge

if.end.for.end_crit_edge:                         ; preds = %if.end
  %.pre18 = load i32, i32* @this_node, align 4, !tbaa !8
  br label %for.end

for.body.preheader:                               ; preds = %if.end
  %wide.trip.count = zext i32 %length to i64
  %.pre17 = load i32, i32* @this_node, align 4, !tbaa !8
  br label %for.body

for.body:                                         ; preds = %for.inc, %for.body.preheader
  %1 = phi i32 [ %.pre17, %for.body.preheader ], [ %3, %for.inc ]
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %cmp2 = icmp eq i32 %1, 0
  br i1 %cmp2, label %if.then3, label %for.inc

if.then3:                                         ; preds = %for.body
  %arrayidx = getelementptr inbounds i32, i32* %path, i64 %indvars.iv
  %2 = load i32, i32* %arrayidx, align 4, !tbaa !8
  %call4 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10.23, i64 0, i64 0), i32 %2) #33
  %.pre = load i32, i32* @this_node, align 4, !tbaa !8
  br label %for.inc

for.inc:                                          ; preds = %if.then3, %for.body
  %3 = phi i32 [ %1, %for.body ], [ %.pre, %if.then3 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !31

for.end:                                          ; preds = %for.inc, %if.end.for.end_crit_edge
  %4 = phi i32 [ %.pre18, %if.end.for.end_crit_edge ], [ %3, %for.inc ]
  %cmp6 = icmp eq i32 %4, 0
  br i1 %cmp6, label %if.then7, label %if.end9

if.then7:                                         ; preds = %for.end
  %call8 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str.13.26, i64 0, i64 0), i32 %length) #33
  br label %if.end9

if.end9:                                          ; preds = %if.then7, %for.end
  ret void
}

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
define void @mult_su3_an(%struct.su3_matrix* nocapture readonly %a, %struct.su3_matrix* nocapture readonly %b, %struct.su3_matrix* nocapture %c) local_unnamed_addr #4 {
entry:
  %real = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 0, i64 0, i32 0
  %imag = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 0, i64 0, i32 1
  %real17 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 1, i64 0, i32 0
  %imag21 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 1, i64 0, i32 1
  %real35 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 2, i64 0, i32 0
  %imag39 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 2, i64 0, i32 1
  %real67 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 0, i64 1, i32 0
  %imag71 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 0, i64 1, i32 1
  %real85 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 1, i64 1, i32 0
  %imag89 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 1, i64 1, i32 1
  %real103 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 2, i64 1, i32 0
  %imag107 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 2, i64 1, i32 1
  %real136 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 0, i64 2, i32 0
  %imag140 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 0, i64 2, i32 1
  %real154 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 1, i64 2, i32 0
  %imag158 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 1, i64 2, i32 1
  %real172 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 2, i64 2, i32 0
  %imag176 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 2, i64 2, i32 1
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %0 = load double, double* %real, align 8, !tbaa !32
  %1 = load double, double* %imag, align 8, !tbaa !34
  %real8 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 0, i64 %indvars.iv, i32 0
  %2 = load double, double* %real8, align 8, !tbaa !32
  %imag13 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 0, i64 %indvars.iv, i32 1
  %3 = load double, double* %imag13, align 8, !tbaa !34
  %4 = load double, double* %real17, align 8, !tbaa !32
  %5 = load double, double* %imag21, align 8, !tbaa !34
  %real26 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 1, i64 %indvars.iv, i32 0
  %6 = load double, double* %real26, align 8, !tbaa !32
  %imag31 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 1, i64 %indvars.iv, i32 1
  %7 = load double, double* %imag31, align 8, !tbaa !34
  %8 = load double, double* %real35, align 8, !tbaa !32
  %9 = load double, double* %imag39, align 8, !tbaa !34
  %real44 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 2, i64 %indvars.iv, i32 0
  %10 = load double, double* %real44, align 8, !tbaa !32
  %imag49 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 2, i64 %indvars.iv, i32 1
  %11 = load double, double* %imag49, align 8, !tbaa !34
  %mul50 = fmul double %1, %3
  %12 = tail call double @llvm.fmuladd.f64(double %0, double %2, double %mul50)
  %13 = tail call double @llvm.fmuladd.f64(double %4, double %6, double %12)
  %14 = tail call double @llvm.fmuladd.f64(double %5, double %7, double %13)
  %15 = tail call double @llvm.fmuladd.f64(double %8, double %10, double %14)
  %16 = tail call double @llvm.fmuladd.f64(double %9, double %11, double %15)
  %real55 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %c, i64 0, i32 0, i64 0, i64 %indvars.iv, i32 0
  store double %16, double* %real55, align 8, !tbaa !32
  %17 = fneg double %1
  %neg = fmul double %2, %17
  %18 = tail call double @llvm.fmuladd.f64(double %0, double %3, double %neg)
  %19 = tail call double @llvm.fmuladd.f64(double %4, double %7, double %18)
  %neg57 = fneg double %5
  %20 = tail call double @llvm.fmuladd.f64(double %neg57, double %6, double %19)
  %21 = tail call double @llvm.fmuladd.f64(double %8, double %11, double %20)
  %neg58 = fneg double %9
  %22 = tail call double @llvm.fmuladd.f64(double %neg58, double %10, double %21)
  %imag63 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %c, i64 0, i32 0, i64 0, i64 %indvars.iv, i32 1
  store double %22, double* %imag63, align 8, !tbaa !34
  %23 = load double, double* %real67, align 8, !tbaa !32
  %24 = load double, double* %imag71, align 8, !tbaa !34
  %25 = load double, double* %real8, align 8, !tbaa !32
  %26 = load double, double* %imag13, align 8, !tbaa !34
  %27 = load double, double* %real85, align 8, !tbaa !32
  %28 = load double, double* %imag89, align 8, !tbaa !34
  %29 = load double, double* %real26, align 8, !tbaa !32
  %30 = load double, double* %imag31, align 8, !tbaa !34
  %31 = load double, double* %real103, align 8, !tbaa !32
  %32 = load double, double* %imag107, align 8, !tbaa !34
  %33 = load double, double* %real44, align 8, !tbaa !32
  %34 = load double, double* %imag49, align 8, !tbaa !34
  %mul118 = fmul double %24, %26
  %35 = tail call double @llvm.fmuladd.f64(double %23, double %25, double %mul118)
  %36 = tail call double @llvm.fmuladd.f64(double %27, double %29, double %35)
  %37 = tail call double @llvm.fmuladd.f64(double %28, double %30, double %36)
  %38 = tail call double @llvm.fmuladd.f64(double %31, double %33, double %37)
  %39 = tail call double @llvm.fmuladd.f64(double %32, double %34, double %38)
  %real123 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %c, i64 0, i32 0, i64 1, i64 %indvars.iv, i32 0
  store double %39, double* %real123, align 8, !tbaa !32
  %40 = fneg double %24
  %neg125 = fmul double %25, %40
  %41 = tail call double @llvm.fmuladd.f64(double %23, double %26, double %neg125)
  %42 = tail call double @llvm.fmuladd.f64(double %27, double %30, double %41)
  %neg126 = fneg double %28
  %43 = tail call double @llvm.fmuladd.f64(double %neg126, double %29, double %42)
  %44 = tail call double @llvm.fmuladd.f64(double %31, double %34, double %43)
  %neg127 = fneg double %32
  %45 = tail call double @llvm.fmuladd.f64(double %neg127, double %33, double %44)
  %imag132 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %c, i64 0, i32 0, i64 1, i64 %indvars.iv, i32 1
  store double %45, double* %imag132, align 8, !tbaa !34
  %46 = load double, double* %real136, align 8, !tbaa !32
  %47 = load double, double* %imag140, align 8, !tbaa !34
  %48 = load double, double* %real8, align 8, !tbaa !32
  %49 = load double, double* %imag13, align 8, !tbaa !34
  %50 = load double, double* %real154, align 8, !tbaa !32
  %51 = load double, double* %imag158, align 8, !tbaa !34
  %52 = load double, double* %real26, align 8, !tbaa !32
  %53 = load double, double* %imag31, align 8, !tbaa !34
  %54 = load double, double* %real172, align 8, !tbaa !32
  %55 = load double, double* %imag176, align 8, !tbaa !34
  %56 = load double, double* %real44, align 8, !tbaa !32
  %57 = load double, double* %imag49, align 8, !tbaa !34
  %mul187 = fmul double %47, %49
  %58 = tail call double @llvm.fmuladd.f64(double %46, double %48, double %mul187)
  %59 = tail call double @llvm.fmuladd.f64(double %50, double %52, double %58)
  %60 = tail call double @llvm.fmuladd.f64(double %51, double %53, double %59)
  %61 = tail call double @llvm.fmuladd.f64(double %54, double %56, double %60)
  %62 = tail call double @llvm.fmuladd.f64(double %55, double %57, double %61)
  %real192 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %c, i64 0, i32 0, i64 2, i64 %indvars.iv, i32 0
  store double %62, double* %real192, align 8, !tbaa !32
  %63 = fneg double %47
  %neg194 = fmul double %48, %63
  %64 = tail call double @llvm.fmuladd.f64(double %46, double %49, double %neg194)
  %65 = tail call double @llvm.fmuladd.f64(double %50, double %53, double %64)
  %neg195 = fneg double %51
  %66 = tail call double @llvm.fmuladd.f64(double %neg195, double %52, double %65)
  %67 = tail call double @llvm.fmuladd.f64(double %54, double %57, double %66)
  %neg196 = fneg double %55
  %68 = tail call double @llvm.fmuladd.f64(double %neg196, double %56, double %67)
  %imag201 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %c, i64 0, i32 0, i64 2, i64 %indvars.iv, i32 1
  store double %68, double* %imag201, align 8, !tbaa !34
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 3
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !35

for.end:                                          ; preds = %for.body
  ret void
}

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @setup() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @initial_set() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @make_3n_gathers() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @third_neighbor(i32, i32, i32, i32, i32* nocapture readonly, i32, i32* nocapture, i32* nocapture, i32* nocapture, i32* nocapture) #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @readin(i32) local_unnamed_addr #1

; Function Attrs: argmemonly mustprogress nofree nounwind optsize willreturn
declare i8* @strcpy(i8* noalias returned writeonly, i8* noalias nocapture readonly) local_unnamed_addr #14

; Function Attrs: noinline nounwind optsize uwtable
declare void @path_product(i32* nocapture readonly, i32) local_unnamed_addr #1

; Function Attrs: mustprogress nofree nounwind optsize willreturn
declare noalias noundef align 16 i8* @calloc(i64 noundef, i64 noundef) local_unnamed_addr #9

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #15

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
define double @su3_rdot(%struct.su3_vector* nocapture readonly %a, %struct.su3_vector* nocapture readonly %b) local_unnamed_addr #0 {
entry:
  %real = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %a, i64 0, i32 0, i64 0, i32 0
  %0 = load double, double* %real, align 8, !tbaa !32
  %real3 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %b, i64 0, i32 0, i64 0, i32 0
  %1 = load double, double* %real3, align 8, !tbaa !32
  %mul = fmul double %0, %1
  %imag = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %a, i64 0, i32 0, i64 0, i32 1
  %2 = load double, double* %imag, align 8, !tbaa !34
  %imag8 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %b, i64 0, i32 0, i64 0, i32 1
  %3 = load double, double* %imag8, align 8, !tbaa !34
  %mul9 = fmul double %2, %3
  %add = fadd double %mul, %mul9
  %real12 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %a, i64 0, i32 0, i64 1, i32 0
  %4 = load double, double* %real12, align 8, !tbaa !32
  %real15 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %b, i64 0, i32 0, i64 1, i32 0
  %5 = load double, double* %real15, align 8, !tbaa !32
  %mul16 = fmul double %4, %5
  %add17 = fadd double %add, %mul16
  %imag20 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %a, i64 0, i32 0, i64 1, i32 1
  %6 = load double, double* %imag20, align 8, !tbaa !34
  %imag23 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %b, i64 0, i32 0, i64 1, i32 1
  %7 = load double, double* %imag23, align 8, !tbaa !34
  %mul24 = fmul double %6, %7
  %add25 = fadd double %add17, %mul24
  %real28 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %a, i64 0, i32 0, i64 2, i32 0
  %8 = load double, double* %real28, align 8, !tbaa !32
  %real31 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %b, i64 0, i32 0, i64 2, i32 0
  %9 = load double, double* %real31, align 8, !tbaa !32
  %mul32 = fmul double %8, %9
  %add33 = fadd double %add25, %mul32
  %imag36 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %a, i64 0, i32 0, i64 2, i32 1
  %10 = load double, double* %imag36, align 8, !tbaa !34
  %imag39 = getelementptr inbounds %struct.su3_vector, %struct.su3_vector* %b, i64 0, i32 0, i64 2, i32 1
  %11 = load double, double* %imag39, align 8, !tbaa !34
  %mul40 = fmul double %10, %11
  %add41 = fadd double %add33, %mul40
  ret double %add41
}

; Function Attrs: nofree noinline nosync nounwind optsize readonly uwtable
define double @realtrace_su3(%struct.su3_matrix* nocapture readonly %a, %struct.su3_matrix* nocapture readonly %b) local_unnamed_addr #16 {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.inc24, %entry
  %indvars.iv47 = phi i64 [ 0, %entry ], [ %indvars.iv.next48, %for.inc24 ]
  %sum.046 = phi double [ 0.000000e+00, %entry ], [ %add, %for.inc24 ]
  br label %for.body3

for.body3:                                        ; preds = %for.body3, %for.cond1.preheader
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader ], [ %indvars.iv.next, %for.body3 ]
  %sum.144 = phi double [ %sum.046, %for.cond1.preheader ], [ %add, %for.body3 ]
  %real = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 %indvars.iv47, i64 %indvars.iv, i32 0
  %0 = load double, double* %real, align 8, !tbaa !32
  %real11 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 %indvars.iv47, i64 %indvars.iv, i32 0
  %1 = load double, double* %real11, align 8, !tbaa !32
  %imag = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %a, i64 0, i32 0, i64 %indvars.iv47, i64 %indvars.iv, i32 1
  %2 = load double, double* %imag, align 8, !tbaa !34
  %imag22 = getelementptr inbounds %struct.su3_matrix, %struct.su3_matrix* %b, i64 0, i32 0, i64 %indvars.iv47, i64 %indvars.iv, i32 1
  %3 = load double, double* %imag22, align 8, !tbaa !34
  %mul23 = fmul double %2, %3
  %4 = tail call double @llvm.fmuladd.f64(double %0, double %1, double %mul23)
  %add = fadd double %sum.144, %4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 3
  br i1 %exitcond.not, label %for.inc24, label %for.body3, !llvm.loop !36

for.inc24:                                        ; preds = %for.body3
  %indvars.iv.next48 = add nuw nsw i64 %indvars.iv47, 1
  %exitcond49.not = icmp eq i64 %indvars.iv.next48, 3
  br i1 %exitcond49.not, label %for.end26, label %for.cond1.preheader, !llvm.loop !37

for.end26:                                        ; preds = %for.inc24
  ret double %add
}

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @su3mat_copy(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @initialize_machine(i32, i8** nocapture) local_unnamed_addr #17

; Function Attrs: noinline nounwind optsize uwtable
declare void @make_nn_gathers() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @neighbor_coords_special(i32, i32, i32, i32, i32* nocapture readonly, i32, i32* nocapture, i32* nocapture, i32* nocapture, i32* nocapture) #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @make_gather(void (i32, i32, i32, i32, i32*, i32, i32*, i32*, i32*, i32*)* nocapture, i32*, i32, i32, i32) local_unnamed_addr #1

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @sort_eight_special(i8** nocapture) local_unnamed_addr #4

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn
declare noalias noundef align 16 i8* @realloc(i8* nocapture, i64 noundef) local_unnamed_addr #15

; Function Attrs: noinline noreturn nounwind optsize uwtable
declare void @terminate(i32) local_unnamed_addr #18

; Function Attrs: noinline nounwind optsize uwtable
declare void @time_stamp(i8*) local_unnamed_addr #1

; Function Attrs: nounwind optsize
declare i64 @time(i64*) local_unnamed_addr #19

; Function Attrs: nounwind optsize
declare i8* @ctime(i64*) local_unnamed_addr #19

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @sort_eight_neighborlists(i32) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare void @neighbor_coords(i32, i32, i32, i32, i32, i32* nocapture, i32* nocapture, i32* nocapture, i32* nocapture) local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @start_handlers() local_unnamed_addr #17

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare noalias %struct.msg_tag* @start_gather(i32, i32, i32, i32, i8** nocapture) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @restart_gather(i32, i32, i32, i32, i8** nocapture, %struct.msg_tag* nocapture) local_unnamed_addr #17

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare noalias %struct.msg_tag* @start_gather_from_temp(i8*, i32, i32, i32, i8** nocapture) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @restart_gather_from_temp(i8* nocapture, i32, i32, i32, i8** nocapture, %struct.msg_tag* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @wait_gather(%struct.msg_tag* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @cleanup_gather(%struct.msg_tag* nocapture) local_unnamed_addr #17

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.msg_tag* @start_general_gather(i32, i32, i32* nocapture readonly, i32, i8** nocapture) local_unnamed_addr #1

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fprintf(%struct._IO_FILE* nocapture noundef, i8* nocapture noundef readonly, ...) local_unnamed_addr #8

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
declare void @wait_general_gather(%struct.msg_tag* nocapture readnone) local_unnamed_addr #20

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @cleanup_general_gather(%struct.msg_tag* nocapture) local_unnamed_addr #17

; Function Attrs: noinline nounwind optsize uwtable
declare i8* @field_pointer_at_coordinates(i32, i32, i32, i32, i32, i32) local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare i8* @field_pointer_at_direction(i32, i32, %struct.site*, i32) local_unnamed_addr #0

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @cleanup_field_pointer(i8* nocapture) local_unnamed_addr #17

; Function Attrs: nofree noinline nounwind optsize uwtable
declare void @send_field(i8* nocapture readnone, i32, i32) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare void @get_field(i8* nocapture readnone, i32) local_unnamed_addr #13

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare i8* @machine_type() local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare i32 @mynode() local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare i32 @numnodes() local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_sync() local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_floatsum(float* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_doublesum(double* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_vecdoublesum(double* nocapture, i32) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_complexsum(%struct.complex* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_dcomplexsum(%struct.complex* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_veccomplexsum(%struct.complex* nocapture, i32) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_wvectorsum(%struct.wilson_vector* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_xor32(i32* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_floatmax(float* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @g_doublemax(double* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @broadcast_float(float* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @broadcast_double(double* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @broadcast_complex(%struct.complex* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @broadcast_dcomplex(%struct.complex* nocapture) local_unnamed_addr #17

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare void @broadcast_bytes(i8* nocapture, i32) local_unnamed_addr #17

; Function Attrs: nofree noinline nounwind optsize uwtable
declare void @send_integer(i32, i32* nocapture readnone) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare void @receive_integer(i32* nocapture readnone) local_unnamed_addr #13

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare double @dclock() local_unnamed_addr #17

; Function Attrs: noinline noreturn nounwind optsize uwtable
declare void @normal_exit(i32) local_unnamed_addr #18

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @sub_su3_matrix(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @cleanup_gathers(%struct.msg_tag** nocapture readonly, %struct.msg_tag** nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @cleanup_dslash_temps() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @dslash_fn(i32, i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @dslash_fn_special(i32, i32, i32, %struct.msg_tag** nocapture, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @dslash_fn_on_temp(%struct.su3_vector*, %struct.su3_vector*, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @dslash_fn_on_temp_special(%struct.su3_vector*, %struct.su3_vector*, i32, %struct.msg_tag** nocapture, i32) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @su3_adjoint(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @accum_gauge_hit(i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @do_hit(i32, i32, i32, i32, double, i32, i32* nocapture readonly, i32* nocapture readonly, i32, i32* nocapture readonly, i32* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare double @get_gauge_fix_action(i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @gaugefixstep(i32, double* nocapture, double, i32, i32* nocapture readonly, i32* nocapture readonly, i32, i32* nocapture readonly, i32* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @gaugefixscratch(i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @gaugefix(i32, double, i32, double, i32, i32, i32, i32* nocapture readonly, i32* nocapture readonly, i32, i32* nocapture readonly, i32* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @save_lattice(i32, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @reload_lattice(i32, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @coldlat() local_unnamed_addr #1

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @ask_starting_lattice(i32, i32* nocapture, i8*) local_unnamed_addr #13

; Function Attrs: nofree nounwind optsize
declare noundef i32 @__isoc99_scanf(i8* nocapture noundef readonly, ...) local_unnamed_addr #8

; Function Attrs: argmemonly mustprogress nofree nounwind readonly willreturn
declare i32 @bcmp(i8* nocapture, i8* nocapture, i64) local_unnamed_addr #21

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #6

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @ask_ending_lattice(i32, i32* nocapture, i8*) local_unnamed_addr #13

; Function Attrs: noinline nounwind optsize uwtable
declare void @funnylat() local_unnamed_addr #1

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @get_f(i32, i8*, double*) local_unnamed_addr #13

; Function Attrs: nofree nounwind optsize
declare noundef i32 @__isoc99_sscanf(i8* nocapture noundef readonly, i8* nocapture noundef readonly, ...) local_unnamed_addr #8

; Function Attrs: argmemonly mustprogress nofree nounwind optsize readonly willreturn
declare i32 @strcmp(i8* nocapture, i8* nocapture) local_unnamed_addr #22

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @get_i(i32, i8*, i32*) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @get_s(i32, i8*, i8*) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @get_prompt(i32*) local_unnamed_addr #13

; Function Attrs: noinline nounwind optsize uwtable
declare double @gaussian_rand_no(%struct.double_prn*) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @sub_su3_vector(%struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @update_h(double) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @grsource_imp(i32, double, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @checkmul_imp(i32, double) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @add_su3_matrix(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @add_su3_vector(%struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @right_su2_hit_a(%struct.su2_matrix*, i32, i32, %struct.su3_matrix*) local_unnamed_addr #1

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @scalar_mult_add_su3_matrix(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture readonly, double, %struct.su3_matrix* nocapture) local_unnamed_addr #4

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare { double, double } @trace_su3(%struct.su3_matrix* nocapture readonly) local_unnamed_addr #0

; Function Attrs: noinline nounwind optsize uwtable
declare void @setup_layout() local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare i32 @node_number(i32, i32, i32, i32) local_unnamed_addr #0

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare i32 @node_index(i32, i32, i32, i32) local_unnamed_addr #0

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn
declare i32 @num_sites(i32) local_unnamed_addr #0

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @mult_su3_mat_vec_sum_4dir(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @d_plaquette(double* nocapture, double* nocapture) local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare void @mult_su3_mat_hwvec(%struct.su3_matrix* nocapture readonly, %struct.half_wilson_vector* nocapture readonly, %struct.half_wilson_vector* nocapture) local_unnamed_addr #11

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @scalar_mult_su3_matrix(%struct.su3_matrix* nocapture readonly, double, %struct.su3_matrix* nocapture) local_unnamed_addr #23

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize readonly uwtable willreturn
declare { double, double } @su3_dot(%struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly) local_unnamed_addr #24

; Function Attrs: noinline nounwind optsize uwtable
declare void @ranmom() local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @make_anti_hermitian(%struct.su3_matrix* nocapture readonly, %struct.anti_hermitmat* nocapture) local_unnamed_addr #23

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @phaseset() local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare void @rephase(i32) local_unnamed_addr #1

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @mult_adj_su3_mat_vec_4dir(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare void @f_meas_imp(i32, i32, double) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @update() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @ks_congrad(i32, i32, double, i32, double, i32, double* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @scalar_mult_add_latvec(i32, i32, double, i32, i32) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @clear_latvec(i32, i32) local_unnamed_addr #10

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @copy_latvec(i32, i32, i32) local_unnamed_addr #4

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @scalar2_mult_add_su3_vector(%struct.su3_vector* nocapture readonly, double, %struct.su3_vector* nocapture readonly, double, %struct.su3_vector* nocapture) local_unnamed_addr #4

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @scalar2_mult_add_latvec(i32, double, i32, double, i32, i32) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare void @scalar_mult_latvec(i32, double, i32, i32) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @mult_su3_nn(%struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
declare void @initialize_prn(%struct.double_prn* nocapture, i32, i32) local_unnamed_addr #20

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare double @myrand(%struct.double_prn* nocapture) local_unnamed_addr #23

; Function Attrs: noinline nounwind optsize uwtable
declare void @left_su2_hit_n(%struct.su2_matrix*, i32, i32, %struct.su3_matrix*) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable writeonly
declare void @clear_su3mat(%struct.su3_matrix* nocapture) local_unnamed_addr #25

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare i32 @check_deviation(double) local_unnamed_addr #11

; Function Attrs: noinline nounwind optsize uwtable
declare void @reunit_report_problem_matrix(%struct.su3_matrix* nocapture readonly, i32, i32) local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline nounwind optsize uwtable willreturn
declare i32 @reunit_su3(%struct.su3_matrix* nocapture) local_unnamed_addr #26

; Function Attrs: noinline nounwind optsize uwtable
declare void @reunitarize() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @update_u(double) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @make_path_table() local_unnamed_addr #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smax.i32(i32, i32) #5

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @add_basic_path(i32* nocapture readonly, i32, double) local_unnamed_addr #1

; Function Attrs: nofree noinline norecurse nosync nounwind optsize readonly uwtable
declare i32 @is_path_equal(i32* nocapture readonly, i32* nocapture readonly, i32) local_unnamed_addr #27

; Function Attrs: noinline nounwind optsize uwtable
declare void @path_transport(i32, i32, i32, i32* nocapture readonly, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @path_transport_hwv(i32, i32, i32, i32* nocapture readonly, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @load_longlinks() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @load_fatlinks() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @compute_gen_staple(i32, i32, i32, i32, double) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @eo_fermion_force(double, i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @u_shift_fermion(%struct.su3_vector*, %struct.su3_vector*, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @add_force_to_mom(%struct.su3_vector*, %struct.su3_vector*, i32, double) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @side_link_force(i32, i32, double, %struct.su3_vector*, %struct.su3_vector*, %struct.su3_vector*, %struct.su3_vector*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @eo_fermion_force_3f(double, i32, i32, i32, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @u_shift_hw_fermion(%struct.half_wilson_vector*, %struct.half_wilson_vector*, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @add_3f_force_to_mom(%struct.half_wilson_vector*, %struct.half_wilson_vector*, i32, double* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @side_link_3f_force(i32, i32, double* nocapture, %struct.half_wilson_vector*, %struct.half_wilson_vector*, %struct.half_wilson_vector*, %struct.half_wilson_vector*) local_unnamed_addr #1

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @byterevn(i32* nocapture, i32) local_unnamed_addr #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.bswap.i32(i32) #5

; Function Attrs: noinline nounwind optsize uwtable
declare double @check_unitarity() local_unnamed_addr #1

; Function Attrs: nofree noinline nounwind optsize uwtable
declare double @check_su3(%struct.su3_matrix* readonly) local_unnamed_addr #13

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @mult_adj_su3_mat_vec(%struct.su3_matrix* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture) local_unnamed_addr #10

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @uncompress_anti_hermitian(%struct.anti_hermitmat* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #23

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare void @mult_su2_mat_vec_elem_a(%struct.su2_matrix* nocapture readonly, %struct.complex* nocapture, %struct.complex* nocapture) local_unnamed_addr #11

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare { double, double } @cmplx(double, double) local_unnamed_addr #17

; Function Attrs: noinline nounwind optsize uwtable
declare void @random_anti_hermitian(%struct.anti_hermitmat* nocapture, %struct.double_prn*) local_unnamed_addr #1

; Function Attrs: nofree noinline nosync nounwind optsize uwtable
declare void @scalar_mult_add_su3_vector(%struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, double, %struct.su3_vector* nocapture) local_unnamed_addr #4

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn
declare void @sub_four_su3_vecs(%struct.su3_vector* nocapture, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly) local_unnamed_addr #23

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare void @mult_adj_su3_mat_hwvec(%struct.su3_matrix* nocapture readonly, %struct.half_wilson_vector* nocapture readonly, %struct.half_wilson_vector* nocapture) local_unnamed_addr #11

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct._IO_FILE* @g_open(i8*, i8*) local_unnamed_addr #1

; Function Attrs: argmemonly mustprogress nofree nounwind optsize readonly willreturn
declare i8* @strchr(i8*, i32) local_unnamed_addr #22

; Function Attrs: nofree optsize
declare noundef i32 @open(i8* nocapture noundef readonly, i32 noundef, ...) local_unnamed_addr #28

; Function Attrs: mustprogress nofree nosync nounwind optsize readnone willreturn
declare i32* @__errno_location() local_unnamed_addr #29

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @g_seek(%struct._IO_FILE* nocapture readonly, i64, i32) local_unnamed_addr #1

; Function Attrs: nounwind optsize
declare i64 @lseek(i32, i64, i32) local_unnamed_addr #19

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i64 @g_write(i8* nocapture readonly, i64, i64, %struct._IO_FILE* nocapture readonly) local_unnamed_addr #13

; Function Attrs: nofree optsize
declare noundef i64 @write(i32 noundef, i8* nocapture noundef readonly, i64 noundef) local_unnamed_addr #28

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i64 @g_read(i8* nocapture, i64, i64, %struct._IO_FILE* nocapture readonly) local_unnamed_addr #13

; Function Attrs: nofree optsize
declare noundef i64 @read(i32 noundef, i8* nocapture noundef, i64 noundef) local_unnamed_addr #28

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @g_close(%struct._IO_FILE* nocapture) local_unnamed_addr #1

; Function Attrs: optsize
declare i32 @close(i32) local_unnamed_addr #30

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
declare void @clearvec(%struct.su3_vector* nocapture) local_unnamed_addr #20

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @qcdhdr_get_str(i8* nocapture readonly, %struct.QCDheader* nocapture readonly, i8** nocapture) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @qcdhdr_get_int(i8* nocapture readonly, %struct.QCDheader* nocapture readonly, i32*) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @qcdhdr_get_int32x(i8* nocapture readonly, %struct.QCDheader* nocapture readonly, i32* nocapture) local_unnamed_addr #13

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @qcdhdr_get_double(i8* nocapture readonly, %struct.QCDheader* nocapture readonly, double*) local_unnamed_addr #13

; Function Attrs: noinline nounwind optsize uwtable
declare void @error_exit(i8* nocapture readonly) local_unnamed_addr #1

; Function Attrs: mustprogress nofree noinline nosync nounwind optsize uwtable willreturn
declare void @complete_U(double*) local_unnamed_addr #11

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn
declare i32 @big_endian() local_unnamed_addr #17

; Function Attrs: nofree noinline nounwind optsize uwtable
declare noalias %struct.QCDheader* @qcdhdr_get_hdr(%struct._IO_FILE* nocapture) local_unnamed_addr #13

; Function Attrs: nofree nounwind optsize
declare noundef i8* @fgets(i8* noundef, i32 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #8

; Function Attrs: argmemonly mustprogress nofree nounwind optsize readonly willreturn
declare i64 @strlen(i8* nocapture) local_unnamed_addr #22

; Function Attrs: noinline nounwind optsize uwtable
declare void @qcdhdr_destroy_hdr(%struct.QCDheader*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @swrite_data(%struct._IO_FILE* nocapture, i8* nocapture, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: nofree nounwind optsize
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
declare void @pwrite_data(%struct._IO_FILE*, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @pswrite_data(i32, %struct._IO_FILE*, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @sread_data(%struct._IO_FILE* nocapture, i8* nocapture, i64, i8*, i8*) local_unnamed_addr #13

; Function Attrs: nofree nounwind optsize
declare noundef i64 @fread(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @pread_data(%struct._IO_FILE*, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @pread_byteorder(i32, %struct._IO_FILE*, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @sread_byteorder(i32, %struct._IO_FILE* nocapture, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @psread_data(i32, %struct._IO_FILE*, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @psread_byteorder(i32, i32, %struct._IO_FILE*, i8*, i64, i8*, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @pwrite_gauge_hdr(%struct._IO_FILE*, %struct.gauge_header*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @swrite_gauge_hdr(%struct._IO_FILE* nocapture, %struct.gauge_header* nocapture) local_unnamed_addr #1

; Function Attrs: nofree noinline nounwind optsize uwtable
declare i32 @write_gauge_info_item(%struct._IO_FILE* nocapture, i8*, i8*, i8*, i32, i32) local_unnamed_addr #13

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, %struct._IO_FILE* nocapture noundef) local_unnamed_addr #6

; Function Attrs: noinline nounwind optsize uwtable
declare void @write_gauge_info_file(%struct.gauge_file* nocapture readonly) local_unnamed_addr #1

; Function Attrs: nofree nounwind optsize
declare noalias noundef %struct._IO_FILE* @fopen(i8* nocapture noundef readonly, i8* nocapture noundef readonly) local_unnamed_addr #8

; Function Attrs: nofree nounwind optsize
declare noundef i32 @sprintf(i8* noalias nocapture noundef writeonly, i8* nocapture noundef readonly, ...) local_unnamed_addr #8

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fclose(%struct._IO_FILE* nocapture noundef) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @setup_input_gauge_file(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @setup_output_gauge_file() local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @w_serial_i(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @read_checksum(i32, %struct.gauge_file*, %struct.gauge_check* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @write_checksum(i32, %struct.gauge_file*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @w_serial(%struct.gauge_file*) local_unnamed_addr #1

; Function Attrs: nofree nounwind optsize
declare noundef i32 @fseek(%struct._IO_FILE* nocapture noundef, i64 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: noinline nounwind optsize uwtable
declare void @w_serial_f(%struct.gauge_file* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @read_site_list(i32, %struct.gauge_file* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @read_v3_gauge_hdr(%struct.gauge_file* nocapture readonly, i32, i32* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @read_1996_gauge_hdr(%struct.gauge_file* nocapture readonly, i32, i32* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @read_gauge_hdr(%struct.gauge_file* nocapture, i32) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @r_serial_i(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @r_serial(%struct.gauge_file*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @r_serial_arch(%struct.gauge_file* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @r_serial_f(%struct.gauge_file* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @write_site_list(%struct._IO_FILE*, %struct.gauge_header* nocapture readonly) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @parallel_open(i32, i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @w_parallel_i(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @w_checkpoint_i(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.su3_matrix* @w_parallel_setup(%struct.gauge_file* nocapture readonly, i64* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @w_parallel(%struct.gauge_file*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @w_checkpoint(%struct.gauge_file*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @w_parallel_f(%struct.gauge_file* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @r_parallel_i(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @r_parallel(%struct.gauge_file*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @r_parallel_f(%struct.gauge_file* nocapture) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @restore_ascii(i8*) local_unnamed_addr #1

; Function Attrs: optsize
declare i32 @__isoc99_fscanf(%struct._IO_FILE*, i8*, ...) local_unnamed_addr #30

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @save_ascii(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @restore_serial(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @restore_parallel(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @save_serial(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @save_parallel(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %struct.gauge_file* @save_checkpoint(i8*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @save_serial_archive(i8*) local_unnamed_addr #1

; Function Attrs: nofree noinline nounwind optsize uwtable
declare noalias %struct.gauge_file* @save_parallel_archive(i8* nocapture readnone) local_unnamed_addr #13

; Function Attrs: nofree noinline norecurse nosync nounwind optsize uwtable
declare void @su3_projector(%struct.su3_vector* nocapture readonly, %struct.su3_vector* nocapture readonly, %struct.su3_matrix* nocapture) local_unnamed_addr #10

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @main(i32, i8**) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare void @make_lattice() local_unnamed_addr #1

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind optsize readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nosync nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn }
attributes #4 = { nofree noinline nosync nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nofree nounwind }
attributes #7 = { noreturn nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { mustprogress nofree nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { nofree noinline norecurse nosync nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { mustprogress nofree noinline nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { argmemonly nofree nounwind willreturn writeonly }
attributes #13 = { nofree noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #14 = { argmemonly mustprogress nofree nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #15 = { inaccessiblemem_or_argmemonly mustprogress nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #16 = { nofree noinline nosync nounwind optsize readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #17 = { mustprogress nofree noinline norecurse nosync nounwind optsize readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #18 = { noinline noreturn nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #19 = { nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #20 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #21 = { argmemonly mustprogress nofree nounwind readonly willreturn }
attributes #22 = { argmemonly mustprogress nofree nounwind optsize readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #23 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #24 = { mustprogress nofree noinline nosync nounwind optsize readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #25 = { nofree noinline norecurse nosync nounwind optsize uwtable writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #26 = { mustprogress nofree noinline nounwind optsize uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #27 = { nofree noinline norecurse nosync nounwind optsize readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #28 = { nofree optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #29 = { mustprogress nofree nosync nounwind optsize readnone willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #30 = { optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #31 = { nounwind }
attributes #32 = { nounwind optsize }
attributes #33 = { optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"double", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"int", !6, i64 0}
!10 = !{!11, !11, i64 0}
!11 = !{!"any pointer", !6, i64 0}
!12 = !{i64 0, i64 8, !4, i64 8, i64 8, !4}
!13 = !{i64 0, i64 8, !4}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !15}
!17 = distinct !{!17, !15}
!18 = distinct !{!18, !15}
!19 = distinct !{!19, !15}
!20 = distinct !{!20, !15}
!21 = distinct !{!21, !15}
!22 = distinct !{!22, !15}
!23 = distinct !{!23, !15}
!24 = distinct !{!24, !15}
!25 = distinct !{!25, !15}
!26 = distinct !{!26, !15}
!27 = distinct !{!27, !15}
!28 = distinct !{!28, !15}
!29 = distinct !{!29, !15}
!30 = distinct !{!30, !15}
!31 = distinct !{!31, !15}
!32 = !{!33, !5, i64 0}
!33 = !{!"", !5, i64 0, !5, i64 8}
!34 = !{!33, !5, i64 8}
!35 = distinct !{!35, !15}
!36 = distinct !{!36, !15}
!37 = distinct !{!37, !15}
