`timescale 1ns / 1ps

`include "defines.vh"

module DM(
    input wire [2: 0] op,
    input wire [31: 0] rdo,

    output reg [3: 0] wen,
    output wire [31: 0] rdo_ext
);

always @(*) begin
    case(op)
        `RAM_W1: wen = 4'b0001;
        `RAM_W2: wen = 4'b0011;
        `RAM_W4: wen = 4'b1111;
        default: wen = 4'b0000;
    endcase
end

always @(*) begin
    case(op)
        `RAM_R1: rdo_ext = {rdo[7] ? 24'hffffff : 24'h0, rdo[7: 0]};
        `RAM_R2: rdo_ext = {rdo[15] ? 16'hffff : 16'h0, rdo[15: 0]};
        `RAM_U1: rdo_ext = {24'h0, rdo[7: 0]};
        `RAM_U2: rdo_ext = {16'h0, rdo[15: 0]};
        default: rdo_ext = rdo;
    endcase
end

endmodule