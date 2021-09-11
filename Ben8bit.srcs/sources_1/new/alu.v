`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2021 08:06:22 PM
// Design Name: 
// Module Name: alu
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


module alu#(parameter DataBits = 8)(
    input [DataBits-1:0] a,
    input [DataBits-1:0] b,
    input sub_bAdd,
    output [DataBits-1:0] result,
    output carry_flag,
    output zero_flag
    );

wire [DataBits:0]expanded_result;
assign expanded_result = a+(sub_bAdd ? b : ~b + 1);
assign result = expanded_result[DataBits-1:0];
assign carry_flag = expanded_result[DataBits];
assign zero_flag = expanded_result[DataBits-1:0] == 0;

endmodule
