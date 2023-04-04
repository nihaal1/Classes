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
// CREATED		"Mon Apr 25 22:43:01 2022"

module dffe4(
	rst_n,
	clk,
	en,
	d,
	q
);


input wire	rst_n;
input wire	clk;
input wire	en;
input wire	[3:0] d;
output wire	[3:0] q;

reg	[3:0] q_ALTERA_SYNTHESIZED;
wire	VCC;





always@(posedge clk or negedge rst_n or negedge VCC)
begin
if (!rst_n)
	begin
	q_ALTERA_SYNTHESIZED[3] <= 0;
	end
else
if (!VCC)
	begin
	q_ALTERA_SYNTHESIZED[3] <= 1;
	end
else
if (en)
	begin
	q_ALTERA_SYNTHESIZED[3] <= d[3];
	end
end


always@(posedge clk or negedge rst_n or negedge VCC)
begin
if (!rst_n)
	begin
	q_ALTERA_SYNTHESIZED[2] <= 0;
	end
else
if (!VCC)
	begin
	q_ALTERA_SYNTHESIZED[2] <= 1;
	end
else
if (en)
	begin
	q_ALTERA_SYNTHESIZED[2] <= d[2];
	end
end


always@(posedge clk or negedge rst_n or negedge VCC)
begin
if (!rst_n)
	begin
	q_ALTERA_SYNTHESIZED[1] <= 0;
	end
else
if (!VCC)
	begin
	q_ALTERA_SYNTHESIZED[1] <= 1;
	end
else
if (en)
	begin
	q_ALTERA_SYNTHESIZED[1] <= d[1];
	end
end


always@(posedge clk or negedge rst_n or negedge VCC)
begin
if (!rst_n)
	begin
	q_ALTERA_SYNTHESIZED[0] <= 0;
	end
else
if (!VCC)
	begin
	q_ALTERA_SYNTHESIZED[0] <= 1;
	end
else
if (en)
	begin
	q_ALTERA_SYNTHESIZED[0] <= d[0];
	end
end


assign	q = q_ALTERA_SYNTHESIZED;
assign	VCC = 1;

endmodule
