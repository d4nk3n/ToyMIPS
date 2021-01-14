`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: if-id regfile

`include "./define.vh"

module ifid_reg(
    input               clk             ,
    input               rst_n           ,
    input               stall           ,
    input               flush           ,
    input       [31:0]  if_pc           ,
    input       [31:0]  if_npc          ,
    input               if_pred_branch  ,
    input               if_pred_taken   ,
    input       [31:0]  if_pred_npc     ,

    output  reg [31:0]  id_pc           ,
    output  reg [31:0]  id_npc          ,
    output  reg         id_pred_branch  ,
    output  reg         id_pred_taken   ,
    output  reg [31:0]  id_pred_npc
);

    always @(posedge clk) begin
        if (rst_n == 1'b0 || flush) begin
            id_pc           <= `PC_INIT;
            id_npc          <= `PC_INIT;
            id_pred_branch  <= 1'b0;
            id_pred_taken   <= 1'b0;
            id_pred_npc     <= `PC_INIT;
        end
        else if (stall == 1'b1) begin
            id_pc           <= id_pc;
            id_npc          <= id_npc;
            id_pred_branch  <= id_pred_branch;
            id_pred_taken   <= id_pred_taken;
            id_pred_npc     <= id_pred_npc;
        end
        else begin
            id_pc           <= if_pc;
            id_npc          <= if_npc;
            id_pred_branch  <= if_pred_branch;
            id_pred_taken   <= if_pred_taken;
            id_pred_npc     <= if_pred_npc;
        end
    end

endmodule
