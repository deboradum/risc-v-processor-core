`include "parameters.vh"

module mainControl(
    input reset,
    input[6:0] opcode,
    output regDst,
    output ALUSrc,
    output MemToReg,
    output RegWrite,
    output MemRead,
    output MemWrite,
    output branch_op,
    output [1:0] ALUOp
);
    reg regDstR, ALUSrcR, MemToRegR, RegWriteR, MemReadR, MemWriteR, branch_opR;
    reg [1:0] ALUOpR;
    assign regDst = regDstR;
    assign ALUSrc = ALUSrcR;
    assign MemToReg = MemToRegR;
    assign RegWrite = RegWriteR;
    assign MemRead = MemReadR;
    assign MemWrite = MemWriteR;
    assign branch_op = branch_opR;
    assign ALUOp = ALUOpR;
    // Control unit.
    always @(*) begin
        if (reset == 1'b0) begin
            regDstR <= 1'b0;
            branch_opR <= 1'b0;
            MemReadR <= 1'b0;
            MemToRegR <= 1'b0;
            MemWriteR <= 1'b0;
            ALUSrcR <= 1'b0;
            RegWriteR <= 1'b0;
            ALUOpR <= 2'b00;
        end
        else begin
        case (opcode)
            `RTYPE: begin
                regDstR <= 1;
                branch_opR <= 0;
                MemReadR <= 0;
                MemToRegR <= 0;
                MemWriteR <= 0;
                ALUSrcR <= 0;
                RegWriteR <= 1;
                ALUOpR <= 2'b10;
            end
            `LWTYPE: begin // TODO
                regDstR <= 0;
                branch_opR <= 0;
                MemReadR <= 1;
                MemToRegR <= 1;
                MemWriteR <= 0;
                ALUSrcR <= 1;
                RegWriteR <= 1;
                ALUOpR <= 2'b00;
            end
            `ITYPE: begin
                regDstR <= 1;
                branch_opR <= 0;
                MemReadR <= 0;
                MemToRegR <= 0;
                MemWriteR <= 0;
                ALUSrcR <= 1;
                RegWriteR <= 1;
                ALUOpR <= 2'b10; // ?
            end
            `STYPE: begin
                regDstR <= 1'bx;
                branch_opR <= 0;
                MemReadR <= 0;
                MemToRegR <= 1'bx;
                MemWriteR <= 1;
                ALUSrcR <= 1;
                RegWriteR <= 0;
                ALUOpR <= 2'b00;
            end
            `SBTYPE: begin
                regDstR <= 1'bx;
                branch_opR <= 1;
                MemReadR <= 0;
                MemToRegR <= 1'bx;
                MemWriteR <= 0;
                ALUSrcR <= 0;
                RegWriteR <= 0;
                ALUOpR <= 2'b01;
            end
            default: begin
                regDstR <= 1'b0;
                branch_opR <= 1'b0;
                MemReadR <= 1'b0;
                MemToRegR <= 1'b0;
                MemWriteR <= 1'b0;
                ALUSrcR <= 1'b0;
                RegWriteR <= 1'b0;
                ALUOpR <= 2'b00;
            end
        endcase
        end
    end

endmodule