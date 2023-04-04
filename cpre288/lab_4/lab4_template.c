/**
 * lab4_template.c
 * 
 * Template file for CprE 288 lab 4
 *
 * @author Zhao Zhang, Chad Nelson, Zachary Glanz
 * @date 08/14/2016
 */

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
#include "button.h"

char header1[]="switch 1 \n \r";
    char header2[]="switch 2 \n \r";
    char header3[]="switch 3 \n \r";
    char header4[]="switch 4 \n \r";
    int i;

 // Functions for communiticate between CyBot and Putty (via UART)
                         // PuTTy: Buad=115200, 8 data bits, No Flow Control, No Party,  COM1


#define REPLACEME 0




int main(void) {
    int x=0;
	button_init();
	lcd_init();
	cyBot_uart_init();
	
	
	while(1)
	{
	   x=button_getButton();
  if (x=='4'){
      lcd_printf("switch 4");
        for(i=0;i<(strlen(header4));i++){
         cyBot_sendByte(header4[i]);
  }
	
	}
  else if (x=='3'){
        lcd_printf("switch 3");
          for(i=0;i<(strlen(header3));i++){
           cyBot_sendByte(header3[i]);
    }

      }
  else if (x=='2'){
        lcd_printf("switch 2");
          for(i=0;i<(strlen(header2));i++){
           cyBot_sendByte(header2[i]);
    }

      }
  else if (x=='1'){
        lcd_printf("switch 1");
          for(i=0;i<(strlen(header1));i++){
           cyBot_sendByte(header1[i]);
    }

      }
	
}
}
