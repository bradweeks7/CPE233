`timescale 1ns / 1ps

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
    logic [7:0] MCU_OUT_PORT_OUT;
    logic [7:0] PORT_ID_OUT;
    logic IO_STRB_OUT;
   // logic s_interrupt;
    logic RESET_IN;
    logic SlowCLK = 1'b0;     // 50 MHz clock
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   MCU_IN_PORT;
    logic [7:0]   r_leds = 8'h00;
    
    logic [7:0] D;
    

    // Declare RAT_CPU ///////////////////////////////////////////////////////
    MCU MCU (.IN_PORT_MCU(MCU_IN_PORT), .OUT_PORT_MCU(MCU_OUT_PORT_OUT),
                .PORT_ID_MCU(PORT_ID_OUT), .IO_STRB_MCU(IO_STRB_OUT), .RESET_MCU(RESET_IN),
               /*.INTR(s_interrupt),*/ .CLK(SlowCLK));
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        SlowCLK <= ~SlowCLK;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        case(PORT_ID_OUT)
            8'h20 : MCU_IN_PORT = SWITCHES;
            default : MCU_IN_PORT = 8'h00;
        endcase
        end
   
    // MUX for updating output registers /////////////////////////////////////
    
    always_comb begin
        case(PORT_ID_OUT)
            8'h40 : D = MCU_OUT_PORT_OUT;
            default : D = 8'b00000000;
        endcase
        end
  
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge SlowCLK) begin
        case(IO_STRB_OUT)
            1'b1 : r_leds <= D;
            default : r_leds <= r_leds;
        endcase
    end
     
    
    /* 
    always_ff @ (posedge SlowCLK) begin
    case(IO_STRB_OUT)
    1'b1 : begin
            case(PORT_ID_OUT)
                8'h40 : r_leds <= MCU_OUT_PORT_OUT;
                default : r_leds <= r_leds; 
           endcase
           end
    default : r_leds <= r_leds;
    endcase
    end
    */
    
    // Connect Signals ///////////////////////////////////////////////////////
    assign RESET_IN = BTNC;
   // assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    assign LEDS = r_leds;
   
    endmodule
