#include "llvm/Transforms/IPO/MergeAnnotation.h"
#include "llvm/Support/JSON.h"
#include <utility>

using namespace llvm;

std::unique_ptr<MergeAnnotations> MergeAnnotations::create(StringRef Buf) {
  auto A = std::make_unique<MergeAnnotations>();

  auto MaybeRoot = json::parse(Buf);
  if (!MaybeRoot)
    return nullptr;
  json::Value Root = MaybeRoot.get();
  json::Object *Object = Root.getAsObject();

  if (!Object)
    return nullptr;

  for (auto &Entry : *Object) {
    StringRef FunctionName = Entry.first;
    json::Array *Array = Entry.second.getAsArray();
    if (!Array)
      continue;

    for (auto &Annotation : *Array) {
      auto AnnotationName = Annotation.getAsString();
      if (!AnnotationName)
        continue;
      A->Annotations[FunctionName].insert(*AnnotationName);
    }
  }

  return std::move(A);
}

bool MergeAnnotations::hasAnnotation(StringRef FunctionName,
                                     StringRef AnnotationName) const {
  auto I = Annotations.find(FunctionName);
  if (I == Annotations.end())
    return false;
  return I->second.count(AnnotationName);
}
