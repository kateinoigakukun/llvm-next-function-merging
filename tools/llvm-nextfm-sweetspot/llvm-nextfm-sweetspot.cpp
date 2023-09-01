#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Bitcode/BitcodeWriterPass.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/IRPrintingPasses.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Remarks/Remark.h"
#include "llvm/Remarks/RemarkParser.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Host.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Support/WithColor.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/IPO/ExtractGV2.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include <algorithm>
#include <memory>
#include <optional>
#include <set>
#include <sstream>

using namespace llvm;

cl::OptionCategory SweetSpotCat(
    "llvm-nextfm-sweetspot Options",
    "Estimate the best reduction size for a given bitcode and remarks");
static cl::opt<std::string> InputFile(cl::Positional, cl::desc("<input file>"),
                                      cl::Required, cl::cat(SweetSpotCat));
enum OutputFileType {
  OFT_LLVMAssembly,
  OFT_LLVMBitcode,
  // OFT_ObjectFile
};
static cl::opt<OutputFileType>
    FileType("filetype", cl::init(OFT_LLVMBitcode),
             cl::desc("Choose an output file type:"),
             cl::values(clEnumValN(OFT_LLVMAssembly, "llvm-asm",
                                   "Emit an assembly ('.ll') file"),
                        clEnumValN(OFT_LLVMBitcode, "llvm-bc",
                                   "Emit an assembly ('.ll') file")
                        // clEnumValN(OFT_ObjectFile, "obj",
                        //            "Emit a native object ('.o') file")
                        ),
             cl::cat(SweetSpotCat));

static cl::list<std::string>
    DeletingFunctions("del-func",
                      cl::desc("Delete the specified function from the module"),
                      cl::cat(SweetSpotCat));

static cl::opt<std::string> OutputFile("o", cl::desc("<output dir>"),
                                       cl::Optional, cl::cat(SweetSpotCat));
static cl::opt<std::string> StatsFile("delete-stats",
                                      cl::desc("<stats output file>"),
                                      cl::Optional, cl::cat(SweetSpotCat));
static cl::opt<std::string> RemarkFile("remark", cl::desc("<remark file>"),
                                       cl::Optional, cl::cat(SweetSpotCat));
static cl::opt<std::string> ParserFormat("format",
                                         cl::desc("The format of the remarks."),
                                         cl::init("yaml"),
                                         cl::cat(SweetSpotCat));
static cl::list<std::string>
    RemarkFilter("filter-remark",
                 cl::desc("Count only remarks containing the given name."),
                 cl::cat(SweetSpotCat));

struct Stats {
  size_t OriginalFunctions;
  size_t DeletedFunctions;
};

static std::unique_ptr<Module>
DeleteFunctions(SetVector<StringRef> &DeletedFunctions, Module *M) {
  // Use SetVector to avoid duplicates.
  SetVector<GlobalValue *> GVSet;
  std::unique_ptr<Module> NewM = CloneModule(*M);

  for (auto FuncName : DeletedFunctions) {
    GlobalValue *GV = NewM->getFunction(FuncName);
    if (GV) {
      GVSet.insert(GV);
    }
  }

  legacy::PassManager PM;
  std::vector<GlobalValue *> GVs(GVSet.begin(), GVSet.end());
  PM.add(createGVExtraction2Pass(GVs, true));

  PM.add(createGlobalDCEPass());           // Delete unreachable globals
  PM.add(createStripDeadDebugInfoPass());  // Remove dead debug info
  PM.add(createStripDeadPrototypesPass()); // Remove dead func decls
  PM.run(*NewM);

  for (auto &FuncName : DeletedFunctions) {
    if (auto *F = NewM->getFunction(FuncName)) {
      F->setLinkage(GlobalValue::InternalLinkage);
      auto *BB = BasicBlock::Create(M->getContext(), "entry", F);
      IRBuilder<> Builder(BB);
      Builder.CreateUnreachable();
    }
  }

  return std::move(NewM);
}

class RemarkSelector {

public:
  RemarkSelector() {}

  bool isEligibleRemark(const remarks::Remark &Remark) {
    if (RemarkFilter.empty())
      return true;

    for (const std::string &Filter : RemarkFilter) {
      if (Remark.RemarkName.str().find(Filter) != std::string::npos)
        return true;
    }
    std::set<std::string> TargetSet;
    for (const remarks::Argument &Arg : Remark.Args) {
      if (Arg.Key == "Function")
        TargetSet.insert(Arg.Val.str());
    }
    return false;
  }
};

static std::vector<std::unique_ptr<remarks::Remark>>
CollectMissedRemarks(MemoryBuffer &RemarkFileBuf) {
  Expected<remarks::Format> Format = remarks::parseFormat(ParserFormat);
  if (!Format) {
    handleAllErrors(Format.takeError(), [&](const ErrorInfoBase &PE) {
      PE.log(WithColor::error());
      errs() << '\n';
    });
    return {};
  }

  Expected<std::unique_ptr<remarks::RemarkParser>> MaybeParser =
      remarks::createRemarkParserFromMeta(*Format, RemarkFileBuf.getBuffer());

  if (!MaybeParser) {
    handleAllErrors(MaybeParser.takeError(), [&](const ErrorInfoBase &PE) {
      PE.log(WithColor::error());
      errs() << '\n';
    });
    return {};
  }

  remarks::RemarkParser &Parser = **MaybeParser;
  unsigned RemarkIndex = 0;
  RemarkSelector Selector;

  std::vector<std::unique_ptr<remarks::Remark>> MissedRemarks;

  while (true) {
    Expected<std::unique_ptr<remarks::Remark>> MaybeRemark = Parser.next();
    if (!MaybeRemark) {
      Error E = MaybeRemark.takeError();
      if (E.isA<remarks::EndOfFileError>()) {
        // EOF.
        consumeError(std::move(E));
        break;
      }
      handleAllErrors(std::move(E), [&](const ErrorInfoBase &PE) {
        PE.log(WithColor::error());
        errs() << '\n';
      });
      return {};
    }

    std::unique_ptr<remarks::Remark> Remark = std::move(*MaybeRemark);
    if (!Selector.isEligibleRemark(*Remark))
      continue;

    switch (Remark->RemarkType) {
    case remarks::Type::Missed: {
      MissedRemarks.push_back(std::move(Remark));
      break;
    }
    default:
      break;
    }
    RemarkIndex += 1;
  }
  return std::move(MissedRemarks);
}

static std::unique_ptr<Module>
EstimateBestReduction(MemoryBuffer &RemarkFileBuf, Module *M, Stats &S) {
  auto MissedRemarks = CollectMissedRemarks(RemarkFileBuf);
  SetVector<StringRef> DeletedFunctions;
  for (auto &Remark : MissedRemarks) {
    bool hasSkippedFirst = false;
    for (const remarks::Argument &Arg : Remark->Args) {
      if (Arg.Key == "Function") {
        if (hasSkippedFirst) {
          DeletedFunctions.insert(Arg.Val);
        } else {
          hasSkippedFirst = true;
        }
      }
    }
  }

  auto NewM = DeleteFunctions(DeletedFunctions, M);
  S.DeletedFunctions = DeletedFunctions.size();
  S.OriginalFunctions = M->getFunctionList().size();

  return std::move(NewM);
}

struct MergeEstimation {
  size_t ReductionBytes;
  SetVector<StringRef> DeletedFunctions;
};

static bool DeletedObjectFunctions(SetVector<StringRef> &DeletedFunctions,
                                   Module *M, raw_pwrite_stream &OS) {
  for (auto FuncName : DeletedFunctions) {
    GlobalValue *GV = M->getFunction(FuncName);
    if (!GV) {
      errs() << "Function " << FuncName << " not found in module\n";
      return true;
    }
  }
  std::string Err;
  auto *Target = TargetRegistry::lookupTarget(M->getTargetTriple(), Err);
  if (Err.size()) {
    errs() << "Error: " << Err << "\n";
  }

  TargetOptions opt;
  auto TM = Target->createTargetMachine(M->getTargetTriple(), "generic", "",
                                        opt, std::nullopt);

  auto NewM = DeleteFunctions(DeletedFunctions, M);

  legacy::PassManager pass;
  auto FileType = CGFT_ObjectFile;

  if (TM->addPassesToEmitFile(pass, OS, nullptr, FileType)) {
    errs() << "TheTargetMachine can't emit a file of this type";
    return true;
  }

  pass.run(*NewM);
  return false;
}

static bool
FindBestMissingCandidates(MemoryBuffer &RemarkFileBuf, Module *M,
                          std::vector<MergeEstimation> &Estimations) {
  auto MissedRemarks = CollectMissedRemarks(RemarkFileBuf);

  for (auto &Remark : MissedRemarks) {
    bool hasSkippedFirst = false;
    SetVector<StringRef> DeletedFunctions;
    for (const remarks::Argument &Arg : Remark->Args) {
      if (Arg.Key == "Function") {
        if (hasSkippedFirst) {
          DeletedFunctions.insert(Arg.Val);
        } else {
          hasSkippedFirst = true;
        }
      }
    }
    SmallString<0> CodeString;
    raw_svector_ostream OStream(CodeString);
    if (DeletedObjectFunctions(DeletedFunctions, M, OStream))
      continue;

    dbgs() << "Reduction: " << CodeString.size() << " bytes\n";
    Estimations.push_back({CodeString.size(), DeletedFunctions});
  }
  return false;
}

int bestReductionMain(MemoryBuffer &Buf, Module *M) {
  // Handle remark files.
  Stats stats;
  auto NewM = EstimateBestReduction(Buf, M, stats);

  if (!NewM) {
    return 1;
  }

  if (!StatsFile.empty()) {
    llvm::json::Object obj{
        {"DeletedFunctions", (uint32_t)stats.DeletedFunctions},
        {"OriginalFunctions", (uint32_t)stats.OriginalFunctions},
    };
    std::error_code EC;
    raw_fd_ostream OS(StatsFile, EC, sys::fs::OF_None);
    OS << json::Value(std::move(obj));
  }

  std::error_code EC;
  raw_fd_ostream OS(OutputFile, EC, sys::fs::OF_None);
  if (EC) {
    errs() << "Error creating temporary file: \n";
    errs() << EC.message() << '\n';
    return 1;
  }

  legacy::PassManager PM;
  switch (FileType) {
  case OFT_LLVMAssembly:
    PM.add(createPrintModulePass(OS));
    break;
  case OFT_LLVMBitcode:
    PM.add(createBitcodeWriterPass(OS));
    break;
  }
  PM.run(*NewM);
  return 0;
}

int bestMergeMain(MemoryBuffer &Buf, Module *M) {
  std::vector<MergeEstimation> Estimations;
  auto hasError = FindBestMissingCandidates(Buf, M, Estimations);

  if (hasError) {
    return 1;
  }

  for (auto &Estimation : Estimations) {
    json::Array DeletedFunctions;
    for (auto &DeletedFunction : Estimation.DeletedFunctions) {
      DeletedFunctions.push_back(DeletedFunction);
    }
    json::Object obj{
        {"ReductionBytes", (uint32_t)Estimation.ReductionBytes},
        {"DeletedFunctions", json::Value(std::move(DeletedFunctions))},
    };
    std::error_code EC;
    raw_fd_ostream OS(StatsFile, EC, sys::fs::OF_None);
    OS << json::Value(std::move(obj));
  }

  return 0;
}

int main(int argc, char **argv) {
  InitLLVM X(argc, argv);

  LLVMContext Context;
  cl::HideUnrelatedOptions(SweetSpotCat);
  cl::ParseCommandLineOptions(argc, argv, "llvm NextFM test generator\n");

  SMDiagnostic Err;
  std::unique_ptr<Module> M = parseIRFile(InputFile, Err, Context);

  if (!M.get()) {
    Err.print(argv[0], errs());
    return 1;
  }

  if (true) {
    InitializeNativeTarget();
    InitializeNativeTargetAsmParser();
    InitializeNativeTargetAsmPrinter();
    SetVector<StringRef> DeletedFunctions;
    for (auto &FuncName : DeletingFunctions) {
      DeletedFunctions.insert(FuncName);
    }
    std::error_code EC;
    raw_fd_ostream OS(OutputFile, EC, sys::fs::OF_None);
    if (EC) {
      errs() << "Error creating temporary file: \n";
      errs() << EC.message() << '\n';
      return 1;
    }

    if (DeletedObjectFunctions(DeletedFunctions, M.get(), OS)) {
      errs() << "Error while deleting functions";
      return 1;
    }
    return 0;
  } else {
    ErrorOr<std::unique_ptr<MemoryBuffer>> Buf =
        MemoryBuffer::getFile(RemarkFile);
    if (std::error_code EC = Buf.getError()) {
      WithColor::error() << "Can't open file " << RemarkFile << ": "
                         << EC.message() << "\n";
      return 1;
    }

    return bestReductionMain(*Buf.get(), M.get());
  }
}
