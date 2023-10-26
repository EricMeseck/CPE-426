`timescale 1ns / 1ps
(* keep="true" *)
(* dont_touch = "true" *)

module mux_2x1(
    input logic a,
    input logic b,
    input sel,
    output logic c
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