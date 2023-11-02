`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2022 09:22:33 AM
// Design Name: 
// Module Name: Stall_Regs
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


module Stall_Regs(
    input clk,
    input [31:0] in,
    input stall,
    output logic [31:0] stall_1,
    output logic [31:0] stall_2,
    output logic [31:0] stall_3,
    output logic [31:0] stall_4
    );
    always_ff @ (posedge clk)
    begin
        if (stall) begin end
        else begin
            stall_4 = stall_3;
            stall_3 = stall_2;
            stall_2 = stall_1;
            stall_1 = in;
        end
    end
endmodule
