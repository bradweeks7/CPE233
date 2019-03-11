`timescale 1ns / 1ps


module testbench_wrapper();

logic CLK;
logic BTNC;
logic BTNL;
logic [7:0] SWITCHES;
logic [7:0] LEDS;
logic [7:0] CATHODES;
logic [3:0] ANODES;
logic [7:0] VGA_RGB;
logic VGA_VS;
logic VGA_HS;


initial begin
CLK = 1'B0;
BTNC = 1'B0;
BTNL = 1'b0;
SWITCHES = 8'B00000000;
end

RAT_WRAPPER uut(.CLK(CLK), .BTNL(BTNL), .BTNC(BTNC), .SWITCHES(SWITCHES), .LEDS(LEDS), .CATHODES(CATHODES), .ANODES(ANODES), .VGA_RGB(VGA_RGB), .VGA_VS(VGA_VS), .VGA_HS(VGA_HS));

always
 #10 CLK = ~CLK;






endmodule