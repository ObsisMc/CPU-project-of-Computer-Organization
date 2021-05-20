`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module SwitchIO(switclk, switrst, switchread, switchcs,switchaddr, switchrdata, switch_i, keybd_i);
    input switclk;			        //  时钟信号
    input switrst;			        //  复位信号
    input switchcs;			        //从memorio来的switch片选信号  !!!!!!!!!!!!!!!!!
    input[1:0] switchaddr;		    //  到switch模块的地址低端  !!!!!!!!!!!!!!!
    input switchread;			    //  读信号
    output [15:0] switchrdata;	    //  送到CPU的拨码开关值注意数据总线只有16根
    input [23:0] switch_i;		    //  从板上读的24位开关数据
    input [23:0] keybd_i;

    reg[23:0] in;
    always @(*)
    begin
        if(switrst)
            in <= 0;
        else
        begin
            if(keybd_i[19] == 1)
            begin
                if(keybd_i[23:21] == 3'b000)
                    in<={keybd_i[23:16], 16'h0000};
                else
                    in <= keybd_i;
            end
            else
            begin
                in <= switch_i;
            end
        end
    end

    reg [23:0] switchrdata;
    always@(negedge switclk or posedge switrst) begin
        if(switrst) begin
            switchrdata <= 0;
        end
		else if(switchcs && switchread) begin
			if(switchaddr==2'b00)
				switchrdata[15:0] <= in[15:0];   // data output,lower 16 bits non-extended
			else if(switchaddr==2'b10)
				switchrdata[15:0] <= { 8'h00, in[23:16] }; //data output, upper 8 bits extended with zero
			else 
				switchrdata <= switchrdata;
        end
		else begin
            switchrdata <= switchrdata;
        end
    end
endmodule
