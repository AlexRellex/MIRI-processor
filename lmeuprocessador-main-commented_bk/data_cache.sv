module data_cache (    
    input clk, reset,flush, 
    input mem_read,
    input mem_write, 
    input [31:0] address, 
    input [31:0] writedata, 
    output reg [31:0] readdata,
    input [127:0] data_from_mem,
    input read_ready_from_mem,
    input written_data_ack,
    output reg reqD_mem,
    output reg reqD_stop,
    output reg [25:0] reqAddrD_mem,
    output reg reqD_cache_write,
    output reg [127:0] data_to_mem,
    output reg [25:0] reqAddrD_write_mem);

    reg [127:0] dataCache [0:3];
    reg [25:0] dataTag [0:3];
    reg dataValid [0:3];
    reg dataDirty [0:3];

    wire [3:0] addr_byte;
    wire [1:0] addr_index;
    wire [25:0] addr_tag;
    reg req_valid;
    reg pending_req;
    reg ready_next;
    wire [31:0] next_instruction;
    reg [31:0] readdata_intern;
    reg cache_hit;

    assign addr_byte = address[3:0];
    assign    addr_index = address[5:4];
        
    assign    addr_tag = address[31:6];
    int row;


    wire [31:0] data_read_store_buffer;
    wire [63:0] data_to_write_from_SB;
    wire hit_storeBuffer,storeBuffer_full,exists_address_in_SB;
    wire sending_data_to_cache,cache_ready_to_catch;

    int addr_byte_SB;
    int rowSB;
    assign addr_byte_SB = data_to_write_from_SB[35:32];
    assign rowSB = data_to_write_from_SB[37:36];
    
    reg cache_ready_to_catch_SB;
    assign cache_ready_to_catch = (!mem_read & !mem_write) | cache_ready_to_catch_SB;

    store_buffer store_buffer(
        .clk(clk),
        .reset(reset),
        .flush(flush),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .writedata(writedata),
        .cache_ready_to_catch(cache_ready_to_catch),
        .data_read(data_read_store_buffer),
        .hit_storeBuffer(hit_storeBuffer),
        .data_to_cache(data_to_write_from_SB),
        .sending_data_to_cache(sending_data_to_cache),
        .storeBuffer_full(storeBuffer_full),
        .exists_address(exists_address_in_SB),
        .cache_hit(cache_hit)

    );

    

    mux2Data dataread_StoreBuffer(
        .select(hit_storeBuffer),
        .a(readdata_intern),
        .b(data_read_store_buffer),
        .y(readdata)
    );

    int flushing_SB;
    always @ (negedge clk) begin
    
         
        if (reset == 1'b1 || flush == 1'b1) begin

            cache_hit = 1'b0;
            req_valid = 1'b1;
            pending_req = 1'b0;
            reqD_mem = 1'b0;
            reqD_cache_write = 1'b0;
            reqAddrD_write_mem =26'b0;
            reqD_stop = 1'b0;
            flushing_SB = 0;
            for (int k = 0; k < 4; k++) begin         
                
                dataDirty[k] = 0;
                dataValid[k] = 0;
                
            end
        end

        /*case ({addr_index})

            2'b00: begin
                row = 0;
            end

            2'b01: begin
                row = 1;
            end

            2'b10: begin
                row = 2;
            end

            2'b11: begin
                row = 3;
            end
            
        endcase*/

        row = addr_index;
        cache_hit=1'b0;
        

        if (sending_data_to_cache == 1'b1 && flushing_SB == 1) begin
        
            dataCache [rowSB][addr_byte_SB*8 +: 31] = data_to_write_from_SB[31:0];

            //$display("%b",{dataCache [rowSB][addr_byte_SB + 3],dataCache [rowSB][addr_byte_SB + 2], dataCache [rowSB][addr_byte_SB + 1], dataCache [rowSB][addr_byte_SB] });
            cache_hit=1'b1;
            dataDirty[rowSB]=1;
            
        end

        if (storeBuffer_full == 1'b1 || sending_data_to_cache == 1'b1) begin
            cache_ready_to_catch_SB = 1'b1;
            ready_next = 1'b0;
            flushing_SB= 1;
            reqD_stop = 1'b1;
        end
        
        else begin
            cache_ready_to_catch_SB = 0'b0;
            ready_next = 1'b1;
            reqD_stop = 1'b0;
            flushing_SB= 0;
        end

        if (pending_req && flushing_SB == 0 && read_ready_from_mem == 1'b1) begin
                        
            if (dataDirty[row] == 0) begin
                dataCache [row] = data_from_mem;
                dataTag [row] = addr_tag;
                pending_req = 1'b0;
                dataValid [row] = 1'b1;
                ready_next = 1'b1;
                reqD_mem = 1'b0;
            end

                
        end
        
        if (pending_req == 1'b1 && written_data_ack == 1'b1 && flushing_SB == 0) begin
            pending_req = 1'b0;
        end

        if (!pending_req && req_valid && mem_read && flushing_SB == 0) begin
            if (dataTag [row] == addr_tag) begin
                if (dataValid [row] == 1'b1) begin
                    readdata_intern = {dataCache[row][addr_byte*8 +: 31]};
                    cache_hit=1'b1;
                end
            end

            else begin
                cache_hit = 1'b0;
            end

            if (cache_hit == 1'b0) begin
                if (dataDirty[row] == 1'b0) begin
                    pending_req = 1'b1;
                    reqAddrD_mem = address[31:2];
                    reqD_mem = 1'b1;
                    ready_next = 1'b0;
                end

                else begin
                    //escriure a meme
                    pending_req = 1'b1;
                    data_to_mem = dataCache [row];
                    reqAddrD_mem = address[31:2];
                    reqD_mem = 1'b1;
                    ready_next = 1'b0;
                    reqD_cache_write = 1'b1;
                    dataDirty[row] = 1'b0;
                end 
            end
        end

        else if (!pending_req && req_valid && mem_write && flushing_SB == 0) begin
            if (dataTag [row] == addr_tag) begin
                if (dataValid [row] == 1'b1) begin
                    

                    //{dataCache [row][addr_byte + 3],dataCache [row][addr_byte + 2], dataCache [addr_index][addr_byte + 1], dataCache [addr_index][addr_byte] } = writedata;
                    cache_hit=1'b1;
                    dataDirty[row]=1;
                end
            end
            else begin
                cache_hit = 1'b0;
            end

            if (cache_hit == 1'b0) begin
                if (dataDirty[row] == 1'b0) begin
                    pending_req = 1'b1;
                    reqAddrD_mem = address[31:2];
                    reqD_mem = 1'b1;
                    ready_next = 1'b0;
                    reqD_cache_write = 1'b0;
                end
                else begin
                    //escriure a meme
                    pending_req = 1'b1;
                    data_to_mem = dataCache [row];
                    reqAddrD_write_mem = {dataTag[row],row,4'b0000};
                    reqAddrD_mem = address[31:2];
                    reqD_mem = 1'b1;
                    ready_next = 1'b0;
                    reqD_cache_write = 1'b1;
                    dataDirty[row] = 1'b0;
                end 
            end
        end


    end

endmodule // insttructionMem