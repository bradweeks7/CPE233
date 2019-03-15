`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/07/2018 06:00:59 PM
// Design Name:
// Module Name: ram2k_8
// Project Name: VGA 40x30
// Target Devices: RAT MCU on Basys3
// Description: Framebuffer memory for VGA driver.
//              3 port memory, 2 for reading, 1 for writing
//              WA1 - first address for reading and writing,
//                    output is RD1, input is WD
//              WE  - write enable, only save data (WD to WA1) when high
//              RA2 - first address only for reading, output is RD2
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module ram2k_8(
    input CLK,
    input WE,           // write enable
    input RST,
    input [10:0] WA1,   // write address 1
    input [10:0] RA2,   // read address 2
    input [7:0] WD,     // write data to address 1
    output [7:0] RD1,   // read data from address 1
    output [7:0] RD2    // read data from address 2
    );
    
    logic [7:0] r_memory [2047:0];
    
    // Initialize all memory to 0s
    initial begin
        int i;
       int j;
        int k;
        int l;
        int m;
        int n;
        int o;
        int p;
        
        for (i=0; i<255; i++) begin         // rows of blue
            r_memory[i] = 8'h03;            
        end
        for (k=255; k<275; k++) begin      //water
            r_memory[i] = 8'h03;
            end
        for (j=275; j<285; j++) begin      //sand
            r_memory[i] = 8'hF9;
            end
        for (l=285; l<319; l++) begin  //water
            r_memory[i] = 8'h03;
            end 
            //sand
            r_memory[319] = 8'hF9;
            r_memory[320] = 8'hF9;
            r_memory[321] = 8'hF9;
        for (m=321; m<337; m++) begin
            r_memory[m] = 8'h03;
            end
        for (n=337; n<349; n++) begin
            r_memory[n] = 8'hF9;
            end
        for (o=349; o<384; o++) begin
            r_memory[0] = 8'h03;    
            end  
        for (p=384; p<2048; p++) begin //sand fill
            r_memory[p] = 8'hF9;
            end
        
        
        for (k=255; k<2048; k++) begin  //sand
                        r_memory[k] = 8'hF9;
                    end
                    
        
        //rock
        r_memory[600] = 8'h4A;
        r_memory[665] = 8'h4A;
        
        //rock
        r_memory[800] = 8'h4A;
        r_memory[865] = 8'h4A;
        r_memory[866] = 8'h4A;
        r_memory[929] = 8'h4A;
        
        //rock
        r_memory[500] = 8'h4A;
        r_memory[564] = 8'h4A;
        r_memory[628] = 8'h4A;
        
        //rock
        r_memory[1200] = 8'h4A;
        
        //rock
        r_memory[1370] = 8'h4A;
        r_memory[1435] = 8'h4A;
        r_memory[1499] = 8'h4A;
        
        
        //rock
        r_memory[730] = 8'h4A;
        r_memory[731] = 8'h4A;
        r_memory[794] = 8'h4A;
        r_memory[795] = 8'h4A;
        
        //rock
        r_memory[448] = 8'h4A;
        r_memory[511] = 8'h4A;
        r_memory[512] = 8'h4A;
        r_memory[513] = 8'h4A;
        r_memory[575] = 8'h4A;
        r_memory[576] = 8'h4A;
        r_memory[577] = 8'h4A;
        r_memory[640] = 8'h4A;
  

        //rock (boulder)
        r_memory[985] = 8'h4A;
        r_memory[986] = 8'h4A;
        r_memory[984] = 8'h4A;
        r_memory[983] = 8'h4A;
        r_memory[920] = 8'h4A;
        r_memory[921] = 8'h4A;
        r_memory[1047] = 8'h4A;
        r_memory[1048] = 8'h4A;
        r_memory[1049] = 8'h4A;
        r_memory[1050] = 8'h4A;
        r_memory[1112] = 8'h4A;
        r_memory[1113] = 8'h4A;


        r_memory[1419] = 8'h10;
        r_memory[1420] = 8'h10;
        r_memory[1421] = 8'h10;
        r_memory[1480] = 8'h10;
        r_memory[1481] = 8'h10;
        r_memory[1484] = 8'h10;
        r_memory[1545] = 8'h10;
        r_memory[1546] = 8'h10;
        r_memory[1547] = 8'h10;
        r_memory[1610] = 8'h10;
        r_memory[1611] = 8'h10;
        r_memory[1613] = 8'h10;
        r_memory[1672] = 8'h10;
        r_memory[1673] = 8'h10;
        r_memory[1675] = 8'h10;
        r_memory[1676] = 8'h10;
        r_memory[1677] = 8'h10;
        r_memory[1736] = 8'h10;
        r_memory[1740] = 8'h10;
        
        
        
        //palm tree
        r_memory[978] = 8'h08;
        r_memory[979] = 8'h08;
        r_memory[981] = 8'h08;
        r_memory[982] = 8'h08;
        r_memory[983] = 8'h08;
        r_memory[1042] = 8'h08;
        r_memory[1043] = 8'h08;
        r_memory[1044] = 8'h08;
        r_memory[1045] = 8'h08;
        r_memory[1047] = 8'h08;
        r_memory[1108] = 8'h08;
        r_memory[1109] = 8'h08;
        r_memory[1171] = 8'h08;
        r_memory[1172] = 8'h08;
        r_memory[1173] = 8'h08;
        r_memory[1174] = 8'h08;
        r_memory[1175] = 8'h08;
        r_memory[1234] = 8'h08;
        r_memory[1238] = 8'h08;
        
            
        
        
        end
    
    // only save data on rising edge
    always_ff @(posedge CLK) begin
        if (RST == 1'b1) begin
            int i;
               int j;
                int k;
                int l;
                int m;
                int n;
                int o;
                int p;
                
                for (i=0; i<255; i++) begin         // rows of blue
                    r_memory[i] = 8'h03;            
                end
                for (k=255; k<275; k++) begin      //water
                    r_memory[i] = 8'h03;
                    end
                for (j=275; j<285; j++) begin      //sand
                    r_memory[i] = 8'hF9;
                    end
                for (l=285; l<319; l++) begin  //water
                    r_memory[i] = 8'h03;
                    end 
                    //sand
                    r_memory[319] = 8'hF9;
                    r_memory[320] = 8'hF9;
                    r_memory[321] = 8'hF9;
                for (m=321; m<337; m++) begin
                    r_memory[m] = 8'h03;
                    end
                for (n=337; n<349; n++) begin
                    r_memory[n] = 8'hF9;
                    end
                for (o=349; o<384; o++) begin
                    r_memory[0] = 8'h03;    
                    end  
                for (p=384; p<2048; p++) begin //sand fill
                    r_memory[p] = 8'hF9;
                    end
                
                
                for (k=255; k<2048; k++) begin  //sand
                                r_memory[k] = 8'hF9;
                            end
                            
                
                //rock
                r_memory[600] = 8'h4A;
                r_memory[665] = 8'h4A;
                
                //rock
                r_memory[800] = 8'h4A;
                r_memory[865] = 8'h4A;
                r_memory[866] = 8'h4A;
                r_memory[929] = 8'h4A;
                
                //rock
                r_memory[500] = 8'h4A;
                r_memory[564] = 8'h4A;
                r_memory[628] = 8'h4A;
                
                //rock
                r_memory[1200] = 8'h4A;
                
                //rock
                r_memory[1370] = 8'h4A;
                r_memory[1435] = 8'h4A;
                r_memory[1499] = 8'h4A;
                
                
                //rock
                r_memory[730] = 8'h4A;
                r_memory[731] = 8'h4A;
                r_memory[794] = 8'h4A;
                r_memory[795] = 8'h4A;
                
                //rock
                r_memory[448] = 8'h4A;
                r_memory[511] = 8'h4A;
                r_memory[512] = 8'h4A;
                r_memory[513] = 8'h4A;
                r_memory[575] = 8'h4A;
                r_memory[576] = 8'h4A;
                r_memory[577] = 8'h4A;
                r_memory[640] = 8'h4A;
          
        
        
                r_memory[1429] = 8'h10;
                r_memory[1430] = 8'h10;
                r_memory[1431] = 8'h10;
                r_memory[1490] = 8'h10;
                r_memory[1491] = 8'h10;
                r_memory[1494] = 8'h10;
                r_memory[1555] = 8'h10;
                r_memory[1556] = 8'h10;
                r_memory[1557] = 8'h10;
                r_memory[1620] = 8'h10;
                r_memory[1621] = 8'h10;
                r_memory[1623] = 8'h10;
                r_memory[1682] = 8'h10;
                r_memory[1683] = 8'h10;
                r_memory[1685] = 8'h10;
                r_memory[1686] = 8'h10;
                r_memory[1687] = 8'h10;
                r_memory[1746] = 8'h10;
                r_memory[1750] = 8'h10;
                
                
                
                //palm tree
                r_memory[978] = 8'h08;
                r_memory[979] = 8'h08;
                r_memory[981] = 8'h08;
                r_memory[982] = 8'h08;
                r_memory[983] = 8'h08;
                r_memory[1042] = 8'h08;
                r_memory[1043] = 8'h08;
                r_memory[1044] = 8'h08;
                r_memory[1045] = 8'h08;
                r_memory[1047] = 8'h08;
                r_memory[1108] = 8'h08;
                r_memory[1109] = 8'h08;
                r_memory[1171] = 8'h08;
                r_memory[1172] = 8'h08;
                r_memory[1173] = 8'h08;
                r_memory[1174] = 8'h08;
                r_memory[1175] = 8'h08;
                r_memory[1234] = 8'h08;
                r_memory[1238] = 8'h08;
                
                    
                
        end
        else if (WE == 1'b1) begin
            r_memory[WA1] = WD;
            end
    end
    
    assign RD2 = r_memory[RA2];
    assign RD1 = r_memory[WA1];
    
endmodule
