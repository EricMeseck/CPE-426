module Stall_2bit(
    input clk,
    input [1:0] in,
    input stall,
    output logic [1:0] stall_1
    );
    always_ff @ (posedge clk)
    begin
        if (stall) begin end
        else begin
            stall_1 = in;
        end
    end
endmodule