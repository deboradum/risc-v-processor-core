`include "instructionMemory.v"

module IF_Stage(
    input clk, // Clock signal.
    input reset, // 1 if PC needs to be reset, 0 otherwise.
    input PCSrc, // 1 if the PC should be jumped, 0 otherwise.
    input[31:0] newPC, // New PC value if branch needs to be taken.
    output[31:0] pc_ID, // Wire that contains PC value.
    output[31:0] instruction // Instruction
);
    wire[31:0] instruction_IF;
    reg[31:0] pcR, instructionR;
    wire[31:0] pc_intrl;

    // PC Mux.
    assign pc_intrl = PCSrc ? newPC : pcR + 4;

    // Instruction memory module.
    instructionMemory IM(.reset(reset), .address(pc_intrl), .instruction(instruction_IF));

    assign pc_ID = pcR;
    assign instruction = instructionR;

    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0) begin
            pcR <= 0;
            instructionR <= 0;
        end
        else begin
            pcR <= pc_intrl;
            instructionR <= instruction_IF;
        end
    end

endmodule