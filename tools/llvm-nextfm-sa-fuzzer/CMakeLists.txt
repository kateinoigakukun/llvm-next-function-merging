add_executable(llvm-nextfm-sa-fuzzer
    "SequenceAlignerCheck.cpp"
    "llvm-nextfm-sa-fuzzer.cpp")

add_executable(llvm-nextfm-sa-check
    "SequenceAlignerCheck.cpp"
    "llvm-nextfm-sa-check.cpp")

llvm_map_components_to_libnames(llvm_libs support core irreader transformutils ipo x86asmparser x86codegen x86desc x86disassembler x86info fuzzmutate)

target_compile_options(llvm-nextfm-sa-fuzzer
            PRIVATE $<$<C_COMPILER_ID:Clang>:-g -O1 -fsanitize=fuzzer>
            )

target_link_options(llvm-nextfm-sa-fuzzer
            PRIVATE $<$<C_COMPILER_ID:Clang>:-fsanitize=fuzzer>
            )
target_link_libraries(llvm-nextfm-sa-fuzzer ${llvm_libs} LLVMNextFMObjects)
target_link_libraries(llvm-nextfm-sa-check ${llvm_libs} LLVMNextFMObjects)
