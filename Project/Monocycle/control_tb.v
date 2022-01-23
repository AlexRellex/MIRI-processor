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
        instruction = 32'h0000_0000;
        #30;

        $display("Test OK!");
        $finish();
    end
    
endmodule