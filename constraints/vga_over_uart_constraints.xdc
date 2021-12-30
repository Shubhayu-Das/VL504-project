set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports h_sync]
set_property IOSTANDARD LVCMOS33 [get_ports v_sync]
set_property IOSTANDARD LVCMOS33 [get_ports {BLUE_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BLUE_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BLUE_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BLUE_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GREEN_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GREEN_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GREEN_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GREEN_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RED_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RED_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RED_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RED_out[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx_busy]

# Clock pin
# This is set to 10ns period in the clocking wizard configs(clk_wiz_0.xdc) by default
set_property PACKAGE_PIN W5 [get_ports clk]

# H and V SYNC
set_property PACKAGE_PIN P19 [get_ports h_sync]
set_property PACKAGE_PIN R19 [get_ports v_sync]

set_property PACKAGE_PIN N18 [get_ports {BLUE_out[0]}]
set_property PACKAGE_PIN L18 [get_ports {BLUE_out[1]}]
set_property PACKAGE_PIN K18 [get_ports {BLUE_out[2]}]
set_property PACKAGE_PIN J18 [get_ports {BLUE_out[3]}]

set_property PACKAGE_PIN J17 [get_ports {GREEN_out[0]}]
set_property PACKAGE_PIN H17 [get_ports {GREEN_out[1]}]
set_property PACKAGE_PIN G17 [get_ports {GREEN_out[2]}]
set_property PACKAGE_PIN D17 [get_ports {GREEN_out[3]}]

set_property PACKAGE_PIN G19 [get_ports {RED_out[0]}]
set_property PACKAGE_PIN H19 [get_ports {RED_out[1]}]
set_property PACKAGE_PIN J19 [get_ports {RED_out[2]}]
set_property PACKAGE_PIN N19 [get_ports {RED_out[3]}]

# UART related stuff
set_property PACKAGE_PIN B18 [get_ports rx]
set_property PACKAGE_PIN U16 [get_ports rx_busy]