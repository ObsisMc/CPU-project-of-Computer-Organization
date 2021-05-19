`timescale 1ns / 1ps
module FracFrequency(input clk,
               input reset,
               output reg clkout);
    reg [1:0] cnt;
    always @(posedge clk,posedge reset)
    begin
        if (reset)
        begin
            cnt     <= 0;
            clkout <= 0;
        end
        else if (cnt == 1'b1)
        begin
            cnt <= 0;
            clkout <= ~clkout;
        end
        else
        begin
            cnt <= cnt+1;
        end
    end
endmodule