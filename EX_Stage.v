`include "parameters.vh"
`include "aluControl.v"

module EX_Stage(
    input clk, // Clock signal.
    input reset, // Reset signal.
    input ALUSrc_EX, // EX control signal.
    input[1:0] ALUOp_EX, // EX control signal.
    input MemToReg_EX,
    input RegWrite_EX,
    input MemRead_EX,
    input MemWrite_EX,
    input branch_op_EX,
    input[2:0] func3_EX,
    input[4:0] rd_EX,
    input[6:0] func7,
    input[31:0] rs1Data,
    input[31:0] rs2Data,
    input[31:0] imm,
    input[31:0] currPC, // For pc adder.
    input[31:0] writeData_ID, // For hazards.
    input[1:0] forwardA, // From Hazarding unit.
    input[1:0] forwardB, // From Hazarding unit.
    output[2:0] func3_MEM,
    output[31:0] newPC_MEM, // For pc adder
    output[31:0] result,
    output[31:0] writeData_MEM,
    output isZero,
    output MemToReg_MEM,
    output RegWrite_MEM,
    output MemRead_MEM,
    output MemWrite_MEM,
    output branch_op_MEM,
    output[4:0] rd_MEM
);
    // Internal regs and wires.
    reg[2:0] func3_MEM_r;
    reg isZero_r, MemToReg_MEM_r, RegWrite_MEM_r,MemRead_MEM_r, MemWrite_MEM_r, branch_op_MEM_r;
    reg[31:0] rd_MEM_r, writeData_MEM_r, newPC_MEM_r, result_r;
    wire isZero_itrnl;
    wire[31:0] x, y, newPC_MEM_itrnl, result_itrnl, hazard_B_mux;
    wire[3:0] alu_function;

    // Hazard mux x.
    assign x = (reset == 1'b0)     ? 32'b00000000000000000000000000000000 :
               (forwardA == 2'b00) ? rs1Data :
               (forwardA == 2'b01) ? writeData_ID :
               (forwardA == 2'b10) ? result_itrnl :
               32'b00000000000000000000000000000000;

    // Hazard mux y.
    assign hazard_B_mux = (reset == 1'b0)     ? 32'b00000000000000000000000000000000 :
                 (forwardB == 2'b00) ? rs2Data :
                 (forwardB == 2'b01) ? writeData_ID :
                 (forwardB == 2'b10) ? result_itrnl :
                 32'b00000000000000000000000000000000;

    // ALUSrc mux.
    assign y = ALUSrc_EX ? imm : hazard_B_mux;

    // ALU control module.
    ALUControl ac(.func3(func3_EX), .func7(func7), .ALUOp(ALUOp_EX), .alu_function(alu_function));

    // ALU arithmatic unit
    assign result_itrnl = (reset == 1'b0)                 ? 32'b00000000000000000000000000000000 :
                          (alu_function == `ALU_ADD)      ?   x + y :
                          (alu_function == `ALU_SUBTRACT) ?   x - y :
                          (alu_function == `ALU_AND)      ?   x & y :
                          (alu_function == `ALU_OR)       ?   x | y :
                          (alu_function == `ALU_SRL)      ?   x >> y[4:0] : // [4:0] because that is the maximum shift amount
                          (alu_function == `ALU_SLL)      ?   x << y[4:0] : // [4:0] because that is the maximum shift amount
                          (alu_function == `ALU_SRA)      ?   $unsigned($signed(x) >>> y) : // ?
                          32'b00000000000000000000000000000000;

    // Zero signal used for branching.
    assign isZero_itrnl = (reset == 1'b0) ? 0 : result_itrnl == 0; // 1 if result is zero, 0 otherwise.

    // New PC adder.
    assign newPC_MEM_itrnl = (reset == 1'b0) ? 32'b00000000000000000000000000000000 :
                             currPC + imm;

    assign func3_MEM = func3_MEM_r;
    assign newPC_MEM = newPC_MEM_r;
    assign result = result_r;
    assign writeData_MEM = writeData_MEM_r;
    assign isZero = isZero_r;
    assign MemToReg_MEM = MemToReg_MEM_r;
    assign RegWrite_MEM = RegWrite_MEM_r;
    assign MemRead_MEM = MemRead_MEM_r;
    assign MemWrite_MEM = MemWrite_MEM_r;
    assign branch_op_MEM = branch_op_MEM_r;
    assign rd_MEM = rd_MEM_r;

    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0) begin
            func3_MEM_r <= 3'b000;
            newPC_MEM_r <= 0;
            result_r <= 0;
            writeData_MEM_r <= 0;
            isZero_r <= 1'b0;
            MemToReg_MEM_r <= 1'b0;
            RegWrite_MEM_r <= 1'b0;
            MemRead_MEM_r <= 1'b0;
            MemWrite_MEM_r <= 1'b0;
            branch_op_MEM_r <= 1'b0;
            rd_MEM_r <= 1'b0;
        end
        else begin
            func3_MEM_r <= func3_EX;
            newPC_MEM_r <= newPC_MEM_itrnl;
            result_r <= result_itrnl;
            writeData_MEM_r <= hazard_B_mux;
            isZero_r <= isZero_itrnl;
            MemToReg_MEM_r <= MemToReg_EX;
            RegWrite_MEM_r <= RegWrite_EX;
            MemRead_MEM_r <= MemRead_EX;
            MemWrite_MEM_r <= MemWrite_EX;
            branch_op_MEM_r <= branch_op_EX;
            rd_MEM_r <= rd_EX;
        end
    end
endmodule