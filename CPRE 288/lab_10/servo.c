/*
 * servo.c
 *
 *  Created on: Jun 21, 2022
 *      Author: drboor
 */
#include "servo.h"
#include <stdint.h>
#include <inc/tm4c123gh6pm.h>
#include <stdbool.h>
#include "driverlib/interrupt.h"
#include "timer.h"
#include "ping.h"
#include "adc.h"

int sound_dist;
int IR_raw_val;

void servo_init(){
    SYSCTL_RCGCGPIO_R |= 0x02;
    SYSCTL_RCGCTIMER_R |= 0x2;
    timer_waitMillis(1);

    GPIO_PORTB_DIR_R   |= 0x20; //set PB5 to be a PWM timer output (timer 1b)
    GPIO_PORTB_AFSEL_R |=0x20;
    GPIO_PORTB_PCTL_R |=0x700000;
    GPIO_PORTB_DEN_R   |= 0x20;

    TIMER1_CTL_R &=0xFFFFFEFF;
    TIMER1_CFG_R |=0x04;
    TIMER1_TBMR_R |=0x0A;
    TIMER1_TBPR_R |=0x04;
    TIMER1_TBILR_R &=0x0;
    TIMER1_TBILR_R |=0xE200;
    TIMER1_TBMATCHR_R &=0x0;
    TIMER1_TBPMR_R |=0x04;
//    TIMER1_TBMATCHR_R |=0xC204;
//    TIMER1_TBMATCHR_R |=0xBD7A;
//    TIMER1_TBMATCHR_R |=0x51AA;
    TIMER1_TBMATCHR_R |=0xE200;
    TIMER1_CTL_R |=0x100;
}
void servo_move(float degrees){
    TIMER1_TBMATCHR_R=((-153.33*degrees)+48506);
    timer_waitMillis(200);
    sound_dist=ping_read();
   IR_raw_val=adc_read();
}




