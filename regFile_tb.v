`timescale 1ns/1ns
`include "regFile.v"

module regFile_tb;
    reg clk;
    reg wrt;

    reg [(`ADDR_WIDTH-1):0] addrA;
    reg [(`ADDR_WIDTH-1):0] addrB;
    reg [(`ADDR_WIDTH-1):0] addrD;
    reg [(`REG_FILE_WIDTH-1):0] d;

    wire [(`REG_FILE_WIDTH-1):0] data_a;
    wire [(`REG_FILE_WIDTH-1):0] data_b;

    reg [(`REG_FILE_WIDTH-1):0] regFile[(`REG_FILE_NREG-1):0];

	reg [(`ADDR_WIDTH-1):0] addrA_reg;
	reg [(`ADDR_WIDTH-1):0] addrB_reg;
	reg [(`ADDR_WIDTH-1):0] addrD_reg;

    regFile uut(clk, wrt, addrA, addrB, addrD,
    d, data_a, data_b);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        wrt = 0;

        $dumpfile("regFile_tb.vcd");
        $dumpvars(0, regFile_tb);

        // Try some addr
        addrA=5'b0001; #5;
        addrB=5'b1111; #10;
        addrA=5'b0010; #5;
        addrD=5'b0110; #15;

        // Try to write to r0 without wrt enabled
        d=32'h0000_4544;
        addrD=5'b0000;
        addrA=5'b0000; #25;

        // Try to write to r0 with wrt enabled
        wrt = 1;
        d=32'h0000_4541;
        addrD=5'b0000;
        addrA=5'b0000; #25;
        wrt = 0;
        
        // Try to read from addrB
        addrB=5'b0000; #15;

        $finish;

        $display("Test OK!");
    end


endmodule