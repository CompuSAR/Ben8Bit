`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2021 06:00:10 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "control.vh"

module top(
    output [7:0] out,
    input clock_in,
    input bReset
);

    wire [7:0]bus;

    wire [7:0]bus_inputs[`BusIn_NumOptions-1:0];
    assign bus = bus_inputs[ctl_bus_selector];

    assign bus_inputs[`BusIn_None] = 0;

    wire clock = clock_in || ctl_hlt;

    wire [3:0]memory_address_value;
    register#(.DataBits(4)) memory_address_register(
        .data_in(bus),
        .data_out(memory_address_value),
        .clock(clock),
        .write_enable(ctl_memory_in),
        .bReset(bReset)
    );

    ram ram(
        .a(memory_address_value),
        .d(bus),
        .clk( clock ),
        .we( ctl_ram_in ),
        .spo( bus_inputs[`BusIn_Memory] )
    );

    wire [7:0]instruction_register_value;
    register instruction_register(
        .data_in(bus),
        .data_out(instruction_register_value),
        .clock(clock),
        .write_enable(ctl_instruction_in),
        .bReset(bReset)
    );
    assign bus_inputs[`BusIn_InstructionRegister] = {4'b0, instruction_register_value[3:0]};

    // Control lines
    wire ctl_hlt;
    wire ctl_memory_in;
    wire ctl_ram_in;
    wire ctl_instruction_in;
    wire ctl_reg_a_in;
    wire ctl_subtract;
    wire ctl_reg_b_in;
    wire ctl_out_in;
    wire ctl_advance_pc;
    wire ctl_pc_in;
    wire ctl_flags_in;
    wire [`BusSelectorBits-1:0]ctl_bus_selector;

    // Flags
    reg carry_flag;
    reg zero_flag;
    control control(
        .instruction(instruction_register_value[7:4]),
        .clock(clock),
        .bReset(bReset),
        .carry_flag(carry_flag),
        .zero_flag(zero_flag),

        // Control lines
        .hlt(ctl_hlt),
        .memory_in(ctl_memory_in),
        .ram_in(ctl_ram_in),
        .instruction_in(ctl_instruction_in),
        .reg_a_in(ctl_reg_a_in),
        .subtract(ctl_subtract),
        .reg_b_in(ctl_reg_b_in),
        .out_in(ctl_out_in),
        .advance_pc(ctl_advance_pc),
        .pc_in(ctl_pc_in),
        .flags_in(ctl_flags_in),
        .bus_selector(ctl_bus_selector)
    );

    wire [3:0]program_counter_value;
    register#(.DataBits(4)) program_counter(
        .data_in( program_counter_value+1 ),
        .data_out( program_counter_value ),
        .clock(clock),
        .write_enable(ctl_advance_pc),
        .bReset(bReset)
    );
    assign bus_inputs[`BusIn_PC] = {4'b0, program_counter_value};

    register reg_a(
        .data_in(bus),
        .data_out(bus_inputs[`BusIn_RegA]),
        .clock(clock),
        .write_enable(ctl_reg_a_in),
        .bReset(bReset)
    );

    wire carry_flag_value, zero_flag_value;
    alu alu(
        .a(bus_inputs[`BusIn_RegA]),
        .b(bus_inputs[`BusIn_RegB]),
        .result(bus_inputs[`BusIn_ALU]),
        .sub_bAdd(ctl_subtract),
        .carry_flag(carry_flag_value),
        .zero_flag(zero_flag_value)
    );

    register reg_b(
        .data_in(bus),
        .data_out(bus_inputs[`BusIn_RegB]),
        .clock(clock),
        .write_enable(ctl_reg_b_in),
        .bReset(bReset)
    );
    register reg_out(
        .data_in(bus),
        .data_out(out),
        .clock(clock),
        .write_enable(ctl_out_in),
        .bReset(bReset)
    );

    initial
    reset_everything();

    task reset_everything();
        begin
            carry_flag <= 0;
            zero_flag <= 0;
        end
    endtask

endmodule
