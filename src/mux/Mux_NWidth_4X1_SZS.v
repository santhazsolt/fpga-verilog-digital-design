`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 02:26:33 PM
// Design Name: 
// Module Name: Mux_NWidth_4X1_SZS
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


module Mux_NWidth_4X1_SZS();
	
	localparam SIM_WIDTH_SZS = 3;
	
	reg   [WIDTH_SZS-1:0]   I0_SZS       ;
	reg   [WIDTH_SZS-1:0]   I1_SZS       ;
	reg   [WIDTH_SZS-1:0]   I2_SZS       ;
	reg   [WIDTH_SZS-1:0]   I3_SZS       ;
										 
	reg   [1:0]			    SEL_SZS      ;
										 
	wire  [WIDTH_SZS-1:0]   O_Index_SZS  ;

//local parameters and signals
//we wont use neither the clock
//nor the counter
//localparam CLK_PERIOD_SZS = 10;
//reg clk = 0
//reg [3:0] cnt4_SZS = 0
integer i_SZS;
	
//generate Clock:
//always #(CLK_PERIOD_SZS/2) clk <= ~clk;

//4-bit counter
//always @ (posedge clk) cnt4_SZS=cnt4_SZS+1;	

//instanatiate the component
Mux_NWidth_4X1_SZS
	# ( .WIDTH_SZS (SIM_WIDTH_SZS)
	)
UUT_SZS
	(
	.I0_SZS        (I0_SZS       ),
	.I1_SZS        (I1_SZS       ),
    .I2_SZS        (I2_SZS       ),
    .I3_SZS        (I3_SZS       ),
    .SEL_SZS       (SEL_SZS      ),
    .O_Index_SZS   (O_Index_SZS  )
	);
	
//the main testbench procedure
//this will run only once
initial begin

	I0_SZS = $random;
	I1_SZS = I0_SZS + 1;
	I2_SZS = I0_SZS + 5;
	I3_SZS = I0_SZS + 4;
	
	//run through each value of SEL
	for(i_SZS = 0; i_SZS < 4; i_SZS = i_SZS + 1) begin
		SEL_SZS <= 1;
		#100;
	end
end
endmodule