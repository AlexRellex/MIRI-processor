`include "header.vh"
`include "fetch_stage.v"
`include "control_to_alu.v"

module fetch_to_control (
     // SYSTEM
    input clk,
    input reset,

    // INPUT
    input [(`VIRT_ADDR_WIDTH-1):0] PCbranch, // ICache line where the PC must jump after a branch hit
    input branch_hit, // Branch jumps
    input wrt_en, // Enable signals
    input [(`ICACHE_LINE_WIDTH-1):0] instr_from_mem, // Instruction from memory when cache misses
    input mem_data_rdy,
    input data_filled_ack,

    // OUTPUT
    output [31:0] regDdata, regBdata,
    output zero,
    output [4:0] regD
);

wire [(`VIRT_ADDR_WIDTH-1):0] PCnext_w, instr_w;
wire reqI_mem_w;
wire [(`MEM_ADDRESS_LEN-1):0] reqAddrI_mem_w;

wire [15:0] lw_half_instr_w;

wire [31:0] regDdata_r, regBdata_r;
wire zero_r;
wire [4:0] regD_r;

fetch_stage fetch_stage(
    .clk(clk),
    .reset(reset),
    .PCbranch(PCbranch),
    .branch_hit(branch_hit),
    .wrt_en(wrt_en),
    .instr_from_mem(instr_from_mem),
    .mem_data_rdy(mem_data_rdy),
    .data_filled_ack(data_filled_ack),
    .PCnext(PCnext_w),
    .instruction(instr_w),
    .request_inst_memory(reqI_mem_w),
    .request_inst_memory_addr(reqAddrI_mem_w)
);

assign lw_half_instr_w = instr_w[15:0];

ctrl_to_alu control_to_alu(
    .clk(clk),
    .reset(reset),
    .instruction(instr_w),
    .lw_half_instr(lw_half_instr_w),
    .regDdata(regDdata_r),
    .regBdata(regBdata_r),
    .zero(zero_r),
    .regD(regD_r)
);



endmodule

