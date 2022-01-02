`include "Electric_Components/mux.sv"
`include "Electric_Components/flipflop.sv"

module fetch_stage(
    input [31:0] branch_PC,
    input clk, reset
    input branch_taken,
    input enable_register,
    output reg [31:0] next_PC,
    output reg [31:0] instruction,
    );

    wire [31:0] PC_ADDER, ADDER_MUX, MUX_PC, MUX_ICACHE;
    reg cache_hit;

    mux2to1 SelectPC(
        .select(branch_taken),
        .a(ADDER_MUX),
        .b(branch_PC),
        .out(MUX_ICACHE)
    );

    assign ADDER_MUX = PC_ADDER +4;

    flipflop PC(
        .clk(clk),
        .reset(reset),
        .write_enable(enable_register & cache_hit),
        .regIn(MUX_PC),
        .regOut(PC_ADDER)
    );

    // TODO: create instruction cache

    always @ (posedge clk) begin

        if (reset) begin
            PCnext <= 0;
        end
        else if (enable_register) begin            
            PCnext <= PC_PC;
        end

    end

);
    
endmodule