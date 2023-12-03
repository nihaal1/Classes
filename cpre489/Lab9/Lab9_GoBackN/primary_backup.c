#include <stdio.h> 
#include <string.h>    
#include <sys/socket.h>    
#include <stdlib.h>
#include "ccitt16.h"
#include "utilities.h"
#include "introduceerror.h"
#define N 3 //send window of size N

/* Note: Based on the code, a minimmum of more than 3 packages are required to be sent
in order to build the packages and finish execvution
That is
At least: ABCDEF*/

void primary(int sockfd, double ber) {
	int read_size;
    char msg[100], srv_reply[150];
	// first and last represent sequence numbers of sent packets
	unsigned char last = 0;
	unsigned char first;
	int len;
	int arr_len;

    //keep communicating with server
    while(1)
    {
	first = last; 
	memset(msg, 0, 100);// initializes msg to set all values to 0 for len of 100
    printf("Enter message : ");
	fgets(msg, 100 , stdin);   

	//remove new line from entered message
	for(char *charecter = msg; *charecter; charecter++) {
		if(*charecter == '\n') 
			*charecter = 0;     
	}	

	// below is used to check if msg can be divided in packets with even charecters
	// if not we need to add an extra packet.
	len = strlen(msg);
	// int arr_len = len%DATA_LENGTH ? len/DATA_LENGTH + 1 : len/DATA_LENGTH;
	if(len % DATA_LENGTH != 0){
		arr_len = len / DATA_LENGTH + 1;
	}
	else{
		arr_len = len / DATA_LENGTH;
	}

	struct packet_buffer packets[arr_len];       
	struct packet_buffer buffer[N];        //buffer with sender window of size=3        

	unsigned char sent_arr[arr_len];                 //########### check later ########
	//initializing sent_arr with all 0.
	memset(sent_arr, 0, sizeof(char)* arr_len);     
	

	for(char *i = msg; *i; i++) {  // iterates through msg and sets the first pkg to i 
        unsigned char buf[DATA_LENGTH] = {0};
		char *j = i + sizeof(char); // this sets j as the next packet after i
		if(j) { // if j is True, that is not a null pointer
			buf[DATA_LENGTH-2] = *i; //sets the first pkg to i
			buf[DATA_LENGTH-1] = *j; //sets the second pkg to j
			i = i + 1; 
		} else {                   
			buf[DATA_LENGTH-2] = *i; 
			buf[DATA_LENGTH-1] = 0; //sice j is null pointer, that is packet at i is last
		}
		// builds that packet
        buildPacket(packets[last - first].packet, DATA_PACKET, buf, last);
		printf("buildPacket (sequence number): %d \n", last);
		printPacket(packets[last - first].packet);
		last = last + 1;
	}

	//reset 
	last = first;  

	//iterates N times, that is depending on number of built packages 
	for(int i = 0; i < N; i++) {
		// copies packets for error simulation
		memcpy(buffer[i].packet, packets[i].packet, sizeof(struct packet_buffer)); 
		printf("Sent (Sequence Number): %d \n", last + i);
		printPacket(buffer[i].packet);
		//introduces error into copied packets
		IntroduceError(buffer[i].packet, ber);  
		if( send(sockfd , buffer[i].packet, sizeof(struct packet_buffer), 0) < 0){
			perror("Send failed");
		}
		//marks sent packet as 1
		sent_arr[i] = 1;	
	}
        // Send some data to the receiver
		// msg - the message to be sent
		// strlen(msg) - length of the message
		// 0 - Options and are not necessary here
		// If return value < 0, an error occured
        // if( send(sockfd , msg, strlen(msg), 0) < 0)
        //     perror("Send failed");
         
        // Receive a reply from the server
		// NOTE: If you have more data than 149 bytes, it will 
		// 			be received in the next call to "recv"
		// read_size - the length of the received message 
		// 				or an error code in case of failure
		// msg - a buffer where the received message will be stored
		// 149 - the size of the receiving buffer (any more data will be 
		// 		delievered in subsequent "recv" operations
		// 0 - Options and are not necessary here
        // if( (read_size = recv(sockfd , srv_reply , 149 , 0)) < 0)
        //     perror("recv failed");

		//  Null termination since we need to print it
		// srv_reply[read_size] = '\0';
        // printf("Server's reply: %s\n", srv_reply);
    


	while(last - first < arr_len) { 
	//we get the below from skeleton code provided
		if( (read_size = recv(sockfd, srv_reply, 149, 0)) < 0) 
				perror("recv failed");
		srv_reply[read_size] = '\0'; 
		
		printf("Packet type: %d, Sequence Number: %d \n", srv_reply[0], srv_reply[1]);

		//checks if packet type is ACK 
		if(srv_reply[0] == ACK_PACKET) {
			last = srv_reply[1];    
			printf("packet %d successfully sent \n", last);

			for(int i = 0; i < N && last + i - first < arr_len; i++) { 
				//we check if the packets had been sent before
				if(!sent_arr[last + i - first]) {	// has the packet been sent before
					memcpy(buffer[i].packet, packets[last+i-first].packet, sizeof(struct packet_buffer)); 
					printf("Sent (Sequence Number): %d \n", last + i);
					//introduces error into copied packets
					printPacket(buffer[i].packet);
					IntroduceError(buffer[i].packet, ber);
					//sends packets to secondary/server
					if( send(sockfd , buffer[i].packet, sizeof(struct packet_buffer), 0) < 0){
						perror("Send failed");
						}
					sent_arr[last + i - first] = 1;  //marks sent packet as 1
				}		
			}

		//checks if packet type is NAK 
		} else if(srv_reply[0] == NAK_PACKET) {
			last = srv_reply[1];	
			printf("packet %d unsuccessfully sent \n", last);
			if (arr_len > last + N - first){
				printf("Sending packets %d to %d again \n", last, last + N - 1);
			}
			else{
				printf("Sending packets %d to %d again \n", last, arr_len - 1);
			}

			for(int i = 0; i < N && last+i-first < arr_len; i++) {  
				//copy packets for introducing error	
				memcpy(buffer[i].packet, packets[last + i - first].packet, sizeof(struct packet_buffer)); 
				printf("Sent (Sequence Number): %d \n", last + i);
				//introduces error into copied packets
				printPacket(buffer[i].packet);
				IntroduceError(buffer[i].packet, ber); 
				
				if( send(sockfd , buffer[i].packet, sizeof(struct packet_buffer), 0) < 0)
					perror("Send failed");
				sent_arr[last + i - first] = 1; 
			}
		}	
	}	

    }
}	

//ABCDEFGHIJKLMNOPQRSTUVWXYZ