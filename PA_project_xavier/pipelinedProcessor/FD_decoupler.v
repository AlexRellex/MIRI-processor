module FD_decoupler
#(parameter INSTR_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input clk,
	input [(INSTR_WIDTH-1):0] F_instr,
	input [(ADDR_WIDTH-1):0] F_Pc,
	input F_kill,
	
	output reg [(INSTR_WIDTH-1):0] D_instr,
	output reg [(ADDR_WIDTH-1):0] D_Pc,
	output reg D_kill
);

	always @(posedge clk) begin
		D_instr <= F_instr;
		D_Pc <= F_Pc;
		D_kill <= F_kill;
	end


endmodule