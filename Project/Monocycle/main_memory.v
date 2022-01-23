`include "header.vh"


module main_memory(    
    // Inputs
    //input reset, 
    input [(`MEM_ADDRESS_LEN-1):0] addr, // TODO: Use Virtual 
    input [(`MEM_DATA_WIDTH-1):0] data_to_write,
    input wrt_en,

    // Outputs
    output reg [(`MEM_DATA_WIDTH-1):0] data_to_read);


    // Internal registers
    reg [(`VIRT_ADDR_WIDTH-1):0] memory [(`MEM_DATA_SIZE)-1:0]; // 2^20
    integer i;

    initial begin
        // Stack of variables goes from 0 to CODE_START
        memory[0] = 32'b0000_0000_0000_0000_0000_0000_0000_0010; // 2
        memory[1] = 32'b0000_0000_0000_0000_0000_0000_0000_0010; // 2
        for (i = 2; i<`CODE_START; i=i+1) begin
            memory[i] = 32'b000000_00000_00000_0000_0000_0000_0000;
        end
        // Program code goes from CODE_START to OS_START
        memory[`CODE_START] = 32'b0000_1000_0000_0001_0000_0000_1000_0000; // ADDI R1 <- R0,0x80 //128
        memory[`CODE_START+1] = 32'b000010_00000_11111_0000_0000_0000_0000; // ADDI R31 <- R0,0x00 //0
        memory[`CODE_START+2] = 32'b000010_00000_00101_0000_0000_0000_0000; // ADDI R5 <- R0,0x00 //0 i
        memory[`CODE_START+3] = 32'b000010_00000_00010_0000_0000_0000_0000; // ADDI R2 <- R0,0x00 //0 count
        memory[`CODE_START+4] = 32'b000100_00010_00011_0010_0000_0000_0000; // LD R3 <- 0x2000(R2)
        memory[`CODE_START+5] = 32'b000000_00011_11111_11111_000_0000_0010; // ADD R31 <- R3,R31
        memory[`CODE_START+6] = 32'b000010_00000_00010_0000_0000_0000_0100; // ADDI R2 <- R0,0x04 //4 ++count
        memory[`CODE_START+7] = 32'b000010_00000_00101_0000_0000_0000_0001; // ADDI R5 <- R0,0x01 //1 ++count
        memory[`CODE_START+8] = 32'b000000_00101_00110_0010_1000_0000_1000; // COMPLT R6 <- R5, R1
        memory[`CODE_START+9] = 32'b001001_00110_00000_0000_0000_0000_0000;
        for (i = `CODE_START+9; i<`OS_START; i=i+1) begin
            memory[i] = 32'b000000_00000_00000_0000_0000_0000_0000;
        end
        // TODO: Add OS code
        for (i = `OS_START; i<`MEM_DATA_SIZE; i=i+1) begin
            memory[i] = 32'b000000_00000_00000_0000_0000_0000_0000;
        end

    end

    always @ (*) begin
        
        /*if (reset == 1'b1) begin // Restart memory to do the basic operations
            for (i = 0; i<`MEM_DATA_SIZE; i=i+1) begin
                memory[i] = 32'b000000_00000_00000_0000_0000_0000_0000;
            end
        end*/

        //else begin
            // If we enable writting, assume we want to write to memory
        if (wrt_en == 1'b1) begin
            {memory[addr], memory[addr+1], memory[addr+2], memory[addr+3]} = data_to_write;
        end
        // If writting is not enable, assume we want to read from memory
        else begin
            data_to_read = {memory[addr], memory[addr+1], memory[addr+2], memory[addr+3]};
        end
        //end

    end

endmodule
