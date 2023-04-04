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
// CREATED		"Wed Apr 27 17:06:16 2022"

module register_file(
	CLK,
	w0,
	w1,
	load0,
	load1,
	load2,
	load3,
	s1,
	s0,
	En,
	out0,
	out1,
	out2,
	out3
);


input wire	CLK;
input wire	w0;
input wire	w1;
input wire	load0;
input wire	load1;
input wire	load2;
input wire	load3;
input wire	s1;
input wire	s0;
input wire	En;
output wire	out0;
output wire	out1;
output wire	out2;
output wire	out3;

wire	SYNTHESIZED_WIRE_48;
wire	SYNTHESIZED_WIRE_49;
wire	SYNTHESIZED_WIRE_50;
wire	SYNTHESIZED_WIRE_51;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_25;
wire	SYNTHESIZED_WIRE_26;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_31;
wire	SYNTHESIZED_WIRE_52;

assign	SYNTHESIZED_WIRE_49 = 1;




\2_to_4_decoder 	b2v_inst(
	.w0(w0),
	.w1(w1),
	.En(En),
	.y0(SYNTHESIZED_WIRE_48),
	.y1(SYNTHESIZED_WIRE_52),
	.y2(SYNTHESIZED_WIRE_50),
	.y3(SYNTHESIZED_WIRE_51));


register	b2v_inst1(
	.In(load1),
	.Load(SYNTHESIZED_WIRE_48),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_16));


register	b2v_inst10(
	.In(load2),
	.Load(SYNTHESIZED_WIRE_50),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_22));


register	b2v_inst11(
	.In(load3),
	.Load(SYNTHESIZED_WIRE_50),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_26));


register	b2v_inst12(
	.In(load0),
	.Load(SYNTHESIZED_WIRE_51),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_31));


register	b2v_inst13(
	.In(load1),
	.Load(SYNTHESIZED_WIRE_51),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_19));


register	b2v_inst14(
	.In(load2),
	.Load(SYNTHESIZED_WIRE_51),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_23));


register	b2v_inst15(
	.In(load3),
	.Load(SYNTHESIZED_WIRE_51),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_27));


register	b2v_inst2(
	.In(load2),
	.Load(SYNTHESIZED_WIRE_48),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_20));


\4_to_1_mux 	b2v_inst20(
	.s0(s0),
	.s1(s1),
	.w0(SYNTHESIZED_WIRE_16),
	.w1(SYNTHESIZED_WIRE_17),
	.w2(SYNTHESIZED_WIRE_18),
	.w3(SYNTHESIZED_WIRE_19),
	.out(out1));


\4_to_1_mux 	b2v_inst21(
	.s0(s0),
	.s1(s1),
	.w0(SYNTHESIZED_WIRE_20),
	.w1(SYNTHESIZED_WIRE_21),
	.w2(SYNTHESIZED_WIRE_22),
	.w3(SYNTHESIZED_WIRE_23),
	.out(out2));


\4_to_1_mux 	b2v_inst22(
	.s0(s0),
	.s1(s1),
	.w0(SYNTHESIZED_WIRE_24),
	.w1(SYNTHESIZED_WIRE_25),
	.w2(SYNTHESIZED_WIRE_26),
	.w3(SYNTHESIZED_WIRE_27),
	.out(out3));


\4_to_1_mux 	b2v_inst23(
	.s0(s0),
	.s1(s1),
	.w0(SYNTHESIZED_WIRE_28),
	.w1(SYNTHESIZED_WIRE_29),
	.w2(SYNTHESIZED_WIRE_30),
	.w3(SYNTHESIZED_WIRE_31),
	.out(out0));



register	b2v_inst3(
	.In(load3),
	.Load(SYNTHESIZED_WIRE_48),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_24));


register	b2v_inst4(
	.In(load0),
	.Load(SYNTHESIZED_WIRE_52),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_29));


register	b2v_inst5(
	.In(load1),
	.Load(SYNTHESIZED_WIRE_52),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_17));


register	b2v_inst6(
	.In(load2),
	.Load(SYNTHESIZED_WIRE_52),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_21));


register	b2v_inst7(
	.In(load3),
	.Load(SYNTHESIZED_WIRE_52),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_25));


register	b2v_inst8(
	.In(load0),
	.Load(SYNTHESIZED_WIRE_50),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_30));


register	b2v_inst9(
	.In(load1),
	.Load(SYNTHESIZED_WIRE_50),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_18));


register	b2v_inst_1(
	.In(load0),
	.Load(SYNTHESIZED_WIRE_48),
	.CLRN(SYNTHESIZED_WIRE_49),
	.Clock(CLK),
	.Out(SYNTHESIZED_WIRE_28));


endmodule
