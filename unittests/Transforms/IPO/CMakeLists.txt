add_executable(LLVMNextFMTests
  MultipleSequenceAlignmentTests.cpp)

llvm_map_components_to_libnames(LLVM_LINK_LIBS Passes Core Analysis)
target_link_libraries(LLVMNextFMTests
  LLVMNextFMObjects
  gtest_main
  ${LLVM_LINK_LIBS})

include(GoogleTest)
gtest_discover_tests(LLVMNextFMTests)
add_test(NAME LLVMNextFMTests COMMAND LLVMNextFMTests)
