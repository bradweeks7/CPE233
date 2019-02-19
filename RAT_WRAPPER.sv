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
    input [7:0] SWITCHES,
    output logic [7:0] LEDS
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
       
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic s_load;
   // logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_leds = 8'h00;
    
    logic [7:0] D;

    // Declare RAT_CPU ///////////////////////////////////////////////////////
    MCU MCU (.IN_PORT_MCU(s_input_port), .OUT_PORT_MCU(s_output_port),
                .PORT_ID_MCU(s_port_id), .IO_STRB_MCU(s_load), .RESET_MCU(s_reset),
               /*.INTR(s_interrupt),*/ .CLK(s_clk_50));
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
        else
            s_input_port = 8'h00;
    end
   
    // MUX for updating output registers /////////////////////////////////////
    
    always_comb begin
        if (s_port_id == s_output_port) begin
            D <= s_output_port;
            end
        end
  
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
            if (s_port_id == LEDS_ID) begin
                r_leds <= s_output_port;
            end
        end
    end
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
   // assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    assign LEDS = r_leds;
   
    endmodule
