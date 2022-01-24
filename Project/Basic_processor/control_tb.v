`timescale 1ns/1ns
`include "control.v"

module control_tb;
    // SYSTEM
    reg clk;
    reg reset;

    // INPUT
    reg [31:0] instruction;
    reg block_pipe_data_cache;
    reg block_pipe_instr_cache;

    // OUTPUT
    wire ALU_REG_DEST;
    wire is_branch;
    wire MEM_R_EN, MEM_W_EN;
    wire MEM_TO_REG;
    wire WB_EN;
    wire [1:0] ALU_OP;
    wire [4:0] regA, regB, regD;
    wire EN_REG_FETCH, EN_REG_DECODE, EN_REG_ALU, EN_REG_MEM;
    wire is_immediate;
    wire [31:0] inject_nop;
    wire injecting_nop;


    control uut(clk, reset, instruction, block_pipe_data_cache, block_pipe_instr_cache, ALU_REG_DEST,
    is_branch, MEM_R_EN, MEM_W_EN, MEM_TO_REG, WB_EN, ALU_OP, regA, regB, regD, EN_REG_FETCH, EN_REG_DECODE,
    EN_REG_ALU, EN_REG_MEM, is_immediate, inject_nop, injecting_nop);


    always #5 clk = ~clk;

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);

        clk = 0;
        reset = 0;
        block_pipe_data_cache = 0;
        block_pipe_instr_cache = 0;

        //R-type ADD r1, r2 -> r3: 
        // 31-26  25-21 19-15 14-10    9-0
        // 000000|00011|00001|00010|0000000000
        instruction = 32'b0000000_00011_00001_00010_0000000000; #30;
    
        //R-type SUB r1, r2 -> r3 
        // 31-26  24-20 19-15 14-10    9-0
        // 000001|00011|00001|00010|0000000000
        instruction = 32'b0000001_00011_00001_00010_0000000000; #30;


        //M-type LDB 80(r1) -> r0
        //  op     dst   src       off
        // 010000|00000|00001|0000000001010000
        instruction = 32'b0010000_00000_00001_000000001010000; #30;


        //M-type LDW 80(r1) -> r0
        // 010001|00000|00001|0000000001010000
        instruction = 32'b0010001_00000_00001_000000001010000; #30;


        //M-type STB r0 -> 80(r1)
        // 010010|00001|00000|0000000001010000
        instruction = 32'b0010010_00001_00000_000000001010000; #30;

        //M-type STW r0 -> 80(r1)
        // 010011|00001|00000|0000000001010000
        instruction = 32'b0010011_00001_00000_000000001010000; #30;


        $display("Test OK!");
        $finish();
    end
    
endmodule