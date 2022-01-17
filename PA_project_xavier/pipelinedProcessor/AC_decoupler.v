
module AC_decoupler
#(parameter DATA_WIDTH=32)
(
	input clk,
	input [(DATA_WIDTH-1):0] A_w,
	input [6:0] A_regDst,
	input [1:0] A_DC_rd_wr,
	input A_DC_we,
	input A_MuxD,
	input A_RF_wrd,
	
	output reg [(DATA_WIDTH-1):0] C_w,
	output reg [6:0] C_regDst,
	output reg [1:0] C_DC_rd_wr,
	output reg C_DC_we,
	output reg C_MuxD,
	output reg C_RF_wrd
);

	always @(posedge clk) begin
		C_w <= A_w;
		C_regDst <= A_regDst;
		C_DC_rd_wr <= A_DC_rd_wr;
		C_DC_we <= A_DC_we;
		C_MuxD <= A_MuxD;
		C_RF_wrd <= A_RF_wrd;
	end


endmodule
