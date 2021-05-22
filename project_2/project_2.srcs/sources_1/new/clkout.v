`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 08:54:48
// Design Name: 
// Module Name: clkout
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


module clkout(
input clk,
inout rst,
output reg clk_out
    );
    reg [31:0]cnt;
    parameter period = 200000;
    always@(posedge clk,negedge rst)
    begin
    if(rst)
    begin
        cnt<=0;
    end
    else if(cnt==(period>>1)-1) 
    begin
    cnt<=0;
    clk_out<=~clk_out;
    end
    else
    cnt<=cnt+1;

    end
endmodule
