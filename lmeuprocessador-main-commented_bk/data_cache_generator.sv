module data_cache_generator (
    
    input clk, reset, flush,
    input requested_data_to_mem,
    output reg mem_read, mem_write,
    output reg [31:0] address, writedata);

    reg [31:0] coses_a_fer [63:0];
    reg reads [63:0];
    reg writes [63:0];
    reg blocked;
    reg [31:0] coses_a_escriure [31:0];
    integer count,count_write;
    always @ (posedge clk) begin
  	    

        /*if (requested_data_to_mem == 1'b1) begin
            blocked = 1'b1;
        end
        else begin
            blocked = 1'b0;
        end*/
        #10ps
        if (reset) begin
           
            count =0;
            count_write=0;
            for (int i = 0; i < 31;i++) begin
                reads[i] = 1;
            end
            for (int i = 20; i < 64;i++) begin
                reads[i] = 0;
            end
            for (int i = 20; i < 64;i++) begin
                writes[i] = 1;
            end
            for (int i = 0; i < 20;i++) begin
                writes[i] = 0;
            end

            coses_a_fer[0] <=   32'b00000000000000000000000000000000;
            coses_a_fer[1] <=   32'b00000000000000000000000000000100;
            coses_a_fer[2] <=   32'b00000000000000000000000000001000;
            coses_a_fer[3] <=   32'b00000000000000000000000000001100;
            coses_a_fer[4] <=   32'b00000000000000000000000000010000;
            coses_a_fer[5] <=   32'b00000000000000000000000000010100;
            coses_a_fer[6] <=   32'b00000000000000000000000000011000;
            coses_a_fer[7] <=   32'b00000000000000000000000000011100;
            coses_a_fer[8] <=   32'b00000000000000000000000000100000;
            coses_a_fer[9] <=   32'b00000000000000000000000000100100;
            coses_a_fer[10] <=  32'b00000000000000000000000000101000;
            coses_a_fer[11] <=  32'b00000000000000000000000000101100;
            coses_a_fer[12] <=  32'b00000000000000000000000000110000;
            coses_a_fer[13] <=  32'b00000000000000000000000000110100;
            coses_a_fer[14] <=  32'b00000000000000000000000000111000;
            coses_a_fer[15] <=  32'b00000000000000000000000000111100;
            coses_a_fer[16] <=  32'b00000000000000000000000001000000;
            coses_a_fer[17] <=  32'b00000000000000000000000001000100;
            coses_a_fer[18] <=  32'b00000000000000000000000001001000;
            coses_a_fer[19] <=  32'b00000000000000000000000001001100;
            coses_a_fer[20] <=  32'b00000000000000000000000001010000;
            coses_a_fer[21] <=  32'b00000000000000000000000001010100;
            coses_a_fer[22] <=  32'b00000000000000000000000001011000;
            coses_a_fer[23] <=  32'b00000000000000000000000001011100;
            coses_a_fer[24] <=  32'b00000000000000000000000001100000;
            coses_a_fer[25] <=  32'b00000000000000000000000001100100;
            coses_a_fer[26] <=  32'b00000000000000000000000001101000;
            coses_a_fer[27] <=  32'b00000000000000000000000001101100;
            coses_a_fer[28] <=  32'b00000000000000000000000001110000;
            coses_a_fer[29] <=  32'b00000000000000000000000001110100;
            coses_a_fer[30] <=  32'b00000000000000000000000001111000;
            coses_a_fer[31] <=  32'b00000000000000000000000001111100;
            coses_a_fer[32] <=  32'b00000000000000000000000010000000;
            coses_a_fer[33] <=  32'b00000000000000000000000010000100;
            coses_a_fer[34] <=  32'b00000000000000000000000010001000;
            coses_a_fer[35] <=  32'b00000000000000000000000010001100;
            coses_a_fer[36] <=  32'b00000000000000000000000010010000;
            coses_a_fer[37] <=  32'b00000000000000000000000010010100;
            coses_a_fer[38] <=  32'b00000000000000000000000010011000;
            coses_a_fer[39] <=  32'b00000000000000000000000010011100;
            coses_a_fer[40] <=  32'b00000000000000000000000010100000;
            coses_a_fer[41] <=  32'b00000000000000000000000010100100;
            coses_a_fer[42] <=  32'b00000000000000000000000010101000;
            coses_a_fer[43] <=  32'b00000000000000000000000010110000;
            
            coses_a_escriure[0] <=  32'b00000000000000000000000000000001;
            coses_a_escriure[1] <=  32'b00000000000000000000000000000010;
            coses_a_escriure[2] <=  32'b00000000000000000000000000000011;
            coses_a_escriure[3] <=  32'b00000000000000000000000000000100;
            coses_a_escriure[4] <=  32'b00000000000000000000000000000101;
            coses_a_escriure[5] <=  32'b00000000000000000000000000000110;
            coses_a_escriure[6] <=  32'b00000000000000000000000000000111;
            coses_a_escriure[7] <=  32'b00000000000000000000000000001000;
            coses_a_escriure[8] <=  32'b00000000000000000000000010000001;
            coses_a_escriure[9] <=  32'b00000000000000000000000010000010;
            coses_a_escriure[10] <=  32'b00000000000000000000000010000011;
            coses_a_escriure[11] <=  32'b00000000000000000000000010000100;
            coses_a_escriure[12] <=  32'b00000000000000000000000010000101;
            coses_a_escriure[13] <=  32'b00000000000000000000000010000110;
            coses_a_escriure[14] <=  32'b00000000000000000000000010000111;
            coses_a_escriure[15] <=  32'b00000000000000000000000010001000;
            coses_a_escriure[16] <=  32'b00000000000000000000001110000001;
            coses_a_escriure[17] <=  32'b00000000000000000000001110000010;
            coses_a_escriure[18] <=  32'b00000000000000000000001110000011;
            coses_a_escriure[19] <=  32'b00000000000000000000001110000100;
            coses_a_escriure[20] <=  32'b00000000000000000000001110000101;
            coses_a_escriure[21] <=  32'b00000000000000000000001110000110;
            coses_a_escriure[22] <=  32'b00000000000000000000001110000111;
            coses_a_escriure[23] <=  32'b00000000000000000000001110001000;
            blocked = 1'b0;
        end

        else if (requested_data_to_mem == 1'b1) begin
            blocked = 1'b1;
        end

        else if (requested_data_to_mem == 1'b0 && blocked == 1'b1) begin
            blocked = 1'b0;
        end
        else if (requested_data_to_mem == 1'b0 && blocked == 1'b0) begin
            
            address=coses_a_fer[count];
            mem_read=reads[count];
            mem_write=writes[count];
            count = count + 1;
            if (mem_write == 1'b1) begin
                writedata = coses_a_escriure[count_write];
                count_write = count_write + 1;
            end
        end

        
    end


endmodule // insttructionMem