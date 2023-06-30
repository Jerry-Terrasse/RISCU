`timescale 1ns / 1ps

`include "defines.vh"

module RF(
    input wire rst,
    input wire clk,
    input wire [4: 0] rR1,
    input wire [4: 0] rR2,

    input wire [4: 0] wR,
    input wire we,
    input wire [31: 0] wD,

    output reg [31: 0] rD1,
    output reg [31: 0] rD2
);

reg [31: 0] rf [31: 0];

always @(*) begin
    rD1 = rf[rR1];
    rD2 = rf[rR2];
end

always @(posedge rst or posedge clk) begin
    if(rst) begin
        rf <= 1024'h0;
    end else begin
        if(we == `RF_WE && wR != 5'h0) begin
            rf[wR] <= wD;
        end
    end
end

endmodule