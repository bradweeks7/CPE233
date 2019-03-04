`timescale 1ns / 1ps


module INTERRUPT(
    input logic INTR,
    input logic I_S,
    input logic I_C,
    input CLK,
    output logic OUT_I
    );

wire OUT_Wire;   

INTERRUPT_HANDLER IH(.SET(I_S), .CLR(I_C), .CLK(CLK), .OUT(OUT_Wire));

always_comb begin

OUT_I = INTR & OUT_Wire;

end
endmodule
