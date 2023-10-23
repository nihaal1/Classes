//include libraries
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

// ./file <SOURCE IP> <SOURCE PORT> <DESTINATION IP> <DESTINATION PORT> <LOSS RATE>
int main(int argc, char ** argv){

	int Port_in;
	int Port_out;
	char* IP_in;
	char* IP_out;
	int lossRate;
    char serverBuffer[4000];
    int sockServer;
    int sockClient;
    int lenClient;
    int lenIn;
    int ranLoss = 0;
	srand(time(NULL));//seed random var

    if (argc == 6)      
    {
        IP_in = argv[1];
        Port_in = atoi(argv[2]);
        IP_out = argv[3];
        Port_out = atoi(argv[4]);
        lossRate = atoi(argv[5]);        
        }
    
    else{
        printf("Invalid number of arguments");
        return -1;
    }

    struct sockaddr_in inAddr, outAddr, in_stream;

    if ((sockServer = socket(PF_INET, SOCK_DGRAM, 0)) < 0){
        perror("[-]Socker error]");
        return -1;
    }
    
    memset(&inAddr, 0, sizeof(inAddr));
    memset(&in_stream, 0 , sizeof(in_stream));

    inAddr.sin_family = PF_INET;
    inAddr.sin_port = htons(Port_in);
    inAddr.sin_addr.s_addr = inet_addr(IP_in);

	if( bind(sockServer, (const struct sockaddr *)&inAddr, sizeof(inAddr)) <0 )
	{
		perror("Server Binding failed:");
		return -1;
	}

    if( (sockClient = socket(PF_INET, SOCK_DGRAM, 0)) < 0)
	{
		perror("[-]Client Socket failed");
		return -1;
	}
	memset(&outAddr, 0, sizeof(outAddr));
    
    outAddr.sin_family = PF_INET;
	outAddr.sin_port = htons(Port_out);
	outAddr.sin_addr.s_addr = inet_addr(IP_out);

    lenClient = sizeof(outAddr);
    
    while(1){
        ranLoss = rand() % 1000 + 1;
		if( (recvfrom(sockServer, serverBuffer, sizeof(serverBuffer), 0, (struct sockaddr *)&in_stream, &lenIn)) < 0)//recieve data thats being sent to our server ip, store sending address to dummy struct
		{
			perror("Receive: ");
		}

		if(ranLoss < (1001-lossRate))//if ranLoss is between 1001 and 1001-lossrate, we dont send, othewise send. Simulates packet loss
		{
			if ( (sendto(sockClient, serverBuffer, sizeof(serverBuffer), 0, (struct sockaddr *)&outAddr, lenClient)) < 0 )//using the client socket, send it to the given destination port and ip
			{
				perror("Send: ");
			}
		}

    }
    close(sockClient);
    close(sockServer);
    return 1;
}