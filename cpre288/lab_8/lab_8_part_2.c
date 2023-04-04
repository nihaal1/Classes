#include "timer.h"
#include "lcd.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "open_interface.h"
#include <math.h>
#include <inc/tm4c123gh6pm.h>
#include "driverlib/interrupt.h"
#include "movement.h"
#include "cyBot_uart.h"
#include "cyBot_Scan.h"
#include "adc.h"
#include "uart_extra_help.h"


int ir_raw, ir_data;
char header3[25];
char x;
char y;
int i, dummy=0;
char move_command;

typedef struct
{
    int object;
    int angle;
    int distance;
    int width_d;
    int start_angle;
    int stop_angle;
    int width_cm;
    double half_angle;
    double dist_angle;
} data1;

data1 data[100];
int sound_dist[100];
int ir_data1[100];
int j,q, adc_raw;
int obj;
int no_obj;
int count;
int smallest_width = 1000;
int smallest_angle;
char header[] = "Degrees  Distance (cm) \n \r";
char header2[] =
        "Object#   Angle     Distance   Width(degrees)     Width(cm) \n \r";
char header3[] = "Manual mode\n \r";
char header4[] = "Automatic mode\n \r";
char header5[] = "Right Bump Detected \n \r";
char header6[] = "Left Bump Detected \n \r";
char header7[] = "1 cm forward \n \r";
char header8[] = "turn 1 degree \n \r";
char putty[500];
char putty2[500];
double distance;
int ir_dist_total;
int count1 = 0, too_close=0;
double smallest_dist;

void main (){

    timer_init();
    lcd_init();
    adc_init();
    uart_init(115200);
    cyBOT_init_Scan(0b0011);
    right_calibration_value = 327250;
    left_calibration_value = 1293250;

    cyBOT_Scan_t scan;

//   oi_t *sensor_data = oi_alloc();
//   oi_init(sensor_data);





    adc_raw=adc_read();

    q=(673156*(pow(adc_raw,-1.44)));

    lcd_printf("%d   %d", adc_raw, q);


//    sprintf(putty, " %03d \n \r", q);
//
//                  for (j = 0; j < strlen(putty); j++)
//                  {
//                      uart_sendChar(putty[j]);
//                  }
     timer_waitMillis(500);







}





