add_library(LLVMNextFMObjects OBJECT
  Transforms/IPO/FastFM.cpp
  Transforms/IPO/FMSA.cpp
  Transforms/IPO/FunctionMerging.cpp
  Transforms/IPO/MatchingUtils.h
  Transforms/IPO/MergeSimilarFunctions.cpp
  Transforms/IPO/MinSizeAttr.cpp
  Transforms/IPO/MultipleSequenceAlignment.cpp
  Transforms/IPO/SALSSACodeGen.cpp)

set_property(TARGET LLVMNextFMObjects PROPERTY POSITION_INDEPENDENT_CODE ON)

add_llvm_pass_plugin(LLVMNextFM
  Transforms/IPO/NextFMLoader.cpp
  LINK_LIBS LLVMNextFMObjects)
