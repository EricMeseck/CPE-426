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
    input CLK, BTNC,
    input [15:0] SWITCHES,
    output logic [15:0] LEDS
    );
    logic [31:0] count = 0; 
    logic [31:0] clkCount = 0;
    logic [8:0] [31:0] oscCount = 0;
    logic [31:0] countCheck;
    logic [3:0] ro_index;
    logic [5:0] challenge = 0;
    logic [7:0] response;
    logic [8:0] ro_enable;
    logic [8:0] out, xout;
    logic countEN = 0, clkEN = 0;
    typedef enum logic [2:0] {
        st_WAIT,
        st_SEL,
        st_COUNT,
        st_STORE,
        st_STALL,
        st_COMP
        } state_type;
   state_type state = st_WAIT;
    
    RingOsc ringo0(challenge[2:0], challenge[5:3], !ro_enable[0], out[0], xout[0]) /* synthesis keep */;
    RingOsc ringo1(challenge[2:0], challenge[5:3], !ro_enable[1], out[1], xout[1]) /* synthesis keep */;
    RingOsc ringo2(challenge[2:0], challenge[5:3], !ro_enable[2], out[2], xout[2]) /* synthesis keep */;
    RingOsc ringo3(challenge[2:0], challenge[5:3], !ro_enable[3], out[3], xout[3]) /* synthesis keep */;
    RingOsc ringo4(challenge[2:0], challenge[5:3], !ro_enable[4], out[4], xout[4]) /* synthesis keep */;
    RingOsc ringo5(challenge[2:0], challenge[5:3], !ro_enable[5], out[5], xout[5]) /* synthesis keep */;
    RingOsc ringo6(challenge[2:0], challenge[5:3], !ro_enable[6], out[6], xout[6]) /* synthesis keep */;
    RingOsc ringo7(challenge[2:0], challenge[5:3], !ro_enable[7], out[7], xout[7]) /* synthesis keep */;
    RingOsc ringo8(challenge[2:0], challenge[5:3], !ro_enable[8], out[8], xout[8]) /* synthesis keep */;
    always_ff @ (posedge out[ro_index]) begin
        if (countEN) begin
            count += 1;
        end
        else begin count = 0; end
    end
    
   always_ff @ (posedge CLK) begin
        if (clkEN) begin
            clkCount += 1;
        end
        else begin clkCount = 0; end
   
        case (state)
            st_WAIT: begin
                if ((challenge != SWITCHES[5:0]) || BTNC) begin
                    state = st_COUNT;
                    challenge = SWITCHES[5:0];
                    ro_index = 0;
                    ro_enable = 1;
                    LEDS[14] = 0;
                    clkEN = 1;
                    countEN = 1;
                end
            end
            st_COUNT: begin 
                if (clkCount > 10000000) begin
                    state = st_STORE;
                end
            end
            st_STORE: begin 
                oscCount[ro_index] = count;
                clkEN = 0;
                countEN = 0;
                ro_enable <=  ro_enable << 1;
                if (ro_index < 8) begin 
                    ro_index++;
                    state = st_STALL;  
                end
                else begin state = st_COMP; end
            end
            st_STALL: begin
                clkEN = 1;
                countEN = 1;
                state = st_COUNT;
            end
            st_COMP: begin 
                for (int i = 0; i < 8; i++) begin
                    response[i] = oscCount[i] >= oscCount[i+1];
                end
                LEDS[14] = 1;
                LEDS[7:0] = response;
                state = st_WAIT;
            end
        endcase
   end
    
endmodule
