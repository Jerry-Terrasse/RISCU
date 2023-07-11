`timescale 1ns / 1ps

`include "defines.vh"

module Switches(
    input wire rst, // 重要，不加rst和clk信号会导致opt_design fail
    input wire clk,
    input wire [11: 0] adr,
    input wire [23: 0] sw,
    output wire [31: 0] rdata
);

assign rdata = {8'h0, sw[23: 0]};

endmodule