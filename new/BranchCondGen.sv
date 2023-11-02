`timescale 1ns / 1ps

module BranchCondGen(
    input [31:0] rs1, rs2,
    input [6:0] opcode,
    input [2:0] func,
    input intTaken,
    output logic [2:0] pcSource,
    output logic seen, taken
    );
    logic br_eq, br_lt, br_ltu;
    assign br_eq = (rs1 == rs2);
    assign br_lt = ($signed(rs1) < $signed(rs2));
    assign br_ltu = (rs1 < rs2);
    always_comb begin
        pcSource = 3'b000;
        if (opcode == 7'b1100011) begin //Branch
            seen = 1'b1;
            case (func)
                    3'b000: if (br_eq) begin pcSource = 3'b010; taken = 1'b1; end
                            else begin pcSource = 3'b000; taken = 1'b0; end
                    3'b001: if (br_eq) begin pcSource = 3'b000; taken = 1'b0; end
                            else begin pcSource = 3'b010; taken = 1'b1; end
                    3'b100: if (br_lt) begin pcSource = 3'b010; taken = 1'b1; end
                            else begin pcSource = 3'b000; taken = 1'b0; end
                    3'b101: if (br_lt) begin pcSource = 3'b000; taken = 1'b0; end
                            else begin pcSource = 3'b010; taken = 1'b1; end
                    3'b110: if (br_ltu) begin pcSource = 3'b010; taken = 1'b1; end
                            else begin pcSource = 3'b000; taken = 1'b0; end
                    3'b111: if (br_ltu) begin pcSource = 3'b000; taken = 1'b0; end
                            else begin pcSource = 3'b010; taken = 1'b1; end
            endcase
        end
        else if (opcode == 7'b1101111) begin //jal
            pcSource = 3'b011;
            seen = 1'b0;
            taken = 1'b0;
        end
        else if (opcode == 7'b1100111) begin //jalr
            pcSource = 3'b001;
            seen = 1'b0;
            taken = 1'b0;
        end
        else if (opcode == 7'b1110011) begin //csr
            if (func == 3'b000) begin
                    pcSource = 3'b101;
                end
            else begin pcSource = 3'b000; end
        end
        else begin seen = 1'b0; taken = 1'b0; end
        if (intTaken) begin
            pcSource = 3'b100;
        end
    end
endmodule 
