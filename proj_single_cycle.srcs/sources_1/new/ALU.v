`timescale 1ns / 1ps

`include "defines.vh"

module ALU(
    input wire [31: 0] A,
    input wire [31: 0] B,
    input wire [3: 0] op,

    output reg [31: 0] C,
    output reg zf,
    output reg sf
);
// TODO: 进行优化，实现组件复用

/*
// alu_op
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR  4'b0011
`define ALU_XOR 4'b0100
`define ALU_SLL 4'b0101
`define ALU_SRL 4'b0110
`define ALU_SRA 4'b0111
`define ALU_SLT 4'b1000
`define ALU_SLTU 4'b1001
*/

reg [31: 0] minuend;
reg [31: 0] subtrahend;
reg [31: 0] difference;

always @(*) begin
    if(op == `ALU_SLTU) begin
        minuend = {~A[31], A[30: 0]};
        subtrahend = {~B[31], B[30: 0]};
    end else begin
        minuend = A;
        subtrahend = B;
    end
end

always @(*) difference = minuend - subtrahend;

always @(*) begin
    case(op)
        `ALU_ADD: C = A + B;
        `ALU_SUB: C = difference;
        `ALU_AND: C = A & B;
        `ALU_OR:  C = A | B;
        `ALU_XOR: C = A ^ B;
        `ALU_SLL: C = A << B[4: 0];
        `ALU_SRL: C = A >> B[4: 0];
        `ALU_SRA: begin
            if(B[4: 0] == 0) begin
                C = A;
            end else if(A[31] == 0) begin
                C = A >> B[4: 0];
            end else begin
                C = (A >> B[4: 0]) | ((32'b1 << B[4: 0]) - 1) << (32 - B[4: 0]);
            end
        end
        `ALU_SLT: C = difference;
        `ALU_SLTU: C = difference;
        default: C = A;
    endcase
end

always @(*) zf = (C == 0);

always @(*) begin
    if(op == `ALU_SLT || op == `ALU_SLTU) begin
        if(A[31] == B[31]) begin
            sf = C[31];
        end else begin
            sf = minuend[31];
        end
    end else begin
        sf = C[31];
    end
end

endmodule
