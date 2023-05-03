#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"

using namespace llvm;

cl::OptionCategory SACheckCat("llvm-nextfm-sa-check Options");
static cl::opt<std::string> InputFile(cl::Positional, cl::desc("<input file>"),
                                      cl::Required, cl::cat(SACheckCat));

void SequenceAlignerCheck(Module *M);

int main(int argc, char **argv) {
  InitLLVM X(argc, argv);

  LLVMContext Context;
  cl::HideUnrelatedOptions(SACheckCat);
  cl::ParseCommandLineOptions(argc, argv,
                              "LLVM NextFM Sequence Aligner check\n");

  SMDiagnostic Err;
  std::unique_ptr<Module> M = parseIRFile(InputFile, Err, Context);

  if (!M.get()) {
    Err.print(argv[0], errs());
    return 1;
  }

  SequenceAlignerCheck(M.get());

  return 0;
}
