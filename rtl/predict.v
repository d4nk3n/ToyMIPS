`timescale 1ns / 1ps
// date:        2021/01/12
// by:          kun
// name:        predict
// description: the module makes branch prediction

module predict(
    input           clk             ,
    input   [31:0]  if_pc           ,
    input   [31:0]  ex_pc           ,
    input           ex_pred_branch  ,
    input           ex_pred_taken   ,
    input   [31:0]  ex_pred_npc     ,
    input           ex_is_branch    ,
    input           ex_is_cond      ,
    input           ex_is_taken     ,
    input   [31:0]  ex_target       ,

    output          if_pred_branch  ,
    output          if_pred_taken   ,
    output  [31:0]  if_pred_npc     ,
    output          flush
);
    // pattern history table
    reg [ 1:0]  pht [ 255:0];

    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin
            initial begin
                pht[i] <= 2'b0;
            end
        end
    endgenerate


    // global history register
    reg [ 7:0]  ghr;

    initial begin
        ghr <= 8'b0;
    end


    // BTB entry structure:
    // bit:     |65   65|64    64|63     32|31     0|
    // field:   | valid |  type  | address | target |
    // description:
    //  --valid:    entry valid
    //  --type:     0 --> unconditional, 1 --> conditional
    //  --address:  branch instruction pc
    //  --target:   branch instruction target pc
    reg [65:0]  btb [1023:0];

    generate
        genvar j;
        for (j = 0; j < 1024; j = j + 1) begin
            initial begin
                btb[j] <= 66'b0;
            end
        end
    endgenerate



    wire [ 9:0] if_btb_index;
    wire [65:0] if_sel_btb_entry;
    wire        if_btb_valid;
    wire        if_btb_type;
    wire [31:0] if_btb_address;
    wire [31:0] if_btb_target;
    wire        if_btb_hit;

    assign if_btb_index     = if_pc[11:2];
    assign if_sel_btb_entry = btb[if_btb_index];
    assign if_btb_valid     = if_sel_btb_entry[65];
    assign if_btb_type      = if_sel_btb_entry[64];
    assign if_btb_address   = if_sel_btb_entry[63:32];
    assign if_btb_target    = if_sel_btb_entry[31:0];
    assign if_btb_hit       = (if_btb_valid) && (if_btb_address == if_pc);


    wire [ 7:0] if_pht_index;
    wire [ 1:0] if_sel_pht_entry;

    assign if_pht_index     = ghr ^ if_pc[9:2];
    assign if_sel_pht_entry = pht[if_pht_index];


    assign if_pred_branch   = if_btb_hit;
    assign if_pred_taken    = if_btb_hit && (if_btb_type == 1'b0 || if_sel_pht_entry[1]);
    assign if_pred_npc      = flush ?   (ex_is_taken    ? ex_target     : (ex_pc + 4)) :
                                        (if_pred_taken  ? if_btb_target : (if_pc + 4));


    wire [ 9:0] ex_btb_index;
    wire [ 7:0] ex_pht_index;

    assign ex_btb_index     = ex_pc[11:2];
    assign ex_pht_index     = ghr ^ ex_pc[9:2];


    // update ghr
    always @(posedge clk) begin
        if (ex_is_branch && ex_is_cond) begin
            ghr <= {ghr[6:0], ex_is_taken};
        end
    end

    // update btb
    always @(posedge clk) begin
        if (ex_is_branch) begin
            btb[ex_btb_index] <= {1'b1, ex_is_cond, ex_pc, ex_target};
        end
    end

    // update ght
    always @(posedge clk) begin
        if (ex_is_branch && ex_is_cond) begin
            if (ex_is_taken) begin
                pht[ex_pht_index] <= (pht[ex_pht_index] == 2'b11) ? 2'b11 : pht[ex_pht_index] + 2'b1;
            end
            else begin
                pht[ex_pht_index] <= (pht[ex_pht_index] == 2'b00) ? 2'b00 : pht[ex_pht_index] - 2'b1;
            end
        end
    end

    // When resolving a branch, the pipeline is flushed under any of the following conditions:
    // (1). The instruction is a branch, but it was not recognized as a branch (i.e., BTB miss)
    // (2). The instruction is a branch, and it is taken, but the predicted destination (target) does not 
    //      match the actual destination
    // (3). The instruction is a branch, but the predicted direction does not match the actual direction.

    assign flush =  (!ex_pred_branch) && (ex_is_branch) ||
                    (ex_is_branch) && (ex_is_taken) && (ex_pred_npc != ex_target) ||
                    (ex_is_branch) && (ex_pred_taken != ex_is_taken);

endmodule
