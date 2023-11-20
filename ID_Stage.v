`include "parameters.vh"
`include "mainControl.v"
`include "registerFile.v"

module ID_Stage(
    input clk, // Clock signal.
    input reset, // Reset signal.
    input RegWrite_WB,
    input[4:0] rd_ID, // Write register.
    input[31:0] writeData_ID,
    input[31:0] instruction, // Instruction to decode.
    input[31:0] PC_ID,
    output[31:0] final_imm, // immediate value for I types.
    output[31:0] rs1Data,
    output[31:0] rs2Data,
    output[2:0] func3_EX, // For ALU control
    output[6:0] func7, // For ALU control
    output[4:0] rd_EX,
    output[31:0] PC_EX,
    output ALUSrc_EX, // From mainControl
    output MemToReg_EX, // From mainControl
    output RegWrite_EX, // From mainControl
    output MemRead_EX, // From mainControl
    output MemWrite_EX, // From mainControl
    output branch_op_EX, // From mainControl
    output[1:0] ALUOp_EX, // From mainControl
    output[4:0] rs1_H, // For hazarding unit
    output[4:0] rs2_H // For hazarding unit
);
    // Internal regs and wires.
    reg ALUSrc_EX_r, MemToReg_EX_r, RegWrite_EX_r, MemRead_EX_r, MemWrite_EX_r, branch_op_EX_r;
    reg[4:0] rd_EX_r, rs1_H_r, rs2_H_r;
    reg[1:0] ALUOp_EX_r;
    reg[31:0] PC_EX_r, rs1Data_r, rs2Data_r, final_imm_r;
    reg[2:0] func3_EX_r;
    reg[6:0] func7_r;
    wire ALUSrc_EX_itrnl, MemToReg_EX_itrnl, RegWrite_EX_itrnl, MemWrite_EX_itrnl, MemRead_EX_itrnl, branch_op_EX_itrnl;
    wire[1:0] ALUOp_EX_itrnl;
    wire[31:0] rs1Data_itrnl, rs2Data_itrnl, final_imm_itrnl;
    wire[6:0] opcode;

    // Opcode assignment.
    assign opcode = instruction[6:0];

    // Main control module.
    mainControl mc(.reset(reset), .opcode(opcode), 
                   .regDst(regDst_EX), .ALUSrc(ALUSrc_EX_itrnl), .MemToReg(MemToReg_EX_itrnl), 
                   .RegWrite(RegWrite_EX_itrnl), .MemRead(MemRead_EX_itrnl), .MemWrite(MemWrite_EX_itrnl), 
                   .branch_op(branch_op_EX_itrnl), .ALUOp(ALUOp_EX_itrnl));

    // Registerfile module.
    registerFile rf(.clk(clk), .reset(reset), .RegWrite(RegWrite_WB), .data(writeData_ID), 
                    .rs1(instruction[19:15]), .rs2(instruction[24:20]), 
                    .rd(rd_ID), .rs1Data(rs1Data_itrnl), .rs2Data(rs2Data_itrnl));

    // immediate generator
    wire[31:0] imm_i = { {20{instruction[31]}}, instruction[31:20] };
    wire[31:0] imm_s = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
    wire[31:0] imm_sb = { { 20{ instruction[31] } }, instruction[31:25], instruction[11:7] };
    assign final_imm_itrnl = (reset == 1'b0) ? 32'b00000000000000000000000000000000 :
                       (opcode == `ITYPE || opcode == `LWTYPE) ? imm_i : 
                       (opcode == `STYPE) ? imm_s :
                       (opcode == `SBTYPE) ? imm_sb :
                       32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

    assign final_imm = final_imm_r;
    assign rs1Data = rs1Data_r;
    assign rs2Data = rs2Data_r;
    assign func3_EX = func3_EX_r;
    assign func7 = func7_r;
    assign PC_EX = PC_EX_r;
    assign rd_EX = rd_EX_r;
    assign ALUSrc_EX = ALUSrc_EX_r;
    assign MemToReg_EX = MemToReg_EX_r;
    assign RegWrite_EX = RegWrite_EX_r;
    assign MemRead_EX = MemRead_EX_r;
    assign MemWrite_EX = MemWrite_EX_r;
    assign branch_op_EX = branch_op_EX_r;
    assign ALUOp_EX = ALUOp_EX_r;
    assign rs1_H = rs1_H_r;
    assign rs2_H = rs2_H_r;

    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0) begin
            final_imm_r <= 0;
            rs1Data_r <= 0;
            rs2Data_r <= 0;
            PC_EX_r <= 0;
            func3_EX_r <= 3'b000;
            func7_r <= 7'b0000000;
            rd_EX_r <= 5'b00000;
            ALUSrc_EX_r <= 0;
            MemToReg_EX_r <= 0;
            RegWrite_EX_r <= 0;
            MemRead_EX_r <= 0;
            MemWrite_EX_r <= 0;
            branch_op_EX_r <= 0;
            ALUOp_EX_r <= 0;
            rs1_H_r <= 5'b00000;
            rs2_H_r <= 5'b00000;
        end
        else begin
            final_imm_r <= final_imm_itrnl;
            rs1Data_r <= rs1Data_itrnl;
            rs2Data_r <= rs2Data_itrnl;
            PC_EX_r <= PC_ID;
            func3_EX_r <= instruction[14:12];
            func7_r <= instruction[31:25];
            rd_EX_r <= instruction[11:7];
            ALUSrc_EX_r <= ALUSrc_EX_itrnl;
            MemToReg_EX_r <= MemToReg_EX_itrnl;
            RegWrite_EX_r <= RegWrite_EX_itrnl;
            MemRead_EX_r <= MemRead_EX_itrnl;
            MemWrite_EX_r <= MemWrite_EX_itrnl;
            branch_op_EX_r <= branch_op_EX_itrnl;
            ALUOp_EX_r <= ALUOp_EX_itrnl;
            rs1_H_r <= instruction[19:15];
            rs2_H_r <= instruction[24:20];
        end
    end
endmodule