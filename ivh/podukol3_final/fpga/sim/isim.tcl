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

	# User signals -----------------------------------------------
	add_divider "CLKs EN"
	wave add -radix unsigned -name LED_EN  /testbench/uut/fpga_inst/LED_EN
	wave add -radix unsigned -name SEC_EN  /testbench/uut/fpga_inst/SEC_EN
	
	add_divider "ROM"
	wave add -radix unsigned -name CURRENT_IMAGE  /testbench/uut/fpga_inst/CURRENT_STATE
	wave add -radix unsigned -name ROM_DATA  /testbench/uut/fpga_inst/ROM_DATA
	wave add -radix unsigned -name DATA_OUT_TEMP  /testbench/uut/fpga_inst/ROM_MEM/DATA_OUT_TEMP
	
	add_divider "CONTROLLER"
	wave add -radix unsigned -name ROT_DIRECTION  /testbench/uut/fpga_inst/ROT_DIRECTION
	wave add -radix unsigned -name ROT_EN  /testbench/uut/fpga_inst/ROT_EN
	wave add -radix unsigned -name CONTROLLER_DATA  /testbench/uut/fpga_inst/CONTROLLER_DATA
	
	add_divider "COLUMNS"
	wave add -radix unsigned -name COLUMN_STATE  /testbench/uut/fpga_inst/COLUMN_STATE
	
	add_divider "LED CONTROLLER"
	wave add -radix unsigned -name A  /testbench/uut/fpga_inst/a
	wave add -radix unsigned -name R  /testbench/uut/fpga_inst/r



	run 3 ms
} 

