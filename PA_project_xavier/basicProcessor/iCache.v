module iCache
#(parameter ADDR_WIDTH=32, parameter DATA_WIDTH=32, parameter NUM_LINES=4, parameter BITS_LINE=128)
(
	input clk,
	input [(ADDR_WIDTH-1):0] addrInst,
	input we,
	output reg [(DATA_WIDTH-1):0] instr,
	input [(BITS_LINE-1):0] data_mem_read, //Data read from memory
	output reg cache_miss //Data cache miss
);

	reg [(BITS_LINE-1):0] instrs_cache [(NUM_LINES-1):0];
	reg [(ADDR_WIDTH-7):0] tag_cache [(NUM_LINES-1):0];
	reg [(NUM_LINES-1):0] val_bits;
	wire [(BITS_LINE-1):0] instrs_cache_line;
	wire [(ADDR_WIDTH-7):0] tag_cache_line;

	initial
		begin
			//$readmemb("single_port_rom_init.txt", rom);
			//val_bits = 4'b0000; //Memory hierarchy supported
			val_bits = 4'b1111; //Without memory hierarchy
			tag_cache[0] = 26'h0000000;
			tag_cache[1] = 26'h0000000;
			tag_cache[2] = 26'h0000000;
			tag_cache[3] = 26'h0000000;
			instrs_cache[0] = 128'h22500000_26300000_00410C00_00308800; // LDW 0(R0), R5 | STW R3, 0(R0) | ADD R4, R2, R3 | ADD R3, R1, R2
			instrs_cache[1] = 128'h60007C0C_04801C00_04733C00_02611400; // BEQ R0, R31, 12| MUL R8, R0, R7 | MUL R7, R6, R15 | SUB R6, R2, R5
			instrs_cache[2] = 128'hFFFFFFFF_62000030_FFFFFFFF_FFFFFFFF; // Garbage | JMP R0, 48 | Garbage | Garbage
			instrs_cache[3] = 128'h62000000_600005E8_20900027_24700027; // JMP R0, 0 | BEQ R0, R1, 488 | LDB 39(R0), R9 | STB R7, 39(R0)
//			tag_cache[0] = 26'h1111111;
//			tag_cache[1] = 26'h2222222;
//			tag_cache[2] = 26'h3333333;
//			tag_cache[3] = 26'h4444444;
//			instrs_cache[0] = 128'h55443322_11009988_77665544_33221100;
//			instrs_cache[1] = 128'h11009988_77665544_33221100_99887766;
//			instrs_cache[2] = 128'h77665544_33221100_99887766_55443322;
//			instrs_cache[3] = 128'h33221100_99887766_55443322_11009988;
		end
	
	assign instrs_cache_line = instrs_cache[addrInst[5:4]];
	assign tag_cache_line = tag_cache[addrInst[5:4]];
	
	always @(addrInst)//posedge clk)
	begin
		if (addrInst[(ADDR_WIDTH-1):6] == tag_cache_line)
		begin
			case(addrInst[3:2])
			0 : instr = instrs_cache_line[31:0];
			1 : instr = instrs_cache_line[63:32];
			2 : instr = instrs_cache_line[95:64];
			3 : instr = instrs_cache_line[127:96];
			endcase
		end
		else
		begin
			//Implement memory hierarchy
			//Meanwhile...
			instr = 32'hZZZZZZZZ;
		end
	end
		
endmodule