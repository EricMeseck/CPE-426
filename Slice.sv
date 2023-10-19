`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 05:25:18 PM
// Design Name: 
// Module Name: Slice
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


module Slice(
    input CLK,
    input logic a,
    input logic b,
    input logic sel,
    input logic bx,
    output logic outA,
    output logic outB
    );
    //Make sure that the mux inputs are good
    logic lutOut1, lutOut2;
    LUT lutto1(b, a, sel, lutOut1);
    LUT lutto2(b, a, sel, lutOut2);
    mux_2x1 muxy1(lutOut1, lutOut2, bx, outA);
    always_ff @ (CLK) begin
        if (CLK == 1) begin
        outB = outA;
        end
    end 
endmodule
