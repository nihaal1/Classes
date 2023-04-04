#ifndef MOVEMENT_H_
#define MOVEMENT_H_

#include "Timer.h"
#include "lcd.h"
#include "open_interface.h"


void move_forward(oi_t *sensor_data, double dist, int speed);

void right_turn(oi_t *sensor_data, double turn_angle);

void left_turn(oi_t *sensor_data, double turn_angle);

void left_bump(oi_t *sensor_data);

void move_backward(oi_t *sensor_data, double dist, int speed);

void move_right_bump(oi_t *sensor_data);

void move_left_bump(oi_t *sensor_data);

void move_with_bumps(oi_t *sensor_data, double dist, int speed);

#endif
