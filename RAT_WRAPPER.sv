`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: Basic RAT_WRAPPER
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module RAT_WRAPPER(
    input CLK,
    input BTNC,
    input BTNI,
    input [7:0] SWITCHES,
    output [7:0] LEDS,
    output logic [7:0] CATH_OUT,
    output logic [3:0] ANO_OUT
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SEVSEG_ID = 8'h81;
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] MCU_OUT_PORT_OUT;
       logic [7:0] PORT_ID_OUT;
       logic IO_STRB_OUT;
       logic s_interrupt;
       logic RESET_IN;
       logic SlowCLK = 1'b0;     // 50 MHz clock
       logic An_OUT;
       logic Cat_OUT;
       
       // Register definitions for output devices ///////////////////////////////
       logic [7:0]  MCU_IN_PORT;
       logic [7:0]  r_leds = 8'h00;
       logic [15:0] SevSegIN;
       logic [7:0]  SS_C_OUT;
       logic [3:0]  SS_A_OUT;
       
       logic [7:0] D_led;
       logic [7:0] D_ss; 
       
       
   
       // Declare RAT_CPU ///////////////////////////////////////////////////////
       MCU MCU(.IN_PORT_MCU(MCU_IN_PORT), .OUT_PORT_MCU(MCU_OUT_PORT_OUT),
                   .PORT_ID_MCU(PORT_ID_OUT), .IO_STRB_MCU(IO_STRB_OUT), .RESET_MCU(RESET_IN),
                   .INT_R(s_interrupt), .CLK(SlowCLK));
       SevSegDisp SV (.CLK(SlowCLK), .MODE(1'b1), .DATA_IN(SevSegIN), .CATHODES(SS_C_OUT), .ANODES(SS_A_OUT));
       DEBOUNCE DB(.CLK(SlowCLK), .BTN(BTNI), .DB_BTN(s_interrupt));
       
       // Clock Divider to create 50 MHz Clock //////////////////////////////////
       always_ff @(posedge CLK) begin
           SlowCLK <= ~SlowCLK;
       end
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
        else
            s_input_port = 8'h00;
    end
   
    // MUX for updating output registers /////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
            if (s_port_id == LEDS_ID)
                r_leds <= s_output_port;
            end
            if (s_port_id ==
        
       end
        
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
    assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    assign LEDS = r_leds;
   
    endmodule
