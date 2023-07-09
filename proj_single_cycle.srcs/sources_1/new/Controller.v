`timescale 1ns / 1ps

`include "defines.vh"

module Controller(
    input wire [10: 0] inst,
    
    output wire pc_sel,
    output wire [1: 0] npc_op,
    output wire br_sel,
    output wire [3: 0] rf_we,
    output wire [2: 0] rf_wsel,
    output wire [2: 0] sext_op,
    output wire [3: 0] alu_op,
    output wire alub_sel,
    output wire ram_we
);

wire [19: 0] rom_data;
Controller_ROM u_controller_rom(.a(inst), .spo(rom_data));

assign pc_sel = rom_data[19];
assign npc_op = rom_data[18: 17];
assign br_sel = rom_data[16];
assign rf_we = rom_data[15: 12];
assign rf_wsel = rom_data[11: 9];
assign sext_op = rom_data[8: 6];
assign alu_op = rom_data[5: 2];
assign alub_sel = rom_data[1];
assign ram_we = rom_data[0];

endmodule