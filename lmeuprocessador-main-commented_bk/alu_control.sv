module alu_control (
    
    input [5:0] alu_function,
    input [1:0] alu_op,
    output reg [3:0] alu_control
    );

    always @(alu_function) begin
        
        if (alu_op == 2'b10) begin
            case (alu_function)
                6'b000000: alu_control = 4'b0000; //OR
                6'b000001: alu_control = 4'b0001; //AND
                6'b000010: alu_control = 4'b0010; //ADD
                6'b000100: alu_control = 4'b0100; //XOR
                6'b000110: alu_control = 4'b0110; //SUB
                6'b000111: alu_control = 4'b0111; //slt
                6'b001000: alu_control = 4'b1000; //complt
            endcase
        end

        else begin
            alu_control = 4'b0010; //ADD
        end

    end

endmodule // register