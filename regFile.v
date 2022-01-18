`ifndef _regFile
`define _regFile

`include "header.vh"

module regFile(

    // SYSTEM
    input clk,
    input wrt,

    // Inputs
    input [(`ADDR_WIDTH-1):0] addrA,  // Address to read from A
    input [(`ADDR_WIDTH-1):0] addrB,  // Address to read from B
    input [(`ADDR_WIDTH-1):0] addrD,  // Address to write to C
    input [(`REG_FILE_WIDTH-1):0] d,      // Data to write

    // Outputs
    output [(`REG_FILE_WIDTH-1):0] data_a,  // Data from regA
    output [(`REG_FILE_WIDTH-1):0] data_b); // Data from regB


    // Internal registers
    reg [(`REG_FILE_WIDTH-1):0] regFile[(`REG_FILE_NREG-1):0];

	reg [(`ADDR_WIDTH-1):0] addrA_reg;
	reg [(`ADDR_WIDTH-1):0] addrB_reg;
	reg [(`ADDR_WIDTH-1):0] addrD_reg;

    initial begin

		regFile[5'b00000] = 32'h0000_0000;
		regFile[5'b00001] = 32'h0000_0000;
		regFile[5'b00010] = 32'h0000_0000;
		regFile[5'b00011] = 32'h0000_0000;
		regFile[5'b00100] = 32'h0000_0000;
		regFile[5'b00101] = 32'h0000_0000;
		regFile[5'b00110] = 32'h0000_0000;
		regFile[5'b00111] = 32'h0000_0000;
		regFile[5'b01000] = 32'h0000_0000;
		regFile[5'b01001] = 32'h0000_0000;
		regFile[5'b01010] = 32'h0000_0000;
		regFile[5'b01011] = 32'h0000_0000;
		regFile[5'b01100] = 32'h0000_0000;
		regFile[5'b01101] = 32'h0000_0000;
		regFile[5'b01110] = 32'h0000_0000;
		regFile[5'b01111] = 32'h0000_0000;
		regFile[5'b10000] = 32'h0000_0000;
		regFile[5'b10001] = 32'h0000_0000;
		regFile[5'b10010] = 32'h0000_0000;
		regFile[5'b10011] = 32'h0000_0000;
		regFile[5'b10100] = 32'h0000_0000;
		regFile[5'b10101] = 32'h0000_0000;
		regFile[5'b10110] = 32'h0000_0000;
		regFile[5'b10111] = 32'h0000_0000;
		regFile[5'b11000] = 32'h0000_0000;
		regFile[5'b11001] = 32'h0000_0000;
		regFile[5'b11010] = 32'h0000_0000;
		regFile[5'b11011] = 32'h0000_0000;
		regFile[5'b11100] = 32'h0000_0000;
		regFile[5'b11101] = 32'h0000_0000;
		regFile[5'b11110] = 32'h0000_0000;
		regFile[5'b11111] = 32'h0000_0000;

	end


    always @ (posedge clk)
        begin
            if (wrt)
                regFile[addrD_reg] <= d;
        end
        
    always @(negedge clk)
    begin
        addrA_reg <= addrA;
        addrB_reg <= addrB;
        addrD_reg <= addrD;
    end

    assign data_a = regFile[addrA_reg];
    assign data_b = regFile[addrB_reg];

endmodule

`endif