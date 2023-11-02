`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 08:49:56 AM
// Design Name: 
// Module Name: Forwarder
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


module Forwarder(
    input CLK,
    input regWrite,
    input [4:0] ir,
    input [4:0] addr1,
    input [4:0] addr2,
    input [4:0] mem_add,
    input [6:0] mem_op,
    input [31:0] alu_in1,
    input [31:0] alu_in2,
    input [31:0] alu_out,
    input [31:0] mem_out,
    output logic [31:0] alu_for1,
    output logic [31:0] alu_for2,
    output logic [31:0] forStor1, forStor2,
    output logic [4:0] irStor1, irStor2
    );
    
    always_ff @ (posedge CLK) begin
        if (addr1 == mem_add && addr1 != 5'b0 && mem_op == 7'b0000011) 
            begin alu_for1 = mem_out; end
        else if (addr1 == irStor1 && addr1 != 5'b0) begin alu_for1 = forStor1; end
        else if (addr1 == irStor2 && addr1 != 5'b0) begin alu_for1 = forStor2; end
        else begin alu_for1 = alu_in1; end
        if (addr2 == mem_add && addr2 != 5'b0 && mem_op == 7'b0000011) 
            begin alu_for2 = mem_out; end
        else if (addr2 == irStor1 && addr2 != 5'b0) begin alu_for2 = forStor1; end
        else if (addr2 == irStor2 && addr2 != 5'b0) begin alu_for2 = forStor2; end
        else begin alu_for2 = alu_in2; end
    end
    always_ff @ (negedge CLK) begin
        if (regWrite && ir != 5'b0) begin
            forStor2 <= forStor1;
            irStor2 <= irStor1;
            forStor1 <= alu_out;
            irStor1 <= ir;
        end
    end
endmodule
