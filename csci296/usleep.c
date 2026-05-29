#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/errno.h>

int main() {
	int fileNum;
	if((fileNum = open("out.txt", O_CREAT | O_WRONLY)) == -1) {
		perror("Error opening file");
		exit(1);
	}
	
	for(int i = 0;;i++) {
		char buf[] = "ASCII Character: _\n";
		buf[17] = i; 
		if(write(fileNum, buf, sizeof(buf)) == -1) {
			perror("Error writing to file");
			exit(1);
		}
		usleep(1000);
	}
}
