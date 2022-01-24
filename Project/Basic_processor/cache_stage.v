`include "header.vh"
`include "dCache.v"
`include "store_buffer.v"

module cache_stage(
    // SYSTEM
    input clk,reset, wrt_en,

    // INPUTS
    input [31:0] instr,
    input [31:0] regBdata_write_data,regData_address,
    input [4:0] regD_init,
    input [127:0] data_from_mem,
    input read_ready_from_mem,
    input written_data_ack_from_mem,

    output reg [31:0] read_data_mem,
    output reg [31:0] alu_result,
    output reg [4:0] regD,
    output reg reqD_mem,
    output reg [25:0] reqAddrD_mem,
    output reg [127:0] data_to_mem,
    output reg reqD_cache_write,
    output reg [25:0] reqAddrD_write_mem
);


wire cache_hit_w, req_dCache_mem_w;
wire [25:0] req_dCache_mem_addr;
wire evicted_data_w;

dCache dCache(
    .clk(clk),
    .reset(reset),
    .wrt_en(wrt_en),
    .addr(regData_address),
    .data_to_fill(data_from_mem),
    .mem_data_rdy(read_ready_from_mem),
    .data(regBdata_write_data),
    .cache_hit(cache_hit_w),
    .req_dCache_mem(req_dCache_mem_w),
    .req_dCache_mem_addr(req_dCache_mem_addr),
    .evicted_data(evicted_data_w)
);


endmodule