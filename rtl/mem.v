`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: get data mem address

module mem(
    input   [31:0]  alu_out,
    
    output  [15:0]  data_addr
);

    assign data_addr = alu_out[15:0];

endmodule
