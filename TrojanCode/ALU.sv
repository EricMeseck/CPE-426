`timescale 1ns / 1ps

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_fun,
    output [31:0] out
    );
    logic [31:0] add, sub, or_fun, and_fun, xor_fun, srl, sll, sra, slt, sltu, copy;
    wire [31:0] out1, out2, out3, out4;
    assign add = A + B;
    assign sub = A - B;
    assign or_fun = A | B;
    assign and_fun = A & B;
    assign xor_fun = A ^ B;
    assign srl = A >> B[4:0];
    assign sll = A << B[5:0];
    assign sra = $signed(A) >>> B[4:0];
    assign slt = $signed(A) < $signed(B);
    assign sltu = A < B;
    assign copy = A;
    mux_4x2 mux1(add, sll, slt, sltu, ALU_fun[0], ALU_fun[1], out1);
    mux_4x2 mux2(xor_fun, srl, or_fun, and_fun, ALU_fun[0], ALU_fun[1], out2);
    mux_4x2 mux3(sub, copy, 0, 0, ALU_fun[0], ALU_fun[1], out3);
    mux_4x2 mux4(0, sra, 0, 0, ALU_fun[0], ALU_fun[1], out4);
    mux_4x2 mux5(out1, out2, out3, out4, ALU_fun[2], ALU_fun[3], out);
endmodule