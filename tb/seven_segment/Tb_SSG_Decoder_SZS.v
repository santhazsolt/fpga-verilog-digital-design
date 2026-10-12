`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 05:33:06 PM
// Design Name: 
// Module Name: Tb_Ssg_Decoder_SZS
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


module Tb_Ssg_Decoder_SZS();


localparam CLK_FREQUENCY_HZ = 100_000_000 ;
localparam RFR_DIV_MODE_SZS = 1           ;
localparam RFR_DIV_RATE_SZS = 10000       ;
localparam NUMDIGITS        = 8           ;


localparam CE_DIV_RATE      = 8           ;

	reg           CLK         = 0 ;
    reg           RESETn      = 0 ;
    reg  [31:0]   DIN_SZS     = 0 ;
    reg  [3:0]    RFR_DIV_SZS = 4'hE ;
    reg  [7:0]    Dp_InN_SZS  = 8'hff ;
    reg  [7:0]    BLANK_SZS   = 8'h00 ;
    wire [7:0]    AN_SZS      ;
    wire [7:0]    SSG_SZS     ;

    reg[8*20-1:0] SimMsg_SZS;
    
    reg[7:0] Decoded_SSG_SZS;
    
localparam CLK_PERIOD_SZS = 10;             

integer i_SZS = 0;
 
//generate Clock: 
always #(CLK_PERIOD_SZS/2) CLK <= ~CLK;


//decodificam SSG
always @(SSG_SZS)
      case (SSG_SZS[6:0])
           7'b1111001: Decoded_SSG_SZS="1";   // 1
           7'b0100100: Decoded_SSG_SZS="2";   // 2
           7'b0110000: Decoded_SSG_SZS="3";   // 3
           7'b0011001: Decoded_SSG_SZS="4";   // 4
           7'b0010010: Decoded_SSG_SZS="5";   // 5
           7'b0000010: Decoded_SSG_SZS="6";   // 6
           7'b1111000: Decoded_SSG_SZS="7";   // 7
           7'b0000000: Decoded_SSG_SZS="8";   // 8
           7'b0010000: Decoded_SSG_SZS="9";   // 9
           7'b0001000: Decoded_SSG_SZS="A";   // A
           7'b0000011: Decoded_SSG_SZS="B";   // b
           7'b1000110: Decoded_SSG_SZS="C";   // C
           7'b0100001: Decoded_SSG_SZS="D";   // d
           7'b0000110: Decoded_SSG_SZS="E";   // E
           7'b0001110: Decoded_SSG_SZS="F";   // F
           7'b1000000: Decoded_SSG_SZS="0";   // 0
      endcase

Ssg_Decoder_SZS
    #(
       .CLK_FREQUENCY_HZ (CLK_FREQUENCY_HZ) ,
       .RFR_DIV_MODE_SZS (RFR_DIV_MODE_SZS) ,
       .RFR_DIV_RATE_SZS (RFR_DIV_RATE_SZS) ,
       .NUMDIGITS        (NUMDIGITS       )
    )
	UUT
    (
    .CLK         (CLK        ),
    .RESETn      (RESETn     ),
    .DIN_SZS     (DIN_SZS    ),
    .RFR_DIV_SZS (RFR_DIV_SZS),
    .Dp_InN_SZS  (Dp_InN_SZS ),
    .BLANK_SZS   (BLANK_SZS  ),
    .USE_SEG_SZS (8'h00), 
    .SegN_SZS    (64'h0000_0000_0000_0000  ),
    .AN_SZS      (AN_SZS     ),
    .SSG_SZS     (SSG_SZS    )
    
    );
	
	
initial begin

repeat (10) @(posedge CLK);
RESETn <= #1 1'b1;

SimMsg_SZS = "Testing Anodes";
repeat (150) @(posedge CLK);

SimMsg_SZS = "Testing Decoder";
    DIN_SZS <= #1 32'h16092003; 
    repeat (300) @(posedge CLK);

SimMsg_SZS = "Testing BLANK_SZS";
    for (i_SZS=0; i_SZS < 8; i_SZS = i_SZS + 1) begin
        BLANK_SZS = {BLANK_SZS[6:0], 1'b1};
        repeat (8*10) @(posedge CLK);
    end


end

endmodule
