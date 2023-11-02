module Stall_1bit(
    input clk,
    input in,
    input stall,
    output logic stall_1
    );
    always_ff @ (posedge clk)
    begin
        if (stall) begin end
        else begin
            stall_1 = in;
        end
    end
endmodule