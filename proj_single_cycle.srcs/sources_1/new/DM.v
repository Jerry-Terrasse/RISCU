`timescale 1ns / 1ps

`include "defines.vh"

module DM(
    input wire [2: 0] op,
    input wire [31: 0] rdo,
    input wire [31: 0] a_i,
    input wire [31: 0] wdi,

    output wire [31: 0] a_o,
    output reg [3: 0] wen,
    output reg [31: 0] wdo,
    output wire [31: 0] rdo_ext
);

always @(*) begin
    if(op == `RAM_W1) begin
        case(adr[1: 0])
            2'b00: begin
                wen = 4'b0001;
                wdo = {24'h0, wdi[7: 0]};
            end
            2'b01: begin
                wen = 4'b0010;
                wdo = {16'h0, wdi[7: 0], 8'h0};
            end
            2'b10: begin
                wen = 4'b0100;
                wdo = {8'h0, wdi[7: 0], 16'h0};
            end
            2'b11: begin
                wen = 4'b1000;
                wdo = {wdi[7: 0], 24'h0};
            end
            default: begin
                wen = 4'b0000;
                wdo = 32'hffffffff;
            end
        endcase
    end else if(op == `RAM_W2) begin
        if(adr[1]) begin
            wen = 4'b1100;
            wdo = {wdi[15: 0], 16'h0};
        end else begin
            wen = 4'b0011;
            wdo = {16'h0, wdi[15: 0]};
        end
    end else if(op == `RAM_W4) begin
        wen = 4'b1111;
        wdo = wdi;
    end else begin
        wen = 4'b0000;
        wdo = 32'h0;
    end
end

always @(*) begin
    if(op == `RAM_R1) begin
        case(adr[1: 0])
            2'b00: rdo_ext = {rdo[7] ? 24'hffffff : 24'h0, rdo[7: 0]};
            2'b01: rdo_ext = {rdo[15] ? 16'hffff : 16'h0, rdo[15: 8]};
            2'b10: rdo_ext = {rdo[23] ? 8'hff : 8'h0, rdo[23: 16]};
            2'b11: rdo_ext = {rdo[31] ? 8'hff : 8'h0, rdo[31: 24]};
            default: rdo_ext = 32'hffffffff;
        endcase
    end else if(op == `RAM_R2) begin
        if(adr[1]) begin
            rdo_ext = {rdo[15] ? 16'hffff : 16'h0, rdo[31: 16]};
        end else begin
            rdo_ext = {rdo[15] ? 16'hffff : 16'h0, rdo[15: 0]};
        end
    end else if(op == `RAM_U1) begin
        case(adr[1: 0])
            2'b00: rdo_ext = {24'h0, rdo[7: 0]};
            2'b01: rdo_ext = {24'h0, rdo[15: 8]};
            2'b10: rdo_ext = {24'h0, rdo[23: 16]};
            2'b11: rdo_ext = {24'h0, rdo[31: 24]};
            default: rdo_ext = 32'hffffffff;
        endcase
    end else if(op == `RAM_U2) begin
        if(adr[1]) begin
            rdo_ext = {16'h0, rdo[31: 16]};
        end else begin
            rdo_ext = {16'h0, rdo[15: 0]};
        end
    end else begin
        rdo_ext = rdo;
    end
end

assign a_o = {a_i[31: 2], 2'h0};

endmodule