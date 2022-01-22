`include "header.vh"

module alu_stage(
    // SYSTEM
    input clk, reset, 

    // From Fetch
    input [31:0] regAdata_init,regBdata_init,
    input [31:0] lower_half_instruction,
    input [31:0] PCNEXT_init,
    input [1:0] ALU_OP,

    // OUTPUT
    output reg [31:0] regDdata, regBdata,
    output reg zero,
    output reg [31:0] PCNEXT,
    output reg [4:0] regD
    );


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
    

    alu_control alu_controller(
        .alu_function(FUNCTION_TO_ALU),
        .alu_op(ALU_OP),
        .alu_control(alu_control_int)
    );

    alu alu(
        .regA(regA_data),
        .regB(regB_data),
        .op(alu_control_int),
        .regD(regD_data),
        .zero(zero_internal)
    );

    
    always @ (posedge clk) begin
        if (reset) begin
            regDdata <= 0;
            zero <= 0;
            regBdata <= 0;
            PCNEXT <= 0;
            regD <= 0;

        end
        else begin
            regDdata <= regD_data;
            regBdata <= regB_data;
            zero <= zero_internal;
            PCNEXT <= PC_NEXT_INTERNAL;
            regD <= regD_data;
        end
    end

endmodule