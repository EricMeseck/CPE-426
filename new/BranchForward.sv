`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 08:20:47 AM
// Design Name: 
// Module Name: BranchForward
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


module BranchForward(
    input CLK,
    input [6:0] opcode,
    input regWrite,
    input memWrite,
    input squash,
    output logic newRegWrite,
    output logic newMemWrite
    );
    logic [1:0] timer;
    always @ (negedge CLK) begin
        if (timer > 0) begin
            newMemWrite = 1'b0;
            newRegWrite = 1'b0;
            timer = timer - 1;
        end
        else if (opcode == 7'b1100111 || //Jal
                 opcode == 7'b1100111 || //Jalr
                 squash) begin //Branch
            newMemWrite = memWrite;
            newRegWrite = regWrite;
            timer = 2;
        end
        else begin
            newMemWrite = memWrite;
            newRegWrite = regWrite;
        end         
    end
endmodule
