#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

// rm ./beep && gcc -o beep ./scripts/beep.c && chmod +x ./beep
int main(int argc, char *argv[]) {
    printf("beep🚨 v0.1.0\n");
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <interval_seconds> command [args...]\n", argv[0]);
        return 1;
    };

    int span = atoi(argv[1]);
    if (span <= 0) {
        fprintf(stderr, "Invalid interval. Must be a positive integer.\n");
        return 1;
    };

    while (1) {
        pid_t pid = fork();
        if (pid == 0) { // Child process
            execvp(argv[2], &argv[2]);
            perror("execvp failed");
            exit(1);
        } else if (pid > 0) { // Parent process
            wait(NULL); // Wait for child
            sleep(span);
        } else {
            perror("fork failed");
            return 1;
        }
    }

    return 0;
}