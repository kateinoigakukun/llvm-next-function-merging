#include "llvm/Transforms/IPO/FunctionSizeEstimation.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/CommandFlags.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/PassManager.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Object/ELFObjectFile.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/IPO/ExtractGV2.h"
#include "llvm/Transforms/Utils/Cloning.h"

#define DEBUG_TYPE "function-size-estimation"

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
                                 const std::vector<Function *> &Exclusions,
                                 EstimationMethod Method) {

  PrettyStackTraceFunctionsAnalysis X("estimating function size", Functions);

  switch (Method) {
  case EstimationMethod::GlobalExact:
  case EstimationMethod::Exact: {
    bool GlobalExact = Method == EstimationMethod::GlobalExact;
    LLVM_DEBUG(dbgs() << "[FunctionSizeEstimation] Estimating " << (GlobalExact ? "global " : "")
           << "exact function size for " << Functions.size() << " functions\n");
    for (auto *F : Functions) {
      LLVM_DEBUG(dbgs() << "[FunctionSizeEstimation]   " << F->getName() << "\n");
    }

    auto MaybeSize =
        estimateExactFunctionSize(Functions, Exclusions, GlobalExact);
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

std::optional<size_t> FunctionSizeEstimation::estimateExactFunctionSize(
    const std::vector<Function *> &Functions,
    const std::vector<Function *> &Exclusions, bool GlobalExact) {
  // This estimation actually emits the object code for the given function
  // and counts the number of bytes in the emitted object code.
  // This is a very expensive operation, but useful for further research.

  // First, extract the un-counted function from the module.

  legacy::PassManager PM;
  std::unique_ptr<Module> NewM;
  {
    TimeTraceScope TimeScope("CloneModule");
    NewM = CloneModule(*Functions[0]->getParent());
  }
  std::vector<GlobalValue *> GVs;

  {
    for (auto *F : GlobalExact ? Exclusions : Functions) {
      Function *NewF = NewM->getFunction(F->getName());
      LLVM_DEBUG(dbgs() << "[FunctionSizeEstimation] Extracting function " << F->getName() << "\n");
      GVs.push_back(NewF);
    }
  }

  std::string Error;
  const Target *TheTarget =
      TargetRegistry::lookupTarget(NewM->getTargetTriple(), Error);
  if (!TheTarget) {
    errs() << "Error: " << Error << "\n";
    return std::nullopt;
  }
  auto Target = std::unique_ptr<TargetMachine>(TheTarget->createTargetMachine(
      NewM->getTargetTriple(), codegen::getCPUStr(), codegen::getFeaturesStr(),
      TargetOptions(), Reloc::PIC_));
  PM.add(createGVExtraction2Pass(GVs, GlobalExact));
  PM.add(createGlobalDCEPass());

  std::string ObjectCode;
  {
    raw_string_ostream OS(ObjectCode);
    buffer_ostream POS(OS);
    if (Target->addPassesToEmitFile(PM, POS, nullptr, CGFT_ObjectFile)) {
      errs() << "Error: cannot emit a file of this type\n";
      return std::nullopt;
    }
    PM.run(*NewM);
  }

  Expected<std::unique_ptr<object::ObjectFile>> ObjectFile =
      object::ObjectFile::createObjectFile(
          MemoryBufferRef(ObjectCode, "function-size-estimation"));

  if (!ObjectFile) {
    logAllUnhandledErrors(
        ObjectFile.takeError(), errs(),
        "Error: cannot create object file for function size estimation\n");
    return std::nullopt;
  }

  // check env var LLVM_FSE_DUMP_DIR
  if (const char *DumpDir = getenv("LLVM_FSE_DUMP_DIR")) {
    std::error_code EC;
    size_t i = 0;
    auto fileName = [&]() {
      return std::string(DumpDir) + "/" + Functions[0]->getName().str() + "." +
             std::to_string(i) + ".o";
    };
    while (sys::fs::exists(fileName())) ++i;

    raw_fd_ostream OS(fileName(), EC, sys::fs::OF_None);
    if (EC) {
      errs() << "Error: cannot open file for dumping\n";
      return std::nullopt;
    }
    OS << ObjectCode;
    OS.close();
    errs() << "Dumped object file to " << fileName() << "\n";
  }

  // We don't count the size of relocations and symbol table.
  size_t Size = 0;
  {
    TimeTraceScope TimeScope("CountSize");
    if (auto *ELF = dyn_cast<object::ELF64LEObjectFile>(&**ObjectFile)) {
      const auto &ELFFile = ELF->getELFFile();
      for (auto &Sec : ELF->sections()) {
        StringRef SecName;
        if (auto NameOrErr = Sec.getName())
          SecName = *NameOrErr;
        if (SecName.startswith(".rel") || SecName.startswith(".symtab") ||
            SecName.startswith(".strtab") || SecName.equals(".comment"))
          continue;

        Size += Sec.getSize();
      }
    } else {
      errs() << "Error: unsupported object file format\n";
      return std::nullopt;
    }
  }

  return Size;
}
