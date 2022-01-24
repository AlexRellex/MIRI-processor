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
    reg [31:0] memory [127:0]; // 2^20

    main_memory uut(reset, addr, data_to_write, wrt_en, data_to_read);

    wire [(`MEM_DATA_SIZE-1):0] test_memory;

    assign test_memory = memory[0];

    initial begin
    $dumpfile("main_memory_tb.vcd");
    $dumpvars(0, main_memory_tb);

    // Read some addr
    reset = 0;
    wrt_en = 0;
    addr = 32'h0000_0000; #10;
    $display(data_to_read);
    addr = 32'h0000_0005; #10;
    addr = 32'h0000_0009; #10;
    addr = 32'h0000_000F; #10;
    addr = 32'h0000_0FF5; #10;

    $display("Write some addr");
    // Write some addr
    wrt_en = 1;
    data_to_write = 128'h0000_0000_0000_0000_0000_0000_0000_0000;
    addr = 32'h0000_0000; #10;
    // Overwritte address 0
    data_to_write = 128'h0000_0000_0000_0000_0000_FFFF_FFFF_0000; #30;
    wrt_en = 0; #10;
    
    // Read addr 0
    addr = 32'h0000_0000; #30;

    // Flush memory
    reset = 1; #10;
    reset = 0; #20;

    // Read after flush
    addr = 32'h0000_0000; #30;
    addr = 32'h0000_0005; #30;


    // Write after memory reset
    // Overwritte address 0
    wrt_en=1;
    addr = 32'h0000_0000;
    data_to_write = 128'hFFFF_AAAA_CCCC_EEEE_0000_FFFF_FFFF_1234; #30;
    wrt_en = 0; #30;

    // Read after memory reset

    $display("Test OK!");
end

    
endmodule