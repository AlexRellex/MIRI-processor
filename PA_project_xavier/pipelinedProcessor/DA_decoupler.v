module DA_decoupler
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input clk,
	input [(DATA_WIDTH-1):0] D_dataA,
	input [(DATA_WIDTH-1):0] D_dataB,
	input [(ADDR_WIDTH-1):0] D_PC,
	input [(DATA_WIDTH-1):0] D_BranchOffset,
	input [6:0] D_opcode,
	input [4:0] D_regDst,
	input [1:0] D_DC_rd_wr,
	input D_DC_we,
	input D_MuxD,
	input D_RF_wrd,
	input D_kill,
	
	output reg [(DATA_WIDTH-1):0] A_dataA,
	output reg [(DATA_WIDTH-1):0] A_dataB,
	output reg [(ADDR_WIDTH-1):0] A_PC,
	output reg [(DATA_WIDTH-1):0] A_BranchOffset,	
	output reg [6:0] A_opcode,
	output reg [4:0] A_regDst,
	output reg [1:0] A_DC_rd_wr,
	output reg A_DC_we,
	output reg A_MuxD,
	output reg A_RF_wrd,
	output reg A_kill
);

	always @(posedge clk) begin
		A_dataA <= D_dataA;
		A_dataB <= D_dataB;
		A_opcode <= D_opcode;
		A_regDst <= D_regDst;
		A_DC_rd_wr <= D_DC_rd_wr;
		A_DC_we <= D_DC_we;
		A_MuxD <= D_MuxD;
		A_PC <= D_PC;
		A_BranchOffset <= D_BranchOffset;
		A_RF_wrd <= D_RF_wrd;
		A_kill <= D_kill;
	end

	
endmodule
