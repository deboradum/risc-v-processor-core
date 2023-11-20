module HazardForwardingUnit(
    input reset,
    input RegWrite_MEM,
    input RegWrite_WB,
    input[4:0] rd_MEM,
    input[4:0] rd_WB,
    input[4:0] rs1,
    input[4:0] rs2,
    output[1:0] forwardA,
    output[1:0] forwardB
);

    assign forwardA = (reset == 1'b0) ? 0 :
                      ((RegWrite_MEM == 1'b1) && (rd_MEM == rs1) && (rd_MEM !=  2'b00)) ? 2'b10 :
                      ((RegWrite_WB == 1'b1) && (rd_WB == rs1) && (rd_WB !=  2'b00)) ? 2'b01 :
                      2'b00;
    assign forwardB = (reset == 1'b0) ? 0 :
                      ((RegWrite_MEM == 1'b1) && (rd_MEM == rs2) && (rd_MEM !=  2'b00)) ? 2'b10 :
                      ((RegWrite_WB == 1'b1) && (rd_WB == rs2) && (rd_WB !=  2'b00)) ? 2'b01 :
                      2'b00;
endmodule