#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

/* Headers*/
/* define two routines called by threads*/

void * thread1();
void * thread2();


void * thread1(){
	sleep(5);
	printf("Hello from thread1 \n");
}

void * thread2(){
	sleep(5);
	printf("Hello from thread2 \n");
}

int main(int argc, char* argv){
  /* thread id or type*/


	pthread_t i1;
	pthread_t i2;

  /* thread creation */
	pthread_create(&i1, NULL, (void*)&thread1, NULL);
	pthread_create(&i2, NULL, (void*)&thread2, NULL);
	
  /* main waits for the two threads to finish */

	pthread_join(i1, NULL);
	pthread_join(i2, NULL);

	printf("Hello from main \n");

	return 0;
}
