`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 10:49:05
// Design Name: 
// Module Name: clkout2
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


module clkout2(
input clk,
input reset,
output reg clkout
    );
    reg [3:0] cnt=0;
    always@(posedge clk or posedge reset)
    begin
    if(reset)
      begin
    cnt=0;
     clkout=0;
          end
       else if(cnt<4)
       begin
      cnt=cnt+1;
       end
       else begin
        cnt<=0;
        clkout<=~clkout;
        end
    end
endmodule
