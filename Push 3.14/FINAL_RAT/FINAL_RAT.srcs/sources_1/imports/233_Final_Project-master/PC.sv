`timescale 1ns / 1ps

module PC(
    input logic PC_RST,
    input logic LD,
    input logic INC,
    input logic [9:0]DIN,
    input logic CLK,
    output logic [9:0]PC_COUNT
    ); 
    
    always_ff @(posedge CLK)
    begin
    
    //Reset (RST) has the highest priority
    if (PC_RST == 1'b1)
        PC_COUNT <= 10'b0000000000;
    else if (LD == 1'b1)
            PC_COUNT <= DIN;
    else if (INC == 1'b1)
            PC_COUNT <= PC_COUNT + 1'b1;    
    end
endmodule
