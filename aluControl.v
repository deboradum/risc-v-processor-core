`include "parameters.vh"

module ALUControl(
    input[2:0] func3,
    input[6:0] func7,
    input[1:0] ALUOp,
    output[3:0] alu_function
);
assign alu_function = (ALUOp == 2'b00) ?    `ALU_ADD : // LW, SW
                      (ALUOp[0] == 1'b1) ?  `ALU_SUBTRACT : // BEQ
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0000000) && (func3 == 3'b000)) ? `ALU_ADD :
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0100000) && (func3 == 3'b000)) ? `ALU_SUBTRACT :
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0000000) && (func3 == 3'b111)) ? `ALU_AND :
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0000000) && (func3 == 3'b110)) ? `ALU_OR :
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0000000) && (func3 == 3'b001)) ? `ALU_SLL :
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0000000) && (func3 == 3'b101)) ? `ALU_SRL :
                      ((ALUOp[1] == 1'b1) && (func7 == 7'b0100000) && (func3 == 3'b101)) ? `ALU_SRA :
                      ((ALUOp[1] == 1'b1) && (func3 == 3'b000)) ? `ALU_ADD : // ADDI
                      ((ALUOp[1] == 1'b1) && (func3 == 3'b111)) ? `ALU_AND : // ANDI
                      ((ALUOp[1] == 1'b1) && (func3 == 3'b110)) ? `ALU_OR : // ORI
                      1'bx;

endmodule