`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/26 17:25:25
// Design Name:
// Module Name: IFetch
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


module Ifetc32(Instruction,
               branch_base_addr,
               link_addr,
               clock,
               reset,
               Addr_result,
               Read_data_1,
               Branch,
               nBranch,
               Jmp,
               Jal,
               Jr,
               Zero,
               pco);
    output[31:0] Instruction; // the instruction fetched from this module
    output[31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
    output reg[31:0] link_addr; // (pc+4) to decoder which is used by jal instruction
    input clock,reset; // Clock and reset
    // from ALU
    input[31:0] Addr_result; // the calculated address from ALU
    input Zero; // while Zero is 1, it means the ALUresult is zero
    // from Decoder
    input[31:0] Read_data_1; // the address of instruction used by jr instruction
    // from controller
    input Branch; // while Branch is 1,it means current instruction is beq
    input nBranch; // while nBranch is 1,it means current instruction is bnq
    input Jmp; // while Jmp 1,it means current instruction is jump
    input Jal; // while Jal is 1,it means current instruction is jal
    input Jr; // while Jr is 1,it means current instruction is jr
    output[31:0] pco;
    
    reg[31:0] PC ;
    wire[31:0] PC_plus_4;
    assign pco              = PC;
    assign branch_base_addr = {{PC[31:2]+1'b1},PC[1:0]};
    // assign link_addr     = {{PC[31:2]+1'b1},PC[1:0]};
    
    reg[31:0] Next_PC;
    
    prgrom instmem(
    .clka(clock),
    .addra(PC[15:2]),
    .douta(Instruction)
    );
    
    always @(*)
    begin
        if (((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0))) // beq, bne
        begin
            Next_PC = Addr_result<<2;// the calculated new value for PC
        end
        else if (Jr == 1)
        begin
            Next_PC = Read_data_1<<2; // the value of $31 register
        end
        else
        begin
            Next_PC = (PC+3'd4); // PC+4
        end
    end
    
    always @(negedge clock)
    begin
        if (reset == 1)
        begin
            PC <= 32'h0000_0000;
        end
        else if ((Jmp == 1) || (Jal == 1))
        begin
            link_addr = (PC+4)>>2;
            PC <= {PC[31:28],Instruction[25:0],2'b00}; //PC or PC+4
            
        end
        else
        begin
            PC <= Next_PC;
        end
    end
endmodule
