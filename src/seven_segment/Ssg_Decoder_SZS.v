`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 08:34:10 AM
// Design Name: 
// Module Name: Ssg_Decoder_SZS
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


module Ssg_Decoder_SZS
     #(
       parameter CLK_FREQUENCY_HZ = 100_000_000 ,
       parameter RFR_DIV_MODE_SZS = 1           ,
       parameter RFR_DIV_RATE_SZS = 10000       ,
       parameter NUMDIGITS        = 8
    )
    (
    input           CLK         ,
    input           RESETn      ,
    input  [31:0]   DIN_SZS     ,
    input  [3:0]    RFR_DIV_SZS ,
    input  [7:0]    Dp_InN_SZS  ,
    input  [7:0]    USE_SEG_SZS ,
    input  [63:0]   SegN_SZS    ,
    input  [7:0]    BLANK_SZS   ,
    output [7:0]    AN_SZS      ,
    output [7:0]    SSG_SZS  
    
    );

/*****************************************
//Rata de divizare 
*******************************************/
wire [31:0] DIV_RATE_SZS;
reg [31:0] EXT_DIV_RATE;

localparam CONST_DIV_RATE = CLK_FREQUENCY_HZ / RFR_DIV_RATE_SZS;

assign DIV_RATE_SZS = (RFR_DIV_MODE_SZS == 0)? CONST_DIV_RATE : EXT_DIV_RATE;

    always @ * begin
    case(RFR_DIV_SZS)
        4'h0: EXT_DIV_RATE <= 2 * CLK_FREQUENCY_HZ; //0.5Hz
        4'h1: EXT_DIV_RATE <= CLK_FREQUENCY_HZ; //1Hz 
        4'h2: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/2; //2Hz
        4'h3: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/5; //5Hz
        4'h4: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/10; //10Hz
        4'h5: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/25; //25Hz
        4'h6: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/50; //50Hz
        4'h7: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/100; //100Hz
        4'h8: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/200; //200Hz
		4'h9: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/400; //400Hz
        4'hA: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/1000; //1KHz
        4'hB: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/10_000; //10KHz
        4'hC: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/100_000; //100KHz
        4'hD: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/1_000_000; //1MHz
        4'hE: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/10_000_000; //10MHz
        4'hF: EXT_DIV_RATE <= CLK_FREQUENCY_HZ/50_000_000; //50MHz  
    endcase
    end


/*****************************************
//Autoreset divizor 
*******************************************/
//Semnale pentru Circuitul de AutoReset
reg [3:0] RFR_DIV_SZS_REG[0:1];
wire ResetnDiv_SZS;

localparam DIV_RATE = 1;                  

always @(posedge CLK)
    if (~RESETn) begin
        RFR_DIV_SZS_REG[0] <= 4'b0000;
        RFR_DIV_SZS_REG[1] <= 4'b0000;
    end else begin
        RFR_DIV_SZS_REG[1] <= RFR_DIV_SZS_REG[0];
        RFR_DIV_SZS_REG[0] <= RFR_DIV_SZS;
    end

assign ResetnDiv_SZS = (RFR_DIV_SZS_REG[1] != RFR_DIV_SZS_REG[0])? 1'b1 : 1'b0;
    
/*****************************************
//Divizorul programabil
*******************************************/
//iesirea divizorului
wire CE_DIV_SZS;
//numaratorul pentru divizor
integer cntDiv_SZS;

always @(posedge CLK)
    if ( (~RESETn) || (cntDiv_SZS == (DIV_RATE_SZS-1)) || (ResetnDiv_SZS)) cntDiv_SZS <= 0;
    else cntDiv_SZS <= cntDiv_SZS + 1; 

assign CE_DIV_SZS = (cntDiv_SZS == DIV_RATE_SZS - 1)? 1:0;

/*****************************************
//Walk 0 si formarea adresei MUX
*******************************************/
reg [2:0] MuxAddr_SZS;
reg [7:0] AnWalk0_SZS;
wire Sin;
integer i;

assign Sin = (AnWalk0_SZS == 8'hFF)? 1'b0:1'b1;
always @(posedge CLK)
 if  (~RESETn) 
    AnWalk0_SZS <= 8'hFF;
 else if (CE_DIV_SZS) 
 AnWalk0_SZS <= {AnWalk0_SZS[6:0], Sin};
 
 always @(*) begin
   MuxAddr_SZS = 0;
   for(i=0; i<8; i = i+1)
          if(AnWalk0_SZS[i] == 1'b0)
         MuxAddr_SZS = i;
end

assign AN_SZS = AnWalk0_SZS | BLANK_SZS;

/*********************************************************
Multiplexorul pentru DinMux_SZS, cu intrarea DIN_SZS[31:0}
**********************************************************/
wire [3:0] DinMux_SZS;

wire DP_MUX_SZS;

reg [3:0] DinMux_reg_SZS;
assign DinMux_SZS = DinMux_reg_SZS;

always @(*) begin
    case (MuxAddr_SZS)
        3'b000 : DinMux_reg_SZS <= DIN_SZS[3:0];
        3'b001 : DinMux_reg_SZS <= DIN_SZS[7:4];
        3'b010 : DinMux_reg_SZS <= DIN_SZS[11:8];
        3'b011 : DinMux_reg_SZS <= DIN_SZS[15:12];
        3'b100 : DinMux_reg_SZS <= DIN_SZS[19:16];
        3'b101 : DinMux_reg_SZS <= DIN_SZS[23:20];
        3'b110 : DinMux_reg_SZS <= DIN_SZS[27:24];
        3'b111 : DinMux_reg_SZS <= DIN_SZS[31:28];
        default: DinMux_reg_SZS <= 4'b0000;
    endcase
end

reg DP_MUX_reg_SZS;
    assign DP_MUX_SZS = DP_MUX_reg_SZS;



always @(*) begin
    case (MuxAddr_SZS)
        3'b000 : DP_MUX_reg_SZS <= 1'b0;
        3'b001 : DP_MUX_reg_SZS <= 1'b1;
        3'b010 : DP_MUX_reg_SZS <= 1'b0;
        3'b011 : DP_MUX_reg_SZS <= 1'b1;
        3'b100 : DP_MUX_reg_SZS <= 1'b0;
        3'b101 : DP_MUX_reg_SZS <= 1'b1;
        3'b110 : DP_MUX_reg_SZS <= 1'b1;
        3'b111 : DP_MUX_reg_SZS <= 1'b1;
        default: DP_MUX_reg_SZS <= 1'b0;
    endcase
end


/*****************************************
//Decodificatorul HEX - 7 Segmente
*******************************************/
//iesirea decodificatorului
reg [6:0] SegDcd_SZS;

 always @(DinMux_SZS)
      case (DinMux_SZS)
          4'b0001 : SegDcd_SZS = 7'b1111001;   // 1
          4'b0010 : SegDcd_SZS = 7'b0100100;   // 2
          4'b0011 : SegDcd_SZS = 7'b0110000;   // 3
          4'b0100 : SegDcd_SZS = 7'b0011001;   // 4
          4'b0101 : SegDcd_SZS = 7'b0010010;   // 5
          4'b0110 : SegDcd_SZS = 7'b0000010;   // 6
          4'b0111 : SegDcd_SZS = 7'b1111000;   // 7
          4'b1000 : SegDcd_SZS = 7'b0000000;   // 8
          4'b1001 : SegDcd_SZS = 7'b0010000;   // 9
          4'b1010 : SegDcd_SZS = 7'b0001000;   // A
          4'b1011 : SegDcd_SZS = 7'b0000011;   // b
          4'b1100 : SegDcd_SZS = 7'b1000110;   // C
          4'b1101 : SegDcd_SZS = 7'b0100001;   // d
          4'b1110 : SegDcd_SZS = 7'b0000110;   // E
          4'b1111 : SegDcd_SZS = 7'b0001110;   // F
          default : SegDcd_SZS = 7'b1000000;   // 0
      endcase       

assign  SSG_SZS  = {DP_MUX_SZS, SegDcd_SZS};
    
endmodule
