#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "inc/tm4c123gh6pm.h"
#include "timer.h"
#include "lcd.h"
#include "cyBot_uart.h"
#include "cyBot_Scan.h"
#include "open_interface.h"
#include "movement.h"
#include <math.h>

typedef struct{
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
int i;
int j;
int obj;
int no_obj;
int count;
int smallest_width=1000;
int smallest_angle;
double half_angle;
char header[]="Degrees  Distance (cm)   IR val \n \r";
char header2[]="Object#   Angle     Distance   Width(degrees)     Width(cm) \n \r";
char putty[500];
char putty2[500];



int main(void)
{
    timer_init();
    lcd_init();
    cyBOT_init_Scan(0b0111);
    right_calibration_value=327250;
    left_calibration_value=1293250;
    cyBot_uart_init();

    cyBOT_Scan_t scan;

    cyBOT_Scan(0,&scan);

    for(i=0;i<(strlen(header));i++){
        cyBot_sendByte(header[i]);
    }

       for(i=0;i<=180;i+=2){

           cyBOT_Scan(i,&scan);

           sound_dist[i/2]=(int)scan.sound_dist;
           ir_data[i/2]=scan.IR_raw_val;

//          float dist_new = scan.sound_dist;
//          int angles=i;
//          int ping_dists=(int)scan.sound_dist;
//          int ir_dists=scan.IR_raw_val;

//          float dist_old = scan.sound_dist;
//          float diff_dist = dis_old - dis_new;
//          printf("difference: %f", diff_dist);

          sprintf(putty," %03d       %03d         %03d  \n \r",i,(int)scan.sound_dist, scan.IR_raw_val);

          for(j=0;j<strlen(putty);j++){
                     cyBot_sendByte(putty[j]);
                 }


       }

count=0;
obj=0;
no_obj=0;

       for(i=0;i<(strlen(header2));i++){
           cyBot_sendByte(header2[i]);
       }

       for(i=0;i<91;i++){

           if (ir_data[i]>1000){
                   obj++;
               }

           if (ir_data[i]<1000 && obj>0){
                   no_obj++;
               }

           if(obj==3){
            count++;
            data[count].start_angle=(i*2)-4;
           }
           if((no_obj==2) && obj>=3){
               data[count].stop_angle=(i*2)-4;
               data[count].width_d=(data[count].stop_angle-data[count].start_angle);
               data[count].angle=(data[count].start_angle);
               data[count].distance=sound_dist[data[count].start_angle/2];
               half_angle=((((double)data[count].width_d)/2)*(3.14/180));
               data[count].width_cm=2*(sin(half_angle)*data[count].distance);
               obj=0;
               data[count].object=count;




               sprintf(putty2,"%03d       %03d          %03d       %03d               %03d  \n \r",data[count].object,data[count].angle,data[count].distance,data[count].width_d,data[count].width_cm);

                         for(j=0;j<strlen(putty2);j++){
                                    cyBot_sendByte(putty2[j]);
                                }

           }

       if((i==90) && obj>=3){
           data[count].stop_angle=(i*2)-4;
           data[count].width_d=(data[count].stop_angle-data[count].start_angle);
           data[count].angle=(data[count].start_angle);
           data[count].distance=sound_dist[data[count].start_angle/2];
           half_angle=(((data[count].width_d)/2)*(3.14/180));
           data[count].width_cm=2*(sin(half_angle)*data[count].distance);
           obj=0;
           data[count].object=count;




           sprintf(putty2,"%03d       %03d          %03d       %03d               %03d  \n \r",data[count].object,data[count].angle,data[count].distance,data[count].width_d,data[count].width_cm);

                     for(j=0;j<strlen(putty2);j++){
                                cyBot_sendByte(putty2[j]);
                                 }

            }
       if(no_obj==2){
            no_obj=0;
             obj=0;
                 }
            }

       for(i=1;i<count+1;i++){
           if (smallest_width>data[i].width_d){
               smallest_width=data[i].width_d;
               smallest_angle=data[i].angle;
           }
       }

       cyBOT_Scan(smallest_angle,&scan);


//           sprintf(putty,"%03d      %03d  \n \r",(i*2), sound_dist[i]);
//
//           for(j=0;j<strlen(putty);j++){
//                      cyBot_sendByte(putty[j]);
//                  }
//
//       }
//       }


//    for(i=0;i<=180;i+=2){
//        cyBOT_Scan(i,&scan);

//        cyBot_getByte();
//    }


//        while(1){
//            int move_command = cyBot_getByte();
//            int message_to_board = cyBot_getByte();
//                lcd_clear();
//                lcd_puts("Got an ");
//                lcd_putc(message_to_board);
//                cyBot_sendByte(message_to_board);
//
//        if(move_command=='w'){
//           move_forward(sensor_data, 10, 500);
//        }
//        if(move_command=='a'){
//            right_turn(sensor_data, -1);
//               }
//        if(move_command=='s'){
//               move_backward(sensor_data, -10, -500);
//               }
//        if(move_command=='d'){
//                 left_turn(sensor_data, 1);
//               }
//        }

    //    ssh_move();


    return 0;
}
