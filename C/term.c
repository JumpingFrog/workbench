#define STDIN 0
#define STDOUT 1
#define ERROUT 2

void printStr(char * str) {
	char * temp = str;
	int len = 0;
	while (*temp++ != '\0') {
		len++;	
	}
	write(STDOUT, str, len);
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

int readln(char * buf, int len) {
	int read_len = read(STDIN, buf, (len - 1)) - 1;
	buf[read_len] = '\0';
	return read_len++;
}

void ccp(char * in) {
	if (strcmp("help", in)) {
		printStr(in);
		printStr("Here is some help.\n");	
	}
	else {
		char buf[200];
		str_cat(buf, ": is not a recognised command, try typing 'help'.\n"); 
		printStr(buf);	
	}
}


int main(void) {
	printStr("Type 'help' for information on commands.\n");
	char buf[128];
	while (1) {
	readln(buf, 128);
	ccp(buf);
	}
}



