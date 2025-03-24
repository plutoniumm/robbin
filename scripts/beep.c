#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s [--span SECONDS] command [args...]\n", argv[0]);
        return 1;
    }

    int span = 1;
    int cmd_start = 1;

    // Check if --span is specified
    if (argc > 2 && strcmp(argv[1], "--span") == 0) {
        span = atoi(argv[2]);
        if (span <= 0) {
            fprintf(stderr, "Invalid span value. Must be a positive integer.\n");
            return 1;
        }
        cmd_start = 3;
    }

    if (cmd_start >= argc) {
        fprintf(stderr, "No command provided to execute.\n");
        return 1;
    }

    while (1) {
        pid_t pid = fork();
        if (pid == 0) { // Child process
            execvp(argv[cmd_start], &argv[cmd_start]);
            perror("execvp failed");
            exit(1);
        } else if (pid > 0) { // Parent process
            wait(NULL); // Wait for child to finish
            sleep(span);
        } else {
            perror("fork failed");
            return 1;
        }
    }
    return 0;
}

