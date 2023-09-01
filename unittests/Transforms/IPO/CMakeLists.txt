add_executable(LLVMNextFMTests
  FixedBitVectorTests.cpp
  FunctionMergingUtilsTests.cpp
  MultipleSequenceAlignmentTests.cpp
  TensorTableTests.cpp)

llvm_map_components_to_libnames(LLVM_LINK_LIBS Passes Core Analysis CodeGen)
target_link_libraries(LLVMNextFMTests
  LLVMNextFMObjects
  LLVMExtractGV2Objects
  gtest_main
  ${LLVM_LINK_LIBS})

include(GoogleTest)
gtest_discover_tests(LLVMNextFMTests)
add_test(NAME LLVMNextFMTests COMMAND LLVMNextFMTests)
