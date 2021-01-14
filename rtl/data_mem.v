`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: data memory

`include "./define.vh"

module data_mem(
    input               clk         ,
    input               dwce, drce  ,
    input       [15:0]  daddr       ,
    input       [31:0]  data_in     ,
    
    output  reg [31:0]  data_out
);

    reg [31:0] mem [255:0];

    initial begin
        $readmemh(`DMEM_FILE_PATH, mem);
        data_out <= `ZERO_WORD;
    end

    always @(posedge clk) begin
        if (drce) begin
            data_out <= mem[daddr[7:0]];
        end
        else begin
            data_out <= `ZERO_WORD;
        end
        if (dwce) begin
            mem[daddr[7:0]] <= data_in;
        end
    end

endmodule
