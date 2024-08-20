#include "s21_grep.h"

int main(int argc, char **argv) {
  int error = 0;
  error = s21_grep(argc, argv);
  return error;
}

int s21_grep(int argc, char **argv) {
  char patterns[SIZE][SIZE] = {0};
  int opt_ind = 0, error = 0;
  flags option = {0};
  grep_values value = {0};
  opt_ind = parser_flag(argc, argv, &option, &value, patterns);
  if (argc >= 3 && !option.err && opt_ind != argc) {
    process_files(argc, argv, opt_ind, patterns, value, option);
  } else {
    printf("usage: grep [-ivclnhso] [-e pattern] [-f file] [file ...]\n");
    error = 1;
  }
  return error;
}

int parser_flag(int argc, char **argv, flags *flag, grep_values *value,
                char patterns[SIZE][SIZE]) {
  int opt = 0;
  opterr = 0;
  while ((opt = getopt_long(argc, argv, "e:ivclnhsf:o", NULL, NULL)) != -1) {
    switch (opt) {
      case 'e':
        handle_E_flag(flag, value, patterns);
        break;
      case 'i':
        flag->i = true;
        break;
      case 'v':
        flag->v = true;
        break;
      case 'c':
        flag->c = true;
        break;
      case 'l':
        flag->l = true;
        break;
      case 'n':
        flag->n = true;
        break;
      case 'h':
        flag->h = true;
        break;
      case 's':
        flag->s = true;
        break;
      case 'f':
        handle_F_flag(flag, value, patterns, optarg);
        break;
      case 'o':
        flag->o = true;
        break;
      default:
        if (!flag->err) {
          printf("grep: unknown --directories option\n");
          flag->err = true;
          break;
        }
    }
  }
  return optind;
}

void handle_E_flag(flags *flag, grep_values *value, char patterns[SIZE][SIZE]) {
  while (*patterns[value->count_pattern] != 0)
    value->count_pattern = value->count_pattern + 1;
  strcpy(patterns[value->count_pattern], optarg);
  value->count_pattern = value->count_pattern + 1;
  flag->e = 1;
}

int handle_F_flag(flags *flag, grep_values *value, char patterns[SIZE][SIZE],
                  const char *optarg) {
  while (*patterns[value->count_pattern] != 0)
    value->count_pattern = value->count_pattern + 1;
  if (!f_flag(optarg, patterns, value))
    flag->f = 1;
  else
    flag->f = 0;
  return flag->f;
}

int f_flag(const char *path, char pattern[SIZE][SIZE], grep_values *value) {
  int flag = 0;
  if (access(path, F_OK) == 0) {
    FILE *file = fopen(path, "rt");
    if (file == NULL) {
      perror(path);
      flag = 1;
    } else {
      while (!feof(file)) {
        int length = 0;
        fgets(pattern[value->count_pattern], SIZE, file);
        length = strlen(pattern[value->count_pattern]);
        if (pattern[value->count_pattern][0] != '\n' &&
            pattern[value->count_pattern][length - 1] == '\n') {
          pattern[value->count_pattern][length - 1] = '\0';
        }
        value->count_pattern = value->count_pattern + 1;
      }
    }
    if (file != NULL) fclose(file);
  } else {
    fprintf(stderr, "grep: %s: No such file or directory\n", path);
    flag = 1;
  }
  return flag;
}

int process_files(int argc, char **argv, int opt_ind, char patterns[SIZE][SIZE],
                  grep_values value, flags option) {
  int file_location = find_pattern(opt_ind, argv, patterns);
  while (file_location < argc) {
    if (argv[file_location + 1] != NULL)
      value.count_files = value.count_files + 1;
    value.path = argv[file_location];
    if (!flags_realisation(value, option, patterns))
      file_location++;
    else {
      file_location = 128;
    }
  }
  return file_location;
}

int find_pattern(int opt_ind, char **argv, char patterns[SIZE][SIZE]) {
  int file_location = 0;
  if (*patterns[0] == 0) {
    file_location = opt_ind + 1;
    strcpy(patterns[0], argv[optind]);
  } else
    file_location = opt_ind;
  return file_location;
}

int flags_realisation(grep_values value, flags flag, char pattern[SIZE][SIZE]) {
  int comp_flag = REG_EXTENDED, error = 0;
  if (flag.v || flag.c || flag.l) flag.o = false;
  if (check_file_access(value, flag)) {
    FILE *file = fopen(value.path, "r");
    if (file) {
      int exit_l = 0;
      process_file_contents(file, value, flag, pattern, comp_flag, exit_l);
      fclose(file);
    }
  } else if (!flag.s) {
    fprintf(stderr, "grep: %s: No such file or directory\n", value.path);
    error = 1;
  }
  return error;
}

int check_file_access(grep_values value, flags flag) {
  int result = 0;
  if (access(value.path, F_OK) == 0)
    result = 1;
  else if (!flag.s)
    result = 0;
  return result;
}

void process_file_contents(FILE *file, grep_values value, flags flag,
                           const char pattern[SIZE][SIZE], int comp_flag,
                           int exit_l) {
  int count_lines = 0, count_match_lines = 0;
  char str[SIZE];
  regex_t compiled;
  if (value.count_pattern == 0 && !flag.e && !flag.f) value.count_pattern = 1;
  if (flag.i) comp_flag = REG_ICASE;
  while (fgets(str, SIZE, file) && (exit_l == 0)) {
    int findline = 0, pattern_no_match = 0;
    count_lines++;
    if (strchr(str, '\n') == NULL) strcat(str, "\n");
    for (int i = 0; i < value.count_pattern; i++) {
      int match = 0, resultRegex = 0;
      if (regcomp(&compiled, pattern[i], comp_flag | REG_NEWLINE)) {
        fprintf(stderr, "grep: brackets ([ ]) not balanced\n");
        regfree(&compiled);
        exit_l = -1;
      }
      resultRegex = regexec(&compiled, str, 0, NULL, 0);
      if (resultRegex == 0 && !flag.v) match = 1;
      if (resultRegex == REG_NOMATCH && flag.v) {
        pattern_no_match++;
        if (pattern_no_match == value.count_pattern) match = 1;
      }
      if (flag.l && match == 1 && !flag.c) {
        printf("%s\n", value.path);
        match = 0;
        exit_l = 1;
      }
      if (flag.c == 1 && match == 1) {
        count_match_lines++;
        match = 0;
      }
      if (findline == 0 && match == 1) {
        nh_flags(value, flag, count_lines, str);
        findline++;
      }
      if (flag.o) o_flag(str, compiled);
      regfree(&compiled);
    }
  }
  if (flag.c) cl_flags(value, flag, count_match_lines);
}

void nh_flags(grep_values value, flags flag, int count_lines, const char *str) {
  if (value.count_files >= 1 && !flag.h) printf("%s:", value.path);
  if (flag.n) printf("%d:", count_lines);
  if (!flag.o) printf("%s", str);
}

void o_flag(char *str, regex_t compiled) {
  regmatch_t pmatch[1];
  while (regexec(&compiled, str, 1, pmatch, 0) == 0) {
    for (int i = 0; i < pmatch->rm_eo; i++) {
      if (i >= pmatch->rm_so) printf("%c", str[i]);
      str[i] = 127;
    }
    printf("\n");
  }
}

void cl_flags(grep_values value, flags flag, int count_matched_lines) {
  if (value.count_files >= 1 && !flag.h) printf("%s:", value.path);
  if (!flag.l)
    printf("%d\n", count_matched_lines);
  else {
    if (count_matched_lines > 0) {
      printf("1\n");
      printf("%s\n", value.path);
    } else
      printf("0\n");
  }
}