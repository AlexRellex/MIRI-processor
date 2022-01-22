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
    reg [(`PHY_PAGE_NUM_WIDTH-1):0] physical_page_num_mem;

    // OUTPUT
    wire [(`PHY_ADDR_WIDTH-1):0] PhysicalAddr;
    wire tlb_miss;

    // As with iCache, we define 4 lines for the TLB
    reg [(`PHY_ADDR_WIDTH-1):0] tlb_tag [(`ITLB_NUM_LINES-1):0];
    reg [(`PHY_PAGE_NUM_WIDTH-1):0] tlb_translation [(`ITLB_NUM_LINES-1):0];
    reg valid_page [(`ITLB_NUM_LINES-1):0];

    wire [(`PHY_ADDR_WIDTH-1):0] page_tag;
    wire [(`PAGE_SIZE-1):0] page_offset;

    iTLB uut(clk, reset, VirtualAddr, tlb_write, physical_page_num_mem, PhysicalAddr, tlb_miss);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        tlb_write = 0;

        $dumpfile("iTLB_tb.vcd");
        $dumpvars(0, iTLB_tb);
        
        VirtualAddr=32'h00FF_0101; #20;
        
        VirtualAddr=32'h0011_0101; #20;

        VirtualAddr=32'h0021_0101;
        physical_page_num_mem=8'h11; #20;

        tlb_write = 1; #20;
        tlb_write=0; #40;

        reset = 1; #20;

        $finish();
        $display("Test OK!");
    end
    
endmodule
