; RUN: llvm-extract-13 \
; RUN:   --func=_ZNSt12_Vector_baseIN10xalanc_1_814KeyDeclarationESaIS1_EED2Ev \
; RUN:   --func=_ZNSt12_Vector_baseIN10xalanc_1_814VariablesStack10StackEntryESaIS2_EED2Ev \
; RUN:   --func=_ZNSt12_Vector_baseIN10xalanc_1_814VariablesStack17ParamsVectorEntryESaIS2_EED2Ev \
; RUN:   --func=_ZNSt12_Vector_baseIN10xalanc_1_814XalanDOMStringESaIS1_EED2Ev \
; RUN:   --func=_ZNSt12_Vector_baseIN10xalanc_1_817NamespacesHandler17NamespaceExtendedESaIS2_EED2Ev \
; RUN:   /home/katei/ghq/github.com/kateinoigakukun/llvm-nextfm-benchmark/benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc \
; RUN:   -o %t.base.bc

; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" \
; RUN:   -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging \
; RUN:   -func-merging-explore=1 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true \
; RUN:   -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive \
; RUN:   -pass-remarks-output=- \
; RUN:   %t.x.bc \
; RUN:   -o %t.merged.2.base.bc 2>&1 | FileCheck %s

; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" \
; RUN:   -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging \
; RUN:   -func-merging-explore=1 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true \
; RUN:   -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive \
; RUN:   --multiple-func-merging-extract=_ZNSt12_Vector_baseIN10xalanc_1_814KeyDeclarationESaIS1_EED2Ev \
; RUN:   --multiple-func-merging-extract=_ZNSt12_Vector_baseIN10xalanc_1_814VariablesStack10StackEntryESaIS2_EED2Ev \
; RUN:   --multiple-func-merging-extract=_ZNSt12_Vector_baseIN10xalanc_1_814VariablesStack17ParamsVectorEntryESaIS2_EED2Ev \
; RUN:   --multiple-func-merging-extract=_ZNSt12_Vector_baseIN10xalanc_1_814XalanDOMStringESaIS1_EED2Ev \
; RUN:   --multiple-func-merging-extract=_ZNSt12_Vector_baseIN10xalanc_1_817NamespacesHandler17NamespaceExtendedESaIS2_EED2Ev \
; RUN:   -pass-remarks-output=- \
; RUN:   /home/katei/ghq/github.com/kateinoigakukun/llvm-nextfm-benchmark/benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc \
; RUN:   -o %t.merged.2.x.bc 2>&1 | FileCheck %s

; RUN: %llc --filetype=obj %t.merged.2.base.bc -o %t.merged.2.base.o
; RUN: %llc --filetype=obj %t.merged.2.x.bc -o %t.merged.2.x.o
; RUN: %strip %t.merged.2.base.o
; RUN: %strip %t.merged.2.x.o
; RUN: test $(stat -c%%s %t.merged.2.x.o) -eq $(stat -c%%s %t.merged.2.base.o)

; CHECK:      --- !Passed
