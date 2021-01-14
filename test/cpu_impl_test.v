`timescale 1ns / 1ps

module cpu_impl_test;

    // Inputs
    reg clk;
    reg rst_n;

    // Outputs
    wire [31:0] debug_wb_pc;
    wire debug_wb_rf_wen;
    wire [4:0] debug_wb_rf_addr;
    wire [31:0] debug_wb_rf_wdata;

    // Instantiate the Unit Under Test (UUT)
    cpu_impl uut (
        .clk                (clk                ), 
        .rst_n              (rst_n              ), 
        .debug_wb_pc        (debug_wb_pc        ), 
        .debug_wb_rf_wen    (debug_wb_rf_wen    ), 
        .debug_wb_rf_addr   (debug_wb_rf_addr   ), 
        .debug_wb_rf_wdata  (debug_wb_rf_wdata  )
    );

    initial begin
        clk     = 0;
        rst_n   = 0;

        #100;
        rst_n   = 1;
    end
    
    always #5 clk = ~clk;

endmodule
