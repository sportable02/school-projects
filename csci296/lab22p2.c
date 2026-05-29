#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <fcntl.h>

static void sig_handler(int signo) {
	printf("lab22p2.c received SIGALRM %d\n", signo);
}

int main(int argc, char **argv) {

	if(argc == 1) {
		fprintf(stderr, "No file descriptor provided\n");
		exit(1);
	}

	int fd = atoi(argv[1]);
	printf("lab22p2 ready with fd: %d\n", fd);

	char *write_buf = "INSERTED LINE\n";
	int write_buf_size = 15;

	if(write(fd, write_buf, write_buf_size) != write_buf_size) {
		fprintf(stderr, "Failed to write\n", argv[1]);
		perror("");
		exit(1);
	}

	//release data and exit
	exit(0);
}
