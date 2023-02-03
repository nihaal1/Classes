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
// CREATED		"Wed Apr 27 16:09:25 2022"

module reg4b(
	Load,
	CLRN,
	Clock,
	In,
	Out
);


input wire	Load;
input wire	CLRN;
input wire	Clock;
input wire	[3:0] In;
output wire	[3:0] Out;

wire	[3:0] Out_ALTERA_SYNTHESIZED;





register	b2v_inst(
	.In(In[3]),
	.Load(Load),
	.CLRN(CLRN),
	.Clock(Clock),
	.Out(Out_ALTERA_SYNTHESIZED[0]));


register	b2v_inst1(
	.In(In[2]),
	.Load(Load),
	.CLRN(CLRN),
	.Clock(Clock),
	.Out(Out_ALTERA_SYNTHESIZED[1]));


register	b2v_inst2(
	.In(In[1]),
	.Load(Load),
	.CLRN(CLRN),
	.Clock(Clock),
	.Out(Out_ALTERA_SYNTHESIZED[2]));


register	b2v_inst3(
	.In(In[0]),
	.Load(Load),
	.CLRN(CLRN),
	.Clock(Clock),
	.Out(Out_ALTERA_SYNTHESIZED[3]));

assign	Out = Out_ALTERA_SYNTHESIZED;

endmodule
