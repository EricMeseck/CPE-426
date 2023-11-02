`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 08:56:54 AM
// Design Name: 
// Module Name: BranchPCFixer
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


module BranchPCFixer(
    input CLK,
    input [6:0] opcode,
    input [2:0] pcSource,
    input squash,
    output logic [2:0] newPcSource
    );
    logic [1:0] timer;
    always @ (negedge CLK) begin
        if (timer > 0) begin
            newPcSource = 3'b000;
            timer = timer - 1;
        end
        else if (opcode == 7'b1100111 || //Jal
                 opcode == 7'b1100111 || //Jalr
                 squash) begin //Squash case
            newPcSource = pcSource;
            timer = 2;
        end
        else begin
            newPcSource = pcSource;
        end
    end
endmodule
