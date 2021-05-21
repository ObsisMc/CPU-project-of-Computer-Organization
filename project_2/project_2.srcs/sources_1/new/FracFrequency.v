`timescale 1ns / 1ps
module FracFrequency(input clk,
               input reset,
               output reg clkout);
    reg [31:0] cnt;
    parameter fq = 5000000;
    always @(posedge clk,posedge reset)
    begin
        if (reset)
        begin
            cnt     <= 0;
            clkout <= 0;
        end
        else if (cnt == (fq>>1)-1)
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