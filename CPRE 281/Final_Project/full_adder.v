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
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Standard Edition"
// CREATED		"Wed Apr 27 18:22:40 2022"

module full_adder(
	xi,
	yi,
	Cin,
	Cout,
	S
);


input wire	xi;
input wire	yi;
input wire	Cin;
output wire	Cout;
output wire	S;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;





xor3_0	b2v_inst(
	.IN3(Cin),
	.IN1(xi),
	.IN2(yi),
	.OUT1(S));

assign	SYNTHESIZED_WIRE_2 = xi & yi;

assign	SYNTHESIZED_WIRE_0 = xi & Cin;

assign	SYNTHESIZED_WIRE_1 = yi & Cin;

assign	Cout = SYNTHESIZED_WIRE_0 | SYNTHESIZED_WIRE_1 | SYNTHESIZED_WIRE_2;


endmodule

module xor3_0(IN3,IN1,IN2,OUT1);
/* synthesis black_box */

input IN3;
input IN1;
input IN2;
output OUT1;

endmodule
