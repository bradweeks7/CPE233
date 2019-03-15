`timescale 1ns / 1ps

module C_FLAG_CONTROLLER(
    input logic IN,
    input logic LD,
    input logic SET,
    input logic CLR,
    input logic CLK,
    output logic OUT
    );
    
always_ff @ (posedge CLK) begin

if (SET == 1'b1) begin
	OUT <= 1'b1;
	end
else if (CLR == 1'b1) begin
	OUT <= 1'b0;
	end
else if (LD == 1'b1) begin
	OUT <= IN;
	end
end
endmodule
