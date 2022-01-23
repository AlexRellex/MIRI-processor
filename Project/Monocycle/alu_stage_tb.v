`timescale 1ns/1ns
`include "alu_stage.v"


module alu_stage_tb;
    // SYSTEM
    reg clk;
    reg reset;

    // From Fetch
    reg [31:0] regAdata_init,regBdata_init;
    reg [31:0] lower_half_instruction;
    reg [31:0] PCNEXT_init;
    reg [1:0] ALU_OP;

    // OUTPUT
    wire [31:0] regDdata;
    wire [31:0]regBdata;
    wire zero;
    wire [31:0] PCNEXT;
    wire [4:0] regD;

    // Internal wires
    wire zero_internal;
    wire [3:0] alu_control_int;
    wire [31:0] PC_NEXT_INTERNAL;
    wire [5:0] FUNCTION_TO_ALU;
    wire [31:0] regA_data;
    wire [31:0] regB_data;
    wire [31:0] regD_data;
    assign FUNCTION_TO_ALU = lower_half_instruction [5:0];
    assign PC_NEXT_INTERNAL = PCNEXT_init + (lower_half_instruction << 2);
    assign regA_data = regAdata_init;
    assign regB_data = regBdata_init;

    alu_stage uut(clk, reset, regAdata_init,regBdata_init, lower_half_instruction, PCNEXT_init,
     ALU_OP, regDdata, regBdata, zero, PCNEXT, regD);

    integer i;

    always #5 clk = ~clk;

    initial begin
        $dumpfile("alu_stage_tb.vcd");
        $dumpvars(0, alu_stage_tb);
        clk=0;
        reset=0;
        lower_half_instruction = 32'h0000_0001;

        ALU_OP = 2'b10;
        
        regAdata_init = 32'h0000_0001;
        regBdata_init = 32'h0000_0001;
        #20;

        //ADD
        #20;

        //SUB
        lower_half_instruction = 32'h0000_0000;
        #20;

        regAdata_init = 32'h0000_0011;
        regBdata_init = 32'h0000_0021;
        //ADD
        lower_half_instruction = 32'h0000_0001;
        #20;
        $finish();
    end
endmodule