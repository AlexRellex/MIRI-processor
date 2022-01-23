`include "header.vh"

module control (
    
    // SYSTEM
    input clk,
    input reset,

    // INPUT
    input [31:0] instruction,
    input block_pipe_data_cache,
    input block_pipe_instr_cache,

    // OUTPUT
    output reg ALU_REG_DEST,
    output reg is_branch,
    output reg MEM_R_EN, MEM_W_EN,
    output reg MEM_TO_REG,
    output reg WB_EN,
    output reg [1:0] ALU_OP,
    output reg [4:0] regA, regB, regD,
    output reg EN_REG_FETCH, EN_REG_DECODE, EN_REG_ALU, EN_REG_MEM,
    output reg is_immediate,
    output reg [31:0] inject_nop,
    output reg injecting_nop
    );

    // R-type               M-Type              B-Type
    //31-25 Operation       31-25 Operation     31-25 Operation
    //24-20 dst             24-20 dst           24-20 off_hi
    //19-15 src1            19-15 src1          19-15 src1
    //14-10 scr2            14-0 Offset         14-10 src2/off_mem
    //9-0   0                                   9-0   off_lw

    /*              OPCODE (31:26)
    add             0x00
    sub             0x01
    mul             0x02
    loadb           0x10
    loadw           0x11   
    storeb          0x12
    storew          0x13
    mov             0x14
    beq             0x30
    jump            0x31
    */

    wire signed [5:0] operation;
    assign operation = instruction [31:25];
    reg [5:0] default_alu_op = 6'b000000; // ADD

    //wire [4:0] regD,regB;

    always @ ( * ) begin 

        case({operation})
            // R-type
            6'b000000, 6'b000001: begin
                $display("ADD/SUM");
                WB_EN <= 1;
                ALU_REG_DEST <= 1;
                is_branch <= 0;
                MEM_R_EN <= 0;
                MEM_W_EN <= 0;
                MEM_TO_REG <= 0;
                ALU_OP <= operation;
                regD <= instruction[24:20];
                regA <= instruction[19:15];
                regB <= instruction[14:10];
                is_immediate  <= 0;
            end

            // MUL
            6'b000010: begin
                $display("MUL");
                WB_EN <= 1;
                ALU_REG_DEST <= 1;
                is_branch <= 0;
                MEM_R_EN <= 0;
                MEM_W_EN <= 0;
                MEM_TO_REG <= 0;
                ALU_OP <= operation;
                regD <= instruction[24:20];
                regA <= instruction[19:15];
                regB <= instruction[14:10];
                is_immediate  <= 0;
            end

            // LDB, LDW
            6'b010000, 6'b010001: begin
                $display("LD");
                WB_EN <= 1;
                ALU_REG_DEST <= 0;
                is_branch <= 0;
                MEM_R_EN <= 1;
                MEM_W_EN <= 0;
                MEM_TO_REG <= 1;
                ALU_OP <= default_alu_op;
                regA <= instruction[19:15];
                regB <= instruction[24:20]; // dst
                is_immediate  <= 1;
            end
            // STB, STW
            6'b010010, 6'b010011: begin
                $display("STR");
                WB_EN <= 0;
                ALU_REG_DEST <= 1;
                is_branch <= 0;
                MEM_R_EN <= 0;
                MEM_W_EN <= 1;
                MEM_TO_REG <= 0;
                ALU_OP <= default_alu_op;
                regA <= instruction[24:20];
                regB <= instruction[19:15];
                is_immediate  <= 1;
            end
            //Move
            6'b010100: begin
                WB_EN <= 1;
                ALU_REG_DEST <= 0;
                is_branch <= 0;
                MEM_R_EN <= 0;
                MEM_W_EN <= 0;
                MEM_TO_REG <= 0;
                ALU_OP <= default_alu_op;
                regA <= instruction[24:20];
                regB <= instruction[19:15];
                regD <= 6'b000000;
                is_immediate <= 0;
            end
            // BEQ
            6'b110000: begin
                WB_EN <= 1;
                ALU_REG_DEST <= 1;
                is_branch <= 1;
                MEM_R_EN <= 0;
                MEM_W_EN <= 0;
                MEM_TO_REG <= 0;
                ALU_OP <= 2'b01;
                regD <= 6'b000000;
                regB <= instruction[20:16];
                is_immediate  <= 1;
            end
            // Jump
            6'b110001: begin
                WB_EN <= 0;
                ALU_REG_DEST <= 1;
                is_branch <= 1;
                MEM_R_EN <= 0;
                MEM_W_EN <= 0;
                MEM_TO_REG <= 0;
                ALU_OP <= 2'b01;
                regD <= 6'b000000;
                regB <= instruction[20:16];
                is_immediate <= 0;
            end
            default: begin
                WB_EN <= 0;
                ALU_REG_DEST <= 0;
                is_branch <= 0;
                MEM_R_EN <= 0;
                MEM_W_EN <=0;
                MEM_TO_REG <=0;
                ALU_OP <= 2'b10;
                is_immediate  <= 0;
            end
        endcase

        if (block_pipe_instr_cache == 1'b1) begin
            EN_REG_FETCH = 0;
            EN_REG_DECODE = 1;
            EN_REG_ALU = 1;
            EN_REG_MEM = 1;
            injecting_nop = 1'b1;
             WB_EN =0; 
        end
        else begin
            EN_REG_FETCH = 1;
            injecting_nop = 1'b0;
        end

        if (block_pipe_data_cache  == 1'b1) begin
            EN_REG_FETCH = 0;
            EN_REG_DECODE = 0;
            EN_REG_ALU = 0;
            EN_REG_MEM = 0;
            WB_EN =0; 
        end
        else if (block_pipe_data_cache  == 1'b0 && block_pipe_instr_cache == 1'b0) begin
            EN_REG_FETCH = 1;
            EN_REG_DECODE = 1;
            EN_REG_ALU = 1;
            EN_REG_MEM = 1;     
        end
    end 
    always @ (reset) begin

        if (reset == 1) begin
            EN_REG_FETCH = 1;
            EN_REG_DECODE = 1;
            EN_REG_ALU = 1;
            EN_REG_MEM = 1;
            inject_nop= 32'b0;
            injecting_nop = 1'b0;

        end

        // Block pipeline for iCache
        if (block_pipe_instr_cache == 1'b1) begin
            EN_REG_FETCH = 0;
            EN_REG_DECODE = 1;
            EN_REG_ALU = 1;
            EN_REG_MEM = 1;
            injecting_nop = 1'b1;
             WB_EN =0; 
        end
        else begin
            EN_REG_FETCH = 1;
            injecting_nop = 1'b0;
        end


        // Block pipeline for dCache miss
        if (block_pipe_data_cache) begin
            EN_REG_FETCH = 0;
            EN_REG_DECODE = 0;
            EN_REG_ALU = 0;
            EN_REG_MEM = 0;
            WB_EN =0;
        end

        // If no need to block pipeline
        else if (!block_pipe_data_cache && !block_pipe_instr_cache) begin
            EN_REG_FETCH = 1;
            EN_REG_DECODE = 1;
            EN_REG_ALU = 1;
            EN_REG_MEM = 1;     
        end
    end

    always @ (reset) begin

        if (reset == 1) begin
            EN_REG_FETCH = 1;
            EN_REG_DECODE = 1;
            EN_REG_ALU = 1;
            EN_REG_MEM = 1;
            inject_nop = 32'b0;
            injecting_nop = 1'b0;
        end
    end 
endmodule // register