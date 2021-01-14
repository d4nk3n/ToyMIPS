`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: exe data in redirect

module redirect_exe(
    input   [31:0]  data_out        ,
    input   [31:0]  exe_rs, exe_rt  ,
    input   [ 1:0]  fwd_rs, fwd_rt  ,

    output  [31:0]  rs, rt
);

    assign rs = (fwd_rs == 2'b11) ? data_out : exe_rs;
    assign rt = (fwd_rt == 2'b11) ? data_out : exe_rt;

endmodule
