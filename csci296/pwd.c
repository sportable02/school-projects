#include <pwd.h>
#include <stdio.h>

int main() {
	struct passwd *passwd = getpwnam("sportable");
	printf("%s\n", passwd->pw_dir);
}
