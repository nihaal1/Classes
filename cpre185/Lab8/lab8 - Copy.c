// WII-MAZE Skeleton code written by Jason Erbskorn 2007
// Edited for ncurses 2008 Tom Daniels
// Updated for Esplora 2013 TeamRursch185
// Updated for DualShock 4 2016 Rursch


// Headers
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ncurses/ncurses.h>
#include <unistd.h>

// Mathematical constants
#define PI 3.14159

// Screen geometry
// Use ROWS and COLS for the screen height and width (set by system)
// MAXIMUMS
#define NUMCOLS 100
#define NUMROWS 72

// Character definitions taken from the ASCII table
#define AVATAR 'A'
#define WALL '*'
#define EMPTY_SPACE ' '


// 2D character array which the maze is mapped into
char MAZE[NUMROWS][NUMCOLS];


// POST: Generates a random maze structure into MAZE[][]
//You will want to use the rand() function and maybe use the output %100.
//You will have to use the argument to the command line to determine how
//difficult the maze is (how many maze characters are on the screen).
void generate_maze(int difficulty);

// PRE: MAZE[][] has been initialized by generate_maze()
// POST: Draws the maze to the screen
void draw_maze(void);

// PRE: 0 < x < COLS, 0 < y < ROWS, 0 < use < 255
// POST: Draws character use to the screen and position x,y
void draw_character(int x, int y, char use);

// PRE: -1.0 < x_mag < 1.0
// POST: Returns tilt magnitude scaled to -1.0 -> 1.0
// You may want to reuse the roll function written in previous labs.
float calc_roll(float x_mag);

// Main - Run with './ds4rd.exe -t -g -b' piped into STDIN
int main(int argc, char* argv[])
{
	int t;
	double gx, gy, gz;
	int count;
	int time = 0;
	int X_Position = NUMCOLS/2, Y_Position = 0;


	if (argc <2) { printf("You forgot the difficulty\n"); return 1;}
	int difficulty = atoi(argv[1]); // get difficulty from first command line arg
	// setup screen
	initscr();
	refresh();

	// Generate and draw the maze, with initial avatar
	generate_maze(difficulty);
	// Read gyroscope data to get ready for using moving averages.
	draw_maze();
	// Event loop
	draw_character(X_Position, Y_Position,AVATAR);
	int loopCount = 0;
	do
	{

		// Read data, update average
		scanf("%d, %lf, %lf, %lf", &t,&gx, &gy, &gz);
		// Is it time to move?  if so, then move avatar

		if (t > (time + 1000)) {
			if (MAZE[Y_Position +1][X_Position] == EMPTY_SPACE)
			{
				Y_Position++;
				draw_character(X_Position, Y_Position, AVATAR);
				draw_character(X_Position, Y_Position-1,EMPTY_SPACE);

			}
		if (MAZE[Y_Position][X_Position+1] == EMPTY_SPACE)
			{
			if (gx < -0.2) {
				X_Position += 1;
				draw_character(X_Position, Y_Position, AVATAR);
				draw_character(X_Position-1, Y_Position,EMPTY_SPACE);
				}
			}
			if (MAZE[Y_Position][X_Position-1] == EMPTY_SPACE)
				{
			 if (gx > 0.2) {
				X_Position -= 1;
				draw_character(X_Position, Y_Position, AVATAR);
				draw_character(X_Position+1, Y_Position,EMPTY_SPACE);
				}
			}
 		time = t;
		}

	count += 1;

} while(Y_Position < NUMROWS); // Change this to end game at right time

	// Print the win message
	endwin();



	printf("YOU WIN!\n");
	return 0;
}



/* Put your functions here */
void generate_maze(int difficulty){
	for (int i = 0; i < NUMROWS ;i++) {
		for (int j = 0; j < NUMCOLS; j++) {
			int r = rand() % 100;
			if (r < difficulty){
					MAZE[i][j] = WALL;
			}
			else if (r >= difficulty){
				MAZE[i][j] = EMPTY_SPACE;
			}
		}
	}
}
void draw_maze(void){
	for (int i = 0; i < NUMROWS ;i++) {
		for (int j = 0; j < NUMCOLS; j++) {
			draw_character(j, i ,MAZE[i][j]);
		}
	}
}

float calc_roll(float x_mag){
	if (x_mag > -1 && x_mag < 0) {
		x_mag = -1;
	}
	else if (x_mag > 1){
		x_mag = 1;
	}
	return x_mag;
}



// PRE: 0 < x < COLS, 0 < y < ROWS, 0 < use < 255
// POST: Draws character use to the screen and position x,y
//THIS CODE FUNCTIONS FOR PLACING THE AVATAR AS PROVIDED.
//
//    >>>>DO NOT CHANGE THIS FUNCTION.<<<<
void draw_character(int x, int y, char use)
{
	mvaddch(y,x,use);
	refresh();
}
