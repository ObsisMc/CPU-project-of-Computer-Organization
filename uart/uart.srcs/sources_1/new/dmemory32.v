`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/12 17:08:17
// Design Name: 
// Module Name: dmemory32
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


module dmemory32(
input clock,
input Memwrite,
input[31:0] address,
input[31:0] write_data,
output[31:0] read_data,
// UART Programmer Pinouts 
input upg_rst_i, // UPG reset (Active High)
 input upg_clk_i, // UPG ram_clk_i (10MHz) 
 input upg_wen_i, // UPG write enable
  input [13:0] upg_adr_i, // UPG write address
   input [31:0] upg_dat_i, // UPG write data 
   input upg_done_i // 1 if programming is finished
    );
    wire clk;
    assign clk = !clock;
    RAM ram(
    .clka(clk),
    .wea(Memwrite),
    .addra(address[15:2]),
    .dina(write_data),
    .douta(read_data)
    );
endmodule
