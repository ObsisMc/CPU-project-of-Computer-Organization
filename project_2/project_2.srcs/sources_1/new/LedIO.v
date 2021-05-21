`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module LedIO(led_clk,
             ledrst,
             ledwrite,
             ledcs,
             ledaddr,
             ledwdata,
             ledout,
             mod,
             keybd_i);
    input led_clk;    		    // 时钟信号
    input ledrst; 		        // 复位信号
    input ledwrite;		       	// 写信�???????????(from controller?)
    input ledcs;		      	// 从memorio来的LED片�?�信�???????????   !!!!!!!!!!!!!!!!!
    input[1:0] ledaddr;	        //  到LED模块的地�???????????低端  !!!!!!!!!!!!!!!!!!!!
    input[15:0] ledwdata;	  	//  写到LED模块的数据，注意数据线只�???????????16�???????????
    output[23:0] ledout;		//  向板子上输出�???????????24位LED信号
    input[7:0] mod;
    input[23:0] keybd_i;
    
    reg [23:0] ledout;
    
    always@(posedge led_clk or posedge ledrst)
    begin
        if (ledrst)
        begin
            ledout <= 24'h000000;
        end
        else
        begin
            if (mod == 8'b0010_1000) // if should put in this place
            begin
                ledout[23:0] <= keybd_i;
            end
            else if (ledcs && ledwrite)
            begin
                if (ledaddr == 2'b00)
                begin
                    ledout[23:0] <= { ledout[23:16], ledwdata[15:0] };
                end
                else if (ledaddr == 2'b10)
                begin
                    ledout[23:0] <= { ledwdata[7:0], ledout[15:0] };
                end
                else
                    ledout <= ledout;
            end
            
            if (mod[3] == 1)
            begin
                ledout[23:16] <= mod;
            end
        end
    end
endmodule
