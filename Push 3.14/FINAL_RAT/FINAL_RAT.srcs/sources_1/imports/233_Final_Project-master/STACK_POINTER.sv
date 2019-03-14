`timescale 1ns / 1ps

module SP(
    input logic [7:0] SP_DATA_IN,
    input logic SP_RST,
    input logic SP_LD,
    input logic SP_INCR,
    input logic SP_DECR,
    input logic CLK,
    output logic [7:0] SP_OUT
    ); 
    
    always_ff @(posedge CLK)
    begin
    
    //Reset (RST) has the highest priority
    if (SP_RST == 1'b1)
            SP_OUT <= 8'b00000000;
    else if (SP_LD == 1'b1)
            SP_OUT <= SP_DATA_IN;
    else if (SP_INCR == 1'b1)
            SP_OUT <= SP_OUT + 1'b1;
    else if (SP_DECR == 1'b1)
            SP_OUT <= SP_OUT - 1'b1;
    end
    
endmodule
