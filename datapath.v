`include "IF_Stage.v"
`include "ID_Stage.v"
`include "EX_Stage.v"
`include "MEM_Stage.v"
`include "WB_Stage.v"
`include "HazardForwardingUnit.v"

module datapath(
    input clock,
    input reset
);
    wire PCSrc, RegWrite_WB, ALUSrc_EX, MemToReg_EX, RegWrite_EX, MemRead_EX, MemWrite_EX, branch_op_EX, isZero, MemToReg_MEM, RegWrite_MEM, MemRead_MEM, MemWrite_MEM, branch_op_MEM, MemToReg_WB;
    wire[1:0] ALUOp_EX, forwardA, forwardB;
    wire[2:0] func3_EX, func3_MEM;
    wire[4:0] rd_WB, rd_EX, rd_MEM, rd_ID, rs1_H, rs2_H;
    wire[6:0] func7;
    wire[31:0] newPC_IF, PC_ID, instruction, writeData_ID, imm, rs1Data, rs2Data, PC_EX, newPC_MEM, alu_result, writeData_MEM, readData, alu_writeback_data_WB;

    IF_Stage IF(.clk(clock), .reset(reset), .PCSrc(PCSrc), .newPC(newPC_IF),
                .pc_ID(PC_ID), .instruction(instruction));

    ID_Stage ID(.clk(clock), .reset(reset), .RegWrite_WB(RegWrite_WB), .rd_ID(rd_ID), .writeData_ID(writeData_ID), .instruction(instruction), .PC_ID(PC_ID),
                .final_imm(imm), .rs1Data(rs1Data), .rs2Data(rs2Data), .func3_EX(func3_EX), .func7(func7), .rd_EX(rd_EX), .PC_EX(PC_EX), .ALUSrc_EX(ALUSrc_EX), .MemToReg_EX(MemToReg_EX), .RegWrite_EX(RegWrite_EX), .MemRead_EX(MemRead_EX), .MemWrite_EX(MemWrite_EX), .branch_op_EX(branch_op_EX), .ALUOp_EX(ALUOp_EX), .rs1_H(rs1_H), .rs2_H(rs2_H));

    EX_Stage EX(.clk(clock), .reset(reset), .ALUSrc_EX(ALUSrc_EX), .ALUOp_EX(ALUOp_EX), .MemToReg_EX(MemToReg_EX), .RegWrite_EX(RegWrite_EX), .MemRead_EX(MemRead_EX), .MemWrite_EX(MemWrite_EX), .branch_op_EX(branch_op_EX), .func3_EX(func3_EX), .rd_EX(rd_EX), .func7(func7), .rs1Data(rs1Data), .rs2Data(rs2Data), .imm(imm), .currPC(PC_EX), .writeData_ID(writeData_ID), .forwardA(forwardA), .forwardB(forwardB),
                .func3_MEM(func3_MEM), .newPC_MEM(newPC_MEM), .result(alu_result), .writeData_MEM(writeData_MEM), .isZero(isZero), .MemToReg_MEM(MemToReg_MEM), .RegWrite_MEM(RegWrite_MEM), .MemRead_MEM(MemRead_MEM), .MemWrite_MEM(MemWrite_MEM), .branch_op_MEM(branch_op_MEM), .rd_MEM(rd_MEM));

    MEM_Stage MEM(.clk(clock), .reset(reset), .address(alu_result), .writeData_MEM(writeData_MEM), .func3_MEM(func3_MEM), .rd_MEM(rd_MEM), .MemToReg_MEM(MemToReg_MEM), .RegWrite_MEM(RegWrite_MEM), .MemRead_MEM(MemRead_MEM), .MemWrite_MEM(MemWrite_MEM), .branch_op_MEM(branch_op_MEM), .isZero(isZero), .newPC_MEM(newPC_MEM),
                  .rd_WB(rd_WB), .readData(readData), .alu_writeback_data_WB(alu_writeback_data_WB), .PCSrc(PCSrc), .MemToReg_WB(MemToReg_WB), .RegWrite_WB(RegWrite_WB), .newPC_IF(newPC_IF));

    WB_Stage WB(.readData(readData), .alu_result(alu_writeback_data_WB), .MemToReg_WB(MemToReg_WB), .RegWrite_WB(RegWrite_WB), .rd_WB(rd_WB),
                .writeData_ID(writeData_ID), .rd_ID(rd_ID));

    HazardForwardingUnit HFW(.reset(reset), .RegWrite_MEM(RegWrite_MEM), .RegWrite_WB(RegWrite_WB), .rd_MEM(rd_MEM), .rd_WB(rd_WB), .rs1(rs1_H), .rs2(rs2_H),
                             .forwardA(forwardA), .forwardB(forwardB));
endmodule