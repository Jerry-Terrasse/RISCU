`timescale 1ns / 1ps

`include "defines.vh"

module SEXT(
    input wire [2: 0] op,
    input wire [24: 0] din, // inst[31: 7]

    output reg [31: 0] ext
);

always @(*) begin
    case(op)
        `SEXT_R: ext = 32'h0;
        `SEXT_I: ext = {din[24] ? 20'hfffff: 20'h0, din[24: 13]};
        `SEXT_S: ext = {din[24] ? 20'hfffff: 20'h0, din[24: 18], din[4: 0]};
        `SEXT_B: ext = {din[24] ? 19'h7ffff: 19'h0, din[24], din[0], din[23: 18], din[4: 1], 1'b0};
        `SEXT_U: ext = {din, 12'h0};
        `SEXT_J: ext = {din[24] ? 11'h3ff: 11'h0, din[24], din[12: 5], din[13], din[23: 14], 1'b0};
    endcase
end

endmodule