module KeypadDriver(
    input logic CLK,
    input logic [2:0] Column,
    output logic [7:0]Data_Out,
    output logic Interrupt_Out
    );
    
    logic [7:0] Data;
    logic Interrupt;
    logic [3:0] Rows;
    logic RowCycleClk = 1'b0;
    logic CycleSpeed = 20'hAAE60;  //700 , 000 clk cycles
    
    typedef enum {st_row1, st_row2, st_row3, st_row4} STATES;
    STATES PS, NS;
    
    always @(posedge CLK) begin
        CycleSpeed <= CycleSpeed + 1;
        if (CycleSpeed == 20'hAAE60)
            begin
                CycleSpeed <= 20'h00000;
                RowCycleClk <= ~RowCycleClk;
            end
        end
    
    
    always_ff @(posedge RowCycleClk)
        begin
            PS <= NS;
        end        
    
    
    always_comb begin 
        Data = 8'h00;
        Interrupt = 1'b0;
    
        case(PS)       
        st_row1 : begin
                 if(Column[0] == 1'b1) 
                 begin
                    Data = 8'b10011111; //1
                    Interrupt = 1'b1;
                 end
                 if(Column[1] == 1'b1) begin
                    Data = 8'b0010010; //2
                    Interrupt = 1'b1;
                 end
                 if(Column[2] == 1'b1) begin
                    Data = 8'b0000110; //3
                    Interrupt = 1'b1;
                 end 
                 
                 end
        st_row2 : begin
                 if(Column[0] == 1'b1) begin
                    Data = 8'b1001100; //4
                    Interrupt = 1'b1;
                 end
                 if(Column[1] == 1'b1) begin
                    Data = 8'b0100100; //5
                    Interrupt = 1'b1;
                 end
                 if(Column[2] == 1'b1) begin
                    Data = 8'b0100000; //6
                    Interrupt = 1'b1;
                 end
                 NS = st_row3;
                 end 
        st_row3 : begin
                 if(Column[0] == 1'b1) begin
                   Data = 8'b0001111; //7
                   Interrupt = 1'b1;
                 end
                 if(Column[1] == 1'b1) begin
                    Data = 8'b0000000; //8
                    Interrupt = 1'b1;
                 end
                 if(Column[2] == 1'b1) begin
                    Data = 8'b0000100; //9
                    Interrupt = 1'b1;
                 end 
                 NS = st_row4;
                 end
        st_row4 : begin
                 if(Column[0] == 1'b1) begin
                    Data = 8'b0000010; // A / #
                    Interrupt = 1'b1;
                 end
                 if(Column[1] == 1'b1) begin
                    Data = 8'b0000001; // 0  
                    Interrupt = 1'b1; 
                 end
                 if(Column[2] == 1'b1) begin
                    Data = 8'b1100000; // B
                    Interrupt = 1'b1;
                 end
                 NS = st_row1;
                 end 
    endcase
   end
    
    always_ff @(posedge RowCycleClk)
        begin
        Data_Out <= Data;
        Interrupt_Out <= Interrupt;
        end
    
    endmodule
    