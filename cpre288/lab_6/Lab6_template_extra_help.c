/**
 * lab6_template_extra_help.c
 *
 * Description: This is file is meant for those that would like a little
 *              extra help with formatting their code.
 *
 */

#define _RESET 1
#define _PART1 0
#define _PART2 0
#define _PART3 0

#include "timer.h"
#include "lcd.h"
#include "uart_extra_help.h"
#include <stdint.h>
#include <stdbool.h>
#include <inc/tm4c123gh6pm.h>
#include "driverlib/interrupt.h"
#include "movement.h"
#include "cyBot_uart.h"
#include "cyBot_Scan.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "open_interface.h"
#include <math.h>


#if _RESET
//#include "Simulation_User Files_resetSimulation.h"
#endif

// Adding global volatile varibles for communcating between 
// your Interupt Service Routine, and your non-interupt code.

volatile  char uart_data;  // Your UART interupt code can place read data here
volatile  char flag;       // Your UART interupt can update this flag
                           // to indicate that it has placed new data
                           // in uart_data                     

int i = 0;
char text[21];
char header[] = "Degrees  Distance (cm) \n \r";
char header2[] = "Object#   Angle     Distance   Width(degrees)     Width(cm) \n \r";
char header3[] = "Manual mode \n \r";
char header4[] = "Automatic mode \n \r";
char move_command;

typdef struct {
    int object;
    int angle;
    int distance;
    int width_d;
    int start_angle;
    int stop_angle;
    int width_cm;
} data1;

data1 data[100];
int sound_dist[100];
int ir_data[100];



void main()
{
#if _RESET
    resetSimulationBoard();
#else

    timer_init();
    lcd_init();
    uart_init(115200);

//#if _PART1      // Receive and display text
//    while(1){
//        for (i=0; i<20; i++){
//            if (uart_recieve() == '\r'){
//                text[i] = '\0';
//                break;
//            }
//            else{
//                text[i] = uart_recieve();
//            }
//        }
//            lcd_printf("%s",text);
//    }

//        while(1){
//
//          for(i=0;i<20;i++){
//              y=uart_receive();
//              if(y=='\r'){
//                  header[i]='\0';
//                  break;
//              }
//              else{
//                  header[i]=y;
//              }
//          }
//          lcd_printf("%s",header);
//        }

//#endif

//#if _PART2      // Echo Received Character
//    while(1){
//        x = uart_recieve()
//
//    }

//#endif

//#if _PART3 // Receive and send characters using interrupts.

    oi_t *sensor_data = oi_alloc();
    oi_init(sensor_data);
while(1){
    int move_command = uart_recieve();
    if (move_command == 't'){
        count1++;
        if (count1%2 == 0){
            for (i = 0; i < strlen(header3); i++){
                uart_sendChar(header3[i]);
            }
        }
        if (count1%2 == 1)
        {
            for (i = 0; i < strlen(header4); i++)
            {
                uart_sendChar(header4[i]);
            }
        }
    }
// manual mode
    if (count1%2 == 0){
        if (move_command == 'w'){
            move_forward(sensor_data,1,500);
        }
        if (move_command == 'a')
        {
            left_turn(sensor_data, 1);
        }
        if (move_command == 's')
        {
            move_backward(sensor_data, -1, -500);
        }
        if (move_command == 'd')
        {
            right_turn(sensor_data, -1);
        }
        if (move_command == 'm'){
            cyBot_Scan(0,&scan);
            for (i = 0; i < (strlen(header)); i++)
                {
                uart_sendChar(header3[i]);
                }
            for (i = 0; i <= 180; i+=2)){
                cyBot_scan(i,&scan);
                if (scan.IR_raw_val >= 1750)
                          {
                            ir_data[i / 2] = 33 - (.0093 * scan.IR_raw_val);
                          }
                          if (scan.IR_raw_val >= 1300 && scan.IR_raw_val < 1750)
                          {
                              ir_data[i / 2] = 62 - (.026 * scan.IR_raw_val);
                          }
                          if (scan.IR_raw_val >= 1180 && scan.IR_raw_val < 1300)
                          {
                              ir_data[i / 2] = 101.2 - (.0565 * scan.IR_raw_val);
                          }
                          if (scan.IR_raw_val >= 1000 && scan.IR_raw_val < 1180)
                          {
                              ir_data[i / 2] = 137 - (.0872 * scan.IR_raw_val);
                          }

                          if(scan.IR_raw_val < 1000){
                              ir_data[i / 2] =100;
                          }
                          sprintf(putty,"%03d    %03d \n \r", i, ir_data[1/2]);
                          for(i = 0; i<strlen(putty); i++)){
                              uart_sendChar(putty[i])
                          }
            }
        }
        for(i = 0; i < strlen(header2); i++){
                uart_sendChar(header2[i])
            }
    }
    for (i = 0; i < 91; i++)
        {

            if (ir_data[i] < 50)
            {
                obj++;
            }

            if (ir_data[i] > 50 && obj > 0)
            {
                no_obj++;
            }

            if (obj == 3)
            {
                count++;
                data[count].start_angle = (i * 2) - 4;
            }
            if ((no_obj == 2) && obj >= 3)
            {
                data[count].stop_angle = (i * 2) - 4;
                data[count].width_d = (data[count].stop_angle
                        - data[count].start_angle);
                data[count].angle = (data[count].start_angle);
                data[count].distance = ir_data[(data[count].start_angle / 2)+2];
                half_angle = ((((double) data[count].width_d) / 2) * (3.14 / 180));
                data[count].width_cm = 2 * (sin(half_angle) * data[count].distance);
                obj = 0;
                data[count].object = count;

                sprintf(putty2,
                        "%03d       %03d          %03d       %03d               %03d  \n \r",
                        data[count].object, data[count].angle, data[count].distance,
                        data[count].width_d, data[count].width_cm);

                for (j = 0; j < strlen(putty2); j++)
                {
                    uart_sendChar (putty2[j]);
                }

            }

            if ((i == 90) && obj >= 3)
            {
                data[count].stop_angle = (i * 2) - 4;
                data[count].width_d = (data[count].stop_angle
                        - data[count].start_angle);
                data[count].angle = (data[count].start_angle);
                data[count].distance = ir_data[data[count].start_angle / 2];
                half_angle = ((((double) data[count].width_d) / 2) * (3.14 / 180));
                data[count].width_cm = 2 * (sin(half_angle) * data[count].distance);
                obj = 0;
                data[count].object = count;

                sprintf(putty2,
                        "%03d       %03d          %03d       %03d               %03d  \n \r",
                        data[count].object, data[count].angle, data[count].distance,
                        data[count].width_d, data[count].width_cm);

                for (j = 0; j < strlen(putty2); j++)
                {
                    uart_sendChar(putty2[j]);
                }

            }
            if (no_obj == 2)
            {
                no_obj = 0;
                obj = 0;
            }
        }

                    for (i = 1; i < count + 1; i++)
                    {
                        if (smallest_width > data[i].width_d)
                        {
                            smallest_width = data[i].width_d;
                            smallest_angle = data[i].angle;
                            smallest_dist = (double) data[i].distance;
                        }
                    }

//auto mode
if (count1%2 == 1){
    for (i = 0; i < stlen(header);i++){
        uart_sendChar(header[i]);
    }
    for (i = 0; i <= 180; i += 2)
                   {

                       cyBOT_Scan(i, &scan);

                       if (scan.IR_raw_val >= 1750)
                         {
                           ir_data[i / 2] = 33 - (.0093 * scan.IR_raw_val);
                         }
                         if (scan.IR_raw_val >= 1300 && scan.IR_raw_val < 1750)
                         {
                             ir_data[i / 2] = 62 - (.026 * scan.IR_raw_val);
                         }
                         if (scan.IR_raw_val >= 1180 && scan.IR_raw_val < 1300)
                         {
                             ir_data[i / 2] = 101.2 - (.0565 * scan.IR_raw_val);
                         }
                         if (scan.IR_raw_val >= 1000 && scan.IR_raw_val < 1180)
                         {
                             ir_data[i / 2] = 137 - (.0872 * scan.IR_raw_val);
                         }

                         if(scan.IR_raw_val < 1000){
                             ir_data[i / 2] =100;
                         }


                       sprintf(putty, " %03d       %03d  \n \r", i,ir_data[i / 2]);

                       for (j = 0; j < strlen(putty); j++)
                       {
                           uart_sendChar (putty[j]);
                       }
                   }

                count = 0;
                  obj = 0;
                  no_obj = 0;
                  smallest_width=1000;




                  for (i = 0; i < (strlen(header2)); i++)
                  {
                      uart_sendChar (header2[i]);
                  }

                  for (i = 0; i < 91; i++)
                  {

                      if (ir_data[i] < 50)
                      {
                          obj++;
                      }

                      if (ir_data[i] > 50 && obj > 0)
                      {
                          no_obj++;
                      }

                      if (obj == 3)
                      {
                          count++;
                          data[count].start_angle = (i * 2) - 4;
                      }
                      if ((no_obj == 2) && obj >= 3)
                      {
                          data[count].stop_angle = (i * 2) - 4;
                          data[count].width_d = (data[count].stop_angle
                                  - data[count].start_angle);
                          data[count].angle = (data[count].start_angle);
                          data[count].distance = ir_data[(data[count].start_angle / 2)+2];
                          half_angle = ((((double) data[count].width_d) / 2) * (3.14 / 180));
                          data[count].width_cm = 2 * (sin(half_angle) * data[count].distance);
                          obj = 0;
                          data[count].object = count;

                          sprintf(putty2,
                                  "%03d       %03d          %03d       %03d               %03d  \n \r",
                                  data[count].object, data[count].angle, data[count].distance,
                                  data[count].width_d, data[count].width_cm);

                          for (j = 0; j < strlen(putty2); j++)
                          {
                              uart_sendChar (putty2[j]);
                          }

                      }

                      if ((i == 90) && obj >= 3)
                      {
                          data[count].stop_angle = (i * 2) - 4;
                          data[count].width_d = (data[count].stop_angle
                                  - data[count].start_angle);
                          data[count].angle = (data[count].start_angle);
                          data[count].distance = ir_data[(data[count].start_angle / 2)+2];
                          half_angle = ((((double) data[count].width_d) / 2) * (3.14 / 180));
                          data[count].width_cm = 2 * (sin(half_angle) * data[count].distance);
                          obj = 0;
                          data[count].object = count;

                          sprintf(putty2,
                                  "%03d       %03d          %03d       %03d               %03d  \n \r",
                                  data[count].object, data[count].angle, data[count].distance,
                                  data[count].width_d, data[count].width_cm);

                          for (j = 0; j < strlen(putty2); j++)
                          {
                              uart_sendChar(putty2[j]);
                          }

                      }
                      if (no_obj == 2)
                      {
                          no_obj = 0;
                          obj = 0;
                      }
                  }

                  for (i = 1; i < count + 1; i++)
                  {
                      if (smallest_width > data[i].width_d)
                      {
                          smallest_width = data[i].width_d;
                          smallest_angle = data[i].angle;
                          smallest_dist=(double)data[i].distance;
                      }
                  }
                  if (smallest_angle < 40)
                              {
                                  right_turn(sensor_data, (smallest_angle - 90) + 7);
                                  move_forward(sensor_data, (smallest_dist * 10) - 95, 250);
                              }
                              if (smallest_angle > 140)
                              {
                                  left_turn(sensor_data, (smallest_angle - 90) - 7);
                                  move_forward(sensor_data, (smallest_dist * 10) - 115, 250);
                              }
                              if (smallest_angle > 70 && smallest_angle <= 90)
                              {
                                  right_turn(sensor_data, (smallest_angle - 90) + 7);
                                  move_forward(sensor_data, (smallest_dist * 10) - 55, 250);
                              }
                              if (smallest_angle > 90 && smallest_angle <= 110)
                              {
                                  left_turn(sensor_data, (smallest_angle - 90) - 7);
                                  move_forward(sensor_data, (smallest_dist * 10) - 55, 250);
                              }
                              if (smallest_angle >= 40 && smallest_angle <= 70)
                              {
                                  right_turn(sensor_data, (smallest_angle - 90) + 7);
                                  move_forward(sensor_data, (smallest_dist * 10) - 75, 250);
                              }
                              if (smallest_angle > 110 && smallest_angle <= 140)
                              {
                                  left_turn(sensor_data, (smallest_angle - 90) - 7);
                                  move_forward(sensor_data, (smallest_dist * 10) - 75, 250);
                              }
}


}
}
