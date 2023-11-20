module MEM_Stage(
    input clk, // Clock signal.
    input reset, // Reset signal.
    input[31:0] address, // ALU result from EX stage.
    input[31:0] writeData_MEM,
    input[2:0] func3_MEM, // For determining if branch should be taken. (Other way possible??)
    input[4:0] rd_MEM,
    input MemToReg_MEM,
    input RegWrite_MEM,
    input MemRead_MEM, // MEM control signal.
    input MemWrite_MEM, // MEM control signal.
    input branch_op_MEM, // MEM control signal.
    input isZero,// If equality is 0 (For determining PCSrc).
    input[31:0] newPC_MEM,
    output[4:0] rd_WB,
    output[31:0] readData,
    output[31:0] alu_writeback_data_WB,
    output PCSrc,
    output MemToReg_WB,
    output RegWrite_WB,
    output[31:0] newPC_IF
);
    // Internal regs and wires.
    wire[31:0] readData_itrnl;
    wire PCSrc_itrnl;
    reg[31:0] readData_r, alu_writeback_data_WB_r, newPC_IF_r;
    reg[4:0] rd_WB_r;
    reg PCSrc_r, MemToReg_WB_r, RegWrite_WB_r;

    // Main memory.
    reg[7:0] mainMemory[0:2047];
    integer i;
    initial begin
       for (i = 0; i < 2048 ; i = i + 1) begin
            mainMemory[i] <= 8'b00000000;
        end
    end

    // MM reading.
    assign readData_itrnl = (reset == 1'b0) ? 0 :
                      MemRead_MEM ? {mainMemory[address], mainMemory[address+1], mainMemory[address+2], mainMemory[address+3]} : 
                      32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

    // 1 if branch should be taken, 0 otherwise.
    assign PCSrc_itrnl = (reset == 1'b0) ? 1'b0 :
                   (branch_op_MEM && func3_MEM == 3'b000 && isZero) ? 1'b1 :
                   (branch_op_MEM && func3_MEM == 3'b001 && !isZero) ? 1'b1 :
                   1'b0;

    assign rd_WB = rd_WB_r;
    assign readData = readData_r;
    assign alu_writeback_data_WB = alu_writeback_data_WB_r;
    assign PCSrc = PCSrc_r;
    assign MemToReg_WB = MemToReg_WB_r;
    assign RegWrite_WB = RegWrite_WB_r;
    assign newPC_IF = newPC_IF_r;

    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0) begin
            rd_WB_r <= 5'b00000;
            readData_r <= 0;
            alu_writeback_data_WB_r <= 0;
            PCSrc_r <= 1'b0;
            MemToReg_WB_r <= 1'b0;
            RegWrite_WB_r <= 1'b0;
            newPC_IF_r <= 0;
        end
        else begin
            rd_WB_r <= rd_MEM;
            readData_r <= readData_itrnl;
            alu_writeback_data_WB_r <= address;
            PCSrc_r <= PCSrc_itrnl;
            MemToReg_WB_r <= MemToReg_MEM;
            RegWrite_WB_r <= RegWrite_MEM;
            newPC_IF_r <= newPC_MEM;
            if (MemWrite_MEM) begin
                mainMemory[address] <= writeData_MEM[31:24];
                mainMemory[address+1] <= writeData_MEM[23:16];
                mainMemory[address+2] <= writeData_MEM[15:8];
                mainMemory[address+3] <= writeData_MEM[7:0];
            end
        end
    end

endmodule