`timescale 1us / 1ps

module sccb_configuration(
    input clk,
    input enable,
    input [7:0] reg_address,
    input [7:0] reg_data,
    output reg busy,
    output reg sio_c,
    output reg sio_d
    );
    
    reg [4:0] bit_cnt;
    reg [2:0] state;
    wire [27:0] buffer;
    reg dummy;

    initial begin
        busy = 0;
        sio_c = 1;
        sio_d = 1;
        bit_cnt = 28; // 3 phase
        state = 0;
    end
    
    assign buffer[27:20] = 8'h42; // slave write address
    assign buffer[19] = 1;
    assign buffer[18:11] = reg_address;
    assign buffer[10] = 1;
    assign buffer[9:2] = reg_data;
    assign buffer[1] = 1;
    assign buffer[0] = 0; // prepare for stop
    
    always @(posedge clk) begin
        if (enable) begin
            if(state == 0) begin
                sio_d = 0;
                state = state + 1;
                busy = 1;
            end 
            else if(state == 3'd1) begin
                sio_c = ~sio_c;
                if(bit_cnt == 0) begin
                  state = state + 1;
                end
            end
            else if(state == 3'd2) begin
                sio_c = 1;
                state = state + 1;                
            end
            else if(state == 3'd3) begin                
                sio_d = 1;
                busy = 0;
            end
        end
    end
    
    always @(negedge sio_c) begin
        if(state == 3'd1) begin
            if (enable) begin
                sio_d = buffer[bit_cnt-1];
                bit_cnt = bit_cnt - 1;
            end 
        end
    end
    
endmodule


module sccb_tb();

wire busy, sio_c, sio_d;
reg clk, enable;
reg [7:0] reg_address, reg_data;

sccb_configuration tut(clk,enable,reg_address, reg_data, busy, sio_c, sio_d);

initial begin
	$dumpfile("sccb.vcd");
	$dumpvars(0,sccb_tb);
	clk = 0;
	enable = 0;
	#15
	enable = 1;
	reg_address = 8'b01010011;
	reg_data = 8'b00001010;	
	#650
	$finish;
end

always begin
	#5 clk = ~clk;
end

endmodule
