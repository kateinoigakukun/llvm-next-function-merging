add_library(LLVMNextFMObjects OBJECT
  Analysis/DumpFunctionSize.cpp
  Analysis/InstCount2.cpp
  Transforms/IPO/ExtractGV2.cpp
  Transforms/IPO/FastFM.cpp
  Transforms/IPO/FMSA.cpp
  Transforms/IPO/FunctionMerging.cpp
  Transforms/IPO/FunctionMergingUtils.cpp
  Transforms/IPO/FunctionMergingUtils.h
  Transforms/IPO/FunctionSizeEstimation.cpp
  Transforms/IPO/MatchingUtils.h
  Transforms/IPO/MergeSimilarFunctions.cpp
  Transforms/IPO/MinSizeAttr.cpp
  Transforms/IPO/MultipleSequenceAlignment.cpp
  Transforms/IPO/SALSSACodeGen.cpp
  Transforms/IPO/LegacySequenceAligner.cpp
  Transforms/IPO/MSA/MultipleSequenceAligner.cpp
  Transforms/IPO/MSA/HyFMMultipleSequenceAligner.cpp
  Transforms/IPO/MSA/BlockAlignment.cpp
  Transforms/IPO/MSA/BlockAlignment.h
  Transforms/IPO/MSA/NeedlemanWunschMultipleSequenceAligner.cpp)

set_property(TARGET LLVMNextFMObjects PROPERTY POSITION_INDEPENDENT_CODE ON)

add_llvm_pass_plugin(LLVMNextFM
  Transforms/IPO/NextFMLoader.cpp
  LINK_LIBS LLVMNextFMObjects
  NO_INSTALL_RPATH)

add_llvm_pass_plugin(LLVMNextFMForTwo
  Transforms/IPO/NextFMLoaderForTwo.cpp
  LINK_LIBS LLVMNextFMObjects
  NO_INSTALL_RPATH)

add_llvm_pass_plugin(LLVMNextFMForMore
  Transforms/IPO/NextFMLoaderForMore.cpp
  LINK_LIBS LLVMNextFMObjects
  NO_INSTALL_RPATH)
