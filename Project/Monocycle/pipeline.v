module datapath(
    input clk, reset,
);
    //Control registers enables
    wire EN_WRITE_FETCH, EN_WRITE_DECODE, EN_WRITE_ALU, EN_WRITE_MEM;

    // RegD lecture control variables
    wire [4:0] regD_to_wb;
    wire [4:0] regD_to_mem;
    wire is_immediate;

    //Fetch - Decode
    wire [31:0] instruction_to_decode;
    wire [31:0] PCnext_to_decode;
    
    //MEM to Fetch
    wire BRANCH_TO_FETCH;
    wire [31:0] PCNEXT_TO_FETCH;

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

    //WB - Decode
    wire [31:0] write_data_to_reg;
    wire [4:0] destination_reg;
    wire RegW_en_to_decode;

    assign block_pipe_instr_cache = reqI_cache;

    // Stage modules
    fetch_stage fetch(
        //inputs
        .clk(clk),
        .reset(reset), // flow control variables    
        .PCbranch(PCNEXT_TO_FETCH), // ICache line where the PC must jump after a branch hit
        .branch_hit(BRANCH_TO_FETCH), // Branch jumps
        .wrt_en(EN_REG_FETCH), // Enable signals
        .instr_from_mem(data_to_cache), // Instruction from memory when cache misses
        .mem_data_rdy(read_ready_for_icache),
        .data_filled_ack(written_data_ack),
        //ouputs
        .PCnext(PCnext_to_decode), // PC for the next cycle
        .instruction(instruction_to_decode), // Instruction from Icache to next stage
        .reqI_mem(reqI_cache), // Initiate request to memory
        .reqAddrI_mem(reqAddrI_mem) // address identifier for request to mem
    );

    decode_stage decode(
        // inputs
        .clk(clk),
        .reset(reset),
        .PCNEXT_FETCH(PCnext_to_decode), // PC from fetch stage
        .instruction(instruction_to_decode), // instruction from fetch stage
        .addrD(destination_reg), // register address to write from alu
        .data_d(write_data_to_reg), // data to write from alu
        .is_write(RegW_en_to_decode), // write in reg file
        .wrt_en(EN_REG_DECODE), // enable general flipflop write
        .block_pipe_data_cache(block_pipe_data_cache), // blocking pipeline because data cache is busy
        .block_pipe_instr_cache(block_pipe_instr_cache), // blocking pipeline because instruction cache is busy
        // outputs
        .data_a(RegAdata_to_alu), // regA data to alu
        .data_b(RegBdata_to_alu), // regB data to alu
        .lower_half_instruction(lower_half_instruction_to_alu), // Immediate value
        .PCNEXT_ALU(PC_TO_ALU), // PC to alu
        .WB_EN(WB_EN_TO_ALU), 
        .MEM_R_EN(MEM_R_EN_TO_ALU), 
        .MEM_W_EN(MEM_W_EN_TO_ALU), // enable signals deppending on instruction type
        .regD(regD_reg_ALU), 
        .regD_imme(regD_imme_ALU), // regD containing values for immediate operations
        .ALU_REG_DEST(ALU_REG_DEST_TO_ALU), // op uses alu stage
        .is_branch(is_BRANCH_TO_ALU), // op is branch
        .addrA(reg_s), 
        .addrB(reg_t), // addrA and addrB addresses for next stage
        .MEM_TO_REG(MEM_TO_REG_TO_ALU), // op uses mem stage
        .ALU_OP(ALU_OP_TO_ALU), // alu operation code
        .EN_REG_FETCH(EN_REG_FETCH), 
        .EN_REG_DECODE(EN_REG_DECODE), 
        .EN_REG_ALU(EN_REG_ALU), 
        .EN_REG_MEM(EN_REG_MEM), // enable signals for all stages
        .is_immediate(is_immediate) // op is immediate
    );

    alu_stage alu_stage(
        // inputs
        .clk(clk), 
        .reset(reset), 
        .regAdata_init(RegAdata_to_alu),
        .regBdata_init(RegBdata_to_alu),
        .lower_half_instruction(lower_half_instruction_to_alu),
        .op(ALU_OP_TO_ALU),
        .is_immediate(is_immediate),
        // OUTPUT
        .regDdata(regDdata_to_mem), 
        .regBdata(regBdata_to_mem),
        .zero(zero_to_mem),
        .PCNEXT(PC_TO_ALU),
        .regD(regD_to_mem)
    );

    WB_stage writeback(
        // inputs
        .clk(clk), 
        .reset(reset), 
        .RegW_EN(WB_EN_TO_WB), // write enable from previous stages
        .alu_result(alu_result_to_wb), // result from alu op
        .loadValue(read_data_mem_to_wb), // value to writte if load
        .addrD(regD_to_wb), // register address to write to
        .MemOrReg(MEM_TO_REG_TO_WB), // memory operation or register operation to select the output
        // outputs
        .WriteData(write_data_to_reg), // data to write to register file
        .addrD_out(destination_reg), // register address to write to forwarded
        .RegW_EN_out(RegW_en_to_decode) // write enable to register file forwarded
    );

    mem_ctrl mem_controller(
        //inputs
        .clk(clk),
        .reset(reset),
        .from_icache(reqI_cache),
        .from_dcache(reqD_cache),
        .is_write(reqD_cache_write),
        .addr_dcache(reqAddrD_mem),
        .write_addr(reqAddrD_write_mem),
        .addr_icache(reqAddrI_mem),
        .data_from_cache(data_to_mem),
        //outputs
        .data_to_cache(data_to_cache),
        .read_ready_for_icache(read_ready_for_icache),
        .read_ready_for_dcache(read_ready_for_dcache),
        .written_data_ack(written_data_ack)
    );

endmodule