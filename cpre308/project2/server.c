#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <math.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include "Bank.c"
#include <pthread.h>

#define MAX_PATH_SIZE 300
#define MAX_TRANSACTIONS 10
#define CHECK_0 0
#define TRANS_1 1
#define END_2 2

/*********** defining functions *********/

/********** global variables begin *******/
pthread_mutex_t *acc_mut;
pthread_mutex_t *file_mut;
// pthread_cond_t bal_thread;

/******* Structs ******/
typedef struct trans
{               // structure for a transaction pair
    int acc_id; // account ID
    int amount; // amount to be added, could be positive or negative
} trans;

typedef struct request
{
    struct request *next;              // pointer to the next request in the list
    int request_id;                    // request ID assigned by the main thread
    int check_acc_id;                  // account ID for a CHECK request
    int request_type;                  // tells if check, trans or end
    struct trans *transactions;        // array of transaction data
    int num_trans;                     // number of accounts in this transaction
    struct timeval starttime, endtime; // starttime and endtime for TIME
} Request;

typedef struct queue
{
    struct request *head, *tail; // head and tail of the list
    int num_jobs;                // number of jobs currently in queue
} Queue;

/*********** defining functions *********/
int CHECK(int ID, Request r);
int TRANS(int ID, Request r, char *split_list[]);
int timeOfDay();
void enqueue(Request *req, Queue que);
Request *dequeue(Queue que);
FILE *output_file;

int main(int argc, char **argv)
{
    int i = 0;
    int while_end = 1;
    int ID = 1;
    char *prompt = "> ";
    char *input;
    char word[1024];
    size_t size = 0;
    int num_threads = 0;
    int num_accts = 0;
    // char *split_list[MAX_PATH_SIZE];
    output_file = fopen(argv[3], "w");

    num_threads = atoi(argv[1]);
    num_accts = atoi(argv[2]);

    if (argc != 4)
    {
        printf("Invalid number of arguments! \n");
        while_end = 0;
    }

    initialize_accounts(atoi(argv[2]));
    timeOfDay();
    printf("Hello \n");

    acc_mut = malloc(num_accts * sizeof(pthread_mutex_t));
    // for (i = 0; i < num_accts; i++)
    // {
    //     pthread_mutex_init(&acc_mut[i], NULL);
    // }

    Queue que;
    // enqueue
    que.head = 0;
    que.tail = 0;
    que.num_jobs = 0;

    /* mutex and thread initialization*/
    // pthread_mutex_init(&que.);

    // pthread_mutex_init(&queue.lock, NULL);
    // pthread_mutex_init(&file_mut, NULL);
    // pthread_cond_init(&que.jobs, NULL);
    pthread_t threads[num_threads];

    // create worker threads
    // for (i = 0; i < num_threads; i++)
    // {
    //     pthread_create(&threads[i], NULL, worker_thread, &que);
    // }

// input_worker_thread(&que);










    while (while_end)
    {
        printf("%s", prompt);
        fgets(word, 1024, stdin);
        char *token = strtok(word, " ");






        if (strcmp(token, "CHECK") == 0)
        {
            Request r;
            r.request_id = ID;
            r.check_acc_id = atoi(strtok(NULL, " \n"));
            r.request_type = CHECK_0;
            // printf("account id: %d \n", atoi(strtok(NULL, "\n")));
            gettimeofday(&r.starttime, NULL);
            CHECK(ID, r);
            // printf("< ID %d \n", ID);
            enqueue(&r, que);
            ID++;
        }

        else if (strcmp(token, "TRANS") == 0)
        {
            Request r;
            r.request_id = ID;
            r.num_trans = 0;
            r.transactions = malloc(MAX_TRANSACTIONS * sizeof(trans));
            r.request_type = TRANS_1;
            while (1)
            {
                char *accountID = strtok(NULL, " \n");
                if (!accountID)
                {

                    break;
                }
                char *ammount = strtok(NULL, " \n");
                if (!ammount)
                {
                    break;
                }
                r.transactions[r.num_trans].acc_id = atoi(accountID);
                r.transactions[r.num_trans].amount = atoi(ammount);
                r.num_trans++;
            }
            // sortrs
            if (r.num_trans > 0)
            {
                int i, j;
                for (i = 0; i < r.num_trans; i++)
                {
                    for (j = i + 1; j < r.num_trans; j++)
                    {
                        if (r.transactions[j].acc_id < r.transactions[i].acc_id)
                        {
                            trans temp = r.transactions[i];
                            r.transactions[i] = r.transactions[j];
                            r.transactions[j] = temp;
                        }
                    }
                }
                enqueue(&r, que);
            }
            if(r.transactions->amount > 0){
            fprintf(output_file, "%d OK TIME %d <endtime> \n", ID, r.starttime.tv_usec);
            }
            if(r.transactions->amount < 0){
            fprintf(output_file, "%d ISF %d TIME %d <endtime> \n", ID, r.check_acc_id,r.starttime.tv_usec);
            }
        }
        else if (strcmp(token, "END") == 0)
        {
            while_end = 0;
        }

        else
        {
            printf("INVALID \n");
        }
        // printf("token: %c \n", token);
    }
    fclose(output_file);

    return 0;
}

int timeOfDay()
{
    struct timeval time;
    gettimeofday(&time, NULL);
    printf("TIME %ld.%06.ld\n", time.tv_sec, time.tv_usec);
}

void enqueue(Request *req, Queue que)
{
    if (que.head == NULL && que.tail == NULL)
    {
        que.head = req;
        que.tail = req;
    }
    else
    {
        que.tail->next = req;
        que.tail = req;
    }
    que.num_jobs++;
}
Request *dequeue(Queue que)
{
    Request *r = que.head;
    que.head = que.head->next;
    que.num_jobs--;
    return r;
}

int CHECK(int ID, Request r)
{
    printf("< ID %d \n", ID);
    int BAL = read_account(r.request_id);

    fprintf(output_file, "%d BAL %d TIME %d <endtime> \n", ID, BAL, r.starttime.tv_usec);
    // printf("%d BAL %d TIME %d <endtime> \n", ID, BAL, r.starttime.tv_usec);
    fflush(output_file);
}

int TRANS(int ID, Request r, char *split_list[])
{

    printf("< ID %d \n", ID);
}



// void *input_worker_thread(void *arg){
//     Queue que = (Queue *)arg;
//     int ID = 1;
//     char input[100];
//     char *input_command;

//     while (fgets(input, 100, stdin)){
//          input_command = strtok(input, " \n");
//         if (strcmp(input_command, "CHECK") == 0){
//             Request r;
//         }
//         {
//     }
// }
// }



