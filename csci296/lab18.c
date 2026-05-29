#include <stdio.h>
#include <unistd.h>

int main() {
	int count = 1;
	printf("count: %d\tpid: %llu\n", count, getpid());

	for(int i = 0; i < 4; i++) {
		count++;
		fork();
		printf("count: %d\tpid: %llu\n", count, getpid());
	}

	return 0;
}
