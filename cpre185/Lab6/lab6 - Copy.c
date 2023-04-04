// 185 lab6.c
//
// This is the outline for your program
// Please implement the functions given by the prototypes below and
// complete the main function to make the program complete.
// You must implement the functions which are prototyped below exactly
//  as they are requested.
// use ./ ds4rd.exe -d 054c:09cc -D DS4_USB -g -t -b | ./lab6 while implementing on cygwin

/*-----------------------------------------------------------------------------
-	                            Includes
-----------------------------------------------------------------------------*/


#include <stdio.h>
#include <math.h>
#define PI 3.141592653589

//NO GLOBAL VARIABLES ALLOWED

/*-----------------------------------------------------------------------------
-	                            Prototypes
-----------------------------------------------------------------------------*/

//PRE: Arguments must point to double variables or int variables as appropriate
//This function scans a line of DS4 data, and returns
//  True when the square button is pressed
//  False Otherwise
//This function is the ONLY place scanf is allowed to be used
//POST: it modifies its arguments to return values read from the input line.
//int read_line(double* g_x, double* g_y, double* g_z, int* time, int* Button_T, int* Button_X, int* Button_S, int* Button_C);
int read_line(double* g_x, double* g_y, double* g_z, int* time, int* Button_T, int* Button_X, int* Button_S,  int* Button_C);

// PRE: -1.0 <= x_mag <= 1.0
// This function computes the roll of the DS4 in radians
// if x_mag outside of -1 to 1, treat it as if it were -1 or 1
// POST: -PI/2 <= return value <= PI/2
double roll(double x_mag);

// PRE: -1.0 <= y_mag <= 1.0
// This function computes the pitch of the DS4 in radians
// if y_mag outside of -1 to 1, treat it as if it were -1 or 1
// POST: -PI/2 <= return value <= PI/2
double pitch(double y_mag);


// PRE: -PI/2 <= rad <= PI/2
// This function scales the roll value to fit on the screen
// POST: -39 <= return value <= 39
int scaleRadsForScreen(double rad);

// PRE: num >= 0
// This function prints the character use to the screen num times
// This function is the ONLY place printf is allowed to be used
// POST: nothing is returned, but use has been printed num times
void print_chars(int num, char use);

//PRE: -39 <= number <=39
// Uses print_chars to graph a number from -39 to 39 on the screen.
// You may assume that the screen is 80 characters wide.
void graph_line(int number, int mode);

/*-----------------------------------------------------------------------------
-			Implementation
-----------------------------------------------------------------------------*/
int main()
{
	double x, y, z;
	int mode = 0;
	double type;
	int t;                             					// magnitude values of x, y, and z
	int b_Triangle, b_X, b_Square, b_Circle;    // variables to hold the button statuses
	double roll_rad, pitch_rad;                 // value of the roll measured in radians
	int scaled_value;                           // value of the roll adjusted to fit screen display


	//insert any beginning needed code here

mode = 1;
	do
	{
		// Get line of input
	//scanf("%d, %lf, %lf, %lf, %d, %d, %d, %d", &t, &x, &y, &z, &b_Triangle, &b_X, &b_Square, &b_Circle);
	read_line(&x, &y, &z, &t, &b_Triangle, &b_X, &b_Square, &b_Circle);
	//printf("%d : %lf : %lf : %lf : %d : %d : %d : %d\n", t, x, y, z, b_Triangle, b_X, b_Square, b_Circle);
	fflush(stdout);


	//read_line(&x, &y, &z, &t, &b_Triangle, &b_X, &b_Square, &b_Circle);
		//read_line(&x, &y, &z, &t, &b_Triangle, &b_Circle, &b_X, &b_Square,);


		// calculate roll and pitch.  Use the buttons to set the condition for roll and pitch
		 // printf("%lf\n",roll(x));
		 //printf("%lf\n",pitch(y));
		//roll(x);
	//	pitch(y);


		// switch between roll and pitch(up vs. down button)
			// mode = pitch(y);
		//mode = roll(x);


		// type = roll(x);

		if (b_Triangle == 1) {
			if (mode == 1){
				type = roll(x);
				mode = 2;
			}																	// these lines of code switches roll and pitch with just a single button
			else if (mode == 2){
				type = pitch(y);
				mode = 1;
				// type = pitch(y);
			}
}

if (mode == 1){
	type = roll(x);

}

if (mode == 2){
	type = pitch(y);
}

/*
			mode = 1;
			type = roll(x);
			if (b_Triangle == 1){
				mode = 2;
				type = pitch(y);
			}                               // this is with the 2 buttons
			else if (b_Triangle == 1){
				mode = 1;
			type = roll(x);
			}
*/



		// if (b_Triangle == 1) {
		// 	mode = 1;
		// }
		// if (mode == 1){
		// 	type = roll(x);
		// }
		//
		// if (b_X == 1) {
		// 	mode = 2;
		// }
		// if (mode == 2){
		// 	type = pitch(y);
		// }



		// Scale your output value

		// printf("%d \n", scaleRadsForScreen(roll(x)));
		 // print_chars(1,'0');
		 // printf("%d\n", t);

		// Output your graph line

		// printf("0\n" );
		graph_line(scaleRadsForScreen(type),mode);



		// printf("%d \n",b_Square );


	//	fflush(stdout);
}while(b_Square == 0); //while(1); // Modify to stop when the square button is pressed
	return 0;
}



/* Put your functions here */
int read_line(double* g_x, double* g_y, double* g_z, int* time, int* Button_T, int* Button_X, int* Button_S, int* Button_C){
	//scanf("%d,%lf,%lf,%lf,%d,%d,%d,%d",time, g_x, g_y, g_z, Button_T, Button_C, Button_X, Button_S );
	scanf("%d, %lf, %lf, %lf, %d, %d, %d, %d", time, g_x, g_y, g_z, Button_T, Button_C, Button_X, Button_S );
	if(*Button_S == 1){
		return 1;
	}
	else {
		return 0;
	}
}

double roll(double x_mag){

	if (x_mag < -1){
		return asin(-1); // asin)(-1) = -1.570796

	}
	else if (x_mag > 1){
		return asin(1); // asin(1) = 1.570796
	}
		return asin(x_mag);
}

double pitch(double y_mag){
	if (y_mag < -1){
		return asin(-1);
	}
	else if (y_mag > 1){
		return asin(1);
	}
		return asin(y_mag);
}


int scaleRadsForScreen(double rad){
return  sin(rad)*39;
}


void print_chars(int num, char use){
	for (int i = 0; i < num; i++ ){ // use for loop
		printf("%c", use);
	}

}

void graph_line(int number, int mode){
	number *= -1; // this fixes the radians getting inverted

// if (mode == 1){
// 	if (number == 0){
// 		print_chars(39,' ');
// 		// printf("0\n" );
// 		print_chars(1,'0');
// 	}
if (mode == 1){
	if (number < 0){
		print_chars(39 + number,' ');
		print_chars(abs(number),'l');
		print_chars(1,'\n');
	}

	if (number >= 0){
		print_chars(39,' ');
		if (number == 0){
			print_chars(1,'0');
			// print_chars(1,'\n');

		}
		print_chars(number,'r');
		print_chars(1,'\n');
	}
}

if (mode == 2){
	if (number < 0){
		print_chars(39 + number,' ');
		print_chars(abs(number),'f');
		print_chars(1,'\n');
	}

	if (number >= 0){
		print_chars(39,' ');
		if (number == 0){
			print_chars(1,'0');
			// print_chars(1,'\n');

		}
		print_chars(number,'b');
		print_chars(1,'\n');
	}
}



// if (mode == 2){
// 		if (number == 0){
// 			print_chars(39,' ');
// 			// printf("\n" );
// 			print_chars(1,'0');
// 		}
// 		if (number < 0){
// 			print_chars(39 + number,' ');
// 			print_chars(1,'f');
// 		}
// 		if (number >= 0){
// 			print_chars(39,' ');
// 			if (number == 0){
// 				print_chars(1,'0');
// 			}
// 			print_chars(number,'b');
// 		}
//
//
// 		}
//
// 	}
}

//int p = &a;
//*p = a;

//13 -> variable time;
//scanf("%d", time)


/* FIXME


*/
