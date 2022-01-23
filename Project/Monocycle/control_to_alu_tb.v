`timescale 1ns/1ns
`include "control_to_alu.v"

module ctrl_to_alu_tb;
    

    // SYSTEM
    reg clk;
    reg reset;

    // INPUT
    reg [31:0] instruction;
    reg [15:0] lw_half_instr;

    // OUTPUT
    wire [31:0] regDdata;
    wire [31:0] regBdata;
    wire zero;
    wire [4:0] regD;

    ctrl_to_alu uut(clk, reset, instruction, lw_half_instr, regDdata, regBdata, zero, regD);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("ctrl_to_alu_tb.vcd");
        $dumpvars(0, ctrl_to_alu_tb);
        clk=0;
        reset=0;

        //R-type ADD r1, r2 -> r3: 
        // opcode  dst   s1    s2      off
        // 31-26  25-21 19-15 14-10    9-0
        // 000000|00011|00001|00010|0000000000
        instruction = 32'b0000000_00011_00001_00010_0000000000; 
        lw_half_instr = 16'h0000;
        #30;

        //R-type SUB r1, r2 -> r3 
        // 31-26  24-20 19-15 14-10    9-0
        // 000001|00011|00001|00010|0000000001
        instruction = 32'b0000001_00011_00001_00010_0000000001; 
        lw_half_instr = 16'h0001;
        #30;

        //M-type LDB 80(r1) -> r0
        //  op     dst   src       off
        // 010000|00000|00001|0000000001010000
        instruction = 32'b0010000_00000_00001_000000001010000;
        lw_half_instr = 16'h0050;
        #30;

        $finish();
    end

endmodule