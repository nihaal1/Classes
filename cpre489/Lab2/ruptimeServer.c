//include libraries
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>


//  Main method
int main(int argc, char ** argv){
    char * IP_addr;
    FILE *fp;
    char uptimeInfo[1024];
    char concatenatedString[1024];
    char first_part[1024];

    // Takes in argument Ip address, if left unspecified, uses default localhost (127.0.0.1)
    if (argc == 2){
        printf("argv: %s\n", argv[1]);
        IP_addr = argv[1];
        printf("custom IP: %s\n ",IP_addr);
    }
    else{
        IP_addr = "127.0.0.1";
        printf("IP_addr: %s\n", IP_addr);
    }
  // Initialization of TCP socket [socket()]
  int port = 5566;

  int server_sock, client_sock;
  struct sockaddr_in server_addr, client_addr;
  socklen_t addr_size;
  char buffer[1024];
  int n;


// uptime from file

 
    // Open the uptime file in /proc directory
    fp = fopen("/proc/uptime", "r");
    if (fp == NULL) {
        perror("Error opening /proc/uptime");
        return 1;
    }

    // Read uptime information from the file
    fgets(uptimeInfo, sizeof(uptimeInfo), fp);
    fclose(fp);

    // Parse the uptime information
    double uptime, idleTime;
    sscanf(uptimeInfo, "%lf %lf", &uptime, &idleTime);

    // Calculate the system uptime in days, hours, minutes, and seconds
    int days = (int)uptime / 86400;
    int hours = ((int)uptime % 86400) / 3600;
    int minutes = ((int)uptime % 3600) / 60;
    int seconds = (int)uptime % 60;

    // Print the uptime information
    sprintf(first_part, "  %02d:%02d:%02d up %d days, %02d:%02d, 0 users, load average: ", 
        hours, minutes, seconds, days, hours, minutes);
    // printf("  %02d:%02d:%02d up %d days, %02d:%02d, 0 users, load average: ", hours, minutes, seconds, days, hours, minutes);

    // Open the load average file in /proc directory
    fp = fopen("/proc/loadavg", "r");
    if (fp == NULL) {
        perror("Error opening /proc/loadavg");
        return 1;
    }

    // Read load average information from the file
    fgets(uptimeInfo, sizeof(uptimeInfo), fp);
    fclose(fp);

    // Print the load average information
    // printf("uptimeInfo: %s\n", uptimeInfo);
    strcpy(concatenatedString, IP_addr);
    strcat(concatenatedString, ":");
    strcat(concatenatedString, first_part);
    strcat(concatenatedString, uptimeInfo);
    // printf("%s \n", concatenatedString);




  server_sock = socket(AF_INET, SOCK_STREAM, 0);
  // checks if socket is created without any errors
  if (server_sock < 0){
    perror("[-]Socket error");
    exit(1);
  }
  printf("[+]TCP server socket created.\n");

// Initialzes server_add with null values
  memset(&server_addr, '\0', sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_port = port;
  server_addr.sin_addr.s_addr = inet_addr(IP_addr);

// Bind [bind()]
  n = bind(server_sock, (struct sockaddr*)&server_addr, sizeof(server_addr));
  // check if bind is successful
  if (n < 0){
    perror("[-]Bind error");
    exit(1);
  }
  printf("[+]Bind to the port number: %d\n", port);

  listen(server_sock, 5);
  printf("Listening...\n");








// Read from client after connecting
  while(1){
    addr_size = sizeof(client_addr);
    client_sock = accept(server_sock, (struct sockaddr*)&client_addr, &addr_size);
    printf("[+]Client connected.\n");

// initializes and copies data to buffer to read from 
    // bzero(buffer, 1024);
    // recv(client_sock, buffer, sizeof(buffer), 0);
    // printf("Client: %s\n", buffer);

// Sends data in buffer to client socket
    // bzero(buffer, 1024);
    // strcpy(buffer, "HI, THIS IS SERVER. HAVE A NICE DAY!!!");
    // printf("Server: %s\n", buffer);
    // send(client_sock, buffer, strlen(buffer), 0);

//  Sends concatenatedStrings
    bzero(buffer, 1024);
    strcpy(buffer, concatenatedString);
    printf("%s\n", buffer);
    send(client_sock, buffer, strlen(buffer), 0);

// closes socket after sucessful implementation.
    close(client_sock);
    printf("[+]Client disconnected.\n\n");

  }

  return 0;
}

