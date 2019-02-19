`timescale 1ns / 1ps

module Flags(
	input C_SET_FLG,
	input C_LD_FLG,
	input C_CLR_FLG,
	input Z_LD_FLG,
	input logic C_ALU,
	input logic Z_ALU,
	input CLK,
	output logic C_FLG,
	output logic Z_FLG
	);
	
always_ff @ (posedge CLK) begin
if (C_SET_FLG == 1'b1) begin
	C_FLG <= 1'b1;
	end
else if (C_CLR_FLG == 1'b1) begin
	C_FLG <= 1'b0;
	end
else if (C_LD_FLG == 1'b1) begin
	C_FLG <= C_ALU;
	end
if (Z_LD_FLG == 1'b1) begin
	Z_FLG <= Z_ALU;
	end
end
endmodule