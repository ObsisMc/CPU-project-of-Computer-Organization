`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 08:54:22
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
input clk,
input rst,
input[15:0] ledwdata,
output [7:0] seg_en,
output [7:0] seg_out
    );
    wire clk_out;
    clkout co(clk,rst,clk_out);
    show ss(clk_out,rst,seg_en,seg_out,ledwdata);
endmodule
