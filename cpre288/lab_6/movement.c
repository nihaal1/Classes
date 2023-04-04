#include "open_interface.h"
#include "movement.h"

void move_forward(oi_t *sensor_data, double dist, int speed) {
    double sum = 0;
         oi_setWheels((speed), speed-25); // move forward; full speed
         while (sum < dist) {
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
    move_backward(sensor_data,-150,-500);
    left_turn(sensor_data,90);
    move_forward(sensor_data,250,500);
    right_turn(sensor_data,-90);

        }

void move_left_bump(oi_t *sensor_data){
    move_backward(sensor_data,-150,-500);
    right_turn(sensor_data,-90);
    move_forward(sensor_data,250,500);
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
