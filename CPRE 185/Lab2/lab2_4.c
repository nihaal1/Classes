/*-----------------------------------------------------------------------------
-					          CPRE 185 Lab 02
-	Name: Nihaal Koyakunju Zaheer
- Section: 2
-	NetID: nzaheer
-	Date: 09/10/21
-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
-	                            Includes
-----------------------------------------------------------------------------*/
#include <stdio.h>


/*-----------------------------------------------------------------------------
-	                            Defines
-----------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------
-	                            Prototypes
-----------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------
-							 Implementation
-----------------------------------------------------------------------------*/
int main()
{


  int a = 6427 + 1725;   // correct
  int b = (6971 * 3925) - 95; // correct
  double c = 79 + 12 /5; // correct
  double d = 3640 / 107.9; //correct

  int e = (22 / 3) * 3; //incorrect, return 21, correct = 22;
  int f = 22 / (3 * 3); //correct
  double g = 22 / (3 * 3); //incorrect, return 2.00000 instead of 2.4
  double h = 22 / 3 * 3; //incorrect, return 21.00000 instead of 22.00000

  double i = (22.0 / 3) * 3.0; // correct
  int j = 22.0 / (3 * 3.0); //correct
  double k = 22.0 / 3.0 * 3.0; //correct


// To Calculate the area of a circle with circumference 23.567
//area = (c^2)/(4*3.140)

double circum = 23.567;
double area = (circum * circum) / (4 * 3.140);

double feet = 14.0000;
double meters = feet * 0.3048;

double faren = 76.000;
double celc = (faren - 32.000)/1.800;



  printf("%d\n", a);
  printf("%d\n", b);
  printf("%lf\n", c);
  printf("%lf\n", d);

  printf("\n");

  printf("%d\n", e);
  printf("%d\n", f);
  printf("%lf\n", g);
  printf("%lf\n", h);

  printf("\n");

  printf("%lf\n", i);
  printf("%d\n", j);
  printf("%lf\n", k);

  printf("\n" );

  printf("area: %lf\n",area); // correct
  printf("meters: %lf\n", meters); //correct
  printf("Centigrade: %lf\n", celc); //correct


    return 0;
}
