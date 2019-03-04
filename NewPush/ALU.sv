`timescale 1ns / 1ps
module ALU(
	input logic[3:0] SEL,
	input logic [7:0] A,
	input logic [7:0] B,
	input logic CIN,
	output logic [7:0] RESULT,
	output logic C,
	output logic Z
	);
	
var bit tempC;	
logic [8:0] temp;
	
always_comb begin
case(SEL)
0 : temp = {1'b0, A} + {1'b0, B};                 	//add
1 : temp = {1'b0, A} + {1'b0, B} + {1'b0, CIN};   	//addc
2 : temp = {1'b0, A} - {1'b0, B};                 	//sub
3 : temp = {1'b0, A} - {1'b0, B} - {1'b0, CIN};   	//subc
4 : temp =  {1'b0, A} - {1'b0, B};                  	//cmp
5 : temp = {1'b0, A} & {1'b0, B};                   //and
6 : temp = {1'b0, A} | {1'b0, B};                   //or                                          
7 : temp = {1'b0, A} ^ {1'b0, B};                   //exor
8 : temp = {1'b0, A} & {1'b0, B};                   // test
9 : temp = {A,CIN};                                 //lsl	
10 : temp = {A[0],CIN,A[7:1]};                      //lsr
11 : temp = {A[7],A[6:0],CIN};                      //rol	
12 : temp = {A[0],CIN, A[7:1]};                     //ror
13 : temp = {A[0],A[7],A[7:1]};                     //asr 
14 : temp = {1'b0,B};                              //mov                                               
15 : temp = {1'b0,A};
endcase

{C, RESULT} = temp;

if (RESULT == 8'h00) begin
    Z = 1'b1;
end
else begin
    Z = 1'b0; 
end
end

endmodule


