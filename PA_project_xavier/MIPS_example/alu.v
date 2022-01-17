
module alu(input [6:0] op, input [31:0] x, y, output reg [31:0] w, output carry);

	always @(*) begin
		case (op)
/* add */	4'b0000:  w <= x + y;
					carry = (x[31] == y[31] && w[31] != x[31]) ? 1 : 0;

/* sub */   4'b0001:  w <= x - y;			
					carry = (x[31] == y[31] && w[31] != x[31]) ? 1 : 0;

/* MUL */	4'b0010:  w <= x * y;									
		
			default: w <= 0;
		endcase
	end

endmodule
