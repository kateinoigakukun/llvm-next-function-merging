#include "llvm/ADT/SequenceAlignment.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/CodeGen/CommandFlags.h"
#include "llvm/FuzzMutate/FuzzerCLI.h"
#include "llvm/FuzzMutate/IRMutator.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Verifier.h"
#include "llvm/InitializePasses.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"

#include "llvm/Transforms/IPO/LegacySequenceAligner.h"
#include "llvm/Transforms/IPO/MSA/MSAAlignmentEntry.h"
#include <memory>

using namespace llvm;

static codegen::RegisterCodeGenFlags CGF;

static std::unique_ptr<IRMutator> Mutator;
static std::unique_ptr<TargetMachine> TM;

std::unique_ptr<IRMutator> createOptMutator() {
  std::vector<TypeGetter> Types{
      Type::getInt1Ty,  Type::getInt8Ty,  Type::getInt16Ty, Type::getInt32Ty,
      Type::getInt64Ty, Type::getFloatTy, Type::getDoubleTy};

  std::vector<std::unique_ptr<IRMutationStrategy>> Strategies;
  Strategies.push_back(std::make_unique<InjectorIRStrategy>(
      InjectorIRStrategy::getDefaultOps()));
  Strategies.push_back(std::make_unique<InstDeleterIRStrategy>());
  Strategies.push_back(std::make_unique<InstModificationIRStrategy>());

  return std::make_unique<IRMutator>(std::move(Types), std::move(Strategies));
}

static std::unique_ptr<Module>
parseAndVerifyOrCreateModule(uint8_t *Data, size_t Size, LLVMContext &Context) {
  if (Size <= 1) {
    auto M = std::make_unique<Module>("M", Context);
    // Create two empty functions
    for (int i = 0; i < 2; ++i) {
      auto *F = Function::Create(FunctionType::get(Type::getVoidTy(Context),
                                                   /*isVarArg=*/false),
                                 Function::ExternalLinkage,
                                 "f" + std::to_string(i), M.get());
      auto *BB = BasicBlock::Create(Context, "entry", F);
      ReturnInst::Create(Context, BB);
    }
    return std::move(M);
  }
  return parseAndVerify(Data, Size, Context);
}

extern "C" LLVM_ATTRIBUTE_USED size_t LLVMFuzzerCustomMutator(
    uint8_t *Data, size_t Size, size_t MaxSize, unsigned int Seed) {

  assert(Mutator &&
         "IR mutator should have been created during fuzzer initialization");

  LLVMContext Context;
  auto M = parseAndVerifyOrCreateModule(Data, Size, Context);
  if (!M) {
    errs() << "error: mutator input module is broken!\n";
    return 0;
  }

  Mutator->mutateModule(*M, Seed, Size, MaxSize);

  if (verifyModule(*M, &errs())) {
    errs() << "mutation result doesn't pass verification\n";
#ifndef NDEBUG
    M->dump();
#endif
    // Avoid adding incorrect test cases to the corpus.
    return 0;
  }

  std::string Buf;
  {
    raw_string_ostream OS(Buf);
    WriteBitcodeToFile(*M, OS);
  }
  if (Buf.size() > MaxSize)
    return 0;

  // There are some invariants which are not checked by the verifier in favor
  // of having them checked by the parser. They may be considered as bugs in the
  // verifier and should be fixed there. However until all of those are covered
  // we want to check for them explicitly. Otherwise we will add incorrect input
  // to the corpus and this is going to confuse the fuzzer which will start
  // exploration of the bitcode reader error handling code.
  auto NewM = parseAndVerify(reinterpret_cast<const uint8_t *>(Buf.data()),
                             Buf.size(), Context);
  if (!NewM) {
    errs() << "mutator failed to re-read the module\n";
#ifndef NDEBUG
    M->dump();
#endif
    return 0;
  }

  if (M->getFunctionList().size() != 2) {
    errs() << "error: input module should contain exactly two functions!\n";
    return 0;
  }

  memcpy(Data, Buf.data(), Buf.size());
  return Buf.size();
}

void SequenceAlignerCheck(Module *M);

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  assert(TM && "Should have been created during fuzzer initialization");

  if (Size <= 1)
    // We get bogus data given an empty corpus - ignore it.
    return 0;

  // Parse module
  //

  LLVMContext Context;
  auto M = parseAndVerify(Data, Size, Context);
  if (!M) {
    errs() << "error: input module is broken!\n";
    return 0;
  }

  if (M->getFunctionList().size() != 2) {
    errs() << "error: input module should contain exactly two functions!\n";
    return 0;
  }

  // Set up target dependant options
  //

  M->setTargetTriple(TM->getTargetTriple().normalize());
  M->setDataLayout(TM->createDataLayout());

  SequenceAlignerCheck(M.get());

  return 0;
}

static void handleLLVMFatalError(void *, const std::string &Message, bool) {
  // TODO: Would it be better to call into the fuzzer internals directly?
  dbgs() << "LLVM ERROR: " << Message << "\n"
         << "Aborting to trigger fuzzer exit handling.\n";
  abort();
}

extern "C" LLVM_ATTRIBUTE_USED int LLVMFuzzerInitialize(int *argc,
                                                        char ***argv) {
  EnableDebugBuffering = true;

  // Make sure we print the summary and the current unit when LLVM errors out.
  install_fatal_error_handler(handleLLVMFatalError, nullptr);

  InitializeNativeTarget();
  InitializeNativeTargetAsmParser();
  InitializeNativeTargetAsmPrinter();

  // Parse input options
  //

  handleExecNameEncodedOptimizerOpts(*argv[0]);
  parseFuzzerCLOpts(*argc, *argv);

  // Create TargetMachine
  //

  Triple TargetTriple = Triple(Triple::normalize(LLVM_DEFAULT_TARGET_TRIPLE));

  std::string Error;
  const Target *TheTarget =
      TargetRegistry::lookupTarget(codegen::getMArch(), TargetTriple, Error);
  if (!TheTarget) {
    errs() << *argv[0] << ": " << Error;
    exit(1);
  }

  TargetOptions Options =
      codegen::InitTargetOptionsFromCodeGenFlags(TargetTriple);
  TM.reset(TheTarget->createTargetMachine(
      TargetTriple.getTriple(), codegen::getCPUStr(), codegen::getFeaturesStr(),
      Options, codegen::getExplicitRelocModel(),
      codegen::getExplicitCodeModel(), CodeGenOpt::Default));
  assert(TM && "Could not allocate target machine!");

  // Create mutator
  //

  Mutator = createOptMutator();

  return 0;
}
