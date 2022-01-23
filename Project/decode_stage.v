`include "Monocycle/header.vh"
`include "Monocycle/control.v"
`include "Monocycle/regFile.v"
`include "Electric_Components/MUX_2_4_8.v"
module decode_stage(
    port_list
);
    control control(
        // SYSTEM
        .clk(),
        .reset(),
        // INPUT
        .instruction(),
        .block_pipe_data_cache(),
        .block_pipe_instr_cache(),
        // OUTPUT
        .ALU_REG_DEST(),
        .is_branch(),
        .MEM_R_EN(), 
        .MEM_W_EN(),
        .MEM_TO_REG(),
        .WB_EN(),
        .ALU_OP(),
        .regA(), 
        .regB(), 
        .regD(),
        .EN_REG_FETCH(), 
        .EN_REG_DECODE(), 
        .EN_REG_ALU(), 
        .EN_REG_MEM(),
        .is_immediate(),
        .inject_nop(),
        .injecting_nop()
    );

    regFile regfile(
    // SYSTEM
    .clk(),
    .wrt_en(),
    // Inputs
    .addrA(),  // Address to read A
    .addrB(),  // Address to read B
    .addrD(),  // Address to write D
    .d(),      // Data to write
    // Outputs
    .data_a(),  // Data from regA
    .data_b() // Data from regB
    );
endmodule