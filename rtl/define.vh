// date: 2020/12/22
// by: kun
// description: define

`define OP_R        6'b000000
`define OP_BEQ      6'b000100
`define OP_J        6'b000010
`define OP_SW       6'b101011
`define OP_LW       6'b100011
`define FUNC_ADD    6'b100000
`define FUNC_SUB    6'b100010
`define FUNC_AND    6'b100100
`define FUNC_OR     6'b100101
`define FUNC_XOR    6'b100110
`define FUNC_SLT    6'b101010
`define ZERO_WORD   32'b0
`define PC_INIT     32'b0

`define IMEM_FILE_PATH  "rtl/data/cpu_instructions"
`define REG_FILE_PATH   "rtl/data/cpu_regfile"
`define DMEM_FILE_PATH  "rtl/data/cpu_data"