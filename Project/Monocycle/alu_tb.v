`timescale 1ns/1ns
`include "alu.v"

module alu_tb;
    reg [3:0] op;
    reg [(`REG_FILE_WIDTH-1):0] x, y;
    wire [(`REG_FILE_WIDTH-1):0] w;
    wire zero;

    alu uut(op, x, y, w, zero);

    integer i;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Give some values to the registers
        x=32'h0000_0001;
        y=32'h0000_0001;

        op=0;
        for (i = 1; i < 5; i=i+1) begin
            #5;
            op = op + 1;
            $display(op);
        end

        x=32'h0000_0010;
        y=32'h0000_00F1;

        op=0;
        for (i = 1; i < 5; i=i+1) begin
            #5;
            op = op + 1;
        end
    end
endmodule