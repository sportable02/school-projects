#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <pwd.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <limits.h>
#include <time.h>

#define BUFSIZE 4096

//filter for scandir to omit hidden files
int filter(const struct dirent *a) {
	return strncmp(a->d_name, ".", 1);
}

//create a directory if it doesn't exist
void create_dir_if_missing(char * path) {
	struct stat path_stat;
	if((stat(path, &path_stat) == -1 || !S_ISDIR(path_stat.st_mode)) && mkdir(path, 0755) == -1) {
		fprintf(stderr, "Error: failed to create %s: %s\n", path, strerror(errno));
		exit(EXIT_FAILURE);
	}
}

//search a directory for an entry with a matching name
int search_entries(struct dirent ** s_ent, int num_entries, char * name) {
	int is_found = 0;
	for(int i = 0; i < num_entries; i++)
		if(!strcmp(s_ent[i]->d_name, name)) is_found = 1;
	return is_found;
}

//display all entries inside a directory
void display_entries(char * path, struct dirent ** entries, int num_entries) {

	printf("Files in %s\n", path);
	for(int i = 0; i < strlen(path) + 10;i++) putchar('-');
	putchar('\n');

	for(int i = 0; i < num_entries; i++) {
		struct stat curr_stat;

		//make the path of the entry (critical)
		int ent_path_len = strlen(path) + strlen(entries[i]->d_name) + 2;
		char ent_path[ent_path_len];
		ent_path[ent_path_len - 1] = '\0';
		strcpy(ent_path, path);
		strcat(ent_path, "/");
		strcat(ent_path, entries[i]->d_name);

		if(stat(ent_path, &curr_stat) == -1)
			fprintf(stderr, "Error: could not retrieve stats for %s: %s\n", ent_path, strerror(errno));
		else
		printf("%-50s%10d\t%s", entries[i]->d_name, curr_stat.st_size, ctime(&curr_stat.st_mtim.tv_sec));
	}

	for(int i = 0; i < strlen(path) + 10; i++) putchar('-');
	putchar('\n');
}

//copy file from src to dst path
void copy_file(char * src, char * dst) {
	int src_fd, dst_fd;
	if((src_fd = open(src, O_RDONLY)) == -1) {
		fprintf(stderr, "Error: could not open %s for reading: %s\n", src, strerror(errno));
	} else {
		struct stat src_stat;
		if(fstat(src_fd, &src_stat) == -1) {
			fprintf(stderr, "Error: stats of %s could not be retrieved: %s", src, strerror(errno));
		} else {
			mode_t dst_mode = src_stat.st_mode & (S_IRWXU | S_IRWXG | S_IRWXO);
			if((dst_fd = creat(dst, dst_mode)) == -1) {
				fprintf(stderr, "Error: could not create %s: %s\n", dst, strerror(errno));
			} else {
				int n_chars;
				char buf[BUFSIZE];
				while((n_chars = read(src_fd, buf, BUFSIZE)) > 0)
					if(write(dst_fd, buf, n_chars) != n_chars)
						fprintf(stderr, "Error: failed to write to %s: %s\n", dst, strerror(errno));

				if(n_chars == -1)
					fprintf(stderr, "Error: failed to read from %s: %s\n", src, strerror(errno));
			}
			if(close(src_fd) == -1 || close(dst_fd) == -1)
				perror("Error: could not close files");
		}
	}
}

int main(int argc, char **argv) {
	//invalid command
	if(argc < 3) {
		fprintf(stderr, "Error: too few arguments: Expects mysubmit <course_name> <assignment_name>\n");
		exit(EXIT_FAILURE);
	}

	//verify class directory exists, otherwise create it
	int class_path_len = strlen(argv[1]) + 3;
	char class_path[class_path_len];
	class_path[class_path_len - 1] = '\0';
	strcpy(class_path, "./");
	strcat(class_path, argv[1]);
	create_dir_if_missing(class_path);

	//verify user directory exists, otherwise create it
	uid_t user_id;
	if((user_id = getuid()) == -1) {
		perror("Error: user id could not be retrieved");
		exit(EXIT_FAILURE);
	}

	struct passwd *user_info;
	if((user_info = getpwuid(user_id)) == NULL) {
		perror("Error: could not retrieve user name");
		exit(EXIT_FAILURE);
	}

	int user_path_len = strlen(class_path) + strlen(user_info->pw_name) + 2;
	char user_path[user_path_len];
	user_path[user_path_len - 1] = '\0';
	strcpy(user_path, class_path);
	strcat(user_path, "/");
	strcat(user_path, user_info->pw_name);
	create_dir_if_missing(user_path);

	//verify assignment directory exists, otherwise create it
	int full_path_len = strlen(user_path) + strlen(argv[2]) + 2;
	char full_path[full_path_len];
	full_path[full_path_len - 1] = '\0';
	strcpy(full_path, user_path);
	strcat(full_path, "/");
	strcat(full_path, argv[2]);
	create_dir_if_missing(full_path);

	//display entries for the current folder
	struct dirent **curr_entries;
	int entries;
	if((entries = scandir(".", &curr_entries, filter, alphasort)) == -1) {
		perror("Directory scan failed");
		exit(EXIT_FAILURE);
	}
	char curr_dir[PATH_MAX];
	getcwd(curr_dir, PATH_MAX);
	display_entries(curr_dir, curr_entries, entries);


	//ask user for file names to add to submission folder
	char in_file [NAME_MAX];
	do {
		//ask user for file name
		printf("Enter a file to submit (q to quit): ");
		scanf("%s", &in_file);

		//try to submit all files if user entered *
		if(!strcmp(in_file, "*")) {
			for(int i = 0; i < entries; i++) {
				//prepare out file name
				int out_file_len = strlen(full_path) + strlen(curr_entries[i]->d_name) + 2;
				char out_file[out_file_len];
				out_file[out_file_len - 1] = '\0';
				strcpy(out_file, full_path);
				strcat(out_file, "/");
				strcat(out_file, curr_entries[i]->d_name);

				copy_file(curr_entries[i]->d_name, out_file);
			}

		//try to submit specific file if user entered anything other than q
		} else if (strcmp(in_file, "q")) {
			if(search_entries(curr_entries, entries, in_file)) {
				//prepare out file name
				int out_file_len = strlen(full_path) + strlen(in_file) + 2;
				char out_file[out_file_len];
				out_file[out_file_len - 1] = '\0';
				strcpy(out_file, full_path);
				strcat(out_file, "/");
				strcat(out_file, in_file);

				copy_file(in_file, out_file);
			} else
				fprintf(stderr, "%s could not be submitted: File not found\n", in_file);
		}
	//quit asking the user for a file name to submit when they enter q
	} while (strcmp(in_file, "q"));
	putchar('\n');

	//display entries for the submission folder
	struct dirent **sub_dir_entries;
	int sub_entries;
	if((sub_entries = scandir(full_path, &sub_dir_entries, filter, alphasort)) == -1) {
		perror("Directory scan failed");
		exit(EXIT_FAILURE);
	}
	display_entries(full_path, sub_dir_entries, sub_entries);

	//everything went right!
	exit(EXIT_SUCCESS);
}
