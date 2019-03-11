`timescale 1ns / 1ps

module ALU_MUX(
	input logic ALU_MUX_SEL,
	input logic [7:0] DY_INPUT, 
	input logic [7:0] IR_INPUT,
	output logic [7:0] B_INPUT
	);
	
always_comb
begin
case(ALU_MUX_SEL)
    1'b0: B_INPUT = DY_INPUT;
    1'b1: B_INPUT = IR_INPUT;
endcase
end
endmodule