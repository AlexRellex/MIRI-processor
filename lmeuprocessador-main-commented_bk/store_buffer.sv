module store_buffer (    
    input clk, reset,flush, 
    input mem_read,
    input mem_write, 
    input [31:0] address, 
    input [31:0] writedata,
    input cache_ready_to_catch,
    output reg [31:0] data_read,
    output reg hit_storeBuffer,
    output reg [63:0] data_to_cache,
    output reg sending_data_to_cache,
    output reg storeBuffer_full,
    output reg exists_address,
    input cache_hit);


    reg [63:0] storeBuffer [0:3];
    reg storeBuffer_valid [0:3];

    wire pos_0, pos_1,pos_2,pos_3;

    assign pos_0 = storeBuffer[0][63:32] & address & storeBuffer_valid[0];
    assign pos_1 = storeBuffer[1][63:32] & address & storeBuffer_valid[1];
    assign pos_2 = storeBuffer[2][63:32] & address & storeBuffer_valid[2];
    assign pos_3 = storeBuffer[3][63:32] & address & storeBuffer_valid[3];

    assign exists_address = pos_0 | pos_1 | pos_2 | pos_3;
    int valid;

    always @ (posedge clk) begin

        if (reset == 1'b1 || flush == 1'b1) begin
            for (int k = 0; k < 4; k++) begin         
                storeBuffer[k] = 64'b0;
                storeBuffer_valid[k] = 1'b0;
            end
            sending_data_to_cache = 0;
            hit_storeBuffer = 0;
            storeBuffer_full = 1'b0;
            
        end
        
        if (mem_read == 1'b1 && cache_ready_to_catch == 1'b0) begin
            hit_storeBuffer = 1'b0;
            valid = 1;
            for (int k = 0; k < 4 && valid == 1; k++) begin
                if (storeBuffer_valid[k] == 1'b1 && storeBuffer[k][63:32] == address) begin
                    data_read = storeBuffer[k][31:0];
                    hit_storeBuffer = 1'b1;
                    valid = 0;
                end
            end
        end

        if (mem_write == 1'b1 && cache_ready_to_catch == 1'b0) begin
            hit_storeBuffer = 1'b0;
            valid = 1;
            for (int k = 0; k < 4 && valid == 1; k++) begin
                if (storeBuffer_valid[k] == 1'b1 && storeBuffer[k][63:32] == address) begin
                    storeBuffer[k][31:0] = writedata;
                    hit_storeBuffer = 1'b1;
                    valid = 0;
                end
                if (storeBuffer_valid[k] == 1'b0 && cache_hit == 1'b1) begin
                    storeBuffer[k][31:0] = writedata;
                    storeBuffer[k][63:32] = address;
                    hit_storeBuffer = 1'b0;
                    storeBuffer_valid[k] = 1'b1;
                    valid = 0;
                end
            end
        end

        if (cache_ready_to_catch == 1'b1) begin
            if (storeBuffer_valid[0] == 1'b1) begin
                    
                sending_data_to_cache= 1'b1;
                data_to_cache = storeBuffer[0];
                storeBuffer_valid[0] = 1'b0;
                valid = 1;
                for (int k = 1; k < 4 && valid == 1; k++) begin
                    if (storeBuffer_valid[k] == 1'b1) begin
                        storeBuffer[k-1] = storeBuffer[k];
                        storeBuffer_valid[k-1] = 1'b1;
                        storeBuffer_valid[k] = 1'b0;
                    end
                    else begin
                        valid = 0;
                    end
                end
            end
            else begin
                sending_data_to_cache= 1'b0;
            end
        end

        if (storeBuffer_valid[3] == 1'b1) begin
            storeBuffer_full = 1'b1;
        end

        else begin
            storeBuffer_full = 1'b0;
        end

    end


endmodule