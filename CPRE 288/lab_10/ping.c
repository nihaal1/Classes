#include "ping.h"
#include <stdint.h>
#include <inc/tm4c123gh6pm.h>
#include <stdbool.h>
#include "timer.h"


// Global varibles

volatile int count;
volatile int start_count;
volatile int stop_count;
volatile float diff;
volatile int overflow;
volatile float time;

void ping_init()
{
    SYSCTL_RCGCGPIO_R |= 0x02;
    SYSCTL_RCGCTIMER_R |= 0x8;
    timer_waitMillis(1);
    GPIO_PORTB_DEN_R   |= 0x08;
    TIMER3_CTL_R &=0xFFFFFEFF;
    TIMER3_CFG_R |=0x04;
    TIMER3_TBMR_R |=0x07;
    TIMER3_CTL_R |=0xC00;
    TIMER3_TBPR_R |=0xFF;
    TIMER3_TBILR_R |=0xFFFF;
    TIMER3_ICR_R |=0x400;
    TIMER3_IMR_R |=0x400;
    NVIC_EN1_R |=0x10;
    TIMER3_CTL_R |=0x100;

    IntRegister(INT_TIMER3B, ping_handler);

}

int ping_read()
{
    count=0;
    overflow=0;
    TIMER3_IMR_R &=0xFFFFFBFF;
    GPIO_PORTB_DIR_R   |= 0x08;
    GPIO_PORTB_AFSEL_R &=0xFFFFFFF7;
    GPIO_PORTB_DATA_R |= 0x08;
    timer_waitMicros(10);
    GPIO_PORTB_DATA_R &=0xFFFFFFF7;

    GPIO_PORTB_DIR_R   &= 0xFFFFFFF7;
    GPIO_PORTB_AFSEL_R |=0x08;
    GPIO_PORTB_PCTL_R |=0x7000;
    TIMER3_ICR_R |=0x400;
    TIMER3_IMR_R |=0x400;


    while(count!=2){

        while (count==1){
        if(TIMER3_TBR_R==0x0){
            overflow++;
        }
        }
    }




    diff=(start_count-stop_count);
    if(diff<0){
        diff=(0xFFFFFF-stop_count)+start_count;
    }
     time=diff/(32000000);
    float dist=time*34000;
    return ((int)dist);
}

void ping_handler() {
    TIMER3_ICR_R |=0x400;
    count++;

 if(count==1){
     start_count=TIMER3_TBR_R;

 }
 if(count==2){
      stop_count=TIMER3_TBR_R;

  }


}





