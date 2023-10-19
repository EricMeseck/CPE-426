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


module EnableSlice(
    input CLK,
    input logic a,
    input logic b,
    input logic sel,
    input logic bx,
    input logic en,
    output logic outA,
    output logic outB
    );
    //Make sure that the mux inputs are good
    logic lutOut1, lutOut2;
    EnableLUT lutto1(b, a, sel, en, lutOut1);
    EnableLUT lutto2(b, a, sel, en, lutOut2);
    mux_2x1 muxy1(lutOut1, lutOut2, bx, outA);
    always_ff @ (CLK) begin
        if (CLK == 1) begin
        outB = outA;
        end
    end 
endmodule