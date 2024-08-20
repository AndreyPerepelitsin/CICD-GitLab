#include "s21_cat.h"

int main(int argc, char *argv[]) {
  int err = 1;
  err = s21_cat(argc, argv, err);
  return err;
}

int s21_cat(int argc, char *argv[], int err) {
  flag_arr flag = {0};
  err = parser_flag(argc, argv, &flag);
  if (flag.b == 1) {
    flag.n = 0;
  }
  if (err != 1) {
    while (optind < argc) {
      err = read_file(argv, &flag);
      optind++;
    }
  } else {
    fprintf(stderr, "Error flag");
  }
  return err;
}

int parser_flag(int argc, char *argv[], flag_arr *flag) {
  int f, err = 0, index = 0;
  static struct option options[] = {
      {"number-nonblank", 0, 0, 'b'},
      {"number", 0, 0, 'n'},
      {"squeeze-blank", 0, 0, 's'},
      {0, 0, 0, 0},
  };
  while ((f = getopt_long(argc, argv, "bEnsTvet", options, &index)) != -1) {
    switch (f) {
      case 'b':
        flag->b = 1;
        break;
      case 'E':
        flag->e = 1;
        break;
      case 'n':
        flag->n = 1;
        break;
      case 's':
        flag->s = 1;
        break;
      case 'T':
        flag->t = 1;
        break;
      case 'v':
        flag->v = 1;
        break;
      case 'e':
        flag->e = 1;
        flag->v = 1;
        break;
      case 't':
        flag->t = 1;
        flag->v = 1;
        break;
      default:
        err = 1;
        break;
    }
  }
  return err;
}

int read_file(char *argv[], const flag_arr *flag) {
  FILE *file = open_file(argv[optind], "r");
  int err = 0;
  if (file != NULL) {
    read_chars(file, flag);
  }
  err = handle_errors(file, err);
  return err;
}

FILE *open_file(const char *filename, const char *mode) {
  FILE *file = fopen(filename, mode);
  if (file == NULL) {
    perror("Error opening file");
  }
  return file;
}

void read_chars(FILE *file, const flag_arr *flag) {
  int str_count = 1, empty_str_count = 0;
  int last_sym = '\n', cur_c = fgetc(file);
  while (cur_c != EOF) {
    current_char(cur_c, &str_count, &empty_str_count, &last_sym, flag);
    cur_c = fgetc(file);
  }
}

void current_char(int cur_c, int *str_count, int *empty_str_count,
                  int *last_sym, const flag_arr *flag) {
  if (flag->s && cur_c == '\n' && *last_sym == '\n') {
    (*empty_str_count)++;
    if (*empty_str_count > 1) {
      return;
    }
  } else {
    *empty_str_count = 0;
  }
  if (*last_sym == '\n' && ((flag->b && cur_c != '\n') || flag->n)) {
    printf("%6d\t", (*str_count)++);
  }
  if (flag->t && cur_c == '\t') {
    printf("^");
    cur_c = 'I';
  }
  if (flag->e && cur_c == '\n') {
    printf("$");
  }
  if (flag->v) {
    if ((cur_c >= 0 && cur_c < 9) || (cur_c > 10 && cur_c < 32) ||
        (cur_c > 126 && cur_c <= 160)) {
      printf("^");
      if (cur_c > 126) {
        cur_c -= 64;
      } else {
        cur_c += 64;
      }
    }
  }
  printf("%c", cur_c);
  *last_sym = cur_c;
}

int handle_errors(FILE *file, int err) {
  if (file != NULL) {
    fclose(file);
  } else {
    err = -1;
  }
  return err;
}
