`timescale 1ns / 1ps
(* keep="true" *)
(* dont_touch = "true" *)
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 05:41:51 PM
// Design Name: 
// Module Name: RingOsc
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


module RingOsc(
    input logic [2:0] sel,
    input logic [2:0] bx,
    input logic en,
    output logic out1, out2 /* synthesis keep */
    );
    logic s1out1, s1out2, s2out1, s2out2 /* synthesis keep */;
    EnableSlice enSliceo(out1, out2, sel[0], bx[0], en, s1out1, s1out2) /* synthesis keep */;
    Slice slicey1(s1out1, s1out2, sel[1], bx[1], s2out1, s2out2) /* synthesis keep */;
    Slice slicey2(s2out1, s2out2, sel[2], bx[2], out1, out2) /* synthesis keep */;
endmodule
