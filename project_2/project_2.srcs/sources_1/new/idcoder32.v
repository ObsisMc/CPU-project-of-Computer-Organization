`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/05 10:03:29
// Design Name:
// Module Name: idcoder32
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


module Idecode32(input[31:0] Instruction,
                 input[31:0] read_data,     //From memory
                 input[31:0] ALU_result,
                 input Jal,
                 input RegWrite,            //if write to reg
                 input MemtoReg,
                 input RegDst,              // if 1 then rd, if 0 then rs
                 input clock,
                 input reset,
                 input[31:0] opcplus4, // from Ifetch32 link_addr?
                 output[31:0] read_data_1,
                 output[31:0] read_data_2,
                 output[31:0] imme_extend);

assign imme_extend = {{16{Instruction[15]}},Instruction[15:0]};

reg[31:0] register[0:31]; 
assign read_data_1 = register[Instruction[25:21]];
assign read_data_2 = register[Instruction[20:16]];

//confirm which writeRegister should be write
reg[4:0] writeR;
always@(Instruction) 
begin
    if (Jal)
    begin
        writeR = 5'd31;
    end
    else
    begin
        if (RegDst) writeR = Instruction[15:11];
        else writeR        = Instruction[20:16];
    end
end

always @(posedge clock,posedge reset)
begin
    if (reset)
    begin
        for(integer i = 0;i<32;i = i+1)
        begin
            register[i] <= 0; //if don't initial like this, it will be WA
        end
    end
    else if (RegWrite) register[writeR] <= Jal?opcplus4:(MemtoReg?read_data:ALU_result);
    
end
endmodule
