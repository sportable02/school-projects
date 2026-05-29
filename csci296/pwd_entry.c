#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

#define BUFSIZE 100

char buf[BUFSIZE];
char *get_passwd();
struct termios orig_attr;

int main() {
	struct termios input_attr;

	tcgetattr(0, &orig_attr);

	tcgetattr(0, &input_attr);
	input_attr.c_lflag &= ~ECHO;
	input_attr.c_lflag &= ~ICANON;
	input_attr.c_cc[VMIN] = 1;
	tcsetattr(0, TCSANOW, &input_attr);
	
	printf("enter password: ");
	char *passwd = get_passwd();
	printf("You entered: %s\n", passwd);

	tcsetattr(0, TCSANOW, &orig_attr);
	return 0;
}


char *get_passwd() {
	int c, len;
	for(len = 0; len < BUFSIZE && (c = getchar()) != EOF && c != '\n'; len++) {
		buf[len] = c;
		putchar('*');	
	}
	buf[len] = 0;
	putchar('\n');
	return buf;
}
