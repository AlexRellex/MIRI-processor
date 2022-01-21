`include "header.vh"



module iTLB(  
    // SYSTEM  
    input reset, clk,

    // INPUT
    input [(`VIRT_ADDR_WIDTH-1):0] VirtualAddr,
    //input supervisor_mode,
    input tlb_write,
    input [(`PHY_ADDR_WIDTH-1):0] physical_page_num_mem,

    // OUTPUT
    output [(`PHY_ADDR_WIDTH-1):0] PhysicalAddr,
    output tlb_miss);


    /*
    |31          Virtual pag num       12|11   Pag offset      0|     
    -------------------------------------------------------------
    */

    // As with iCache, we define 4 lines for the TLB
    reg [(`PHY_ADDR_WIDTH-1):0] page_table [(`ITLB_NUM_LINES-1):0];
    reg [(`PHY_PAGE_NUM_WIDTH-1):0] page_translation [(`ITLB_NUM_LINES-1):0];
    reg valid_page [(`ITLB_NUM_LINES-1):0];
    reg [1:0] countValid [(`ITLB_NUM_LINES-1):0];
    wire [(`PHY_ADDR_WIDTH-1):0] page_tag;
    wire [(`PAGE_SIZE-1):0] page_offset;
    wire tlb_hit;


    always @ (posedge clk) begin
        
        page_tag = VirtualAddr [(`VIRT_ADDR_WIDTH-1):`PAGE_SIZE];
        page_offset =  VirtualAddr [(`PAGE_SIZE-1):0];
        if reset begin
            for (i=0; i <=1048575; i++ ) begin
                page_table[i] = 20'b0;
                tlb_miss = 0;
            end
        end        
        // Loop for all iTLB lines
        for (line=0; line < `ITLB_NUM_LINES; line++) begin
            // Does the iTLB have the tag we are looking for?
            if (page_tag [line*20+19:line*20] == page_tag) begin
                $display("iTLB: Page tag hit")
                // Is that line valid?
                if (instValid [line] == 1'b1) begin
                    $display("iTLB: Valid line")
                    PhysicalAddr[(`PHY_ADDR_WIDTH-1):`PAGE_SIZE] = page_traduction [line]; 
                    PhysicalAddr[(`PAGE_SIZE-1):0] = page_offset;
                    tlb_hit=1;
                end
            end
        end

        tlb_miss = ! tlb_hit;

        // Recieve translation from memory
        else if (tlb_write == 1'b1) begin
            // If all lines in the iTLB are valid, the first entry is taken by default (TODO: think a better strategy)
            integer line_to_overwrite = 0; //default
            // If we want to writo to the iTLB, try to take a line that it is not valid
            for (line=0; line < 4; line++) begin
                if (valid_page [line] == 1'b0) begin
                    line_to_overwrite = line;
                end
            end
            
            // Keep tag for future translations
            page_translation [line_to_overwrite*8+7:line_to_overwrite*8] = page_tag;
            // Physical translation recieved from main memory
            page_table [line_to_overwrite*20+19:line_to_overwrite*20] = physical_page_num_mem;
            // This entry is now valid
            instValid [line_to_overwrite] = 1'b1;
        end
    end

endmodule // insttructionMem