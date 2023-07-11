`timescale 1ns / 1ps

`include "defines.vh"

module MaskedDRAM(
    input wire clk,
    input wire [13: 0] a,
    input wire [3: 0] we,
    input wire [31: 0] d,
    output wire [31: 0] spo
);

    DRAM0 u_dram_0(.clk(clk), .a(a), .we(we[0]), .d(d[7: 0]), .spo(spo[7: 0]));
    DRAM1 u_dram_1(.clk(clk), .a(a), .we(we[1]), .d(d[15: 8]), .spo(spo[15: 8]));
    DRAM2 u_dram_2(.clk(clk), .a(a), .we(we[2]), .d(d[23:16]), .spo(spo[23:16]));
    DRAM3 u_dram_3(.clk(clk), .a(a), .we(we[3]), .d(d[31:24]), .spo(spo[31:24]));

endmodule