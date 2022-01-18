module iTLB(    
    input reset, clk, flush,
    input [31:0] VirtualAddress,
    input supervisor_mode,
    input tlb_write,
    input [19:0] reg_logic_page,
    input [7:0] reg_physical_page,
    output [19:0] PhysicalAddress,
    output tlb_miss);

    reg [19:0] page_table [3:0];
    reg [7:0] page_traduction [3:0];
    reg valid_page [3:0];
    reg [1:0] countValid [3:0];
    wire [19:0] page_tag;
    wire [11:0] page_offset;
    wire tlb_hit;
    integer tlb_line; 
    wire [1:0] lastcountValid;

    always @ (posedge clk) begin
        
        page_tag = VirtualAddress [31:12];
        page_offset =  VirtualAddress [11:0];
        tlb_line = page_tag
        if (reset || flush) begin
            for (i=0; i <=1048575; i++ ) begin
                page_table[i] = 20'b0;
                tlb_miss = 0;
            end
        end
        row_cache = -1; //undefined
        else if ( supervisor_mode == 1'b0 ) begin
            
            for (i=0; i < 4; i++) begin
                if (page_tag [i*20+19:i*20] == page_tag) begin
                    if (instValid [i] == 1'b1) begin
                        PhysicalAddress[19:12] = page_traduction [i]; 
                        PhysicalAddress[11:0] = page_offset
                        tlb_hit=1'b1;
                        
                        lastcountValid = countValid [i*2];

                        for (k = 0; k < 4; k++) begin
                            if (i != k && countValid[k*2+1:k*2] < lastcountValid[k*2+1:k*2]) begin
                                countValid [k*2+1:k*2] = countValid [k*2+1:k*2] + 2'b01;
                            end
                        end

                        countValid [i*2+1:i*2] == 2'b00;

                    end
                end
            end

            tlb_miss = ! tlb_hit;

        else if (tlb_write == 1'b1) begin

            for (i=0; i < 4; i++) begin
                if (valid_page [i] == 1'b0) begin
                    row_cache = i;
                end

            if (row_cache == -1) begin
                for (i=0; i < 4; i++) begin
                    if (countValid [i*2+1:i*2] == 2'b11) begin
                        row_cache = i;
                        countValid [i*2+1:i*2] = 2'b00;
                    end
                    else begin
                        countValid [i*2+1:i*2] = countValid [i*2+1:i*2] + 2'b01;
                    end
                end
            end

            page_table [row_cache*20+19:row_cache*20] = reg_logic_page;
            page_traduction [row_cache*8+7:row_cache*8] = reg_physical_page;
            instValid [row_cache] = 1'b1;

        end
        

            /*if (valid_page[tlb_line] == 1'b1) begin
                PhysicalAddress = page_table [tlb_line];
                tlb_miss = 0;
            end
            else begin
                tlb_miss = 1'b1;
            end*/


        
        end
    end

endmodule // insttructionMem