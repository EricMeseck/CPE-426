`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 02:35:01 PM
// Design Name: 
// Module Name: Target_Gen
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


module Target_Gen(
    input [31:0] pc,
    input [31:0] J_Immed,
    input [31:0] B_Immed,
    input [31:0] I_Immed,
    input [31:0] rs1,
    output [31:0] jalr,
    output [31:0] branch,
    output [31:0] jal
    );
    
    assign branch = pc + B_Immed;
    assign jalr = rs1 + I_Immed;
    assign jal = pc + J_Immed;
    
endmodule
