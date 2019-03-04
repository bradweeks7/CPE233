`timescale 1ns / 1ps

module SHADOW_FLAGS(
    input FLG_SHAD_LD,
    input FLG_LD_SEL,
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
	
wire MUX_TO_Z;
wire MUX_TO_C;
wire SHAD_Z_TO_MUX;
wire Z_TO_SHAD;
wire SHAD_C_TO_MUX;
wire C_TO_SHAD;

SHADOW_MUX Z_MUX(.LD_SEL(FLG_LD_SEL), .FLG(Z_ALU), .SHAD_FLG(SHAD_Z_TO_MUX), .FLG_IN(MUX_TO_Z));

INDIVIDUAL_FLAG Z_REG(.LD(Z_LD_FLG), .CLK(CLK), .IN(MUX_TO_Z), .OUT(Z_TO_SHAD));

INDIVIDUAL_FLAG Z_SHAD(.LD(FLG_SHAD_LD), .CLK(CLK), .IN(Z_TO_SHAD), .OUT(SHAD_Z_TO_MUX));

SHADOW_MUX C_MUX(.LD_SEL(FLG_LD_SEL), .FLG(C_ALU), .SHAD_FLG(SHAD_C_TO_MUX), .FLG_IN(MUX_TO_C));

C_FLAG_CONTROLLER C_REG(.IN(MUX_TO_C), .LD(C_LD_FLG), .SET(C_SET_FLG), .CLR(C_CLR_FLG), .CLK(CLK), .OUT(C_TO_SHAD));

INDIVIDUAL_FLAG C_SHAD(.LD(FLG_SHAD_LD), .CLK(CLK), .IN(C_TO_SHAD), .OUT(SHAD_C_TO_MUX));

assign C_FLG = C_TO_SHAD;
assign Z_FLG = Z_TO_SHAD;

endmodule
