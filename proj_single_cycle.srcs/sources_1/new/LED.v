`timescale 1ns / 1ps

`include "defines.vh"

module LED(
    input wire rst,
    input wire clk,

    input wire wen,
    input wire [31: 0] wdata,

    output reg [23: 0] led
);

always @(posedge rst or posedge clk) begin
    if(rst)
        led <= 24'h000000;
    else if(wen)
        led <= wdata[23: 0];
    else
        led <= led;
end

endmodule