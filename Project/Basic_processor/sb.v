module store_buffer (    
    input clk, reset,flush, 
    input is_load,
    input is_store, 
    input [31:0] address, 
    input [31:0] writedata,
    input cache_ready_to_catch,
    input cache_hit,
    output reg [31:0] data_read,
    output reg hit_storeBuffer,
    output reg [63:0] data_to_cache,
    output reg sending_data_to_cache,
    output reg storeBuffer_full,
    output exists_address);



    reg [63:0] storeBuffer [0:3];
    reg storeBuffer_valid [0:3];

    wire pos_0,pos_1,pos_2,pos_3;

    assign pos_0 = storeBuffer[0][63:32] & address & storeBuffer_valid[0];
    assign pos_1 = storeBuffer[1][63:32] & address & storeBuffer_valid[1];
    assign pos_2 = storeBuffer[2][63:32] & address & storeBuffer_valid[2];
    assign pos_3 = storeBuffer[3][63:32] & address & storeBuffer_valid[3];

    assign exists_address = pos_0 | pos_1 | pos_2 | pos_3;
    integer valid, k;

    initial begin
        for (k = 0; k < 4; k=k+1) begin         
            storeBuffer[k] = 64'b0;
            storeBuffer_valid[k] = 1'b0;
        end
        sending_data_to_cache = 0;
        hit_storeBuffer = 0;
        storeBuffer_full = 1'b0;            
    end

    always @ (posedge clk) begin

        if (reset || flush) begin
            for (k = 0; k < 4; k=k+1) begin         
                storeBuffer[k] = 64'b0;
                storeBuffer_valid[k] = 1'b0;
            end
            sending_data_to_cache = 0;
            hit_storeBuffer = 0;
            storeBuffer_full = 1'b0;
            
        end

        sending_data_to_cache = 0;
        hit_storeBuffer = 0;
    
        if (is_load && !cache_ready_to_catch) begin
            hit_storeBuffer = 1'b0;
            valid = 1;
            for (k = 0; k < 4 && valid == 1; k=k+1) begin
                if (storeBuffer_valid[k] && storeBuffer[k][63:32] == address) begin
                    data_read = storeBuffer[k][31:0];
                    hit_storeBuffer = 1'b1;
                    valid = 0;
                end
            end
        end

        if (is_store && !cache_ready_to_catch) begin
            hit_storeBuffer = 1'b0;
            valid = 1;
            for (k = 0; k < 4 && valid == 1; k=k+1) begin
                if (storeBuffer_valid[k] && storeBuffer[k][63:32] == address) begin
                    storeBuffer[k][31:0] = writedata;
                    hit_storeBuffer = 1'b1;
                    valid = 0;
                end
                if (!storeBuffer_valid[k] && cache_hit) begin
                    storeBuffer[k][31:0] = writedata;
                    storeBuffer[k][63:32] = address;
                    hit_storeBuffer = 1'b0;
                    storeBuffer_valid[k] = 1'b1;
                    valid = 0;
                end
            end
        end

        if (cache_ready_to_catch) begin
            if (storeBuffer_valid[0]) begin
                sending_data_to_cache= 1'b1;
                data_to_cache = storeBuffer[0];
                storeBuffer_valid[0] = 1'b0;
                valid = 1;
                for (k = 1; k < 4 && valid == 1; k=k+1) begin
                    if (storeBuffer_valid[k]) begin
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

        if (storeBuffer_valid[3]) begin
            storeBuffer_full = 1'b1;
        end

        else begin
            storeBuffer_full = 1'b0;
        end

    end


endmodule