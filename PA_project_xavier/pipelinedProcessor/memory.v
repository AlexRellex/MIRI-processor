`ifndef _memory
`define _memory

module memory 
#(parameter DATA_WIDTH=128, parameter PHYS_WIDTH=10, parameter ADDR_WIDTH=32, parameter MEMORY_SIZE=2**PHYS_WIDTH)

(	input clk,							// Clock
	input rd_wr,						// rdwr=0 read | rdwr=1 write
	input we,							// Write enable. we=1 enabled | we=0 disabled
	input [(ADDR_WIDTH-1):0] addr,		// Memory address
	input [(DATA_WIDTH-1):0] data_wr,	// Data to write

	output [(DATA_WIDTH-1):0] data_rd);	// Data read

	reg [(DATA_WIDTH-1):0] memory[(MEMORY_SIZE-1):0];
	reg [(ADDR_WIDTH-1):0] addr_reg;
	reg [(DATA_WIDTH-1):0] data_reg;
	
	always @ (posedge clk)
	begin

		addr_reg <= addr;

		if (we && rd_wr)
		begin
			memory[addr_reg[(PHYS_WIDTH+4-1):4]] <= data_wr;
			data_reg <= 128'bZ;
		end
		
		if (!rd_wr)
			data_reg <= memory[addr_reg[(PHYS_WIDTH+4-1):4]];

	end
	
	assign data_rd = data_reg;

endmodule

`endif
