module WB_Stage(
    input clk, // Clock signal.
    input reset, // Reset signal.
    input[31:0] readData,
    input[31:0] alu_result,
    input MemToReg_WB, // WB control signal.
    input RegWrite_WB, // WB control signal.
    input[4:0] rd_WB,
    output[31:0] writeData_ID,
    output[4:0] rd_ID
);
    assign writeData_ID = MemToReg_WB ? readData : alu_result;
    assign rd_ID = rd_WB;
endmodule