`timescale 1ns / 1ps
// date: 2020/12/22
// by: kun
// description: register file

`include "./define.vh"

module regfile(
    input           clk     ,
    input           rst_n   ,
    input   [ 4:0]  wa      ,
    input           we      ,
    input   [31:0]  wd      ,

    input   [ 4:0]  rsa, rta,
    output  [31:0]  rsd, rtd
);

    reg [31:0] reg_data [31:0];

    initial begin
        $readmemh(`REG_FILE_PATH, reg_data);
    end

    always@(negedge clk) begin
        begin
            if (we && (|wa)) begin // reg $0 cannot be modified
                reg_data[wa] <= wd;
            end
        end
    end

    assign rsd = reg_data[rsa];
    assign rtd = reg_data[rta];

endmodule
