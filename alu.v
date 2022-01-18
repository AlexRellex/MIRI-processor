`include "header.vh"

module alu(
    input [4:0] op, 
    input [(`REG_FILE_WIDTH-1):0] x, y,
    output reg [(`REG_FILE_WIDTH-1):0] w,
    output reg  cmp);

initial begin
	w = 32'h0000_0000;
end

always @(*) begin
	cmp <= 0;
	case (op)
        // Arithmetic operations
        5'b00000: w <= x + y;      // 0: ADD 
        5'b00001: w <= x - y;      // 1: SUB 
    	5'b00010: w <= x * y;      // 2: MUL

        // Bit-wise operations
        5'b00011: w <= x | y;      // 3: OR
        5'b00100: w <= x & y;      // 4: AND
        5'b00101: w <= x ^ y;      // 5: XOR

        // Shift operations
        5'b00110: w <= x << y;     // 6: SLL
        5'b00111: w <= x >> y;     // 7: SRL

        // Relational operations
        5'b01001: cmp <= (x < y);  // 9: LT
        5'b01010: cmp <= (x > y);  // 10: GT
        5'b01011: cmp <= (x == y); // 11: EQ

        
        5'b01100: w <= x + y;      // 12: JMP TODO!
        5'b01000: w <= x | 0;      // 8: MV
        //5'b110010: TLBWrite 

		default: 
		begin
			$display("ALU: Operation unknown!");
		end
	endcase
end
endmodule