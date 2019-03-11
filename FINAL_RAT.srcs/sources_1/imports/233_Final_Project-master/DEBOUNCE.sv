`timescale 1ns / 1ps

module DEBOUNCE(
    input CLK,
    input BTN,
    output logic DB_BTN
    );
    
    const logic [7:0] c_LOW_GOING_HIGH_CLOCKS = 8'h22; // 25 clks
    const logic [7:0] c_HIGH_GOING_LOW_CLOCKS = 8'h30; // 50 clks
    const logic [7:0] c_ONE_SHOT_CLOCKS       = 8'h03; // 3 clks

    typedef enum { ST_init, ST_BTN_low, ST_BTN_low_to_high, ST_BTN_high, ST_BTN_high_to_low, ST_one_shot} STATES;
    
    STATES NS, PS;
    
    logic [7:0] s_db_count = 8'h00;
    logic s_count_rst, s_count_inc = 1'b0;
    
    // Counter block to count the number of clock pulses when enabled  /////////
    always_ff @(posedge CLK) begin
        if (s_count_rst == 1'b1)
            s_db_count = 8'h00;
        else if (s_count_inc == 1'b1)
            s_db_count = s_db_count + 1;
    end
    ////////////////////////////////////////////////////////////////////////////
    
    // FSM State Register //////////////////////////////////////////////////////
    always_ff @(posedge CLK) begin
       PS = NS; 
    end
    ////////////////////////////////////////////////////////////////////////////
    
    // FSM Logic //////////////////////////////////////////////////////////////
    always_comb begin
        // assign default values to avoid latches
        NS = ST_init;
        DB_BTN = 1'b0;
        s_count_rst = 1'b0;
        s_count_inc = 1'b0;
        
        case (PS)
            ST_init: begin          // initialize FSM 
                NS = ST_BTN_low;
                DB_BTN = 1'b0;
                s_count_rst = 1'b1;
            end
            
            ST_BTN_low: begin   // waiting for button press
                if (BTN == 1'b1) begin       // press detected
                    NS = ST_BTN_low_to_high;  
                    s_count_inc = 1'b1;       // start counting
                end
                else begin
                    NS = ST_BTN_low;        // nothing detected
                    s_count_rst = 1'b1;
                end
            end
            
            ST_BTN_low_to_high: begin   // waiting for high bounce to settle
                if (BTN == 1'b1) begin  // button is still high
                    // button stayed high for specified time
                    if (s_db_count == c_LOW_GOING_HIGH_CLOCKS) begin 
                        NS = ST_BTN_high;
                        s_count_rst = 1'b1;
                    end
                    else begin          // keep counting
                        NS = ST_BTN_low_to_high;
                        s_count_inc = 1'b1;
                    end
                end
                else begin              // button low, so still bouncing
                    NS = ST_BTN_low;
                    s_count_rst = 1'b1;
                end
            end
            
            ST_BTN_high: begin          // waiting for button release
                if (BTN == 1'b1) begin 
                    NS = ST_BTN_high;
                    s_count_rst = 1'b1;
                end
                else begin              // button released
                    NS = ST_BTN_high_to_low;
                    s_count_inc = 1'b1;
                end
            end
            
            ST_BTN_high_to_low: begin
                if (BTN == 1'b0) begin  // button still low
                    // button stayed low for specified time
                    if (s_db_count == c_HIGH_GOING_LOW_CLOCKS) begin 
                        NS = ST_one_shot;
                        s_count_rst = 1'b1;
                    end
                    else begin          // keep counting
                        NS = ST_BTN_high_to_low;
                        s_count_inc = 1'b1;
                    end
                end
                else begin              // button high, so still bouncing
                    NS = ST_BTN_high;
                    s_count_rst = 1'b1;
                end 
            end
            
            ST_one_shot: begin  // button press complete, create a single pulse
                // one shot pulse has been high for specified time
                if (s_db_count == c_ONE_SHOT_CLOCKS) begin  
                    NS = ST_init;
                    s_count_rst = 1'b1;
                    DB_BTN = 1'b0;
                end
                else begin              // keep counting
                    NS = ST_one_shot;
                    s_count_inc = 1'b1;
                    DB_BTN = 1'b1;
                end
            end
            
            default: begin              // failsafe
                NS = ST_init;
                s_count_rst = 1'b1;
                s_count_inc = 1'b0;
                DB_BTN = 1'b0;
            end
        endcase
    end
    ////////////////////////////////////////////////////////////////////////////
    
endmodule
