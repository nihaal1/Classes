/* 185 Lab 3 Template */

#include <stdio.h>
#include <math.h>

/* Put your function prototypes here */
int counter(int triangle, int circle, int x, int square);

int main(void) {
    /* DO NOT MODIFY THESE VARIABLE DECLARATIONS */

    int triangle, circle, x, square; // use scanf and read the data to check if it is 0 or 1


    /* This while loop makes your code repeat. Don't get rid of it. */
    while (1) {
        scanf("%d,%d,%d,%d", &triangle, &circle, &x, &square);

        printf("Number of buttons pressed: %d\n", counter(triangle, circle, x, square));
        fflush(stdout);
}

return 0;
}

/* Put your functions here */
int counter(int triangle, int circle, int x, int square){

  int count;

  count += triangle;
  count += circle;
  count += x;
  count += square;

  return count;


}
