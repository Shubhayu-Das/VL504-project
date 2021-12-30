/*
 * Module to generate the vertical timing pulse for VGA
 * Author: Shubhayu Das
 * Version: 1.1
 * Written in October, 2021
 * Last modified: November 2021
 * Updates: added H_LIMIT to make things cleaner
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
 * x_location: The horizontal location of the active pixel.
                This is needed to increment the v_sync_counter.
 *
 ************************************************************
 * 
 * Outputs:
 *
 * v_sync: The actual vertical synchronisation timing signal
 * v_sync_counter: The vertical location of the active pixel.
                    This will help in drawing the image
*/

`ifndef _V_SYNC_
`define _V_SYNC_
module v_sync #(
    parameter V_RES= 1024,
    V_FRONT_PORCH = 1,
    V_SYNC_PULSE = 3,
    V_BACK_PORCH = 38,
    H_LIMIT = 1687
) (
    input clk,
    input [10:0] x_location,
    output reg v_sync_signal,
    output reg [10:0] v_sync_counter
);
    initial begin
        v_sync_signal = 1'b0;
        v_sync_counter = 11'b0;
    end

    // Maintain the vertical location of the currently active pixel
    always @(posedge clk) begin
        if(x_location == H_LIMIT)
            v_sync_counter <= v_sync_counter + 1;
        if(v_sync_counter == V_RES+V_FRONT_PORCH+V_SYNC_PULSE+V_BACK_PORCH - 1)
			v_sync_counter <= 11'b0;
    end

    // Wait for the right instant to set V_SYNC high
    always @(posedge clk) begin
        if(v_sync_counter >= (V_RES+V_FRONT_PORCH - 1) && v_sync_counter <= (V_RES+V_FRONT_PORCH+V_SYNC_PULSE - 1))
                v_sync_signal <= 1'b1;
        else
            v_sync_signal <= 1'b0;
    end
endmodule
`endif