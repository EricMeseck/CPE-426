`timescale 1ns / 1ps
module CU_Decoder(
    input br_eq, br_lt, br_ltu, intTaken,
    input [6:0] cu_opcode,
    input [2:0] func,
    input [6:0] check_func,
    output logic [3:0] alu_fun,
    output logic alu_srcA,
    output logic [1:0] alu_srcB, 
    output logic [2:0] pcSource, 
    output logic [1:0] rf_wr_sel,
    output logic seen, taken
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
    pcSource = 3'b000;
    rf_wr_sel = 2'b11;
        case (OPCODE)
            LUI: begin
                alu_srcA = 1'b1;
                alu_srcB = 2'b00;
                alu_fun = 4'b1001;
                pcSource = 3'b000;
                rf_wr_sel = 2'b11;
                seen = 1'b0;
                taken = 1'b0;
            end
            AIUPC: begin
                alu_srcA = 1'b1;
                alu_srcB = 2'b11;
                alu_fun = 4'b0000;
                pcSource = 3'b000;
                rf_wr_sel = 2'b11;
                seen = 1'b0;
                taken = 1'b0;
            end
            JAL: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                alu_fun = 4'b0000;
                pcSource = 3'b011;
                rf_wr_sel = 2'b00;
                seen = 1'b0;
                taken = 1'b0;
            end
            JALR: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                alu_fun = 4'b0000;
                pcSource = 3'b001;
                rf_wr_sel = 2'b00;
                seen = 1'b0;
                taken = 1'b0;
            end
            BRANCH: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                alu_fun = 4'b0000;
                seen = 1'b1;
                case (func)
                    3'b000: if (br_eq) begin pcSource = 2'b10; taken = 1'b1; end
                            else begin pcSource = 3'b000; taken = 1'b0; end
                    3'b001: if (br_eq) begin pcSource = 2'b00; end
                            else begin pcSource = 3'b010; taken = 1'b1; end
                    3'b100: if (br_lt) begin pcSource = 2'b10; taken = 1'b1; end
                            else begin pcSource = 3'b000; taken = 1'b0; end
                    3'b101: if (br_lt) begin pcSource = 2'b00; taken = 1'b0; end
                            else begin pcSource = 3'b010; taken = 1'b1; end
                    3'b110: if (br_ltu) begin pcSource = 2'b10; taken = 1'b1; end
                            else begin pcSource = 3'b000; taken = 1'b0; end
                    3'b111: if (br_ltu) begin pcSource = 2'b00; taken = 1'b0; end
                            else begin pcSource = 3'b010; taken = 1'b1; end
                endcase
                rf_wr_sel = 2'b00;
            end
            LOAD: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                alu_fun = 4'b0000;
                pcSource = 3'b000;
                rf_wr_sel = 2'b10;
                seen = 1'b0;
                taken = 1'b0;
            end
            STORE: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b10;
                alu_fun = 4'b0000;
                pcSource = 3'b000;
                rf_wr_sel = 2'b11;
                seen = 1'b0;
                taken = 1'b0;
            end
            OP_IMM: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                seen = 1'b0;
                taken = 1'b0;
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
                pcSource = 3'b000;
                rf_wr_sel = 2'b11;
            end
            OP: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                seen = 1'b0;
                taken = 1'b0;
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
                pcSource = 3'b000;
                rf_wr_sel = 2'b11;
            end
            CSR: begin
                alu_srcA = 1'b0;
                alu_srcB = 2'b0;
                alu_fun = 4'b1001;
                seen = 1'b0;
                taken = 1'b0;
                if (func == 3'b000) begin
                    pcSource = 3'b101;
                end
                else begin pcSource = 3'b000; end
                rf_wr_sel = 2'b01;
                
            end
        endcase
        if (intTaken) begin
            pcSource = 3'b100;
        end
    end
endmodule