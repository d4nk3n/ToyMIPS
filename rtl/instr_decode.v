`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: instruction decode

`include "./define.vh"

module instr_decode(
    input   [31:0]  instr                   ,
    input           rst_n                   ,
    input   [ 5:0]  exe_op, mem_op, wb_op   ,
    input   [ 4:0]  exe_rwa, mem_rwa, wb_rwa,
    input           exe_wce, mem_wce, wb_wce,
    input   [ 4:0]  exe_rsa, exe_rta        ,
    input           exe_rs_re, exe_rt_re    ,

    output  [31:0]  imm                     ,
    output  [ 5:0]  op                      ,
    output  [10:0]  func                    ,
    output  [ 4:0]  rwa, rsa, rta           ,
    output          wce                     ,
    output          mux_1, mux_2, mux_3     ,
    output          dwce, drce              ,
    output  [ 1:0]  fwd_rs, fwd_rt          ,
    output          stall
);

    assign stall =  ((exe_op == `OP_LW) && ((exe_rwa == rsa && rs_re) || (exe_rwa == rta && rt_re)));

    wire rs_re = (op != `OP_J);
    wire rt_re = (op == `OP_R || op == `OP_SW || op == `OP_BEQ);

    assign fwd_rs = (rst_n == 1'b0) ? 2'b00 :
                    (exe_wce == 1'b1 && exe_rwa == rsa && rs_re && exe_op != `OP_LW) ? 2'b10 :
                    (mem_wce == 1'b1 && mem_rwa == rsa && rs_re && mem_op != `OP_LW) ? 2'b01 :
                    (wb_wce  == 1'b1 && exe_rsa == wb_rwa && exe_rs_re && wb_op  == `OP_LW) ? 2'b11 : 2'b00;

    assign fwd_rt = (rst_n == 1'b0) ? 2'b00 :
                    (exe_wce == 1'b1 && exe_rwa == rta && rt_re && exe_op != `OP_LW) ? 2'b10 :
                    (mem_wce == 1'b1 && mem_rwa == rta && rt_re && mem_op != `OP_LW) ? 2'b01 : 
                    (wb_wce  == 1'b1 && exe_rta == wb_rwa && exe_rt_re && wb_op  == `OP_LW) ? 2'b11 : 2'b00;

    assign op   = instr[31:26];
    assign func = instr[10:0];

    assign rwa  = (op == `OP_LW) ? instr[20:16] : instr[15:11];
    assign rsa  = instr[25:21];
    assign rta  = instr[20:16];

    assign imm  =   (op == `OP_J)   ?   {{6{instr[25]}}, instr[25:0]}   << 2 :
                    (op == `OP_BEQ) ?   {{16{instr[15]}}, instr[15:0]}  << 2 :
                                        {{16{instr[15]}}, instr[15:0]};

    // mux_1 == 1   ->   use npc
    // mux_2 == 1   ->   use imm
    // mux_3 == 1   ->   use alu_out

    assign mux_1 = (op == `OP_BEQ)  ? 1'b1 : 1'b0;
    assign mux_2 = (op == `OP_R)    ? 1'b0 : 1'b1;
    assign mux_3 = (op == `OP_LW)   ? 1'b0 : 1'b1;

    assign wce  = (op == `OP_LW || (op == `OP_R && func != 11'b0)) ? 1'b1 : 1'b0;
    assign dwce = (op == `OP_SW) ? 1'b1 : 1'b0;
    assign drce = (op == `OP_LW) ? 1'b1 : 1'b0;

endmodule
