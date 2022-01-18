module memory_controller (    
    input clk, reset, 
    input reqI_cache,
    input reqD_cache,
    input reqD_cache_write,
    input [25:0] reqAddrD_mem,
    input [25:0] reqAddrD_write_mem,
    input [25:0] reqAddrI_mem,
    input [127:0] data_from_cache,
    output reg [127:0] data_to_cache,
    output reg read_ready_for_icache,
    output reg read_ready_for_dcache,
    output reg written_data_ack);

    integer count_mem_received;
    integer count_mem_response;
    reg recived_mem_access;
    reg attending_mem_access;
    
    reg arbitror;

    reg [25:0] data_req_to_mem,where_to_write;
    reg [127:0] data_req_by_cache;
    reg write_to_mem;
    reg [127:0] data_to_write;
    ram_memory ram_memory(
        .reset(reset),
        .data_requested(data_req_to_mem),
        .data_returned(data_req_by_cache),
        .data_to_write(data_to_write),
        .write_to_mem(write_to_mem),
        .where_to_write(where_to_write)
    );



    always @ (posedge clk) begin
        
        if (reset == 1'b1) begin
            recived_mem_access = 1'b0;
            attending_mem_access = 1'b0;
            count_mem_received = 0;
            count_mem_response = 0;
        end
        write_to_mem=0;
        written_data_ack=0;
        if (( reqI_cache == 1'b1 || reqD_cache == 1'b1) && recived_mem_access != 1'b1 && attending_mem_access != 1'b1 && read_ready_for_icache == 1'b0 && read_ready_for_dcache == 1'b0 ) begin
            recived_mem_access = 1'b1;

            if (reqD_cache == 1'b1) begin
                arbitror = 1'b0;
            end
            else begin
                arbitror = 1'b1;
            end
            
        end

        //accessing logic counter
        if (count_mem_received == 4) begin
            attending_mem_access = 1'b1;
            count_mem_received = 0;
            if (arbitror == 1'b0) begin
                data_req_to_mem = reqAddrD_mem;
                if (reqD_cache_write == 1'b1) begin
                    data_to_write = data_from_cache;
                    where_to_write = reqAddrD_write_mem;
                    write_to_mem = 1'b1;
                    written_data_ack = 1'b1;
                end
            end
            else begin
                data_req_to_mem = reqAddrI_mem;
            end

            recived_mem_access = 1'b0;
        end

        //response logic counter
        if (count_mem_response == 4) begin
            data_to_cache = data_req_by_cache;
            count_mem_response = 0;
            if (arbitror == 1'b0) begin
                read_ready_for_dcache = 1'b1;
                read_ready_for_icache = 1'b0;
            end
            else begin
                read_ready_for_icache = 1'b1;
                read_ready_for_dcache = 1'b0;
            end

            attending_mem_access = 1'b0;
        end

        else begin
            read_ready_for_dcache = 1'b0;
            read_ready_for_icache = 1'b0;
        end

        //counter
        if (recived_mem_access ==  1'b1) begin
            count_mem_received = count_mem_received + 1; 
        end

        if (attending_mem_access ==  1'b1) begin
            count_mem_response = count_mem_response + 1; 
        end


        
    end

endmodule // insttructionMem