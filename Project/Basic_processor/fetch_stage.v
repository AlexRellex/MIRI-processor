`include "header.vh"
`include "components/MUX_2_4_8.v"
`include "components/flipflop.v"
`include "iCache.v"


module fetch_stage(
    input clk,reset, // flow control variables    
    input [(`VIRT_ADDR_WIDTH-1):0] PCbranch, // ICache line where the PC must jump after a branch hit
    input branch_hit, // Branch jumps
    input wrt_en, // Enable signals
    input [(`ICACHE_LINE_WIDTH-1):0] instr_from_mem, // Instruction from memory when cache misses
    input mem_data_rdy,
    input data_filled_ack,
    output reg [(`VIRT_ADDR_WIDTH-1):0] PCnext, // PC to decode
    output [(`INST_WIDTH-1):0] instruction, // Instruction from Icache to next stage
    output reg request_inst_memory, // Initiate request to memory
    output reg [(`MEM_ADDRESS_LEN-1):0] request_inst_memory_addr); // address identifier for request to mem

    wire [(`VIRT_ADDR_WIDTH-1):0] MUX_PC, ICACHE_INSTRUCTION, PC_ADDER_ICACHE; // wires, format FROM_TO_ALSO
    reg [31:0] ADDER_MUX;
    wire cache_hit;
    wire request_inst_memory_w;
    wire [(`MEM_ADDRESS_LEN-1):0] request_inst_memory_addr_w;

    mux2Data muxSelectPC( // 2way mux
        //Inputs
        .select(branch_hit),
        .a(ADDER_MUX),
        .b(PCbranch),
        //Outputs
        .y(MUX_PC)
    );

    iCache instr_cache (
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
        .cache_hit(cache_hit),
        .reqI_mem(request_inst_memory_w),
        .reqAddrI_mem(request_inst_memory_addr_w)
    );


    flipflop PC( // flip flop to store PC
        //Inputs
        .clk(clk),
        .reset(reset),
        .write_enable(wrt_en),
        .regIn(MUX_PC),
        //Outputs
        .regOut(PC_ADDER_ICACHE)
    );

    assign instruction = ICACHE_INSTRUCTION;

    initial begin
        ADDER_MUX = 32'h0000_1000;
    end
    //STAGE REGISTER 
    always @ (posedge clk) begin

        if (reset) begin
            PCnext <= 0;
        end
        /*
        else if (wrt_en && !mem_data_rdy) begin
            request_inst_memory = request_inst_memory_w;
            request_inst_memory_addr = request_inst_memory_addr_w;
            PCnext <= MUX_PC;
        end*/
        else begin
            ADDER_MUX = ADDER_MUX + 4;
            PCnext <= MUX_PC;
        end

    end

endmodule