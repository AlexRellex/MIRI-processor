`include "header.vh"
`include "../Electric_Components/MUX_2_4_8.v"
module WB_stage(
    input clk, reset, 
    input RegW_EN, // write enable from previous stages
    input [(`REG_FILE_WIDTH-1):0] alu_result, // result from alu op
    input [(`REG_FILE_WIDTH-1):0] loadValue, // value to writte if load
    input [(`ADDR_WIDTH-1):0] addrD, // register address to write to
    input MemOrReg, // memory operation or register operation to select the output
    output [(`REG_FILE_WIDTH-1):0] WriteData, // data to write to register file
    output [(`ADDR_WIDTH-1):0] addrD_out, // register address to write to forwarded
    output RegW_EN_out); // write enable to register file forwarded

    wire [(`REG_FILE_WIDTH-1):0] WriteData_INT; // internal wiring for the multiplexor

    mux2Data selectSource( // select the source for loading data into the register file or the alu result
        .select(MemOrReg),
        .a(alu_result),
        .b(loadValue),
        .y(WriteData_INT)
    );
    assign addrD_out = addrD;
    assign WriteData = WriteData_INT;
    assign RegW_EN_out = RegW_EN;

endmodule 