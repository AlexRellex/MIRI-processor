`timescale 1ns/1ns
`include "dCache.v"

module dCache_tb;
    reg clk;
    reg wrt_en;
    reg reset;

    reg [(`VIRT_ADDR_WIDTH)-1:0] addr;
    reg [(`DCACHE_LINE_WIDTH-1):0] data_to_fill;
    reg mem_data_rdy;

    wire [31:0] data;
    wire cache_hit;
    wire req_dCache_mem;
    wire [(`MEM_ADDRESS_LEN-1):0] req_dCache_mem_addr;

    // Internal registers
   	reg [(`DCACHE_LINE_WIDTH-1):0] cache_data [(`DCACHE_NLINES-1):0];   // iCache memory
	reg [(`DCACHE_TAG_WIDTH-1):0] cache_tag [(`DCACHE_NLINES-1):0];     // Tag of each line
	reg [(`DCACHE_NLINES-1):0] cache_val_bit;    // Valid bit for each line
    
    // Wires to connect input-output
    wire [(`DCACHE_TAG_WIDTH-1):0] addr_tag;    // Memory tag
    wire [(`DCACHE_INDEX_WIDTH-1):0] addr_index;    // iCache line (direct mapped)
    wire [(`DCACHE_BYTEINLINE_WIDTH-1):0] addr_byte; // Locate the byte-in-line

    dCache uut(clk, reset, wrt_en, addr, data_to_fill, mem_data_rdy, data, cache_hit, req_dCache_mem, req_dCache_mem_addr);

always #5 clk = ~clk;

    initial begin
        clk = 0;
        wrt_en = 0;
        reset = 0;
        data_to_fill = 128'h0011_0101_0011_0101_0011_0101_0011_0101;
        mem_data_rdy = 0;

        $dumpfile("dCache_tb.vcd");
        $dumpvars(0, dCache_tb);

        // Try some addr
        addr = 32'b00000000_00000000_00000000_00010101; #20;
        addr = 32'b00000000_00000000_00000000_00000000; #20;
        addr = 32'b00000000_00000000_00000000_00000001; #20;
        mem_data_rdy=1;
        wrt_en=1;
        addr = 32'b00000000_00000000_00000000_00000011; #20;
        mem_data_rdy=0;
        wrt_en=0;
        addr = 32'b00000000_00000000_00000000_00001010; #20;
        

        reset=1;
        addr = 32'hF000_0000; #20;
        addr = 32'h0000_0050; #20;
        addr = 32'h0000_0051; #20;
        addr = 32'h0000_0052; #20;

        $display("Test OK!");
        $finish();
    end
    
endmodule