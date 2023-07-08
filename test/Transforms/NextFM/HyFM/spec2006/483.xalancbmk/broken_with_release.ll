; UNSUPPORTED: true
; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" \
; RUN:   -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging \
; RUN:   -func-merging-explore=3 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true \
; RUN:   -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive \
; RUN:   --multiple-func-merging-extract=_ZN10xalanc_1_822doAppendSiblingToChildINS_19XalanSourceTreeTextEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ \
; RUN:   --multiple-func-merging-extract=_ZN10xalanc_1_822doAppendSiblingToChildINS_36XalanSourceTreeProcessingInstructionEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ \
; RUN:   --multiple-func-merging-extract=_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeElementEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ \
; RUN:   --multiple-func-merging-extract=_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeCommentEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ \
; RUN:   --multiple-func-merging-extract=_ZN10xalanc_1_815doAppendSiblingINS_19XalanSourceTreeTextEEEvPT_RPNS_9XalanNodeES5_ \
; RUN:   -pass-remarks-output=- \
; RUN:   /home/katei/ghq/github.com/kateinoigakukun/llvm-nextfm-benchmark/benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc \
; RUN:   -o /dev/null 2>&1 | FileCheck %s

; CHECK:      --- !Passed
; CHECK-NEXT: Pass:            multiple-func-merging
; CHECK-NEXT: Name:            Merge
; CHECK-NEXT: Function:        __mf_merge__ZN10xalanc_1_822doAppendSiblingToChildINS_19XalanSourceTreeTextEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT___ZN10xalanc_1_815doAppendSiblingINS_19XalanSourceTreeTextEEEvPT_RPNS_9XalanNodeES5___ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeCommentEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT___ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeElementEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_

