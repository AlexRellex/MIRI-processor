module FloatRegFile (
  
    input [4:0] FregA, FregB, FregD,
    input [31:0] Fdata_to_w,
    input clk, FRegWriteEn,
    output [31:0] FregA_data, FregB_data);

    reg [31:0] Fregfile [31:0];
    integer i;
  
    initial begin
        for (i=1; i<32; i=i+1) begin
            Fregfile[i]=i*10;
	    end
    end
  
    always @(posedge clk)begin
	    if (FRegWriteEn) 
	 	    Fregfile[FregD] <= Fdata_to_w;
        Fregfile[0]=0;
    end
    
    assign FregA_data = Fregfile[regA];
    assign FregB_data = Fregfile[regB];

endmodule