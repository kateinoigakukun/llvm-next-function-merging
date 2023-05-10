; RUN: %opt -S --passes="mergefunc,multiple-func-merging" -func-merging-explore=1 --multiple-func-merging-whole-program=true --multiple-func-merging-coalescing=false --multiple-func-merging-hyfm-nw -multiple-func-merging-hyfm-profitability=true -o %t.mfm-hyfm.ll %s
; RUN: %llc --filetype=obj %s -o %t.baseline.o
; RUN: %llc --filetype=obj %t.mfm-hyfm.ll -o %t.mfm-hyfm.o
; RUN: test $(stat -c%%s %t.mfm-hyfm.o) -lt $(stat -c%%s %t.baseline.o)

; ModuleID = './473.astar/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%class.wayobj = type <{ i32, i32, i32, i32, i32, i32, i32, i32, i32, float, float, float, float, float, %struct.createwaymnginfot, %struct.createwayinfot, [4 x i8], i16*, %struct.waymapcellt*, i32*, i32*, i32, i32, i8, [3 x i8], i32, i16, i16, [4 x i8] }>
%struct.createwaymnginfot = type { float, float, float, float, i32, i32, float, float }
%struct.createwayinfot = type <{ %class.rvectort, %class.rvectort, i8, [3 x i8] }>
%class.rvectort = type { float, float, float }
%struct.waymapcellt = type { i16, i16 }
%struct.wayinfot = type { i8, %class.rvectort*, i32, i8 }

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #2

; Function Attrs: nobuiltin optsize allocsize(0)
declare nonnull i8* @_Znam(i64) local_unnamed_addr #3

; Function Attrs: nobuiltin nounwind optsize
declare void @_ZdaPv(i8*) local_unnamed_addr #4

; Function Attrs: noinline nounwind optsize uwtable
declare { <2 x float>, float } @_ZN6wayobj8getpointEi(%class.wayobj* nocapture nonnull readonly align 8 dereferenceable(172), i32) local_unnamed_addr #5 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN8rvectortC2Ev(%class.rvectort* nonnull align 4 dereferenceable(12)) unnamed_addr #5 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @_ZN6wayobj5indexEii(%class.wayobj* nonnull align 8 dereferenceable(172), i32, i32) local_unnamed_addr #5 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @_ZN6wayobj6indexxEi(%class.wayobj* nonnull align 8 dereferenceable(172), i32) local_unnamed_addr #5 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare i32 @_ZN6wayobj6indexyEi(%class.wayobj* nonnull align 8 dereferenceable(172), i32) local_unnamed_addr #5 align 2

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline optsize uwtable
define zeroext i1 @_ZN6wayobj11createwayarEiiR8wayinfot(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %startindex, i32 %endindex, %struct.wayinfot* nocapture nonnull align 8 dereferenceable(24) %wayinfo) local_unnamed_addr #6 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %deltaar = alloca [8 x %struct.waymapcellt], align 16
  %0 = bitcast [8 x %struct.waymapcellt]* %deltaar to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %0) #7
  %arrayinit.begin = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 0
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.begin, i16 signext -1, i16 signext 1) #8
  %arrayinit.element = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 1
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element, i16 signext 0, i16 signext 1) #8
  %arrayinit.element2 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 2
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element2, i16 signext 1, i16 signext 1) #8
  %arrayinit.element3 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 3
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element3, i16 signext 1, i16 signext 0) #8
  %arrayinit.element4 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 4
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element4, i16 signext 1, i16 signext -1) #8
  %arrayinit.element5 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 5
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element5, i16 signext 0, i16 signext -1) #8
  %arrayinit.element6 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 6
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element6, i16 signext -1, i16 signext -1) #8
  %arrayinit.element7 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 7
  call void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4) %arrayinit.element7, i16 signext -1, i16 signext 0) #8
  %step = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 26
  %1 = load i16, i16* %step, align 8, !tbaa !4
  %conv = sext i16 %1 to i32
  %2 = sext i16 %1 to i64
  %3 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %2, i64 12)
  %4 = extractvalue { i64, i1 } %3, 1
  %5 = extractvalue { i64, i1 } %3, 0
  %6 = select i1 %4, i64 -1, i64 %5
  %call = call noalias nonnull i8* @_Znam(i64 %6) #9
  %7 = bitcast i8* %call to %class.rvectort*
  %isempty = icmp eq i16 %1, 0
  br i1 %isempty, label %arrayctor.cont, label %new.ctorloop

new.ctorloop:                                     ; preds = %entry
  %arrayctor.end = getelementptr inbounds %class.rvectort, %class.rvectort* %7, i64 %2
  br label %arrayctor.loop

arrayctor.loop:                                   ; preds = %arrayctor.loop, %new.ctorloop
  %arrayctor.cur = phi %class.rvectort* [ %7, %new.ctorloop ], [ %arrayctor.next, %arrayctor.loop ]
  call void @_ZN8rvectortC2Ev(%class.rvectort* nonnull align 4 dereferenceable(12) %arrayctor.cur) #8
  %arrayctor.next = getelementptr inbounds %class.rvectort, %class.rvectort* %arrayctor.cur, i64 1
  %arrayctor.done = icmp eq %class.rvectort* %arrayctor.next, %arrayctor.end
  br i1 %arrayctor.done, label %arrayctor.cont, label %arrayctor.loop

arrayctor.cont:                                   ; preds = %arrayctor.loop, %entry
  %waymap8 = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 18
  %8 = load %struct.waymapcellt*, %struct.waymapcellt** %waymap8, align 8, !tbaa !16
  %call9 = call i32 @_ZN6wayobj6indexxEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %startindex) #8
  %call10 = call i32 @_ZN6wayobj6indexyEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %startindex) #8
  %fillnum103 = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 27
  %cmp304 = icmp sgt i16 %1, 2
  br i1 %cmp304, label %for.body.preheader, label %for.end156

for.body.preheader:                               ; preds = %arrayctor.cont
  %9 = add nsw i64 %2, -2
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc154
  %indvars.iv = phi i64 [ %9, %for.body.preheader ], [ %indvars.iv.next, %for.inc154 ]
  %index.0307 = phi i32 [ %endindex, %for.body.preheader ], [ %call99.lcssa.sink, %for.inc154 ]
  %call11 = call i32 @_ZN6wayobj6indexxEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %index.0307) #8
  %call12 = call i32 @_ZN6wayobj6indexyEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %index.0307) #8
  %sub13 = sub nsw i32 %call9, %call11
  %sub14 = sub nsw i32 %call10, %call12
  %cmp16.not = icmp ne i32 %sub13, 0
  %spec.store.select = sext i1 %cmp16.not to i32
  %cmp15.inv = icmp slt i32 %sub13, 1
  %dpx.0 = select i1 %cmp15.inv, i32 %spec.store.select, i32 1
  %cmp22.not = icmp ne i32 %sub14, 0
  %spec.store.select189 = sext i1 %cmp22.not to i32
  %cmp19.inv = icmp slt i32 %sub14, 1
  %spec.store.select189.op = mul nsw i32 %spec.store.select189, 100
  %mul = select i1 %cmp19.inv, i32 %spec.store.select189.op, i32 100
  %mul26 = mul nsw i32 %dpx.0, 241
  %cmp27.not = icmp slt i32 %mul, %mul26
  %10 = xor i1 %cmp27.not, true
  %mul32 = mul nsw i32 %dpx.0, 41
  %cmp33.not = icmp slt i32 %mul, %mul32
  %11 = xor i1 %cmp33.not, true
  %mul38 = mul nsw i32 %dpx.0, -40
  %cmp39.not = icmp slt i32 %mul, %mul38
  %12 = xor i1 %cmp39.not, true
  %mul44 = mul nsw i32 %dpx.0, -240
  %cmp45.not = icmp slt i32 %mul, %mul44
  %13 = xor i1 %cmp45.not, true
  %or.cond = select i1 %10, i1 %13, i1 false
  br i1 %or.cond, label %for.body90.preheader, label %if.end52

if.end52:                                         ; preds = %for.body
  %or.cond190 = select i1 %11, i1 %cmp27.not, i1 false
  br i1 %or.cond190, label %for.body90.preheader, label %if.end57

if.end57:                                         ; preds = %if.end52
  %or.cond191 = select i1 %12, i1 %cmp33.not, i1 false
  br i1 %or.cond191, label %for.body90.preheader, label %if.end62

if.end62:                                         ; preds = %if.end57
  %or.cond192 = select i1 %13, i1 %cmp39.not, i1 false
  br i1 %or.cond192, label %for.body90.preheader, label %if.end67

if.end67:                                         ; preds = %if.end62
  %or.cond193 = select i1 %cmp27.not, i1 %cmp45.not, i1 false
  br i1 %or.cond193, label %for.body90.preheader, label %if.end72

if.end72:                                         ; preds = %if.end67
  %or.cond194 = select i1 %10, i1 %cmp33.not, i1 false
  br i1 %or.cond194, label %for.body90.preheader, label %if.end77

if.end77:                                         ; preds = %if.end72
  %or.cond195 = select i1 %11, i1 %cmp39.not, i1 false
  br i1 %or.cond195, label %for.body90.preheader, label %if.end82

if.end82:                                         ; preds = %if.end77
  %or.cond196 = select i1 %12, i1 %cmp45.not, i1 false
  %. = select i1 %or.cond196, i32 0, i32 6
  br label %for.body90.preheader

for.body90.preheader:                             ; preds = %if.end82, %if.end77, %if.end72, %if.end67, %if.end62, %if.end57, %if.end52, %for.body
  %delta2num.0303.in.in.ph = phi i32 [ %., %if.end82 ], [ 7, %if.end77 ], [ 6, %if.end72 ], [ 5, %if.end67 ], [ 4, %if.end62 ], [ 3, %if.end57 ], [ 2, %if.end52 ], [ 1, %for.body ]
  br label %for.body90

for.body90:                                       ; preds = %for.body90.preheader, %if.end148
  %delta2num.0303.in.in = phi i32 [ %delta2num.0303, %if.end148 ], [ %delta2num.0303.in.in.ph, %for.body90.preheader ]
  %j.0302 = phi i32 [ %inc, %if.end148 ], [ 0, %for.body90.preheader ]
  %delta1num.0301 = phi i32 [ %spec.store.select197, %if.end148 ], [ %delta2num.0303.in.in.ph, %for.body90.preheader ]
  %delta2num.0303.in = add nuw nsw i32 %delta2num.0303.in.in, 1
  %delta2num.0303 = and i32 %delta2num.0303.in, 7
  %idxprom314 = zext i32 %delta1num.0301 to i64
  %x91 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 %idxprom314, i32 0
  %14 = load i16, i16* %x91, align 4, !tbaa !17
  %conv92 = sext i16 %14 to i32
  %add93 = add nsw i32 %call11, %conv92
  %y96 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 %idxprom314, i32 1
  %15 = load i16, i16* %y96, align 2, !tbaa !19
  %conv97 = sext i16 %15 to i32
  %add98 = add nsw i32 %call12, %conv97
  %call99 = call i32 @_ZN6wayobj5indexEii(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %add93, i32 %add98) #8
  %idxprom100 = sext i32 %call99 to i64
  %fillnum = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom100, i32 0
  %16 = load i16, i16* %fillnum, align 2, !tbaa !20
  %17 = load i16, i16* %fillnum103, align 2, !tbaa !22
  %cmp105 = icmp eq i16 %16, %17
  br i1 %cmp105, label %if.then106, label %if.end116

if.then106:                                       ; preds = %for.body90
  %num = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom100, i32 1
  %18 = load i16, i16* %num, align 2, !tbaa !23
  %19 = zext i16 %18 to i64
  %cmp110 = icmp eq i64 %indvars.iv, %19
  br i1 %cmp110, label %for.inc154, label %if.end116

if.end116:                                        ; preds = %if.then106, %for.body90
  %20 = zext i32 %delta2num.0303 to i64
  %x119 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 %20, i32 0
  %21 = load i16, i16* %x119, align 4, !tbaa !17
  %conv120 = sext i16 %21 to i32
  %add121 = add nsw i32 %call11, %conv120
  %y124 = getelementptr inbounds [8 x %struct.waymapcellt], [8 x %struct.waymapcellt]* %deltaar, i64 0, i64 %20, i32 1
  %22 = load i16, i16* %y124, align 2, !tbaa !19
  %conv125 = sext i16 %22 to i32
  %add126 = add nsw i32 %call12, %conv125
  %call127 = call i32 @_ZN6wayobj5indexEii(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %add121, i32 %add126) #8
  %idxprom128 = sext i32 %call127 to i64
  %fillnum130 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom128, i32 0
  %23 = load i16, i16* %fillnum130, align 2, !tbaa !20
  %24 = load i16, i16* %fillnum103, align 2, !tbaa !22
  %cmp134 = icmp eq i16 %23, %24
  br i1 %cmp134, label %if.then135, label %if.end148

if.then135:                                       ; preds = %if.end116
  %num138 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom128, i32 1
  %25 = load i16, i16* %num138, align 2, !tbaa !23
  %26 = zext i16 %25 to i64
  %cmp140 = icmp eq i64 %indvars.iv, %26
  br i1 %cmp140, label %for.inc154, label %if.end148

if.end148:                                        ; preds = %if.then135, %if.end116
  %dec = add nsw i32 %delta1num.0301, -1
  %cmp149 = icmp slt i32 %delta1num.0301, 1
  %spec.store.select197 = select i1 %cmp149, i32 7, i32 %dec
  %inc = add nuw nsw i32 %j.0302, 1
  %exitcond.not = icmp eq i32 %inc, 4
  br i1 %exitcond.not, label %delete.notnull, label %for.body90, !llvm.loop !24

delete.notnull:                                   ; preds = %if.end148
  call void @_ZdaPv(i8* nonnull %call) #10
  br label %cleanup

for.inc154:                                       ; preds = %if.then135, %if.then106
  %call99.lcssa.sink = phi i32 [ %call99, %if.then106 ], [ %call127, %if.then135 ]
  %call112 = call { <2 x float>, float } @_ZN6wayobj8getpointEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %call99.lcssa.sink) #8
  %call112.fca.0.extract = extractvalue { <2 x float>, float } %call112, 0
  %call112.fca.1.extract = extractvalue { <2 x float>, float } %call112, 1
  %arrayidx114 = getelementptr inbounds %class.rvectort, %class.rvectort* %7, i64 %indvars.iv
  %ref.tmp.sroa.0.0..sroa_cast204 = bitcast %class.rvectort* %arrayidx114 to <2 x float>*
  store <2 x float> %call112.fca.0.extract, <2 x float>* %ref.tmp.sroa.0.0..sroa_cast204, align 4
  %ref.tmp.sroa.4.0..sroa_idx206 = getelementptr inbounds %class.rvectort, %class.rvectort* %7, i64 %indvars.iv, i32 2
  store float %call112.fca.1.extract, float* %ref.tmp.sroa.4.0..sroa_idx206, align 4
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %cmp = icmp sgt i64 %indvars.iv, 1
  br i1 %cmp, label %for.body, label %for.end156, !llvm.loop !26

for.end156:                                       ; preds = %for.inc154, %arrayctor.cont
  %createwayinfo = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 15
  %27 = bitcast %struct.createwayinfot* %createwayinfo to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %call, i8* noundef nonnull align 8 dereferenceable(12) %27, i64 12, i1 false), !tbaa.struct !27
  %finishp = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 15, i32 1
  %sub159 = add nsw i32 %conv, -1
  %idxprom160 = sext i32 %sub159 to i64
  %arrayidx161 = getelementptr inbounds %class.rvectort, %class.rvectort* %7, i64 %idxprom160
  %28 = bitcast %class.rvectort* %arrayidx161 to i8*
  %29 = bitcast %class.rvectort* %finishp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %28, i8* noundef nonnull align 4 dereferenceable(12) %29, i64 12, i1 false), !tbaa.struct !27
  %flexist = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 0
  store i8 1, i8* %flexist, align 8, !tbaa !29
  %wayarp162 = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 1
  %30 = bitcast %class.rvectort** %wayarp162 to i8**
  store i8* %call, i8** %30, align 8, !tbaa !31
  %wayarsize = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 2
  store i32 %conv, i32* %wayarsize, align 8, !tbaa !32
  %flcorrect = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 3
  store i8 0, i8* %flcorrect, align 4, !tbaa !33
  br label %cleanup

cleanup:                                          ; preds = %for.end156, %delete.notnull
  %cmp298 = phi i1 [ true, %for.end156 ], [ false, %delete.notnull ]
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %0) #7
  ret i1 %cmp298
}

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN8point16tC2Ess(%struct.waymapcellt* nonnull align 2 dereferenceable(4), i16 signext, i16 signext) unnamed_addr #5 align 2

; Function Attrs: noinline optsize uwtable
define zeroext i1 @_ZN6wayobj12createwayar2EiiR8wayinfot(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %startindex, i32 %endindex, %struct.wayinfot* nocapture nonnull align 8 dereferenceable(24) %wayinfo) local_unnamed_addr #6 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %step = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 26
  %0 = load i16, i16* %step, align 8, !tbaa !4
  %conv = sext i16 %0 to i32
  %1 = sext i16 %0 to i64
  %2 = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %1, i64 12)
  %3 = extractvalue { i64, i1 } %2, 1
  %4 = extractvalue { i64, i1 } %2, 0
  %5 = select i1 %3, i64 -1, i64 %4
  %call = tail call noalias nonnull i8* @_Znam(i64 %5) #9
  %6 = bitcast i8* %call to %class.rvectort*
  %isempty = icmp eq i16 %0, 0
  br i1 %isempty, label %arrayctor.cont, label %new.ctorloop

new.ctorloop:                                     ; preds = %entry
  %arrayctor.end = getelementptr inbounds %class.rvectort, %class.rvectort* %6, i64 %1
  br label %arrayctor.loop

arrayctor.loop:                                   ; preds = %arrayctor.loop, %new.ctorloop
  %arrayctor.cur = phi %class.rvectort* [ %6, %new.ctorloop ], [ %arrayctor.next, %arrayctor.loop ]
  tail call void @_ZN8rvectortC2Ev(%class.rvectort* nonnull align 4 dereferenceable(12) %arrayctor.cur) #8
  %arrayctor.next = getelementptr inbounds %class.rvectort, %class.rvectort* %arrayctor.cur, i64 1
  %arrayctor.done = icmp eq %class.rvectort* %arrayctor.next, %arrayctor.end
  br i1 %arrayctor.done, label %arrayctor.cont, label %arrayctor.loop

arrayctor.cont:                                   ; preds = %arrayctor.loop, %entry
  %maply = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 8
  %7 = load i32, i32* %maply, align 8, !tbaa !34
  %waymap2 = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 18
  %8 = load %struct.waymapcellt*, %struct.waymapcellt** %waymap2, align 8, !tbaa !16
  %call3 = tail call i32 @_ZN6wayobj6indexxEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %startindex) #8
  %call4 = tail call i32 @_ZN6wayobj6indexyEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %startindex) #8
  %fillnum85 = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 27
  %cmp501 = icmp sgt i16 %0, 2
  br i1 %cmp501, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %arrayctor.cont
  %9 = add nsw i64 %1, -2
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %indvars.iv = phi i64 [ %9, %for.body.preheader ], [ %indvars.iv.next, %for.inc ]
  %index.0504 = phi i32 [ %endindex, %for.body.preheader ], [ %inc254.sink, %for.inc ]
  %call5 = tail call i32 @_ZN6wayobj6indexxEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %index.0504) #8
  %call6 = tail call i32 @_ZN6wayobj6indexyEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %index.0504) #8
  %sub7 = sub nsw i32 %call3, %call5
  %sub8 = sub nsw i32 %call4, %call6
  %cmp10.not = icmp ne i32 %sub7, 0
  %spec.store.select = sext i1 %cmp10.not to i32
  %cmp9.inv = icmp slt i32 %sub7, 1
  %dpx.0 = select i1 %cmp9.inv, i32 %spec.store.select, i32 1
  %cmp16.not = icmp ne i32 %sub8, 0
  %spec.store.select301 = sext i1 %cmp16.not to i32
  %cmp13.inv = icmp slt i32 %sub8, 1
  %spec.store.select301.op = mul nsw i32 %spec.store.select301, 100
  %mul = select i1 %cmp13.inv, i32 %spec.store.select301.op, i32 100
  %mul20 = mul nsw i32 %dpx.0, 241
  %cmp21.not = icmp slt i32 %mul, %mul20
  %10 = xor i1 %cmp21.not, true
  %mul26 = mul nsw i32 %dpx.0, 41
  %cmp27.not = icmp slt i32 %mul, %mul26
  %11 = xor i1 %cmp27.not, true
  %mul32 = mul nsw i32 %dpx.0, -40
  %cmp33.not = icmp slt i32 %mul, %mul32
  %12 = xor i1 %cmp33.not, true
  %mul38 = mul nsw i32 %dpx.0, -240
  %cmp39.not = icmp slt i32 %mul, %mul38
  %13 = xor i1 %cmp39.not, true
  %or.cond = select i1 %10, i1 %13, i1 false
  br i1 %or.cond, label %getsector, label %if.end46

if.end46:                                         ; preds = %for.body
  %or.cond302 = select i1 %11, i1 %cmp21.not, i1 false
  br i1 %or.cond302, label %getsector, label %if.end51

if.end51:                                         ; preds = %if.end46
  %or.cond303 = select i1 %12, i1 %cmp27.not, i1 false
  br i1 %or.cond303, label %getsector, label %if.end56

if.end56:                                         ; preds = %if.end51
  %or.cond304 = select i1 %13, i1 %cmp33.not, i1 false
  br i1 %or.cond304, label %getsector, label %if.end61

if.end61:                                         ; preds = %if.end56
  %or.cond305 = select i1 %cmp21.not, i1 %cmp39.not, i1 false
  br i1 %or.cond305, label %getsector, label %if.end66

if.end66:                                         ; preds = %if.end61
  %or.cond306 = select i1 %10, i1 %cmp27.not, i1 false
  br i1 %or.cond306, label %getsector, label %if.end71

if.end71:                                         ; preds = %if.end66
  %or.cond307 = select i1 %11, i1 %cmp33.not, i1 false
  br i1 %or.cond307, label %getsector, label %if.end76

if.end76:                                         ; preds = %if.end71
  %or.cond308 = select i1 %12, i1 %cmp39.not, i1 false
  %. = select i1 %or.cond308, i32 1, i32 -1
  br label %getsector

getsector:                                        ; preds = %if.end76, %if.end71, %if.end66, %if.end61, %if.end56, %if.end51, %if.end46, %for.body
  %dy.0 = phi i32 [ 1, %for.body ], [ 1, %if.end46 ], [ 0, %if.end51 ], [ -1, %if.end56 ], [ -1, %if.end61 ], [ -1, %if.end66 ], [ 0, %if.end71 ], [ %., %if.end76 ]
  %dx.0 = phi i32 [ 0, %for.body ], [ 1, %if.end46 ], [ 1, %if.end51 ], [ 1, %if.end56 ], [ 0, %if.end61 ], [ -1, %if.end66 ], [ -1, %if.end71 ], [ -1, %if.end76 ]
  %add = add nsw i32 %dx.0, %call5
  %add82 = add nsw i32 %dy.0, %call6
  %call83 = tail call i32 @_ZN6wayobj5indexEii(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %add, i32 %add82) #8
  %idxprom = sext i32 %call83 to i64
  %fillnum = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom, i32 0
  %14 = load i16, i16* %fillnum, align 2, !tbaa !20
  %15 = load i16, i16* %fillnum85, align 2, !tbaa !22
  %cmp87 = icmp eq i16 %14, %15
  br i1 %cmp87, label %if.then88, label %if.end98

if.then88:                                        ; preds = %getsector
  %num = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom, i32 1
  %16 = load i16, i16* %num, align 2, !tbaa !23
  %17 = zext i16 %16 to i64
  %cmp92 = icmp eq i64 %indvars.iv, %17
  br i1 %cmp92, label %for.inc, label %if.end98

if.end98:                                         ; preds = %if.then88, %getsector
  %sub99 = sub nsw i32 %index.0504, %7
  %sub100 = add nsw i32 %sub99, -1
  %idxprom101 = sext i32 %sub100 to i64
  %fillnum103 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom101, i32 0
  %18 = load i16, i16* %fillnum103, align 2, !tbaa !20
  %cmp107 = icmp eq i16 %18, %15
  br i1 %cmp107, label %if.then108, label %if.end121

if.then108:                                       ; preds = %if.end98
  %num111 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom101, i32 1
  %19 = load i16, i16* %num111, align 2, !tbaa !23
  %20 = zext i16 %19 to i64
  %cmp113 = icmp eq i64 %indvars.iv, %20
  br i1 %cmp113, label %for.inc, label %if.end121

if.end121:                                        ; preds = %if.then108, %if.end98
  %idxprom122 = sext i32 %sub99 to i64
  %fillnum124 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom122, i32 0
  %21 = load i16, i16* %fillnum124, align 2, !tbaa !20
  %cmp128 = icmp eq i16 %21, %15
  br i1 %cmp128, label %if.then129, label %if.end142

if.then129:                                       ; preds = %if.end121
  %num132 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom122, i32 1
  %22 = load i16, i16* %num132, align 2, !tbaa !23
  %23 = zext i16 %22 to i64
  %cmp134 = icmp eq i64 %indvars.iv, %23
  br i1 %cmp134, label %for.inc, label %if.end142

if.end142:                                        ; preds = %if.then129, %if.end121
  %inc143 = add nsw i32 %sub99, 1
  %idxprom144 = sext i32 %inc143 to i64
  %fillnum146 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom144, i32 0
  %24 = load i16, i16* %fillnum146, align 2, !tbaa !20
  %cmp150 = icmp eq i16 %24, %15
  br i1 %cmp150, label %if.then151, label %if.end164

if.then151:                                       ; preds = %if.end142
  %num154 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom144, i32 1
  %25 = load i16, i16* %num154, align 2, !tbaa !23
  %26 = zext i16 %25 to i64
  %cmp156 = icmp eq i64 %indvars.iv, %26
  br i1 %cmp156, label %for.inc, label %if.end164

if.end164:                                        ; preds = %if.then151, %if.end142
  %sub165 = add nsw i32 %index.0504, -1
  %idxprom166 = sext i32 %sub165 to i64
  %fillnum168 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom166, i32 0
  %27 = load i16, i16* %fillnum168, align 2, !tbaa !20
  %cmp172 = icmp eq i16 %27, %15
  br i1 %cmp172, label %if.then173, label %if.end186

if.then173:                                       ; preds = %if.end164
  %num176 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom166, i32 1
  %28 = load i16, i16* %num176, align 2, !tbaa !23
  %29 = zext i16 %28 to i64
  %cmp178 = icmp eq i64 %indvars.iv, %29
  br i1 %cmp178, label %for.inc, label %if.end186

if.end186:                                        ; preds = %if.then173, %if.end164
  %add187 = add nsw i32 %index.0504, 1
  %idxprom188 = sext i32 %add187 to i64
  %fillnum190 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom188, i32 0
  %30 = load i16, i16* %fillnum190, align 2, !tbaa !20
  %cmp194 = icmp eq i16 %30, %15
  br i1 %cmp194, label %if.then195, label %if.end208

if.then195:                                       ; preds = %if.end186
  %num198 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom188, i32 1
  %31 = load i16, i16* %num198, align 2, !tbaa !23
  %32 = zext i16 %31 to i64
  %cmp200 = icmp eq i64 %indvars.iv, %32
  br i1 %cmp200, label %for.inc, label %if.end208

if.end208:                                        ; preds = %if.then195, %if.end186
  %add209 = add nsw i32 %index.0504, %7
  %sub210 = add nsw i32 %add209, -1
  %idxprom211 = sext i32 %sub210 to i64
  %fillnum213 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom211, i32 0
  %33 = load i16, i16* %fillnum213, align 2, !tbaa !20
  %cmp217 = icmp eq i16 %33, %15
  br i1 %cmp217, label %if.then218, label %if.end231

if.then218:                                       ; preds = %if.end208
  %num221 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom211, i32 1
  %34 = load i16, i16* %num221, align 2, !tbaa !23
  %35 = zext i16 %34 to i64
  %cmp223 = icmp eq i64 %indvars.iv, %35
  br i1 %cmp223, label %for.inc, label %if.end231

if.end231:                                        ; preds = %if.then218, %if.end208
  %idxprom233 = sext i32 %add209 to i64
  %fillnum235 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom233, i32 0
  %36 = load i16, i16* %fillnum235, align 2, !tbaa !20
  %cmp239 = icmp eq i16 %36, %15
  br i1 %cmp239, label %if.then240, label %if.end253

if.then240:                                       ; preds = %if.end231
  %num243 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom233, i32 1
  %37 = load i16, i16* %num243, align 2, !tbaa !23
  %38 = zext i16 %37 to i64
  %cmp245 = icmp eq i64 %indvars.iv, %38
  br i1 %cmp245, label %for.inc, label %if.end253

if.end253:                                        ; preds = %if.then240, %if.end231
  %inc254 = add nsw i32 %add209, 1
  %idxprom255 = sext i32 %inc254 to i64
  %fillnum257 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom255, i32 0
  %39 = load i16, i16* %fillnum257, align 2, !tbaa !20
  %cmp261 = icmp eq i16 %39, %15
  br i1 %cmp261, label %if.then262, label %delete.notnull

if.then262:                                       ; preds = %if.end253
  %num265 = getelementptr inbounds %struct.waymapcellt, %struct.waymapcellt* %8, i64 %idxprom255, i32 1
  %40 = load i16, i16* %num265, align 2, !tbaa !23
  %41 = zext i16 %40 to i64
  %cmp267 = icmp eq i64 %indvars.iv, %41
  br i1 %cmp267, label %for.inc, label %delete.notnull

delete.notnull:                                   ; preds = %if.end253, %if.then262
  tail call void @_ZdaPv(i8* nonnull %call) #10
  br label %cleanup

for.inc:                                          ; preds = %if.then262, %if.then240, %if.then218, %if.then195, %if.then173, %if.then151, %if.then129, %if.then108, %if.then88
  %inc254.sink = phi i32 [ %call83, %if.then88 ], [ %sub100, %if.then108 ], [ %sub99, %if.then129 ], [ %inc143, %if.then151 ], [ %sub165, %if.then173 ], [ %add187, %if.then195 ], [ %sub210, %if.then218 ], [ %add209, %if.then240 ], [ %inc254, %if.then262 ]
  %call270 = tail call { <2 x float>, float } @_ZN6wayobj8getpointEi(%class.wayobj* nonnull align 8 dereferenceable(172) %this, i32 %inc254.sink) #8
  %call270.fca.0.extract = extractvalue { <2 x float>, float } %call270, 0
  %call270.fca.1.extract = extractvalue { <2 x float>, float } %call270, 1
  %arrayidx273 = getelementptr inbounds %class.rvectort, %class.rvectort* %6, i64 %indvars.iv
  %ref.tmp269.sroa.0.0..sroa_cast310 = bitcast %class.rvectort* %arrayidx273 to <2 x float>*
  store <2 x float> %call270.fca.0.extract, <2 x float>* %ref.tmp269.sroa.0.0..sroa_cast310, align 4
  %ref.tmp269.sroa.4.0..sroa_idx312 = getelementptr inbounds %class.rvectort, %class.rvectort* %6, i64 %indvars.iv, i32 2
  store float %call270.fca.1.extract, float* %ref.tmp269.sroa.4.0..sroa_idx312, align 4
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %cmp = icmp sgt i64 %indvars.iv, 1
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !35

for.end:                                          ; preds = %for.inc, %arrayctor.cont
  %createwayinfo = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 15
  %42 = bitcast %struct.createwayinfot* %createwayinfo to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %call, i8* noundef nonnull align 8 dereferenceable(12) %42, i64 12, i1 false), !tbaa.struct !27
  %finishp = getelementptr inbounds %class.wayobj, %class.wayobj* %this, i64 0, i32 15, i32 1
  %sub278 = add nsw i32 %conv, -1
  %idxprom279 = sext i32 %sub278 to i64
  %arrayidx280 = getelementptr inbounds %class.rvectort, %class.rvectort* %6, i64 %idxprom279
  %43 = bitcast %class.rvectort* %arrayidx280 to i8*
  %44 = bitcast %class.rvectort* %finishp to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(12) %43, i8* noundef nonnull align 4 dereferenceable(12) %44, i64 12, i1 false), !tbaa.struct !27
  %flexist = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 0
  store i8 1, i8* %flexist, align 8, !tbaa !29
  %wayarp281 = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 1
  %45 = bitcast %class.rvectort** %wayarp281 to i8**
  store i8* %call, i8** %45, align 8, !tbaa !31
  %wayarsize = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 2
  store i32 %conv, i32* %wayarsize, align 8, !tbaa !32
  %flcorrect = getelementptr inbounds %struct.wayinfot, %struct.wayinfot* %wayinfo, i64 0, i32 3
  store i8 0, i8* %flcorrect, align 4, !tbaa !33
  br label %cleanup

cleanup:                                          ; preds = %for.end, %delete.notnull
  %cmp500 = phi i1 [ true, %for.end ], [ false, %delete.notnull ]
  ret i1 %cmp500
}

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nobuiltin optsize allocsize(0) "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nobuiltin nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nounwind }
attributes #8 = { optsize }
attributes #9 = { builtin optsize allocsize(0) }
attributes #10 = { builtin nounwind optsize }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !15, i64 168}
!5 = !{!"_ZTS6wayobj", !6, i64 0, !6, i64 4, !6, i64 8, !6, i64 12, !6, i64 16, !6, i64 20, !6, i64 24, !6, i64 28, !6, i64 32, !9, i64 36, !9, i64 40, !9, i64 44, !9, i64 48, !9, i64 52, !10, i64 56, !11, i64 88, !14, i64 120, !14, i64 128, !14, i64 136, !14, i64 144, !6, i64 152, !6, i64 156, !13, i64 160, !6, i64 164, !15, i64 168, !15, i64 170}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = !{!"float", !7, i64 0}
!10 = !{!"_ZTS17createwaymnginfot", !9, i64 0, !9, i64 4, !9, i64 8, !9, i64 12, !6, i64 16, !6, i64 20, !9, i64 24, !9, i64 28}
!11 = !{!"_ZTS14createwayinfot", !12, i64 0, !12, i64 12, !13, i64 24}
!12 = !{!"_ZTS8rvectort", !9, i64 0, !9, i64 4, !9, i64 8}
!13 = !{!"bool", !7, i64 0}
!14 = !{!"any pointer", !7, i64 0}
!15 = !{!"short", !7, i64 0}
!16 = !{!5, !14, i64 128}
!17 = !{!18, !15, i64 0}
!18 = !{!"_ZTS8point16t", !15, i64 0, !15, i64 2}
!19 = !{!18, !15, i64 2}
!20 = !{!21, !15, i64 0}
!21 = !{!"_ZTS11waymapcellt", !15, i64 0, !15, i64 2}
!22 = !{!5, !15, i64 170}
!23 = !{!21, !15, i64 2}
!24 = distinct !{!24, !25}
!25 = !{!"llvm.loop.unroll.disable"}
!26 = distinct !{!26, !25}
!27 = !{i64 0, i64 4, !28, i64 4, i64 4, !28, i64 8, i64 4, !28}
!28 = !{!9, !9, i64 0}
!29 = !{!30, !13, i64 0}
!30 = !{!"_ZTS8wayinfot", !13, i64 0, !14, i64 8, !6, i64 16, !13, i64 20}
!31 = !{!30, !14, i64 8}
!32 = !{!30, !6, i64 16}
!33 = !{!30, !13, i64 20}
!34 = !{!5, !6, i64 32}
!35 = distinct !{!35, !25}
