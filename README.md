# sp2004

_32-bit RISC Processor Implemented on FPGA_

sp2004 processor has 41 instructions, 32-bit data and address buses, 32 32-bit registers, 4-stage pipeline, data forwarding, branch prediction, interrupt handler, and Harvard memory architecture. It is implemented on Xilinx Spartan 2 FPGA and an additional Xilinx XC95108 CPLD for the I/O controller. The processor and I/O controller are written in VHDL. They are successfully tested on 12.5MHz clock speed. sp2004 assembler is also developed using C to convert sp2004 assembly language into binary code.

![Processor Schematic](https://github.com/ekaakurniawan/sp2004/raw/master/Design/fig14_processor_schematic.jpg)
