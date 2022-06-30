cmake_minimum_required(VERSION 3.13.4)
project(llvm-next-function-merging)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

if(NOT LLVM_ENABLE_RTTI)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()

set(LLVM_NEXT_FM_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_compile_definitions(LLVM_NEXT_FM_STANDALONE)
include_directories(include)
add_subdirectory(lib)
add_subdirectory(tools)

if(BUILD_TESTING)
  enable_testing()

  # Locally built LLVM can have gtest installed
  if(NOT TARGET gtest)
    include(FetchContent)
    FetchContent_Declare(
      googletest
      URL https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip
    )
    # For Windows: Prevent overriding the parent project's compiler/linker settings
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
  endif()

  add_subdirectory(test)
  add_subdirectory(unittests)
endif()
