module mult_stages (
    
    input clk,reset,
    input [31:0] instruction,
    output reg ALU_REG_DEST,
    output reg is_branch,
    output reg MEM_R_EN, MEM_W_EN,
    output reg MEM_TO_REG,
    output reg WB_EN,
    output reg [1:0] ALU_OP,
    output reg [5:0] FUNCTION ,
    output reg [4:0] regA, regB, regD,
    output reg EN_REG_FETCH, EN_REG_DECODE, EN_REG_ALU, EN_REG_MEM,
    output reg is_immediate
    );

    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (flush || reset) begin
            instruction <= 0;
            PCnext <= 0;
            PC  <= 0;
        end
        else if (EN_REG) begin
            instruction <= instruction_internal;
            PC <= PC_address_to_PC;
            PCnext <= PC_internal_plus_4;
        end
    end

    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (flush || reset) begin
            instruction <= 0;
            PCnext <= 0;
            PC  <= 0;
        end
        else if (EN_REG) begin
            instruction <= instruction_internal;
            PC <= PC_address_to_PC;
            PCnext <= PC_internal_plus_4;
        end
    end

    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (flush || reset) begin
            instruction <= 0;
            PCnext <= 0;
            PC  <= 0;
        end
        else if (EN_REG) begin
            instruction <= instruction_internal;
            PC <= PC_address_to_PC;
            PCnext <= PC_internal_plus_4;
        end
    end

    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (flush || reset) begin
            instruction <= 0;
            PCnext <= 0;
            PC  <= 0;
        end
        else if (EN_REG) begin
            instruction <= instruction_internal;
            PC <= PC_address_to_PC;
            PCnext <= PC_internal_plus_4;
        end
    end
    