#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>

static void sig_handler(int signo) {
	printf("lab22p1 received SIGALRM %d\n", signo);
}

int main(int argc, char **argv) {

	if(argc == 1) {
		fprintf(stderr, "No file path provided\n");
		exit(1);
	}

	int fd;
	if((fd = open(argv[1], O_WRONLY)) == -1) {
		fprintf(stderr, "Could not open %s\n", argv[1]);
		perror("");
		exit(1);
	}
	printf("lab22p1 opened %s with fd: %d\n", argv[1], fd);

	lseek(fd, 5, SEEK_SET);
	signal(SIGALRM, sig_handler);
	alarm(15);
	pause();


	//release data and exit
	printf("Ending lab22p1\n");
	close(fd);
	exit(0);
}
