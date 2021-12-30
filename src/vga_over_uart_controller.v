`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIITB - VL504
// Engineer: Manish, Shubhayu, Veerendra
// 
// Create Date: 05.12.2021 11:53:15
// Design Name: Master controller
// Module Name: controller
// Project Name: VGA over UART
// Target Devices: Basys 3 dev board
// Tool Versions: Vivado 2019.1
// Description: It works!
// 
// Dependencies: A script to send data over UART.
// 
// Revision:
// Revision 1.0 - Stable working version
// Additional Comments:
// 
// Block RAM configuration:
//
// 11 bits wide data
// 320*240*2 = 153600 deep(addresses)
// Simple 2 port memory, with one read-only and one write-only port
// Read port is always enabled
// Write port is enabled only when required
// The latency of reading and writing to the block RAM doesn't matter
//
// Copied output of the clocking wizard
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// _clk_vga___108.000______0.000______50.0______127.691_____97.646
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________100.000____________0.010
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input clk,
    input rx,
    output rx_busy,
    output h_sync,
    output v_sync,
    output reg [3:0] RED_out,
    output reg [3:0] GREEN_out,
    output reg [3:0] BLUE_out
);

    // States for the UART receiving FSM
    localparam HIGH_BYTE = 0;
    localparam LOW_BYTE = 1;
    
    // Resolution of received image
    localparam DISPLAY_X = 11'd320;
    localparam DISPLAY_Y = 11'd240;

    // VGA positions locations
    wire [10:0] x_loc;
    wire [10:0] y_loc;
    reg [2:0] x_counter, y_counter;
    reg show_second_image;
    
    // UART related wiring and regs
    reg flush, allow_next;
    reg state; 
    wire [7:0] rx_data;
    reg [5:0] rx_data_buffer1;
    wire rx_converted, rx_data_valid;
    
    // Block RAM related variables
    reg  [10:0] bram_write_data;
    wire [10:0] bram_read_data;
    reg  [17:0] bram_write_addr, bram_read_addr;
    reg bram_wea;
    
    // Timing related stuff
    wire clk_vga;
    reg clk_uart;
    reg [2:0] counter;
    wire locked;
    reg reset;
    
    // Generate 108MHz for VGA
    clk_wiz_0 clock_synthesis (
      // Clock out ports
      .clk_vga(clk_vga),     // output clk_vga
      // Status and control signals
      .reset(reset),        // input reset
      .locked(locked),      // output locked
      
      // Clock in ports
      .clk(clk)
    );
    
    blk_mem_gen_0 data_buffer (
      // Port A, used to buffer data from UART
      .clka(clk_uart),    // input wire clka
      .wea(bram_wea),      // input wire [0 : 0] wea
      .addra(bram_write_addr),  // input wire [17 : 0] addra
      .dina(bram_write_data),    // input wire [11 : 0] dina
      
      // Port B, used to read data by VGA
      .clkb(clk_vga),    // input wire clkb
      .addrb(bram_read_addr),  // input wire [17 : 0] addrb
      .doutb(bram_read_data)  // output wire [11 : 0] doutb
    );
    
    vga #(
        .H_RES(1280),
        .H_FRONT_PORCH(48),
        .H_SYNC_PULSE(112),
        .H_BACK_PORCH(248),
        .V_RES(1024),
        .V_FRONT_PORCH(1),
        .V_SYNC_PULSE(3),
        .V_BACK_PORCH(38)
    ) timing_control_1280_1024 (
        .clk_108Mhz(clk_vga),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .x_loc(x_loc),
        .y_loc(y_loc)
    );
    
    uart_rx #(
        .FRAME_BITS(8),
        .PARITY_BIT(2),
        .STOP_BITS(1),
        .OVERSAMPLE_FACTOR(13)
    ) input_uart_data_1843200 (
        .rx(rx),
        .i_clk(clk_uart),
        .flush(flush),
        .data(rx_data),
        .converted(rx_converted),
        .data_valid(rx_data_valid), // Not using parity, so useless
        .busy(rx_busy)      // Just an indicator
    );

    initial begin
        counter = 0;
        reset = 0;
        flush = 0;
        allow_next = 0;
        rx_data_buffer1 = 0;
        
        show_second_image = 0;
       
        bram_wea = 0;
        bram_write_addr = 0;
        bram_read_addr = 0;
        bram_write_data = 0;
    end
    
    // Manually divide the clock by 4 for UART
    always @(posedge clk) begin
        counter <= counter + 1;
        
        if(counter == 3'd1) begin
            counter <= 0;
            clk_uart <= ~clk_uart;
        end
    end
    
    // Logic for receiving and storing data
    always @(posedge clk_uart) begin
        case(state)
            HIGH_BYTE: begin
                // Preventing false starts
                if(~rx_converted && ~flush)
                    allow_next <= 1;
                    
                if(rx_converted && ~flush && allow_next) begin
                    allow_next <= 0;
                    flush <= 1;
                    state <= LOW_BYTE;

                    // Get rid of the safety '0' bits on either side
                    rx_data_buffer1 <= rx_data[6:1];
                    
                    // disable writing in to the block RAM and update the address
                    bram_wea <= 0;
                    bram_write_addr <= (bram_write_addr == DISPLAY_X*DISPLAY_Y*2-1) ? 0 : bram_write_addr + 1;
                end
                else begin
                    flush <= 0;
                end
            end
            LOW_BYTE: begin
                // Preventing false starts
                if(~rx_converted && ~flush)
                    allow_next <= 1;
                    
                if(rx_converted && ~flush && allow_next) begin
                    allow_next <= 0;
                    flush <= 1;
                    state <= HIGH_BYTE;
                    
                    // Rearrange the data as R[3:0], G[3:1], B[3:0]
                    bram_write_data <= {
                                        rx_data[6:3],
                                        rx_data[2:1],
                                        rx_data_buffer1[5],
                                        rx_data_buffer1[3:0]
                                       };
                    bram_wea <= 1;
                end
                else
                    flush <= 0;
            end
        endcase
        
        // Check which part of the BRAM is being used at the video buffer
        if(bram_write_addr == DISPLAY_X*DISPLAY_Y-1)
            show_second_image <= 0;
        else if(bram_write_addr == DISPLAY_X*DISPLAY_Y*2-1)
            show_second_image <= 1;
    end
    
    always @(posedge clk_vga) begin
        // Display something as long as in the active region in VGA
        if(x_loc < (DISPLAY_X<<2) && y_loc < (DISPLAY_Y<<2)) begin
            
            // Check which part of the BRAM needs to be displayed
            // This is actually unsafe as this variable is crossing clock domains
            // Experimentally, it didn't make difference
            if(show_second_image)
                bram_read_addr <= DISPLAY_X*DISPLAY_Y - 1 + y_loc[10:2] + x_loc[10:2]*DISPLAY_Y;
            else
                bram_read_addr <= y_loc[10:2] + x_loc[10:2]*DISPLAY_Y;

            // Assign the output colors for each pixel
            // Note that GREEN needs to be zero-padded
            {RED_out, GREEN_out, BLUE_out} <= { bram_read_data[10:7],
                                                {bram_read_data[6:4], 1'b0},
                                                bram_read_data[3:0]
                                              };
        end
        else
            {RED_out, GREEN_out, BLUE_out} <= {4'h0, 4'h0, 4'h0};
    end 
endmodule
