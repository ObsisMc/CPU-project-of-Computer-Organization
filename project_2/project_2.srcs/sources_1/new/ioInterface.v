`timescale 1ns / 1ps


module ioInterface(input reset,
              input ior,                      // 从控制器来的I/O读，
              input switchctrl,
              input[15:0] ioread_data_switch, //从外设来的读数据，此处来自拨码开�???????
              output reg[15:0] ioread_data);
    
    always @(*)
    begin
        if (reset == 1)
        begin
            ioread_data = 0;
        end
        else
        begin
            if (ior == 1)
            begin
                if (switchctrl == 1)
                begin
                    ioread_data = ioread_data_switch;
                end
                else
                begin
                    ioread_data = ioread_data;
                end
                
            end
        end
    end
endmodule
