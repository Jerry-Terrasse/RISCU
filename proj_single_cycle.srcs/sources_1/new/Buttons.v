`timescale 1ns / 1ps

`include "defines.vh"

module Buttons(
    input wire [4: 0] btn,
    output wire [31: 0] rdata
);

assign rdata = {27'h0, btn[4: 0]};

endmodule