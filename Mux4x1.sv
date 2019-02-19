`timescale 1ns / 1ps
module mux4x1(
	input logic [17:0] IR, /*FROM_STACK,*/
	input logic [1:0] PC_MUX_SEL,
	output logic [9:0] DIN_MUX
	);
	
always @(*)
begin
if (PC_MUX_SEL == 2'b00) begin
	DIN_MUX = IR[12:3];
end else
/*if (PC_MUX_SEL == 2'b01) begin
	DIN_MUX = FROM_STACK;
end else
*/
if (PC_MUX_SEL == 2'b10) begin
	DIN_MUX = 10'b11111_11111;
end else
if (PC_MUX_SEL == 2'b11) begin
	DIN_MUX = 10'b00000_00000;
end
end
 
endmodule
