`timescale 1ns / 1ps
module Mux4x1_REG(
	input logic [7:0] IN_PORT, /*SP_OUT_B,*/ ALU_RESULT, /*SCR_DATA_OUT,*/
	input logic [1:0] RF_WR_SEL_MUX,
	output logic [7:0] DIN_REG
	); // SP_OUT and SCR_DATA_OUT to be reimplemented when adding the SP and SCR to the MCU
	
always @(IN_PORT, ALU_RESULT, RF_WR_SEL_MUX, DIN_REG)
begin
if (RF_WR_SEL_MUX == 2'b00) begin
	DIN_REG <= ALU_RESULT;
end else
/*if (RF_WR_SEL_MUX == 2'b01) begin
	DIN_REG <= SCR_DATA_OUT;
end else
if (RF_WR_SEL_MUX == 2'b10) begin
	DIN_REG <= SP_OUT_B;
end else
*/
if (RF_WR_SEL_MUX == 2'b11) begin
	DIN_REG <= IN_PORT;
end
end
 
endmodule


