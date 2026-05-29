#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAB_FLAG "-t"

int main(int argc, char **argv) {
	//default tab size
	int tab_size = 8;

	if(argc > 3) {
		fprintf(stderr, "Too many arguments\n");
		exit(1);
	} else if(argc == 3) {
		if(strcmp(argv[1], TAB_FLAG) != 0) {
			fprintf(stderr, "Unrecognized flag %s\n", argv[1]);
			exit(1);
		}  
		if((tab_size = atoi(argv[2])) < 0) {
			fprintf(stderr, "Invalid 2nd argument, cannot be negative\n");
			exit(1);
		}
	} else if(argc == 2) {
		if(strcmp(argv[1], TAB_FLAG) == 0) {
			fprintf(stderr, "No tab size provided\n");
			exit(1);
		} else {
			fprintf(stderr, "Incorrect number of arguments\n");
			exit(1);
		}
	} else if(argc < 1) {
		fprintf(stderr, "Too few arguments\n");
		exit(1);
	}
	
	int c;
	int chars_in_width = 0;
	while((c = getchar()) != EOF) {
		if(c == '\t') {
			int num_spaces = tab_size - (chars_in_width % tab_size);
			for(int i = 0;i < num_spaces;i++)
				putchar(' ');
			chars_in_width = 0;
		} else {
			if(c == '\n') chars_in_width = 0;
			else chars_in_width++;
			
			if(putchar(c) == EOF) {
				fprintf(stderr, "Error writing to file\n");
				exit(1);
			}
		}
	}

	exit(0);
}
