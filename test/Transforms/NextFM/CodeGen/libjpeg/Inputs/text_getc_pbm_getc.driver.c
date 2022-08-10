#include <stdio.h>

int pbm_getc(FILE *infile);

int main(int argc, char **argv) {
  FILE *infile;

  if ((infile = fopen(argv[1], "rb")) == NULL) {
    return 1;
  }
  int ch;
  do {
    ch = pbm_getc(infile);
    if (ch == EOF) {
      printf("EOF");
      return 1;
    }
  } while (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r');

  if (ch < '0' || ch > '9')
    return 1;
  pbm_getc(infile);
  fclose(infile);
}
