`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: J. Calllenes
//           P. Hummel
// 
// Create Date: 01/20/2019 10:36:50 AM
// Description: OTTER Wrapper (with Debounce, Switches, LEDS, and SSEG
//////////////////////////////////////////////////////////////////////////////////

module OTTER_Wrapper(
   input CLK,
   input BTNL,
   input BTNC,
   input [15:0] SWITCHES,
   output logic [15:0] LEDS,
   output [7:0] CATHODES,
   output [3:0] ANODES
   );
       
   
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more MMIO, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_AD = 32'h11000000;
    //localparam RAND_AD = 32'h11040000;
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more MMIO
    localparam LEDS_AD      = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;
   
    
   // Signals for connecting OTTER_MCU to OTTER_wrapper /////////////////////////
   logic s_interrupt;
   logic s_reset,s_load;  
   logic slck;
   //logic [3:0] random;
   
 
   logic [15:0]  r_SSEG;// = 16'h0000;
     
   logic [31:0] IOBUS_out,IOBUS_in,IOBUS_addr;
   logic IOBUS_wr;
   logic [31:0] ir;
   
   assign s_interrupt = BTNL;
   
   
    // Declare OTTER_CPU ///////////////////////////////////////////////////////
   Otter_Control MCU (.CLK(slck),.INTR(s_interrupt), .RST(s_reset), 
                   .IOBUS_OUT(IOBUS_out),.IOBUS_IN(IOBUS_in),.IOBUS_ADDR(IOBUS_addr),.IOBUS_WR(IOBUS_wr), .ir(ir));

   // Declare Seven Segment Display /////////////////////////////////////////
   SevSegDisp SSG_DISP (.DATA_IN(r_SSEG), .CLK(slck), .MODE(1'b1),
                       .CATHODES(CATHODES), .ANODES(ANODES));
   
   // Declare Debouncer One Shot  ///////////////////////////////////////////
   debounce_one_shot DB(.CLK(CLK), .BTN(BTNL), .DB_BTN(btn_int));
   
   // Declare Random Number ANODES
   //RandGen rando (.CLK(CLK), .RST(BTNC), .RANDOM(random));
   
   clk_div slow(CLK, slck);
  
   assign s_reset = BTNC;
   
     // Connect Board peripherals (Memory Mapped IO devices) to IOBUS /////////////////////////////////////////
    always_ff @ (posedge slck)
    begin
     
        if(IOBUS_wr)
            case(IOBUS_addr)
                LEDS_AD: LEDS <= IOBUS_out;    
                
            endcase
        r_SSEG <= ir[15:0];
    end
   
    always_comb
    begin
        IOBUS_in=32'b0;
        case(IOBUS_addr)
            SWITCHES_AD: IOBUS_in[15:0] = SWITCHES;
            //RAND_AD: IOBUS_in[3:0] = random;
            default: IOBUS_in=32'b0;
        endcase
    end
   endmodule

