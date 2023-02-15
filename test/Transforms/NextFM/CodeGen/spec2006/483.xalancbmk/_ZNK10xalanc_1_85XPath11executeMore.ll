; RUN: %opt -S --passes="multiple-func-merging" -func-merging-explore 2 -pass-remarks-output=- -pass-remarks-filter=multiple-func-merging %s -o %t.mfm.ll
; RUN: %opt -S --passes="mergefunc,func-merging" -func-merging-operand-reorder=false -func-merging-coalescing=false -func-merging-whole-program=true -func-merging-matcher-report=false -func-merging-debug=false -func-merging-verbose=false -hyfm-profitability=true -func-merging-f3m=true -adaptive-threshold=false -adaptive-bands=false -hyfm-f3m-rows=2 -hyfm-f3m-bands=100 -shingling-cross-basic-blocks=true -ranking-distance=1.0 -bucket-size-cap=100 -func-merging-report=false -func-merging-hyfm-nw=true -func-merging-explore 2 -pass-remarks-output=- -pass-remarks-filter=func-merging %s -o %t.fm.ll


; ModuleID = './.x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/spec2006/483.xalancbmk/_main_._all_._files_._linked_.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.xercesc_2_5::XMLElementDecl" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::QName"*, i32, i32, i8, [7 x i8] }>
%"class.xalanc_1_8::XalanNode" = type { i32 (...)** }
%"class.xercesc_2_5::QName" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i16*, i32, i16*, i32, i16*, i32, i32 }
%"class.xercesc_2_5::TraverseSchema.9681" = type { i8, i32, i32, i32, i32, i32, i32, i16*, %"class.xercesc_2_5::DatatypeValidatorFactory.9585"*, %"class.xercesc_2_5::GrammarResolver.9601"*, %"class.xercesc_2_5::SchemaGrammar.9640"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLScanner.9660"*, %"class.xercesc_2_5::NamespaceScope"*, %"class.xercesc_2_5::RefHashTableOf.25"*, %"class.xercesc_2_5::RefHashTableOf.23"*, %"class.xercesc_2_5::RefHashTableOf.25.9631"*, %"class.xercesc_2_5::RefHashTableOf.41"*, %"class.xercesc_2_5::RefHashTableOf.36"*, %"class.xercesc_2_5::RefHashTableOf.38"*, %"class.xercesc_2_5::SchemaInfo"*, %"class.xercesc_2_5::XercesGroupInfo.9629"*, %"class.xercesc_2_5::XercesAttGroupInfo"*, %"class.xercesc_2_5::ComplexTypeInfo.6137"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf.48"*, %"class.xercesc_2_5::ValueVectorOf.4990"*, %"class.xercesc_2_5::ValueVectorOf.11"**, %"class.xercesc_2_5::ValueVectorOf.3"*, %"class.xercesc_2_5::RefHashTableOf.49.9666"*, %"class.xercesc_2_5::RefHashTableOf.51"*, %"class.xercesc_2_5::RefHash2KeysTableOf.53"*, %"class.xercesc_2_5::RefHash2KeysTableOf.53"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.29"*, %"class.xercesc_2_5::RefHash2KeysTableOf.57"*, %"class.xercesc_2_5::XSDDOMParser.9676"*, %"class.xercesc_2_5::XSDErrorReporter", %"class.xercesc_2_5::XSDLocator"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XSAnnotation"*, %"class.xercesc_2_5::GeneralAttributeCheck.9680" }
%"class.xercesc_2_5::DatatypeValidatorFactory.9585" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::RefHashTableOf.0.9578"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.0.9578" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.9577"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.9577" = type { %"class.xercesc_2_5::DatatypeValidator.1024"*, %"struct.xercesc_2_5::RefHashTableBucketElem.9577"*, i8* }
%"class.xercesc_2_5::DatatypeValidator.1024" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::RefHashTableOf.1"*, i16*, %"class.xercesc_2_5::RegularExpression"*, i16*, i16*, i16*, i32, i8, i8, i8, i8 }>
%"class.xercesc_2_5::RefHashTableOf.1" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.1013"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.1013" = type { %"class.xercesc_2_5::KVStringPair"*, %"struct.xercesc_2_5::RefHashTableBucketElem.1013"*, i8* }
%"class.xercesc_2_5::KVStringPair" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i16*, i64, i16*, i64 }
%"class.xercesc_2_5::RegularExpression" = type { i8, i8, i32, i32, i32, i32, %"class.xercesc_2_5::BMPattern"*, i16*, i16*, %"class.xercesc_2_5::Op"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::RangeToken"*, %"class.xercesc_2_5::OpFactory", %"class.xercesc_2_5::XMLMutex", %"class.xercesc_2_5::TokenFactory"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::BMPattern" = type { i8, i32, i32*, i16*, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::Op" = type { i32 (...)**, %"class.xalanc_1_8::XalanNode"*, i16, %"class.xercesc_2_5::Op"* }
%"class.xercesc_2_5::Token" = type { i32 (...)**, i16, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RangeToken" = type { %"class.xercesc_2_5::Token", i8, i8, i32, i32, i32, i32*, i32*, %"class.xercesc_2_5::RangeToken"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::OpFactory" = type { %"class.xercesc_2_5::RefVectorOf"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf" = type { %"class.xercesc_2_5::BaseRefVectorOf.9" }
%"class.xercesc_2_5::BaseRefVectorOf.9" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::Op"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLMutex" = type { i8* }
%"class.xercesc_2_5::TokenFactory" = type { %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::GrammarResolver.9601" = type { i8, i8, i8, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefHashTableOf.1"*, %"class.xercesc_2_5::RefHashTableOf.1"*, %"class.xercesc_2_5::DatatypeValidatorFactory.9585"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::XSModel"*, %"class.xercesc_2_5::XSModel"*, %"class.xercesc_2_5::ValueVectorOf"* }
%"class.xercesc_2_5::XMLGrammarPool" = type { i32 (...)**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSModel" = type <{ %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::RefArrayVectorOf"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefVectorOf"*, [14 x %"class.xercesc_2_5::XSNamedMap"*], %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::XSObjectFactory"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::XSModel"*, i8, i8, [6 x i8] }>
%"class.xercesc_2_5::RefArrayVectorOf" = type { %"class.xercesc_2_5::BaseRefVectorOf" }
%"class.xercesc_2_5::BaseRefVectorOf" = type { i32 (...)**, i8, i32, i32, i16**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSNamedMap" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefVectorOf.20"*, %"class.xercesc_2_5::RefHash2KeysTableOf.21"* }
%"class.xercesc_2_5::RefVectorOf.20" = type { %"class.xercesc_2_5::BaseRefVectorOf.24.2252" }
%"class.xercesc_2_5::BaseRefVectorOf.24.2252" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSIDCDefinition"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSIDCDefinition" = type { %"class.xercesc_2_5::XSObject", %"class.xercesc_2_5::IdentityConstraint"*, %"class.xercesc_2_5::XSIDCDefinition"*, %"class.xercesc_2_5::RefArrayVectorOf"*, %"class.xercesc_2_5::RefVectorOf"* }
%"class.xercesc_2_5::XSObject" = type { i32 (...)**, i32, %"class.xercesc_2_5::XSModel"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IdentityConstraint" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector"*, %"class.xercesc_2_5::RefVectorOf.17"*, %"class.xalanc_1_8::XalanNode"*, i32, [4 x i8] }>
%"class.xercesc_2_5::IC_Selector" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath.2425"*, %"class.xercesc_2_5::IdentityConstraint.2430"* }
%"class.xercesc_2_5::XercesXPath.2425" = type { %"class.xalanc_1_8::XalanNode", i32, i16*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IdentityConstraint.2430" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector"*, %"class.xercesc_2_5::RefVectorOf.6.2429"*, %"class.xalanc_1_8::XalanNode"*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefVectorOf.6.2429" = type { %"class.xercesc_2_5::BaseRefVectorOf.7.2428" }
%"class.xercesc_2_5::BaseRefVectorOf.7.2428" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IC_Field.2427"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IC_Field.2427" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath.2425"*, %"class.xercesc_2_5::IdentityConstraint.2430"* }
%"class.xercesc_2_5::RefVectorOf.17" = type { %"class.xercesc_2_5::BaseRefVectorOf.18" }
%"class.xercesc_2_5::BaseRefVectorOf.18" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IC_Field"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IC_Field" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath"*, %"class.xercesc_2_5::IdentityConstraint"* }
%"class.xercesc_2_5::XercesXPath" = type { %"class.xalanc_1_8::XalanNode", i32, i16*, %"class.xercesc_2_5::RefVectorOf.12.1036"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.12.1036" = type { %"class.xercesc_2_5::BaseRefVectorOf.13.1035" }
%"class.xercesc_2_5::BaseRefVectorOf.13.1035" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XercesLocationPath"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XercesLocationPath" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::RefVectorOf.14"* }
%"class.xercesc_2_5::RefVectorOf.14" = type { %"class.xercesc_2_5::BaseRefVectorOf.15" }
%"class.xercesc_2_5::BaseRefVectorOf.15" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XercesStep"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XercesStep" = type { %"class.xalanc_1_8::XalanNode", i16, %"class.xercesc_2_5::XercesNodeTest"* }
%"class.xercesc_2_5::XercesNodeTest" = type { %"class.xalanc_1_8::XalanNode", i16, %"class.xercesc_2_5::QName"* }
%"class.xercesc_2_5::RefHash2KeysTableOf.21" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.25"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.25" = type <{ %"class.xercesc_2_5::XSIDCDefinition"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.25"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefHashTableOf" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.2"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.2" = type { %"class.xercesc_2_5::DatatypeValidator"*, %"struct.xercesc_2_5::RefHashTableBucketElem.2"*, i8* }
%"class.xercesc_2_5::DatatypeValidator" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::RefHashTableOf"*, i16*, %"class.xercesc_2_5::RegularExpression"*, i16*, i16*, i16*, i32, i8, i8, i8, i8 }>
%"class.xercesc_2_5::XSObjectFactory" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::RefHashTableOf.24.3541"*, %"class.xercesc_2_5::RefVectorOf.20.3537"* }
%"class.xercesc_2_5::RefHashTableOf.24.3541" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.25.3540"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.25.3540" = type { %"class.xercesc_2_5::XSObject.3532"*, %"struct.xercesc_2_5::RefHashTableBucketElem.25.3540"*, i8* }
%"class.xercesc_2_5::XSObject.3532" = type { i32 (...)**, i32, %"class.xercesc_2_5::XSModel.3553"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSModel.3553" = type <{ %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::RefArrayVectorOf"*, %"class.xercesc_2_5::RefVectorOf.3543"*, %"class.xercesc_2_5::RefVectorOf.26"*, %"class.xercesc_2_5::RefVectorOf.33"*, [14 x %"class.xercesc_2_5::XSNamedMap.3539"*], %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefVectorOf.22"*, %"class.xercesc_2_5::RefHashTableOf.35"*, %"class.xercesc_2_5::XSObjectFactory"*, %"class.xercesc_2_5::RefVectorOf.3543"*, %"class.xercesc_2_5::XSModel.3553"*, i8, i8, [6 x i8] }>
%"class.xercesc_2_5::RefVectorOf.26" = type { %"class.xercesc_2_5::BaseRefVectorOf.27" }
%"class.xercesc_2_5::BaseRefVectorOf.27" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSElementDeclaration.3550"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSElementDeclaration.3550" = type { %"class.xercesc_2_5::XSObject.3532", i16, i16, i32, i32, %"class.xercesc_2_5::SchemaElementDecl"*, %"class.xercesc_2_5::XSTypeDefinition.3544"*, %"class.xercesc_2_5::XSComplexTypeDefinition.3549"*, %"class.xercesc_2_5::XSElementDeclaration.3550"*, %"class.xercesc_2_5::XSAnnotation.3533"*, %"class.xercesc_2_5::XSNamedMap"* }
%"class.xercesc_2_5::SchemaElementDecl" = type <{ %"class.xercesc_2_5::XMLElementDecl.base", [3 x i8], i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator"*, i32, i32, i32, i32, i16*, %"class.xercesc_2_5::ComplexTypeInfo"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::ComplexTypeInfo"*, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::RefVectorOf.15"*, %"class.xercesc_2_5::SchemaAttDef"*, %"class.xercesc_2_5::SchemaElementDecl"*, i32, i32, i8, i8, i8, [5 x i8] }>
%"class.xercesc_2_5::XMLElementDecl.base" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::QName"*, i32, i32, i8 }>
%"class.xercesc_2_5::RefHash2KeysTableOf" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem" = type <{ %"class.xercesc_2_5::SchemaAttDef"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::ComplexTypeInfo" = type { %"class.xalanc_1_8::XalanNode", i8, i8, i8, i8, i8, i32, i32, i32, i32, i32, i32, i16*, i16*, i16*, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::ComplexTypeInfo"*, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::SchemaAttDef"*, %"class.xercesc_2_5::SchemaAttDefList"*, %"class.xercesc_2_5::RefVectorOf.12"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xalanc_1_8::XalanNode"*, i16*, i32*, i32, i32, %"class.xercesc_2_5::XSDLocator"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ContentSpecNode" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::QName"*, %"class.xercesc_2_5::XMLElementDecl"*, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::ContentSpecNode"*, i32, i8, i8, i32, i32 }
%"class.xercesc_2_5::SchemaAttDefList" = type { %"class.xercesc_2_5::XMLGrammarDescription", %"class.xercesc_2_5::RefHash2KeysTableOfEnumerator"*, %"class.xercesc_2_5::RefHash2KeysTableOf.1031"*, %"class.xercesc_2_5::SchemaAttDef.1028"**, i32, i32 }
%"class.xercesc_2_5::XMLGrammarDescription" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHash2KeysTableOfEnumerator" = type { %"class.xalanc_1_8::XalanNode", i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.1030"*, i32, %"class.xercesc_2_5::RefHash2KeysTableOf.1031"*, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.1030" = type <{ %"class.xercesc_2_5::SchemaAttDef.1028"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.1030"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::SchemaAttDef.1028" = type { %"class.xercesc_2_5::XMLAttDef", i32, %"class.xercesc_2_5::QName"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::ValueVectorOf.11"*, i32, i32, i32, %"class.xercesc_2_5::SchemaAttDef.1028"* }
%"class.xercesc_2_5::XMLAttDef" = type { %"class.xalanc_1_8::XalanNode", i32, i32, i32, i8, i8, i32, i16*, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHash2KeysTableOf.1031" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.1030"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.12" = type { %"class.xercesc_2_5::BaseRefVectorOf.13" }
%"class.xercesc_2_5::BaseRefVectorOf.13" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaElementDecl"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.15" = type { %"class.xercesc_2_5::BaseRefVectorOf.16" }
%"class.xercesc_2_5::BaseRefVectorOf.16" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IdentityConstraint"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::SchemaAttDef" = type { %"class.xercesc_2_5::XMLAttDef", i32, %"class.xercesc_2_5::QName"*, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::ValueVectorOf.11"*, i32, i32, i32, %"class.xercesc_2_5::SchemaAttDef"* }
%"class.xercesc_2_5::XSTypeDefinition.3544" = type { %"class.xercesc_2_5::XSObject.3532", i32, i16, %"class.xercesc_2_5::XSTypeDefinition.3544"* }
%"class.xercesc_2_5::XSComplexTypeDefinition.3549" = type <{ %"class.xercesc_2_5::XSTypeDefinition.3544", %"class.xercesc_2_5::ComplexTypeInfo"*, %"class.xercesc_2_5::XSWildcard"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::XSSimpleTypeDefinition.3547"*, %"class.xercesc_2_5::RefVectorOf.22"*, %"class.xercesc_2_5::XSParticle"*, i16, [6 x i8] }>
%"class.xercesc_2_5::XSWildcard" = type { %"class.xercesc_2_5::XSObject", i32, i32, %"class.xercesc_2_5::RefArrayVectorOf"*, %"class.xercesc_2_5::XSAnnotation"* }
%"class.xercesc_2_5::XSSimpleTypeDefinition.3547" = type { %"class.xercesc_2_5::XSTypeDefinition.3544", i32, i32, i32, %"class.xercesc_2_5::DatatypeValidator"*, %"class.xercesc_2_5::RefVectorOf.29"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefArrayVectorOf"*, %"class.xercesc_2_5::XSSimpleTypeDefinition.3547"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefVectorOf.22"* }
%"class.xercesc_2_5::RefVectorOf.29" = type { %"class.xercesc_2_5::BaseRefVectorOf.30" }
%"class.xercesc_2_5::BaseRefVectorOf.30" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaAttDef"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSParticle" = type { %"class.xercesc_2_5::XSObject", i32, i32, i32, %"class.xercesc_2_5::XSObject"* }
%"class.xercesc_2_5::XSAnnotation.3533" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XSObject.3532", i16*, %"class.xercesc_2_5::XSAnnotation.3533"* }
%"class.xercesc_2_5::RefVectorOf.33" = type { %"class.xercesc_2_5::BaseRefVectorOf.34" }
%"class.xercesc_2_5::BaseRefVectorOf.34" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSAttributeDeclaration"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSAttributeDeclaration" = type { %"class.xercesc_2_5::XSObject.3532", %"class.xercesc_2_5::SchemaAttDef"*, %"class.xercesc_2_5::XSSimpleTypeDefinition.3547"*, %"class.xercesc_2_5::XSAnnotation.3533"*, i32, i32, %"class.xercesc_2_5::XSComplexTypeDefinition.3549"* }
%"class.xercesc_2_5::XSNamedMap.3539" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefVectorOf.20.3537"*, %"class.xercesc_2_5::RefHash2KeysTableOf.21.3538"* }
%"class.xercesc_2_5::RefHash2KeysTableOf.21.3538" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.61"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.61" = type <{ %"class.xercesc_2_5::XSObject.3532"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.61"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefVectorOf.22" = type { %"class.xercesc_2_5::BaseRefVectorOf.23" }
%"class.xercesc_2_5::BaseRefVectorOf.23" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSAnnotation.3533"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.35" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.36"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.36" = type { %"class.xercesc_2_5::XSNamespaceItem"*, %"struct.xercesc_2_5::RefHashTableBucketElem.36"*, i8* }
%"class.xercesc_2_5::XSNamespaceItem" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::SchemaGrammar.3534"*, %"class.xercesc_2_5::XSModel.3553"*, [14 x %"class.xercesc_2_5::XSNamedMap.3539"*], %"class.xercesc_2_5::RefVectorOf.22"*, [14 x %"class.xercesc_2_5::RefHashTableOf.24.3541"*], i16* }
%"class.xercesc_2_5::SchemaGrammar.3534" = type { %"class.xalanc_1_8::XalanDocumentFragment", i16*, %"class.xercesc_2_5::RefHash3KeysIdPool"*, %"class.xercesc_2_5::RefHash3KeysIdPool"*, %"class.xercesc_2_5::RefHash3KeysIdPool"*, %"class.xercesc_2_5::NameIdPool"*, %"class.xercesc_2_5::RefHashTableOf.25"*, %"class.xercesc_2_5::RefHashTableOf.12"*, %"class.xercesc_2_5::RefHashTableOf.13.3525"*, %"class.xercesc_2_5::RefHashTableOf.14.3527"*, %"class.xercesc_2_5::NamespaceScope"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xalanc_1_8::XalanNode"*, i8, %"class.xercesc_2_5::DatatypeValidatorFactory", %"class.xercesc_2_5::XMLSchemaDescription"*, %"class.xercesc_2_5::RefHashTableOf.17"* }
%"class.xalanc_1_8::XalanDocumentFragment" = type { %"class.xalanc_1_8::XalanNode" }
%"class.xercesc_2_5::RefHash3KeysIdPool" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash3KeysTableBucketElem"**, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::SchemaElementDecl"**, i32, i32 }
%"struct.xercesc_2_5::RefHash3KeysTableBucketElem" = type { %"class.xercesc_2_5::SchemaElementDecl"*, %"struct.xercesc_2_5::RefHash3KeysTableBucketElem"*, i8*, i32, i32 }
%"class.xercesc_2_5::NameIdPool" = type <{ %"class.xalanc_1_8::XalanNode"*, %"struct.xercesc_2_5::NameIdPoolBucketElem"**, %"class.xercesc_2_5::XMLNotationDecl"**, i32, i32, i32, [4 x i8] }>
%"struct.xercesc_2_5::NameIdPoolBucketElem" = type { %"class.xercesc_2_5::XMLNotationDecl"*, %"struct.xercesc_2_5::NameIdPoolBucketElem"* }
%"class.xercesc_2_5::XMLNotationDecl" = type { %"class.xalanc_1_8::XalanNode", i32, i16*, i16*, i16*, i16*, i32, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.12" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.13"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.13" = type { %"class.xercesc_2_5::ComplexTypeInfo"*, %"struct.xercesc_2_5::RefHashTableBucketElem.13"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.13.3525" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.56"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.56" = type { %"class.xercesc_2_5::XercesGroupInfo.3524"*, %"struct.xercesc_2_5::RefHashTableBucketElem.56"*, i8* }
%"class.xercesc_2_5::XercesGroupInfo.3524" = type { %"class.xalanc_1_8::XalanNode", i8, i32, i32, i32, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::RefVectorOf.12"*, %"class.xercesc_2_5::XercesGroupInfo.3524"*, %"class.xercesc_2_5::XSDLocator"* }
%"class.xercesc_2_5::RefHashTableOf.14.3527" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.51"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.51" = type { %"class.xercesc_2_5::XercesAttGroupInfo.3109"*, %"struct.xercesc_2_5::RefHashTableBucketElem.51"*, i8* }
%"class.xercesc_2_5::XercesAttGroupInfo.3109" = type { %"class.xalanc_1_8::XalanNode", i8, i32, i32, %"class.xercesc_2_5::RefVectorOf.29"*, %"class.xercesc_2_5::RefVectorOf.29"*, %"class.xercesc_2_5::SchemaAttDef"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::DatatypeValidatorFactory" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::RefHashTableOf"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLSchemaDescription" = type { %"class.xercesc_2_5::XMLGrammarDescription" }
%"class.xercesc_2_5::RefHashTableOf.17" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.18"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.18" = type { %"class.xercesc_2_5::XSAnnotation.3533"*, %"struct.xercesc_2_5::RefHashTableBucketElem.18"*, i8* }
%"class.xercesc_2_5::RefVectorOf.3543" = type { %"class.xercesc_2_5::BaseRefVectorOf.0" }
%"class.xercesc_2_5::BaseRefVectorOf.0" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSNamespaceItem"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.20.3537" = type { %"class.xercesc_2_5::BaseRefVectorOf.60" }
%"class.xercesc_2_5::BaseRefVectorOf.60" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSObject.3532"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf" = type { i8, i32, i32, %"class.xercesc_2_5::SchemaGrammar"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::SchemaGrammar" = type { %"class.xalanc_1_8::XalanDocumentFragment", i16*, %"class.xercesc_2_5::RefHash3KeysIdPool"*, %"class.xercesc_2_5::RefHash3KeysIdPool"*, %"class.xercesc_2_5::RefHash3KeysIdPool"*, %"class.xercesc_2_5::NameIdPool"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::NamespaceScope"*, %"class.xercesc_2_5::RefHash2KeysTableOf.23"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xalanc_1_8::XalanNode"*, i8, %"class.xercesc_2_5::DatatypeValidatorFactory", %"class.xercesc_2_5::XMLSchemaDescription"*, %"class.xercesc_2_5::RefHashTableOf.24"* }
%"class.xercesc_2_5::RefHash2KeysTableOf.23" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.23"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.23" = type <{ %"class.xercesc_2_5::ValueVectorOf.31"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.23"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::ValueVectorOf.31" = type { i8, i32, i32, %"class.xercesc_2_5::SchemaElementDecl"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.24" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.25"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.25" = type { %"class.xercesc_2_5::XSAnnotation"*, %"struct.xercesc_2_5::RefHashTableBucketElem.25"*, i8* }
%"class.xercesc_2_5::SchemaGrammar.9640" = type { %"class.xalanc_1_8::XalanDocumentFragment", i16*, %"class.xercesc_2_5::RefHash3KeysIdPool.9625"*, %"class.xercesc_2_5::RefHash3KeysIdPool.9625"*, %"class.xercesc_2_5::RefHash3KeysIdPool.9625"*, %"class.xercesc_2_5::NameIdPool"*, %"class.xercesc_2_5::RefHashTableOf.25"*, %"class.xercesc_2_5::RefHashTableOf.23"*, %"class.xercesc_2_5::RefHashTableOf.25.9631"*, %"class.xercesc_2_5::RefHashTableOf.41"*, %"class.xercesc_2_5::NamespaceScope"*, %"class.xercesc_2_5::RefHash2KeysTableOf.29"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xalanc_1_8::XalanNode"*, i8, %"class.xercesc_2_5::DatatypeValidatorFactory.9585", %"class.xercesc_2_5::XMLSchemaDescription"*, %"class.xercesc_2_5::RefHashTableOf.31"* }
%"class.xercesc_2_5::RefHash3KeysIdPool.9625" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash3KeysTableBucketElem.9624"**, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::SchemaElementDecl.6147"**, i32, i32 }
%"struct.xercesc_2_5::RefHash3KeysTableBucketElem.9624" = type { %"class.xercesc_2_5::SchemaElementDecl.6147"*, %"struct.xercesc_2_5::RefHash3KeysTableBucketElem.9624"*, i8*, i32, i32 }
%"class.xercesc_2_5::SchemaElementDecl.6147" = type <{ %"class.xercesc_2_5::XMLElementDecl.base", [3 x i8], i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.1024"*, i32, i32, i32, i32, i16*, %"class.xercesc_2_5::ComplexTypeInfo.6137"*, %"class.xercesc_2_5::RefHash2KeysTableOf.1031"*, %"class.xercesc_2_5::ComplexTypeInfo.6137"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::RefVectorOf.6.6146"*, %"class.xercesc_2_5::SchemaAttDef.1028"*, %"class.xercesc_2_5::SchemaElementDecl.6147"*, i32, i32, i8, i8, i8, [5 x i8] }>
%"class.xercesc_2_5::RefVectorOf.6.6146" = type { %"class.xercesc_2_5::BaseRefVectorOf.7.6145" }
%"class.xercesc_2_5::BaseRefVectorOf.7.6145" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IdentityConstraint.6144"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IdentityConstraint.6144" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector.6138"*, %"class.xercesc_2_5::RefVectorOf.8.6143"*, %"class.xalanc_1_8::XalanNode"*, i32, [4 x i8] }>
%"class.xercesc_2_5::IC_Selector.6138" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath.6140"*, %"class.xercesc_2_5::IdentityConstraint.6144"* }
%"class.xercesc_2_5::XercesXPath.6140" = type { %"class.xalanc_1_8::XalanNode", i32, i16*, %"class.xercesc_2_5::RefVectorOf.10"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.10" = type { %"class.xercesc_2_5::BaseRefVectorOf.11" }
%"class.xercesc_2_5::BaseRefVectorOf.11" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XSAttributeUse.5561"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSAttributeUse.5561" = type { %"class.xercesc_2_5::XSObject", i8, i32, i16*, %"class.xercesc_2_5::XSAttributeDeclaration"* }
%"class.xercesc_2_5::RefVectorOf.8.6143" = type { %"class.xercesc_2_5::BaseRefVectorOf.9.6142" }
%"class.xercesc_2_5::BaseRefVectorOf.9.6142" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IC_Field.6141"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IC_Field.6141" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath.6140"*, %"class.xercesc_2_5::IdentityConstraint.6144"* }
%"class.xercesc_2_5::RefHashTableOf.31" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.32"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.32" = type { %"class.xercesc_2_5::XSAnnotation"*, %"struct.xercesc_2_5::RefHashTableBucketElem.32"*, i8* }
%"class.xercesc_2_5::XMLStringPool" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLStringPool::PoolElem"**, %"class.xercesc_2_5::RefHashTableOf"*, i32, i32 }
%"class.xercesc_2_5::XMLStringPool::PoolElem" = type { i32, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLBuffer" = type { i8, i32, i32, %"class.xalanc_1_8::XalanNode"*, i16* }
%"class.xercesc_2_5::XMLScanner.9660" = type { i32 (...)**, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i32, i32, i32, i32, i32, i32, i32, i32, i32**, i32, i32, i32, i32, i32, %"class.xercesc_2_5::RefVectorOf.33"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::ErrorHandler.9647"*, %"class.xercesc_2_5::PSVIHandler"*, %"class.xercesc_2_5::XMLGrammarPool"*, i8, %"class.xercesc_2_5::ReaderMgr.9654", %"class.xercesc_2_5::XMLValidator"*, i32, %"class.xercesc_2_5::GrammarResolver.9601"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xercesc_2_5::XMLStringPool"*, i16*, i16*, i16*, %"class.xalanc_1_8::XalanDOMException"*, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLBufferMgr", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::ElemStack" }
%"class.xercesc_2_5::ErrorHandler.9647" = type opaque
%"class.xercesc_2_5::PSVIHandler" = type { i32 (...)** }
%"class.xercesc_2_5::ReaderMgr.9654" = type { %"class.xercesc_2_5::Locator", %"class.xercesc_2_5::XMLEntityDecl"*, %"class.xercesc_2_5::XMLReader"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::RefStackOf"*, i32, %"class.xercesc_2_5::RefStackOf"*, i8, i32, i8, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::Locator" = type { i32 (...)** }
%"class.xercesc_2_5::XMLEntityDecl" = type { %"class.xalanc_1_8::XalanNode", i32, i32, i16*, i16*, i16*, i16*, i16*, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLReader" = type { i32, [16384 x i16], i32, [16384 x i8], i64, i64, i32, i16*, i8, i8, i16*, i32, [49152 x i8], i32, i32, i32, i8, i32, i32, i8, i8, i16*, %"class.xalanc_1_8::XalanNode"*, i8, i8, %"class.xercesc_2_5::XMLTranscoder"*, i32, i8*, i8, i32, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLTranscoder" = type { i32 (...)**, i32, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefStackOf" = type { [8 x i8], %"class.xercesc_2_5::RefVectorOf.9" }
%"class.xercesc_2_5::RefVectorOf.9" = type { %"class.xercesc_2_5::BaseRefVectorOf.10" }
%"class.xercesc_2_5::BaseRefVectorOf.10" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::RefHashTableOf.8"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.8" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.2700"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.2700" = type { %"class.xercesc_2_5::ValueStore"*, %"struct.xercesc_2_5::RefHashTableBucketElem.2700"*, i8* }
%"class.xercesc_2_5::ValueStore" = type { i8, i32, %"class.xercesc_2_5::IdentityConstraint"*, %"class.xercesc_2_5::FieldValueMap", %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::ValueStore"*, %"class.xercesc_2_5::XMLScanner"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::FieldValueMap" = type { %"class.xercesc_2_5::ValueVectorOf.2685"*, %"class.xercesc_2_5::ValueVectorOf.2"*, %"class.xercesc_2_5::RefArrayVectorOf"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.2685" = type { i8, i32, i32, %"class.xercesc_2_5::IC_Field"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.2" = type { i8, i32, i32, %"class.xercesc_2_5::DatatypeValidator"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLScanner" = type { i32 (...)**, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i32, i32, i32, i32, i32, i32, i32, i32, i32**, i32, i32, i32, i32, i32, %"class.xercesc_2_5::RefVectorOf.134"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::ErrorHandler"*, %"class.xercesc_2_5::PSVIHandler"*, %"class.xercesc_2_5::XMLGrammarPool"*, i8, %"class.xercesc_2_5::ReaderMgr", %"class.xercesc_2_5::XMLValidator"*, i32, %"class.xercesc_2_5::GrammarResolver.146"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xercesc_2_5::XMLStringPool"*, i16*, i16*, i16*, %"class.xalanc_1_8::XalanDOMException"*, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLBufferMgr", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::ElemStack" }
%"class.xercesc_2_5::RefVectorOf.134" = type { %"class.xercesc_2_5::BaseRefVectorOf.133" }
%"class.xercesc_2_5::BaseRefVectorOf.133" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::XMLAttr"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XMLAttr" = type <{ i8, [3 x i8], i32, i32, [4 x i8], i16*, %"class.xercesc_2_5::QName"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DatatypeValidator"*, i8, [7 x i8] }>
%"class.xercesc_2_5::ErrorHandler" = type { i32 (...)** }
%"class.xercesc_2_5::ReaderMgr" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XMLEntityDecl"*, %"class.xercesc_2_5::XMLReader"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::RefStackOf"*, i32, %"class.xercesc_2_5::RefStackOf.3"*, i8, i32, i8, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefStackOf.3" = type opaque
%"class.xercesc_2_5::GrammarResolver.146" = type { i8, i8, i8, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::DatatypeValidatorFactory"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::XSModel"*, %"class.xercesc_2_5::XSModel"*, %"class.xercesc_2_5::ValueVectorOf"* }
%"class.xercesc_2_5::XMLValidator" = type { i32 (...)**, %"class.xercesc_2_5::XMLBufferMgr"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::ReaderMgr"*, %"class.xercesc_2_5::XMLScanner"* }
%"class.xalanc_1_8::XalanDOMException" = type <{ i32 (...)**, i32, [4 x i8] }>
%"class.xercesc_2_5::XMLBufferMgr" = type { i32, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLBuffer"** }
%"class.xercesc_2_5::ElemStack" = type { i32, i32, %"class.xercesc_2_5::XMLStringPool", %"struct.xercesc_2_5::ElemStack::StackElem"**, i32, i32, i32, i32, i32, i32, i32, %"class.xercesc_2_5::ValueVectorOf"*, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::ElemStack::StackElem" = type <{ %"class.xercesc_2_5::XMLElementDecl"*, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::QName"**, %struct.anon*, i32, i32, i8, [3 x i8], i32, %"class.xalanc_1_8::XalanDocumentFragment"*, i32, [4 x i8] }>
%struct.anon = type { i32, i32 }
%"class.xercesc_2_5::NamespaceScope" = type { i32, i32, i32, %"class.xercesc_2_5::XMLStringPool", %"struct.xercesc_2_5::NamespaceScope::StackElem"**, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::NamespaceScope::StackElem" = type { %struct.anon*, i32, i32 }
%"class.xercesc_2_5::RefHashTableOf.25" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.26"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.26" = type { %"class.xercesc_2_5::XMLAttDef"*, %"struct.xercesc_2_5::RefHashTableBucketElem.26"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.23" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.24"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.24" = type { %"class.xercesc_2_5::ComplexTypeInfo.6137"*, %"struct.xercesc_2_5::RefHashTableBucketElem.24"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.25.9631" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.26.9630"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.26.9630" = type { %"class.xercesc_2_5::XercesGroupInfo.9629"*, %"struct.xercesc_2_5::RefHashTableBucketElem.26.9630"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.41" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.42"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.42" = type { %"class.xercesc_2_5::XercesAttGroupInfo"*, %"struct.xercesc_2_5::RefHashTableBucketElem.42"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.36" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.37"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.37" = type { %"class.xercesc_2_5::ValueVectorOf.48"*, %"struct.xercesc_2_5::RefHashTableBucketElem.37"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.38" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.39.9664"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.39.9664" = type { %"class.xercesc_2_5::SchemaInfo"*, %"struct.xercesc_2_5::RefHashTableBucketElem.39.9664"*, i8* }
%"class.xercesc_2_5::SchemaInfo" = type { i8, i8, i16, i32, i32, i32, i32, i32, i16*, i16*, %"class.xalanc_1_8::XalanDocumentFragment"*, %"class.xercesc_2_5::RefVectorOf.4989"*, %"class.xercesc_2_5::RefVectorOf.4989"*, %"class.xercesc_2_5::RefVectorOf.4989"*, %"class.xercesc_2_5::ValueVectorOf.4990"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf.4990"*, %"class.xercesc_2_5::ValueVectorOf.26"*, [7 x %"class.xercesc_2_5::ValueVectorOf.4990"*], %"class.xercesc_2_5::ValueVectorOf.3"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.4989" = type { %"class.xercesc_2_5::BaseRefVectorOf.4988" }
%"class.xercesc_2_5::BaseRefVectorOf.4988" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaInfo"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.26" = type { i8, i32, i32, i16**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XercesGroupInfo.9629" = type { %"class.xalanc_1_8::XalanNode", i8, i32, i32, i32, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::RefVectorOf.3"*, %"class.xercesc_2_5::XercesGroupInfo.9629"*, %"class.xercesc_2_5::XSDLocator"* }
%"class.xercesc_2_5::RefVectorOf.3" = type { %"class.xercesc_2_5::BaseRefVectorOf.4" }
%"class.xercesc_2_5::BaseRefVectorOf.4" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaElementDecl.6147"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XercesAttGroupInfo" = type { %"class.xalanc_1_8::XalanNode", i8, i32, i32, %"class.xercesc_2_5::RefVectorOf.19"*, %"class.xercesc_2_5::RefVectorOf.19"*, %"class.xercesc_2_5::SchemaAttDef.1028"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.19" = type { %"class.xercesc_2_5::BaseRefVectorOf.20" }
%"class.xercesc_2_5::BaseRefVectorOf.20" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaAttDef.1028"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ComplexTypeInfo.6137" = type { %"class.xalanc_1_8::XalanNode", i8, i8, i8, i8, i8, i32, i32, i32, i32, i32, i32, i16*, i16*, i16*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::ComplexTypeInfo.6137"*, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::SchemaAttDef.1028"*, %"class.xercesc_2_5::SchemaAttDefList"*, %"class.xercesc_2_5::RefVectorOf.3"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefHash2KeysTableOf.1031"*, %"class.xalanc_1_8::XalanNode"*, i16*, i32*, i32, i32, %"class.xercesc_2_5::XSDLocator"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.11" = type { i8, i32, i32, i32*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.48" = type { i8, i32, i32, %"class.xercesc_2_5::SchemaElementDecl.6147"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.4990" = type { i8, i32, i32, %"class.xalanc_1_8::XalanDocumentFragment"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ValueVectorOf.3" = type { i8, i32, i32, %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.49.9666" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.50.9665"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.50.9665" = type { %"class.xercesc_2_5::ValueVectorOf.4990"*, %"struct.xercesc_2_5::RefHashTableBucketElem.50.9665"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.51" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.52"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.52" = type { %"class.xercesc_2_5::ValueVectorOf.11"*, %"struct.xercesc_2_5::RefHashTableBucketElem.52"*, i8* }
%"class.xercesc_2_5::RefHash2KeysTableOf.53" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.54"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.54" = type <{ i16*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.54"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefHash2KeysTableOf.55" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.56"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.56" = type <{ %"class.xercesc_2_5::IdentityConstraint.6144"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.56"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefHash2KeysTableOf.29" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.30"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.30" = type <{ %"class.xercesc_2_5::ValueVectorOf.48"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.30"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefHash2KeysTableOf.57" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.58"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.58" = type <{ %"class.xercesc_2_5::SchemaInfo"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.58"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::XSDDOMParser.9676" = type { %"class.xercesc_2_5::XercesDOMParser.9674", i8, i32, i32, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XSDErrorReporter", %"class.xercesc_2_5::XSDLocator" }
%"class.xercesc_2_5::XercesDOMParser.9674" = type { %"class.xercesc_2_5::AbstractDOMParser.9671", %"class.xercesc_2_5::EntityResolver.9672"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::ErrorHandler.9647"* }
%"class.xercesc_2_5::AbstractDOMParser.9671" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", i8, i8, i8, i8, i8, i8, %"class.xercesc_2_5::XMLScanner.9660"*, i16*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DOMEntity.9667"*, %"class.xercesc_2_5::DOMDocumentImpl"*, %"class.xercesc_2_5::ValueStackOf"*, %"class.xercesc_2_5::DOMDocumentTypeImpl"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::GrammarResolver.9601"*, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::XMLValidator"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::XMLBufferMgr", %"class.xercesc_2_5::XMLBuffer"*, %"class.xercesc_2_5::PSVIHandler"* }
%"class.xercesc_2_5::DOMEntity.9667" = type opaque
%"class.xercesc_2_5::DOMDocumentImpl" = type <{ %"class.xercesc_2_5::DOMDocument", %"class.xercesc_2_5::DOMNodeImpl", %"class.xercesc_2_5::DOMParentNode", %"class.xercesc_2_5::DOMNodeIDMap"*, i16*, i16*, i8, [7 x i8], i16*, i16*, %"class.xercesc_2_5::DOMConfiguration"*, %"class.xercesc_2_5::RefHashTableOf"*, i8*, i8*, i64, %"class.xercesc_2_5::RefArrayOf"*, %"class.xercesc_2_5::RefStackOf"*, %"class.xercesc_2_5::DOMDeepNodeListPool"*, %"class.xercesc_2_5::DOMDocumentType"*, %"class.xercesc_2_5::DOMElement"*, %"class.xercesc_2_5::DOMStringPool"*, %"class.xercesc_2_5::DOMNormalizer"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xalanc_1_8::XalanNode"*, i32, i8, [3 x i8] }>
%"class.xercesc_2_5::DOMDocument" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode" }
%"class.xercesc_2_5::DOMNodeImpl" = type <{ %"class.xalanc_1_8::XalanNode"*, i16, [6 x i8] }>
%"class.xercesc_2_5::DOMParentNode" = type { %"class.xercesc_2_5::DOMDocument"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarDescription" }
%"class.xercesc_2_5::DOMNodeIDMap" = type { i32 (...)**, %"class.xalanc_1_8::XalanDocumentFragment"**, i64, i64, i64, i64, %"class.xercesc_2_5::DOMDocument"* }
%"class.xercesc_2_5::DOMConfiguration" = type { i32 (...)** }
%"class.xercesc_2_5::RefArrayOf" = type { i32, %"class.xercesc_2_5::RefStackOf.5389"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefStackOf.5389" = type { [8 x i8], %"class.xercesc_2_5::RefVectorOf.1" }
%"class.xercesc_2_5::RefVectorOf.1" = type { %"class.xercesc_2_5::BaseRefVectorOf.1964" }
%"class.xercesc_2_5::BaseRefVectorOf.1964" = type { i32 (...)**, i8, i32, i32, %"class.xalanc_1_8::XalanNode"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::DOMDeepNodeListPool" = type { i8, %"struct.xercesc_2_5::DOMDeepNodeListPoolTableBucketElem"**, i64, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DOMDeepNodeListImpl"**, i64, i64, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::DOMDeepNodeListPoolTableBucketElem" = type { %"class.xercesc_2_5::DOMDeepNodeListImpl"*, %"struct.xercesc_2_5::DOMDeepNodeListPoolTableBucketElem"*, i8*, i16*, i16* }
%"class.xercesc_2_5::DOMDeepNodeListImpl" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i16*, i8, [3 x i8], i32, %"class.xalanc_1_8::XalanNode"*, i64, i16*, i8, i8, [6 x i8] }>
%"class.xercesc_2_5::DOMDocumentType" = type { %"class.xalanc_1_8::XalanNode" }
%"class.xercesc_2_5::DOMElement" = type { %"class.xalanc_1_8::XalanNode" }
%"class.xercesc_2_5::DOMStringPool" = type <{ %"class.xercesc_2_5::DOMDocumentImpl"*, %"struct.xercesc_2_5::DOMStringPoolEntry"**, i32, [4 x i8] }>
%"struct.xercesc_2_5::DOMStringPoolEntry" = type { %"struct.xercesc_2_5::DOMStringPoolEntry"*, [1 x i16] }
%"class.xercesc_2_5::DOMNormalizer" = type { %"class.xercesc_2_5::DOMDocumentImpl"*, %"class.xercesc_2_5::DOMConfigurationImpl"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DOMNormalizer::InScopeNamespaces"*, i32, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::DOMConfigurationImpl" = type { %"class.xercesc_2_5::DOMConfiguration", i16, %"class.xalanc_1_8::XalanNode"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::DOMNormalizer::InScopeNamespaces" = type { %"class.xercesc_2_5::RefVectorOf.1.4797"*, %"class.xercesc_2_5::DOMNormalizer::InScopeNamespaces::Scope"* }
%"class.xercesc_2_5::RefVectorOf.1.4797" = type { %"class.xercesc_2_5::BaseRefVectorOf.4796" }
%"class.xercesc_2_5::BaseRefVectorOf.4796" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::DOMNormalizer::InScopeNamespaces::Scope"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::DOMNormalizer::InScopeNamespaces::Scope" = type { %"class.xercesc_2_5::DOMNormalizer::InScopeNamespaces::Scope"*, %"class.xercesc_2_5::RefHashTableOf.3049"*, %"class.xercesc_2_5::RefHashTableOf.3049"* }
%"class.xercesc_2_5::RefHashTableOf.3049" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.3048"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.3048" = type { i16*, %"struct.xercesc_2_5::RefHashTableBucketElem.3048"*, i8* }
%"class.xercesc_2_5::ValueStackOf" = type { [8 x i8], %"class.xercesc_2_5::ValueVectorOf.11" }
%"class.xercesc_2_5::DOMDocumentTypeImpl" = type <{ %"class.xercesc_2_5::DOMDocumentType", %"class.xercesc_2_5::DOMNodeImpl", %"class.xercesc_2_5::DOMParentNode", %"class.xercesc_2_5::DOMChildNode", i16*, %"class.xercesc_2_5::DOMNamedNodeMap"*, %"class.xercesc_2_5::DOMNamedNodeMap"*, %"class.xercesc_2_5::DOMNamedNodeMap"*, i16*, i16*, i16*, i8, i8, [6 x i8] }>
%"class.xercesc_2_5::DOMChildNode" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::DOMNamedNodeMap" = type { i32 (...)** }
%"class.xercesc_2_5::EntityResolver.9672" = type opaque
%"class.xercesc_2_5::XSDLocator" = type { %"class.xercesc_2_5::Locator", i64, i64, i16*, i16* }
%"class.xercesc_2_5::XSDErrorReporter" = type { i32 (...)**, i8, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::XSAnnotation" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XSObject", i16*, %"class.xercesc_2_5::XSAnnotation"* }
%"class.xercesc_2_5::GeneralAttributeCheck.9680" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::IDDatatypeValidator" }
%"class.xercesc_2_5::IDDatatypeValidator" = type { %"class.xercesc_2_5::StringDatatypeValidator.9679" }
%"class.xercesc_2_5::StringDatatypeValidator.9679" = type { %"class.xercesc_2_5::AbstractStringValidator.9678" }
%"class.xercesc_2_5::AbstractStringValidator.9678" = type { %"class.xercesc_2_5::DatatypeValidator.base.6151", i32, i32, i32, i8, %"class.xercesc_2_5::RefArrayVectorOf"* }
%"class.xercesc_2_5::DatatypeValidator.base.6151" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::RefHashTableOf.1"*, i16*, %"class.xercesc_2_5::RegularExpression"*, i16*, i16*, i16*, i32, i8, i8, i8 }>
%"class.xercesc_2_5::Janitor.66" = type { %"class.xercesc_2_5::IC_Unique.9701"* }
%"class.xercesc_2_5::IC_Unique.9701" = type { %"class.xercesc_2_5::IdentityConstraint.base.9699", [4 x i8] }
%"class.xercesc_2_5::IdentityConstraint.base.9699" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector.6138"*, %"class.xercesc_2_5::RefVectorOf.8.6143"*, %"class.xalanc_1_8::XalanNode"*, i32 }>
%"class.xercesc_2_5::GeneralAttributeCheck.13896" = type { %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::NameDatatypeValidator" }
%"class.xercesc_2_5::NameDatatypeValidator" = type { %"class.xercesc_2_5::StringDatatypeValidator" }
%"class.xercesc_2_5::StringDatatypeValidator" = type { %"class.xercesc_2_5::AbstractStringValidator.4114" }
%"class.xercesc_2_5::AbstractStringValidator.4114" = type { %"class.xercesc_2_5::DatatypeValidator.base.3655", i32, i32, i32, i8, %"class.xercesc_2_5::RefArrayVectorOf"* }
%"class.xercesc_2_5::DatatypeValidator.base.3655" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::RefHashTableOf.1"*, i16*, %"class.xercesc_2_5::RegularExpression.3653"*, i16*, i16*, i16*, i32, i8, i8, i8 }>
%"class.xercesc_2_5::DatatypeValidator.3654" = type <{ %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, i8, i8, i16, i32, i32, i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::RefHashTableOf.1"*, i16*, %"class.xercesc_2_5::RegularExpression.3653"*, i16*, i16*, i16*, i32, i8, i8, i8, i8 }>
%"class.xercesc_2_5::RegularExpression.3653" = type { i8, i8, i32, i32, i32, i32, %"class.xercesc_2_5::BMPattern"*, i16*, i16*, %"class.xercesc_2_5::Op"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::RangeToken"*, %"class.xercesc_2_5::OpFactory", %"class.xercesc_2_5::XMLMutex", %"class.xercesc_2_5::TokenFactory.3652"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::TokenFactory.3652" = type { %"class.xercesc_2_5::RefVectorOf.0"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xercesc_2_5::Token"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.0" = type { %"class.xercesc_2_5::BaseRefVectorOf.1" }
%"class.xercesc_2_5::BaseRefVectorOf.1" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::TreeWalkerImpl"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::TreeWalkerImpl" = type <{ %"class.xalanc_1_8::XalanReferenceCountedObject.base", [4 x i8], i64, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DOM_Node", %"class.xercesc_2_5::DOM_Node", i8, [7 x i8] }>
%"class.xalanc_1_8::XalanReferenceCountedObject.base" = type <{ i32 (...)**, i32 }>
%"class.xercesc_2_5::DOM_Node" = type { %"class.xercesc_2_5::NodeImpl"* }
%"class.xercesc_2_5::NodeImpl" = type <{ %"class.xercesc_2_5::NodeListImpl.base", [4 x i8], %"class.xercesc_2_5::NodeImpl"*, i16, [6 x i8] }>
%"class.xercesc_2_5::NodeListImpl.base" = type { %"class.xalanc_1_8::XalanReferenceCountedObject.base" }
%"class.xercesc_2_5::TraverseSchema.13955" = type { i8, i32, i32, i32, i32, i32, i32, i16*, %"class.xercesc_2_5::DatatypeValidatorFactory.11228"*, %"class.xercesc_2_5::GrammarResolver"*, %"class.xercesc_2_5::SchemaGrammar.13936"*, %"class.xercesc_2_5::XMLEntityHandler.13937"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLStringPool.13941"*, %"class.xercesc_2_5::XMLStringPool.13941"*, %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XMLScanner"*, %"class.xercesc_2_5::NamespaceScope"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf.12"*, %"class.xercesc_2_5::RefHashTableOf.13"*, %"class.xercesc_2_5::RefHashTableOf.18"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::SchemaInfo"*, %"class.xercesc_2_5::XercesGroupInfo"*, %"class.xercesc_2_5::XercesAttGroupInfo"*, %"class.xercesc_2_5::ComplexTypeInfo.13915"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::ValueVectorOf"*, %"class.xercesc_2_5::ValueVectorOf.4990"*, %"class.xercesc_2_5::ValueVectorOf.11"**, %"class.xercesc_2_5::ValueVectorOf.3"*, %"class.xercesc_2_5::RefHashTableOf.28"*, %"class.xercesc_2_5::RefHashTableOf.29"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::XSDDOMParser"*, %"class.xercesc_2_5::XSDErrorReporter", %"class.xercesc_2_5::XSDLocator"*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XSAnnotation"*, %"class.xercesc_2_5::GeneralAttributeCheck.13896" }
%"class.xercesc_2_5::DatatypeValidatorFactory.11228" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::RefHashTableOf.2"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.2" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.3"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.3" = type { %"class.xercesc_2_5::DatatypeValidator.3654"*, %"struct.xercesc_2_5::RefHashTableBucketElem.3"*, i8* }
%"class.xercesc_2_5::GrammarResolver" = type { i8, i8, i8, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::RefHashTableOf.0"*, %"class.xercesc_2_5::RefHashTableOf.0"*, %"class.xercesc_2_5::DatatypeValidatorFactory"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::XSModel"*, %"class.xercesc_2_5::XSModel"*, %"class.xercesc_2_5::ValueVectorOf"* }
%"class.xercesc_2_5::RefHashTableOf.0" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem" = type { %"class.xalanc_1_8::XalanDocumentFragment"*, %"struct.xercesc_2_5::RefHashTableBucketElem"*, i8* }
%"class.xercesc_2_5::SchemaGrammar.13936" = type { %"class.xalanc_1_8::XalanDocumentFragment", i16*, %"class.xercesc_2_5::RefHash3KeysIdPool.13926"*, %"class.xercesc_2_5::RefHash3KeysIdPool.13926"*, %"class.xercesc_2_5::RefHash3KeysIdPool.13926"*, %"class.xercesc_2_5::NameIdPool"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf"*, %"class.xercesc_2_5::RefHashTableOf.12"*, %"class.xercesc_2_5::RefHashTableOf.13"*, %"class.xercesc_2_5::NamespaceScope"*, %"class.xercesc_2_5::RefHash2KeysTableOf"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xalanc_1_8::XalanNode"*, i8, %"class.xercesc_2_5::DatatypeValidatorFactory.11228", %"class.xercesc_2_5::XMLSchemaDescription"*, %"class.xercesc_2_5::RefHashTableOf.15"* }
%"class.xercesc_2_5::RefHash3KeysIdPool.13926" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash3KeysTableBucketElem.13925"**, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::SchemaElementDecl.13924"**, i32, i32 }
%"struct.xercesc_2_5::RefHash3KeysTableBucketElem.13925" = type { %"class.xercesc_2_5::SchemaElementDecl.13924"*, %"struct.xercesc_2_5::RefHash3KeysTableBucketElem.13925"*, i8*, i32, i32 }
%"class.xercesc_2_5::SchemaElementDecl.13924" = type <{ %"class.xercesc_2_5::XMLElementDecl.base", [3 x i8], i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.3654"*, i32, i32, i32, i32, i16*, %"class.xercesc_2_5::ComplexTypeInfo.13915"*, %"class.xercesc_2_5::RefHash2KeysTableOf.13913"*, %"class.xercesc_2_5::ComplexTypeInfo.13915"*, %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::RefVectorOf.15"*, %"class.xercesc_2_5::SchemaAttDef.13907"*, %"class.xercesc_2_5::SchemaElementDecl.13924"*, i32, i32, i8, i8, i8, [5 x i8] }>
%"class.xercesc_2_5::RefHash2KeysTableOf.13913" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.13912"**, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHash2KeysTableBucketElem.13912" = type <{ %"class.xercesc_2_5::SchemaAttDef.13907"*, %"struct.xercesc_2_5::RefHash2KeysTableBucketElem.13912"*, i8*, i32, [4 x i8] }>
%"class.xercesc_2_5::SchemaAttDef.13907" = type { %"class.xercesc_2_5::XMLAttDef", i32, %"class.xercesc_2_5::QName"*, %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::ValueVectorOf.11"*, i32, i32, i32, %"class.xercesc_2_5::SchemaAttDef.13907"* }
%"class.xercesc_2_5::RefHashTableOf.15" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.16"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.16" = type { %"class.xercesc_2_5::XSAnnotation"*, %"struct.xercesc_2_5::RefHashTableBucketElem.16"*, i8* }
%"class.xercesc_2_5::XMLEntityHandler.13937" = type opaque
%"class.xercesc_2_5::XMLStringPool.13941" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLStringPool::PoolElem"**, %"class.xercesc_2_5::RefHashTableOf.17"*, i32, i32 }
%"class.xercesc_2_5::RefHashTableOf.13" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.150"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.150" = type { %"class.xercesc_2_5::XMLRefInfo"*, %"struct.xercesc_2_5::RefHashTableBucketElem.150"*, i8* }
%"class.xercesc_2_5::XMLRefInfo" = type { %"class.xalanc_1_8::XalanNode", i8, i8, i16*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.18" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.19"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.19" = type { %"class.xercesc_2_5::XSAnnotation"*, %"struct.xercesc_2_5::RefHashTableBucketElem.19"*, i8* }
%"class.xercesc_2_5::XercesGroupInfo" = type { %"class.xalanc_1_8::XalanNode", i8, i32, i32, i32, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::RefVectorOf.4"*, %"class.xercesc_2_5::XercesGroupInfo"*, %"class.xercesc_2_5::XSDLocator"* }
%"class.xercesc_2_5::RefVectorOf.4" = type { %"class.xercesc_2_5::BaseRefVectorOf.5" }
%"class.xercesc_2_5::BaseRefVectorOf.5" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaElementDecl.1041"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::SchemaElementDecl.1041" = type <{ %"class.xercesc_2_5::XMLElementDecl.base", [3 x i8], i32, i32, [4 x i8], %"class.xercesc_2_5::DatatypeValidator.1024"*, i32, i32, i32, i32, i16*, %"class.xercesc_2_5::ComplexTypeInfo.1033"*, %"class.xercesc_2_5::RefHash2KeysTableOf.1031"*, %"class.xercesc_2_5::ComplexTypeInfo.1033"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::RefVectorOf.15"*, %"class.xercesc_2_5::SchemaAttDef.1028"*, %"class.xercesc_2_5::SchemaElementDecl.1041"*, i32, i32, i8, i8, i8, [5 x i8] }>
%"class.xercesc_2_5::ComplexTypeInfo.1033" = type { %"class.xalanc_1_8::XalanNode", i8, i8, i8, i8, i8, i32, i32, i32, i32, i32, i32, i16*, i16*, i16*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::DatatypeValidator.1024"*, %"class.xercesc_2_5::ComplexTypeInfo.1033"*, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::SchemaAttDef.1028"*, %"class.xercesc_2_5::SchemaAttDefList"*, %"class.xercesc_2_5::RefVectorOf.4"*, %"class.xercesc_2_5::RefVectorOf.6"*, %"class.xercesc_2_5::RefHash2KeysTableOf.1031"*, %"class.xalanc_1_8::XalanNode"*, i16*, i32*, i32, i32, %"class.xercesc_2_5::XSDLocator"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.6" = type { %"class.xercesc_2_5::BaseRefVectorOf.7" }
%"class.xercesc_2_5::BaseRefVectorOf.7" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::ContentSpecNode"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::ComplexTypeInfo.13915" = type { %"class.xalanc_1_8::XalanNode", i8, i8, i8, i8, i8, i32, i32, i32, i32, i32, i32, i16*, i16*, i16*, %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::DatatypeValidator.3654"*, %"class.xercesc_2_5::ComplexTypeInfo.13915"*, %"class.xercesc_2_5::ContentSpecNode"*, %"class.xercesc_2_5::SchemaAttDef.13907"*, %"class.xercesc_2_5::SchemaAttDefList"*, %"class.xercesc_2_5::RefVectorOf.3.13910"*, %"class.xercesc_2_5::RefVectorOf.5"*, %"class.xercesc_2_5::RefHash2KeysTableOf.13913"*, %"class.xalanc_1_8::XalanNode"*, i16*, i32*, i32, i32, %"class.xercesc_2_5::XSDLocator"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.3.13910" = type { %"class.xercesc_2_5::BaseRefVectorOf.4.13909" }
%"class.xercesc_2_5::BaseRefVectorOf.4.13909" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::SchemaElementDecl.13924"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefVectorOf.5" = type { %"class.xercesc_2_5::BaseRefVectorOf.6" }
%"class.xercesc_2_5::BaseRefVectorOf.6" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IdentityConstraint.12073"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IdentityConstraint.12073" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector.12067"*, %"class.xercesc_2_5::RefVectorOf.7.12072"*, %"class.xalanc_1_8::XalanNode"*, i32, [4 x i8] }>
%"class.xercesc_2_5::IC_Selector.12067" = type opaque
%"class.xercesc_2_5::RefVectorOf.7.12072" = type { %"class.xercesc_2_5::BaseRefVectorOf.8.12071" }
%"class.xercesc_2_5::BaseRefVectorOf.8.12071" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IC_Field.12070"**, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::IC_Field.12070" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath.12069"*, %"class.xercesc_2_5::IdentityConstraint.12073"* }
%"class.xercesc_2_5::XercesXPath.12069" = type { %"class.xalanc_1_8::XalanNode", i32, i16*, %"class.xercesc_2_5::RefVectorOf.9"*, %"class.xalanc_1_8::XalanNode"* }
%"class.xercesc_2_5::RefHashTableOf.28" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.29"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.29" = type { %"class.xercesc_2_5::XSAnnotation"*, %"struct.xercesc_2_5::RefHashTableBucketElem.29"*, i8* }
%"class.xercesc_2_5::RefHashTableOf.29" = type { %"class.xalanc_1_8::XalanNode"*, i8, %"struct.xercesc_2_5::RefHashTableBucketElem.30"**, i32, i32, i32, %"class.xalanc_1_8::XalanNode"* }
%"struct.xercesc_2_5::RefHashTableBucketElem.30" = type { %"class.xercesc_2_5::DTDAttDef"*, %"struct.xercesc_2_5::RefHashTableBucketElem.30"*, i8* }
%"class.xercesc_2_5::DTDAttDef" = type { %"class.xercesc_2_5::XMLAttDef", i32, i16* }
%"class.xercesc_2_5::XSDDOMParser" = type { %"class.xercesc_2_5::XercesDOMParser.9391", i8, i32, i32, i32, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::ValueVectorOf.11"*, %"class.xercesc_2_5::XMLBuffer", %"class.xercesc_2_5::XSDErrorReporter", %"class.xercesc_2_5::XSDLocator.9341" }
%"class.xercesc_2_5::XercesDOMParser.9391" = type { %"class.xercesc_2_5::AbstractDOMParser.9388", %"class.xercesc_2_5::EntityResolver.9389"*, %"class.xercesc_2_5::XMLEntityResolver.9390"*, %"class.xercesc_2_5::ErrorHandler"* }
%"class.xercesc_2_5::AbstractDOMParser.9388" = type { %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", %"class.xalanc_1_8::XalanNode", i8, i8, i8, i8, i8, i8, %"class.xercesc_2_5::XMLScanner"*, i16*, %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::DOMEntity.9385"*, %"class.xercesc_2_5::DOMDocumentImpl"*, %"class.xercesc_2_5::ValueStackOf"*, %"class.xercesc_2_5::DOMDocumentTypeImpl"*, %"class.xercesc_2_5::RefVectorOf"*, %"class.xercesc_2_5::GrammarResolver.146"*, %"class.xercesc_2_5::XMLStringPool"*, %"class.xercesc_2_5::XMLValidator"*, %"class.xalanc_1_8::XalanNode"*, %"class.xercesc_2_5::XMLGrammarPool"*, %"class.xercesc_2_5::XMLBufferMgr", %"class.xercesc_2_5::XMLBuffer"*, %"class.xercesc_2_5::PSVIHandler"* }
%"class.xercesc_2_5::DOMEntity.9385" = type opaque
%"class.xercesc_2_5::EntityResolver.9389" = type opaque
%"class.xercesc_2_5::XMLEntityResolver.9390" = type opaque
%"class.xercesc_2_5::XSDLocator.9341" = type { %"class.xalanc_1_8::XalanNode", i64, i64, i16*, i16* }
%"class.xercesc_2_5::IC_Key" = type { %"class.xercesc_2_5::IdentityConstraint.base", [4 x i8] }
%"class.xercesc_2_5::IdentityConstraint.base" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector"*, %"class.xercesc_2_5::RefVectorOf.17"*, %"class.xalanc_1_8::XalanNode"*, i32 }>
%"class.xercesc_2_5::IC_Unique" = type { %"class.xercesc_2_5::IdentityConstraint.base.2525", [4 x i8] }
%"class.xercesc_2_5::IdentityConstraint.base.2525" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector.2518"*, %"class.xercesc_2_5::RefVectorOf.0.2521"*, %"class.xalanc_1_8::XalanNode"*, i32 }>
%"class.xercesc_2_5::IC_Selector.2518" = type { %"class.xalanc_1_8::XalanNode", %"class.xercesc_2_5::XercesXPath.2425"*, %"class.xercesc_2_5::IdentityConstraint.2522"* }
%"class.xercesc_2_5::IdentityConstraint.2522" = type <{ %"class.xalanc_1_8::XalanNode", i16*, i16*, %"class.xercesc_2_5::IC_Selector.2518"*, %"class.xercesc_2_5::RefVectorOf.0.2521"*, %"class.xalanc_1_8::XalanNode"*, i32, [4 x i8] }>
%"class.xercesc_2_5::RefVectorOf.0.2521" = type { %"class.xercesc_2_5::BaseRefVectorOf.2520" }
%"class.xercesc_2_5::BaseRefVectorOf.2520" = type { i32 (...)**, i8, i32, i32, %"class.xercesc_2_5::IC_Selector.2518"**, %"class.xalanc_1_8::XalanNode"* }

@_ZN11xercesc_2_513SchemaSymbols12fgELT_UNIQUEE = external constant [7 x i16], align 2
@_ZN11xercesc_2_513SchemaSymbols9fgELT_KEYE = external constant [4 x i16], align 2
@_ZN11xercesc_2_513SchemaSymbols10fgATT_NAMEE = external constant [5 x i16], align 2
@_ZN11xercesc_2_56XMLUni14fgXMLErrDomainE = external constant [41 x i16], align 16

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
declare hidden void @__clang_call_terminate(i8*) local_unnamed_addr #0

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: noinline optsize uwtable
declare i16* @_ZN11xercesc_2_514XMLElementDecl11getBaseNameEv(%"class.xercesc_2_5::XMLElementDecl"* nonnull align 8 dereferenceable(33)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare i8* @_ZN11xercesc_2_57XMemorynwEmPNS_13MemoryManagerE(i64, %"class.xalanc_1_8::XalanNode"*) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_57XMemorydlEPvPNS_13MemoryManagerE(i8*, %"class.xalanc_1_8::XalanNode"* nocapture readnone) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare i16* @_ZN11xercesc_2_514TraverseSchema18getElementAttValueEPKNS_10DOMElementEPKtb(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544), %"class.xalanc_1_8::XalanDocumentFragment"*, i16*, i1 zeroext) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_514TraverseSchema17reportSchemaErrorEPKNS_10DOMElementEPKtiS5_S5_S5_S5_(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544), %"class.xalanc_1_8::XalanDocumentFragment"*, i16*, i32, i16*, i16*, i16*, i16*) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZNK11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE11containsKeyEPKvi(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40), i8*, i32) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE3putEPviPS1_(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40), i8*, i32, %"class.xercesc_2_5::IdentityConstraint.6144"*) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZN11xercesc_2_514TraverseSchema26traverseIdentityConstraintEPNS_18IdentityConstraintEPKNS_10DOMElementE(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544), %"class.xercesc_2_5::IdentityConstraint.6144"*, %"class.xalanc_1_8::XalanDocumentFragment"*) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_517SchemaElementDecl21addIdentityConstraintEPNS_18IdentityConstraintE(%"class.xercesc_2_5::SchemaElementDecl.6147"* nonnull align 8 dereferenceable(147), %"class.xercesc_2_5::IdentityConstraint.6144"*) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_518IdentityConstraint15setNamespaceURIEi(%"class.xercesc_2_5::IdentityConstraint.6144"* nonnull align 8 dereferenceable(52), i32) local_unnamed_addr #3 align 2

; Function Attrs: noinline optsize uwtable
define void @_ZN11xercesc_2_514TraverseSchema11traverseKeyEPKNS_10DOMElementEPNS_17SchemaElementDeclE(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, %"class.xercesc_2_5::SchemaElementDecl.6147"* %elemDecl) local_unnamed_addr #2 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %janKey = alloca %"class.xercesc_2_5::Janitor.66", align 8
  %fAttributeCheck = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 48
  %fNonXSAttList = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 34
  %0 = load %"class.xercesc_2_5::ValueVectorOf.3"*, %"class.xercesc_2_5::ValueVectorOf.3"** %fNonXSAttList, align 8, !tbaa !4
  tail call void bitcast (void (%"class.xercesc_2_5::GeneralAttributeCheck.13896"*, %"class.xalanc_1_8::XalanDocumentFragment"*, i16, %"class.xercesc_2_5::TraverseSchema.13955"*, i1, %"class.xercesc_2_5::ValueVectorOf.3"*)* @_ZN11xercesc_2_521GeneralAttributeCheck15checkAttributesEPKNS_10DOMElementEtPNS_14TraverseSchemaEbPNS_13ValueVectorOfIPNS_7DOMNodeEEE to void (%"class.xercesc_2_5::GeneralAttributeCheck.9680"*, %"class.xalanc_1_8::XalanDocumentFragment"*, i16, %"class.xercesc_2_5::TraverseSchema.9681"*, i1, %"class.xercesc_2_5::ValueVectorOf.3"*)*)(%"class.xercesc_2_5::GeneralAttributeCheck.9680"* nonnull align 8 dereferenceable(144) %fAttributeCheck, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16 zeroext 26, %"class.xercesc_2_5::TraverseSchema.9681"* nonnull %this, i1 zeroext false, %"class.xercesc_2_5::ValueVectorOf.3"* %0) #4
  %call = tail call i16* @_ZN11xercesc_2_514TraverseSchema18getElementAttValueEPKNS_10DOMElementEPKtb(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16* getelementptr inbounds ([5 x i16], [5 x i16]* @_ZN11xercesc_2_513SchemaSymbols10fgATT_NAMEE, i64 0, i64 0), i1 zeroext false) #4
  %tobool.not = icmp eq i16* %call, null
  br i1 %tobool.not, label %cleanup42, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %1 = load i16, i16* %call, align 2, !tbaa !15
  %tobool2.not = icmp eq i16 %1, 0
  br i1 %tobool2.not, label %cleanup42, label %if.end

if.end:                                           ; preds = %lor.lhs.false
  %call3 = tail call zeroext i1 @_ZN11xercesc_2_59XMLString13isValidNCNameEPKt(i16* nonnull %call) #4
  br i1 %call3, label %if.end5, label %if.then4

if.then4:                                         ; preds = %if.end
  tail call void @_ZN11xercesc_2_514TraverseSchema17reportSchemaErrorEPKNS_10DOMElementEPKtiS5_S5_S5_S5_(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16* getelementptr inbounds ([41 x i16], [41 x i16]* @_ZN11xercesc_2_56XMLUni14fgXMLErrDomainE, i64 0, i64 0), i32 59, i16* getelementptr inbounds ([4 x i16], [4 x i16]* @_ZN11xercesc_2_513SchemaSymbols9fgELT_KEYE, i64 0, i64 0), i16* nonnull %call, i16* null, i16* null) #4
  br label %cleanup42

if.end5:                                          ; preds = %if.end
  %fIdentityConstraintNames = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 39
  %2 = load %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames, align 8, !tbaa !17
  %tobool6.not = icmp eq %"class.xercesc_2_5::RefHash2KeysTableOf.55"* %2, null
  br i1 %tobool6.not, label %if.then7, label %if.else

if.then7:                                         ; preds = %if.end5
  %fMemoryManager = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 45
  %3 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fMemoryManager, align 8, !tbaa !18
  %call8 = tail call i8* @_ZN11xercesc_2_57XMemorynwEmPNS_13MemoryManagerE(i64 40, %"class.xalanc_1_8::XalanNode"* %3) #4
  %4 = bitcast i8* %call8 to %"class.xercesc_2_5::RefHash2KeysTableOf.55"*
  %5 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fMemoryManager, align 8, !tbaa !18
  invoke void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEEC2EjbPNS_13MemoryManagerE(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %4, i32 29, i1 zeroext false, %"class.xalanc_1_8::XalanNode"* %5) #4
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %if.then7
  %6 = bitcast %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames to i8**
  store i8* %call8, i8** %6, align 8, !tbaa !17
  br label %if.end16

lpad:                                             ; preds = %if.then7
  %7 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZN11xercesc_2_57XMemorydlEPvPNS_13MemoryManagerE(i8* %call8, %"class.xalanc_1_8::XalanNode"* %3) #4
          to label %ehcleanup43 unwind label %terminate.lpad

if.else:                                          ; preds = %if.end5
  %8 = bitcast i16* %call to i8*
  %fTargetNSURI = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 1
  %9 = load i32, i32* %fTargetNSURI, align 4, !tbaa !19
  %call13 = tail call zeroext i1 @_ZNK11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE11containsKeyEPKvi(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %2, i8* nonnull %8, i32 %9) #4
  br i1 %call13, label %if.then14, label %if.end16

if.then14:                                        ; preds = %if.else
  tail call void @_ZN11xercesc_2_514TraverseSchema17reportSchemaErrorEPKNS_10DOMElementEPKtiS5_S5_S5_S5_(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16* getelementptr inbounds ([41 x i16], [41 x i16]* @_ZN11xercesc_2_56XMLUni14fgXMLErrDomainE, i64 0, i64 0), i32 146, i16* nonnull %call, i16* null, i16* null, i16* null) #4
  br label %cleanup42

if.end16:                                         ; preds = %if.else, %invoke.cont
  %fGrammarPoolMemoryManager = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 46
  %10 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fGrammarPoolMemoryManager, align 8, !tbaa !20
  %call17 = tail call i8* @_ZN11xercesc_2_57XMemorynwEmPNS_13MemoryManagerE(i64 56, %"class.xalanc_1_8::XalanNode"* %10) #4
  %11 = bitcast i8* %call17 to %"class.xercesc_2_5::IC_Unique.9701"*
  %12 = bitcast %"class.xercesc_2_5::SchemaElementDecl.6147"* %elemDecl to %"class.xercesc_2_5::XMLElementDecl"*
  %call20 = invoke i16* @_ZN11xercesc_2_514XMLElementDecl11getBaseNameEv(%"class.xercesc_2_5::XMLElementDecl"* nonnull align 8 dereferenceable(33) %12) #4
          to label %invoke.cont19 unwind label %lpad18

invoke.cont19:                                    ; preds = %if.end16
  %13 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fGrammarPoolMemoryManager, align 8, !tbaa !20
  invoke void bitcast (void (%"class.xercesc_2_5::IC_Key"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)* @_ZN11xercesc_2_56IC_KeyC1EPKtS2_PNS_13MemoryManagerE to void (%"class.xercesc_2_5::IC_Unique.9701"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*)(%"class.xercesc_2_5::IC_Unique.9701"* nonnull align 8 dereferenceable(52) %11, i16* nonnull %call, i16* %call20, %"class.xalanc_1_8::XalanNode"* %13) #4
          to label %invoke.cont22 unwind label %lpad18

invoke.cont22:                                    ; preds = %invoke.cont19
  %14 = bitcast %"class.xercesc_2_5::Janitor.66"* %janKey to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %14) #5
  call void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEEC2EPS1_(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janKey, %"class.xercesc_2_5::IC_Unique.9701"* nonnull %11) #4
  %15 = load %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames, align 8, !tbaa !17
  %16 = bitcast i16* %call to i8*
  %fTargetNSURI25 = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 1
  %17 = load i32, i32* %fTargetNSURI25, align 4, !tbaa !19
  %18 = bitcast i8* %call17 to %"class.xercesc_2_5::IdentityConstraint.6144"*
  invoke void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE3putEPviPS1_(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %15, i8* nonnull %16, i32 %17, %"class.xercesc_2_5::IdentityConstraint.6144"* %18) #4
          to label %invoke.cont27 unwind label %lpad26

invoke.cont27:                                    ; preds = %invoke.cont22
  %call29 = invoke zeroext i1 @_ZN11xercesc_2_514TraverseSchema26traverseIdentityConstraintEPNS_18IdentityConstraintEPKNS_10DOMElementE(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xercesc_2_5::IdentityConstraint.6144"* %18, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem) #4
          to label %invoke.cont28 unwind label %lpad26

invoke.cont28:                                    ; preds = %invoke.cont27
  br i1 %call29, label %if.end34, label %if.then30

if.then30:                                        ; preds = %invoke.cont28
  %19 = load %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames, align 8, !tbaa !17
  %20 = load i32, i32* %fTargetNSURI25, align 4, !tbaa !19
  invoke void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE3putEPviPS1_(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %19, i8* nonnull %16, i32 %20, %"class.xercesc_2_5::IdentityConstraint.6144"* null) #4
          to label %cleanup unwind label %lpad26

lpad18:                                           ; preds = %invoke.cont19, %if.end16
  %21 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZN11xercesc_2_57XMemorydlEPvPNS_13MemoryManagerE(i8* %call17, %"class.xalanc_1_8::XalanNode"* %10) #4
          to label %ehcleanup43 unwind label %terminate.lpad

lpad26:                                           ; preds = %invoke.cont35, %if.end34, %if.then30, %invoke.cont27, %invoke.cont22
  %22 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEED2Ev(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janKey) #4
          to label %invoke.cont39 unwind label %terminate.lpad

if.end34:                                         ; preds = %invoke.cont28
  invoke void @_ZN11xercesc_2_517SchemaElementDecl21addIdentityConstraintEPNS_18IdentityConstraintE(%"class.xercesc_2_5::SchemaElementDecl.6147"* nonnull align 8 dereferenceable(147) %elemDecl, %"class.xercesc_2_5::IdentityConstraint.6144"* %18) #4
          to label %invoke.cont35 unwind label %lpad26

invoke.cont35:                                    ; preds = %if.end34
  %23 = load i32, i32* %fTargetNSURI25, align 4, !tbaa !19
  call void @_ZN11xercesc_2_518IdentityConstraint15setNamespaceURIEi(%"class.xercesc_2_5::IdentityConstraint.6144"* nonnull align 8 dereferenceable(52) %18, i32 %23) #4
  invoke void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEE6orphanEv(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janKey) #4
          to label %cleanup unwind label %lpad26

cleanup:                                          ; preds = %invoke.cont35, %if.then30
  call void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEED2Ev(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janKey) #4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %14) #5
  br label %cleanup42

cleanup42:                                        ; preds = %entry, %lor.lhs.false, %cleanup, %if.then14, %if.then4
  ret void

invoke.cont39:                                    ; preds = %lpad26
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %14) #5
  br label %ehcleanup43

ehcleanup43:                                      ; preds = %invoke.cont39, %lpad18, %lpad
  %.pn.pn = phi { i8*, i32 } [ %7, %lpad ], [ %22, %invoke.cont39 ], [ %21, %lpad18 ]
  resume { i8*, i32 } %.pn.pn

terminate.lpad:                                   ; preds = %lpad26, %lpad18, %lpad
  %24 = landingpad { i8*, i32 }
          catch i8* null
  %25 = extractvalue { i8*, i32 } %24, 0
  call void @__clang_call_terminate(i8* %25) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
define void @_ZN11xercesc_2_514TraverseSchema14traverseUniqueEPKNS_10DOMElementEPNS_17SchemaElementDeclE(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, %"class.xercesc_2_5::SchemaElementDecl.6147"* %elemDecl) local_unnamed_addr #2 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %janUnique = alloca %"class.xercesc_2_5::Janitor.66", align 8
  %fAttributeCheck = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 48
  %fNonXSAttList = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 34
  %0 = load %"class.xercesc_2_5::ValueVectorOf.3"*, %"class.xercesc_2_5::ValueVectorOf.3"** %fNonXSAttList, align 8, !tbaa !4
  tail call void bitcast (void (%"class.xercesc_2_5::GeneralAttributeCheck.13896"*, %"class.xalanc_1_8::XalanDocumentFragment"*, i16, %"class.xercesc_2_5::TraverseSchema.13955"*, i1, %"class.xercesc_2_5::ValueVectorOf.3"*)* @_ZN11xercesc_2_521GeneralAttributeCheck15checkAttributesEPKNS_10DOMElementEtPNS_14TraverseSchemaEbPNS_13ValueVectorOfIPNS_7DOMNodeEEE to void (%"class.xercesc_2_5::GeneralAttributeCheck.9680"*, %"class.xalanc_1_8::XalanDocumentFragment"*, i16, %"class.xercesc_2_5::TraverseSchema.9681"*, i1, %"class.xercesc_2_5::ValueVectorOf.3"*)*)(%"class.xercesc_2_5::GeneralAttributeCheck.9680"* nonnull align 8 dereferenceable(144) %fAttributeCheck, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16 zeroext 48, %"class.xercesc_2_5::TraverseSchema.9681"* nonnull %this, i1 zeroext false, %"class.xercesc_2_5::ValueVectorOf.3"* %0) #4
  %call = tail call i16* @_ZN11xercesc_2_514TraverseSchema18getElementAttValueEPKNS_10DOMElementEPKtb(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16* getelementptr inbounds ([5 x i16], [5 x i16]* @_ZN11xercesc_2_513SchemaSymbols10fgATT_NAMEE, i64 0, i64 0), i1 zeroext false) #4
  %tobool.not = icmp eq i16* %call, null
  br i1 %tobool.not, label %cleanup43, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %1 = load i16, i16* %call, align 2, !tbaa !15
  %tobool2.not = icmp eq i16 %1, 0
  br i1 %tobool2.not, label %cleanup43, label %if.end

if.end:                                           ; preds = %lor.lhs.false
  %call3 = tail call zeroext i1 @_ZN11xercesc_2_59XMLString13isValidNCNameEPKt(i16* nonnull %call) #4
  br i1 %call3, label %if.end5, label %if.then4

if.then4:                                         ; preds = %if.end
  tail call void @_ZN11xercesc_2_514TraverseSchema17reportSchemaErrorEPKNS_10DOMElementEPKtiS5_S5_S5_S5_(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16* getelementptr inbounds ([41 x i16], [41 x i16]* @_ZN11xercesc_2_56XMLUni14fgXMLErrDomainE, i64 0, i64 0), i32 59, i16* getelementptr inbounds ([7 x i16], [7 x i16]* @_ZN11xercesc_2_513SchemaSymbols12fgELT_UNIQUEE, i64 0, i64 0), i16* nonnull %call, i16* null, i16* null) #4
  br label %cleanup43

if.end5:                                          ; preds = %if.end
  %fIdentityConstraintNames = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 39
  %2 = load %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames, align 8, !tbaa !17
  %tobool6.not = icmp eq %"class.xercesc_2_5::RefHash2KeysTableOf.55"* %2, null
  br i1 %tobool6.not, label %if.then7, label %if.else

if.then7:                                         ; preds = %if.end5
  %fGrammarPoolMemoryManager = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 46
  %3 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fGrammarPoolMemoryManager, align 8, !tbaa !20
  %call8 = tail call i8* @_ZN11xercesc_2_57XMemorynwEmPNS_13MemoryManagerE(i64 40, %"class.xalanc_1_8::XalanNode"* %3) #4
  %4 = bitcast i8* %call8 to %"class.xercesc_2_5::RefHash2KeysTableOf.55"*
  %5 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fGrammarPoolMemoryManager, align 8, !tbaa !20
  invoke void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEEC2EjbPNS_13MemoryManagerE(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %4, i32 29, i1 zeroext false, %"class.xalanc_1_8::XalanNode"* %5) #4
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %if.then7
  %6 = bitcast %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames to i8**
  store i8* %call8, i8** %6, align 8, !tbaa !17
  br label %if.end16

lpad:                                             ; preds = %if.then7
  %7 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZN11xercesc_2_57XMemorydlEPvPNS_13MemoryManagerE(i8* %call8, %"class.xalanc_1_8::XalanNode"* %3) #4
          to label %ehcleanup44 unwind label %terminate.lpad

if.else:                                          ; preds = %if.end5
  %8 = bitcast i16* %call to i8*
  %fTargetNSURI = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 1
  %9 = load i32, i32* %fTargetNSURI, align 4, !tbaa !19
  %call13 = tail call zeroext i1 @_ZNK11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE11containsKeyEPKvi(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %2, i8* nonnull %8, i32 %9) #4
  br i1 %call13, label %if.then14, label %if.end16

if.then14:                                        ; preds = %if.else
  tail call void @_ZN11xercesc_2_514TraverseSchema17reportSchemaErrorEPKNS_10DOMElementEPKtiS5_S5_S5_S5_(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem, i16* getelementptr inbounds ([41 x i16], [41 x i16]* @_ZN11xercesc_2_56XMLUni14fgXMLErrDomainE, i64 0, i64 0), i32 146, i16* nonnull %call, i16* null, i16* null, i16* null) #4
  br label %cleanup43

if.end16:                                         ; preds = %if.else, %invoke.cont
  %fGrammarPoolMemoryManager17 = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 46
  %10 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fGrammarPoolMemoryManager17, align 8, !tbaa !20
  %call18 = tail call i8* @_ZN11xercesc_2_57XMemorynwEmPNS_13MemoryManagerE(i64 56, %"class.xalanc_1_8::XalanNode"* %10) #4
  %11 = bitcast i8* %call18 to %"class.xercesc_2_5::IC_Unique.9701"*
  %12 = bitcast %"class.xercesc_2_5::SchemaElementDecl.6147"* %elemDecl to %"class.xercesc_2_5::XMLElementDecl"*
  %call21 = invoke i16* @_ZN11xercesc_2_514XMLElementDecl11getBaseNameEv(%"class.xercesc_2_5::XMLElementDecl"* nonnull align 8 dereferenceable(33) %12) #4
          to label %invoke.cont20 unwind label %lpad19

invoke.cont20:                                    ; preds = %if.end16
  %13 = load %"class.xalanc_1_8::XalanNode"*, %"class.xalanc_1_8::XalanNode"** %fGrammarPoolMemoryManager17, align 8, !tbaa !20
  invoke void bitcast (void (%"class.xercesc_2_5::IC_Unique"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)* @_ZN11xercesc_2_59IC_UniqueC1EPKtS2_PNS_13MemoryManagerE to void (%"class.xercesc_2_5::IC_Unique.9701"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)*)(%"class.xercesc_2_5::IC_Unique.9701"* nonnull align 8 dereferenceable(52) %11, i16* nonnull %call, i16* %call21, %"class.xalanc_1_8::XalanNode"* %13) #4
          to label %invoke.cont23 unwind label %lpad19

invoke.cont23:                                    ; preds = %invoke.cont20
  %14 = bitcast %"class.xercesc_2_5::Janitor.66"* %janUnique to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %14) #5
  call void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEEC2EPS1_(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janUnique, %"class.xercesc_2_5::IC_Unique.9701"* nonnull %11) #4
  %15 = load %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames, align 8, !tbaa !17
  %16 = bitcast i16* %call to i8*
  %fTargetNSURI26 = getelementptr inbounds %"class.xercesc_2_5::TraverseSchema.9681", %"class.xercesc_2_5::TraverseSchema.9681"* %this, i64 0, i32 1
  %17 = load i32, i32* %fTargetNSURI26, align 4, !tbaa !19
  %18 = bitcast i8* %call18 to %"class.xercesc_2_5::IdentityConstraint.6144"*
  invoke void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE3putEPviPS1_(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %15, i8* nonnull %16, i32 %17, %"class.xercesc_2_5::IdentityConstraint.6144"* %18) #4
          to label %invoke.cont28 unwind label %lpad27

invoke.cont28:                                    ; preds = %invoke.cont23
  %call30 = invoke zeroext i1 @_ZN11xercesc_2_514TraverseSchema26traverseIdentityConstraintEPNS_18IdentityConstraintEPKNS_10DOMElementE(%"class.xercesc_2_5::TraverseSchema.9681"* nonnull align 8 dereferenceable(544) %this, %"class.xercesc_2_5::IdentityConstraint.6144"* %18, %"class.xalanc_1_8::XalanDocumentFragment"* %icElem) #4
          to label %invoke.cont29 unwind label %lpad27

invoke.cont29:                                    ; preds = %invoke.cont28
  br i1 %call30, label %if.end35, label %if.then31

if.then31:                                        ; preds = %invoke.cont29
  %19 = load %"class.xercesc_2_5::RefHash2KeysTableOf.55"*, %"class.xercesc_2_5::RefHash2KeysTableOf.55"** %fIdentityConstraintNames, align 8, !tbaa !17
  %20 = load i32, i32* %fTargetNSURI26, align 4, !tbaa !19
  invoke void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEE3putEPviPS1_(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40) %19, i8* nonnull %16, i32 %20, %"class.xercesc_2_5::IdentityConstraint.6144"* null) #4
          to label %cleanup unwind label %lpad27

lpad19:                                           ; preds = %invoke.cont20, %if.end16
  %21 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZN11xercesc_2_57XMemorydlEPvPNS_13MemoryManagerE(i8* %call18, %"class.xalanc_1_8::XalanNode"* %10) #4
          to label %ehcleanup44 unwind label %terminate.lpad

lpad27:                                           ; preds = %invoke.cont36, %if.end35, %if.then31, %invoke.cont28, %invoke.cont23
  %22 = landingpad { i8*, i32 }
          cleanup
  invoke void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEED2Ev(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janUnique) #4
          to label %invoke.cont40 unwind label %terminate.lpad

if.end35:                                         ; preds = %invoke.cont29
  invoke void @_ZN11xercesc_2_517SchemaElementDecl21addIdentityConstraintEPNS_18IdentityConstraintE(%"class.xercesc_2_5::SchemaElementDecl.6147"* nonnull align 8 dereferenceable(147) %elemDecl, %"class.xercesc_2_5::IdentityConstraint.6144"* %18) #4
          to label %invoke.cont36 unwind label %lpad27

invoke.cont36:                                    ; preds = %if.end35
  %23 = load i32, i32* %fTargetNSURI26, align 4, !tbaa !19
  call void @_ZN11xercesc_2_518IdentityConstraint15setNamespaceURIEi(%"class.xercesc_2_5::IdentityConstraint.6144"* nonnull align 8 dereferenceable(52) %18, i32 %23) #4
  invoke void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEE6orphanEv(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janUnique) #4
          to label %cleanup unwind label %lpad27

cleanup:                                          ; preds = %invoke.cont36, %if.then31
  call void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEED2Ev(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8) %janUnique) #4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %14) #5
  br label %cleanup43

cleanup43:                                        ; preds = %entry, %lor.lhs.false, %cleanup, %if.then14, %if.then4
  ret void

invoke.cont40:                                    ; preds = %lpad27
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %14) #5
  br label %ehcleanup44

ehcleanup44:                                      ; preds = %invoke.cont40, %lpad19, %lpad
  %.pn.pn = phi { i8*, i32 } [ %7, %lpad ], [ %22, %invoke.cont40 ], [ %21, %lpad19 ]
  resume { i8*, i32 } %.pn.pn

terminate.lpad:                                   ; preds = %lpad27, %lpad19, %lpad
  %24 = landingpad { i8*, i32 }
          catch i8* null
  %25 = extractvalue { i8*, i32 } %24, 0
  call void @__clang_call_terminate(i8* %25) #6
  unreachable
}

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_519RefHash2KeysTableOfINS_18IdentityConstraintEEC2EjbPNS_13MemoryManagerE(%"class.xercesc_2_5::RefHash2KeysTableOf.55"* nonnull align 8 dereferenceable(40), i32, i1 zeroext, %"class.xalanc_1_8::XalanNode"*) unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEEC2EPS1_(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8), %"class.xercesc_2_5::IC_Unique.9701"*) unnamed_addr #3 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEED2Ev(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8)) unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_57JanitorINS_9IC_UniqueEE6orphanEv(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline nounwind optsize uwtable
declare void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEEC2EPS1_(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8), %"class.xercesc_2_5::IC_Unique.9701"*) unnamed_addr #3 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEED2Ev(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8)) unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_57JanitorINS_6IC_KeyEE6orphanEv(%"class.xercesc_2_5::Janitor.66"* nonnull align 8 dereferenceable(8)) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare void @_ZN11xercesc_2_521GeneralAttributeCheck15checkAttributesEPKNS_10DOMElementEtPNS_14TraverseSchemaEbPNS_13ValueVectorOfIPNS_7DOMNodeEEE(%"class.xercesc_2_5::GeneralAttributeCheck.13896"* nonnull align 8 dereferenceable(144), %"class.xalanc_1_8::XalanDocumentFragment"*, i16 zeroext, %"class.xercesc_2_5::TraverseSchema.13955"*, i1 zeroext, %"class.xercesc_2_5::ValueVectorOf.3"*) local_unnamed_addr #2 align 2

; Function Attrs: noinline optsize uwtable
declare zeroext i1 @_ZN11xercesc_2_59XMLString13isValidNCNameEPKt(i16*) local_unnamed_addr #2 align 2

declare void @_ZN11xercesc_2_56IC_KeyC1EPKtS2_PNS_13MemoryManagerE(%"class.xercesc_2_5::IC_Key"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)

declare void @_ZN11xercesc_2_59IC_UniqueC1EPKtS2_PNS_13MemoryManagerE(%"class.xercesc_2_5::IC_Unique"*, i16*, i16*, %"class.xalanc_1_8::XalanNode"*)

attributes #0 = { noinline noreturn nounwind }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { noinline optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noinline nounwind optsize uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { optsize }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"clang version 14.0.0 (git@github.com:ppetoumenos/llvm-project.git 43ffe3222a75cd50a33f8da93c3356b91752b555)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!5, !10, i64 272}
!5 = !{!"_ZTSN11xercesc_2_514TraverseSchemaE", !6, i64 0, !9, i64 4, !9, i64 8, !9, i64 12, !9, i64 16, !9, i64 20, !9, i64 24, !10, i64 32, !10, i64 40, !10, i64 48, !10, i64 56, !10, i64 64, !10, i64 72, !10, i64 80, !10, i64 88, !11, i64 96, !10, i64 128, !10, i64 136, !10, i64 144, !10, i64 152, !10, i64 160, !10, i64 168, !10, i64 176, !10, i64 184, !10, i64 192, !10, i64 200, !10, i64 208, !10, i64 216, !10, i64 224, !10, i64 232, !10, i64 240, !10, i64 248, !10, i64 256, !10, i64 264, !10, i64 272, !10, i64 280, !10, i64 288, !10, i64 296, !10, i64 304, !10, i64 312, !10, i64 320, !10, i64 328, !10, i64 336, !12, i64 344, !10, i64 368, !10, i64 376, !10, i64 384, !10, i64 392, !13, i64 400}
!6 = !{!"bool", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = !{!"int", !7, i64 0}
!10 = !{!"any pointer", !7, i64 0}
!11 = !{!"_ZTSN11xercesc_2_59XMLBufferE", !6, i64 0, !9, i64 4, !9, i64 8, !10, i64 16, !10, i64 24}
!12 = !{!"_ZTSN11xercesc_2_516XSDErrorReporterE", !6, i64 8, !10, i64 16}
!13 = !{!"_ZTSN11xercesc_2_521GeneralAttributeCheckE", !10, i64 0, !10, i64 8, !14, i64 16}
!14 = !{!"_ZTSN11xercesc_2_519IDDatatypeValidatorE"}
!15 = !{!16, !16, i64 0}
!16 = !{!"short", !7, i64 0}
!17 = !{!5, !10, i64 312}
!18 = !{!5, !10, i64 376}
!19 = !{!5, !9, i64 4}
!20 = !{!5, !10, i64 384}
