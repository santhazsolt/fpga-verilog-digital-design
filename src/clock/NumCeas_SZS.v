`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:01:38 AM
// Design Name: 
// Module Name: Casc_Sincr_3Num_Corectat
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


module NumCeas_SZS
    (
    input          clk      ,
    input          RESETn   ,
    input  [23:0]  Din_SZS  ,
    input          Load_SZS ,
    input          CE_SZS   ,
    input          UnD_SZS  ,
    input  [2:0]   Inc_SZS  ,
    input  [2:0]   Dec_SZS  ,
    output [23:0]  Q_SZS    ,
    output         TC_SZS
    );



//Nr biti:
//0 - Sec, 1- ZSec, 2 - Min,
//3 - ZMin, 4 - Hr, 5 - ZHr
wire [5:0] CE_Int_SZS;
wire [5:0] TC_Int_SZS;
wire [5:0] UnD_Int_SZS;
wire [5:0] Load_Int_SZS = {6{Load_SZS}};
//wire [5:0] RSTn_Int_SZS = {6{RESETn}};
wire [5:0] RSTn_Int_SZS;

wire Is_23, RESETn_Ore;
assign Is_23 = (Q_SZS[23:16] == 8'h23)? 1'b1:1'b0;
assign RESETn_Ore = ( ~(Is_23 & CE_Int_SZS[4]) ) & RESETn ;

assign RSTn_Int_SZS[3:2] = {2{RESETn}};
assign RSTn_Int_SZS[5:4] = {2{RESETn_Ore}};

//Ajustare Secunde = Reset Secunde
assign RSTn_Int_SZS[0] = RESETn &
    ( ~(Inc_SZS[0] | Dec_SZS[0]) );
assign RSTn_Int_SZS[1] = RSTn_Int_SZS[0];

//Reglaj secunde, avans minute la >30
wire IsSecOver30;
assign IsSecOver30 = (Q_SZS[7:0] >= 8'h30) ? 1'b1:1'b0;
wire AdvMinOver30 = (Inc_SZS[0] | Dec_SZS[0])& IsSecOver30;

//Logica UnD pentru ajustarea minutelor
assign UnD_Int_SZS[2] = (Inc_SZS[1])? 1'b1 :
                        (Dec_SZS[1])? 1'b0 : UnD_SZS;
assign UnD_Int_SZS[3] = UnD_Int_SZS[2];                       

assign UnD_Int_SZS[4] = (Inc_SZS[2])? 1'b1 :
                        (Dec_SZS[2])? 1'b0 : UnD_SZS;
                        
assign UnD_Int_SZS[5] = UnD_Int_SZS[4];                       

//UnD Secunde
assign UnD_Int_SZS[1:0] = {2{UnD_SZS}};
//UnD Ore
//assign UnD_Int_SZS[5:4] = {2{UnD_SZS}};

/****************************************************
    Lantul de porti Si, pentru transport
****************************************************/
//secunde
assign CE_Int_SZS[0] = CE_SZS;
//Zsecunde
assign CE_Int_SZS[1] = CE_Int_SZS[0] & TC_Int_SZS[0];
//Minute
assign CE_Int_SZS[2] = (CE_Int_SZS[1] & TC_Int_SZS[1]) | 
                        AdvMinOver30 | Inc_SZS[1] | Dec_SZS[1];
//ZMinute
assign CE_Int_SZS[3] = CE_Int_SZS[2] & TC_Int_SZS[2];
//Ore
assign CE_Int_SZS[4] = (CE_Int_SZS[3] & TC_Int_SZS[3]
                      & (~Inc_SZS[1]) & (~Dec_SZS[1]) )
                      | Inc_SZS[2] | Dec_SZS[2];
//Zore
assign CE_Int_SZS[5] = CE_Int_SZS[4] & TC_Int_SZS[4];

//TC iesire
assign TC_SZS =   (Is_23 & CE_Int_SZS[4]) & 
                & (~Inc_SZS[2]) & (~Dec_SZS[2]);

/****************************************************
    Instantierea numaratoarelor individual
****************************************************/
/*
//Secunde
CntNbits_L_SZS
    #(.Nbits (4),
      .LIMIT (9)
    )
    Secunde
    (
    .clk    (clk           ) ,
    .RESETn (RSTn_Int_SZS[0]) ,
    .Din    (Din_SZS[3:0]      ) ,
    .Load   (Load_Int_SZS[0]) ,
    .CE     (CE_Int_SZS[0]  ) ,
    .UnD    (UnD_Int_SZS[0])  ,
    .Q      (Q_SZS[3:0]        ) ,
    .TC     (TC_Int_SZS[0]  )
    );

//Zeci Secunde
CntNbits_L_SZS
    #(.Nbits (4),
      .LIMIT (5)
    )
    ZSecunde
    (
    .clk    (clk           ) ,
    .RESETn (RSTn_Int_SZS[1]) ,
    .Din    (Din_SZS[7:4]      ) ,
    .Load   (Load_Int_SZS[1]) ,
    .CE     (CE_Int_SZS[1]  ) ,
    .UnD    (UnD_Int_SZS[1])  ,
    .Q      (Q_SZS[7:4]        ) ,
    .TC     (TC_Int_SZS[1]  )
    );

//Urmeaza Minute, ZMinute, Ore, ZOre, 
*/
 
 
/**********************************************************
SystemVerilog Version: Instantiate with Generate
***********************************************************/
localparam [3:0] Limits_SZS[0:5] = {9, 5, 9, 5, 9, 2};
 
 /****************************************************
    Instantierea numaratoarelor prin Generate
****************************************************/

genvar i;
	generate
	for (i = 0; i < 6; i = i + 1) begin
        CntNbits_L_SZS
        #(.Nbits (4),
          .LIMIT (Limits_SZS[i])
        )
        Num
        (
        .clk    (clk                )  ,
        .RESETn (RSTn_Int_SZS[i]    )  ,
        .Din    (Din_SZS[4*i+3:4*i] )  ,
        .Load   (Load_SZS           )  ,
        .CE     (CE_Int_SZS[i]      )  ,
        .UnD    (UnD_Int_SZS[i]     )  ,
        .Q      (Q_SZS[4*i+3:4*i]   )  ,
        .TC     (TC_Int_SZS[i]      )
        );
    end
	endgenerate




/**********************************************************
Verilog Version: Use a ROM for Limits
***********************************************************/
/*
reg [3:0] Limits_SZS[0:5];
initial begin
Limits_SZS[0] <= 9;
Limits_SZS[1] <= 5;
Limits_SZS[2] <= 9;
Limits_SZS[3] <= 5;
Limits_SZS[4] <= 9;
Limits_SZS[5] <= 2;
end
*/
/****************************************************
    Descrierea comportamentale a numaratoarelor
    prin Generate
****************************************************/
/*
genvar i;
	generate
	for (i = 0; i < 6; i = i + 1) begin
	reg [3:0] Q_reg = 0;
        assign Q_SZS[4*i+3:4*i] = Q_reg;  
        always @ (posedge clk)
          if (~RSTn_Int_SZS[i]) Q_reg <= 0;
          else if (Load_Int_SZS[i])
                if (Din_SZS[4*i+3:4*i] >= Limits_SZS[i]) Q_reg <= Limits_SZS[i];
                else Q_reg <= Din_SZS[4*i+3:4*i];
          else if (CE_Int_SZS[i])
            if (UnD_Int_SZS[i])
                if (Q_reg == Limits_SZS[i]) Q_reg <= 0;
                else Q_reg <= Q_reg + 1;
            else 
                if (Q_reg == 0) Q_reg <= Limits_SZS[i];
                else Q_reg <= Q_reg - 1;
            
        assign TC_Int_SZS[i] = ( ((Q_reg == Limits_SZS[i]) && (UnD_Int_SZS[i] == 1)) ||  
                              ((Q_reg == 0) && (UnD_Int_SZS[i] == 0))  )? 1'b1:1'b0;
    end	
	endgenerate
*/
endmodule