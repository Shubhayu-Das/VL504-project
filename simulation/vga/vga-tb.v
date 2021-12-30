`timescale 1ps/1ps
`include "../../src/vga/vga.v"
`include "../../src/vga/h_sync.v"
`include "../../src/vga/v_sync.v"

module vga_tb;

reg clk_108Mhz;
wire h_sync, v_sync;
wire [10:0] x_loc, y_loc;

vga DUT(
		.clk_108Mhz(clk_108Mhz),
		.h_sync(h_sync),
		.v_sync(v_sync),
		.x_loc(x_loc),
		.y_loc(y_loc)
);

initial begin
	clk_108Mhz = 0;
	$dumpfile("dump_vga.vcd");
	$dumpvars(0);
	
	$monitor("[Time: %10d] [X_LOC: %4d] [Y_LOC: %4d] [HSYNC: %d] [VSYNC: %d]", $time, x_loc, y_loc, h_sync, v_sync);
	// Stop after displaying one frame
	#(1688*1066*926) $finish;
end

always #463 clk_108Mhz <= ~clk_108Mhz;

endmodule
