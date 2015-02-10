#include <stdio.h>
 
int main(int argc, char *argv[]) {
	char buf[128];
	printf("%p\n", &buf);
	puts("What is your name?");
	gets(buf);
	printf("Hello, %s!\n\r", buf);
	return 0;
}
