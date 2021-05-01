onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/clk
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/n_rst
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hsel
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/haddr
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hsize
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/htrans
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hwrite
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hwdata
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_data_ready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/buffer_occupancy
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/rx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hrdata
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/hresp
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/clear
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/get_rx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/store_tx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/tx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/mem
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/data_buffer_reg
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/nxt_hrdata
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/nxt_clear
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/nxt_tx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/prev_hwrite
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/prev_htrans
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/prev_hsize
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/prev_haddr
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/start_push
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/start_pop
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/size
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/nxt_size
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/pos
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/nxt_pos
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/state
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/AHB/nxt_state
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/clk
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/n_rst
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/dplus_in
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/dminus_in
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/buffer_occupancy
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/store_rx_packet_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/flush
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_error
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/rx_data_ready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/dplus_in_sync
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/dminus_in_sync
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/edge_detect
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/d_sent
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/EOP_detect
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/shift_enable
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/recv_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/enable_timer
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/byte_received
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/clk
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/n_rst
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/edge_detect
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/eop
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/shift_enable
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/rcv_data
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/byte_received
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/buffer_occupancy
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/write_en
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/rx_err
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/rx_data_ready
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/rx_trans_active
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/rx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/enable_timer
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/flush
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/state
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/n_state
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/nxt_rx_packet
add wave -noupdate -radix unsigned /tb_ahb_lite_usb/DUT/USBRX/c1/nxt_rx_err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {13676 ps}
