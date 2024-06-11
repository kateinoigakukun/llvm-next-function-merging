#include "llvm/Transforms/IPO/FunctionMergingOptions.h"

#include "llvm/Support/CommandLine.h"
#include <cmath>

using namespace llvm;

static cl::opt<unsigned>
    gLSHRows("hyfm-f3m-rows", cl::init(2), cl::Hidden,
             cl::desc("Number of rows in the LSH structure"));

static cl::opt<unsigned>
    gLSHBands("hyfm-f3m-bands", cl::init(100), cl::Hidden,
              cl::desc("Number of bands in the LSH structure"));

static cl::opt<double>
    gRankingDistance("ranking-distance", cl::init(1.0), cl::Hidden,
                     cl::desc("Define a threshold to be used"));

static cl::opt<bool> AdaptiveThreshold(
    "adaptive-threshold", cl::init(false), cl::Hidden,
    cl::desc("Adaptively define a new threshold based on the application"));

static cl::opt<bool> AdaptiveBands(
    "adaptive-bands", cl::init(false), cl::Hidden,
    cl::desc("Adaptively define the LSH geometry based on the application"));

FunctionMergingOptions
FunctionMergingOptions::derive(size_t numberOfFunctions) {
  FunctionMergingOptions Options;
  Options.LSHRows = gLSHRows;
  Options.LSHBands = gLSHBands;
  Options.RankingDistance = gRankingDistance;

  // Create a threshold based on the application's size
  if (AdaptiveThreshold || AdaptiveBands) {
    double x = std::log10(numberOfFunctions) / 10;
    Options.RankingDistance = (double)(x - 0.3);
    if (Options.RankingDistance < 0.05)
      Options.RankingDistance = 0.05;
    if (Options.RankingDistance > 0.4)
      Options.RankingDistance = 0.4;

    if (AdaptiveBands) {
      float target_probability = 0.9;
      float offset = 0.1;
      unsigned tempBands =
          std::ceil(std::log(1.0 - target_probability) /
                    std::log(1.0 - std::pow(Options.RankingDistance + offset,
                                            Options.LSHRows)));
      if (tempBands < Options.LSHBands)
        Options.LSHBands = tempBands;
    }
    if (AdaptiveThreshold)
      Options.RankingDistance = 1 - Options.RankingDistance;
    else
      Options.RankingDistance = 1.0;
  }

  return Options;
}
