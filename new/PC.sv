`timescale 1ns / 1ps

module PC(
    input clk, pc_reset, pcWrite,
    input [31:0] data_in,
    output logic [31:0] out
    );
    always_ff @(posedge clk) begin 
        if (pc_reset) begin
            out = 0;
        end
        else if(pcWrite) begin
            out = data_in;
        end
    end
    
endmodule