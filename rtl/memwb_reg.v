`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: mem-wb regfile

`include "./define.vh"

module memwb_reg(
    input               clk         ,
    input               rst_n       ,
    input       [31:0]  mem_pc      ,
    input       [31:0]  mem_alu_out ,
    input       [ 5:0]  mem_op      ,
    input       [ 4:0]  mem_rwa     ,
    input               mem_mux_3   ,
    input               mem_wce     ,

    output  reg [31:0]  wb_pc       ,
    output  reg [31:0]  wb_alu_out  ,
    output  reg [ 5:0]  wb_op       ,
    output  reg [ 4:0]  wb_rwa      ,
    output  reg         wb_mux_3    ,
    output  reg         wb_wce
);

    always @(posedge clk) begin
        if (rst_n == 1'b0) begin
            wb_pc       <= `PC_INIT;
            wb_alu_out  <= `ZERO_WORD;
            wb_op       <= 6'b0;
            wb_rwa      <= 5'b0;
            wb_mux_3    <= 1'b0;
            wb_wce      <= 1'b0;
        end
        else begin
            wb_pc       <= mem_pc;
            wb_alu_out  <= mem_alu_out;
            wb_op       <= mem_op;
            wb_rwa      <= mem_rwa;
            wb_mux_3    <= mem_mux_3;
            wb_wce      <= mem_wce;
        end
    end

endmodule
