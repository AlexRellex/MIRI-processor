`timescale 1ns/1ns
`include "store_buffer.v"

module store_buffer_tb;
    // SYSTEM
    reg clk;
    reg reset;

    // INPUT
    reg is_store;
    reg is_load;
    reg [(`SB_ADDR_WIDTH-1):0] in_addr;
    reg [(`SB_DATA_WIDTH-1):0] in_data;
    reg cache_hit;

    // OUTPUT
    wire [(`SB_DATA_WIDTH-1):0] out_data;
    wire SB_hit;
    wire [(`SB_WIDTH-1):0] data_to_cache;
    wire sending_data_to_cache;
    wire SB_full;
    wire SB_empty;
    wire addr_hit;

    reg [(`SB_WIDTH-1):0] SB [(`SB_NLINES-1):0];
    reg SB_valid [(`SB_NLINES-1):0];

    store_buffer uut(clk, reset, is_store, is_load, in_addr, in_data, cache_hit, out_data, SB_hit, data_to_cache,
    sending_data_to_cache, SB_full, SB_empty ,addr_hit);


    always #5 clk = ~clk;

    initial begin                
        clk = 0;
        reset = 0;
        is_store = 0;
        in_addr = 32'h0000_0000;
        in_data = 32'h0000_0000;
        cache_hit = 0;
        is_load = 0; 
        is_store = 0;

        $dumpfile("store_buffer_tb.vcd");
        $dumpvars(0, store_buffer_tb);

        #10;

        // Store case, miss
        is_load = 0; 
        is_store = 1;
        in_addr = 32'h0000_00AA;
        in_data = 32'h0000_DDDD; #20;
        
        // Store case, hit
        in_addr = 32'h0000_00BB;
        in_data = 32'h0000_FFFF; #20;

        reset = 1; #20;

        // Store case after reset
        in_addr = 32'h0000_00BB;
        in_data = 32'h0000_FFFF; #20;
        #30;
        
        $display("Test OK!");
        $finish();
    end
endmodule