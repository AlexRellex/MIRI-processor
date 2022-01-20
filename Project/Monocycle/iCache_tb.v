`timescale 1ns/1ns
`include "iCache.v"

module iCache_tb;
    reg clk;
    reg wrt_en;
    reg reset;

    reg [(`VIRT_ADDR_WIDTH)-1:0] addr;
    wire [31:0] instr;
    wire cache_hit;

    // Internal registers
   	reg [(`ICACHE_LINE_WIDTH-1):0] cache_data [(`ICACHE_NLINES-1):0];   // iCache memory
	reg [(`ICACHE_TAG_WIDTH-7):0] cache_tag [(`ICACHE_NLINES-1):0];     // Tag of each line
	reg [(`ICACHE_NLINES-1):0] cache_val_bit;    // Valid bit for each line
    
    // Wires to connect input-output
    wire [(`ICACHE_TAG_WIDTH-1):0] addr_tag;    // Memory tag
    wire [(`ICACHE_INDEX_WIDTH-1):0] addr_index;    // iCache line (direct mapped)
    wire [(`ICACHE_BYTEINLINE_WIDTH-1):0] addr_byte; // Locate the byte-in-line

    iCache uut(clk, wrt_en, reset, addr, instr, cache_hit);

always #5 clk = ~clk;

    initial begin
        clk = 0;
        wrt_en = 0;
        reset = 0;

        $dumpfile("iCache_tb.vcd");
        $dumpvars(0, iCache_tb);

        // Try some addr
        #15;
        addr = 32'hF000_0000; #20;
        addr = 32'h0000_0050; #20;
        addr = 32'h0000_0051; #20;
        addr = 32'h0000_0052; #20;
    
        addr = 32'h000F_0050; #20;
        addr = 32'hFFFF_FFC0; #20;
        addr = 32'h0000_0053; #20;
        addr = 32'h0000_0043; #20;

        reset=1;
        addr = 32'hF000_0000; #20;
        addr = 32'h0000_0050; #20;
        addr = 32'h0000_0051; #20;
        addr = 32'h0000_0052; #20;

        $finish;

        $display("Test OK!");
    end
    
endmodule