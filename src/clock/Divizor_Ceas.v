`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 07:54:10 AM
// Design Name: 
// Module Name: Progr_Divider
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


module Divizor_Ceas(
    input        CLK    ,
    input        RESETn ,
    input  [1:0] SEL    ,
    output       DivOut
	);

integer i;

localparam CLK_FREQUENCY_HZ = 100000000;

wire[31:0] DIV_RATE;

//pentru self-reset la schimbarea SEL
reg [1:0] SEL_REG[0:1];
wire Sel_Changed;

assign DIV_RATE = (SEL == 0)? CLK_FREQUENCY_HZ/1       :  //1Hz
                  (SEL == 1)? CLK_FREQUENCY_HZ/10      :  //10Hz
                  (SEL == 2)? CLK_FREQUENCY_HZ/1000    :  CLK_FREQUENCY_HZ/1000000;
							//1KHz                              //=FCLK/10

always @(posedge CLK)
    if (~RESETn) begin
        SEL_REG[0] <= 2'b00;
        SEL_REG[1] <= 2'b00;
    end else begin
        SEL_REG[1] <= SEL_REG[0];
        SEL_REG[0] <= SEL;
    end
assign Sel_Changed = (SEL_REG[1] != SEL_REG[0])? 1'b1 : 1'b0;                   

always @(posedge CLK)
    if ( (~RESETn) || (i == (DIV_RATE-1)) || (Sel_Changed) ) i <= 0;
    else i <= i + 1; 


assign DivOut = (i == DIV_RATE - 1)? 1:0;

endmodule
