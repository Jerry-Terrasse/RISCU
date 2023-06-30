`timescale 1ns / 1ps

`include "defines.vh"

module PC(
    input wire rst,
    input wire clk,
    input wire [29: 0] din,

    output reg [31: 0] pc
);

always @(posedge rst or posedge clk) begin
    if(rst) begin
        pc <= 32'h0;
    end else begin
        pc <= {din, 2'h0};
    end
end

endmodule