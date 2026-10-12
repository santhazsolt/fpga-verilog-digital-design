`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:04:15 AM
// Design Name: 
// Module Name: Tb_Casc_Sincr_3Num_Corectat
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


module Tb_NumCeas_SZS( );


 localparam Nbits = 24;
 localparam CE_DIV_RATE = 4;

    reg               clk    = 0 ;
    reg               RESETn = 0 ;
    reg   [Nbits-1:0] Din    = 0 ;
    reg               Load   = 0;
    reg               CE     = 0 ;
    reg    [2:0]      Inc    = 0 ;
    reg    [2:0]      Dec    = 0 ;
    reg               UnD    = 1 ;
    wire  [Nbits-1:0] Q       ;
    wire              TC      ;

task LoadVal(input [Nbits-1:0] Val);
begin
    @(posedge clk);
    Din <=#2 Val;
    Load <=#2 1'b1;
    @(posedge clk);
    Load <=  1'b0;
end
endtask


localparam CLK_PERIOD_SZS = 10;             

integer i_SZS;

//Sim Messages
reg[8*20-1:0] SimMsg_SZS;

//generate Clock: 
always #(CLK_PERIOD_SZS/2) clk <= ~clk;

//form CE_CNT by AND logic between CE and CE_DIV
reg  CE_DIV = 0;
wire CE_CNT;

assign CE_CNT = CE & CE_DIV;

//generate CE_DIV by dividing CLK to 4
always begin
CE_DIV<=#2 0;
repeat (CE_DIV_RATE-1)
    @(posedge clk);
CE_DIV <=#2 1;
@ (posedge clk);
end

//Instantiate the UUT
NumCeas_SZS  UUT
    (
    .clk        (clk    )  ,
    .RESETn     (RESETn )  ,
    .Din_SZS    (Din    )  ,
    .Load_SZS   (Load   )  ,
    .CE_SZS     (CE_CNT )  ,
    .UnD_SZS    (UnD    )  ,
    .Inc_SZS    (Inc    )  ,
    .Dec_SZS    (Dec    )  ,
    .Q_SZS      (Q      )  ,
    .TC_SZS     (TC     )
    );
 
initial begin

SimMsg_SZS = "Reset";
repeat (10) @(posedge clk);
RESETn <= #2 1'b1;

SimMsg_SZS = "Hold CE";
repeat (10) @(posedge clk);

SimMsg_SZS = "CU  first min";
CE<=#2 1'b1;
UnD <=#2 1'b1;
@ (Q == 24'h000111);
@ (posedge clk);


SimMsg_SZS = "Ld first hour";
LoadVal(24'h005950);
@ (posedge clk);
@ (Q == 24'h010010);

SimMsg_SZS = "Ld HR 095950";
LoadVal(24'h095950);
@ (posedge clk);
@ (Q == 24'h100010);

SimMsg_SZS = "Ld HR 235950";
LoadVal(24'h235950);
@ (posedge clk);
@ (Q == 24'h000040);
@ (posedge clk);


@(Q[7:0] == 8'h40);
SimMsg_SZS = "Adj Sec from Inc[0]";
repeat (2)begin
    @ (posedge clk);
    Inc[0] <= 1;
    @ (posedge clk);
    Inc[0] <= 0;
    repeat (10) @ (posedge clk);
end

@(Q[7:0] == 8'h40);
@ (posedge clk);
SimMsg_SZS = "Adj Sec from Dec[0]";
repeat (2)begin
    @ (posedge clk);
    Dec[0] <= 1;
    @ (posedge clk);
    Dec[0] <= 0;
    repeat (10) @ (posedge clk);
end


//oprim ceasul sa putem urmari doar ajustarile
CE<=0;

SimMsg_SZS = "Adj Min from Inc[1]";
repeat (64)begin
    @ (posedge clk);
    Inc[1] <= 1;
    @ (posedge clk);
    Inc[1] <= 0;
    repeat (10) @ (posedge clk);
end

@ (posedge clk);
SimMsg_SZS = "Adj Min from Dec[1]";
repeat (64)begin
    @ (posedge clk);
    Dec[1] <= 1;
    @ (posedge clk);
    Dec[1] <= 0;
    repeat (10) @ (posedge clk);
end


SimMsg_SZS = "Adj Hr from Inc[2]";
repeat (30)begin
    @ (posedge clk);
    Inc[2] <= 1;
    @ (posedge clk);
    Inc[2] <= 0;
    repeat (10) @ (posedge clk);
end

@ (posedge clk);
SimMsg_SZS = "Adj Hr from Dec[2]";
repeat (30)begin
    @ (posedge clk);
    Dec[2] <= 1;
    @ (posedge clk);
    Dec[2] <= 0;
    repeat (10) @ (posedge clk);
end



end

endmodule


