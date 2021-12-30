`timescale 1ns / 1ps
module top_controller(
    input clk_100MHz,
    input p_clk,
    input start,
    input vsync_ov7670,
	input href_ov7670,
	input [7:0] p_data,
    output sioc,
    output siod,
    output clk_ov7670,
    output done,
    output pixel_valid,
    output frame_done,
    output hsync_vga,
    output vsync_vga,
    output reg [3:0] Red_out,
    output reg [3:0] Green_out,
    output reg [3:0] Blue_out
    );
    
    
    reg [1:0] current_state;
    reg [1:0] timer;
    reg image;
    //reg start;
    wire clk_vga;
    wire locked;
    
    reg [10:0] BRAM_Write_data;
    wire [10:0] BRAM_Read_data;
    reg [17:0] BRAM_Write_addr, BRAM_Read_addr;
    reg BRAM_wea;
    wire [15:0] pixel_data;
    
    // VGA positions locations
    wire [10:0] x_loc;
    wire [10:0] y_loc;
    reg show_frame;

    
    initial begin
        //start = 1;
        image = 0;
        BRAM_Write_data = 11'b0;
        BRAM_Write_addr = 18'b0;
        BRAM_Read_addr = 18'b0;
        BRAM_wea = 1;
        current_state = 0;
        show_frame = 0;
    end
    
    
    clk_wiz_0 clk_wiz
   (
    // Clock out ports
    .clk_vga(clk_vga),     // output clk_vga
    .clk_ov7670(clk_ov7670),     // output clk_ov7670
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_100MHz));      // input clk_in1
    
    
    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
    blk_mem_gen_0 data_buffer (
    .clka(p_clk),    // input wire clka
    .wea(BRAM_wea),     // input wire [0 : 0] wea
    .addra(BRAM_Write_addr),  // input wire [17 : 0] addra
    .dina(BRAM_Write_data),    // input wire [10 : 0] dina
    .clkb(clk_vga),    // input wire clkb
    .addrb(BRAM_Read_addr),  // input wire [17 : 0] addrb
    .doutb(BRAM_Read_data)  // output wire [10 : 0] doutb
    );
    
    
    top_camera_module tcm ( 
    .clk(clk_ov7670),
    .start(start),
    .p_clk(p_clk),
    .vsync(vsync_ov7670),
	.href(href_ov7670),
	.p_data(p_data),
    .sioc(sioc),
    .siod(siod),
    .done(done),
    .pixel_data(pixel_data),
    .pixel_valid(pixel_valid),
    .frame_done(frame_done)
    );
    
   /*always @(posedge p_clk)begin
        if(pixel_valid) begin
            BRAM_Write_data <= {pixel_data[15:12],pixel_data[10:8],pixel_data[4:1]};
            BRAM_Write_addr <= (BRAM_Write_addr == 18'd153599) ? 0 : BRAM_Write_addr + 1;
        end
    end
    */
    
    reg [17:0] counter_pixel;
    initial counter_pixel = 0;
    
   always @(posedge p_clk) begin
        case(current_state)
            0: begin 
            if(pixel_valid) 
                begin
                    BRAM_Write_addr <= (BRAM_Write_addr == 18'd153599) ? 0 : BRAM_Write_addr + 1; 
                    BRAM_Write_data <= {pixel_data[15:12],pixel_data[9:7],pixel_data[4:1]};
//                    BRAM_Write_data <= {4'D0,3'b1,4'd0};

                    BRAM_wea <= 1;
                    current_state <= 2'd1;
                    timer <= 2'b01;
                    counter_pixel <= counter_pixel + 1;
                    /*if((counter_pixel > 18'd76797)) begin
                       current_state <= 2'd2; 
                    end*/
                end
               else begin
                    BRAM_wea <= 0;
               end 
            end   
            1: begin //count down and jump to next state
                if(timer == 0)begin
                    current_state <= 0;
                    BRAM_wea <= 0;
                end
                
                else
                    timer <= timer - 1;
            end
            
            2'd2: begin
                BRAM_wea <= 0;
            end
        endcase
        
        image <= (BRAM_Write_addr == 320 * 240) ? 1 : 0;
   end
   
    vga #(
        .H_RES(1280),
        .H_FRONT_PORCH(48),
        .H_SYNC_PULSE(112),
        .H_BACK_PORCH(248),
        .V_RES(1024),
        .V_FRONT_PORCH(1),
        .V_SYNC_PULSE(3),
        .V_BACK_PORCH(38)
    ) timing_control (
        .clk_108Mhz(clk_vga),
        .h_sync(hsync_vga),
        .v_sync(vsync_vga),
        .x_loc(x_loc),
        .y_loc(y_loc)
    );
    
    reg [12:0] counter;
    initial counter = 0;
    
    vio_0 your_instance_name (
    .clk(clk_vga),              // input wire clk
    .probe_in0(current_state),  // input wire [12 : 0] probe_in0
     .probe_in1(counter_pixel)
     );

    
    always @(posedge clk_vga) begin
        if(x_loc < 1280 && y_loc < 960) begin
         
           BRAM_Read_addr <= y_loc[10:2]*320 + x_loc[10:2];
          if(BRAM_Read_addr == 300*239) counter <= counter + 1; 
         
          
          //if(x_loc < 320 && y_loc < 240) begin
            //BRAM_Read_addr <= (BRAM_Read_addr < 76800) ? BRAM_Read_addr + 1 : 0;
            {Red_out, Green_out, Blue_out} <= {
                                                BRAM_Read_data[10:7],
                                                BRAM_Read_data[6:4], 1'b0,
                                                BRAM_Read_data[3:0]
                                            };
           //end
           
          //{Red_out, Green_out, Blue_out} <= {{y_loc[6:5], x_loc[6:5]}, {y_loc[6:5], x_loc[6:5]}, {y_loc[6:5], x_loc[6:5]}};                              ;
        end
        else begin
            show_frame <= ~show_frame;
            {Red_out, Green_out, Blue_out} <= {4'h0, 4'h0, 4'h0};
        end
    end
endmodule
