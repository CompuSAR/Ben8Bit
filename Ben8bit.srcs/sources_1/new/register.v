`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2021 06:02:01 PM
// Design Name: 
// Module Name: register
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


module register#(parameter DataBits = 8)(
    input [DataBits-1:0] data_in,
    output [DataBits-1:0] data_out,
    input clock,
    input write_enable,
    input bReset
    );
    
reg [DataBits-1:0]data;
assign data_out = data;

always@(posedge clock, negedge bReset)
begin
    if( !bReset )
        data = 0;
    else if( write_enable )
        data = data_in;
end

endmodule
