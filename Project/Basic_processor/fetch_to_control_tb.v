 `timescale 1ns/1ns
 `include "fetch_to_control.v"
 
module fetch_to_control_tb;

    // SYSTEM
    reg clk;
    reg reset;

    // INPUT
    reg [(`VIRT_ADDR_WIDTH-1):0] PCbranch; // ICache line where the PC must jump after a branch hit
    reg branch_hit; // Branch jumps
    reg wrt_en; // Enable signals
    reg [(`ICACHE_LINE_WIDTH-1):0] instr_from_mem; // Instruction from memory when cache misses
    reg mem_data_rdy;
    reg data_filled_ack;

    // OUTPUT
    wire [31:0] regDdata, regBdata;
    wire zero;
    wire [4:0] regD;

    fetch_to_control uut(clk, reset, PCbranch, branch_hit, wrt_en, instr_from_mem,
        mem_data_rdy, data_filled_ack, regDdata, regBdata, zero, regD);

always #5 clk = ~clk;

initial begin
    $dumpfile("fetch_to_control_tb.vcd");
    $dumpvars(0, fetch_to_control_tb);
    clk = 0;
    wrt_en = 1;
    reset = 0;
    PCbranch = 32'h0000_11FF;
    branch_hit = 0;
    instr_from_mem = {32'b0000000_00011_00001_00010_0000000000, 
        32'b0000000_00011_00001_00010_0000000000, 
        32'b0000000_00011_00001_00010_0000000000, 
        32'b0000000_00011_00001_00010_0000000000};
    mem_data_rdy=1;
    data_filled_ack=0;


    //R-type ADD r1, r2 -> r3: 
    // opcode  dst   s1    s2      off
    // 31-26  25-21 19-15 14-10    9-0
    // 000000|00011|00001|00010|0000000000
    #30;
    $display("TEST OK!");
    $finish();
end 

endmodule
