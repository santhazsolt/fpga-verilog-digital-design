`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 04:50:27 PM
// Design Name: 
// Module Name: CntNbits_L_SZS
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


module CntNbits_L_SZS
    #( parameter Nbits = 4,
       parameter LIMIT = 9
    )
    (
    input               clk      ,
    input               RESETn   ,
    input   [Nbits-1:0] Din      ,
    input               Load     ,
    input               CE       ,
    input               UnD      ,
    output  [Nbits-1:0] Q        ,
    output              TC
    );
 
reg [Nbits-1:0] Q_reg = 0;
assign Q = Q_reg;  
  
always @ (posedge clk)
  if (~RESETn) Q_reg <= 0;
  else if (Load)
        if (Din >= LIMIT) Q_reg <= LIMIT;
        else Q_reg <= Din;
  else if (CE)
    if (UnD)
        if (Q_reg == LIMIT) Q_reg <= 0;
        else Q_reg <= Q_reg + 1;
    else 
        if (Q_reg == 0) Q_reg <= LIMIT;
        else Q_reg <= Q_reg - 1;
            
    
assign TC = ( ((Q_reg == LIMIT) && (UnD == 1)) ||  
              ((Q_reg == 0) && (UnD == 0))  )? 1'b1:1'b0;
    
    
endmodule
