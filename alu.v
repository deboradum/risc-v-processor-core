`include "parameters.vh"

module ALU(
    input[3:0] alu_function,
    input[31:0] x,
    input[31:0] y,
    output[31:0] result
);
// ALU arithmatic unit
assign result = (alu_function == `ALU_ADD)      ?   x + y :
                (alu_function == `ALU_SUBTRACT) ?   x - y :
                (alu_function == `ALU_AND)      ?   x & y :
                (alu_function == `ALU_OR)       ?   x | y :
                (alu_function == `ALU_SRL)      ?   x >> y[4:0] : // [4:0] because that is the maximum shift amount
                (alu_function == `ALU_SLL)      ?   x << y[4:0] : // [4:0] because that is the maximum shift amount
                (alu_function == `ALU_SRA)      ?   x >>> y[4:0] : // ?
                0;
endmodule