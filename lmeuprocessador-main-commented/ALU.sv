module ALU(
    input [31:0] regA,regB,
    input [3:0] aluoperation,
    output reg [31:0] regD,
    output reg zero,lt,gt,
    output reg is_comp);
  
    always@(aluoperation,regA,regB) begin 
	    
        case (aluoperation)
            4'b0000 : regD = regA | regB; // OR
            4'b0001 : regD = regA & regB; // AND
            4'b0010 : regD = regA + regB; // ADD
            4'b0100 : regD = regA ^ regB; // XOR
            4'b0110 : regD = regA - regB; // SUB
            4'b0111 : regD = {31'b0,lt}; //slt
            //4'b1100 : regD = regA regB; //NOR
            // if you want to add new Alu instructions  add here
        default : regD = regA + regB; // ADD
    
        endcase
    
        if(regA>regB) begin
        
            gt = 1'b1;
            lt = 1'b0; 
        end 
        else if(regA<regB) begin
            gt = 1'b0;
            lt = 1'b1;  
        end

        if (aluoperation == 4'b1000)
            is_comp = 1'b1;
        else
            is_comp = 1'b0;
        
        if (regD==32'd0) zero=1'b1;
        else zero=1'b0;
    end

endmodule
