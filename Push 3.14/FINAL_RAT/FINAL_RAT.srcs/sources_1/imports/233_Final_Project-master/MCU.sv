`timescale 1ns / 1ps

module MCU(     //Universal Clock
                input CLK, 

                //MCU Vars
                 input logic RESET_MCU,
                 input logic [7:0]IN_PORT_MCU, 
                 input logic INT_R,
                 output logic [7:0] OUT_PORT_MCU, 
                 output logic [7:0] PORT_ID_MCU, 
                 output logic IO_STRB_MCU
                 );
                
                 wire C_Flag_Wire;
                 wire Z_Flag_Wire;
                 wire PC_LD_Wire;
                 wire PC_INC_Wire; 
                 wire [1:0]PC_SEL_Wire;
                 wire ALU_OPY_SEL_Wire; 
                 wire [3:0]ALU_SEL_Wire;  
                 wire RF_WR_Wire; 
                 wire [1:0]RF_WR_SEL_Wire;
                 wire FLAG_C_SET_Wire;
                 wire FLAG_C_CLR_Wire;
                 wire FLAG_C_LD_Wire;
                 wire FLAG_Z_LD_Wire;
                 wire FLAG_LD_SEL_Wire;
                 wire RST_Wire;
                 wire [17:0]IR_Wire;
                 wire [7:0]ALU_RESULT_Wire;
                 wire [7:0]MUX_OUT_REG_IN_Wire;
                 wire [7:0]DX_OUT_Wire;
                 wire [7:0]DY_OUT_Wire;
                 wire [7:0]ALU_MUX_B_IN;
                 wire C_Wire;
                 wire Z_Wire;
                 wire [9:0]PC_MUX_Wire;
                 wire [9:0]PC_COUNT_Wire;
                 wire IO_STRB_Wire;
                 wire SP_LD_Wire;
                 wire SP_INCR_Wire;
                 wire SP_DECR_Wire;
                 wire [7:0]SP_OUT_Wire;
                 wire [1:0] SCR_ADDR_SEL_Wire;
                 wire [7:0] SCR_ADDR_IN_Wire;
                 wire [7:0] SCR_MUX_OUT_Wire;
                 wire SCR_DATA_SEL_Wire;
                 wire [9:0] SCR_DATA_IN_Wire;
                 wire [9:0] SCR_DATA_OUT_Wire;
                 wire SCR_WE_Wire;
                 wire FLAG_SHAD_LD_Wire;
                 wire INTR_Wire;
                 wire I_SET_Wire;
                 wire I_CLR_Wire;
                

INTERRUPT IR(.CLK(CLK), .I_S(I_SET_Wire), .I_C(I_CLR_Wire), .INTR(INT_R), .OUT_I(INTR_Wire));

CONTROL_UNIT CU(.INT_R_MCU(INTR_Wire), .I_SET(I_SET_Wire), .I_CLR(I_CLR_Wire), .FLG_LD_SEL(FLAG_LD_SEL_Wire), .FLG_SHAD_LD(FLAG_SHAD_LD_Wire), .C_FLAG_CONTR(C_Flag_Wire), .Z_FLAG_CONTR(Z_Flag_Wire), .RESET(RESET_MCU), .IR_FIVE(IR_Wire[17:13]), .IR_TWO(IR_Wire[1:0]), .CLK(CLK),  .PC_LD(PC_LD_Wire), .PC_INC(PC_INC_Wire), .PC_MUX_SEL_MCU(PC_SEL_Wire), .ALU_OPY_SEL(ALU_OPY_SEL_Wire), .ALU_SEL(ALU_SEL_Wire), .RF_WR(RF_WR_Wire), .RF_WR_SEL(RF_WR_SEL_Wire), .FLG_C_SET(FLAG_C_SET_Wire), .FLG_C_CLR(FLAG_C_CLR_Wire), .FLG_C_LD(FLAG_C_LD_Wire), .FLG_Z_LD(FLAG_Z_LD_Wire), .MCU_RST(RST_Wire), .IO_STRB(IO_STRB_Wire), .SP_LD(SP_LD_Wire), .SP_INCR(SP_INCR_Wire), .SP_DECR(SP_DECR_Wire), .SCR_ADDR_SEL(SCR_ADDR_SEL_Wire), .SCR_DATA_SEL(SCR_DATA_SEL_Wire), .SCR_WE(SCR_WE_Wire));

REG_MUX RM(.IN_PORT(IN_PORT_MCU), .SCR_DATA_OUT(SCR_DATA_OUT_Wire[7:0]), .SP_OUT_B(SP_OUT_Wire), .ALU_RESULT(ALU_RESULT_Wire), .RF_WR_SEL_MUX(RF_WR_SEL_Wire), .DIN_REG(MUX_OUT_REG_IN_Wire));

REG_FILE   RF(.CLK(CLK), .DIN_REG_FILE(MUX_OUT_REG_IN_Wire), .WR(RF_WR_Wire), .ADRX(IR_Wire[12:8]), .ADRY(IR_Wire[7:3]), .DX_OUT(DX_OUT_Wire), .DY_OUT(DY_OUT_Wire));

ProgROM    PR(.PROG_CLK(CLK), .PROG_ADDR(PC_COUNT_Wire), .PROG_IR(IR_Wire));

ALU_MUX AM(.IR_INPUT(IR_Wire[7:0]), .DY_INPUT(DY_OUT_Wire), .ALU_MUX_SEL(ALU_OPY_SEL_Wire), .B_INPUT(ALU_MUX_B_IN));

ALU     AL(.CIN(C_Flag_Wire), .SEL(ALU_SEL_Wire), .A(DX_OUT_Wire), .B(ALU_MUX_B_IN), .RESULT(ALU_RESULT_Wire), .C(C_Wire), .Z(Z_Wire));

SHADOW_FLAGS SF(.FLG_LD_SEL(FLAG_LD_SEL_Wire), .FLG_SHAD_LD(FLAG_SHAD_LD_Wire), .CLK(CLK), .C_SET_FLG(FLAG_C_SET_Wire), .C_CLR_FLG(FLAG_C_CLR_Wire), .C_LD_FLG(FLAG_C_LD_Wire), .Z_LD_FLG(FLAG_Z_LD_Wire), .C_FLG(C_Flag_Wire), .Z_FLG(Z_Flag_Wire), .C_ALU(C_Wire), .Z_ALU(Z_Wire));

PC_MUX PM(.FROM_IR(IR_Wire[12:3]), .FROM_STACK(SCR_DATA_OUT_Wire), .PC_MUX_SEL(PC_SEL_Wire), .DIN_MUX(PC_MUX_Wire));

PC PC(.PC_RST(RST_Wire), .LD(PC_LD_Wire), .INC(PC_INC_Wire), .DIN(PC_MUX_Wire), .CLK(CLK), .PC_COUNT(PC_COUNT_Wire)); 

SP SP(.CLK(CLK), .SP_LD(SP_LD_Wire), .SP_INCR(SP_INCR_Wire), .SP_DECR(SP_DECR_Wire), .SP_DATA_IN(DX_OUT_Wire), .SP_RST(RST_Wire), .SP_OUT(SP_OUT_Wire));

SP_MUX SPM(.SP_OUT(SP_OUT_Wire), .DX_OUT(DY_OUT_Wire), .IR(IR_Wire[7:0]), .SCR_ADDR_SEL(SCR_ADDR_SEL_Wire), .SCR_ADDR(SCR_ADDR_IN_Wire)); 

SCR_MUX SCRM(.SCR_DATA_SEL(SCR_DATA_SEL_Wire), .DX_OUT(DX_OUT_Wire), .PC_COUNT(PC_COUNT_Wire), .SCR_DATA_IN(SCR_DATA_IN_Wire));

SCRATCH_RAM SCR(.SCR_DIN(SCR_DATA_IN_Wire), .SCR_ADDR(SCR_ADDR_IN_Wire), .SCR_WE(SCR_WE_Wire), .CLK(CLK), .SCR_DATA_OUT(SCR_DATA_OUT_Wire));  

assign PORT_ID_MCU = IR_Wire[7:0];
assign OUT_PORT_MCU = DX_OUT_Wire;
assign IO_STRB_MCU = IO_STRB_Wire;

endmodule
