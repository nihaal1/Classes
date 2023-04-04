#include "adc.h"
#include <stdint.h>
#include <inc/tm4c123gh6pm.h>
#include <stdbool.h>
#include "driverlib/interrupt.h"
#include "timer.h"

// Global varibles

int ir_raw, ir_data;

void adc_init()
{
    SYSCTL_RCGCADC_R |= 0x01; //module init
    timer_waitMillis(1);
    SYSCTL_RCGCGPIO_R |= 0x02;
    timer_waitMillis(1);
    GPIO_PORTB_AFSEL_R |= 0x10;
    GPIO_PORTB_DEN_R &= 0xEF;
    GPIO_PORTB_AMSEL_R |= 0x10;

    //sample sequencer config
    ADC0_ACTSS_R &= 0xE;
    ADC0_SSMUX0_R |= 0x0A;
    ADC0_SSCTL0_R |= 0x06;
    ADC0_IM_R &= 0xFFFFFFFE;
    ADC0_SAC_R = 0x03;
    ADC0_ACTSS_R |= 0x1;
}

int adc_read()
{

    ADC0_PSSI_R = 0x01;
    while ((ADC0_RIS_R & 0x01) == 0)
        ;
    ir_raw = ADC0_SSFIFO0_R & 0xFFF;
    ADC0_ISC_R |=0x01;

    return (ir_raw);
}

