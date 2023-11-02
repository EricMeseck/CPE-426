`timescale 1ns / 1ps

module Otter_Control(
    input CLK,
    input INTR,
    input RST,
    input [31:0] IOBUS_IN,
    output logic [31:0] IOBUS_OUT,
    output logic [31:0] IOBUS_ADDR,
    output IOBUS_WR
    );
    logic [31:0] ram [0:31];
    logic decRegWrite, decMemWrite, regWrite, memWrite, 
        memRead2, alu_srcA, err, csrWrite, intTaken, int_in, mie;
    logic [1:0] rf_wr_sel, alu_srcB;
    logic [2:0] genPcSource, pcSource, newPCsource;
    logic [3:0] alu_fun;
    logic [31:0] jalr, branch, newBranch, jal, pc_out, pcWeird, pcs1, pcs2, ir, irs1, irs2, 
                 irs3, pc_4, pc4s1, pc4s2, pc4s3, pc4s4, wd, rs1, rs2, alu_in1, 
                 alu_in2, IType, UType, SType, JType, BType, alu_out, mem_out2, 
                 rd, mtvec, mepc, alu_o1, alu_o2, JtypeS1, BtypeS1, ItypeS1;
    logic [31:0] alu_in1s1, alu_in2s1, rs2s1, rs2s2;              
    logic [3:0]  alufs1, tablePC, tableNewAddr;
    logic [1:0]  rfs1, rfs2, rfs3, rfs4;
    logic        regWriteS1, regWriteS2, regWriteS3, regWriteS1EX,
                 memWriteS1, memWriteS2, memWriteS1EX,
                 memRead2s1, memRead2s2,
                 stall, seen, taken, squash;             
    //F Stage
    PC_Control pc(CLK, RST, !stall, newPCsource, jalr, newBranch, jal, mtvec, mepc, pc_out, pc_4);
    Stall_Reg pcstall2(CLK, pcs1, stall, pcs2);
    Stall_Reg pcstall1(CLK, pcWeird, stall, pcs1);
    Stall_Reg weirdstall(CLK, pc_out, stall, pcWeird); 
    Stall_Reg pc4stall4(CLK, pc4s3, 1'b0, pc4s4);
    Stall_Reg pc4stall3(CLK, pc4s2, 1'b0, pc4s3);
    Stall_Reg pc4stall2(CLK, pc4s1, stall, pc4s2);
    Stall_Reg pc4stall1(CLK, pc_4, stall, pc4s1);
    OTTER_mem_byte ot_mem(CLK, pc_out, alu_o1, rs2s2, memWriteS2, !stall, memRead2s2, 
                     err, ir, mem_out2, IOBUS_IN, IOBUS_WR, irs2[13:12], irs2[14]);
    assign int_in = INTR & mie;
    logic [15:0] [31:0] addresses;
    Branch_Cache branchCache(CLK, pc_out, pcs2, branch, seen, taken,
                             genPcSource, newBranch, newPCsource, tablePC, tableNewAddr, squash, addresses);
    
    //D Stage
    Stall_Reg irstall3(CLK, irs2, 1'b0, irs3);
    Stall_Reg irstall2(CLK, irs1, 1'b0, irs2);
    Stall_Reg irstall1(CLK, ir, stall, irs1);
    
    
    
    //CU_FSM fsm(CLK, int_in, RST, ir[6:0], ir[14:12], pcWrite, regWrite, memWrite, 
               //memRead1, memRead2, csrWrite, intTaken);
    Reg_File registers(CLK, regWriteS3, wd, ir[19:15], ir[24:20], irs3[11:7], rs1, rs2, ram);
    CU_Decoder decoder(ir[6:0], ir[14:12], ir[31:25], alu_fun, alu_srcA, alu_srcB, rf_wr_sel,
                       regWrite, memWrite, memRead2);
    
    Stall_Reg rs2stall2(CLK, rs2s1, 1'b0, rs2s2);
    Stall_Reg rs2stall1(CLK, rs2, stall, rs2s1);
    Stall_4bit aluFSstall(CLK, alu_fun, stall, alufs1);
    Stall_2bit rfstall3(CLK, rfs2, 1'b0, rfs3);
    Stall_2bit rfstall2(CLK, rfs1, 1'b0, rfs2);
    Stall_2bit rfstall1(CLK, rf_wr_sel, stall, rfs1);
    Stall_1bit regWstall3(CLK, regWriteS2, 1'b0, regWriteS3);
    Stall_1bit regWstall2(CLK, regWriteS1EX, 1'b0, regWriteS2);
    Stall_1bit regWstall1(CLK, regWrite, stall, regWriteS1);
    Stall_1bit memWstall2(CLK, memWriteS1EX, 1'b0, memWriteS2);
    Stall_1bit memWstall1(CLK, memWrite, stall, memWriteS1);
    Stall_1bit memRstall2(CLK, memRead2s1, 1'b0, memRead2s2);
    Stall_1bit memRstall1(CLK, memRead2, stall, memRead2s1);
    Immed_Gen igen(ir, IType, JType, UType, BType, SType);
    mux_2x1 aluMuxA(rs1, UType, alu_srcA, alu_in1);
    mux_4x2 aluMuxB(rs2, IType, SType, pcs1, alu_srcB[0], alu_srcB[1], alu_in2);
    Stall_Reg ALU_in1stall(CLK, alu_in1, stall, alu_in1s1);
    Stall_Reg ALU_in2stall(CLK, alu_in2, stall, alu_in2s1);
    Stall_Reg Jstall(CLK, JType, stall, JtypeS1);
    Stall_Reg Bstall(CLK, BType, stall, BtypeS1);
    Stall_Reg Istall(CLK, IType, stall, ItypeS1);
    
    //E Stage
    logic [31:0] alu_fin1, alu_fin2, forStor1, forStor2;
    logic [4:0] irstor1, irstor2;
    BranchPCFixer bpcf(CLK, irs1[6:0], genPcSource, squash, pcSource);
    BranchForward bfor(CLK, irs1[6:0], regWriteS1, memWriteS1, squash, regWriteS1EX, memWriteS1EX);
    Forwarder forward(CLK, regWriteS1EX, irs1[11:7], irs1[19:15], irs1[24:20], irs3[11:7], irs3[6:0],
                      alu_in1s1, alu_in2s1, alu_out, mem_out2, alu_fin1, alu_fin2, 
                      forStor1, forStor2, irstor1, irstor2); 
    ALU alu(alu_fin1, alu_fin2, alufs1, alu_out);
    Stall_Reg alu_outStall2(CLK, alu_o1, 1'b0, alu_o2);
    Stall_Reg alu_outStall1(CLK, alu_out, 1'b0, alu_o1);
    BranchCondGen bcg(alu_fin1, alu_fin2, irs1[6:0], irs1[14:12], intTaken, 
                      genPcSource, seen, taken);
    
    Target_Gen tgen(pcs2, JtypeS1, BtypeS1, ItypeS1, alu_fin1, jalr, branch, jal);
    //CSR csr(CLK, RST, intTaken, irs3[31:20], pc_out, alu_out, csrWrite, rd, mepc, mtvec, mie);
    
    //M stage
    logic [1:0] count;
    Load_Forward loadf(CLK, irs1[6:0], stall, count);
    
    //W Stage
    mux_4x2 RegMux(pc4s4, rd, mem_out2, alu_o2, rfs3[0], rfs3[1], wd);
    assign IOBUS_ADDR  = alu_o1;
    assign IOBUS_OUT = rs2s2;
    
endmodule
