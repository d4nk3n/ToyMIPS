# ToyMIPS
ToyMIPS is my implementation of a MIPS processor with five-stage pipeline and branch predication, used in HIT Computer Architecture Labs of the year 2020.

Supports 10 instructions, tested under Xilinx ISE.

## Description
* ```rtl```: Verilog code of the MIPS processor, with gshare and BTB(in ```predict.v```). The initialization files of the instruction memory and data memory are under folder ```data```.
* ```test```: Verilog test fixture.
* ```tool```: Python tool to convert the assembly language to machine code.
