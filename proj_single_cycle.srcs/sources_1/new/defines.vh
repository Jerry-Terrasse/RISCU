`ifndef CPU_DEFINES
`define CPU_DEFINES

// Annotate this macro before synthesis
// `define RUN_TRACE

`define ONBOARD_TRACE

// 控制信号

// pc_sel
`define PC_NPC 1'b0
`define PC_ALU 1'b1

// npc_op
`define NPC_PC4 2'b00
`define NPC_BR1 2'b01
`define NPC_BR0 2'b10
`define NPC_JMP 2'b11

// br_sel
`define BR_SIGN 1'b0
`define BR_ZERO 1'b1

// rf_we
`define RF_WE 1'b1
`define RF_RD 1'b0

// rf_wsel
`define RF_ALUC 3'b000
`define RF_ALUF 3'b001
`define RF_DRAM 3'b010
`define RF_SEXT 3'b011
`define RF_PC_4 3'b100
`define RF_PC_B 3'b101

// sext_op
`define SEXT_R 3'b000
`define SEXT_I 3'b001
`define SEXT_S 3'b010
`define SEXT_B 3'b011
`define SEXT_U 3'b100
`define SEXT_J 3'b101

// alu_op
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR  4'b0011
`define ALU_XOR 4'b0100
`define ALU_SLL 4'b0101
`define ALU_SRL 4'b0110
`define ALU_SRA 4'b0111
`define ALU_SLT 4'b1000
`define ALU_SLTU 4'b1001

// alub_sel
`define ALUB_RS2 1'b0
`define ALUB_EXT 1'b1

// ram_mode
`define RAM_NO 3'b000
`define RAM_W1 3'b101
`define RAM_W2 3'b110
`define RAM_W4 3'b111
`define RAM_R4 3'b000
`define RAM_R2 3'b001
`define RAM_R1 3'b010
`define RAM_U2 3'b011
`define RAM_U1 3'b100

// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078

`endif