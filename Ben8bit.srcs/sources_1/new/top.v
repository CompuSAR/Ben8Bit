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


module top(
    output [7:0] out,
    input clock,
    input bReset
    );

localparam BusIn_None = 0;
localparam BusIn_PC = 1;
localparam BusIn_RegA = 2;
localparam BusIn_ALU = 3;
localparam BusIn_RegB = 4;

localparam BusIn_MemoryAddress = 5;
localparam BusIn_Memory = 6;
localparam BusIn_InstructionRegister = 7;
localparam BusIn_NumOptions = 8;

wire [7:0]bus;
reg [$clog2(BusIn_NumOptions-1)-1:0] bus_selector;

wire [7:0]bus_inputs[BusIn_NumOptions-1:0];
assign bus = bus_inputs[bus_selector];

assign bus_inputs[BusIn_None] = 0;

wire [3:0]program_counter_value;
register#(.DataBits(4)) program_counter(
    .data_in( program_counter_value+1 ),
    .data_out( program_counter_value ),
    .clock(clock),
    .write_enable(program_counter_update),
    .bReset(bReset)
);
assign bus_inputs[BusIn_PC] = {{4{0}}, program_counter_value};

register reg_a(
    .data_in(bus),
    .data_out(bus_inputs[BusIn_RegA]),
    .clock(clock),
    .write_enable(register_a_write),
    .bReset(bReset)
);

wire carry_flag_value, zero_flag_value;
alu alu(
    .a(bus_inputs[BusIn_RegA]),
    .b(bus_inputs[BusIn_RegB]),
    .result(bus_inputs[BusIn_ALU]),
    .sub_bAdd(alu_subtract),
    .carry_flag(carry_flag_value),
    .zero_flag(zero_flag_value)
);

register reg_b(
    .data_in(bus),
    .data_out(bus_inputs[BusIn_RegB]),
    .clock(clock),
    .write_enable(register_b_write),
    .bReset(bReset)
);
register reg_out(
    .data_in(bus),
    .data_out(out),
    .clock(clock),
    .write_enable(register_out_write),
    .bReset(bReset)
);

wire [7:0]instruction_register_data;
register instruction_register(
    .data_in(bus),
    .data_out(instruction_register_data),
    .clock(clock),
    .write_enable(instruction_register_write),
    .bReset(bReset)
);
assign bus_inputs[BusIn_InstructionRegister] = {{4{0}}, instruction_register_data[3:0]};

// Control lines
reg program_counter_update;
reg register_a_write;
reg alu_subtract;
reg register_b_write;
reg register_out_write;
reg intruction_register_write;

// Flags
reg carry_flag;
reg zero_flag;

initial
    reset_everything();

task reset_everything();
begin
    reset_controls();
    carry_flag <= 0;
    zero_flag <= 0;
end
endtask

task reset_controls();
begin
    bus_selector <= BusIn_None;
    program_counter_update <= 0;
    register_a_write <= 0;
    alu_subtract <= 0;
    register_b_write <= 0;
    register_out_write <= 0;
end
endtask

endmodule
