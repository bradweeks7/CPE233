`timescale 1ns / 1ps
module CONTROL_UNIT(
	input C_FLAG_CONTR,
	input Z_FLAG_CONTR,
	//input INT_R,
	input RESET,
	input logic [4:0] IR_FIVE,
	input logic [1:0] IR_TWO,
	input CLK,
	//output logic I_SET,
	//output logic I_CLR,
	output logic PC_LD,
	output logic PC_INC,
	output logic [1:0] PC_MUX_SEL_MCU,
	output logic ALU_OPY_SEL,
	output logic [3:0] ALU_SEL,
	output logic RF_WR,
	output logic [1:0] RF_WR_SEL,
	//output logic SP_LD,
	//output logic SP_INCR,
	//output logic SP_DECR,
	//output logic SCR_WE,
	//output logic [1:0] SCR_ADDR_SEL,
	//output logic SCR_DATA_SEL,
	output logic FLG_C_SET,
	output logic FLG_C_CLR,
	output logic FLG_C_LD,
	output logic FLG_Z_LD,
	//output logic FLG_LD_SEL,
	//output logic FLG_SHAD_LD,
	output logic MCU_RST,
	output logic IO_STRB
	);
	
	
	typedef enum {st_init, st_fetch, st_exec} STATES;
	STATES PS, NS;
	
	always_ff @(posedge CLK) begin
	   if (RESET == 1'b1) 
	       PS <= st_init;
       else
           PS <= NS;
   end
   
   always_comb begin
        case(PS)
            st_init: begin
                MCU_RST = 1'b1;
                NS = st_fetch;
                end
            st_fetch: begin
                PC_INC = 1'b1;
                NS = st_exec;
                end
            st_exec: begin
                       // I_SET <= 1'b0;
	//I_CLR <= 1'b0;
	PC_LD <= 1'b0;
	PC_INC <= 1'b0;
	PC_MUX_SEL_MCU <= 2'b00;
	ALU_OPY_SEL <= 1'b0;
	ALU_SEL <= 4'b0000;
	RF_WR <= 1'b0;
	RF_WR_SEL <= 2'b00;
	//SP_LD <= 1'b0;
	//SP_INCR <= 1'b0;
	//SP_DECR <= 1'b0;
	//SCR_WE <= 1'b0;
	//SCR_ADDR_SEL <= 2'b00;
	//SCR_DATA_SEL <= 1'b0;
	FLG_C_SET <= 1'b0;
	FLG_C_CLR <= 1'b0;
	FLG_C_LD <= 1'b0;
	FLG_Z_LD <= 1'b0;
	//FLG_LD_SEL <= 1'b0;
	//FLG_SHAD_LD <= 1'b0;
	MCU_RST <= 1'b0;
	IO_STRB <= 1'b0;

    NS = st_fetch;                
   
	

	
case({IR_FIVE, IR_TWO})

0 : begin // AND REG - REG
    RF_WR <= 1'b1;
    ALU_SEL <= 4'b0101;
    FLG_C_CLR <= 1'b1;
    FLG_Z_LD <= 1'b1;
    ALU_OPY_SEL <= 1'b0;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end   
1 : begin // OR : REG - REG
    RF_WR <= 1'b1;
    ALU_SEL <= 4'b0110;
    ALU_OPY_SEL <= 1'b0;
    FLG_C_CLR <= 1'b1;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end
2 : begin        // EXOR REG- REG
	ALU_SEL <= 4'b0111;
	RF_WR <= 1'b1;
	RF_WR_SEL <= 2'b00;
	FLG_C_CLR <= 1'b1;
	FLG_Z_LD <= 1'b1;
	PC_LD <= 1'b0;	
    end
3 : begin // TEST : REG - REG
    RF_WR <= 1'b0;
    ALU_SEL <= 4'b1000;
    ALU_OPY_SEL <= 1'b0;
    PC_LD <= 1'b0;
    FLG_C_CLR <= 1'b1;
    FLG_Z_LD <= 1'b0;
    end
4 : begin // ADD : REG - REG
    RF_WR <= 1'b1;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    ALU_OPY_SEL <= 1'b0;
    ALU_SEL <= 4'b0000;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end
5 : begin // ADDC : REG - REG +C
    RF_WR <= 1'b1;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    ALU_OPY_SEL <= 1'b0;
    ALU_SEL <= 4'b0001;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end
6 : begin // SUB : REG - REG
    RF_WR <= 1'b1;
    RF_WR_SEL <= 2'b00;
    ALU_SEL <= 4'b0010;
    PC_LD <= 1'b0;
    ALU_OPY_SEL <= 1'b0;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    end
7 : begin // SUBC : REG - REG
    RF_WR <= 1'b1;
    RF_WR_SEL <= 2'b00;
    ALU_SEL <= 4'b0011;
    PC_LD <= 1'b0;
    ALU_OPY_SEL <= 1'b0;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    end
8 : begin  // CMP : REG - REG
    PC_LD <= 1'b0;
    ALU_SEL <= 4'b0100;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    ALU_OPY_SEL <= 1'b0; 
    end  
9 : begin  //MOV : REG - REG
	ALU_SEL <= 4'b1110;
	RF_WR <= 1'b1;
	RF_WR_SEL <= 2'b00;
	PC_LD <= 1'b0;
end
16 : begin // BRN
    PC_MUX_SEL_MCU <= 2'b00;
	PC_LD <= 1'b1;
end  
18 : begin // BREQ 
     PC_LD <= 1'b1;
     PC_MUX_SEL_MCU <= 2'b00;
     end
19 : begin // BRNE
     PC_LD <= 1'b1;
     PC_MUX_SEL_MCU <= 2'b00;
     end     
20 : begin // BRCS
     PC_LD <= 1'b1;
     PC_MUX_SEL_MCU <= 2'b00;
     end   
21 : begin     //BRCC
     PC_LD <= 1'b1;
     PC_MUX_SEL_MCU <= 2'b00;
     end
32 : begin /// LSL
     RF_WR <= 1'b1;
     ALU_SEL <= 4'b1001;
     PC_LD <= 1'b0;
     FLG_C_LD <= 1'b1;
     FLG_Z_LD <= 1'b1;
     RF_WR_SEL <= 2'b00;
     end   
33 : begin // LSR
     RF_WR <= 1'b1;
     ALU_SEL <= 4'b1010;
     PC_LD <= 1'b0;
     FLG_C_LD <= 1'b1;
     FLG_Z_LD <= 1'b1; 
     RF_WR_SEL <= 2'b00;
     end    
34 : begin // ROL 
     RF_WR <= 1'b1;
     RF_WR_SEL <= 2'b00;
     ALU_SEL <= 4'b1011;
     FLG_C_LD <= 1'b1;
     FLG_Z_LD <= 1'b1; 
     PC_LD <= 1'b0;
     end
35 : begin // ROR 
     RF_WR <= 1'b1;
     RF_WR_SEL <= 2'b00;
     ALU_SEL <= 4'b1100;
     FLG_C_LD <= 1'b1;
     FLG_Z_LD <= 1'b1; 
     PC_LD <= 1'b0;
     end
36 : begin  // ASR
     RF_WR <= 1'b1;
     ALU_SEL <= 4'b1101;
     FLG_C_LD <= 1'b1;
     FLG_Z_LD <= 1'b1;
     PC_LD <= 1'b0;
     RF_WR_SEL <= 2'b00;
     end   
48 : begin // CLC
    FLG_C_CLR <= 1'b1;
    end
49 : begin // SEC
     FLG_C_SET <= 1'b1;
     end
64 : begin //AND REG - immed
    RF_WR <= 1'b1;
    ALU_SEL <= 4'b0101;
    ALU_OPY_SEL <= 1;
    FLG_C_CLR <= 1;
    FLG_Z_LD <= 1;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end
68 : begin // OR REG - immed
      RF_WR <= 1'b1;
      ALU_SEL <= 4'b0110;
      ALU_OPY_SEL <= 1'b1;
      FLG_C_CLR <= 1'b1;
      PC_LD <= 1'b0;
      RF_WR_SEL <= 2'b00;
      end
72 : begin    //EXOR reg <- immed
	ALU_OPY_SEL <= 1'b1;
	ALU_SEL <= 4'b0111;
	RF_WR <= 1'b1;
	FLG_C_CLR <= 1'b1;
	FLG_Z_LD <= 1'b1;
	PC_LD <= 1'b0;
	RF_WR_SEL <= 2'b00;
end
76 : begin // TEST : REG - REG
    RF_WR <= 1'b0;
    ALU_SEL <= 4'b1000;
    ALU_OPY_SEL <= 1'b1;
    PC_LD <= 1'b0;
    FLG_C_CLR <= 1'b1;
    FLG_Z_LD <= 1'b0;
    end
80 : begin  // ADD REG - immed
    RF_WR <= 1'b1;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    ALU_OPY_SEL <= 1'b1;
    ALU_SEL <= 4'b0000;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end
84 : begin // ADDC // REG - immed - C
    RF_WR <= 1'b1;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    ALU_OPY_SEL <= 1'b1;
    ALU_SEL <= 4'b0001;
    PC_LD <= 1'b0;
    RF_WR_SEL <= 2'b00;
    end
88 : begin // SUB : REG - immed
    RF_WR <= 1'b1;
    RF_WR_SEL <= 2'b00;
    ALU_SEL <= 4'b0010;
    PC_LD <= 1'b0;
    ALU_OPY_SEL <= 1'b1;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    end
92 : begin // SUBC : REG - immed
    RF_WR <= 1'b1;
    RF_WR_SEL <= 2'b00;
    ALU_SEL <= 4'b0011;
    PC_LD <= 1'b0;
    ALU_OPY_SEL <= 1'b1;
    FLG_C_LD <= 1'b1;
    FLG_Z_LD <= 1'b1;
    end
96 : begin // CMP REG - immed
     PC_LD <= 1'b0;
     ALU_SEL <= 4'b0100;
     FLG_C_LD <= 1'b1;
     FLG_Z_LD <= 1'b1;
     ALU_OPY_SEL <= 1'b1;
     end   
100 : begin       // IN
	RF_WR <= 1'b1;
	RF_WR_SEL <= 2'b11;
	PC_LD <= 1'b0;
end

104 : begin        // OUT 
	ALU_SEL <= 4'b1111;
	PC_LD <= 1'b0;
	IO_STRB <= 1'b1;
end
108 : begin  // MOV : REG - IMMEDIATE
	PC_MUX_SEL_MCU <= 2'b00;
	ALU_OPY_SEL <= 1'b1;
	ALU_SEL <= 4'b1110;
	RF_WR <= 1'b1;
    PC_LD <= 1'b0;
end
default : begin
    end   
endcase
end
endcase
end
endmodule