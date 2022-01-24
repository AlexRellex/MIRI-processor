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
`define CODE_START 4096
`define OS_START 8192
`define MEM_LINE_WIDTH 128

/////// Fetch
`define ICACHE_NLINES 4
`define ICACHE_LINE_WIDTH 128
`define ICACHE_BYTEINLINE_WIDTH 2
`define ICACHE_INDEX_WIDTH 2
`define ICACHE_TAG_WIDTH 26
`define MEM_ADDRESS_LEN 26
`define INST_WIDTH 32


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
`define DCACHE_NLINES 4
`define DCACHE_LINE_WIDTH 128
`define DCACHE_BYTEINLINE_WIDTH 2
`define DCACHE_INDEX_WIDTH 2
`define DCACHE_TAG_WIDTH 28

// Main mamory
`define MEM_DATA_WIDTH  128
`define MEM_DATA_SIZE   32768 // 2^20 = 1048576 // 1MB = 1048576 --> 1048576/32 = 32768

// iTLB
`define ITLB_NUM_LINES  4


/////// Cache
// Store Buffer
`define SB_ADDR_WIDTH 32
`define SB_DATA_WIDTH 32
`define SB_NLINES   4
`define SB_WIDTH  `SB_ADDR_WIDTH + `SB_DATA_WIDTH


`endif
