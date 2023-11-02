`timescale 1ns / 1ps
module CU_Decoder(
    input [6:0] cu_opcode,
    input [2:0] func,
    input [6:0] check_func,
    output logic [3:0] alu_fun,
    output logic alu_srcA,
    output logic [1:0] alu_srcB, 
    output logic [1:0] rf_wr_sel,
    output logic regWrite,
    output logic memWrite,
    output logic memRead2
    );
    typedef enum logic [6:0] {
        LUI = 7'b0110111,
        AIUPC = 7'b0010111,
        JAL = 7'b1101111,
        JALR = 7'b1100111,
        BRANCH = 7'b1100011,
        LOAD = 7'b0000011,
        STORE = 7'b0100011,
        OP_IMM = 7'b0010011,
        OP = 7'b0110011,
        CSR = 7'b1110011
    } opcode_t;
    opcode_t OPCODE;
    assign OPCODE = opcode_t'(cu_opcode);
    always_comb begin
    alu_srcA = 1'b1;
    alu_srcB = 2'b00;
    alu_fun = 4'b1001;
    rf_wr_sel = 2'b11;
    regWrite = 1'b0;
    memWrite = 1'b0;
    memRead2 = 1'b0;
        case (OPCODE)
            LUI: begin
                alu_srcA = 1'b1;
                alu_srcB = 2'b00;
                alu_fun = 4'b1001;
                rf_wr_sel = 2'b11;
                regWrite = 1'b1;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            AIUPC: begin
                alu_srcA = 1'b1;
                alu_srcB = 2'b11;
                alu_fun = 4'b0000;
                rf_wr_sel = 2'b11;
                regWrite = 1'b1;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            JAL: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                alu_fun = 4'b0000;
                rf_wr_sel = 2'b00;
                regWrite = 1'b1;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            JALR: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                alu_fun = 4'b0000;
                rf_wr_sel = 2'b00;
                regWrite = 1'b1; 
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            BRANCH: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                alu_fun = 4'b0000;
                rf_wr_sel = 2'b00;
                regWrite = 1'b0;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            LOAD: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                alu_fun = 4'b0000;
                rf_wr_sel = 2'b10;
                regWrite = 1'b1;
                memWrite = 1'b0;
                memRead2 = 1'b1;
            end
            STORE: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b10;
                alu_fun = 4'b0000;
                rf_wr_sel = 2'b11;
                regWrite = 1'b0;
                memWrite = 1'b1;
                memRead2 = 1'b0;
            end
            OP_IMM: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                case (func)
                    3'b000: alu_fun = 4'b0000;
                    3'b010: alu_fun = 4'b0010;
                    3'b011: alu_fun = 4'b0011;
                    3'b100: alu_fun = 4'b0100;
                    3'b110: alu_fun = 4'b0110;
                    3'b111: alu_fun = 4'b0111;
                    3'b001: alu_fun = 4'b0001;
                    3'b101: if (check_func[5]) begin
                                alu_fun = 4'b1101;
                            end
                            else begin
                                alu_fun = 4'b0101;
                            end
                endcase
                rf_wr_sel = 2'b11;
                regWrite = 1'b1;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            OP: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                case (func)
                    3'b000: if (check_func[5]) begin
                                alu_fun = 4'b1000;
                            end
                            else begin
                                alu_fun = 4'b0000;
                            end
                    3'b010: alu_fun = 4'b0010;
                    3'b011: alu_fun = 4'b0011;
                    3'b100: alu_fun = 4'b0100;
                    3'b110: alu_fun = 4'b0110;
                    3'b111: alu_fun = 4'b0111;
                    3'b001: alu_fun = 4'b0001;
                    3'b101: if (check_func[5]) begin
                                alu_fun = 4'b1101;
                            end
                            else begin
                                alu_fun = 4'b0101;
                            end
                endcase
                rf_wr_sel = 2'b11;
                regWrite = 1'b1;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
            CSR: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b0;
                alu_fun = 4'b1001;
                rf_wr_sel = 2'b01;
                regWrite = 1'b0;
                memWrite = 1'b0;
                memRead2 = 1'b0;
            end
        endcase
    end 
endmodule