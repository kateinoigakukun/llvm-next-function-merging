#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/Twine.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRPrintingPasses.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Remarks/Remark.h"
#include "llvm/Remarks/RemarkParser.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include <algorithm>
#include <set>
#include <sstream>

using namespace llvm;

cl::OptionCategory TestGenCat("llvm-nextfm-testgen Options");
static cl::opt<std::string> InputFile(cl::Positional, cl::desc("<input file>"),
                                      cl::Required, cl::cat(TestGenCat));
static cl::opt<std::string> OutputDir("o", cl::desc("<output dir>"),
                                      cl::Required, cl::cat(TestGenCat));
static cl::list<std::string> RemarkFiles("remark", cl::desc("<remark file>"),
                                         cl::ZeroOrMore, cl::cat(TestGenCat));
static cl::opt<std::string> RegressionTrainer(
    "regression-trainer",
    cl::desc("Extract only missed remarks that passed in the given trainer"),
    cl::cat(TestGenCat));
static cl::opt<std::string> ParserFormat("format",
                                         cl::desc("The format of the remarks."),
                                         cl::init("yaml"), cl::cat(TestGenCat));
static cl::list<std::string>
    RemarkFilter("filter-remark",
                 cl::desc("Extract only remarks containing the given name."),
                 cl::cat(TestGenCat));

static bool HandleMissedRemark(const remarks::Remark &Remark,
                               unsigned RemarkIndex, Module *M) {
  // Use SetVector to avoid duplicates.
  SetVector<GlobalValue *> GVSet;
  std::unique_ptr<Module> NewM = CloneModule(*M);

  for (const remarks::Argument &Arg : Remark.Args) {
    if (Arg.Key == "Function")
      GVSet.insert(cast<GlobalValue>(NewM->getFunction(Arg.Val)));
  }

  legacy::PassManager PM;
  std::vector<GlobalValue *> GVs(GVSet.begin(), GVSet.end());
  PM.add(createGVExtractionPass(GVs, false));

  std::error_code EC;
  SmallString<128> OutputFilePath(OutputDir);
  std::stringstream OutputFilename;
  OutputFilename << RemarkIndex << "_" << Remark.PassName.str() << "_"
                 << Remark.RemarkName.str() << ".ll";
  sys::path::append(OutputFilePath, OutputFilename.str());
  ToolOutputFile Out(OutputFilePath, EC, sys::fs::OF_None);
  if (EC) {
    errs() << EC.message() << '\n';
    return 1;
  }

  std::stringstream Banner;
  Banner << "; Generated from " << Remark.PassName.str() << ":"
         << Remark.RemarkName.str() << "\n";

  std::sort(GVs.begin(), GVs.end());
  for (auto *GV : GVs) {
    Banner << "; - " << GV->getName().str() << "\n";
  }
  Banner << "\n";
  Banner << "; RUN: %opt -S --passes=\"" << Remark.PassName.str()
         << "\" -func-merging-explore 2 -o /dev/null"
         << " -pass-remarks-output=- -pass-remarks-filter="
         << Remark.PassName.str() << " < %s | FileCheck %s\n";
  Banner << "; CHECK-NOT: --- !Missed\n";
  Banner << "; XFAIL: *\n";

  PM.add(createGlobalDCEPass());           // Delete unreachable globals
  PM.add(createStripDeadDebugInfoPass());  // Remove dead debug info
  PM.add(createStripDeadPrototypesPass()); // Remove dead func decls
  PM.add(createPrintModulePass(Out.os(), Banner.str(), false));
  PM.run(*NewM);

  // Declare success.
  Out.keep();

  return false;
}

class RemarkSelector {
  std::vector<std::set<std::string>> TrainerPassRemarks;

public:
  RemarkSelector() {
    if (!RegressionTrainer.empty()) {
      collectTrainerRemarks(RegressionTrainer);
    }
  }

  void collectTrainerRemarks(std::string TrainerFile) {
    Expected<remarks::Format> Format = remarks::parseFormat(ParserFormat);
    if (!Format) {
      handleAllErrors(Format.takeError(), [&](const ErrorInfoBase &PE) {
        PE.log(WithColor::error());
        errs() << '\n';
      });
      return;
    }
    auto Buf = MemoryBuffer::getFile(TrainerFile);
    if (std::error_code EC = Buf.getError()) {
      WithColor::error() << "Can't open file " << TrainerFile << ": "
                         << EC.message() << "\n";
      return;
    }
    Expected<std::unique_ptr<remarks::RemarkParser>> MaybeParser =
        remarks::createRemarkParserFromMeta(*Format, (*Buf)->getBuffer());

    if (!MaybeParser) {
      handleAllErrors(MaybeParser.takeError(), [&](const ErrorInfoBase &PE) {
        PE.log(WithColor::error());
        errs() << '\n';
      });
      return;
    }

    remarks::RemarkParser &Parser = **MaybeParser;

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
        return;
      }

      const remarks::Remark &TrainerRemark = **MaybeRemark;
      std::set<std::string> TrainerTargetSet;
      if (TrainerRemark.RemarkType != remarks::Type::Passed)
        continue;

      for (const remarks::Argument &Arg : TrainerRemark.Args) {
        if (Arg.Key == "Function")
          TrainerTargetSet.insert(Arg.Val.str());
      }
      if (!TrainerTargetSet.empty()) {
        TrainerPassRemarks.push_back(TrainerTargetSet);
      }
    }
  }

  bool isEligibleRemark(const remarks::Remark &Remark) {
    if (RemarkFilter.empty() && RegressionTrainer.empty())
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
    for (auto &TrainerTargetSet : TrainerPassRemarks) {
      if (TrainerTargetSet == TargetSet)
        return true;
    }
    return false;
  }
};

static bool HandleRemarkFile(StringRef RemarkFile, Module *M) {
  Expected<remarks::Format> Format = remarks::parseFormat(ParserFormat);
  if (!Format) {
    handleAllErrors(Format.takeError(), [&](const ErrorInfoBase &PE) {
      PE.log(WithColor::error());
      errs() << '\n';
    });
    return false;
  }

  ErrorOr<std::unique_ptr<MemoryBuffer>> Buf =
      MemoryBuffer::getFile(RemarkFile);
  if (std::error_code EC = Buf.getError()) {
    WithColor::error() << "Can't open file " << RemarkFile << ": "
                       << EC.message() << "\n";
    return false;
  }
  Expected<std::unique_ptr<remarks::RemarkParser>> MaybeParser =
      remarks::createRemarkParserFromMeta(*Format, (*Buf)->getBuffer());

  if (!MaybeParser) {
    handleAllErrors(MaybeParser.takeError(), [&](const ErrorInfoBase &PE) {
      PE.log(WithColor::error());
      errs() << '\n';
    });
    return false;
  }

  remarks::RemarkParser &Parser = **MaybeParser;
  unsigned RemarkIndex = 0;
  RemarkSelector Selector;

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
      return false;
    }

    const remarks::Remark &Remark = **MaybeRemark;
    if (!Selector.isEligibleRemark(Remark))
      continue;

    switch (Remark.RemarkType) {
    case remarks::Type::Missed: {
      HandleMissedRemark(Remark, RemarkIndex, M);
      break;
    }
    default:
      break;
    }
    RemarkIndex += 1;
  }

  return true;
}

int main(int argc, char **argv) {
  InitLLVM X(argc, argv);

  LLVMContext Context;
  cl::HideUnrelatedOptions(TestGenCat);
  cl::ParseCommandLineOptions(argc, argv, "llvm NextFM test generator\n");

  SMDiagnostic Err;
  std::unique_ptr<Module> M = parseIRFile(InputFile, Err, Context);

  if (!M.get()) {
    Err.print(argv[0], errs());
    return 1;
  }

  // Create output dir if it doesn't exist.
  std::error_code EC = sys::fs::create_directories(OutputDir);
  if (EC) {
    errs() << EC.message() << '\n';
    return 1;
  }

  // Handle remark files.
  for (auto &RemarkFile : RemarkFiles) {
    if (!HandleRemarkFile(RemarkFile, M.get())) {
      return 1;
    }
  }

  return 0;
}
