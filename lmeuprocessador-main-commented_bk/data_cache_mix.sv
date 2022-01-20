module data_cache_mix (    
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
    output reg [31:0] reqAddrD_mem,
    output reg reqD_cache_write,
    output reg [127:0] data_to_mem);

    reg [127:0] dataCache [0:3];
    reg [17:0] dataTag [0:3];
    reg dataValid [0:3];
    reg dataDirty [0:3];
    reg [1:0] countValid [0:3];

    wire [6:0] addr_byte;
    wire [1:0] addr_index;
    wire [22:0] addr_tag;
    reg req_valid;
    reg pending_req;
    reg ready_next;
    wire [31:0] next_instruction;
    reg cache_hit;
    reg [1:0] lastcountValid;
    integer row_cache;

    assign addr_byte = address[6:0];
    assign    addr_index = address[8:7];
        
    assign    addr_tag = address[31:9];

    always @ (posedge clk) begin
    
         
        if (reset == 1'b1 || flush == 1'b1) begin
            for (int k = 0; k < 4; k++) begin         
                countValid [k] = 0;
                cache_hit = 1'b0;
                req_valid = 1'b1;
                pending_req = 1'b0;
                dataDirty[k] = 0;
                dataValid[k] = 0;
                reqD_mem = 1'b0;
                reqD_cache_write = 1'b0;
            end
        end

        if (!pending_req && req_valid && mem_read) begin
            for (int i=0; i < 4; i++) begin
                if (dataTag [i] == addr_tag) begin
                    if (dataValid [i] == 1'b1) begin
                        readdata = dataCache [addr_index][addr_byte];
                        cache_hit=1'b1;
                        
                        lastcountValid = countValid [i];

                        for (int k = 0; k < 4; k++) begin
                            if (i != k && countValid[k] < lastcountValid[k]) begin
                                countValid [k] = countValid [k] + 1;
                            end
                        end

                        countValid [i] = 0;

                    end
                end
            end

            if (cache_hit == 1'b0) begin
                pending_req = 1'b1;
                reqAddrD_mem = address;
                reqD_mem = 1'b1;
                ready_next = 1'b0;
            end
        end

        else if (!pending_req && req_valid && mem_write) begin
            for (int i=0; i < 4; i++) begin
                if (dataTag [i] == addr_tag) begin
                    if (dataValid [i] == 1'b1) begin
                        dataCache [addr_index][addr_byte] = writedata;
                        cache_hit=1'b1;
                        dataDirty[i]=1;
                        lastcountValid = countValid [i];

                        for (int k = 0; k < 4; k++) begin
                            if (i != k && countValid[k] < lastcountValid[k]) begin
                                countValid [k] = countValid [k] + 1;
                            end
                        end

                        countValid [i] = 0;

                    end
                end
            end

            if (cache_hit == 1'b0) begin
                pending_req = 1'b1;
                reqAddrD_mem = address[31:7];
                reqD_mem = 1'b1;
                ready_next = 1'b0;
                reqD_cache_write = 1'b0;
            end
        end

        row_cache = -1; //undefined

        if (pending_req && read_ready_from_mem == 1'b1) begin
            
            for (int i=0; i < 4; i++) begin
                if (dataValid [i] == 1'b0) begin
                    row_cache = i;
                end
            end
            if (row_cache == -1) begin
                for (int i=0; i < 4; i++) begin
                    if (countValid [i] == 2'b11) begin
                        row_cache = i;
                        countValid [i] = 2'b00;
                    end
                    else begin
                        countValid [i] = countValid [i] + 1;
                    end
                end
            end
            
            if (dataDirty[row_cache] == 0) begin
                dataCache [row_cache] = data_from_mem;
                dataTag [row_cache] = addr_tag;
                pending_req = 1'b0;
                dataValid [row_cache] = 1'b1;
                ready_next = 1'b1;
                readdata = dataCache [addr_index][addr_byte];
                reqD_mem = 1'b0;
            end

            else begin
                //escriure a meme
                pending_req = 1'b1;
                data_to_mem = dataCache [row_cache];
                reqAddrD_mem = dataTag[row_cache];
                reqD_mem = 1'b1;
                ready_next = 1'b0;
                reqD_cache_write = 1'b1;
            end     
        end

        if (pending_req == 1'b1 && written_data_ack == 1'b1) begin
            pending_req = 1'b0;
        end

    end

endmodule // insttructionMem