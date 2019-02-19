`timescale 1ns / 1ps
module Reg_File(
	input logic [7:0] DIN_REG_FILE,
	input logic [17:0] IR,
	input logic WR,
	input logic CLK,
	output logic [7:0] DX_OUT, DY_OUT,
	output logic [7:0] OUT_PORT
	);
	
logic [7:0] ram [0:31]; 			 //sets up 2d RAM file, 8x32

initial begin  				//instantiates all values in register to 0
	int i;
	for (i=0; i<32; i++)		//loops through each register, sets new value for each one
begin	
    		ram[i] = 0;		//for every iterations, set the register to 0
    end
	end



always_comb				//dx and dy are asynchronous => combinational logic
begin
DX_OUT <= ram[IR[12:8]];
DY_OUT <= ram[IR[7:3]];
OUT_PORT <= ram[IR[12:8]];
end

always_ff @(posedge CLK) 		//synchronous portion, writing into register file
begin
if (WR == 1'b1)			//checks to see if write is high, if so...
	ram[IR[12:8]] = DIN_REG_FILE;		//Write DIN to the inputted address
end
endmodule
