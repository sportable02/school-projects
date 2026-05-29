#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char **argv) {
	if(argc == 1) {
		exit(1);
	}
	pid_t pid;
	int count = atoi(argv[1]);

	for(int i = 0;i < 5;i++) {

		pid = fork();

		if(pid < 0) {
			exit(1);
		}
		if(pid == 0) {
			//turn count into ascii string
			char countStr[] = {48 + count + 1 + i, 0};
			char *args[] = {"lab19", countStr, NULL};
			execvp(argv[0], args);
		} else {
			int status;
			waitpid(pid, &status, 0);

			printf("count %s\tpid %llu\n", argv[1], pid);
		}

	}
	//printf("count %s\n", argv[1]);
	//for(int i = 0; i < 3; i++) {
	//	fork();
	//	int count = atoi(argv[1]);
	//	execvp("lab19", args);
	//	printf("count %s\n", argv[1]);
	//}

	return 0;
}
