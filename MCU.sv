`timescale 1ns / 1ps

module MCU(     //Universal Clock
                input CLK, 

                //MCU Vars
                 input logic RESET_MCU,
                 input logic [7:0]IN_PORT_MCU, 
                // input logic INT_R,
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
                 //wire FLAG_LD_SEL_Wire;
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
                 wire [9:0]PC_Count_Wire;
                

CONTROL_UNIT CU(.C_FLAG_CONTR(C_Flag_Wire), .Z_FLAG_CONTR(Z_Flag_Wire), .RESET(RESET_MCU), .IR_FIVE(IR_Wire[17:13]), .IR_TWO(IR_Wire[1:0]), .CLK(CLK),  .PC_LD(PC_LD_Wire), .PC_INC(PC_INC_Wire), .PC_MUX_SEL_MCU(PC_SEL_Wire), .ALU_OPY_SEL(ALU_OPY_SEL_Wire), .ALU_SEL(ALU_SEL_Wire), .RF_WR(RF_WR_Wire), .RF_WR_SEL(RF_WR_SEL_Wire), .FLG_C_SET(FLAG_C_SET_Wire), .FLG_C_CLR(FLAG_C_CLR_Wire), .FLG_C_LD(FLAG_C_LD_Wire), .FLG_Z_LD(FLAG_Z_LD_Wire), .MCU_RST(RST_Wire), .IO_STRB(IO_STRB_MCU));

REG_MUX MR(.IN_PORT(IN_PORT_MCU), .SCR_DATA_OUT(8'b00000000), .SP_OUT_B(8'b00000000), .ALU_RESULT(ALU_RESULT_Wire), .RF_WR_SEL_MUX(RF_WR_SEL_Wire), .DIN_REG(MUX_OUT_REG_IN_Wire));

REG_FILE   RF(.CLK(CLK), .DIN_REG_FILE(MUX_OUT_REG_IN_Wire), .WR(RF_WR_Wire), .IR_IN(IR_Wire[12:8]), .DX_OUT(DX_OUT_Wire), .DY_OUT(DY_OUT_Wire), .OUT_PORT(OUT_PORT_MCU));

ProgROM    PR(.PROG_CLK(CLK), .PROG_ADDR(PC_Count_Wire), .PROG_IR(IR_Wire), .PORT_ID(PORT_ID_MCU));

ALU_MUX AM(.IR_INPUT(IR_Wire[7:0]), .DY_INPUT(DY_OUT_Wire), .ALU_MUX_SEL(ALU_OPY_SEL_Wire), .B_INPUT(ALU_MUX_B_IN));

ALU        AL(.CIN(C_Flag_Wire), .SEL(ALU_SEL_Wire), .A(DX_OUT_Wire), .B(ALU_MUX_B_IN), .RESULT(ALU_RESULT_Wire), .C(C_Wire), .Z(Z_Wire));

Flags      FL(.CLK(CLK), .C_SET_FLG(FLAG_C_SET_Wire), .C_CLR_FLG(FLAG_C_CLR_Wire), .C_LD_FLG(FLAG_C_LD_Wire), .Z_LD_FLG(FLAG_Z_LD_Wire), .C_FLG(C_Flag_Wire), .Z_FLG(Z_Flag_Wire), .C_ALU(C_Wire), .Z_ALU(Z_Wire));

PC_MUX PM(.FROM_IR(IR_Wire[12:3]), .FROM_STACK(8'b00000000), .PC_MUX_SEL(PC_SEL_Wire), .DIN_MUX(PC_MUX_Wire));

PC PC(.PC_RST(RST_Wire), .LD(PC_LD_Wire), .INC(PC_INC_Wire), .DIN(PC_MUX_Wire), .CLK(CLK), .PC_COUNT(PC_Count_Wire)); 





endmodule
