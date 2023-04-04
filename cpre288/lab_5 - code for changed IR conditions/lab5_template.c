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
int ir_dist_total;

char header1[]="switch 1 \n \r";
char header2[]="switch 2 \n \r";
char header3[]="switch 3 \n \r";
char header4[]="switch 4 \n \r";
int j;





int main(void) {
    int x=0;
    button_init();
    init_button_interrupts();
    lcd_init();


	

     cyBot_uart_init_clean();  // Clean UART initialization, before running your UART GPIO init code

//	 Complete this code for configuring the  (GPIO) part of UART initialization
      SYSCTL_RCGCGPIO_R |= 0x02;
      timer_waitMillis(1);            // Small delay before accessing device after turning on clock
      GPIO_PORTB_AFSEL_R |=0x03;
      GPIO_PORTB_PCTL_R &= 0xFFFFFF00;     // Force 0's in the disired locations
      GPIO_PORTB_PCTL_R |= 0x011;     // Force 1's in the disired locations
      GPIO_PORTB_DEN_R |= 0x03;
      GPIO_PORTB_DIR_R &= 0xFFFFFFFD;      // Force 0's in the disired locations
      GPIO_PORTB_DIR_R |= 0x02;      // Force 1's in the disired locataions
    
     cyBot_uart_init_last_half();  // Complete the UART device initialization part of configuration
	

     cyBOT_init_Scan(0b0111);
     right_calibration_value=327250;
     left_calibration_value=1293250;
     ir_dist_total=0;

     for(i=0;i<10;i++){
         cyBOT_Scan(90,&scan);
         ir_dist_total = ir_dist_total + scan.IR_raw_val;

     }

     ir_dist_total=ir_dist_total/10;


               if(ir_dist_total>=1750){
                 distance=33-(.0093*ir_dist_total);
                                             }
               if(ir_dist_total>=1300 && ir_dist_total<1750){
                 distance=62-(.026*ir_dist_total);
                            }
               if(ir_dist_total>=1180 && ir_dist_total<1300){
                  distance=101.2-(.0565*ir_dist_total);
                            }
               if(ir_dist_total>=1000 && ir_dist_total<1180){
                                distance=137-(.0872*ir_dist_total);
                                           }



              sprintf(putty," %03d    %03d \n \r", (int)distance, ir_dist_total);

              for(j=0;j<strlen(putty);j++){
                         cyBot_sendByte(putty[j]);
                     }




		
	

	        while(1)
	        {
	            if( button_event == 1){
	            if (button_num=='4'){
	                               lcd_printf("switch 4");
	                               for(j=0;j<(strlen(header4));j++){
	                                cyBot_sendByte(header4[j]);
	                               }

	                               button_event = 0;

	                 }

	                           else if (button_num=='3'){
	                                 lcd_printf("switch 3");
	                                 for(j=0;j<(strlen(header3));j++){
	                                   cyBot_sendByte(header3[j]);

	                                    }
	                                 button_event = 0;

	                               }
	                           else if (button_num=='2'){
	                                 lcd_printf("switch 2");
	                                 for(j=0;j<(strlen(header2));j++){
	                                  cyBot_sendByte(header2[j]);
	                                 }
	                                    button_event = 0;
	                               }
	                           else if (button_num=='1'){
	                                 lcd_printf("switch 1");
	                                 for(j=0;j<(strlen(header1));j++){
	                                  cyBot_sendByte(header1[j]);

	                                 }
	                                 button_event = 0;
	                             }
	                           else if (button_num=='0'){
	                                 lcd_printf("0");
	                                 button_event = 0;

	                                            }

	            }

}
}
