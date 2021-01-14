`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: write back

module write_back(
    input           mux_3   ,
    input   [31:0]  mem_data,
    input   [31:0]  alu_out ,
    
    output  [31:0]  write_data
);

    assign write_data = mux_3 ? alu_out : mem_data;

endmodule
