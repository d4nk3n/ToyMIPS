`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: exe module

`include "./define.vh"

module exe(
    input   [31:0]  rs, rt, imm, npc    ,
    input   [ 5:0]  op                  ,
    input   [10:0]  func                ,
    input           mux_1, mux_2        ,
    
    output  [31:0]  alu_out             ,
    output          exe_rs_re, exe_rt_re,
    output          ex_is_branch        ,
    output          ex_is_cond          ,
    output          ex_is_taken         ,
    output  [31:0]  ex_target
);

    wire    [5:0]   func_6;
    wire    [31:0]  alu_a, alu_b;
    reg     [31:0]  alu_result;

    assign  exe_rs_re   = (op != `OP_J);
    assign  exe_rt_re   = (op == `OP_R || op == `OP_SW || op == `OP_BEQ);

    assign  alu_a   = mux_1 ? npc : rs;
    assign  alu_b   = mux_2 ? imm : rt;
    assign  alu_out = alu_result;
    assign  func_6  = func[5:0];

    always @(*) begin
    case (op)
    `OP_R:  case (func_6)
                `FUNC_ADD:  alu_result <= alu_a + alu_b;
                `FUNC_SUB:  alu_result <= alu_a - alu_b;
                `FUNC_AND:  alu_result <= alu_a & alu_b;
                `FUNC_OR:   alu_result <= alu_a | alu_b;
                `FUNC_XOR:  alu_result <= alu_a ^ alu_b;
                `FUNC_SLT:  alu_result <= alu_a < alu_b ? 1 : 0;
                default:    alu_result <= 0;
            endcase
    `OP_LW:  alu_result <= alu_a + alu_b;
    `OP_SW:  alu_result <= alu_a + alu_b;
    `OP_BEQ: alu_result <= alu_a + alu_b;
    `OP_J:   alu_result <= alu_b;
    default: alu_result <= 0;
    endcase
    end

    assign ex_is_branch = (op == `OP_BEQ) || (op == `OP_J);
    assign ex_is_cond   = (op == `OP_BEQ);
    assign ex_is_taken  = (op == `OP_J) || (op == `OP_BEQ && rs == rt);
    assign ex_target    = alu_out;

endmodule
