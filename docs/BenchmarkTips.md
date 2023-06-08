## Sort benchmark cases by number of source functions

```bash
for f in ../llvm-nextfm-benchmark/benchmarks/*/*/_main_._all_._files_._linked_.bc; do
  n=$(./build/release-13/tools/llvm-nextfm-opt --passes="dump-funcsize" $f -o /dev/null 2>/dev/null | jq 'map(select(.size != 0)) | length');
  echo "$n\t$f";
done | sort -h
```
