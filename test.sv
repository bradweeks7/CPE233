module testbench();
logic clk;
logic [9:0] address;
logic [17:0] register;
logic [7:0] PORT_ID;

ProgRom uut(.PROG_CLK(clk), .PROG_ADDR(address), .PROG_IR(register), .PORT_ID(PORT_ID));

initial begin
    clk=1'b0;
end

always 
    #10 clk<=~clk;
    
initial begin
    for(address=1'b0; address<=80; address=address+1)
    #20;
end

endmodule
