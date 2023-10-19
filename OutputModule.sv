`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 03:04:33 PM
// Design Name: 
// Module Name: OutputModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OutputModule(
    input CLK, en,
    output logic LED
    );
    reg [31:0] count; 
    logic [2:0] sel;
    logic [2:0] bx;
    logic out1, out2;
    RingOsc ringo(CLK, sel, bx, en, out1, out2);
    always_ff @ (CLK) begin
        if (en == 1) begin
            LED = 0;
            count = 0;
            sel = 3'b0;
            bx = 3'b0;
        end
        if (out1 == 1) begin
            count += 1;
        end
        if (count > 100) begin
            count = 0;
            LED = !LED;
        end
    end
endmodule
