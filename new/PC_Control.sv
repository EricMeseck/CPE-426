`timescale 1ns / 1ps

module PC_Control(
    input clk, pc_reset, pcWrite,
    input [2:0] pcSource,
    input [31:0] jalr, 
    input [31:0] branch, 
    input [31:0] jal,
    input [31:0] mtvec,
    input [31:0] mepc,
    output logic [31:0] pc_out,
    output logic [31:0] pc_4
    );
    logic [31:0] pc_in;
    always_comb begin
        case (pcSource) 
        3'b000: begin
            pc_in = pc_4;
        end
        3'b001: begin
            pc_in = jalr;
        end
        3'b010: begin
            pc_in = branch;
        end
        3'b011: begin
            pc_in = jal;
        end
        3'b100: begin
            pc_in = mtvec;
        end
        3'b101: begin
            pc_in = mepc;
        end
        endcase
    end
    PC pc(clk, pc_reset, pcWrite, pc_in, pc_out);
    assign pc_4 = pc_out + 4;
    endmodule