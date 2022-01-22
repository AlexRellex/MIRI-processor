// Basic implementation of muxes from the internet
module mux2Data(

	input select,
	input [31:0] a,b,
	output [31:0] y);
	
	wire [31:0] a_internal, b_internal;


	assign y = (select) ? b : a;

endmodule

module mux2RegD(

	input select,
	input[4:0] a,b,
	output [4:0] y);
	
	assign y = (select) ? b : a;

endmodule

module mux2Logic(
	

	input select,
	input[3:0] a,b,
	output [3:0] y);
	
	assign y = (select) ? b : a;
	
endmodule

module mux4Logic(
	
	
	input [1:0] select,
	input [3:0] a,b,c,d,
	output [3:0] y);
	

	assign y = select[1] ? (select[0] ? d : c) : (select[0] ? b : a);

endmodule

module mux4Data(
	
		
	
	input [1:0] select,
	input [31:0] a,b,c,d,
	output [31:0] y);
	
	assign y = select[1] ? (select[0] ? d : c) : (select[0] ? b : a);
	
endmodule