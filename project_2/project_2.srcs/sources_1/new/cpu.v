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
           input [3:0] row,
           input[23:0] switch,
           output[23:0] led,
           output reg[3:0] col,
           output [7:0] seg_en,
           output [7:0] seg_out
           );

    wire clk;
    FracFrequency ff(.clk(clock),
    .reset(rst),
    .clkout(clk));
    
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
    .link_addr(link_addr)   //output
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
    );
    
    //input
    wire[15:0] iodata;
    wire[15:0] switchrdata; //data from switchio
    assign iodata = switchrdata;
    
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
    .write_data(write_data),    //io_wdata, output
    .LEDCtrl(LEDCtrl),
    .SwitchCtrl(SwitchCtrl)
    );

    // ioInterface ioin(.reset(rst),
    // .ior(IORead),
    // .switchctrl(SwitchCtrl),
    // .ioread_data(iodata),   //output
    // .ioread_data_switch(switchrdata));

    wire[23:0] keybd_i;    
    LedIO ledoutput(
    .led_clk(clk),
    .ledrst(rst),
    .ledwrite(IOWrite),   //from controller(IOWrite)?????
    .ledcs(LEDCtrl),
    .ledaddr(addr_out[1:0]), //??????????????  from memorio?????
    .ledwdata(write_data[15:0]),    //from memio(id_rdata)??
    .ledout(led[23:0]),
    .mod(keybd_i[23:16]),
    .keybd_i(keybd_i)
    );

    SwitchIO switchinput(
        .switclk(clk),
        .switrst(rst),
        .switchcs(SwitchCtrl),
        .switchaddr(addr_out[1:0]), //?????????????????
        .switchread(IORead),  //from controller(IORead)?????
        .switchrdata(switchrdata), //output
        .switch_i(switch[23:0]),
        .keybd_i(keybd_i)
    );
    
//    top S_SEG_TUBE(
//    .clk(clock),
//    .rst(rst),
//    .ledwdata(led[15:0]),
//    .seg_en(seg_en),
//    .seg_out(seg_out)
//    );

    wire clock_out;
    
    clkout co(
    .clk(clock),
    .rst(rst),
    .clk_out(clock_out)
    );

    show S_SEG_TUBE(
    .clk(clock_out),
    .rst(rst),
    .ledwdata(led[16:0]),
    .seg_en(seg_en),
    .seg_out(seg_out)
    );

// 只能对初始�?�操�?
//----------------------------------keyboard------------------------------------------------------------
    reg key_pressed_flag;  //not used
     //select which scene to show, the same as swtich_i[23:16] in switch module but should be concat with keybd_i_low, modeCtrl[3]=1 means use keybd
    reg [7:0] modeCtrl;   
    reg[15:0] keybd_i_low;   // the same as swtich_i[15:0] in switch module but should be concat with modeCtrl
    
    
    reg [19:0] cnt;
    always @ (posedge clock, posedge rst)
        if (rst)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
    
    wire key_clk = cnt[19];                // (2^20/50M = 21)ms
    
    parameter NO_KEY_PRESSED = 6'b000_001;
    parameter SCAN_COL0      = 6'b000_010;
    parameter SCAN_COL1      = 6'b000_100;
    parameter SCAN_COL2      = 6'b001_000;
    parameter SCAN_COL3      = 6'b010_000;
    parameter KEY_PRESSED    = 6'b100_000;
    
    reg [5:0] current_state, next_state;
    
    always @ (posedge key_clk, posedge rst)
        if (rst)
            current_state <= NO_KEY_PRESSED;
        else
            current_state <= next_state;
    
    
    always @ *
    case (current_state)
        NO_KEY_PRESSED :
        begin
            if (row != 4'hF)
                next_state = SCAN_COL0;
            else
                next_state = NO_KEY_PRESSED;
        end
        SCAN_COL0 :
        begin
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = SCAN_COL1;
        end
        SCAN_COL1 :
        begin
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = SCAN_COL2;
        end
        SCAN_COL2 :
        begin
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = SCAN_COL3;
        end
        SCAN_COL3 :
        begin
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = NO_KEY_PRESSED;
        end
        KEY_PRESSED :
        begin
            if (row != 4'hF)
                next_state = KEY_PRESSED;
            else
                next_state = NO_KEY_PRESSED;
        end
    endcase
    
    
    reg [3:0] col_val, row_val;
    always @ (posedge key_clk, posedge rst)
        if (rst)
        begin
            col              <= 4'h0;
            key_pressed_flag <= 0;
        end
        else
            case (next_state)
                NO_KEY_PRESSED :
                begin
                    col              <= 4'h0;
                    row_val          <= 4'hf;
                    key_pressed_flag <= 0;
                end
                SCAN_COL0 :
                begin
                    col     <= 4'b1110;
                    row_val <= 4'hf;
                end
                SCAN_COL1 :
                begin
                    col     <= 4'b1101;
                    row_val <= 4'hf;
                end
                SCAN_COL2 :
                begin
                    col     <= 4'b1011;
                    row_val <= 4'hf;
                end
                SCAN_COL3 :
                begin
                    col     <= 4'b0111;
                    row_val <= 4'hf;
                end
                KEY_PRESSED :
                begin
                    col_val          <= col;
                    row_val          <= row;
                    key_pressed_flag <= 1;
                end
            endcase
    
    
    // reg [3:0] keyboard_val;     //键盘
    always @ (posedge key_clk, posedge rst)
        if (rst)
        begin
            // keyboard_val = 2'b0;
            keybd_i_low <= 0;
            modeCtrl <= 0;
        end
        else
            if (key_pressed_flag)
            begin
                case ({col_val, row_val})
                    8'b1110_1110 :
                    begin
                        // keyboard_val = 1;
                        keybd_i_low <= 1;
                    end
                    8'b1101_1110 :
                    begin
                        // keyboard_val = 2;
                        keybd_i_low <= 2;
                    end
                    8'b1011_1110 :
                    begin
                        // keyboard_val = 3;
                        keybd_i_low <= 3;
                    end
                    8'b0111_1110:
                    begin
                        if(modeCtrl[3] == 0)
                        begin
                            modeCtrl <= 8'b0000_1000;
                        end
                        else
                        begin
                            modeCtrl <= 8'b0000_0000;
                        end
                        keybd_i_low <= 0;
                    end
                    8'b1110_1101:
                    begin
                        // keyboard_val = 4;
                        keybd_i_low <= 4;
                    end
                    8'b1101_1101:
                    begin
                        // keyboard_val = 5;
                        keybd_i_low <= 5;
                    end
                    8'b1011_1101:
                    begin
                        // keyboard_val = 6;
                        keybd_i_low <= 6;
                    end
                    8'b0111_1101:
                    begin
                        modeCtrl[7:5] <= 3'b001;
                        keybd_i_low <= 0;
                    end
                    8'b1110_1011:
                    begin
                        // keyboard_val = 7;
                        keybd_i_low <= 7;
                    end
                    8'b1101_1011:
                    begin
                        // keyboard_val = 8;
                        keybd_i_low <= 8;
                    end
                    8'b1011_1011:
                    begin
                        // keyboard_val = 9;
                        keybd_i_low <= 9;
                    end
                    8'b0111_1011:
                    begin
                        modeCtrl[7:5] <= 3'b010;
                    end
                    8'b1110_0111:
                    begin
                        modeCtrl[7:5] <=3'b100;
                    end
                    8'b1101_0111 :
                    begin
                        // keyboard_val = 0;
                        keybd_i_low <= 0;
                    end
                    8'b1011_0111:
                    begin
                        modeCtrl[7:5] <=3'b101;
                    end
                    8'b0111_0111:
                    begin
                        modeCtrl[7:5] <=3'b011;
                    end
                    default:
                    begin
                        // keyboard_val = 0;
                        keybd_i_low <= 0;
                    end
                endcase
            end
            else
            begin
                // keyboard_val = 2'b00;
                // keybd_i_low <= 0;
            end
    assign keybd_i = {modeCtrl,keybd_i_low};

endmodule
    
