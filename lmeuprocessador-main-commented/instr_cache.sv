module instr_cache (    
    input clk, reset, flush,  // flow control variables
    input mem_read, // Enable signal
    input [31:0] address, // Address to read that comes from PC
    input [127:0] data_from_mem, // Data to fill in the cache
    input read_ready_from_mem, // Data requested to mem is ready
    input written_data_ack, // 
    output reg [31:0] readdata, // Instruction to send to next stage
    output reg reqI_mem, 
    output reg [25:0] reqAddrI_mem,
    output reg cache_hit);

    reg [127:0] dataCache [0:3]; // 4 data cache lines
    reg [25:0] dataTag [0:3]; // 4 tag cache lines --> direct mapped
    reg dataValid [0:3]; // valid bit for each line

    wire [3:0] addr_byte;
    wire [1:0] addr_index;
    wire [25:0] addr_tag;
    reg req_valid;
    reg pending_req;
    reg ready_next;
    wire [31:0] next_instruction;

    assign addr_byte = address[3:0];
    assign addr_index = address[5:4];
        
    assign addr_tag = address[31:6];
    integer row;
    always @ (negedge clk) begin
    
        
        if (reset == 1'b1 || flush == 1'b1) begin
            for (int k = 0; k < 4; k++) begin         
                cache_hit = 1'b0;
                req_valid = 1'b1;
                pending_req = 1'b0;
                dataValid[k] = 0;
                reqI_mem = 1'b0;
                readdata = 32'b0;
            end
        end

        row = addr_index;
        cache_hit=1'b0;
        if (pending_req && read_ready_from_mem == 1'b1) begin
                        
            
            dataCache [row] = data_from_mem;
            dataTag [row] = addr_tag;
            pending_req = 1'b0;
            dataValid [row] = 1'b1;
            ready_next = 1'b1;
            reqI_mem = 1'b0;
            

                
        end
        
        if (pending_req == 1'b1 && written_data_ack == 1'b1) begin
            pending_req = 1'b0;
        end

        if (!pending_req && req_valid && mem_read) begin
            if (dataTag [row] == addr_tag) begin
                if (dataValid [row] == 1'b1) begin
                    readdata = {dataCache [row][addr_byte*8 +: 31]};
                    cache_hit=1'b1;
                end
            end

            else begin
                cache_hit = 1'b0;
            end

            if (cache_hit == 1'b0) begin
        
                pending_req = 1'b1;
                reqAddrI_mem = address[31:4];
                reqI_mem = 1'b1;
                ready_next = 1'b0;

            end
        end

    end

endmodule