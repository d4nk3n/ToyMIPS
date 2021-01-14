`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: instruction fetch

`include "./define.vh"

module instr_fetch(
    input               clk                 ,
    input               rst_n               ,
    input               stall               ,
    input       [31:0]  pc_in               ,
    
    output  reg [31:0]  pc      = `PC_INIT  ,
    output      [31:0]  npc                 ,
    output              rce
);

    assign rce = rst_n;
    assign npc = pc + 4;

    always @(posedge clk) begin
        pc  <=  (rst_n == 1'b0) ? `PC_INIT  :
                (stall == 1'b1) ? pc        : pc_in;
    end

endmodule
