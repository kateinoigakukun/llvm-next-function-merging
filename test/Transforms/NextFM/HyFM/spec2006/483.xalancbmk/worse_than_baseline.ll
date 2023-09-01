; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive --pass-remarks-output=%t.mfm-hyfm-exact2.yaml -o %t.mfm-hyfm-exact2.bc %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=2 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive --pass-remarks-output=%t.mfm-hyfm-exact3.yaml -o %t.mfm-hyfm-exact3.bc %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=3 -multiple-func-merging-hyfm-profitability=false -multiple-func-merging-hyfm-nw=true -multiple-func-merging-size-estimation=exact -multiple-func-merging-explore=exhaustive --pass-remarks-output=%t.mfm-hyfm-exact4.yaml -o %t.mfm-hyfm-exact4.bc %s

; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=1 -multiple-func-merging-hyfm-profitability=true -multiple-func-merging-hyfm-nw=true -pass-remarks-output=%t.mfm-hyfm-approx2.yaml -o %t.mfm-hyfm-approx2.bc %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=2 -multiple-func-merging-hyfm-profitability=true -multiple-func-merging-hyfm-nw=true -pass-remarks-output=%t.mfm-hyfm-approx3.yaml -o %t.mfm-hyfm-approx3.bc %s
; RUN: %opt -S -multiple-func-merging-whole-program=true -func-merging-whole-program=true --passes="mergefunc,multiple-func-merging" -multiple-func-merging-coalescing=false -pass-remarks-filter=multiple-func-merging -func-merging-explore=3 -multiple-func-merging-hyfm-profitability=true -multiple-func-merging-hyfm-nw=true -pass-remarks-output=%t.mfm-hyfm-approx4.yaml -o %t.mfm-hyfm-approx4.bc %s


; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %s -o %t.baseline.clangxx.o
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-exact2.bc -o %t.mfm-hyfm-exact2.clangxx.s -S
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-exact2.bc -o %t.mfm-hyfm-exact2.clangxx.o
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-exact3.bc -o %t.mfm-hyfm-exact3.clangxx.o
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-exact4.bc -o %t.mfm-hyfm-exact4.clangxx.o
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-approx2.bc -o %t.mfm-hyfm-approx2.clangxx.o
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-approx3.bc -o %t.mfm-hyfm-approx3.clangxx.o
; RUN: %clang++ -O2 -Xclang -disable-llvm-passes -std=gnu++98 -v -B /usr/bin -DSPEC -DNDEBUG -x ir -c %t.mfm-hyfm-approx4.bc -o %t.mfm-hyfm-approx4.clangxx.o

; RUN: %llc --filetype=obj %s -o %t.baseline.llc.o
; RUN: %llc --filetype=asm %t.mfm-hyfm-exact2.bc -o %t.mfm-hyfm-exact2.llc.s
; RUN: %llc --filetype=obj %t.mfm-hyfm-exact2.bc -o %t.mfm-hyfm-exact2.llc.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-exact3.bc -o %t.mfm-hyfm-exact3.llc.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-exact4.bc -o %t.mfm-hyfm-exact4.llc.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-approx2.bc -o %t.mfm-hyfm-approx2.llc.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-approx3.bc -o %t.mfm-hyfm-approx3.llc.o
; RUN: %llc --filetype=obj %t.mfm-hyfm-approx4.bc -o %t.mfm-hyfm-approx4.llc.o


; ModuleID = '../llvm-nextfm-benchmark/benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.std::vector.55" = type { %"struct.std::_Vector_base.56" }
%"struct.std::_Vector_base.56" = type { %"struct.std::_Vector_base<xalanc_1_8::ElemVariable *, std::allocator<xalanc_1_8::ElemVariable *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ElemVariable *, std::allocator<xalanc_1_8::ElemVariable *> >::_Vector_impl" = type { %"class.xalanc_1_8::ElemVariable"**, %"class.xalanc_1_8::ElemVariable"**, %"class.xalanc_1_8::ElemVariable"** }
%"class.xalanc_1_8::ElemVariable" = type { %"class.xalanc_1_8::ElemTemplateElement.base", %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XPath"*, i8, %"class.xalanc_1_8::XObjectPtr", %"class.xalanc_1_8::XalanNode"* }
%"class.xalanc_1_8::ElemTemplateElement.base" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::Stylesheet"*, %"class.xalanc_1_8::NamespacesHandler", i32, i32, i32, [4 x i8], %"class.xalanc_1_8::ElemTemplateElement"*, %"class.xalanc_1_8::ElemTemplateElement"*, %"class.xalanc_1_8::ElemTemplateElement"*, %union.anon, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::ElemTemplateElement::LocatorProxy", i16 }>
%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%"class.xalanc_1_8::Stylesheet" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::StylesheetRoot"*, %"class.xalanc_1_8::XalanDOMString", %"class.std::vector.0.12", %"class.std::vector.20", %"class.xalanc_1_8::XalanDOMString", %"class.std::vector.25", i64, %"class.std::deque.15", %"class.std::deque.33", i8, %"class.std::map", %"class.xalanc_1_8::ElemTemplate"*, %"class.std::vector.42", %"class.std::map", %"class.std::vector.55", double, %"class.std::map", %"struct.std::_Rb_tree_const_iterator", %"class.std::vector.65", %"class.std::map", %"struct.std::_Rb_tree_const_iterator", %"class.std::vector.65", %"class.std::vector.65", %"class.std::vector.65", %"class.std::vector.65", %"class.std::vector.65", %"class.std::vector.65", %"class.std::deque.70", i64, %"class.std::vector.76", %"class.xalanc_1_8::NamespacesHandler" }
%"class.xalanc_1_8::StylesheetRoot" = type { %"class.xalanc_1_8::Stylesheet", %"class.xalanc_1_8::XalanDOMString", i8, [7 x i8], %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XalanDOMString", i8, [7 x i8], %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XalanDOMString", i32, %"class.std::vector.103", i8, %"class.std::vector.42", %"class.xalanc_1_8::ElemTemplateElement"*, %"class.xalanc_1_8::ElemTemplateElement"*, %"class.xalanc_1_8::ElemTemplateElement"*, i8, i8, i32, i8, i64, %"class.std::map" }
%"class.std::vector.103" = type { %"struct.std::_Vector_base.104" }
%"struct.std::_Vector_base.104" = type { %"struct.std::_Vector_base<const xalanc_1_8::XalanQName *, std::allocator<const xalanc_1_8::XalanQName *> >::_Vector_impl" }
%"struct.std::_Vector_base<const xalanc_1_8::XalanQName *, std::allocator<const xalanc_1_8::XalanQName *> >::_Vector_impl" = type { %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"** }
%"class.std::vector.0.12" = type { %"struct.std::_Vector_base.1.11" }
%"struct.std::_Vector_base.1.11" = type { %"struct.std::_Vector_base<xalanc_1_8::KeyDeclaration, std::allocator<xalanc_1_8::KeyDeclaration> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::KeyDeclaration, std::allocator<xalanc_1_8::KeyDeclaration> >::_Vector_impl" = type { %"class.xalanc_1_8::KeyDeclaration"*, %"class.xalanc_1_8::KeyDeclaration"*, %"class.xalanc_1_8::KeyDeclaration"* }
%"class.xalanc_1_8::KeyDeclaration" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XalanDOMString"*, i64, i64 }
%"class.std::vector.20" = type { %"struct.std::_Vector_base.21" }
%"struct.std::_Vector_base.21" = type { %"struct.std::_Vector_base<xalanc_1_8::XalanSpaceNodeTester, std::allocator<xalanc_1_8::XalanSpaceNodeTester> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::XalanSpaceNodeTester, std::allocator<xalanc_1_8::XalanSpaceNodeTester> >::_Vector_impl" = type { %"class.xalanc_1_8::XalanSpaceNodeTester"*, %"class.xalanc_1_8::XalanSpaceNodeTester"*, %"class.xalanc_1_8::XalanSpaceNodeTester"* }
%"class.xalanc_1_8::XalanSpaceNodeTester" = type { %"class.xalanc_1_8::XPath::NodeTester", i32, i32 }
%"class.xalanc_1_8::XPath::NodeTester" = type { %"class.xalanc_1_8::XPathExecutionContext"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, { i64, i64 }, { i64, i64 } }
%"class.xalanc_1_8::XPathExecutionContext" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XObjectFactory"* }
%"class.xalanc_1_8::XObjectFactory" = type { i32 (...)** }
%"class.xalanc_1_8::XalanDOMString" = type <{ %"class.std::vector", i32, [4 x i8] }>
%"class.std::vector" = type { %"struct.std::_Vector_base" }
%"struct.std::_Vector_base" = type { %"struct.std::_Vector_base<unsigned short, std::allocator<unsigned short> >::_Vector_impl" }
%"struct.std::_Vector_base<unsigned short, std::allocator<unsigned short> >::_Vector_impl" = type { i16*, i16*, i16* }
%"class.std::vector.25" = type { %"struct.std::_Vector_base.26" }
%"struct.std::_Vector_base.26" = type { %"struct.std::_Vector_base<xalanc_1_8::Stylesheet *, std::allocator<xalanc_1_8::Stylesheet *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::Stylesheet *, std::allocator<xalanc_1_8::Stylesheet *> >::_Vector_impl" = type { %"class.xalanc_1_8::Stylesheet"**, %"class.xalanc_1_8::Stylesheet"**, %"class.xalanc_1_8::Stylesheet"** }
%"class.std::deque.15" = type { %"class.std::_Deque_base.14" }
%"class.std::_Deque_base.14" = type { %"struct.std::_Deque_base<std::deque<xalanc_1_8::NameSpace>, std::allocator<std::deque<xalanc_1_8::NameSpace> > >::_Deque_impl" }
%"struct.std::_Deque_base<std::deque<xalanc_1_8::NameSpace>, std::allocator<std::deque<xalanc_1_8::NameSpace> > >::_Deque_impl" = type { %"class.std::deque.33"**, i64, %"struct.std::_Deque_iterator.38", %"struct.std::_Deque_iterator.38" }
%"struct.std::_Deque_iterator.38" = type { %"class.std::deque.33"*, %"class.std::deque.33"*, %"class.std::deque.33"*, %"class.std::deque.33"** }
%"class.std::deque.33" = type { %"class.std::_Deque_base.34" }
%"class.std::_Deque_base.34" = type { %"struct.std::_Deque_base<xalanc_1_8::NameSpace, std::allocator<xalanc_1_8::NameSpace> >::_Deque_impl" }
%"struct.std::_Deque_base<xalanc_1_8::NameSpace, std::allocator<xalanc_1_8::NameSpace> >::_Deque_impl" = type { %"class.xalanc_1_8::NameSpace"**, i64, %"struct.std::_Deque_iterator.13", %"struct.std::_Deque_iterator.13" }
%"class.xalanc_1_8::NameSpace" = type { %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XalanDOMString" }
%"struct.std::_Deque_iterator.13" = type { %"class.xalanc_1_8::NameSpace"*, %"class.xalanc_1_8::NameSpace"*, %"class.xalanc_1_8::NameSpace"*, %"class.xalanc_1_8::NameSpace"** }
%"class.xalanc_1_8::ElemTemplate" = type { %"class.xalanc_1_8::ElemTemplateElement.base", %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, double }
%"class.std::vector.42" = type { %"struct.std::_Vector_base.43" }
%"struct.std::_Vector_base.43" = type { %"struct.std::_Vector_base<xalanc_1_8::XalanDOMString, std::allocator<xalanc_1_8::XalanDOMString> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::XalanDOMString, std::allocator<xalanc_1_8::XalanDOMString> >::_Vector_impl" = type { %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"* }
%"class.std::map" = type { %"class.std::_Rb_tree" }
%"class.std::_Rb_tree" = type { %"struct.std::_Rb_tree<const unsigned short *, std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *>, std::_Select1st<std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *> >, xalanc_1_8::less_null_terminated_arrays<unsigned short> >::_Rb_tree_impl" }
%"struct.std::_Rb_tree<const unsigned short *, std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *>, std::_Select1st<std::pair<const unsigned short *const, xalanc_1_8::XalanSourceTreeElement *> >, xalanc_1_8::less_null_terminated_arrays<unsigned short> >::_Rb_tree_impl" = type { %"struct.std::_Rb_tree_key_compare", %"struct.std::_Rb_tree_header" }
%"struct.std::_Rb_tree_key_compare" = type { %"class.xalanc_1_8::ArenaBlockDestroy" }
%"class.xalanc_1_8::ArenaBlockDestroy" = type { i8 }
%"struct.std::_Rb_tree_header" = type { %"struct.std::_Rb_tree_node_base", i64 }
%"struct.std::_Rb_tree_node_base" = type { i32, %"struct.std::_Rb_tree_node_base"*, %"struct.std::_Rb_tree_node_base"*, %"struct.std::_Rb_tree_node_base"* }
%"struct.std::_Rb_tree_const_iterator" = type { %"struct.std::_Rb_tree_node_base"* }
%"class.std::vector.65" = type { %"struct.std::_Vector_base.66" }
%"struct.std::_Vector_base.66" = type { %"struct.std::_Vector_base<const xalanc_1_8::Stylesheet::MatchPattern2 *, std::allocator<const xalanc_1_8::Stylesheet::MatchPattern2 *> >::_Vector_impl" }
%"struct.std::_Vector_base<const xalanc_1_8::Stylesheet::MatchPattern2 *, std::allocator<const xalanc_1_8::Stylesheet::MatchPattern2 *> >::_Vector_impl" = type { %"class.xalanc_1_8::Stylesheet::MatchPattern2"**, %"class.xalanc_1_8::Stylesheet::MatchPattern2"**, %"class.xalanc_1_8::Stylesheet::MatchPattern2"** }
%"class.xalanc_1_8::Stylesheet::MatchPattern2" = type <{ %"class.xalanc_1_8::ElemTemplate"*, i64, %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XalanDOMString"*, i32, [4 x i8] }>
%"class.std::deque.70" = type { %"class.std::_Deque_base.71" }
%"class.std::_Deque_base.71" = type { %"struct.std::_Deque_base<xalanc_1_8::Stylesheet::MatchPattern2, std::allocator<xalanc_1_8::Stylesheet::MatchPattern2> >::_Deque_impl" }
%"struct.std::_Deque_base<xalanc_1_8::Stylesheet::MatchPattern2, std::allocator<xalanc_1_8::Stylesheet::MatchPattern2> >::_Deque_impl" = type { %"class.xalanc_1_8::Stylesheet::MatchPattern2"**, i64, %"struct.std::_Deque_iterator.75", %"struct.std::_Deque_iterator.75" }
%"struct.std::_Deque_iterator.75" = type { %"class.xalanc_1_8::Stylesheet::MatchPattern2"*, %"class.xalanc_1_8::Stylesheet::MatchPattern2"*, %"class.xalanc_1_8::Stylesheet::MatchPattern2"*, %"class.xalanc_1_8::Stylesheet::MatchPattern2"** }
%"class.std::vector.76" = type { %"struct.std::_Vector_base.77" }
%"struct.std::_Vector_base.77" = type { %"struct.std::_Vector_base<xalanc_1_8::ElemDecimalFormat *, std::allocator<xalanc_1_8::ElemDecimalFormat *> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::ElemDecimalFormat *, std::allocator<xalanc_1_8::ElemDecimalFormat *> >::_Vector_impl" = type { %"class.xalanc_1_8::ElemDecimalFormat"**, %"class.xalanc_1_8::ElemDecimalFormat"**, %"class.xalanc_1_8::ElemDecimalFormat"** }
%"class.xalanc_1_8::ElemDecimalFormat" = type { %"class.xalanc_1_8::ElemTemplateElement.base", %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XPath"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanDecimalFormatSymbols" }
%"class.xalanc_1_8::XalanDecimalFormatSymbols" = type { %"class.xalanc_1_8::XalanDOMString", i16, i16, i16, [2 x i8], %"class.xalanc_1_8::XalanDOMString", %"class.xalanc_1_8::XalanDOMString", i16, i16, [4 x i8], %"class.xalanc_1_8::XalanDOMString", i16, i16, i16, i16 }
%"class.xalanc_1_8::NamespacesHandler" = type { %"class.std::vector.81.7", %"class.std::vector.86", %"class.std::vector.128", %"class.std::map" }
%"class.std::vector.81.7" = type { %"struct.std::_Vector_base.82.6" }
%"struct.std::_Vector_base.82.6" = type { %"struct.std::_Vector_base<xalanc_1_8::NamespacesHandler::Namespace, std::allocator<xalanc_1_8::NamespacesHandler::Namespace> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::NamespacesHandler::Namespace, std::allocator<xalanc_1_8::NamespacesHandler::Namespace> >::_Vector_impl" = type { %"class.xalanc_1_8::NamespacesHandler::Namespace"*, %"class.xalanc_1_8::NamespacesHandler::Namespace"*, %"class.xalanc_1_8::NamespacesHandler::Namespace"* }
%"class.xalanc_1_8::NamespacesHandler::Namespace" = type { %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::XalanDOMString"* }
%"class.std::vector.86" = type { %"struct.std::_Vector_base.87" }
%"struct.std::_Vector_base.87" = type { %"struct.std::_Vector_base<xalanc_1_8::NamespacesHandler::NamespaceExtended, std::allocator<xalanc_1_8::NamespacesHandler::NamespaceExtended> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::NamespacesHandler::NamespaceExtended, std::allocator<xalanc_1_8::NamespacesHandler::NamespaceExtended> >::_Vector_impl" = type { %"class.xalanc_1_8::NamespacesHandler::NamespaceExtended"*, %"class.xalanc_1_8::NamespacesHandler::NamespaceExtended"*, %"class.xalanc_1_8::NamespacesHandler::NamespaceExtended"* }
%"class.xalanc_1_8::NamespacesHandler::NamespaceExtended" = type { %"class.xalanc_1_8::NamespacesHandler::Namespace", %"class.xalanc_1_8::XalanDOMString"* }
%"class.std::vector.128" = type { %"struct.std::_Vector_base.129" }
%"struct.std::_Vector_base.129" = type { %"struct.std::_Vector_base<const xalanc_1_8::XalanDOMString *, std::allocator<const xalanc_1_8::XalanDOMString *> >::_Vector_impl" }
%"struct.std::_Vector_base<const xalanc_1_8::XalanDOMString *, std::allocator<const xalanc_1_8::XalanDOMString *> >::_Vector_impl" = type { %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"** }
%"class.xalanc_1_8::ElemTemplateElement" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::Stylesheet"*, %"class.xalanc_1_8::NamespacesHandler", i32, i32, i32, [4 x i8], %"class.xalanc_1_8::ElemTemplateElement"*, %"class.xalanc_1_8::ElemTemplateElement"*, %"class.xalanc_1_8::ElemTemplateElement"*, %union.anon, %"class.xalanc_1_8::XalanDOMString"*, %"class.xalanc_1_8::ElemTemplateElement::LocatorProxy", i16, [6 x i8] }>
%union.anon = type { %"class.xalanc_1_8::ElemTemplateElement"* }
%"class.xalanc_1_8::ElemTemplateElement::LocatorProxy" = type { %"class.xalanc_1_8::XalanDocumentFragment", %"class.xalanc_1_8::ElemTemplateElement"* }
%"class.xalanc_1_8::XalanDocumentFragment" = type { %"class.xalanc_1_8::XalanNode" }
%"class.xalanc_1_8::XPath" = type <{ %"class.xalanc_1_8::XPathExpression", %"class.xalanc_1_8::XalanNode"*, i8, [7 x i8] }>
%"class.xalanc_1_8::XPathExpression" = type { %"class.std::vector.5", i32, %"class.std::vector.10", i32, %"class.xalanc_1_8::XalanDOMString"*, %"class.std::vector.15" }
%"class.std::vector.5" = type { %"struct.std::_Vector_base.6" }
%"struct.std::_Vector_base.6" = type { %"struct.std::_Vector_base<int, std::allocator<int> >::_Vector_impl" }
%"struct.std::_Vector_base<int, std::allocator<int> >::_Vector_impl" = type { i32*, i32*, i32* }
%"class.std::vector.10" = type { %"struct.std::_Vector_base.11" }
%"struct.std::_Vector_base.11" = type { %"struct.std::_Vector_base<xalanc_1_8::XToken, std::allocator<xalanc_1_8::XToken> >::_Vector_impl" }
%"struct.std::_Vector_base<xalanc_1_8::XToken, std::allocator<xalanc_1_8::XToken> >::_Vector_impl" = type { %"class.xalanc_1_8::XToken"*, %"class.xalanc_1_8::XToken"*, %"class.xalanc_1_8::XToken"* }
%"class.xalanc_1_8::XToken" = type <{ %"class.xalanc_1_8::XObject", %"class.xalanc_1_8::XalanDOMString"*, double, i8, [7 x i8] }>
%"class.xalanc_1_8::XObject" = type { %"class.xalanc_1_8::XalanReferenceCountedObject.base", i32, %"class.xalanc_1_8::XObjectFactory"* }
%"class.xalanc_1_8::XalanReferenceCountedObject.base" = type <{ i32 (...)**, i32 }>
%"class.std::vector.15" = type { %"struct.std::_Vector_base.16" }
%"struct.std::_Vector_base.16" = type { %"struct.std::_Vector_base<double, std::allocator<double> >::_Vector_impl" }
%"struct.std::_Vector_base<double, std::allocator<double> >::_Vector_impl" = type { double*, double*, double* }
%"class.xalanc_1_8::XObjectPtr" = type { %"class.xalanc_1_8::XObject"* }

$_ZNSt6vectorIPKN10xalanc_1_812ElemVariableESaIS3_EED2Ev = comdat any

$_ZNSt6vectorIPKN10xalanc_1_814XalanDOMStringESaIS3_EED2Ev = comdat any

$_ZNSt6vectorIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EED2Ev = comdat any

$_ZNSt6vectorIPKN10xalanc_1_810XalanQNameESaIS3_EED2Ev = comdat any

$_ZNSt6vectorIPKN10xalanc_1_817XalanParsedSourceESaIS3_EED2Ev = comdat any

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
declare hidden void @__clang_call_terminate(i8*) local_unnamed_addr #0

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZNSt6vectorIPKN10xalanc_1_812ElemVariableESaIS3_EED2Ev(%"class.std::vector.55"* nonnull align 8 dereferenceable(24) %this) unnamed_addr #1 comdat align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = getelementptr inbounds %"class.std::vector.55", %"class.std::vector.55"* %this, i64 0, i32 0
  %_M_start = getelementptr inbounds %"class.std::vector.55", %"class.std::vector.55"* %this, i64 0, i32 0, i32 0, i32 0
  %1 = load %"class.xalanc_1_8::ElemVariable"**, %"class.xalanc_1_8::ElemVariable"*** %_M_start, align 8, !tbaa !4
  %_M_finish = getelementptr inbounds %"class.std::vector.55", %"class.std::vector.55"* %this, i64 0, i32 0, i32 0, i32 1
  %2 = load %"class.xalanc_1_8::ElemVariable"**, %"class.xalanc_1_8::ElemVariable"*** %_M_finish, align 8, !tbaa !10
  %call = tail call nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.56"* nonnull align 8 dereferenceable(24) %0) #3
  invoke void @_ZSt8_DestroyIPPKN10xalanc_1_812ElemVariableES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::ElemVariable"** %1, %"class.xalanc_1_8::ElemVariable"** %2, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %call) #3
          to label %invoke.cont3 unwind label %lpad

invoke.cont3:                                     ; preds = %entry
  tail call void @_ZNSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EED2Ev(%"struct.std::_Vector_base.56"* nonnull align 8 dereferenceable(24) %0) #3
  ret void

lpad:                                             ; preds = %entry
  %3 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZNSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EED2Ev(%"struct.std::_Vector_base.56"* nonnull align 8 dereferenceable(24) %0) #3
          to label %eh.resume unwind label %terminate.lpad

eh.resume:                                        ; preds = %lpad
  resume { i8*, i32 } %3

terminate.lpad:                                   ; preds = %lpad
  %4 = landingpad { i8*, i32 }
          catch i8* null
  %5 = extractvalue { i8*, i32 } %4, 0
  tail call void @__clang_call_terminate(i8* %5) #4
  unreachable
}

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.56"* nonnull align 8 dereferenceable(24)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZSt8_DestroyIPPKN10xalanc_1_812ElemVariableES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::ElemVariable"**, %"class.xalanc_1_8::ElemVariable"**, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1)) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare void @_ZNSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EED2Ev(%"struct.std::_Vector_base.56"* nonnull align 8 dereferenceable(24)) unnamed_addr #1 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.129"* nonnull align 8 dereferenceable(24)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZSt8_DestroyIPPKN10xalanc_1_814XalanDOMStringES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1)) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZNSt6vectorIPKN10xalanc_1_814XalanDOMStringESaIS3_EED2Ev(%"class.std::vector.128"* nonnull align 8 dereferenceable(24) %this) unnamed_addr #1 comdat align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = getelementptr inbounds %"class.std::vector.128", %"class.std::vector.128"* %this, i64 0, i32 0
  %_M_start = getelementptr inbounds %"class.std::vector.128", %"class.std::vector.128"* %this, i64 0, i32 0, i32 0, i32 0
  %1 = load %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"*** %_M_start, align 8, !tbaa !11
  %_M_finish = getelementptr inbounds %"class.std::vector.128", %"class.std::vector.128"* %this, i64 0, i32 0, i32 0, i32 1
  %2 = load %"class.xalanc_1_8::XalanDOMString"**, %"class.xalanc_1_8::XalanDOMString"*** %_M_finish, align 8, !tbaa !14
  %call = tail call nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.129"* nonnull align 8 dereferenceable(24) %0) #3
  invoke void @_ZSt8_DestroyIPPKN10xalanc_1_814XalanDOMStringES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::XalanDOMString"** %1, %"class.xalanc_1_8::XalanDOMString"** %2, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %call) #3
          to label %invoke.cont3 unwind label %lpad

invoke.cont3:                                     ; preds = %entry
  tail call void @_ZNSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EED2Ev(%"struct.std::_Vector_base.129"* nonnull align 8 dereferenceable(24) %0) #3
  ret void

lpad:                                             ; preds = %entry
  %3 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZNSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EED2Ev(%"struct.std::_Vector_base.129"* nonnull align 8 dereferenceable(24) %0) #3
          to label %eh.resume unwind label %terminate.lpad

eh.resume:                                        ; preds = %lpad
  resume { i8*, i32 } %3

terminate.lpad:                                   ; preds = %lpad
  %4 = landingpad { i8*, i32 }
          catch i8* null
  %5 = extractvalue { i8*, i32 } %4, 0
  tail call void @__clang_call_terminate(i8* %5) #4
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare void @_ZNSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EED2Ev(%"struct.std::_Vector_base.129"* nonnull align 8 dereferenceable(24)) unnamed_addr #1 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.66"* nonnull align 8 dereferenceable(24)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZSt8_DestroyIPPKN10xalanc_1_810Stylesheet13MatchPattern2ES4_EvT_S6_RSaIT0_E(%"class.xalanc_1_8::Stylesheet::MatchPattern2"**, %"class.xalanc_1_8::Stylesheet::MatchPattern2"**, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1)) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZNSt6vectorIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EED2Ev(%"class.std::vector.65"* nonnull align 8 dereferenceable(24) %this) unnamed_addr #1 comdat align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = getelementptr inbounds %"class.std::vector.65", %"class.std::vector.65"* %this, i64 0, i32 0
  %_M_start = getelementptr inbounds %"class.std::vector.65", %"class.std::vector.65"* %this, i64 0, i32 0, i32 0, i32 0
  %1 = load %"class.xalanc_1_8::Stylesheet::MatchPattern2"**, %"class.xalanc_1_8::Stylesheet::MatchPattern2"*** %_M_start, align 8, !tbaa !15
  %_M_finish = getelementptr inbounds %"class.std::vector.65", %"class.std::vector.65"* %this, i64 0, i32 0, i32 0, i32 1
  %2 = load %"class.xalanc_1_8::Stylesheet::MatchPattern2"**, %"class.xalanc_1_8::Stylesheet::MatchPattern2"*** %_M_finish, align 8, !tbaa !18
  %call = tail call nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.66"* nonnull align 8 dereferenceable(24) %0) #3
  invoke void @_ZSt8_DestroyIPPKN10xalanc_1_810Stylesheet13MatchPattern2ES4_EvT_S6_RSaIT0_E(%"class.xalanc_1_8::Stylesheet::MatchPattern2"** %1, %"class.xalanc_1_8::Stylesheet::MatchPattern2"** %2, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %call) #3
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %entry
  tail call void @_ZNSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EED2Ev(%"struct.std::_Vector_base.66"* nonnull align 8 dereferenceable(24) %0) #3
  ret void

lpad:                                             ; preds = %entry
  %3 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZNSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EED2Ev(%"struct.std::_Vector_base.66"* nonnull align 8 dereferenceable(24) %0) #3
          to label %eh.resume unwind label %terminate.lpad

eh.resume:                                        ; preds = %lpad
  resume { i8*, i32 } %3

terminate.lpad:                                   ; preds = %lpad
  %4 = landingpad { i8*, i32 }
          catch i8* null
  %5 = extractvalue { i8*, i32 } %4, 0
  tail call void @__clang_call_terminate(i8* %5) #4
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare void @_ZNSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EED2Ev(%"struct.std::_Vector_base.66"* nonnull align 8 dereferenceable(24)) unnamed_addr #1 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZSt8_DestroyIPPKN10xalanc_1_810XalanQNameES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1)) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZNSt6vectorIPKN10xalanc_1_810XalanQNameESaIS3_EED2Ev(%"class.std::vector.103"* nonnull align 8 dereferenceable(24) %this) unnamed_addr #1 comdat align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = getelementptr inbounds %"class.std::vector.103", %"class.std::vector.103"* %this, i64 0, i32 0
  %_M_start = getelementptr inbounds %"class.std::vector.103", %"class.std::vector.103"* %this, i64 0, i32 0, i32 0, i32 0
  %1 = load %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"*** %_M_start, align 8, !tbaa !19
  %_M_finish = getelementptr inbounds %"class.std::vector.103", %"class.std::vector.103"* %this, i64 0, i32 0, i32 0, i32 1
  %2 = load %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"*** %_M_finish, align 8, !tbaa !22
  %call = tail call nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24) %0) #3
  invoke void @_ZSt8_DestroyIPPKN10xalanc_1_810XalanQNameES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::XalanNode"** %1, %"class.xalanc_1_8::XalanNode"** %2, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %call) #3
          to label %invoke.cont3 unwind label %lpad

invoke.cont3:                                     ; preds = %entry
  tail call void @_ZNSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EED2Ev(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24) %0) #3
  ret void

lpad:                                             ; preds = %entry
  %3 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZNSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EED2Ev(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24) %0) #3
          to label %eh.resume unwind label %terminate.lpad

eh.resume:                                        ; preds = %lpad
  resume { i8*, i32 } %3

terminate.lpad:                                   ; preds = %lpad
  %4 = landingpad { i8*, i32 }
          catch i8* null
  %5 = extractvalue { i8*, i32 } %4, 0
  tail call void @__clang_call_terminate(i8* %5) #4
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare void @_ZNSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EED2Ev(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24)) unnamed_addr #1 align 2

; Function Attrs: noinline optsize uwtable
define weak_odr void @_ZNSt6vectorIPKN10xalanc_1_817XalanParsedSourceESaIS3_EED2Ev(%"class.std::vector.103"* nonnull align 8 dereferenceable(24) %this) unnamed_addr #1 comdat align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %0 = getelementptr inbounds %"class.std::vector.103", %"class.std::vector.103"* %this, i64 0, i32 0
  %_M_start = getelementptr inbounds %"class.std::vector.103", %"class.std::vector.103"* %this, i64 0, i32 0, i32 0, i32 0
  %1 = load %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"*** %_M_start, align 8, !tbaa !23
  %_M_finish = getelementptr inbounds %"class.std::vector.103", %"class.std::vector.103"* %this, i64 0, i32 0, i32 0, i32 1
  %2 = load %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"*** %_M_finish, align 8, !tbaa !26
  %call = tail call nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24) %0) #3
  invoke void @_ZSt8_DestroyIPPKN10xalanc_1_817XalanParsedSourceES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::XalanNode"** %1, %"class.xalanc_1_8::XalanNode"** %2, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1) %call) #3
          to label %invoke.cont3 unwind label %lpad

invoke.cont3:                                     ; preds = %entry
  tail call void @_ZNSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EED2Ev(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24) %0) #3
  ret void

lpad:                                             ; preds = %entry
  %3 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZNSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EED2Ev(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24) %0) #3
          to label %eh.resume unwind label %terminate.lpad

eh.resume:                                        ; preds = %lpad
  resume { i8*, i32 } %3

terminate.lpad:                                   ; preds = %lpad
  %4 = landingpad { i8*, i32 }
          catch i8* null
  %5 = extractvalue { i8*, i32 } %4, 0
  tail call void @__clang_call_terminate(i8* %5) #4
  unreachable
}

; Function Attrs: noinline nounwind optsize uwtable
declare nonnull align 1 dereferenceable(1) %"class.xalanc_1_8::ArenaBlockDestroy"* @_ZNSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EE19_M_get_Tp_allocatorEv(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZSt8_DestroyIPPKN10xalanc_1_817XalanParsedSourceES3_EvT_S5_RSaIT0_E(%"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::ArenaBlockDestroy"* nonnull align 1 dereferenceable(1)) local_unnamed_addr #1

; Function Attrs: noinline optsize uwtable
declare void @_ZNSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EED2Ev(%"struct.std::_Vector_base.104"* nonnull align 8 dereferenceable(24)) unnamed_addr #1 align 2

attributes #0 = { noinline noreturn nounwind }
attributes #1 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { optsize }
attributes #4 = { noreturn nounwind }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !7, i64 0}
!5 = !{!"_ZTSSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EE", !6, i64 0}
!6 = !{!"_ZTSNSt12_Vector_baseIPKN10xalanc_1_812ElemVariableESaIS3_EE12_Vector_implE", !7, i64 0, !7, i64 8, !7, i64 16}
!7 = !{!"any pointer", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C++ TBAA"}
!10 = !{!5, !7, i64 8}
!11 = !{!12, !7, i64 0}
!12 = !{!"_ZTSSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EE", !13, i64 0}
!13 = !{!"_ZTSNSt12_Vector_baseIPKN10xalanc_1_814XalanDOMStringESaIS3_EE12_Vector_implE", !7, i64 0, !7, i64 8, !7, i64 16}
!14 = !{!12, !7, i64 8}
!15 = !{!16, !7, i64 0}
!16 = !{!"_ZTSSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EE", !17, i64 0}
!17 = !{!"_ZTSNSt12_Vector_baseIPKN10xalanc_1_810Stylesheet13MatchPattern2ESaIS4_EE12_Vector_implE", !7, i64 0, !7, i64 8, !7, i64 16}
!18 = !{!16, !7, i64 8}
!19 = !{!20, !7, i64 0}
!20 = !{!"_ZTSSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EE", !21, i64 0}
!21 = !{!"_ZTSNSt12_Vector_baseIPKN10xalanc_1_810XalanQNameESaIS3_EE12_Vector_implE", !7, i64 0, !7, i64 8, !7, i64 16}
!22 = !{!20, !7, i64 8}
!23 = !{!24, !7, i64 0}
!24 = !{!"_ZTSSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EE", !25, i64 0}
!25 = !{!"_ZTSNSt12_Vector_baseIPKN10xalanc_1_817XalanParsedSourceESaIS3_EE12_Vector_implE", !7, i64 0, !7, i64 8, !7, i64 16}
!26 = !{!24, !7, i64 8}
