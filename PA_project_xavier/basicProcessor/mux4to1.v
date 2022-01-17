`ifndef _mux4to1
`define _mux4to1

module mux4to1
#(parameter DATA_SIZE=32)

(	input [(DATA_SIZE-1):0] in0,
	input [(DATA_SIZE-1):0] in1,
	input [(DATA_SIZE-1):0] in2,
	input [(DATA_SIZE-1):0] in3,
	input [1:0] sel,

	output reg [(DATA_SIZE-1):0] out);

	always @(*) begin //or always @(in0, in1, in2, in3, sel)
		case (sel)
			2'b00 : out <= in0;
			2'b01 : out <= in1;
			2'b10 : out <= in2;
			2'b11 : out <= in3;
			default: out <= 32'h0000_0000;
		endcase
	end
endmodule

//module mux4to1
//
//  (sel, in0, in1, in2, in3, out);
//
//	input [31:0] in0;
//	input [31:0] in1;
//	input [31:0] in2;
//	input [31:0] in3;
//	input [1:0] sel;
//
//	output reg [31:0] out;
//
//
//always @(sel or in0 or in1 or in2 or in3)
//
//  begin
//
//    case (sel)
//
//      2'b00: out = in0;
//
//      2'b01: out = in1;
//
//      2'b10: out = in2;
//
//      2'b11: out = in3;
//
//    endcase
//
//  end
//
//endmodule

`endif