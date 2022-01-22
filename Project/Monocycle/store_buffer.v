`include "header.vh"

module store_buffer (
    // SYSTEM
    input clk, reset, 

    // INPUT
    input is_store,
    input is_load, 
    input [(`ADDR_WIDTH-1):0] in_addr, 
    input [(`DATA_WIDTH-1):0] in_data,
    input cache_hit,

    // OUTPUT
    output reg [(`DATA_WIDTH-1):0] out_data,
    output reg SB_hit,
    output reg [(`SB_WIDTH-1):0] data_to_cache,
    output reg sending_data_to_cache,
    output reg SB_full,
    output reg addr_hit);
    


    reg [(`SB_WIDTH-1):0] SB [(`SB_NLINES-1):0];
    reg SB_valid [(`SB_NLINES-1):0];

    
    // TB stuff
    // Assign a wire to each of the lines of the SB. 
    wire SB_addr_0, SB_addr_1, SB_addr_2, SB_addr_3; 

    // Add the input addr only if the line is valid.
    assign SB_addr_0 = SB[0][63:32] & in_addr & SB_valid[0];
    assign SB_addr_1 = SB[1][63:32] & in_addr & SB_valid[1];
    assign SB_addr_2 = SB[2][63:32] & in_addr & SB_valid[2];
    assign SB_addr_3 = SB[3][63:32] & in_addr & SB_valid[3];

    // If the input addr is found in at least one line, it exists in the SB
    assign exists_address = SB_addr_0 | SB_addr_1 | SB_addr_2 | SB_addr_3;
    

    integer line;
    reg [(`ADDR_WIDTH-1):0] SB_addr;
    integer addr_found;

    initial begin
        SB_full = 0;
        SB_hit = 0;
        addr_hit = 0;
        for (line=0; line < `SB_NLINES; line=line+1) begin
            SB_valid[line] = 0;
        end

        // TB stuff
        SB[2][63:32] = 32'h0000_00BB;
        SB[2][31:0] = 32'h0000_1234;
        SB_valid[2] = 1;
    end

    always @ (posedge clk) begin
        addr_found = 0;
        if (reset) begin
            for (line=0; line < `SB_NLINES; line=line+1) begin
                SB_valid[line] = 0;
            end
            SB_full = 0;
            SB_hit = 0;
            sending_data_to_cache = 0;
        end

        // Neither a load or a store
        if (!is_store && !is_load) begin
            $display("SB: Neither a load or a store. PASS");
        end

        // Control for Stores
        else if (is_store) begin
            for (line=0; line < `SB_NLINES; line=line+1) begin
                // Is the line of the SB valid?
                if (SB_valid[line]) begin
                    SB_addr = SB[line][(`SB_WIDTH-1):`ADDR_WIDTH];
                    $display("line:", line, "  SB:", SB_addr);
                    if (SB_addr == in_addr) begin
                        $display("hit addr in store");
                        addr_found = 1;
                        SB[line][(`SB_WIDTH-1):0] = {in_addr, in_data};
                    end
                end
            end
            if (!addr_found) begin
                // Store and not found in SB: Do nothing --> go to memory
                $display("Store to memory");
            end
        end
        // Control for Loads
        else if (is_load) begin
             for (line=0; line < `SB_NLINES; line=line+1) begin
                // Is the line of the SB valid?
                if (SB_valid[line]) begin
                    SB_addr = SB[line][(`SB_WIDTH-1):`ADDR_WIDTH];
                    $display("line:", line, "  SB:", SB_addr);
                    if (SB_addr == in_addr && cache_hit) begin
                        $display("hit addr and cache in load");
                        addr_found = 1;
                        out_data = SB[line][(`DATA_WIDTH-1):0];
                    end
                    else begin
                        if (cache_hit) begin
                            // Use data from cache
                            $display("SB: SB miss and Cache hit: Use data from Cache");
                        end
                        else if (!cache_hit) begin
                            // Use data form Memory
                            $display("SB: SB and Cache miss: Use data from main Memory");
                        end
                    end
                end
            end
        end

    end


endmodule