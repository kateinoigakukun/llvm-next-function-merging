; RUN: %opt -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=3 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=manual --multiple-func-merging-only=_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeElementEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ --multiple-func-merging-only=_ZN10xalanc_1_815doAppendSiblingINS_19XalanSourceTreeTextEEEvPT_RPNS_9XalanNodeES5_ --multiple-func-merging-only=_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeCommentEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ -pass-remarks-output=- %s -S -o /dev/null | FileCheck %s
; CHECK-NOT: Reason:          Something went wrong

source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.xalanc_1_8::XalanSourceTreeComment" = type { %"class.xalanc_1_8::XalanComment", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanSourceTreeDocument"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, i64 }
%"class.xalanc_1_8::XalanComment" = type { %"class.xalanc_1_8::XalanDocumentFragment" }
%"class.xalanc_1_8::XalanDocumentFragment" = type { %"class.xalanc_1_8::XalanNode" }
%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%"class.xalanc_1_8::XalanDOMString" = type <{ %"class.std::vector", i32, [4 x i8] }>
%"class.std::vector" = type { %"struct.std::_Vector_base" }
%"struct.std::_Vector_base" = type { %"struct.std::_Vector_base<unsigned short, std::allocator<unsigned short> >::_Vector_impl" }
%"struct.std::_Vector_base<unsigned short, std::allocator<unsigned short> >::_Vector_impl" = type { i16*, i16*, i16* }
%"class.xalanc_1_8::XalanSourceTreeDocument" = type { %"class.xalanc_1_8::XalanDocumentFragment", %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanSourceTreeElement"*, %"class.xalanc_1_8::XalanSourceTreeAttributeAllocator", %"class.xalanc_1_8::XalanSourceTreeAttributeNSAllocator", %"class.xalanc_1_8::XalanSourceTreeCommentAllocator", %"class.xalanc_1_8::XalanSourceTreeElementAAllocator", %"class.xalanc_1_8::XalanSourceTreeElementANSAllocator", %"class.xalanc_1_8::XalanSourceTreeElementNAAllocator", %"class.xalanc_1_8::XalanSourceTreeElementNANSAllocator", %"class.xalanc_1_8::XalanSourceTreeProcessingInstructionAllocator", %"class.xalanc_1_8::XalanSourceTreeTextAllocator", %"class.xalanc_1_8::XalanSourceTreeTextIWSAllocator", %"class.xalanc_1_8::XalanDOMStringPool", %"class.xalanc_1_8::XalanDOMStringPool", %"class.xalanc_1_8::XalanArrayAllocator", i64, i8, %"class.std::map", %"class.std::map", %"class.std::deque", %"class.xalanc_1_8::XalanDOMString" }
%"class.xalanc_1_8::XalanSourceTreeElement" = type { %"class.xalanc_1_8::XalanDocumentFragment", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanSourceTreeDocument"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, i64 }
%"class.xalanc_1_8::XalanSourceTreeAttributeAllocator" = type { %"class.xalanc_1_8::ArenaAllocator" }
%"class.xalanc_1_8::ArenaAllocator" = type { i32 (...)**, i64, %"class.std::vector.0" }
%"class.std::vector.0" = type { %"struct.std::_Vector_base.1" }
%"struct.std::_Vector_base.1" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttr> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttr> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttr> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttr> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock"**, %"class.xalanc_1_8::ArenaBlock"**, %"class.xalanc_1_8::ArenaBlock"** }
%"class.xalanc_1_8::ArenaBlock" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeAttr"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeAttr" = type { %"class.xalanc_1_8::XalanDocumentFragment", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanSourceTreeElement"*, i64 }
%"class.xalanc_1_8::ArenaBlockDestroy" = type { i8 }
%"class.xalanc_1_8::XalanSourceTreeAttributeNSAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.8" }
%"class.xalanc_1_8::ArenaAllocator.8" = type { i32 (...)**, i64, %"class.std::vector.9" }
%"class.std::vector.9" = type { %"struct.std::_Vector_base.10" }
%"struct.std::_Vector_base.10" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttrNS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttrNS> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttrNS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeAttrNS> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.14"**, %"class.xalanc_1_8::ArenaBlock.14"**, %"class.xalanc_1_8::ArenaBlock.14"** }
%"class.xalanc_1_8::ArenaBlock.14" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeAttrNS"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeAttrNS" = type { %"class.xalanc_1_8::XalanSourceTreeAttr", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"* }
%"class.xalanc_1_8::XalanSourceTreeCommentAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.20" }
%"class.xalanc_1_8::ArenaAllocator.20" = type { i32 (...)**, i64, %"class.std::vector.21" }
%"class.std::vector.21" = type { %"struct.std::_Vector_base.22" }
%"struct.std::_Vector_base.22" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeComment> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeComment> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeComment> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeComment> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.26"**, %"class.xalanc_1_8::ArenaBlock.26"**, %"class.xalanc_1_8::ArenaBlock.26"** }
%"class.xalanc_1_8::ArenaBlock.26" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeComment"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeElementAAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.32" }
%"class.xalanc_1_8::ArenaAllocator.32" = type { i32 (...)**, i64, %"class.std::vector.33" }
%"class.std::vector.33" = type { %"struct.std::_Vector_base.34" }
%"struct.std::_Vector_base.34" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementA> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementA> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementA> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementA> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.38"**, %"class.xalanc_1_8::ArenaBlock.38"**, %"class.xalanc_1_8::ArenaBlock.38"** }
%"class.xalanc_1_8::ArenaBlock.38" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeElementA"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeElementA" = type { %"class.xalanc_1_8::XalanSourceTreeElement", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanSourceTreeAttr"**, i64 }
%"class.xalanc_1_8::XalanSourceTreeElementANSAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.44" }
%"class.xalanc_1_8::ArenaAllocator.44" = type { i32 (...)**, i64, %"class.std::vector.45" }
%"class.std::vector.45" = type { %"struct.std::_Vector_base.46" }
%"struct.std::_Vector_base.46" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementANS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementANS> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementANS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementANS> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.50"**, %"class.xalanc_1_8::ArenaBlock.50"**, %"class.xalanc_1_8::ArenaBlock.50"** }
%"class.xalanc_1_8::ArenaBlock.50" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeElementANS"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeElementANS" = type { %"class.xalanc_1_8::XalanSourceTreeElementA", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"* }
%"class.xalanc_1_8::XalanSourceTreeElementNAAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.56" }
%"class.xalanc_1_8::ArenaAllocator.56" = type { i32 (...)**, i64, %"class.std::vector.57" }
%"class.std::vector.57" = type { %"struct.std::_Vector_base.58" }
%"struct.std::_Vector_base.58" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNA> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNA> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNA> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNA> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.62"**, %"class.xalanc_1_8::ArenaBlock.62"**, %"class.xalanc_1_8::ArenaBlock.62"** }
%"class.xalanc_1_8::ArenaBlock.62" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeElementNA"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeElementNA" = type { %"class.xalanc_1_8::XalanSourceTreeElement" }
%"class.xalanc_1_8::XalanSourceTreeElementNANSAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.68" }
%"class.xalanc_1_8::ArenaAllocator.68" = type { i32 (...)**, i64, %"class.std::vector.69" }
%"class.std::vector.69" = type { %"struct.std::_Vector_base.70" }
%"struct.std::_Vector_base.70" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNANS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNANS> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNANS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeElementNANS> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.74"**, %"class.xalanc_1_8::ArenaBlock.74"**, %"class.xalanc_1_8::ArenaBlock.74"** }
%"class.xalanc_1_8::ArenaBlock.74" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeElementNANS"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeElementNANS" = type { %"class.xalanc_1_8::XalanSourceTreeElementNA", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"* }
%"class.xalanc_1_8::XalanSourceTreeProcessingInstructionAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.80" }
%"class.xalanc_1_8::ArenaAllocator.80" = type { i32 (...)**, i64, %"class.std::vector.81" }
%"class.std::vector.81" = type { %"struct.std::_Vector_base.82" }
%"struct.std::_Vector_base.82" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeProcessingInstruction> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeProcessingInstruction> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeProcessingInstruction> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeProcessingInstruction> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.86"**, %"class.xalanc_1_8::ArenaBlock.86"**, %"class.xalanc_1_8::ArenaBlock.86"** }
%"class.xalanc_1_8::ArenaBlock.86" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeProcessingInstruction"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeProcessingInstruction" = type { %"class.xalanc_1_8::XalanDocumentFragment", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanSourceTreeDocument"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, i64 }
%"class.xalanc_1_8::XalanSourceTreeTextAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.92" }
%"class.xalanc_1_8::ArenaAllocator.92" = type { i32 (...)**, i64, %"class.std::vector.93" }
%"class.std::vector.93" = type { %"struct.std::_Vector_base.94" }
%"struct.std::_Vector_base.94" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeText> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeText> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeText> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeText> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.98"**, %"class.xalanc_1_8::ArenaBlock.98"**, %"class.xalanc_1_8::ArenaBlock.98"** }
%"class.xalanc_1_8::ArenaBlock.98" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeText"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeText" = type { %"class.xalanc_1_8::XalanComment", %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, i64 }
%"class.xalanc_1_8::XalanSourceTreeTextIWSAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.104" }
%"class.xalanc_1_8::ArenaAllocator.104" = type { i32 (...)**, i64, %"class.std::vector.105" }
%"class.std::vector.105" = type { %"struct.std::_Vector_base.106" }
%"struct.std::_Vector_base.106" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeTextIWS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeTextIWS> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeTextIWS> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanSourceTreeTextIWS> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.110"**, %"class.xalanc_1_8::ArenaBlock.110"**, %"class.xalanc_1_8::ArenaBlock.110"** }
%"class.xalanc_1_8::ArenaBlock.110" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanSourceTreeTextIWS"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanSourceTreeTextIWS" = type { %"class.xalanc_1_8::XalanSourceTreeText" }
%"class.xalanc_1_8::XalanDOMStringPool" = type { i32 (...)**, %"class.xalanc_1_8::XalanDOMStringAllocator", i64, %"class.xalanc_1_8::XalanDOMStringHashTable" }
%"class.xalanc_1_8::XalanDOMStringAllocator" = type { %"class.xalanc_1_8::ArenaAllocator.116" }
%"class.xalanc_1_8::ArenaAllocator.116" = type { i32 (...)**, i64, %"class.std::vector.117" }
%"class.std::vector.117" = type { %"struct.std::_Vector_base.118" }
%"struct.std::_Vector_base.118" = type { %"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanDOMString> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanDOMString> *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanDOMString> *, std::allocator<xalanc_1_8::ArenaBlock<xalanc_1_8::XalanDOMString> *> >::_Vector_impl" = type { %"class.xalanc_1_8::ArenaBlock.122"**, %"class.xalanc_1_8::ArenaBlock.122"**, %"class.xalanc_1_8::ArenaBlock.122"** }
%"class.xalanc_1_8::ArenaBlock.122" = type <{ i32 (...)**, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8], i64, i64, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::ArenaBlockDestroy", [7 x i8] }>
%"class.xalanc_1_8::XalanDOMStringHashTable" = type <{ i64, i64, %"class.xalanc_1_8::XalanArrayAutoPtr", i64, i32, [4 x i8] }>
%"class.xalanc_1_8::XalanArrayAutoPtr" = type { %"class.std::vector.128"* }
%"class.std::vector.128" = type { %"struct.std::_Vector_base.129" }
%"struct.std::_Vector_base.129" = type { %"struct.std::_Vector_base<const xalanc_1_8::XalanDOMString *, std::allocator<const xalanc_1_8::XalanDOMString *> >::_Vector_impl" }
%"struct.std::_Vector_base<const xalanc_1_8::XalanDOMString *, std::allocator<const xalanc_1_8::XalanDOMString *> >::_Vector_impl" = type { %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"** }
%"class.xalanc_1_8::XalanArrayAllocator" = type { %"class.std::__cxx11::list", i64, %"struct.std::pair"* }
%"class.std::__cxx11::list" = type { %"class.std::__cxx11::_List_base" }
%"class.std::__cxx11::_List_base" = type { %"struct.std::__cxx11::_List_base<std::pair<unsigned long, std::vector<xalanc_1_8::XalanSourceTreeAttr *> >, std::allocator<std::pair<unsigned long, std::vector<xalanc_1_8::XalanSourceTreeAttr *> > > >::_List_impl" }
%"struct.std::__cxx11::_List_base<std::pair<unsigned long, std::vector<xalanc_1_8::XalanSourceTreeAttr *> >, std::allocator<std::pair<unsigned long, std::vector<xalanc_1_8::XalanSourceTreeAttr *> > > >::_List_impl" = type { %"struct.std::_List_node" }
%"struct.std::_List_node" = type { %"struct.std::__detail::_List_node_base", i64 }
%"struct.std::__detail::_List_node_base" = type { %"struct.std::__detail::_List_node_base"*, %"struct.std::__detail::_List_node_base"* }
%"struct.std::pair" = type { i8*, i64 }
%"class.std::map" = type { %"class.std::_Rb_tree" }
%"class.std::_Rb_tree" = type { %"struct.std::_Rb_tree<const unsigned short *, std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *>, std::_Select1st<std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *> >, xalanc_1_8::less_null_terminated_arrays<unsigned short> >::_Rb_tree_impl" }
%"struct.std::_Rb_tree<const unsigned short *, std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *>, std::_Select1st<std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *> >, xalanc_1_8::less_null_terminated_arrays<unsigned short> >::_Rb_tree_impl" = type { %"struct.std::_Rb_tree_key_compare", %"struct.std::_Rb_tree_header" }
%"struct.std::_Rb_tree_key_compare" = type { %"class.xalanc_1_8::ArenaBlockDestroy" }
%"struct.std::_Rb_tree_header" = type { %"struct.std::_Rb_tree_node_base", i64 }
%"struct.std::_Rb_tree_node_base" = type { i32, %"struct.std::_Rb_tree_node_base"*, %"struct.std::_Rb_tree_node_base"*, %"struct.std::_Rb_tree_node_base"* }
%"class.std::deque" = type { %"class.std::_Deque_base" }
%"class.std::_Deque_base" = type { %"struct.std::_Deque_base<xalanc_1_8::XalanDOMString, std::allocator<xalanc_1_8::XalanDOMString> >::_Deque_impl" }
%"struct.std::_Deque_base<xalanc_1_8::XalanDOMString, std::allocator<xalanc_1_8::XalanDOMString> >::_Deque_impl" = type { %"class.xalanc_1_8::XalanDOMString"**, i64, %"struct.std::_Deque_iterator", %"struct.std::_Deque_iterator" }
%"struct.std::_Deque_iterator" = type { %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"** }
%"class.xalanc_1_8::XalanSourceTreeDocumentFragment" = type { %"class.xalanc_1_8::XalanDocumentFragment", %"class.xalanc_1_8::XalanSourceTreeDocument"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xalanc_1_8::XalanDOMException" = type <{ i32 (...)**, i32, [4 x i8] }>

$_ZN10xalanc_1_815doAppendSiblingINS_19XalanSourceTreeTextEEEvPT_RPNS_9XalanNodeES5_ = comdat any

$_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeCommentEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ = comdat any

$_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeElementEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_ = comdat any

@_ZTIN10xalanc_1_817XalanDOMExceptionE = external constant { i8*, i8* }, align 8

declare i32 @__gxx_personality_v0(...)

declare i8* @__cxa_allocate_exception(i64) local_unnamed_addr

declare void @__cxa_throw(i8*, i8*, i8*) local_unnamed_addr

declare void @__cxa_free_exception(i8*) local_unnamed_addr

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
declare void @_ZN10xalanc_1_822XalanSourceTreeComment9setParentEPNS_31XalanSourceTreeDocumentFragmentE(%"class.xalanc_1_8::XalanSourceTreeComment"* nocapture nonnull align 8 dereferenceable(56), %"class.xalanc_1_8::XalanSourceTreeDocumentFragment"*) local_unnamed_addr #0 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare %"class.xalanc_1_8::XalanSourceTreeComment"* @_ZN10xalanc_1_813castToCommentEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_86appendINS_22XalanSourceTreeCommentEEEvRPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanSourceTreeComment"*) local_unnamed_addr #2

; Function Attrs: noinline nounwind optsize uwtable
declare %"class.xalanc_1_8::XalanSourceTreeElement"* @_ZN10xalanc_1_813castToElementEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_86appendINS_22XalanSourceTreeElementEEEvRPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanSourceTreeElement"*) local_unnamed_addr #2

; Function Attrs: noinline nounwind optsize uwtable
declare %"class.xalanc_1_8::XalanSourceTreeProcessingInstruction"* @_ZN10xalanc_1_827castToProcessingInstructionEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #1

; Function Attrs: noinline nounwind optsize uwtable
declare %"class.xalanc_1_8::XalanSourceTreeText"* @_ZN10xalanc_1_810castToTextEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare %"class.xalanc_1_8::XalanNode"* @_ZN10xalanc_1_816doGetLastSiblingEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_815doAppendSiblingINS_22XalanSourceTreeElementEEEvPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanSourceTreeElement"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_815doAppendSiblingINS_22XalanSourceTreeCommentEEEvPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanSourceTreeComment"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZN10xalanc_1_815doAppendSiblingINS_19XalanSourceTreeTextEEEvPT_RPNS_9XalanNodeES5_(%"class.xalanc_1_8::XalanSourceTreeText"* %thePreviousSibling, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theNextSiblingSlot, %"class.xalanc_1_8::XalanNode"* %theNewSibling) local_unnamed_addr #2 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = bitcast %"class.xalanc_1_8::XalanNode"* %theNewSibling to i32 (%"class.xalanc_1_8::XalanNode"*)***
  %vtable = load i32 (%"class.xalanc_1_8::XalanNode"*)**, i32 (%"class.xalanc_1_8::XalanNode"*)*** %0, align 8, !tbaa !4
  %vfn = getelementptr inbounds i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vtable, i64 4
  %1 = load i32 (%"class.xalanc_1_8::XalanNode"*)*, i32 (%"class.xalanc_1_8::XalanNode"*)** %vfn, align 8
  %call = tail call i32 %1(%"class.xalanc_1_8::XalanNode"* nonnull align 8 dereferenceable(8) %theNewSibling) #3
  switch i32 %call, label %sw.default [
    i32 8, label %sw.bb
    i32 1, label %sw.bb2
    i32 7, label %sw.bb4
    i32 3, label %sw.bb6
  ]

sw.bb:                                            ; preds = %entry
  %call1 = tail call %"class.xalanc_1_8::XalanSourceTreeComment"* @_ZN10xalanc_1_813castToCommentEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"* nonnull %theNewSibling) #3
  tail call void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextENS_22XalanSourceTreeCommentEEEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"* %thePreviousSibling, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theNextSiblingSlot, %"class.xalanc_1_8::XalanSourceTreeComment"* %call1) #3
  br label %sw.epilog

sw.bb2:                                           ; preds = %entry
  %call3 = tail call %"class.xalanc_1_8::XalanSourceTreeElement"* @_ZN10xalanc_1_813castToElementEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"* nonnull %theNewSibling) #3
  tail call void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextENS_22XalanSourceTreeElementEEEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"* %thePreviousSibling, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theNextSiblingSlot, %"class.xalanc_1_8::XalanSourceTreeElement"* %call3) #3
  br label %sw.epilog

sw.bb4:                                           ; preds = %entry
  %call5 = tail call %"class.xalanc_1_8::XalanSourceTreeProcessingInstruction"* @_ZN10xalanc_1_827castToProcessingInstructionEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"* nonnull %theNewSibling) #3
  tail call void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextENS_36XalanSourceTreeProcessingInstructionEEEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"* %thePreviousSibling, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theNextSiblingSlot, %"class.xalanc_1_8::XalanSourceTreeProcessingInstruction"* %call5) #3
  br label %sw.epilog

sw.bb6:                                           ; preds = %entry
  %call7 = tail call %"class.xalanc_1_8::XalanSourceTreeText"* @_ZN10xalanc_1_810castToTextEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"* nonnull %theNewSibling) #3
  tail call void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextES1_EEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"* %thePreviousSibling, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theNextSiblingSlot, %"class.xalanc_1_8::XalanSourceTreeText"* %call7) #3
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  %exception = tail call i8* @__cxa_allocate_exception(i64 16) #4
  %2 = bitcast i8* %exception to %"class.xalanc_1_8::XalanDOMException"*
  invoke void @_ZN10xalanc_1_817XalanDOMExceptionC1ENS0_13ExceptionCodeE(%"class.xalanc_1_8::XalanDOMException"* nonnull align 8 dereferenceable(12) %2, i32 3) #3
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %sw.default
  tail call void @__cxa_throw(i8* %exception, i8* bitcast ({ i8*, i8* }* @_ZTIN10xalanc_1_817XalanDOMExceptionE to i8*), i8* bitcast (void (%"class.xalanc_1_8::XalanDOMException"*)* @_ZN10xalanc_1_817XalanDOMExceptionD1Ev to i8*)) #5
  unreachable

lpad:                                             ; preds = %sw.default
  %3 = landingpad { i8*, i32 }
          cleanup
  tail call void @__cxa_free_exception(i8* %exception) #4
  resume { i8*, i32 } %3

sw.epilog:                                        ; preds = %sw.bb6, %sw.bb4, %sw.bb2, %sw.bb
  ret void
}

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextENS_22XalanSourceTreeCommentEEEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"*, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanSourceTreeComment"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextENS_22XalanSourceTreeElementEEEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"*, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanSourceTreeElement"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextENS_36XalanSourceTreeProcessingInstructionEEEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"*, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanSourceTreeProcessingInstruction"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
declare void @_ZN10xalanc_1_86appendINS_19XalanSourceTreeTextES1_EEvPT_RPNS_9XalanNodeEPT0_(%"class.xalanc_1_8::XalanSourceTreeText"*, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8), %"class.xalanc_1_8::XalanSourceTreeText"*) local_unnamed_addr #2

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeCommentEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanSourceTreeDocumentFragment"* %theOwnerDocumentFragment, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theFirstChildSlot, %"class.xalanc_1_8::XalanSourceTreeComment"* %theNewSibling) local_unnamed_addr #2 comdat {
entry:
  %0 = bitcast %"class.xalanc_1_8::XalanSourceTreeComment"* %theNewSibling to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)***
  %vtable = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)*** %0, align 8, !tbaa !4
  %vfn = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)** %vtable, i64 5
  %1 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeComment"*)** %vfn, align 8
  %call = tail call %"class.xalanc_1_8::XalanNode"* %1(%"class.xalanc_1_8::XalanSourceTreeComment"* nonnull align 8 dereferenceable(56) %theNewSibling) #3
  %2 = getelementptr %"class.xalanc_1_8::XalanSourceTreeDocumentFragment", %"class.xalanc_1_8::XalanSourceTreeDocumentFragment"* %theOwnerDocumentFragment, i64 0, i32 0, i32 0
  %cmp.not = icmp eq %"class.xalanc_1_8::XalanNode"* %call, %2
  br i1 %cmp.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  tail call void @_ZN10xalanc_1_822XalanSourceTreeComment9setParentEPNS_31XalanSourceTreeDocumentFragmentE(%"class.xalanc_1_8::XalanSourceTreeComment"* nonnull align 8 dereferenceable(56) %theNewSibling, %"class.xalanc_1_8::XalanSourceTreeDocumentFragment"* %theOwnerDocumentFragment) #3
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %3 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %theFirstChildSlot, align 8, !tbaa !7
  %cmp1 = icmp eq %"class.xalanc_1_8::XalanNode"* %3, null
  br i1 %cmp1, label %if.then2, label %if.else

if.then2:                                         ; preds = %if.end
  tail call void @_ZN10xalanc_1_86appendINS_22XalanSourceTreeCommentEEEvRPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theFirstChildSlot, %"class.xalanc_1_8::XalanSourceTreeComment"* nonnull %theNewSibling) #3
  br label %if.end4

if.else:                                          ; preds = %if.end
  %call3 = tail call %"class.xalanc_1_8::XalanNode"* @_ZN10xalanc_1_816doGetLastSiblingEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"* nonnull %3) #3
  tail call void @_ZN10xalanc_1_815doAppendSiblingINS_22XalanSourceTreeCommentEEEvPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"* %call3, %"class.xalanc_1_8::XalanSourceTreeComment"* nonnull %theNewSibling) #3
  br label %if.end4

if.end4:                                          ; preds = %if.else, %if.then2
  ret void
}

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZN10xalanc_1_822doAppendSiblingToChildINS_22XalanSourceTreeElementEEEvPNS_31XalanSourceTreeDocumentFragmentERPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanSourceTreeDocumentFragment"* %theOwnerDocumentFragment, %"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theFirstChildSlot, %"class.xalanc_1_8::XalanSourceTreeElement"* %theNewSibling) local_unnamed_addr #2 comdat {
entry:
  %0 = bitcast %"class.xalanc_1_8::XalanSourceTreeElement"* %theNewSibling to %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)***
  %vtable = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)**, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)*** %0, align 8, !tbaa !4
  %vfn = getelementptr inbounds %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)** %vtable, i64 5
  %1 = load %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)*, %"class.xalanc_1_8::XalanNode"* (%"class.xalanc_1_8::XalanSourceTreeElement"*)** %vfn, align 8
  %call = tail call %"class.xalanc_1_8::XalanNode"* %1(%"class.xalanc_1_8::XalanSourceTreeElement"* nonnull align 8 dereferenceable(64) %theNewSibling) #3
  %2 = getelementptr %"class.xalanc_1_8::XalanSourceTreeDocumentFragment", %"class.xalanc_1_8::XalanSourceTreeDocumentFragment"* %theOwnerDocumentFragment, i64 0, i32 0, i32 0
  %cmp.not = icmp eq %"class.xalanc_1_8::XalanNode"* %call, %2
  br i1 %cmp.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  tail call void @_ZN10xalanc_1_822XalanSourceTreeElement9setParentEPNS_31XalanSourceTreeDocumentFragmentE(%"class.xalanc_1_8::XalanSourceTreeElement"* nonnull align 8 dereferenceable(64) %theNewSibling, %"class.xalanc_1_8::XalanSourceTreeDocumentFragment"* %theOwnerDocumentFragment) #3
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %3 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %theFirstChildSlot, align 8, !tbaa !7
  %cmp1 = icmp eq %"class.xalanc_1_8::XalanNode"* %3, null
  br i1 %cmp1, label %if.then2, label %if.else

if.then2:                                         ; preds = %if.end
  tail call void @_ZN10xalanc_1_86appendINS_22XalanSourceTreeElementEEEvRPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"** nonnull align 8 dereferenceable(8) %theFirstChildSlot, %"class.xalanc_1_8::XalanSourceTreeElement"* nonnull %theNewSibling) #3
  br label %if.end4

if.else:                                          ; preds = %if.end
  %call3 = tail call %"class.xalanc_1_8::XalanNode"* @_ZN10xalanc_1_816doGetLastSiblingEPNS_9XalanNodeE(%"class.xalanc_1_8::XalanNode"* nonnull %3) #3
  tail call void @_ZN10xalanc_1_815doAppendSiblingINS_22XalanSourceTreeElementEEEvPNS_9XalanNodeEPT_(%"class.xalanc_1_8::XalanNode"* %call3, %"class.xalanc_1_8::XalanSourceTreeElement"* nonnull %theNewSibling) #3
  br label %if.end4

if.end4:                                          ; preds = %if.else, %if.then2
  ret void
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly
declare void @_ZN10xalanc_1_822XalanSourceTreeElement9setParentEPNS_31XalanSourceTreeDocumentFragmentE(%"class.xalanc_1_8::XalanSourceTreeElement"* nocapture nonnull align 8 dereferenceable(64), %"class.xalanc_1_8::XalanSourceTreeDocumentFragment"*) local_unnamed_addr #0 align 2

declare void @_ZN10xalanc_1_817XalanDOMExceptionC1ENS0_13ExceptionCodeE(%"class.xalanc_1_8::XalanDOMException"*, i32)

declare void @_ZN10xalanc_1_817XalanDOMExceptionD1Ev(%"class.xalanc_1_8::XalanDOMException"*)

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind optsize uwtable willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { optsize }
attributes #4 = { nounwind }
attributes #5 = { noreturn }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"vtable pointer", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !6, i64 0}
