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
  printf("Name: Nihaal Koyakunju Zaheer \n");
  printf("Section: 2 \n" );
  printf("NetID: nzaheer \n");
  printf("Date: 09/10/21 \n");

    int integerResult;
    double decimalResult;

    integerResult = 77.0 / 5.0;
    printf("The value of 77/5 is %d, using integer math\n", integerResult); // plug in .0 and change to %d

    integerResult = 2 + 3;
    printf("The value of 2+3 is %d\n", integerResult);   // plug i %d instead of %lf

    decimalResult = 1.0 / 22.0;
    printf("The value 1.0/22.0 is %lf\n", decimalResult);  // plug in .0 and %lf instead of &d

    return 0;
}
