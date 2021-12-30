/*
 * Module to generate the vertical timing pulse for VGA
 * Author: Shubhayu Das
 * Version: 1.1
 * Written in October, 2021
 *
 ************************************************************
 *
 * Refer to other sources for documentation on how VGA works
 * There are many good sources already, it's too tiring to
 * repeat it.
 *
 ************************************************************
 *
 * Inputs:
 * clk: The clock signal, depending on the resolution and FPS in use
 *
 ************************************************************
 * 
 * Outputs:
 *
 * h_sync: The actual horizontal synchronisation timing signal
 * h_sync_counter: The horizontal location of the active pixel.
                    This will help in drawing the image
*/

`ifndef _H_SYNC_
`define _H_SYNC_
module h_sync #(
    parameter H_RES = 1280,
    H_FRONT_PORCH = 48,
    H_SYNC_PULSE = 112,
    H_BACK_PORCH = 248
) (
    input clk,
    output reg h_sync_signal,
    output reg [10:0] h_sync_counter
);
    initial begin
        h_sync_signal = 0;
        h_sync_counter = 11'b0;
    end

    always @(posedge clk) begin        
        if(h_sync_counter == (H_RES+H_FRONT_PORCH+H_SYNC_PULSE+H_BACK_PORCH - 1))
			h_sync_counter <= 11'b0;
		else
		    h_sync_counter <= h_sync_counter + 1;
    end

    always @(posedge clk) begin
        if(h_sync_counter >= (H_RES+H_FRONT_PORCH - 1) && h_sync_counter < (H_RES+H_FRONT_PORCH+H_SYNC_PULSE - 1))
            h_sync_signal <= 1'b1;
        else
            h_sync_signal <= 1'b0;
    end
endmodule
`endif