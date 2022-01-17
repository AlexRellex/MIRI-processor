
module CW_decoupler
#(parameter DATA_WIDTH=32)
(
	input clk,
	input [(DATA_WIDTH-1):0] C_dataD,
	input [(DATA_WIDTH-1):0] C_w,
	input [6:0] C_regDst,
	input C_MuxD,
	input C_RF_wrd,
	
	output reg [(DATA_WIDTH-1):0] W_dataD,
	output reg [(DATA_WIDTH-1):0] W_w,
	output reg [6:0] W_regDst,
	output reg W_MuxD,
	output reg W_RF_wrd
);

	always @(posedge clk) begin
		W_dataD <= C_dataD;
		W_w <= C_w;
		W_regDst <= C_regDst;
		W_MuxD <= C_MuxD;
		W_RF_wrd <= C_RF_wrd;
	end


endmodule
