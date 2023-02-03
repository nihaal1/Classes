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
// CREATED		"Mon Apr 25 22:42:52 2022"

module reg_file(
	clk,
	rst_n,
	wr_en,
	rd_addr_a,
	rd_addr_b,
	wr_addr,
	wr_dat,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	rd_dat_a,
	rd_dat_b
);


input wire	clk;
input wire	rst_n;
input wire	wr_en;
input wire	[1:0] rd_addr_a;
input wire	[1:0] rd_addr_b;
input wire	[1:0] wr_addr;
input wire	[3:0] wr_dat;
output wire	[3:0] HEX0;
output wire	[3:0] HEX1;
output wire	[3:0] HEX2;
output wire	[3:0] HEX3;
output wire	[3:0] rd_dat_a;
output wire	[3:0] rd_dat_b;

wire	[3:0] en;
wire	[3:0] HEX_ALTERA_SYNTHESIZED0;
wire	[3:0] HEX_ALTERA_SYNTHESIZED1;
wire	[3:0] HEX_ALTERA_SYNTHESIZED2;
wire	[3:0] HEX_ALTERA_SYNTHESIZED3;





dffe4	b2v_inst(
	.clk(clk),
	.en(en[0]),
	.rst_n(rst_n),
	.d(wr_dat),
	.q(HEX_ALTERA_SYNTHESIZED3));


mux4	b2v_inst1(
	.data_0(HEX_ALTERA_SYNTHESIZED3),
	.data_1(HEX_ALTERA_SYNTHESIZED2),
	.data_2(HEX_ALTERA_SYNTHESIZED1),
	.data_3(HEX_ALTERA_SYNTHESIZED0),
	.sel(rd_addr_a),
	.result(rd_dat_a));


mux4	b2v_inst2(
	.data_0(HEX_ALTERA_SYNTHESIZED3),
	.data_1(HEX_ALTERA_SYNTHESIZED2),
	.data_2(HEX_ALTERA_SYNTHESIZED1),
	.data_3(HEX_ALTERA_SYNTHESIZED0),
	.sel(rd_addr_b),
	.result(rd_dat_b));


dffe4	b2v_inst3(
	.clk(clk),
	.en(en[1]),
	.rst_n(rst_n),
	.d(wr_dat),
	.q(HEX_ALTERA_SYNTHESIZED2));


dffe4	b2v_inst4(
	.clk(clk),
	.en(en[2]),
	.rst_n(rst_n),
	.d(wr_dat),
	.q(HEX_ALTERA_SYNTHESIZED1));


dffe4	b2v_inst5(
	.clk(clk),
	.en(en[3]),
	.rst_n(rst_n),
	.d(wr_dat),
	.q(HEX_ALTERA_SYNTHESIZED0));


demux4	b2v_inst6(
	.in(wr_en),
	.sel(wr_addr),
	.out(en));

assign	HEX0 = HEX_ALTERA_SYNTHESIZED0;
assign	HEX1 = HEX_ALTERA_SYNTHESIZED1;
assign	HEX2 = HEX_ALTERA_SYNTHESIZED2;
assign	HEX3 = HEX_ALTERA_SYNTHESIZED3;

endmodule
