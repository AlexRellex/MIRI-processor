module flipflop (   
    input clk, reset, write_enable,
    input [31:0] regIn,
    output reg [31:0] regOut
    );

    always @ (posedge clk) begin
        if (reset == 1) regOut <= 0;
        else if (write_enable) regOut <= regIn;
    end
endmodule