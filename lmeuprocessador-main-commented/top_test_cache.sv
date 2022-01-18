module top_test_cache(
    input clk, reset, flush
);


    wire mem_read,mem_write;
    wire [31:0] address,writedata;
    wire [25:0] reqAddrD_mem,reqAddrD_write_mem;
    wire reqD_mem,reqD_stop,read_ready_for_dcache,written_data_ack;
    wire reqD_cache_write;
    wire [127:0] data_to_cache,data_to_mem;
    wire reqI_mem, read_ready_for_icache;
    wire [25:0] reqAddrI_mem;
    reg [31:0] readdata;
    wire bloqued_pipe;

    assign bloqued_pipe = reqD_mem | reqD_stop;


    data_cache_generator_store_buffer data_cache_generator(
        .clk(clk), 
        .reset(reset),
        .flush(flush),
        .requested_data_to_mem(bloqued_pipe),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .writedata(writedata)
    );

    data_cache data_cache(
        .clk(clk), 
        .reset(reset),
        .flush(flush), 
        .mem_read(mem_read),
        .mem_write(mem_write), 
        .address(address), 
        .writedata(writedata), 
        .readdata(readdata),
        .data_from_mem ( data_to_cache),
        .read_ready_from_mem (read_ready_for_dcache),
        .written_data_ack( written_data_ack),
        .reqD_mem (reqD_mem),
        .reqD_stop(reqD_stop),
        .reqAddrD_mem ( reqAddrD_mem),
        .reqD_cache_write ( reqD_cache_write),
        .data_to_mem ( data_to_mem),
        .reqAddrD_write_mem(reqAddrD_write_mem)
    );
    memory_controller memory_controller(
        .clk(clk), 
        .reset(reset), 
        .reqI_cache (reqI_cache),
        .reqD_cache (reqD_mem),
        .reqD_cache_write ( reqD_cache_write),
        .reqAddrD_mem ( reqAddrD_mem),
        .reqAddrI_mem ( reqAddrI_mem),
        .data_from_cache ( data_to_mem),
        .data_to_cache (data_to_cache),
        .read_ready_for_icache (read_ready_for_icache),
        .read_ready_for_dcache(read_ready_for_dcache),
        .written_data_ack (written_data_ack),
        .reqAddrD_write_mem(reqAddrD_write_mem)
    );


endmodule