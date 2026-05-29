#include <stdio.h>

int recurse(int input) {
	printf("Value: %d\n", input);
	recurse(input + 1);
}

int main() {
	recurse(0);
	return 0;
}

