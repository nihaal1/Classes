// 185 Lab 7
#include <stdio.h>


#define MAXPOINTS 10000

// compute the average of the first num_items of buffer
double avg(double buffer[], int num_items);

//update the max and min of the first num_items of array
void maxmin(double array[], int num_items, double* max, double* min);

//shift length-1 elements of the buffer to the left and put the
//new_item on the right.
void updatebuffer(double buffer[], int length, double new_item);



int main(int argc, char* argv[]) {
	int i=0, b1, b2, b3, b4;
	double gx, gy, gz;

	/* DO NOT CHANGE THIS PART OF THE CODE */

	double x[MAXPOINTS], y[MAXPOINTS], z[MAXPOINTS];
	int lengthofavg = 0;
	if (argc>1) {
		sscanf(argv[1], "%d", &lengthofavg );
		printf("You entered a buffer length of %d\n", lengthofavg);
	}
	else {
		printf("Enter a length on the command line\n");
		return -1;
	}
	if (lengthofavg <1 || lengthofavg >MAXPOINTS) {
		printf("Invalid length\n");
		return -1;
	}



	/* PUT YOUR CODE HERE */
	while(i != lengthofavg){
		scanf("%lf, %lf, %lf, %d, %d, %d, %d \n",  gx, gy, gz, b1, b2, b3, b4);
		x[i] = gx;
		y[i] = gy;
		z[i] = gz;

		i++;
	}

// while(b4 == 0){
// 	avg(gx);
// 	maxmin(gx, &max, &min);
// 	updatebuffer(x);
// }


return 0;

}


/* Put your functions here */
double avg(double buffer[], int num_items){
	int sum = 0;
	for (int i = 0; i < num_items; i++) {
		sum += buffer[i];
	}
	return sum / num_items;
}

void maxmin(double array[], int num_items, double* max, double* min){
	*max = array[0];
	*min = array[0];

	for (int i = 0; i < num_items; i++) {
		if (array[i] > *max) {
			*max = array[i];
		}
		else if (array[i] < *min) {
			*min = array[i];
		}
	}
}


void updatebuffer(double buffer[], int length, double new_item){
	for (int i = 0; i < length; i++) {
		buffer[i] = buffer[i+1];
	}
	buffer[length - 1] = new_item;
}
