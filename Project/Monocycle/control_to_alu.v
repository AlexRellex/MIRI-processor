`include "control.v"
`include "alu_stage.v"
`include "regFile.v"

module ctrl_to_alu (
     // SYSTEM
    input clk,
    input reset,

    // INPUT
    input [31:0] instruction,
    input [15:0] lw_half_instr,

    // OUTPUT
    output reg [31:0] regDdata, regBdata,
    output reg zero,
    output reg [4:0] regD
);

wire [1:0] alu_op;
wire [4:0] regA_w, regB_w, regD_w, rD;
wire is_imm;
wire [31:0] regA_data, regB_data, outD, outB;
wire [31:0] PC;
wire [31:0] lw_half_inst_extended;

assign lw_half_inst_extended = lw_half_instr;

control control(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .ALU_OP(alu_op),
    .regA(regA_w),
    .regB(regB_w),
    .regD(regD_w),
    .is_immediate(is_imm)
);

regFile regFile(
    .clk(clk),
    .wrt_en(0),
    .addrA(regA_w),
    .addrB(regB_w),
    .addrD(regD_w),
    .data_a(regA_data),
    .data_b(regB_data)
);

alu_stage alu_stage(
    .clk(clk),
    .reset(reset),
    .regAdata_init(regA_data),
    .regBdata_init(regB_data),
    .lower_half_instruction(lw_half_inst_extended),
    .op(alu_op),
    .is_immediate(is_imm),
    .regDdata(outD),
    .regBdata(outB),
    .zero(z),
    .PCNEXT(PC),
    .regD(rD)
);
    
endmodule