
module UC(
	input clk,
	input wire [31:0] instr,
	input wire z,
	input wire [6:0] opcode_ALU,
	input wire kill,
	input wire iCacheMiss,
	input wire dCacheMiss,
	output reg [1:0] MuxB,
	output reg MuxD,
	output reg MuxAddrB,
	output reg RF_wrd,
	output reg [1:0] DC_rd_wr,
	output reg Nop,
	output reg DC_we,
	output reg IC_we,
	output reg [1:0] MuxPc);
	
	/*MuxPc: 
	00 newpc
	01 branch
	10 jump
	11 stall*/

	always @(instr[31:25]) 
	begin
		case (instr[31:25])
			7'b0000000,7'b0000001,7'b0000010: /* R-TYPE -> ADD, SUB, MUL */
			begin
				MuxB <= 2'b00;
				MuxD <= 0;
				MuxAddrB <= 0;
			end
			//7'b0010100: /* MOV */
			7'b0010000,7'b0010001: /* M-TYPE -> LDB, LDW */
			begin
				MuxB <= 2'b01;
				MuxD <= 1;
				MuxAddrB <= 0;
				DC_rd_wr <= instr[26:25];
			end
			7'b0010010,7'b0010011: /* M-TYPE -> STB, STW */
			begin
				MuxB <= 2'b01;
				MuxAddrB <= 1;
				DC_rd_wr <= instr[26:25];
			end
			7'b0110000: /* B-TYPE -> BEQ */
			begin
				MuxB <= 2'b00;
				MuxAddrB <= 0;
			end 	
			7'b0110001: /* B-TYPE -> JMP */
			begin
				MuxB <= 2'b10;
			end
		endcase
	end
	
	always @(clk)
	begin
		if (clk == 1)
		begin	
			RF_wrd <= 0;
			DC_we <= 0;
			IC_we <= 0;
		end
		else if (clk == 0)
		begin	
			case (instr[31:25])
				7'b0000000,7'b0000001,7'b0000010: /* R-TYPE -> ADD, SUB, MUL */
				begin
					RF_wrd <= 1;
				end
				7'b0010000,7'b0010001: /* M-TYPE -> LDB, LDW */
				begin
					RF_wrd <= 1;
				end
				7'b0010010,7'b0010011: /* M-TYPE -> STB, STW */
				begin
					DC_we <= 1;
				end
			endcase
			if ((z == 1) && (kill == 0))
			begin
				Nop <= 1;
				MuxPc <= 2'b01;
			end
			else if ((opcode_ALU == 7'b0110001) && (kill == 0))
			begin
				Nop <= 1;
				MuxPc <= 2'b10;
			end
			else
			begin
				Nop <= 0;
				MuxPc <= 2'b00;
			end
		end
	end
endmodule
 