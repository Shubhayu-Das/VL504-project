set_property PACKAGE_PIN U16 [get_ports done]
set_property PACKAGE_PIN L1 [get_ports frame_done]

## new constraints
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports hsync_vga]
set_property IOSTANDARD LVCMOS33 [get_ports vsync_vga]
set_property IOSTANDARD LVCMOS33 [get_ports {Blue_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Blue_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Blue_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Blue_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Green_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Green_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Green_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Green_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Red_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Red_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Red_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Red_out[0]}]

# Clock pin
# This is set to 10ns period in the clocking wizard configs(clk_wiz_0.xdc) by default
set_property PACKAGE_PIN W5 [get_ports clk_100MHz]

# H and V SYNC
set_property PACKAGE_PIN P19 [get_ports hsync_vga]
set_property PACKAGE_PIN R19 [get_ports vsync_vga]

set_property PACKAGE_PIN N18 [get_ports {Blue_out[0]}]
set_property PACKAGE_PIN L18 [get_ports {Blue_out[1]}]
set_property PACKAGE_PIN K18 [get_ports {Blue_out[2]}]
set_property PACKAGE_PIN J18 [get_ports {Blue_out[3]}]

set_property PACKAGE_PIN J17 [get_ports {Green_out[0]}]
set_property PACKAGE_PIN H17 [get_ports {Green_out[1]}]
set_property PACKAGE_PIN G17 [get_ports {Green_out[2]}]
set_property PACKAGE_PIN D17 [get_ports {Green_out[3]}]

set_property PACKAGE_PIN G19 [get_ports {Red_out[0]}]
set_property PACKAGE_PIN H19 [get_ports {Red_out[1]}]
set_property PACKAGE_PIN J19 [get_ports {Red_out[2]}]
set_property PACKAGE_PIN N19 [get_ports {Red_out[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports clk_ov7670]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports done]
set_property IOSTANDARD LVCMOS33 [get_ports frame_done]
set_property IOSTANDARD LVCMOS33 [get_ports href_ov7670]
set_property IOSTANDARD LVCMOS33 [get_ports p_clk]
set_property IOSTANDARD LVCMOS33 [get_ports pixel_valid]
set_property IOSTANDARD LVCMOS33 [get_ports sioc]
set_property IOSTANDARD LVCMOS33 [get_ports siod]
set_property IOSTANDARD LVCMOS33 [get_ports vsync_ov7670]
set_property PACKAGE_PIN M18 [get_ports clk_ov7670]
set_property PACKAGE_PIN A15 [get_ports {p_data[7]}]
set_property PACKAGE_PIN A14 [get_ports {p_data[6]}]
set_property PACKAGE_PIN C16 [get_ports {p_data[5]}]
set_property PACKAGE_PIN B16 [get_ports {p_data[4]}]
set_property PACKAGE_PIN C15 [get_ports {p_data[3]}]
set_property PACKAGE_PIN B15 [get_ports {p_data[2]}]
set_property PACKAGE_PIN A17 [get_ports {p_data[1]}]
set_property PACKAGE_PIN A16 [get_ports {p_data[0]}]
set_property PACKAGE_PIN M19 [get_ports href_ov7670]
set_property PACKAGE_PIN N17 [get_ports p_clk]
set_property PACKAGE_PIN R18 [get_ports sioc]
set_property PACKAGE_PIN P18 [get_ports siod]
set_property PACKAGE_PIN P17 [get_ports vsync_ov7670]
set_property PACKAGE_PIN V3 [get_ports pixel_valid]
set_property PULLUP true [get_ports siod]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {p_clk_IBUF_inst/O}]
set_property PULLUP true [get_ports sioc]

set_property PACKAGE_PIN V17 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]