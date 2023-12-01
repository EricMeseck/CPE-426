`timescale 1ns / 1ps

module Reg_File(
    input clk, en,
    input [31:0] wd,
    input [4:0] addr1, addr2, wa,
    output logic [31:0] rs1, rs2
    );
   logic [31:0] ram [0:31];
   initial begin
        for (int x = 0; x < 32; x++) begin
            ram[x] = 0;
        end
    end
    assign rs1 = (addr1!=0)?ram[addr1]:32'b0;
    assign rs2 = (addr2!=0)?ram[addr2]:32'b0;
    always_ff @ (posedge clk) begin
        
        if (en) begin
            if (wa == 5'b00000) begin
                ram[0] = 0;
            end
            else begin
                ram[wa] = wd;
            end
        end
    end
endmodule
