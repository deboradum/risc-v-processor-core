module instructionMemory(
    input reset,
    input[31:0] address,
    output[31:0] instruction
);
    reg[31:0] instructionMemory[0:2047];
    assign instruction = (reset == 1'b0) ? 32'b00000000000000000000000000000000 :
                         instructionMemory[address[31:2]];

    initial
        $readmemh("instructions.hex", instructionMemory);
endmodule