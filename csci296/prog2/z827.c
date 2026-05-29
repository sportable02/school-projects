#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>

int main(int argc, char **argv) {
	//Check if any arguments
	if(argc == 1) {
		fprintf(stderr, "Error: no file path provided\n"); 
		exit(1);
	}

	//Check file exists
	int fd;
	if((fd = open(argv[1], O_RDONLY)) == -1) {
		fprintf(stderr, "Error: %s", argv[1]);
		perror(" could not be opened");
		exit(1);
	}
	printf("%s successfully opened\n", argv[1]);

	//File stats
	struct stat in_file_stats;
	if(stat(argv[1], &in_file_stats) == -1) {
		fprintf(stderr, "Error: %s", argv[1]);
		perror("'s stats could not be retrieved");
		exit(1);
	}
	off_t buf_size = in_file_stats.st_size;
	char * buffer = (char *) malloc(buf_size);

	//Read input file
	if(read(fd, buffer, buf_size) == -1) {
		fprintf(stderr, "Error: %s", argv[1]);
		perror(" could not be read");
		exit(1);
	}
	printf("%s successfully read\n", argv[1], buffer);

	//delete input file
	close(fd);
	if(unlink(argv[1]) == -1) {
		fprintf(stderr, "Error: could not delete %s\n", argv[1]);
		exit(1);
	}
	printf("%s successfully deleted\n", argv[1]);

	//Create name for output file
	char * out_file = (char *) malloc(sizeof(argv[1]) + 6);
	strcpy(out_file, argv[1]);
	strcat(out_file, ".z827");

	//Create output file based on input file
	mode_t out_perm = in_file_stats.st_mode & (S_IRWXU | S_IRWXG | S_IRWXO);
	int out_fd;
	if((out_fd = creat(out_file, out_perm)) == -1) {
		fprintf(stderr, "Error: %s", out_file);
		perror(" could not be created");
		exit(1);
	}
	printf("%s successfully created\n", out_file);

	//write initial file size to output file first
	if(write(out_fd, &buf_size, 4) == -1) {
		fprintf(stderr, "Error: %s", out_file);
		perror(" could not be written to");
		exit(1);
	}

	//Write to output file
	unsigned int totalOut = 0;	//write buffer for 32 bits per write
	int index = 0;			//input buffer char index
	int totalIndex = 1;		//# of buffers written
	int total_bits_left = 32;	//# of bits left to fill in the write buffer
	int shift_amt = 0;		//location in write buffer to add data to
	while(index < buf_size) {
		unsigned char thisChar = buffer[index];

		//file cannot be compressed if the character has a 1 in the leftmost bit
		if((thisChar & 0x80) > 0) {
			fprintf(stderr, "Error: %s could not be compressed\n", out_file);
			exit(1);
		}

		totalOut |= thisChar << shift_amt;
		if(total_bits_left <= 7) {
			//move write position
			lseek(out_fd, totalIndex++ * 4, SEEK_SET);
			//write buffer
			if(write(out_fd, &totalOut, 4) == -1) {
				fprintf(stderr, "Error: %s", out_file);
				perror(" could not be written to");
				exit(1);
			}
			//clear int write buffer
			totalOut = 0;
			//add new fragment at beginning of next write buffer
			//(split char between buffers)
			shift_amt = 7 - total_bits_left;
			totalOut |= thisChar >> total_bits_left;
			total_bits_left = 32 - shift_amt;
		} else {
			shift_amt += 7;
			total_bits_left -= 7;

			//figure out how many bytes we actually need to write
			// (gets rid of null bytes)
			int totalBytes = 4;
			while(totalBytes > 0 && (totalOut >> ((totalBytes - 1) * 8)) <= 0)
				totalBytes--;

			//the last input buffer character will likely need to be written
			//while the output buffer is partially filled
			if(index == buf_size - 1) {
				lseek(out_fd, totalIndex * 4, SEEK_SET);
				if(write(out_fd, &totalOut, totalBytes) == -1) {
					fprintf(stderr, "Error: %s", out_file);
					perror(" could not be written to");
					exit(1);
				}
			}
		}
		index++;
	}
	printf("%s successfully written to\n", out_file);

	//release any data used
	free(buffer);
	free(out_file);
	exit(0);
}
