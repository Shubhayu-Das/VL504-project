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
 * To configure for other frame sizes/FPS values, 
 * find the timing information here: http://tinyvga.com/vga-timing
 *
 * All the parameters can be found in the above website too
 * 
 * This module simply puts the h_sync and v_sync modules together
 * There is no logic here
 *
 ************************************************************
 *
 * Inputs:
 * clk_108Mhz: The clock signal, depending on the resolution and
                FPS in use. The actual frequency may vary depending
                on your configuration
 *
 ************************************************************
 * 
 * Outputs:
 *
 * h_sync: The actual horizontal synchronisation timing signal
 * v_sync: The actual vertical synchronisation timing signal
 * x_loc:  The horizontal location of the active pixel.
 * y_loc:  The vertical location of the active pixel.
 *                  
 * x_loc and y_loc will help in drawing the image
*/

`ifndef _VGA_
`define _VGA_

module vga #(
    parameter H_RES = 1280,
    H_FRONT_PORCH = 48,
    H_SYNC_PULSE = 112,
    H_BACK_PORCH = 248,
    V_RES = 1024,
    V_FRONT_PORCH = 1,
    V_SYNC_PULSE = 3,
    V_BACK_PORCH = 38
)(
	input clk_108Mhz,
	output h_sync,
	output v_sync,
	output [10:0] x_loc,
    output [10:0] y_loc
);   

    localparam H_TOTAL = H_RES+H_FRONT_PORCH+H_SYNC_PULSE+H_BACK_PORCH-1;
    
	h_sync #(
        .H_RES(H_RES),
        .H_FRONT_PORCH(H_FRONT_PORCH),
        .H_SYNC_PULSE(H_SYNC_PULSE),
        .H_BACK_PORCH(H_BACK_PORCH)
	) horizontal (
		.clk(clk_108Mhz),
		.h_sync_signal(h_sync),
		.h_sync_counter(x_loc)
	);

	v_sync # (
	    .V_RES(V_RES),
        .V_FRONT_PORCH(V_FRONT_PORCH),
        .V_SYNC_PULSE(V_SYNC_PULSE),
        .V_BACK_PORCH(V_BACK_PORCH),
        .H_LIMIT(H_TOTAL)
	) vertical (
		.clk(clk_108Mhz),
		.x_location(x_loc),
		.v_sync_signal(v_sync),
		.v_sync_counter(y_loc)
	);
endmodule
`endif