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
                output reg[22:0] led,
                output reg key_pressed_flag);
    //键盘
    //++++++++++++++++++++++++++++++++++++++
    reg [19:0] cnt;
    // reg key_pressed_flag;

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
    
    
    reg [3:0] keyboard_val;     //键盘值,输出
    always @ (posedge key_clk, posedge rst)
        if (rst)
        begin
            keyboard_val = 2'b0;
        end
        else
            if (key_pressed_flag)
            begin
                case ({col_val, row_val})
                    8'b1110_1110 :
                    begin
                        keyboard_val = 1;
                        led <= 1;
                    end
                    8'b1101_0111 :
                    begin
                        keyboard_val = 0;
                        led <= 0;
                    end
                    8'b1101_1110 :
                    begin
                        keyboard_val = 2;
                        led <= 2;
                    end
                    8'b1011_1110 :
                    begin
                        keyboard_val = 3;
                        led <= 3;
                    end
                    8'b1110_1101:
                    begin
                        keyboard_val = 4;
                        led <= 4;
                    end
                    8'b1101_1101:
                    begin
                        keyboard_val = 5;
                        led <= 5;
                    end
                    8'b1011_1101:
                    begin
                        keyboard_val = 6;
                        led <= 6;
                    end
                    8'b1110_1011:
                    begin
                        keyboard_val = 7;
                        led <= 7;
                    end
                    8'b1101_1011:
                    begin
                        keyboard_val = 8;
                        led <= 8;
                    end
                    8'b1011_1011:
                    begin
                        keyboard_val = 9;
                        led <= 9;
                    end
                    8'b0111_1110:
                    begin
                        
                    end
                    8'b1011_0111 :
                    begin
                        
                    end
                    default:
                    begin
                        keyboard_val = 0;
                    end
                endcase
            end
            else
            begin
                keyboard_val = 2'b00;
            end
endmodule
