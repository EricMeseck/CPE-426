`timescale 1ns / 1ps

module EnableLUT(
    input logic a,
    input logic b,
    input logic sel,
    input logic en,
    output logic c
    );
    logic d;
    mux_2x1 muxy1(!a, !b, sel, d);
    mux_2x1 muxy2(d, 0, en, c);
endmodule