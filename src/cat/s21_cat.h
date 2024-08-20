#ifndef SRC_CAT_S21_CAT_H
#define SRC_CAT_S21_CAT_H

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct flag {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
} flag_arr;

int s21_cat(int argc, char *argv[], int err);
int parser_flag(int argc, char *argv[], flag_arr *flag);
int read_file(char *argv[], const flag_arr *flag);
FILE *open_file(const char *filename, const char *mode);
void read_chars(FILE *file, const flag_arr *flag);
void current_char(int cur_c, int *str_count, int *empty_str_count,
                  int *last_sym, const flag_arr *flag);
int handle_errors(FILE *file, int err);

#endif  // SRC_CAT_S21_CAT_H
