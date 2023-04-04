// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.0 Build 711 06/05/2020 SJ Lite Edition"
// CREATED		"Mon Apr 25 22:44:16 2022"

module demux4(
	in,
	sel,
	out
);


input wire	in;
input wire	[1:0] sel;
output wire	[3:0] out;

wire	[3:0] out_ALTERA_SYNTHESIZED;
wire	[1:0] sel_inv;




assign	out_ALTERA_SYNTHESIZED[3] = in & sel[1] & sel[0];

assign	out_ALTERA_SYNTHESIZED[2] = in & sel[1] & sel_inv[0];

assign	out_ALTERA_SYNTHESIZED[1] = in & sel_inv[1] & sel[0];

assign	out_ALTERA_SYNTHESIZED[0] = in & sel_inv[1] & sel_inv[0];

assign	sel_inv[1] =  ~sel[1];

assign	sel_inv[0] =  ~sel[0];

assign	out = out_ALTERA_SYNTHESIZED;

endmodule
