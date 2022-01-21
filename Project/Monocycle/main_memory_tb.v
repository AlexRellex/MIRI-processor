`timescale 1ns/1ns
`include "main_memory.v"

module main_memory_tb;
    // Inputs
    reg reset; 
    reg [31:0] addr; // TODO: Use Virtual 
    reg [(`MEM_DATA_WIDTH-1):0] data_to_write;
    reg wrt_en;

    // Outputs
    wire [(`MEM_DATA_WIDTH-1):0] data_to_read;


    // Internal registers
    reg [31:0] memory [(`MEM_DATA_SIZE)-1:0]; // 2^20

    main_memory uut(reset, addr, data_to_write, wrt_en, data_to_read);

    initial begin
    $dumpfile("main_memory_tb.vcd");
    $dumpvars(0, main_memory_tb);

    // Read some addr
    reset = 0;
    wrt_en = 0;
    addr = 32'h0000_0000; #10;
    addr = 32'h0000_0005; #10;
    addr = 32'h0000_0009; #10;
    addr = 32'h0000_000F; #10;
    addr = 32'h0000_0FF5; #10;

    // Write some addr
    wrt_en = 1;
    data_to_write = 128'h0000_0000_0000_0000_0000_0000_0000_0000;
    addr = 32'h0000_0000; #10;
    data_to_write = 128'h0000_0000_0000_0000_0000_FFFF_FFFF_0000; #10;
    wrt_en = 0;

    reset = 1; #20;

    $finish();
    $display("Test OK!");
    
end
    
endmodule