`timescale 1ns / 1ps
module REG_MUX(
	input logic [7:0] IN_PORT, SP_OUT_B, ALU_RESULT, SCR_DATA_OUT,
	input logic [1:0] RF_WR_SEL_MUX,
	output logic [7:0] DIN_REG
	);
	
always_comb
begin
case( RF_WR_SEL_MUX)
    2'b00: DIN_REG = ALU_RESULT;
    2'b01: DIN_REG = SCR_DATA_OUT;
    2'b10: DIN_REG = SP_OUT_B;
    2'b11: DIN_REG = IN_PORT;
endcase
end
endmodule