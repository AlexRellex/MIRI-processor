`ifndef _regFile
`define _regFile

`include "header.vh"

module regFile(

    // SYSTEM
    input clk,
    input wrt_en,

    // Inputs
    input [(`ADDR_WIDTH-1):0] addrA,  // Address to read A
    input [(`ADDR_WIDTH-1):0] addrB,  // Address to read B
    input [(`ADDR_WIDTH-1):0] addrD,  // Address to write D
    input [(`REG_FILE_WIDTH-1):0] d,      // Data to write

    // Outputs
    output [(`REG_FILE_WIDTH-1):0] data_a,  // Data from regA
    output [(`REG_FILE_WIDTH-1):0] data_b); // Data from regB


    // Internal registers
    reg [(`REG_FILE_WIDTH-1):0] regFile[(`REG_FILE_NREG-1):0];

	reg [(`ADDR_WIDTH-1):0] addrA_reg;
	reg [(`ADDR_WIDTH-1):0] addrB_reg;
	reg [(`ADDR_WIDTH-1):0] addrD_reg;
    
    integer i;

    initial begin
        for (i=0; i<`REG_FILE_NREG; i=i+1) begin
             regFile[i] = 32'h0000_0000;   
        end
	end


    always @ (posedge clk)
        begin
            if (wrt_en)
                regFile[addrD_reg] <= d;
        end
        
    always @(negedge clk)
    begin
        addrA_reg <= addrA;
        addrB_reg <= addrB;
        addrD_reg <= addrD;
    end

    assign data_a = regFile[addrA_reg];
    assign data_b = regFile[addrB_reg];

endmodule

`endif