`timescale 1ns / 1ps

module ALU_Mux2x1(
	input logic ALU_MUX_SEL,
	input logic [7:0] DY_INPUT, [17:0]IR_INPUT,
	output logic [7:0] B_INPUT
	);
	
always_comb begin
if (ALU_MUX_SEL == 1'b0) begin
	B_INPUT = DY_INPUT;
end
else if (ALU_MUX_SEL == 1'b1) begin
	B_INPUT = IR_INPUT[7:0];
end
end
endmodule

