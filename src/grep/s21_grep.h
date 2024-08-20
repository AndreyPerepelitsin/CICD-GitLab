#ifndef S21_GREP_H_
#define S21_GREP_H_

#include <getopt.h>
#include <regex.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SIZE 1024

typedef struct flag {
  bool e;
  bool i;
  bool v;
  bool c;
  bool l;
  bool n;
  bool h;
  bool s;
  bool f;
  bool o;
  bool err;
} flags;

typedef struct {
  char *path;
  int count_pattern;
  int count_files;
} grep_values;

int s21_grep(int argc, char **argv);
int parser_flag(int argc, char **argv, flags *flag, grep_values *value,
                char patterns[SIZE][SIZE]);
void handle_E_flag(flags *flag, grep_values *value, char patterns[SIZE][SIZE]);
int handle_F_flag(flags *flag, grep_values *value, char patterns[SIZE][SIZE],
                  const char *optarg);
int f_flag(const char *path, char pattern[SIZE][SIZE], grep_values *value);

int process_files(int argc, char **argv, int opt_ind, char patterns[SIZE][SIZE],
                  grep_values value, flags option);
int find_pattern(int opt_ind, char **argv, char patterns[SIZE][SIZE]);
int flags_realisation(grep_values value, flags flag, char pattern[SIZE][SIZE]);
int check_file_access(grep_values value, flags flag);
void process_file_contents(FILE *file, grep_values value, flags flag,
                           const char pattern[SIZE][SIZE], int comp_flag,
                           int exit_l);
void nh_flags(grep_values value, flags flag, int count_lines, const char *str);
void o_flag(char *str, regex_t compiled);
void cl_flags(grep_values value, flags flag, int count_matched_lines);

#endif  // S21_GREP_H
