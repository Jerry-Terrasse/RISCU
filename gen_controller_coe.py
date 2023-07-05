import csv
import sys

'''
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

// ram_we
`define RAM_WE 1'b1
`define RAM_NO 1'b0
'''


signal: dict[str, int] = {
    'PC_NPC': 0b0,
    'PC_ALU': 0b1,
    'NPC_PC4': 0b00,
    'NPC_BR1': 0b01,
    'NPC_BR0': 0b10,
    'NPC_JMP': 0b11,
    'BR_SIGN': 0b0,
    'BR_ZERO': 0b1,
    'RF_WE': 0b1,
    'RF_RD': 0b0,
    'RF_ALUC': 0b000,
    'RF_ALUF': 0b001,
    'RF_DRAM': 0b010,
    'RF_SEXT': 0b011,
    'RF_PC_4': 0b100,
    'RF_PC_B': 0b101,
    'SEXT_R': 0b000,
    'SEXT_I': 0b001,
    'SEXT_S': 0b010,
    'SEXT_B': 0b011,
    'SEXT_U': 0b100,
    'SEXT_J': 0b101,
    'ALU_ADD': 0b0000,
    'ALU_SUB': 0b0001,
    'ALU_AND': 0b0010,
    'ALU_OR': 0b0011,
    'ALU_XOR': 0b0100,
    'ALU_SLL': 0b0101,
    'ALU_SRL': 0b0110,
    'ALU_SRA': 0b0111,
    'ALU_SLT': 0b1000,
    'ALU_SLTU': 0b1001,
    'ALUB_RS2': 0b0,
    'ALUB_EXT': 0b1,
    'RAM_WE': 0b1,
    'RAM_RD': 0b0,
    'RAM_NO': 0b0,
}

class Instruction:
    def __init__(self, data: list[str]) -> None:
        self.name = data[1]
        self.opcode = data[2]
        if len(self.opcode) < 7:
            self.opcode = '0' * (7 - len(self.opcode)) + self.opcode
        self.funct3 = data[3] if data[3] != '-' else None
        if self.funct3 and len(self.funct3) < 3:
            self.funct3 = '0' * (3 - len(self.funct3)) + self.funct3
        self.funct7 = data[4] if data[4] != '-' else None
        if self.funct7 and len(self.funct7) < 7:
            self.funct7 = '0' * (7 - len(self.funct7)) + self.funct7
        if self.funct7:
            self.funct7 = self.funct7[1]
        self.pc_sel = 0 if data[5] == '-' else signal[data[5]]
        self.npc_op = 0 if data[6] == '-' else signal[data[6]]
        self.br_sel = 0 if data[7] == '-' else signal[data[7]]
        self.rf_we = 0 if data[8] == '-' else signal[data[8]]
        self.rf_wsel = 0 if data[9] == '-' else signal[data[9]]
        self.sext_op = 0 if data[10] == '-' else signal[data[10]]
        self.alu_op = 0 if data[11] == '-' else signal[data[11]]
        self.alub_sel = 0 if data[12] == '-' else signal[data[12]]
        self.ram_we = 0 if data[13] == '-' else signal[data[13]]
        self.signal = f"{self.pc_sel:01b}{self.npc_op:02b}{self.br_sel:01b}{self.rf_we:01b}{self.rf_wsel:03b}{self.sext_op:03b}{self.alu_op:04b}{self.alub_sel:01b}{self.ram_we:01b}"
        

def work(file_name: str):
    with open(file_name, newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        lines = [line for line in reader]
    lines = lines[3: -2]
    # print(lines)
    insts: list[Instruction] = []
    for line in lines:
        inst = Instruction(line)
        insts.append(inst)
    
    ROM = []
    for i in range(0b1101111_111_1 + 1):
        code = f"{i:011b}"
        opcode = code[:7]
        funct3 = code[7:10]
        funct7 = code[10]
        for inst in insts:
            if opcode != inst.opcode:
                continue
            if inst.funct3 and funct3 != inst.funct3:
                continue
            if inst.funct7 and funct7 != inst.funct7:
                continue
            ROM.append(inst.signal)
            break
        else:
            ROM.append('0' * 17)
    print("add:", ROM[0b0110011_000_0]) # add
    print("srai:", ROM[0b0010011_101_1]) # srai
    print("jal:", ROM[0b1101111_000_0]) # jal
    
    with open("controller.coe", "w", encoding='utf-8') as f:
        f.write("memory_initialization_radix=2;\n")
        f.write("memory_initialization_vector=\n")
        output = ',\n'.join(ROM)
        f.write(output)
        f.write(";")
    with open("controller.bin", "wb") as f:
        for inst in ROM:
            f.write(int(inst, 2).to_bytes(4, byteorder='big'))

if __name__ == '__main__':
    file_name = sys.argv[1]
    work(file_name)