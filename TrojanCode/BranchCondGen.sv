`timescale 1ns / 1ps

module BranchCondGen(
    input [31:0] rs1, rs2,
    output logic br_eq, br_lt, br_ltu
    );
    assign br_eq = (rs1 == rs2);
    assign br_lt = ($signed(rs1) < $signed(rs2));
    assign br_ltu = (rs1 < rs2);
endmodule
