/* 185 Lab 3 Template */

#include <stdio.h>
#include <math.h>

/* Put your function prototypes here */
double mag(double x, double y, double z);
int minutes(int t);
int seconds(int t);
int millis(int t);

int main(void) {
    /* DO NOT MODIFY THESE VARIABLE DECLARATIONS */
    int t;
    double  ax, ay, az;


    /* This while loop makes your code repeat. Don't get rid of it. */
    while (1) {
        scanf("%d,%lf,%lf,%lf", &t, &ax, &ay, &az);



/* CODE SECTION 0 */

        double seconds = t / 1000.0;

        //printf("Echoing output: %d, %lf, %lf, %lf\n", t, ax, ay, az);
        printf("Echoing output: %8.3lf, %7.4lf, %7.4lf, %7.4lf\n", seconds, ax, ay, az); //Since seconds is in type int we would get the decimal precision in the form of "x.000"
        //8.3, 7.4 shows how many places in the integer and decimal places  the floating type can use



/* CODE SECTION 1 */
/*
        printf("At %d ms, the acceleration's magnitude was: %lf\n",
            t, mag(ax, ay, az));
*/

/* CODE SECTION 2
        printf("At %d minutes, %d seconds, and %d milliseconds it was: %lf\n",
        minutes(t), seconds(t), millis(t), mag(ax,ay,az));
*/
    }

return 0;
}

/* Put your functions here */
double mag(double x, double y, double z){
  double magnitude;
  magnitude = sqrt((x*x)+(y*y)+(z*z));
  // magnitude = sqrt(pow(ax,2)+pow(ay,2)+pow(az,2));

  return magnitude;
}

int minutes(int t){
  int min = t/60000;
  // int min = ceil(sec(t)/60000);
  return min;
}

int seconds(int t){
  //int sec = t/1000;
  int sec = (t % 60000) / 1000;
  return sec;
}

int millis(int t){
  return t % 1000;
}
