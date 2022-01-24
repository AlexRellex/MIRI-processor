`timescale 1ns/1ns
`include "sb.v"

module store_buffer_tb;   
    reg clk, reset,flush;
    reg is_load;
    reg is_store; 
    reg [31:0] address;
    reg [31:0] writedata;
    reg cache_ready_to_catch;
    reg cache_hit;
    wire [31:0] data_read;
    wire hit_storeBuffer;
    wire [63:0] data_to_cache;
    wire sending_data_to_cache;
    wire storeBuffer_full;
    wire exists_address;


    reg [63:0] storeBuffer [0:3];
    reg storeBuffer_valid [0:3];

    wire pos_0, pos_1,pos_2,pos_3;

    assign pos_0 = storeBuffer[0][63:32] & address & storeBuffer_valid[0];
    assign pos_1 = storeBuffer[1][63:32] & address & storeBuffer_valid[1];
    assign pos_2 = storeBuffer[2][63:32] & address & storeBuffer_valid[2];
    assign pos_3 = storeBuffer[3][63:32] & address & storeBuffer_valid[3];

    assign exists_address = pos_0 | pos_1 | pos_2 | pos_3;
    integer valid;

store_buffer uut(clk, reset, flush, is_load, is_store, address, writedata, cache_ready_to_catch, cache_hit,
  data_read, hit_storeBuffer, data_to_cache,sending_data_to_cache,storeBuffer_full,exists_address);

always #5 clk = ~clk;

initial begin
    $dumpfile("sb_tb.vcd");
    $dumpvars(0, store_buffer_tb);
    
    clk=0;
    reset=1;
    #10;
    reset=0;
    flush=0;
    is_load=0;
    is_store=0;
    address=0;
    writedata=0;
    cache_ready_to_catch=0;
    cache_hit=0;
    #10;

    // STR1
    is_store=1;
    is_load=0;
    cache_hit=1;
    cache_ready_to_catch=0;
    address=32'h0001_0001;
    writedata=32'h0001_0AA0;
    #10;

    // STR2
    is_store=1;
    is_load=0;
    cache_hit=1;
    cache_ready_to_catch=0;
    address=32'h0001_0331;
    writedata=32'h0001_0BB0;
    #10;

    // STR3
    is_store=1;
    is_load=0;
    cache_hit=1;
    cache_ready_to_catch=0;
    address=32'h0001_00F1;
    writedata=32'h0001_0AA0;
    #10;

    // STR4
    is_store=1;
    is_load=0;
    cache_hit=1;
    cache_ready_to_catch=0;
    address=32'h0AA1_0001;
    writedata=32'h0001_0AA0;
    #10;

    // STR5
    is_store=1;
    is_load=0;
    cache_hit=0;
    cache_ready_to_catch=0;
    address=32'h0001_0FFF;
    writedata=32'h0001_0BB0;
    #10;

    is_store=0;
    is_load=1;
    cache_hit=0;
    cache_ready_to_catch=0;
    address=32'h0001_0331;
    writedata=32'h0001_0BB0;
    #10;

    is_store=0;
    is_load=1;
    cache_hit=0;
    cache_ready_to_catch=0;
    address=32'h0001_0001;
    writedata=32'h0001_0BB0;
    #10;


    cache_ready_to_catch=1;
    is_store=0;
    is_load=0;
    #30;


    $display("TEST OK");
    $finish();
end

endmodule