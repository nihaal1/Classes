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
#include "cyBot_uart.h"
#include "cyBot_Scan.h"
#include "adc.h"
#include "uart_extra_help.h"
#include "ping.h"
#include "driverlib/interrupt.h"

extern volatile int start_count;
extern volatile int stop_count;
extern volatile int count;
extern volatile float diff;
extern volatile int overflow;
extern volatile float time;
int x;

int main(void)
{

    timer_init();
    lcd_init();
    ping_init();

    while (1)
    {

       x=ping_read();
        lcd_printf("%d  %d  %d  %f", x, overflow,(int) diff, (time*1000));

        timer_waitMillis(500);
    }

}

