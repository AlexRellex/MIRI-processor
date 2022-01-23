`include "header.vh"
`include "main_memory.v"

module mem_ctrl(
    input clk, reset, 
    input from_icache,
    input from_dcache,
    input is_write,
    input [(`MEM_ADDRESS_LEN-1):0] addr_dcache,
    input [(`MEM_ADDRESS_LEN-1):0] write_addr,
    input [(`MEM_ADDRESS_LEN-1):0] addr_icache,
    input [(`MEM_LINE_WIDTH-1):0] data_from_cache,
    output reg [(`MEM_LINE_WIDTH-1):0] data_to_cache,
    output reg read_ready_for_icache,
    output reg read_ready_for_dcache,
    output reg written_data_ack
);
    integer fake_latency;
    reg accessing_memory;
    reg arbiter;
    reg was_write;

    reg [(`MEM_LINE_WIDTH-1):0] fake_data_buffer; // Buffer to fake data delay
    reg [(`MEM_LINE_WIDTH-1):0] data_to_write;

    main_memory ram(
        //Inputs
        //.reset(reset),
        .addr(addr),
        .data_to_write(data_to_write),
        .wrt_en(is_write),
        //Outputs
        .data_returned(fake_data_buffer),
    );

    always @ (posedge clk) begin
        
        if (reset == 1'b1) begin
            accessing_memory = 1'b0;
            fake_latency = 0;
        end
        written_data_ack=0;
        // A request is comming from one of the caches
        // We do not support icache and dcache conflict requests :(
        if (( from_icache == 1'b1 || from_dcache == 1'b1) && accessing_memory != 1'b1) begin
            read_ready_for_icache = 1'b0;
            read_ready_for_dcache = 1'b0;
            written_data_ack = 1'b0;
            if (from_dcache == 1'b1) begin
                arbiter = 1'b0;
                addr = addr_dcache;
                if (is_write == 1'b1) begin
                    was_write = is_write;
                    data_to_write = data_from_cache;
                    addr = write_addr;
                    written_data_ack = 1'b1;
                end
            end
            else begin
                arbiter = 1'b1;
                addr = addr_icache;
            end
            accessing_memory = 1'b1;            
        end
        // Fake the memory acces letency time to take 5 cycles
        if (accessing_memory ==  1'b1) begin
            fake_latency = fake_latency + 1; 
        end
        // When reached the fake latency, we can send the data to the cache
        if (fake_latency >= 4) begin
            if (arbiter == 1'b0) begin
                if (was_write) begin
                    written_data_ack = 1'b1;
                end
                else begin
                    data_to_cache = fake_data_buffer
                    read_ready_for_dcache = 1'b1;
                end
         
            end
            else if (arbiter == 1'b1) begin
                data_to_cache = fake_data_buffer
                read_ready_for_icache = 1'b1;
            end
            fake_latency = 0;            
        end
    end
endmodule