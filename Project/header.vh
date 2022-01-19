`ifndef Macros_header
`define Macros_header
// Basics
`define BYTE_SIZE       1
`define WORD_SIZE       4

/////////////// Global stuff

// Virtual and Physical memory
`define VIRT_ADDR_WIDTH 32
`define PHY_ADDR_WIDTH  20
`define PAGE_SIZE_BITS  12 // 4 KB


// Register file
`define REG_FILE_WIDTH 32
`define REG_FILE_NREG  32
`define ADDR_WIDTH      5
`define DATA_WIDTH      5

`endif
