`timescale 1ns / 1ps
module PC_MUX(
	input logic [9:0] FROM_IR, 
	input logic [9:0] FROM_STACK,
	input logic [1:0] PC_MUX_SEL,
	output logic [9:0] DIN_MUX
	);
	
always_comb
begin
case(PC_MUX_SEL)
    2'b00: DIN_MUX = FROM_IR;
    2'b01: DIN_MUX = FROM_STACK;
    2'b10: DIN_MUX = 10'b11111_11111;
    2'b11: DIN_MUX = 10'b00000_00000;
endcase
end
endmodule