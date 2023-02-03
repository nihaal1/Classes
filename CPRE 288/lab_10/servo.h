/*
 * servo.h
 *
 *  Created on: Jun 21, 2022
 *      Author: drboor
 */

#ifndef SERVO_H_
#define SERVO_H_

#include <stdint.h>
#include <inc/tm4c123gh6pm.h>
#include <stdbool.h>
#include "driverlib/interrupt.h"

void servo_init(void);
void servo_move(float degrees);



#endif /* SERVO_H_ */
