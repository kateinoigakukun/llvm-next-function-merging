#ifndef LLVM_TRANSFORMS_IPO_MERGEANNOTATION_H
#define LLVM_TRANSFORMS_IPO_MERGEANNOTATION_H

#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSet.h"
#include <memory>

namespace llvm {

class MergeAnnotations {

  StringMap<StringSet<>> Annotations;

public:
  MergeAnnotations() = default;

  /// Parses the annotations from the buffer.
  static std::unique_ptr<MergeAnnotations> create(StringRef Buf);

  static std::unique_ptr<MergeAnnotations> createEmpty() {
    return std::make_unique<MergeAnnotations>();
  }

  /// Returns true if the function has the annotation.
  bool hasAnnotation(StringRef FunctionName, StringRef AnnotationName) const;
};

} // namespace llvm

#endif
