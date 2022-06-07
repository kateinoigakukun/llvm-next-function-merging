add_llvm_pass_plugin(LLVMNextFM
  NO_MODULE
  FastFM.cpp
  FMSA.cpp
  FunctionMerging.cpp
  MatchingUtils.h
  MergeSimilarFunctions.cpp
  MinSizeAttr.cpp
  MultipleSequenceAlignment.cpp
  NextFMLoader.cpp
  SALSSACodeGen.cpp)

if(NOT LLVM_ENABLE_RTTI)
  target_compile_options(LLVMNextFM PRIVATE "-fno-rtti")
endif()
