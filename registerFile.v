module registerFile(
    input clk,
    input reset,
    input RegWrite, // 1 if we should write to a register, 0 otherwise.
    input[31:0] data, // Data that should be written.
    input[4:0] rs1, // Read register 1.
    input[4:0] rs2, // Read register 2.
    output[4:0] rd, // register that should be written to.
    output[31:0] rs1Data, // Data from read register 1.
    output[31:0] rs2Data // Data from read register 2.
);
    reg[31:0] registers[0:31];
    initial begin
        for (i = 0; i < 32 ; i = i + 1) begin
            registers[i] <= 0;
        end
    end

    assign rs1Data = registers[rs1];
    assign rs2Data = registers[rs2];

    integer i;
    always @(posedge clk) begin
        if (reset == 1'b0) begin
            for (i = 0; i < 32 ; i = i + 1) begin
                registers[i] <= 0;
            end
        end
        else begin 
            if (RegWrite && (rd != 0)) begin
                registers[rd] <= data;
            end
        end
    end
endmodule