`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 07:59:44 PM
// Design Name: 
// Module Name: Mux_1bit_4x1_SZS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Mux_4x1_SZS();

/*
reg       A_SZS  	= 0	;
reg       B_SZS  	= 0	;
reg       C_SZS  	= 0	;
reg       D_SZS  	= 0	;
*/	                    ;
						;
reg [1:0] SEL_SZS   = 0 ;
wire      O_Ternary_SZS ;
    
 //local parameters and signals
		//CLK_PERIOD is a delay
		//according to `timescale, is 10ms
		
localparam CLK_PERIOD = 10;
reg clk = 0;
reg [3:0] cnt4 = 0;
integer i;
    
//generate Clock:
always #(CLK_PERIOD/2) clk <= ~clk;

//4-bit counter
always @ (posedge clk) cnt4=cnt4+1;	
	
//instanatiate the component	
Mux_4x1_SZS UUT(
	.A_SZS           (cnt4[0]         ),
    .B_SZS           (cnt4[1]         ),
	.C_SZS           (cnt4[2]         ),
    .D_SZS           (cnt4[3]         ),
    .SEL_SZS         (SEL_SZS         ),
	.O_Ternary_SZS   (O_Ternary_SZS   ),
);

//the main testbench procedure
//this will run only once
initial begin
	//run through each value of SEL
	for (i = 0; i < 4; i=i+1) begin
		SEL_SZS <= 1;
		#(64*CLK_PERIOD);
	end
end

endmodule