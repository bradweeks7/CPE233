`timescale 1ns / 1ps

module SHADOW_MUX(
    input logic FLG,
    input logic LD_SEL,
    input logic SHAD_FLG,
    output logic FLG_IN
    );
    
always_comb begin
case(LD_SEL)
    1'b0: FLG_IN = FLG;
    1'b1: FLG_IN = SHAD_FLG;
endcase
end
endmodule
