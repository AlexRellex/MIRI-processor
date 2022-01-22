`include "header.vh"

module iCache (
        // SYSTEM
    input clk,
    input reset,
    input wrt_en,

    // Inputs
    input [(`VIRT_ADDR_WIDTH-1):0] addr, // Address to read (from PC)
    input [(`ICACHE_LINE_WIDTH-1):0] data_to_fill, // Data to fill in the cache
    input mem_data_rdy, // Data requested to mem is ready
    input data_filled_ack, // Data written to cache is acked

    // Outputs
    output reg [(`VIRT_ADDR_WIDTH-1):0] instr, // Instruction to send to next stage
    output reg cache_hit // Hit?
    output reg reqI_mem, // Request signal to memory
    output reg [(`ICACHE_TAG_WIDTH-1):0] reqAddrI_mem); // Tag of the requested address


    /*
    |31          TAG            6|5  Idx  4|3 byte-in-line 0|     
    ---------------------------------------------------------
    */

    // Internal registers
   	reg [(`ICACHE_LINE_WIDTH-1):0] cache_data [(`ICACHE_NLINES-1):0];   // iCache memory
	reg [(`ICACHE_TAG_WIDTH-1):0] cache_tag [(`ICACHE_NLINES-1):0];     // Tag of each line
	reg [(`ICACHE_NLINES-1):0] cache_val_bit;    // Valid bit for each line
    reg pending_data; // waiting for data to be filled
    
    // Wires to connect input-output
    wire [(`ICACHE_TAG_WIDTH-1):0] addr_tag;    // Memory tag
    wire [(`ICACHE_INDEX_WIDTH-1):0] addr_index;    // iCache line (direct mapped)
    wire [(`ICACHE_BYTEINLINE_WIDTH-1):0] addr_byte; // Locate the byte-in-line

    // Assign bits from addr (from PC) to tag, line and byteinline
    /*
    integer p_strt, p_end; // pointers
    p_strt = `VIRT_ADDR_WIDTH-1;
    p_end = `VIRT_ADDR_WIDTH - `ICACHE_TAG_WIDTH;
    assign addr_tag = addr[p_strt:p_end];  // 31:6
    p_strt = p_end - 1;
    p_end = p_end - `ICACHE_INDEX_WIDTH;
    assign addr_index = addr[p_strt:p_end]; // 5:4
    p_strt = p_end - 1;
    p_end = p_end - `ICACHE_BYTEINLINE_WIDTH; 
    assign addr_byte = addr[p_strt:p_end];  // 3:0
    */
    assign addr_tag = addr[31:6];
    assign addr_index = addr[5:4];
    assign addr_byte = addr[3:0];

    integer line;
    initial begin
        pending_data = 1'b0;
        // Set each line of the iCache as not valid. No need to ctrl the data inside as it'll be overwritten
        for (line=0; line<`ICACHE_NLINES; line=line+1) begin
            cache_val_bit[line] = 1'b0;            
        end

        cache_data[1] = 128'hAAAAAAAA_BBBBBBBB_CCCCCCCC_DDDDDDDD;
        cache_tag[1] = 'b00_00000000_00000000_00000001;
        cache_val_bit[1] = 1'b1;
        
	end

    always @(negedge clk ) begin // Using posedge for the first part of the stage and negedge for the second

        cache_hit = 0;
        // Flush iCache
        if (reset == 1'b1) begin         
            cache_hit = 1'b0;
            cache_val_bit = 4'b0000; // set all lines to invalid
            instr = 32'b0;
            pending_data = 1'b0;
            reqI_mem = 1'b0;
        end

        line = addr_index;
        // If Icache is waiting for data and data is ready --> fill data into the cache
        if (pending_data && mem_data_rdy == 1'b1) begin           
            cache_data [line] = data_to_fill;
            cache_tag[line] = addr_tag;
            cache_val_bit[line] = 1'b1;
            pending_data = 1'b0;
            reqI_mem = 1'b0;     
        end
        
        // If data has been filled succesfully turn off the request
        if (pending_data == 1'b1 && data_filled_ack == 1'b1) begin
            pending_data = 1'b0;
        end

        // If we are not requesting data to memory
        if (!pending_data && wrt_en) begin
            // Do we have a TAG hit?
            if (addr_tag == cache_tag[line]) begin
                // Is the chache line valid?
                if (cache_val_bit[line] == 1'b1) begin
                    // hit and valid. Read the instruction
                    cache_hit=1'b1;
                    case(addr_byte)
                        0 : instr = cache_data[line][31:0];
                        1 : instr = cache_data[line][63:32];
                        2 : instr = cache_data[line][95:64];
                        3 : instr = cache_data[line][127:96];
                endcase
                end
            end
            
            else begin // Request to memory
                cache_hit = 1'b0;
                pending_data = 1'b1;
                reqAddrI_mem = addr[31:4];
                reqI_mem = 1'b1;
            end
    end
    
endmodule