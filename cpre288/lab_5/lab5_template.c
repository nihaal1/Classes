/**
 * lab5_template.c
 * 
 * Template file for CprE 288 lab 5
 *
 * @author Zhao Zhang, Chad Nelson, Zachary Glanz
 * @date 08/14/2016
 *
 * @author Phillip Jones, updated 6/4/2019
 */

#include "button.h"
#include "timer.h"
#include "lcd.h"



#include "cyBot_uart.h"  // Functions for communiticate between CyBot and Putty (via UART)
                         // PuTTy: Buad=115200, 8 data bits, No Flow Control, No Party,  COM1

#include "cyBot_Scan.h"  // For scan sensors



#define REPLACEME 0


// Defined in button.c : Used to communicate information between the
// the interupt handeler and main.
extern volatile int button_event;
extern volatile int button_num;
cyBOT_Scan_t scan;
char putty[500];
int i, j;
double distance;






int main(void) {
    int x=0;
    button_init();
    init_button_interrupts();
    lcd_init();




     cyBot_uart_init_clean();  // Clean UART initialization, before running your UART GPIO init code

////   Complete this code for configuring the  (GPIO) part of UART initialization
//      SYSCTL_RCGCGPIO_R |= 0x02;
//      timer_waitMillis(1);            // Small delay before accessing device after turning on clock
//      GPIO_PORTB_AFSEL_R |=0x03;
//      GPIO_PORTB_PCTL_R &= 0xFFFFFF00;     // Force 0's in the disired locations
//      GPIO_PORTB_PCTL_R |= 0x011;     // Force 1's in the disired locations
//      GPIO_PORTB_DEN_R |= 0x03;
//      GPIO_PORTB_DIR_R &= 0xFFFFFFFD;      // Force 0's in the disired locations
//      GPIO_PORTB_DIR_R |= 0x02;      // Force 1's in the disired locataions

     SYSCTL_RCGCGPIO_R |= 0b000010; // Guven below as port B AFSEL..
         timer_waitMillis(1);            // Small delay before accessing device after turning on clock
         GPIO_PORTB_AFSEL_R |= 0x03;
         GPIO_PORTB_PCTL_R &= 0xFFFFFF00;     // Force 0's in the disired locations
         GPIO_PORTB_PCTL_R |= 0x00000011;     // Force 1's in the disired locations
         GPIO_PORTB_DEN_R |= 0x03;
         GPIO_PORTB_DIR_R &= 0xFE;        // Force 0's in the disired locations           //0xFD ##########
         GPIO_PORTB_DIR_R |= 0x02;      // Force 1's in the disired locataions

     cyBot_uart_init_last_half();  // Complete the UART device initialization part of configuration


     cyBOT_init_Scan(0b0111);
     right_calibration_value=327250;
     left_calibration_value=1293250;

     while(1){

               cyBOT_Scan(90,&scan);

               if(scan.IR_raw_val>2000 || scan.IR_raw_val< 1040 ){
                   distance=75.735-(.0263*(double)scan.IR_raw_val);
               }
               if(scan.IR_raw_val<=2000 && scan.IR_raw_val>=1180){
                 distance=65.735-(.0263*(double)scan.IR_raw_val);
                              }
               if(scan.IR_raw_val<1180 && scan.IR_raw_val>=1040){
                 distance=70-(.0263*(double)scan.IR_raw_val);
                                             }


              sprintf(putty," %03d    %03d \n \r", (int)distance, scan.IR_raw_val);

              for(j=0;j<strlen(putty);j++){
                         cyBot_sendByte(putty[j]);
                     }


           }




            while(1)
            {



}
}
