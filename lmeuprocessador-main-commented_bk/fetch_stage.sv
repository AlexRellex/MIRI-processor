`include "MUX_2_4_8.sv"
`include "flipflop.sv"

module fetch_stage(
    input [31:0] PCbranch, // ICache line where the PC must jump after a branch hit
    input clk,reset,flush, // flow control variables
    input branch_hit, // Branch jumps
    input EN_REG, // Enable signals
    input [127:0] instr_from_mem, // Instruction from memory when cache misses
    input read_ready_from_mem,
    input written_data_ack_from_mem,
    output reg [31:0] PCnext, // PC for the next cycle
    output reg [31:0] instruction, // Instruction from Icache to next stage
    output reg reqI_mem,
    output reg [25:0] reqAddrI_mem);

    wire [31:0] ADDER_MUX, MUX_PC, ICACHE_INSTRUCTION, PC_ADDER_ICACHE; // wires, format FROM_TO_ALSO
    reg cache_hit;
    
    mux2Data muxSelectPC( // 2way mux
        .select(branch_hit),
        .a(ADDER_MUX),
        .b(PCbranch),
        .y(MUX_PC)
    );

    assign ADDER_MUX = PC_ADDER_ICACHE +4; // simple logic adder

    instr_cache instr_cache(
        .clk(clk),
        .reset(reset),
        .flush(flush), 
        .mem_read(EN_REG),
        .address(PC_ADDER_ICACHE), 
        .readdata(ICACHE_INSTRUCTION),
        .data_from_mem(instr_from_mem),
        .read_ready_from_mem(read_ready_from_mem),
        .written_data_ack(written_data_ack_from_mem),
        .reqI_mem(reqI_mem),
        .reqAddrI_mem(reqAddrI_mem),
        .cache_hit(cache_hit)
    );

    flipflop PC( // flip flop to store PC
        .clk(clk),
        .reset(reset),
        .writeEn(EN_REG & !read_ready_from_mem & cache_hit ),
        .regIn(MUX_PC),
        .regOut(PC_ADDER_ICACHE)
    );

    assign instruction = ICACHE_INSTRUCTION;

    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (flush || reset) begin
            PCnext <= 0;
        end
        else if (EN_REG && !read_ready_from_mem) begin
            
            PCnext <= MUX_PC;
        end

    end

endmodule

