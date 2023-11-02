`timescale 1ns / 1ps

module Branch_Cache(
    input clk,
    input [31:0] pc,
    input [31:0] addr,
    input [31:0] dest,
    input seen, taken,
    input [2:0] genPcSource,
    output logic [31:0] branch,
    output logic [2:0] pcSource,
    output logic [3:0] tablePC, tableNewAddr,
    output logic squash,
    output logic [15:0] [31:0] addressBox
    ); 
    
    logic [15:0] [31:0] destinationBox;
    logic [15:0] [1:0] stateBox;
    
    toTableValue hexerPC(pc, tablePC);
    toTableValue hexerAddr(addr, tableNewAddr);
    always_ff @ (negedge clk) begin
        if (seen) begin
            //Branch seen and in table
            if (addr == addressBox[tableNewAddr]) begin
                //Predicted no jump, but was
                if(taken && stateBox[tableNewAddr] <= 2'b01) begin
                    squash = 1'b1;
                    pcSource = 3'b010;
                    branch = destinationBox[tableNewAddr];
                    stateBox[tableNewAddr] += 1; 
                end
                //Predicted jump, but wasn't
                else if (!taken && stateBox[tableNewAddr] >= 2'b10) begin
                    squash = 1'b1;
                    pcSource = 3'b010;
                    branch = addressBox[tableNewAddr] + 4;
                    stateBox[tableNewAddr] -= 1; 
                end
                //Prediction was correct
                else begin
                    squash = 1'b0;
                    pcSource = 3'b000;
                    if (taken && stateBox[tableNewAddr] == 2'b10) begin
                        stateBox[tableNewAddr] += 1;
                    end
                    else if (!taken && stateBox[tableNewAddr] == 2'b01) begin
                        stateBox[tableNewAddr] -= 1;
                    end 
                    if (pc == addressBox[tablePC]) begin
                        if (stateBox[tablePC] > 2'b10) begin
                            pcSource = 3'b010;
                            branch = destinationBox[tablePC];
                        end
                    end
                end
            end
            //Branch seen but not in table
            else begin
                addressBox[tableNewAddr] = addr;
                destinationBox[tableNewAddr] = dest;
                if (taken) begin
                    stateBox[tableNewAddr] = 2'b10;
                    squash = 1'b1;
                    pcSource = 3'b010;
                    branch = dest;
                end
                else begin
                    stateBox[tableNewAddr] = 2'b01;
                    squash = 1'b0;
                    pcSource = genPcSource;
                end
            end
        end
        else if (pc == addressBox[tablePC]) begin
            if (stateBox[tablePC] >= 2'b10) begin
                pcSource = 3'b010;
                branch = destinationBox[tablePC];
                squash = 1'b0;
            end 
            else begin 
            pcSource = genPcSource; 
            squash = 1'b0;
            end
        end
        else begin 
        pcSource = genPcSource; 
        squash = 1'b0;
        end
    end
endmodule

module toTableValue(
    input [31:0] addr,
    output logic [3:0] val
    );
    always_comb begin
    val = (addr[31:28] + addr[27:24] + addr[23:20] + addr[19:16] + addr[15:12] + addr[11:8]
           + addr[7:4] + addr[3:0]) % 16;
    end
endmodule 