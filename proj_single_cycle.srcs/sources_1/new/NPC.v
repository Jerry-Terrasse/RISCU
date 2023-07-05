`timescale 1ns / 1ps

`include "defines.vh"

module NPC(
    input wire [29: 0] pc,
    input wire [29: 0] offset,
    input wire br,
    input wire [1: 0] op,

    output reg [29: 0] npc,
    output wire [31: 0] pc4,
    output wire [31: 0] pcb
);

assign pc4 = {pc + 30'h1, 2'b00};
assign pcb = {pc + offset, 2'b00};

always @(*) begin
    case(op)
        `NPC_PC4: npc = pc4;
        `NPC_BR1: npc = br ? pcb : pc4;
        `NPC_BR0: npc = br ? pc4 : pcb;
        `NPC_JMP: npc = pcb[31: 2];
    endcase
end

endmodule