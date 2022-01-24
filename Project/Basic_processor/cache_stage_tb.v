`timescale 1ns/1ns
`include "cache_stage.v"

module cache_stage_tb;
    // SYSTEM
    reg clk;
    reg reset;
    reg wrt_en;

    // INPUTS
    reg [31:0] instr;
    reg [31:0] regBdata_write_data,regData_address;
    reg [4:0] regD_init;
    reg [127:0] data_from_mem;
    reg read_ready_from_mem;
    reg written_data_ack_from_mem;

    wire [31:0] read_data_mem;
    wire [31:0] alu_result;
    wire [4:0] regD;
    wire reqD_mem;
    wire [25:0] reqAddrD_mem;
    wire [127:0] data_to_mem;
    wire reqD_cache_write;
    wire [25:0] reqAddrD_write_mem;

cache_stage uut(clk, reset, wrt_en, instr, regBdata_write_data,regData_address, regD_init, data_from_mem,
 read_ready_from_mem, written_data_ack_from_mem, read_data_mem,alu_result,regD,reqD_mem, reqAddrD_mem, data_to_mem,
 reqD_cache_write, reqAddrD_write_mem);

always #5 clk = ~clk;

 initial begin
        $dumpfile("cache_stage_tb.vcd");
        $dumpvars(0, cache_stage_tb);
        clk = 0;
        wrt_en = 1;
        reset = 0;
        instr = 32'h0000_0000;
        regBdata_write_data = 32'h0000_0002;
        regData_address = 32'h0000_0002;
        regD_init = 5'b0100;
        data_from_mem=128'hAAAAAAAA_BBBBBBBB_CCCCCCCC_DDDDDDDD;
        written_data_ack_from_mem = 0;

        #40;

        $display("Test OK!");
        $finish;

    end

endmodule