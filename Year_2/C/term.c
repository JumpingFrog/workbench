#include <fcntl.h> //our lone import

#define STDIN  0
#define STDOUT 1
#define ERROUT 2

int str_len(char * str) {
	int len = -1;
	while (*str++ != '\0') {
		len++;	
	}
	return len;
}

void printStr(char * str) {
	write(STDOUT, str, (1 + str_len(str)));
}

void printInt(int in) {
}

int strcmp(char * str1, char * str2) {
	while(*str1 != '\0' || *str2 != '\0') {
		if (*str1 == *str2) {
			*str1++;
			*str2++;		
		}
		else {
			return 0;		
		}	
	}
	return 1;	
}

void str_cat(char * str1, char * str2) {
	while (*str1 != '\0') {
		*str1++;	
	}
	while (*str2 != '\0') {
		*str1++ = *str2;
		*str2++;
	}
	*str1++ = '\0';
	
}

int str_start(char * match, char * str) { //returns 1 if str starts with match
	int c;
	for (c = 0; c <= str_len(match); c++) {
		if (match[c] != str[c]) {
			return 0;
		}
	}
	return 1;
}

int readln(char * buf, int len) {
	int read_len = read(STDIN, buf, (len - 1)) - 1;
	buf[read_len] = '\0';
	return read_len++;
}

void str_tok(char tok, char * in, char * buf) {
	int c;
	int found = 0;
	for (c = 0; c <= str_len(in); c++) {
		if (found) {
			*buf = in[c];
			*buf++;
		}
		else if (tok == in[c]) {
			found = 1;
		}
	}
	*buf = '\0';
}

void clearbuf(char * buf, int len) {
	int c;
	for  (c = 0; c < len; c++) {
		buf[c] = '\0';
	}
}

void ccp(char * in) { //command processor
	char static buf2[200];
	if (strcmp("help", in)) {
		printStr("Valid commands are:\n\tmkfile <fiename> : creates a new file.\n\tcat <filename> : prints output of file.\n\t>> <filename> <text> : writes text to the file (overwrites).\n\trm <filename> : deletes the file.\n\t./ <program> : executes the program.\n");	
	}
	else if (str_start("mkfile ", in)) {
		str_tok(' ', in, buf2);
		creat(buf2, O_CREAT);
		str_cat(buf2, " created.\n");
		printStr(buf2);
		buf2[0] = '\0';
	}
	else if (str_start(">> ", in)) {
		char fname[128];
		str_tok(' ', in, buf2);
		int c;
		for (c = 0; c < 128; c++) {
			if (buf2[c] == ' ') {
				fname[c] = '\0';
				break;
			}
			else {
				fname[c] = buf2[c];
			}
		}
		c++;
		int fd = open(fname, O_WRONLY);
		if (fd < 0) {
			printStr("Error writing to file. Check the file exists.\n");
		}
		else {
			write(fd, &buf2[c], (str_len(&buf2[c])+1));
			printStr("File written.\n");
			buf2[0] = '\0';
			close(fd);
		}
	}
	else if (str_start("cat ", in)) {
		str_tok(' ', in, buf2);
		int fd = open(buf2, O_RDONLY);
		if (fd < 0 ) {
			printStr("Error opening file. Check the file exists.\n");
		}
		else {
			clearbuf(buf2, 200);
			while (read(fd, buf2, 200) != 0) {
				printStr(buf2); 
			}
			buf2[0] = '\0';
			printStr("\n");
			close(fd);
		}
		
	}
	else if (str_start("rm ", in)) {
		str_tok(' ', in , buf2);
		if (unlink(buf2) == 0) {
			printStr("File deteled successfully.\n");
		}
		else {
			printStr("File could not be deleted.\n");
		}	
		buf2[0] = '\0';
	}
	else if (str_start("./ ", in)) {
		str_tok(' ', in, buf2);
		int pid = fork();
		if (pid == 0) {
			execl(buf2, "\0",  0L);
		}
		else {
			wait(); //wait for child to finish.
		}
		printStr("\n");
		buf2[0] = '\0';
	}	
	else if (strcmp("exit", in)) {
		exit(0);
	}
	else {
		str_cat(buf2, in);
		str_cat(buf2, ": is not a recognised command, try typing 'help'.\n"); 
		printStr(buf2);
		buf2[0] = '\0'; //make buf2 look empty	
	}
}


int main(void) {
	printStr("Type 'help' for information on commands.\n");
	char buf[128];
	while (1) {
		printStr("> ");
		readln(buf, 128);
		ccp(buf);
	}
}
