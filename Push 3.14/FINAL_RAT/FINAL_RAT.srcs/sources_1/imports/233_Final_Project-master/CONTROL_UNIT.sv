`timescale 1ns / 1ps

module CONTROL_UNIT(
	input C_FLAG_CONTR,
	input Z_FLAG_CONTR,
	input RESET,
	input logic [4:0] IR_FIVE,
	input logic [1:0] IR_TWO,
	input CLK,
	output logic PC_LD,
	output logic PC_INC,
	output logic [1:0] PC_MUX_SEL_MCU,
	output logic ALU_OPY_SEL,
	output logic [3:0] ALU_SEL,
	output logic RF_WR,
	output logic [1:0] RF_WR_SEL,
	output logic FLG_C_SET,
	output logic FLG_C_CLR,
	output logic FLG_C_LD,
	output logic FLG_Z_LD,
	output logic MCU_RST,
	output logic IO_STRB,
	input INT_R_MCU,
	output logic I_SET,
	output logic I_CLR,
	output logic SP_LD,
	output logic SP_INCR,
	output logic SP_DECR,
	output logic SCR_WE,
	output logic [1:0] SCR_ADDR_SEL,
	output logic SCR_DATA_SEL,
	output logic FLG_LD_SEL,
	output logic FLG_SHAD_LD
	);	

typedef enum {st_init, st_fetch, st_exec, st_intr} STATES;
STATES PS, NS;
	
always_ff @(posedge CLK) begin
    if (RESET == 1'b1) 
        PS <= st_init;
     else
          PS <= NS;
   end

always_comb begin
         I_SET = 1'b0;
         I_CLR = 1'b0;
	     PC_LD = 1'b0;
	     PC_INC = 1'b0;
	     PC_MUX_SEL_MCU = 2'b00;
         
         ALU_OPY_SEL = 1'b0;
         ALU_SEL = 4'b0000;
         
         RF_WR = 1'b0;
         RF_WR_SEL = 2'b00;
         
         FLG_C_SET = 1'b0;
         FLG_C_CLR = 1'b0;
         FLG_C_LD = 1'b0;
         FLG_Z_LD = 1'b0;
         
         MCU_RST = 1'b0;
         IO_STRB = 1'b0;

         NS = st_fetch;
         
         SP_LD = 1'b0;
         SP_INCR = 1'b0;
         SP_DECR = 1'b0;
         
         SCR_WE = 1'b0;
         SCR_ADDR_SEL = 2'b00;
         SCR_DATA_SEL = 1'b0;
         FLG_LD_SEL = 1'b0;
         FLG_SHAD_LD = 1'b0;
         
case(PS)
st_init : begin
         MCU_RST = 1'b1;
         NS = st_fetch;
         end

st_fetch : begin
         PC_INC = 1'b1;
         NS = st_exec;
         end

st_intr : begin
          PC_MUX_SEL_MCU = 2'b10;
          PC_LD = 1'b1;
          FLG_SHAD_LD = 1'b1;
          SCR_DATA_SEL = 1'b1;
          SCR_WE = 1'b1;
          SP_DECR = 1'b1;
          SCR_ADDR_SEL = 2'b11;
          I_CLR = 1'b1;
          NS = st_fetch;
          end

st_exec : begin
        PC_INC = 1'b0;
        if(INT_R_MCU == 1'b1)
        NS = st_intr;
        else
        NS = st_fetch;
        
    case(IR_FIVE)  
    5'b00000 : begin 
               case(IR_TWO)
                   2'b00 : begin // AND REG - REG
                            RF_WR = 1'b1;
                            ALU_SEL = 4'b0101;
                            FLG_C_CLR = 1'b1;
                            FLG_Z_LD = 1'b1;
                            ALU_OPY_SEL = 1'b0;
                            PC_LD = 1'b0;
                            RF_WR_SEL = 2'b00;
                            end   
                   2'b01 :  begin // OR : REG - REG
                            RF_WR = 1'b1;
                            ALU_SEL = 4'b0110;
                            ALU_OPY_SEL = 1'b0;
                            FLG_C_CLR = 1'b1;
                            PC_LD = 1'b0;
                            RF_WR_SEL = 2'b00;
                            FLG_Z_LD = 1'b1;
                            end
                   2'b10 :  begin        // EXOR REG- REG
                            ALU_SEL = 4'b0111;
                            RF_WR = 1'b1;
                            RF_WR_SEL = 2'b00;
                            FLG_C_CLR = 1'b1;
                            FLG_Z_LD = 1'b1;
                            PC_LD = 1'b0;	
                            end   
                    2'b11 : begin // TEST : REG - REG
                            RF_WR = 1'b0;
                            ALU_SEL = 4'b1000;
                            ALU_OPY_SEL = 1'b0;
                            PC_LD = 1'b0;
                            FLG_C_CLR = 1'b1;
                            FLG_Z_LD = 1'b0;
                            end
                    endcase
                    end
    5'b00001 : begin
               case(IR_TWO)
               2'b00 :  begin // ADD : REG - REG
                        RF_WR = 1'b1;
                        FLG_C_LD = 1'b1;
                        FLG_Z_LD = 1'b1;
                        ALU_OPY_SEL = 1'b0;
                        ALU_SEL = 4'b0000;
                        PC_LD = 1'b0;
                        RF_WR_SEL = 2'b00;
                        end
               2'b01 :  begin // ADDC : REG - REG +C
                        RF_WR = 1'b1;
                        FLG_C_LD = 1'b1;
                        FLG_Z_LD = 1'b1;
                        ALU_OPY_SEL = 1'b0;
                        ALU_SEL = 4'b0001;
                        PC_LD = 1'b0;
                        RF_WR_SEL = 2'b00;
                        end
                2'b10 : begin // SUB : REG - REG
                        RF_WR = 1'b1;
                        RF_WR_SEL = 2'b00;
                        ALU_SEL = 4'b0010;
                        PC_LD = 1'b0;
                        ALU_OPY_SEL = 1'b0;
                        FLG_C_LD = 1'b1;
                        FLG_Z_LD = 1'b1;
                        end
                2'b11 : begin // SUBC : REG - REG
                        RF_WR = 1'b1;
                        RF_WR_SEL = 2'b00;
                        ALU_SEL = 4'b0011;
                        PC_LD = 1'b0;
                        ALU_OPY_SEL = 1'b0;
                        FLG_C_LD = 1'b1;
                        FLG_Z_LD = 1'b1;
                        end
                endcase
                end
    5'b00010 : begin
               case(IR_TWO)
               2'b00 : begin  // CMP : REG - REG
                        PC_LD = 1'b0;
                        ALU_SEL = 4'b0100;
                        FLG_C_LD = 1'b1;
                        FLG_Z_LD = 1'b1;
                        ALU_OPY_SEL = 1'b0; 
                        end 
                2'b01:  begin  //MOV : REG - REG
                        ALU_SEL = 4'b1110;
                        RF_WR = 1'b1;
                        RF_WR_SEL = 2'b00;
                        PC_LD = 1'b0;
                        ALU_OPY_SEL = 1'b0;
                        end
                2'b10 : begin //LD - REG 
                        RF_WR = 1'b1;
                        RF_WR_SEL = 2'b01; 
                        SCR_ADDR_SEL = 2'b00;      
                        end
                2'b11 : begin // ST - REG
                        SCR_WE = 1'b1;
                        SCR_ADDR_SEL = 2'b00;
                        end 
                endcase
                end
    5'b00100 : begin
               case(IR_TWO)
               2'b00 : begin // BRN
                        PC_MUX_SEL_MCU = 2'b00;
                        PC_LD = 1'b1;
                        end   
                2'b01 : begin //CALL
                        SP_DECR = 1'b1;
                        SCR_DATA_SEL = 1'b1;
                        SCR_ADDR_SEL = 2'b11;
                        SCR_WE = 1'b1;
                        PC_LD = 1'b1; 
                        PC_MUX_SEL_MCU = 2'b00;     
                        end
                2'b10 : begin // BREQ 
                         if (Z_FLAG_CONTR == 1'b1) begin
                            PC_LD = 1'b1;
                            PC_MUX_SEL_MCU = 2'b00;
                            end
                         end
                2'b11 :  begin // BRNE
                         if (Z_FLAG_CONTR == 1'b0) begin
                            PC_LD = 1'b1;
                            PC_MUX_SEL_MCU = 2'b00;
                            end
                         end 
                default : PC_LD = 1'b0;
                endcase
                end

    5'b00101 : begin
                case(IR_TWO)
                2'b00 : begin // BRCS
                         if (C_FLAG_CONTR == 1'b1) begin
                            PC_LD = 1'b1;
                            PC_MUX_SEL_MCU = 2'b00;
                            end
                         end
                2'b01 : begin     //BRCC
                         if (C_FLAG_CONTR == 1'b0) begin
                            PC_LD = 1'b1;
                            PC_MUX_SEL_MCU = 2'b00;
                            end
                         end 
                 default : PC_LD = 1'b0;
                endcase
                end
                
    5'b01000 : begin
                case(IR_TWO)
                2'b00 : begin /// LSL
                         RF_WR = 1'b1;
                         ALU_SEL = 4'b1001;
                         PC_LD = 1'b0;
                         FLG_C_LD = 1'b1;
                         FLG_Z_LD = 1'b1;
                         RF_WR_SEL = 2'b00;
                         end  
                2'b01 :   begin // LSR
                         RF_WR = 1'b1;
                         ALU_SEL = 4'b1010;
                         PC_LD = 1'b0;
                         FLG_C_LD = 1'b1;
                         FLG_Z_LD = 1'b1; 
                         RF_WR_SEL = 2'b00;
                         end       
                2'b10 :   begin // ROL 
                         RF_WR = 1'b1;
                         RF_WR_SEL = 2'b00;
                         ALU_SEL = 4'b1011;
                         FLG_C_LD = 1'b1;
                         FLG_Z_LD = 1'b1; 
                         PC_LD = 1'b0;
                         end
                2'b11 :  begin // ROR 
                         RF_WR = 1'b1;
                         RF_WR_SEL = 2'b00;
                         ALU_SEL = 4'b1100;
                         FLG_C_LD = 1'b1;
                         FLG_Z_LD = 1'b1; 
                         PC_LD = 1'b0;
                         end
                endcase
                end

    5'b01001 : begin
                case(IR_TWO)
                2'b00 : begin  // ASR
                         RF_WR = 1'b1;
                         ALU_SEL = 4'b1101;
                         FLG_C_LD = 1'b1;
                         FLG_Z_LD = 1'b1;
                         PC_LD = 1'b0;
                         RF_WR_SEL = 2'b00;
                         end
                2'b01 : begin // PUSH
                        SCR_DATA_SEL = 1'b0;
                        SCR_WE = 1'b1;
                        SP_DECR = 1'b1;
                        SCR_ADDR_SEL = 2'b11;
                        end
                2'b10 : begin // POP
                        RF_WR = 1'b1;
                        RF_WR_SEL = 2'b01;
                        SCR_ADDR_SEL = 2'b10;
                        SP_INCR = 1'b1;
                        end   
                default : RF_WR = 1'b1;
                endcase
                end
     5'b01010 : begin // WSP
                SP_LD = 1'b1;
                end           
     5'b01100 : begin
                case(IR_TWO)
                2'b00 : begin // CLC
                        FLG_C_CLR = 1'b1;
                        end
                2'b01 : begin // SEC
                         FLG_C_SET = 1'b1;
                         end
                2'b10 : begin // RET
                        PC_LD = 1'b1;
                        PC_MUX_SEL_MCU = 2'b01;
                        SP_INCR = 1'b1;
                        SCR_ADDR_SEL = 2'b10;
                        end
                default : FLG_C_SET = 1'b0;
                endcase
                end
     5'b01101 : begin
                case(IR_TWO)
                2'b00 : begin // SEI
                        I_SET = 1'b1;                
                        end
                2'b01 : begin // CLI
                        I_CLR = 1'b1;
                        end
                2'b10 : begin // RETID
                        PC_LD = 1'b1;
                        PC_MUX_SEL_MCU = 2'b01;
                        SCR_ADDR_SEL = 2'b10;
                        SP_INCR = 1'b1;
                        I_CLR = 1'b1;
                        FLG_LD_SEL = 1'b1;
                        end
                2'b11 : begin // RETIE 
                        PC_LD = 1'b1;
                        PC_MUX_SEL_MCU = 2'b01;
                        SCR_ADDR_SEL = 2'b10;
                        SP_INCR = 1'b1;
                        I_SET = 1'b1;
                        FLG_LD_SEL = 1'b1;
                        end
                endcase
                end
     5'b10000 : begin //AND REG - immed
                RF_WR = 1'b1;
                ALU_SEL = 4'b0101;
                ALU_OPY_SEL = 1;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                PC_LD = 1'b0;
                RF_WR_SEL = 2'b00;
                end

    5'b10001 : begin // OR REG - immed
                RF_WR = 1'b1;
                ALU_SEL = 4'b0110;
                ALU_OPY_SEL = 1'b1;
                FLG_C_CLR = 1'b1;
                PC_LD = 1'b0;
                RF_WR_SEL = 2'b00;
                FLG_Z_LD = 1'b1;
                end

     5'b10010 : begin    //EXOR reg - immed
                ALU_OPY_SEL = 1'b1;
                ALU_SEL = 4'b0111;
                RF_WR = 1'b1;
                FLG_C_CLR = 1'b1;
                FLG_Z_LD = 1'b1;
                PC_LD = 1'b0;
                RF_WR_SEL = 2'b00;
                end

      5'b10011 : begin // TEST : REG - IMMED
                RF_WR = 1'b0;
                ALU_SEL = 4'b1000;
                ALU_OPY_SEL = 1'b1;
                PC_LD = 1'b0;
                FLG_C_CLR = 1'b1;
                FLG_Z_LD = 1'b0;
                end

    5'b10100 : begin  // ADD REG - immed
                RF_WR = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
                ALU_OPY_SEL = 1'b1;
                ALU_SEL = 4'b0000;
                PC_LD = 1'b0;
                RF_WR_SEL = 2'b00;
                end
    
    5'b10101 : begin // ADDC // REG - immed - C
               RF_WR = 1'b1;
               FLG_C_LD = 1'b1;
               FLG_Z_LD = 1'b1;
               ALU_OPY_SEL = 1'b1;
               ALU_SEL = 4'b0001;
               PC_LD = 1'b0;
               RF_WR_SEL = 2'b00;
               end

    5'B10110 : begin // SUB : REG - immed
               RF_WR = 1'b1;
               RF_WR_SEL = 2'b00;
               ALU_SEL = 4'b0010;
               PC_LD = 1'b0;
               ALU_OPY_SEL = 1'b1;
               FLG_C_LD = 1'b1;
               FLG_Z_LD = 1'b1;
               end

    5'B10111 : begin // SUBC : REG - immed
               RF_WR = 1'b1;
               RF_WR_SEL = 2'b00;
               ALU_SEL = 4'b0011;
               PC_LD = 1'b0;
               ALU_OPY_SEL = 1'b1;
               FLG_C_LD = 1'b1;
               FLG_Z_LD = 1'b1;
               end

    5'B11000 : begin // CMP REG - immed
               PC_LD = 1'b0;
               ALU_SEL = 4'b0100;
               FLG_C_LD = 1'b1;
               FLG_Z_LD = 1'b1;
               ALU_OPY_SEL = 1'b1;
               end   

     5'B11001 : begin       // IN
                RF_WR = 1'b1;
                RF_WR_SEL = 2'b11;
                PC_LD = 1'b0;
                end
 
    5'B11010 : begin        // OUT 
               ALU_SEL = 4'b1111;
               PC_LD = 1'b0;
               IO_STRB = 1'b1;
               end

    5'b11100 : begin //LD -IMMED
               RF_WR = 1'b1;
               RF_WR_SEL = 2'b01;
               SCR_ADDR_SEL = 2'b01;
               end
    5'b11101 : begin // ST - IMMED
               SCR_DATA_SEL = 1'b0;
               SCR_WE = 1'b1;
               SCR_ADDR_SEL = 2'b01;
               end 
    5'B11011 : begin  // MOV : REG - IMMEDIATE
               PC_MUX_SEL_MCU = 2'b00;
               ALU_OPY_SEL = 1'b1;
               ALU_SEL = 4'b1110;
               RF_WR = 1'b1;
               PC_LD = 1'b0;
               end   
    endcase
end

endcase
end
endmodule