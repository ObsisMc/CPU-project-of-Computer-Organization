`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/19 16:55:50
// Design Name:
// Module Name: controller
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


module controller(input[5:0] Opcode,
                  input[5:0] Function_opcode,
                  output Jr,
                  Jmp,
                  Jal,
                  output Branch,
                  nBranch,
                  output RegDST,
                  output MemtoReg,
                  output RegWrite,
                  output MemWrite,
                  output ALUSrc,
                  output I_format,
                  output Sftmd,
                  output[1:0] ALUOp);
    wire R_format = (Opcode == 6'b000000)?1'b1:1'b0;
    wire Lw       = (Opcode == 6'h23)?1'b1:1'b0;
    wire Sw       = (Opcode == 6'h2b)?1'b1:1'b0;
    
    assign Jr        = ((Function_opcode == 6'b001000)&&(Opcode == 6'b000000))?1'b1:1'b0;
    assign Jmp       = (Opcode == 6'b000010)?1'b1:1'b0;
    assign Jal       = (Opcode == 6'b000011)?1'b1:1'b0;
    assign Branch    = (Opcode == 6'b000100)?1'b1:1'b0;
    assign nBranch   = (Opcode == 6'b000101)?1'b1:1'b0;
    assign RegDST    = R_format;
    assign  MemtoReg = Lw;
    assign RegWrite  = (R_format || Lw || Jal || I_format) && !(Jr);
    assign MemWrite  = Sw;
    assign ALUSrc    = I_format||Lw||Sw;
    assign I_format  = (Opcode[5:3] == 3'b001)?1'b1:1'b0;
    assign Sftmd = (((Function_opcode == 6'b000000)
    ||(Function_opcode == 6'b000010) ||(Function_opcode == 6'b000011)
    ||(Function_opcode == 6'b000100) ||(Function_opcode == 6'b000110)
    ||(Function_opcode == 6'b000111)) && R_format)? 1'b1:1'b0;
    assign ALUOp       = {(R_format || I_format),(Branch || nBranch)};
    
    
endmodule
