`include "header.vh"

module alu( 
    input [3:0] op,
    input [(`REG_FILE_WIDTH-1):0] regA, regB,
    output reg [(`REG_FILE_WIDTH-1):0] regD,
    output reg zero);

    always @(*) begin
        case (op)
            // Arithmetic operations
            3'b000: regD <= regA + regB;      // 0: ADD 
            3'b001: regD <= regA - regB;      // 1: SUB 
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

            default: begin
                    regD <= regA + regB; 
                    $display("ALU: Operation unknown!");
                end
            
        endcase

        if (regD==0) zero=1;
        else zero=0;
    end

endmodule