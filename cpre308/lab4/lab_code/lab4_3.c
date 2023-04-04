#include <signal.h>
// #include <stdio.h>
void catch_zero();
int main()
{
    int a = 4;
    signal(SIGFPE,catch_zero);
    a = a/0;
    printf("Result: %d",a);
    return 0;
}

void catch_zero()
{
    printf("Caught a SIGFPE \n");
    exit(1);
}