`timescale 1ns / 1ps

module CU_FSM(
    input CLK,
    input INT,
    input RST,
    input [6:0] ir,
    input [2:0] csrStuff,
    output logic pcWrite,
    output logic regWrite,
    output logic memWrite,
    output logic memRead1,
    output logic memRead2,
    output logic csrWrite,
    output logic intTaken,
    output logic execute
    );
    
    typedef enum {FETCH,EXECUTE,LOAD,INTERRUPT} STATES;
    STATES PS = FETCH;
    STATES NS;
    
    always_ff @ (posedge CLK)
    begin
        if (RST) begin
        PS <= FETCH;
        end
        else begin
        PS <= NS;
        end
    end 
    
    always_comb
    begin
    pcWrite = 1'b0;
    regWrite= 1'b0;
    memWrite= 1'b0;
    memRead1= 1'b1;
    memRead2= 1'b0;
   csrWrite = 1'b0;
   intTaken = 1'b0;
        case (PS)
            FETCH: begin
                NS = EXECUTE;
                pcWrite = 1'b0;
                regWrite= 1'b0;
                memWrite= 1'b0;
                memRead1= 1'b1;
                memRead2= 1'b0;
                csrWrite = 1'b0;
                intTaken = 1'b0;
                execute = 1'b1;
            end
            EXECUTE: begin
            execute = 1'b0;
            if (INT) begin
                    NS = INTERRUPT;
                    pcWrite = 1'b0;
                    regWrite = 1'b0;
                    memWrite = 1'b0;
                    memRead1 = 1'b0;
                    memRead2 = 1'b0;
                    csrWrite = 1'b0;
                    intTaken = 1'b1;
                end
            else if(ir == 7'b0100011) begin
                NS = FETCH;
                pcWrite = 1'b1;
                regWrite= 1'b0;
                memWrite= 1'b1;
                memRead1= 1'b1;
                memRead2= 1'b0;
                csrWrite = 1'b0;
                intTaken = 1'b0;
                end
            else if(ir == 7'b0000011) begin
                NS = LOAD;
                pcWrite = 1'b0;
                regWrite= 1'b0;
                memWrite= 1'b0;
                memRead1= 1'b0;
                memRead2= 1'b1;
                csrWrite = 1'b0;
                intTaken = 1'b0;
                end
            else if(ir == 7'b1100011) begin
                NS = FETCH;
                pcWrite = 1'b1;
                regWrite= 1'b0;
                memWrite= 1'b0;
                memRead1= 1'b0;
                memRead2= 1'b0;
                csrWrite = 1'b0;
                intTaken = 1'b0;
            end
            else if (ir == 7'b1110011) begin
                NS = FETCH;
                pcWrite = 1'b1;
                regWrite = 1'b0;
                memWrite = 1'b0;
                memRead1 = 1'b0;
                memRead2 = 1'b0;
                if (csrStuff == 3'b001) begin
                   csrWrite = 1'b1;
                end
                else begin
                    csrWrite = 1'b0;
                end
                intTaken = 1'b0;
            end
            else begin
                NS = FETCH;
                pcWrite = 1'b1;
                regWrite= 1'b1;
                memWrite= 1'b0;
                memRead1= 1'b0;
                memRead2= 1'b0;
                csrWrite = 1'b0;
                intTaken = 1'b0;
                end
            end
            LOAD: begin
                if (INT) begin
                    NS = INTERRUPT;
                    pcWrite = 1'b0;
                    regWrite = 1'b0;
                    memWrite = 1'b0;
                    memRead1 = 1'b0;
                    memRead2 = 1'b0;
                    csrWrite = 1'b0;
                    intTaken = 1'b1;
                end
                else begin
                    NS = FETCH;
                    pcWrite = 1'b1;
                    regWrite= 1'b1;
                    memWrite= 1'b0;
                    memRead1= 1'b0;
                    memRead2= 1'b0;
                    csrWrite = 1'b0;
                    intTaken = 1'b0;
                end
            end
            INTERRUPT: begin
                NS = FETCH;
                pcWrite = 1'b1;
                regWrite = 1'b0;
                memWrite = 1'b0;
                memRead1 = 1'b0;
                memRead2 = 1'b0;
                csrWrite = 1'b0;
                intTaken = 1'b1;
                execute = 1'b0;
            end
            default:
                NS = FETCH;
        endcase
     end
endmodule
