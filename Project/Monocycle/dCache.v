`include "header.vh"

module dCache (
    // SYSTEM
    input clk,
    input reset,
    input wrt_en,

    // Inputs
    input [(`VIRT_ADDR_WIDTH-1):0] addr, // Address to read (from PC)
    input [(`ICACHE_LINE_WIDTH-1):0] data_to_fill, // Data to fill in the cache
    input mem_data_rdy, // Data requested to mem is ready

    // Outputs
    output reg [(`VIRT_ADDR_WIDTH-1):0] data, // Data to send to next stage
    output reg cache_hit, // Hit?
    output reg req_dCache_mem, // Request signal to memory
    output reg [(`MEM_ADDRESS_LEN-1):0] req_dCache_mem_addr,  // Tag of the requested address
    output reg evicted_data);


    /*
    |31          TAG            6|5  Idx  4|3 byte-in-line 0|
    ---------------------------------------------------------
    */

    // Internal registers
   	reg [(`DCACHE_LINE_WIDTH-1):0] cache_data [(`DCACHE_NLINES-1):0];   // iCache memory
	reg [(`DCACHE_TAG_WIDTH-1):0] cache_tag [(`DCACHE_NLINES-1):0];     // Tag of each line
	reg [(`DCACHE_NLINES-1):0] cache_valid_line;                        // Valid bit for each line
    reg [(`DCACHE_NLINES-1):0] dirty_line;                              // Dirty flag for each line
    reg waiting_data;                                                   // Flag to wait data form memory


    wire [(`DCACHE_TAG_WIDTH-1):0] addr_tag;         // Memory tag
    wire [(`DCACHE_INDEX_WIDTH-1):0] addr_index;     // iCache line (direct mapped)
    wire [(`DCACHE_BYTEINLINE_WIDTH-1):0] addr_byte; // Locate the byte-in-line

    assign addr_tag = addr[(`VIRT_ADDR_WIDTH-1):(`VIRT_ADDR_WIDTH - `DCACHE_TAG_WIDTH)];
    assign addr_index = addr[3:2];
    assign addr_byte = addr[1:0];

    integer line;
    initial begin
        waiting_data = 1'b0;
        req_dCache_mem = 1'b0;
        req_dCache_mem_addr = `MEM_ADDRESS_LEN'h0;
        evicted_data=0;
        // Set each line of the iCache as not valid. No need to ctrl the data inside as it'll be overwritten
        for (line=0; line<`DCACHE_NLINES; line=line+1) begin
            cache_valid_line[line] = 1'b0;            
        end

        // Some initial values
        cache_data[1] = 128'hAAAAAAAA_BBBBBBBB_CCCCCCCC_DDDDDDDD;
        cache_tag[1] = 26'b00_00000000_00000000_00000001;
        cache_valid_line[1] = 1'b1;
	end

    always @(negedge clk ) begin

        cache_hit = 0;
        // Flush dCache
        if (reset == 1'b1) begin         
            cache_hit = 1'b0;
            cache_valid_line = 4'b0000; // set all lines to invalid
            data = 32'b0;
            waiting_data = 1'b0;
            req_dCache_mem = 1'b0;
        end

        line = addr_index;
        // If dCache is waiting for data
        if (waiting_data) begin        
            $display("Waiting data,");
            // Fill dCache with data from Memory
            line = $urandom%10;
            if (dirty_line[line]) begin
                $display("line dirty. Send to memory");
                data = cache_data[line];
                evicted_data = 1;
                //TODO: STALL F, D and A
                if (mem_data_rdy && wrt_en) begin
                    $display("Data from memory ready");         
                    cache_data [line] = data_to_fill;
                    cache_tag[line] = addr_tag;
                    cache_valid_line[line] = 1'b1;
                    waiting_data = 1'b0;
                    req_dCache_mem = 1'b0;     
                end
        end

        // If we are not requesting data to memory
        if (!waiting_data) begin
            $display("Not waiting data, wrt_en");
            // Do we have a TAG hit?
            if (addr_tag == cache_tag[line]) begin
                // Is the chache line valid?
                if (cache_valid_line[line] == 1'b1) begin
                    // hit and valid. Read the data
                    cache_hit=1'b1;
                    $display("dCache hit");
                    case(addr_byte)
                        0 : data = cache_data[line][31:0];
                        1 : data = cache_data[line][63:32];
                        2 : data = cache_data[line][95:64];
                        3 : data = cache_data[line][127:96];
                endcase
                end
            end
            else begin // Request to memory
                $display("dCache miss. Request to memory");
                cache_hit = 1'b0;
                waiting_data = 1'b1;
                req_dCache_mem_addr = addr;
                req_dCache_mem = 1'b1;
            end
        end
    end
    
endmodule