module demux1to4(
     input logic [7:0] OUTPUT_MCU,
     input logic [7:0] port ,
    output logic Data_out_0,
    output logic Data_out_1,
    output logic Data_out_2,
    output logic Data_out_3
    );

//always block with Data_in and sel in its sensitivity list
    always_comb
    begin
        case (sel)  //case statement with "sel"
        //multiple statements can be written inside each case.
        //you just have to use 'begin' and 'end' keywords as shown below.
            2'b00 : begin
                        Data_out_0 = Data_in;
                        Data_out_1 = 0;
                        Data_out_2 = 0;
                        Data_out_3 = 0;
                      end
            2'b01 : begin
                        Data_out_0 = 0;
                        Data_out_1 = Data_in;
                        Data_out_2 = 0;
                        Data_out_3 = 0;
                      end
            2'b10 : begin
                        Data_out_0 = 0;
                        Data_out_1 = 0;
                        Data_out_2 = Data_in;
                        Data_out_3 = 0;
                      end
            2'b11 : begin
                        Data_out_0 = 0;
                        Data_out_1 = 0;
                        Data_out_2 = 0;
                        Data_out_3 = Data_in;
                      end
        endcase
    end
    
endmodule