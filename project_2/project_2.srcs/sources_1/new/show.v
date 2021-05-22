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


module show(
input clk,
inout rst,
input [16:0] ledwdata,
output reg [7:0] seg_en,
output [7:0] seg_out
    );
    reg [3:0] scan_cnt;
    reg [6:0] Y_r;
    assign seg_out = {1'b1,(~Y_r[6:0])};
    
    always@(posedge clk,negedge rst)
    begin
    if(rst)
    begin
        scan_cnt<=0;
    end
    else if(scan_cnt==7) 
    begin
    scan_cnt<=0;
    end
    else
    scan_cnt<=scan_cnt+1;
    end
    
    always@(scan_cnt)
    begin
    case(scan_cnt)
    0:seg_en<=8'b1111_1110;
    1:seg_en<=8'b1111_1101;
    2:seg_en<=8'b1111_1011;
    3:seg_en<=8'b1111_0111;
    4:seg_en<=8'b1110_1111;
    5:seg_en<=8'b1101_1111;
    6:seg_en<=8'b1011_1111;
    7:seg_en<=8'b0111_1111;
    endcase
    end
    
    reg [3:0] num;
    
    always@(num)
    begin
    case(num)
    0:Y_r = 7'b0111111;
    1:Y_r = 7'b0000110;
    2:Y_r = 7'b1011011;
    3:Y_r = 7'b1001111;
    4:Y_r = 7'b1100110;
    5:Y_r = 7'b1101101;
    6:Y_r = 7'b1111101;
    7:Y_r = 7'b0100111;
    8:Y_r = 7'b1111111;
    9:Y_r = 7'b1100111;
    10:Y_r = 7'b1110111;
    11:Y_r = 7'b1111100;
    12:Y_r = 7'b0111001;
    13:Y_r = 7'b1011110;
    14:Y_r = 7'b1111001;
    15:Y_r = 7'b1110001;
    endcase
    end
    
    always@(scan_cnt)
    begin
    case(scan_cnt)
    0:num <= ledwdata % 16;
    1:num <= (ledwdata % 256)/16;
    2:num <= (ledwdata % 4096)/256;
    3:num <= (ledwdata % 65536)/4096;
    4:num <= (ledwdata % 1048576)/65536;
    5:num <= (ledwdata % 16777216)/1048576;
    6:num <= (ledwdata % 268435456)/16777216;
    7:num <= 0;
    endcase
    end
    
endmodule
