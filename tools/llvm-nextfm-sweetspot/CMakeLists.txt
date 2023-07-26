add_executable(llvm-nextfm-sweetspot "llvm-nextfm-sweetspot.cpp")
llvm_map_components_to_libnames(llvm_libs support core irreader transformutils ipo x86asmparser x86codegen x86desc x86disassembler x86info)

# Link against LLVM libraries
target_link_libraries(llvm-nextfm-sweetspot ${llvm_libs} LLVMExtractGV2Objects)
