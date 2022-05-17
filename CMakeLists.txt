cmake_minimum_required(VERSION 3.13.4)
project(llvm-next-function-merging)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

set(LLVM_NEXT_FM_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_compile_definitions(LLVM_NEXT_FM_STANDALONE)
include_directories(include)
add_subdirectory(lib/Transforms/IPO)

if(BUILD_TESTING)
  add_subdirectory(test)
endif()
