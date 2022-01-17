module dCache
#(parameter ADDR_WIDTH=32, parameter DATA_WIDTH=32, parameter NUM_LINES=4, parameter BITS_LINE=128)
(
	input clk, //Clock
	input WE, //WE = 0 -> Writing not allowed; WE = 1 -> Writing Enabled;
	input [1:0] rd_wr, /*rd_wr == 00 -> LOAD BYTE
								rd_wr == 01 -> LOAD WORD
								rd_wr == 10 -> STORE BYTE
								rd_wr == 11 -> STORE WORD*/
	input [(ADDR_WIDTH-1):0] addrData, //Address data
	input [(DATA_WIDTH-1):0] data_to_write, //Data to write into dcache
	output reg [(DATA_WIDTH-1):0] data_read, //Data read from dcache
	output reg [(BITS_LINE-1):0] data_mem_write, //Data to write into memory
	input [(BITS_LINE-1):0] data_mem_read, //Data read from memory
	output reg cache_miss //Data cache miss
);

	//Cache containers
	reg [(BITS_LINE-1):0] data_cache [(NUM_LINES-1):0];
	reg [(ADDR_WIDTH-7):0] tag_cache [(NUM_LINES-1):0];
	reg [(NUM_LINES-1):0] val_bits;
	reg [(NUM_LINES-1):0] dirty_bits;
	//Some internal wires
	wire [(BITS_LINE-1):0] data_cache_line;
	wire [(ADDR_WIDTH-7):0] tag_cache_line;
	reg [(DATA_WIDTH-1):0] word_read_load;
	reg [(DATA_WIDTH-1):0] word_read_store;
	reg [(DATA_WIDTH-1):0] word_to_write;

	initial
		begin
			//$readmemb("single_port_rom_init.txt", rom);
			//val_bits = 4'b0000; //Memory hierarchy supported
			val_bits = 4'b1111; //Without memory hierarchy
			dirty_bits = 4'b0000;
			tag_cache[0] = 26'h0000000;
			tag_cache[1] = 26'h0000000;
			tag_cache[2] = 26'h0000000;
			tag_cache[3] = 26'h0000000;
			data_cache[0] = 128'h55443322_11009988_77665544_33221100;
			data_cache[1] = 128'h11009988_77665544_33221100_99887766;
			data_cache[2] = 128'h77665544_33221100_99887766_55443322;
			data_cache[3] = 128'h33221100_99887766_55443322_11009988;
//			tag_cache[0] = 26'h1111111;
//			tag_cache[1] = 26'h2222222;
//			tag_cache[2] = 26'h3333333;
//			tag_cache[3] = 26'h4444444;
//			data_cache[0] = 128'h55443322_11009988_77665544_33221100;
//			data_cache[1] = 128'h11009988_77665544_33221100_99887766;
//			data_cache[2] = 128'h77665544_33221100_99887766_55443322;
//			data_cache[3] = 128'h33221100_99887766_55443322_11009988;
		end
	
	assign data_cache_line = data_cache[addrData[5:4]];
	assign tag_cache_line = tag_cache[addrData[5:4]];
	
	always @(negedge clk)
	begin
		if (rd_wr == 0) //Load byte
		begin
			if (WE == 0)
			begin
				if ((addrData[(ADDR_WIDTH-1):6] == tag_cache_line) && (val_bits[addrData[5:4]] == 1)) //Read byte from cache
				begin
					case(addrData[3:2])
					0 : word_read_store = data_cache_line[31:0];
					1 : word_read_store = data_cache_line[63:32];
					2 : word_read_store = data_cache_line[95:64];
					3 : word_read_store = data_cache_line[127:96];
					endcase
					case(addrData[1:0])
					0 : data_read = {{24{word_read_store[7]}},word_read_store[7:0]};
					1 : data_read = {{24{word_read_store[15]}},word_read_store[15:8]};
					2 : data_read = {{24{word_read_store[23]}},word_read_store[23:16]};
					3 : data_read = {{24{word_read_store[31]}},word_read_store[31:24]};
					endcase
				end
				else
				begin
					//Implement memory hierarchy
					//Meanwhile...
					$display("BUG: MEMORY NOT FOUND");
				end
			end
			else if (WE == 1)//NOT POSSIBLE!!
			begin
				$display("BUG");
			end
		end
		else if (rd_wr == 1) //Load word
		begin
			if (WE == 0)
			begin
				if ((addrData[(ADDR_WIDTH-1):6] == tag_cache_line) && (val_bits[addrData[5:4]] == 1)) //Read word from cache
				begin
					case(addrData[3:2])
					0 : data_read = data_cache_line[31:0];
					1 : data_read = data_cache_line[63:32];
					2 : data_read = data_cache_line[95:64];
					3 : data_read = data_cache_line[127:96];
					endcase
				end
				else
				begin
					//Implement memory hierarchy
					//Meanwhile...
					$display("BUG: MEMORY NOT FOUND");
				end
			end
			else if (WE == 1)//NOT POSSIBLE!!
			begin
				$display("BUG");
			end
		end
	end
	
	always @(posedge clk)
	begin	
		if (rd_wr == 2) //Store byte
		begin
			if (WE == 1)
			begin
				if ((addrData[(ADDR_WIDTH-1):6] == tag_cache_line) && (val_bits[addrData[5:4]] == 1)) //Write byte into cache
				begin
					case(addrData[3:2])
					0 : word_read_load = data_cache_line[31:0];
					1 : word_read_load = data_cache_line[63:32];
					2 : word_read_load = data_cache_line[95:64];
					3 : word_read_load = data_cache_line[127:96];
					endcase
					case(addrData[1:0])
					0 : word_to_write = {word_read_load[31:8], data_to_write[7:0]};
					1 : word_to_write = {word_read_load[31:16],data_to_write[7:0],word_read_load[7:0]};
					2 : word_to_write = {word_read_load[31:24],data_to_write[7:0],word_read_load[15:0]};
					3 : word_to_write = {data_to_write[7:0],word_read_load[23:0]};
					endcase
					case(addrData[3:2])
					0 : data_cache[addrData[5:4]] = {data_cache_line[127:32],word_to_write};
					1 : data_cache[addrData[5:4]] = {data_cache_line[127:64],word_to_write,data_cache_line[31:0]};
					2 : data_cache[addrData[5:4]] = {data_cache_line[127:96],word_to_write,data_cache_line[63:0]};
					3 : data_cache[addrData[5:4]] = {word_to_write,data_cache_line[95:0]};
					endcase
				end
				else
				begin
					//Implement memory hierarchy
					//Meanwhile...
					$display("BUG: MEMORY NOT FOUND");
				end
			end
			else if (WE == 0)//NOT POSSIBLE!!
			begin
				$display("BUG");
			end
		end
		else if (rd_wr == 3) //Store word
		begin
			if (WE == 1)
			begin
				if ((addrData[(ADDR_WIDTH-1):6] == tag_cache_line) && (val_bits[addrData[5:4]] == 1)) //Write word into cache
				begin
					case(addrData[3:2])
					0 : data_cache[addrData[5:4]] = {data_cache_line[127:32],data_to_write};
					1 : data_cache[addrData[5:4]] = {data_cache_line[127:64],data_to_write,data_cache_line[31:0]};
					2 : data_cache[addrData[5:4]] = {data_cache_line[127:96],data_to_write,data_cache_line[63:0]};
					3 : data_cache[addrData[5:4]] = {data_to_write,data_cache_line[95:0]};
					endcase
				end
				else
				begin
					//Implement memory hierarchy
					//Meanwhile...
					$display("BUG: MEMORY NOT FOUND");
				end
			end
			else if (WE == 0)//NOT POSSIBLE!!
			begin
				$display("BUG");
			end
		end
	end

endmodule