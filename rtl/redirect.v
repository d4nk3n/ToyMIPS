`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: regfile dataflow redirect

module redirect(
    input   [31:0]  exe_alu_out     ,
    input   [31:0]  mem_alu_out     ,
    input   [31:0]  reg_rs, reg_rt  ,
    input   [ 1:0]  fwd_rs, fwd_rt  ,

    output  [31:0]  rs, rt
);

    assign rs = (fwd_rs == 2'b10) ? exe_alu_out :
                (fwd_rs == 2'b01) ? mem_alu_out : reg_rs;

    assign rt = (fwd_rt == 2'b10) ? exe_alu_out :
                (fwd_rt == 2'b01) ? mem_alu_out : reg_rt;

endmodule
