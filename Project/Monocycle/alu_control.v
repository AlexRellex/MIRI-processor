module alu_control (
    
    input [5:0] alu_function,
    input [1:0] alu_op,
    output reg [3:0] alu_control
    );

    always @(alu_function) begin
        
        if (alu_op == 2'b10) begin
            case (alu_function)
                6'b000000: alu_control = 4'b0000; //ADD
                6'b000001: alu_control = 4'b0001; //SUB
            endcase
        end

        else begin
            alu_control = 4'b0000; //ADD
        end

    end

endmodule