`timescale 1ns / 1ps

module RAT_DEMUX(
    input [7:0] OUTPUT_DATA_IN,
    input [7:0] PORT_ID_MCU,
    output logic [7:0] D_led,
    output logic [7:0] D_ss

    );
   
localparam LEDS_ID = 8'h40;
localparam SEVSEG_ID = 8'h81;


always_comb begin
    if (PORT_ID_MCU == LEDS_ID) begin
        D_led = OUTPUT_DATA_IN;
        D_ss = 8'h00;
        end
    else if (PORT_ID_MCU == SEVSEG_ID) begin
        D_ss = OUTPUT_DATA_IN;
        D_led = 8'h00;
        end
end        

endmodule
