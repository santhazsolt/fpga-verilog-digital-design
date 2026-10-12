`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 08:40:43 AM
// Design Name: 
// Module Name: SsgDisplay_Wrapper_SZS
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


module SsgDisplay_Wrapper_SZS
    #(
       parameter RFR_DIV_RATE_SZS = 10000
    )
    (
    input           CLK         ,
    input           RESETn      ,
    input  [31:0]   DIN_SZS     ,
    input  [7:0]    Dp_InN_SZS  ,
    input  [7:0]    BLANK_SZS   ,
    input           AUTOBLANK_EN_SZS,
    output [7:0]    AN_SZS      ,
    output [7:0]    SSG_SZS  
    );

wire [7:0] AutoBlank_SZS, BlankDecoder;

assign BlankDecoder = (AUTOBLANK_EN_SZS)?  BLANK_SZS | AutoBlank_SZS : BLANK_SZS;

//completati autoblank ai celorlalti digiti

assign AutoBlank_SZS = (DIN_SZS[31:4] == 0)? 8'hFE  :
                       (DIN_SZS[31:8] == 0)? 8'hFC  :
                       (DIN_SZS[31:12] == 0)? 8'hF8 :
                       (DIN_SZS[31:16] == 0)? 8'hF0 :
                       (DIN_SZS[31:20] == 0)? 8'hE0 :
                       (DIN_SZS[31:24] == 0)? 8'hC0 :
                       (DIN_SZS[31:28] == 0)? 8'h80 : 8'h00;

Ssg_Decoder_SZS
    #(
       .CLK_FREQUENCY_HZ (100_000_000) ,
       .RFR_DIV_MODE_SZS (0          ) ,
       .RFR_DIV_RATE_SZS (RFR_DIV_RATE_SZS ) ,
       .NUMDIGITS        (8          )
    )
    My_Decoder
    (
    .CLK         (CLK        ) ,
    .RESETn      (RESETn     ) ,
    .DIN_SZS     (DIN_SZS    ) ,
    .RFR_DIV_SZS (4'hB) , //e nefolosit
    .Dp_InN_SZS  (Dp_InN_SZS ) ,
    .BLANK_SZS   (BlankDecoder  ) ,
    .USE_SEG_SZS (8'h0) , //Tema: De implementat
    .SegN_SZS    (64'h0000_0000_0000_0000),
    .AN_SZS      (AN_SZS     ) ,
    .SSG_SZS     (SSG_SZS    )
    );



endmodule
