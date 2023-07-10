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
    output reg [3: 0] ram_we
);

wire [17: 0] rom_data;
Controller_ROM u_controller_rom(.a(inst), .spo(rom_data));

assign pc_sel = rom_data[17];
assign npc_op = rom_data[16: 15];
assign br_sel = rom_data[14];
assign rf_we = rom_data[13];
assign rf_wsel = rom_data[12: 10];
assign sext_op = rom_data[8: 7];
assign alu_op = rom_data[6: 3];
assign alub_sel = rom_data[2];

wire [1: 0] ram_we_compressed rom_data[1: 0];

always @(*) begin
    case(ram_we_compressed)
        `RAM_NO: ram_we = 4'b0000;
        `RAM_W1: ram_we = 4'b0001;
        `RAM_W2: ram_we = 4'b0011;
        `RAM_W4: ram_we = 4'b1111;
        `default: ram_we = 4'b0000;
    endcase
end

endmodule