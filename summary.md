# 各个部件的接口信号、位宽、功能描述

## 算数逻辑单元 ALU

```verilog
module ALU(
    input wire [31: 0] A,
    input wire [31: 0] B,
    input wire [3: 0] op,

    output reg [31: 0] C,
    output reg zf,
    output reg sf
);
```

|接口|位宽|功能描述|
|-|-|-|
|A|32|输入端口A|
|B|32|输入端口B|
|op|4|操作码|
|C|32|输出端口C|
|zf|1|零标志位|
|sf|1|符号标志位|

## 控制器 Controller

```verilog
module Controller(
    input wire [10: 0] inst,
    
    output wire pc_sel,
    output wire [1: 0] npc_op,
    output wire br_sel,
    output wire rf_we,
    output wire [2: 0] rf_wsel,
    output wire [2: 0] sext_op,
    output wire [3: 0] alu_op,
    output wire alub_sel,
    output wire [2: 0] ram_mode
);
```

|接口|位宽|功能描述|
|-|-|-|
|inst|11|必要的指令相关位|
|pc_sel|1|PC选择信号|
|npc_op|2|NPC控制信号|
|br_sel|1|分支选择信号|
|rf_we|1|寄存器写使能|
|rf_wsel|3|寄存器写选择信号|
|sext_op|3|符号扩展控制信号|
|alu_op|4|ALU操作码|
|alub_sel|1|ALU第二个操作数选择信号|
|ram_mode|3|RAM读写控制信号|

## 主存控制器 DM

```verilog
module DM(
    input wire [2: 0] op,
    input wire [31: 0] rdo,
    input wire [31: 0] a_i,
    input wire [31: 0] wdi,

    output wire [31: 0] a_o,
    output reg [3: 0] wen,
    output reg [31: 0] wdo,
    output reg [31: 0] rdo_ext
);
```

|接口|位宽|功能描述|
|-|-|-|
|op|3|操作码|
|rdo|32|读数据（自DRAM）|
|a_i|32|地址输入（未对齐）|
|wdi|32|写数据（自CPU）|
|a_o|32|地址输出（对齐）|
|wen|4|写使能|
|wdo|32|写数据（至DRAM）|
|rdo_ext|32|读数据（符号扩展，至CPU）|

## 寄存器堆 Register File

```verilog
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
```

|接口|位宽|功能描述|
|-|-|-|
|rst|1|复位信号|
|clk|1|时钟信号|
|rR1|5|读端口1地址|
|rR2|5|读端口2地址|
|wR|5|写端口地址|
|we|1|写使能|
|wD|32|写数据|
|rD1|32|读端口1数据|
|rD2|32|读端口2数据|

## PC

```verilog
module PC(
    input wire rst,
    input wire clk,
    input wire [29: 0] din,

    output reg [31: 0] pc
);
```

|接口|位宽|功能描述|
|-|-|-|
|rst|1|复位信号|
|clk|1|时钟信号|
|din|30|输入数据（低2位默认为0）|
|pc|32|输出数据|

## 程序计数器生成器 NPC

```verilog
module NPC(
    input wire [29: 0] pc,
    input wire [29: 0] offset,
    input wire br,
    input wire [1: 0] op,

    output reg [29: 0] npc,
    output wire [31: 0] pc4,
    output wire [31: 0] pcb
);
```

|接口|位宽|功能描述|
|-|-|-|
|pc|30|输入PC|
|offset|30|输入偏移量|
|br|1|分支信号|
|op|2|NPC控制信号|
|npc|30|输出NPC|
|pc4|32|输出PC+4|
|pcb|32|输出PC+偏移量|

## 符号扩展器 SEXT

```verilog
module SEXT(
    input wire [2: 0] op,
    input wire [24: 0] din, // inst[31: 7]

    output reg [31: 0] ext
);
```

|接口|位宽|功能描述|
|-|-|-|
|op|3|操作码|
|din|25|输入数据|
|ext|32|输出数据|