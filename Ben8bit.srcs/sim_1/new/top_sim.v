`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2021 01:19:32 PM
// Design Name: 
// Module Name: top_sim
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


module top_sim(

    );

reg clock;
reg reset;
wire [7:0] out;

top testee(
    .clock_in(clock),
    .bReset(reset),
    .out(out)
);

initial
begin
    clock = 0;
    reset = 0;
    forever begin
        #500 clock = ~clock;
    end
end

initial begin
    #3002 reset = 1;
    
    #50007 reset = 0;
    #10 reset = 1;
end

endmodule
