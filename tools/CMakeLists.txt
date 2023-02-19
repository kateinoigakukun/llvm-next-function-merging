add_subdirectory(llvm-nextfm-testgen)
add_subdirectory(llvm-nextfm-sweetspot)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/llvm-nextfm-opt.in
               ${CMAKE_CURRENT_BINARY_DIR}/llvm-nextfm-opt @ONLY)
