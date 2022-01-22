`include "header.vh"



module iTLB(  
    // SYSTEM  
    input clk,
    input reset,

    // INPUT
    input [(`VIRT_ADDR_WIDTH-1):0] VirtualAddr,
    input tlb_write,
    input [(`PHY_PAGE_NUM_WIDTH-1):0] physical_page_num_mem,

    // OUTPUT
    output reg [(`PHY_ADDR_WIDTH-1):0] PhysicalAddr,
    output reg tlb_miss);


    /*
    |31          Virtual pag num       12|11   Pag offset      0|     
    -------------------------------------------------------------
    */

    // As with iCache, we define 4 lines for the TLB
    reg [(`PHY_ADDR_WIDTH-1):0] tlb_tag [(`ITLB_NUM_LINES-1):0];
    reg [(`PHY_PAGE_NUM_WIDTH-1):0] tlb_translation [(`ITLB_NUM_LINES-1):0];
    reg valid_page [(`ITLB_NUM_LINES-1):0];

    wire [(`PHY_ADDR_WIDTH-1):0] page_tag;
    wire [(`PAGE_SIZE-1):0] page_offset;

    assign page_tag = VirtualAddr [(`VIRT_ADDR_WIDTH-1):`PAGE_SIZE];
    assign page_offset = VirtualAddr [(`PAGE_SIZE-1):0];

    integer line;

    initial begin
        $display("start iTLB with 0s");
        for (line=0; line<`ITLB_NUM_LINES; line=line+1) begin
             valid_page[line] = 0;
        end
        valid_page[0] = 1;
        tlb_tag[0] = 20'h00110;
        tlb_translation[0] = 8'hAB;
	end

    always @ (posedge clk) begin
        if (reset) begin
            for (line=0; line<`ITLB_NUM_LINES; line=line+1) begin
                valid_page[line] = 0;
            end
        end
        tlb_miss = 1;
        // If we are not writting to the iTLB
        if (!tlb_write) begin
            // Loop for all iTLB lines
            for (line=0; line < (`ITLB_NUM_LINES); line=line+1) begin
                // Is that line valid?
                if (valid_page [line] == 1'b1) begin
                    // Does the iTLB have the tag we are looking for?
                    if (tlb_tag[line] == page_tag) begin
                        $display("iTLB: Page hit");
                        // Get page translation from iTLB
                        PhysicalAddr = {tlb_translation[line], page_offset};
                        tlb_miss = 0;
                    end
                end
            end
        end
        // If we don't have a Hit, go ask to memory
        if (tlb_miss) begin
            $display("iTLB: Miss. Go to memory");
            if (tlb_write) begin
                line = 0; // Write to line 0 by default. TODO: Think a better strategy.
                tlb_tag[line] = page_tag;
                tlb_translation[line] = physical_page_num_mem;
            end
        end
    end

endmodule