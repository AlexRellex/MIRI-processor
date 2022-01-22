`include "Electric_Components/MUX_2_4_8.v"
`include "Electric_Components/flipflop.v"
`include "Monocycle/iCache.v"
`include "Monocycle/header.vh"

module fetch_stage(
    input clk,reset, // flow control variables    
    input [(`VIRT_ADDR_WIDTH-1):0] PCbranch, // ICache line where the PC must jump after a branch hit
    input branch_hit, // Branch jumps
    input wrt_en, // Enable signals
    input [(`ICACHE_LINE_WIDTH-1):0] instr_from_mem, // Instruction from memory when cache misses
    input mem_data_rdy,
    input data_filled_ack,
    output reg [(`VIRT_ADDR_WIDTH-1):0] PCnext, // PC for the next cycle
    output reg [(`VIRT_ADDR_WIDTH-1):0] instruction, // Instruction from Icache to next stage
    output reg reqI_mem, // Initiate request to memory
    output reg [(`ICACHE_TAG_WIDTH-1):0] reqAddrI_mem); // address identifier for request to mem

    wire [(`VIRT_ADDR_WIDTH-1):0] ADDER_MUX, MUX_PC, ICACHE_INSTRUCTION, PC_ADDER_ICACHE; // wires, format FROM_TO_ALSO
    reg cache_hit;
    
    mux2Data muxSelectPC( // 2way mux
        //Inputs
        .select(branch_hit),
        .a(ADDER_MUX),
        .b(PCbranch),
        //Outputs
        .y(MUX_PC)
    );

    assign ADDER_MUX = PC_ADDER_ICACHE +4; // simple logic adder

    instr_cache iCache(
        //Inputs
        .clk(clk),
        .reset(reset),
        .wrt_en(wrt_en),
        .addr(PC_ADDER_ICACHE), 
        .data_to_fill(instr_from_mem),
        .mem_data_rdy(mem_data_rdy),
        .data_filled_ack(data_filled_ack),
        //Outputs
        .instr(ICACHE_INSTRUCTION),
        .cache_hit(cache_hit)
        .reqI_mem(reqI_mem),
        .reqAddrI_mem(reqAddrI_mem),
    );

    flipflop PC( // flip flop to store PC
        //Inputs
        .clk(clk),
        .reset(reset),
        .writeEn(wrt_en & !mem_data_rdy & cache_hit ),
        .regIn(MUX_PC),
        //Outputs
        .regOut(PC_ADDER_ICACHE)
    );

    assign instruction = ICACHE_INSTRUCTION;

    initial begin
        PC.regIn = 32'h0000_1000;
    end

    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (reset) begin
            PCnext <= 0;
        end
        else if (wrt_en && !mem_data_rdy) begin
            
            PCnext <= MUX_PC;
        end

    end

endmodule