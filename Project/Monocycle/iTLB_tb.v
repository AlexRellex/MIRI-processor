`timescale 1ns/1ns
`include "iTLB.v"

module iTLB_tb;
    // SYSTEM 
    reg clk; 
    reg reset;
    // INPUT
    reg [(`VIRT_ADDR_WIDTH-1):0] VirtualAddr;
    //input supervisor_mode,
    reg tlb_write;
    reg [(`PHY_ADDR_WIDTH-1):0] physical_page_num_mem;

    // OUTPUT
    wire [(`PHY_ADDR_WIDTH-1):0] PhysicalAddr;
    wire tlb_miss;

    // As with iCache, we define 4 lines for the TLB
    reg [(`PHY_ADDR_WIDTH-1):0] page_table [(`ITLB_NUM_LINES-1):0];
    reg [(`PHY_PAGE_NUM_WIDTH-1):0] page_translation [(`ITLB_NUM_LINES-1):0];
    reg valid_page [(`ITLB_NUM_LINES-1):0];
    reg [1:0] countValid [(`ITLB_NUM_LINES-1):0];
    wire [(`PHY_ADDR_WIDTH-1):0] page_tag;
    wire [(`PAGE_SIZE-1):0] page_offset;
    wire tlb_hit;


    iTLB uut(clk, reset, VirtualAddr, tlb_write, physical_page_num_mem, PhysicalAddr, tlb_miss);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;

        $dumpfile("iTLB_tb.vcd");
        $dumpvars(0, iTLB_tb);

        #20;

        $finish();
        $display("Test OK!");
    end
    
endmodule
