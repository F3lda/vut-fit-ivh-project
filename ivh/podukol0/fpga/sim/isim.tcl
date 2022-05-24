# sim.tcl : ISIM simulation script
# Copyright (C) 2011 Brno University of Technology,
#                    Faculty of Information Technology
# Author(s): Zdenek Vasicek
#
# LICENSE TERMS
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. All advertising materials mentioning features or use of this software
#    or firmware must display the following acknowledgement:
#
#      This product includes software developed by the University of
#      Technology, Faculty of Information Technology, Brno and its
#      contributors.
#
# 4. Neither the name of the Company nor the names of its contributors
#    may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# This software or firmware is provided ``as is'', and any express or implied
# warranties, including, but not limited to, the implied warranties of
# merchantability and fitness for a particular purpose are disclaimed.
# In no event shall the company or contributors be liable for any
# direct, indirect, incidental, special, exemplary, or consequential
# damages (including, but not limited to, procurement of substitute
# goods or services; loss of use, data, or profits; or business
# interruption) however caused and on any theory of liability, whether
# in contract, strict liability, or tort (including negligence or
# otherwise) arising in any way out of the use of this software, even
# if advised of the possibility of such damage.
#

#Project setup
#========================================
#set TESTBENCH_ENTITY "testbench"
#set ISIM_PRECISION "100 ps"

#Run simulation
#========================================
proc isim_script {} {

	add_wave_label "-color #FFFF00" "reset" /testbench/uut/fpga_inst/reset
	add_wave_label "-color #ff8000" "clk" /testbench/uut/fpga_inst/clk
	add_wave_label "-color #ff8000" "smclk" /testbench/uut/fpga_inst/smclk
	wave add -name clk /testbench/uut/clk
	wave add -name smclk /testbench/uut/smclk

	# Keyboard signals --------------------------------------------
	divider add "Keyboard Interface"
	wave add -name key /testbench/key
	wave add -name kin /testbench/uut/kin
	wave add -name kout /testbench/uut/kout

	# LCD display signals -----------------------------------------
	divider add "LCD Display Interface"
	wave add -name lrw /testbench/uut/lrw
	wave add -name le /testbench/uut/le
	wave add -name lrs /testbench/uut/lrs
	wave add -radix hex -name ld /testbench/uut/ld
	wave add -name display /testbench/lcd_u/display
	add_wave_label "" "Display" /testbench/lcd/display

	# User signals -----------------------------------------------
	add_divider "USER signals"
	
	#add_wave "cnt1" /testbench/uut/cnt
	#wave add -radix unsigned -name cnt2  /testbench/uut/cnt
	#add_wave_label "-radix unsigned" "cnt3" /testbench/uut/cnt
	
	#add_wave "cnt4" /testbench/uut/fpga_inst/cnt
	wave add -radix unsigned -name cnt5  /testbench/uut/fpga_inst/cnt
	add_wave_label "-radix unsigned" "cnt6" /testbench/uut/fpga_inst/cnt



	wave add -radix unsigned -name mem_cnt  /testbench/uut/fpga_inst/mem_cnt
	wave add -radix unsigned -name mem_data  /testbench/uut/fpga_inst/mem_data
	wave add -radix unsigned -name lcd_write_en  /testbench/uut/fpga_inst/lcd_write_en
	wave add -radix unsigned -name lcd_write_done  /testbench/uut/fpga_inst/lcd_write_done
	wave add -radix unsigned -name mem_cnt  /testbench/uut/fpga_inst/mem_cnt

   
	run 200 us
} 

