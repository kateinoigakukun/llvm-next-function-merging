static bool CmpNumbers(uint64_t L, uint64_t R) {
  return L==R;
}

// Any two pointers in the same address space are equivalent, intptr_t and
// pointers are equivalent. Otherwise, standard type equivalence rules apply.
static bool CmpTypes(Type *TyL, Type *TyR, const DataLayout *DL) {
  PointerType *PTyL = dyn_cast<PointerType>(TyL);
  PointerType *PTyR = dyn_cast<PointerType>(TyR);

  //const DataLayout &DL = FnL->getParent()->getDataLayout();
  if (PTyL && PTyL->getAddressSpace() == 0)
    TyL = DL->getIntPtrType(TyL);
  if (PTyR && PTyR->getAddressSpace() == 0)
    TyR = DL->getIntPtrType(TyR);

  if (TyL == TyR)
    return 0;

  if (int Res = CmpNumbers(TyL->getTypeID(), TyR->getTypeID()))
    return Res;

  switch (TyL->getTypeID()) {
  default:
    llvm_unreachable("Unknown type!");
  case Type::IntegerTyID:
    return CmpNumbers(cast<IntegerType>(TyL)->getBitWidth(),
                      cast<IntegerType>(TyR)->getBitWidth());
  // TyL == TyR would have returned true earlier, because types are uniqued.
  case Type::VoidTyID:
  case Type::FloatTyID:
  case Type::DoubleTyID:
  case Type::X86_FP80TyID:
  case Type::FP128TyID:
  case Type::PPC_FP128TyID:
  case Type::LabelTyID:
  case Type::MetadataTyID:
  case Type::TokenTyID:
    return 0;

  case Type::PointerTyID:
    assert(PTyL && PTyR && "Both types must be pointers here.");
    return CmpNumbers(PTyL->getAddressSpace(), PTyR->getAddressSpace());

  case Type::StructTyID: {
    StructType *STyL = cast<StructType>(TyL);
    StructType *STyR = cast<StructType>(TyR);
    if (STyL->getNumElements() != STyR->getNumElements())
      return CmpNumbers(STyL->getNumElements(), STyR->getNumElements());

    if (STyL->isPacked() != STyR->isPacked())
      return CmpNumbers(STyL->isPacked(), STyR->isPacked());

    for (unsigned i = 0, e = STyL->getNumElements(); i != e; ++i) {
      if (int Res = CmpTypes(STyL->getElementType(i), STyR->getElementType(i), DL))
        return Res;
    }
    return 0;
  }

  case Type::FunctionTyID: {
    FunctionType *FTyL = cast<FunctionType>(TyL);
    FunctionType *FTyR = cast<FunctionType>(TyR);
    if (FTyL->getNumParams() != FTyR->getNumParams())
      return CmpNumbers(FTyL->getNumParams(), FTyR->getNumParams());

    if (FTyL->isVarArg() != FTyR->isVarArg())
      return CmpNumbers(FTyL->isVarArg(), FTyR->isVarArg());

    if (int Res = CmpTypes(FTyL->getReturnType(), FTyR->getReturnType(), DL))
      return Res;

    for (unsigned i = 0, e = FTyL->getNumParams(); i != e; ++i) {
      if (int Res = CmpTypes(FTyL->getParamType(i), FTyR->getParamType(i), DL))
        return Res;
    }
    return 0;
  }

  case Type::ArrayTyID: {
    auto *STyL = cast<ArrayType>(TyL);
    auto *STyR = cast<ArrayType>(TyR);
    if (STyL->getNumElements() != STyR->getNumElements())
      return CmpNumbers(STyL->getNumElements(), STyR->getNumElements());
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL);
  }
  case Type::FixedVectorTyID:
  case Type::ScalableVectorTyID: {
    auto *STyL = cast<VectorType>(TyL);
    auto *STyR = cast<VectorType>(TyR);
    if (STyL->getElementCount().isScalable() !=
        STyR->getElementCount().isScalable())
      return CmpNumbers(STyL->getElementCount().isScalable(),
                        STyR->getElementCount().isScalable());
    if (STyL->getElementCount() != STyR->getElementCount())
      return CmpNumbers(STyL->getElementCount().getKnownMinValue(),
                        STyR->getElementCount().getKnownMinValue());
    return CmpTypes(STyL->getElementType(), STyR->getElementType(), DL);
  }
  }
}

static bool matchIntrinsicCalls(Intrinsic::ID ID, const CallBase *CI1,
                                const CallBase *CI2) {
  Intrinsic::ID ID1;
  Intrinsic::ID ID2;
  if (Function *F = CI1->getCalledFunction())
    ID1 = (Intrinsic::ID)F->getIntrinsicID();
  if (Function *F = CI2->getCalledFunction())
    ID2 = (Intrinsic::ID)F->getIntrinsicID();

  if (ID1 != ID)
    return false;
  if (ID1 != ID2)
    return false;

  switch (ID) {
  default:
    break;
  case Intrinsic::coro_id: {
    /*
    auto *InfoArg = CS.getArgOperand(3)->stripPointerCasts();
    if (isa<ConstantPointerNull>(InfoArg))
      break;
    auto *GV = dyn_cast<GlobalVariable>(InfoArg);
    Assert(GV && GV->isConstant() && GV->hasDefinitiveInitializer(),
      "info argument of llvm.coro.begin must refer to an initialized "
      "constant");
    Constant *Init = GV->getInitializer();
    Assert(isa<ConstantStruct>(Init) || isa<ConstantArray>(Init),
      "info argument of llvm.coro.begin must refer to either a struct or "
      "an array");
    */
    break;
  }
  case Intrinsic::ctlz: // llvm.ctlz
  case Intrinsic::cttz: // llvm.cttz
    //is_zero_undef argument of bit counting intrinsics must be a constant int
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::experimental_constrained_fadd:
  case Intrinsic::experimental_constrained_fsub:
  case Intrinsic::experimental_constrained_fmul:
  case Intrinsic::experimental_constrained_fdiv:
  case Intrinsic::experimental_constrained_frem:
  case Intrinsic::experimental_constrained_fma:
  case Intrinsic::experimental_constrained_sqrt:
  case Intrinsic::experimental_constrained_pow:
  case Intrinsic::experimental_constrained_powi:
  case Intrinsic::experimental_constrained_sin:
  case Intrinsic::experimental_constrained_cos:
  case Intrinsic::experimental_constrained_exp:
  case Intrinsic::experimental_constrained_exp2:
  case Intrinsic::experimental_constrained_log:
  case Intrinsic::experimental_constrained_log10:
  case Intrinsic::experimental_constrained_log2:
  case Intrinsic::experimental_constrained_rint:
  case Intrinsic::experimental_constrained_nearbyint:
    // visitConstrainedFPIntrinsic(
    //    cast<ConstrainedFPIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_declare: // llvm.dbg.declare
    // Assert(isa<MetadataAsValue>(CS.getArgOperand(0)),
    //       "invalid llvm.dbg.declare intrinsic call 1", CS);
    // visitDbgIntrinsic("declare",
    // cast<DbgInfoIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_addr: // llvm.dbg.addr
    // visitDbgIntrinsic("addr", cast<DbgInfoIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_value: // llvm.dbg.value
    // visitDbgIntrinsic("value", cast<DbgInfoIntrinsic>(*CS.getInstruction()));
    break;
  case Intrinsic::dbg_label: // llvm.dbg.label
    // visitDbgLabelIntrinsic("label",
    // cast<DbgLabelInst>(*CS.getInstruction()));
    break;
  case Intrinsic::memcpy:
  case Intrinsic::memmove:
  case Intrinsic::memset: {
    //isvolatile argument of memory intrinsics must be a constant int
    return CI1->getArgOperand(3) == CI2->getArgOperand(3);
  }
  case Intrinsic::memcpy_element_unordered_atomic:
  case Intrinsic::memmove_element_unordered_atomic:
  case Intrinsic::memset_element_unordered_atomic: {
    const auto *AMI1 = cast<AtomicMemIntrinsic>(CI1);
    const auto *AMI2 = cast<AtomicMemIntrinsic>(CI2);

    ConstantInt *ElementSizeCI1 =
        dyn_cast<ConstantInt>(AMI1->getRawElementSizeInBytes());

    ConstantInt *ElementSizeCI2 =
        dyn_cast<ConstantInt>(AMI2->getRawElementSizeInBytes());

    return (ElementSizeCI1!=nullptr && ElementSizeCI1==ElementSizeCI2);
  }
  case Intrinsic::gcroot:
  case Intrinsic::gcwrite:
  case Intrinsic::gcread:
    //llvm.gcroot parameter #2 must be a constant.
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::init_trampoline:
    break;
  case Intrinsic::prefetch:
    //arguments #2 and #3 in llvm.prefetch must be constants
    return CI1->getArgOperand(1) == CI2->getArgOperand(1) &&
           CI1->getArgOperand(2) == CI2->getArgOperand(2);
  case Intrinsic::stackprotector:
    /*
    Assert(isa<AllocaInst>(CS.getArgOperand(1)->stripPointerCasts()),
           "llvm.stackprotector parameter #2 must resolve to an alloca.", CS);
    */
    break;
  case Intrinsic::lifetime_start:
  case Intrinsic::lifetime_end:
  case Intrinsic::invariant_start:
    //size argument of memory use markers must be a constant integer
    return CI1->getArgOperand(0) == CI2->getArgOperand(0);
  case Intrinsic::invariant_end:
    //llvm.invariant.end parameter #2 must be a constant integer
    return CI1->getArgOperand(1) == CI2->getArgOperand(1);
  case Intrinsic::localescape: {
    /*
    BasicBlock *BB = CS.getParent();
    Assert(BB == &BB->getParent()->front(),
           "llvm.localescape used outside of entry block", CS);
    Assert(!SawFrameEscape,
           "multiple calls to llvm.localescape in one function", CS);
    for (Value *Arg : CS.args()) {
      if (isa<ConstantPointerNull>(Arg))
        continue; // Null values are allowed as placeholders.
      auto *AI = dyn_cast<AllocaInst>(Arg->stripPointerCasts());
      Assert(AI && AI->isStaticAlloca(),
             "llvm.localescape only accepts static allocas", CS);
    }
    FrameEscapeInfo[BB->getParent()].first = CS.getNumArgOperands();
    SawFrameEscape = true;
    */
    break;
  }
  case Intrinsic::localrecover: {
    /*
    Value *FnArg = CS.getArgOperand(0)->stripPointerCasts();
    Function *Fn = dyn_cast<Function>(FnArg);
    Assert(Fn && !Fn->isDeclaration(),
           "llvm.localrecover first "
           "argument must be function defined in this module",
           CS);
    auto *IdxArg = dyn_cast<ConstantInt>(CS.getArgOperand(2));
    Assert(IdxArg, "idx argument of llvm.localrecover must be a constant int",
           CS);
    auto &Entry = FrameEscapeInfo[Fn];
    Entry.second = unsigned(
        std::max(uint64_t(Entry.second), IdxArg->getLimitedValue(~0U) + 1));
    */
    break;
  }
    /*
    case Intrinsic::experimental_gc_statepoint:
      Assert(!CS.isInlineAsm(),
             "gc.statepoint support for inline assembly unimplemented", CS);
      Assert(CS.getParent()->getParent()->hasGC(),
             "Enclosing function does not use GC.", CS);

      verifyStatepoint(CS);
      break;
    case Intrinsic::experimental_gc_result: {
      Assert(CS.getParent()->getParent()->hasGC(),
             "Enclosing function does not use GC.", CS);
      // Are we tied to a statepoint properly?
      CallSite StatepointCS(CS.getArgOperand(0));
      const Function *StatepointFn =
        StatepointCS.getInstruction() ? StatepointCS.getCalledFunction() :
    nullptr; Assert(StatepointFn && StatepointFn->isDeclaration() &&
                 StatepointFn->getIntrinsicID() ==
                     Intrinsic::experimental_gc_statepoint,
             "gc.result operand #1 must be from a statepoint", CS,
             CS.getArgOperand(0));

      // Assert that result type matches wrapped callee.
      const Value *Target = StatepointCS.getArgument(2);
      auto *PT = cast<PointerType>(Target->getType());
      auto *TargetFuncType = cast<FunctionType>(PT->getElementType());
      Assert(CS.getType() == TargetFuncType->getReturnType(),
             "gc.result result type does not match wrapped callee", CS);
      break;
    }
    case Intrinsic::experimental_gc_relocate: {
      Assert(CS.getNumArgOperands() == 3, "wrong number of arguments", CS);

      Assert(isa<PointerType>(CS.getType()->getScalarType()),
             "gc.relocate must return a pointer or a vector of pointers", CS);

      // Check that this relocate is correctly tied to the statepoint

      // This is case for relocate on the unwinding path of an invoke statepoint
      if (LandingPadInst *LandingPad =
            dyn_cast<LandingPadInst>(CS.getArgOperand(0))) {

        const BasicBlock *InvokeBB =
            LandingPad->getParent()->getUniquePredecessor();

        // Landingpad relocates should have only one predecessor with invoke
        // statepoint terminator
        Assert(InvokeBB, "safepoints should have unique landingpads",
               LandingPad->getParent());
        Assert(InvokeBB->getTerminator(), "safepoint block should be well
    formed", InvokeBB); Assert(isStatepoint(InvokeBB->getTerminator()), "gc
    relocate should be linked to a statepoint", InvokeBB);
      }
      else {
        // In all other cases relocate should be tied to the statepoint
    directly.
        // This covers relocates on a normal return path of invoke statepoint
    and
        // relocates of a call statepoint.
        auto Token = CS.getArgOperand(0);
        Assert(isa<Instruction>(Token) &&
    isStatepoint(cast<Instruction>(Token)), "gc relocate is incorrectly tied to
    the statepoint", CS, Token);
      }

      // Verify rest of the relocate arguments.

      ImmutableCallSite StatepointCS(
          cast<GCRelocateInst>(*CS.getInstruction()).getStatepoint());

      // Both the base and derived must be piped through the safepoint.
      Value* Base = CS.getArgOperand(1);
      Assert(isa<ConstantInt>(Base),
             "gc.relocate operand #2 must be integer offset", CS);

      Value* Derived = CS.getArgOperand(2);
      Assert(isa<ConstantInt>(Derived),
             "gc.relocate operand #3 must be integer offset", CS);

      const int BaseIndex = cast<ConstantInt>(Base)->getZExtValue();
      const int DerivedIndex = cast<ConstantInt>(Derived)->getZExtValue();
      // Check the bounds
      Assert(0 <= BaseIndex && BaseIndex < (int)StatepointCS.arg_size(),
             "gc.relocate: statepoint base index out of bounds", CS);
      Assert(0 <= DerivedIndex && DerivedIndex < (int)StatepointCS.arg_size(),
             "gc.relocate: statepoint derived index out of bounds", CS);

      // Check that BaseIndex and DerivedIndex fall within the 'gc parameters'
      // section of the statepoint's argument.
      Assert(StatepointCS.arg_size() > 0,
             "gc.statepoint: insufficient arguments");
      Assert(isa<ConstantInt>(StatepointCS.getArgument(3)),
             "gc.statement: number of call arguments must be constant integer");
      const unsigned NumCallArgs =
          cast<ConstantInt>(StatepointCS.getArgument(3))->getZExtValue();
      Assert(StatepointCS.arg_size() > NumCallArgs + 5,
             "gc.statepoint: mismatch in number of call arguments");
      Assert(isa<ConstantInt>(StatepointCS.getArgument(NumCallArgs + 5)),
             "gc.statepoint: number of transition arguments must be "
             "a constant integer");
      const int NumTransitionArgs =
          cast<ConstantInt>(StatepointCS.getArgument(NumCallArgs + 5))
              ->getZExtValue();
      const int DeoptArgsStart = 4 + NumCallArgs + 1 + NumTransitionArgs + 1;
      Assert(isa<ConstantInt>(StatepointCS.getArgument(DeoptArgsStart)),
             "gc.statepoint: number of deoptimization arguments must be "
             "a constant integer");
      const int NumDeoptArgs =
          cast<ConstantInt>(StatepointCS.getArgument(DeoptArgsStart))
              ->getZExtValue();
      const int GCParamArgsStart = DeoptArgsStart + 1 + NumDeoptArgs;
      const int GCParamArgsEnd = StatepointCS.arg_size();
      Assert(GCParamArgsStart <= BaseIndex && BaseIndex < GCParamArgsEnd,
             "gc.relocate: statepoint base index doesn't fall within the "
             "'gc parameters' section of the statepoint call",
             CS);
      Assert(GCParamArgsStart <= DerivedIndex && DerivedIndex < GCParamArgsEnd,
             "gc.relocate: statepoint derived index doesn't fall within the "
             "'gc parameters' section of the statepoint call",
             CS);

      // Relocated value must be either a pointer type or vector-of-pointer
    type,
      // but gc_relocate does not need to return the same pointer type as the
      // relocated pointer. It can be casted to the correct type later if it's
      // desired. However, they must have the same address space and
    'vectorness' GCRelocateInst &Relocate =
    cast<GCRelocateInst>(*CS.getInstruction());
      Assert(Relocate.getDerivedPtr()->getType()->isPtrOrPtrVectorTy(),
             "gc.relocate: relocated value must be a gc pointer", CS);

      auto ResultType = CS.getType();
      auto DerivedType = Relocate.getDerivedPtr()->getType();
      Assert(ResultType->isVectorTy() == DerivedType->isVectorTy(),
             "gc.relocate: vector relocates to vector and pointer to pointer",
             CS);
      Assert(
          ResultType->getPointerAddressSpace() ==
              DerivedType->getPointerAddressSpace(),
          "gc.relocate: relocating a pointer shouldn't change its address
    space", CS); break;
    }
    case Intrinsic::eh_exceptioncode:
    case Intrinsic::eh_exceptionpointer: {
      Assert(isa<CatchPadInst>(CS.getArgOperand(0)),
             "eh.exceptionpointer argument must be a catchpad", CS);
      break;
    }
    case Intrinsic::masked_load: {
      Assert(CS.getType()->isVectorTy(), "masked_load: must return a vector",
    CS);

      Value *Ptr = CS.getArgOperand(0);
      //Value *Alignment = CS.getArgOperand(1);
      Value *Mask = CS.getArgOperand(2);
      Value *PassThru = CS.getArgOperand(3);
      Assert(Mask->getType()->isVectorTy(),
             "masked_load: mask must be vector", CS);

      // DataTy is the overloaded type
      Type *DataTy = cast<PointerType>(Ptr->getType())->getElementType();
      Assert(DataTy == CS.getType(),
             "masked_load: return must match pointer type", CS);
      Assert(PassThru->getType() == DataTy,
             "masked_load: pass through and data type must match", CS);
      Assert(Mask->getType()->getVectorNumElements() ==
             DataTy->getVectorNumElements(),
             "masked_load: vector mask must be same length as data", CS);
      break;
    }
    case Intrinsic::masked_store: {
      Value *Val = CS.getArgOperand(0);
      Value *Ptr = CS.getArgOperand(1);
      //Value *Alignment = CS.getArgOperand(2);
      Value *Mask = CS.getArgOperand(3);
      Assert(Mask->getType()->isVectorTy(),
             "masked_store: mask must be vector", CS);

      // DataTy is the overloaded type
      Type *DataTy = cast<PointerType>(Ptr->getType())->getElementType();
      Assert(DataTy == Val->getType(),
             "masked_store: storee must match pointer type", CS);
      Assert(Mask->getType()->getVectorNumElements() ==
             DataTy->getVectorNumElements(),
             "masked_store: vector mask must be same length as data", CS);
      break;
    }

    case Intrinsic::experimental_guard: {
      Assert(CS.isCall(), "experimental_guard cannot be invoked", CS);
      Assert(CS.countOperandBundlesOfType(LLVMContext::OB_deopt) == 1,
             "experimental_guard must have exactly one "
             "\"deopt\" operand bundle");
      break;
    }

    case Intrinsic::experimental_deoptimize: {
      Assert(CS.isCall(), "experimental_deoptimize cannot be invoked", CS);
      Assert(CS.countOperandBundlesOfType(LLVMContext::OB_deopt) == 1,
             "experimental_deoptimize must have exactly one "
             "\"deopt\" operand bundle");
      Assert(CS.getType() ==
    CS.getInstruction()->getFunction()->getReturnType(),
             "experimental_deoptimize return type must match caller return
    type");

      if (CS.isCall()) {
        auto *DeoptCI = CS.getInstruction();
        auto *RI = dyn_cast<ReturnInst>(DeoptCI->getNextNode());
        Assert(RI,
               "calls to experimental_deoptimize must be followed by a return");

        if (!CS.getType()->isVoidTy() && RI)
          Assert(RI->getReturnValue() == DeoptCI,
                 "calls to experimental_deoptimize must be followed by a return
    " "of the value computed by experimental_deoptimize");
      }

      break;
    }
    */
  };
  return false; // TODO: change to false by default
}

//bool FunctionMerger::matchLandingPad(LandingPadInst *LP1, LandingPadInst *LP2) {
static  bool matchLandingPad(LandingPadInst *LP1, LandingPadInst *LP2) {
  if (LP1->getType() != LP2->getType())
    return false;
  if (LP1->isCleanup() != LP2->isCleanup())
    return false;
  if (LP1->getNumClauses() != LP2->getNumClauses())
    return false;
  for (unsigned i = 0; i < LP1->getNumClauses(); i++) {
    if (LP1->isCatch(i) != LP2->isCatch(i))
      return false;
    if (LP1->isFilter(i) != LP2->isFilter(i))
      return false;
    if (LP1->getClause(i) != LP2->getClause(i))
      return false;
  }
  return true;
}

static bool matchLoadInsts(const LoadInst *LI1, const LoadInst *LI2) {
  return LI1->isVolatile() == LI2->isVolatile() &&
         LI1->getAlignment() == LI2->getAlignment() &&
         LI1->getOrdering() == LI2->getOrdering();
}

static bool matchStoreInsts(const StoreInst *SI1, const StoreInst *SI2) {
  return SI1->isVolatile() == SI2->isVolatile() &&
         SI1->getAlignment() == SI2->getAlignment() &&
         SI1->getOrdering() == SI2->getOrdering();
}

static bool matchAllocaInsts(const AllocaInst *AI1, const AllocaInst *AI2) {
  if (AI1->getArraySize() != AI2->getArraySize() ||
      AI1->getAlignment() != AI2->getAlignment())
    return false;

  /*
  // If size is known, I2 can be seen as equivalent to I1 if it allocates
  // the same or less memory.
  if (DL->getTypeAllocSize(AI->getAllocatedType())
        < DL->getTypeAllocSize(cast<AllocaInst>(I2)->getAllocatedType()))
    return false;

  */

  return true;
}

static bool matchGetElementPtrInsts(const GetElementPtrInst *GEP1, const GetElementPtrInst *GEP2) {
  Type *Ty1 = GEP1->getSourceElementType();
  SmallVector<Value*, 16> Idxs1(GEP1->idx_begin(), GEP1->idx_end());

  Type *Ty2 = GEP2->getSourceElementType();
  SmallVector<Value*, 16> Idxs2(GEP2->idx_begin(), GEP2->idx_end());

  if (Ty1!=Ty2) return false;
  if (Idxs1.size()!=Idxs2.size()) return false;

  if (Idxs1.empty())
    return true;

  for (unsigned i = 1; i<Idxs1.size(); i++) {
    Value *V1 = Idxs1[i];
    Value *V2 = Idxs2[i];

    //structs must have constant indices, therefore they must be constants and must be identical when merging
    if (isa<StructType>(Ty1)) {
      if (V1!=V2) return false;
    }
    Ty1 = GetElementPtrInst::getTypeAtIndex(Ty1, V1);
    Ty2 = GetElementPtrInst::getTypeAtIndex(Ty2, V2);
    if (Ty1!=Ty2) return false;
  }
  return true;
}

static bool matchSwitchInsts(const SwitchInst *SI1, const SwitchInst *SI2) {
  if (SI1->getNumCases() == SI2->getNumCases()) {
    auto CaseIt1 = SI1->case_begin(), CaseEnd1 = SI1->case_end();
    auto CaseIt2 = SI2->case_begin(), CaseEnd2 = SI2->case_end();
    do {
      auto *Case1 = &*CaseIt1;
      auto *Case2 = &*CaseIt2;
      if (Case1 != Case2)
        return false; // TODO: could allow permutation!
      ++CaseIt1;
      ++CaseIt2;
    } while (CaseIt1 != CaseEnd1 && CaseIt2 != CaseEnd2);
    return true;
  }
  return false;
}

static bool matchCallInsts(const CallBase *CI1, const CallBase *CI2) {
  if (CI1->isInlineAsm() || CI2->isInlineAsm())
    return false;

  //if (CI1->getCalledFunction()==nullptr) return false;

  if (CI1->getCalledFunction() != CI2->getCalledFunction())
    return false;
 
  if (Function *F = CI1->getCalledFunction()) {
    if (Intrinsic::ID ID = (Intrinsic::ID)F->getIntrinsicID()) {
      if (!matchIntrinsicCalls(ID, CI1, CI2))
        return false;
    }
  }

  return CI1->getNumArgOperands() == CI2->getNumArgOperands()
      && CI1->getCallingConv() == CI2->getCallingConv()
      && CI1->getAttributes() == CI2->getAttributes();
}

static bool matchInvokeInsts(const InvokeInst *II1, const InvokeInst *II2) {
    return matchCallInsts(II1,II2) && II1->getCallingConv() == II2->getCallingConv()
        && II1->getAttributes() == II2->getAttributes()
        && matchLandingPad(II1->getLandingPadInst(), II2->getLandingPadInst());
}

static bool matchInsertValueInsts(const InsertValueInst *IV1, const InsertValueInst *IV2) {
    return IV1->getIndices() == IV2->getIndices();
}

static bool matchExtractValueInsts(const ExtractValueInst *EV1, const ExtractValueInst *EV2) {
    return EV1->getIndices() == EV2->getIndices();
}

static bool matchFenceInsts(const FenceInst *FI1, const FenceInst *FI2) {
    return FI1->getOrdering() == FI2->getOrdering() &&
           FI1->getSyncScopeID() == FI2->getSyncScopeID();
}
