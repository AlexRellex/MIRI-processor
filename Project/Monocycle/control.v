`include "header.vh"

module control (
    
    // SYSTEM
    input clk,
    input reset,

    // INPUT
    input [31:0] instruction,

    // OUTPUT
    output reg [1:0] ALU_OP,
    output reg [4:0] regA, regB, regD,
    output reg is_immediate
    );

    // R-type               M-Type              B-Type
    //31-25 opcode          31-25 opcode        31-25 opcode
    //24-20 dst             24-20 dst           24-20 off_hi
    //19-15 src1            19-15 src1          19-15 src1
    //14-10 scr2            14-0 Offset         14-10 src2/off_mem
    //9-0   0                                   9-0   off_lw

    /*              OPCODE (31:26)
    add             0x00
    sub             0x01
    mul             0x02
    loadb           0x10
    loadw           0x11   
    storeb          0x12
    storew          0x13
    mov             0x14
    beq             0x30
    jump            0x31
    */

    wire signed [5:0] opcode;
    assign opcode = instruction [31:25];
    reg [1:0] default_alu_op = 2'b00; // ADD


    //wire [4:0] regD,regB;

    always @ ( * ) begin 

        case({opcode})
            // R-type
            6'b000000, 6'b000001: begin
                $display("ADD/SUM");
                ALU_OP <= 2'b10;
                regD <= instruction[24:20];
                regA <= instruction[19:15];
                regB <= instruction[14:10];
                is_immediate  <= 0;
            end

            // MUL
            6'b000010: begin
                $display("MUL");
                ALU_OP <= default_alu_op;
                regD <= instruction[24:20];
                regA <= instruction[19:15];
                regB <= instruction[14:10];
                is_immediate  <= 0;
            end

            // LDB, LDW
            6'b010000, 6'b010001: begin
                $display("LD");
                ALU_OP <= default_alu_op;
                regA <= instruction[19:15];
                regB <= instruction[24:20]; // dst
                is_immediate  <= 1;
            end
            // STB, STW
            6'b010010, 6'b010011: begin
                $display("STR");
                ALU_OP <= default_alu_op;
                regA <= instruction[24:20];
                regB <= instruction[19:15];
                is_immediate  <= 1;
            end

            default: begin
                ALU_OP <= 2'b10;
                is_immediate  <= 0;
            end
        endcase

    end 
endmodule // register