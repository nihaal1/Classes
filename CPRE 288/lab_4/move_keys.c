/*

#include "open_interface.h"
#include "movement.h"
#include "move_keys.h"

void ssh_move(){

    cyBot_uart_init();

            while(1){
                int move_command = cyBot_getByte();
                int message_to_board = cyBot_getByte();
                    lcd_clear();
                    lcd_puts("Got an ");
                    lcd_putc(message_to_board);
                    cyBot_sendByte(message_to_board);

            if(move_command=='w'){
               move_forward(sensor_data, 10, 500);
            }
            if(move_command=='a'){
                right_turn(sensor_data, -1);
                   }
            if(move_command=='s'){
                   move_backward(sensor_data, -10, -500);
                   }
            if(move_command=='d'){
                     left_turn(sensor_data, 1);
                   }
            }
}

*/
