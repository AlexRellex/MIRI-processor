`timescale 1ns/1ns
`include "fetch_stage.v"

module fetch_stage_tb;
    reg clk;
    reg reset; // flow control variables
    reg [(`VIRT_ADDR_WIDTH-1):0] PCbranch; // ICache line where the PC must jump after a branch hit
    reg branch_hit; // Branch jumps
    reg wrt_en; // Enable signals
    reg [(`ICACHE_LINE_WIDTH-1):0] instr_from_mem; // Instruction from memory when cache misses
    reg mem_data_rdy;
    reg data_filled_ack;
    wire reg [(`VIRT_ADDR_WIDTH-1):0] PCnext, // PC for the next cycle
    wire reg [(`VIRT_ADDR_WIDTH-1):0] instruction; // Instruction from Icache to next stage
    wire reg reqI_mem; // Initiate request to memory
    wire reg [(`ICACHE_TAG_WIDTH-1):0] reqAddrI_mem;

    fetch_stage uut(clk, reset, PCbranch, branch_hit, wrt_en, 
    instr_from_mem, mem_data_rdy, data_filled_ack, 
    PCnext, instruction, reqI_mem, reqAddrI_mem);

always #5 clk = ~clk;

    initial begin
        clk = 0;
        wrt_en = 1;
        reset = 0;

        $dumpfile("fetch_stage.vcd");
        $dumpvars(0, fetch_stage_tb);

        [(`VIRT_ADDR_WIDTH-1):0] PCbranch = 0x1000;
        branch_hit = 0;
        [(`ICACHE_LINE_WIDTH-1):0] instr_from_mem = ;
        mem_data_rdy = 0;
        data_filled_ack = 0;

        $finish;

        $display("Test OK!");
    end

endmodule