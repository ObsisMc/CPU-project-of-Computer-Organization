`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 16:34:42
// Design Name: 
// Module Name: cache
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

// a: 128block 1word cindex=7   twidth=32-7-2=23
// b: 1block 128 word cindex=0  twidth=32-0-9=23
module cache#(parameter A_WIDTH=32, parameter C_INDEX=10, parameter D_WIDTH=32)
(
p_a,p_dout,p_din,p_strobe,p_rw,p_ready,clk,resetn, m_a,m_dout,m_din,m_strobe,m_rw,m_ready
    );
    input clk,resetn; 
    input [A_WIDTH-1:0] p_a; //address of memory tobe accessed
    input [D_WIDTH-1:0] p_dout; //the data from cpu
    output [D_WIDTH-1:0] p_din; //the data to cpu
    input p_strobe; //1 means to do the reading or writing
    input p_rw; //0:read, 1:write
    output p_ready; //tell cpu, outside of cpu is ready
    output [A_WIDTH-1:0] m_a; //address
    input [D_WIDTH-1:0] m_dout; //the data from memory
    output [D_WIDTH-1:0] m_din; //the data to memory
    output m_strobe; //same as 'p_strobe
    output m_rw; //0:read, 1:write
    input m_ready;
    localparam T_WIDTH = 20 ;
    reg d_valid [ 0 : (1<<C_INDEX)-1];
    reg [ T_WIDTH-1 : 0] d_tags [0 : (1<<C_INDEX)-1];
    reg [D_WIDTH-1:0] d_data [0 : (1<<C_INDEX)-1];
    wire [C_INDEX-1:0] index = p_a[C_INDEX+1 : 2]; 
    wire [T_WIDTH-1:0] tag = p_a[A_WIDTH-1: C_INDEX+2];
    wire valid = d_valid[index]; 
    wire [T_WIDTH-1:0] tagout = d_tags[index]; 
    wire [D_WIDTH-1:0] c_dout = d_data[index];
    wire cache_hit = valid & (tagout == tag); 
    wire cache_miss = ~cache_hit;
     assign m_din = p_dout; 
     assign m_a = p_a;
     assign m_rw = p_strobe & p_rw; //write_through
     wire c_write = p_rw | cache_miss & m_ready; 
     assign m_strobe = p_strobe &(p_rw | cache_miss); 
     assign p_ready = ~p_rw & cache_hit | (cache_miss | p_rw) & m_ready;
     wire sel_in = p_rw; 
     wire [D_WIDTH-1:0] c_din = sel_in ? p_dout : m_dout;
     wire sel_out = cache_hit;
      assign p_din = sel_out? c_dout:m_dout;
        integer i; 
      always @ (posedge clk, negedge resetn)
       if(resetn == 1'b0) begin 
       for(i=0;i<(1<<C_INDEX);i=i+1) 
       d_valid[i] <=1'b0; 
       end 
       else if(c_write==1'b1) d_valid[index] <=1'b1;
        always@(posedge clk) 
        if(c_write==1'b1) 
        begin 
        d_tags[index] <= tag; 
        d_data[index] <= c_din; 
        end
endmodule
