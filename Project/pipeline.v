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

    //Decode - ALU
    wire [31:0] RegAdata_to_alu, RegBdata_to_alu;
    wire [31:0] lower_half_instruction_to_alu;
    wire WB_EN_TO_ALU, MEM_R_EN_TO_ALU, MEM_W_EN_TO_ALU, ALU_REG_DEST_TO_ALU;
    wire [31:0] PC_TO_ALU;
    wire [4:0] regD_reg_ALU, regD_imme_ALU;
    wire is_BRANCH_TO_ALU;
    wire [1:0] ALU_OP_TO_ALU;
    wire [5:0] FUNCTION_TO_ALU;
    wire [4:0] reg_s, reg_t;
    wire MEM_TO_REG_TO_ALU;


    assign block_pipe_instr_cache = reqI_cache;

    // Stage modules
    fetch_stage fetch(
        //inputs
        .clk(clk),
        .reset(reset), // flow control variables    
        .PCbranch(), // ICache line where the PC must jump after a branch hit
        .branch_hit(), // Branch jumps
        .wrt_en(), // Enable signals
        .instr_from_mem(), // Instruction from memory when cache misses
        .mem_data_rdy(read_ready_for_icache),
        .data_filled_ack(),
        //ouputs
        .PCnext(), // PC for the next cycle
        .instruction(), // Instruction from Icache to next stage
        .reqI_mem(reqI_cache), // Initiate request to memory
        .reqAddrI_mem() // address identifier for request to mem
    );

    decode_stage decode(
        // inputs
        .clk(clk),
        .reset(reset),
        .PCNEXT_FETCH(), // PC from fetch stage
        .instruction(), // instruction from fetch stage
        .addrD(), // register address to write from alu
        .data_d(), // data to write from alu
        .is_write(), // write in reg file
        .wrt_en(), // enable general flipflop write
        .block_pipe_data_cache(), // blocking pipeline because data cache is busy
        .block_pipe_instr_cache(), // blocking pipeline because instruction cache is busy
        // outputs
        .data_a(), // regA data to alu
        .data_b(), // regB data to alu
        .lower_half_instruction(), // Immediate value
        .PCNEXT_ALU(), // PC to alu
        .WB_EN(), 
        .MEM_R_EN(), 
        .MEM_W_EN(), // enable signals deppending on instruction type
        .regD(), 
        .regD_imme(), // regD containing values for immediate operations
        .ALU_REG_DEST(), // op uses alu stage
        .is_branch(), // op is branch
        .addrA(), 
        .addrB(), // addrA and addrB addresses for next stage
        .MEM_TO_REG(), // op uses mem stage
        .ALU_OP(), // alu operation code
        .EN_REG_FETCH(), 
        .EN_REG_DECODE(), 
        .EN_REG_ALU(), 
        .EN_REG_MEM(), // enable signals for all stages
        .is_immediate() // op is immediate
    );

    alu_stage alu_stage(
        // inputs
        .clk(clk), 
        .reset(reset), 
        .regAdata_init(),
        .regBdata_init(),
        .lower_half_instruction(),
        .op(),
        .is_immediate(),
        // OUTPUT
        .regDdata(), 
        .regBdata(),
        .zero(),
        .PCNEXT(),
        .regD()
    );

    mem_ctrl mem_controller(
        //inputs
        .clk(clk),
        .reset(reset),
        .from_icache(reqI_cache),
        .from_dcache(),
        .is_write(),
        .addr_dcache(),
        .write_addr(),
        .addr_icache(),
        .data_from_cache(),
        //outputs
        .data_to_cache(),
        .read_ready_for_icache(),
        .read_ready_for_dcache(),
        .written_data_ack()
    );

endmodule