`timescale 1ns / 1ps

`include "defines.vh"

module Controller(
    input wire [10: 0] inst,
    
    output wire pc_sel,
    output wire [1: 0] npc_op,
    output wire br_sel,
    output wire rf_we,
    output wire [2: 0] rf_wsel,
    output wire [2: 0] sext_op,
    output wire [3: 0] alu_op,
    output wire alub_sel,
    output wire [2: 0] ram_mode
);

wire [17: 0] rom_data;
Controller_ROM u_controller_rom(.a(inst), .spo(rom_data));

assign pc_sel = rom_data[18];
assign npc_op = rom_data[17: 16];
assign br_sel = rom_data[15];
assign rf_we = rom_data[14];
assign rf_wsel = rom_data[13: 11];
assign sext_op = rom_data[9: 8];
assign alu_op = rom_data[7: 4];
assign alub_sel = rom_data[3];
assign ram_mode = rom_data[2: 0];

endmodule