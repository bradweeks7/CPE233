`timescale 1ns / 1ps



module testbench_mcu();
logic CLK;
logic RESET_MCU;
logic [7:0]IN_PORT_MCU; 
logic [7:0] OUT_PORT_MCU; 
logic [7:0] PORT_ID_MCU; 
logic IO_STRB_MCU;

MCU uut(.CLK(CLK), .RESET_MCU(RESET_MCU), .IN_PORT_MCU(IN_PORT_MCU), .OUT_PORT_MCU(OUT_PORT_MCU), .PORT_ID_MCU(PORT_ID_MCU), .IO_STRB_MCU(IO_STRB_MCU));

endmodule
