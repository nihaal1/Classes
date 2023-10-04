#include <stdio.h>
#include <stdlib.h>
#include <string.h>



int main(){
    FILE *fp;
    char uptimeInfo[1024];
    char concatenatedString[1024];
    char first_part[1024];

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
    strcpy(concatenatedString, "127.0.0.1");
    strcat(concatenatedString, ":");
    strcat(concatenatedString, first_part);
    strcat(concatenatedString, uptimeInfo);
    strcat(concatenatedString, uptimeInfo);
    printf("%s \n", concatenatedString);


    return 0;
}

