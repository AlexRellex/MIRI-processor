`timescale 1ns/1ns
`include "decoder.v"

module decoder2to4_tb;

    reg [1:0] A;
    wire [3:0] D;

    decoder2to4 uut(A, D);

    initial begin
        $dumpfile("decoder2to4_tb.vcd");
        $dumpvars(0, decoder2to4_tb);

        A = 2'b00; #20;
        A = 2'b01; #20;
        A = 2'b10; #20;
        A = 2'b11; #20;

        $display("Test OK!");
    end
    
endmodule