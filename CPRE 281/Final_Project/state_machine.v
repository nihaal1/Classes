module state_machine(
		Clock,
		CLRN,
		ex_n,
		mode,
		write_enabler,
		error_over,
		error_under,
		stack3,
		stack2,
		stack1,
		stack0,
		alu_output,
		write_select,
		read_address_a,
		read_address_b,
		write_address
);

input Clock;
input CLRN;
input ex_n;
input [1:0] mode;

output write_enabler;
output error_over;
output error_under;
output stack3;
output stack2;
output stack1;
output stack0;
output alu_output;
output write_select;
output [1:0] read_address_a;
output [1:0] read_address_b;
output [1:0] write_address;

wire ctrl_en;
reg [2:0] ctrl;
wire[2:0] nxt_ctrl;
reg ex_delay;

assign alu_op = mode[0];

assign stack3 = ctrl[0] | ctrl[1] | ctrl[2];
assign stack2 = ctrl[1] | ctrl[2];
assign stack1 = ctrl[0] & ctrl [1] | ctrl[2];
assign stack0 = ctrl[2];

assign write_enabler = ctrl_en & (
						(~mode[0] & ~mode[1] & ~ctrl[2]) | 
						(mode[1] & (ctrl[1] | ctrl[2]))
					);

assign write_select = mode[1];

assign write_address[1] = ctrl[2] | (~mode[1] & ctrl[1]);
assign write_address[0] = ctrl[0];

assign read_address_a[1] = ctrl[0] | ctrl[2];
assign read_address_a[0] = ~ctrl[0]; 

assign read_address_b[1] = ~ctrl[1];
assign read_address_b[0] = ctrl[0];  

assign error_over = ~mode[0] & ~mode[1] & ctrl[2];

assign error_under = (mode[0] & ~mode[1] & ~ctrl[2] & ~ctrl[1] & ~ctrl[0]) |
			(mode[1] & ~ctrl[2] & ~ctrl[1]);
			
//edge detector
always @(posedge Clock or negedge CLRN) begin
	if (CLRN == 1'b0) begin
		ex_delay <= 1'b1;
	end else begin
		ex_delay <= ex_n;
	end
end
assign ctrl_en = ex_delay & ~ex_n;

assign nxt_ctrl[2] = (~mode[0] & ~mode[1] & (ctrl[2] | (ctrl[1] & ctrl[0])));

assign nxt_ctrl[1] = (~mode[0] & ~mode[1] & (ctrl[0] ^ ctrl [1])) | 
							((mode[0] | mode[1]) & (ctrl[2] | (ctrl[1] & ctrl[0])));
				
assign nxt_ctrl[0] = (~mode[0] & ~mode[1] & ~ctrl[2] & ~ctrl[0]) |
							((mode[0] | mode[1]) & ctrl[2]) |
							(mode[1] & ~ctrl[1] & ctrl[0]) |
							(ctrl[1] & ~ctrl[0]);


always @(posedge Clock or negedge CLRN) begin
	if (CLRN == 1'b0) begin
		ctrl <= 3'b000;
	end else if (ctrl_en) begin
		ctrl <= nxt_ctrl;
	end
end

endmodule


















