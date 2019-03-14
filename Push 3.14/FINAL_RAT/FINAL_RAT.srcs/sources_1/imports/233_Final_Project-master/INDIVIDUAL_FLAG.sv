`timescale 1ns / 1ps


module INDIVIDUAL_FLAG(
    input logic LD,
    input logic CLK,
    input logic IN,
    output logic OUT
    );

always_ff @ (posedge CLK) begin
    if (LD == 1'b1) begin
        OUT <= IN;
    end
end
endmodule
