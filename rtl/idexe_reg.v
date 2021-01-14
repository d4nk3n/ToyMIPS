`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: id-exe regfile

`include "./define.vh"

module idexe_reg(
    input               clk                         ,
    input               rst_n                       ,
    input               stall                       ,
    input               flush                       ,
    input       [31:0]  id_pc                       ,
    input       [31:0]  id_npc                      ,
    input       [31:0]  id_imm                      ,
    input       [31:0]  id_rs, id_rt                ,
    input       [31:0]  id_instr                    ,
    input       [ 5:0]  id_op                       ,
    input       [10:0]  id_func                     ,
    input       [ 4:0]  id_rwa, id_rsa, id_rta      ,
    input               id_wce                      ,
    input               id_mux_1, id_mux_2, id_mux_3,
    input               id_dwce, id_drce            ,
    input               id_pred_branch              ,
    input               id_pred_taken               ,
    input       [31:0]  id_pred_npc                 ,    

    output  reg [31:0]  exe_pc                      ,
    output  reg [31:0]  exe_npc                     ,
    output  reg [31:0]  exe_imm                     ,
    output  reg [31:0]  exe_rs, exe_rt              ,
    output  reg [31:0]  exe_instr                   ,
    output  reg [ 5:0]  exe_op                      ,
    output  reg [10:0]  exe_func                    ,
    output  reg [ 4:0]  exe_rwa, exe_rsa, exe_rta   ,
    output  reg         exe_wce                     ,
    output  reg         exe_mux_1, exe_mux_2, exe_mux_3,
    output  reg         exe_dwce, exe_drce          ,
    output  reg         exe_pred_branch             ,
    output  reg         exe_pred_taken              ,
    output  reg [31:0]  exe_pred_npc
);

    always @(posedge clk) begin
        if (rst_n == 1'b0 || stall == 1'b1 || flush) begin
            exe_pc      <=  `PC_INIT;
            exe_npc     <=  `PC_INIT;
            exe_imm     <=  `ZERO_WORD;
            exe_op      <=  6'b0;
            exe_rs      <=  `ZERO_WORD;
            exe_rt      <=  `ZERO_WORD;
            exe_instr   <=  `ZERO_WORD;
            exe_func    <=  11'b0;
            exe_rwa     <=  5'b0;
            exe_rsa     <=  5'b0;
            exe_rta     <=  5'b0;
            exe_wce     <=  1'b0;
            exe_mux_1   <=  1'b0;
            exe_mux_2   <=  1'b0;
            exe_mux_3   <=  1'b0;
            exe_dwce    <=  1'b0;
            exe_drce    <=  1'b0;
            exe_pred_branch <= 1'b0;
            exe_pred_taken  <= 1'b0;
            exe_pred_npc    <= `PC_INIT;
        end
        else begin
            exe_pc      <=  id_pc;
            exe_npc     <=  id_npc;
            exe_imm     <=  id_imm;
            exe_op      <=  id_op;
            exe_rs      <=  id_rs;
            exe_rt      <=  id_rt;
            exe_instr   <=  id_instr;
            exe_func    <=  id_func;
            exe_rwa     <=  id_rwa;
            exe_rsa     <=  id_rsa;
            exe_rta     <=  id_rta;
            exe_wce     <=  id_wce;
            exe_mux_1   <=  id_mux_1;
            exe_mux_2   <=  id_mux_2;
            exe_mux_3   <=  id_mux_3;
            exe_dwce    <=  id_dwce;
            exe_drce    <=  id_drce;
            exe_pred_branch <= id_pred_branch;
            exe_pred_taken  <= id_pred_taken;
            exe_pred_npc    <= id_pred_npc;
        end
    end

endmodule
