`define BusIn_None 0
`define BusIn_PC 1
`define BusIn_RegA 2
`define BusIn_ALU 3
`define BusIn_RegB 4

`define BusIn_MemoryAddress 5
`define BusIn_Memory 6
`define BusIn_InstructionRegister 7

`define BusIn_NumOptions 8

`define BusSelectorBits $clog2(`BusIn_NumOptions-1)