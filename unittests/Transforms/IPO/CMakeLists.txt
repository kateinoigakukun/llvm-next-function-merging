add_executable(LLVMNextFMTests
  MultipleSequenceAlignmentTests.cpp)

target_link_libraries(LLVMNextFMTests
  LLVMNextFM
  gtest_main)

include(GoogleTest)
gtest_discover_tests(LLVMNextFMTests)
add_test(NAME LLVMNextFMTests COMMAND LLVMNextFMTests)
