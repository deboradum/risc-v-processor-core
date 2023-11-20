# risc-v-processor-core
A simple RISC V core written in Verilog for an Asic Design class during my Electrical Engineering minor at Korea University.
The core is five-stage pipelined and has a hazard forwarding unit to prevent data hazards.

The core is able to parse the following instructions: `add`, `sub`, `and`, `or`, `sll`, `srl`, `sra`, `beq`, `bne`, `lw`, `addi`, `ori`, `andi` & `sw`.

Instructions should be provided in a `instructions.hex` file, which will be loaded in memory by the register file.
Due to the lacking of a memory compiler, main memory is handled by a large array of 8 bit bitstrings.
