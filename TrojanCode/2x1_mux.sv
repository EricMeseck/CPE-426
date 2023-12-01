`timescale 1ns / 1ps

module mux_2x1(
    input logic [31:0] a,
    input logic [31:0] b,
    input sel,
    output logic [31:0] c
);
    always_ff @(a, b, sel) begin
        if (sel == 0) begin
            c = a;
        end
        else begin
         c = b;
        end
    end
endmodule