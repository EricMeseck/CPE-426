`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2022 08:56:40 AM
// Design Name: 
// Module Name: Load_Forward
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


module Load_Forward(
    input CLK,
    input [6:0] opcode,
    output logic stall, 
    output logic [1:0] count
    );

    always_ff @ (posedge CLK) begin
        if (count > 0) begin
            count = count - 1;
            if (count == 0) begin
                stall = 0;
            end
        end
        else if (opcode == 7'b0000011) begin
            count = 2;
            stall = 1;
        end
        else begin
            stall = 0;
        end
    end
endmodule
