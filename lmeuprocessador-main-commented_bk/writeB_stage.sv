module writeB_stage(
    input clk, reset, 
    input RegW_en_init,
    input [31:0] alu_result, memReadVal,
    input [4:0] RegD_init,
    input MemToReg,
    output [31:0] WriteData,
    output [4:0] RegD,
    output RegW_en);

    wire [31:0] WriteData_internal;

    mux2Data dataFromtoW(
        .select(MemToReg),
        .a(alu_result),
        .b(memReadVal),
        .y(WriteData_internal)
    );
    assign RegD = RegD_init;
    assign WriteData = WriteData_internal;
    assign RegW_en = RegW_en_init;

    
endmodule 