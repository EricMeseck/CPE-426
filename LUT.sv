`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 05:07:37 PM
// Design Name: 
// Module Name: LUT
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


module LUT(
    input logic a,
    input logic b,
    input logic sel,
    output logic c
    );
    mux_2x1 muxy1(!a, !b, sel, c);
endmodule
