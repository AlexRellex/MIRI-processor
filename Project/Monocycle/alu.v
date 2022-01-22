`include "header.vh"

module alu(
    input [5:0] op,
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
        5'h00: w <= x + y;      // 0: ADD 
        5'h01: w <= x - y;      // 1: SUB 
    	5'h02: w <= x * y;      // 2: MUL

        // Relational operations
        5'h09: cmp <= (x < y);  // 9: LT
        5'h0A: cmp <= (x > y);  // 10: GT
        5'h0B: cmp <= (x == y); // 11: EQ


        /*

        // Bit-wise operations
        5'h03: w <= x | y;      // 3: OR
        5'h04: w <= x & y;      // 4: AND
        5'h05: w <= x ^ y;      // 5: XOR

        // Shift operations
        5'h06: w <= x << y;     // 6: SLL
        5'h07: w <= x >> y;     // 7: SRL

        // Relational operations
        5'h09: cmp <= (x < y);  // 9: LT
        5'h0A: cmp <= (x > y);  // 10: GT
        5'h0B: cmp <= (x == y); // 11: EQ

        // I think mem stuff (mv, ld, st...) should be somewhere else
        5'h0C: w <= x | 0;      // 8: MV
        //5'b110010: TLBWrite 

        */

		default: 
            begin
                $display("ALU: Operation unknown!");
            end
	endcase
end
endmodule