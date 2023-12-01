`timescale 1ns / 1ps

module Otter_Control(
    input CLK,
    input INTR,
    input RST,
    input [31:0] IOBUS_IN,
    output logic [31:0] IOBUS_OUT,
    output logic [31:0] IOBUS_ADDR,
    output IOBUS_WR,
    output logic [31:0] ir
    );
    logic pcWrite, memRead1, regWrite, memWrite, memRead2, br_eq, br_lt, br_ltu, alu_srcA, err,
    csrWrite, intTaken, int_in, mie;
    logic seen, taken, execute;
    logic [1:0] rf_wr_sel, alu_srcB;
    logic [2:0] pcSource, newPCsource;
    logic [3:0] alu_fun, tablePC, tableNewAddress;
    logic [15:0] [31:0] addressBox;
    logic [31:0] jalr, branch, newBranch, jal, pc_out, pc_4, wd, rs1, rs2, alu_in1, alu_in2,
                 IType, UType, SType, JType, BType, alu_out, mem_out2, rd, mtvec, mepc;
    PC_Control pc(CLK, RST, pcWrite, newPCsource, pc_4, jalr, newBranch, jal, mtvec, mepc, pc_out);
    OTTER_mem_byte ot_mem(CLK, pc_out, alu_out, rs2, memWrite, memRead1, memRead2, 
                     err, ir, mem_out2, IOBUS_IN, IOBUS_WR, ir[13:12], ir[14]);
    assign int_in = INTR & mie;
    Branch_Cache branchCache(CLK, pc_out, pc_out, branch, seen, taken, execute, pcSource, newBranch, newPCsource, tablePC, tableNewAddress, addressBox);
    CU_FSM fsm(CLK, int_in, RST, ir[6:0], ir[14:12], pcWrite, regWrite, memWrite, 
               memRead1, memRead2, csrWrite, intTaken, execute);
    Reg_File registers(CLK, regWrite, wd, ir[19:15], ir[24:20], ir[11:7], rs1, rs2);
    BranchCondGen bcg(rs1, rs2, br_eq, br_lt, br_ltu);
    CU_Decoder decoder(br_eq, br_lt, br_ltu, intTaken, ir[6:0], ir[14:12], ir[31:25], alu_fun, alu_srcA,
                       alu_srcB, pcSource, rf_wr_sel);
    Immed_Gen igen(ir, IType, JType, UType, BType, SType);
    mux_2x1 aluMuxA(rs1, UType, alu_srcA, alu_in1);
    mux_4x2 aluMuxB(rs2, IType, SType, pc_out, alu_srcB[0], alu_srcB[1], alu_in2);
    ALU alu(alu_in1, alu_in2, alu_fun, alu_out);
    Target_Gen tgen(pc_out, JType, BType, IType, rs1, jalr, branch, jal);
    CSR csr(CLK, RST, intTaken, ir[31:20], pc_out, alu_out, csrWrite, rd, mepc, mtvec, mie);
    mux_4x2 RegMux(pc_4, rd, mem_out2, alu_out, rf_wr_sel[0], rf_wr_sel[1], wd);
    assign IOBUS_ADDR  = alu_out;
    assign IOBUS_OUT = rs2;
    assign pc_4 = pc_out + 3'b100;
    assign seen = (ir[6:0] == 7'b1100011);
    assign taken = (pcSource == 3'b010);
endmodule
