add_executable(llvm-nextfm-testgen "llvm-nextfm-testgen.cpp")
llvm_map_components_to_libnames(llvm_libs support core irreader transformutils ipo)

# Link against LLVM libraries
target_link_libraries(llvm-nextfm-testgen ${llvm_libs})
