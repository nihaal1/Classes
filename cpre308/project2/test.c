#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>
#include "Bank.c"

/*

This program simulates a multi-threaded bank transaction system.
It takes three command line arguments:
Number of worker threads
Number of bank accounts
Output file name
It accepts commands from stdin in the following format:
CHECK <account_number>
TRANS <account_number1> <amount1> <account_number2> <amount2> ...
END
Each transaction command can contain multiple account number and amount pairs.
It then processes the commands using the worker threads and logs the output to the specified file.
*/

#define MAX_TRANSACTIONS 10

// Holds transaction information
typedef struct
{
    int accountId;
    int amount;
} Transaction;

// Enumeration of request types
typedef enum
{
    CHECK,
    TRANS,
    END
} RequestType;

// Holds the information linked to each request
typedef struct
{
    int requestId;
    RequestType type;
    int checkAccountId;
    Transaction *transactions;
    int numTransactions;
    struct timeval startTime;
    struct timeval endTime;
} Request;

// Defines a queue to handle a new or completed request
typedef struct
{
    Request *requests;
    int numRequests;
    int head;
    int tail;
    int numJobs;
    pthread_mutex_t lock;
    pthread_cond_t jobs;
} RequestQueue;

// Function declarations
void enqueueRequest(RequestQueue *queue, Request request);
Request dequeueRequest(RequestQueue *queue);
void *workerThread(void *arg);
void *inputThread(void *arg);
int NUM_ACCOUNTS;
int NUM_THREADS;
FILE *file;
pthread_mutex_t *account_locks;
pthread_mutex_t file_mutex;

int main(int argc, char **argv)
{
    // Checks for the right number of arguments
    if (argc != 4)
    {
        fprintf(stderr, "Not enough arguments\n");
        return 1;
    }
    NUM_THREADS = atoi(argv[1]);
    NUM_ACCOUNTS = atoi(argv[2]);
    file = fopen(argv[3], "w");
    // initialize the number of bank accounts inputted
    initialize_accounts(NUM_ACCOUNTS);
    // define an array of locks linked to each account_id
    account_locks = malloc(NUM_ACCOUNTS * sizeof(pthread_mutex_t));
    int index;
    // initialize mutex
    for (index = 0; index < NUM_ACCOUNTS; index++)
    {
        pthread_mutex_init(&account_locks[index], NULL);
    }
    // initialize queue
    RequestQueue queue;
    queue.requests = malloc(MAX_TRANSACTIONS * sizeof(Request));
    queue.numRequests = 0;
    queue.head = 0;
    queue.tail = 0;
    queue.numJobs = 0;

    // initialize mutex and conditional variable
    pthread_mutex_init(&queue.lock, NULL);
    pthread_mutex_init(&file_mutex, NULL);
    pthread_cond_init(&queue.jobs, NULL);
    pthread_t threads[NUM_THREADS];
    int i;
    // create worker threads
    for (i = 0; i < NUM_THREADS; i++)
    {
        pthread_create(&threads[i], NULL, workerThread, &queue);
    }

    // start input thread
    inputThread(&queue);
    // join work threads
    for (i = 0; i < NUM_THREADS; i++)
    {
        pthread_join(threads[i], NULL);
    }
    // free accounts from memroy
    free_accounts();
    for (i = 0; i < NUM_ACCOUNTS; i++)
    {
        pthread_mutex_destroy(&account_locks[i]);
    }
    // free account locks from memory
    free(account_locks);
    free(queue.requests);
    // close file
    fclose(file);
    return 0;
}

/*
Enqueue a request type
*/
void enqueueRequest(RequestQueue *queue, Request request)
{
    // lock queue
    pthread_mutex_lock(&queue->lock);
    // push request to queue
    queue->requests[queue->tail++] = request;
    queue->numRequests++;
    queue->numJobs++;
    if (queue->tail == MAX_TRANSACTIONS)
    {
        queue->tail = 0;
    }
    // unlock queue
    pthread_mutex_unlock(&queue->lock);
}

Request dequeueRequest(RequestQueue *queue)
{
    // lock queue
    pthread_mutex_lock(&queue->lock);
    // pop request from queue
    while (queue->numJobs == 0)
    {
        pthread_cond_wait(&queue->jobs, &queue->lock);
    }
    Request request = queue->requests[queue->head++];
    queue->numJobs--;
    if (queue->head == MAX_TRANSACTIONS)
    {
        queue->head = 0;
    }
    // unlock queue
    pthread_mutex_unlock(&queue->lock);
    return request;
}

void *workerThread(void *arg)
{
    // define queue with requests made in that thread
    RequestQueue *queue = (RequestQueue *)arg;
    while (1)
    {
        // pop and store a request
        Request request = dequeueRequest(queue);
        // if the request type is END terminate
        if (request.type == END)
        {
            break;
        }
        // if request type is CHECK
        else if (request.type == CHECK)
        {
            // retrieve the account id
            int accountId = request.checkAccountId;
            // check if account id is valid
            if (accountId < 1 || accountId > NUM_ACCOUNTS)
            {
                fprintf(stderr, "Invalid account\n");
            }
            // if account id is valid
            else
            {
                // lock the account at that id
                pthread_mutex_lock(&account_locks[accountId - 1]);
                // read the balance amount in that account id
                int balance = read_account(accountId);
                // unlock the account at that id
                pthread_mutex_unlock(&account_locks[accountId - 1]);
                // print transaction information to the output file
                gettimeofday(&request.endTime, NULL);
                pthread_mutex_lock(&file_mutex);
                fprintf(file, "\t%d BAL %d TIME %ld.%06ld %ld.%06ld\n",
                        request.requestId, balance,
                        request.startTime.tv_sec, request.startTime.tv_usec,
                        request.endTime.tv_sec, request.endTime.tv_usec);
                fflush(file);
                pthread_mutex_unlock(&file_mutex);
            }
        }
        // if request type is TRANS
        else if (request.type == TRANS)
        {
            int i;
            int isError = 0;
            // run all transactions
            for (i = 0; i < request.numTransactions; i++)
            {
                // retrieve the account id
                int accountId = request.transactions[i].accountId;
                // retrieve the transaction ammont
                int amount = request.transactions[i].amount;
                // check if account is valid
                if (accountId < 1 || accountId > NUM_ACCOUNTS)
                {
                    fprintf(stderr, "Invalid account\n");
                    isError = 1;
                    break;
                }
                // lock the account id in play
                pthread_mutex_lock(&account_locks[accountId - 1]);
                // retrieve the balance
                int balance = read_account(accountId);
                // unlock the account id in play
                pthread_mutex_unlock(&account_locks[accountId - 1]);
                // check if there is sufficient funds in that account
                if (balance + amount < 0)
                {
                    // fprintf(stderr, "Not enough funds\n");
                    isError = 1;
                    break;
                }
            }
            // if an error does exists in the transaction
            if (!isError)
            {
                // write the new balance to all accounts in play
                for (i = 0; i < request.numTransactions; i++)
                {
                    int accountId = request.transactions[i].accountId;
                    int amount = request.transactions[i].amount;
                    pthread_mutex_lock(&account_locks[accountId - 1]);
                    int balance = read_account(accountId);
                    write_account(accountId, balance + amount);
                    pthread_mutex_unlock(&account_locks[accountId - 1]);
                }
                // output transaction information to output file
                gettimeofday(&request.endTime, NULL);
                pthread_mutex_lock(&file_mutex);
                fprintf(file, "\t%d OK TIME %ld.%06ld %ld.%06ld\n",
                        request.requestId,
                        request.startTime.tv_sec, request.startTime.tv_usec,
                        request.endTime.tv_sec, request.endTime.tv_usec);
                fflush(file);
                pthread_mutex_unlock(&file_mutex);
            }
            // if an error does exist
            else
            {
                // output error to output file
                gettimeofday(&request.endTime, NULL);
                pthread_mutex_lock(&file_mutex);
                fprintf(file, "\t%d ISF TIME %ld.%06ld %ld.%06ld\n",
                        request.requestId,
                        request.startTime.tv_sec, request.startTime.tv_usec,
                        request.endTime.tv_sec, request.endTime.tv_usec);
                fflush(file);
                pthread_mutex_unlock(&file_mutex);
            }
        }
    }
    return NULL;
}
void *inputThread(void *arg)
{
    // declare a queue with input arguments
    RequestQueue *queue = (RequestQueue *)arg;
    // set initial request id
    int requestId = 1;
    char input[100];
    char *command;
    while (fgets(input, 100, stdin))
    {
        command = strtok(input, " \n");
        // if the input commands a CHECK request type
        if (strcmp(command, "CHECK") == 0)
        {
            // create a new request and define its attributes
            Request request;
            request.requestId = requestId++;
            request.type = CHECK;
            request.checkAccountId = atoi(strtok(NULL, " \n"));
            gettimeofday(&request.startTime, NULL);
            // push request to queue
            enqueueRequest(queue, request);
            printf("ID %d\n", request.requestId);
            // unblock all threads linked to the the conditional variable
            pthread_cond_broadcast(&queue->jobs);
        }
        // if the input commands a TRANS request type
        else if (strcmp(command, "TRANS") == 0)
        {
            // create a new request and define its attributes
            Request request;
            request.requestId = requestId++;
            request.type = TRANS;
            request.numTransactions = 0;
            request.transactions = malloc(MAX_TRANSACTIONS * sizeof(Transaction));
            while (1)
            {
                char *accountId = strtok(NULL, " \n");
                if (!accountId)
                {
                    break;
                }
                char *amount = strtok(NULL, " \n");
                if (!amount)
                {
                    break;
                }
                if (request.numTransactions == MAX_TRANSACTIONS)
                {
                    fprintf(stderr, "Too many transactions\n");
                    request.numTransactions = 0;
                    break;
                }
                request.transactions[request.numTransactions].accountId = atoi(accountId);
                request.transactions[request.numTransactions].amount = atoi(amount);
                request.numTransactions++;
            }
            if (request.numTransactions > 0)
            {
                int i, j;
                for (i = 0; i < request.numTransactions; i++)
                {
                    for (j = i + 1; j < request.numTransactions; j++)
                    {
                        if (request.transactions[j].accountId < request.transactions[i].accountId)
                        {
                            Transaction temp = request.transactions[i];
                            request.transactions[i] = request.transactions[j];
                            request.transactions[j] = temp;
                        }
                    }
                }
                gettimeofday(&request.startTime, NULL);
                // enqueue defined request
                enqueueRequest(queue, request);
                printf("ID %d\n", request.requestId);
                // unblock threads linked to the condition variable
                pthread_cond_broadcast(&queue->jobs);
            }
        }
        // if the input request type is END
        else if (strcmp(command, "END") == 0)
        {
            int i;
            // define a new request and its attributes to all threads
            for (i = 0; i < NUM_THREADS; i++)
            {
                Request request;
                request.type = END;
                enqueueRequest(queue, request);
            }
            // if there are jobs still pending
            while (queue->numJobs > 0)
            {
                // unblock threads linked to the conditional variable
                pthread_cond_broadcast(&queue->jobs);
                usleep(1000);
            }
            return NULL;
        }
    }
    return NULL;
}
