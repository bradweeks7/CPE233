`timescale 1ns / 1ps

module SCR_MUX( 
    input logic SCR_DATA_SEL,
    input logic [7:0] DX_OUT,
    input logic [9:0] PC_COUNT,
    output logic [9:0] SCR_DATA_IN
    );
    
    always_comb begin
       case(SCR_DATA_SEL)
        1'b0: SCR_DATA_IN = {2'b00 , DX_OUT};
        1'b1: SCR_DATA_IN = PC_COUNT;
       endcase
       
    end
    
endmodule
