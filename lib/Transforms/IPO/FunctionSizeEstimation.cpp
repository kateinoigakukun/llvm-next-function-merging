#include "llvm/Transforms/IPO/FunctionSizeEstimation.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/CommandFlags.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/Utils/Cloning.h"

namespace llvm {
// See ExtractGV2.cpp header for the reason why we need '2'.
ModulePass *createGVExtraction2Pass(std::vector<GlobalValue *> &GVs,
                                    bool deleteFn = false,
                                    bool keepConstInit = false);
}; // namespace llvm

using namespace llvm;

namespace {

class PrettyStackTraceFunctionsAnalysis : public llvm::PrettyStackTraceEntry {
  const std::vector<Function *> &Functions;
  StringRef action;

public:
  PrettyStackTraceFunctionsAnalysis(const char *action,
                                    const std::vector<Function *> &Functions)
      : Functions(Functions), action(action) {}

  virtual void print(llvm::raw_ostream &os) const override {
    os << "While " << action << " on functions:\n";
    for (auto *F : Functions) {
      F->print(os);
      os << "\n";
    }
  }
};
} // namespace

size_t EstimateFunctionSize(Function *F, TargetTransformInfo *TTI);

size_t
FunctionSizeEstimation::estimate(const std::vector<Function *> &Functions,
                                 EstimationMethod Method) {

  PrettyStackTraceFunctionsAnalysis X("estimating function size", Functions);

  switch (Method) {
  case EstimationMethod::Exact: {
    auto MaybeSize = estimateExactFunctionSize(Functions);
    if (MaybeSize) {
      return *MaybeSize;
    } else {
      llvm::errs() << "Warning: exact function size estimation failed, "
                      "falling back to approximate estimation\n";
      [[fallthrough]];
    }
  }
  case EstimationMethod::Approximate: {
    size_t Size = 0;
    for (auto *F : Functions) {
      Size += estimateApproximateFunctionSize(*F);
    }
    return Size;
  }
  }
}

size_t FunctionSizeEstimation::estimateApproximateFunctionSize(Function &F) {
  return EstimateFunctionSize(&F, &FAM.getResult<TargetIRAnalysis>(F));
}

namespace {

// A raw_pwrite_stream that keeps track of the number of bytes written to it.
class raw_size_ostream : public raw_pwrite_stream {
  size_t Size = 0;

  /// See raw_ostream::write_impl.
  void write_impl(const char *Ptr, size_t Size) override { this->Size += Size; }

  void pwrite_impl(const char *Ptr, size_t Size, uint64_t Offset) override {
    if (Offset + Size > this->Size)
      this->Size = Offset + Size;
  }

  /// Return the current position within the stream.
  uint64_t current_pos() const override { return 0; }

public:
  /// Construct a new raw_size_ostream.
  explicit raw_size_ostream() { SetUnbuffered(); }

  ~raw_size_ostream() override = default;

  void flush() = delete;

  size_t size() const { return Size; }
};
}; // namespace

Optional<size_t> FunctionSizeEstimation::estimateExactFunctionSize(
    const std::vector<Function *> &Functions) {
  // This estimation actually emits the object code for the given function
  // and counts the number of bytes in the emitted object code.
  // This is a very expensive operation, but useful for further research.

  // First, extract the function from the module.

  legacy::PassManager PM;
  std::unique_ptr<Module> NewM = CloneModule(*Functions[0]->getParent());
  std::vector<GlobalValue *> PreservedGVs;

  for (auto *F : Functions) {
    Function *NewF = NewM->getFunction(F->getName());
    PreservedGVs.push_back(NewF);
  }

  std::string Error;
  const Target *TheTarget =
      TargetRegistry::lookupTarget(NewM->getTargetTriple(), Error);
  if (!TheTarget) {
    errs() << "Error: " << Error << "\n";
    return None;
  }
  auto Target = std::unique_ptr<TargetMachine>(TheTarget->createTargetMachine(
      NewM->getTargetTriple(), codegen::getCPUStr(), codegen::getFeaturesStr(),
      TargetOptions(), Reloc::PIC_));
  PM.add(createGVExtraction2Pass(PreservedGVs, false));

  std::string ObjectCode;
  {
    raw_string_ostream OS(ObjectCode);
    buffer_ostream POS(OS);
    if (Target->addPassesToEmitFile(PM, POS, nullptr, CGFT_ObjectFile)) {
      errs() << "Error: cannot emit a file of this type\n";
      return None;
    }
    PM.run(*NewM);
  }

  return ObjectCode.size();
}
