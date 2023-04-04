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
// CREATED		"Mon May 02 15:35:39 2022"

module register(
	Load,
	CLRN,
	Clock,
	In,
	Out
);


input wire	Load;
input wire	CLRN;
input wire	Clock;
input wire	In;
output wire	Out;

wire	[0:0] SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
reg	DFF_inst;

assign	Out = DFF_inst;
assign	SYNTHESIZED_WIRE_1 = 1;




always@(posedge Clock or negedge CLRN or negedge SYNTHESIZED_WIRE_1)
begin
if (!CLRN)
	begin
	DFF_inst <= 0;
	end
else
if (!SYNTHESIZED_WIRE_1)
	begin
	DFF_inst <= 1;
	end
else
	begin
	DFF_inst <= SYNTHESIZED_WIRE_0[0];
	end
end


busmux_0	b2v_inst1(
	.sel(Load),
	.dataa(DFF_inst),
	.datab(In),
	.result(SYNTHESIZED_WIRE_0));



endmodule

module busmux_0(sel,dataa,datab,result);
/* synthesis black_box */

input sel;
input [0:0] dataa;
input [0:0] datab;
output [0:0] result;

endmodule
