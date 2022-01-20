  
module RegFile (
  
    input [4:0] regA, regB, regD,
    input [31:0] data_to_w,
    input clk, RegWriteEn,
    output [31:0] regA_data, regB_data);

    reg [31:0] regfile [31:0];
    integer i;
  
    initial begin
        for (i=1; i<32; i=i+1) begin
            regfile[i]=i*10;
	    end
    end
  
    always @(posedge clk)begin
	    if (RegWriteEn) 
	 	    regfile[regD] <= data_to_w;
        regfile[0]=0;
    end
    
    assign regA_data = regfile[regA];
    assign regB_data = regfile[regB];

endmodule