`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/15 16:43:20
// Design Name:
// Module Name: keyboard
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


module keyboard(input clk,
                input rst,
                input [3:0] row,
                output reg [3:0] col,
                output wire[23:0] keybd_i,    //the same as swtich_iin switch module
                output reg key_pressed_flag); //show if keybd is being pressed

      //select which scene to show, the same as swtich_i[23:16] in switch module but should be concat with keybd_i_low, modeCtrl[3]=1 means use keybd
    reg [7:0] modeCtrl;   
    reg[15:0] keybd_i_low;   // the same as swtich_i[15:0] in switch module but should be concat with modeCtrl
    
    
    reg [19:0] cnt;
    always @ (posedge clk, posedge rst)
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
