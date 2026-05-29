#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int comp(const void *strA, const void *strB) {
		return strlen(*(char**)strA) - strlen(*(char**)strB);
}

int main(int argc, char **argv) {
	char **argStrings = calloc(argc - 1, sizeof(argv[0]));
	for(int i = 0; i < argc - 1;i++) {
		argStrings[i] = argv[i+1];
	}

	qsort(argStrings, argc - 1, sizeof(argStrings[0]), comp);

	for(int i = 0;i < argc - 1;i++) {
		if(i < argc - 2)
			printf("%s ", argStrings[i]);
		else
			printf("%s\n", argStrings[i]);
	}	
	return 0;
}
