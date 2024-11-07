#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include <string.h>
#include <signal.h>
#include <sys/wait.h>

#define DEBUG 1
#define MAX_PATH_SIZE 300

int main(int argc, char **argv)
{
    int i = 0;
    int k = 0;
    int while_cond = 1;
    int exit_status;
    int pid_status;
    int ppid_status;
    int pwd_status;
    int cd_status;
    int ls_status;
    int status;
    char *input = NULL;
    int bg_flag;
    char *prompt = "308sh> ";
    char *token;
    char *split_list[MAX_PATH_SIZE];
    size_t size = 0;
    int child;
    int child1;

    int l = 0;
    int j = 0;

    // printf("Option %d is \"%s\"\n", i, argv[i]);

    if (argc == 3)
    {

        if ((strlen(argv[1]) != 2) || (strncmp("-p", argv[1], 2) != 0))
        {
            printf("Invalid command. Exiting.\n");
            return 0;
        }
        prompt = argv[2];
    }

    while (while_cond)
    {
        printf("%s", prompt);
        getline(&input, &size, stdin);
        input[strcspn(input, "\n")] = 0;
        char last_char = input[strlen(input) - 1];

        if (DEBUG)
            printf("Inp is: '%s' \n", input);
        if (DEBUG)
            printf("Last element: %d \n", last_char);
        if (DEBUG)
            printf("Number for &: %d \n", '&');
        // -----------Built-in commands-------------------------------
        exit_status = strcmp(input, "exit");
        if (exit_status == 0)
        {
            while_cond = 0;
        }
        else if (strcmp(input, "") == 0)
        {
            printf("");
        }
        else if (strcmp(input, "pid") == 0)
        {
            printf("PID: %d \n", getpid());
        }
        else if (strcmp(input, "ppid") == 0)
        {
            printf("PPID: %d \n", getppid());
        }
        else if (strcmp(input, "pwd") == 0)
        {
            printf("%s\n", getcwd(NULL, 0));
        }
        //cd with an input
        else if (strstr(input, "cd ") && strlen(input) > 3)
        {
            char *dir = &input[3];
            chdir(dir);
        }
        // change directory to home
        else if (strcmp(input, "cd") == 0)
        {
            chdir(getenv("HOME"));
            if (DEBUG)
                printf("%s\n", getcwd(NULL, 0));
        }

        // --------------------program commands---------------
        else
        {
            //split input seperated by whitespace and store it in an array
            char *token = strtok(input, " ");
            while (token != NULL && i < MAX_PATH_SIZE)
            {
                split_list[i] = token;
                token = strtok(NULL, " ");
                i++;
            }
            // check if background or not
            if (i >= MAX_PATH_SIZE)
            {
                bg_flag = -1;
            }
            else if (last_char == '&') // last_char == '&' == 38
            {
                split_list[i - 1] = "";
                // set background flag true
                bg_flag = 1;
                split_list[i - 1] = NULL;
            }
            else
            {
                // set background flag false
                split_list[i] = NULL;
                bg_flag = 0;
            }
            if (DEBUG)
                printf("bg_flag: %d \n", bg_flag);

            //-------------if background process---------------------
            if (bg_flag == 1)
            {
                // create another fork, so that it can run in the background
                bg_flag = 0;
                child1 = fork();

                if (child1 == 0)
                {

                    child = fork();
                    char *argument_list[] = {split_list[0], split_list[1], NULL};
                    i = 0;
                    if (child == 0)
                    {
                        printf("[%d] %s \n", getpid(), argument_list[0]);
                        int status_code = execvp(argument_list[0], argument_list);

                        split_list[0] = NULL;
                        split_list[1] = NULL;

                        if (status_code == -1)
                        {
                            printf("Invalid command!\n");
                            return 1;
                        }
                    }
                    //parent process
                    else
                    {
                        usleep(1000);
                        status = -1;
                        waitpid(-1, &status, 0);
                        printf("\n[%d] %s Exit %d \n", getpid(), argument_list[0], WEXITSTATUS(status));
                    }
                }

                else
                {
                    usleep(1000);
                }
            }

            // -----------normal built-in command without background process------------
            else
            {
                child = fork();
                // sets 0th and 1st element of the input
                char *argument_list[] = {split_list[0], split_list[1], NULL};
                i = 0;

                if (child == 0)
                {
                    if (DEBUG)
                        printf("split_list_0: %s \n", split_list[0]);
                    if (DEBUG)
                        printf("split_list_1: %s \n", split_list[1]);
                    if (DEBUG)
                        printf("argument_list_0: %s \n", argument_list[0]);
                    printf("[%d] %s \n", getpid(), argument_list[0]);
                    //this lien is what executes the built-in commands
                    int status_code = execvp(argument_list[0], argument_list);

                    split_list[0] = NULL;
                    split_list[1] = NULL;

                    if (status_code == -1)
                    {
                        printf("Cannot exec %s: No such file or directory \n", input);
                        return 1;
                    }
                }
                //parent process
                else
                {
                    usleep(1000);
                    status = -1;
                    waitpid(-1, &status, 0);
                    printf("[%d] %s Exit %d \n", getpid(), argument_list[0], WEXITSTATUS(status));
                }
            }
        }
    }
    // -----------------------------------------------------------

    free(input);

    return 0;
}
