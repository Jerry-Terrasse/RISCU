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
        rf[0] <= 32'h0;
        rf[1] <= 32'h0;
        rf[2] <= 32'h0;
        rf[3] <= 32'h0;
        rf[4] <= 32'h0;
        rf[5] <= 32'h0;
        rf[6] <= 32'h0;
        rf[7] <= 32'h0;
        rf[8] <= 32'h0;
        rf[9] <= 32'h0;
        rf[10] <= 32'h0;
        rf[11] <= 32'h0;
        rf[12] <= 32'h0;
        rf[13] <= 32'h0;
        rf[14] <= 32'h0;
        rf[15] <= 32'h0;
        rf[16] <= 32'h0;
        rf[17] <= 32'h0;
        rf[18] <= 32'h0;
        rf[19] <= 32'h0;
        rf[20] <= 32'h0;
        rf[21] <= 32'h0;
        rf[22] <= 32'h0;
        rf[23] <= 32'h0;
        rf[24] <= 32'h0;
        rf[25] <= 32'h0;
        rf[26] <= 32'h0;
        rf[27] <= 32'h0;
        rf[28] <= 32'h0;
        rf[29] <= 32'h0;
        rf[30] <= 32'h0;
        rf[31] <= 32'h0;
    end else begin
        if(we == `RF_WE && wR != 5'h0) begin
            rf[wR] <= wD;
        end
    end
end

endmodule