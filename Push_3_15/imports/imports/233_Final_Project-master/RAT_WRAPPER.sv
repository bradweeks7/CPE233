`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: RAT_WRAPPER with VGA connections
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module RAT_WRAPPER(
    input CLK,
    //input BTNL,
    input BTNC,
    input PS2CLK,
    input PS2DATA,
    input [7:0] SWITCHES,
    output [7:0] LEDS,
    output [7:0] CATHODES,
    output [3:0] ANODES,
    output [7:0] VGA_RGB,
    output VGA_HS,
    output VGA_VS
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
    localparam KEYBOARD_ID = 8'h22;
    localparam VGA_READ_ID = 8'h93;
    localparam RANDOM_ID = 8'h21;
    localparam COLOR_ID = 8'h23;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SSEG_ID     = 8'h81;
    localparam VGA_HADDR_ID = 8'h82;
    localparam VGA_LADDR_ID = 8'h83;
    localparam VGA_COLOR_ID = 8'h84;
       
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] OUT_PORT_MCU;
    logic [7:0] PORT_ID_MCU;
    logic s_load;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    logic [7:0] randomIN;
    logic [7:0] s_scancode;
    
    // Signals for connecting VGA Framebuffer Driver
    logic r_vga_we;             // write enable
    logic [10:0] r_vga_wa;      // address of framebuffer to read and write
    logic [7:0] r_vga_wd;       // pixel color data to write to framebuffer
    logic [7:0] r_vga_rd;       // pixel color data read from framebuffer
     
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   IN_PORT_MCU;
    logic [7:0]   r_LEDS = 8'h00;
    logic [15:0]  r_SSEG = 16'h0000;
         
    // Declare RAT_CPU ///////////////////////////////////////////////////////
    MCU MCU (.IN_PORT_MCU(IN_PORT_MCU), .OUT_PORT_MCU(OUT_PORT_MCU),
                .PORT_ID_MCU(PORT_ID_MCU), .IO_STRB_MCU(s_load), .RESET_MCU(s_reset),
                .INT_R(s_interrupt), .CLK(s_clk_50));
    
    // Declare Seven Segment Display /////////////////////////////////////////
    SevSegDisp SSG_DISP (.DATA_IN(r_SSEG), .CLK(CLK), .MODE(1'b0),
                        .CATHODES(CATHODES), .ANODES(ANODES));
    
    // Declare Debouncer One Shot  ///////////////////////////////////////////
    //DEBOUNCE DB(.CLK(s_clk_50), .BTN(BTNL), .DB_BTN(s_interrupt));
    
    // Declare RANDOM_GENERATOR  /////////////////////////////////////////////
    RANDOM_GENERATOR RG(.CLK(CLK), .RST(s_reset), .RANDOM(randomIN));
    
    // Declare VGA Frame Buffer //////////////////////////////////////////////
    vga_fb_driver VGA(.CLK(s_clk_50), .reset(s_reset), .WA(r_vga_wa), .WD(r_vga_wd),
                        .WE(r_vga_we), .RD(r_vga_rd), .ROUT(VGA_RGB[7:5]),
                        .GOUT(VGA_RGB[4:2]), .BOUT(VGA_RGB[1:0]),
                        .HS(VGA_HS), .VS(VGA_VS));
    
    // declare keyboard module
    KeyboardDriver KEYBD (.CLK(CLK), .PS2DATA(PS2DATA), .PS2CLK(PS2CLK),
                          .INTRPT(s_interrupt), .SCANCODE(s_scancode));

    
    // Clock Divider to create 50 MHz Clock /////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (PORT_ID_MCU == SWITCHES_ID)
            IN_PORT_MCU = SWITCHES;
        else if (PORT_ID_MCU == VGA_READ_ID)
            IN_PORT_MCU = r_vga_rd;
        else if (PORT_ID_MCU == RANDOM_ID)
            IN_PORT_MCU = randomIN;
        else if (PORT_ID_MCU == KEYBOARD_ID)
            IN_PORT_MCU = s_scancode;
        else if (PORT_ID_MCU == COLOR_ID) 
            IN_PORT_MCU = r_vga_rd;
        else
            IN_PORT_MCU = 8'h00;
    end
   
    // MUX for updating output registers //////////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        r_vga_we <= 1'b0;           // reset VGA framebuffer write enable to 0
        if (s_load == 1'b1) begin
             
            if (PORT_ID_MCU == LEDS_ID)
                r_LEDS <= OUT_PORT_MCU;
            else if (PORT_ID_MCU == SSEG_ID)
                r_SSEG <= {8'h00, OUT_PORT_MCU};
            else if (PORT_ID_MCU == VGA_HADDR_ID)   // top 3 bits of high addr
                r_vga_wa[10:8] <= OUT_PORT_MCU[2:0];
            else if (PORT_ID_MCU == VGA_LADDR_ID)   // lower 8 bits for low addr
                r_vga_wa[7:0] <= OUT_PORT_MCU[7:0];  // was [4:0]
            else if (PORT_ID_MCU == VGA_COLOR_ID) begin
                r_vga_wd <= OUT_PORT_MCU;
                r_vga_we <= 1'b1; // write enable to save data to framebuffer
            end
        end
    end

     
    // Connect Signals ////////////////////////////////////////////////////////////
    assign s_reset = BTNC;
     
    // Register Interface Assignments /////////////////////////////////////////////
    assign LEDS = r_LEDS;
   
    endmodule