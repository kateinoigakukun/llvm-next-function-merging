add_llvm_pass_plugin(LLVMNextFM
  FastFM.cpp
  FMSA.cpp
  FunctionMerging.cpp
  MatchingUtils.h
  MergeSimilarFunctions.cpp
  MinSizeAttr.cpp
  NextFMLoader.cpp)

if(NOT LLVM_ENABLE_RTTI)
  target_compile_options(LLVMNextFM PRIVATE "-fno-rtti")
endif()
