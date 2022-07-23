// RUN: %clang -c -emit-llvm %s -o %t.bc
// RUN: %opt --passes='multiple-func-merging' -func-merging-explore=1 -multiple-func-merging-allow-unprofitable --multiple-func-merging-disable-post-opt %t.bc -o %t.opt.bc
// RUN: %llc --filetype=obj %t.opt.bc -o %t.opt.o
// RUN: %clang -Wno-all -Wno-pointer-sign -Wno-literal-conversion %t.opt.o %S/Inputs/0_multiple-func-merging_Alignment.reduced.driver.c -lm -o %t.opt
// RUN: %clang -Wno-all -Wno-pointer-sign -Wno-literal-conversion %s %S/Inputs/0_multiple-func-merging_Alignment.reduced.driver.c -lm -o %t.safe
// RUN: %t.safe %S/Inputs/input_small.pgm %t.output_small.edges.pgm -e
// RUN: not %t.opt %S/Inputs/input_small.pgm %t.output_small.edges.pgm -e
// XFAIL: *

typedef unsigned char uchar;

int susan_edges(uchar *in, int x_size, int y_size) {

  for (int i = 0; i < y_size; i++) {
    x_size += *in;
  }
  return 0;
}

int susan_edges_small(uchar *in, int x_size, int y_size) {
  int n;
  uchar *p;

  for (int i = 0; i < y_size; i++) {
    n += *p;
  }
  return 0;
}
