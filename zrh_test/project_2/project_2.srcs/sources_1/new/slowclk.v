`timescale 1ns / 1ps
module slowclk(input clk,
               input reset,
               output reg clkout1);
    reg [1:0] cnt;
    always @(posedge clk,posedge reset)
    begin
        if (reset)
        begin
            cnt     <= 0;
            clkout1 <= 0;
        end
        else if (cnt == 1'b1)
        begin
            cnt <= 0;
            clkout1 <= ~clkout1;
        end
        else
        begin
            cnt <= cnt+1;
        end
    end
endmodule
