`ifndef Macros_header
`define Macros_header
// Basics
`define BYTE_SIZE       1
`define WORD_SIZE       4

/////////////// Global stuff




/////// Fetch
`define ICACHE_NLINES 4
`define ICACHE_LINE_WIDTH 128
`define ICACHE_BYTEINLINE_WIDTH 4
`define ICACHE_INDEX_WIDTH 2
`define ICACHE_TAG_WIDTH 26


/////// Decode
// Register file
`define REG_FILE_WIDTH 32
`define REG_FILE_NREG  32
`define ADDR_WIDTH      5
`define DATA_WIDTH      5


/////// Memory
// Virtual and Physical memory
`define VIRT_ADDR_WIDTH     32
`define PHY_ADDR_WIDTH      20
`define PAGE_SIZE           12  // 4 KB
`define PHY_PAGE_NUM_WIDTH  `PHY_ADDR_WIDTH - `PAGE_SIZE

// Main mamory
`define MEM_DATA_WIDTH  128
`define MEM_DATA_SIZE   32768 // 2^20 = 1048576 // 1MB = 1048576 --> 1048576/32 = 32768

// iTLB
`define ITLB_NUM_LINES  4


/////// Cache
// Store Buffer
`define ADDR_WIDTH 32
`define DATA_WIDTH 32
`define SB_NLINES   4
`define SB_WIDTH  `ADDR_WIDTH + `DATA_WIDTH


`endif
