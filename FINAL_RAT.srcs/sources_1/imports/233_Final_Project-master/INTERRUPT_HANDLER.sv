`timescale 1ns / 1ps

module INTERRUPT_HANDLER(
    input logic SET,
    input logic CLR,
    input logic CLK,
    output logic OUT
    );

always_ff @ (posedge CLK) begin

if (CLR == 1'b1) begin
    OUT <= 1'b0;
    end
else if (SET == 1'b1) begin
    OUT <= 1'b1;
    end     
end
endmodule
