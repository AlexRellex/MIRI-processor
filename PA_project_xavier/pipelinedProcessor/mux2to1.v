`ifndef _mux2to1
`define _mux2to1

module mux2to1
#(parameter DATA_SIZE=32)

(	input [(DATA_SIZE-1):0] in0,
	input [(DATA_SIZE-1):0] in1,
	input sel,

	output reg [(DATA_SIZE-1):0] out);

	always @(*) //or always @(in0, in1, sel)
			case (sel)
				0 : out <= in0;
				1 : out <= in1;
				default: out <= 32'h0000_0000;
			endcase
endmodule

`endif