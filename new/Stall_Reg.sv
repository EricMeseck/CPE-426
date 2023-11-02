module Stall_Reg(
    input clk,
    input [31:0] in,
    input stall,
    output logic [31:0] stall_1
    );
    always_ff @ (posedge clk) begin
        if (stall) begin end
        else begin
            stall_1 = in;
        end
    end
endmodule