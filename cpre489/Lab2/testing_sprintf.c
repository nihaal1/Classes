#include <stdio.h>
#include <stdlib.h>

int main() {
    int days = 43;
    int hours = 9;
    int minutes = 39;
    int seconds = 3;

    char formattedString[100];

    // Format the string and store it in formattedString variable
    sprintf(formattedString, "  %02d:%02d:%02d up %d days, %02d:%02d, 0 users, load average: \n", 
            hours, minutes, seconds, days, hours, minutes);

    // Print the formatted string
    printf("%s", formattedString);

    return 0;
}
