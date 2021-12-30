module top_camera_module ( 
    input clk,
    input start,
    input p_clk,
    input vsync,
	input href,
	input [7:0] p_data,
    output sioc,
    output siod,
    output done,
    output [15:0] pixel_data,
    output pixel_valid,
    output frame_done
    );
    
    camera_configure CC ( .clk(clk),
      .start(start),
      .sioc(sioc), 
      .siod(siod), 
      .done(done)
    );

    camera_read CR(
	.p_clock(p_clk),
	.vsync(vsync),
	.href(href),
	.p_data(p_data),
	.pixel_data(pixel_data),
	.pixel_valid(pixel_valid),
	.frame_done(frame_done)
    );

    // use clock wizard to generate xclk of 25MHz
endmodule