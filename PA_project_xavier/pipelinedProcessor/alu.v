
module alu(op, x, y, w, z);

input [6:0] op;
input [31:0] x, y;
output reg [31:0] w;
output reg z;

initial begin
	w = 32'd0;
end

always @(*) begin
	z <= 0;
	case (op)
/* ADD */	7'b0000000: w <= x + y;
/* SUB */   7'b0000001: w <= x - y;			
/* MUL */	7'b0000010: w <= x * y;	//De moment 1 cicle, quan segmentat = 5 cicles (simul perque alu es bloqueja)	
/* LDB */   7'b0010000: w <= x+y;
/* LDW */   7'b0010001: w <= x+y;
/* STB */   7'b0010010: w <= x+y;
/* STW */   7'b0010011: w <= x+y;
/* MOV */   7'b0010100: w <= y;
/* BEQ */   7'b0110000: 
					if(x == y)
						z <= 1;
					else
						z <= 0;
/* JMP */   7'b0110001: w <= x+y;
/*TLBWrite  7'b0110010:*/ 
		default: 
		begin
			$display("Unkown operation");
		end
	endcase
end

//z = tmb es fa servir per branch
//si es tracta 'op aritmetica 
//unitat add tambe
//st,lb,beq,
//mov-jump pasen pero sha de fer res
endmodule
