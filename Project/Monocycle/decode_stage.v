`include "header.vh"
`include "control.v"
`include "regFile.v"
`include "../Electric_Components/MUX_2_4_8.v"
module decode_stage(
    input clk,reset,
    input [(`VIRT_ADDR_WIDTH-1):0] PCNEXT_FETCH, // PC from fetch stage
    input [(`INST_WIDTH-1):0] instruction, // instruction from fetch stage
    input [(`ADDR_WIDTH-1):0] addrD, // register address to write from alu
    input [(`REG_FILE_WIDTH-1):0] data_d, // data to write from alu
    input is_write, // write in reg file
    input wrt_en, // enable general flipflop write
    input block_pipe_data_cache, // blocking pipeline because data cache is busy
    input block_pipe_instr_cache, // blocking pipeline because instruction cache is busy

    output reg [(`REG_FILE_WIDTH-1):0] data_a, // regA data to alu
    output reg [(`REG_FILE_WIDTH-1):0] data_b, // regB data to alu
    output reg [(`REG_FILE_WIDTH-1):0] lower_half_instruction, // Immediate value
    output reg [(`VIRT_ADDR_WIDTH-1):0] PCNEXT_ALU, // PC to alu
    output reg WB_EN, MEM_R_EN, MEM_W_EN, // enable signals deppending on instruction type
    output reg [(`ADDR_WIDTH-1):0] regD, regD_imme, // regD containing values for immediate operations
    output reg ALU_REG_DEST, // op uses alu stage
    output reg is_branch, // op is branch
    output reg [(`ADDR_WIDTH-1):0] addrA, addrB, // addrA and addrB addresses for next stage
    output reg MEM_TO_REG, // op uses mem stage
    output reg [1:0] ALU_OP, // alu operation code
    output reg EN_REG_FETCH, EN_REG_DECODE, EN_REG_ALU, EN_REG_MEM, // enable signals for all stages
    output reg is_immediate // op is immediate
);

    wire [(`INST_WIDTH-1):0] instruction_INT, lower_half_instruction_INT; // to calculate immediate value
    wire [(`REG_FILE_WIDTH-1):0] data_a_INT, data_b_INT; // pass data to next stage
    wire [(`ADDR_WIDTH-1):0] regD_INT, regD_imme_INT; // For immediate ops
    wire ALU_REG_DEST_INT; // OP uses alu signal
    wire is_branch_INT; // OP is branch signal
    wire MEM_R_EN_INT, MEM_W_EN_INT, MEM_TO_REG_INT, WB_EN_INT; // enable signals deppending on instruction type
    wire [1:0] ALU_OP_INT; // opcode to alu
    wire [(`ADDR_WIDTH-1):0] addrA_INT, addrB_INT, addrD_INT; // read reg address from instruction
    wire EN_REG_FETCH_INT, EN_REG_DECODE_INT, EN_REG_ALU_INT, EN_REG_MEM_INT; // enable signals deppending on instruction type
    wire is_immediate_INT; // op is immediate

    wire [(`REG_FILE_WIDTH-1):0] inject_nop; // if control detects a problem, stall the pipeline propagating nop
    wire injecting_nop;

    // Connect signals to other stages


    control control(
        // SYSTEM
        .clk(clk),
        .reset(reset),
        // INPUT
        .instruction(instruction),
        .block_pipe_data_cache(block_pipe_data_cache),
        .block_pipe_instr_cache(block_pipe_instr_cache),
        // OUTPUT
        .ALU_REG_DEST(ALU_REG_DEST_INT),
        .is_branch(is_branch_INT),
        .MEM_R_EN(MEM_R_EN_INT), 
        .MEM_W_EN(MEM_W_EN_INT),
        .MEM_TO_REG(MEM_TO_REG_INT),
        .WB_EN(WB_EN_INT),
        .ALU_OP(ALU_OP_INT),
        .regA(addrA_INT), 
        .regB(addrB_INT), 
        .regD(addrD_INT),
        .EN_REG_FETCH(EN_REG_FETCH_INT), 
        .EN_REG_DECODE(EN_REG_DECODE_INT), 
        .EN_REG_ALU(EN_REG_ALU_INT), 
        .EN_REG_MEM(EN_REG_MEM_INT),
        .is_immediate(is_immediate_INT),
        .inject_nop(inject_nop),
        .injecting_nop(injecting_nop)
    );

    regFile regfile(
        // SYSTEM
        .clk(clk),
        .wrt_en(is_write),
        // Inputs
        .addrA(addrA_INT),  // Address to read A
        .addrB(addrB_INT),  // Address to read B
        .addrD(addrD),  // Address to write D
        .d(data_d),      // Data to write
        // Outputs
        .data_a(data_a_INT),  // Data from regA
        .data_b(data_b_INT) // Data from regB
    );

    // select between the current op or remove the op and forward nop
    mux2Data nop_bubble(
        .a(instruction),
        .b(inject_nop),
        .y(instruction_INT),
        .select(injecting_nop)
    );

    // Operation for immediate value calculation
    assign lower_half_instruction_INT= { 16'b0, instruction_INT[15:0] };
    assign regD_INT = instruction_INT[20:16];
    assign regD_imme_INT = instruction_INT[15:11];
    
    initial begin
        PCNEXT_ALU <= 0;
        lower_half_instruction  <= 0;
        data_a <= 0;
        data_b <= 0;
        regD  <= 0;
        regD_imme  <= 0;
        ALU_REG_DEST <= 0;
        is_branch <= 0;
        MEM_R_EN <= 0;
        MEM_W_EN <= 0;
        MEM_TO_REG <= 0;
        WB_EN <= 0;
        ALU_OP <= 0;
        addrA  <= 5'b00000;
        addrB <= 5'b00000;
        is_immediate <= 0;
    end

    always @ (posedge clk) begin
        if (reset) begin
            PCNEXT_ALU <= 0;
            lower_half_instruction  <= 0;
            data_a <= 0;
            data_b <= 0;
            regD  <= 0;
            regD_imme  <= 0;
            ALU_REG_DEST <= 0;
            is_branch <= 0;
            MEM_R_EN <= 0;
            MEM_W_EN <= 0;
            MEM_TO_REG <= 0;
            WB_EN <= 0;
            ALU_OP <= 0;
            addrA  <= 5'b00000;
            addrB <= 5'b00000;
            is_immediate <= 0;
        end
        else if (wrt_en) begin
            PCNEXT_ALU <= PCNEXT_FETCH;
            lower_half_instruction  <= lower_half_instruction_INT;
            data_a <= data_a_INT;
            data_b <= data_b_INT;
            regD <= addrD_INT;
            regD_imme <= regD_imme_INT;
            ALU_REG_DEST <= ALU_REG_DEST_INT;
            is_branch <= is_branch_INT;
            MEM_R_EN <= MEM_R_EN_INT;
            MEM_W_EN <= MEM_W_EN_INT;
            MEM_TO_REG <= MEM_TO_REG_INT;
            WB_EN <= WB_EN_INT;
            ALU_OP <= ALU_OP_INT;
            addrA  <= addrA_INT;
            addrB <= addrB_INT;
            is_immediate <= is_immediate_INT;
            EN_REG_FETCH = EN_REG_FETCH_INT;
            EN_REG_DECODE = EN_REG_DECODE_INT;
            EN_REG_ALU = EN_REG_ALU_INT;
            EN_REG_MEM = EN_REG_MEM_INT;
        end
    end
endmodule