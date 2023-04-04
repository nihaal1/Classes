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
int check(double x);
int position(int gx,int gy, int gz);

/*-----------------------------------------------------------------------------
-							  Implementation
-----------------------------------------------------------------------------*/
int main(void) {
    int t, b1, b2, b3, b4;
    double ax, ay, az, gx, gy, gz;


    while (1) {
        scanf("%d, %lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d", &t, &ax, &ay, &az, &gx, &gy, &gz, &b1, &b2, &b3, &b4 );



        /* printf for observing values scanned in from ds4rd.exe, be sure to comment or remove in final program */
        // if (close_to(0.25,1.0,gy) == 0) {
        //   printf("upright");
        // }

        // printf("Echoing output: %d, %lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d \n", t, ax, ay, az, gx, gy, gz, b1, b2, b3, b4);

        /* It would be wise (mainly save time) if you copy your code to calculate the magnitude from last week
         (lab 3).  You will also need to copy your prototypes and functions to the appropriate sections
         in this program. */

        //printf("At %d ms, the acceleration's magnitude was: %f\n", t, mag(ax, ay, az));



        //   printf("Echoing output: %d,  %lf, %lf, %lf \n", t, gx, gy, gz);

        // scanf("%lf, %lf, %lf,  %d, %d, %d, %d", &gx, &gy, &gz, &b1, &b2, &b3, &b4 );
        // printf("Output:  %lf, %lf, %lf \n",  gx, check(gy), gz); // just for gravitational

        // printf("Output:  %d, %d, %d, %d, %d, %d, %d \n",  close_to(0.25,1.0,gx), close_to(0.25,1.0,gy), close_to(0.25,1.0,gz), b1, b2, b3, b4); // just for gravitational
        if (close_to(0.25, 1.0, mag(ax, ay, az))){
        position(close_to(0.25,1.0,gx), close_to(0.25,1.0,gy), close_to(0.25,1.0,gz));
      }
        fflush(stdout);
        if (b1 == 1){
          break;
        }
    }
    // close_to(tolerance, point, mag(ax, ay, az));

    return 0;
}

/* Put your functions here */
double mag(double x, double y, double z){
  double magnitude;
  magnitude = sqrt((x*x)+(y*y)+(z*z));
  // magnitude = sqrt(pow(ax,2)+pow(ay,2)+pow(az,2));

  return magnitude;
}

int close_to(double tolerance, double point, double value){
  if ((point - tolerance <= value) && (point + tolerance >= value)){
    return 1;
                                                                  }
                                                                  // 0.75 < x < 1.25
 else if(((point * -1) - tolerance) <= value && ((point * -1) + tolerance) >= value)
 {
   return -1;
 }
  else{
    return 0;
      }
                                 }

                                    // -1.25 < x < -0.75



int position(int gx,int gy,int gz){
if ((gx == 0) && (gy == 1) && (gz == 0)) {
  printf("TOP\n");
}
else if ((gx == 0) && (gy == -1) && (gz == 0)) {
  printf("BOTTOM\n");
}
else if ((gx == 1) && (gy == 0) && (gz == 0)) {
  printf("RIGHT\n");
}
else if ((gx == -1) && (gy == 0) && (gz == 0)) {
  printf("LEFT\n");
}
else if ((gx == 0) && (gy == 0) && (gz == -1)) {
  printf("FRONT\n");
}
else if ((gx == 0) && (gy == 0) && (gz == 1)) {
  printf("BACK\n");
}
  return 0;
}




int check(double x){
  if (x < 0) {
    return 1;
  }
}
