#ifndef LLVM_TRANSFORMS_IPO_SALSSACODEGEN_H
#define LLVM_TRANSFORMS_IPO_SALSSACODEGEN_H

#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/Transforms/IPO/FunctionMerging.h"

namespace llvm {

class FunctionMerger {
private:
  Module *M;

  // ProfileSummaryInfo *PSI;
  function_ref<BlockFrequencyInfo *(Function &)> LookupBFI;

  Type *IntPtrTy;

  const DataLayout *DL;
  LLVMContext *ContextPtr;

  // cache of linear functions
  // KeyValueCache<Function *, SmallVector<Value *, 8>> LFCache;

  // statistics for analyzing this optimization for future improvements
  // unsigned LastMaxParamScore = 0;
  // unsigned TotalParamScore = 0;
  // int CountOpReorder = 0;
  // int CountBinOps = 0;

  static bool matchInstructions(Instruction *I1, Instruction *I2,
                                const FunctionMergingOptions &Options = {});

  void replaceByCall(Function *F, FunctionMergeResult &MergedFunc,
                     const FunctionMergingOptions &Options = {});
  bool replaceCallsWith(Function *F, FunctionMergeResult &MergedFunc,
                        const FunctionMergingOptions &Options = {});

  void updateCallGraph(Function *F, FunctionMergeResult &MFR,
                       StringSet<> &AlwaysPreserved,
                       const FunctionMergingOptions &Options);

public:
  FunctionMerger(Module *M) : M(M), IntPtrTy(nullptr) {
    //, ProfileSummaryInfo *PSI=nullptr, function_ref<BlockFrequencyInfo
    //*(Function &)> LookupBFI=nullptr) : M(M), PSI(PSI), LookupBFI(LookupBFI),
    // IntPtrTy(nullptr) {
    if (M) {
      DL = &M->getDataLayout();
      ContextPtr = &M->getContext();
      IntPtrTy = DL->getIntPtrType(*ContextPtr);
    }
  }

  enum LinearizationKind { LK_Random, LK_Canonical };

  void linearize(Function *F, SmallVectorImpl<Value *> &FVec,
                 LinearizationKind LK = LinearizationKind::LK_Canonical);

  bool validMergeTypes(Function *F1, Function *F2,
                       const FunctionMergingOptions &Options = {});

  static bool areTypesEquivalent(Type *Ty1, Type *Ty2, const DataLayout *DL,
                                 const FunctionMergingOptions &Options = {});

  static bool isSAProfitable(AlignedSequence<Value *> &AlignedBlocks);
  static bool isPAProfitable(BasicBlock *BB1, BasicBlock *BB2);

  static bool match(Value *V1, Value *V2, const FunctionMergingOptions &Options = {});

  void updateCallGraph(FunctionMergeResult &Result,
                       StringSet<> &AlwaysPreserved,
                       const FunctionMergingOptions &Options = {});

  FunctionMergeResult merge(Function *F1, Function *F2, std::string Name = "",
                            OptimizationRemarkEmitter *ORE = nullptr,
                            const FunctionMergingOptions &Options = {});

  template <typename BlockListType> class CodeGenerator {
  private:
    LLVMContext *ContextPtr;
    Type *IntPtrTy;

    Value *FuncId;

    // BlockListType &Blocks1;
    // BlockListType &Blocks2;
    std::vector<BasicBlock *> Blocks1;
    std::vector<BasicBlock *> Blocks2;

    BasicBlock *EntryBB1;
    BasicBlock *EntryBB2;
    BasicBlock *PreBB;

    Type *RetType1;
    Type *RetType2;
    Type *ReturnType;

    bool RequiresUnifiedReturn;

    Function *MergedFunc;

    SmallPtrSet<BasicBlock *, 8> CreatedBBs;
    SmallPtrSet<Instruction *, 8> CreatedInsts;

  protected:
    void removeRedundantInstructions(std::vector<Instruction *> &WorkInst,
                                     DominatorTree &DT);

  public:
    // CodeGenerator(BlockListType &Blocks1, BlockListType &Blocks2) :
    // Blocks1(Blocks1), Blocks2(Blocks2) {}
    CodeGenerator(BlockListType &Blocks1, BlockListType &Blocks2) {
      for (BasicBlock &BB : Blocks1)
        this->Blocks1.push_back(&BB);
      for (BasicBlock &BB : Blocks2)
        this->Blocks2.push_back(&BB);
    }

    virtual ~CodeGenerator() {}

    CodeGenerator &setContext(LLVMContext *ContextPtr) {
      this->ContextPtr = ContextPtr;
      return *this;
    }

    CodeGenerator &setIntPtrType(Type *IntPtrTy) {
      this->IntPtrTy = IntPtrTy;
      return *this;
    }

    CodeGenerator &setFunctionIdentifier(Value *IsFunc1) {
      this->FuncId = IsFunc1;
      return *this;
    }

    CodeGenerator &setEntryPoints(BasicBlock *EntryBB1, BasicBlock *EntryBB2) {
      this->EntryBB1 = EntryBB1;
      this->EntryBB2 = EntryBB2;
      return *this;
    }

    CodeGenerator &setReturnTypes(Type *RetType1, Type *RetType2) {
      this->RetType1 = RetType1;
      this->RetType2 = RetType2;
      return *this;
    }

    CodeGenerator &setMergedEntryPoint(BasicBlock *PreBB) {
      this->PreBB = PreBB;
      return *this;
    }

    CodeGenerator &setMergedReturnType(Type *ReturnType,
                                       bool RequiresUnifiedReturn = false) {
      this->ReturnType = ReturnType;
      this->RequiresUnifiedReturn = RequiresUnifiedReturn;
      return *this;
    }

    CodeGenerator &setMergedFunction(Function *MergedFunc) {
      this->MergedFunc = MergedFunc;
      return *this;
    }

    Function *getMergedFunction() { return MergedFunc; }
    Type *getMergedReturnType() { return ReturnType; }
    bool getRequiresUnifiedReturn() { return RequiresUnifiedReturn; }

    Value *getFunctionIdentifier() { return FuncId; }

    LLVMContext &getContext() { return *ContextPtr; }

    std::vector<BasicBlock *> &getBlocks1() { return Blocks1; }
    std::vector<BasicBlock *> &getBlocks2() { return Blocks2; }

    BasicBlock *getEntryBlock1() { return EntryBB1; }
    BasicBlock *getEntryBlock2() { return EntryBB2; }
    BasicBlock *getPreBlock() { return PreBB; }

    Type *getReturnType1() { return RetType1; }
    Type *getReturnType2() { return RetType2; }

    Type *getIntPtrType() { return IntPtrTy; }

    void insert(BasicBlock *BB) { CreatedBBs.insert(BB); }
    void insert(Instruction *I) { CreatedInsts.insert(I); }

    void erase(BasicBlock *BB) { CreatedBBs.erase(BB); }
    void erase(Instruction *I) { CreatedInsts.erase(I); }

    virtual bool generate(AlignedSequence<Value *> &AlignedSeq,
                          ValueToValueMapTy &VMap,
                          const FunctionMergingOptions &Options = {}) = 0;

    void destroyGeneratedCode();

    SmallPtrSet<Instruction *, 8>::const_iterator begin() const {
      return CreatedInsts.begin();
    }
    SmallPtrSet<Instruction *, 8>::const_iterator end() const {
      return CreatedInsts.end();
    }
  };

  template <typename BlockListType>
  class SALSSACodeGen : public FunctionMerger::CodeGenerator<BlockListType> {

  public:
    SALSSACodeGen(BlockListType &Blocks1, BlockListType &Blocks2)
        : CodeGenerator<BlockListType>(Blocks1, Blocks2) {}
    virtual ~SALSSACodeGen() {}
    virtual bool generate(AlignedSequence<Value *> &AlignedSeq,
                          ValueToValueMapTy &VMap,
                          const FunctionMergingOptions &Options = {}) override;
  };
};

} // namespace llvm

#endif
