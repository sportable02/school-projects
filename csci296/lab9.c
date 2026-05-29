#include <stdio.h>
#include <stdlib.h>

int main() {
	int ALLOC_SIZE = -1;

	do {
		printf("Enter size: \n");
		scanf("%d", &ALLOC_SIZE);
	} while (ALLOC_SIZE < 1);

	char *buf = malloc(ALLOC_SIZE);
	char *pOriginal = buf;
	printf("First address: %p\n", buf);
	for(int i = 0;i<1000;i++) {
		buf = malloc(ALLOC_SIZE);	
	}
	printf("Last address: %p\n", buf);
	printf("Difference (hex): %x, (dec): %d\n", buf - pOriginal, buf - pOriginal);
}
