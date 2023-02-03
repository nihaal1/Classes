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
// CREATED		"Wed Apr 27 18:23:52 2022"

module adder_subtractor(
	ALU_select,
	x,
	y,
	Cout,
	s3,
	s2,
	s1,
	s0
);


input wire	ALU_select;
input wire	[3:0] x;
input wire	[3:0] y;
output wire	Cout;
output wire	s3;
output wire	s2;
output wire	s1;
output wire	s0;

wire	gdfx_temp0;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;





full_adder	b2v_inst(
	.xi(x[3]),
	.yi(SYNTHESIZED_WIRE_0),
	.Cin(SYNTHESIZED_WIRE_1),
	.S(s3),
	.Cout(Cout));

assign	gdfx_temp0 = gdfx_temp0 ^ y[0];


full_adder	b2v_inst4(
	.xi(x[2]),
	.yi(SYNTHESIZED_WIRE_2),
	.Cin(SYNTHESIZED_WIRE_3),
	.S(s2),
	.Cout(SYNTHESIZED_WIRE_1));


full_adder	b2v_inst5(
	.xi(x[1]),
	.yi(SYNTHESIZED_WIRE_4),
	.Cin(SYNTHESIZED_WIRE_5),
	.S(s1),
	.Cout(SYNTHESIZED_WIRE_3));


full_adder	b2v_inst6(
	.xi(x[0]),
	.yi(gdfx_temp0),
	.Cin(gdfx_temp0),
	.S(s0),
	.Cout(SYNTHESIZED_WIRE_5));

assign	SYNTHESIZED_WIRE_0 = gdfx_temp0 ^ y[3];

assign	SYNTHESIZED_WIRE_2 = gdfx_temp0 ^ y[2];

assign	SYNTHESIZED_WIRE_4 = gdfx_temp0 ^ y[1];

assign	gdfx_temp0 = ALU_select;

endmodule
