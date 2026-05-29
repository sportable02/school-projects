#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>	
//#include <time.h>

void timer_handler(int signum) {
	struct timeval tp;
	int result = gettimeofday(&tp, NULL);
	printf("%d microseconds\n", tp.tv_usec);
}

int main() {
	signal(SIGALRM, timer_handler);
	
	struct itimerval timer;
	timer.it_interval.tv_sec = 0;
	timer.it_interval.tv_usec = 1000;

	timer.it_value.tv_sec = 0;
	timer.it_value.tv_usec = 1000;

	if(setitimer(ITIMER_REAL, &timer, NULL) == -1) {
		perror("setitimer failed");
		return 1;
	}

	for(int i = 0; i < 10; i++) {
		pause();
	}

	return 0;
}
