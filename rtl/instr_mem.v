`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: instruction memory

`include "define.vh"

module instr_mem(
    input               clk     ,
    input               rce     ,
    input               stall   ,
    input               flush   ,
    input       [31:0]  iaddr   ,
    
    output  reg [31:0]  instr
);

    reg [31:0] instructions [255:0];

    initial begin
        instr <= 0;
        $readmemh(`IMEM_FILE_PATH, instructions);
    end

    always @(posedge clk) begin
        if (stall) begin
            instr <= instr;
        end
        else if (flush) begin
            instr <= 0;
        end
        else if (rce) begin
            instr <= instructions[iaddr[9:2]];
        end
        else begin
            instr <= 0;
        end
    end

endmodule
