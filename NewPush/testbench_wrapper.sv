`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2019 08:55:42 PM
// Design Name: 
// Module Name: testbench_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_wrapper();

logic CLK;
logic BTNC;
logic [7:0] SWITCHES;
logic [7:0] LEDS;
logic [7:0] CATH_OUT;
logic [3:0] ANO_OUT;

initial begin
CLK = 1'B0;
BTNC = 1'B0;
SWITCHES = 8'B00000000;
end

RAT_WRAPPER uut(.CLK(CLK), .BTNC(BTNC), .SWITCHES(SWITCHES), .LEDS(LEDS), .CATH_OUT(CATH_OUT), .ANO_OUT(ANO_OUT));

always
 #10 CLK = ~CLK;






endmodule
