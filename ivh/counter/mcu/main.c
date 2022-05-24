/*******************************************************************************
   main.c: 
   Copyright (C) 2009 Brno University of Technology,
                      Faculty of Information Technology
   Author(s): Jan Markovic <xmarko04 AT stud.fit.vutbr.cz>

   LICENSE TERMS

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:
   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
   3. All advertising materials mentioning features or use of this software
      or firmware must display the following acknowledgement: 

        This product includes software developed by the University of
        Technology, Faculty of Information Technology, Brno and its 
        contributors. 

   4. Neither the name of the Company nor the names of its contributors
      may be used to endorse or promote products derived from this
      software without specific prior written permission.
 
   This software is provided ``as is'', and any express or implied
   warranties, including, but not limited to, the implied warranties of
   merchantability and fitness for a particular purpose are disclaimed.
   In no event shall the company or contributors be liable for any
   direct, indirect, incidental, special, exemplary, or consequential
   damages (including, but not limited to, procurement of substitute
   goods or services; loss of use, data, or profits; or business
   interruption) however caused and on any theory of liability, whether
   in contract, strict liability, or tort (including negligence or
   otherwise) arising in any way out of the use of this software, even
   if advised of the possibility of such damage.

   $Id$


*******************************************************************************/
#include <fitkitlib.h>
#include <lcd/display.h>
#include "counter.h"

int autocount;

/*******************************************************************************
 * Vypis uzivatelske napovedy (funkce se vola pri vykonavani prikazu "help") 
 * systemoveho helpu  
*******************************************************************************/
void print_user_help(void)
{
  unsigned char cnt = FPGA_SPI_RW_A8_D8(SPI_FPGA_ENABLE_READ, BASE_ADDR_COUNTER, 0);

  term_send_str_crlf(" START....");
  term_send_str_crlf(" STOP....");
  term_send_str_crlf(" RESET FPGA....");
  term_send_str_crlf(" NEXT....");

  term_send_str(" counter state: ");
  term_send_num(cnt);
  term_send_crlf();
}


/*******************************************************************************
 * Dekodovani a vykonani uzivatelskych prikazu
*******************************************************************************/

unsigned char decode_user_cmd(char *cmd_ucase, char *cmd)
{
  if (strcmp5(cmd_ucase, "START"))
  {
    autocount = 1;
  }
  else if (strcmp4(cmd_ucase, "STOP"))
  {
    autocount = 0;
  }
  else if (strcmp4(cmd_ucase, "NEXT"))
  {
    LCD_append_char(read_count()+'0');
    next_count();  
  }
  else
  {
     return CMD_UNKNOWN;
  }
  return USER_COMMAND;     
}

/*******************************************************************************
 * Inicializace periferii/komponent po naprogramovani FPGA
*******************************************************************************/
void fpga_initialized()
{
  LCD_init();
  LCD_write_string("Counter ...");
}


/*******************************************************************************
 * Hlavni funkce
*******************************************************************************/
//inline int INIT_MCU(void)                     
int main(void)
{
  unsigned int cnt = 0;        
  autocount = 1;

  initialize_hardware();

  set_led_d6(1);                       // rozsviceni D6
  set_led_d5(1);                       // rozsviceni D5
 
  while (1) {
    delay_ms(10);
    cnt++;
    if (cnt > 50)
    {
      cnt = 0;
      flip_led_d6();                   // negace portu na ktere je LED
      if (autocount) 
      {
        LCD_append_char(read_count()+'0');
        next_count();
      }
    }    

    terminal_idle();                 // obsluha terminalu 
  } 

}
