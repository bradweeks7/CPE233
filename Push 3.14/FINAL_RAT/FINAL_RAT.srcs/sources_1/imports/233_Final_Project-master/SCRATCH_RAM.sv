`timescale 1ns / 1ps
module SCRATCH_RAM(
	input logic [9:0] SCR_DIN,				//data read in
	input logic [7:0] SCR_ADDR,			//8 bit address
	input logic SCR_WE,				//save signal
	input logic CLK,					//clock
	output logic [9:0] SCR_DATA_OUT			//data sent out
	);
	
logic [9:0] ram [0:255];				//ram is 256 address of 10 bit values

initial begin
int i;
for (i=0; i<256; i++)
    begin						//initializing all addresses
    ram[i] = 0;
    end
end

always_ff @(posedge CLK)
begin
if (SCR_WE == 1'b1) begin				//if the signal is high on a posedge
     ram[SCR_ADDR] <= SCR_DIN;				//save data in to current address
     end
end

assign SCR_DATA_OUT = ram[SCR_ADDR];

endmodule
