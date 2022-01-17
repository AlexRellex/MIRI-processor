`ifndef _regFile
`define _regFile

module regFile 
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5, parameter REGFILE_SIZE=32)

(	input clk,								// Clock
	input wrd,								// Enable write. wrd=1 enabled | wrd=0 disabled
	input [(ADDR_WIDTH-1):0] addrA,	// Register A address
	input [(ADDR_WIDTH-1):0] addrB,	// Register B address
	input [(ADDR_WIDTH-1):0] addrD,	// Register D address
	input [(DATA_WIDTH-1):0] d,		// Data to register D

	output [(DATA_WIDTH-1):0] a,		// Data from register A
	output [(DATA_WIDTH-1):0] b);		// Data from register B

	reg [(DATA_WIDTH-1):0] regFile[(REGFILE_SIZE-1):0];

	reg [(ADDR_WIDTH-1):0] addrA_reg;
	reg [(ADDR_WIDTH-1):0] addrB_reg;
	reg [(ADDR_WIDTH-1):0] addrD_reg;

	initial begin

		regFile[5'b00000] = 32'h0000_0000;
		regFile[5'b00001] = 32'h0960_1050;
		regFile[5'b00010] = 32'h0a78_00d0;
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
		regFile[5'b01111] = 32'h0000_0f7e;
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
		if (wrd)
			regFile[addrD_reg] <= d;
	end
	
	always @(negedge clk)
	begin
		addrA_reg <= addrA;
		addrB_reg <= addrB;
		addrD_reg <= addrD;
	end

	assign a = regFile[addrA_reg];
	assign b = regFile[addrB_reg];

endmodule

`endif
