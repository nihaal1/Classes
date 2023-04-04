module mux4(
	data_0,
	data_1,
	data_2,
	data_3,
	sel,
	result
);


input wire	[3:0] data_0;
input wire	[3:0] data_1;
input wire	[3:0] data_2;
input wire	[3:0] data_3;
input wire	[1:0] sel;
output wire	[3:0] result;

assign result[0] = ( ~sel[1] & ~sel[0] & data_0[0] )
                 | ( ~sel[1] &  sel[0] & data_1[0] )
                 | (  sel[1] & ~sel[0] & data_2[0] )
                 | (  sel[1] &  sel[0] & data_3[0] );

assign result[1] = ( ~sel[1] & ~sel[0] & data_0[1] )
                 | ( ~sel[1] &  sel[0] & data_1[1] )
                 | (  sel[1] & ~sel[0] & data_2[1] )
                 | (  sel[1] &  sel[0] & data_3[1] );

assign result[2] = ( ~sel[1] & ~sel[0] & data_0[2] )
                 | ( ~sel[1] &  sel[0] & data_1[2] )
                 | (  sel[1] & ~sel[0] & data_2[2] )
                 | (  sel[1] &  sel[0] & data_3[2] );

assign result[3] = ( ~sel[1] & ~sel[0] & data_0[3] )
                 | ( ~sel[1] &  sel[0] & data_1[3] )
                 | (  sel[1] & ~sel[0] & data_2[3] )
                 | (  sel[1] &  sel[0] & data_3[3] );

endmodule
