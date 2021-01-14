`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: cpu implementation

module cpu_impl(
    input           clk             ,
    input           rst_n           ,

    output  [31:0]  debug_wb_pc     ,
    output          debug_wb_rf_wen ,
    output  [ 4:0]  debug_wb_rf_addr,
    output  [31:0]  debug_wb_rf_wdata
);

    // instr_fetch
    wire        rce;
    wire [31:0] if_pc, if_npc;

    // predict
    wire        if_pred_branch;
    wire        if_pred_taken;
    wire [31:0] if_pred_npc;
    wire        flush;

    // instr_mem
    wire [31:0] instr;

    // ifid_reg
    wire [31:0] id_pc, id_npc;
    wire        id_pred_branch;
    wire        id_pred_taken;
    wire [31:0] id_pred_npc;

    // instr_decode
    wire [31:0] id_imm;
    wire [ 5:0] id_op;
    wire [10:0] id_func;
    wire [ 4:0] id_rwa, id_rsa, id_rta;
    wire        id_mux_1, id_mux_2, id_mux_3;
    wire        id_wce, id_drce, id_dwce;
    wire [ 1:0] fwd_rs, fwd_rt;
    wire        stall;

    // regfile
    wire [31:0] reg_rs, reg_rt;

    // redirect
    wire [31:0] id_rs, id_rt;

    // redirect_exe
    wire [31:0] exe_rs_real, exe_rt_real;

    // id_exe_reg
    wire [31:0] exe_pc, exe_npc;
    wire [31:0] exe_imm;
    wire [31:0] exe_rs, exe_rt;
    wire [31:0] exe_instr;
    wire [ 5:0] exe_op;
    wire [10:0] exe_func;
    wire [ 4:0] exe_rwa, exe_rsa, exe_rta;
    wire        exe_wce;
    wire        exe_mux_1, exe_mux_2, exe_mux_3;
    wire        exe_drce, exe_dwce;
    wire        exe_pred_branch;
    wire        exe_pred_taken;
    wire [31:0] exe_pred_npc;

    // exe
    wire [31:0] exe_alu_out;
    wire        exe_rs_re, exe_rt_re;
    wire        ex_is_branch;
    wire        ex_is_cond;
    wire        ex_is_taken;
    wire [31:0] ex_target;

    // exemem_reg
    wire        mem_mux_3;
    wire        mem_drce, mem_dwce;
    wire        mem_wce;
    wire [ 5:0] mem_op;
    wire [31:0] mem_pc;
    wire [31:0] mem_alu_out;
    wire [31:0] mem_rt;
    wire [ 4:0] mem_rwa;

    // mem
    wire [15:0] data_addr;

    // data_mem
    wire [31:0] mem_data;

    // memwb_reg
    wire [31:0] wb_pc;
    wire [31:0] wb_alu_out;
    wire [ 5:0] wb_op;
    wire [ 4:0] wb_rwa;
    wire        wb_mux_3;
    wire        wb_wce;

    // write_back
    wire [31:0] write_data;

    assign debug_wb_pc          =   wb_pc;
    assign debug_wb_rf_wen      =   wb_wce;
    assign debug_wb_rf_addr     =   wb_rwa;
    assign debug_wb_rf_wdata    =   write_data;

    instr_fetch U_if(
        .clk    (clk            ),
        .rst_n  (rst_n          ),
        .stall  (stall          ),
        .pc_in  (if_pred_npc    ),
        .pc     (if_pc          ),
        .rce    (rce            ),
        .npc    (if_npc         )
    );


    predict U_predict(
        .clk            (clk            ),
        .if_pc          (if_pc          ),
        .ex_pc          (exe_pc         ),
        .ex_pred_branch (exe_pred_branch),
        .ex_pred_taken  (exe_pred_taken ),
        .ex_pred_npc    (exe_pred_npc   ),
        .ex_is_branch   (ex_is_branch   ),
        .ex_is_cond     (ex_is_cond     ),
        .ex_is_taken    (ex_is_taken    ),
        .ex_target      (ex_target      ),
        .if_pred_branch (if_pred_branch ),
        .if_pred_taken  (if_pred_taken  ),
        .if_pred_npc    (if_pred_npc    ),
        .flush          (flush          )
    );


    instr_mem U_instr_mem(
        .clk    (clk),
        .iaddr  (if_pc),
        .rce    (rce),
        .flush  (flush),
        .stall  (stall),
        .instr  (instr)
    );


    ifid_reg U_ifid_reg(
        .clk            (clk            ),
        .rst_n          (rst_n          ),
        .stall          (stall          ),
        .flush          (flush          ),
        .if_pc          (if_pc          ),
        .if_npc         (if_npc         ),
        .if_pred_branch (if_pred_branch ),
        .if_pred_taken  (if_pred_taken  ),
        .if_pred_npc    (if_pred_npc    ),
        .id_pc          (id_pc          ),
        .id_npc         (id_npc         ),
        .id_pred_branch (id_pred_branch ),
        .id_pred_taken  (id_pred_taken  ),
        .id_pred_npc    (id_pred_npc    )
    );


    instr_decode U_id(
        .instr      (instr      ),
        .rst_n      (rst_n      ),
        .exe_rwa    (exe_rwa    ),
        .mem_rwa    (mem_rwa    ),
        .wb_rwa     (wb_rwa     ),
        .exe_wce    (exe_wce    ),
        .mem_wce    (mem_wce    ),
        .wb_wce     (wb_wce     ),
        .exe_op     (exe_op     ),
        .mem_op     (mem_op     ),
        .wb_op      (wb_op      ),
        .exe_rsa    (exe_rsa    ),
        .exe_rta    (exe_rta    ),
        .exe_rs_re  (exe_rs_re  ),
        .exe_rt_re  (exe_rt_re  ),
        .imm        (id_imm     ),
        .op         (id_op      ),
        .func       (id_func    ),
        .rwa        (id_rwa     ),
        .rsa        (id_rsa     ),
        .rta        (id_rta     ),
        .wce        (id_wce     ),
        .mux_1      (id_mux_1   ),
        .mux_2      (id_mux_2   ),
        .mux_3      (id_mux_3   ),
        .dwce       (id_dwce    ),
        .drce       (id_drce    ),
        .fwd_rs     (fwd_rs     ),
        .fwd_rt     (fwd_rt     ),
        .stall      (stall      )
    );

    regfile U_reg(
        .clk    (clk        ),
        .rst_n  (rst_n      ),
        .wa     (wb_rwa     ),
        .we     (wb_wce     ),
        .wd     (write_data ),
        .rsa    (id_rsa     ),
        .rta    (id_rta     ),
        .rsd    (reg_rs     ),
        .rtd    (reg_rt     )
    );

    redirect U_redirect(
        .exe_alu_out    (exe_alu_out),
        .mem_alu_out    (mem_alu_out),
        .reg_rs         (reg_rs     ),
        .reg_rt         (reg_rt     ),
        .fwd_rs         (fwd_rs     ),
        .fwd_rt         (fwd_rt     ),
        .rs             (id_rs      ),
        .rt             (id_rt      )
    );

    redirect_exe U_redirect_exe(
        .data_out   (mem_data   ),
        .exe_rs     (exe_rs     ),
        .exe_rt     (exe_rt     ),
        .fwd_rs     (fwd_rs     ),
        .fwd_rt     (fwd_rt     ),
        .rs         (exe_rs_real),
        .rt         (exe_rt_real)
    );

    idexe_reg U_idexe_reg(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .stall      (stall      ),
        .flush      (flush      ),
        .id_pc      (id_pc      ),
        .id_npc     (id_npc     ),
        .id_imm     (id_imm     ),
        .id_rs      (id_rs      ),
        .id_rt      (id_rt      ),
        .id_instr   (instr      ),
        .id_op      (id_op      ),
        .id_func    (id_func    ),
        .id_rwa     (id_rwa     ),
        .id_rsa     (id_rsa     ),
        .id_rta     (id_rta     ),
        .id_wce     (id_wce     ),
        .id_mux_1   (id_mux_1   ),
        .id_mux_2   (id_mux_2   ),
        .id_mux_3   (id_mux_3   ),
        .id_dwce    (id_dwce    ),
        .id_drce    (id_drce    ),
        .id_pred_branch (id_pred_branch ),
        .id_pred_taken  (id_pred_taken  ),
        .id_pred_npc    (id_pred_npc    ),
        .exe_pc     (exe_pc     ),
        .exe_npc    (exe_npc    ),
        .exe_imm    (exe_imm    ),
        .exe_rs     (exe_rs     ),
        .exe_rt     (exe_rt     ),
        .exe_instr  (exe_instr  ),
        .exe_op     (exe_op     ),
        .exe_func   (exe_func   ),
        .exe_rwa    (exe_rwa    ),
        .exe_rsa    (exe_rsa    ),
        .exe_rta    (exe_rta    ),
        .exe_wce    (exe_wce    ),
        .exe_mux_1  (exe_mux_1  ),
        .exe_mux_2  (exe_mux_2  ),
        .exe_mux_3  (exe_mux_3  ),
        .exe_dwce   (exe_dwce   ),
        .exe_drce   (exe_drce   ),
        .exe_pred_branch(exe_pred_branch),
        .exe_pred_taken (exe_pred_taken ),
        .exe_pred_npc   (exe_pred_npc   )
    );

    exe U_exe(
        .rs         (exe_rs_real),
        .rt         (exe_rt_real),
        .imm        (exe_imm    ),
        .npc        (exe_npc    ),
        .op         (exe_op     ),
        .func       (exe_func   ),
        .mux_1      (exe_mux_1  ),
        .mux_2      (exe_mux_2  ),
        .alu_out    (exe_alu_out),
        .exe_rs_re  (exe_rs_re  ),
        .exe_rt_re  (exe_rt_re  ),
        .ex_is_branch(ex_is_branch),
        .ex_is_cond (ex_is_cond ),
        .ex_is_taken(ex_is_taken),
        .ex_target  (ex_target  )
    );

    exemem_reg U_exemem_reg(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .exe_mux_3  (exe_mux_3  ),
        .exe_drce   (exe_drce   ),
        .exe_dwce   (exe_dwce   ),
        .exe_wce    (exe_wce    ),
        .exe_op     (exe_op     ),
        .exe_pc     (exe_pc     ),
        .exe_alu_out(exe_alu_out),
        .exe_rt     (exe_rt     ),
        .exe_rwa    (exe_rwa    ),
        .mem_mux_3  (mem_mux_3  ),
        .mem_drce   (mem_drce   ),
        .mem_dwce   (mem_dwce   ),
        .mem_wce    (mem_wce    ),
        .mem_op     (mem_op     ),
        .mem_pc     (mem_pc     ),
        .mem_alu_out(mem_alu_out),
        .mem_rt     (mem_rt     ),
        .mem_rwa    (mem_rwa    )
    );

    mem U_mem(
        .alu_out    (mem_alu_out),
        .data_addr  (data_addr  )
    );

    data_mem U_data_mem(
        .clk        (clk        ),
        .dwce       (mem_dwce   ),
        .drce       (mem_drce   ),
        .daddr      (data_addr  ),
        .data_in    (mem_rt     ),
        .data_out   (mem_data   )
    );

    memwb_reg U_memwb_reg(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .mem_pc     (mem_pc     ),
        .mem_alu_out(mem_alu_out),
        .mem_rwa    (mem_rwa    ),
        .mem_mux_3  (mem_mux_3  ),
        .mem_wce    (mem_wce    ),
        .mem_op     (mem_op     ),
        .wb_pc      (wb_pc      ),
        .wb_alu_out (wb_alu_out ),
        .wb_rwa     (wb_rwa     ),
        .wb_mux_3   (wb_mux_3   ),
        .wb_wce     (wb_wce     ),
        .wb_op      (wb_op      )
    );

    write_back U_write_back(
        .mux_3      (wb_mux_3   ),
        .mem_data   (mem_data   ),
        .alu_out    (wb_alu_out ),
        .write_data (write_data )
    );

endmodule
