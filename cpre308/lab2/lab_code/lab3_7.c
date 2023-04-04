#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void main() {
execl("/bin/lsl", "ls", NULL);
printf("What happened?\n");
}
