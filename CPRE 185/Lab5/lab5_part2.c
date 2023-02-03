/*-----------------------------------------------------------------------------
-					         SE/CprE 185 Lab 04
-             Developed for 185-Rursch by T.Tran and K.Wang
-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
-	                            Includes
-----------------------------------------------------------------------------*/
#include <stdio.h>
#include <math.h>


/*-----------------------------------------------------------------------------
-	                            Defines
-----------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------
-	                            Prototypes
-----------------------------------------------------------------------------*/
double mag(double x, double y, double z);
int close_to(double tolerance, double point, double value);


/*-----------------------------------------------------------------------------
-							  Implementation
-----------------------------------------------------------------------------*/
int main(void) {
    int t, b1, b2, b3, b4;
    double ax, ay, az, gx, gy, gz;
    int count = 0, fall_count = 0;
    int t1 = 0, t2 = 0;
    double time_seconds = 0;
    double distance = 0;
    double vCurrent = 0, tPrevious = 0, xCurrent = 0;
    int percentage;

printf("Nihaal Zaheer \n");
printf("nzaheer@iastate.edu \n");

//
// while(1)
// {
//   scanf("%d, %lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d", &t, &ax, &ay, &az, &gx, &gy, &gz, &b1, &b2, &b3, &b4 );
//   printf("%lf\n", mag(gx, gy, gz));
//   fflush(stdout);
// }

// when it falls returns to 0 and spikes to 3 when it stops

// FIXME: the curly braces for while (include fflush )

    while (!close_to(0.1, 1.0, mag(ax, ay, az))) {
        scanf("%d, %lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d", &t, &ax, &ay, &az, &gx, &gy, &gz, &b1, &b2, &b3, &b4 );
        count += 1;

        if (count == 1){
          printf("Ok, I'm now recieving data. \n");
          printf("I'm Waiting");
        }

        if (t % 10 == 0){ //&& (count < 11) // (count > 1)
          printf(".");
        }
        fflush(stdout);
}
        while (!close_to(0.75, 3.0, mag(gx, gy, gz))) { // now calcuate time difference and use that in equation to find distance
            scanf("%d, %lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d", &t, &ax, &ay, &az, &gx, &gy, &gz, &b1, &b2, &b3, &b4 );
            fall_count += 1;
            // t1 = t;   //t1 is time when it starts dropping

            // for (int i = 0; i < count; i++) {
              if (fall_count == 1){
                printf("\nHelp me! I'm Falling");
                t1 = t;
              }
              if (fall_count > 1){
                  printf("!");
              }

          //    tPrevious = (t - tPrevious)/1000.0;

              vCurrent = vCurrent + (9.8 * ((1 - mag(ax,ay,az))* (t - tPrevious)/1000.0) );

              xCurrent = xCurrent + (vCurrent * ((t1 - tPrevious)/1000.0));
              tPrevious = t1;


  fflush(stdout);
      }
t2 = t; // t2 is time when its done falling. that is t2 - t1 = time it fell for


// Test points
//printf("t1 %d\n", t1);
//printf("t2 %d\n", t2);


time_seconds = (t2 - t1)/1000.0; // now with this we use the equation x1 = x0 + vt + (1/2)gt^2 where g= 9.8 //(t2 - t1)/1000.0;
distance = (0.50)*9.8*(time_seconds * time_seconds);

percentage = ( (distance - xCurrent) /distance)*100;

printf("\nOuch! I fell for %lf meters in %lf seconds. \n", distance, time_seconds);


/* Test points */
printf("magnitude is: %lf\n", mag(ax,ay,az));
printf("magnitude with time and everything is: %lf\n", ((1 - mag(ax,ay,az))* (tPrevious)) );
printf("tPrevious is: %lf\n", tPrevious);
printf("vCurrent is: %lf\n", vCurrent);

printf("Compensating for air resistance, the fall was %lf meters.\n", xCurrent);
printf("This is %d%% less than computed before. \n", percentage);


// now we calculate distance wrt air resistance.

    return 0;
}

/* Put your functions here */
double mag(double x, double y, double z){
  double magnitude;
  magnitude = sqrt((x*x)+(y*y)+(z*z));


  return magnitude;
}

int close_to(double tolerance, double point, double value){
  if ((point - tolerance <= value) && (point + tolerance >= value)){
    return 1;
                                                                  }
                                                                  // 0.75 < x < 1.25
 else if(((point * -1) - tolerance) <= value && ((point * -1) + tolerance) >= value)
 {
   return -1;                                                   // -1.25 < x < -0.75
 }
  else{
    return 0;
      }
                                 }
