`include "header.vh"


module main_memory(    
    // Inputs
    input reset, 
    input [31:0] addr, // TODO: Use Virtual 
    input [(`MEM_DATA_WIDTH-1):0] data_to_write,
    input wrt_en,

    // Outputs
    output reg [(`MEM_DATA_WIDTH-1):0] data_to_read);


    // Internal registers
    reg [31:0] memory [(`MEM_DATA_SIZE)-1:0]; // 2^20
    integer i;
    always @ (*) begin
        
        if (reset == 1'b1) begin // Restart memory to do the basic operations
            memory[0] = 32'b000010_00000_00001_0000_0000_1000_0000; // ADDI R1 <- R0,0x80 //128
            memory[1] = 32'b000010_00000_11111_0000_0000_0000_0000; // ADDI R31 <- R0,0x00 //0
            memory[2] = 32'b000010_00000_00101_0000_0000_0000_0000; // ADDI R5 <- R0,0x00 //0 i
            memory[3] = 32'b000010_00000_00010_0000_0000_0000_0000; // ADDI R2 <- R0,0x00 //0 count
            memory[4] = 32'b000100_00010_00011_0010_0000_0000_0000; // LD R3 <- 0x2000(R2)
            memory[5] = 32'b000000_00011_11111_11111_000_0000_0010; // ADD R31 <- R3,R31
            memory[6] = 32'b000010_00000_00010_0000_0000_0000_0100; // ADDI R2 <- R0,0x04 //4 ++count
            memory[7] = 32'b000010_00000_00101_0000_0000_0000_0001; // ADDI R5 <- R0,0x01 //1 ++count
            memory[8] = 32'b000000_00101_00110_0010_1000_0000_1000; // COMPLT R6 <- R5, R1
            memory[9] = 32'b001001_00110_00000_0000_0000_0000_0000;
            
            for (i = 0; i<`MEM_DATA_SIZE; i=i+1) begin
                memory[i] <= 32'b000000_00000_00000_0000_0000_0000_0000;
            end
        end

        else begin
            // If we enable writting, assume we want to write to memory
            if (wrt_en == 1'b1) begin
               {memory[addr], memory[addr+1], memory[addr+2], memory[addr+3]} = data_to_write;
            end
            // If writting is not enable, assume we want to read from memory
            else begin
                data_to_read = {memory[addr], memory[addr+1], memory[addr+2], memory[addr+3]};
            end
        end

    end

endmodule
