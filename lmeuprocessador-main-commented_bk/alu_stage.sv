module alu_stage(
    input clk, reset, 
    input [4:0] mem_regD, wb_regD,
    input RegW_en_mem, RegW_en_wb,
    input [31:0] regAdata_init,regBdata_init,
    input [4:0] reg_s,reg_t,
    input [31:0] regFromWB, regFromMem,
    input [31:0] lower_half_instruction,
    input WB_EN_INIT, MEM_R_EN_INIT, MEM_W_EN_INIT,
    input [31:0] PCNEXT_init,
    input [1:0] ALU_OP,
    input REG_DEST,
    input [4:0] regD_reg,
    input [4:0] regD_imme,
    input is_BRANCH_init,
    input EN_REG,
    input MEM_TO_REG_INIT,
    input [5:0] FUNCTION,
    input is_immediate,
    output reg MEM_TO_REG,
    output reg [31:0] regDdata, regBdata,
    output reg zero, //lt,gt,
    output reg WB_EN, MEM_R_EN, MEM_W_EN,
    output reg [31:0] PCNEXT,
    output reg is_BRANCH,
    output reg [4:0] regD
    );

    wire [31:0] unused_data;
    wire [31:0] regDdata_internal;
    wire [31:0] regBdata_internal,regBdata_pre_internal;
    wire [31:0] regAdata_internal;
    wire [31:0] immediate;
    wire zero_internal;
    wire [4:0] regD_internal;
    wire [1:0] selMuxRegA, selMuxRegB;
    wire lt,gt;
    wire [3:0] alu_control_int;
    wire [31:0] PC_NEXT_INTERNAL;
    wire [5:0] FUNCTION_TO_ALU;
    assign immediate = lower_half_instruction;
    assign FUNCTION_TO_ALU = lower_half_instruction [5:0];
    assign PC_NEXT_INTERNAL = PCNEXT_init + (lower_half_instruction << 2);

    
    assign unused_data = 32'h0000;

    alu_control alu_controller(
        .alu_function(FUNCTION_TO_ALU),
        .alu_op(ALU_OP),
        .alu_control(alu_control_int)
    );

    forwarding_unit forward_logic(
        .RegW_en_mem(RegW_en_mem),
        .RegW_en_wb(RegW_en_wb),
        .mem_regD(mem_regD),
        .wb_regD(wb_regD),
        .reg_s(reg_s),
        .reg_t(reg_t),
        .selMuxRegA(selMuxRegA),
        .selMuxRegB(selMuxRegB)
    );

    mux2RegD muxRegD (
        .select(REG_DEST),
        .a(regD_imme),
        .b(regD_reg),
        .y(regD_internal)
    );


    mux4Data muxRegA (
        .select(selMuxRegA),
        .a(regAdata_init),
        .b(regFromWB),
        .c(regFromMem),
        .d(unused_data),
        .y(regAdata_internal)
    );

    mux2Data muxImmeRegB(
        .select(is_immediate),
        .a(regBdata_init),
        .b(immediate),
        .y(regBdata_pre_internal)
    );

    mux4Data muxRegB (
        .select(selMuxRegB),
        .a(regBdata_pre_internal),
        .b(regFromWB),
        .c(regFromMem),
        .d(unused_data),
        .y(regBdata_internal)
    );

    ALU alu(
        .regA(regAdata_internal),
        .regB(regBdata_internal),
        .aluoperation(alu_control_int),
        .regD(regDdata_internal),
        .zero(zero_internal),
        .lt(lt),
        .gt(gt)
    );

    

    //STAGE REGISTER 
    always @ (posedge clk) begin
        if (reset) begin
            WB_EN <= 0;
            MEM_R_EN <= 0;
            MEM_W_EN <= 0;
            regDdata <= 0;
            zero <= 0;
            regBdata <= 0;
            PCNEXT <= 0;
            regD <= 0;
            is_BRANCH <= 0;
            MEM_TO_REG <= 0;
        end
        else if (EN_REG) begin
            WB_EN <= WB_EN_INIT;
            MEM_R_EN <= MEM_R_EN_INIT;
            MEM_W_EN <= MEM_W_EN_INIT;
            regDdata <= regDdata_internal;
            regBdata <= regBdata_internal;
            zero <= zero_internal;
            PCNEXT <= PC_NEXT_INTERNAL;
            regD <= regD_internal;
            is_BRANCH <= is_BRANCH_init;
            MEM_TO_REG <= MEM_TO_REG_INIT;
        end
    end

endmodule