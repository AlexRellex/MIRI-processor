module forwarding_unit(
    input RegW_en_mem, RegW_en_wb,
    input [4:0] mem_regD, wb_regD,
    input [4:0] reg_s, reg_t,
    output reg [1:0] selMuxRegA, selMuxRegB
);

always @(mem_regD) begin
        if (RegW_en_mem == 1 && mem_regD != 0) begin
        
            if ( mem_regD == reg_s ) begin
                selMuxRegA <= 2'b10;
                selMuxRegB <= 2'b00;
            end
            if ( mem_regD == reg_t ) begin
                selMuxRegB <= 2'b10;
                selMuxRegA <= 2'b00;
            end
        end

        else if (RegW_en_wb == 1 && wb_regD != 0) begin
        
            if (!(RegW_en_mem == 1 && mem_regD != 0)  && (mem_regD == reg_s )) begin
                if ( wb_regD == reg_s ) begin
                    selMuxRegA <= 2'b01;
                    selMuxRegB <= 2'b00;
                end
            end 
            
            if (!(RegW_en_mem == 1 && mem_regD != 0)  && (mem_regD == reg_t )) begin
                if ( wb_regD == reg_t ) begin
                    selMuxRegB <= 2'b01;
                    selMuxRegA <= 2'b00;
                end
            end
        end

        else begin
            selMuxRegB <= 2'b00;
            selMuxRegA <= 2'b00;
        end
    end

endmodule