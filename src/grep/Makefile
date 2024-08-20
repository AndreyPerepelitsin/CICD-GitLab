CC = gcc
FLAGS = -Wall -Werror -Wextra -std=c11

all: clean s21_grep test

s21_grep:
	$(CC) $(FLAGS) s21_grep.c -o s21_grep

test:
	bash test_grep.sh

style:
	clang-format -style=Google -n *.c *.h
	clang-format -style=Google -i *.c *.h

leaks:
	leaks -atExit -- ./s21_grep -f patterns.txt ./s21_grep.c
	leaks -atExit -- ./s21_grep -f patterns.tt ./s21_grep.c
	leaks -atExit -- ./s21_grep -f patterns.txt ./s21_grep.
	leaks -atExit -- ./s21_grep -e -e
	leaks -atExit -- ./s21_grep -e "case" -e "[0-9]" ./s21_grep.c

check: test
	cppcheck --enable=all --suppress=missingIncludeSystem --inconclusive --library=posix *.c *.h

clean:
	rm -rf s21_grep *.o

rebuild:
	make clean
	make all
	rm -rf *.o *.a