`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 02:35:01 PM
// Design Name: 
// Module Name: Immed_Gen
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


module Immed_Gen(
    input [31:0] IR,
    output [31:0] I_Immed,
    output [31:0] J_Immed,
    output [31:0] U_Immed,
    output [31:0] B_Immed,
    output [31:0] S_Immed
    );
    
    assign I_Immed = {{20{IR[31]}},IR[31:20]};
    assign J_Immed = {{12{IR[31]}},IR[31],IR[19:12],IR[20],IR[30:21],1'b0};
    assign U_Immed = {IR[31:12], 12'b0};
    assign B_Immed = {{19{IR[31]}},IR[31],IR[7],IR[30:25],IR[11:8],1'b0};
    assign S_Immed = {{20{IR[31]}},IR[31:25],IR[11:7]};
    
endmodule
