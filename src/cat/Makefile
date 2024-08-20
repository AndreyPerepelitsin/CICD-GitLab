CC = gcc
FLAGS = -Wall -Werror -Wextra -std=c11

all: clean s21_cat test

s21_cat:
	$(CC) $(FLAGS) s21_cat.c -o s21_cat

test:
	bash test_cat.sh

style:
	clang-format -style=Google -n *.c *.h
	clang-format -style=Google -i *.c *.h

leaks:
	leaks -atExit -- ./s21_cat -e -e
	leaks -atExit -- ./s21_cat -ev ./test.txt
	leaks -atExit -- ./s21_cat -v ./test.txt

check: test
	cppcheck --enable=all --suppress=missingIncludeSystem --inconclusive --library=posix *.c *.h

clean:
	rm -rf s21_cat *.o report_cat.info

rebuild:
	make clean
	make all
	rm -rf  *.o *.a