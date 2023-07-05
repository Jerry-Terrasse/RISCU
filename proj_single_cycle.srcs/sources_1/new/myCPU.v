`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

wire [31: 0] pc;
assign inst_addr = pc[13: 0];

Controller u_controller(.inst(inst[31: 15]));

wire alu_f;
wire [31: 0] ext;
NPC u_npc(.pc(pc), .offset(ext), .br(alu_f), .op(u_controller.npc_op));

wire [31: 0] alu_c;
wire [31: 0] pc_din = u_controller.pc_sel==`PC_NPC ? u_npc.npc : alu_c;
PC u_pc(.rst(cpu_rst), .clk(cpu_clk), .din(pc_din), .pc(pc));

SEXT u_sext(.op(u_controller.sext_op), .din(inst[31: 7]), .ext(ext));

wire [31: 0] dram_rdo;
reg [31: 0] rf_wd;
always @(*) begin
    case(u_controller.rf_wsel)
        `RF_ALUC: rf_wd = alu_c;
        `RF_ALUF: rf_wd = alu_f;
        `RF_DRAM: rf_wd = dram_rdo;
        `RF_SEXT: rf_wd = ext;
        `RF_PC_4: rf_wd = u_npc.pc4;
        `RF_PC_B: rf_wd = u_npc.pcb;
        default: rf_wd = 32'h0;
    endcase
end
RF u_rf(
    .rst(cpu_rst), .clk(cpu_clk),
    .rR1(inst[19:15]), .rR2(inst[24:20]),
    .wR(inst[11:7]), .wD(rf_wd), .we(u_controller.rf_we)
);

wire [31: 0] alu_b = u_controller.alub_sel==`ALUB_RS2 ? u_rf.rD2 : ext;
ALU u_alu(.op(u_controller.alu_op), .A(u_rf.rD1), .B(alu_b), .C(alu_c));
assign alu_f = u_controller.br_sel==`BR_SIGN ? u_alu.sf : u_alu.zf;

DRAM u_dram(
    .a(alu_c), .spo(dram_rdo),
    .d(u_rf.rD2), .clk(cpu_clk), .we(u_controller.ram_we)
);

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1;
    assign debug_wb_pc        = pc_din;
    assign debug_wb_ena       = u_controller.rf_we;
    assign debug_wb_reg       = inst[11:7];
    assign debug_wb_value     = rf_wd;
`endif

endmodule
