CFLAGS=-Wall -Wextra -Wpedantic -O0
CC=clang

all: ex1
	@echo "Carafe application built..."

ex1:
	clang ex1.c -lpthread -Wall -Wextra -pedantic -O3 -o ex1

ex2:
	clang ex2.c -lpthread -Wall -Wextra -pedantic -O0 -o ex2

ex3:
	clang ex3.c -lpthread -Wall -Wextra -pedantic -O2 -o ex3

clean:
	rm -f *.out
	rm -f *.o
