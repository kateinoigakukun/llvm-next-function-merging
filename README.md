# LLVM Next Function Merging

LLVM Next Function Merging is an experimental LLVM pass plugin that allows you to apply the State of the Art function merging techniques to your program.

The optimization passes are derived from ["F3M: Fast Focused Function Merging (CGO'22), Sean Sterling, Rodrigo C. O. Rocha, Hugh Leather, Kim Hazelwood, Michael O'Boyle, Pavlos Petoumenos"](https://ieeexplore.ieee.org/document/9741269) and its [forked LLVM repository](https://github.com/ppetoumenos/llvm-project/releases/tag/cgo22ae2) with a few changes for building it as a plugin (Licensed under Apache License v2.0 with LLVM Exceptions).

This repository is a fork of the original repository and allows out-of-tree development from LLVM to focus on the essential improvements.

## Quick start

1. Clone the repository

```console
$ git clone https://github.com/kateinoigakukun/llvm-next-function-merging.git
$ cd llvm-next-function-merging
```

2. Configure build directory

You need LLVM 13 or later to build this plugin.
Please add `-DLLVM_DIR:PATH=/path/to/lib/cmake/llvm` to the CMake configuration in the case of pkg-config cannot find LLVM.

```console
$ cmake -B build -G Ninja
```

3. Build the plugin

```console
$ cmake --build ./build
```

4. Use the plugin with `opt`

Note: Since most of passes other than `func-merging` still use the legacy pass manager, you need to pass `--enable-new-pm=false` and `--load` instead of `--load-pass-plugin` to `opt`.

```console
opt --load-pass-plugin ./build/lib/Transforms/IPO/LLVMNextFM.so \
  -S ./test/Transforms/NextFM/basic.ll \
  --passes=func-merging
```

## Optimization passes

This plugin provides the following passes:

| Pass name | Short description | Paper | Original source |
| --------- | ----------- | ----- | ----- |
| [`func-merging`](./lib/Transforms/IPO/FunctionMerging.cpp) | The current state of the art. Better pair finding algorithm based on MinHash, LSH, and `fastfm` | [F3M: Fast Focused Function Merging (CGO'22)](https://ieeexplore.ieee.org/document/9741269), [HyFM: Function Merging for Free (LCTES'21)](https://dl.acm.org/doi/10.1145/3461648.3463852) | [ppetoumenos/llvm-project by Pavlos Petoumenos](https://github.com/ppetoumenos/llvm-project) |
| [`fastfm`](./lib/Transforms/IPO/FastFM.cpp) | Better merging algorithm (SalSSA) | [Effective Function Merging in the SSA Form (PLDI'20)](https://dl.acm.org/doi/abs/10.1145/3385412.3386030) | [rcorcs/llvm-project by Rodrigo Rocha](https://github.com/rcorcs/llvm-project/tree/func-merge) |
| [`fmsa`](./lib/Transforms/IPO/FMSA.cpp) | Merging arbitrary two functions by pairwise sequence alignment | [Function Merging by Sequence Alignment (CGO'19)](https://ieeexplore.ieee.org/document/8661174) | [rcorcs/fmsa by Rodrigo Rocha](https://github.com/rcorcs/fmsa) |
| [`mergesimilarfunc`](./lib/Transforms/IPO/MergeSimilarFunctions.cpp) | Merging two functions with isomorphic CFGs | [Exploiting Function Similarity for Code Size Reduction (LCTES 2014)](https://dl.acm.org/doi/10.1145/2666357.2597811) | [LLVM Patch D22051 by Tobias Edler von Koch](https://reviews.llvm.org/D22051) |



## Executing the Tests

This project uses `lit` to execute the tests as well as other LLVM families do.

```console
$ cmake -B build -G Ninja -D BUILD_TESTING:BOOL=ON
$ cmake --build ./build
$ lit ./build/test
```

## Project Structure

The directory structure of this project is designed to be easy for upstreaming to the LLVM project.
Most part of the tree shadows the original LLVM repository structure.
