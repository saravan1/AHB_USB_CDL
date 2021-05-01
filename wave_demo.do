onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/clk
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/n_rst
add wave -noupdate -divider {AHB LITE}
add wave -noupdate -divider {Inputs ahb}
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hsel
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/haddr
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hsize
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hwrite
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hwdata
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_data_ready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/buffer_occupancy
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/get_rx_data
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/AHB/mem
add wave -noupdate -divider {Outputs ahb}
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hrdata
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hready
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hresp
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/clear
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/store_tx_data
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/clear
add wave -noupdate -divider {DATA BUFFER}
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/get_rx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/get_tx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/store_tx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/store_rx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/flush
add wave -noupdate -color Gold -radix unsigned -childformat {{{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[7]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[6]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[5]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[4]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[3]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[2]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[1]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[0]} -radix unsigned}} -subitemconfig {{/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[7]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[6]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[5]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[4]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[3]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[2]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[1]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/tx_data[0]} {-color Gold -height 16 -radix unsigned}} /tb_ahb_lite_usb/DUT/DATABUFF/tx_data
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/rx_packet_data
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/buffer_occupancy
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/rx_data
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/tx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/read_ptr
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/DATABUFF/write_ptr
add wave -noupdate -color Gold -radix unsigned -childformat {{{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[63]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[62]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[61]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[60]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[59]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[58]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[57]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[56]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[55]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[54]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[53]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[52]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[51]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[50]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[49]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[48]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[47]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[46]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[45]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[44]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[43]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[42]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[41]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[40]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[39]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[38]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[37]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[36]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[35]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[34]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[33]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[32]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[31]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[30]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[29]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[28]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[27]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[26]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[25]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[24]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[23]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[22]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[21]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[20]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[19]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[18]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[17]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[16]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[15]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[14]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[13]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[12]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[11]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[10]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[9]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[8]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[7]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[6]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[5]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[4]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[3]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[2]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[1]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[0]} -radix unsigned}} -subitemconfig {{/tb_ahb_lite_usb/DUT/DATABUFF/registerData[63]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[62]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[61]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[60]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[59]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[58]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[57]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[56]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[55]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[54]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[53]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[52]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[51]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[50]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[49]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[48]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[47]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[46]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[45]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[44]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[43]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[42]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[41]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[40]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[39]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[38]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[37]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[36]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[35]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[34]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[33]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[32]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[31]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[30]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[29]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[28]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[27]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[26]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[25]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[24]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[23]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[22]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[21]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[20]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[19]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[18]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[17]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[16]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[15]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[14]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[13]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[12]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[11]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[10]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[9]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[8]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[7]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[6]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[5]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[4]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[3]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[2]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[1]} {-color Gold -height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/DATABUFF/registerData[0]} {-color Gold -height 16 -radix unsigned}} /tb_ahb_lite_usb/DUT/DATABUFF/registerData
add wave -noupdate -divider {USB RX}
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/clk
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/n_rst
add wave -noupdate -divider {Inputs rx}
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/dplus_in
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/dminus_in
add wave -noupdate /tb_ahb_lite_usb/DUT/USBRX/c1/state
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/buffer_occupancy
add wave -noupdate -divider {Outputs rx}
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_packet_data
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/store_rx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/enable_timer
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/shift_enable
add wave -noupdate -color Cyan -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/byte_received
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_data_ready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/edge_detect
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/flush
add wave -noupdate -divider {USB TX}
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/clk
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/n_rst
add wave -noupdate -divider {Inputs tx}
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/tx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/tx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/buffer_occupancy
add wave -noupdate -divider {outputs tx}
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/Dplus_out
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/Dminus_out
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/CNTFSM/state
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/tx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/get_tx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/tx_transfer_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/eop_flag
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/load_enable
add wave -noupdate -radix unsigned -childformat {{{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[7]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[6]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[5]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[4]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[3]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[2]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[1]} -radix unsigned} {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[0]} -radix unsigned}} -subitemconfig {{/tb_ahb_lite_usb/DUT/USBTX/parallel_in[7]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[6]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[5]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[4]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[3]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[2]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[1]} {-height 16 -radix unsigned} {/tb_ahb_lite_usb/DUT/USBTX/parallel_in[0]} {-height 16 -radix unsigned}} /tb_ahb_lite_usb/DUT/USBTX/parallel_in
add wave -noupdate -color Gold -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/serial_out
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/enable_timer
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/shift_enable
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/byte_sent
add wave -noupdate -divider {Test Bench Signals}
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_test_case_num
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hsel
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_htrans
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_haddr
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hsize
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hwrite
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hwdata
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hrdata
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hresp
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_hready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_dplus_in
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_dminus_in
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_dplus_out
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/tb_dminus_out
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/CNTFSM/tx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/CNTFSM/tx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBTX/CNTFSM/tx_transfer_active
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {1976500 ps} 1} {{Cursor 4} {7725800 ps} 1} {{Cursor 5} {11810000 ps} 1}
quietly wave cursor active 3
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {15141 ns}
