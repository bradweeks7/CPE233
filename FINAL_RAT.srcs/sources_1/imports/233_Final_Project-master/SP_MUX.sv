`timescale 1ns / 1ps

module SP_MUX(
	input logic [7:0] SP_OUT,
	input logic [7:0] DX_OUT, 
	input logic [7:0] IR,
	input logic [1:0] SCR_ADDR_SEL,
	output logic [7:0] SCR_ADDR
	);
	
always_comb
begin
case(SCR_ADDR_SEL)
    2'b00: SCR_ADDR = DX_OUT;
    2'b01: SCR_ADDR = IR;
    2'b10: SCR_ADDR = SP_OUT;
    2'b11: SCR_ADDR = SP_OUT - 1'b1;
endcase
end
endmodule