## Fuzzing

This project uses [libFuzzer](https://llvm.org/docs/LibFuzzer.html) to fuzz the optimizers.
Currently, the fuzzing target is only the sequence aligner, but it can be extended to other optimizers.


### Running the fuzzer

```console
$ mkdir -p test/fuzzer/reports
$ cd build/release
$ ninja tools/llvm-nextfm-sa-fuzzer/llvm-nextfm-sa-fuzzer
$ ./tools/llvm-nextfm-sa-fuzzer/llvm-nextfm-sa-fuzzer -artifact_prefix=../../test/fuzzer/reports
```


### Debugging the found bugs

After the fuzzer finds a bug, it will generate a test case in the `test/fuzzer/reports` directory. To debug the bug, you can use the `llvm-nextfm-sa-check`.

```console
$ tools/llvm-nextfm-sa-fuzzer/llvm-nextfm-sa-check ../../test/fuzzer/reports/crash-5ca2d00275140de23e6a2bb918c30ce7bf8e490a
```
