`timescale 1ns / 1ps

module mux_4x2(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input sel1, sel2,
    output [31:0] out
    );
    wire [31:0] out1, out2;
    mux_2x1 mux1(a, b, sel1, out1);
    mux_2x1 mux2(c, d, sel1, out2);
    mux_2x1 mux3(out1, out2, sel2, out);
endmodule