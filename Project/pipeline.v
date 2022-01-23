`include "fetch_stage.v"
module datapath(
    input clk, reset,
);
    //Control registers enables
    wire EN_WRITE_FETCH, EN_WRITE_DECODE, EN_WRITE_ALU, EN_WRITE_MEM;

    //Fetch - Decode
    wire [31:0] instruction_to_decode;
    wire [31:0] PCnext_to_decode;

    // fetch - RAM
    wire reqI_cache, read_ready_for_icache, write,written_data_ack;
    wire [127:0] data_to_cache,data_to_mem;
    wire [25:0] reqAddrI_mem;

    // Stage modules
    fetch_stage fetch(
        .clk(clk),
        .reset(reset), // flow control variables    
        .PCbranch(), // ICache line where the PC must jump after a branch hit
        .branch_hit(), // Branch jumps
        .wrt_en(), // Enable signals
        .instr_from_mem(), // Instruction from memory when cache misses
        .mem_data_rdy(),
        .data_filled_ack(),
        .PCnext(), // PC for the next cycle
        .instruction(), // Instruction from Icache to next stage
        .reqI_mem(), // Initiate request to memory
        .reqAddrI_mem() // address identifier for request to mem
    );

    mem_ctrl mem_controller(
        .clk(clk),
        .reset(reset),
        .from_icache(),
        .from_dcache(),
        .is_write(),
        .addr_dcache(),
        .write_addr(),
        .addr_icache(),
        .data_from_cache(),
        .data_to_cache(),
        .read_ready_for_icache(),
        .read_ready_for_dcache(),
        .written_data_ack()
    );

endmodule