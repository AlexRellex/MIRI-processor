// Basic implementation of a flip-flop from the internet
module flipflop (
    
    input clk, reset, writeEn,
    input [31:0] regIn,
    output reg [31:0] regOut);

    always @ (posedge clk) begin
        if (reset == 1) regOut <= 0;
        else if (writeEn) regOut <= regIn;
    end
endmodule // register