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
#include "adc.h"
#include "uart_extra_help.h"
#include "ping.h"
#include "driverlib/interrupt.h"
#include "servo.h"
#include "button.h"

//extern volatile int button_event;
//extern volatile int button_num;
//int multiplier=1, incr=0, current_angle=90;

//int main(void)
//
//{
//
//    timer_init();
//    lcd_init();
//    servo_init();
//    button_init();
//    init_button_interrupts();
//    servo_move(90);
//
//    while(1){
//        if(multiplier==1){
//        lcd_printf("%d increasing", current_angle);
//        }
//        if(multiplier==-1){
//          lcd_printf("%d decreasing", current_angle);
//                }
//        if(button_event==1){
//            if(button_num==1){
//                button_event = 0;
//                current_angle+=multiplier;
//                servo_move(current_angle);
//                timer_waitMillis(200);
//            }
//            if(button_num==2){
//                button_event = 0;
//                current_angle+=multiplier*5;
//                servo_move(current_angle);
//                timer_waitMillis(200);
//                        }
//            if(button_num==3){
//                incr++;
//                timer_waitMillis(200);
//                button_event = 0;
//                if (incr%2==0){
//                    multiplier=1;
//
//                }
//                if (incr%2==1){
//                   multiplier=-1;
//                                }
//                        }
//            if(button_num==4){
//                button_event = 0;
//                if(multiplier==-1){
//                    servo_move(0);
//                    current_angle=0;
//                    timer_waitMillis(200);
//                }
//                if(multiplier==1){
//                   servo_move(180);
//                   current_angle=180;
//                   timer_waitMillis(200);
//                                }
//                        }
//        }
//    }
//
//}


    int ir_raw;
    int ir_data1[90];
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
    int ir_data11[100];
    int j,q, adc_raw;
    int obj;
    int no_obj;
    int count0;
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
    extern int IR_raw_val, sound_dist;

    void main (){

        timer_init();
        lcd_init();
        adc_init();
        uart_init(115200);
        servo_init();
        ping_init();



       oi_t *sensor_data = oi_alloc();
      oi_init(sensor_data);


     servo_move(90);




//        q=(673156*(pow(IR_raw_val(),-1.44)));

    //    lcd_printf("%d   %d", adc_raw, q);


    //    sprintf(putty, " %03d \n \r", q);
    //
    //                  for (j = 0; j < strlen(putty); j++)
    //                  {
    //                      uart_sendChar(putty[j]);
    //                  }
         timer_waitMillis(500);


         while (1)
           {

               int move_command = uart_receive();
               if (move_command == 't')
               {
                   count1++;
                   if (count1 % 2 == 0)
                   {
                       for (i = 0; i < (strlen(header3)); i++)
                       {
                           uart_sendChar(header3[i]);
                       }
                   }
                   if (count1 % 2 == 1)
                   {
                       for (i = 0; i < (strlen(header4)); i++)
                       {
                           uart_sendChar(header4[i]);
                       }
                   }
               }

               if (count1 % 2 == 0)
               {

                   if (move_command == 'w')
                   {
                       move_forward(sensor_data, 1, 250);
                       for (i = 0; i < (strlen(header7)); i++)
                       {
                           uart_sendChar(header7[i]);
                       }
                       if (sensor_data->bumpLeft)
                       {
                           for (i = 0; i < (strlen(header6)); i++)
                           {
                               uart_sendChar(header6[i]);
                           }
                           timer_waitMillis(1000);
                       }
                       if (sensor_data->bumpRight)
                       {
                           for (i = 0; i < (strlen(header5)); i++)
                           {
                               uart_sendChar(header5[i]);
                           }
                           timer_waitMillis(1000);

                       }
                   }
                   if (move_command == 'a')
                   {
                       left_turn(sensor_data, 1);
                       for (i = 0; i < (strlen(header8)); i++)
                       {
                           uart_sendChar(header8[i]);
                       }
                   }
                   if (move_command == 's')
                   {
                       move_backward(sensor_data, -1, -250);
                   }
                   if (move_command == 'd')
                   {
                       right_turn(sensor_data, -1);
                       for (i = 0; i < (strlen(header8)); i++)
                       {
                           uart_sendChar(header8[i]);
                       }
                   }

                   if (move_command == 'm')
                   {
                       servo_move(0);

                       for (i = 0; i < (strlen(header)); i++)
                       {
                           uart_sendChar(header[i]);
                       }

                       for (i = 0; i <= 180; i += 2)
                       {

                           servo_move(i);


                           ir_data1[i/2]=(673156*(pow(IR_raw_val,-1.44)));

                           sprintf(putty, " %03d       %03d  \n \r", i,
                                   ir_data11[i / 2]);

                           for (j = 0; j < strlen(putty); j++)
                           {
                               uart_sendChar(putty[j]);
                           }

                       }

                       count0 = 0;
                       obj = 0;
                       no_obj = 0;
                       too_close=0;

                       for (i = 0; i < (strlen(header2)); i++)
                       {
                           uart_sendChar(header2[i]);
                       }

                       for (i = 0; i < 91; i++)
                       {

                           if (ir_data11[i] <= 50 && ir_data11[i] > 8)
                           {
                               obj++;
                           }

                           if ((ir_data11[i] > 50 || ir_data11[i]<9) && obj > 0)
                           {
                               no_obj++;
                           }

                           if (obj == 3)
                           {
                               count0++;
                               data[count0].start_angle = (i * 2) - 4;
                           }
                           if ((no_obj == 2) && obj >= 3)
                           {
                               data[count0].stop_angle = (i * 2) - 4;
                               data[count0].width_d = (data[count0].stop_angle
                                       - data[count0].start_angle);
                               data[count0].angle = (data[count0].start_angle);
                               obj = 0;
                               data[count0].object = count0;
                               data[count0].half_angle = (((double) data[count0].width_d)
                                       / 2);
                               data[count0].dist_angle = data[count0].half_angle
                                       + (double) data[count0].start_angle;

                           }

                           if ((i == 90) && obj >= 3)
                           {
                               data[count0].stop_angle = (i * 2) - 4;
                               data[count0].width_d = (data[count0].stop_angle
                                       - data[count0].start_angle);
                               data[count0].angle = (data[count0].start_angle);
                               obj = 0;
                               data[count0].object = count0;
                               data[count0].half_angle = (((double) data[count0].width_d)
                                       / 2);
                               data[count0].dist_angle = data[count0].half_angle
                                       + (double) data[count0].start_angle;

                           }
                           if (no_obj == 2)
                           {
                               no_obj = 0;
                               obj = 0;
                           }
                       }
                       for (i = 1; i < count0 + 1; i++)
                       {

                           servo_move((int) data[i].dist_angle);  // to turn
                           timer_waitMillis(1000);                // don't collect data
                           servo_move((int) data[i].dist_angle);  //collect data

                           data[i].distance = sound_dist;
                           data[i].width_cm = 2
                                   * ((sin(data[i].half_angle * (3.14 / 180)))
                                           * data[i].distance);

                           sprintf(putty2,
                                   "%03d       %03d          %03d       %03d               %03d  \n \r",
                                   data[i].object, (int) data[i].dist_angle,
                                   data[i].distance, data[i].width_d,
                                   data[i].width_cm);

                           for (j = 0; j < strlen(putty2); j++)
                           {
                               uart_sendChar(putty2[j]);
                           }
                       }
                   }

               }


               if (count1 % 2 == 1) //automatic mode
               {
                   dummy=0;
                 while((UART1_DR_R & 0xFF)!='x'){

                     servo_move(90);
                     timer_waitMillis(1000);
                     servo_move(90);

                 if((sound_dist <40) && dummy==0){
                   servo_move(0);

                   for (i = 0; i < (strlen(header)); i++)
                   {
                       uart_sendChar(header[i]);
                   }

                   for (i = 0; i <= 180; i += 2)
                   {


                       servo_move(i);

                       ir_data1[i/2]=(673156*(pow(IR_raw_val,-1.44)));


                       sprintf(putty, " %03d       %03d  \n \r", i, ir_data1[i / 2]);

                       for (j = 0; j < strlen(putty); j++)
                       {
                           uart_sendChar(putty[j]);
                       }

                   }

                   count0 = 0;
                   obj = 0;
                   no_obj = 0;
                   smallest_width=1000;

                   for (i = 0; i < (strlen(header2)); i++)
                   {
                       uart_sendChar(header2[i]);
                   }

                   for (i = 0; i < 91; i++)
                   {

                       if(ir_data1[i]<9){
                           move_backward(sensor_data,-50,-200);
                           too_close=1;
                           break;
                       }

                       if (ir_data1[i] < 50)
                       {
                           obj++;
                           no_obj=0;
                       }

                       if ((ir_data1[i] > 50) && obj > 0)
                       {
                           no_obj++;
                       }

                       if (obj == 3)
                       {
                           count0++;
                           data[count0].start_angle = (i * 2) - 4;
                       }
                       if ((no_obj == 2) && obj >= 3)
                       {
                           data[count0].stop_angle = (i * 2) - 4;
                           data[count0].width_d = (data[count0].stop_angle
                                   - data[count0].start_angle);
                           data[count0].angle = (data[count0].start_angle);
                           obj = 0;
                           data[count0].object = count0;
                           data[count0].half_angle =
                                   (((double) data[count0].width_d) / 2);
                           data[count0].dist_angle = data[count0].half_angle
                                   + (double) data[count0].start_angle;

                       }

                       if ((i == 90) && obj >= 3)
                       {
                           data[count0].stop_angle = (i * 2);
                           data[count0].width_d = (data[count0].stop_angle
                                   - data[count0].start_angle);
                           data[count0].angle = (data[count0].start_angle);
                           obj = 0;
                           data[count0].object = count0;
                           data[count0].half_angle =
                                   (((double) data[count0].width_d) / 2);
                           data[count0].dist_angle = data[count0].half_angle
                                   + (double) data[count0].start_angle;

                       }
                       if (no_obj == 2)
                       {
                           no_obj = 0;
                           obj = 0;
                       }
                   }
                   if(too_close==0){
                   for (i = 1; i < count0 + 1; i++)
                   {

                       servo_move((int) data[i].dist_angle);  // to turn
                       timer_waitMillis(1000);                // don't collect data
                       servo_move((int) data[i].dist_angle);  //collect data
                       data[i].distance = sound_dist;
                       data[i].width_cm = 2
                               * ((sin(data[i].half_angle * (3.14 / 180)))
                                       * data[i].distance);

                       sprintf(putty2,
                               "%03d       %03d          %03d       %03d               %03d  \n \r",
                               data[i].object, (int) data[i].dist_angle,
                               data[i].distance, data[i].width_d, data[i].width_cm);

                       for (j = 0; j < strlen(putty2); j++)
                       {
                           uart_sendChar(putty2[j]);
                       }
                   }
                   for (i = 1; i < count0 + 1; i++)
                                {
                                    if (smallest_width > data[i].width_cm)
                                    {
                                        smallest_width = data[i].width_cm;
                                        smallest_angle = data[i].dist_angle;
                                        smallest_dist=(double)data[i].distance;
                                    }
                                }


                              if (smallest_angle < 40)
                              {
                                  right_turn(sensor_data, (smallest_angle - 90) + 7);
                                  move_forward_auto(sensor_data, (smallest_dist * 10) - 155, 250);
                              }
                              if (smallest_angle > 140)
                              {
                                  left_turn(sensor_data, (smallest_angle - 90) - 7);
                                  move_forward_auto(sensor_data, (smallest_dist * 10) - 165, 250);
                              }
                              if (smallest_angle > 70 && smallest_angle <= 90)
                              {
                                  right_turn(sensor_data, (smallest_angle - 90) + 7);

                                  move_forward_auto(sensor_data, (smallest_dist * 10) - 95, 250);
                              }
                              if (smallest_angle > 90 && smallest_angle <= 110)
                              {
                                  left_turn(sensor_data, (smallest_angle - 90) - 7);
                                  move_forward_auto(sensor_data, (smallest_dist * 10) - 95, 250);
                              }
                              if (smallest_angle >= 40 && smallest_angle <= 70)
                              {
                                  right_turn(sensor_data, (smallest_angle - 90) + 7);
                                  move_forward_auto(sensor_data, (smallest_dist * 10) - 135, 250);
                              }
                              if (smallest_angle > 110 && smallest_angle <= 140)
                              {
                                  left_turn(sensor_data, (smallest_angle - 90) - 7);
                                  move_forward_auto(sensor_data, (smallest_dist * 10) - 135, 250);
                              }


                   if(count0>=1){
                   dummy=1;
                   }
                   break;

                 }

                   too_close=0;
                 }
                 else{ move_forward_auto(sensor_data,300,250);
                                    timer_waitMillis(1000);
                 }

                 }
               }
           }




}

