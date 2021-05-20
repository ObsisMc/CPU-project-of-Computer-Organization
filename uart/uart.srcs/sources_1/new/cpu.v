`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/15 17:37:17
// Design Name:
// Module Name: cpu
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


module cpu(input clock,
           input rst,
           input[23:0] switch,
           input start_pg,
           input rx,
           output tx,
           output[23:0] led);
// UART Programmer Pinouts 
wire reset;
wire upg_clk, upg_clk_o; 
 clkout2 change(clock,upg_clk);
wire upg_wen_o; //Uart write out enable 
wire upg_done_o; //Uart rx data have done //data to which memory unit of program_rom/dmemory32
 wire [14:0] upg_adr_o; //data to program_rom or dmemory32 
 wire [31:0] upg_dat_o;
 wire spg_bufg;
  BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter // Generate UART Programmer reset signal
    wire clk;
    FracFrequency ff(.clk(clock),
    .reset(rst),
    .clkout(clk));
    reg upg_rst;
     always @ (posedge clock) 
     begin 
     if (spg_bufg) 
     upg_rst = 0; 
     if (rst)
      upg_rst = 1; 
     end 
     assign reset = rst | !upg_rst;
   
    
     uart_bmpg_0 uart(upg_clk,upg_rst,upg_clk_o,upg_wen_o, upg_adr_o, upg_dat_o,upg_done_o,rx,tx);
    //output of ifetch
    wire[31:0] Instruction;
    wire[31:0] branch_base_addr;    // from ifetch to ALU(PC_plus_4)
    wire[31:0] link_addr;    // from ifetch to idecode(opcplus4)
    wire[31:0] pco;
    //input of ifetch
    wire[31:0] Addr_result;
    wire Zero;
    wire[31:0] Read_data_1;
    wire Branch;
    wire nBranch;
    wire Jmp;
    wire Jal;
    wire Jr;
    
    Ifetc32 ifetch(
    .clock(clk),
    .reset(rst),
    .Addr_result(Addr_result),
    .Read_data_1(Read_data_1),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jmp(Jmp),
    .Jal(Jal),
    .Jr(Jr),
    .Zero(Zero),
    .pco(pco),                          //output
    .Instruction(Instruction),          //output
    .branch_base_addr(branch_base_addr),    //output
    .link_addr(link_addr) ,  //output
    .upg_rst_i(reset),
    . upg_clk_i(upg_clk_o),
    . upg_wen_i(upg_wen_o& (!upg_adr_o[14])),
    . upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i( upg_dat_o),
    . upg_done_i(upg_done_o)
    );
    
    //input
    wire[31:0] r_wdata;   //from memroio
    wire[31:0] ALU_result;
    wire RegWrite;
    wire MemtoReg;
    wire RegDst;
    //output
    wire [31:0] read_data_1;
    wire[31:0] read_data_2;
    wire[31:0] imme_extend;
    
    Idecode32 idecode(.Instruction(Instruction),
    .read_data(r_wdata),
    .ALU_result(ALU_result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .RegDst(RegDst),
    .clock(clk),
    .reset(rst),
    .opcplus4(link_addr),
    .read_data_1(read_data_1),  //output
    .read_data_2(read_data_2),  //output
    .imme_extend(imme_extend)   //output
    );
    
    //input
    wire[5:0] Opcode;
    wire[5:0] Function_opcode;
    wire[21:0] Alu_resultHigh;
    //output
    wire MemWrite;
    wire ALUSrc;
    wire I_format;
    wire Sftmd;
    wire[1:0] ALUOp;
    wire MemorIOtoReg;                  // 1 indicates that data needs to be read from memory or I/O to the register
    wire MemRead;                       // 1 indicates that the instruction needs to read from the memory
    wire IORead;                        // 1 indicates I/O read
    wire IOWrite;
    
    assign Opcode          = Instruction[31:26];
    assign Function_opcode = Instruction[5:0];
    assign Alu_resultHigh  = ALU_result[31:10];
    controller ctrl(.Opcode(Opcode), //input
    .Function_opcode(Function_opcode),  //input
    .Alu_resultHigh(Alu_resultHigh),    //input
    .Jr(Jr),
    .Jmp(Jmp),
    .Jal(Jal),
    .Branch(Branch),
    .nBranch(nBranch),
    .RegDST(RegDst),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .ALUOp(ALUOp),
    .MemorIOtoReg(MemorIOtoReg),
    .MemRead(MemRead),
    .IORead(IORead),
    .IOWrite(IOWrite)
    );
    
    
    wire[4:0] Shamt;
    assign Shamt = Instruction[10:6];
    Executs32 alu(.Read_data_1(read_data_1),
    .Read_data_2(read_data_2),
    .Imme_extend(imme_extend),
    .Function_opcode(Function_opcode),
    .opcode(Opcode),
    .Shamt(Shamt),
    .PC_plus_4(branch_base_addr),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .Jr(Jr),
    .Zero(Zero),
    .ALU_Result(ALU_result),
    .Addr_Result(Addr_result)
    );
    
    //input of memory
    wire[31:0] addr_out;    //from memio
    wire[31:0] write_data;  //from memio
    //output
    wire[31:0] read_data;
    dmemory32 memory(.clock(clk),
    .Memwrite(MemWrite),
    .address(addr_out),
    .write_data(write_data),
    .read_data(read_data)   //output: to memroio
    ,.upg_clk_i(upg_clk_o),.upg_wen_i(upg_wen_o& upg_adr_o[14]),.upg_rst_i(reset),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_done_o)
    );
    
    //input
    wire[15:0] iodata;
    wire[15:0] switchrdata; //data from switchio
    //output of memorio
    wire LEDCtrl; // LED Chip Select
    wire SwitchCtrl; // Switch Chip Select
    

    MemOrIO memio(
    .mRead(MemRead),    // read memory, from control32
    .mWrite(MemWrite),  // write memory, from control32
    .ioRead(IORead),    // read IO, from control32
    .ioWrite(IOWrite),  // write IO, from control32
    .addr_in(ALU_result),   //from alu
    .m_rdata(read_data),    //from memory
    .io_rdata(iodata),    //data read from hardware, switch or something
    .r_rdata(read_data_2), // data read from idecode32(register file)(read_data_2)!!!!!!!!!?
    .addr_out(addr_out),    //output and follows are they
    .r_wdata(r_wdata),
    .write_data(write_data),    //io_wdata
    .LEDCtrl(LEDCtrl),
    .SwitchCtrl(SwitchCtrl)
    );

    ioInterface ioin(.reset(rst),
    .ior(IORead),
    .switchctrl(SwitchCtrl),
    .ioread_data(iodata),
    .ioread_data_switch(switchrdata));
    
    LedIO ledoutput(
    .led_clk(clk),
    .ledrst(rst),
    .ledwrite(IOWrite),   //from controller(IOWrite)?????
    .ledcs(LEDCtrl),
    .ledaddr(addr_out[1:0]), //??????????????  from memorio?????
    .ledwdata(write_data[15:0]),    //from memio(id_rdata)??
    .ledout(led[23:0])
    );

    SwitchIO switchinput(
        .switclk(clk),
        .switrst(rst),
        .switchcs(SwitchCtrl),
        .switchaddr(addr_out[1:0]), //?????????????????
        .switchread(IORead),  //from controller(IORead)?????
        .switchrdata(switchrdata),
        .switch_i(switch[23:0])
    );
endmodule
    
