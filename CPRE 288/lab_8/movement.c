#include "open_interface.h"
#include "movement.h"
#include "timer.h"
#include "lcd.h"
#include "uart_extra_help.h"
#include <stdint.h>
#include <stdbool.h>
#include <inc/tm4c123gh6pm.h>
#include "driverlib/interrupt.h"
#include "cyBot_uart.h"
#include "cyBot_Scan.h"


int i;
void move_forward(oi_t *sensor_data, double dist, int speed) {
    double sum = 0;
         oi_setWheels((speed), speed-25); // move forward; full speed
         while (sum < dist) {
         oi_update(sensor_data);
         sum += sensor_data->distance;
         }
         oi_setWheels(0, 0); // stop
}
void move_forward_auto(oi_t *sensor_data, double dist, int speed) {
    char header5[] = "Right Bump Detected \n \r";
    char header6[] = "Left Bump Detected \n \r";
    double sum = 0;
         oi_setWheels((speed), speed); // move forward; full speed
         while (sum < dist) {
        if (sensor_data->bumpLeft)
        {
            for (i = 0; i < (strlen(header6)); i++)
            {
                uart_sendChar (header6[i]);
            }
            move_left_bump(sensor_data);
            break;
        }
        if (sensor_data->bumpRight)
        {
            for (i = 0; i < (strlen(header5)); i++)
            {
                uart_sendChar (header5[i]);
            }
            move_right_bump(sensor_data);
            break;
        }
         oi_update(sensor_data);
         sum += sensor_data->distance;
         }
         oi_setWheels(0, 0); // stop
}

void right_turn(oi_t *sensor_data, double turn_angle) {
    oi_update(sensor_data);
    double turn = 0;
         oi_setWheels(-50, 50); // move forward; full speed
         while (turn > turn_angle) {
         oi_update(sensor_data);
         turn += sensor_data->angle;
         }
         oi_setWheels(0, 0); // stop
}

void left_turn(oi_t *sensor_data, double turn_angle){
    oi_update(sensor_data);
    double turn = 0;
    oi_setWheels(50, -50); // move forward; full speed
           while (turn < turn_angle) {
           oi_update(sensor_data);
           turn += sensor_data->angle;
           }
           oi_setWheels(0, 0); // stop
}

void move_right_bump(oi_t *sensor_data){
    move_backward(sensor_data,-30,-250);
    left_turn(sensor_data,90);
    move_forward(sensor_data,150,250);
    right_turn(sensor_data,-90);

        }

void move_left_bump(oi_t *sensor_data){
    move_backward(sensor_data,-30,-250);
    right_turn(sensor_data,-90);
    move_forward(sensor_data,150,250);
    left_turn(sensor_data,90);

        }


void move_backward(oi_t *sensor_data, double dist, int speed) {
    double sum = 0;
         oi_setWheels(speed, speed); // move forward; full speed
         while (sum > dist) {
         oi_update(sensor_data);
         sum += sensor_data->distance;
         }
         oi_setWheels(0, 0); // stop
}


void move_with_bumps(oi_t *sensor_data, double dist, int speed){
    double sum_final = 0;
            while (sum_final < dist) {
            oi_setWheels(speed, (speed-25)); // move forward; full speed
            oi_update(sensor_data);
            sum_final += sensor_data->distance;
            if (sensor_data->bumpLeft) {
            // respond to left bumper being pressed
              move_left_bump(sensor_data);
              sum_final-=150;
                }
            else if (sensor_data->bumpRight){
                 // respond to right bumper being pressed
              move_right_bump(sensor_data);
              sum_final-=150;
                    }
            }
            oi_setWheels(0, 0); // stop

}
