`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: exe-mem regfile

`include "./define.vh"

module exemem_reg(
    input               clk, rst_n          ,
    input               exe_mux_3           ,
    input               exe_drce, exe_dwce  ,
    input               exe_wce             ,
    input       [ 5:0]  exe_op              ,
    input       [31:0]  exe_pc              ,
    input       [31:0]  exe_alu_out         ,
    input       [31:0]  exe_rt              ,
    input       [ 4:0]  exe_rwa             ,

    output  reg         mem_mux_3           ,
    output  reg         mem_drce, mem_dwce  ,
    output  reg         mem_wce             ,
    output  reg [ 5:0]  mem_op              ,
    output  reg [31:0]  mem_pc              ,
    output  reg [31:0]  mem_alu_out         ,
    output  reg [31:0]  mem_rt              ,
    output  reg [ 4:0]  mem_rwa
);

    always @(posedge clk) begin
        if (rst_n == 1'b0) begin
            mem_mux_3   <=  1'b0;
            mem_drce    <=  1'b0;
            mem_dwce    <=  1'b0;
            mem_wce     <=  1'b0;
            mem_op      <=  6'b0;
            mem_pc      <=  `PC_INIT;
            mem_alu_out <=  `ZERO_WORD;
            mem_rt      <=  `ZERO_WORD;
            mem_rwa     <=  5'b0;
        end
        else begin
            mem_mux_3   <=  exe_mux_3;
            mem_drce    <=  exe_drce;
            mem_dwce    <=  exe_dwce;
            mem_wce     <=  exe_wce;
            mem_op      <=  exe_op;
            mem_pc      <=  exe_pc;
            mem_alu_out <=  exe_alu_out;
            mem_rt      <=  exe_rt;
            mem_rwa     <=  exe_rwa;
        end
    end

endmodule
