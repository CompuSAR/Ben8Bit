`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2021 09:13:34 PM
// Design Name: 
// Module Name: control
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

module control
(
    input [3:0] instruction,
    input clock,
    input bReset,
    input carry_flag,
    input zero_flag,
    output reg hlt,
    output reg memory_in,
    output reg ram_in,
    output reg instruction_in,
    output reg reg_a_in,
    output reg subtract,
    output reg reg_b_in,
    output reg out_in,
    output reg advance_pc,
    output reg pc_in,
    output reg flags_in,
    output reg [`BusSelectorBits-1:0] bus_selector
    );

reg [2:0]step;

initial
    reset_everything();

always@(negedge clock, negedge bReset)
begin
    if( ! bReset ) begin
        reset_everything();
    end else begin
        reset_controls();
        step <= step+1;
        if( step<2 ) begin
            perform_fetch_cycle();
        end else begin
            if( instruction==4'b0000 )
                perform_ins_nop();
            else if( instruction==4'b0001 )
                perform_ins_lda();
            else if( instruction==4'b0010 )
                perform_ins_add();
            else if( instruction==4'b0011 )
                perform_ins_sub();
            else if( instruction==4'b0100 )
                perform_ins_sta();
            else if( instruction==4'b0101 )
                perform_ins_ldi();
            else if( instruction==4'b0110 )
                perform_ins_jmp();
            else if( instruction==4'b1110 )
                perform_ins_out();
            else if( instruction==4'b1111 )
                perform_ins_hlt();
            else
                perform_ins_nop();
        end
    end
end

task perform_fetch_cycle();
begin
    if( step==0 ) begin
        bus_selector <= `BusIn_PC;
        memory_in <= 1;
    end else begin
        bus_selector <= `BusIn_Memory;
        instruction_in <= 1;
        advance_pc <= 1;
    end
end
endtask

task perform_ins_nop();
    step <= 0;
endtask

task perform_ins_lda();
begin
    if( step==2 ) begin
        bus_selector <= `BusIn_InstructionRegister;
        memory_in <= 1;
    end else begin
        bus_selector <= `BusIn_Memory;
        reg_a_in <= 1;
        step <= 0;
    end
end
endtask

task perform_ins_add();
begin
    if( step==2 ) begin
        bus_selector <= `BusIn_InstructionRegister;
        memory_in <= 1;
    end else if( step==3 ) begin
        bus_selector <= `BusIn_Memory;
        reg_b_in <= 1;
    end else begin
        bus_selector <= `BusIn_ALU;
        reg_a_in <= 1;
        step <= 0;
    end
end
endtask

task perform_ins_sub();
begin
    if( step==2 ) begin
        bus_selector <= `BusIn_InstructionRegister;
        memory_in <= 1;
    end else if( step==3 ) begin
        bus_selector <= `BusIn_Memory;
        reg_b_in <= 1;
    end else begin
        bus_selector <= `BusIn_ALU;
        reg_a_in <= 1;
        subtract <= 1;
        step <= 0;
    end
end
endtask

task perform_ins_sta();
begin
    if( step==2 ) begin
        bus_selector <= `BusIn_InstructionRegister;
        memory_in <= 1;
    end else begin
        bus_selector <= `BusIn_RegA;
        ram_in <= 1;
        step <= 0;
    end
end
endtask

task perform_ins_ldi();
begin
    bus_selector <= `BusIn_InstructionRegister;
    reg_a_in <= 1;
    step <= 0;
end
endtask

task perform_ins_jmp();
begin
    bus_selector <= `BusIn_InstructionRegister;
    pc_in <= 1;
    step <= 0;
end
endtask

task perform_ins_out();
begin
    bus_selector <= `BusIn_RegA;
    out_in <= 1;
    step <= 0;
end
endtask

task perform_ins_hlt();
begin
    hlt <= 1;
    step <= 0;
end
endtask

task reset_everything();
begin
    step = 0;
    reset_controls();
end
endtask

task reset_controls();
begin
    hlt <= 0;
    memory_in <= 0;
    ram_in <= 0;
    instruction_in <= 0;
    reg_a_in <= 0;
    subtract <= 0;
    reg_b_in <= 0;
    out_in <= 0;
    advance_pc <= 0;
    pc_in <= 0;
    flags_in <= 0;
    bus_selector <= `BusIn_None;
end
endtask

endmodule
